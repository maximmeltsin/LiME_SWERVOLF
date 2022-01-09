// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu Aug 12 19:17:40 2021
// Host        : CL-MDS31404 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               Z:/Projects/ASIC2/LiME-SwerVolf/LiME-SwerVolf.srcs/sources_1/ip/sys_clk_mmcm/sys_clk_mmcm_stub.v
// Design      : sys_clk_mmcm
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module sys_clk_mmcm(clk_out1, clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_in1_p,clk_in1_n" */;
  output clk_out1;
  input clk_in1_p;
  input clk_in1_n;
endmodule
