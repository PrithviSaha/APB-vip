//`include "defines.svh"

class apb_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_sequence)
  
   function new(string name = "apb_sequence");
     super.new(name);
   endfunction
    
   virtual task body();
     repeat(4) begin
       req = apb_sequence_item::type_id::create("req");
       wait_for_grant();
       void'(req.randomize());
       send_request(req);
       wait_for_item_done();

     end
   endtask
    
endclass

///////////////////////////////////////////////////////////////////////////
