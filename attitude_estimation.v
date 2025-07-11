`timescale 1ns / 1ps

module attitude_estimation(
    input clk,
    input reset,
    
    //  SPI Signals
    output SCLK,
    output MOSI,
    input  MISO_G,
    output SS_G,
    input  MISO_A,
    output SS_A,
    
    //  Preprocessed Data
    output [15:0] gyro_x,
    output [15:0] gyro_y,
    output [15:0] accl_x,
    output [15:0] accl_y,
    output [15:0] accl_z
    );
    
    wire read_ready;
    wire [7:0] read_data;
    
    wire TREADY;
    wire TVALID;
    wire [103:0] TDATA;
    
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
                       
    spi_axis_bridge bridge (.clk(clk),
                            .reset(reset),
                            .read_ready(read_ready),
                            .read_data(read_data),
                            .TREADY(TREADY),
                            .TVALID(TVALID),
                            .TDATA(TDATA));
                            
    preprocessor preprocessor (.clk(clk),
                               .reset(reset),
                               .RAW_GYRO_X({TDATA[95:88], TDATA[103:96]}),
                               .RAW_GYRO_Y({TDATA[79:72], TDATA[87:80]}),
                               .RAW_ACCL_X({TDATA[55:48], TDATA[63:56]}),
                               .RAW_ACCL_Y({TDATA[31:24], TDATA[39:32]}),
                               .RAW_ACCL_Z({TDATA[7:0], TDATA[15:8]}),
                               .GYRO_X(gyro_x),
                               .GYRO_Y(gyro_y),
                               .ACCL_X(accl_x),
                               .ACCL_Y(accl_y),
                               .ACCL_Z(accl_z),
                               .TREADY(TREADY),
                               .TVALID(TVALID));

                            
endmodule