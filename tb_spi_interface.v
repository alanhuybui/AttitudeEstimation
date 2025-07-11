`timescale 1ns / 1ps

module tb_spi_interface();
    
    reg div_clk;
    reg reset;
    reg sensor_select;
    
    reg write_start;
    reg [7:0] write_data;
    reg [2:0] write_count_bytes;
    wire write_ready;
    
    wire read_ready;
    wire [7:0] read_data;
    
    wire SCLK;
    wire MOSI;
    reg MISO_G;
    wire SS_G;
    
    reg MISO_A;
    wire SS_A;
    
    spi_interface DUT (.div_clk(div_clk),
                       .reset(reset),
                       .sensor_select(sensor_select),
                       .write_start(write_start),
                       .write_data(write_data),
                       .write_count_bytes(write_count_bytes),
                       .write_ready(write_ready),
                       .read_ready(read_ready),
                       .read_data(read_data),
                       .SCLK(SCLK),
                       .MOSI(MOSI),
                       .MISO_G(MISO_G),
                       .SS_G(SS_G),
                       .MISO_A(MISO_A),
                       .SS_A(SS_A));
                       
    initial begin
        div_clk = 1'b1;
        sensor_select = 1'b0;   //  GYRO
        write_start = 1'b0;
        write_data = 7'd0;
        write_count_bytes = 3'd0;
        MISO_G = 1'b0;
        MISO_A = 1'b0;
        
        reset = 1'b1;
        #2
        
        reset = 1'b0;
        #17
        
        write_start = 1'b1;
        write_data = 8'hAA;
        write_count_bytes = 3'd2;
        #2
        write_start = 1'b0;
        #34
        
        MISO_G = 1'b1;
        #4
        MISO_G = 1'b0;
        #4
        MISO_G = 1'b1;
        #4
        MISO_G = 1'b0;
        #4
        MISO_G = 1'b1;
        #18
        
        sensor_select = 1'b1;   //  ACCL
        write_start = 1'b1;
        write_data = 8'hFF;
        write_count_bytes = 3'd5;
        #2
        write_start = 1'b0;
        #34
        
        MISO_A = 1'b1;
        #4
        MISO_A = 1'b0;
        #4
        MISO_A = 1'b1;
        #4
        MISO_A = 1'b0;
        #4
        MISO_A = 1'b1;
        #114
        
        #8
        
        $finish;
        end
        
    always #1 div_clk = ~div_clk;
    
endmodule
