/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 18 February 2022
*Project name : APB SLAVE IP 
*Domain : SYSTEMVERILOG
*Description : APB slave IP TestBench 
*Refrence : https://www.edaplayground.com/x/67
*           https://github.com/maomran/APB-Slave/blob/master/APB_Slave.v
            https://www.edaplayground.com/x/Axae
*File Name : tb.sv
*File ID : 745639
*Modified by : #your name#
*/


//`include "apb_slave.v"
`timescale 1ns/1ps
`define AWIDTH 8
`define DWIDTH 32
`define IDLE     2'b00
`define WRITE  2'b01
`define READ  2'b10
module tb_apb_slave;
    
    reg clk = 1; always #5 clk=~clk;
    reg rst = 0; 
    reg p_sel;
    reg p_en ;
    reg p_write;
    reg [`AWIDTH-1:0] addr;
    reg [`DWIDTH-1:0] wdata;
    wire [`DWIDTH-1:0] rdata;
    wire p_ready;
    
    apb_slave inst
    (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .rdata(rdata),
        .wdata(wdata),
        .p_sel(p_sel),
        .p_write(p_write),
        .p_en(p_en),
        .p_ready(p_ready)
    );


    // initial 
    // begin
    //     $dumpfile("tb_apb_slave.vcd");
    //     $dumpvars(0, tb_apb_slave);
    // end

    initial 
    begin
        repeat(3)@(posedge clk)
        rst = 1;
        p_sel = 1;
        p_en = 1;
        #10;
        Write;
        Read;
        @(posedge clk);
        p_write = 1;
        addr = 23;
        wdata = 55;
        @(posedge clk);
        // @(posedge clk);
        $display("[WRITE] addr %d, wdata %d  ",addr,wdata);
        p_write = 0;
        addr = 23;
        @(posedge clk);
        @(posedge clk);
        $display("[READ] addr %d, rdata %d  ",addr,rdata);
        #20;
        $finish;
    end

 
    integer i;
    integer j;

    task Write;
       for (i = 0; i < 10; i=i+1) 
       begin
            p_write = 1;
            addr = i;
            wdata = i+i;
            @(posedge clk); 
            @(posedge clk); 
            $display("[WRITE] addr %d, wdata %d  ",addr,wdata);
        end
       endtask
       
                
       task Read;
           for (j = 0;  j < 10; j = j+1) 
           begin
                p_write = 0;
                addr = j;
                @(posedge clk); 
                @(posedge clk); 
                $display("[READ] addr %d, rdata %d  ",addr,rdata);
            end
        endtask

endmodule