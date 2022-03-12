/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 07 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Input Monitor
*Refrence : 
*File Name : iMonitor.sv
*File ID : 482788
*Modified by : #your name#
*/

class iMonitor;

    packet pkt;
    virtual apb_if.tb_mon_in vif;
    mailbox#(packet) mbx;
    bit [31:0] no_of_pkts_recvd;
    
    function new(input mailbox#(packet) mbx,input virtual apb_if.tb_mon_in vif);
        this.mbx = mbx;
        this.vif = vif;
    endfunction: new
    
    extern virtual task run();
    extern virtual function void report();

endclass: iMonitor

task iMonitor::run();
    $display("[iMon] Run Started @time = %0t",$time);
    forever 
    begin
        @(vif.mcb_in.wdata);
        if(vif.mcb_in.p_write == 1);
        begin
            no_of_pkts_recvd++;
            pkt = new;
            pkt.addr = vif.mcb_in.addr;
            pkt.data = vif.mcb_in.wdata;
            mbx.put(pkt);
            $display("[iMon] Sending Packet [%0d] to Scoreboard @time = %0t",no_of_pkts_recvd,$time);
            pkt.print();
            @(vif.mcb_in); 
            @(vif.mcb_in); 
        end
    end
    $display("[iMon] Run Ended @time = %0t",$time);
endtask: run

function void iMonitor::report();
    $display("[iMon] Total packets collected in Input Monitor is %0d @time = %0t",$time,no_of_pkts_recvd);
endfunction: report
