`default_nettype none
module swervolf_nexys_a7
  #(parameter bootrom_file = "jumptoram.vh")
   (input  wire 	   sys_clk_p,
    input  wire 	   sys_clk_n,
    input  wire 	   CPU_RESET,
    input  wire 	   i_uart_rx,
    output wire        o_uart_tx,
    output wire        o_flash_cs_n,
    output wire        o_flash_mosi,
    input  wire 	   i_flash_miso
   );

   wire [15:0]         i_sw;
   reg  [15:0]         o_led;  
   wire 	           clk;
   wire 	           rstn;
   wire [63:0] 	       gpio_out;
   reg [15:0] 	       led_int_r;
   reg [15:0] 	       sw_r;
   reg [15:0] 	       sw_2r;

   wire 	       litedram_init_done;
   wire 	       litedram_init_error;

   wire 	 rst_core;

   assign rstn = ~CPU_RESET;
   
   sys_clk_mmcm sys_clk_mmcm_inst
   (
    // Clock out ports
    .clk_out1(clk),     // output clk_out1
   // Clock in ports
    .clk_in1_p(sys_clk_p),    // input clk_in1_p
    .clk_in1_n(sys_clk_n));    // input clk_in1_n

   AXI_BUS #(32, 64, 6, 1) cpu();

   assign cpu.aw_atop = 6'd0;
   assign cpu.aw_user = 1'b0;
   assign cpu.ar_user = 1'b0;
   assign cpu.w_user = 1'b0;
   assign cpu.b_user = 1'b0;
   assign cpu.r_user = 1'b0;
   assign mem.b_user = 1'b0;
   assign mem.r_user = 1'b0;
   
   assign litedram_init_done = 1'b1;
   assign litedram_init_error = 1'b0;

    riscv_local_ram riscv_local_ram_inst (
      .s_aclk(clk),                // input wire s_aclk
      .s_aresetn(rstn),          // input wire s_aresetn
      .s_axi_awid(cpu.aw_id),        // input wire [3 : 0] s_axi_awid
      .s_axi_awaddr(cpu.aw_addr),    // input wire [31 : 0] s_axi_awaddr
      .s_axi_awlen(cpu.aw_len),      // input wire [7 : 0] s_axi_awlen
      .s_axi_awsize(cpu.aw_size),    // input wire [2 : 0] s_axi_awsize
      .s_axi_awburst(cpu.aw_burst),  // input wire [1 : 0] s_axi_awburst
      .s_axi_awvalid(cpu.aw_valid),  // input wire s_axi_awvalid
      .s_axi_awready(cpu.aw_ready),  // output wire s_axi_awready
      .s_axi_wdata(cpu.w_data),      // input wire [63 : 0] s_axi_wdata
      .s_axi_wstrb(cpu.w_strb),      // input wire [7 : 0] s_axi_wstrb
      .s_axi_wlast(cpu.w_last),      // input wire s_axi_wlast
      .s_axi_wvalid(cpu.w_valid),    // input wire s_axi_wvalid
      .s_axi_wready(cpu.w_ready),    // output wire s_axi_wready
      .s_axi_bid(cpu.b_id),          // output wire [3 : 0] s_axi_bid
      .s_axi_bresp(cpu.b_resp),      // output wire [1 : 0] s_axi_bresp
      .s_axi_bvalid(cpu.b_valid),    // output wire s_axi_bvalid
      .s_axi_bready(cpu.b_ready),    // input wire s_axi_bready
      .s_axi_arid(cpu.ar_id),        // input wire [3 : 0] s_axi_arid
      .s_axi_araddr(cpu.ar_addr),    // input wire [31 : 0] s_axi_araddr
      .s_axi_arlen(cpu.ar_len),      // input wire [7 : 0] s_axi_arlen
      .s_axi_arsize(cpu.ar_size),    // input wire [2 : 0] s_axi_arsize
      .s_axi_arburst(cpu.ar_burst),  // input wire [1 : 0] s_axi_arburst
      .s_axi_arvalid(cpu.ar_valid),  // input wire s_axi_arvalid
      .s_axi_arready(cpu.ar_ready),  // output wire s_axi_arready
      .s_axi_rid(cpu.r_id),          // output wire [3 : 0] s_axi_rid
      .s_axi_rdata(cpu.r_data),      // output wire [63 : 0] s_axi_rdata
      .s_axi_rresp(cpu.r_resp),      // output wire [1 : 0] s_axi_rresp
      .s_axi_rlast(cpu.r_last),      // output wire s_axi_rlast
      .s_axi_rvalid(cpu.r_valid),    // output wire s_axi_rvalid
      .s_axi_rready(cpu.r_ready)    // input wire s_axi_rready
    );

   wire        dmi_reg_en;
   wire [6:0]  dmi_reg_addr;
   wire        dmi_reg_wr_en;
   wire [31:0] dmi_reg_wdata;
   wire [31:0] dmi_reg_rdata;
   wire        dmi_hard_reset;
   wire        flash_sclk;

   STARTUPE2 STARTUPE2
     (
      .CFGCLK    (),
      .CFGMCLK   (),
      .EOS       (),
      .PREQ      (),
      .CLK       (1'b0),
      .GSR       (1'b0),
      .GTS       (1'b0),
      .KEYCLEARB (1'b1),
      .PACK      (1'b0),
      .USRCCLKO  (flash_sclk),
      .USRCCLKTS (1'b0),
      .USRDONEO  (1'b1),
      .USRDONETS (1'b0));

   bscan_tap tap
     (.clk            (clk),
      .rst            (rst_core),
      .jtag_id        (31'd0),
      .dmi_reg_wdata  (dmi_reg_wdata),
      .dmi_reg_addr   (dmi_reg_addr),
      .dmi_reg_wr_en  (dmi_reg_wr_en),
      .dmi_reg_en     (dmi_reg_en),
      .dmi_reg_rdata  (dmi_reg_rdata),
      .dmi_hard_reset (dmi_hard_reset),
      .rd_status      (2'd0),
      .idle           (3'd0),
      .dmi_stat       (2'd0),
      .version        (4'd1));

   swervolf_core
     #(.bootrom_file (bootrom_file),
       .clk_freq_hz  (32'd50_000_000))
   swervolf
     (.clk  (clk),
      .rstn (~CPU_RESET),
      .dmi_reg_rdata  (dmi_reg_rdata),
      .dmi_reg_wdata  (dmi_reg_wdata),
      .dmi_reg_addr   (dmi_reg_addr ),
      .dmi_reg_en     (dmi_reg_en   ),
      .dmi_reg_wr_en  (dmi_reg_wr_en),
      .dmi_hard_reset (dmi_hard_reset),
      .o_flash_sclk   (flash_sclk),
      .o_flash_cs_n   (o_flash_cs_n),
      .o_flash_mosi   (o_flash_mosi),
      .i_flash_miso   (i_flash_miso),
      .i_uart_rx      (i_uart_rx),
      .o_uart_tx      (o_uart_tx),
      .o_ram_awid     (cpu.aw_id),
      .o_ram_awaddr   (cpu.aw_addr),
      .o_ram_awlen    (cpu.aw_len),
      .o_ram_awsize   (cpu.aw_size),
      .o_ram_awburst  (cpu.aw_burst),
      .o_ram_awlock   (cpu.aw_lock),
      .o_ram_awcache  (cpu.aw_cache),
      .o_ram_awprot   (cpu.aw_prot),
      .o_ram_awregion (cpu.aw_region),
      .o_ram_awqos    (cpu.aw_qos),
      .o_ram_awvalid  (cpu.aw_valid),
      .i_ram_awready  (cpu.aw_ready),
      .o_ram_arid     (cpu.ar_id),
      .o_ram_araddr   (cpu.ar_addr),
      .o_ram_arlen    (cpu.ar_len),
      .o_ram_arsize   (cpu.ar_size),
      .o_ram_arburst  (cpu.ar_burst),
      .o_ram_arlock   (cpu.ar_lock),
      .o_ram_arcache  (cpu.ar_cache),
      .o_ram_arprot   (cpu.ar_prot),
      .o_ram_arregion (cpu.ar_region),
      .o_ram_arqos    (cpu.ar_qos),
      .o_ram_arvalid  (cpu.ar_valid),
      .i_ram_arready  (cpu.ar_ready),
      .o_ram_wdata    (cpu.w_data),
      .o_ram_wstrb    (cpu.w_strb),
      .o_ram_wlast    (cpu.w_last),
      .o_ram_wvalid   (cpu.w_valid),
      .i_ram_wready   (cpu.w_ready),
      .i_ram_bid      (cpu.b_id),
      .i_ram_bresp    (cpu.b_resp),
      .i_ram_bvalid   (cpu.b_valid),
      .o_ram_bready   (cpu.b_ready),
      .i_ram_rid      (cpu.r_id),
      .i_ram_rdata    (cpu.r_data),
      .i_ram_rresp    (cpu.r_resp),
      .i_ram_rlast    (cpu.r_last),
      .i_ram_rvalid   (cpu.r_valid),
      .o_ram_rready   (cpu.r_ready),
      .i_ram_init_done  (litedram_init_done),
      .i_ram_init_error (litedram_init_error),
      .i_gpio           ({32'd0,sw_2r,16'd0}),
      .o_gpio           (gpio_out));

   always @(posedge clk) begin
      o_led <= led_int_r;
      led_int_r <= gpio_out[15:0];
      sw_r <= i_sw;
      sw_2r <= sw_r;
   end

endmodule
