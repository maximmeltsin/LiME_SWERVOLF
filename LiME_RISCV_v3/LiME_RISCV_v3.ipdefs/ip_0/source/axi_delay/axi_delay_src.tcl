# From open project, type:
# source [get_property DIRECTORY [current_project]]/axi_delay_src.tcl

set repo_base C:/Xilinx/Vivado/2014.1/data/ip/xilinx
set proj_base [get_property DIRECTORY [current_project]]
# Option: [add_files -norecurse ...]
# To determine the files in a library, look in component.xml
# see xilinx_vhdlbehavioralsimulation_view_fileset
# see xilinx_vhdlsynthesis_view_fileset

set_property target_language VHDL [current_project]

# blk_mem_gen
set blk_mem_gen blk_mem_gen_v8_2
set_property -dict [ list LIBRARY $blk_mem_gen USED_IN {synthesis} ] [add_files $repo_base/$blk_mem_gen/hdl]
set_property -dict [ list LIBRARY $blk_mem_gen USED_IN {simulation} ] [add_files -fileset sim_1 $repo_base/$blk_mem_gen/simulation/blk_mem_gen_v8_2.vhd]

# fifo_generator
set fifo_generator fifo_generator_v12_0
set_property -dict [ list LIBRARY $fifo_generator USED_IN {synthesis simulation} ] [add_files $repo_base/$fifo_generator/hdl]
set_property -dict [ list LIBRARY $fifo_generator USED_IN {simulation} ] [add_files -fileset sim_1 $repo_base/$fifo_generator/simulation/fifo_generator_vhdl_beh.vhd]

# proc_common
set proc_common proc_common_v4_0
set_property -dict [ list LIBRARY $proc_common USED_IN {synthesis simulation} ] [add_files $repo_base/$proc_common/hdl/src/vhdl]

# axi_delay
set axi_delay axi_delay_lib
set_property -dict [ list LIBRARY $axi_delay USED_IN {synthesis simulation} ] [add_files $proj_base/hdl/vhdl/axi_delay_pkg.vhd $proj_base/hdl/vhdl/chan_delay.vhd $proj_base/hdl/vhdl/axi_delay.vhd]
set_property top axi_delay [current_fileset]

# test bench
set_property -dict [ list LIBRARY work USED_IN {simulation} ] [add_files -fileset sim_1 $proj_base/hdl/example/axi_blk_mem.vhd $proj_base/hdl/example/axi_delay_tb.vhd]
set_property top axi_delay_tb [get_filesets sim_1]
