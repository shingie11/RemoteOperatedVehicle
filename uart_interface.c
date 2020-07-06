/* File name: uart_interface.c
 * Author: George Klimiashvili, Shingirai Dhoro, Ebisan Ekperigin
 * Lab date: 11/1/19
 * Description: Implements the functions described in uart_interface.h
 *              There are three functions in this file:
 *              1. Init_UART which initializes uart and choose the number of 
                    stop and parity bits as well as the baud rate. The user
                    chooses what uart you want to initialize.
                    
                2.  Read_Data which reads data send from the DTE
                
                3. Write_Data which writes to TX buffer and send it to DTE
 */
#include "uart_interface.h"
#include <xc.h>
#include <string.h>

// Initializes specific UART on PIC32
// x determines which UART we want to use (1 to 6)
// baudRate determines the baud rate that UART will be using
// parity determines the parity of the 
void Init_UART(short x, int baudRate, int parity, int stopBits) {
    if (x == 1) { // use UART1
        U1MODEbits.PDSEL = parity; // set parity
        U1STAbits.UTXEN = 1; // enable transmit
        U1STAbits.URXEN = 1; // enable receive
        U1BRG = 80000000 / (16 * baudRate) - 1; // 500k/(MxB) - 1
        U1MODEbits.ON = 1; // turn on the uart
        U1MODEbits.STSEL = stopBits; // terminating bit
    } else if (x == 2) { // use UART2
        U2MODEbits.PDSEL = parity; // set parity
        U2STAbits.UTXEN = 1; // enable transmit
        U2STAbits.URXEN = 1; // enable receive
        U2BRG = 80000000 / (16 * baudRate) - 1; // 500k/(MxB) - 1
        U2MODEbits.ON = 1; // turn on the uart
        U2MODEbits.STSEL = stopBits; // terminating bit
    } else if (x == 3) { // use UART3
        U3MODEbits.PDSEL = parity; // set parity
        U3STAbits.UTXEN = 1; // enable transmit
        U3STAbits.URXEN = 1; // enable receive
        U3BRG = 80000000 / (16 * baudRate) - 1; // 500k/(MxB) - 1
        U3MODEbits.ON = 1; // turn on the uart
        U3MODEbits.STSEL = stopBits; // terminating bit
    } else if (x == 4) { // use UART4
        U4MODEbits.PDSEL = parity; // set parity
        U4STAbits.UTXEN = 1; // enable transmit
        U4STAbits.URXEN = 1; // enable receive
        U4BRG = 80000000 / (16 * baudRate) - 1; // 500k/(MxB) - 1
        U4MODEbits.ON = 1; // turn on the uart
        U4MODEbits.STSEL = stopBits; // terminating bit
    } else if (x == 5) { // use UART5
        U5MODEbits.PDSEL = parity; // set parity
        U5STAbits.UTXEN = 1; // enable transmit
        U5STAbits.URXEN = 1; // enable receive
        U5BRG = 80000000 / (16 * baudRate) - 1; // 500k/(MxB) - 1
        U5MODEbits.ON = 1; // turn on the uart
        U5MODEbits.STSEL = stopBits; // terminating bit
    } else if (x == 6) { // use UART6
        U6MODEbits.PDSEL = parity; // set parity
        U6STAbits.UTXEN = 1; // enable transmit
        U6STAbits.URXEN = 1; // enable receive
        U6BRG = 80000000 / (16 * baudRate) - 1; // 500k/(MxB) - 1
        U6MODEbits.ON = 1; // turn on the uart
        U6MODEbits.STSEL = stopBits; // terminating bit
    } else {
        // ILLEGAL
    }
}

// Reads data from a specific UART
// x determines which UART we want to use (1 to 6)
// data will contain data that we received
// maxLength determines the maximum length of the data we want to RX
void Read_Data(short x, char * message, int maxLength) {
    char data = 0;
    int complete = 0, num_bytes = 0;

   if(x == 3){ //read from UART 3
   // loop until you get a ?\r? or ?\n? 
        while (!complete) {
         if (U3STAbits.URXDA) { // if data is available 
              data = U3RXREG; // read the data
              if ((data == '\n') || (data == '\r')) {
              complete = 1;
              } 
              else {
                  message[num_bytes] = data;
                  ++num_bytes; // roll over if the array is too small 
                  if (num_bytes >= maxLength) {
                    num_bytes = 0;
                  }

              } 
         }
        }  
     // end the string 
        message[num_bytes] = '\0';
   }
   
   else if (x == 2){ //read from UART 2
       
       // loop until you get a ?\r? or ?\n? 
        while (!complete) {
         if (U2STAbits.URXDA) { // if data is available 
              data = U2RXREG; // read the data
              if ((data == '\n') || (data == '\r')) {
                complete = 1;
              } 
              else {
                  message[num_bytes] = data;
                  ++num_bytes; // roll over if the array is too small 
                  if (num_bytes >= maxLength) {
                    num_bytes = 0;
                  }

              } 
         }
        }  
     // end the string 
        message[num_bytes] = '\0';
   }
   
   else if (x == 1){ //read from UART 1
       
       // loop until you get a ?\r? or ?\n? 
        while (!complete) {
         if (U1STAbits.URXDA) { // if data is available 
              data = U1RXREG; // read the data
              if ((data == '\n') || (data == '\r')) {
              complete = 1;
              } 
              else {
                  message[num_bytes] = data;
                  ++num_bytes; // roll over if the array is too small 
                  if (num_bytes >= maxLength) {
                    num_bytes = 0;
                  }

              } 
         }
        }  
     // end the string 
        message[num_bytes] = '\0';
   }
   else if (x == 4){ //read from UART 4
       
       // loop until you get a ?\r? or ?\n? 
        while (!complete) {
         if (U4STAbits.URXDA) { // if data is available 
              data = U4RXREG; // read the data
              if ((data == '\n') || (data == '\r')) {
              complete = 1;
              } 
              else {
                  message[num_bytes] = data;
                  ++num_bytes; // roll over if the array is too small 
                  if (num_bytes >= maxLength) {
                    num_bytes = 0;
                  }

              } 
         }
        }  
     // end the string 
        message[num_bytes] = '\0';
   }
   else if (x == 5){ //read from UART 5
       
       // loop until you get a ?\r? or ?\n? 
        while (!complete) {
         if (U5STAbits.URXDA) { // if data is available 
              data = U5RXREG; // read the data
              if ((data == '\n') || (data == '\r')) {
                complete = 1;
              } 
              else {
                  message[num_bytes] = data;
                  ++num_bytes; // roll over if the array is too small 
                  if (num_bytes >= maxLength) {
                    num_bytes = 0;
                  }

              } 
         }
        }  
     // end the string 
        message[num_bytes] = '\0';
   }
   else{    //read from UART 6
       
       // loop until you get a ?\r? or ?\n? 
        while (!complete) {
         if (U6STAbits.URXDA) { // if data is available 
              data = U6RXREG; // read the data
              if ((data == '\n') || (data == '\r')) {
                complete = 1;
              } 
              else {
                  message[num_bytes] = data;
                  ++num_bytes; // roll over if the array is too small 
                  if (num_bytes >= maxLength) {
                    num_bytes = 0;
                  }

              } 
         }
        }  
     // end the string 
        message[num_bytes] = '\0';
   }
}

   
// Write data to a specific UART
// x determines which UART we want to use (1 to 6)
// data contains the data we want to send
// length determines the length of the data we want to TX
void Write_Data(short x, char * data, int length) {
    if (x == 1) { // Write to UART1
        int i; // for the loop
        for (i = 0; i < length; i++) {         
            while(U1STAbits.UTXBF);// wait for UART to be ready to transmit
            U1TXREG = *data; // Add data to TX reg
            ++data; // Move to next character
        }
    } else if (x == 2) { // Write to UART2
        int i; // for the loop
        for (i = 0; i < length; i++) {         
            while(U2STAbits.UTXBF);// wait for UART to be ready to transmit
            U2TXREG = *data; // Add data to TX reg
            ++data; // Move to next character
        }
    } else if (x == 3) { // Write to UART3
        int i; // for the loop
        for (i = 0; i < length; i++) {         
            while(U3STAbits.UTXBF);// wait for UART to be ready to transmit
            U3TXREG = *data; // Add data to TX reg
            ++data; // Move to next character
        }
    } else if (x == 4) { // Write to UART4
        int i; // for the loop
        for (i = 0; i < length; i++) {         
            while(U4STAbits.UTXBF);// wait for UART to be ready to transmit
            U4TXREG = *data; // Add data to TX reg
            ++data; // Move to next character
        }
    } else if (x == 5) { // Write to UART5
        int i; // for the loop
        for (i = 0; i < length; i++) {         
            while(U5STAbits.UTXBF);// wait for UART to be ready to transmit
            U5TXREG = *data; // Add data to TX reg
            ++data; // Move to next character
        }
    } else if (x == 6) { // Write to UART6
        int i; // for the loop
        for (i = 0; i < length; i++) {         
            while(U6STAbits.UTXBF);// wait for UART to be ready to transmit
            U6TXREG = *data; // Add data to TX reg
            ++data; // Move to next character
        }
    } else {
        // ILLEGAL
    }
}


