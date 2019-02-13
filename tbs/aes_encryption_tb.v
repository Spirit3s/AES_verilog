`timescale 1ns / 1ps

module aes_encryption_tb(
    );


parameter CLK_PERIOD  = 10;
parameter FILE_ENC    ="data_enc.init";
parameter FILE_DEC    ="data_dec.init";
parameter FILE_KEY    ="data_key.init";
parameter FILE_KEY_GOLDEN    ="data_big_key.init";


parameter CONF = 2'd1;
parameter NULL=0;
integer block;
integer line;


reg clk ;
reg rst;
reg en;
reg tb_start;

//------------------------------------------------------
//--------KEY PROCESS ----------------------------------
//------------------------------------------------------
  integer key_fp , key_golden;

 reg start_in_reg, start_reg;
  reg [31:0] key_in_reg,key_reg;
  wire [31:0] key_out_wire; 
  wire [5:0] key_num_out_wire;
  wire key_valid_out_wire;
  wire key_last_out_wire;
  reg key_start_flag;
  reg [31:0] key_gold_buffer;
  integer key_counter;

//------------------------------------------------------
//-------DATA PROCESS ----------------------------------
//------------------------------------------------------
  integer dec_fp;
  integer enc_fp;
  wire[2:0] dataB_size;

  wire [31:0] data_out_wire;
wire data_dvalid_out;
reg [31:0] data_in_reg, data_reg;

  reg [2:0] counter_datain;
  reg [31:0] gold_buffer;



  assign dataB_size =   (CONF == 2'd0) ?  3'd3:
                        (CONF == 2'd1) ?  3'd3:
                                          3'd3;                  
//------------------------------------------------------

initial begin
  clk     = 1'b0;
  rst     = 1'b1;
  en      = 1'b0;
  tb_start= 1'b0;
  key_counter = 0;
  block   = 0;
  line  = 0;
  key_start_flag  <= 1'b1;

  //-----------------
  //---INIT FILES 
  //-----------------
  key_fp = $fopen(FILE_KEY, "r");
  if (key_fp == NULL) begin
    $display("Error:file %s not open",FILE_KEY);
  end else begin
    $display("file %s is open",FILE_KEY);
  end
  dec_fp = $fopen(FILE_DEC, "r");
  if (dec_fp == NULL) begin
    $display("Error:file %s not open",FILE_DEC);
  end else begin
    $display("file %s is open",FILE_DEC);
  end
  enc_fp = $fopen(FILE_ENC, "r");
  if (key_fp == NULL) begin
    $display("Error:file %s not open",FILE_ENC);
  end else begin
    $display("file %s is open",FILE_ENC);
  end


  key_golden = $fopen(FILE_KEY_GOLDEN, "r");
  if (key_golden == NULL) begin
    $display("Error:file %s not open",FILE_KEY_GOLDEN);
  end else begin
    $display("file %s is open",FILE_KEY_GOLDEN);
  end

  #(CLK_PERIOD * 10);
  rst     = 1'b0;
  #(CLK_PERIOD * 10);
  en      = 1'b1;
  #(CLK_PERIOD * 10);
  tb_start= 1'b1;

  #(2);
  $fscanf(dec_fp,"%h\n",data_reg); 
  counter_datain    <= 3'd0;

end

  
  
  always begin
    #(CLK_PERIOD/2)clk =!clk; 
  end
 

//------------------------------------------------------
//--------DATA PROCESS ---------------------------------
//------------------------------------------------------

  always @ (negedge clk , posedge rst) begin
    if(rst) begin
      counter_datain    <= 3'b111;
      data_reg          <= 32'd0;
    end else begin
      #(1);
      if(key_last_out_wire) begin
        counter_datain    <= 3'd0;
        if($feof(dec_fp)==0)begin
            $fscanf(dec_fp,"%h\n",data_reg);  
          end
      end else begin
        if(counter_datain < dataB_size) begin
          counter_datain  <= counter_datain + 1'b1;
          if($feof(dec_fp)==0)begin
            $fscanf(dec_fp,"%h\n",data_reg);  
          end
        end
      end
    end
  end


  always @ (posedge clk, posedge rst) begin
    if(rst) begin
      data_in_reg       <= 32'd0;
    end else begin
      data_in_reg       <= data_reg;
    end
  end


//------------------------------------------------------
//--------KEY PROCESS ----------------------------------
//------------------------------------------------------
  always @ (negedge clk , posedge rst) begin
    if(rst) begin
      key_reg     <= 32'd0;
      start_reg   <= 1'b0;
    end else begin 
      if(key_last_out_wire == 1'b1) begin
        $fclose(key_fp);
        $display("Block -> %d",block);
        block = block + 1;
         key_start_flag  <= 1'b1;
        key_fp = $fopen(FILE_KEY, "r");
        if (key_fp == NULL) begin
          $display("Error:file %s not open",FILE_KEY);
        end else begin
          //$display("file %s is open",FILE_KEY);
        end
      end else begin
         //key_start_flag  <= 1'b0;
      end

      if(tb_start && ($feof(key_fp)==0)) begin
        $fscanf(key_fp,"%h\n",key_reg);  
        start_reg = 1'b1;
      end else begin
        start_reg = 1'b0;
      end
    end
  end


  always @ (negedge clk , posedge rst) begin
    if(key_valid_out_wire && ($feof(key_golden)==0)) begin
       $fscanf(key_golden,"%h\n",key_gold_buffer);  
       key_counter = key_counter + 1;
       if(key_gold_buffer != key_out_wire) begin
        $display("error_key %d",key_counter);
       end else begin
        $display("key_ok,%d",key_counter);
       end
    end 
  end


  always @ (posedge clk, posedge rst) begin
    if(rst) begin
      start_in_reg      <= 1'b0;
      key_in_reg        <= 32'd0;
    end else begin
      start_in_reg      <= start_reg && key_start_flag;
      key_in_reg        <= key_reg ;
      if(start_reg && key_start_flag) begin
        key_start_flag  <= 1'b0;
      end
    end
  end

  always @ (negedge clk)begin
    if(data_dvalid_out) begin
    line = line + 1'b1;
      $fscanf(enc_fp,"%h\n",gold_buffer);  
      $display("line                        = %d",line);
      if(gold_buffer != data_out_wire) begin
        $display("#--------------------------");
        $display("#TEST COMPLETED : FAILLED");
        $display("#--------------------------");
        #(10);
        $stop;
      end

      if(!$feof(enc_fp)==0) begin
        $display("#--------------------------");
        $display("#TEST COMPLETED : No Errors");
        $display("#--------------------------");
        $stop;
      end
    end
  end

//------------------------------------------------------
//------------------------------------------------------

key_xpa key_uut (
    .clk_in(clk), 
    .rst_in(rst), 
    .en_in(en), 
    .start_in(start_in_reg), 
    .conf_in(CONF), 
    .key_in(key_in_reg), 
    .key_out(key_out_wire), 
    .key_num_out(key_num_out_wire), 
    .key_valid_out(key_valid_out_wire), 
    .key_last_out(key_last_out_wire)
    );



cipher_eng cipher_uut (
    .clk_in(clk), 
    .rst_in(rst), 
    .en_in(en), 
    .start_in(start_in_reg), 
    .conf_in(CONF), 
    .data_in(data_in_reg), 
    .key_in(key_out_wire), 
    .data_out(data_out_wire), 
    .dvalid_out(data_dvalid_out)
    );


endmodule
