/*排程主逻辑*/


/*初排前要先强排指定机种的指定数量  ???  */
/*比如:可能是排程日后两天的数量,排程调整指定的数量*/

/*初排:量产件MP,维修件SP,按满足经济批量和库存基准下限的数量*/
for each kc_det
    where kc_site = site 
    break by kc_site by kc_type by kc_date by kc_part:

    v_qty_prod = 0.
    v_is_mp    = if kc_type = "MP" then yes else no .


    find first xln_det
        where xln_site = kc_site 
        and   xln_part = kc_part
        and   xln_main = yes
    no-error.
    if avail xln_det then do:

        /*计算满足经济批量和库存下限的数量*/
        {gprun.i ""xxpsmt01p04.p""  
            "(input  kc_site, 
              input  kc_part,
              input  v_is_mp,
              input  kc_qty_min,
              input  kc_qty_min,
              input  kc_qty_nr ,
              input  kc_qty_oh ,
              output v_qty_prod
            )"}

        find first xps_mstr
            where xps_rev       = v_rev 
            and   xps_site      = xln_site
            and   xps_part      = xln_part
        no-error.
        if not avail xps_mstr then do:
            create xps_mstr .
            assign xps_rev       = v_rev    
                   xps_site      = xln_site 
                   xps_part      = xln_part 
                   xps_qty_min   = v_qty_prod
                   xps_qty_left  = 0
                   xps_type      = kc_type
                   .
        end. /*if not avail xps_mstr*/

        find first xpsd_det
            where  xpsd_rev       = v_rev 
            and    xpsd_site      = xln_site
            and    xpsd_line      = xln_line
            and    xpsd_part      = xln_part
        no-error.
        if not avail xpsd_det then do:
            create xpsd_det .
            assign xpsd_rev       = v_rev    
                   xpsd_site      = xln_site 
                   xpsd_line      = xln_line 
                   xpsd_part      = xln_part 
                   xpsd_qty_prod1 = v_qty_prod   /*全部先排在1班次,后面再根据不同班次的产能调整??*/
                   xpsd_type      = kc_type
                   .
            /*有分配机种数量的产线yes***/
            assign xln_used = yes .
        end. /*if not avail xps_mstr*/

    end. /*if avail xln_det then do:*/
end .  /*for each kc_det*/

/*初排结果计算:已用产能(含换机种时间)*/
for each xpsd_det 
    where xpsd_site = site 
    break by xpsd_site by xpsd_line by xpsd_date by xpsd_part:
    

    if first-of(xpsd_line) then do:
        /*生产顺序重排,统计换线时间*
        {gprun.i ""xxpsmt01p02.p""  "(input xpsd_site, input xpsd_line)"}**/
        
        v_time_chg  = 0.
        v_time_used = 0 .

        v_part_prev = "" .
        v_part_next = "" .
        for each ttemp2
            where tt2_site = xpsd_site
            and   tt2_line = xpsd_line
            break by tt2_seq :

            v_part_prev = v_part_next .
            v_part_next = tt2_part .

            if v_part_next <> "" and v_part_prev <> "" then do:
                find first chg_mstr
                    where chg_site  = xpsd_site 
                    and   chg_line  = xpsd_line
                    and   chg_from  = v_part_prev
                    and   chg_to    = v_part_next
                no-lock no-error .
                if avail chg_mstr then do:
                    v_time_tmp = chg_time * 60 .
                end.
                else do:
                    find first xxpsc_ctrl
                        where xxpsc_site = kc_site 
                    no-lock no-error.
                    v_time_tmp = if avail xxpsc_ctrl then xxpsc_time_chg else 0 .

                end.            
                v_time_chg = v_time_chg + v_time_tmp .
            end.
        end.
    end. /*if first-of(xpsd_line)*/

    v_time_used = v_time_used + v_time_chg .

    find first xln_det
        where xln_site = xpsd_site 
        and xln_line   = xpsd_line
        and xln_part   = xpsd_part
    no-error.
    if avail xln_det then do:
        v_time_used = v_time_used + xpsd_qty_prod1 / xln_qty_per_min .
    end.

    if last-of(xpsd_line) then do:
        find first xcn_det 
            where xcn_site     = xpsd_site 
            and   xcn_line     = xpsd_line
            and   xcn_date     = xpsd_date
        no-error.
        if avail xcn_det then do:
            xcn_time_used = v_time_used .
        end.
    end.
end. /*for each xpsd_det*/






/*初排结果调整:考虑产能,生产顺序,不考虑容器*/
for each xcn_det
    where xcn_site = site 
    and xcn_time_used > (xcn_time_1 + xcn_time_2 + xcn_time_3 + xcn_time_4) 
    break by xcn_site by xcn_line by xcn_date:
    

    /* 日历上没安排上班的,比如需要周日有整天加班的情况,照目前逻辑本日不会排程,??? */
    v_time_used   = xcn_time_used . 
    v_time_tmp    = (xcn_time_1 + xcn_time_2 + xcn_time_3 + xcn_time_4)  .
    v_qty_prod    = 0 .


    for each ttemp2
            where tt2_site = xcn_site
            and   tt2_line = xcn_line
        no-lock ,
        each xpsd_det
            where xpsd_rev  = v_rev
            and   xpsd_site = tt2_site
            and   xpsd_line = tt2_line
            and   xpsd_part = tt2_part
        break by tt2_site by tt2_line 
            by tt2_seq descending
            by xpsd_part by xpsd_date :

        if v_time_used <= v_time_tmp then leave .

        v_qty_lot     = 1 . 
        v_qty_per_min = 0 .

        find first xln_det
            where xln_site = xpsd_site 
            and xln_line   = xpsd_line
            and xln_part   = xpsd_part
        no-error.
        if avail xln_det then v_qty_per_min = xln_qty_per_min .

        /*减少排程批量,,直到不超过当日产能上限*/
        if xpsd_qty_prod1 * v_qty_per_min <= ( v_time_used - v_time_tmp ) then do:
            v_qty_prod   = xpsd_qty_prod1 .  /**取消的数量存放起来,稍后继续排程???**/
            xpsd_qty_prod1 = 0 .  /*整个机种取消排程*/
        end.
        else do:   /*逐批减少排程批量*/
            find first xxpbd_det
                where xxpbd_part = kc_part
                and   xxpbd_site = kc_site
            no-lock no-error.
            if avail xxpbd_det then v_qty_lot = xxpbd_qty_lot .

            v_jj  = truncate(xpsd_qty_prod1 / v_qty_lot,0). /*理论上应该是可以整除的*/

            do v_ii = 1 to v_jj:
                if v_qty_prod * v_qty_per_min >= ( v_time_used - v_time_tmp ) then do:
                    leave .
                end.
                v_qty_prod = v_qty_prod + v_qty_lot * v_ii .
            end.

            if v_qty_prod * v_qty_per_min < ( v_time_used - v_time_tmp ) then v_qty_prod = xpsd_qty_prod1 .

            xpsd_qty_prod1 = xpsd_qty_prod1 - v_qty_prod .
            v_time_used = max(0,v_time_used - v_qty_prod * v_qty_per_min) .

            if xpsd_qty_prod1 = 0 then do:
                find first xln_det
                    where xln_site = xpsd_site 
                    and xln_line   = xpsd_line
                    and xln_part   = xpsd_part
                no-error.
                if avail xln_det then do:
                    xln_used = no .                
                    /*也要扣掉换线时间,晚点加???*/
                end.
            end.

            if v_time_used <= v_time_tmp then leave .

        end.  /*逐批减少排程批量*/


        /*剩余的需求,放在排程主表,以期排在副线等*/
        for each xps_mstr
            where xps_rev  = xpsd_rev 
            and   xps_site = xpsd_site
            and   xps_part = xpsd_part
            and   xps_date = xpsd_date
            :
            xps_qty_left = xps_qty_left + v_qty_prod .
        end.

    end. /*for each ttemp2*/

    xcn_time_used = xcn_time_used - v_time_used .
end. /* for each xcn_det */

