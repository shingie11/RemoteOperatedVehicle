/* File name: display_driver.h
 * Author: George Klimiashvili, Shingirai Dhoro, Ebisan Ekperigin
 * Lab date: 11/1/19
 * Description: Defines the functions implemented in display_driver.h
 *              These function allow us to use simple function of the LCD
 *              display including enabling it, initializing it, clearing it,
 *              and printing a message on it.
 */
#ifndef DISPLAY_DRIVER_H
#define DISPLAY_DRIVER_H

// Enables the display driver by toggling the display enable bit
void display_driver_enable();

// Initializes the display and brings it up
// Set the display to the following mode: 5x10 dots, dual line, 
// no cursor, and no blinking.
void display_driver_initialize();

// Clears the display
void display_driver_clear();

// Writes the message on the lcd
//
// char* data stores the message to be printed on the LCD
// int length is the length of the message to be printed on the LCD
void display_driver_write(char* data, int length);

#endif /*DISPLAY_DRIVER_H*/