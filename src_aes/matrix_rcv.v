`timescale 1ns / 1ps

module matrix_rcv(
    input clk_in,
    input rst_in,
    input en_in,
    input [31:0] key_in,

    output en_out,
    output [31:0] key0_out,
    output [31:0] key1_out,
    output [31:0] key2_out,
    output [31:0] key3_out
    );
  reg [31:0] matrix00 ; 
  reg [31:0] matrix10 ; 
  reg [31:0] matrix20; 
  reg [31:0] matrix30; 

  reg [31:0] matrix00_nxt; 
  reg [31:0] matrix10_nxt; 
  reg [31:0] matrix20_nxt; 
  reg [31:0] matrix30_nxt;
  reg [1:0] counter, counter_nxt;

  assign key0_out = matrix00;
  assign key1_out = matrix10;
  assign key2_out = matrix20;
  assign key3_out = matrix30;

  assign en_out = (counter == 2'd0 && en_in == 1'b1) ? 1'b1 : 1'b0;

  always @ (posedge clk_in , posedge rst_in) begin
    if(rst_in == 1'b1) begin
      matrix00    <= 32'd0;
      matrix10    <= 32'd0;
      matrix20    <= 32'd0;
      matrix30    <= 32'd0;
    end else begin
      if(en_in) begin
        matrix00    <= matrix00_nxt;
        matrix10    <= matrix10_nxt;
        matrix20    <= matrix20_nxt;
        matrix30    <= matrix30_nxt;
        counter     <= counter_nxt;
      end
    end
  end

  always @ (*) begin
    matrix00_nxt    = matrix00;
    matrix10_nxt    = matrix10;
    matrix20_nxt    = matrix20;
    matrix30_nxt    = matrix30;
    //counter_nxt     = counter;
    //if(en_in == 1'b1) begin
    counter_nxt   = counter + 1'b1;
    case(counter)
      2'd0 : begin
        matrix00_nxt    = key_in;
      end
      2'd1 : begin
        matrix10_nxt    = key_in;
      end
      2'd2 : begin
        matrix20_nxt    = key_in;
      end
      3'd3 : begin
        matrix30_nxt    = key_in;
      end
    endcase
  end

endmodule
