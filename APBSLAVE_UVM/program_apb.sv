/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Sequence Base Class 
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : program_apb.sv
*File ID : 411713
*Modified by : #your name#
*/

`include "apb_package.pkg"
program program_apb(apb_if pif);
    import uvm_pkg::*;
    import apb_package::*;
    `include "base_test.sv"
    `include "main_test.sv"
    initial 
    begin
        $timeformat(-9, 1, "ns", 10);
        uvm_config_db#(virtual apb_if.tb)::set(null, "uvm_test_top", "master_if", pif.tb);
        uvm_config_db#(virtual apb_if.tb_mon)::set(null, "uvm_test_top", "mon_in", pif.tb_mon);
        uvm_config_db#(virtual apb_if.tb_mon)::set(null, "uvm_test_top", "mon_out", pif.tb_mon);
        run_test();
    end
endprogram:program_apb