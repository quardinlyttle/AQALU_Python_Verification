`timescale 1ns/1ns
`include "AQALU.v"

module AQALU_tb;

    reg [1:0] A,B; // Inputs to AQALU
    reg [3:0] opcode;                // Opcode from the test file
    wire [7:0] aluOut;               // Output from AQALU
    reg rst, clk;
    integer fd, op1, out1, code, A1,B1;
    reg [7:0] testOut;

    // Instantiate the AQALU module
    AQALU dut (.A(A), .B(B), .Opcode(opcode), .Output(aluOut), .clock(clk), .reset(rst));

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk; //currently set to 10MHz
    end

    initial begin
        // Initialize signals and open the file
        $dumpfile("AQALU_tb.vcd");
        $dumpvars(0, AQALU_tb);

        rst = 1;
        #10 rst = 0; // Release reset after some time

        // Open the test vector file
        fd = $fopen("testvector1.txt", "r");
        if (fd == 0) begin
            $display("Error: Could not open testvector1.txt.");
            $finish;
        end

        // Read and apply each test case from the file
        while (!$feof(fd)) begin
            code = $fscanf(fd, "%d,%d,%d,%d\n", A1, B1, op1, out1);
            opcode = op1[3:0];   // Read the opcode
            testOut = out1[7:0];  // Slice and read the output
            A = A1[1:0];          //Slice and read for A
            B = B1[1:0];          //Slice and read for B
            #10;                 // Wait to apply the new opcode to AQALU

            if(opcode < 4'b1110)begin
                $display("Opcode: %b, Expected Output: %8b, ALU Output: %b", opcode, testOut, aluOut);
                if (aluOut !== testOut) begin
                    $display("Mismatch! Expected: %8b, Got: %b", testOut, aluOut);
                end else begin
                    $display("Match! Output is as expected: %b", aluOut);
                end
                if (aluOut !== testOut) begin
                    $display("Mismatch! Expected: %d, Got: %d", testOut, aluOut);
                end else begin
                    $display("Match! Output is as expected: %d", aluOut);
                end
            end

            // else begin
            //     #10
            // end
        end

        // Close file and finish simulation
        $fclose(fd);
        $finish;
    end

endmodule
