`timescale 1ns/1ns
`include "AQALU.v"

module AQALU_tb;

    reg [1:0] A,B; // Inputs to AQALU
    reg [3:0] opcode;                // Opcode from the test file
    wire [7:0] aluOut;               // Output from AQALU
    reg rst, clk;
    integer fd, op1, out1, code, A1,B1,seconds, timestep,i,scale = 10_000;
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
       // if(counter== 26'd9_999_999) begin
       if(counter== (26'd1000-1)) begin
            counter <= 0;
            numSeconds <= numSeconds+1;
        end
        else begin
            counter <= counter+1;
        end
    end

    initial begin
    #10_000_000_000;  // Run the simulation for 10 seconds
    $finish;
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
        
        readFlag = 0;
        #10
        readFlag = 1;
        writeFlag = 0;
        doneFlag = 0;

        // Read and apply each test case from the file
        $display("|Time\t|Match Status\t|Opcode\t|Expected \t|ALU-Output\t|Seconds\t|");
        $display("====================================================================");
        // Close file and finish simulation
        //$fclose(fd);
        //$finish;
    end

        /*
    Create a read and write flag based system for the sequential porition line by line instead to ensure the timing is picked up. 
    Do it in an always block so they are sensitive that way instead
    */

    always @(posedge clk)begin
        if(readFlag)begin
            readFlag <=0;
            if(!$feof(fd))begin
               // $display("reading");
                code <= $fscanf(fd, "%d,%d,%d,%d,%d\n", A1, B1, op1, out1,seconds);
                opcode <= op1[3:0];   // Read the opcode
                testOut <= out1[7:0];  // Slice and read the output
                A <= A1[1:0];          //Slice and read for A
                B <= B1[1:0];          //Slice and read for B
                //timestep <= seconds*10_000_000;
                timestep <= seconds*scale;
                #10
                writeFlag <=1;
            end
            else if($feof(fd)) begin
                //$display("Simulation Complete");
                doneFlag <=1;
            end
        end
    end

    always @(posedge clk)begin 
        if(writeFlag)begin
          //  $display("writing");
            if(opcode == 4'b1111)begin
                #timestep
               //$display("Opcode 1111");
               //repeat (timestep) #1;
                //repeat (seconds * 10_000_000) @(posedge clk);
                /*
                for (i = 0; i < seconds * 10000; i = i + 1) begin
                    @(posedge clk);
                end
                */
                
                if (aluOut !== testOut) begin
                    $display("|%0tns\t|Mismatch!\t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, testOut, aluOut, numSeconds);
                end else begin
                    $display("|%0tns\t|Match! \t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, testOut, aluOut, numSeconds);
                end
            end
                else if(opcode < 4'b1111)begin
                    #timestep
                    if (aluOut !== testOut) begin
                        $display("|%0tns\t|Mismatch!\t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, testOut, aluOut, numSeconds);
                    end else begin
                        $display("|%0tns\t|Match! \t|%b\t|%b\t|%b\t|%d\t|",$time,opcode, testOut, aluOut, numSeconds);
                    end
                end
            #10    
            readFlag <=1;
        end
    end

    always @(posedge doneFlag)begin
        $display("Simulation Complete");
        $fclose(fd);
        $finish;
    end


endmodule
