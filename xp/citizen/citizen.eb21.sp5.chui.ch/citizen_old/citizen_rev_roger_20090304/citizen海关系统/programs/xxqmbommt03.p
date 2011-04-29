/* xxqmbommt03.p 海关零件单耗重算 & 海关BOM产生                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}
define var cu_part  as char format "x(18)" label "商品编码".
define var cu_part1 as char format "x(18)" label "至".
define var cu_ln   like xxcpt_ln format ">>>>>" label "商品序号" .
define var cu_ln1  like xxcpt_ln  format ">>>>>" label "至" .

define variable v_yn like mfc_logical initial yes label "调整重量误差".
define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*重量单位*/
define variable v_conv     like um_conv initial 1 no-undo.  /*重量单位转换率*/


define var v_wt_adjust like pt_net_wt .
define var v_wt_total like pt_net_wt .
define var v_wt_need  like pt_net_wt .
define var v_round1 as decimal .
define var v_round2 as integer .
define var v_round3 as decimal .
define var v_round4 as integer .

define var v_comp_conv like xxccpt_um_conv .
define var v_um     like xxcpt_um .
define var v_cu_um  like xxcpt_um .
define var v_cu_desc1  like pt_Desc1 .
define var v_cu_desc2  like pt_desc1 .
define var v_price     like xxcpt_price label "海关单价(USD)".


define frame a .


form
    skip(1)

    cu_ln     colon 18  
    cu_ln1    colon 45 
    cu_part    colon 18  
    cu_part1   colon 45   
    
    skip(1)
    v_yn      colon 18 /**/
    skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).


{wbrp01.i}
mainloop:
repeat:
    
    hide all no-pause . {xxtop.i}
    view frame  a  .
    clear frame a no-pause .

    if cu_part1 = hi_char then cu_part1 = "" .
    if cu_ln1 = 99999  then cu_ln1 = 0 .


    update cu_ln cu_ln1 cu_part cu_part1 v_yn with frame a editing:
        if frame-field="cu_part" then do:
            {mfnp01.i xxcpt_mstr cu_part xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
            if recno <> ? then do:
                disp xxcpt_cu_part @ cu_part  
                with frame a.
            end.
        end.
        else if frame-field="cu_part1" then do:
            {mfnp01.i xxcpt_mstr cu_part1 xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
            if recno <> ? then do:
                disp xxcpt_cu_part @ cu_part1  
                with frame a.
            end.
        end.
        else if frame-field="cu_ln" then do:
            {mfnp01.i xxcpt_mstr cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
            if recno <> ? then do:
                disp xxcpt_ln @ cu_ln  
                with frame a.
            end.
        end.
        else if frame-field="cu_ln1" then do:
            {mfnp01.i xxcpt_mstr cu_ln1 xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
            if recno <> ? then do:
                disp xxcpt_ln @ cu_ln1  
                with frame a.
            end.
        end.
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.
    end. /*update v_part*/
    assign cu_part cu_part1 cu_ln cu_ln1 v_yn.

    if cu_ln1 = 0   then cu_ln1 = 99999 .
    if cu_part1 = "" then cu_part1 = hi_char .




    printloop:
    do on error undo, retry:

        {gpselout.i &printType = "printer"
            &printWidth = 132
            &pagedFlag = " "
            &stream = " "
            &appendToFile = " "
            &streamedOutputToTerminal = " "
            &withBatchOption = "yes"
            &displayStatementType = 1
            &withCancelMessage = "yes"
            &pageBottomMargin = 6
            &withEmail = "yes"
            &withWinprint = "yes"
            &defineVariables = "yes"}

        {mfphead.i}
        for each xxcpt_mstr 
                where xxcpt_domain = global_domain 
                and xxcpt_ln >= cu_ln and xxcpt_ln <= cu_ln1
                and xxcpt_cu_part >= cu_part  and xxcpt_cu_part <= cu_part1 
                no-lock
            break by xxcpt_ln :

            find first xxps_mstr where xxps_domain = global_domain and xxps_par_ln = xxcpt_ln no-error .
            if not avail xxps_mstr then next .

            v_conv = 0 .
                
            if xxcpt_um = v_wt_um then do:
                v_conv = 1 .     /*成品海关到库存单位转换率*/
                v_wt_total = 0 .     /*累计重量*/
                v_wt_need  = 1.00 .  /*基准重量*/
                v_round1 = 0.00001 . v_round2 = 5 . v_round3 = 0.000000001 .  v_round4 = 9 . /*bom单位最小精确度*/
                
                for each xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcpt_ln :
                    delete xxcps_mstr .
                end.
                for each xxps_mstr where xxps_domain = global_domain and xxps_par_ln = xxcpt_ln :
                    find first xxcps_mstr where xxcps_domain = global_domain 
                        and xxcps_par_ln = xxps_par_ln 
                        and xxcps_comp_ln = xxps_comp_ln
                    no-error .
                    if not avail xxcps_mstr then do:
                        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = xxcps_comp no-lock no-error .
                        v_comp_conv = if avail xxccpt_mstr then xxccpt_um_conv else 1 .

                        create xxcps_mstr .
                        assign
                            xxcps_domain     = global_domain 
                            xxcps_userid     = global_userid
                            xxcps_cr_date    = today 
                            xxcps_par_ln     = xxps_par_ln
                            xxcps_comp_ln    = xxps_comp_ln 
                            xxcps_par        = xxps_par
                            xxcps_comp       = xxps_comp 
                            xxcps_cu_par     = xxcpt_cu_part
                            xxcps_cu_comp    = ""
                            xxcps_um         = xxps_um
                            xxcps_wt         = xxps_wt
                            xxcps_wt_par     = v_wt_need 
                            xxcps_cu_um      = xxps_cu_um
                            xxcps_wt_conv    = if xxps_cu_um = v_wt_um then 1 
                                               else if xxps_wt / v_comp_conv <= 0 then 0
                                               else if xxps_wt / v_comp_conv  <= v_round1 then  v_round1
                                               else round(xxps_wt / v_comp_conv ,v_round2)                            
                            xxcps_cu_qty_per = if xxps_cu_qty_per_b * v_conv <= 0 then 0 
                                               else if xxps_cu_qty_per_b * v_conv <= v_round1 then  v_round1
                                               else round(xxps_cu_qty_per_b * v_conv,v_round2)                             
                            .
                            
                    end.
                end.

                for each xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcpt_ln :
                    find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = xxcps_comp no-lock no-error .
                    if avail xxccpt_mstr then do:
                        if xxccpt_attach = yes then next.
                        else do :
                            if xxcps_cu_um = v_wt_um then v_wt_total = v_wt_total + xxcps_cu_qty_per .
                            else v_wt_total = v_wt_total + if xxcps_cu_qty_per * xxcps_wt <= 0 then 0 
                                                           else if xxcps_cu_qty_per * xxcps_wt <= v_round3 then  v_round3
                                                           else round(xxcps_cu_qty_per * xxcps_wt,v_round4) . 
                        end.
                    end.                    
                end.

                if v_wt_need - v_wt_total <>0 and v_yn then do :
                    if v_wt_need - v_wt_total > 0 then 
                         v_wt_adjust = if v_wt_need - v_wt_total <= v_round1 then  v_round1
                                       else round(v_wt_need - v_wt_total, v_round2) .
                    else v_wt_adjust = if -(v_wt_need - v_wt_total ) <= v_round1 then  - v_round1
                                       else round(v_wt_need - v_wt_total, v_round2) .
                    for each xxcps_mstr 
                        where xxcps_domain = global_domain 
                        and xxcps_par_ln = xxcpt_ln 
                        and xxcps_cu_um = v_wt_um 
                        and (can-find(first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = xxcps_comp and xxccpt_attach = no no-lock))
                        break by xxcps_par_ln by xxcps_cu_qty_per :
                        if last-of(xxcps_par_ln) then xxcps_cu_qty_per = xxcps_cu_qty_per + v_wt_adjust .
                    end.
                end.

            end. /*if xxcpt_um = v_wt_um*/
            else do:  /*if xxcpt_um <> v_wt_um*/
                v_wt_total = 0 . /*累计重量*/
                v_round1 = 0.00001 .  v_round2 = 5 . v_round3 = 0.000000001 .  v_round4 = 9 . /*bom单位最小精确度*/
                
                find first pt_mstr where  pt_domain = global_domain and pt_part = xxps_par no-lock no-error .
                if avail pt_mstr then do:
                    if xxcpt_um <> pt_um then do:
                        {gprun.i ""gpumcnv.p""
                            "(xxcpt_um , pt_um ,  pt_um  , output v_conv)"}
                        if v_conv = ? then v_conv = 0.
                    end.
                    else v_conv = 1 .
                end.
                else v_conv = 0 . /*成品海关到库存单位转换率*/

                v_wt_need  = if xxps_wt_par * v_conv > truncate(xxps_wt_par  * v_conv,2) then 
                                  truncate(xxps_wt_par  * v_conv,2) + 0.01 
                             else truncate(xxps_wt_par * v_conv,2) .   /*基准重量*/ 

                for each xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcpt_ln :
                    delete xxcps_mstr .
                end.
                for each xxps_mstr where xxps_domain = global_domain and xxps_par_ln = xxcpt_ln :
                    find first xxcps_mstr where xxcps_domain = global_domain 
                        and xxcps_par_ln = xxps_par_ln 
                        and xxcps_comp_ln = xxps_comp_ln
                    no-error .
                    if not avail xxcps_mstr then do:
                        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = xxps_comp no-lock no-error .
                        v_comp_conv = if avail xxccpt_mstr then xxccpt_um_conv else 1 .

                        create xxcps_mstr .
                        assign
                            xxcps_domain     = global_domain 
                            xxcps_userid     = global_userid
                            xxcps_cr_date    = today 
                            xxcps_par_ln     = xxps_par_ln
                            xxcps_comp_ln    = xxps_comp_ln 
                            xxcps_par        = xxps_par
                            xxcps_comp       = xxps_comp 
                            xxcps_cu_par     = xxcpt_cu_part
                            xxcps_cu_comp    = ""
                            xxcps_um         = xxps_um
                            xxcps_wt         = xxps_wt 
                            xxcps_wt_par     = v_wt_need 
                            xxcps_cu_um      = xxps_cu_um
                            xxcps_wt_conv    = if xxps_cu_um = v_wt_um then 1 
                                               else if xxps_wt / v_comp_conv <= 0 then 0
                                               else if xxps_wt / v_comp_conv  <= v_round1 then  v_round1
                                               else round(xxps_wt / v_comp_conv ,v_round2) 
                            xxcps_cu_qty_per = if xxps_cu_qty_per * v_conv <= 0 then 0 
                                               else if xxps_cu_qty_per * v_conv <= v_round1 then  v_round1
                                               else round(xxps_cu_qty_per * v_conv,v_round2) 
                            .
                            
                    end.
                end. 
                
                for each xxcps_mstr where xxcps_domain = global_domain and xxcps_par_ln = xxcpt_ln :
                    find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = xxcps_comp no-lock no-error .
                    if avail xxccpt_mstr then do:
                        if xxccpt_attach = yes then next.
                        else do :
                            if xxcps_cu_um = v_wt_um then v_wt_total = v_wt_total + xxcps_cu_qty_per .
                            else v_wt_total = v_wt_total + if xxcps_cu_qty_per * xxcps_wt <= 0 then 0 
                                                           else if xxcps_cu_qty_per * xxcps_wt <= v_round3 then  v_round3
                                                           else round(xxcps_cu_qty_per * xxcps_wt,v_round4) . 
                        end.
                    end.                    
                end.
                
                if v_wt_need - v_wt_total <> 0 and v_yn then do :
                
                    if v_wt_need - v_wt_total > 0 then 
                         v_wt_adjust = if v_wt_need - v_wt_total <= v_round1 then  v_round1
                                       else round(v_wt_need - v_wt_total, v_round2) .
                    else v_wt_adjust = if -(v_wt_need - v_wt_total ) <=  v_round1 then  - v_round1
                                       else round(v_wt_need - v_wt_total, v_round2) .
                    for each xxcps_mstr 
                        where xxcps_domain = global_domain 
                        and xxcps_par_ln = xxcpt_ln 
                        and xxcps_cu_um = v_wt_um 
                        and (can-find(first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = xxcps_comp and xxccpt_attach = no no-lock))
                        break by xxcps_par_ln by xxcps_cu_qty_per :
                        if last-of(xxcps_par_ln) then xxcps_cu_qty_per = xxcps_cu_qty_per + v_wt_adjust .
                    end.
                end.
                
            end. /*if xxcpt_um <> v_wt_um*/

        end. /*for each xxcpt_mstr*/

        for each xxcps_mstr 
                where xxcps_domain = global_domain 
                and xxcps_par_ln >= cu_ln and xxcps_par_ln <= cu_ln1
                and xxcps_cu_par >= cu_part  and xxcps_cu_par <= cu_part1 
                break by xxcps_cu_par by xxcps_par_ln by xxcps_comp_ln 
            with frame x width 300:

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcps_comp_ln no-lock no-error .
            xxcps_cu_comp = if avail xxcpt_mstr then xxcpt_cu_part else "" .
            v_cu_desc2 = if avail xxcpt_mstr then xxcpt_desc else "" .
            v_price    = if avail xxcpt_mstr then xxcpt_price else  0 .

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxcps_par_ln no-lock no-error .
            v_cu_desc1 = if avail xxcpt_mstr then xxcpt_desc else "" .
            v_cu_um    = if avail xxcpt_mstr then xxcpt_um   else "" .

            disp 
                 xxcps_par_ln     label "父商品序"
                 xxcps_cu_par     label "父商品编码" 
                 v_cu_desc1       label "海关品名"
                 v_cu_um          label "海关单位" 
                 xxcps_wt_par     label "重量(KG)"
                 xxcps_comp_ln    label "子商品序"
                 xxcps_cu_comp    label "子商品编码"
                 v_cu_desc2       label "海关品名" 
                 v_price          label "海关单价(USD)"
                 xxcps_cu_qty_per label "单耗"
                 xxcps_cu_um      label "海关单位"
                 xxcps_wt         label "第二单位"
                                         
            with frame x .

        end. /*for each xxcps_mstr*/


        {mfreset.i}  /*{mfrtrail.i}   REPORT TRAILER  */
        {wbrp04.i &frame-spec = a}
    end. /*printloop:*/ 

end. /*mainloop*/
