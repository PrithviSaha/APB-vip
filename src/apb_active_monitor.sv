//`include "defines.svh"

class apb_input_monitor extends uvm_monitor;

  `uvm_component_utils(apb_input_monitor)
  virtual apb_if vif;
  apb_sequence_item seq_item;
  
  uvm_analysis_port#(apb_sequence_item) item_collected_in_port;   //port for coverage
    
  function new (string name = " apb_input_monitor", uvm_component parent);
    super.new(name, parent);
    item_collected_in_port = new("item_collected_in_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		seq_item = apb_sequence_item::type_id::create("seq_item"); 
		if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  

  task monitor();
 /*   repeat(4)
    @(posedge vif.PCLK);
    begin
    seq_item=apb_sequence_item ::type_id::create("seq_item",this);    
    *///capturing the signals
    seq_item.PRESETn = vif.mon_cb.PRESETn;    
    seq_item.transfer = vif.mon_cb.transfer; 
    seq_item.READ_WRITE = vif.mon_cb.READ_WRITE;  
    seq_item.apb_write_paddr = vif.mon_cb.apb_write_paddr;    
    seq_item.apb_read_paddr = vif.mon_cb.apb_read_paddr; 
    seq_item.apb_write_data = vif.mon_cb.apb_write_data;  
		item_collected_in_port.write(seq_item);
		//end
  endtask
  
  task run_phase(uvm_phase phase);
    forever begin
    monitor();
    end
  endtask 

endclass	
