/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 28 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Interface Module
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : apb_if.sv
*File ID : 749683
*Modified by : #your name#
*/


`define AWIDTH 8
`define DWIDTH 32

interface apb_if(input logic clk);
    logic               rst;
    logic               p_sel;
    logic               p_en;
    logic               p_write;
    logic [`AWIDTH-1:0] addr;
    logic [`DWIDTH-1:0] wdata;
    wire  [`DWIDTH-1:0] rdata;
    wire                p_ready;

   clocking cb @(posedge clk);
    output  p_sel,p_write,p_en;
    output  addr;
    output  wdata;
    input   rdata;
    input   p_ready;
   endclocking :cb

  clocking mcb @(posedge clk);
    input   p_sel,p_write,p_en;
    input   addr;
    input   wdata;
    input   rdata;
    input   p_ready;
  endclocking :mcb
  
  modport tb (clocking cb,output rst);
  modport tb_mon (clocking mcb);

endinterface: apb_if
