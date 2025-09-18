`include "defines.svh"

interface apb_if(input logic PCLK, PRESETn, transfer);
  bit [`ADDR_WIDTH:0]	apb_write_paddr;  //Write Address
  bit [`ADDR_WIDTH:0] 	apb_read_paddr;	  //Read Address
  bit [`DATA_WIDTH-1:0] apb_write_data;   //Data      
  bit 			READ_WRITE;	  // 0: READ  1: WRITE
  
  bit [`DATA_WIDTH-1:0] apb_read_data_out;
  bit			PSLVERR;
  
  clocking drv_cb @(posedge PCLK);
    output apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE;
    input  apb_read_data_out, PSLVERR;
  endclocking: drv_cb

  clocking mon_cb @(posedge PCLK);
     input apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE, apb_read_data_out, PSLVERR;
  endclocking: mon_cb

  modport DRV(clocking drv_cb, input PCLK, PRESETn, transfer);
  modport MON(clocking mon_cb, input PCLK, PRESETn, transfer);

endinterface
