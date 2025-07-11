`timescale 1ns / 1ps

module tb_spi_with_preprocessor;
    
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
    
    //  Processed Sensor Data
    wire [15:0] gyro_x;
    wire [15:0] gyro_y;
    wire [15:0] accl_x;
    wire [15:0] accl_y;
    wire [15:0] accl_z;
    
    attitude_estimation DUT (.clk(clk),
                             .reset(reset),
                             .SCLK(SCLK),
                             .MOSI(MOSI),
                             .MISO_G(MISO_G),
                             .SS_G(SS_G),
                             .MISO_A(MISO_A),
                             .SS_A(SS_A),
                             .gyro_x(gyro_x),
                             .gyro_y(gyro_y),
                             .accl_x(accl_x),
                             .accl_y(accl_y),
                             .accl_z(accl_z));
    
    integer i;
    reg signed [15:0] raw_gyro_x;
    reg signed [15:0] raw_gyro_y;
    reg signed [15:0] raw_accl_x;
    reg signed [15:0] raw_accl_y;
    reg signed [15:0] raw_accl_z;
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        MISO_G = 1'b0;
        MISO_A = 1'b0;
        
        //  Data To Test
        raw_gyro_x = 32767;
        raw_gyro_y = 32767;
        raw_accl_x = 32767;
        raw_accl_y = 32767;
        raw_accl_z = 32767;
        
        #2
        reset = 1'b0;
        
        #1
        
        //  First Sample
        #38
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_G = raw_gyro_x[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_G = raw_gyro_x[i];
            #4;
            end
        
        #40
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_G = raw_gyro_y[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_G = raw_gyro_y[i];
            #4;
            end
        
        #40
        for (i = 0; i < 8; i = i + 1) begin
            MISO_A = 1;
            #4;
            end
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_A = raw_accl_x[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_A = raw_accl_x[i];
            #4;
            end
            
        #40
        for (i = 0; i < 8; i = i + 1) begin
            MISO_A = 1;
            #4;
            end
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_A = raw_accl_y[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_A = raw_accl_y[i];
            #4;
            end
        
        #40
        for (i = 0; i < 8; i = i + 1) begin
            MISO_A = 1;
            #4;
            end
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_A = raw_accl_z[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_A = raw_accl_z[i];
            #4;
            end
        
        //  Second Sample
        raw_gyro_x = -32767;
        raw_gyro_y = -32767;
        raw_accl_x = -32767;
        raw_accl_y = -32767;
        raw_accl_z = -32767;
        
        #40
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_G = raw_gyro_x[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_G = raw_gyro_x[i];
            #4;
            end
        
        #40
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_G = raw_gyro_y[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_G = raw_gyro_y[i];
            #4;
            end
        
        #40
        for (i = 0; i < 8; i = i + 1) begin
            MISO_A = 1;
            #4;
            end
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_A = raw_accl_x[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_A = raw_accl_x[i];
            #4;
            end
            
        #40
        for (i = 0; i < 8; i = i + 1) begin
            MISO_A = 1;
            #4;
            end
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_A = raw_accl_y[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_A = raw_accl_y[i];
            #4;
            end
        
        #40
        for (i = 0; i < 8; i = i + 1) begin
            MISO_A = 1;
            #4;
            end
        for (i = 7; i >= 0; i = i - 1) begin
            MISO_A = raw_accl_z[i];
            #4;
            end
        for (i = 15; i >= 8; i = i - 1) begin
            MISO_A = raw_accl_z[i];
            #4;
            end
        
        MISO_G = 0;
        MISO_A = 0;
            
        #2000
        $finish;
        end
    
    always #1 clk = ~clk;
    
endmodule
