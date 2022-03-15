class reset_sequence extends base_sequence;
    `uvm_object_utils(reset_sequence);

    function new(string name = "reset_sequence");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: reset_sequence

task reset_sequence::body();
    begin
        `uvm_info("RESET", "RESET Transaction STARTED", UVM_MEDIUM)
        `uvm_create(req);
        start_item(req);
        req.mode = RESET;
        req.reset_cycles = 2;
        finish_item(req);
        `uvm_info("RESET", "RESET Transaction ENDED", UVM_MEDIUM)
    end
endtask: body

