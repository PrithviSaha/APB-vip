interface apb_assertions(
	PCLK,
	PRESETn,
	transfer,
	READ_WRITE,
	apb_write_paddr,
	apb_read_paddr,
	apb_write_data,
	PSLVERR,
	apb_read_data_out
);

	input PCLK,
	PRESETn,
	transfer,
	READ_WRITE,
	apb_write_paddr,
	apb_read_paddr,
	apb_write_data,
	PSLVERR,
	apb_read_data_out;
/*
	property PRESETn_CHECK;
    		@(posedge PCLK) !PRESETn |-> (apb_read_data_out == 0);
  	endproperty
  	assert property(PRESETn_CHECK)
    		$info("RESET passed");
  	else begin
    		$error("RESET failed");
 	end
*/
	APB_deassert_PRESETn: assert property(@(posedge PCLK) ##2 PRESETn) 
		     else 
			$info("reset is applied");

	property p1;
		@(posedge PCLK)
		##1 !($isunknown(PRESETn) && $isunknown(transfer));
	endproperty

	unknown_value_check_1:
	assert property(p1)
		$info("All global signals are valid - Assertion 1 passed");
	else
		$error("Assertion 1 failed - signals have unknown value");
	
	property p2;
		@(posedge PCLK)
		transfer |-> !($isunknown(READ_WRITE) && $isunknown(apb_read_paddr) && $isunknown(apb_write_paddr) && $isunknown(apb_write_data))[*2];
	endproperty

	unknown_value_check_2:
	assert property(p2)
	$info("All signals are valid - Assertion 2 passed");
	else
		$error("Assertion 1 failed - signals have unknown value");

	property p3;
		@(posedge PCLK) disable iff(!PRESETn)
		( transfer && ( READ_WRITE == 0 || READ_WRITE == 1) |=>
		##1 (
		READ_WRITE == 0 &&
		apb_write_paddr == $past(apb_write_paddr,1) &&
		apb_write_data  == $past(apb_write_data, 1)
																						 )
		||
		(
		READ_WRITE == 1 &&
		apb_read_paddr  == $past(apb_read_paddr, 1)
		 )
		);
	endproperty

	stablity_of_global_signals:
	assert property(p3)
		$info("The global signals are stable for 2 cycles- Assertion 3 passed");
	else
		$error("Assertion 3 failed -global signals are not stble");

	property p4;
		@(posedge PCLK) disable iff(!PRESETn)
		!($isunknown(apb_read_data_out));
	endproperty

	data_out_check:
	assert property(p4)
		$info("Data out is not unknown - Assertion 4 passed");
	else
		$error("Assertion 4 failed - data out is unknown during read operation");
	
endinterface
