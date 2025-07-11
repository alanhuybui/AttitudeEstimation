`timescale 1ns / 1ps


module spi_interface(
    //  General Signals
    input div_clk,
    input reset,
    input sensor_select,
    
    //  Transmit Signals
    input write_start,
    input [7:0] write_data,
    input [2:0] write_count_bytes,
    output reg write_ready,
    
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
    
    //  Sensor Identifiers
    parameter GYRO = 0;
    parameter ACCL = 1;
    
    //  State Encoding
    parameter state_init = 0;
    parameter state_idle = 1;
    parameter state_write_init = 2;
    parameter state_write_set_ss = 3;
    parameter state_write_hi = 4;
    parameter state_write_lo = 5;
    parameter state_write_done = 6;
    
    //  State Machine
    reg [3:0] current_state;
    reg [3:0] next_state;
    
    //  Transmitter (TX) Shift Register
    reg [7:0] shift_reg_tx;
    reg tx_reset;
    reg tx_parallel_load_enable;
    reg tx_shift_right_enable;
    
    //  Receiver (RX) Shift Register
    reg [7:0] shift_reg_rx;
    reg rx_reset;
    reg rx_shift_left_enable;
    
    //  Slave-Select Registers
    reg slave_select_gyro;
    reg slave_select_accl;
    
    //  Shared Clock
    reg shared_clk;
    
    //  Internal Counter
    reg [3:0] count;
    reg [2:0] count_bytes;
    reg count_reset;
    reg count_load;
    reg count_enable;
    reg count_done;
    reg count_bytes_done;
    
    
    //  State Machine Logic
    always @ (posedge div_clk) begin
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
                if (write_start)
                    next_state = state_write_init;
                end
            state_write_init: begin
                next_state = state_write_set_ss;
                end
            state_write_set_ss: begin
                next_state = state_write_hi;
                end
            state_write_hi: begin
                if (count_bytes_done)
                    next_state = state_write_done;
                else
                    next_state = state_write_lo;
                end
            state_write_lo: begin
                next_state = state_write_hi;
                end
            state_write_done: begin
                next_state = state_idle;
                end
            default: begin
                next_state = state_init;
                end
            endcase
        end
        
        
    //  Physical Register Logic
    always @ (posedge div_clk) begin
        //  TX Shift Register
        if (tx_reset)
            shift_reg_tx <= 8'd0;
        else if (tx_parallel_load_enable)
            shift_reg_tx <= write_data;
        else if (tx_shift_right_enable)
            shift_reg_tx <= {shift_reg_tx[6:0], 1'b0};
        
        //  RX Shift Register
        if (rx_reset)
            shift_reg_rx <= 8'd0;
        else if (rx_shift_left_enable && (sensor_select == GYRO))
            shift_reg_rx <= {shift_reg_rx[6:0], MISO_G};
        else if (rx_shift_left_enable && (sensor_select == ACCL))
            shift_reg_rx <= {shift_reg_rx[6:0], MISO_A};
            
        //  Internal Counter
        if (count_reset) begin
            count <= 4'd0;
            count_bytes <= 3'd0;
            count_done <= 1'b0;
            count_bytes_done <= 1'b0;
            end
        else if (count_load) begin
            count <= 4'd15;
            count_bytes <= write_count_bytes;
            end
        else if (count_enable) begin
            count <= count - 1;
            count_done <= 1'b0;
            
            if (count == 4'd1 && (write_count_bytes != count_bytes))
                count_done <= 1'b1;
            
            if (count == 4'd0) begin
                count_bytes <= count_bytes - 1;
                end
                
            if (count_bytes == 3'd1 && count == 4'd2)
                count_bytes_done <= 1'b1;
            end
        end
        
        
    //  Output Logic
    always @ (*) begin
            write_ready = 1'b0;
            tx_reset = 1'b0;
            tx_parallel_load_enable = 1'b0;
            tx_shift_right_enable = 1'b0;
            rx_reset = 1'b0;
            rx_shift_left_enable = 1'b0;
            slave_select_gyro = 1'b1;
            slave_select_accl = 1'b1;
            shared_clk = 1'b0;
            count_reset = 1'b0;
            count_load = 1'b0;
            count_enable = 1'b0;
            
            case (current_state)
                state_init: begin
                    tx_reset = 1'b1;
                    rx_reset = 1'b1;
                    count_reset = 1'b1;
                    end
                state_idle: begin
                    write_ready = 1'b1;
                    count_reset = 1'b1;
                    end
                state_write_init: begin
                    count_load = 1'b1;
                    tx_parallel_load_enable = 1'b1;
                    end
                state_write_set_ss: begin
                    rx_shift_left_enable = 1'b1;
                    
                    if (sensor_select == GYRO)
                        slave_select_gyro = 1'b0;
                    else
                        slave_select_accl = 1'b0;
                    end
                state_write_hi: begin
                    shared_clk = 1'b1;
                    tx_shift_right_enable = 1'b1;
                    count_enable = 1'b1;
                    
                    if (sensor_select == GYRO)
                        slave_select_gyro = 1'b0;
                    else
                        slave_select_accl = 1'b0;
                    end
                state_write_lo: begin
                    shared_clk = 1'b0;
                    rx_shift_left_enable = 1'b1;
                    count_enable = 1'b1;
                    
                    if (sensor_select == GYRO)
                        slave_select_gyro = 1'b0;
                    else
                        slave_select_accl = 1'b0;
                    end
                state_write_done: begin
                    shared_clk = 1'b0;
                    count_enable = 1'b1;
                    
                    if (sensor_select == GYRO)
                        slave_select_gyro = 1'b0;
                    else
                        slave_select_accl = 1'b0;
                    end
                endcase
            end
        
        
        assign MOSI = shift_reg_tx[7];
        assign SS_G = slave_select_gyro;
        assign SS_A = slave_select_accl;
        assign SCLK = shared_clk;
        
        assign read_ready = count_done;
        assign read_data = shift_reg_rx;
endmodule