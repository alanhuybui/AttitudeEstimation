`timescale 1ns / 1ps

module tb_spi_axis_bridge;
    //  General Signals
    reg clk;
    reg reset;
    reg read_ready;
    reg [7:0] read_data;
    
    //  AXI4-Stream Interface
    reg TREADY;
    wire TVALID;
    wire [103:0] TDATA;
    
    spi_axis_bridge DUT (.clk(clk),
                         .reset(reset),
                         .read_ready(read_ready),
                         .read_data(read_data),
                         .TREADY(TREADY),
                         .TVALID(TVALID),
                         .TDATA(TDATA));
    
    integer i;
                         
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        read_ready = 1'b0;
        read_data = 8'd0;
        TREADY = 1'b1;
        
        #2
        reset = 1'b0;
        
        #8
        
        for (i = 0; i < 13; i = i + 1) begin
            read_ready = 1'b1;
            read_data = i;
            #2;
            read_ready = 1'b0;
            #2;
            end
        
        for (i = 0; i < 13; i = i + 1) begin
            read_ready = 1'b1;
            read_data = i;
            #2;
            read_ready = 1'b0;
            #2;
            end
            
        #50
        $finish;
        end
        
    always #1 clk = ~clk;
    
endmodule
