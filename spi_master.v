`timescale 1ns / 1ps

module spi_master(
    input clk,
    input reset,
    
    //  Read Signals
    output wire read_ready,
    output wire [7:0] read_data,
    
    //  Shared SPI Interface
    output wire SCLK,
    output wire MOSI,
    
    //  Gyroscope-Specific SPI Interface
    input  wire MISO_G,
    output wire SS_G,
    
    //  Accelerometer-Specific SPI Interface
    input  wire MISO_A,
    output wire SS_A
    );
    
    wire sensor_select;
    wire write_start;
    wire [7:0] write_data;
    wire [2:0] write_count_bytes;
    wire write_ready;
    
    spi_controller controller(.clk(clk),
                              .reset(reset),
                              .sensor_select(sensor_select),
                              .write_start(write_start),
                              .write_data(write_data),
                              .write_count_bytes(write_count_bytes),
                              .write_ready(write_ready));
    
    spi_interface interface(.div_clk(clk),
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
endmodule