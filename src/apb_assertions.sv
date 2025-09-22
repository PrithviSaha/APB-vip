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


	property p1;
		@(posedge PCLK)
			!($isunknown(PRESETn) && $isunknown(transfer));
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
		transfer |=> ( $stable(READ_WRITE) && $stable(transfer));  
	endproperty

	stablity_of_global_signals:
	assert property(p3)
	$info("The global signals are stable for 2 cycles- Assertion 3 passed");
	else
		$error("Assertion 3 failed -global signals are not stble");

	property p4;
		@(posedge PCLK) disable iff(!PRESETn)
		transfer |-> (READ_WRITE==0) |=> ##1 !($isunknown(apb_read_data_out));
	endproperty

	data_out_check:
	assert property(p4)
	$info("Data out is not unknown - Assertion 4 passed");
	else
		$error("Assertion 4 failed - data out is unknown during read operation");


endinterface

