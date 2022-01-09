-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Thu Aug 12 19:17:40 2021
-- Host        : CL-MDS31404 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               Z:/Projects/ASIC2/LiME-SwerVolf/LiME-SwerVolf.srcs/sources_1/ip/sys_clk_mmcm/sys_clk_mmcm_stub.vhdl
-- Design      : sys_clk_mmcm
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tfbg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sys_clk_mmcm is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end sys_clk_mmcm;

architecture stub of sys_clk_mmcm is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1_p,clk_in1_n";
begin
end;
