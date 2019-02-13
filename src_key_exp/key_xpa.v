`timescale 1ns / 1ps

module key_xpa(
  input clk_in,
  input rst_in,
  input en_in,
  input start_in,
  input [1:0] conf_in,
  input [31:0] key_in,

  output reg [31:0] key_out,
  output [5:0] key_num_out,
  output reg key_valid_out,
  output key_last_out

    );
  parameter IDLE        = 2'd0;
  parameter ST_START    = 2'd1;
  parameter ST_RUN      = 2'd2;

  reg [1:0] state , state_nxt;

  reg enable_master;
  
  wire [31:0] buff_dout;
  wire [7:0] rcon_vec_dout;
  wire [31:0] getSBoxValue_dout,getSBoxValue_dout256;
  wire [5:0] ctrl_i , ctrl_imodk;
  wire ctrl_frst_flag ,ctrl_nwimodk_flag , ctrl_last_flag, ctr_mod256;

  reg [31:0] conf_in_reg;


  wire [7:0] dout0_mod , dout1_mod , dout2_mod , dout3_mod;
  wire [7:0] dout0_mod256 , dout1_mod256 , dout2_mod256 , dout3_mod256;
  wire [7:0] dout0 , dout1 , dout2 , dout3;

   reg [5:0] ctrl_imodk_1_reg;

  assign  dout0_mod = buff_dout[31:24] ^ getSBoxValue_dout[31:24];
  assign  dout1_mod = buff_dout[23:16] ^ getSBoxValue_dout[23:16];
  assign  dout2_mod = buff_dout[15:8] ^ getSBoxValue_dout[15:8];
  assign  dout3_mod = buff_dout[7:0] ^ getSBoxValue_dout[7:0];

  assign  dout0_mod256 = buff_dout[31:24] ^ getSBoxValue_dout256[31:24];
  assign  dout1_mod256 = buff_dout[23:16] ^ getSBoxValue_dout256[23:16];
  assign  dout2_mod256 = buff_dout[15:8] ^ getSBoxValue_dout256[15:8];
  assign  dout3_mod256 = buff_dout[7:0] ^ getSBoxValue_dout256[7:0];

  assign  dout0 = buff_dout[31:24] ^ conf_in_reg[31:24];
  assign  dout1 = buff_dout[23:16] ^ conf_in_reg[23:16];
  assign  dout2 = buff_dout[15:8] ^ conf_in_reg[15:8];
  assign  dout3 = buff_dout[7:0] ^ conf_in_reg[7:0];



  always @ (posedge clk_in , posedge rst_in) begin
    if(rst_in) begin
      ctrl_imodk_1_reg    <= 6'd0;
    end else begin
      ctrl_imodk_1_reg    <= ctrl_imodk+1'b1;
   end
  end

  always @ (posedge clk_in, posedge rst_in) begin
    if(rst_in == 1'b1) begin
      state         <= IDLE;
      conf_in_reg   <= 32'd0;
    end else begin
      state         <= state_nxt;
      conf_in_reg   <= key_out;
    end
  end 

  always @ (*) begin
    enable_master         = 1'b1;
    state_nxt             = state;
    key_out               = 32'd0;
    key_valid_out         = 1'b0;
    case(state)
      IDLE : begin
        enable_master     = 1'b0;
        if(en_in == 1'b1 && start_in == 1'b1) begin
          key_out         = key_in;
          key_valid_out   = 1'b1;
          enable_master     = 1'b1;
          state_nxt       = ST_START;
        end
      end

      ST_START : begin
        key_out           = key_in;
        key_valid_out     = 1'b1;
        if(ctrl_frst_flag) begin
          state_nxt       = ST_RUN;
        end
      end

      ST_RUN : begin
        key_valid_out     = 1'b1;
        if(ctrl_nwimodk_flag) begin
          key_out         = {dout0_mod , dout1_mod , dout2_mod , dout3_mod};
        end else if(ctr_mod256 == 1'b1) begin
          key_out         = {dout0_mod256 , dout1_mod256 , dout2_mod256 , dout3_mod256};
        end else begin
           key_out        = {dout0 , dout1 , dout2 , dout3};
        end
        if(ctrl_last_flag) begin
          state_nxt       = IDLE;
        end
      end
    endcase

  end

  assign  key_num_out = ctrl_i;
  assign  key_last_out  = ctrl_last_flag;

for_mod ctrl_mod (
    .clk_in(clk_in), 
    .rst_in(rst_in), 
    .enable_in(enable_master), 
    .conf_in(conf_in), 

    .i_out(ctrl_i), 
    .imodk_out(ctrl_imodk), 

    .mod256_4_flag(ctr_mod256),

    .fst_a_cpy_out(ctrl_frst_flag), 
    .nw_imodk_out(ctrl_nwimodk_flag), 
    .last_out(ctrl_last_flag)
    );

getSBoxValue getSBoxValue_mod (
    .clk_in(clk_in), 
   // .rst_in(rst_in), 
    .enable_in(enable_master), 
    .conf_in(conf_in), 
    .data_in(key_out), 
    .recon_in(rcon_vec_dout),
    .data_out256(getSBoxValue_dout256),
    .data_out(getSBoxValue_dout)
    );



rcon rcon_vec (
    .clk_in(clk_in), 
    //.rst_in(rst_in), 
    .addr_in(ctrl_imodk+1'b1), 
    .rcon_out(rcon_vec_dout)
    );


reg_buff buff_mod (
    .clk_in(clk_in), 
    .rst_in(rst_in), 
    .enable_in(enable_master), 
    .conf_in(conf_in), 
    .buff_in(key_out), 
    .buff_out(buff_dout)
    );
endmodule
