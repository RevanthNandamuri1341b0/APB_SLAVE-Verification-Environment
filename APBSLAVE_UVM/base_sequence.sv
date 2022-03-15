class base_sequence extends uvm_sequence#(packet);
    `uvm_object_utils(base_sequence);
    bit[31:0] item_count;
    function new(string name = "base_sequence");
        super.new(name);
        set_automatic_phase_objection(1);//uvm 1.2 onwards
    endfunction: new

    extern virtual task pre_start();
    extern virtual task body();
    
endclass: base_sequence

task base_sequence::pre_start();
    if(!uvm_config_db#(bit[31:0])::get(this.get_full_name(), "", "item_count", item_count))
    begin
        `uvm_warning(get_full_name(),"Packet count is not set hence generating 1 transaction")
        item_count = 6;
    end
endtask: pre_start

task base_sequence::body();
    `uvm_do(req);
endtask: body
