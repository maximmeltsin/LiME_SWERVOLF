onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib sys_clk_mmcm_opt

do {wave.do}

view wave
view structure
view signals

do {sys_clk_mmcm.udo}

run -all

quit -force
