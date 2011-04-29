
for each temp2 
    where t2_wolot = t1_wolot
    break by t2_wolot by t2_part_by by t2_part:

    v_qty_crt = 0 .
    v_yn      = no .
    if t2_qty_iss <= 0 then next .

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

    /*按原件的料号comp2分配,存在原件或替代料都认为已产生过,除非是联合替代料t2_sub_type=yes,不再产生*/
    find first xbmd_det 
        where xbmd_domain = global_domain 
        and xbmd_lot      = t1_lot 
        /*
        and xbmd_par      = t1_part 
        and xbmd_wolot    = t1_wolot */
        and xbmd_comp2    = t2_part_by
    no-error .
    if avail xbmd_det then do:
        if t2_sub_type = no then next .
        else do:
            v_qty_crt = min(t2_qty_bom,t2_qty_iss).

            /*产生xbmd_det*/
            {xxbmcrt001zb.i &lot="t1_lot" &part="t1_part" &wolot="wolot" 
                            &comp="t2_part" &compby="t2_part_by" 
                            &qtybom="v_qty_crt"  &sn="v_sn" &hide="v_hide"  }
            assign t2_qty_iss = max(0,t2_qty_iss - v_qty_crt)
                   v_yn = yes .
        end.
    end. /*if avail xbmd_det*/
    else do:
            v_qty_crt = min(t2_qty_bom,t2_qty_iss).
            /*产生xbmd_det*/
            {xxbmcrt001zb.i &lot="t1_lot" &part="t1_part" &wolot="wolot" 
                            &comp="t2_part" &compby="t2_part_by" 
                            &qtybom="v_qty_crt"  &sn="v_sn" &hide="v_hide"  }
            assign t2_qty_iss = max(0,t2_qty_iss - v_qty_crt) 
                   v_yn = yes .
    end. /*else do:*/


    /*如果是ZP件,且产生了xbmd_det的(v_yn=yes),要产生xbmzp_det*/
    if t2_part begins "ZP" and v_yn = yes then do:
            v_qty_crt  = 0 .
            v_qty_bom  = t2_qty_bom .
            v_qty_left = t2_qty_bom . /*ZP半成品的用量*/
            for each xzp_det 
                where xzp_domain = global_domain 
                and xzp_wolot    = t1_wolot 
                and xzp_zppart   = t2_part
                no-lock:
                    v_ii = 0 .
                    do v_ii = 1 to num-entries(xzp_zpwo,",") :
                        v_wo_tmp = entry(v_ii,xzp_zpwo,",") . 

                        if v_qty_left <= 0 then leave .

                        find first xuse_mstr 
                            where xuse_domain = global_domain 
                            and xuse_wolot    = v_wo_tmp
                            and xuse_zppart   = t2_part
                            and xuse_qty_rct - xuse_qty_used > 0 
                        no-error .
                        if avail xuse_mstr then do:
                            if v_qty_left >= xuse_qty_rct - xuse_qty_used then do:

                                 assign v_qty_left    = v_qty_left - (xuse_qty_rct - xuse_qty_used)
                                        v_qty_bom     = xuse_qty_rct -  xuse_qty_used
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
                            else assign v_qty_bom     = v_qty_left 
                                        xuse_qty_used = xuse_qty_used + v_qty_left
                                        v_qty_left    = 0     .

                            for each xused_det
                                where xused_domain = global_domain 
                                and xused_wolot    = v_wo_tmp 
                                exclusive-lock 
                                break by xused_wolot by xused_part_by by xused_part:
                                
                                if xused_qty_iss - xused_qty_used <= 0 then next .
                                find first xbmzp_det 
                                    where xbmzp_domain = global_domain 
                                    and   xbmzp_lot    = t1_lot 
                                    /*
                                    and   xbmzp_par    = t1_part   
                                    and   xbmzp_wolot  = t1_wolot  */
                                    and   xbmzp_zppart = t2_part
                                    and   xbmzp_comp2  = xused_part_by
                                no-error.
                                if avail xbmzp_det and xused_sub_type = no then next .
                                else do:
                                    v_qty_crt  = v_qty_bom * xused_qty_bom .
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
                                                    &zppart="xused_zppart" &zpwo="xused_wolot"   }
                                end.

                            end. /*for each xused_det*/
                        end. /*if avail xuse_mstr*/
                    end. /*do v_ii = 1 to*/
            end. /*for each xzp_det*/


    end. /*if t2_part begins "ZP"*/

end. /*for each temp2*/



