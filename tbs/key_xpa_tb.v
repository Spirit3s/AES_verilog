`timescale 1ns / 1ps

module key_xpa_tb(
    );

parameter CLK_PERIOD = 10;
parameter READFILE="key_in.tb";
parameter WRITEFILE="key_out.tb";
parameter DATAINFILE = "data_in.tb";


parameter NULL=0;

reg clk;
reg rst;
reg en;
reg start;
reg start_flag;
reg tb_clk;

integer file_write , file_read , file_datain;

reg [31:0] rd_buff, gld_buffer ,data_buff;
//$fscanf(file_read,"%h\n",input_data_temp);
//wire key_out;
wire [31:0] key_out;
wire [5:0] key_num_out;
wire key_valid_out;
wire key_last_out;

initial begin
  clk       = 1'b0;
  rst       = 1'b1;
  en        = 1'b0;
  start      = 1'b0;
  start_flag = 1'b0;
  tb_clk      = 1'b0;
  #(CLK_PERIOD * 10);
  rst       = 1'b0;
  #(CLK_PERIOD * 10);
  file_write = $fopen(WRITEFILE, "r");
    if (file_write == NULL) begin
      $display("Error:file %s not open",WRITEFILE);
    end else begin
      $display("file %s is open",WRITEFILE);
    end
  file_read = $fopen(READFILE, "r");
    if (file_read == NULL) begin
      $display("Error:file %s not open",READFILE);
    end else begin
      $display("file %s is open",READFILE);
    end
  file_datain = $fopen(DATAINFILE, "r");
    if (file_datain == NULL) begin
      $display("Error:file %s not open",DATAINFILE);
    end else begin
      $display("file %s is open",DATAINFILE);
    end
  en        = 1'b1;
  #(CLK_PERIOD * 10);
   wait(tb_clk == 1'b0);
   wait(tb_clk == 1'b1);
  //#(1);
  start      = 1'b1;
  start_flag = 1'b1;
  wait(tb_clk == 1'b0);
  wait(tb_clk == 1'b1);
  //#(1);
  start      = 1'b0;
end
  

  always @ (posedge tb_clk) begin
   // #(1);
    if(start_flag == 1'b1)begin
      if($feof(file_datain)==0) begin
        //$display("asdasd");
        $fscanf(file_datain,"%h\n",data_buff); 
      end
    end else begin
      //$display("file_read_closed");
    end
  end

  always @ (posedge tb_clk) begin
   // #(1);
    if(start_flag == 1'b1)begin
      if($feof(file_read)==0) begin
        //$display("asdasd");
        $fscanf(file_read,"%h\n",rd_buff); 
      end
    end else begin
      //$display("file_read_closed");
    end
  end

  always @ (negedge clk) begin
    if(key_valid_out == 1'b1)begin
      if($feof(file_write)==0) begin
        $fscanf(file_write,"%h\n",gld_buffer);  
        if(gld_buffer != key_out) begin
          $display("ERROR : %08x != %08x",gld_buffer,key_out);
        end else begin
          $display("ok");
        end
      end else begin
        //$display("file_write_closed");
      end
    end
  end


  always begin
    #(CLK_PERIOD/2);
    tb_clk =!tb_clk; 
    #(1);
    clk =! clk;
  end


  reg [31:0] key_in_reg , data_int_reg;
  reg start_reg;

  always @ (posedge clk , posedge rst) begin
    if(rst == 1'b1) begin
      key_in_reg    <= 32'd0;
      start_reg     <= 1'b0;
      data_int_reg  <= 32'd0;
    end else begin
      key_in_reg    <= rd_buff;
      start_reg     <= start;
      data_int_reg  <= data_buff;
    end
  end


key_xpa uut (
    .clk_in(clk), 
    .rst_in(rst), 
    .en_in(en), 

    .start_in(start_reg), 
    .conf_in(2'd0), 

    .key_in(key_in_reg),  

    .key_out(key_out), 
    .key_num_out(key_num_out), 
    .key_valid_out(key_valid_out), 
    .key_last_out(key_last_out)
    );



  wire [31:0] data_out_cypher;
  wire data_out_cypher_valid;

  cipher_eng uut_cypher (
    .clk_in(clk), 
    .rst_in(rst), 
    .en_in(en), 

    .start_in(start_reg), 

    .conf_in(2'd0), 

    .data_in(data_int_reg), 
    .key_in(key_out), 

    .data_out(data_out_cypher), 
    .dvalid_out(data_out_cypher_valid)
    );
  

endmodule
