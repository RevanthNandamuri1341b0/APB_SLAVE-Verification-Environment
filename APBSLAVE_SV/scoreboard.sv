/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 08 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : Scoreboard to calculate Matches and MisMatches
*Refrence : 
*File Name : scoreboard.sv
*File ID : 613118
*Modified by : #your name#
*/

class scoreboard;

    packet ref_pkt,got_pkt;
    mailbox#(packet) mbx_in,mbx_out;
    bit[31:0] Total,m_matches,m_mismatches;

    function new(input mailbox#(packet) mbx_in,input mailbox#(packet) mbx_out);
        this.mbx_in = mbx_in;
        this.mbx_out = mbx_out;
    endfunction: new
    
    extern virtual task run();
    extern virtual function void report();

endclass: scoreboard

task scoreboard::run();
    $display("[Scoreboard] Run Started  @time = %0t",$time);
    while (1) 
    begin
        mbx_in.get(ref_pkt);
        mbx_out.get(got_pkt);
        Total++;
        $display("[Scoreboard] Packet %0d @time = %0t",Total,$time);
        if(ref_pkt.compare(got_pkt))
        begin
            m_matches++;
            $display("\n[Scoreboard] Packet %0d Matched @time = %0t",Total,$time);
            $display("[Scoreboard] *** Expected Packet to DUT****");
            ref_pkt.print();
            $display("[Scoreboard] *** Received Packet From DUT****");
            got_pkt.print();
        end
        else
        begin
            m_mismatches++;
            $display("\n[Scoreboard] Packet %0d Mismatched @time = %0t",Total,$time);
            $display("[Scoreboard] *** Expected Packet to DUT ***");
            ref_pkt.print();
            $display("[Scoreboard] *** Received Packet From DUT ***");
            got_pkt.print();
        end
    end
    $display("[Scoreboard] Run Ended  @time = %0t",$time);
endtask: run

function void scoreboard::report();
    $display("[Scoreboard] Report: Total Packets Received=%0d",Total); 
    $display("[Scoreboard] Report: Matches=%0d Mis_Matches=%0d",m_matches,m_mismatches);   
endfunction: report
