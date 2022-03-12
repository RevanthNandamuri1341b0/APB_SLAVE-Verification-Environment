/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 04 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Transaction Driver 
*Refrence : 
*File Name : packet.sv
*File ID : 841785
*Modified by : #your name#
*/
class driver;
    
    packet pkt;
    virtual apb_if.tb_mod_port vif;
    mailbox#(packet) mbx;
    bit[31:0] no_of_pkts_recvd;
    function new(input mailbox#(packet) mbx,input virtual apb_if.tb_mod_port vif);
        this.mbx = mbx;
        this.vif = vif;
    endfunction: new
    
    extern virtual task run();
    extern virtual task drive(packet pkt);
    extern virtual task drive_reset(packet pkt);
    extern virtual task drive_stimulus(packet pkt);
    extern virtual task write(input packet pkt);
    extern virtual task read(input packet pkt);

endclass: driver

task driver::run();
    $display("[Driver] Run Started at time = %0t",$time);
    while (1) 
    begin
        mbx.get(pkt);
        $display("[Driver] Received %0s Packet From the generator at time = %0t",pkt.kind.name(),$time);
        drive(pkt);
        $display("[Driver] Driven %0s Packet to DUT at time = %0t",pkt.kind.name(),$time);
    end
endtask: run

task driver::drive(packet pkt);
    case (pkt.kind)
        RESET    : drive_reset(pkt); 
        STIMULUS : drive_stimulus(pkt); 
        default  : $display("[DRIVER ERROR] Invalid Packet received");
    endcase
endtask: drive

task driver::drive_reset(packet pkt);
    $display("[Driver] Started Driving Reset transaction into DUT at time=%0t",$time); 
    vif.rst <= 0;
    repeat(pkt.reset_cycles)@(vif.cb)
    vif.rst <= 1;
    $display("[Driver] Completed Driving Reset transaction into DUT at time=%0t",$time); 
endtask: drive_reset

task driver::write(input packet pkt);
    $display("[Driver] Started Driving [WRITE] [%0d] transaction into DUT at time=%0t",no_of_pkts_recvd,$time); 
    vif.cb.p_write  <= 1;
    vif.cb.addr     <= pkt.addr;
    vif.cb.wdata    <= pkt.data;
    @(vif.cb);
    // @(vif.cb);
    vif.cb.p_write  <= 'x;
    $display("[Driver] Ended Driving [WRITE] [%0d] transaction into DUT at time=%0t",no_of_pkts_recvd,$time);
    pkt.print();
    // $display("Address = %0d | Data = %0d",vif.cb.addr,vif.cb.wdata);
endtask: write

task driver::read(input packet pkt);
    $display("[Driver] Started Driving [READ] [%0d] transaction into DUT at time=%0t",no_of_pkts_recvd,$time); 
    vif.cb.p_write  <= 0;
    vif.cb.addr     <= pkt.addr;
    @(vif.cb);
    // @(vif.cb);
    vif.cb.p_write  <= 'x;
    pkt.data        = vif.cb.rdata;
    $display("[Driver] Started Driving [READ] [%0d] transaction into DUT at time=%0t",no_of_pkts_recvd,$time); 
    pkt.print();
endtask: read


task driver::drive_stimulus(packet pkt);
    no_of_pkts_recvd++;
    $display("[Driver] Started Driving Main transaction [%0d] into DUT at time=%0t",no_of_pkts_recvd,$time); 
    vif.cb.p_sel <= 1;
    vif.cb.p_en  <= 1;
    write(pkt);
    @(vif.cb);
    read(pkt);
    @(vif.cb);
    $display("[Driver] Ended Driving Main transaction [%0d] into DUT at time=%0t",no_of_pkts_recvd,$time); 
endtask: drive_stimulus
