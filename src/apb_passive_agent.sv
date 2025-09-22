class apb_passive_agent extends uvm_agent;
  `uvm_component_utils(apb_passive_agent)

  apb_output_monitor mon_out;

  function new(string name = "apb_passive_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE) begin
      mon_out = apb_output_monitor::type_id::create("mon_out", this);
    end
  endfunction
endclass

