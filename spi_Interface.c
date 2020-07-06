/* File name: spi_interface.c
 * Author: George Klimiashvili, Shingirai Dhoro, Ebisan Ekperigin, Yousseff Hussein
 * Lab date: 11/1/19
 * Description: Implements the functions described in spi_interface.h
 *              There are three functions in this file:
 *              1. Init_SPI which initializes uart and choose the number of 
                    stop and parity bits as well as the baud rate. The user
                    chooses what uart you want to initialize.
                    
                2.  Read_Data which reads data send from the DTE
                
                3. Write_Data which writes to TX buffer and send it to DTE
 */
#include "uart_interface.h"
#include <xc.h>
#include <string.h>

// Initializes specific UART on PIC32
void Init_SPI() {
    SPI3BUF; // clear the rx buffer by reading from it
    SPI3STATbits.SPIROV = 0; // clear the overflow bit
    SPI3CONbits.MODE32 = 0; // use 8 bit mode
    SPI3CONbits.MODE16 = 0; // use 8 bit mode
    SPI3CONbits.MSTEN = 0; // slave operation
    SPI3CONbits.ON = 1; // turn on spi 3
}

// Reads data from a specific SPI
// data will contain data that we received
// maxLength determines the maximum length of the data we want to RX
void Read_Data_SPI(char * message) {
    char data = 0; // byte to be read
    int num_bytes = 0; // number of bytes read
    while (1) {
        while(!SPI3STATbits.SPIRBF); // wait till data is available
        data = SPI3BUF; // read the data
//        SPI3STATbits.SPIROV = 0; // clear the overflow buffer
        if (data == '\0') { // check if we finished reception
            message[num_bytes] = '\0'; // store byte received
            break;
        } else {
            message[num_bytes] = data; // store byte received
            num_bytes++; // move to next index
        }
    }  
    SPI3STATbits.SPIROV = 0; // clear the overflow buffer
}

   
// Write data to a specific SPI
// data contains the data we want to send
// length determines the length of the data we want to TX
void Write_Data_SPI(char * data, int length) {
    // No need
}
