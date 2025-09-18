
class apb_environment extends uvm_env;
  apb_active_agent apb_agent_1;
  apb_passive_agent apb_agent_2;
  apb_scoreboard apb_scoreboard_1;
  apb_coverage apb_coverage_1;
  
  `uvm_component_utils(apb_environment)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_agent_1 = apb_active_agent::type_id::create("apb_agent_1", this);
    apb_agent_2 = apb_passive_agent::type_id::create("apb_agent_2", this);
    apb_scoreboard_1 = apb_scoreboard::type_id::create("apb_scoreboard_1", this);
    apb_coverage_1 = apb_coverage::type_id::create("apb_coverage_1", this);
  endfunction
 
  function void connect_phase(uvm_phase phase);  
    apb_agent_1.mon_in.ap.connect(apb_scoreboard_1.mon1_imp);
    apb_agent_2.mon_out.ap.connect(apb_scoreboard_1.mon2_imp);
    apb_agent_1.mon_in.ap.connect(apb_coverage_1.aport_mon1);
    apb_agent_2.mon_out.ap.connect(apb_coverage_1.aport_mon2);
  endfunction

endclass
