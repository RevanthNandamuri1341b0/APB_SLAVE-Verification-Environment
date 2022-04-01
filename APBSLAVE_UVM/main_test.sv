/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 March 2022
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : APB slave Main Test class
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : main_test.sv
*File ID : 733431
*Modified by : #your name#
*/

class main_test extends base_test;
    `uvm_component_utils(main_test);

    uvm_cmdline_processor clp=uvm_cmdline_processor::get_inst();
    string count;

    bit[31:0]item_count;
    
    function new(string name = "main_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    // extern virtual function void end_of_elaboration_phase(uvm_phase phase);

endclass: main_test

function void main_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    clp.get_arg_value("+item_count=",count);
    item_count=count.atoi();
    uvm_config_db#(bit[31:0])::set(this,"env.m_agent.seq.*", "item_count", item_count);
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seq.reset_phase", "default_sequence", reset_sequence::get_type());
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.seq.main_phase", "default_sequence", main_sequence::get_type());
endfunction: build_phase

// function void main_test::end_of_elaboration_phase(uvm_phase phase);
//     super.end_of_elaboration_phase(phase);
//     uvm_root::get().print_topology();
// endfunction: end_of_elaboration_phase
