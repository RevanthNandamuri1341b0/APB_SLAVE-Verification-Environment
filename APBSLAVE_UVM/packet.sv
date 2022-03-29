/*
*Author : Revanth Sai Nandamuri
*Portfolio : https://revanthnandamuri1341b0.github.io/
*Date of update : 15 March 2022
*Project name : APB SLAVE Verification using UVM
*Domain : UVM
*Description : APB slave Transaction Packet class
*Refrence : https://www.edaplayground.com/x/Cjzs
*File Name : packet.sv
*File ID : 550462
*Modified by : #your name#
*/
typedef enum {IDLE,RESET,STIMULUS} packet_type;
// typedef enum bit[1:0] {NOT_OK,OK,PENDING,ERROR} response_e;

class packet extends uvm_sequence_item;

    rand logic [`AWIDTH-1:0]addr;
    rand logic [`DWIDTH-1:0]data;

    bit [`AWIDTH-1:0]prev_addr;
    bit [`DWIDTH-1:0]prev_data;
    
    packet_type kind;
    bit[7:0] reset_cycles;
    // response_e status;

   `uvm_object_utils_begin(packet)
       `uvm_field_int(addr,UVM_ALL_ON)
       `uvm_field_int(data,UVM_ALL_ON)
   `uvm_object_utils_end


    extern constraint valid;
    extern function void post_randomize();
    extern virtual function string convert2string();
    
endclass: packet

constraint packet::valid 
{
    data inside {[10:999]};
    addr inside {[0:15]};
    addr != prev_addr;
    data != prev_data;
}

function void packet::post_randomize();
    prev_addr = addr;
    prev_data = data;
endfunction: post_randomize

function string packet::convert2string();
    return $sformatf("[%0s] |addr=%0d|data=%0d| \n",get_type_name(),this.addr,this.data);
endfunction: convert2string
