    /*计算排程期内,每天的可用产能*/
    /*工作日:每天4个班次的每个班次,制造时间大于8小时的部分算在加班时间,其他都算正常时间(不管在shft_det还是cal_det)*/
    /*节假日:全算在加班时间*/

    for each xln_det 
        where xln_site = site
        break by xln_site by xln_line :
        if last-of(xln_line) then do:
            v_ii = 0 .
            do v_ii = 0 to v_days :
                create xcn_det .
                assign xcn_site      = xln_site 
                       xcn_line      = xln_line
                       xcn_date      = today + v_ii 
                       .
            end.
        end.
    end. /* for each xln_det */

    for each xcn_det
        where xcn_site = site 
        break by xcn_site by xcn_line by xcn_date:

        /*正常班次,按周别-------------------*/
        find first hd_mstr
            where hd_site = xcn_site
            and   hd_date = xcn_date
        no-lock no-error.
        if avail hd_mstr then do: /*全厂假日*/
        end. /*全厂假日*/
        else do: /*全厂工作日*/
            find first shft_det
                where shft_site  = xcn_site
                and   shft_wkctr = xcn_line
                and   shft_mch   = ""
                and   shft_day   = weekday(xcn_date)  
            no-lock no-error.
            if avail shft_det then do:  /*正常班次*/
                assign          
                    xcn_time_1 = xcn_time_1 + shft_hour1 * shft_load1
                    xcn_time_2 = xcn_time_2 + shft_hour2 * shft_load2 
                    xcn_time_3 = xcn_time_3 + shft_hour3 * shft_load3
                    xcn_time_4 = xcn_time_4 + shft_hour4 * shft_load4 .
            end.  /*正常班次*/
        end.  /*全厂工作日*/

        /*加班或停机,按指定日期-----------------*/
        for each cal_det 
            where cal_site  = xcn_site 
            and   cal_wkctr = xcn_line
            and   cal_mch   = ""
            and   cal_start <= xcn_date
            and   cal_end   >= xcn_date
        no-lock :  /*加班或停机*/

            /*当天的效率*/
            find first shft_det
                where shft_site  = xcn_site
                and   shft_wkctr = xcn_line
                and   shft_mch   = ""
                and   shft_day   = weekday(xcn_date)  
            no-lock no-error.
            if not avail shft_det then 
                assign  
                    xcn_time_1 = xcn_time_1 + cal_shift1
                    xcn_time_2 = xcn_time_2 + cal_shift2 
                    xcn_time_3 = xcn_time_3 + cal_shift3 
                    xcn_time_4 = xcn_time_4 + cal_shift4 .
            else do:
                assign
                    xcn_time_1 = xcn_time_1 + cal_shift1 * shft_load1 
                    xcn_time_2 = xcn_time_2 + cal_shift2 * shft_load2 
                    xcn_time_3 = xcn_time_3 + cal_shift3 * shft_load3 
                    xcn_time_4 = xcn_time_4 + cal_shift4 * shft_load4 .
            end.

        end.  /*加班或停机*/

        /*产能由小时转换为分钟 , 负数当作零考虑**********/
        assign                      
            xcn_time_1 = max(0,xcn_time_1 * 60)
            xcn_time_2 = max(0,xcn_time_2 * 60) 
            xcn_time_3 = max(0,xcn_time_3 * 60) 
            xcn_time_4 = max(0,xcn_time_4 * 60) .

    end. /*for each xcn_det*/
        
