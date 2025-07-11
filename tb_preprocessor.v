`timescale 1ns / 1ps

module tb_preprocessor;
    
    //  General Signals
    reg clk;
    reg reset;
    
    //  Raw Sensor Data
    reg [15:0] RAW_GYRO_X;
    reg [15:0] RAW_GYRO_Y;
    reg [15:0] RAW_ACCL_X;
    reg [15:0] RAW_ACCL_Y;
    reg [15:0] RAW_ACCL_Z;
    
    //  Processed Sensor Data
    wire [15:0] GYRO_X;
    wire [15:0] GYRO_Y;
    wire [15:0] ACCL_X;
    wire [15:0] ACCL_Y;
    wire [15:0] ACCL_Z;
    
    //  AXI4-Stream Signals
    reg TVALID;
    wire TREADY;
    
    //  For-Loop Index
    integer i;
    
    preprocessor DUT (.clk(clk),
                      .reset(reset),
                      .RAW_GYRO_X(RAW_GYRO_X),
                      .RAW_GYRO_Y(RAW_GYRO_Y),
                      .RAW_ACCL_X(RAW_ACCL_X),
                      .RAW_ACCL_Y(RAW_ACCL_Y),
                      .RAW_ACCL_Z(RAW_ACCL_Z),
                      .GYRO_X(GYRO_X),
                      .GYRO_Y(GYRO_Y),
                      .ACCL_X(ACCL_X),
                      .ACCL_Y(ACCL_Y),
                      .ACCL_Z(ACCL_Z),
                      .TVALID(TVALID),
                      .TREADY(TREADY));
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        TVALID = 1'b0;
        
        #2
        reset = 1'b0;
        
        #2
        for (i = -32768; i < 32768; i = i + 1) begin
            TVALID = 1'b1;
            RAW_GYRO_X = i;
            RAW_GYRO_Y = i;
            RAW_ACCL_X = i;
            RAW_ACCL_Y = i;
            RAW_ACCL_Z = i;
            #2;
            end
            
        #50
            
        $finish;
        end
    
    always #1 clk = ~clk;
    
endmodule
