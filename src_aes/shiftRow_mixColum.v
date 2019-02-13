`timescale 1ns / 1ps

module shiftRow_mixColum(
    input clk,
    input rst,
    input save,

    input [7:0] din00,
    input [7:0] din01,
    input [7:0] din02,
    input [7:0] din03,

    input [7:0] din10,
    input [7:0] din11,
    input [7:0] din12,
    input [7:0] din13,

    input [7:0] din20,
    input [7:0] din21,
    input [7:0] din22,
    input [7:0] din23,

    input [7:0] din30,
    input [7:0] din31,
    input [7:0] din32,
    input [7:0] din33,

    output [7:0] dout00,
    output [7:0] dout01,
    output [7:0] dout02,
    output [7:0] dout03,

    output [7:0] dout10,
    output [7:0] dout11,
    output [7:0] dout12,
    output [7:0] dout13,

    output [7:0] dout20,
    output [7:0] dout21,
    output [7:0] dout22,
    output [7:0] dout23,

    output [7:0] dout30,
    output [7:0] dout31,
    output [7:0] dout32,
    output [7:0] dout33,

    output [7:0] doutend00,
    output [7:0] doutend01,
    output [7:0] doutend02,
    output [7:0] doutend03,

    output [7:0] doutend10,
    output [7:0] doutend11,
    output [7:0] doutend12,
    output [7:0] doutend13,

    output [7:0] doutend20,
    output [7:0] doutend21,
    output [7:0] doutend22,
    output [7:0] doutend23,

    output [7:0] doutend30,
    output [7:0] doutend31,
    output [7:0] doutend32,
    output [7:0] doutend33

    );


  wire [7:0] d00 , d01, d02 , d03;
  wire [7:0] d10 , d11, d12 , d13;
  wire [7:0] d20 , d21, d22 , d23;
  wire [7:0] d30 , d31, d32 , d33;

  reg [7:0] d00_reg , d01_reg, d02_reg , d03_reg;
  reg [7:0] d10_reg , d11_reg, d12_reg , d13_reg;
  reg [7:0] d20_reg , d21_reg, d22_reg , d23_reg;
  reg [7:0] d30_reg , d31_reg, d32_reg , d33_reg;

  reg [2:0] saved_reg;
  always @ (posedge clk , posedge rst) begin
    if(rst == 1'b1) begin
      d00_reg     <= 8'd0;
      d01_reg     <= 8'd0;
      d02_reg     <= 8'd0;
      d03_reg     <= 8'd0;

      d10_reg     <= 8'd0;
      d11_reg     <= 8'd0;
      d12_reg     <= 8'd0;
      d13_reg     <= 8'd0;

      d20_reg     <= 8'd0;
      d21_reg     <= 8'd0;
      d22_reg     <= 8'd0;
      d23_reg     <= 8'd0;

      d30_reg     <= 8'd0;
      d31_reg     <= 8'd0;
      d32_reg     <= 8'd0;
      d33_reg     <= 8'd0;
    end else begin
      if(save) begin
        saved_reg   <= 3'b001;

        d00_reg     <= d00;
        d01_reg     <= d01;
        d02_reg     <= d02;
        d03_reg     <= d03;

        d10_reg     <= d10;
        d11_reg     <= d11;
        d12_reg     <= d12;
        d13_reg     <= d13;

        d20_reg     <= d20;
        d21_reg     <= d21;
        d22_reg     <= d22;
        d23_reg     <= d23;

        d30_reg     <= d30;
        d31_reg     <= d31;
        d32_reg     <= d32;
        d33_reg     <= d33; 
      end else begin
        saved_reg   <= {saved_reg[1:0] , 1'b0};
      end
    end
  end 


  assign d00 = din00;
  assign d01 = din11;
  assign d02 = din22;
  assign d03 = din33;

  assign d10 = din10;
  assign d11 = din21;
  assign d12 = din32;
  assign d13 = din03;

  assign d20 = din20;
  assign d21 = din31;
  assign d22 = din02;
  assign d23 = din13;

  assign d30 = din30;
  assign d31 = din01;
  assign d32 = din12;
  assign d33 = din23;

  assign doutend00 = (saved_reg == 3'd0) ? d00 : d00_reg;
  assign doutend01 = (saved_reg == 3'd0) ? d01 : d01_reg;
  assign doutend02 = (saved_reg == 3'd0) ? d02 : d02_reg;
  assign doutend03 = (saved_reg == 3'd0) ? d03 : d03_reg;

  assign doutend10 = (saved_reg == 3'd0) ? d10 : d10_reg;
  assign doutend11 = (saved_reg == 3'd0) ? d11 : d11_reg;
  assign doutend12 = (saved_reg == 3'd0) ? d12 : d12_reg;
  assign doutend13 = (saved_reg == 3'd0) ? d13 : d13_reg;

  assign doutend20 = (saved_reg == 3'd0) ? d20 : d20_reg;
  assign doutend21 = (saved_reg == 3'd0) ? d21 : d21_reg;
  assign doutend22 = (saved_reg == 3'd0) ? d22 : d22_reg;
  assign doutend23 = (saved_reg == 3'd0) ? d23 : d23_reg;

  assign doutend30 = (saved_reg == 3'd0) ? d30 : d30_reg;
  assign doutend31 = (saved_reg == 3'd0) ? d31 : d31_reg;
  assign doutend32 = (saved_reg == 3'd0) ? d32 : d32_reg;
  assign doutend33 = (saved_reg == 3'd0) ? d33 : d33_reg;



// [0][x] ----------------------
  wire [7:0]  Tmp0, Tm00 , Tm01 , Tm02 , Tm03; 
  wire [7:0] Tm00p , Tm01p , Tm02p , Tm03p;

  assign Tmp0 = d00 ^ d01 ^ d02 ^ d03;

  // [0][0]--
  assign Tm00 = d00 ^ d01;
  assign Tm00p = (Tm00[7] == 1'b1) ?  {Tm00[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm00[6:0] , 1'b0};
  assign dout00 = d00 ^ Tm00p ^ Tmp0;

  // [0][1]--
  assign Tm01 = d01 ^ d02;
  assign Tm01p = (Tm01[7] == 1'b1) ?  {Tm01[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm01[6:0] , 1'b0};
  assign dout01 = d01 ^ Tm01p ^ Tmp0;

  // [0][2]--
  assign Tm02 = d02 ^ d03;
  assign Tm02p = (Tm02[7] == 1'b1) ?  {Tm02[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm02[6:0] , 1'b0};
  assign dout02 = d02 ^ Tm02p ^ Tmp0;

  // [0][3]--
  assign Tm03 = d03 ^ d00;
  assign Tm03p = (Tm03[7] == 1'b1) ?  {Tm03[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm03[6:0] , 1'b0};
  assign dout03 = d03 ^ Tm03p ^ Tmp0;

// [1][x] ----------------------
  wire [7:0]  Tmp1, Tm10 , Tm11 , Tm12 , Tm13; 
  wire [7:0] Tm10p , Tm11p , Tm12p , Tm13p;

  assign Tmp1 = d10 ^ d11 ^ d12 ^ d13;

  // [1][0]--
  assign Tm10 = d10 ^ d11;
  assign Tm10p = (Tm10[7] == 1'b1) ?  {Tm10[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm10[6:0] , 1'b0};
  assign dout10 = d10 ^ Tm10p ^ Tmp1;

  // [1][1]--
  assign Tm11 = d11 ^ d12;
  assign Tm11p = (Tm11[7] == 1'b1) ?  {Tm11[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm11[6:0] , 1'b0};
  assign dout11 = d11 ^ Tm11p ^ Tmp1;

  // [1][2]--
  assign Tm12 = d12 ^ d13;
  assign Tm12p = (Tm12[7] == 1'b1) ?  {Tm12[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm12[6:0] , 1'b0};
  assign dout12 = d12 ^ Tm12p ^ Tmp1;

  // [1][3]--
  assign Tm13 = d13 ^ d10;
  assign Tm13p = (Tm13[7] == 1'b1) ?  {Tm13[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm13[6:0] , 1'b0};
  assign dout13 = d13 ^ Tm13p ^ Tmp1;
// [2][x] ----------------------
  wire [7:0]  Tmp2, Tm20 , Tm21 , Tm22 , Tm23; 
  wire [7:0] Tm20p , Tm21p , Tm22p , Tm23p;

  assign Tmp2 = d20 ^ d21 ^ d22 ^ d23;

  // [2][0]--
  assign Tm20 = d20 ^ d21;
  assign Tm20p = (Tm20[7] == 1'b1) ?  {Tm20[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm20[6:0] , 1'b0};
  assign dout20 = d20 ^ Tm20p ^ Tmp2;

  // [2][1]--
  assign Tm21 = d21 ^ d22;
  assign Tm21p = (Tm21[7] == 1'b1) ?  {Tm21[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm21[6:0] , 1'b0};
  assign dout21 = d21 ^ Tm21p ^ Tmp2;

  // [2][2]--
  assign Tm22 = d22 ^ d23;
  assign Tm22p = (Tm22[7] == 1'b1) ?  {Tm22[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm22[6:0] , 1'b0};
  assign dout22 = d22 ^ Tm22p ^ Tmp2;

  // [2][3]--
  assign Tm23 = d23 ^ d20;
  assign Tm23p = (Tm23[7] == 1'b1) ?  {Tm23[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm23[6:0] , 1'b0};
  assign dout23 = d23 ^ Tm23p ^ Tmp2;

// [3][x] ----------------------
  wire [7:0]  Tmp3, Tm30 , Tm31 , Tm32 , Tm33; 
  wire [7:0] Tm30p , Tm31p , Tm32p , Tm33p;

  assign Tmp3 = d30 ^ d31 ^ d32 ^ d33;

  // [3][0]--
  assign Tm30 = d30 ^ d31;
  assign Tm30p = (Tm30[7] == 1'b1) ?  {Tm30[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm30[6:0] , 1'b0};
  assign dout30 = d30 ^ Tm30p ^ Tmp3;

  // [3][1]--
  assign Tm31 = d31 ^ d32;
  assign Tm31p = (Tm31[7] == 1'b1) ?  {Tm31[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm31[6:0] , 1'b0};
  assign dout31 = d31 ^ Tm31p ^ Tmp3;

  // [3][2]--
  assign Tm32 = d32 ^ d33;
  assign Tm32p = (Tm32[7] == 1'b1) ?  {Tm32[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm32[6:0] , 1'b0};
  assign dout32 = d32 ^ Tm32p ^ Tmp3;

  // [3][3]--
  assign Tm33 = d33 ^ d30;
  assign Tm33p = (Tm33[7] == 1'b1) ?  {Tm33[6:0] , 1'b0} ^ 8'h1b :
                                      {Tm33[6:0] , 1'b0};
  assign dout33 = d33 ^ Tm33p ^ Tmp3;


endmodule
