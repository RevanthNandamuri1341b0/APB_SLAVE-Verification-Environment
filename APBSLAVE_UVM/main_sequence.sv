class main_sequence extends base_sequence;
    `uvm_object_utils(main_sequence);

    function new(string name = "main_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();

endclass: main_sequence

task main_sequence::body();
    bit[31:0] count;
    REQ ref_pkt;
    ref_pkt = packet::type_id::create("ref_pkt",,get_full_name());
    repeat(item_count)
    begin
        `uvm_create(req);
        assert(ref_pkt.randomize());
        req.copy(ref_pkt);
        start_item(req);
        finish_item(req);
        get_response(req);
        count++
        `uvm_info("RW_SEQ",$sformatf("Transaction %0d Done with resp=%0s \n ",count,rsp.slv_rsp.name()),UVM_MEDIUM);
    end
endtask: body
