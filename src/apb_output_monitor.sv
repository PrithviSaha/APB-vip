//`include "defines.svh"

class apb_output_monitor extends uvm_monitor;
  `uvm_component_utils(apb_output_monitor)

  virtual apb_if.MON vif;
  apb_sequence_item seq_item;
  
  uvm_analysis_port#(apb_sequence_item) item_collected_out_port; 

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
    bit prev_sel_bit;
    repeat(1) @(posedge vif.mon_cb);
/*
    if(vif.mon_cb.apb_write_paddr[8] == ~prev_sel_bit) begin
      repeat(1) @(posedge vif.mon_cb);
    end
*/
    seq_item.apb_read_data_out = vif.mon_cb.apb_read_data_out;
    seq_item.PSLVERR = vif.mon_cb.PSLVERR;

/*
    if(vif.mon_cb.apb_write_paddr[8] == ~prev_sel_bit) begin
      repeat(1) @(posedge vif.mon_cb);
    end
*/
    prev_sel_bit = vif.mon_cb.apb_write_paddr[8]; 

    item_collected_out_port.write(seq_item);
    repeat(2) @(posedge vif.mon_cb);
  endtask
  
  task run_phase(uvm_phase phase);
    repeat(4) @(posedge vif.mon_cb);
    forever begin
    monitor();
    end
  endtask 

endclass
