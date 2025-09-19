//`include "defines.svh"

class apb_output_monitor extends uvm_monitor;
  `uvm_component_utils(apb_output_monitor)

  virtual apb_if vif;
  apb_sequence_item seq_item;
  
  uvm_analysis_port#(apb_sequence_item) item_collected_out_port;   //port for coverage

//new    
  function new (string name = " apb_output_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_out_port = new("item_collected_out_port", this);
  endfunction

//build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_item = apb_sequence_item::type_id::create("seq_item");
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  
  task monitor();
   /* repeat(4)
    @(posedge vif.PCLK);
    begin
//capturing the signals 
        seq_item.apb_read_data_out=vif.apb_read_data_out;
        seq_item.PSLVERR=vif.PSLVERR;
    end
	 */
  endtask
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    monitor();
    end
  endtask 

endclass
