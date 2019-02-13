`timescale 1ns / 1ps


module rcon(
  input clk_in,
  //input rst_in,

  //input [1:0] Nk_in, // 4 => 2'd0 ; 6 => 2'd1 ; 2 => 2'd2;
  //input [5:0] i_in,
  input [5:0] addr_in,

  output [7:0] rcon_out

    );

/*
  wire [5:0] addr_wire;

  always @ (*) begin
    case(Nk_in)
      2'd0 : begin
        addr_wire     <= {2'd0,i_in[5:2]};
      end
      2'd1 : begin
        addr_wire     <= {3'd0,i_in[5:3]} + {i_in[3:0] , 2'd0} ;
      end
      2'd2 : begin
        addr_wire     <= {3'd0,i_in[5:3]};
      end
      default : begin
        addr_wire     <= {2'd0,i_in[5:2]};
      end

    endcase
  end
*/
  generic_init_mem#(
    .ROM_WIDTH(8),
      .ROM_ADDR_BITS(6),
      .INIT_FILE("Rcon.init")
  ) rcon_mem(
    .clock(clk_in), 
    .enable(1'b1), 
    .address(addr_in), 
    .data_out(rcon_out)
    );

  
  

endmodule
