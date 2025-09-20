class apb_environment extends uvm_env;
  apb_active_agent apb_agent_1;
  apb_passive_agent apb_agent_2;
  apb_scoreboard apb_scoreboard_1;
  apb_coverage apb_coverage_1;
  
  `uvm_component_utils(apb_environment)
  
  function new(string name = "apb_environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_agent_1 = apb_active_agent::type_id::create("apb_agent_1", this);
    apb_agent_2 = apb_passive_agent::type_id::create("apb_agent_2", this);
    apb_scoreboard_1 = apb_scoreboard::type_id::create("apb_scoreboard_1", this);
    apb_coverage_1 = apb_coverage::type_id::create("apb_coverage_1", this);
		set_config_int("apb_agent1","is_active",UVM_ACTIVE);
	  set_config_int("apb_agent2","is_active",UVM_PASSIVE);
	
	endfunction

  function void connect_phase(uvm_phase phase);  
		super.connect_phase(phase);
	 apb_agent_1.mon_in.item_collected_in_port.connect(apb_scoreboard_1.apb_input_scb_port);
   apb_agent_1.mon_in.item_collected_in_port.connect(apb_coverage_1.aport_ip_mon);
   apb_agent_2.mon_out.item_collected_out_port.connect(apb_scoreboard_1.apb_output_scb_port);
   apb_agent_2.mon_out.item_collected_out_port.connect(apb_coverage_1.aport_out_mon);
  endfunction
 
endclass
 
