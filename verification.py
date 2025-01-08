"""AQALU Verification Python Test Vector Generator

This script is intended to generate values for the AQALU module for verification purposes
"""
import random
from AQALU import AQALU

A = B = -1

randomMode = (input("Do you wish to use random values? Y/N\n"))

if randomMode == 'N' or randomMode == 'n':
    A = int(input("Please enter the value of A (0 to 3):\n"))

    # Error handling for incompatible A values
    while A < 0 or A > 3:
        print("A value entered is not valid! Please enter a value between 0 and 3.\n")
        A = int(input("Please enter the value of A (0 to 3):\n"))

    B = int(input("Please enter the value of B (0 to 3):\n"))

    # Error handling for incompatible B values
    while B < 0 or B > 3:
        print("B value entered is not valid! Please enter a value between 0 and 3.\n")
        B = int(input("Please enter the value of B (0 to 3):\n"))
elif randomMode == 'Y' or randomMode == 'y':
    A = random.randint(0,3)
    B = random.randint(0,3)

else:
    print("Invalid selection")
#intialize arrays and opcode
opcode =0b0000 
opArray = []
outArray = []
numOpcode = 16
numSeconds = 7

#loop through opcodes to obtain values
for i in range(numOpcode):
    opArray.append(opcode)
    result = AQALU(opcode,A,B,numSeconds*10_000_000)
    outArray.append(result)
    print ("Opcode "+ bin(opcode)+" binary: "+bin(result)+
           " int:"+str(result))
    opcode+=1

f = open("testvector1.txt", "a")

#write values to test file
for i in range(numOpcode):
    f.write(str(A)+","+str(B)+","+str(opArray[i])+","+str(outArray[i])+","+str(numSeconds)+"\n")

f.close()