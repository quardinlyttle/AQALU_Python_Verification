
"""AQALU Pyhton version

Recreating the AQALU verilog module in Python
"""
def AQALU(opcode,A,B, clockCycles = 0):

    #light error handling
    if(A > 3 or B > 3):
        print("value greater than supported")

    result =0

    match opcode:

        case 0b0000: #And Opcode
            result = A&B

        case 0b0001: #Or Opcode
            result = A|B
        
        case 0b0010: #Not Opcode- Treats it as a 4 bit input
            result = (~((A << 2)+B))& 0x0F

        case 0b0011: #XOR Opcode
            result = A^B
        
        case 0b0100:  #Nand Opcode
            result = ~(A&B)

        case 0b0101: #Not Opcode
            result = ~(A|B)
        
        case 0b0110: # XNOR Opcode
            result = ~(A^B)
        
        case 0b0111: #Addition Opcode
            result = A+B

        case 0b1000: #Subtract Opcode
            result = A-B

        case 0b1001: #Multiplication Opcode
            result = A*B
        
        case 0b1010: #Compare Opcode
            if(A>B): result = 0b10
            elif(B>A): result = 0b01
            else: result =0b11

        case 0b1011: #Shift Left Logic
            result= ((A <<2)+B) << 1
        
        case 0b1100: #Shift Right logic
            result= ((A <<2)+B) >> 1
        
        case 0b1101: #Shift Left Airthmetic
            result= ((A <<2)+B) << 1
        
        case 0b1110: #Shift Right Arithmetic
            sign = (0b10 & A) << 2
            result = (((A <<2)+B) >> 1) | sign

        case 0b1111: #runningSum
            sum = (A<<2)+B
            seconds = int(clockCycles/10000000)
            
            for i in range(seconds):
                nextNum  = int(input("insert next number"))
                sum += nextNum
            
            result = sum

    return result
