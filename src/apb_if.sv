`include "defines.svh"

interface apb_if(input logic PCLK, PRESETn);
  logic transfer;
  logic [`ADDR_WIDTH : 0 ]		apb_write_paddr;  //Write Address
  logic [`ADDR_WIDTH : 0 ] 		apb_read_paddr;	  //Read Address
  logic [`DATA_WIDTH - 1 : 0] 	apb_write_data;   //Data      
  logic  READ_WRITE;	  // 0: READ  1: WRITE
  
  logic [`DATA_WIDTH - 1 : 0] apb_read_data_out;
  logic	PSLVERR;
  
  clocking drv_cb @(posedge PCLK);
		default input #0 output #0;
    output transfer , apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE;
    input  apb_read_data_out, PSLVERR;
  endclocking

  clocking mon_cb @(posedge PCLK);
		default input #0 output #0;
    input transfer , apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE, apb_read_data_out, PSLVERR;
  endclocking

  modport DRV(clocking drv_cb, input PCLK, PRESETn);
    modport MON(clocking mon_cb, input PCLK, PRESETn);

endinterface
