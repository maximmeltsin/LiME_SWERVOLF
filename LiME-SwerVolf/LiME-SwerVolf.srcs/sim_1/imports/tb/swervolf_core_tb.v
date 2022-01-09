// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Western Digital Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//********************************************************************************
// $Id$
//
// Function: Verilog testbench for SweRVolf
// Comments:
//
//********************************************************************************

`default_nettype none
module swervolf_core_tb
  #(parameter bootrom_file  = "jumtoram.vh",
    parameter ram_init_file  = "hello.vh"
   )
`ifdef VERILATOR
  (input wire clk,
   input wire  rst,
   input wire  i_jtag_tck,
   input wire  i_jtag_tms,
   input wire  i_jtag_tdi,
   input wire  i_jtag_trst_n,
   output wire o_jtag_tdo,
   output wire o_uart_tx,
   output wire o_gpio)
`endif
  ;

   localparam RAM_SIZE     = 32'h100000;

`ifndef VERILATOR
   reg 	 clk = 1'b0;
   reg 	 rst = 1'b1;
   always #10 clk <= !clk;
   initial #100 rst <= 1'b0;
   wire  o_gpio;
   wire i_jtag_tck = 1'b0;
   wire i_jtag_tms = 1'b0;
   wire i_jtag_tdi = 1'b0;
   wire i_jtag_trst_n = 1'b0;
   wire o_jtag_tdo;
   wire  o_uart_tx;

   uart_decoder #(115200) uart_decoder (o_uart_tx);

`endif

//   initial begin
//      if (|$test$plusargs("jtag_vpi_enable"))
//	$display("JTAG VPI enabled. Not loading RAM");
//      else begin
//	 $display("Loading RAM contents from %0s", ram_init_file);
//	 $readmemh(ram_init_file, ram.ram.mem);
//      end
//   end

   reg [1023:0] rom_init_file;

   initial begin
      if ($value$plusargs("rom_init_file=%s", rom_init_file)) begin
	 $display("Loading ROM contents from %0s", rom_init_file);
	 $readmemh(rom_init_file, swervolf.bootrom.ram.mem);
      end else if (!(|bootrom_file))
	/*
	 Set mrac to 0xAAAA0000 and jump to address 0
	 if no bootloader is selected
	 0:   aaaa02b7                lui     t0,0xaaaa0
	 4:   7c029073                csrw    0x7c0,t0
	 8:   00000067                jr      zero

	 */
	$display("Loading jumptoram to ROM");
	swervolf.bootrom.ram.mem[0] = 64'h7c029073aaaa02b7;
	swervolf.bootrom.ram.mem[1] = 64'h0000000000000067;
   end

   wire [63:0] gpio_out;
   assign o_gpio = gpio_out[0];

   wire [5:0]  ram_awid;
   wire [31:0] ram_awaddr;
   wire [7:0]  ram_awlen;
   wire [2:0]  ram_awsize;
   wire [1:0]  ram_awburst;
   wire        ram_awlock;
   wire [3:0]  ram_awcache;
   wire [2:0]  ram_awprot;
   wire [3:0]  ram_awregion;
   wire [3:0]  ram_awqos;
   wire        ram_awvalid;
   wire        ram_awready;
   wire [5:0]  ram_arid;
   wire [31:0] ram_araddr;
   wire [7:0]  ram_arlen;
   wire [2:0]  ram_arsize;
   wire [1:0]  ram_arburst;
   wire        ram_arlock;
   wire [3:0]  ram_arcache;
   wire [2:0]  ram_arprot;
   wire [3:0]  ram_arregion;
   wire [3:0]  ram_arqos;
   wire        ram_arvalid;
   wire        ram_arready;
   wire [63:0] ram_wdata;
   wire [7:0]  ram_wstrb;
   wire        ram_wlast;
   wire        ram_wvalid;
   wire        ram_wready;
   wire [5:0]  ram_bid;
   wire [1:0]  ram_bresp;
   wire        ram_bvalid;
   wire        ram_bready;
   wire [5:0]  ram_rid;
   wire [63:0] ram_rdata;
   wire [1:0]  ram_rresp;
   wire        ram_rlast;
   wire        ram_rvalid;
   wire        ram_rready;

   wire        dmi_reg_en;
   wire [6:0]  dmi_reg_addr;
   wire        dmi_reg_wr_en;
   wire [31:0] dmi_reg_wdata;
   wire [31:0] dmi_reg_rdata;
   wire        dmi_hard_reset;


riscv_local_ram riscv_local_ram_inst (
  .s_aclk(clk),                // input wire s_aclk
  .s_aresetn(!rst),          // input wire s_aresetn
  .s_axi_awid(ram_awid),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr(ram_awaddr),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(ram_awlen),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(ram_awsize),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(ram_awburst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(ram_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready(ram_awready),  // output wire s_axi_awready
  .s_axi_wdata(ram_wdata),      // input wire [63 : 0] s_axi_wdata
  .s_axi_wstrb(ram_wstrb),      // input wire [7 : 0] s_axi_wstrb
  .s_axi_wlast(ram_wlast),      // input wire s_axi_wlast
  .s_axi_wvalid(ram_wvalid),    // input wire s_axi_wvalid
  .s_axi_wready(ram_wready),    // output wire s_axi_wready
  .s_axi_bid(ram_bid),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(ram_bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(ram_bvalid),    // output wire s_axi_bvalid
  .s_axi_bready(ram_bready),    // input wire s_axi_bready
  .s_axi_arid(ram_arid),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr(ram_araddr),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(ram_arlen),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(ram_arsize),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(ram_arburst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(ram_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready(ram_arready),  // output wire s_axi_arready
  .s_axi_rid(ram_rid),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(ram_rdata),      // output wire [63 : 0] s_axi_rdata
  .s_axi_rresp(ram_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(ram_rlast),      // output wire s_axi_rlast
  .s_axi_rvalid(ram_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(ram_rready)    // input wire s_axi_rready
);
   
//   axi_mem_wrapper
//     #(.ID_WIDTH  (`RV_LSU_BUS_TAG+2),
//       .MEM_SIZE  (RAM_SIZE),
//       .INIT_FILE (ram_init_file))
//   ram
//     (.clk       (clk),
//      .rst_n     (!rst),
//      .i_awid    (ram_awid),
//      .i_awaddr  (ram_awaddr),
//      .i_awlen   (ram_awlen),
//      .i_awsize  (ram_awsize),
//      .i_awburst (ram_awburst),
//      .i_awvalid (ram_awvalid),
//      .o_awready (ram_awready),

//      .i_arid    (ram_arid),
//      .i_araddr  (ram_araddr),
//      .i_arlen   (ram_arlen),
//      .i_arsize  (ram_arsize),
//      .i_arburst (ram_arburst),
//      .i_arvalid (ram_arvalid),
//      .o_arready (ram_arready),

//      .i_wdata  (ram_wdata),
//      .i_wstrb  (ram_wstrb),
//      .i_wlast  (ram_wlast),
//      .i_wvalid (ram_wvalid),
//      .o_wready (ram_wready),

//      .o_bid    (ram_bid),
//      .o_bresp  (ram_bresp),
//      .o_bvalid (ram_bvalid),
//      .i_bready (ram_bready),

//      .o_rid    (ram_rid),
//      .o_rdata  (ram_rdata),
//      .o_rresp  (ram_rresp),
//      .o_rlast  (ram_rlast),
//      .o_rvalid (ram_rvalid),
//      .i_rready (ram_rready));

   dmi_wrapper dmi_wrapper
     (.trst_n    (i_jtag_trst_n),
      .tck       (i_jtag_tck),
      .tms       (i_jtag_tms),
      .tdi       (i_jtag_tdi),
      .tdo       (o_jtag_tdo),
      .tdoEnable (),
      // Processor Signals
      .scan_mode      (1'b0),
      .core_rst_n     (!rst),
      .core_clk       (clk),
      .jtag_id        (31'd0),
      .rd_data        (dmi_reg_rdata),
      .reg_wr_data    (dmi_reg_wdata),
      .reg_wr_addr    (dmi_reg_addr),
      .reg_en         (dmi_reg_en),
      .reg_wr_en      (dmi_reg_wr_en),
      .dmi_hard_reset (dmi_hard_reset)); 

   swervolf_core
     #(.bootrom_file (bootrom_file),
       .clk_freq_hz (32'd50_000_000))
   swervolf
     (.clk  (clk),
      .rstn (!rst),
      .dmi_reg_rdata       (dmi_reg_rdata),
      .dmi_reg_wdata       (dmi_reg_wdata),
      .dmi_reg_addr        (dmi_reg_addr),
      .dmi_reg_en          (dmi_reg_en),
      .dmi_reg_wr_en       (dmi_reg_wr_en),
      .dmi_hard_reset      (dmi_hard_reset),
      .o_flash_sclk        (),
      .o_flash_cs_n        (),
      .o_flash_mosi        (),
      .i_flash_miso        (1'b0),
      .i_uart_rx           (1'b1),
      .o_uart_tx           (o_uart_tx),
      .o_ram_awid          (ram_awid),
      .o_ram_awaddr        (ram_awaddr),
      .o_ram_awlen         (ram_awlen),
      .o_ram_awsize        (ram_awsize),
      .o_ram_awburst       (ram_awburst),
      .o_ram_awlock        (ram_awlock),
      .o_ram_awcache       (ram_awcache),
      .o_ram_awprot        (ram_awprot),
      .o_ram_awregion      (ram_awregion),
      .o_ram_awqos         (ram_awqos),
      .o_ram_awvalid       (ram_awvalid),
      .i_ram_awready       (ram_awready),
      .o_ram_arid          (ram_arid),
      .o_ram_araddr        (ram_araddr),
      .o_ram_arlen         (ram_arlen),
      .o_ram_arsize        (ram_arsize),
      .o_ram_arburst       (ram_arburst),
      .o_ram_arlock        (ram_arlock),
      .o_ram_arcache       (ram_arcache),
      .o_ram_arprot        (ram_arprot),
      .o_ram_arregion      (ram_arregion),
      .o_ram_arqos         (ram_arqos),
      .o_ram_arvalid       (ram_arvalid),
      .i_ram_arready       (ram_arready),
      .o_ram_wdata         (ram_wdata),
      .o_ram_wstrb         (ram_wstrb),
      .o_ram_wlast         (ram_wlast),
      .o_ram_wvalid        (ram_wvalid),
      .i_ram_wready        (ram_wready),
      .i_ram_bid           (ram_bid),
      .i_ram_bresp         (ram_bresp),
      .i_ram_bvalid        (ram_bvalid),
      .o_ram_bready        (ram_bready),
      .i_ram_rid           (ram_rid),
      .i_ram_rdata         (ram_rdata),
      .i_ram_rresp         (ram_rresp),
      .i_ram_rlast         (ram_rlast),
      .i_ram_rvalid        (ram_rvalid),
      .o_ram_rready        (ram_rready),
      .i_ram_init_done     (1'b1),
      .i_ram_init_error    (1'b0),
      .i_gpio              (64'd0),
      .o_gpio              (gpio_out));

endmodule
