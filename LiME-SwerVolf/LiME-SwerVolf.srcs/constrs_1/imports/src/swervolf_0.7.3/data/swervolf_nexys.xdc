create_clock -period 100.000 -name tck_dmi -add [get_pins tap/tap_dmi/TCK]
create_clock -period 100.000 -name tck_dtmcs -add [get_pins tap/tap_dtmcs/TCK]
create_clock -period 100.000 -name tck_idcode -add [get_pins tap/tap_idcode/DRCK]

#FIXME: Improve this later but hopefully ok for now.
#Since the JTAG clock is slow and bits 0 and 1 are properly synced, we can be a bit careless about the rest
set_false_path -from [get_cells -regexp {tap/dtmcs_r_reg\[([2-9]|[1-9][0-9])\]}]

set_property -dict {PACKAGE_PIN U4 IOSTANDARD SSTL15} [get_ports CPU_RESET]

set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS18} [get_ports i_uart_rx]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS18} [get_ports o_uart_tx]


set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports o_flash_mosi]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports i_flash_miso]
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { QSPI_DQ[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { QSPI_DQ[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports o_flash_cs_n]

#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }]
#set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }]
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[2] }]
#set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { i_sw[3] }]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { i_sw[4] }]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { i_sw[5] }]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { i_sw[6] }]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[7] }]
#set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { i_sw[8] }]
#set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { i_sw[9] }]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { i_sw[10] }]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { i_sw[11] }]
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { i_sw[12] }]
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { i_sw[13] }]
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { i_sw[14] }]
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { i_sw[15] }]

#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { o_led[0] }]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { o_led[1] }]
#set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { o_led[2] }]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { o_led[3] }]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { o_led[4] }]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { o_led[5] }]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { o_led[6] }]
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { o_led[7] }]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { o_led[8] }]
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { o_led[9] }]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { o_led[10] }]
#set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { o_led[11] }]
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { o_led[12] }]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { o_led[13] }]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { o_led[14] }]
#set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { o_led[15] }]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sys_clk_mmcm_inst/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 64 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {cpu\\.r_data[0]} {cpu\\.r_data[1]} {cpu\\.r_data[2]} {cpu\\.r_data[3]} {cpu\\.r_data[4]} {cpu\\.r_data[5]} {cpu\\.r_data[6]} {cpu\\.r_data[7]} {cpu\\.r_data[8]} {cpu\\.r_data[9]} {cpu\\.r_data[10]} {cpu\\.r_data[11]} {cpu\\.r_data[12]} {cpu\\.r_data[13]} {cpu\\.r_data[14]} {cpu\\.r_data[15]} {cpu\\.r_data[16]} {cpu\\.r_data[17]} {cpu\\.r_data[18]} {cpu\\.r_data[19]} {cpu\\.r_data[20]} {cpu\\.r_data[21]} {cpu\\.r_data[22]} {cpu\\.r_data[23]} {cpu\\.r_data[24]} {cpu\\.r_data[25]} {cpu\\.r_data[26]} {cpu\\.r_data[27]} {cpu\\.r_data[28]} {cpu\\.r_data[29]} {cpu\\.r_data[30]} {cpu\\.r_data[31]} {cpu\\.r_data[32]} {cpu\\.r_data[33]} {cpu\\.r_data[34]} {cpu\\.r_data[35]} {cpu\\.r_data[36]} {cpu\\.r_data[37]} {cpu\\.r_data[38]} {cpu\\.r_data[39]} {cpu\\.r_data[40]} {cpu\\.r_data[41]} {cpu\\.r_data[42]} {cpu\\.r_data[43]} {cpu\\.r_data[44]} {cpu\\.r_data[45]} {cpu\\.r_data[46]} {cpu\\.r_data[47]} {cpu\\.r_data[48]} {cpu\\.r_data[49]} {cpu\\.r_data[50]} {cpu\\.r_data[51]} {cpu\\.r_data[52]} {cpu\\.r_data[53]} {cpu\\.r_data[54]} {cpu\\.r_data[55]} {cpu\\.r_data[56]} {cpu\\.r_data[57]} {cpu\\.r_data[58]} {cpu\\.r_data[59]} {cpu\\.r_data[60]} {cpu\\.r_data[61]} {cpu\\.r_data[62]} {cpu\\.r_data[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 6 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {cpu\\.b_id[0]} {cpu\\.b_id[1]} {cpu\\.b_id[2]} {cpu\\.b_id[3]} {cpu\\.b_id[4]} {cpu\\.b_id[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {cpu\\.ar_addr[0]} {cpu\\.ar_addr[1]} {cpu\\.ar_addr[2]} {cpu\\.ar_addr[3]} {cpu\\.ar_addr[4]} {cpu\\.ar_addr[5]} {cpu\\.ar_addr[6]} {cpu\\.ar_addr[7]} {cpu\\.ar_addr[8]} {cpu\\.ar_addr[9]} {cpu\\.ar_addr[10]} {cpu\\.ar_addr[11]} {cpu\\.ar_addr[12]} {cpu\\.ar_addr[13]} {cpu\\.ar_addr[14]} {cpu\\.ar_addr[15]} {cpu\\.ar_addr[16]} {cpu\\.ar_addr[17]} {cpu\\.ar_addr[18]} {cpu\\.ar_addr[19]} {cpu\\.ar_addr[20]} {cpu\\.ar_addr[21]} {cpu\\.ar_addr[22]} {cpu\\.ar_addr[23]} {cpu\\.ar_addr[24]} {cpu\\.ar_addr[25]} {cpu\\.ar_addr[26]} {cpu\\.ar_addr[27]} {cpu\\.ar_addr[28]} {cpu\\.ar_addr[29]} {cpu\\.ar_addr[30]} {cpu\\.ar_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {cpu\\.aw_burst[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 5 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {cpu\\.aw_id[0]} {cpu\\.aw_id[1]} {cpu\\.aw_id[2]} {cpu\\.aw_id[4]} {cpu\\.aw_id[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 6 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {cpu\\.r_id[0]} {cpu\\.r_id[1]} {cpu\\.r_id[2]} {cpu\\.r_id[3]} {cpu\\.r_id[4]} {cpu\\.r_id[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {cpu\\.w_strb[0]} {cpu\\.w_strb[1]} {cpu\\.w_strb[2]} {cpu\\.w_strb[3]} {cpu\\.w_strb[4]} {cpu\\.w_strb[5]} {cpu\\.w_strb[6]} {cpu\\.w_strb[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {cpu\\.ar_burst[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 64 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {cpu\\.w_data[0]} {cpu\\.w_data[1]} {cpu\\.w_data[2]} {cpu\\.w_data[3]} {cpu\\.w_data[4]} {cpu\\.w_data[5]} {cpu\\.w_data[6]} {cpu\\.w_data[7]} {cpu\\.w_data[8]} {cpu\\.w_data[9]} {cpu\\.w_data[10]} {cpu\\.w_data[11]} {cpu\\.w_data[12]} {cpu\\.w_data[13]} {cpu\\.w_data[14]} {cpu\\.w_data[15]} {cpu\\.w_data[16]} {cpu\\.w_data[17]} {cpu\\.w_data[18]} {cpu\\.w_data[19]} {cpu\\.w_data[20]} {cpu\\.w_data[21]} {cpu\\.w_data[22]} {cpu\\.w_data[23]} {cpu\\.w_data[24]} {cpu\\.w_data[25]} {cpu\\.w_data[26]} {cpu\\.w_data[27]} {cpu\\.w_data[28]} {cpu\\.w_data[29]} {cpu\\.w_data[30]} {cpu\\.w_data[31]} {cpu\\.w_data[32]} {cpu\\.w_data[33]} {cpu\\.w_data[34]} {cpu\\.w_data[35]} {cpu\\.w_data[36]} {cpu\\.w_data[37]} {cpu\\.w_data[38]} {cpu\\.w_data[39]} {cpu\\.w_data[40]} {cpu\\.w_data[41]} {cpu\\.w_data[42]} {cpu\\.w_data[43]} {cpu\\.w_data[44]} {cpu\\.w_data[45]} {cpu\\.w_data[46]} {cpu\\.w_data[47]} {cpu\\.w_data[48]} {cpu\\.w_data[49]} {cpu\\.w_data[50]} {cpu\\.w_data[51]} {cpu\\.w_data[52]} {cpu\\.w_data[53]} {cpu\\.w_data[54]} {cpu\\.w_data[55]} {cpu\\.w_data[56]} {cpu\\.w_data[57]} {cpu\\.w_data[58]} {cpu\\.w_data[59]} {cpu\\.w_data[60]} {cpu\\.w_data[61]} {cpu\\.w_data[62]} {cpu\\.w_data[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 5 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {cpu\\.ar_id[0]} {cpu\\.ar_id[1]} {cpu\\.ar_id[2]} {cpu\\.ar_id[4]} {cpu\\.ar_id[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 3 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {cpu\\.aw_size[0]} {cpu\\.aw_size[1]} {cpu\\.aw_size[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {cpu\\.aw_addr[0]} {cpu\\.aw_addr[1]} {cpu\\.aw_addr[2]} {cpu\\.aw_addr[3]} {cpu\\.aw_addr[4]} {cpu\\.aw_addr[5]} {cpu\\.aw_addr[6]} {cpu\\.aw_addr[7]} {cpu\\.aw_addr[8]} {cpu\\.aw_addr[9]} {cpu\\.aw_addr[10]} {cpu\\.aw_addr[11]} {cpu\\.aw_addr[12]} {cpu\\.aw_addr[13]} {cpu\\.aw_addr[14]} {cpu\\.aw_addr[15]} {cpu\\.aw_addr[16]} {cpu\\.aw_addr[17]} {cpu\\.aw_addr[18]} {cpu\\.aw_addr[19]} {cpu\\.aw_addr[20]} {cpu\\.aw_addr[21]} {cpu\\.aw_addr[22]} {cpu\\.aw_addr[23]} {cpu\\.aw_addr[24]} {cpu\\.aw_addr[25]} {cpu\\.aw_addr[26]} {cpu\\.aw_addr[27]} {cpu\\.aw_addr[28]} {cpu\\.aw_addr[29]} {cpu\\.aw_addr[30]} {cpu\\.aw_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 3 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {cpu\\.ar_size[0]} {cpu\\.ar_size[1]} {cpu\\.ar_size[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {cpu\\.ar_ready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {cpu\\.ar_valid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {cpu\\.aw_ready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {cpu\\.aw_valid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {cpu\\.b_ready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {cpu\\.b_valid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {cpu\\.r_last}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {cpu\\.r_ready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {cpu\\.r_valid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {cpu\\.w_last}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {cpu\\.w_ready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {cpu\\.w_valid}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
