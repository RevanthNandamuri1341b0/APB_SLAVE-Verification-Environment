/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 04 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Transaction Generator 
*Refrence : 
*File Name : packet.sv
*File ID : 841785
*Modified by : #your name#
*/

class generator;

    bit[31:0] pkt_count;
    packet ref_pkt;
    mailbox#(packet) mbx;
    
    function new(input mailbox#(packet) mbx,input bit[31:0] pkt_count);
        this.mbx = mbx;
        this.pkt_count = pkt_count;
        ref_pkt = new;
    endfunction: new
    
    extern virtual task run();

endclass: generator

task generator::run();
    bit[31:0] pkt_id;
//    $display("[GENERATOR] Run Started @time = %0t",$time);
    packet gen_pkt;
    gen_pkt = new;
    gen_pkt.kind = RESET;
    gen_pkt.reset_cycles = 3;
    mbx.put(gen_pkt);
    $display("[GENERATOR]: Sending %0s Packet %0d to Driver at time = %0t",gen_pkt.kind.name(),pkt_id,$time);
    repeat(pkt_count)
    begin
        pkt_id++;
        assert (ref_pkt.randomize());
        gen_pkt = new;
        gen_pkt.kind = STIMULUS;
        gen_pkt.copy(ref_pkt);
        mbx.put(gen_pkt);
        gen_pkt.print();
        $display("[GENERATOR]: Sending %0s Packet %0d to Driver at time = %0t",gen_pkt.kind.name(),pkt_id,$time);
    end
endtask: run

