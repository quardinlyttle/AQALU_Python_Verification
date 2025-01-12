`timescale 1ns/1ns
`include "AQALU.v"

module AQALU_tb;

    reg [1:0] A,B; // Inputs to AQALU
    reg [3:0] opcode;                // Opcode from the test file
    wire [7:0] aluOut;               // Output from AQALU
    reg rst, clk;
    integer fd, op1, out1, code, A1,B1,seconds, timestep,i;
    reg [7:0] testOut;
    reg [25:0] counter=0;
    reg [7:0] numSeconds=0;
    reg readFlag, writeFlag, doneFlag;

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

    initial begin
    #50_000_000;  // Run the simulation for .5 seconds
    $finish;
end

    initial begin
        // Initialize signals and open the file
        $dumpfile("AQALU_tb.vcd");
        $dumpvars(0, AQALU_tb);

        rst = 1;
        #10 rst = 0; // Release reset after some time
        A = 2'b01;
        B = 2'b00;
        opcode = 4'b1111;

        $display("|Time\t|Opcode\t|ALU-Output\t|Seconds\t|");
        $display("====================================================================");
        $monitor("|%0tns\t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, aluOut, numSeconds);


    end
endmodule
