`timescale 1ns / 1ps

module for_mod_tb(
    );

  parameter CLK_PERIOD = 10;
  reg clk;
  reg rst;
  reg enable;

initial begin
  clk   = 1'b0;
  rst   = 1'b1;
  enable  = 1'b0;
  #(10 * CLK_PERIOD);

  rst   = 1'b0;
  #(10 * CLK_PERIOD);
  wait(clk == 1'b1);
  wait(clk == 1'b0);
  wait(clk == 1'b1);
  #(1);
  enable  = 1'b1;
  #(10 * CLK_PERIOD);
end


  always begin
    #(CLK_PERIOD/2) clk =! clk;
  end

  


for_mod uut (
    .clk_in(clk), 
    .rst_in(rst), 

    .enable_in(enable), 
    .conf_in(2'd0), 

    .i_out(), 
    .imodk_out(), 

    .nw_imodk_out(), 
    .last_out(last_out)
    );



endmodule
