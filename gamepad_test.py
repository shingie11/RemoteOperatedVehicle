#!/usr/bin/env python

import time
from inputs import devices #import devices

from inputs import get_gamepad #import the gamepad from inputs

import serial   #import serial

gamepad = devices.gamepads[0] #get all the gamepads

params = [0, 0, 0, 0, 0, 0, 0, 0] #array to later store parameters of the gamepad commands
num_params = 0  #keeps track of the number of parameters that are non-zero in params

serial_interface = serial.Serial('/dev/ttyAMA0', 115200) # our sending serial with baud rate 115200
print(serial_interface.name) #print the name of the serial

L_index = 100 #some index for left analog control
R_index = 100 #some index for right analog control
index = 0  #array index

while True: #indefinitely run this loop
    gamepad_events = gamepad.read() #read commands from gamepad 
    for gamepad_event in gamepad_events: #go through every gamepad event /command
        msg = gamepad_event.code + str(gamepad_event.state) # put the event code and it's state into msg
        msg = msg[4:] #get rid of gabage values
        #by uncomending the commended lines, you can decode commands from unused buttons on the gamepad.
        if msg == "REPORT0": #check to see if msg is "REPORT" 0
#             if params[0] == "HAT0X-1":
#                 print("Left arrow pressed")
#                 serial_interface.write('LA\n')
#             elif params[0] == "HAT0X1":
#                 print("Right arrow pressed")
#                 serial_interface.write('RA\n')
#             elif params[0] == "HAT0Y-1":
#                 print("Up arrow pressed")
#                 serial_interface.write('UA\n')
#             elif params[0] == "HAT0Y1":
#                 print("Down arrow pressed")
#                 serial_interface.write('DA\n')
#             elif params[0] == "HAT0X0":
#                 print("Horizontal arrow Released")
#                 serial_interface.write('HR\n')
#             elif params[0] == "HAT0Y0":
#                 print("Vertical arrow Released")
#                 serial_interface.write('VR\n')
#             elif params[1] == "NORTH1":
#                 print("Y pressed")
#                 serial_interface.write('Y\n')
#             elif params[1] == "NORTH0":
#                 print("Y released")
#                 serial_interface.write('YR\n')
#             elif params[1] == "EAST1":
#                 print("A pressed")
#                 serial_interface.write('A\n')
#             elif params[1] == "EAST0":
#                 print("A released")
#                 serial_interface.write('AR\n')
#             elif params[1] == "SOUTH1":
#                 print("X pressed")
#                 serial_interface.write('X\n')
#             elif params[1] == "SOUTH0":
#                 print("X released")
#                 serial_interface.write('XR\n')
#             elif params[1] == "C1":
#                 print("B pressed")
#                 serial_interface.write('B\n')
#             elif params[1] == "C0":
#                 print("B released")
#                 serial_interface.write('BR\n')
            
            if L_index != 100: #check if left index is 100
                print("L" + params[L_index][1:])  #pad 'L' to the command and print
                serial_interface.write("L" + params[L_index][1:] + '\n') #send the left command over UART
            if R_index != 100: #check if right index is 100
                print("R" + params[R_index][2:])  #pad 'R' to the command and print
                serial_interface.write("R" + params[R_index][2:] + '\n') #send the right command over UART
            num_params = 0 #floor the number of parameters
            L_index = 100 #floor the left index
            R_index = 100 #floor the right index
            index = 0 #floor the index
        else:
            if msg[0] == "Y": # check if command starts with 'Y'
                L_index = index #make left index be index
            elif msg[0:2] == "RZ": "Y": # check if command starts with 'RY'
                R_index = index #make right index be index
            params[num_params] = msg #put the message/command in the parameter array
            num_params = num_params + 1 #increment parameter counter
            index += 1 #increment index 
#        
