"""AQALU Verification Python Test Vector Generator

Thus script is intended to generate values for the AQALU module for verification purposes
"""

from AQALU import AQALU

A =int(input("Please enter the value of A:\n"))

#Mild Error Handling for incompatible A values 
while(A>3 & A>0):
    print("A value entered is not valid!\n")
    A =int(input("Please enter the value of A:\n"))

B =int(input("Please enter the value of B:\n"))
#Mild Error Handling for incompatible A values 
while(B>3 & B>0):
    print("B value entered is not valid!\n")
    B =int(input("Please enter the value of B:\n"))

#intialize arrays and opcode
opcode =0b0000 
opArray = []
outArray = []

#loop through opcodes to obtain values
for i in range(15):
    opArray.append(opcode)
    result = AQALU(opcode,A,B)
    outArray.append(result)
    print ("Opcode "+ bin(opcode)+" binary: "+bin(result)+
           " int:"+str(result))
    opcode+=1

f = open("testvector1.txt", "a")

#write values to test file
for i in range(15):
    f.write(str(A)+","+str(B)+","+str(opArray[i])+","+str(outArray[i])+"\n")

f.close()