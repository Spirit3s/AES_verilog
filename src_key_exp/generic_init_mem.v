`timescale 1ns / 1ps

module generic_init_mem#(
	parameter ROM_WIDTH = 8,
   	parameter ROM_ADDR_BITS = 6,
   	parameter INIT_FILE = "rLPS_table_64x4_0.init"
	)(

	input clock,

	input enable,
	input [ROM_ADDR_BITS-1 : 0] address,
	output reg [ROM_WIDTH-1 : 0] data_out


    );


   

   reg [ROM_WIDTH-1:0] rom [(2**ROM_ADDR_BITS)-1:0];
   //reg [ROM_WIDTH-1:0] <output_data>;

   //<reg_or_wire> [ROM_ADDR_BITS-1:0] <address>;
   
   initial
      $readmemh(INIT_FILE, rom);

   always @(posedge clock)
      if (enable)
       	data_out <= rom[address];

endmodule
