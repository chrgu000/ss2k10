    /*�����ų�����,ÿ��Ŀ���׼*/
    for each nr_det 
        where nr_site = site
        break by nr_part by nr_due_date :

        if first-of(nr_part) then do:

            /*����MP��ά��SP����:��1.4.3�����״̬,����SO��������,ÿ�����ֻ��һ��״̬ */
            find first pt_mstr 
                where pt_part = nr_part
            no-lock no-error.
            v_nr_type = if avail pt_mstr and pt_status = "SP" then "SP" else "MP" .

            /*��������,����SP,MP��. ���ﶼ��Ҫ�������ۿ���kc_det */ 
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


/*SP�����ܻ�������,������ǰ�ڻ����߼�,��ǰ��������ȡ?????
        if v_nr_type = "SP"  then do:
        v_nr_date = nr_due_date .

        /*��ǰ�ڲ��㵽today???*/
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


/*��MP���Ű�����׼�����ų�,�������Ҫ�����׼*/
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