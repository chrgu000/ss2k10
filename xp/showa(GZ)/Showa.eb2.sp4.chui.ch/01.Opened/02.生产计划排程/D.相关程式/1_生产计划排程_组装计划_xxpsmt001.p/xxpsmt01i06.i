    /*计算排程时间点的定义的总容器数*/
    for each xxcase_mstr 
            where xxcase_site = site 
        no-lock:

        find first xrq_det
            where xrq_site = xxcase_site
            and   xrq_nbr  = xxcase_nbr
        no-error .
        if not avail xrq_det then do:
            create xrq_det .               
            assign xrq_site = xxcase_site  
                   xrq_nbr  = xxcase_nbr   
                   xrq_qty_today = xxcase_qty_ord
                   .
        end.
    end. /* for each xxcase_mstr */

    /*计算排程时间点的(剩下的)可用容器数*/
    for each kc_det
        where kc_site = site
        and   kc_date = today 
        break by kc_part :
        
        v_case_used = 0 .
        v_qty_lot   = kc_qty_oh .

        for each xxcased_det
            where xxcased_site = kc_site
            and   xxcased_part = kc_part
            no-lock:

            if v_qty_lot <= 0 then leave .

            v_case_used =   if   truncate(kc_qty_oh / xxcased_qty_per,0) < kc_qty_oh / xxcased_qty_per 
                            then truncate(kc_qty_oh / xxcased_qty_per,0) + 1 
                            else truncate(kc_qty_oh / xxcased_qty_per,0) .


            find first xrq_det
                where xrq_site = xxcased_site
                and   xrq_nbr  = xxcased_nbr
            no-error .
            if avail xrq_det then do:
                if xrq_qty_today > v_case_used then do:
                    xrq_qty_today = max(0,xrq_qty_today - v_case_used) .
                    v_qty_lot     = 0 .
                end.
                else do:
                    v_qty_lot     = max(0,v_qty_lot - xrq_qty_today * xxcased_qty_per ) .
                    xrq_qty_today = 0 .
                end.
            end.

            if v_qty_lot <= 0 then leave .
        end. /*for each xxcased_det*/
    end. /*for each kc_det*/


