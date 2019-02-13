`timescale 1ns / 1ps

module cipher_eng(
    input clk_in,
    input rst_in,
    input en_in,
    input start_in,
    input [1:0] conf_in,

   // input dvalid_in,
    input [31:0] data_in,
    input [31:0] key_in,

    output reg [31:0] data_out,
    output reg dvalid_out
    );


  reg [1:0] state , state_nxt; //TODO

  parameter INIT = 2'd0;
  parameter CYCLE_ST = 2'd1;
  parameter END_ST  = 2'd2;

//reg flag_mux_in_sRmC;

wire [7:0] din00_sRmC,din01_sRmC,din02_sRmC,din03_sRmC;
wire [7:0] din10_sRmC,din11_sRmC,din12_sRmC,din13_sRmC;
wire [7:0] din20_sRmC,din21_sRmC,din22_sRmC,din23_sRmC;
wire [7:0] din30_sRmC,din31_sRmC,din32_sRmC,din33_sRmC;

wire [7:0] dout00_sRmC,dout01_sRmC,dout02_sRmC,dout03_sRmC;
wire [7:0] dout10_sRmC,dout11_sRmC,dout12_sRmC,dout13_sRmC;
wire [7:0] dout20_sRmC,dout21_sRmC,dout22_sRmC,dout23_sRmC;
wire [7:0] dout30_sRmC,dout31_sRmC,dout32_sRmC,dout33_sRmC;


reg [31:0] data_gSbV_in;
wire [31:0] data_gSbV_out;



reg [31:0] buffer_in_mem1,buffer_in_mem1_nxt;
reg [31:0] buffer_in_mem2,buffer_in_mem2_nxt;
reg [31:0] buffer_in_mem3,buffer_in_mem3_nxt;

reg [31:0] buffer_out_mem0,buffer_out_mem0_nxt;
reg [31:0] buffer_out_mem1,buffer_out_mem1_nxt;
reg [31:0] buffer_out_mem2,buffer_out_mem2_nxt;

reg [5:0] counter , counter_nxt;
reg [1:0] counter_int, counter_int_nxt;

wire [5:0] cycle_size;

assign cycle_size = (conf_in == 2'd0) ?   6'd35:
                    (conf_in == 2'd1) ?   6'd43:
                                          6'd51;
                

wire [7:0] doutend00_sRmC;
wire [7:0] doutend01_sRmC;
wire [7:0] doutend02_sRmC;
wire [7:0] doutend03_sRmC;

wire [7:0] doutend10_sRmC;
wire [7:0] doutend11_sRmC;
wire [7:0] doutend12_sRmC;
wire [7:0] doutend13_sRmC;

wire [7:0] doutend20_sRmC;
wire [7:0] doutend21_sRmC;
wire [7:0] doutend22_sRmC;
wire [7:0] doutend23_sRmC;

wire [7:0] doutend30_sRmC;
wire [7:0] doutend31_sRmC;
wire [7:0] doutend32_sRmC;
wire [7:0] doutend33_sRmC;

//reg start_in_reg;

  always @ (posedge clk_in ,posedge rst_in) begin
    if(rst_in == 1'b1) begin
        buffer_in_mem1    <= 32'd0;
        buffer_in_mem2    <= 32'd0;
        buffer_in_mem3    <= 32'd0;

        buffer_out_mem0   <= 32'd0;
        buffer_out_mem1   <= 32'd0;
        buffer_out_mem2   <= 32'd0;

        state             <= INIT;
        counter           <= 6'd0;
        //start_in_reg      <= 1'b0;
        counter_int       <= 2'd0;
    end else begin
      if(en_in == 1'b1) begin
        buffer_in_mem1    <= buffer_in_mem1_nxt;
        buffer_in_mem2    <= buffer_in_mem2_nxt;
        buffer_in_mem3    <= buffer_in_mem3_nxt;

        buffer_out_mem0   <= buffer_out_mem0_nxt;
        buffer_out_mem1   <= buffer_out_mem1_nxt;
        buffer_out_mem2   <= buffer_out_mem2_nxt;

        state             <= state_nxt;
        counter           <= counter_nxt;
        counter_int       <= counter_int_nxt;
        //start_in_reg      <= start_in;
         //if(start_in_reg) begin
         //   counter_int       <= 2'd0;
         // end else begin
         //   counter_int       <= counter_int_nxt;
        // end
      end
    end
  end

  reg save;
 

  always @ (*) begin
    state_nxt     = state;
    counter_nxt   = counter;
    counter_int_nxt = counter_int + 1'b1;

    data_out        = 32'd0;
    dvalid_out      = 1'b0;
    save            = 1'b0;

    case(state)
      INIT : begin
        if(counter != 6'd0 || start_in) begin
          counter_nxt = counter + 1'b1;
          if(counter == 6'd3) begin
            counter_nxt   = 6'd0;
            state_nxt     = CYCLE_ST;
          end
        end else begin
           counter_int_nxt   = 2'd0;
        end
      end
      CYCLE_ST : begin
        counter_nxt = counter + 1'b1;
        if(counter == cycle_size) begin //THIS WILL BE CHANGED!!!!
          counter_nxt   = 6'd0;
          state_nxt     = END_ST;
        end  
      end
      END_ST : begin
        dvalid_out = 1'b1;
          case(counter_int)
            2'd0 : begin
              data_out = {doutend00_sRmC ^ key_in[31:24] ,doutend01_sRmC ^ key_in[23:16], doutend02_sRmC ^ key_in[15:8] , doutend03_sRmC ^ key_in[7:0] };
              save            = 1'b1;
            end
            2'd1: begin
              data_out = {doutend10_sRmC ^ key_in[31:24] ,doutend11_sRmC ^ key_in[23:16], doutend12_sRmC ^ key_in[15:8] , doutend13_sRmC ^ key_in[7:0] };
            end
            2'd2: begin
              data_out = {doutend20_sRmC ^ key_in[31:24] ,doutend21_sRmC ^ key_in[23:16], doutend22_sRmC ^ key_in[15:8] , doutend23_sRmC ^ key_in[7:0] };
            end
            2'd3: begin
              data_out = {doutend30_sRmC ^ key_in[31:24] ,doutend31_sRmC ^ key_in[23:16], doutend32_sRmC ^ key_in[15:8] , doutend33_sRmC ^ key_in[7:0] };
            end
          endcase


        counter_nxt = counter + 1'b1;
        if(counter == 6'd3) begin
          counter_nxt   = 6'd0;
          state_nxt     = INIT;
        end  
      end
    endcase
  end

  always @ (*) begin
    data_gSbV_in  = 32'd0;
    if(state == INIT) begin
        data_gSbV_in = data_in ^key_in;
    end else begin
      case(counter_int)
        2'd0 : begin
          data_gSbV_in ={key_in[31:24] ^ dout00_sRmC , key_in[23:16] ^ dout01_sRmC , key_in[15:8] ^ dout02_sRmC , key_in[7:0] ^ dout03_sRmC};
        end
        2'd1 : begin
          data_gSbV_in = key_in ^ buffer_in_mem1;
        end
        2'd2 : begin
          data_gSbV_in = key_in ^ buffer_in_mem2;
        end
        2'd3 : begin
          data_gSbV_in = key_in ^ buffer_in_mem3;
        end
      endcase
    end
  end

  always @ (*) begin
    buffer_in_mem1_nxt    <= buffer_in_mem1;
    buffer_in_mem2_nxt    <= buffer_in_mem2;
    buffer_in_mem3_nxt    <= buffer_in_mem3;
    buffer_out_mem0_nxt   <= buffer_out_mem0;
    buffer_out_mem1_nxt   <= buffer_out_mem1;
    buffer_out_mem2_nxt   <= buffer_out_mem2;
    case(counter_int)
      2'd0 : begin
        buffer_in_mem1_nxt    <= {dout10_sRmC , dout11_sRmC,dout12_sRmC,dout13_sRmC};
        buffer_in_mem2_nxt    <= {dout20_sRmC , dout21_sRmC,dout22_sRmC,dout23_sRmC};
        buffer_in_mem3_nxt    <= {dout30_sRmC , dout31_sRmC,dout32_sRmC,dout33_sRmC};
      end
      2'd1 : begin
        buffer_out_mem0_nxt   <= data_gSbV_out;
      end
      2'd2 : begin
        buffer_out_mem1_nxt   <= data_gSbV_out;
      end
      2'd3 : begin
        buffer_out_mem2_nxt   <= data_gSbV_out;
      end
    endcase
  end


  assign din00_sRmC = buffer_out_mem0[31:24];
  assign din01_sRmC = buffer_out_mem0[23:16];
  assign din02_sRmC = buffer_out_mem0[15:8];
  assign din03_sRmC = buffer_out_mem0[7:0];

  assign din10_sRmC = buffer_out_mem1[31:24];
  assign din11_sRmC = buffer_out_mem1[23:16];
  assign din12_sRmC = buffer_out_mem1[15:8];
  assign din13_sRmC = buffer_out_mem1[7:0];

  assign din20_sRmC = buffer_out_mem2[31:24];
  assign din21_sRmC = buffer_out_mem2[23:16];
  assign din22_sRmC = buffer_out_mem2[15:8];
  assign din23_sRmC = buffer_out_mem2[7:0];

  assign din30_sRmC = data_gSbV_out[31:24];
  assign din31_sRmC = data_gSbV_out[23:16];
  assign din32_sRmC = data_gSbV_out[15:8];
  assign din33_sRmC = data_gSbV_out[7:0];


getSBoxValue_cipher gSbV_mod (
    .clk_in(clk_in), 
    .enable_in(en_in), 
    .data_in(data_gSbV_in), 
    .data_out(data_gSbV_out)
    );



shiftRow_mixColum shiftRow_mixColum_mod (

    .clk(clk_in),
    .rst(rst_in),
    .save(save),

    .din00(din00_sRmC), 
    .din01(din01_sRmC), 
    .din02(din02_sRmC), 
    .din03(din03_sRmC), 

    .din10(din10_sRmC), 
    .din11(din11_sRmC), 
    .din12(din12_sRmC), 
    .din13(din13_sRmC), 

    .din20(din20_sRmC), 
    .din21(din21_sRmC), 
    .din22(din22_sRmC), 
    .din23(din23_sRmC), 

    .din30(din30_sRmC), 
    .din31(din31_sRmC), 
    .din32(din32_sRmC), 
    .din33(din33_sRmC), 

    .dout00(dout00_sRmC), 
    .dout01(dout01_sRmC), 
    .dout02(dout02_sRmC), 
    .dout03(dout03_sRmC),

    .dout10(dout10_sRmC), 
    .dout11(dout11_sRmC), 
    .dout12(dout12_sRmC), 
    .dout13(dout13_sRmC),

    .dout20(dout20_sRmC), 
    .dout21(dout21_sRmC), 
    .dout22(dout22_sRmC), 
    .dout23(dout23_sRmC),

    .dout30(dout30_sRmC), 
    .dout31(dout31_sRmC), 
    .dout32(dout32_sRmC), 
    .dout33(dout33_sRmC),


    .doutend00(doutend00_sRmC),
    .doutend01(doutend01_sRmC),
    .doutend02(doutend02_sRmC),
    .doutend03(doutend03_sRmC),

    .doutend10(doutend10_sRmC),
    .doutend11(doutend11_sRmC),
    .doutend12(doutend12_sRmC),
    .doutend13(doutend13_sRmC),

    .doutend20(doutend20_sRmC),
    .doutend21(doutend21_sRmC),
    .doutend22(doutend22_sRmC),
    .doutend23(doutend23_sRmC),

    .doutend30(doutend30_sRmC),
    .doutend31(doutend31_sRmC),
    .doutend32(doutend32_sRmC),
    .doutend33(doutend33_sRmC)

    );



endmodule
