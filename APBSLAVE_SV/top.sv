`timescale 1ns/1ps
`define AWIDTH 8
`define DWIDTH 32

`include "apb_interface.sv"
module top;
    logic clk = 0;  always #5 clk=~clk;
    apb_if apb_if_inst(clk);
    apb_slave apb_slave_intf
    (
        .clk(clk),
        .rst(apb_if_inst.rst),
        .p_sel(apb_if_inst.p_sel),
        .p_en(apb_if_inst.p_en),
        .p_write(apb_if_inst.p_write),
        .addr(apb_if_inst.addr),
        .rdata(apb_if_inst.rdata),
        .wdata(apb_if_inst.wdata),
        .p_ready(apb_if_inst.p_ready)
    );
    testbench tb_inst(.vif(apb_if_inst));
    initial 
    begin
        $dumpfile("dump.vcd");
		$dumpvars(0);                   
    end
endmodule: top
