/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 21 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Main Sequence Derived Class 
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : main_sequence.sv
*File ID : 162449
*Modified by : #your name#
*/

class main_sequence extends base_sequence;
    `uvm_object_utils(main_sequence);

    function new(string name = "main_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();

endclass: main_sequence

task main_sequence::body();
    bit[31:0] count;
    REQ ref_pkt;
    ref_pkt = packet::type_id::create("ref_pkt",,get_full_name());
    repeat(item_count)
    begin
        `uvm_create(req);
        assert(ref_pkt.randomize());
        req.copy(ref_pkt);
        start_item(req);
        finish_item(req);
        count++;
        `uvm_info("SEQ",$sformatf("MASTER SEQUENCE : Transaction %0d DONE ",count ), UVM_MEDIUM);
    end
endtask: body
