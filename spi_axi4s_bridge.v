`timescale 1ns / 1ps

module spi_axis_bridge(
    //  General Signals
    input clk,
    input reset,
    input read_ready,
    input [7:0] read_data,
    
    //  AXI4-Stream Interface
    input TREADY,
    output reg TVALID,
    output [103:0] TDATA
    );

    reg [103:0] register_buffer;
    reg [3:0] internal_counter;
    
    
    //  Register Buffer
    always @ (posedge clk) begin
        if (reset)
            register_buffer <= 104'd0;
        else if (read_ready)
            register_buffer <= {register_buffer[95:0], read_data};
        end
        
    
    //  Internal Counter
    always @ (posedge clk) begin
        if (reset)
            internal_counter <= 4'd0;
        else if (internal_counter == 4'd13)
            internal_counter <= 4'd0;
        else if (read_ready)
            internal_counter <= internal_counter + 1'b1;
        end
    
    
    //  TVALID Signal
    always @ (posedge clk) begin
        if (reset)
            TVALID <= 1'b0;
        else if (internal_counter == 4'd13)
            TVALID <= 1'b1;
        else if (TVALID && TREADY)
            TVALID <= 1'b0;
        end
    
    assign TDATA = register_buffer;
    
endmodule
