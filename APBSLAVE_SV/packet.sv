/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 04 March 2022
*Project name : APB SLAVE Verification using SV
*Domain : SYSTEMVERILOG
*Description : APB slave Transaction Packet 
*Refrence : 
*File Name : packet.sv
*File ID : 841785
*Modified by : #your name#
*/

`define AWIDTH 8
`define DWIDTH 32
typedef enum {IDLE,RESET,STIMULUS} pkt_type;
class packet;
    rand bit [`AWIDTH-1:0] addr;
    rand bit [`DWIDTH-1:0] data;
    
    bit [`AWIDTH-1:0] addr_prev;
    bit [`DWIDTH-1:0] data_prev;
    
    pkt_type kind;
    bit [7:0] reset_cycles;
    
    extern constraint valid;
    extern function void post_randomize();
    extern virtual function void print();
    extern virtual function void copy(packet rhs);
    extern virtual function bit compare(input packet dut_pkt);
 
endclass: packet

constraint packet::valid 
{
    addr inside {[1:20]};
    data inside {[1:255]};
    addr  != addr_prev;
    data != data_prev;
}

function void packet::post_randomize();
    addr_prev = addr;
    data_prev = data;
endfunction: post_randomize

function void packet::copy(packet rhs);
    if (rhs==null) 
    begin
        $display("[Error]NULL handle passed to copy");
        $finish;    
    end
    this.addr   = rhs.addr;
    this.data  = rhs.data;
endfunction: copy

function void packet::print();
    $display("addr=%0d data=%0d",addr,data);
endfunction: print

function bit packet::compare(input packet dut_pkt);
    return ((this.data === dut_pkt.data) & (this.addr === dut_pkt.addr));
endfunction: compare
