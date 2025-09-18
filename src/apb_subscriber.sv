`uvm_analysis_imp_decl(_pass_mon_cg)
`uvm_analysis_imp_decl(_act_mon_cg)

class apb_coverage extends uvm_component;
  `uvm_component_utils(apb_coverage)
  uvm_analysis_imp_act_mon_cg #(apb_sequence_item, apb_coverage) aport_mon1;
  uvm_analysis_imp_pass_mon_cg #(apb_sequence_item, apb_coverage) aport_mon2;
  apb_sequence_item mon1_trans, mon2_trans;
  real mon1_cov, mon2_cov;
  
  virtual apb_if vif;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_interface)::get(this, "", "vif", vif)) begin
      `uvm_info(get_type_name(), "vif not set in config_db for coverage yet — will try again later", UVM_LOW)
      `uvm_fatal(get_type_name(), "vif not set for alu_coverage");
    end
  endfunction
    
  
  covergroup active_mon_cov;

  endgroup
  
  covergroup pass_monitor_cov;
    
  endgroup
  
  
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    pass_monitor_cov = new;
    active_mon_cov = new;
    aport_mon1=new("aport_mon1", this);
    aport_mon2 = new("aport_mon2", this);
  endfunction
  
  function void write_act_mon_cg(apb_sequence_item t);
    if(t==null) begin
      `uvm_warning(get_type_name(), "Coverage got NULL transaction, skipping");
      return;
    end
    mon1_trans = t;
    active_mon_cov.sample();
  endfunction
  
  function void write_pass_mon_cg(apb_sequence_item t);
    mon2_trans = t;
    pass_monitor_cov.sample();
   
  endfunction
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    mon1_cov = active_mon_cov.get_coverage();
    mon2_cov = pass_monitor_cov.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[input] Coverage ------> %0.2f%%,", mon1_cov), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("[output] Coverage ------> %0.2f%%", mon2_cov), UVM_LOW);
  endfunction

endclass
