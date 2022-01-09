-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../swervolf_0.7.3.srcs/sources_1/ip/sys_clk_mmcm/sys_clk_mmcm_clk_wiz.v" \
  "../../../../swervolf_0.7.3.srcs/sources_1/ip/sys_clk_mmcm/sys_clk_mmcm.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

