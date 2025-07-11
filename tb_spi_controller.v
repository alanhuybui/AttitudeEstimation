`timescale 1ns / 1ps

module tb_spi_controller;
    
    reg clk;
    reg reset;
    wire sensor_select;
    
    wire write_start;
    wire [7:0] write_data;
    wire [2:0] write_count_bytes;
    reg write_ready;

    spi_controller DUT (.clk(clk),
                        .reset(reset),
                        .sensor_select(sensor_select),
                        .write_start(write_start),
                        .write_data(write_data),
                        .write_count_bytes(write_count_bytes),
                        .write_ready(write_ready));
                    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        write_ready = 1'b0;
        
        #2
        reset = 1'b0;
        
        #4
        write_ready = 1'b1;
        
        #2
        write_ready = 1'b0;
        
        #8
        write_ready = 1'b1;
        
        #2
        write_ready = 1'b0;
        
        #8
        write_ready = 1'b1;
        
        #2
        write_ready = 1'b0;
        
        #8
        write_ready = 1'b1;
        
        #2
        write_ready = 1'b0;
        
        #8
        write_ready = 1'b1;
        
        #2
        write_ready = 1'b0;
        
        #8
        write_ready = 1'b1;
        
        #2
        write_ready = 1'b0;
        
        #50
        
        $finish;
        end
        
    always #1 clk = ~clk;
endmodule
