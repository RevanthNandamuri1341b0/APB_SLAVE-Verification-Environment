/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 March 2022
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : APB slave Base Test class
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : base_test.sv
*File ID : 554995
*Modified by : #your name#
*/

class base_test extends uvm_component;
    `uvm_component_utils(base_test);

    environment env;
    virtual apb_if.tb mvif;
    virtual apb_if.tb_mon vif_min;
    virtual apb_if.tb_mon vif_mout;

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);

endclass: base_test

function void base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=environment::type_id::create("env",this);

    uvm_config_db#(virtual apb_if.tb)::get(this, "", "master_if", mvif);
    uvm_config_db#(virtual apb_if.tb_mon)::get(this, "", "mon_in", vif_min);
    uvm_config_db#(virtual apb_if.tb_mon)::get(this, "", "mon_out", vif_mout);

    uvm_config_db#(virtual apb_if.tb)::set(this, "env.m_agent", "drvr_if", mvif);
    uvm_config_db#(virtual apb_if.tb_mon)::set(this, "env.m_agent", "iMon_if", vif_min);
    uvm_config_db#(virtual apb_if.tb_mon)::set(this, "env.s_agent", "oMon_if", vif_mout);
    
    uvm_config_db#(bit[31:0])::set(this, "env.m_agent.seq", "item_count", 20);
    
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seq.main_phase", "default_sequence", base_sequence::get_type());
    
endfunction: build_phase

task base_test::main_phase(uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);
    objection=phase.get_objection();
    objection.set_drain_time(this,100ns);
endtask: main_phase

