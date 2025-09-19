//`include "defines.svh"

class apb_driver extends uvm_driver #(apb_sequence_item);
  `uvm_component_utils(apb_driver)

  virtual apb_if.DRV vif;
  
  //uvm_analysis_port #(apb_sequence_item) item_collected_port;	//port for coverage
    
  function new (string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  //  item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(req);
    drive();
    seq_item_port.item_done();
    end
  endtask

 task drive();
    //driver logic here
  endtask

endclass
