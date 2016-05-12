//----------------------------------------------------------------------------
// user_logic.v - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.v
// Version:           1.00.a
// Description:       User logic module.
// Date:              Mon Apr 25 11:29:19 2016 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  dbg_data,                       // Debug port for ChipScope
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Resetn,                  // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error,                   // IP to Bus error response
  ip2bus_mstrd_req,               // IP to Bus master read request
  ip2bus_mstwr_req,               // IP to Bus master write request
  ip2bus_mst_addr,                // IP to Bus master read/write address
  ip2bus_mst_be,                  // IP to Bus byte enable
  ip2bus_mst_length,              // Ip to Bus master transfer length
  ip2bus_mst_type,                // Ip to Bus burst assertion control
  ip2bus_mst_lock,                // Ip to Bus bus lock
  ip2bus_mst_reset,               // Ip to Bus master reset
  bus2ip_mst_cmdack,              // Bus to Ip master command ack
  bus2ip_mst_cmplt,               // Bus to Ip master trans complete
  bus2ip_mst_error,               // Bus to Ip master error
  bus2ip_mst_rearbitrate,         // Bus to Ip master re-arbitrate for bus ownership
  bus2ip_mst_cmd_timeout,         // Bus to Ip master command time out
  bus2ip_mstrd_d,                 // Bus to Ip master read data
  bus2ip_mstrd_rem,               // Bus to Ip master read data rem
  bus2ip_mstrd_sof_n,             // Bus to Ip master read start of frame
  bus2ip_mstrd_eof_n,             // Bus to Ip master read end of frame
  bus2ip_mstrd_src_rdy_n,         // Bus to Ip master read source ready
  bus2ip_mstrd_src_dsc_n,         // Bus to Ip master read source dsc
  ip2bus_mstrd_dst_rdy_n,         // Ip to Bus master read dest. ready
  ip2bus_mstrd_dst_dsc_n,         // Ip to Bus master read dest. dsc
  ip2bus_mstwr_d,                 // Ip to Bus master write data
  ip2bus_mstwr_rem,               // Ip to Bus master write data rem
  ip2bus_mstwr_src_rdy_n,         // Ip to Bus master write source ready
  ip2bus_mstwr_src_dsc_n,         // Ip to Bus master write source dsc
  ip2bus_mstwr_sof_n,             // Ip to Bus master write start of frame
  ip2bus_mstwr_eof_n,             // Ip to Bus master write end of frame
  bus2ip_mstwr_dst_rdy_n,         // Bus to Ip master write dest. ready
  bus2ip_mstwr_dst_dsc_n          // Bus to Ip master write dest. ready
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here
parameter C_MST_BURST_LEN                = 8; // burst transfer length in words
parameter SMALL_C_MST_BURST_LEN          = 2;
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_MST_NATIVE_DATA_WIDTH        = 32;
parameter C_LENGTH_WIDTH                 = 12;
parameter C_MST_AWIDTH                   = 32;
parameter C_NUM_REG                      = 8;
parameter C_SLV_DWIDTH                   = 32;
parameter C_BRAM_SIZE                    =1024;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
output     [31 : 0]                       dbg_data;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Resetn;
input      [C_SLV_DWIDTH-1 : 0]           Bus2IP_Data;
input      [C_SLV_DWIDTH/8-1 : 0]         Bus2IP_BE;
input      [C_NUM_REG-1 : 0]              Bus2IP_RdCE;
input      [C_NUM_REG-1 : 0]              Bus2IP_WrCE;
output     [C_SLV_DWIDTH-1 : 0]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
output                                    ip2bus_mstrd_req;
output                                    ip2bus_mstwr_req;
output     [C_MST_AWIDTH-1 : 0]           ip2bus_mst_addr;
output     [(C_MST_NATIVE_DATA_WIDTH/8)-1 : 0] ip2bus_mst_be;
output     [C_LENGTH_WIDTH-1 : 0]         ip2bus_mst_length;
output                                    ip2bus_mst_type;
output                                    ip2bus_mst_lock;
output                                    ip2bus_mst_reset;
input                                     bus2ip_mst_cmdack;
input                                     bus2ip_mst_cmplt;
input                                     bus2ip_mst_error;
input                                     bus2ip_mst_rearbitrate;
input                                     bus2ip_mst_cmd_timeout;
input      [C_MST_NATIVE_DATA_WIDTH-1 : 0] bus2ip_mstrd_d;
input      [(C_MST_NATIVE_DATA_WIDTH)/8-1 : 0] bus2ip_mstrd_rem;
input                                     bus2ip_mstrd_sof_n;
input                                     bus2ip_mstrd_eof_n;
input                                     bus2ip_mstrd_src_rdy_n;
input                                     bus2ip_mstrd_src_dsc_n;
output                                    ip2bus_mstrd_dst_rdy_n;
output                                    ip2bus_mstrd_dst_dsc_n;
output     [C_MST_NATIVE_DATA_WIDTH-1 : 0] ip2bus_mstwr_d;
output     [(C_MST_NATIVE_DATA_WIDTH)/8-1 : 0] ip2bus_mstwr_rem;
output                                    ip2bus_mstwr_src_rdy_n;
output                                    ip2bus_mstwr_src_dsc_n;
output                                    ip2bus_mstwr_sof_n;
output                                    ip2bus_mstwr_eof_n;
input                                     bus2ip_mstwr_dst_rdy_n;
input                                     bus2ip_mstwr_dst_dsc_n;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic
  localparam [2  : 0] S_IDLE = 3'b000, S_WAIT_READ = 3'b001, S_READ = 3'b010,
                      S_WAIT_WRITE = 3'b011, S_WRITE = 3'b100, S_CMPLTD = 3'b101;

  reg        [2  : 0]                       Q, Q_next;
  reg        [31 : 0]                       write_data_r;
  reg        [C_LENGTH_WIDTH-1 : 0]         buf_counter;
  reg        [C_MST_NATIVE_DATA_WIDTH-1:0]  buffer[0 : C_MST_BURST_LEN-1];
  reg        [C_LENGTH_WIDTH-1 : 0]         remaining_len;
  reg        [C_MST_AWIDTH-1 : 0]           addr_offset;

  // Nets for user logic slave model s/w accessible register example
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg0;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg1;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg2;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_reg3;
  wire       [3 : 0]                        slv_reg_write_sel;
  wire       [3 : 0]                        slv_reg_read_sel;
  reg        [C_SLV_DWIDTH-1 : 0]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;

  wire                                       Bus2IP_Clk;
  wire                                       Bus2IP_Resetn;
  wire      [C_SLV_DWIDTH-1 : 0]             Bus2IP_Data;
  wire      [C_SLV_DWIDTH/8-1 : 0]           Bus2IP_BE;
  wire      [C_NUM_REG-1 : 0]                Bus2IP_RdCE;
  wire      [C_NUM_REG-1 : 0]                Bus2IP_WrCE;
  wire      [C_SLV_DWIDTH-1 : 0]             IP2Bus_Data;
  wire                                       IP2Bus_RdAck;
  wire                                       IP2Bus_WrAck;
  wire                                       IP2Bus_Error;
  wire                                       ip2bus_mstrd_req;
  wire                                       ip2bus_mstwr_req;
  wire     [C_MST_AWIDTH-1 : 0]              ip2bus_mst_addr;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] ip2bus_mst_be;
  wire     [C_LENGTH_WIDTH-1 : 0]        ip2bus_mst_length;
  wire                                       ip2bus_mst_type;
  wire                                       ip2bus_mst_lock;
  wire                                       ip2bus_mst_reset;
  wire                                       bus2ip_mst_cmdack;
  wire                                       bus2ip_mst_cmplt;
  wire                                       bus2ip_mst_error;
  wire                                       bus2ip_mst_rearbitrate;
  wire                                       bus2ip_mst_cmd_timeout;
  wire     [C_MST_NATIVE_DATA_WIDTH-1 : 0]   bus2ip_mstrd_d;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] bus2ip_mstrd_rem; 
  wire                                       bus2ip_mstrd_sof_n;
  wire                                       bus2ip_mstrd_eof_n;
  wire                                       bus2ip_mstrd_src_rdy_n;
  wire                                       bus2ip_mstrd_src_dsc_n;
  wire                                       ip2bus_mstrd_dst_rdy_n;
  wire                                       ip2bus_mstrd_dst_dsc_n;
  wire     [C_MST_NATIVE_DATA_WIDTH-1 : 0]   ip2bus_mstwr_d;
  wire     [(C_MST_NATIVE_DATA_WIDTH/8)-1:0] ip2bus_mstwr_rem;
  wire                                       ip2bus_mstwr_src_rdy_n;
  wire                                       ip2bus_mstwr_src_dsc_n;
  wire                                       ip2bus_mstwr_sof_n;
  wire                                       ip2bus_mstwr_eof_n;
  wire                                       bus2ip_mstwr_dst_rdy_n;
  wire                                       bus2ip_mstwr_dst_dsc_n;

// signals for master model control/status registers write/read
  reg        [C_SLV_DWIDTH-1 : 0]            mst_ip2bus_data;
 wire                                       mst_write_ack;
 wire                                       mst_read_ack;

// signals for master model command interface state machine
 reg                                        mst_cmd_sm_rd_req;
 reg                                        mst_cmd_sm_wr_req;
 reg        [C_MST_AWIDTH-1 : 0]            mst_cmd_sm_ip2bus_addr;
 reg        [C_LENGTH_WIDTH-1 : 0]          mst_cmd_sm_xfer_length; /* in bytes */
 reg                                        mst_cmd_sm_mstwr_sof_n;
 reg                                        mst_cmd_sm_mstwr_eof_n;
 reg                                        mst_cmd_sm_mstwr_src_rdy_n;

 
 reg        [31:0]							buf0;
 reg        [31:0]							buf1;
 reg        [31:0]							buf2;
 reg        [31:0]							buf3;
 reg        [31:0]							buf4;
 reg        [31:0]							buf5;
 reg        [31:0]							buf6;
 reg        [31:0]							buf7; 
 
 
 
 wire       [C_SLV_DWIDTH-1 : 0]           stride_x_four;
 reg		[C_SLV_DWIDTH-1 : 0] 		   cnt; 
 
 reg       								   bram0_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram0_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram0_id;        
 wire      [C_SLV_DWIDTH-1 : 0]            bram0_od;    

 reg       								   bram1_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram1_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram1_id;        
 wire      [C_SLV_DWIDTH-1 : 0]            bram1_od;  

 reg       								   bram2_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram2_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram2_id;        
 wire      [C_SLV_DWIDTH-1 : 0]            bram2_od;  

 reg       								   bram3_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram3_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram3_id;        
 wire      [C_SLV_DWIDTH-1 : 0]            bram3_od;   
 
 reg       								   bram4_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram4_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram4_id;        
 wire      [C_SLV_DWIDTH-1 : 0]            bram4_od;  

 reg       								   bram5_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram5_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram5_id;        
 wire      [C_SLV_DWIDTH-1 : 0]            bram5_od;  

 reg       								   bram6_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram6_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram6_id;        
 wire       [C_SLV_DWIDTH-1 : 0]            bram6_od;  
 
 reg       								   bram7_write;
 reg        [C_SLV_DWIDTH-1 : 0]           bram7_addr;
 reg        [C_SLV_DWIDTH-1 : 0]           bram7_id;        
 wire       [C_SLV_DWIDTH-1 : 0]           bram7_od;  
 

 assign  stride_x_four=slv_reg2*4;
 
  // --USER logic implementation added here
  assign dbg_data = { buf_counter[9:0],buf0[10:0],mst_cmd_sm_mstwr_eof_n,
                      bus2ip_mst_cmplt, bus2ip_mst_cmdack, ip2bus_mst_type,
                      mst_cmd_sm_wr_req, mst_cmd_sm_rd_req, Q, slv_reg0[1:0] };
  // assign dbg_data = { buf_counter[4:0], bus2ip_mstwr_dst_rdy_n, mst_cmd_sm_mstwr_src_rdy_n,
                      // mst_cmd_sm_mstwr_eof_n, mst_cmd_sm_mstwr_sof_n, bus2ip_mstrd_src_rdy_n,
                      // addr_offset[8:2], mst_cmd_sm_xfer_length[7:2],
                      // bus2ip_mst_cmplt, bus2ip_mst_cmdack, ip2bus_mst_type,
                      // mst_cmd_sm_wr_req, mst_cmd_sm_rd_req, Q, slv_reg0[0] };
					  
  //localparam [2  : 0] S_IDLE = 3'b000, S_WAIT_READ = 3'b001, S_READ = 3'b010,
  //                    S_WAIT_WRITE = 3'b011, S_WRITE = 3'b100, S_CMPLTD = 3'b101;
  // user logic master command interface assignments
  assign ip2bus_mstrd_req  = mst_cmd_sm_rd_req; //AXI Master Burst Read Request. Active high read request initiation control signal 
  assign ip2bus_mstwr_req  = mst_cmd_sm_wr_req;
  assign ip2bus_mst_addr   = mst_cmd_sm_ip2bus_addr;
  assign ip2bus_mst_be     = 4'b1111;                // Always read/write four-byte at a time  可能需要依bpp做修改      bpp=1 , bpp=4
  assign ip2bus_mst_lock   = 0;                      // Do not lock the bus
  assign ip2bus_mst_reset  = 0;                      // Do not reset the bus
  assign ip2bus_mstwr_rem  = 0;                      // Length is always multiples of four
  assign ip2bus_mstwr_src_dsc_n = 1;
  assign ip2bus_mstwr_dst_dsc_n = 1;

  assign ip2bus_mst_type   = (mst_cmd_sm_xfer_length[C_LENGTH_WIDTH-1:2] == 1)? 0 : 1;
  assign ip2bus_mst_length = mst_cmd_sm_xfer_length;
  assign ip2bus_mstrd_dst_rdy_n = (Q == S_WAIT_READ || Q == S_READ)? 0 : 1;
  assign ip2bus_mstwr_d = write_data_r;
  assign ip2bus_mstwr_sof_n = mst_cmd_sm_mstwr_sof_n;
  assign ip2bus_mstwr_eof_n = mst_cmd_sm_mstwr_eof_n;
  assign ip2bus_mstwr_src_rdy_n = mst_cmd_sm_mstwr_src_rdy_n;
  
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram0(
    .clk(Bus2IP_Clk),
    .we(bram0_write),
    .addr({bram0_addr}),
    .data_i(bram0_id),
    .data_o(bram0_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram1(
    .clk(Bus2IP_Clk),
    .we(bram1_write),
    .addr({bram1_addr}),
    .data_i(bram1_id),
    .data_o(bram1_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram2(
    .clk(Bus2IP_Clk),
    .we(bram2_write),
    .addr({bram2_addr}),
    .data_i(bram2_id),
    .data_o(bram2_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram3(
    .clk(Bus2IP_Clk),
    .we(bram3_write),
    .addr({bram3_addr}),
    .data_i(bram3_id),
    .data_o(bram3_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram4(
    .clk(Bus2IP_Clk),
    .we(bram4_write),
    .addr({bram4_addr}),
    .data_i(bram4_id),
    .data_o(bram4_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram5(
    .clk(Bus2IP_Clk),
    .we(bram5_write),
    .addr({bram5_addr}),
    .data_i(bram5_id),
    .data_o(bram5_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram6(
    .clk(Bus2IP_Clk),
    .we(bram6_write),
    .addr({2'b00, bram6_addr}),
    .data_i(bram6_id),
    .data_o(bram6_od)
  );
  bram2p #(.DATA_WIDTH(C_SLV_DWIDTH), .RAM_SIZE(C_BRAM_SIZE))
  my_ram7(
    .clk(Bus2IP_Clk),
    .we(bram7_write),
    .addr({bram7_addr}),
    .data_i(bram7_id),
    .data_o(bram7_od)
  );
  always @(posedge Bus2IP_Clk) begin
	if (!Bus2IP_Resetn) cnt <= 0;
	else if(Q==S_CMPLTD && Q_next==S_WAIT_READ)cnt<=cnt+8;
	else if(Q==S_CMPLTD && Q_next==S_WAIT_WRITE)cnt<=cnt+2;
	else if(Q==S_CMPLTD && Q_next==S_IDLE)cnt<=0;
	else cnt<=cnt;
  end
  
  always @(*) begin
	if (!Bus2IP_Resetn)begin
		buf0=0;
		buf1=0;
		buf2=0;
		buf3=0;
		buf4=0;
		buf5=0;
		buf6=0;
		buf7=0;
	end
	else begin
		buf0=bram0_od;
		buf1=bram1_od;
		buf2=bram2_od;
		buf3=bram3_od;
		buf4=bram4_od;
		buf5=bram5_od;
		buf6=bram6_od;
		buf7=bram7_od;		
	end
  end
  
  
  //----------------------------------------------------------------------------
  // The main FSM of the memcpy logic
  //----------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk) begin
    if (!Bus2IP_Resetn) Q <= S_IDLE;
    else Q <= Q_next;
  end

  always @(*) begin
    case (Q)
    S_IDLE:
      if (slv_reg0 == 1) Q_next = S_WAIT_READ;
	  else if(slv_reg0 == 2)Q_next = S_WAIT_WRITE;
      else Q_next = S_IDLE;

    S_WAIT_READ:
      if (bus2ip_mst_cmdack) Q_next = S_READ;
      else Q_next = S_WAIT_READ;

    S_READ:
      if (bus2ip_mst_cmplt) Q_next = S_CMPLTD;  //AXI Master Burst Command Complete. Active high signal indicating the requested transaction has completed by the Read/Write Controller and the associated status bits are valid to sample.
      else Q_next = S_READ;

    S_WAIT_WRITE:
      if (bus2ip_mst_cmdack) Q_next = S_WRITE;
      else Q_next = S_WAIT_WRITE;

    S_WRITE:
      if (bus2ip_mst_cmplt) Q_next = S_CMPLTD;
      else Q_next = S_WRITE;

    S_CMPLTD:
      if (remaining_len > { C_MST_BURST_LEN, 2'b00 } && slv_reg0==1) Q_next = S_WAIT_READ;  // repeat the copy cycle
	  else if ((remaining_len > C_MST_BURST_LEN) && slv_reg0==2)Q_next = S_WAIT_WRITE;
      else Q_next = S_IDLE;

    default:
      Q_next = S_IDLE;
    endcase
  end

  //----------------------------------------------------------------------------
  // Address generator for the burst read/write operations
  //----------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn)
      mst_cmd_sm_ip2bus_addr <= 0;
    else if (Q == S_WAIT_READ)
      mst_cmd_sm_ip2bus_addr <= slv_reg1 + addr_offset;//resource=destination
    else
      mst_cmd_sm_ip2bus_addr <= slv_reg1 + addr_offset;
  end

  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn)
      addr_offset <= 0;
    else if (Q == S_IDLE)
      addr_offset <= 0;
    else if (Q == S_CMPLTD && Q_next == S_WAIT_READ) // copy next data
      addr_offset <= addr_offset + stride_x_four;
    else if (Q == S_CMPLTD && Q_next == S_WAIT_WRITE) // copy next data
      addr_offset <= addr_offset + slv_reg2;	  
    else
      addr_offset <= addr_offset;
  end

  //----------------------------------------------------------------------------
  // Determines the transfer length.
  //----------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
	if(slv_reg0==1)begin
	  if (remaining_len > { C_MST_BURST_LEN, 2'b00 } )
        mst_cmd_sm_xfer_length <= { C_MST_BURST_LEN, 2'b00 }; //mst_cmd_sm_xfer_length 和
      else
        mst_cmd_sm_xfer_length <= remaining_len;
	end
	else if(slv_reg0==2)begin
	  if (remaining_len > C_MST_BURST_LEN )
        mst_cmd_sm_xfer_length <= C_MST_BURST_LEN; //mst_cmd_sm_xfer_length 和
      else
        mst_cmd_sm_xfer_length <= remaining_len;	
	end
  end

  //----------------------------------------------------------------------------
  // Transfer size control - each transfer reduces the size by the burst length.
  //----------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
    if (Q == S_IDLE && Q_next ==S_WAIT_READ)
      remaining_len <= 12'd256; // copy transfer length (in bytes)  64*4
	else if (Q == S_IDLE && Q_next ==S_WAIT_WRITE)
	  remaining_len<=12'd64;
    else if (Q == S_CMPLTD && Q_next == S_WAIT_READ)
      remaining_len <= (remaining_len > { C_MST_BURST_LEN, 2'b00 })?
                        remaining_len - { C_MST_BURST_LEN, 2'b00 } : remaining_len;
    else if (Q == S_CMPLTD && Q_next == S_WAIT_WRITE)
      remaining_len <= (remaining_len > C_MST_BURST_LEN)?
                        remaining_len - C_MST_BURST_LEN: remaining_len;
    else
      remaining_len <= remaining_len;
  end

  //----------------------------------------------------------------------------
  // Buffer counter control:
  //   For burst transfer, we use a register array to temporary store the data
  //   transferred between the logic and the bus. A buffer counter must be
  //   maintained to point to the current buffer entry at each clock cycle.
  //----------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
  	if (!Bus2IP_Resetn)
      buf_counter <= 0;
    else
      case(Q)
      S_READ:
        if (!bus2ip_mstrd_src_rdy_n) buf_counter <= buf_counter + 1;
      S_WRITE:
        if (!bus2ip_mstwr_dst_rdy_n) buf_counter <= buf_counter + 1;
      default:
        buf_counter <= 0;
		endcase
  end

  // ===========================================================================
  //  Burst data-read begins.
  // ---------------------------------------------------------------------------
  //  Send read request - drop the request as soon as the bus is granted.
  // ---------------------------------------------------------------------------
  
  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn || bus2ip_mst_cmdack)
      mst_cmd_sm_rd_req <= 0; 
    else if (Q == S_WAIT_READ)
      mst_cmd_sm_rd_req <= 1;  //AXI Master Burst Read Request. Active high read request initiation control signal 
    else
      mst_cmd_sm_rd_req <= mst_cmd_sm_rd_req;
  end
  //4/29寫到這,下次寫如何讀資料
  // ---------------------------------------------------------------------------
  // Data read.
  // ---------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk )
  begin
    if (!bus2ip_mstrd_src_rdy_n)begin  //AXI Master Burst Read LocalLink Source Ready. Active low signal indicating that the data value asserted on the Bus2IP_MstRd_d output bus is valid and ready for transaction.
      bram0_write<=1;
	  bram0_addr<=buf_counter+cnt;
	  bram0_id<=bus2ip_mstrd_d;
	  
	  bram1_write<=1;
	  bram1_addr<=buf_counter+cnt;
	  bram1_id<=bus2ip_mstrd_d;
	  
      bram2_write<=1;
	  bram2_addr<=buf_counter+cnt;
	  bram2_id<=bus2ip_mstrd_d;
	  
      bram3_write<=1;
	  bram3_addr<=buf_counter+cnt;
	  bram3_id<=bus2ip_mstrd_d;
	  
      bram4_write<=1;
	  bram4_addr<=buf_counter+cnt;
	  bram4_id<=bus2ip_mstrd_d;

      bram5_write<=1;
	  bram5_addr<=buf_counter+cnt;
	  bram5_id<=bus2ip_mstrd_d;	  
	  
      bram6_write<=1;
	  bram6_addr<=buf_counter+cnt;
	  bram6_id<=bus2ip_mstrd_d;	  	

      bram7_write<=1;
	  bram7_addr<=buf_counter+cnt;
	  bram7_id<=bus2ip_mstrd_d;	 
	end  
	else if (Q==S_WAIT_WRITE || Q==S_WRITE) begin
	  bram0_write<=0;
	  bram1_write<=0;
	  bram2_write<=0;
	  bram3_write<=0;
	  bram4_write<=0;
	  bram5_write<=0;
	  bram6_write<=0;	
	  bram7_write<=0;
	  bram0_addr<=cnt;
	  bram1_addr<=cnt+1;
	end	
	else begin
	  bram0_write<=0;
	  bram1_write<=0;
	  bram2_write<=0;
	  bram3_write<=0;
	  bram4_write<=0;
	  bram5_write<=0;
	  bram6_write<=0;
	  bram7_write<=0;
	  bram0_addr<=bram0_addr;
	  bram1_addr<=bram1_addr;
	  bram2_addr<=bram2_addr;
	  bram3_addr<=bram3_addr;
	  bram4_addr<=bram4_addr;
	  bram5_addr<=bram5_addr;
	  bram6_addr<=bram6_addr;
	  bram7_addr<=bram7_addr;	
	end
	//還有(1)寫的和(2)其他 的情況 to be continued eg:bram_addr,cnt的關係
  end
  //  Burst data-read ends.
  // ===========================================================================

  // ===========================================================================
  //  Burst data-write begins.
  // ---------------------------------------------------------------------------
  //  Send write request - drop the request as soon as the bus is granted.
  // ---------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn || bus2ip_mst_cmdack)
      mst_cmd_sm_wr_req <= 0;
    else if (Q == S_WAIT_WRITE)
      mst_cmd_sm_wr_req <= 1;
    else
      mst_cmd_sm_wr_req <= mst_cmd_sm_wr_req;
  end

  // ---------------------------------------------------------------------------
  //  Signals the first data item, Start Of Frame (SOF), in a data burst.
  // ---------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn)
      mst_cmd_sm_mstwr_sof_n <= 1;
    else if (Q == S_WAIT_WRITE)
      mst_cmd_sm_mstwr_sof_n <= 0;    //AXI Master Burst Write LocalLink Start of Frame.Active low input signal indicating the starting data beat of a Write LocalLink packet transaction.
    else if (!bus2ip_mstwr_dst_rdy_n) //AXI Master Burst Write LocalLink Destination Ready. Active low output signal indicating that the AXI Master Burst is ready to accept a data transaction on the Write LocalLink.
      mst_cmd_sm_mstwr_sof_n <= 1;
    else
      mst_cmd_sm_mstwr_sof_n <= mst_cmd_sm_mstwr_sof_n;
  end

  // ---------------------------------------------------------------------------
  //  Signals the last data item, End Of Frame (EOF), in a data burst.
  //  EOF equals SOF for a nonburst, single-word transfer.
  // ---------------------------------------------------------------------------
  always @(*)
  begin
    if (ip2bus_mst_type)
      if (buf_counter == 1 && !bus2ip_mstwr_dst_rdy_n)
        mst_cmd_sm_mstwr_eof_n = 0;
      else
        mst_cmd_sm_mstwr_eof_n = 1;
    else
      mst_cmd_sm_mstwr_eof_n = mst_cmd_sm_mstwr_sof_n;
  end

  // ---------------------------------------------------------------------------
  // Signals that the source data for a write transaction is ready.
  // ---------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn)
      mst_cmd_sm_mstwr_src_rdy_n <= 1;
    else if (!mst_cmd_sm_mstwr_eof_n && !bus2ip_mstwr_dst_rdy_n)
      mst_cmd_sm_mstwr_src_rdy_n <= 1;
    else if (Q == S_WAIT_WRITE)
      mst_cmd_sm_mstwr_src_rdy_n <= 0;
    else
      mst_cmd_sm_mstwr_src_rdy_n <= mst_cmd_sm_mstwr_src_rdy_n;
  end

  // ---------------------------------------------------------------------------
  // Data write.
  // ---------------------------------------------------------------------------
  always @(posedge Bus2IP_Clk)
  begin
    if (!Bus2IP_Resetn)
      write_data_r <= 0;
    else  
    begin
      if (Q == S_WAIT_WRITE)
        write_data_r <= buf0;
      else if (!bus2ip_mstwr_dst_rdy_n)begin
		if(buf_counter==0)write_data_r<=buf1;
	  end
      else
        write_data_r <= write_data_r;
    end
  end
  //  Burst data-write ends.
  // ===========================================================================

  // ------------------------------------------------------
  // Example code to read/write user logic slave model s/w accessible registers
  // 
  // Note:
  // The example code presented here is to show you one way of reading/writing
  // software accessible registers implemented in the user logic slave model.
  // Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  // to one software accessible register by the top level template. For example,
  // if you have four 32 bit software accessible registers in the user logic,
  // you are basically operating on the following memory mapped registers:
  // 
  //    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  //                     "1000"   C_BASEADDR + 0x0
  //                     "0100"   C_BASEADDR + 0x4
  //                     "0010"   C_BASEADDR + 0x8
  //                     "0001"   C_BASEADDR + 0xC
  // 
  // ------------------------------------------------------

  assign
    slv_reg_write_sel = Bus2IP_WrCE[3:0],
    slv_reg_read_sel  = Bus2IP_RdCE[3:0],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3];

  // implement slave model register(s)
  always @( posedge Bus2IP_Clk )
    begin: SLAVE_REG_WRITE_PROC

      if ( Bus2IP_Resetn == 0 )
        begin
          slv_reg0 <= 0;
          slv_reg1 <= 0;
          slv_reg2 <= 0;
          slv_reg3 <= 0;
        end
	  else if (slv_reg0==1 && Q==S_CMPLTD && Q_next==S_IDLE)
		slv_reg0<=0;
	  else if (slv_reg0==2 && Q==S_CMPLTD && Q_next==S_IDLE)
	    slv_reg0<=0;
      else
        case ( slv_reg_write_sel )
          4'b1000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg0[bit_index] <= Bus2IP_Data[bit_index];
          4'b0100 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg1[bit_index] <= Bus2IP_Data[bit_index];
          4'b0010 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg2[bit_index] <= Bus2IP_Data[bit_index];
          4'b0001 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg3[bit_index] <= Bus2IP_Data[bit_index];
          default :
			begin
			  slv_reg0 <= (Q == S_CMPLTD && Q_next == S_IDLE)? 0 : slv_reg0;
			  slv_reg1 <= slv_reg1;
			  slv_reg2 <= slv_reg2;
			  slv_reg3 <= slv_reg3;
			end
        endcase

    end // SLAVE_REG_WRITE_PROC

  // implement slave model register read mux
  always @( slv_reg_read_sel or slv_reg0 or slv_reg1 or slv_reg2 or slv_reg3 )
    begin: SLAVE_REG_READ_PROC

      case ( slv_reg_read_sel )
        4'b1000 : slv_ip2bus_data <= slv_reg0;
        4'b0100 : slv_ip2bus_data <= slv_reg1;
        4'b0010 : slv_ip2bus_data <= slv_reg2;
        4'b0001 : slv_ip2bus_data <= slv_reg3;
        default : slv_ip2bus_data <= 0;
      endcase

    end // SLAVE_REG_READ_PROC

  // ------------------------------------------------------------
  // Example code to drive IP to Bus signals
  // ------------------------------------------------------------

  assign IP2Bus_Data = (slv_read_ack == 1'b1) ? slv_ip2bus_data : (mst_read_ack == 1'b1) ? mst_ip2bus_data :  0 ;

  assign IP2Bus_WrAck = slv_write_ack || mst_write_ack;
  assign IP2Bus_RdAck = slv_read_ack || mst_read_ack;
  assign IP2Bus_Error = 0;

endmodule
