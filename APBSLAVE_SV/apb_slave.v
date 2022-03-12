/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 04 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : VERILOG
*Description : APB slave DUT 
*Refrence : https://www.edaplayground.com/x/67
*           https://github.com/maomran/APB-Slave/blob/master/APB_Slave.v
*File Name : apb_slave.v
*File ID : 255396
*Modified by : #your name#
*/

`timescale 1ns/1ps
`define AWIDTH 8
`define DWIDTH 32

module apb_slave(clk,
                 rst,
                 p_sel,
                 p_en,
                 p_write,
                 addr,
                 rdata,
                 wdata,
                 p_ready);

    input clk,rst,p_sel,p_write,p_en;
    input       [`AWIDTH-1:0]   addr;
    input       [`DWIDTH-1:0]   wdata;
    output reg  [`DWIDTH-1:0]   rdata;
    output reg                  p_ready;

    reg [`DWIDTH-1:0] ram [0:2**`AWIDTH-1];
    integer i;

    always @(posedge clk , negedge rst) 
    begin
        if(!rst)
        begin
            p_ready <= 0;
            rdata   <= 0;
            for (i = 0; i < 2**`AWIDTH; i=i+1) ram[i] <= 0;
        end
        else if(p_sel && p_en)
        begin
            if(p_write == 1)    ram[addr] <= wdata;
            else                rdata <= ram[addr];
            p_ready <= 1;
        end
        else    p_ready <= 0;
    end
    
endmodule