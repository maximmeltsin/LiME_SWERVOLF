onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib riscv_local_ram_opt

do {wave.do}

view wave
view structure
view signals

do {riscv_local_ram.udo}

run -all

quit -force
