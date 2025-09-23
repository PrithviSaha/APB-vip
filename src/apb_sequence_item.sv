//`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "defines.svh"
  import uvm_pkg::*;

class apb_sequence_item extends uvm_sequence_item;
//  `uvm_object_utils(apb_sequence_item)

  rand logic transfer;
  rand logic [`ADDR_WIDTH:0] apb_write_paddr;
  rand logic [`ADDR_WIDTH:0] apb_read_paddr;
  rand logic [`DATA_WIDTH-1:0] apb_write_data;
  rand logic READ_WRITE;

  logic [`DATA_WIDTH-1:0] apb_read_data_out;
  logic PSLVERR;

  `uvm_object_utils_begin(apb_sequence_item)
    `uvm_field_int( READ_WRITE ,        UVM_ALL_ON )
    `uvm_field_int( apb_write_paddr ,   UVM_ALL_ON )
    `uvm_field_int( apb_read_paddr ,    UVM_ALL_ON )
    `uvm_field_int( apb_write_data ,    UVM_ALL_ON )
    `uvm_field_int( apb_read_data_out , UVM_ALL_ON )
    `uvm_field_int( PSLVERR ,           UVM_ALL_ON )
  `uvm_object_utils_end

//  constraint addr_msb_dist { 
//    apb_write_paddr[`ADDR_WIDTH] dist { 0 := 9, 1 := 1 };
    //apb_write_paddr[7:4] == 0;
//  }

//  constraint trnsfr_dist {
//    transfer dist { 0 := 1, 1 := 9 };
//  }

  function new(string name = "apb_sequence_item");
    super.new(name);
  endfunction
endclass

