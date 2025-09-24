class apb_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_sequence)
  
  function new(string name = "apb_sequence");
     super.new(name);
   endfunction
    
   virtual task body();
     repeat(4) begin
       req = apb_sequence_item::type_id::create("req");
       wait_for_grant();
       req.randomize();
       send_request(req);
       wait_for_item_done();
     end
   endtask
    
endclass

/////////////////////////////////////////////////////////////////

class write_seq extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(write_seq)
   
  function new(string name = "write_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (`N) begin
      `uvm_do_with(req, {req.READ_WRITE == 0;})
    end
  endtask
endclass

/////////////////////////////////////////////////////////////////

class read_seq extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(read_seq)
   
  function new(string name = "read_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (`N) begin
      `uvm_do_with(req, {req.READ_WRITE == 1;})
    end
  endtask
endclass

/////////////////////////////////////////////////////////////////
//slave 1 selection

class wr_seq_slave1 extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(wr_seq_slave1)
  
  bit [8:0] read_addr;
   //logic t;
  function new(string name = "wr_seq_slave1");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (`N) begin
      `uvm_do_with(req, {req.READ_WRITE == 0; req.transfer == 1; 
                         req.apb_write_paddr inside {[0:255]};})
      //req.apb_write_paddr.rand_mode(0);
      read_addr = req.apb_write_paddr;
      //t = req.transfer;
      `uvm_do_with(req, {req.READ_WRITE == 1; req.transfer == 1; 
	req.apb_read_paddr == read_addr;})
      //req.apb_write_paddr.rand_mode(1);
    end
  endtask
endclass


/////////////////////////////////////////////////////////////////

//slave 2  selection

class wr_seq_slave2 extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(wr_seq_slave2)
  
  bit [8:0] read_addr;
   //logic t;
  function new(string name = "wr_seq_slave2");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (`N) begin
      `uvm_do_with(req, {req.READ_WRITE == 0; req.transfer == 1; 
                         req.apb_write_paddr inside {[256:511]};})
      //req.apb_write_paddr.rand_mode(0);
      read_addr = req.apb_write_paddr;
      //t = req.transfer;
      `uvm_do_with(req, {req.READ_WRITE == 1; req.transfer == 1; 
	req.apb_read_paddr == read_addr;})
      //req.apb_write_paddr.rand_mode(1);
    end
  endtask
endclass


/////////////////////////////////////////////////////////////////

class mid_break_transfer extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(mid_break_transfer)
  
  bit [8:0] read_addr;
   //logic t;
  function new(string name = "mid_break_transfer");
    super.new(name);
  endfunction
  
  virtual task body();
   // repeat (`N) begin
      `uvm_do_with(req, {req.READ_WRITE == 0; req.transfer == 1; 
                         req.apb_write_paddr inside {[0:10]};})
      //req.apb_write_paddr.rand_mode(0);
      read_addr = req.apb_write_paddr;
      //t = req.transfer;
      `uvm_do_with(req, {req.READ_WRITE == 1; req.transfer == 1; 
	                       req.apb_read_paddr == read_addr;})
      
      `uvm_do_with(req, {req.READ_WRITE == 0; req.transfer == 0; 
                         req.apb_write_paddr == 1;})
      //req.apb_write_paddr.rand_mode(0);
      read_addr = req.apb_write_paddr;
      //t = req.transfer;
      `uvm_do_with(req, {req.READ_WRITE == 1; req.transfer == 0; 
	                       req.apb_read_paddr == read_addr;})
      

      `uvm_do_with(req, {req.READ_WRITE == 0; req.transfer == 1; 
                         req.apb_write_paddr inside {[0:10]};})
      //req.apb_write_paddr.rand_mode(0);
      read_addr = req.apb_write_paddr;
      //t = req.transfer;
      `uvm_do_with(req, {req.READ_WRITE == 1; req.transfer == 1; 
	                       req.apb_read_paddr == read_addr;})
      //req.apb_write_paddr.rand_mode(1);
    //end
  endtask
endclass


/////////////////////////////////////////////////////////////////

// transfer = 0 case for read and write transfer
class no_transfer extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(no_transfer)
  
	bit [8:0] read_addr;
  function new(string name = "no_transfer");
    super.new(name);
  endfunction
  
  virtual task body();
    //repeat (`N) begin
      `uvm_do_with(req, {req.READ_WRITE == 0; req.transfer == 0; 
                         req.apb_write_paddr inside {[0:511]};})
      //req.apb_write_paddr.rand_mode(0);
      read_addr = req.apb_write_paddr;
      //t = req.transfer;
      `uvm_do_with(req, {req.READ_WRITE == 1; req.transfer == 0; 
	      		 req.apb_read_paddr == read_addr;})
      //req.apb_write_paddr.rand_mode(1);
    //end
  endtask
endclass


/////////////////////////////////////////////////////////////////

class regression_seq extends uvm_sequence #(apb_sequence_item);
  
  `uvm_object_utils(regression_seq);
  
//   write_seq 		write_seq_1;
//   read_seq 		read_seq_1;
  wr_seq_slave1	wr_seq_1;
  wr_seq_slave2 wr_seq_2;
  mid_break_transfer mid_trans;
  no_transfer trans;
  function new(string name = "regression_seq");
    super.new(name);
  endfunction
  
  task body();
//    `uvm_do(write_seq_1);
//    `uvm_do(read_seq_1);
    `uvm_do(wr_seq_1);
    `uvm_do(wr_seq_2);
//    `uvm_do(mid_trans);
    `uvm_do(trans);
    `uvm_do(mid_trans);
  endtask
endclass
