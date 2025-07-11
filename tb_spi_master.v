`timescale 1ns / 1ps

module tb_spi_master;

    reg clk;
    reg reset;
    wire read_ready;
    wire [7:0] read_data;
    wire SCLK;
    wire MOSI;
    reg MISO_G;
    wire SS_G;
    reg MISO_A;
    wire SS_A;
    
    spi_master master (.clk(clk),
                       .reset(reset),
                       .read_ready(read_ready),
                       .read_data(read_data),
                       .SCLK(SCLK),
                       .MOSI(MOSI),
                       .MISO_G(MISO_G),
                       .SS_G(SS_G),
                       .MISO_A(MISO_A),
                       .SS_A(SS_A));
                       
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        MISO_G = 1'b1;
        MISO_A = 1'b0;
        
        #2
        reset = 1'b0;
        
        #600
        
        $finish;
        end;
    
    always #1 clk = ~clk;
    always #4 MISO_G = ~MISO_G;
    always #4 MISO_A = ~MISO_A;
    
endmodule
