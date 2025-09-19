`include "uvm_macros.svh"
`include "defines.svh"
`include "apb_package.sv"
`include "apb_if.sv"
`include "apb_assertion.sv"
`include "apb_design.sv"
import uvm_pkg::*;
import apb_package::*;
 
module top;
 
  bit PCLK = 0;
  bit PRESETn = 0;
  bit transfer = 0;
 
//clock generation
 
  initial begin
    forever #5 PCLK = ~PCLK;
  end
 
//reset generation
 
  initial begin
    PRESETn = 0;
    repeat(2) @(posedge PCLK);
    PRESETn = 1;
  end
 
//virtual interface
 
   apb_if vif(PCLK,PRESETn,transfer);
 
// connecting interface with design
 
   APB_DESIGN  dut(
    .PCLK(vif.PCLK),
    .PRESERTn(vif.PRESETn),
    .transfer(vif.transfer),
    .apb_write_paddr(vif.apb_write_paddr),
    .apb_read_paddr(vif.apb_read_paddr),
    .apb_write_data(vif.apb_write_data),
    .READ_WRITE(vif.READ_WRITE),
    .PSLVERR(vif.PSLVERR)
  );
 
//binding assertion
 
bind vif apb_assetion ASSERT(
    .PCLK(vif.PCLK),
    .PRESERTn(vif.PRESETn),
    .transfer(vif.transfer),
    .apb_write_paddr(vif.apb_write_paddr),
    .apb_read_paddr(vif.apb_read_paddr),
    .apb_write_data(vif.apb_write_data),
    .READ_WRITE(vif.READ_WRITE),
    .PSLVERR(vif.PSLVERR)
  );
 

  initial begin
 
    uvm_config_db#(virtual apb_if)::set(null,"*","vif",vif);
    $dumpfile("dump.vcd");
    $dumpvars;
 
  end
 
  initial begin
 
    run_test("apb_test");
 
      #100 $finish;
 
  end
endmodule
