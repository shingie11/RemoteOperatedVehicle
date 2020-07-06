#!/usr/bin/env python

import time #import time
from inputs import devices #import devices
import spidev #import spi dev library 
from inputs import get_gamepad #import gamepad

spi = spidev.SpiDev(0, 0) #define spi port 

spi.max_speed_hz = 112500 #max communication bit rate 
spi.mode = 0  #master mode

gamepad = devices.gamepads[0] #get all the gamepads

params = [0, 0, 0, 0, 0, 0, 0, 0] #initialize parameter arrays to store gamepad values
num_params = 0 #initialize number of parameters

L_index = 100 #some index for left analog control
R_index = 100 #some index for right analog control
index = 0  #array index

while True: #repeat indefinitely.
    gamepad_events = gamepad.read() #read commands from gamepad
    for gamepad_event in gamepad_events: #go through every gamepad event /command
        msg = gamepad_event.code + str(gamepad_event.state) # put the event code and it's state into msg
        msg = msg[4:] #get rid of garbage values
        if msg == "REPORT0": #check to see if msg is "REPORT" 0
            if L_index != 100: #check if left index is 100
                print("L" + params[L_index][1:]) #pad 'L' to the command and print
                if len(params[L_index]) == 2: #check to see if length of left index is 2
                    spi.xfer2([48, ord(params[L_index][1]), 0]) #send the left command over SPI
                elif len(params[L_index]) == 3: #check to see if length of left index is 3
                    spi.xfer2([48, ord(params[L_index][1]), ord(params[L_index][2]), 0]) #send the left command over SPI
                elif len(params[L_index]) == 4: #check to see if length of left index is 4
                    spi.xfer2([48, ord(params[L_index][1]), ord(params[L_index][2]), ord(params[L_index][3]), 0]) #send the left command over SPI
            if R_index != 100: #check if right index is 100
                print("R" + params[R_index][2:]) #pad 'R' to the command and print)
                if len(params[R_index]) == 3: #check if length of command at specified place in params array is 3
                    spi.xfer2([49, ord(params[R_index][2]), 0]) #send right command over SPI
                elif len(params[R_index]) == 4: #check if length of command at specified place in params array is 3
                    spi.xfer2([49, ord(params[R_index][2]), ord(params[R_index][3]), 0]) #send right command over SPI
                elif len(params[R_index]) == 5: #check if length of command at specified place in params array is 3
                    spi.xfer2([49, ord(params[R_index][2]), ord(params[R_index][3]), ord(params[R_index][4]), 0])  #send right command over SPI
                
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

