connect -url tcp:127.0.0.1:3121
source Z:/Projects/ASIC2/Vivado/LiME_RISCV_v3/LiME_RISCV_v3.sdk/ZC706_hw_platform/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-SMT2 210251A4553C"} -index 0
loadhw -hw Z:/Projects/ASIC2/Vivado/LiME_RISCV_v3/LiME_RISCV_v3.sdk/ZC706_hw_platform/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent JTAG-SMT2 210251A4553C"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent JTAG-SMT2 210251A4553C"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent JTAG-SMT2 210251A4553C"} -index 0
dow Z:/Projects/ASIC2/Vivado/LiME_RISCV_v3/LiME_RISCV_v3.sdk/test2/Debug/test2.elf
configparams force-mem-access 0
bpadd -addr &main
