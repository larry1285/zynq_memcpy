//----------------------------------------------------------------------------
// bfm_system_tb.v - module
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
// Filename:          bfm_system_tb.v
// Version:           1.00.a
// Description:       Testbench logic.
// Date:              Mon Apr 25 11:29:23 2016 (by Create and Import Peripheral Wizard)
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

`timescale 1 ns / 100 fs

//testbench defines
`define RESET_PERIOD 200
`define CLOCK_PERIOD 10
`define INIT_DELAY   400

//user slave defines
`define SLAVE_BASE_ADDR  32'h30000000
`define SLAVE_REG_OFFSET 32'h00000000
`define SLAVE_SOFT_RESET 32'h0000000A

//User Master Defines
`define C_MST_DWIDTH  32
`define C_SLV_DWIDTH  32
`define MAX_MST_BURST_LENGTH 16

// Lock Type Defines
`define LOCK_TYPE_NORMAL    1'b0

// Burst Type Defines
`define BURST_TYPE_INCR  2'b01

//Response type defines
`define RESPONSE_OKAY   2'b00
//AMBA 4 defines
`define MAX_BURST_LENGTH 1
`define PROT_BUS_WIDTH   3
`define ADDR_BUS_WIDTH   32
`define RESP_BUS_WIDTH   2

//slave bfm defines
`define SLV_BFM_BASE_ADDR 32'h40000000

//master register address
`define MST_CNTL_REG     32'h00000100 
`define MST_ADDR_REG     32'h00000104
`define MST_BE_REG       32'h00000108
`define MST_LEN_REG      32'h0000010C
`define MST_GO_PORT      32'h0000010F

//master registers byte enable
`define MST_CNTL_REG_CMD_BE 4'b0001
`define MST_ADDR_REG_BE     4'b1111
`define MST_BE_REG_BE       4'b0011
`define MST_LEN_REG_BE      4'b0011
`define MST_GO_PORT_BE      4'b1000

//bit location in master control reg
`define DONE_BIT_LOC      8

//master commands
`define MST_CNTL_RDBRST 32'h00000009
`define MST_CNTL_WRBRST 32'h0000000A

// Burst Size Defines
`define BURST_SIZE_1_BYTE    3'b000
`define BURST_SIZE_2_BYTES   3'b001
`define BURST_SIZE_4_BYTES   3'b010
`define BURST_SIZE_8_BYTES   3'b011
`define BURST_SIZE_16_BYTES  3'b100
`define BURST_SIZE_32_BYTES  3'b101
`define BURST_SIZE_64_BYTES  3'b110
`define BURST_SIZE_128_BYTES 3'b111

module bfm_system_tb
(
); // bfm_system_tb

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // -- Testbench nets declartions added here, as needed for testbench logic

  reg                                       rst_n;
  reg                                       sys_clk;
  integer                                   number_of_bytes;
  integer                                   number_of_mst_bytes;
  integer                                   i;
  integer                                   j;
  reg                                       done;
  integer                                   mtestID            ;
  integer                                   mtestBurstLength   ;
  integer                                   mtestLockType      ;
  integer                                   mtestBurstSize     ;
  integer                                   mtestCacheType     ;
  integer                                   mtestdatasize      ;
  integer                                   mtestRegion        ;
  integer                                   mtestQOS           ;
  integer                                   mtestBUSER         ;
  integer                                   mtestAWUSER        ;
  integer                                   mtestARUSER        ;
  integer                                   mtestProtectionType;
  reg        [`C_SLV_DWIDTH-1 : 0]          test_data;
  reg        [(`MAX_MST_BURST_LENGTH)*(`C_MST_DWIDTH-1) : 0] test_burst_data;
  reg        [(`MAX_MST_BURST_LENGTH)*(`C_MST_DWIDTH-1) : 0] rd_burst_data;
  reg        [`ADDR_BUS_WIDTH-1 : 0]        mtestAddr;
  reg        [`PROT_BUS_WIDTH-1 : 0]        mtestProtection;
  reg        [`C_SLV_DWIDTH-1 : 0]          rd_data;
  reg        [`RESP_BUS_WIDTH-1 : 0]        response;
  reg        [`MAX_MST_BURST_LENGTH-1 : 0]  v_ruser;
  reg        [`MAX_MST_BURST_LENGTH-1 : 0]  v_wuser;
  reg        [(`RESP_BUS_WIDTH*(`MAX_MST_BURST_LENGTH))-1 : 0] vresponse;
  //----------------------------------------------------------------------------
  // Instantiate bfm_system
  //----------------------------------------------------------------------------

  bfm_system
    dut(.sys_reset(rst_n),.sys_clk(sys_clk));

  //----------------------------------------------------------------------------
  // Reset block
  //----------------------------------------------------------------------------

  initial begin
         rst_n = 1'b0;
    #`RESET_PERIOD rst_n = 1'b1;
  end

  //----------------------------------------------------------------------------
  // Simple Clock Generator
  //----------------------------------------------------------------------------

  initial sys_clk = 1'b0;
  always #`CLOCK_PERIOD sys_clk = !sys_clk;

  //----------------------------------------------------------------------------
  // Simple testbench logic
  //----------------------------------------------------------------------------

  initial begin
    //Wait for end of reset
    wait(rst_n == 0) @(posedge sys_clk);
    wait(rst_n == 1) @(posedge sys_clk);
    #`INIT_DELAY mtestProtection = 0;
    $display("----------------------------------------------------");
    $display("Full Registers write followed by a full Registers read");
    $display("----------------------------------------------------");
    number_of_bytes = (`C_SLV_DWIDTH/8);
    for( i = 0 ; i <4; i = i+1) begin
      for(j = 0 ; j < number_of_bytes ; j = j+1)
        test_data[j*8 +: 8] = j+(i*number_of_bytes);
      mtestAddr = `SLAVE_BASE_ADDR + `SLAVE_REG_OFFSET + i*number_of_bytes;
      $display("Writing to Slave Register addr=0x%h",mtestAddr, " data=0x%h",test_data);
      SINGLE_WRITE(mtestAddr,test_data,mtestProtection,4'b1111, response);
    end
    for( i = 0 ; i <4; i = i+1) begin
      for(j=0 ; j < number_of_bytes ; j = j+1)
        test_data[j*8 +: 8] = j+(i*number_of_bytes);
      mtestAddr = `SLAVE_BASE_ADDR + `SLAVE_REG_OFFSET + i*number_of_bytes;
      SINGLE_READ(mtestAddr,rd_data,mtestProtection,response);
      $display("Reading from Slave Register addr=0x%h",mtestAddr, " data=0x%h",rd_data);
      COMPARE_DATA(test_data,rd_data);
    end
    case (`C_MST_DWIDTH)
      8  : mtestBurstSize = `BURST_SIZE_1_BYTE;
      16 : mtestBurstSize = `BURST_SIZE_2_BYTES;
      32 : mtestBurstSize = `BURST_SIZE_4_BYTES;
      64 : mtestBurstSize = `BURST_SIZE_8_BYTES;
      128 : mtestBurstSize = `BURST_SIZE_16_BYTES;
      256 : mtestBurstSize = `BURST_SIZE_32_BYTES;
      512 : mtestBurstSize = `BURST_SIZE_64_BYTES;
      1024 : mtestBurstSize = `BURST_SIZE_128_BYTES;
      default : begin
        $display("-----------------------------------------------------");
        $display("EXAMPLE TEST : FAILED -- Invalid C_SLV_DWIDTH");
        $display("-----------------------------------------------------");
      end
    endcase
    
    $display("---------------------------------------------------");
    $display("Master Verification");
    $display("---------------------------------------------------");
    number_of_mst_bytes = (`C_MST_DWIDTH/8);
    mtestBurstLength = `MAX_MST_BURST_LENGTH -1;
    mtestLockType = `LOCK_TYPE_NORMAL;
    mtestdatasize = number_of_mst_bytes * `MAX_MST_BURST_LENGTH ;
    mtestCacheType = 0;
    mtestProtectionType = 0;
    mtestRegion = 0;
    mtestQOS = 0;
    mtestAWUSER = 0;
    mtestARUSER = 0;
    v_wuser = 0;
    mtestID = 0;

    $display("Initializing first ",`MAX_MST_BURST_LENGTH," locations of AXI Slave BFM memory with value");
    for(i = 0 ; i < `MAX_MST_BURST_LENGTH*number_of_mst_bytes ; i = i+1) begin
        test_burst_data[i*8 +: 8] = i; 
    end

    mtestAddr = `SLV_BFM_BASE_ADDR;
    dut.bfm_burst_processor.bfm_burst_processor.cdn_axi4_master_bfm_inst.WRITE_BURST(mtestID,
        mtestAddr,
        mtestBurstLength,
        mtestBurstSize,
        `BURST_TYPE_INCR,
        mtestLockType,
        mtestCacheType,
        mtestProtectionType,
        test_burst_data,
        mtestdatasize,
        mtestRegion,
        mtestQOS,
        mtestAWUSER,
        v_wuser,
        response,
        mtestBUSER);
      $display("EXAMPLE TEST 1 : Burst %0d,WRITE DATA = 0x%h, response = 0x%h",i,test_burst_data,response);
      CHECK_RESPONSE_OKAY(response);

    $display("Initializing second ",`MAX_MST_BURST_LENGTH," locations of AXI Slave BFM memory with value");
    for(i = 0 ; i < `MAX_MST_BURST_LENGTH*number_of_mst_bytes ; i = i+1) begin
        test_burst_data[i*8 +: 8] = 0; 
    end

    mtestAddr = `SLV_BFM_BASE_ADDR + (`MAX_MST_BURST_LENGTH)*number_of_mst_bytes;
    dut.bfm_burst_processor.bfm_burst_processor.cdn_axi4_master_bfm_inst.WRITE_BURST(mtestID,
        mtestAddr,
        mtestBurstLength,
        mtestBurstSize,
        `BURST_TYPE_INCR,
        mtestLockType,
        mtestCacheType,
        mtestProtectionType,
        test_burst_data,
        mtestdatasize,
        mtestRegion,
        mtestQOS,
        mtestAWUSER,
        v_wuser,
        response,
        mtestBUSER);
      $display("EXAMPLE TEST 1 : Burst %0d,WRITE DATA = 0x%h, response = 0x%h",i,test_burst_data,response);
      CHECK_RESPONSE_OKAY(response);

    $display("Requesting master to read the data and write to different location");

    //setup reading address for master read operation
    mtestAddr = `SLV_BFM_BASE_ADDR;
    GEN_MASTER_REQ(0,mtestAddr,number_of_mst_bytes*`MAX_MST_BURST_LENGTH);

    //Now User logic master local FIFO should contain the expected Data

    //setup writing address for master write operation
    mtestAddr = mtestAddr + `MAX_MST_BURST_LENGTH*number_of_mst_bytes;
    GEN_MASTER_REQ(1,mtestAddr,number_of_mst_bytes*`MAX_MST_BURST_LENGTH);

    //Now destination system memory will contain the expected data

    //Verifying destination memory location and comparing with expected value
     for(i = 0 ; i < `MAX_MST_BURST_LENGTH*number_of_mst_bytes ; i = i+1) begin
        test_burst_data[i*8 +: 8] = i; 
     end

      mtestAddr = `SLV_BFM_BASE_ADDR + (`MAX_MST_BURST_LENGTH)*number_of_mst_bytes;
      dut.bfm_burst_processor.bfm_burst_processor.cdn_axi4_master_bfm_inst.READ_BURST(
        mtestID,
        mtestAddr,
        mtestBurstLength,
        mtestBurstSize,
        `BURST_TYPE_INCR,
        mtestLockType,
        mtestCacheType,
        mtestProtectionType,
        mtestRegion,
        mtestQOS,
        mtestARUSER,
        rd_burst_data,
        vresponse,
        v_ruser);

      $display("EXAMPLE TEST 1 : READ DATA = 0x%h, vresponse = 0x%h",rd_burst_data,vresponse);
      COMPARE_BURST_DATA(test_burst_data,rd_burst_data);

  $display("----------------------------------------------------");
  $display("Peripheral Verification Completed Successfully");
  $display("----------------------------------------------------");
end

  //----------------------------------------------------------------------------
  // SINGLE_WRITE : SINGLE_WRITE(Address, Data,protection,strobe,response)
  //----------------------------------------------------------------------------

  task automatic SINGLE_WRITE;
     input [`ADDR_BUS_WIDTH-1 : 0] address;
     input [`C_SLV_DWIDTH-1 : 0]    data;
     input [`PROT_BUS_WIDTH-1 : 0] prot; 
     input [3:0]                   strobe;
     output[`RESP_BUS_WIDTH-1 : 0] response;
     begin
       fork
          dut.bfm_lite_processor.bfm_lite_processor.cdn_axi4_lite_master_bfm_inst.SEND_WRITE_ADDRESS(address,prot);
          dut.bfm_lite_processor.bfm_lite_processor.cdn_axi4_lite_master_bfm_inst.SEND_WRITE_DATA(strobe, data);
          dut.bfm_lite_processor.bfm_lite_processor.cdn_axi4_lite_master_bfm_inst.RECEIVE_WRITE_RESPONSE(response);
       join
       CHECK_RESPONSE_OKAY(response);
     end
  endtask

  //----------------------------------------------------------------------------
  // SINGLE_READ : SINGLE_READ(Address, Data,Protection,strobe,respone)
  //----------------------------------------------------------------------------

  task automatic SINGLE_READ;
     input [`ADDR_BUS_WIDTH-1 : 0] address;
     output [`C_SLV_DWIDTH-1 : 0]    data;
     input [`PROT_BUS_WIDTH-1 : 0] prot; 
     output[`RESP_BUS_WIDTH-1 : 0] response;
     begin
      dut.bfm_lite_processor.bfm_lite_processor.cdn_axi4_lite_master_bfm_inst.SEND_READ_ADDRESS(address,prot);
      dut.bfm_lite_processor.bfm_lite_processor.cdn_axi4_lite_master_bfm_inst.RECEIVE_READ_DATA(data,response);
      CHECK_RESPONSE_OKAY(response);
     end
  endtask

  //----------------------------------------------------------------------------
  //   TEST LEVEL API: CHECK_RESPONSE_OKAY(response)
  //----------------------------------------------------------------------------

  //Description: This task check if the return response is equal to OKAY
  //----------------------------------------------------------------------
  task automatic CHECK_RESPONSE_OKAY;
    input [`RESP_BUS_WIDTH-1:0] response;
     begin
      if (response !== `RESPONSE_OKAY) begin
        $display("TESTBENCH FAILED! Response is not OKAY",
          "\n expected = 0x%h",`RESPONSE_OKAY,
          "\n actual = 0x%h", response);
        $stop;
      end
    end
  endtask
  //----------------------------------------------------------------------------
  //   TEST LEVEL API: COMPARE_BURST_DATA(expected,actual)
  //----------------------------------------------------------------------------

  //Description: This task checks if the actual data is equal to the expected data
  //----------------------------------------------------------------------
  task automatic COMPARE_BURST_DATA;
    input [(`C_MST_DWIDTH*(`MAX_MST_BURST_LENGTH+1))-1:0] expected;
    input [(`C_MST_DWIDTH*(`MAX_MST_BURST_LENGTH+1))-1:0] actual;
    begin
      if (expected === 'hx || actual === 'hx) begin
        $display("TESTBENCH FAILED! COMPARE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
        $stop;
      end
      if (actual !== expected) begin
        $display("TESTBENCH FAILED! Data expected is not equal to actual.","\n expected = 0x%h",expected,
        "\n actual   = 0x%h",actual);
        $stop;
      end
    end
    endtask
  //----------------------------------------------------------------------------
  //   TEST LEVEL API: COMPARE_DATA(expected,actual)
  //----------------------------------------------------------------------------

  //Description: This task checks if the actual data is equal to the expected data
  //----------------------------------------------------------------------
  task automatic COMPARE_DATA;
    input [`C_SLV_DWIDTH-1:0] expected;
    input [`C_SLV_DWIDTH-1:0] actual;
    begin
      if (expected === 'hx || actual === 'hx) begin
        $display("TESTBENCH FAILED! COMPARE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
        $stop;
      end
      if (actual !== expected) begin
        $display("TESTBENCH FAILED! Data expected is not equal to actual.","\n expected = 0x%h",expected,
        "\n actual   = 0x%h",actual);
        $stop;
      end
    end
    endtask
  //----------------------------------------------------------------------------
  // TEST LEVEL API: GEN_MASTER_REQ(nRW,Address)
  //----------------------------------------------------------------------------

  //Description: This task is used to set master(peripheral) for read/write transaction
  //----------------------------------------------------------------------------------
  task automatic GEN_MASTER_REQ;
      input                         nRW;
      input [`ADDR_BUS_WIDTH-1 : 0] address;
      input [31 : 0]                length;
      reg [`PROT_BUS_WIDTH-1   : 0] prot;
      reg [`RESP_BUS_WIDTH-1   : 0] response;
      reg                           done;
      reg [`C_SLV_DWIDTH-1      : 0] rd_data;
      integer count;

      begin
        if(nRW == 1)
            //setup master control register for master write operation
            SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_CNTL_REG,`MST_CNTL_WRBRST,prot,`MST_CNTL_REG_CMD_BE,response);
        else
            //setup master control register for master read operation
            SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_CNTL_REG,`MST_CNTL_RDBRST,prot,`MST_CNTL_REG_CMD_BE,response);

        //setup master address register for target system address (source to be read from)
        SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_ADDR_REG,address,prot,`MST_ADDR_REG_BE,response);

        //setup master byte enable register for valid byte lanes
        SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_BE_REG,32'h0000FFFF,prot,`MST_BE_REG_BE,response);

        //setup master length register for transfer length
        SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_LEN_REG,length,prot,`MST_LEN_REG_BE,response);

        //write master go port to start master read transaction
        SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_GO_PORT,32'h0A000000,prot,`MST_GO_PORT_BE,response);

        //now we need to wait for awhile to let the user logic master complete transaction
        done = 0;
        count = 0;
        while((!done) && (count < 100)) begin
            SINGLE_READ(`SLAVE_BASE_ADDR + `MST_CNTL_REG,rd_data,prot,response);
            done = rd_data[`DONE_BIT_LOC];
            count = count +1;
        end

        //clear the user logic master done bit
        SINGLE_WRITE(`SLAVE_BASE_ADDR + `MST_CNTL_REG,32'h00000000,prot,4'b1111,response);

        //verify Done is cleared out of the user logic master
        rd_data = 0;
        SINGLE_READ(`SLAVE_BASE_ADDR + `MST_CNTL_REG,rd_data,prot,response);
        COMPARE_DATA(rd_data & 32'h0000FF00, 32'h00000000);
    end
    endtask

endmodule
