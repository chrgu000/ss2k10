    /*查找排程的主生产线xln_main = yes*/

    /*产线产能,目前都是按照今天为有效期计算的,非动态产能 ???*/

    /*产能都没考虑simon后来加的需求嫁动率 ????? */

    for each kc_det 
        where kc_site = site 
        and   kc_date = today :

        find first lna_det 
            where lna_site = kc_site
            and   lna_part = kc_part
            and   lna_allocation = 100
        no-lock no-error.
        if avail lna_det then do:
            find first xln_det 
                where xln_site = lna_site
                and   xln_line = lna_line
                and   xln_part = lna_part 
            no-lock no-error.
            if not avail xln_det then do:
                create xln_det.
                assign xln_site = lna_site
                       xln_line = lna_line
                       xln_part = lna_part 
                       xln_main = yes 
                       .
            
                find last lnd_det 
                    use-index lnd_line
                    where lnd_line = lna_line
                    and   lnd_site = lna_site
                    and   lnd_part = lna_part
                    and ( lnd_start <= today or lnd_start = ? )
                    and ( lnd_expire >= today or lnd_expire = ?) 
                no-lock no-error.
                if avail lnd_det then xln_qty_per_min = ( lnd_rate / 60 ). /*每1分钟x件*/
            
            end.
        end.
        else do:
            /*生效期内的,最后一笔日期对应的产线*/
            for each lnd_det 
                use-index lnd_line
                where lnd_site = kc_site
                and   lnd_part = kc_part
                and ( lnd_start <= today or lnd_start = ? )
                and ( lnd_expire >= today or lnd_expire = ?) 
            no-lock 
            break by lnd_start by lnd_line :
                if last(lnd_start) then do:
                    find first xln_det 
                        where xln_site = lnd_site
                        and   xln_line = lnd_line
                        and   xln_part = lnd_part 
                    no-lock no-error.
                    if not avail xln_det then do:
                        create xln_det.
                        assign xln_site = lnd_site
                               xln_line = lnd_line
                               xln_part = lnd_part 
                               xln_main = yes 
                               xln_qty_per_min = ( lnd_rate / 60 ) /*每1分钟x件*/
                               . 
                    end.
                end.  
            end.
        end.
    end. /*for each kc_det*/



    /*查找排程的副生产线:xln_main = no*/
    for each kc_det 
        where kc_site = site 
        and   kc_date = today :

            for each lnd_det 
                where lnd_site = kc_site
                and   lnd_part = kc_part
                and ( lnd_start <= today or lnd_start = ? )
                and ( lnd_expire >= today or lnd_expire = ?) 
            no-lock 
            break by lnd_start by lnd_line :
                    find first xln_det 
                        where xln_site = lnd_site
                        and   xln_line = lnd_line
                        and   xln_part = lnd_part 
                    no-lock no-error.
                    if not avail xln_det then do:
                        create xln_det.
                        assign xln_site = lnd_site
                               xln_line = lnd_line
                               xln_part = lnd_part 
                               xln_main = no 
                               xln_qty_per_min = ( lnd_rate / 60 ) /*每1分钟x件*/
                               .
                    end.
            end.
    end. /*for each kc_det*/
