/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 22 March 2022
*Project name : Verification of Memory Model using RAL Verification
*Domain : UVM
*Description : APB slave Output Transaction Monitor
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : oMonitor.sv
*File ID : 862013
*Modified by : #your name#
*/

class oMonitor extends uvm_monitor;
    `uvm_component_utils(oMonitor);
    virtual apb_if.tb_mon vif;
    uvm_analysis_port#(packet) analysis_port;
    packet pkt;

    function new(string name = "oMonitor", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void build_phase(uvm_phase phase);
            
endclass: oMonitor

function void oMonitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if.tb_mon)::get(get_parent(), "", "oMon_if",vif))
    begin
        `uvm_fatal(get_type_name(), "out Monitor DUT interface NOT set-------------!")    
    end
    analysis_port=new("analysis_port",this);    
endfunction: build_phase

task oMonitor::run_phase(uvm_phase phase);
    forever 
    begin
        @(vif.mcb.rdata);
        if(vif.mcb.rdata === 'x || vif.mcb.rdata === 'z) continue;
        begin
            pkt = packet::type_id::create("pkt",this);
            pkt.addr = vif.mcb.addr;
            pkt.data = vif.mcb.rdata;
            `uvm_info(get_type_name(),pkt.convert2string(),UVM_MEDIUM);
            analysis_port.write(pkt);
        end
    end
endtask: run_phase

