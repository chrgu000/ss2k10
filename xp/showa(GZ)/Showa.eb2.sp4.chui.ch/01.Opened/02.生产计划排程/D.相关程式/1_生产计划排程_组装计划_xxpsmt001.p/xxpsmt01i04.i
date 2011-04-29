    /*计算排产前的理论库存=(实际库存+未结进度工单-未结销售纳入)*/   
	/*取当前时点的,没有按照v_time_stock,不是本日凌晨2点的????*/
    for each kc_det 
        where  kc_site = site
        and    kc_date = today :


        /*实际库存*/
        find first in_mstr 
            where in_part = kc_part
            and   in_site = kc_site
        no-lock no-error.
        kc_qty_oh = if avail in_mstr then in_qty_oh else 0 .

        /*未结进度排程工单*/
        for each wo_mstr 
            use-index wo_type_part 
            where wo_type = "S"
            and   wo_part = kc_part 
            and   wo_site = kc_site
            and   wo_due_date <= kc_date
            no-lock:
            kc_qty_oh = kc_qty_oh + (wo_qty_ord - wo_qty_comp) .
        end.

        /*未结销售纳入*/
        for each nr_det 
            where nr_site = site
            and   nr_part = kc_part 
            and   nr_due_date <= kc_date :
            kc_qty_oh = kc_qty_oh - nr_qty_open .
        end.

        kc_qty_oh = max(0,kc_qty_oh ) .

    end. /* for each kc_det */
