//`include "defines.svh"

class apb_sequence_item extends uvm_sequence_item;
  
  rand logic PRESETn, transfer;
  rand logic [ `ADDR_WIDTH : 0 ] apb_write_paddr;    //Write Address
  rand logic [ `ADDR_WIDTH : 0 ] apb_read_paddr;		//Read Address
  rand logic [ `DATA_WIDTH - 1 : 0 ] apb_write_data;     //Data      
  rand logic READ_WRITE;			// 0: READ  1: WRITE
  
  logic [ `DATA_WIDTH - 1 : 0 ] apb_read_data_out;	//Output for Read data
  logic	PSLVERR;

  `uvm_object_utils_begin(apb_sequence_item)
  `uvm_field_int( PRESETn ,           UVM_ALL_ON )
	`uvm_field_int( transfer ,          UVM_ALL_ON )
	`uvm_field_int( READ_WRITE ,        UVM_ALL_ON )
	`uvm_field_int( apb_write_paddr ,   UVM_ALL_ON )
	`uvm_field_int( apb_read_paddr ,    UVM_ALL_ON )
	`uvm_field_int( apb_write_data ,    UVM_ALL_ON )
	`uvm_field_int( apb_read_data_out , UVM_ALL_ON )
	`uvm_field_int( PSLVERR ,           UVM_ALL_ON )
	`uvm_object_utils_end

  function new (string name = "apb_sequence_item");
    super.new(name);
  endfunction

endclass
