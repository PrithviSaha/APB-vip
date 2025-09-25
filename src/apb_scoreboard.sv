`uvm_analysis_imp_decl(_in_mon_scb)
`uvm_analysis_imp_decl(_out_mon_scb)

class apb_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(apb_scoreboard)
  
  logic [7:0] mem [0:511];
  int PASS, FAIL;
  logic [7:0] prev_data;
  apb_sequence_item inp_q[$];	//input item queue
  apb_sequence_item out_q[$];	//output item queue
  
  uvm_analysis_imp_out_mon_scb #(apb_sequence_item, apb_scoreboard) out_mon_port;
  uvm_analysis_imp_in_mon_scb #(apb_sequence_item, apb_scoreboard) inp_mon_port;
  
  apb_sequence_item inp_mon_item, out_mon_item;
  virtual apb_if vif;
  
  
  function new(string name = "apb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    out_mon_port = new("out_mon_port", this);
    inp_mon_port = new("inp_mon_port", this);
  endfunction
  
  function void write_in_mon_scb(apb_sequence_item t);
    inp_q.push_back(t);
  endfunction
  
  function void write_out_mon_scb(apb_sequence_item t);
    out_q.push_back(t);
  endfunction
  
  task compare(apb_sequence_item inp_item, apb_sequence_item out_item);
    if(inp_item.transfer) begin
      if(inp_item.READ_WRITE == 0) begin
        mem[inp_item.apb_write_paddr] = inp_item.apb_write_data;
//      $display("mem stored = 0x%0h at 0x%0h", mem[inp_item.apb_write_paddr], inp_item.apb_write_paddr);
        `uvm_info("SCOREBOARD", $sformatf("WRITE: Addr=0x%0h Data=0x%0h, transfer = %b",
          inp_item.apb_write_paddr, inp_item.apb_write_data, inp_item.transfer), UVM_MEDIUM); 
      end
      else begin
	prev_data = out_item.apb_read_data_out;
      	`uvm_info("SCOREBOARD", $sformatf("READ: Addr=0x%0h Data=0x%0h, transfer = %b",
        inp_item.apb_read_paddr, out_item.apb_read_data_out, inp_item.transfer), UVM_MEDIUM);
      	if(out_item.apb_read_data_out == mem[inp_item.apb_read_paddr]) begin
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          PASS++;
        end
        else begin
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          `uvm_info(get_type_name(), "----           TEST FAIL           ----", UVM_NONE)
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          FAIL++;
        end
      end
    end
    else begin
      if(inp_item.READ_WRITE == 1) begin
        `uvm_info("SCOREBOARD", $sformatf("READ: Addr=0x%0h Data=0x%0h, transfer = %b",
          inp_item.apb_read_paddr, prev_data, inp_item.transfer), UVM_MEDIUM);
        if(out_item.apb_read_data_out == prev_data) begin
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          PASS++;
        end
        else begin
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          `uvm_info(get_type_name(), "----           TEST FAIL           ----", UVM_NONE)
          `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          FAIL++;
        end
      end
    end
  endtask
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      wait(out_q.size() > 0 && inp_q.size() > 0);
      inp_mon_item = inp_q.pop_front();
      out_mon_item = out_q.pop_front();
      compare(inp_mon_item, out_mon_item);
    end
  endtask
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("Passes = %0d | Fails = %0d", PASS, FAIL);
  endfunction

endclass
