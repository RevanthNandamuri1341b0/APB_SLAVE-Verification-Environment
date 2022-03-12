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

  clocking mcb_in @(posedge clk);
    input   p_sel,p_write,p_en;
    input   addr;
    input   wdata;
    input   p_ready;
  endclocking :mcb_in
  
  clocking mcb_out @(posedge clk);
    input   p_sel,p_write,p_en;
    input   addr;
    input   rdata;
    input   p_ready;
  endclocking :mcb_out

  modport tb_mod_port (clocking cb,output rst);
  modport tb_mon_in (clocking mcb_in);
  modport tb_mon_out (clocking mcb_out);

endinterface: apb_if
