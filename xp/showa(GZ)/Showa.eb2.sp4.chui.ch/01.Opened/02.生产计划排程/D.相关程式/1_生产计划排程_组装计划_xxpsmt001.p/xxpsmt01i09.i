    /*�����ų�����,ÿ��Ŀ��ò���*/
    /*������:ÿ��4����ε�ÿ�����,����ʱ�����8Сʱ�Ĳ������ڼӰ�ʱ��,������������ʱ��(������shft_det����cal_det)*/
    /*�ڼ���:ȫ���ڼӰ�ʱ��*/

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

        /*�������,���ܱ�-------------------*/
        find first hd_mstr
            where hd_site = xcn_site
            and   hd_date = xcn_date
        no-lock no-error.
        if avail hd_mstr then do: /*ȫ������*/
        end. /*ȫ������*/
        else do: /*ȫ��������*/
            find first shft_det
                where shft_site  = xcn_site
                and   shft_wkctr = xcn_line
                and   shft_mch   = ""
                and   shft_day   = weekday(xcn_date)  
            no-lock no-error.
            if avail shft_det then do:  /*�������*/
                assign          
                    xcn_time_1 = xcn_time_1 + shft_hour1 * shft_load1
                    xcn_time_2 = xcn_time_2 + shft_hour2 * shft_load2 
                    xcn_time_3 = xcn_time_3 + shft_hour3 * shft_load3
                    xcn_time_4 = xcn_time_4 + shft_hour4 * shft_load4 .
            end.  /*�������*/
        end.  /*ȫ��������*/

        /*�Ӱ��ͣ��,��ָ������-----------------*/
        for each cal_det 
            where cal_site  = xcn_site 
            and   cal_wkctr = xcn_line
            and   cal_mch   = ""
            and   cal_start <= xcn_date
            and   cal_end   >= xcn_date
        no-lock :  /*�Ӱ��ͣ��*/

            /*�����Ч��*/
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

        end.  /*�Ӱ��ͣ��*/

        /*������Сʱת��Ϊ���� , ���������㿼��**********/
        assign                      
            xcn_time_1 = max(0,xcn_time_1 * 60)
            xcn_time_2 = max(0,xcn_time_2 * 60) 
            xcn_time_3 = max(0,xcn_time_3 * 60) 
            xcn_time_4 = max(0,xcn_time_4 * 60) .

    end. /*for each xcn_det*/
        
