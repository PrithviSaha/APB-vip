class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	apb_environment apb_env;

	function new(string name="base_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_env = apb_environment::type_id::create("apb_env", this);
	endfunction

	// End of elaboration
	function void end_of_elaboration();
		//    super.end_of_elaboration();
		uvm_top.print_topology();
	endfunction

endclass

///////////////////////////////////////////////////////////////
// write test
class write_test extends base_test;

	`uvm_component_utils(write_test)

	function new(string name = "write_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		write_seq seq;
		phase.raise_objection(this);
		seq = write_seq::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask

endclass

//////////////////////////////////////////////////////////
//read test
class read_test extends base_test;

	`uvm_component_utils(read_test)

	function new(string name = "read_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		read_seq seq;
		phase.raise_objection(this);
		seq = read_seq::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask

endclass

///////////////////////////////////////////////////////////////
// write - read transfer for slave1 test
class wr_seq_slave1_test extends base_test;

	`uvm_component_utils(wr_seq_slave1_test)

	function new(string name = "wr_seq_slave1_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		wr_seq_slave1 seq;
		phase.raise_objection(this);
		seq = wr_seq_slave1::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask

endclass

//////////////////////////////////////////////////////////
//write - read transfer for slave2 test
class wr_seq_slave2_test extends base_test;

	`uvm_component_utils(read_test)

	function new(string name = "wr_seq_slave1_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		wr_seq_slave2 seq;
		phase.raise_objection(this);
		seq = wr_seq_slave2::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask

endclass

//////////////////////////////////////////////////////////

// write - read transfer for slave1 test
class mid_break_transfer_test extends base_test;

	`uvm_component_utils(mid_break_transfer_test)

	function new(string name = "mid_break_transfer_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		mid_break_transfer seq;
		phase.raise_objection(this);
		seq = mid_break_transfer::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask

endclass

//////////////////////////////////////////////////////////
//write - read transfer for slave2 test
class no_transfer_test extends base_test;

	`uvm_component_utils(no_transfer_test)

	function new(string name = "no_transfer_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		no_transfer seq;
		phase.raise_objection(this);
		seq = no_transfer::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask

endclass

//////////////////////////////////////////////////////////

//regression test
class regression_test extends base_test;

	`uvm_component_utils(regression_test)

	function new(string name = "regression_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		uvm_objection phase_done = phase.get_objection();
		regression_seq seq;
		phase.raise_objection(this);
		seq = regression_seq::type_id::create("seq");
		seq.start(apb_env.apb_agent_1.seqr);
		phase.drop_objection(this);
		//phase_done.set_drain_time(this,20);
	endtask
endclass
