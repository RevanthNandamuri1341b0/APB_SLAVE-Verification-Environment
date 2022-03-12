onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate /top/apb_if_inst/clk
add wave -noupdate /top/apb_if_inst/rst
add wave -noupdate /top/apb_if_inst/p_sel
add wave -noupdate /top/apb_if_inst/p_en
add wave -noupdate /top/apb_if_inst/p_write
add wave -noupdate /top/apb_if_inst/addr
add wave -noupdate /top/apb_if_inst/wdata
add wave -noupdate /top/apb_if_inst/rdata
add wave -noupdate /top/apb_if_inst/p_ready
add wave -noupdate /top/apb_if_inst/cb/p_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {60248 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {555817 ps}
