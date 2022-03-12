`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "iMonitor.sv"
`include "oMonitor.sv"
`include "scoreboard.sv"

class environment;
    generator   gen;
    driver      drvr;
    iMonitor    iMon;
    oMonitor    oMon;
    scoreboard  scb;

    bit[31:0] no_of_pkts;

    mailbox#(packet) mbx_gen_drvr;
    mailbox#(packet) mbx_iMon_scb;
    mailbox#(packet) mbx_oMon_scb;
    
    virtual apb_if.tb_mod_port  vif;    
    virtual apb_if.tb_mon_in    vif_mon_in;
    virtual apb_if.tb_mon_out   vif_mon_out;



    function new(input virtual apb_if.tb_mod_port vif,
                 input virtual apb_if.tb_mon_in   vif_mon_in,
                 input virtual apb_if.tb_mon_out  vif_mon_out,
                 input bit[31:0] no_of_pkts);
        
        this.vif = vif;
        this.vif_mon_in = vif_mon_in;
        this.vif_mon_out = vif_mon_out;
        this.no_of_pkts = no_of_pkts;
    
    endfunction: new

    extern virtual function void build();
    extern virtual task run();
    extern virtual function void report();

endclass: environment

function void environment::build();
    $display("[Environment] build Started at time=%0t",$time); 
    mbx_gen_drvr = new();
    mbx_iMon_scb = new();
    mbx_oMon_scb = new();

    gen  = new(mbx_gen_drvr,no_of_pkts);
    drvr = new(mbx_gen_drvr,vif);
    iMon = new(mbx_iMon_scb,vif_mon_in);
    oMon = new(mbx_oMon_scb,vif_mon_out);
    scb  = new(mbx_iMon_scb,mbx_oMon_scb);
    $display("[Environment] build Ended at time=%0t",$time); 
endfunction: build

task environment::run();
    $display("[Environment] run Started at time=%0t",$time);
    fork
        gen.run();
        drvr.run();
        iMon.run();
        oMon.run();
        scb.run();
    join_none
    wait(scb.Total==no_of_pkts);
    repeat(5)@(vif.cb);
    report();
    $display("[Environment] run Ended at time=%0t",$time); 
endtask: run

function void environment::report();
    $display("\n[Environment]===========[REPORT]=========== |Started|");
    iMon.report();
    oMon.report();
    scb.report();
    $display("\n------------------------------------------------");
    if((scb.m_mismatches == 0) & (no_of_pkts == scb.Total))
    begin
        $display("===================[TEST PASSED]===================");
        $display("  Matched = %0d",scb.m_matches);
        $display("  Mismatched = %0d",scb.m_mismatches);
        $display("===================================================");
    end
    else
    begin
        $display("===================[TEST FAILED]===================");
        $display("  Mismatched = %0d",scb.m_mismatches);
        $display("  EXPECTED Packets = %0d",no_of_pkts);
        $display("  RECEIVED Packets = %0d",scb.Total);
        $display("===================================================");    
    end
    $display("\n[Environment]===========[REPORT]=========== |Ended|");
endfunction: report
