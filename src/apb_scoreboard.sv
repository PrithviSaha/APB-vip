//`include "defines.svh"
//TLM DECL Ports
`uvm_analysis_imp_decl(_apb_input_mon_scb)
`uvm_analysis_imp_decl(_apb_output_mon_scb)

class apb_scoreboard extends uvm_scoreboard;

	// handle decleration for apb_sequnce item using queues

	apb_sequence_item apb_input_mon_queue[$];
	apb_sequence_item apb_output_mon_queue[$];

	// monitor and reference results declaration for comparsion only
	logic [ ( `DATA_WIDTH - 1 ) + 1 : 0 ] monitor_results;
	logic [ ( `DATA_WIDTH - 1 ) + 1 : 0 ] reference_results;

	// mimicing the memory funactionlaity using register 	
	reg [ `DATA_WIDTH - 1 : 0 ] slave0 [ ( 2 ** `ADDR_WIDTH ) - 1 : 0 ];
	reg [ `DATA_WIDTH - 1 : 0 ] slave1 [ ( 2 ** `ADDR_WIDTH ) - 1 : 0 ];
  
	// declaring PSLVx and PADDR	in order to extract select slave bit 
	// and address bits from both apb_write_paddr and apb_read_paddr  
	logic PSLVx ; 
	logic [ `ADDR_WIDTH - 1 : 0 ] PADDR ;
	
	// declration for temporary reference outputs
	logic [ `DATA_WIDTH - 1 : 0 ] ref_apb_read_data_out ;
	logic ref_PSLVERR;

  // registering the apb_scoareboard to the factory
	`uvm_component_utils(apb_scoreboard)

	// analysis import declaration for both input_monitor and output_monitor	
	uvm_analysis_imp_apb_input_mon_scb#(apb_sequence_item, apb_scoreboard) apb_input_scb_port;
	uvm_analysis_imp_apb_output_mon_scb#(apb_sequence_item, apb_scoreboard) apb_output_scb_port;

	//------------------------------------------------------//
	//   Creating a New Constructor for APB_scoreboard      //  
	//------------------------------------------------------//

	function new(string name = "apb_scoreboard", uvm_component parent);
		super.new(name, parent);
		apb_input_scb_port  = new("apb_input_scb_port" , this);
		apb_output_scb_port = new("apb_output_scb_port", this); 
	endfunction

	//------------------------------------------------------//
	//   Captures the apb_output_monitor transaction and    //
	// temporary storing the outputs in the packet_1 queue  //   
	//------------------------------------------------------//

	function void write_apb_output_mon_scb(apb_sequence_item packet_1);
		apb_output_mon_queue.push_back(packet_1);
	endfunction

	//------------------------------------------------------//
	//    Captures the apb_input_monitor transaction and    //
	//   temporary storing the inputs in the packet_2 queue //   
	//------------------------------------------------------//

	function void write_apb_input_mon_scb(apb_sequence_item packet_2);
		apb_input_mon_queue.push_back(packet_2);
	endfunction

	//------------------------------------------------------//
	// Running the apb_reference model and comparison report//
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin
			fork
				begin
					// waiting when the apb_output_mon_queue has the transaction stored in the
					// queue and perform the extraction of outputs from the apb_output_monitor
					wait(apb_output_mon_queue.size() > 0);
					extract_outputs_from_apb_output_monitor();
				end
				begin
					// waiting when the apb_input_mon_queue has the transaction stored in the
					// queue and perform the extraction of inputs from the apb_input_monitor 
					wait(apb_input_mon_queue.size() > 0);
					extract_inputs_from_apb_input_monitor();
				end
			join
			// generate the comparsion report by comparing reference results 
			// and monitor results and displaying the test pass or fail
			comparision_report();
		end
	endtask

	//------------------------------------------------------//
	//           performs extraction of output bits         //
	//               from the apb_output_monitor            //
	//------------------------------------------------------//

	task extract_outputs_from_apb_output_monitor();
		apb_sequence_item packet_4;
		packet_4 = apb_output_mon_queue.pop_front();
		$display(" Monitor output : @ %0t \n APB_READ_DATA_OUT = %d | PSLVERR = %b " , 
               $time, packet_4.apb_read_data_out , packet_4.PSLVERR );
		monitor_results = { packet_4.apb_read_data_out, packet_4.PSLVERR };
		$display(" time : %t | monitor_results_stored   = %b", $time, monitor_results);
	endtask

	//------------------------------------------------------//
	//           performs extraction of input bits          //
	//               from the apb_input_monitor             //
	//------------------------------------------------------//

	task extract_inputs_from_apb_input_monitor();
		apb_sequence_item packet_3;
		packet_3 = apb_input_mon_queue.pop_front();
		$display(" Monitor input : @ %0t \n PRESETn = %b | transfer = %b | READ_WRITE = %b | apb_read_paddr = %d | apb_write_paddr = %d | apb_write_data = %d", $time, packet_3.PRESETn , packet_3.transfer , packet_3.READ_WRITE , packet_3.apb_read_paddr , packet_3.apb_write_paddr, packet_3.apb_write_data );
		apb_reference_model(packet_3);
	endtask

	//------------------------------------------------------//
	//         performs the apb reference model by          //
	//             mimicing its functionlaity               //
	//------------------------------------------------------//

	task apb_reference_model(input apb_sequence_item packet_3);

		// resetn condition
		if(packet_3.PRESETn == 0 )begin
			ref_apb_read_data_out = 'bz ;
			ref_PSLVERR = 'bz;
	
			for(int i = 0 ; i < ( 2 ** `ADDR_WIDTH ); i++ )
			begin
				slave0[i] = 'bx;
				slave1[i] = 'bx;
			end
		end

		// transfer condition
		else if(packet_3.transfer) begin
			ref_apb_read_data_out = 'bz ;
			ref_PSLVERR = 'bz; 

			if( packet_3.READ_WRITE ) 
				{ PSLVx , PADDR } = packet_3.apb_write_paddr;
      else                      
				{ PSLVx , PADDR } = packet_3.apb_read_paddr;
    
			if( PSLVx )
				//SLAVE1 Operation
				slave1_operation(packet_3,PADDR);
			else
				//SLAVE0 Opertion
				slave0_operation(packet_3,PADDR);
		end
		$display(" Reference output : @ %0t \n  APB_READ_DATA_OUT = %d | PSLVERR = %b ",
			         $time, ref_apb_read_data_out , ref_PSLVERR );
		reference_results = { ref_apb_read_data_out , ref_PSLVERR };
		$display(" time : %t | reference_results_stored = %b", $time, reference_results); 
	endtask

	//------------------------------------------------------//
	//         performs the SLAVE0 operation                //
	//------------------------------------------------------//

	task slave1_operation(input apb_sequence_item packet_3 , input logic PADDR );
		if( packet_3.READ_WRITE ) begin
			slave1[PADDR] = packet_3.apb_write_data;
		end
		else begin
			ref_apb_read_data_out = slave1[PADDR];
		end
	endtask

	//------------------------------------------------------//
	//           performs the SLAVE1 operation              //
	//------------------------------------------------------//

	task slave0_operation(input apb_sequence_item packet_3 , input logic PADDR);
		if( packet_3.READ_WRITE ) begin
			slave0[PADDR] = packet_3.apb_write_data;
		end
		else begin
			ref_apb_read_data_out = slave0[PADDR];
		end
	endtask

	//------------------------------------------------------//
	// performs the comparsion report by checking bit by    //
	// bit between the reference result and monitor results //   
	//------------------------------------------------------//

	task comparision_report();
		if( monitor_results === reference_results )
			$display("<-----------------------------PASS----------------------------->" );
		else
			$display("<-----------------------------FAIL----------------------------->" );
	endtask
endclass
