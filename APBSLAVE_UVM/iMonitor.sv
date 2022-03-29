/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 22 March 2022
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : APB slave Input Transaction Monitor
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : iMonitor.sv
*File ID : 973327
*Modified by : #your name#
*/

class iMonitor extends uvm_monitor;
    `uvm_component_utils(iMonitor);
    
    virtual apb_if.tb_mon vif;
    packet pkt;
    uvm_analysis_port#(packet) analysis_port;

    function new(string name = "iMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass: iMonitor

function void iMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_port = new("analysis_port",this);
endfunction: build_phase

function void iMonitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_if.tb_mon)::get(get_parent(), "", "iMon_if", vif))
    begin
        `uvm_fatal(get_type_name(), "in Monitor DUT interface NOT set-------------!")
    end
endfunction: connect_phase

task iMonitor::run_phase(uvm_phase phase);
    forever 
    begin
        @(vif.mcb.wdata);
        if(vif.mcb.p_write == 1)
        begin
            pkt = packet::type_id::create("pkt",this);
            pkt.addr = vif.mcb.addr;
            pkt.data = vif.mcb.wdata;
            `uvm_info(get_type_name(),pkt.convert2string(),UVM_MEDIUM);
            analysis_port.write(pkt);
        end
    end
endtask: run_phase
