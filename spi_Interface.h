/* File name: spi_interface.h
 * Author: George Klimiashvili, Shingirai Dhoro, Ebisan Ekperigin, Yousseff Hussein
 * Lab date: 11/1/19
 * Description: Defines the functions implemented in spi_interface.c
 *              These function allow us to use simple function of the SPI
 *              including initializing it, reading data from it and 
 *              writing data to it.
 */

#ifndef SPI_INTERFACE_H
#define SPI_INTERFACE_H

// Initializes an SPI on PIC32
void Init_SPI();

// Reads data from an SPI
// data will contain data that we received
// maxLength determines the maximum length of the data we want to RX
void Read_Data_SPI(char * data);

// Write data to an SPI
// data contains the data we want to send
// length determines the length of the data we want to TX
void Write_Data_SPI(char * data, int length);


#endif /*SPI_INTERFACE_H*/
