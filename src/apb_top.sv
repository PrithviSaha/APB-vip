
`include "apb_defines.sv"
`include "apb_design.sv"
`include "apb_if.sv"
`include "apb_package.sv"
//`include "apb_assertion.sv"
import uvm_pkg::*;
import apb_pkg::*;

module top;

	bit PCLK = 0;

	//clock generation

	initial begin
		forever #5 PCLK = ~PCLK;
	end

	//virtual interface

	apb_if vif(PCLK);

	// connecting interface with design

	APB_Protocol dut(
		.PCLK(vif.PCLK),
		.PRESETn(vif.PRESETn),
		.transfer(vif.transfer),
		.apb_write_paddr(vif.apb_write_paddr),
		.apb_read_paddr(vif.apb_read_paddr),
		.apb_write_data(vif.apb_write_data),
		.READ_WRITE(vif.READ_WRITE),
		.apb_read_data_out(vif.apb_read_data_out),
		.PSLVERR(vif.PSLVERR)
	);

	//binding assertion
	/*
	bind vif apb_assertion ASSERT(
	.PCLK(vif.PCLK),
	.PRESETn(vif.PRESETn),
	.transfer(vif.transfer),
	.apb_write_paddr(vif.apb_write_paddr),
	.apb_read_paddr(vif.apb_read_paddr),
	.apb_write_data(vif.apb_write_data),
	.READ_WRITE(vif.READ_WRITE),
	.apb_read_data_out(vif.apb_read_data_out),
	.PSLVERR(vif.PSLVERR)
	);
	*/

	initial begin
		uvm_config_db#(virtual apb_if)::set(null,"*","vif",vif);
		$dumpfile("dump.vcd");
		$dumpvars;
	end

	initial begin
		run_test("apb_test");
		#1000 $finish;
	end
endmodule
