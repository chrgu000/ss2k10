    get-part-iss:
    do on error undo,retry on endkey undo,leave :
        for each tr_hist 
            use-index tr_nbr_eff
            where tr_hist.tr_domain = global_domain 
            and   tr_hist.tr_nbr    = wo_nbr 
            and   tr_hist.tr_lot    = wo_lot
            and   tr_hist.tr_type   = "iss-wo"
            no-lock:

            find first temp2 
                where t2_wolot = tr_hist.tr_lot 
                and t2_part  = tr_hist.tr_part 
            no-error.
            if not avail temp2 then do:
                create temp2 .
                assign t2_wolot = tr_hist.tr_lot 
                       t2_part  = tr_hist.tr_part
                       .
            end.
            t2_qty_iss = t2_qty_iss + (- tr_hist.tr_qty_loc) .
            
        end . /*for each tr_hist*/

        for each temp2 where t2_qty_iss = 0 :
            delete temp2 .
        end.

    end. /*get-part-iss*/   

