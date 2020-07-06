/* File name: display_driver.c
 * Author: George Klimiashvili, Shingirai Dhoro, Ebisan Ekperigin
 * Lab date: 11/1/19
 * Description: Implements the functions described in display_driver.h
 *              These function allow us to use simple function of the LCD
 *              display including enabling it, initializing it, clearing it,
 *              and printing a message on it.
 */
#include "display_driver.h"
#include <xc.h>

// Enables the display driver by toggling the display enable bit
void display_driver_enable() {
    TRISDbits.TRISD5 = 0; // set port D pins to output
    TRISDbits.TRISD4 = 0; // set port D pins to output
    LATDbits.LATD4 = 1; // set RD4 to high (enable port to high)
    int i; // counter for delay
    for (i = 0; i < 1000; i++); // delay
    LATDbits.LATD4 = 0; // set RD4 to low (enable port to low) / toggle
}

// Initializes the display and brings it up
// Set the display to the following mode: 5x10 dots, dual line, 
// no cursor, and no blinking.
void display_driver_initialize() {
    int i; // counter for delay
    for (i = 0; i < 1000; i++); // wait for >30ms
    
    TRISBbits.TRISB15 = 0; // set RB15 to output
    TRISDbits.TRISD5 = 0; // set RD5 to output
    TRISE = 0x0; // set port E pins to output
    // Function set
    LATBbits.LATB15 = 0; // set RB15 to low
    LATDbits.LATD5 = 0; // set RD5 to low
    LATE = 0b00111100; // set RE7, RE6, RE1, RE0 to low and rest to high
    //delay
    for (i = 0; i < 1000; i++); // wait for >40us
    // Display ON/OFF control
    LATE = 0b00001100; // RE3, RE2 to high and rest to low
    //delay
    for (i = 0; i < 1000; i++); // wait for >40us
    // clear display
    display_driver_clear();
    // entry mode set
    LATE = 0b00000110; // RE2, RE1 to high and rest to low
}

// Clears the display
void display_driver_clear() {
    // clear display
    LATBbits.LATB15 = 0; // set RB15 to low
    LATDbits.LATD5 = 0; // set RD5 to high
    LATE = 0b00000001; // RE0 to low and rest to 
    //delay
    int i; // counter for delay
    for (i = 0; i < 10000; i++); // wait
    display_driver_enable(); // enable display driver
}

// Writes the message on the lcd
void display_driver_write(char* data, int length) {
    int i; // counter for delay
    LATBbits.LATB15 = 1; // set RB15 to high
    TRISDbits.TRISD5 = 0; // set port D pins to output
    for (i = 0; i < 1000; i++); // wait
    i = 0; // rest the counter for characters in the string
    while (length > 0) { // print character by character until we print all the characters
        LATE = data[i]; // put the character in register E
        i++; // increase the counter (move to next character)
        display_driver_enable(); // display enable
        length--; // decrement number of characters left to print
    }
}