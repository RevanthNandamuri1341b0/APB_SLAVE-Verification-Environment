/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 04 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Test class that connects interfaces 
*Refrence : 
*File Name : test.sv
*File ID : 519214
*Modified by : #your name#
*/


`include "environment.sv"
class test;
    bit[31:0] no_of_pkts;
    virtual apb_if.tb_mod_port vif;
    virtual apb_if.tb_mon_in vif_mon_in;
    virtual apb_if.tb_mon_out vif_mon_out;

    environment env;

    function new(input virtual apb_if.tb_mod_port vif,
                 input virtual apb_if.tb_mon_in vif_mon_in,
                 input virtual apb_if.tb_mon_out vif_mon_out);
        
        this.vif = vif;
        this.vif_mon_in = vif_mon_in;
        this.vif_mon_out = vif_mon_out;
    
    endfunction: new
    
    extern virtual function void build();
    extern virtual task run();

endclass: test

function void test::build();
    env = new(vif,vif_mon_in,vif_mon_out,no_of_pkts);
    env.build();
endfunction: build

task test::run();
    $display("[Testcase] run Started at time=%0t",$time);
    no_of_pkts=10;
    build();
    env.run();
    $display("[Testcase] run Ended at time=%0t",$time);
endtask: run