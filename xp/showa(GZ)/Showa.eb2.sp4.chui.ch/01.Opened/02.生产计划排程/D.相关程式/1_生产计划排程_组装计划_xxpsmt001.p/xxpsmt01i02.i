    /*查找纳入,from sod_det,包含之前未结的*/
    for each sod_det
        where sod_site = site 
        and   sod_due_date <= today + v_days 
        and  (sod_qty_ord - sod_qty_ship) > 0
        no-lock:
        
        find first nr_det
            where nr_part      = sod_part 
            and   nr_site      = sod_site
            and   nr_due_date  = sod_due_date
        no-error.
        if not avail nr_det then do:
            create nr_det.
            assign nr_part      = sod_part 
                   nr_site      = sod_site
                   nr_due_date  = sod_due_date
                   .
        end.
        nr_qty_open = nr_qty_open + (sod_qty_ord - sod_qty_ship).
    end. /* for each sod_det*/
