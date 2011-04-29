            for each xpre_det 
                where xpre_domain = global_domain 
                and xpre_part = t1_part 
                and xpre_lot  = t1_lot 
                no-lock 
                break by xpre_part by xpre_lot by xpre_zppart by xpre_comp:

                if xpre_zppart = xpre_part then do:

                    v_qty_left = xpre_qty . /*指定用量*/
                    
                    /*主机工单的材料产生xbmd_det*/
                    for each temp2 
                        where t2_wolot = t1_wolot
                        and   t2_part = xpre_comp 
                        no-lock:

                            if v_qty_left <= 0 then leave .

                            if v_qty_left > t2_qty_iss then do:
                                    assign 
                                    v_qty_crt  = t2_qty_iss
                                    v_qty_left = v_qty_left - t2_qty_iss 
                                    t2_qty_iss = 0 .
                            end.
                            else do:
                                    assign 
                                    v_qty_crt  = v_qty_left 
                                    t2_qty_iss = t2_qty_iss - v_qty_left 
                                    v_qty_left = 0 .
                            end. 

                            v_sn   = xpre_sn .
                            find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
                            v_hide = if avail pt_mstr and pt__chr01 = "Y" then yes else no . 
                            if v_hide = no then do:
                                find first wod_det 
                                    where wod_domain = global_domain 
                                    and wod_lot  = t2_wolot
                                    and wod_part = t2_part 
                                no-lock no-error.
                                v_hide = if avail wod_det and wod__chr02 = "Y" then yes else no . 
                            end.
                            /*产生xbmd_det*/
                            {xxbmcrt001zb.i &lot="t1_lot" &part="t1_part" &wolot="wolot" 
                                            &comp="t2_part" &compby="t2_part_by" 
                                            &qtybom="v_qty_crt" &sn="v_sn" &hide="v_hide" }

                    end. /*for each temp2*/
                end. /*if xpre_zppart = xpre_part then do:*/
                else do: /*if xpre_zppart <> xpre_part then do:*/
                    find first xbmd_det 
                        where xbmd_domain = global_domain 
                        and   xbmd_lot    = t1_lot  
                        /*
                        and   xbmd_par    = t1_part   
                        and   xbmd_wolot  = t1_wolot  */
                        and   xbmd_comp   = xpre_zppart
                    no-error.  /*ZP件不要重复产生*/
                    if not avail xbmd_det then do:
                        find first wod_det 
                            where wod_domain = global_domain 
                            and wod_lot = t1_wolot 
                            and wod_part = xpre_zppart 
                        no-lock no-error.
                        v_qty_left = if avail wod_det then wod_bom_qty else 1 .

                        /*ZP件产生xbmd_det*/
                        for each temp2 
                            where t2_wolot = t1_wolot
                            and   t2_part = xpre_zppart 
                            no-lock:

                                if v_qty_left <= 0 then leave .

                                if v_qty_left > t2_qty_iss then do:
                                        assign 
                                        v_qty_crt  = t2_qty_iss
                                        v_qty_left = v_qty_left - t2_qty_iss 
                                        t2_qty_iss = 0 .
                                end.
                                else do:
                                        assign 
                                        v_qty_crt  = v_qty_left 
                                        t2_qty_iss = t2_qty_iss - v_qty_left 
                                        v_qty_left = 0 .
                                end. 

                                v_sn = "" .
                                find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
                                v_hide = if avail pt_mstr and pt__chr01 = "Y" then yes else no . 
                                if v_hide = no then do:
                                    find first wod_det 
                                        where wod_domain = global_domain 
                                        and wod_lot  = t2_wolot
                                        and wod_part = t2_part 
                                    no-lock no-error.
                                    v_hide = if avail wod_det and wod__chr02 = "Y" then yes else no . 
                                end.

                                /*产生xbmd_det*/
                                {xxbmcrt001zb.i &lot="t1_lot" &part="t1_part" &wolot="wolot" 
                                                &comp="t2_part" &compby="t2_part_by" 
                                                &qtybom="v_qty_crt"  &sn="v_sn" &hide="v_hide"  }

                        end. /*for each temp2*/                      
                    end. /*if not avail xbmd_det*/
                    
                    /*ZP件下的材料产生xbmzp_det: 1 - 优先分配部分 */
                    v_qty_left = xpre_qty . /*指定优先分配的材料用量*/
                    v_qty_crt  = 0 .
                    for each temp3 
                        where t3_wolot = t1_wolot
                        and t3_part    = t1_part 
                        and t3_lot     = t1_lot 
                        and t3_zppart  = xpre_zppart
                        no-lock:
                            if v_qty_left <= 0 then leave . 
                                for each xused_det
                                    where xused_domain = global_domain 
                                    and xused_wolot    = t3_zpwo 
                                    and xused_part     = xpre_comp 
                                    exclusive-lock:
                                    
                                    if v_qty_left <= 0 then leave .
                                    if xused_qty_iss - xused_qty_used <= 0 then next .
                                    
                                    if v_qty_left > xused_qty_iss - xused_qty_used then do:
                                            assign 
                                            v_qty_crt  = xused_qty_iss - xused_qty_used
                                            v_qty_left = v_qty_left - xused_qty_iss - xused_qty_used
                                            xused_qty_used = xused_qty_iss .
                                    end.
                                    else do:
                                            assign 
                                            v_qty_crt  = v_qty_left 
                                            xused_qty_used = xused_qty_used +  v_qty_left 
                                            v_qty_left = 0 .
                                    end. 

                                    v_sn = xpre_sn .
                                    find first pt_mstr where pt_domain = global_domain and pt_part = xused_part no-lock no-error.
                                    v_hide = if avail pt_mstr and pt__chr01 = "Y" then yes else no . 
                                    if v_hide = no then do:
                                        find first wod_det 
                                            where wod_domain = global_domain 
                                            and wod_lot  = xused_wolot
                                            and wod_part = xused_part 
                                        no-lock no-error.
                                        v_hide = if avail wod_det and wod__chr02 = "Y" then yes else no . 
                                    end.

                                    /*产生xbmzp_det*/
                                    {xxbmcrt001zc.i &lot="t1_lot" &part="t1_part" &wolot="wolot" 
                                                    &comp="xused_part" &compby="xused_part_by" 
                                                    &qtybom="v_qty_crt" &sn="v_sn" &hide="v_hide" 
                                                    &zppart="xused_zppart" &zpwo="xused_wolot" }
                                end. /*for each xused_det*/
                    end. /*for each temp3*/

                    /*ZP件下的材料产生xbmzp_det: 2 - 除去优先分配部分 */
                    find first wod_det 
                        where wod_domain = global_domain 
                        and wod_lot = t1_wolot 
                        and wod_part = xpre_zppart 
                    no-lock no-error.
                    v_qty_left = if avail wod_det then wod_bom_qty else 1 .

                    for each temp3 
                        where t3_wolot = t1_wolot
                        and t3_part    = t1_part 
                        and t3_lot     = t1_lot 
                        and t3_zppart  = xpre_zppart
                        no-lock:
                                for each xused_det
                                    use-index xused_part_by
                                    where xused_domain = global_domain 
                                    and xused_wolot    = t3_zpwo 
                                    exclusive-lock
                                    break by xused_wolot by xused_part_by by xused_part:
                                    
                                    if xused_qty_iss - xused_qty_used <= 0 then next .

                                    find first xbmzp_det 
                                        where xbmzp_domain = global_domain 
                                        and   xbmzp_lot    = t1_lot  
                                        /*
                                        and   xbmzp_par    = t1_part   
                                        and   xbmzp_wolot  = t1_wolot*/  
                                        and   xbmzp_zppart = xpre_zppart
                                        and   xbmzp_comp2  = xused_part_by
                                    no-error.
                                    if avail xbmzp_det and xused_sub_type = no then next .
                                    else do:
                                        v_qty_crt  = v_qty_left * xused_qty_bom .
                                        xused_qty_used = xused_qty_used +  v_qty_crt . 
                                        

                                        v_sn = "" .
                                        find first pt_mstr where pt_domain = global_domain and pt_part = xused_part no-lock no-error.
                                        v_hide = if avail pt_mstr and pt__chr01 = "Y" then yes else no . 
                                        if v_hide = no then do:
                                            find first wod_det 
                                                where wod_domain = global_domain 
                                                and wod_lot  = xused_wolot
                                                and wod_part = xused_part 
                                            no-lock no-error.
                                            v_hide = if avail wod_det and wod__chr02 = "Y" then yes else no . 
                                        end.

                                        /*产生xbmzp_det*/
                                        {xxbmcrt001zc.i &lot="t1_lot" &part="t1_part" &wolot="wolot" 
                                                        &comp="xused_part" &compby="xused_part_by" 
                                                        &qtybom="v_qty_crt" &sn="v_sn" &hide="v_hide" 
                                                        &zppart="xused_zppart" &zpwo="xused_wolot" }
                                    end.
                                end. /*for each xused_det*/
                                    
                                find first xuse_mstr 
                                    where xuse_domain = global_domain 
                                    and xuse_wolot    = t3_zpwo
                                    and xuse_zppart   = xpre_zppart
                                no-error .
                                if avail xuse_mstr then do:
                                    xuse_qty_used = xuse_qty_used + v_qty_left .
                                    if xuse_qty_rct <= xuse_qty_used then do:
                                        xuse_qty_used = xuse_qty_rct .
                                        find first temp4 
                                            where t4_zpwo   = xuse_wolot
                                            and   t4_zppart = xuse_zppart
                                        no-error.
                                        if not avail temp4 then do:
                                            create temp4 .
                                            assign t4_zpwo   = xuse_wolot
                                                   t4_zppart = xuse_zppart
                                                   t4_lot    = t1_lot .
                                        end.
                                    end.
                                end.
                    end. /*for each temp3*/
                    
                end. /*if xpre_zppart <> xpre_part then do:*/
            end.  /*for each xpre_det*/