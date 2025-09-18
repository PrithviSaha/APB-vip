class apb_passive_agent extends uvm_agent;
  apb_output_monitor mon_out;

  `uvm_component_utils(apb_passive_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_out = apb_output_monitor::type_id::create("mon_out", this);
  endfunction
endclass

           
