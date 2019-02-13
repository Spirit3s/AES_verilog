`timescale 1ns / 1ps

module matrix_mod_aes(
    input clk_in,
    input rst_in,
    input en_in,
    input run_in,
    input config_in, // TODO : 

    input [31:0] data_A_in,

    input [31:0] key0_in,
    input [31:0] key1_in,
    input [31:0] key2_in,
    input [31:0] key3_in,


    input [1:0] sel_in,
    output [31:0] data_out 

    );


  parameter LOAD_0 = 3'd0;
  parameter LOAD_1 = 3'd1;
  parameter LOAD_2 = 3'd2;
  parameter LOAD_3 = 3'd3;
  parameter LOAD_F = 3'd4;


  reg [7:0] matrix00 , matrix01, matrix02 , matrix03; 
  reg [7:0] matrix10 , matrix11, matrix12 , matrix13; 
  reg [7:0] matrix20 , matrix21, matrix22 , matrix23; 
  reg [7:0] matrix30 , matrix31, matrix32 , matrix33; 

  reg [7:0] matrix00_nxt , matrix01_nxt, matrix02_nxt , matrix03_nxt; 
  reg [7:0] matrix10_nxt , matrix11_nxt, matrix12_nxt , matrix13_nxt; 
  reg [7:0] matrix20_nxt , matrix21_nxt, matrix22_nxt , matrix23_nxt; 
  reg [7:0] matrix30_nxt , matrix31_nxt, matrix32_nxt , matrix33_nxt;

  always @ (posedge clk_in , posedge rst_in) begin
    if(rst_in == 1'b1) begin
      matrix00    <= 8'd0;
      matrix10    <= 8'd0;
      matrix20    <= 8'd0;
      matrix30    <= 8'd0;
      matrix01    <= 8'd0;
      matrix11    <= 8'd0; 
      matrix21    <= 8'd0;
      matrix31    <= 8'd0;
      matrix02    <= 8'd0;
      matrix12    <= 8'd0;
      matrix22    <= 8'd0;
      matrix32    <= 8'd0;
      matrix03    <= 8'd0;
      matrix13    <= 8'd0;
      matrix23    <= 8'd0;
      matrix33    <= 8'd0;
    end else begin
      if(en_in == 1'b1 && ) begin
        matrix00    <= matrix00_nxt;
        matrix10    <= matrix10_nxt;
        matrix20    <= matrix20_nxt;
        matrix30    <= matrix30_nxt;
        matrix01    <= matrix01_nxt;
        matrix11    <= matrix11_nxt; 
        matrix21    <= matrix21_nxt;
        matrix31    <= matrix31_nxt;
        matrix02    <= matrix02_nxt;
        matrix12    <= matrix12_nxt;
        matrix22    <= matrix22_nxt;
        matrix32    <= matrix32_nxt;
        matrix03    <= matrix03_nxt;
        matrix13    <= matrix13_nxt;
        matrix23    <= matrix23_nxt;
        matrix33    <= matrix33_nxt;
      end
    end
  end


  always @ (*) begin
    matrix00_nxt    = matrix00;
    matrix10_nxt    = matrix10;
    matrix20_nxt    = matrix20;
    matrix30_nxt    = matrix30;
    matrix01_nxt    = matrix01;
    matrix11_nxt    = matrix11; 
    matrix21_nxt    = matrix21;
    matrix31_nxt    = matrix31;
    matrix02_nxt    = matrix02;
    matrix12_nxt    = matrix12;
    matrix22_nxt    = matrix22;
    matrix32_nxt    = matrix32;
    matrix03_nxt    = matrix03;
    matrix13_nxt    = matrix13;
    matrix23_nxt    = matrix23;
    matrix33_nxt    = matrix33;


    case(config_in)
      LOAD_0 : begin
        matrix00_nxt    = data_A_in[31:24]  ^ key0_in [31:24];
        matrix01_nxt    = data_A_in[23:16]  ^ key0_in [23:16];
        matrix02_nxt    = data_A_in[15:8]   ^ key0_in [15:8];
        matrix02_nxt    = data_A_in[7:0]    ^ key0_in [7:0];
      end

      LOAD_1 : begin
        matrix10_nxt    = data_A_in[31:24]  ^ key1_in [31:24];
        matrix11_nxt    = data_A_in[23:16]  ^ key1_in [23:16];
        matrix12_nxt    = data_A_in[15:8]   ^ key1_in [15:8];
        matrix12_nxt    = data_A_in[7:0]    ^ key1_in [7:0];
      end

      LOAD_2 : begin
        matrix20_nxt    = data_A_in[31:24]  ^ key2_in [31:24];
        matrix21_nxt    = data_A_in[23:16]  ^ key2_in [23:16];
        matrix22_nxt    = data_A_in[15:8]   ^ key2_in [15:8];
        matrix22_nxt    = data_A_in[7:0]    ^ key2_in [7:0];
      end

      LOAD_3 : begin
        matrix30_nxt    = data_A_in[31:24]  ^ key3_in [31:24];
        matrix31_nxt    = data_A_in[23:16]  ^ key3_in [23:16];
        matrix32_nxt    = data_A_in[15:8]   ^ key3_in [15:8];
        matrix32_nxt    = data_A_in[7:0]    ^ key3_in [7:0];
      end

      LOAD_F : begin
        matrix00_nxt    = matrix00          ^ key0_in [31:24];
        matrix01_nxt    = matrix01          ^ key0_in [23:16];
        matrix02_nxt    = matrix02          ^ key0_in [15:8];
        matrix03_nxt    = matrix03          ^ key0_in [7:0];

        matrix10_nxt    = matrix10          ^ key1_in [31:24];
        matrix11_nxt    = matrix11          ^ key1_in [23:16];
        matrix12_nxt    = matrix12          ^ key1_in [15:8];
        matrix13_nxt    = matrix13          ^ key1_in [7:0];

        matrix20_nxt    = matrix20          ^ key2_in [31:24];
        matrix21_nxt    = matrix21          ^ key2_in [23:16];
        matrix22_nxt    = matrix22          ^ key2_in [15:8];
        matrix23_nxt    = matrix23          ^ key2_in [7:0]; 

        matrix30_nxt    = matrix30          ^ key3_in [31:24];
        matrix31_nxt    = matrix31          ^ key3_in [23:16];
        matrix32_nxt    = matrix32          ^ key3_in [15:8];
        matrix33_nxt    = matrix33          ^ key3_in [7:0];       
      end

    endcase
  end



  end

endmodule
