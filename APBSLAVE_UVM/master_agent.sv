/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 23 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Master Agent 
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : master_agent.sv
*File ID : 999937
*Modified by : #your name#
*/

class master_agent extends uvm_agent;
    `uvm_component_utils(master_agent);

    driver drvr;
    iMonitor iMon;
    sequencer seq;
    uvm_analysis_port#(packet) ap;

    function new(string name = "master_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass: master_agent

function void master_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap=new("ap",this);
    if(is_active == UVM_ACTIVE)
    begin
        seq  = sequencer::type_id::create("seq",this);
        drvr = driver::type_id::create("drvr",this);
    end
    iMon = iMonitor::type_id::create("iMon",this);
endfunction: build_phase

function void master_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)
    begin
        drvr.seq_item_port.connect(seq.seq_item_export);
    end
    iMon.analysis_port.connect(this.ap);
endfunction: connect_phase
