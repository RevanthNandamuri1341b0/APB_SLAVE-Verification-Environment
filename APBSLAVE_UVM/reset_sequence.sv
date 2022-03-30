/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 21 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Reset Sequence derived Class 
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : reset_sequence.sv
*File ID : 132939
*Modified by : #your name#
*/

class reset_sequence extends base_sequence;
    `uvm_object_utils(reset_sequence);

    function new(string name = "reset_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: reset_sequence

task reset_sequence::body();
    begin
        `uvm_info("RESET", "RESET Transaction STARTED", UVM_MEDIUM)
        `uvm_create(req);
        req.kind = RESET;
        req.reset_cycles = 2;
        start_item(req);
        finish_item(req);
        `uvm_info("RESET", "RESET Transaction ENDED", UVM_MEDIUM)
    end
endtask: body

