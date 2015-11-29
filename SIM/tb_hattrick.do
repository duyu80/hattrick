vdel -all -lib work
vlib work

vlog  -work work tb_hattrick.v
vlog  -work work wb_master.v
vlog  -work work i2c_master_wb_top.v
vlog  -work work i2c_master_bit_ctrl.v
vlog  -work work i2c_master_byte_ctrl.v
vlog  -work work i2c_master_defines.v
vlog  -work work i2c_master_registers.v
vlog  -work work DELAY.v
vlog  -work work ../SRC/hattrick_define.v
vlog  -work work ../SRC/HATTRICK.v
vlog  -work work ../SRC/I2C.v
vlog  -work work ../SRC/GPI.v
vlog  -work work ../SRC/GPO.v
vlog  -work work ../SRC/LED.v
vlog  -work work ../SRC/LED_CNT.v
vlog  -work work ../SRC/INTERRUPT.v
vlog  -work work ../SRC/HDD_PWR.v
vlog  -work work ../SRC/GPO_Pulse.v
vlog  -work work ../SRC/EnclosureLED.v

#Load the design. Use required libraries.#
#vsim -t ns -novopt +notimingchecks work.tb_hattrick
vsim -t ns -novopt -voptargs="+acc" -lib work work.tb_hattrick
#Log all the objects in design. These will appear in .wlf file#
#log -r /*

do {hattrick_wave.do}
run -all
