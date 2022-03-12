/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 08 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Output Monitor
*Refrence : 
*File Name : oMonitor.sv
*File ID : 242703
*Modified by : #your name#
*/

class oMonitor;

    packet pkt;
    virtual apb_if.tb_mon_out vif;
    mailbox#(packet) mbx;
    bit[31:0] no_of_pkts_recvd;

    function new(input mailbox#(packet) mbx,input virtual apb_if.tb_mon_out vif);
        this.mbx = mbx;
        this.vif = vif;
    endfunction: new
    
    extern virtual task run();
    extern virtual function void report();
endclass: oMonitor

task oMonitor::run();
    $display("[oMon] Run Started @time = %0t",$time);
    forever 
    begin
        @(vif.mcb_out.rdata);
        if(vif.mcb_out.rdata==='x || vif.mcb_out.rdata==='z) continue;
        if(vif.mcb_out.p_write == 0)
        begin
            no_of_pkts_recvd++;
            pkt = new;
            pkt.addr = vif.mcb_out.addr;
            pkt.data = vif.mcb_out.rdata;
            mbx.put(pkt);
            $display("[oMon] Sending Packet [%0d] to Transaction @time = %0t",no_of_pkts_recvd,$time);
            pkt.print();
            @(vif.mcb_out); 
            @(vif.mcb_out);
        end
    end
    $display("[oMon] Run Ended @time = %0t",$time);
endtask: run

function void oMonitor::report();
    $display("[oMon] Total packets collected in Input Monitor is %0d @time = %0t",$time,no_of_pkts_recvd);
endfunction: report