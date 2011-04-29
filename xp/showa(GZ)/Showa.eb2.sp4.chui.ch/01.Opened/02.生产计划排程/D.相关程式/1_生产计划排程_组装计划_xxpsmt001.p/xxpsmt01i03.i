    /*计算排程期内,每天的库存基准*/
    for each nr_det 
        where nr_site = site
        break by nr_part by nr_due_date :

        if first-of(nr_part) then do:

            /*量产MP与维修SP区分:按1.4.3的零件状态,不按SO订单类型,每个零件只有一种状态 */
            find first pt_mstr 
                where pt_part = nr_part
            no-lock no-error.
            v_nr_type = if avail pt_mstr and pt_status = "SP" then "SP" else "MP" .

            /*所有纳入,不分SP,MP件. 这里都需要产生理论库存表kc_det */ 
            find first kc_det 
                where kc_site = nr_site
                and   kc_part = nr_part 
            no-error .
            if not avail kc_det then do:
                v_ii = 0 .
                do v_ii = 0 to v_days :
                    create kc_det .
                    assign kc_part   = nr_part 
                           kc_site   = nr_site
                           kc_type   = v_nr_type 
                           kc_date   = today + v_ii 
                           .
                    release kc_det .
                end.
            end.
        end. /*if first-of(nr_part)*/

    end. /* for each nr_det */


/*SP件按周汇总需求,且有提前期汇总逻辑,提前期在哪里取?????
        if v_nr_type = "SP"  then do:
        v_nr_date = nr_due_date .

        /*提前期不足到today???*/
        if v_nr_date < today then v_nr_date = today .
        end. /*if kc_type = "SP"*/
*/ 



for each kc_det 
    where kc_site = site 
    break by kc_site by kc_part by kc_date:

    find first nr_det
        where nr_site = kc_site 
        and   nr_part = kc_part
        and   nr_due_date = kc_date
    no-lock no-error.
    if avail nr_det then kc_qty_nr = nr_qty_open.
end. /* for each kc_det */


/*仅MP件才按库存基准计算排程,这里才需要算库存基准*/
for each kc_det 
    where kc_site = site 
    and   kc_type = "MP"
    break by kc_site by kc_part by kc_date:

    if first-of(kc_part)  then do:
        find first xxpbd_det 
            where xxpbd_part = kc_part
            and   xxpbd_site = kc_site
        no-lock no-error.
        v_date_min = if avail xxpbd_det then xxpbd_qty_min else 0 . 
        v_date_max = if avail xxpbd_det then xxpbd_qty_max else 0 .            
    end. /* if last-of(nr_part) */ 

    {gprun.i ""xxpsmt01p01.p"" 
             "(input kc_site,
               input kc_part, 
               input kc_date, 
               output v_qty_min,
               output v_qty_max)"}

    assign kc_qty_min = v_qty_min
           kc_qty_max = v_qty_max
           .
end. /* for each kc_det */