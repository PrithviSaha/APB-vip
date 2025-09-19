//`include "defines.svh"

interface apb_if(input logic PCLK);
	logic PRESETn, transfer;
  logic [`ADDR_WIDTH : 0 ]	apb_write_paddr;  //Write Address
  logic [`ADDR_WIDTH : 0 ] apb_read_paddr;	  //Read Address
  logic [`DATA_WIDTH - 1 : 0] apb_write_data;   //Data      
  logic  READ_WRITE;	  // 0: READ  1: WRITE
  
  logic [ `DATA_WIDTH - 1 : 0 ] apb_read_data_out;
  logic	PSLVERR;
  
  clocking drv_cb @(posedge PCLK);
		default input #1 output #1;
    output PRESETn , transfer , apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE;
   // input  apb_read_data_out, PSLVERR;
  endclocking: drv_cb

  clocking mon_cb @(posedge PCLK);
		default input #1 output #1;
    input PRESETn , transfer , apb_write_paddr, apb_read_paddr, apb_write_data, READ_WRITE ,
		       apb_read_data_out, PSLVERR;
  endclocking: mon_cb

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);

endinterface
