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
 
 
        APB_deassert_PRESETn: assert property(@(posedge PCLK) ##9 PRESETn)
                                    else  $error("reset is applied");
 
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
                (READ_WRITE && transfer) |=> ##1 ($stable(apb_read_data_out));
        endproperty
 
        data_out_check:
        assert property(p4)
                $info("Data out is not unknown - Assertion 4 passed");
        else
                $error("Assertion 4 failed - data out is unknown during read operation");
 
        property p5;
                @(posedge PCLK) disable iff (PRESETn)
                (!PRESETn && READ_WRITE==1) |=> (apb_read_data_out == 8'b0 && PSLVERR == 1'b0);
        endproperty
 
        reset_check:
        assert property(p5)
          $info("Reset Check - Assertion 5 passed");
        else
                  $error("Assertion 5 failed - reset");
 
        property p6;
                @(posedge PCLK) disable iff(!PRESETn)
                (!transfer && READ_WRITE==1) |-> ( $stable(apb_read_data_out));
        endproperty
 
 
        transfer_deassert_check:
        assert property(p6)
          $info("Transfer dessert check - Assertion 6 passed");
        else
                  $error("Assertion 6 failed -Transfer dessert check ");
 
/*
        property p7;
                  @(posedge PCLK) disable iff(!PRESETn && !transfer)
                    (transfer && READ_WRITE==1) |=>
                                              $stable(apb_read_paddr) throughout (READ_WRITE[*2]);
        endproperty
 
        read_paddr_stablity_check:
        assert property(p7)
          $info("read paddr stability check - Assertion 7 passed");
        else
                  $error("Assertion 7 failed -read paddr stability check");
 
        property p8;
          @(posedge PCLK) disable iff(!PRESETn && !transfer)
            (transfer && READ_WRITE==0) |=>
                                      $stable(apb_write_paddr) throughout ((READ_WRITE==0)[*2]);
        endproperty
 
        write_paddr_stablity_check:
        assert property(p8)
          $info("write paddr stability check - Assertion 8 passed");
        else
                  $error("Assertion 8 failed - write paddr stability check");
*/
endinterface
