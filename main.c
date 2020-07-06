/* File name: main.c
 * Authors: George Klimiashvili, Shingirai Dhoro, Ebisan Christian Ekperigin, Yousseff Hussein
 * Project date: 12/10/19
 * Description:
            The program gets some two messages from the raspberry pi either over
            UART or SPI. It then reads and decode them to figure out which 
            button is pressed and in what direction should the ROV go. These 
            decoded values are used to alter the duty cycle of a PWM signal that
            drives the motors of the wheels of the ROV in any given direction.
            
            The program uses 4 CN interrupts to keep track of the encoder counts.
            These counts are used to synchronize the signal that control the
            controls the H-bridge that controls the motor. This way, the 
            program makes sure that the motors are moving at a constant velocity.
            The program makes use of a core timer interrupt to sample counter 
            values for about 5 seconds. This value can be easily changed by 
            changing the value of DT.
            
            The program also implements a collision sensor in form of two gitial
            input buttons which when either is pressed, the PWM signal to the 
            H-bridge becomes zero, effectively halting the ROV in a specified
            direction. 
            
            Connections:
            The mapping of connections is in the documentation of this project, 
            specifically, the wiring section of the project report (Figure 2)
            
               
             
 */
#include <xc.h>
#include "display_driver.h"
#include <sys/attribs.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <proc/p32mx795f512l.h>

#pragma config POSCMOD = HS // Primary Oscillator Mode: High Speed crystal
#pragma config FNOSC = PRIPLL // Oscillator Selection: Primary oscillator w/ PLL
#pragma config FPLLMUL = MUL_20 // PLL Multiplier: Multiply by 20
#pragma config FPLLIDIV = DIV_2 // PLL Input Divider: Divide by 2
#pragma config FPLLODIV = DIV_1 // PLL Output Divider: Divide by 1
#pragma config FPBDIV = DIV_1 // Peripheral Bus Clock: Divide by 1

#define PWM_PERIOD 127 // period of PWM signal
#define DT 200000000 //togle the CORE Timer ISR after 5 seconds

bool currentDirectionL; // current direction of motor
bool currentDirectionR; // current direction of motor
int stateL = 0; // hold the current state of the left motor
int stateR = 0; // hold the current state of the right motor
long int counterRF = 0; // counter used on state machine right motor forward
long int counterLF = 0; // counter used on state machine left motor forward
long int counterRB = 0; // counter used on state machine right motor reverse
long int counterLB = 0; // counter used on state machine left motor reverse
const double countsPerRotation = 48; // counts per rotation
double forwardScaler = 1; //used to factor for any mismatch in the velocity of forward motion
double reverseScaler = 1; //used to factor for any mismatch in the velocity of reverse motion
bool backwardsAllowed = true; // Whether we are allowed to move backwards
bool forwardAllowed = true; // Whether we are allowed to move forward
int rightVal = 127;   //right value of the game_pad
int leftVal = 127; //left value of the game_pad
bool useUART = true; // Whether we want to use SPI or UART

void initializePWMSignal() {
    T2CONbits.TCKPS = 2; // Timer2 prescalar N=4
    PR2 = PWM_PERIOD; // period = (PR2+1) * N * 12.5ns =~ 1kHz
    TMR2 = 0; // set initial TIMR2 count to 0
    OC4CONbits.OCM = 0b110; // PWM mode without fault pin
    OC2CONbits.OCM = 0b110; // PWM mode without fault pin
    OC4RS = 0; // set initial duty cycle to about 0%. we start at rest
    OC4R = 0; // initialize before turning OC4 on
    OC2RS = 0; // set initial duty cycle to 0%. we start at rest
    OC2R = 0; // initialize before turning OC2 on 
    T2CONbits.ON = 1; // turn on Timer2
    OC4CONbits.ON = 1; // turn on OC4 (right analog button/motor) (pin 78)
    OC2CONbits.ON = 1; // turn on OC2 (left analog button/motor) (pin 76)
}

//get  the scaler
double getScaler(int counterRF, int counterLF){
    if (counterRF < 1000 || counterLF < 1000) // not big enough sample space
        return 1;
    return (double)counterRF/(double)counterLF; //return scaler
}

// Inverts direction of the left motor
void invertMotorDirectionL(bool direction) {
   if (direction && !currentDirectionL) {
        LATAbits.LATA4 = 0; // set RA4 to low
        LATAbits.LATA5 = 1; // set RA5 to high
        currentDirectionL = true;
    } else if (!direction && currentDirectionL) {
        LATAbits.LATA4 = 1; // set RA4 to high
        LATAbits.LATA5 = 0; // set RD2 to low
        currentDirectionL = false;
    }
}
// Inverts direction of the right motor
void invertMotorDirectionR(bool direction) {
   if (direction && !currentDirectionR) {
        LATBbits.LATB8 = 0; // set RB8 to low
        LATBbits.LATB9 = 1; // set RB9 to high
        currentDirectionR = true;
    } else if (!direction && currentDirectionR) {
        LATBbits.LATB8 = 1; // set RB8 to high
        LATBbits.LATB9 = 0; // set RB9 to low
        currentDirectionR = false;
    }
}

void getDuty(int rightValue, int leftValue){    //sets duty cycle of the motors using information from gamepad/raspberry pi
   
    double temp1 =  (double)(127-leftValue); //duty cycle for left motor
    double temp2 = (double)(127-rightValue); //duty cycle for right motor
  
    if (!PORTAbits.RA2) // no collision in the back
        backwardsAllowed = true; // allow to move backwards
    else {
        backwardsAllowed = false; // do not allow to move backwards
    }
    if (!PORTAbits.RA3) // collision in the back
        forwardAllowed = true; // allow to move forward
    else {
        forwardAllowed = false; // do not allow to move forward
    }
    
    //control for right motor
    if (temp1<0){   //check if duty cycle is negative
        if (backwardsAllowed) {
            invertMotorDirectionR(true); //change direction of the motor
            if (reverseScaler > 1){
                 OC4RS = -temp1 ; //go in the negative direction
            }
            else{
                 OC4RS = -temp1 * reverseScaler; // multiply by scaler to match velocities
            }
        } else {
            OC4RS = 0; // stop since we collided with our back
        }
    }
    else{
        if (forwardAllowed) {
            invertMotorDirectionR(false); //change direction of the motor to go forward
            if (forwardScaler > 1){
                 OC4RS = temp1 ; //go in the forward direction
            }
            else{
                 OC4RS = temp1 * forwardScaler; //multiply by scaler to match velocities
            }
        } else
            OC4RS = 0; // stop since we collided with our front
    }
    
    //control for left motor
     if ( temp2 <0){   //check if duty cycle is negative
        if (backwardsAllowed) {
            invertMotorDirectionL(true); //change direction of the motor
             if (reverseScaler > 1){
                 OC2RS = -temp2 * reverseScaler ; // multiply by scaler to match velocities
            }
            else{
                 OC2RS = -temp2; //go in negative direction
            }
        } else {
            OC2RS = 0; // stop since we collided with our back
        }
    }
    else{
        if (forwardAllowed) {
            invertMotorDirectionL(false); //change direction of the motor to go forward
             if (forwardScaler > 1){
                 OC2RS = temp2 * forwardScaler ; // multiply by scaler to match velocities
            }
            else{
                 OC2RS = temp2; //go in negative direction
            }
        } else
            OC2RS = 0; // stop since we collided with our front
    }
   
}

//change notification ISR
void __ISR(_CHANGE_NOTICE_VECTOR, IPL5SOFT) CNISR(void) {
    IFS1bits.CNIF = 0; // clear the interrupt flag
    if (PORTAbits.RA2) // check we we collided with our back
        getDuty(leftVal, rightVal); //drive the motor (actually will stop)
    if (PORTAbits.RA3) // check we we collided with our front
        getDuty(leftVal, rightVal); //drive the motor (actually will stop)
    //RD6 & 7 corresponds to right motor
    if (PORTDbits.RD6 == 0 && PORTDbits.RD7 == 0) { // State AB=00
        // This means we were in either state AB=01 or AB=10
        if (stateR == 1) // Last AB=01
            counterRB++; // increment RB counter
        else if (stateR == 2) // Last AB=10
            counterRF++; // Increment RF counter
        else {
            // ILLEGAL state
        }
        stateR = 0; // new state is 0 (00)
    } else if (PORTDbits.RD6 == 0 && PORTDbits.RD7 == 1) { // State AB=01
        // This means we were in either state AB=00 or AB=11
        if (stateR == 0) // Lat AB=00
            counterRF++; // Increment RF counter
        else if (stateR == 3) // Last AB=11
            counterRB++; // increment RB counter
        else {
            // ILLEGAL state
        }
        stateR = 1; // new state is 1 (01)
    } else if (PORTDbits.RD6 == 1 && PORTDbits.RD7 == 0) { // State AB=10
        // This means we were in either state AB=00 or AB=11
        if (stateR == 0) // Last AB=00
            counterRB++; // increment RB counter
        else if (stateR == 3) // Last AB=11
            counterRF++; // Increment RF counter
        else {
            // ILLEGAL
        }
        stateR = 2; // new state is 2 (10)
    } else if (PORTDbits.RD6 == 1 && PORTDbits.RD7 == 1) { // State AB=11
        if (stateR == 1) // Last AB=01
            counterRF++; // Increment RF counter
        else if (stateR == 2) // Last AB=10
            counterRB++; // increment RB counter
        else {
            // ILLEGAL
        }
        stateR = 3; // new state is 3 (11)
    }

    //RD4 & 5 corresponds to left motor
    if (PORTDbits.RD4 == 0 && PORTDbits.RD5 == 0) { // State AB=00
        // This means we were in either state AB=01 or AB=10
        if (stateL == 1) // Last AB=01
            counterLB++; // increment LB counter
        else if (stateL == 2) // Last AB=10
            counterLF++; // Increment LF counter
        else {
            // ILLEGAL state
        }
        stateL = 0; // new state is 0 (00)
    } else if (PORTDbits.RD4 == 0 && PORTDbits.RD5 == 1) { // State AB=01
        // This means we were in either state AB=00 or AB=11
        if (stateL == 0) // Lat AB=00
            counterLF++; // Increment LF counter
        else if (stateL == 3) // Last AB=11
            counterLB++; // increment LB counter
        else {
            // ILLEGAL state
        }
        stateL = 1; // new state is 1 (01)
    } else if (PORTDbits.RD4 == 1 && PORTDbits.RD5 == 0) { // State AB=10
        // This means we were in either state AB=00 or AB=11
        if (stateL == 0) // Last AB=00
            counterLB++; // increment LB counter
        else if (stateL == 3) // Last AB=11
            counterLF++; // Increment LF counter
        else {
            // ILLEGAL
        }
        stateL = 2; // new state is 2 (10)
    } else if (PORTDbits.RD4 == 1 && PORTDbits.RD5 == 1) { // State AB=11
        if (stateL == 1) // Last AB=01
            counterLF++; // Increment LF counter
        else if (stateL == 2) // Last AB=10
            counterLB++; // increment LB counter
        else {
            // ILLEGAL
        }
        stateL = 3; // new state is 3 (11)
    }
}

// Core timer ISR
void __ISR(_CORE_TIMER_VECTOR, IPL6SOFT) CoreTimerISR(void) {
    IFS0bits.CTIF = 0; // clear CT interrupt flag
    forwardScaler = getScaler(counterRF, counterLB); //get forward scaler
    reverseScaler = getScaler(counterRB, counterLF); //get reverse scaler
    IEC0bits.CTIE = 0; // step 6: disable core timer interrupt
    _CP0_SET_COUNT(0); // set core timer counter to 0
    _CP0_SET_COMPARE(DT); // set # of ticks for core timer interrupt
}


int main(void) {
    DDPCON = 0; // Disables JTAG debugger so pins are available for digital I/O
    display_driver_initialize(); // Initialize the display
    short UART_N = 2; // which UART we want to use
    char message_rx[50]; // message
    char copy[50];  //copy of string
    currentDirectionL = false;   //direction of motor
    currentDirectionR = false;   //direction of motor
    TRISBbits.TRISB8 = 0;   //set RG2 to digital outputs pin 32
    TRISBbits.TRISB9 = 0;   //set RG3 to digital output pin 33
    LATBbits.LATB8 = 1;
    LATBbits.LATB9 = 0;
    TRISAbits.TRISA4 = 0; //set RA4 to digital output pin 60
    TRISAbits.TRISA5 = 0; //set RA5 to digital output pin 61
    LATAbits.LATA4 = 1; // set RD1 to high
    LATAbits.LATA5 = 0; // set RD2 to low
    int i; //counter
     // For encoder
    TRISDbits.TRISD4 = 1; // Set RD4 to digital input
    TRISDbits.TRISD5 = 1; // Set RD5 to digital input
    TRISDbits.TRISD6 = 1; // Set RD6 to digital input
    TRISDbits.TRISD7 = 1; // Set RD7 to digital input
    // For collision detection
    TRISAbits.TRISA2 = 1; // For back collision detection
    TRISAbits.TRISA3 = 1; // For front collision detection
        
    initializePWMSignal(); //initialize PWM signal starts at rest

    //CN interrupt initialization
     INTCONbits.MVEC = 1; // enable multi-vec interrupts
    __builtin_disable_interrupts(); // step 1: disable interrupts
    CNCONbits.ON = 1; // step 2: configure peripheral: turn on CN
    CNENbits.CNEN15 = 1; // Use CN15/RD6 as a change notification (p83)
    CNENbits.CNEN16 = 1; // Use CN16/RD7 as a change notification (p84)
    CNENbits.CNEN13 = 1; // Use CN13/RD4 as a change notification (p81)
    CNENbits.CNEN14 = 1; // Use CN14/RD5 as a change notification (p82)
    IPC6bits.CNIP = 5; // step 3: set interrupt priority
    IPC6bits.CNIS = 1; // step 4: set interrupt sub-priority
    IFS1bits.CNIF = 0; // step 5: clear the interrupt flag
    IEC1bits.CNIE = 1; // step 6: enable the CN interrupt
    
    //CORE Timer Initialization
    _CP0_SET_COMPARE(DT); // step 3: CP0_COMPARE register set to DT
    IPC0bits.CTIP = 6; // step 4: interrupt priority
    IPC0bits.CTIS = 0; // step 4: subp is 0, which is the default
    IFS0bits.CTIF = 0; // step 5: clear CT interrupt flag
    IEC0bits.CTIE = 1; // step 6: enable core timer interrupt
    
    __builtin_enable_interrupts(); // step 7: CPU interrupts enabled
    _CP0_SET_COUNT(0); // set core timer counter to 0
    
    if (useUART) // we are using UART
        Init_UART(UART_N, 115200, 0, 0); // Initialize UART
    else // we are using SPI
        Init_SPI(); // Initialize SPI
    for (i = 0; i < 100; i++); // delay
    int x; // for loop
    int y; // for lopps
    while (true) {
        if (useUART) { // we are using UART
            Read_Data(UART_N, message_rx, 15); // read the message received to UART
            if (strstr(message_rx, "R") != NULL) { // we received Left Arrow Pressed
                for (x = 1; x<4; x++){  //copy just the game_pad value
                    if(message_rx[x] == '\0') {//if you see end of line character, don't add anything to copy
                        for (y = x; y < 4; y++) // we read the entire number
                            copy[y - 1] = '\0'; // discard
                        break;
                    } else
                        copy[x-1] = message_rx[x];  //copy value to array char copy
                }
                rightVal = atoi(copy);  //get the integer value of right game_pad value 
            }
            else if (strstr(message_rx, "L") != NULL){
                for (x = 1; x<4; x++){  //copy just the game_pad value
                    if(message_rx[x] == '\0') {//if you see end of line character, don't add anything to copy
                        for (y = x; y < 4; y++) // we read the entire number
                            copy[y - 1] = '\0'; // discard
                        break; 
                   } else
                        copy[x-1] = message_rx[x];  //copy value to array char copy
                }
                leftVal = atoi(copy);  //get the integer value of right game_pad value
            }
            getDuty(leftVal, rightVal); //drive the motor
        }
        else { // We are using SPI
            SPI3STATbits.SPIROV = 0; // clear the overflow buffer
            Read_Data_SPI(message_rx); // read the message received by SPI
            if (message_rx[0] == '1') { // we received Left Arrow Pressed
                for (x = 1; x<4; x++){  //copy just the game_pad value
                    if(message_rx[x] == '\0') {//if you see end of line character, don't add anything to copy
                        for (y = x; y < 4; y++) // we read the entire number
                            copy[y - 1] = '\0'; // discard
                        break;
                    } else
                        copy[x-1] = message_rx[x];  //copy value to array char copy
                }
                rightVal = atoi(copy);  //get the integer value of right game_pad value 
            }
            else if (message_rx[0] == '0') { // we received Left Arrow Pressed
                for (x = 1; x<4; x++){  //copy just the game_pad value
                    if(message_rx[x] == '\0') {//if you see end of line character, don't add anything to copy
                        for (y = x; y < 4; y++) // we read the entire number
                            copy[y - 1] = '\0'; // discard
                        break;
                    } else
                        copy[x-1] = message_rx[x];  //copy value to array char copy
                }
                leftVal = atoi(copy);  //get the integer value of right game_pad value 
            }
            getDuty(leftVal, rightVal); //drive the motor
        }
    }
}