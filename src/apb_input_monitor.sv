//`include "defines.svh"

class apb_input_monitor extends uvm_monitor #(apb_sequence_item);
  `uvm_component_utils(apb_monitor)

  virtual apb_if.MON vif;
  apb_sequence_item seq_item;
  
  uvm_analysis_port #(apb_sequence_item) item_collected_port;   //port for coverage
    
  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

  endfunction
  

  task monitor();
    repeat(4)
    @(posedge vif.PCLK);
    begin
    seq_item=apb_sequence_item ::type_id::create("seq_item",this);    
    //capturing the signals
    seq_item.apb_write_paddr=vif.apb_write_paddr;    
    seq_item.apb_read_paddr=vif.apb_read_paddr; 
    seq_item.apb_write_data=vif.apb_write_data;  
    end
  endtask
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    monitor();
    end
  endtask 
