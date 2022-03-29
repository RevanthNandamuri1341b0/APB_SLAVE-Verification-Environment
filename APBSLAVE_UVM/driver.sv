/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 21 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Sequence Driver 
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : driver.sv
*File ID : 345722
*Modified by : #your name#
*/
class driver extends uvm_driver;
    `uvm_component_utils(driver);

    bit[31:0]pkt_id;
    virtual apb_if.tb vif;

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    extern virtual task run_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task write(input packet pkt);
    extern virtual task read(ref packet pkt);
    extern virtual task drive(packet pkt);
    extern virtual task drive_reset(packet pkt);
    extern virtual task drive_config(packet pkt);
    extern virtual task drive_stimulus(packet pkt);
    
endclass: driver

task driver::run_phase(uvm_phase phase);
    seq_item_port.get_next_item(req);
    pkt_id++;
    `uvm_info("DRIVER", $sformatf("Recieved Transaction packet %0s[%0d]",), UVM_NONE)
    drive(req);
    seq_item_port.item_done();
    `uvm_info("DRIVER", $sformatf("Sent Transaction packet %0s[%0d]"), UVM_NONE)
endtask: run_phase

function void driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual apb_if.tb)::get(get_parent(), "", "drvr_if", vif))
    begin
        `uvm_fatal("VIF_ERR_DRVR", "Virtual interface in DRIVER is NULL")
    end
endfunction: connect_phase

task driver::drive(packet pkt);
    case (pkt.kind)
        RESET   : drive_reset(pkt);
        STIMULUS: drive_stimulus(pkt);
        default : `uvm_error("DRIVER ERROR", "Invalid Packet Recieved")
    endcase
endtask: drive

task driver::write(input packet pkt);
    `uvm_info(get_full_name(), "WRITE Transaction Started", UVM_HIGH)
    vif.cb.p_write  <= 1;
    vif.cb.addr     <= pkt.addr;
    vif.cb.wdata    <= pkt.data;
    @(vif.cb);
    vif.cb.p_write  <= 'x;
    `uvm_info(get_full_name(), "WRITE Transaction Ended", UVM_HIGH)
    `uvm_info(get_full_name(), $sformatf("Address = %0d | Data = %0d",vif.cb.addr,vif.cb.wdata), UVM_MEDIUM)
endtask: write

task driver::read(ref packet pkt);
    `uvm_info(get_full_name(), "READ Transaction Started", UVM_HIGH)
    vif.cb.p_write  <= 0;
    vif.cb.addr     <= pkt.addr;
    @(vif.cb);
    // @(vif.cb);
    vif.cb.p_write  <= 'x;
    pkt.data        = vif.cb.rdata;
    `uvm_info(get_full_name(), "READ Transaction Ended", UVM_HIGH)
    `uvm_info(get_full_name(), $sformatf("Address = %0d | Data = %0d",vif.cb.addr,vif.cb.wdata), UVM_MEDIUM)
endtask: read

task driver::drive_reset(packet pkt);
    `uvm_info(get_type_name(),"Reset transaction started...",UVM_FULL);
    vif.rst<=1;
    repeat(2)@(vif.cb);
    vif.rst<=0;
    `uvm_info(get_type_name(),"Reset transaction ended ",UVM_HIGH);
endtask: drive_reset


task driver::drive_stimulus(packet pkt);
    vif.cb.p_sel <= 1;
    vif.cb.p_en  <= 1;
    write(pkt);
    @(vif.cb);
    read(pkt);
    @(vif.cb);
endtask: drive_stimulus