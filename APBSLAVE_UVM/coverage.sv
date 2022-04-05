/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 03 April 2022
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : APB slave Functional Coverage class
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : coverage.sv
*File ID : 485727
*Modified by : #your name#
*/

class coverage extends uvm_subscriber#(packet);
    `uvm_component_utils(coverage);

    real coverage_score;
    packet pkt;

    covergroup cg_apb_slave with function sample(packet pkt);
        coverpoint pkt.addr
        {
            bins small_addr  = {[0:(`AWIDTH-1)/4]};
            bins medium_addr = {[((`AWIDTH-1)/4)+1:(`AWIDTH-1)/2]};
            bins big_addr    = {[(`AWIDTH-1)/2:$]};
        } //addr
        coverpoint pkt.data
        {
            bins small_data  = {[0:(`DWIDTH-1)/4]};
            bins medium_data = {[((`DWIDTH-1)/4)+1:(`AWIDTH-1)/2]};
            bins big_data    = {[((`DWIDTH-1)/2)+1:$]};
        } //data
    endgroup: cg_apb_slave

    function new(string name = "coverage", uvm_component parent);
        super.new(name, parent);
        cg_apb_slave = new();
    endfunction: new

    extern virtual function void write(T t);
    extern virtual function void extract_phase(uvm_phase phase);
        
endclass: coverage

function void coverage::write(T t);
    if (!$cast(pkt, t.clone)) 
    begin
        `uvm_fatal("COV", "Transaction Object Supplied is NULL in Coverage component")        
    end
    cg_apb_slave.sample(pkt);
    coverage_score = cg_apb_slave.get_coverage();
    `uvm_info("COV",$sformatf("Coverage=%0f%%",coverage_score),UVM_MEDIUM);
endfunction: write

function void coverage::extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    uvm_config_db#(real)::set(null,"uvm_test_top.env","cov_score",coverage_score);
endfunction: extract_phase

