/* xxqmbommt02.p 海关成品单重计算                                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}

define var cu_part  as char format "x(18)" label "商品编码".
define var cu_part1 as char format "x(18)" label "至".
define var cu_ln like xxcpt_ln format ">>>>>" label "商品序号" .
define var cu_ln1 like xxcpt_ln  format ">>>>>" label "至" .
define var v_part as char format "x(18)" label "父零件".
define var updt_all like mfc_logical label "更新" initial yes .
define var v_error like mfc_logical label "有误" initial no .
define var v_message as char format "x(18)" .
define variable del-yn like mfc_logical initial no.
define variable v_yn like mfc_logical initial yes.
define variable v_wt_um    like  pt_net_wt_um initial "KG".  /*重量单位*/
define variable v_conv     like um_conv initial 1 no-undo.  /*重量单位转换率*/
define var v_total_wt      like pt_net_wt  .

define variable p_part like pt_part.
define variable site like si_site label "地点".
define variable eff_date as date label "生效日期".


find first icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if available icc_ctrl then icc_site else global_domain .

define temp-table temp2
        field t2_part         like ps_par label "父零件" 
        field t2_ln           like xxcpt_ln 
        field t2_wt           like pt_net_wt label "每台单重" 
        index t2_part t2_part .

define temp-table temp1
        field t1_par         like ps_par label "父零件" 
        field t1_par_ln      like xxcpt_ln label "序号"
        field t1_cu_par      like xxcpt_cu_part 
        field t1_comp        like ps_comp  label "子零件"
        field t1_comp_ln     like xxcpt_ln label "序号"
        field t1_cu_comp     like xxcpt_cu_part 
        field t1_desc        like xxcpt_desc
        field t1_um          like pt_um
        field t1_cu_um       like pt_um
        field t1_um_conv     like um_conv
        field t1_qty_per     like ps_qty_per
        field t1_qty_cu      like ps_qty_per  format ">>>,>>9.9<<<<<<"
        field t1_wt          like pt_net_wt 
        field t1_attach      as logical 
        field t1_rmks        as char format "x(30)"
        index t1_parcomp     t1_par t1_comp.

eff_date = today.

define frame a .
define frame b .
define frame c .

form
    skip(1)
    site        colon 18
    eff_date    colon 18
    cu_ln       colon 18  
    cu_ln1      colon 45 
    cu_part     colon 18  
    cu_part1    colon 45 


    skip(1)
    updt_all  colon 18
    skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form
 space(1)   v_part xxcpt_ln label "商品序"   t2_wt   label "每台单重KG"     
    /*pt_desc1 no-label colon 13 pt_desc2 no-label  colon 45 */
with frame b side-labels width 80 attr-space title color normal "成品".

form                
    p_part       label "子零件"
    t1_qty_per   label "单耗"
    t1_um        label "UM"
    t1_wt        label "净重(KG)"
    t1_comp_ln   label "商品序"   
    t1_qty_cu            label "单耗"  
    t1_cu_um             label "UM"
with frame c three-d overlay 13 down scroll 1 width 80 title color normal "材料明细" . 

{wbrp01.i}
mainloop:
repeat:
    for each temp1: delete temp1. end.
    for each temp2: delete temp2. end.

        
    hide all no-pause . {xxtop.i}
    view frame  a  .
    clear frame a no-pause .

    if cu_part1 = hi_char then cu_part1 = "" .
    if cu_ln1 = 99999  then cu_ln1 = 0 .


    update site eff_date cu_ln cu_ln1 cu_part cu_part1 updt_all with frame a editing:
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
    assign site eff_date  cu_part cu_part1 cu_ln cu_ln1 updt_all .

    if eff_date = ?  then do:
        message "错误:生效日期有误,请重新输入." .
        undo,retry .
    end.

    if not can-find(si_mstr  where si_mstr.si_domain = global_domain and si_site = site)
    then do:        
        {mfmsg.i 708 3} /* SITE DOES NOT EXIST */
        next-prompt site.
        undo, retry.
    end.

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
            no-lock break by xxcpt_ln :

            for each xxccpt_mstr 
                where xxccpt_domain = global_domain 
                and xxccpt_ln = xxcpt_ln 
                no-lock break by xxccpt_ln by xxccpt_part:

                if first-of(xxccpt_ln) then assign p_part = "" .
                
                if xxccpt_key_bom = yes then p_part = xxccpt_part .
                
                if last-of(xxccpt_ln) and p_part <> "" then do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = p_part no-lock no-error.
                    if not avail pt_mstr then next .
                    find first ps_mstr where ps_domain = global_domain and ps_par = p_part no-lock no-error.
                    if not avail ps_mstr then next .
                    
                    run process_report (input p_part ,input eff_date ,input site).  
                end.
                
            end. /*for each xxccpt_mstr*/

        end. /*for each xxcpt_mstr*/

        for each temp1 
            break by t1_par by t1_comp 
            with frame x width 300 :

            if first-of(t1_par) then do:
                v_total_wt = 0 .
            end.

            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t1_par no-lock no-error.
            if not avail xxccpt_mstr then assign t1_rmks = "成品海关零件不存在".
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error.
                if avail xxcpt_mstr then assign t1_par_ln = xxcpt_ln t1_cu_par = xxcpt_cu_part .
                else assign t1_rmks = "成品海关商品编码不存在" .
            end.

            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t1_comp no-lock no-error.
            if not avail xxccpt_mstr then  assign t1_rmks = "零件海关零件不存在" .
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error.
                if avail xxcpt_mstr then 
                    assign  t1_comp_ln = xxcpt_ln 
                            t1_cu_comp = xxcpt_cu_part
                            t1_desc    = xxcpt_desc
                            t1_cu_um   = xxcpt_um 
                            t1_um_conv = xxccpt_um_conv
                            t1_attach  = xxccpt_attach
                            t1_qty_cu  = xxccpt_um_conv * t1_qty_per .
                else  assign t1_rmks = "零件海关商品编码不存在" .
            end.

            find first pt_mstr where pt_domain = global_domain and pt_part = t1_comp no-lock no-error.
            if avail pt_mstr then do:
                if v_wt_um <> pt_net_wt_um then do:
                      {gprun.i ""gpumcnv.p""
                         "(pt_net_wt_um , v_wt_um ,  v_wt_um  , output v_conv)"}
                      if v_conv = ? then  assign v_conv = 0  t1_rmks = "零件净重单位不存在" .
                end.
                else v_conv = 1.                    
                t1_wt = pt_net_wt * v_conv .
            end.
           
            disp  t1_par_ln    label "成品序号"
                  t1_cu_par    label "父商品编码"
                  t1_par       label "父零件" 
                  t1_comp_ln   label "零件序号"
                  t1_cu_comp   label "子商品编码"
                  t1_desc      label "品名"
                  t1_comp      label "子零件"
                  t1_qty_per   label "单耗"
                  t1_um        label "单位"
                  t1_wt        label "净重(KG)"
                  t1_attach    label "附属件"
                  /*t1_um_conv   label "单位换算因子"*/
                  t1_qty_cu    label "单耗"
                  t1_cu_um     label "海关单位"            
                  t1_rmks      label "备注"

            with frame x .

            if t1_attach = no then v_total_wt = v_total_wt + t1_wt * t1_qty_per .

            if last-of(t1_par) then do:
                find first temp2 where t2_part = t1_par no-error.
                if not avail temp2 and t1_par_ln <> 0 then do:
                    create temp2.
                    assign t2_part = t1_par t2_ln = t1_par_ln.
                end.
                t2_wt = v_total_wt .

                down 1 with frame x.
                disp "==========" @ t1_cu_par                    
                     "==========" @ t1_par   
                     "==========" @ t1_wt 
                     with frame x .

                down 1 with frame x.
                disp "成品单重:" @ t1_cu_par                    
                     t1_par   
                     v_total_wt   @ t1_wt 
                     with frame x .

            end.

        end. /*for each temp1*/


        {mfreset.i}  /*{mfrtrail.i}   REPORT TRAILER  */
        {wbrp04.i &frame-spec = a}
    end. /*printloop:*/

find first temp1 no-error .
if not avail temp1 then do:
    message "警告:无记录." view-as alert-box .
end.




if updt_all then do:
    hide all no-pause .
    {xxtop.i}
    view frame b .
    view frame c .
    clear frame b no-pause .

    find first temp2 no-error .
    if avail temp2 then do:
        v_part = t2_part .
        find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
        if avail pt_mstr then do:
            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = pt_part no-lock no-error .
            if avail xxccpt_mstr then do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                if avail xxcpt_mstr then do:
                    disp t2_wt v_part xxcpt_ln  with frame b .
                    message "商品编码:" xxcpt_cu_part "品名" xxcpt_desc .
                end.
            end.            
        end.
    end.
    
    updateloop:
    repeat on error undo, retry :
        update v_part with frame b editing:
            if frame-field="v_part" then do:
                {mfnp.i temp2 v_part t2_part v_part t2_part t2_part}
                if recno <> ? then do:
                    find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
                    if avail pt_mstr then do:
                        find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = pt_part no-lock no-error .
                        if avail xxccpt_mstr then do:
                            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                            if avail xxcpt_mstr then do:
                                disp t2_wt pt_part @ v_part xxcpt_ln  with frame b .
                                message "商品编码:" xxcpt_cu_part "品名" xxcpt_desc .
                            end.
                        end.            
                    end.
                end.
            end.
            else do:
                status input ststatus.
                readkey.
                apply lastkey.
            end.
        end.
        assign v_part .


        
        find first temp2 where t2_part = v_part no-error .
        if not avail temp2 then do:
            message "错误:父零件号不存在,请重新输入" .
            undo , retry .
        end.
        else do:
            find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error.
            if avail pt_mstr then do:
                find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = pt_part no-lock no-error .
                if avail xxccpt_mstr then do:
                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                    if avail xxcpt_mstr then do:
                        disp t2_wt pt_part @ v_part xxcpt_ln  with frame b .
                        message "商品编码:" xxcpt_cu_part "品名" xxcpt_desc .
                    end.
                end.            
            end.
            
            p_part = "" .

            setloop:
            repeat on endkey undo, leave:
                
                
                update p_part with frame c editing:
                    if frame-field="p_part" then do:
                        {mfnp01.i temp1 p_part t1_comp t2_part t1_par t1_parcomp }
                        if recno <> ? then do:
                            disp 
                                t1_comp @ p_part
                                t1_qty_per
                                t1_um
                                t1_wt
                                t1_comp_ln                           
                                t1_cu_um
                                t1_qty_cu  
                            with frame c.
                            message "商品编码:"t1_cu_comp "品名" t1_desc .
                        end.
                    end.
                    else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                    end.                
                end. /*update t1_comp*/
                assign  p_part. 


                find first temp1 where t1_par = t2_part and t1_comp = p_part no-error .
                if not avail temp1  then do:
                    message "子零件不存在,请重新输入" .
                    undo,retry.
                end. 

                disp 
                    t1_comp @ p_part
                    t1_qty_per
                    t1_um
                    t1_wt
                    t1_comp_ln
                    t1_cu_um
                    t1_qty_cu  
                with frame c.
                message "商品编码:"t1_cu_comp "品名" t1_desc .
                
                qtyloop:
                do on error undo, retry:
                    update t1_qty_per   
                           go-on(F5 CTRL-D) 
                    with frame c.

                    if t1_qty_per < 0 or t1_qty_per = ? then do:
                        message "单耗有误,请重新输入" .
                        undo, retry.
                    end.

                    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                    then do:
                       del-yn = yes.
                       /* Please confirm delete */
                       {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                       if del-yn then do:
                            delete temp1.
                            clear frame c.
                            del-yn = no.

                            v_total_wt = 0 .
                            for each temp1 
                                    where t1_par = t2_part 
                                    and t1_attach = no :
                                v_total_wt = v_total_wt + t1_wt * t1_qty_per .
                            end.
                            t2_wt = v_total_wt .

                            disp t2_wt with frame b .

                            next.
                       end.
                    end.

                    t1_qty_cu = t1_um_conv * t1_qty_per .
                    disp t1_qty_cu with frame c .
                    

                    v_total_wt = 0 .
                    for each temp1 
                            where t1_par = t2_part 
                            and t1_attach = no :
                        v_total_wt = v_total_wt + t1_wt * t1_qty_per .
                    end.

                    t2_wt = v_total_wt .

                    disp t2_wt with frame b .
                    

                end. /*qtyloop*/
            end. /*setloop:*/
            
            /*do on error undo,retry :
                update t2_wt with frame b .

                if t2_wt <= 0  then do:
                    message "错误:单重只可为正" .
                    undo ,retry .
                end.
            end.  */

        end. /*if avail temp2 then do:*/
    end. /*updateloop:*/


    {mfmsg01.i 32 1 v_yn}  /*确认更新*/
    if v_yn then do:
        v_error = no .
        for each temp1 where t1_qty_per > 0 break by t1_par by t1_comp :
            
            v_message = "" .

            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t1_par no-lock no-error.
            if not avail xxccpt_mstr then assign v_error = yes  v_message = "成品海关零件不存在".
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error.
                if avail xxcpt_mstr then assign t1_par_ln = xxcpt_ln t1_cu_par = xxcpt_cu_part .
                else assign v_error = yes  v_message = "成品海关商品编码不存在" .
            end.

            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t1_comp no-lock no-error.
            if not avail xxccpt_mstr then  assign v_error = yes v_message = "零件海关零件不存在" .
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error.
                if not avail xxcpt_mstr then assign v_error = yes v_message = "零件海关商品编码不存在" .
            end.

            find first pt_mstr where pt_domain = global_domain and pt_part = t1_comp no-lock no-error.
            if avail pt_mstr then do:
                if v_wt_um <> pt_net_wt_um then do:
                      {gprun.i ""gpumcnv.p""
                         "(pt_net_wt_um , v_wt_um ,  v_wt_um  , output v_conv)"}
                      if v_conv = ? then  assign v_error = yes  v_conv = 0  v_message = "零件净重单位不存在" .
                end.
                else v_conv = 1.                    
            end.

            if v_message <> ""  then do:
                message "错误:资料有误:" skip
                        "成品:" t1_par ",材料:" t1_comp skip
                        v_message 
                view-as alert-box.                        
            end.
        end. /*for each temp1*/

        if v_error then do:
            message "错误:不允许更新!" view-as alert-box.
            undo ,retry .
        end.

        for each temp2:
            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = t2_ln no-lock no-error.
            if avail xxcpt_mstr then do:
                t2_wt = if xxcpt_um = v_wt_um then round(t2_wt,4) else round(t2_wt,6).

                for each xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_ln = xxcpt_ln :
                    /*更新同商品序号的所有工厂零件*/
                    if xxcpt_um = v_wt_um then assign xxccpt_um_conv = t2_wt .
                    for each pt_mstr where pt_domain = global_domain and pt_part = xxccpt_part :
                        assign 
                            pt_net_wt = t2_wt 
                            pt_net_wt_um = v_wt_um .
                    end.

                end.
            end.

            for each xxps_mstr where xxps_domain = global_domain and xxps_par_ln = t2_ln :
                delete xxps_mstr .
            end.

            for each temp1 where t1_par = t2_part and t1_qty_per > 0 :
                find first xxps_mstr where xxps_domain = global_domain and xxps_par_ln = t1_par_ln and xxps_comp_ln = t1_comp_ln no-error.
                if not avail xxps_mstr then do:
                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = t1_comp_ln no-error.

                    create xxps_mstr.
                    assign 
                        xxps_domain  = global_domain 
                        xxps_par     = t1_par
                        xxps_par_ln  = t1_par_ln
                        xxps_comp    = t1_comp
                        xxps_comp_ln = t1_comp_ln
                        xxps_um      = t1_um
                        xxps_wt      = /*t1_wt when (t1_attach = no )*/ if avail xxcpt_mstr then xxcpt_wt_conv else 0 
                        xxps_cu_um   = t1_cu_um                        
                        xxps_wt_par     = t2_wt /*每台单重*/
                        xxps_userid     = global_userid
                        xxps_cr_date    = today
                        xxps_qty_per    = t1_qty_per
                        xxps_cu_qty_per = t1_qty_cu                        
                        xxps_qty_per_b    = t1_qty_per * round( 1 / t2_wt ,3) 
                        xxps_cu_qty_per_b = t1_qty_cu  * round( 1 / t2_wt ,3) 
                        xxps_wt_b         = t1_wt  * round( 1 / t2_wt ,3)  * t1_qty_per when (t1_attach = no )
                        .
/*----------------------------------------------小数精确度, 筛选(attach) , ----------------------------------------------------------------*/
                end.
                else do:
                    assign 
                        xxps_qty_per    = xxps_qty_per + t1_qty_per
                        xxps_cu_qty_per = xxps_cu_qty_per + t1_qty_cu
                        xxps_qty_per_b    = xxps_qty_per_b + t1_qty_per  * round( 1 / t2_wt ,3) 
                        xxps_cu_qty_per_b = xxps_cu_qty_per_b + t1_qty_cu  * round( 1 / t2_wt ,3) 
                        xxps_wt_b         = xxps_wt_b + t1_wt  * round( 1 / t2_wt ,3)  * t1_qty_per when (t1_attach = no )
                        .
                end.
            end. /*for each temp1*/
        end. /*for each temp2*/
    end. /*if v_yn then*/
end.  /*if updt_all then*/   

end. /*mainloop*/




/*--------------------------------------------------------------------------------------------------------*/


/*
                
         
procedure process_report:
    define input  parameter vv_part as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    define input  parameter vv_site as character .
    
    define var  vv_comp like ps_comp no-undo.
    define var  vv_level as integer no-undo.
    define var  vv_record as integer extent 100.
    define var  vv_qty as decimal initial 1 no-undo.
    define var  vv_save_qty as decimal extent 100 no-undo.
    define var  vv_pm_code like ptp_pm_code no-undo .
    
    
    


    assign vv_level = 1 vv_qty = 1 vv_comp = vv_part  .

    find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
    repeat:        
               if not avail ps_mstr then do:                        
                     repeat:  
                        vv_level = vv_level - 1.
                        if vv_level < 1 then leave .                    
                        find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                        vv_comp  = ps_par.  
                        vv_qty = vv_save_qty[vv_level].            
                        find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                        if avail ps_mstr then leave .               
                    end.
                end.  /*if not avail ps_mstr*/
            
                if vv_level < 1 then leave .
                vv_record[vv_level] = recid(ps_mstr).                
                
                
                if (ps_end = ? or vv_eff_date <= ps_end) then do :
                       vv_save_qty[vv_level] = vv_qty.
                       
                
                       vv_pm_code = "" .   
                       find ptp_det where ptp_domain = global_domain and ptp_part = ps_comp and ptp_site = vv_site no-lock no-error .
                       if avail ptp_det then do :
                             vv_pm_code = ptp_pm_code  .                             
                       end.
                       else do:
                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                            vv_pm_code = if avail pt_mstr then pt_pm_code else "" .
                       end.
                       
                       /*if ps_ps_code = "x" then vv_pm_code = "P"  . */

                              
                              
                     if vv_pm_code <> "P" then do:
                               vv_comp  = ps_comp .
                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                               if not avail ps_mstr then do:
                                    find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                                    /*create */
                                    find first temp1 where t1_par = vv_part and t1_comp = ps_comp no-error.
                                    if not available temp1 then do:
                                        find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                        create temp1.
                                        assign
                                            t1_par      = caps(vv_part)
                                            t1_comp     = caps(ps_comp)
                                            t1_um       = (if available pt_mstr then pt_um else "")
                                            t1_qty_per  = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct))
                                            .
                                    end.
                                    else t1_qty_per   = t1_qty_per + vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)) .  
                               end.

                               vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                               vv_level = vv_level + 1.
                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
                     end. /*if vv_pm_code <> "P"*/
                     else do :
                                /*create */
                                find first temp1 where t1_par = vv_part and t1_comp = ps_comp no-error.
                                if not available temp1 then do:
                                    find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                    create temp1.
                                    assign
                                        t1_par      = caps(vv_part)
                                        t1_comp     = caps(ps_comp)
                                        t1_um       = (if available pt_mstr then pt_um else "")
                                        t1_qty_per  = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct))
                                        .
                                end.
                                else t1_qty_per   = t1_qty_per + vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)) .  
                               find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp no-lock no-error.
                     end. /*if vv_pm_code = "P"*/      
                end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
                else do:
                      find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
    
    
    end. /*repeat:*/   

end procedure.

*/

                
         
procedure process_report:
    define input  parameter vv_part as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    define input  parameter vv_site as character .
    
    define var  vv_comp like ps_comp no-undo.
    define var  vv_level as integer no-undo.
    define var  vv_record as integer extent 100.
    define var  vv_qty as decimal initial 1 no-undo.
    define var  vv_save_qty as decimal extent 100 no-undo.
    define var  vv_pm_code like ptp_pm_code no-undo .
    define var  vv_recno    like recno .
    
    



    assign vv_level = 1 vv_qty = 1 vv_comp = vv_part  /*vv_site = ""*/ .

    find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
    repeat:        
               if not avail ps_mstr then do:                        
                     repeat:  
                        vv_level = vv_level - 1.
                        if vv_level < 1 then leave .                    
                        find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                        vv_comp  = ps_par.  
                        vv_qty = vv_save_qty[vv_level].            
                        find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                        if avail ps_mstr then leave .               
                    end.
                end.  /*if not avail ps_mstr*/
            
                if vv_level < 1 then leave .
                vv_record[vv_level] = recid(ps_mstr).                
                
                
                if (ps_end = ? or vv_eff_date <= ps_end) then do :
                       vv_save_qty[vv_level] = vv_qty.
                       
                
                       vv_pm_code = "" .   
                       find ptp_det where ptp_domain = global_domain and ptp_part = ps_comp and ptp_site = vv_site no-lock no-error .
                       if avail ptp_det then do :
                             vv_pm_code = ptp_pm_code  .                             
                       end.
                       else do:
                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                            vv_pm_code = if avail pt_mstr then pt_pm_code else "" .
                       end.
                       
                       /*if ps_ps_code = "x" then vv_pm_code = "P"  . */

                              
                              
                     if vv_pm_code <> "P" then do:
                               vv_comp  = ps_comp .
                               vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                               vv_level = vv_level + 1.
                               vv_recno = recid(ps_mstr) .

                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                               if not avail ps_mstr then do:
                                    find ps_mstr where recid(ps_mstr) = vv_recno  no-lock no-error.
                                    if avail ps_mstr then do:
                                        /*create */
                                        find first temp1 where t1_par = vv_part and t1_comp = ps_comp no-error.
                                        if not available temp1 then do:
                                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                            create temp1.
                                            assign
                                                t1_par      = caps(vv_part)
                                                t1_comp     = caps(ps_comp)
                                                t1_um       = (if available pt_mstr then pt_um else "")
                                                t1_qty_per  = vv_qty 
                                                .
                                        end.
                                        else t1_qty_per   = t1_qty_per + vv_qty  .  
                                    end.
                               end.

                               
                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
                     end. /*if vv_pm_code <> "P"*/
                     else do :
                                /*create */
                                find first temp1 where t1_par = vv_part and t1_comp = ps_comp no-error.
                                if not available temp1 then do:
                                    find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                    create temp1.
                                    assign
                                        t1_par      = caps(vv_part)
                                        t1_comp     = caps(ps_comp)
                                        t1_um       = (if available pt_mstr then pt_um else "")
                                        t1_qty_per  = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct))
                                        .
                                end.
                                else t1_qty_per   = t1_qty_per + vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)) .  
                               find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp no-lock no-error.
                     end. /*if vv_pm_code = "P"*/      
                end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
                else do:
                      find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
    
    
    end. /*repeat:*/   

end procedure.
