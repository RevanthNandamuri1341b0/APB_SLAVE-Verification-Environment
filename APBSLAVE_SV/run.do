vlib work
vdel -all
vlib work
#vlog -f .list +acc
vlog apb_slave.v +acc
vlog testbench.sv +acc
vsim work.top
#vlog tb.sv +acc
#vsim work.tb_apb_slave
add wave -r *
#do wave.do
run -all
