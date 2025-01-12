# AQALU Verification Repository

This repository contains the AQALU design from my [Tiny Tapeout 4 submission](https://github.com/quardinlyttle/tt04-AQALU) and implements it in both Verilog and Python. It includes a verification suite to test the functionality of the AQALU. This is an active project where I am learning to generate test vectors using Python for Verilog testbenches.

## Files

### Verilog Files

- **AQALU.v**: The main AQALU module, which supports various arithmetic and logical operations based on a 4-bit opcode. This module includes:
  - **TwoBitAdder**: A simple adder for two 2-bit inputs.
  - **Multiplier**: A multiplication module for two 2-bit inputs.
  - **Comparator**: A comparator that determines the relationship between two 2-bit inputs.
  - **RunningSum**: A module that calculates a running sum based on clock cycles.

- **AQALU_tb.v**: A testbench for the AQALU module. It generates a clock signal, applies test vectors, and verifies the outputs against expected results.
- **AQALU_tb_Sequential_Trace.v**: A testbench for the AQALU module which generates a trace table to the console with the simulation timestamps. 

### Python Files

- **AQALU.py**: A Python implementation of the AQALU module. This script allows for simulating the AQALU operations in Python, including error handling for input values and processing based on opcode.

- **verification.py**: A test vector generator for the AQALU module. This script prompts the user for input values and generates output values for each opcode, writing the results to a file for further analysis.

### Test Vector File

- **testvector1.txt**: A file generated by `verification.py` that contains input values (A, B), opcodes, and expected outputs. This file is used by the testbench to validate the AQALU functionality.

## How to Use

1. **Compile the Verilog Files**: Use a Verilog simulator (i am using iverilog in this case) to compile and simulate the `AQALU.v` and `AQALU_tb.v` files.

2. **Run the Verification Script**: Execute `verification.py` in a Python environment to generate the test vectors. Ensure the values for A and B are within the specified range (0-3).

3. **Simulate the Testbench**: After generating the test vector file, run the testbench in your Verilog simulator to validate the functionality of the AQALU module against the expected outputs listed in `testvector1.txt`.

## Requirements

- A Verilog simulator (e.g., Icarus Verilog, ModelSim, Vivado)
- Python 3.x

## ALU OpCodes

The AQALU implements a variety of operations controlled by 4-bit opcodes. Each opcode corresponds to a specific arithmetic or logical operation. Below is a list of the opcodes and their respective functions:

| Opcode | Operation                         | Description                                                   |
|--------|-----------------------------------|---------------------------------------------------------------|
| 0000   | AND                               | Performs a bitwise AND operation between inputs A and B.     |
| 0001   | OR                                | Performs a bitwise OR operation between inputs A and B.      |
| 0010   | NOT                               | Performs a bitwise NOT operation on the combined 4-bit input (A and B). |
| 0011   | XOR                               | Performs a bitwise XOR operation between inputs A and B.     |
| 0100   | NAND                              | Performs a bitwise NAND operation between inputs A and B.    |
| 0101   | NOR                               | Performs a bitwise NOR operation between inputs A and B.     |
| 0110   | XNOR                              | Performs a bitwise XNOR operation between inputs A and B.    |
| 0111   | Addition                          | Performs addition of inputs A and B (A + B).                 |
| 1000   | Subtraction                       | Performs subtraction (A - B). Expects unsigned input but provides signed output. |
| 1001   | Multiplication                    | Performs multiplication of inputs A and B (A * B).           |
| 1010   | Compare                           | Compares A and B. Outputs 2'b10 if A > B, 2'b01 if B > A, 2'b11 if A == B. |
| 1011   | Shift Left Logically             | Shifts the input left by one position, filling with zero.    |
| 1100   | Shift Right Logically            | Shifts the input right by one position, filling with zero.   |
| 1101   | Shift Left Arithmetically        | Shifts the input left by one position, preserving the sign bit. |
| 1110   | Shift Right Arithmetically       | Shifts the input right by one position, preserving the sign bit. |
| 1111   | Running Sum                       | Continuously adds the current 4-bit input to the output every second. |

### Additional Notes:
- **Running Sum**: This operation continuously adds the current 4-bit number at the input to the output every second.
- **Compare Operation**: The compare operation returns 2'b10 when A is greater than B, 2'b01 when B is greater than A, and 2'b11 when both are equal.
- **NOT Operation**: Treats inputs A and B as a combined 4-bit input for the NOT operation.
- **Subtraction Operation**: Anticipates unsigned number inputs (treating them as positive), but the output will reflect signed results based on the operation (A - B).


## License

This project is licensed under the MIT License.

## Acknowledgments

This project was inspired by the need to verify hardware designs using both hardware description languages and high-level programming languages.
Special thanks to Professor Magierowski for pushing me to do this project.
