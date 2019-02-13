`timescale 1ns / 1ps

// The number of 32 bit words in a key.
//#define Nk 4

module for_mod(
  input clk_in, 
  input rst_in,

  input enable_in,
  input [1:0] conf_in,// 

  output [5:0] i_out,
  output [5:0] imodk_out,


  output reg mod256_4_flag,
  output reg fst_a_cpy_out,
  output reg nw_imodk_out,
  output reg last_out

    );
//conf_out
//2'b00 => Nk = 4 &&  Nr = 10 // (Nb * (Nr + 1))) = (4 * (10+1)) = 44
//2'b01 => Nk = 6 &&  Nr = 12 // (Nb * (Nr + 1))) = (4 * (12+1)) = 52
//2'b10 => Nk = 8 &&  Nr = 14 // (Nb * (Nr + 1))) = (4 * (14+1)) = 60

reg [5:0] counter_int_i;
reg [5:0] counter_int_global;
reg [5:0] counter_int_imodk;
reg [1:0] counter4;

wire [5:0] mod_cap;
wire [5:0] global_cap;

assign i_out        = counter_int_global;
assign imodk_out    = counter_int_imodk;

assign mod_cap      = (conf_in == 2'd0) ? 6'd4
                    : (conf_in == 2'd1) ? 6'd6
                    : 6'd8;

assign global_cap   = (conf_in == 2'd0) ? 6'd44
                    : (conf_in == 2'd1) ? 6'd52
                    : 6'd60;

always @ (posedge clk_in , posedge rst_in) begin
  if(rst_in == 1'b1) begin
    counter_int_i           <= 6'd0;
    counter_int_imodk       <= 6'd0;
    counter_int_global      <= 6'd0;  
    nw_imodk_out            <= 1'b0;
    counter4                <= 2'd0;
    //last_out                <= 1'b0;
  end else begin
    if(enable_in) begin
      if(counter_int_global == (global_cap - 1'b1)) begin
        counter_int_i       <= 6'd0;
        counter_int_imodk   <= 6'd0;
        counter_int_global  <= 6'd0;  
        counter4            <= 2'd0;
        //last_out            <= 1'b1; 
      end else begin
        counter_int_global  <= counter_int_global + 1'b1;
        counter4          <= counter4 + 1'b1;
        //last_out            <= 1'b0;
        if(counter_int_i == (mod_cap - 1'b1))begin
          counter_int_i     <= 6'd0;
          counter_int_imodk <= counter_int_imodk + 1'b1;
          nw_imodk_out      <= 1'b1;
        end else begin
          counter_int_i     <= counter_int_i + 1'b1;
          
          nw_imodk_out      <= 1'b0; 
        end
      end
    end else begin
      nw_imodk_out          <= 1'b0;
      //last_out              <= 1'b0;
    end
  end
end

always @ (*) begin
  //nw_imodk_out        = 1'b0;
  last_out            = 1'b0;
  fst_a_cpy_out       = 1'b0;
  mod256_4_flag       = 1'b0;

  if(counter_int_global == (global_cap - 1'b1)) begin
    last_out  = 1'b1;
  end else begin
    last_out  = 1'b0;
  end

  if(counter_int_global == (mod_cap - 1'b1)) begin
    fst_a_cpy_out         = 1'b1;
  end else begin
    fst_a_cpy_out         = 1'b0;
  end

  if(conf_in == 2'd2 && counter4 == 2'd0 && nw_imodk_out == 1'b0 && counter_int_global > 6'd8) begin
    mod256_4_flag       = 1'b1;
  end

end

endmodule
