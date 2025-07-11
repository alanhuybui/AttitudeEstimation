`timescale 1 ns / 1 ns

//  MATLAB Simulink HDL Coder

module preprocessor
          (clk,
           reset,
           RAW_GYRO_X,
           RAW_GYRO_Y,
           RAW_ACCL_X,
           RAW_ACCL_Y,
           RAW_ACCL_Z,
           GYRO_X,
           GYRO_Y,
           ACCL_X,
           ACCL_Y,
           ACCL_Z,
           
           TVALID,
           TREADY);


  input   clk;
  input   reset;
  input   signed [15:0] RAW_GYRO_X;  // int16
  input   signed [15:0] RAW_GYRO_Y;  // int16
  input   signed [15:0] RAW_ACCL_X;  // int16
  input   signed [15:0] RAW_ACCL_Y;  // int16
  input   signed [15:0] RAW_ACCL_Z;  // int16
  output  signed [15:0] GYRO_X;  // sfix16_En8
  output  signed [15:0] GYRO_Y;  // sfix16_En8
  output  signed [15:0] ACCL_X;  // sfix16_En3
  output  signed [15:0] ACCL_Y;  // sfix16_En3
  output  signed [15:0] ACCL_Z;  // sfix16_En3
  
  input TVALID;
  output TREADY;
  
  assign TREADY = 1'b1;


  wire signed [30:0] Data_Type_Conversion6_out1;  // sfix31_En15
  wire signed [61:0] Gain8_mul_temp;  // sfix62_En59
  wire signed [16:0] Gain8_out1;  // sfix17_En15
  wire signed [33:0] Gain12_mul_temp;  // sfix34_En24
  wire signed [15:0] Gain12_out1;  // sfix16_En8
  reg signed [15:0] Unit_Delay_out1;  // sfix16_En8
  wire signed [30:0] Data_Type_Conversion1_out1;  // sfix31_En15
  wire signed [61:0] Gain2_mul_temp;  // sfix62_En59
  wire signed [16:0] Gain2_out1;  // sfix17_En15
  wire signed [33:0] Gain1_mul_temp;  // sfix34_En24
  wire signed [15:0] Gain1_out1;  // sfix16_En8
  reg signed [15:0] Unit_Delay1_out1;  // sfix16_En8
  wire signed [30:0] Data_Type_Conversion_out1;  // sfix31_En15
  wire signed [61:0] Gain3_mul_temp;  // sfix62_En59
  wire signed [16:0] Gain3_out1;  // sfix17_En15
  wire signed [33:0] Gain4_mul_temp;  // sfix34_En19
  wire signed [15:0] Gain4_out1;  // sfix16_En3
  reg signed [15:0] Unit_Delay2_out1;  // sfix16_En3
  wire signed [30:0] Data_Type_Conversion2_out1;  // sfix31_En15
  wire signed [61:0] Gain5_mul_temp;  // sfix62_En59
  wire signed [16:0] Gain5_out1;  // sfix17_En15
  wire signed [33:0] Gain6_mul_temp;  // sfix34_En19
  wire signed [15:0] Gain6_out1;  // sfix16_En3
  reg signed [15:0] Unit_Delay3_out1;  // sfix16_En3
  wire signed [30:0] Data_Type_Conversion3_out1;  // sfix31_En15
  wire signed [61:0] Gain7_mul_temp;  // sfix62_En59
  wire signed [16:0] Gain7_out1;  // sfix17_En15
  wire signed [33:0] Gain9_mul_temp;  // sfix34_En19
  wire signed [15:0] Gain9_out1;  // sfix16_En3
  reg signed [15:0] Unit_Delay4_out1;  // sfix16_En3


  assign Data_Type_Conversion6_out1 = {RAW_GYRO_X, 15'b000000000000000};

  assign Gain8_mul_temp = 31'sb0100000000000000100000000000001 * Data_Type_Conversion6_out1;
  assign Gain8_out1 = Gain8_mul_temp[60:44] + $signed({1'b0, Gain8_mul_temp[43] & (( ~ Gain8_mul_temp[61]) | (|Gain8_mul_temp[42:0]))});

  assign Gain12_mul_temp = 17'sb01111101000000000 * Gain8_out1;
  assign Gain12_out1 = Gain12_mul_temp[31:16] + $signed({1'b0, Gain12_mul_temp[15] & (( ~ Gain12_mul_temp[33]) | (|Gain12_mul_temp[14:0]))});

  always @(posedge clk)
    begin : Unit_Delay_process
      if (reset == 1'b1) begin
        Unit_Delay_out1 <= 16'sb0000000000000000;
      end
      else if (TREADY && TVALID) begin
        Unit_Delay_out1 <= Gain12_out1;
      end
    end

  assign GYRO_X = Unit_Delay_out1;

  assign Data_Type_Conversion1_out1 = {RAW_GYRO_Y, 15'b000000000000000};

  assign Gain2_mul_temp = 31'sb0100000000000000100000000000001 * Data_Type_Conversion1_out1;
  assign Gain2_out1 = Gain2_mul_temp[60:44] + $signed({1'b0, Gain2_mul_temp[43] & (( ~ Gain2_mul_temp[61]) | (|Gain2_mul_temp[42:0]))});

  assign Gain1_mul_temp = 17'sb01111101000000000 * Gain2_out1;
  assign Gain1_out1 = Gain1_mul_temp[31:16] + $signed({1'b0, Gain1_mul_temp[15] & (( ~ Gain1_mul_temp[33]) | (|Gain1_mul_temp[14:0]))});

  always @(posedge clk)
    begin : Unit_Delay1_process
      if (reset == 1'b1) begin
        Unit_Delay1_out1 <= 16'sb0000000000000000;
      end
      else if (TREADY && TVALID) begin
        Unit_Delay1_out1 <= Gain1_out1;
      end
    end

  assign GYRO_Y = Unit_Delay1_out1;

  assign Data_Type_Conversion_out1 = {RAW_ACCL_X, 15'b000000000000000};

  assign Gain3_mul_temp = 31'sb0100000000000000100000000000001 * Data_Type_Conversion_out1;
  assign Gain3_out1 = Gain3_mul_temp[60:44] + $signed({1'b0, Gain3_mul_temp[43] & (( ~ Gain3_mul_temp[61]) | (|Gain3_mul_temp[42:0]))});

  assign Gain4_mul_temp = 17'sb01011101110000000 * Gain3_out1;
  assign Gain4_out1 = Gain4_mul_temp[31:16] + $signed({1'b0, Gain4_mul_temp[15] & (( ~ Gain4_mul_temp[33]) | (|Gain4_mul_temp[14:0]))});

  always @(posedge clk)
    begin : Unit_Delay2_process
      if (reset == 1'b1) begin
        Unit_Delay2_out1 <= 16'sb0000000000000000;
      end
      else if (TREADY && TVALID) begin
        Unit_Delay2_out1 <= Gain4_out1;
      end
    end

  assign ACCL_X = Unit_Delay2_out1;

  assign Data_Type_Conversion2_out1 = {RAW_ACCL_Y, 15'b000000000000000};

  assign Gain5_mul_temp = 31'sb0100000000000000100000000000001 * Data_Type_Conversion2_out1;
  assign Gain5_out1 = Gain5_mul_temp[60:44] + $signed({1'b0, Gain5_mul_temp[43] & (( ~ Gain5_mul_temp[61]) | (|Gain5_mul_temp[42:0]))});

  assign Gain6_mul_temp = 17'sb01011101110000000 * Gain5_out1;
  assign Gain6_out1 = Gain6_mul_temp[31:16] + $signed({1'b0, Gain6_mul_temp[15] & (( ~ Gain6_mul_temp[33]) | (|Gain6_mul_temp[14:0]))});

  always @(posedge clk)
    begin : Unit_Delay3_process
      if (reset == 1'b1) begin
        Unit_Delay3_out1 <= 16'sb0000000000000000;
      end
      else if (TREADY && TVALID) begin
        Unit_Delay3_out1 <= Gain6_out1;
      end
    end

  assign ACCL_Y = Unit_Delay3_out1;

  assign Data_Type_Conversion3_out1 = {RAW_ACCL_Z, 15'b000000000000000};

  assign Gain7_mul_temp = 31'sb0100000000000000100000000000001 * Data_Type_Conversion3_out1;
  assign Gain7_out1 = Gain7_mul_temp[60:44] + $signed({1'b0, Gain7_mul_temp[43] & (( ~ Gain7_mul_temp[61]) | (|Gain7_mul_temp[42:0]))});

  assign Gain9_mul_temp = 17'sb01011101110000000 * Gain7_out1;
  assign Gain9_out1 = Gain9_mul_temp[31:16] + $signed({1'b0, Gain9_mul_temp[15] & (( ~ Gain9_mul_temp[33]) | (|Gain9_mul_temp[14:0]))});

  always @(posedge clk)
    begin : Unit_Delay4_process
      if (reset == 1'b1) begin
        Unit_Delay4_out1 <= 16'sb0000000000000000;
      end
      else if (TREADY && TVALID) begin
        Unit_Delay4_out1 <= Gain9_out1;
      end
    end

  assign ACCL_Z = Unit_Delay4_out1;

endmodule