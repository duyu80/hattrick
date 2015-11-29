onerror {resume}
quietly WaveActivateNextPane {} 0
#add wave -noupdate -expand -group tb_hattrick /tb_hattrick/*
add wave -noupdate -radix ascii /tb_hattrick/test
add wave -noupdate -group tb_hattrick /tb_hattrick/*
add wave -noupdate -group HATTRICK_TOP_INST /tb_hattrick/HATTRICK_TOP_INST/*
add wave -noupdate -group I2C_INS /tb_hattrick/HATTRICK_TOP_INST/I2C_INS/*
add wave -noupdate -group GPI0_INST /tb_hattrick/HATTRICK_TOP_INST/GPI0_INST/*
add wave -noupdate -group GPO1_INST /tb_hattrick/HATTRICK_TOP_INST/GPO1_INST/*
add wave -noupdate -group GPO2_INST /tb_hattrick/HATTRICK_TOP_INST/GPO2_INST/*
add wave -noupdate -group LED_CNT_INST /tb_hattrick/HATTRICK_TOP_INST/LED_CNT_INST/*
add wave -noupdate -group HEALTH_LED_INST /tb_hattrick/HATTRICK_TOP_INST/HEALTH_LED_INST/*
add wave -noupdate -group GPO3_INST /tb_hattrick/HATTRICK_TOP_INST/GPO3_INST/*
add wave -noupdate -group FAULT_LED_INST /tb_hattrick/HATTRICK_TOP_INST/FAULT_LED_INST/*
add wave -noupdate -group GPI4_INST /tb_hattrick/HATTRICK_TOP_INST/GPI4_INST/*
add wave -noupdate -group GPO5_INST /tb_hattrick/HATTRICK_TOP_INST/GPO5_INST/*
add wave -noupdate -group GPO6_INST /tb_hattrick/HATTRICK_TOP_INST/GPO6_INST/*
add wave -noupdate -group MINISAS_LED_INST /tb_hattrick/HATTRICK_TOP_INST/MINISAS_LED_INST/*
add wave -noupdate -group INTERRUPT_INST /tb_hattrick/HATTRICK_TOP_INST/INTERRUPT_INST/*
add wave -noupdate -group HDD_PWR_INST /tb_hattrick/HATTRICK_TOP_INST/HDD_PWR_INST/*
add wave -noupdate -group GPO_Pulse_INST /tb_hattrick/HATTRICK_TOP_INST/GPO_Pulse_INST/*
add wave -noupdate -group ENCLOSURE_LED_INST /tb_hattrick/HATTRICK_TOP_INST/ENCLOSURE_LED_INST/*

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3457351 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 156
configure wave -valuecolwidth 98
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {5857677 ns}
