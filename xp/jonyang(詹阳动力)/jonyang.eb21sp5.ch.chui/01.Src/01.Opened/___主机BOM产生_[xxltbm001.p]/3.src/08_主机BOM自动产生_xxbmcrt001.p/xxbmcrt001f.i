/*多发料之:主机工单的多发料*/
for each temp2 
    where t2_qty_iss > 0
    break by t2_wolot by t2_part :

    find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
    v_um = if avail pt_mstr then pt_um else "" .

    find code_mstr  
        where code_mstr.code_domain = global_domain 
        and  code_fldname = fieldname
        and  code_value   = v_um 
    no-lock no-error.
    v_umx = if avail code_mstr and code_user1 = "Y" then yes  else no .
    
    /*多发料是不可拆分的单位,则分布到最后一个主机上*/
    if v_umx = no then do:
        for last temp1 break by t1_wolot by t1_lot :
        end.
        if avail temp1 then do: 
            for each xbmd_det
                where xbmd_domain = global_domain 
                and xbmd_lot  = t1_lot
                and xbmd_comp = t2_part 
                :
                if t2_qty_iss <= 0 then leave .
                assign xbmd_qty_bom = xbmd_qty_bom + t2_qty_iss 
                       v_qty_left   = t2_qty_iss 
                       t2_qty_iss   = 0 .
                if t2_part begins "zp" then do:
                    v_qty_crt  = 0 .
                    v_qty_bom  = v_qty_left . /*ZP半成品的用量*/
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
                                            and   xbmzp_comp   = xused_part
                                        no-error.
                                        if avail xbmzp_det then do:
                                            v_qty_crt = v_qty_bom * xused_qty_bom .
                                            xbmzp_qty_bom  = xbmzp_qty_bom + v_qty_crt .
                                            xused_qty_used = xused_qty_used +  v_qty_crt . 
                                        end.
                                    end. /*for each xused_det*/
                                end. /*if avail xuse_mstr*/
                            end. /*do v_ii = 1 to*/
                    end. /*for each xzp_det*/
                end. /*if t2_part begins "zp" then do:*/
            end. /*for each xbmd_det*/
        end. /*if avail temp1*/
    end. /*if v_umx = no*/
    else do: /*单位可拆分,一定不可能是ZP件*/
        v_ii = 0 .
        for each temp1 :
            v_ii = v_ii + 1 .
        end.
        v_qty_bom = round(t2_qty_iss / v_ii ,3) .

        for each temp1 :
            for each xbmd_det
                where xbmd_domain = global_domain 
                and xbmd_lot  = t1_lot
                and xbmd_comp = t2_part
                :
                xbmd_qty_bom = xbmd_qty_bom + v_qty_bom .
            end. /*for each xbmd_det*/
        end.
    end. /*else do: 单位可拆分*/

end. /*for each temp2*/

/*多发料之:ZP工单的多发料,temp4 create from xuse_mstr,  ZP件子件的多发料,全部计入最后一个主机,不再按单位拆分分摊*/
for each temp4:
    find first xused_det 
        where xused_wolot = t4_zpwo 
        and  xused_qty_iss - xused_qty_used > 0 
    no-error.
    if not avail xused_det then next .
    else do : /*存在未分配完的料*/
        for each xused_det 
            where xused_wolot = t4_zpwo 
            and  xused_qty_iss - xused_qty_used > 0 :
                find first xbmzp_det 
                    where xbmzp_domain = global_domain 
                    and   xbmzp_lot    = t1_lot 
                    /*
                    and   xbmzp_par    = t1_part   
                    and   xbmzp_wolot  = t1_wolot  */
                    and   xbmzp_zppart = t4_zppart
                    and   xbmzp_comp   = xused_part
                    and   xbmzp_zpwo   = t4_zpwo
                no-error.
                if avail xbmzp_det then do:
                    v_qty_crt      = xused_qty_iss - xused_qty_used .
                    xbmzp_qty_bom  = xbmzp_qty_bom + v_qty_crt .
                    xused_qty_used = xused_qty_used +  v_qty_crt . 
                end.
        end. /*for each xused_det*/
    end. /*存在未分配完的料*/
end. /*for each temp4*/