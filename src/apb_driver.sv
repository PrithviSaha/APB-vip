//`include "defines.svh"
class apb_driver extends uvm_driver #(apb_sequence_item);
  `uvm_component_utils(apb_driver)

  virtual apb_if vif;
  
 // uvm_analysis_port #(apb_sequence_item) item_collected_port;   //port for coverage
    
  function new (string name = "apb_driver", uvm_component parent );
    super.new(name, parent);
   // item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

  endfunction
  
  task send_to_interface();
    vif.transfer       <= req.transfer;
    vif.READ_WRITE     <= req.READ_WRITE;
    vif.apb_write_paddr <= req.apb_write_paddr;    
    vif.apb_read_paddr  <= req.apb_read_paddr;    
    vif.apb_write_data  <= req.apb_write_data;
  endtask
  
  task drive();
    //if (vif.PRESETn) begin
      send_to_interface();
/*
      if(req.apb_write_paddr === 8'bx || req.apb_read_paddr === 8'bx) begin
	repeat(1) @(posedge vif.drv_cb);
      end
*/
//      $display("DRIVER : W_ADDR = %h, R_ADDR = %h, READ_WRITE = %0b", req.apb_write_paddr, req.apb_read_paddr, req.READ_WRITE);
      repeat(3) @(posedge vif.drv_cb);
    //end
  endtask


  task run_phase(uvm_phase phase);
    repeat(3) @(posedge vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req);  
      drive();                          
      seq_item_port.item_done();        
    end
  endtask


endclass
