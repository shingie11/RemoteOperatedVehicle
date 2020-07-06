/* File name: uart_interface.h
 * Author: George Klimiashvili, Shingirai Dhoro, Ebisan Ekperigin
 * Lab date: 11/1/19
 * Description: Defines the functions implemented in uart_interface.c
 *              These function allow us to use simple function of the UARTs
 *              including initializing them, reading data from them and 
 *              writing data to them.
 */

#ifndef UART_INTERFACE_H
#define UART_INTERFACE_H

// Initializes specific UART on PIC32
// x determines which UART we want to use (1 to 6)
void Init_UART(short x, int baudRate, int parity, int stopBits);

// Reads data from a specific UART
// x determines which UART we want to use (1 to 6)
// data will contain data that we received
// maxLength determines the maximum length of the data we want to RX
void Read_Data(short x, char * data, int maxLength);

// Write data to a specific UART
// x determines which UART we want to use (1 to 6)
// data contains the data we want to send
// length determines the length of the data we want to TX
void Write_Data(short x, char * data, int length);


#endif /*UART_INTERFACE_H*/