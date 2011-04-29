    /*从tr_hist得到此wo_part即将产生的Lot*/
    get-lot-rct:
    do on error undo,retry on endkey undo,leave :

        for each tr_hist 
            use-index tr_nbr_eff
            where tr_hist.tr_domain = global_domain 
            and   tr_hist.tr_nbr    = wo_nbr 
            and   tr_hist.tr_lot    = wo_lot
            and   tr_hist.tr_part   = wo_part 
            and   tr_hist.tr_type   = "rct-wo"
            no-lock:

            find first temp1 
                where t1_wolot = tr_hist.tr_lot 
                and t1_part    = tr_hist.tr_part 
                and t1_lot     = tr_hist.tr_serial 
            no-error.
            if not avail temp1 then do:
                create temp1 .
                assign t1_wolot = tr_hist.tr_lot 
                       t1_part  = tr_hist.tr_part 
                       t1_lot   = tr_hist.tr_serial
                       .
            end.
            t1_qty = t1_qty + tr_hist.tr_qty_loc .
        end .

        for each temp1 where t1_qty = 0 :
            delete temp1 .
        end.
        for each temp1:
            accum t1_qty (total).
        end.
        if (accum total t1_qty) <> wo_qty_comp then do:
            message "错误:入库记录与工单完成数不同." . /*这个错应该不会出现*/
            undo mainloop,retry mainloop.
        end.
        
        /*每批次入库限一个,否则不是主机,不能继续运行*/
        for each temp1 where t1_qty <> 1 :
            message "错误:此工单有(" t1_qty ")台主机是同批号(" t1_lot ")" .
            undo mainloop, retry mainloop.
        end.

    end. /*get-lot-rct*/   
