`timescale 1ns / 1ps

module generic_init_mem_2r#(
	parameter ROM_WIDTH = 8,
   	parameter ROM_ADDR_BITS = 6,
   	parameter INIT_FILE = "rLPS_table_64x4_0.init"
	)(

	input clock,

	input enableA,
	input [ROM_ADDR_BITS-1 : 0] addressA,
	output reg [ROM_WIDTH-1 : 0] data_outA,

	input enableB,
	input [ROM_ADDR_BITS-1 : 0] addressB,
	output reg [ROM_WIDTH-1 : 0] data_outB


    );


   

   reg [ROM_WIDTH-1:0] rom [(2**ROM_ADDR_BITS)-1:0];
   //reg [ROM_WIDTH-1:0] <output_data>;

   //<reg_or_wire> [ROM_ADDR_BITS-1:0] <address>;
   
   initial
      $readmemh(INIT_FILE, rom);

   	always @(posedge clock)
      if (enableA)
       	data_outA <= rom[addressA];

   	always @(posedge clock)
      if (enableB)
      	data_outB <= rom[addressB];


endmodule