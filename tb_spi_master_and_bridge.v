`timescale 1ns / 1ps

module tb_spi_master_and_bridge;
    
    //  General Signals
    reg clk;
    reg reset;
    
    //  SPI Signals
    wire SCLK;
    wire MOSI;
    reg MISO_G;
    wire SS_G;
    reg MISO_A;
    wire SS_A;
    
    //  AXI Signals
    reg TREADY;
    wire TVALID;
    wire [103:0] TDATA;
    
    attitude_estimation DUT (.clk(clk),
                             .reset(reset),
                             .SCLK(SCLK),
                             .MOSI(MOSI),
                             .MISO_G(MISO_G),
                             .SS_G(SS_G),
                             .MISO_A(MISO_A),
                             .SS_A(SS_A),
                             .TREADY(TREADY),
                             .TVALID(TVALID),
                             .TDATA(TDATA));
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        MISO_G = 1'b1;
        MISO_A = 1'b0;
        TREADY = 1'b1;
        
        #2
        reset = 1'b0;
        
        #620
        MISO_G = 1'b0;
        MISO_A = 1'b1;
        
        #1000
        
        $finish;
        end
        
    always #1 clk = ~clk;
    //always #4 MISO_G = ~MISO_G;
    //always #4 MISO_A = ~MISO_A;
    
endmodule