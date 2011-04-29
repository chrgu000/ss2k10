/*xxbmmt001.p 主机BOM返修,替换ZP件 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1   Created On: 20100907   By: Softspeed Roger Xiao                               */



{mfdtitle.i "100907.1"}
define var v_lot     like xbm_lot  no-undo.
define var v_part    like pt_part  no-undo.
define var v_desc11  like pt_desc1 no-undo.
define var v_um11    like pt_um    no-undo.
define var v_desc12  like pt_desc2 no-undo.

define var v_zppart like pt_part  no-undo.
define var v_desc21  like pt_desc1 no-undo.
define var v_desc22  like pt_desc2 no-undo.
define var v_um21    like pt_um    no-undo.

define var v_newpart like pt_part  no-undo.
define var v_desc31  like pt_desc1 no-undo.
define var v_desc32  like pt_desc2 no-undo.
define var v_um31    like pt_um    no-undo.

define var v_wo      like wo_lot   no-undo.
define var v_newwo   like wo_lot   no-undo.

define var choice     as logical no-undo.
define var v_hide     as logical no-undo.
define var v_sn       as char    no-undo.
define var v_qty_bom  like wod_bom_qty .
define var v_qty_left like wod_bom_qty .
define var v_qty_crt  like wod_bom_qty .


form
    SKIP(.2)
    v_lot          colon 15 label "主机号"
    v_part         colon 15 label "零件号"
    v_desc11       colon 47 no-label    
    v_um11         colon 15 label "单位"
    v_desc12       colon 47 no-label 
                   
                   skip(2)
    v_zppart       colon 15 label "原ZP件"       v_newpart      colon 47 label "新ZP件"     
    v_desc21       colon 15 label "说明"         v_desc31       colon 47 label "说明"           
    v_desc22       colon 15 no-label             v_desc32       colon 47 no-label           
    v_um21         colon 15 label "单位"         v_um31         colon 47 label "单位"       
    xbmd_qty_bom   colon 15 label "用量"         v_qty_bom      colon 47 label "用量"   
    v_wo           colon 15 label "原ZP工单ID"   v_newwo        colon 47 label "新ZP工单ID"
    
skip(1) 
with frame a  side-labels width 80 attr-space.
/*setFrameLabels(frame a:handle).*/

view frame a .
mainloop:
repeat:
    clear frame a no-pause .

    disp v_lot with frame a .

    prompt-for 
        v_lot
    with frame a editing:
         {mfnp11.i xbm_mstr xbm_lot  "xbm_domain = global_domain and xbm_lot"  "input v_lot"  }
         if recno <> ? then do:
            disp 
                xbm_lot  @ v_lot
                xbm_part @ v_part
            with frame a .
            find first pt_mstr where pt_domain = global_domain and pt_part = xbm_part no-lock no-error .
            if avail pt_mstr then do:
                disp 
                    pt_desc1 @ v_desc11
                    pt_desc2 @ v_desc12
                    pt_um    @ v_um11
                with frame a.
            end.
         end . 
    end. /*editing:*/
    assign v_lot .

    find first xbm_mstr where xbm_domain = global_domain and xbm_lot = v_lot exclusive-lock no-error .
    if not avail xbm_mstr then do:
        message "错误:无效主机编号,请重新输入".
        undo,retry.
    end.
    v_part = xbm_part .

    find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error .
    if avail pt_mstr then do:
        disp 
            pt_desc1 @ v_desc11
            pt_desc2 @ v_desc12
            pt_um    @ v_um11
        with frame a.
    end.

    find first xbmd_det 
        where xbmd_domain = global_domain 
        and   xbmd_lot    = xbm_lot
        and   xbmd_par    = xbm_part
    no-error .
    if not avail xbmd_det then do:
        message "错误:主机BOM明细不存在,请重新输入" .
        undo,retry .
    end.
    v_zppart  = xbmd_comp .

    zploop:
    do on error undo,retry on endkey undo,leave :
        disp v_zppart with frame a .

        prompt-for 
            v_zppart
        with frame a editing:
             {mfnp11.i xbmd_det xbmd_comp  "xbmd_domain = global_domain and xbmd_lot = xbm_lot and xbmd_comp "  "input v_zppart"  }
             if recno <> ? then do:
                disp 
                    xbmd_comp @ v_zppart
                    xbmd_qty_bom
                with frame a .
                find first pt_mstr where pt_domain = global_domain and pt_part = xbmd_comp no-lock no-error .
                if avail pt_mstr then do:
                    disp 
                        pt_desc1 @ v_desc21
                        pt_desc2 @ v_desc22
                        pt_um    @ v_um21
                    with frame a.
                end.
                find first xbmzp_det where xbmzp_domain = global_domain and xbmzp_lot = xbm_lot and xbmzp_zppart = xbmd_comp no-lock no-error.
                v_wo = if avail xbmzp_det then xbmzp_zpwo else "".
                disp v_wo with frame a.
             end . 
        end. /*editing:*/
        assign v_zppart .

        if not v_zppart begins "ZP" then do:
            message "错误:仅限ZP件".
            undo,retry.
        end.

        find first pt_mstr where pt_domain = global_domain and pt_part = v_zppart no-lock no-error .
        if not avail pt_mstr then do:
            message "错误:无效零件编号,请重新输入".
            undo,retry.
        end.
        disp 
            pt_desc1 @ v_desc21
            pt_desc2 @ v_desc22
            pt_um    @ v_um21
        with frame a.

        find first xbmzp_det where xbmzp_domain = global_domain and xbmzp_lot = xbm_lot and xbmzp_zppart = v_zppart no-lock no-error.
        v_wo = if avail xbmzp_det then xbmzp_zpwo else "".
        disp v_wo with frame a.

        find first xbmd_det 
            where xbmd_domain = global_domain 
            and   xbmd_lot    = xbm_lot
            and   xbmd_comp   = v_zppart 
        exclusive-lock no-error .
        if not avail xbmd_det then do:
            message "错误:无效ZP件,请重新输入." .
            undo,retry.
        end.
        disp 
            xbmd_qty_bom 
        with frame a .
        v_qty_bom = xbmd_qty_bom .
        v_newpart = xbmd_comp .

        newloop:
        do on error undo,retry on endkey undo,leave :
            update v_newpart with frame a editing:
                 {mfnp11.i pt_mstr pt_part  "pt_domain = global_domain and pt_part "  "input v_newpart"  }
                 if recno <> ? then do:
                        disp 
                            pt_desc1 @ v_desc31
                            pt_desc2 @ v_desc32
                            pt_um    @ v_um31
                            pt_part  @ v_newpart
                        with frame a.
                 end .                 
            end. /*editing:*/

            if v_newpart = v_zppart then do:
                message "错误:替换的ZP件与原件相同" .
                undo,retry.
            end.

            find first pt_mstr where pt_domain = global_domain and pt_part = v_newpart no-lock no-error.
            if not avail pt_mstr then do:
                message "错误:无效零件编号,请重新输入".
                undo,retry.
            end.
            disp 
                pt_desc1 @ v_desc31
                pt_desc2 @ v_desc32
                pt_um    @ v_um31
            with frame a.

            update v_qty_bom  with frame a .


            newwoloop:
            do on error undo,retry:
                update v_newwo  with frame a editing:
                     {mfnp11.i wo_mstr wo_lot  "wo_domain = global_domain and wo_lot "  "input v_newwo"  }
                     if recno <> ? then do:
                            disp 
                                wo_lot @ v_newwo 
                            with frame a.
                     end .       
                end.
                find first wo_mstr where wo_domain = global_domain and wo_lot = v_newwo no-lock no-error.
                if not avail wo_mstr then do:
                    message "错误:无效工单ID,请重新输入".
                    undo,retry.
                end.
                if wo_part <> v_newpart then do:
                    message "错误:此工单ID的完成品非(" v_newpart "),请重新输入".
                    undo,retry.
                end.
                if wo_qty_comp + wo_qty_rjct < wo_qty_ord then do:
                    message "错误:加工单数量未完成,请重新输入".
                    undo,retry.
                end.
                if wo_qty_comp < v_qty_bom then do:
                    message "错误:加工单数量不足本次使用量,请重新输入,".
                    undo,retry.                    
                end.

                find first xuse_mstr where xuse_domain = global_domain and xuse_wolot = v_newwo and xuse_zppart = v_newpart no-lock no-error.
                if avail xuse_mstr and xuse_qty_rct - xuse_qty_used < v_qty_bom then do:
                    message "错误:加工单剩余数量不足本次使用量,请重新输入.".
                    undo,retry.        
                end.

                message "以上信息全部正确?" update choice .
                if choice = no then undo mainloop,retry mainloop.

                if not avail xuse_mstr then do:
                    /* 产生占用明细表xuse_mstr , xused_det from tr_hist **/
                    for each tr_hist 
                        use-index tr_nbr_eff
                        where tr_hist.tr_domain = global_domain 
                        and   tr_hist.tr_nbr    = wo_nbr 
                        and   tr_hist.tr_lot    = wo_lot
                        and   (tr_hist.tr_type   = "RCT-wo" or tr_hist.tr_type   = "ISS-wo" )
                        no-lock:

                        if tr_hist.tr_type = "ISS-wo" then do:
                            find first xused_det 
                                where xused_domain = global_domain  
                                and xused_wolot    = tr_hist.tr_lot 
                                and xused_part     = tr_hist.tr_part 
                            no-error.
                            if not avail xused_det then do:
                                create xused_det .
                                assign xused_wolot = tr_hist.tr_lot 
                                       xused_part  = tr_hist.tr_part
                                       xused_wonbr = tr_hist.tr_nbr
                                       xused_zppart = wo_part 
                                       xused_domain = global_domain 
                                       .
                            end.
                            xused_qty_iss = xused_qty_iss + (- tr_hist.tr_qty_loc) .
                        end.
                        else do:
                            find first xuse_mstr 
                                where xuse_domain = global_domain  
                                and xuse_wolot    = tr_hist.tr_lot 
                                and xuse_zppart     = tr_hist.tr_part 
                            no-error.
                            if not avail xuse_mstr then do:
                                create xuse_mstr .
                                assign xuse_wolot   = tr_hist.tr_lot 
                                       xuse_zppart  = tr_hist.tr_part
                                       xuse_wonbr   = tr_hist.tr_nbr
                                       xuse_domain = global_domain 
                                       .
                            end.
                            xuse_qty_rct = xuse_qty_rct + tr_hist.tr_qty_loc .
                        end.
                        
                    end . /*for each tr_hist*/

                    /*计算ZP子工单所有材料的替代关系*/
                    for each xused_det 
                            where xused_domain = global_domain  
                            and xused_wolot    = wo_lot :

                            if xused_qty_iss = 0 then do:
                                delete xused_det .
                                next.
                            end.

                            find first wod_det 
                                where wod_domain = global_domain 
                                and wod_lot  = xused_wolot
                                and wod_part = xused_part
                            no-lock no-error .
                            if avail wod_det then do:
                                xused_qty_bom = wod_bom_qty .
                            end.

                            find first xsub_det 
                                use-index xsub_wolot_sub
                                where xsub_domain  = global_domain 
                                and   xsub_wolot   = xused_wolot
                                and   xsub_subpart = xused_part 
                            no-lock no-error.
                            if not avail xsub_det then do:
                                xused_part_by  = xused_part .
                            end.
                            else do:
                                xused_part_by = xsub_part .
                                find first xsub_det 
                                    use-index xsub_wolot_sub
                                    where xsub_domain = global_domain 
                                    and   xsub_wolot  = xused_wolot
                                    and   xsub_part   = xused_part 
                                no-lock no-error.
                                if avail xsub_det then xused_sub_type  = yes . /*找得到层级的替代,就是联合替代1*/

                                repeat :
                                    find first xsub_det 
                                        use-index xsub_wolot_sub
                                        where xsub_domain  = global_domain 
                                        and   xsub_wolot   = xused_wolot
                                        and   xsub_subpart = xused_part_by 
                                    no-lock no-error.
                                    if not avail xsub_det then leave .
                                    else do:
                                        xused_part_by   = xsub_part .
                                        xused_sub_type  = yes . /*找得到层级的替代,就是联合替代2*/
                                    end.
                                end.
                            end.
                    end. /*for each xused_det */
                end. /*if not avail xuse_mstr then*/

                v_sn = "" .
                find first pt_mstr where pt_domain = global_domain and pt_part = v_newpart no-lock no-error.
                v_hide = if avail pt_mstr and pt__chr01 = "Y" then yes else no . 

                /*产生xbmd_det*/
                find first xbmd_det 
                    where xbmd_domain = global_domain 
                    and xbmd_lot      = v_lot 
                    and xbmd_comp     = v_newpart
                no-error .
                if not avail xbmd_det then do:
                        v_qty_crt = v_qty_bom .
                        /*产生xbmd_det*/
                        {xxbmmt003zb.i &lot="xbm_lot" &part="xbm_part" &wolot="xbm_wolot" 
                                        &comp="v_newpart" &compby="v_newpart" 
                                        &qtybom="v_qty_crt"  &sn="v_sn" &hide="v_hide"  }

                    /*ZP件产生了xbmd_det,要产生xbmzp_det*/
                    v_qty_crt  = 0 .
                    v_qty_left = v_qty_bom .
                    find first xuse_mstr 
                        where xuse_domain = global_domain 
                        and xuse_wolot    = v_newwo
                        and xuse_zppart   = v_newpart
                        and xuse_qty_rct - xuse_qty_used > 0 
                    no-error .
                    if avail xuse_mstr then do:
                        if v_qty_left >= xuse_qty_rct - xuse_qty_used then do:

                             assign v_qty_left    = v_qty_left - (xuse_qty_rct - xuse_qty_used)
                                    v_qty_bom     = xuse_qty_rct -  xuse_qty_used
                                    xuse_qty_used = xuse_qty_rct .
                        end.
                        else assign v_qty_bom     = v_qty_left 
                                    xuse_qty_used = xuse_qty_used + v_qty_left
                                    v_qty_left    = 0     .

                        for each xused_det
                            where xused_domain = global_domain 
                            and xused_wolot    = v_newwo 
                            exclusive-lock 
                            break by xused_wolot by xused_part_by by xused_part:
                            
                            if xused_qty_iss - xused_qty_used <= 0 then next .
                            find first xbmzp_det 
                                where xbmzp_domain = global_domain 
                                and   xbmzp_lot    = v_lot 
                                and   xbmzp_zppart = v_newpart
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
                                {xxbmmt003zc.i &lot="xbm_lot" &part="xbm_part" &wolot="xbm_wolot" 
                                                &comp="xused_part" &compby="xused_part_by" 
                                                &qtybom="v_qty_crt" &sn="v_sn" &hide="v_hide" 
                                                &zppart="xused_zppart" &zpwo="xused_wolot"   }
                            end.

                        end. /*for each xused_det*/
                    end. /*if avail xuse_mstr*/
                end. /*if not avail xbmd_det*/


                /*删除返修前的原件*/
                for each xbmd_det where xbmd_domain = global_domain and xbmd_lot = v_lot and xbmd_comp = v_zppart exclusive-lock:
                    delete xbmd_det .
                end.
                for each xbmzp_det where xbmzp_domain = global_domain and xbmzp_lot = v_lot and xbmzp_zppart = v_zppart exclusive-lock:
                    delete xbmzp_det .
                end.
                
                /*标记BOM最后修改的方式等*/
                assign xbm_mthd_crt = "Rework"  
                       xbm_user_mod = global_userid
                       xbm_date_mod = today
                       xbm_time_mod = time 
                       .          

            end. /*newwoloop*/
        end. /*newloop*/
    end. /* zploop: */
end. /* mainloop: */





