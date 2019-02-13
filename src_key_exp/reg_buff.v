`timescale 1ns / 1ps

module reg_buff(
  input clk_in,
  input rst_in,
  input enable_in,
  input [1:0] conf_in,
  input [31:0] buff_in, 
  output [31:0] buff_out
    );

//conf_out
//2'b00 => Nk = 4 &&  Nr = 10 // (Nb * (Nr + 1))) = (4 * (10+1)) = 44
//2'b01 => Nk = 6 &&  Nr = 12 // (Nb * (Nr + 1))) = (4 * (12+1)) = 52
//2'b10 => Nk = 8 &&  Nr = 14 // (Nb * (Nr + 1))) = (4 * (14+1)) = 60

reg [31:0] reg_0 , reg_1 ,reg_2 , reg_3, reg_4 ,reg_5 , reg_6 , reg_7;

always @ (posedge clk_in , posedge rst_in) begin
  if(rst_in) begin
    reg_0         <= 32'd0;
    reg_1         <= 32'd0;
    reg_2         <= 32'd0;
    reg_3         <= 32'd0;
    reg_4         <= 32'd0;
    reg_5         <= 32'd0;
    reg_6         <= 32'd0;
    reg_7         <= 32'd0; 
  end else begin
    if(enable_in) begin
      reg_0         <= buff_in;
      reg_1         <= reg_0;
      reg_2         <= reg_1;
      reg_3         <= reg_2;
      reg_4         <= reg_3;
      reg_5         <= reg_4;
      reg_6         <= reg_5;
      reg_7         <= reg_6; 
    end
  end
end

assign buff_out   = (conf_in == 2'd0) ? reg_3
                  : (conf_in == 2'd1) ? reg_5
                  : reg_7;


endmodule
