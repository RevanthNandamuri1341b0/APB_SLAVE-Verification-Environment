/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 04 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Environment Testbench class
*Refrence : 
*File Name : testbench.sv
*File ID : 108456
*Modified by : #your name#
*/

program testbench(apb_if vif);
    `include "test.sv"
    test test1;
    initial 
    begin
        $display("[Program Block] Simulation Started at time=%0t",$time);
        test1=new(vif.tb_mod_port,vif.tb_mon_in,vif.tb_mon_out);
        test1.run();
        $display("[Program Block] Simulation Ended at time=%0t",$time);
    end
endprogram:testbench
`include "top.sv"