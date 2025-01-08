`timescale 1ns/1ns
`include "AQALU.v"

module AQALU_tb;

    reg [1:0] A,B; // Inputs to AQALU
    reg [3:0] opcode;                // Opcode from the test file
    wire [7:0] aluOut;               // Output from AQALU
    reg rst, clk;
    integer fd, op1, out1, code, A1,B1,seconds, timestep;
    reg [7:0] testOut;
    reg [25:0] counter=0;
    reg [7:0] numSeconds=0;

    // Instantiate the AQALU module
    AQALU dut (.A(A), .B(B), .Opcode(opcode), .Output(aluOut), .clock(clk), .reset(rst));

    // Clock generation
    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk; //currently set to 10MHz
    end

    always @(posedge clk) begin
        if(counter== 26'd9_999_999) begin
            counter <= 0;
            numSeconds <= numSeconds+1;
        end
        else begin
            counter <= counter+1;
        end
    end

    /*
    Create a read and write flag based system for the sequential porition line by line instead to ensure the timing is picked up. 
    Do it in an always block so they are sensitive that way instead
    */
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
        $display("|Time\t|Match Status\t|Opcode\t|Expected \t|ALU-Output\t|Seconds\t|");
        $display("====================================================================");
        while (!$feof(fd)) begin
            code = $fscanf(fd, "%d,%d,%d,%d,%d\n", A1, B1, op1, out1,seconds);
            opcode = op1[3:0];   // Read the opcode
            testOut = out1[7:0];  // Slice and read the output
            A = A1[1:0];          //Slice and read for A
            B = B1[1:0];          //Slice and read for B
            timestep=seconds*10_000_000;
            #timestep;                 // Wait to apply the number of seconds ellapsed.

            if(opcode == 4'b1111)begin
               // $display("Opcode: %b, Expected Output: %8b, ALU Output: %b", opcode, testOut, aluOut);
                if (aluOut !== testOut) begin
                    $display("|%0tns\t|Mismatch!\t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, testOut, aluOut, numSeconds);
                    //$display("Mismatch! Expected: %8b, Got: %b", testOut, aluOut);
                end else begin
                    $display("|%0tns\t|Match! \t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, testOut, aluOut, numSeconds);
                    //$display("Match! Output is as expected: %b", aluOut);
                end
               /* if (aluOut !== testOut) begin
                    $display("Mismatch! Expected: %d, Got: %d\n", testOut, aluOut);
                end else begin
                    $display("Match! Output is as expected: %d\n", aluOut);
                end
                */
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
