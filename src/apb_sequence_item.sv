`include "defines.svh"

class apb_sequence_item extends uvm_sequence_item;
  
  `uvm_object_utils(apb_sequence_item)

  rand bit 	[`ADDR_WIDTH:0] 	apb_write_paddr;    //Write Address
  rand bit 	[`ADDR_WIDTH:0] 	apb_read_paddr;		//Read Address
  rand bit 	[`DATA_WIDTH-1:0] 	apb_write_data;     //Data      
  rand bit 						READ_WRITE;			// 0: READ  1: WRITE
  
  bit [`DATA_WIDTH-1:0] apb_read_data_out;	//Output for Read data
  bit					PSLVERR;
  
  function new (string name = "apb_sequence_item");
    super.new(name);
  endfunction

  
endclass
