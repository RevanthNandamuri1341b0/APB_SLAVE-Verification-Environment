program testbench(apb_if vif);
    `include "test.sv"
    test test1;
    initial 
    begin
        $display("[Program Block] Simulation Started at time=%0t",$time);
        test1=new(vif.tb_mod_port,vif.tb_mon_in,vif.tb_mon_out);
        test1.run();
        $display("[Program Block] Simulation Ended at time=%0t",$time);
    end
endprogram:testbench
`include "top.sv"