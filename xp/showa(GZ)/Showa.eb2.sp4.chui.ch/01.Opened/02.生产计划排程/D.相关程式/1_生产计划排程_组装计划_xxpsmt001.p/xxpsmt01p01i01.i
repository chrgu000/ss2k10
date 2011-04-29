/*Ì«Âı***************
    for each kc_det 
        where kc_site = i_site
        and   kc_part = i_part
        and   kc_date > i_date 
        and   kc_date <= (i_date + {&datei})
    no-lock:
        if kc_date < (i_date + {&datei}) then 
             {&qty} = {&qty} + kc_qty_nr .
        else {&qty} = {&qty} + kc_qty_nr *  {&dated} .
    end.

    v_date_further = ? .
    if {&qty} = 0 then do:
        do v_ii = 1 to v_find_further:
            if v_date_further = ? then do:
                find first kc_det 
                    where kc_site = i_site
                    and   kc_part = i_part
                    and   kc_date = i_date + v_ii
                    and   kc_qty_nr > 0 
                no-error .
                if avail kc_det then v_date_further = kc_date .
            end.
        end.
    end.
    if v_date_further <> ? then do:
        for each kc_det 
            where kc_site = i_site
            and   kc_part = i_part
            and   kc_date >= v_date_further 
            and   kc_date <= (v_date_further + {&datei})
            and   kc_date <= (i_date + v_find_further)
        no-lock:
            if kc_date < (v_date_further + {&datei}) then 
                 {&qty} = {&qty} + kc_qty_nr .
            else {&qty} = {&qty} + kc_qty_nr *  {&dated} .
        end.
    end.



*******************/


    for each nr_det 
        where nr_site = i_site
        and   nr_part = i_part
        and   nr_due_date > i_date 
        and   nr_due_date <= (i_date + {&datei})
    no-lock:
        if nr_due_date < (i_date + {&datei}) then 
             {&qty} = {&qty} + nr_qty_open .
        else {&qty} = {&qty} + nr_qty_open *  {&dated} .
    end.

    v_date_further = ? .
    if {&qty} = 0 then do:
        do v_ii = 1 to v_find_further:
            if v_date_further = ? then do:
                find first nr_det 
                    where nr_site = i_site
                    and   nr_part = i_part
                    and   nr_due_date = i_date + v_ii
                    and   nr_qty_open > 0 
                no-error .
                if avail nr_det then v_date_further = nr_due_date .
            end.
        end.
    end.
    if v_date_further <> ? then do:
        for each nr_det 
            where nr_site = i_site
            and   nr_part = i_part
            and   nr_due_date >= v_date_further 
            and   nr_due_date <= (v_date_further + {&datei})
            and   nr_due_date <= (i_date + v_find_further)
        no-lock:
            if nr_due_date < (v_date_further + {&datei}) then 
                 {&qty} = {&qty} + nr_qty_open .
            else {&qty} = {&qty} + nr_qty_open *  {&dated} .
        end.
    end.

