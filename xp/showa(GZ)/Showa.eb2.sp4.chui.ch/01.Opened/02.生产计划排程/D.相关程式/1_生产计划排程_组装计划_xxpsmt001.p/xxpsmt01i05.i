    /*��ʼ�Ų�ǰ�Ĵ�����*/
    for each kc_det 
        where  kc_site = site
        and    kc_date = today 
        break  by kc_site by kc_part :

        if first-of(kc_site) then do:
            find first xxpsc_ctrl
                where xxpsc_site = kc_site 
            no-lock no-error.
            if not avail xxpsc_ctrl then do:
                {xxpsmt01i05a.i 
                    &err-part=kc_part
                    &err-site=kc_site
                    &err-type=""0""
                    &err-desc=""�̶�����ʱ��δ�趨""
                }                
            end.
        end .  /*if first-of(kc_site) then*/

        if first-of(kc_part) then do:

            /*����Ƿ����趨����*/
            find first xxcased_det 
                where xxcased_site = kc_site
                and   xxcased_part = kc_part 
            no-lock no-error.
            if (not avail xxcased_det )
               or
               (xxcased_qty_per = 0 )
            then do:
                {xxpsmt01i05a.i 
                    &err-part=kc_part
                    &err-site=kc_site
                    &err-type=""1""
                    &err-desc=""���δ�趨����""
                }
            end.

            /*�ų̾�������*/
            find first xxpbd_det
                where xxpbd_part = kc_part
                and   xxpbd_site = kc_site
            no-lock no-error.
            if not avail xxpbd_det then do:
                {xxpsmt01i05a.i 
                    &err-part=kc_part
                    &err-site=kc_site
                    &err-type=""2""
                    &err-desc=""���δ�趨�ų̾�������,�����׼""
                }
            end.


            /*���������*/
            v_ii = 0 .
            for each xxpsq_det
                use-index xxpsq_part
                where xxpsq_site = kc_site
                and   xxpsq_part = kc_part
                no-lock :
                v_ii = v_ii + 1 .

                /*����Ƿ�Ĳ����мӰ�����*/
                find first xxovd_det 
                    where xxovd_site = kc_site 
                    and   xxovd_line = xxpsq_line
                no-lock no-error.
                if not avail xxovd_det then do:
                    {xxpsmt01i05a.i 
                        &err-part=string(xxpsq_line)
                        &err-site=kc_site
                        &err-type=""4""
                        &err-desc=""������δ�趨�����Ӱ�ʱ������""
                    }
                end.            
            end.

            find first xxpsq_det
                use-index xxpsq_part
                where xxpsq_site = kc_site
                and   xxpsq_part = kc_part
            no-lock no-error.
            if not avail xxpsq_det or v_ii > 1  then do:
                find first lna_det 
                    where lna_site = kc_site
                    and   lna_part = kc_part
                    and   lna_allocation = 100
                no-lock no-error.
                if not avail lna_det then do:
                    {xxpsmt01i05a.i 
                        &err-part=kc_part
                        &err-site=kc_site
                        &err-type=""3""
                        &err-desc=""���δ�趨��������,�ҹ̶�����˳��δ�趨�����������""
                    }
                end.
                else do:
                    find first lnd_det 
                        where lnd_line = lna_line
                        and   lnd_site = lna_site
                        and   lnd_part = lna_part
                        and ( lnd_start <= today or lnd_start = ? )
                        and ( lnd_expire >= today or lnd_expire = ?) 
                    no-lock no-error.
                    if not avail lnd_Det then do:
                        {xxpsmt01i05a.i 
                            &err-part=kc_part
                            &err-site=kc_site
                            &err-type=""3""
                            &err-desc=""���δ�趨��������,�ҹ̶�����˳��δ�趨�����������""
                        }                        
                    end.
                end.
            end. /*if not avail xxpsq_det*/

        end.  /* if first-of(kc_part) */      
    end.  /* for each kc_det */

    
/***????**
    find first err_det no-lock no-error.
    if avail err_det then do:
        {gprun.i ""xxpsmt01p03.p"" } /*print error log to report*/
        message "����:�д�����,�ų���ֹ" .
        undo,retry.
    end.
***/


