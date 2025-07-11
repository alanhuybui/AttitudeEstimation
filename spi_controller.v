`timescale 1ns / 1ps

//  SPI Mode 0:
//  Clock Polarity (CPOL) = 0
//  Clock Phase (CPHA) = 0 (Leading)

module spi_controller(
    //  General Signals
    input clk,
    input reset,
    output reg sensor_select,
    
    //  Transmit Signals
    output reg write_start,
    output reg [7:0] write_data,
    output reg [2:0] write_count_bytes,
    input write_ready
    );
    
    //  Sensor Identifiers
    parameter GYRO = 0;
    parameter ACCL = 1;
    
    //  State Encodings
    parameter state_init = 0;
    parameter state_idle = 1;
    parameter state_gyro_x = 2;
    parameter state_idle_1 = 3;
    parameter state_gyro_y = 4;
    parameter state_idle_2 = 5;
    parameter state_accl_x = 6;
    parameter state_idle_3 = 7;
    parameter state_accl_y = 8;
    parameter state_idle_4 = 9;
    parameter state_accl_z = 10;
    parameter state_idle_5 = 11;

    //  State Machine
    reg [3:0] current_state;
    reg [3:0] next_state;
    
    
    //  State Machine Logic
    always @ (posedge clk) begin
        if (reset)
            current_state <= state_init;
        else
            current_state <= next_state;
        end
    
    
    //  Next State Logic
    always @ (*) begin
        next_state = current_state;
        
        case (current_state)
            state_init: begin
                next_state = state_idle;
                end
            state_idle: begin
                if (write_ready)
                    next_state = state_gyro_x;
                end
            state_gyro_x: begin
                next_state = state_idle_1;
                end
            state_idle_1: begin
                if (write_ready)
                    next_state = state_gyro_y;
                end
            state_gyro_y: begin
                next_state = state_idle_2;
                end
            state_idle_2: begin
                if (write_ready)
                    next_state = state_accl_x;
                end
            state_accl_x: begin
                next_state = state_idle_3;
                end
            state_idle_3: begin
                if (write_ready)
                    next_state = state_accl_y;
                end
            state_accl_y: begin
                next_state = state_idle_4;
                end
            state_idle_4: begin
                if (write_ready)
                    next_state = state_accl_z;
                end
            state_accl_z: begin
                next_state = state_idle_5;
                end
            state_idle_5: begin
                if (write_ready)
                    next_state = state_gyro_x;
                end
            endcase
        end
    
    
    //  Output Logic
    always @ (*) begin
        case (current_state)
            state_init: begin
                sensor_select = 1'b0;
                write_start = 1'b0;
                write_data = 8'd0;
                write_count_bytes = 3'b0;
                end
            state_idle: begin
                sensor_select = 1'b0;
                write_start = 1'b0;
                write_data = 8'd0;
                write_count_bytes = 3'b0;
                end
            state_gyro_x: begin
                sensor_select = GYRO;
                write_start = 1'b1;
                write_data = 8'h02;
                write_count_bytes = 3'd3;
                end
            state_idle_1: begin
                sensor_select = GYRO;
                write_start = 1'b0;
                write_data = 8'h02;
                write_count_bytes = 3'd3;
                end
            state_gyro_y: begin
                sensor_select = GYRO;
                write_start = 1'b1;
                write_data = 8'h04;
                write_count_bytes = 3'd3;
                end
            state_idle_2: begin
                sensor_select = GYRO;
                write_start = 1'b0;
                write_data = 8'h04;
                write_count_bytes = 3'd3;
                end
            state_accl_x: begin
                sensor_select = ACCL;
                write_start = 1'b1;
                write_data = 8'h12;
                write_count_bytes = 3'd4;
                end
            state_idle_3: begin
                sensor_select = ACCL;
                write_start = 1'b0;
                write_data = 8'h12;
                write_count_bytes = 3'd4;
                end
            state_accl_y: begin
                sensor_select = ACCL;
                write_start = 1'b1;
                write_data = 8'h14;
                write_count_bytes = 3'd4;
                end
            state_idle_4: begin
                sensor_select = ACCL;
                write_start = 1'b0;
                write_data = 8'h14;
                write_count_bytes = 3'd4;
                end
            state_accl_z: begin
                sensor_select = ACCL;
                write_start = 1'b1;
                write_data = 8'h16;
                write_count_bytes = 3'd4;
                end
            state_idle_5: begin
                sensor_select = ACCL;
                write_start = 1'b0;
                write_data = 8'h16;
                write_count_bytes = 3'd4;
                end
            endcase
        end
    
    
endmodule