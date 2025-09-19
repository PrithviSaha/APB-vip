`uvm_analysis_imp_decl(_pass_mon_cg)
`uvm_analysis_imp_decl(_act_mon_cg)

class apb_coverage extends uvm_component;
  `uvm_component_utils(apb_coverage)
  uvm_analysis_imp_act_mon_cg #(apb_sequence_item, apb_coverage) aport_ip_mon;
  uvm_analysis_imp_pass_mon_cg #(apb_sequence_item, apb_coverage) aport_out_mon;
  apb_sequence_item ip_mon_trans, out_mon_trans;
  real ip_mon_cov, out_mon_cov;
  
  virtual apb_if vif;
  
  covergroup active_mon_cov;   
    TRANSFER : coverpoint ip_mon_trans.transfer{ bins transfer_bin[]  = {0,1}; }
    READ_WRITE: coverpoint ip_mon_trans.READ_WRITE{ bins read_write_bin[]  = {0,1}; }
    WRITE_ADDRESS: coverpoint ip_mon_trans.apb_write_paddr{ bins write_address_bin[]  = {[0:255]}; }
    READ_ADDRESS: coverpoint ip_mon_trans.apb_read_paddr{ bins read_address_bin[]  = {[0:255]}; }
    WRITE_DATA : coverpoint ip_mon_trans.apb_write_data{ bins write_data_bin[]  = {[0:127]}; }
    
    TRANSFER_X_READ_WRITE : cross TRANSFER , READ_WRITE;
    
  endgroup
  
  covergroup pass_monitor_cov;
    READ_DATA : coverpoint out_mon_trans.apb_read_data_out{ bins read_data_bin[]  = {[0:255]}; }
    SLAVE_ERR : coverpoint out_mon_trans.PSLVERR{ bins pslverr_bin[]  = {{0,1}; }
                                                 
  endgroup 
  
  function new(string name = "", uvm_component parent);
    super.new(name, parent);
    pass_monitor_cov = new;
    active_mon_cov = new;
    aport_ip_mon = new("aport_ip_mon", this);
    aport_out_mon = new("aport_out_mon", this);
  endfunction
  
  function void write_act_mon_cg(apb_sequence_item t);
    if(t==null) begin
      `uvm_warning(get_type_name(), "Coverage got NULL transaction, skipping");
      return;
    end
    ip_mon_trans = t;
    active_mon_cov.sample();
  endfunction
  
  function void write_pass_mon_cg(apb_sequence_item t);
    out_mon_trans = t;
    pass_monitor_cov.sample();
  endfunction
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    ip_mon_cov = active_mon_cov.get_coverage();
    out_mon_cov = pass_monitor_cov.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[input] Coverage ------> %0.2f%%,", ip_mon_cov), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("[output] Coverage ------> %0.2f%%", out_mon_cov), UVM_LOW);
  endfunction

endclass
