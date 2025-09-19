class apb_active_agent extends uvm_agent;
	apb_driver drv;
	apb_sequencer seqr;
	apb_input_monitor mon_in;

	`uvm_component_utils(apb_active_agent)

	function new(string name = "apb_active_gent", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(get_is_active() == UVM_ACTIVE) begin
			drv = apb_driver::type_id::create("drv", this);
			seqr = apb_sequencer::type_id::create("seqr", this);
		end

		mon_in = apb_input_monitor::type_id::create("mon_in", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		//super.connect_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin
			drv.seq_item_port.connect(seqr.seq_item_export);
		end
	endfunction

endclass
