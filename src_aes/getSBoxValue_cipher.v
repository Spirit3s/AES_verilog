`timescale 1ns / 1ps

module getSBoxValue_cipher(
  input clk_in,
  //input rst_in,
  input enable_in,

  input [31:0] data_in,
  output [31:0] data_out
    );

  wire [7:0] data_int0,data_int1 ,data_int2 , data_int3;

  generic_init_mem_2r#(
    .ROM_WIDTH(8),
    .ROM_ADDR_BITS(8),
    .INIT_FILE("sbox.init")
  ) m0 (
    .clock(clk_in),

    .enableA(enable_in), 
    .addressA(data_in[7:0]), 
    .data_outA(data_int3),

    .enableB(enable_in), 
    .addressB(data_in[15:8]), 
    .data_outB(data_int2)
    );

  generic_init_mem_2r#(
    .ROM_WIDTH(8),
    .ROM_ADDR_BITS(8),
    .INIT_FILE("sbox.init")
  ) m1 (
    .clock(clk_in),

    .enableA(enable_in), 
    .addressA(data_in[23:16]), 
    .data_outA(data_int1),
     
    .enableB(enable_in), 
    .addressB(data_in[31:24]), 
    .data_outB(data_int0)
    );

    assign data_out =  {data_int0 ,data_int1 ,data_int2,data_int3};

endmodule
