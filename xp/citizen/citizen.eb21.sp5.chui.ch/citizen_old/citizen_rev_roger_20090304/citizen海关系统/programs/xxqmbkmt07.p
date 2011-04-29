/* xxqmbkmt07.p  零星出口报关单                                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 03/13/2008   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/




{mfdtitle.i "1+ "}    /* DISPLAY TITLE */

{xxqmbkmt07.i "NEW" } /* all defines */

define temp-table temp2 
field t2_id like abs_id .

v_bk_type = "OUT" .

mainloop:
repeat with frame h1 :
    ststatus = stline[1].
    status input ststatus.

    new_add = no .
    for each temp : delete temp . end.

    hide frame d1 no-pause .
    hide frame d2 no-pause .
    hide frame d3 no-pause .
    hide frame h1 no-pause .
    hide frame h2 no-pause .
    view frame h1 .
    view frame h2 .

    prompt-for v_nbr with frame h1 editing:
         if frame-field = "v_nbr" then do:    
             {mfnp01.i xxexp_mstr v_nbr xxexp_nbr global_domain xxexp_domain xxexp_nbr }

             if recno <> ? then do:
                v_nbr = xxexp_nbr .
                disp  v_nbr   xxexp_iss_date xxexp_req_date xxexp_bk_nbr  with frame h1 .
                disp xxexp_cu_nbr xxexp_pre_nbr xxexp_dept xxexp_ship_via  xxexp_ship_tool xxexp_bl_nbr 
                    xxexp_trade_mtd xxexp_tax_mtd xxexp_tax_rate xxexp_license xxexp_appr_nbr xxexp_contract
                    xxexp_container xxexp_from xxexp_to xxexp_port xxexp_fob xxexp_box_num xxexp_box_type 
                    xxexp_net xxexp_gross xxexp_curr xxexp_amt xxexp_stat xxexp_use xxexp_rmks1 xxexp_rmks2 
                with frame h2 .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign v_nbr  .
    
    if v_nbr = "" then do:
        message "单号不允许为空" .
        undo,retry.
    end.

    find first xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr no-lock no-error .
    if avail xxexp_mstr then do:
        if xxexp_type <> v_form_type then do:
            message "错误:已存在,且非'零星'出口报关单,请重新输入" .
            undo,retry .
        end.
        v_add = no .
        v_all = no .
        disp v_nbr v_add v_all xxexp_iss_date xxexp_req_date  xxexp_bk_nbr  with frame h1 .
        disp xxexp_cu_nbr xxexp_pre_nbr xxexp_dept xxexp_ship_via  xxexp_ship_tool xxexp_bl_nbr 
            xxexp_trade_mtd xxexp_tax_mtd xxexp_tax_rate xxexp_license xxexp_appr_nbr xxexp_contract
            xxexp_container xxexp_from xxexp_to xxexp_port xxexp_fob xxexp_box_num xxexp_box_type 
            xxexp_net xxexp_gross xxexp_curr xxexp_amt xxexp_stat xxexp_use xxexp_rmks1 xxexp_rmks2 
        with frame h2 .
    end.



    loopa:
    do on error undo , retry:
        
        find xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr  no-error .
        if not avail xxexp_mstr then do:            

            find first xxcbk_mstr 
                            where xxcbk_domain = global_domain
                            and xxcbk_stat     = "" 
            no-lock no-error . 

            find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-error.
            if not avail xxcbkc_ctrl then do:
                create xxcbkc_ctrl . xxcbkc_domain = global_domain .
            end.

            clear frame h1 no-pause .
            clear frame h2 no-pause .
            
            message "新增记录" .
            create xxexp_mstr .
            assign 
                xxexp_domain     = global_domain 
                xxexp_type       = v_form_type
                xxexp_nbr        = v_nbr 
                xxexp_userid     = global_userid
                xxexp_crt_date   = today
                xxexp_iss_date   = today
                xxexp_req_date   = today
                xxexp_bk_nbr     = if avail xxcbk_mstr then xxcbk_bk_nbr else ""               
                xxexp_amt        = 0
                xxexp_curr       = "USD"
                xxexp_dept       = xxcbkc_dept
                xxexp_trade_mtd  = xxcbkc_trade
                xxexp_ship_via   = xxcbkc_ship_via 
                xxexp_ship_tool  = xxcbkc_ship_tool
                xxexp_tax_mtd    = xxcbkc_tax_mtd
                xxexp_tax_rate   = xxcbkc_tax_ratio
                xxexp_port       = xxcbkc_imp
                xxexp_fob        = xxcbkc_fob 
                xxexp_from       = xxcbkc_frm_loc
                xxexp_to         = xxcbkc_loc       
                xxexp_box_type   = xxcbkc_box_type
                xxexp_bl_nbr     = xxcbkc_bl_nbr                   
                new_add = yes 
                v_add = yes 
                v_all = yes .

        end.
        else message "修改记录" .

        disp v_nbr  v_add v_all xxexp_iss_date xxexp_req_date xxexp_bk_nbr  with frame h1 .

        v_recid = recid(xxexp_mstr) .
        update 
            xxexp_iss_date 
            xxexp_req_date 
            xxexp_bk_nbr when ( new_add )
            v_add when ( new_add )
            v_all when ( new_add ) 
        go-on ("F5" "CTRL-D") with frame h1 editing :
                if frame-field = "xxexp_bk_nbr" then do:
                    {mfnp01.i xxcbk_mstr xxexp_bk_nbr xxcbk_bk_nbr "global_domain and xxcbk_stat = '' " xxcbk_domain xxcbk_bk_nbr }
                    if recno <> ? then do:
                        display  xxcbk_bk_nbr @ xxexp_bk_nbr with frame h1.
                    end.
                end.
                else do:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxexp_stat <> "" then do:
                            message "错误:非未结状态,不允许删除" . 
                            undo,retry .
                        end.
                        else do:
                            find first xxexpd_det 
                                    where xxexpd_domain = global_domain 
                                    and xxexpd_nbr = v_nbr 
                                    and (xxexpd_stat <> "" or xxexpd_used > 0)
                            no-lock no-error.
                            if avail xxexpd_det then do :
                                message "错误:明细非未结状态或已开始库存转移,不允许删除" . 
                                undo,retry .
                            end.
                            else do:
                                del-yn = yes.
                                {mfmsg01.i 11 1 del-yn}
                                if del-yn then do :
                                    for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr :
                                        find first abs_mstr 
                                            where abs_domain   = global_domain 
                                            and abs_par_id     = "S" + xxexpd_iss_nbr 
                                            and abs_type       = "S"
                                            and integer(abs_line) = xxexpd_iss_ln 
                                        no-error.
                                        if avail abs_mstr then assign abs__dec02 = abs__dec02 - xxexpd_iss_qty . 


                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxexp_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xxexp_bk_nbr 
                                            and xxcbkd_cu_ln  = xxexpd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_io = xxcbkd_qty_io - xxexpd_cu_qty  .

                                        delete xxexpd_Det.
                                    end.
                                    delete xxexp_mstr .
                                    clear frame h1 no-pause .
                                    next mainloop .
                                end.
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end.
        end. /* update ...EDITING */

        if xxexp_iss_date = ? then do:
            message "错误:无效出口日期,请重新输入." .
            next-prompt xxexp_iss_date with frame h1.
            undo,retry .
        end.
        if xxexp_req_date = ? then do:
            message "错误:无效出口日期,请重新输入." .
            next-prompt xxexp_req_date with frame h1.
            undo,retry .
        end.

        find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = xxexp_bk_nbr  no-error .
        if not avail xxcbk_mstr then do:
            message "错误:无效手册编号,请重新输入." .
            next-prompt xxexp_bk_nbr with frame h1.
            undo,retry .
        end.
        else if xxcbk_stat <> "" then do :
            message "错误:手册已结,请重新输入." .
            next-prompt xxexp_bk_nbr with frame h1.
            undo,retry .
        end.
        else do:
            find first xxcbkd_det 
                    where xxcbkd_domain = global_domain 
                    and xxcbkd_bk_type  = v_bk_type 
                    and xxcbkd_bk_nbr   = xxexp_bk_nbr 
                    and xxcbkd_stat     = ""
            no-error.
            if not avail xxcbkd_det then do:
                message "错误:无未结手册明细,请重新输入." .
                next-prompt xxexp_bk_nbr with frame h1.
                undo,retry .
            end.
        end.

     
    end. /*  loopa: */

    if v_add then do:
        for each temp : delete temp . end.
        for each temp2 : delete temp2 . end.


        v_abs_id = "" .
        for each abs_mstr use-index abs_par_id 
            where abs_domain = global_domain 
            and abs_id > "" 
            and abs_par_id = ""
            and abs_shp_date = xxexp_iss_date 
            and abs_type     = "S"
            /*and abs__chr02   = "CHA" */
            no-lock :

            find first temp2 where t2_id = abs_id no-error .
            if not avail temp2 then do:
                create temp2 .
                t2_id = abs_id .
            end.
        end.

        for each temp2,
            each abs_mstr use-index abs_par_id 
            where abs_domain = global_domain 
            and abs_par_id   = t2_id 
            and abs_shp_date = xxexp_iss_date 
            and abs_type     = "S"
            /*and abs__chr02   = "HK" */
            and abs__dec02 < abs_qty 
            no-lock :
        
            v_error = "" .
            v_abs_id = substring(abs_par_id,2,50) .

            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = abs_item no-lock no-error .
            if not avail xxccpt_mstr then do:
                message "警告: 海关零件" abs_item "不存在" ".货运单号:" v_abs_id . 
                v_error = "*ERROR*" .
            end.
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                if not avail xxcpt_mstr then do:
                    message "警告:零件" abs_item ",商品序" xxccpt_ln "无对应海关商品" ".货运单号:" v_abs_id . 
                    v_error = "*ERROR*" .
                end.
                else do:

                    
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xxexp_bk_nbr 
                            and xxcbkd_cu_ln    = xxcpt_ln 
                    no-error.
                    if not avail xxcbkd_det then do:
                        message "警告:手册无此零件" abs_item ",商品序" xxccpt_ln ".货运单号:" v_abs_id .
                        v_error = "*ERROR*" .
                    end.
                    else do:
                        if round((abs_qty - abs__dec02) * round(integer(abs__qad03) * xxccpt_um_conv,v_round2 + 2 ) , v_round2 ) > 
                           ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) then do:
                            message  "警告:手册余数不足,零件" abs_item ",商品序" xxccpt_ln ".货运单号:" v_abs_id . 
                            v_error = "*ERROR*" .
                        end.
                    end.
                end.
            end.
            if v_error <> "" then pause .
            
            create temp .
            assign 
                t_nbr      = v_abs_id 
                t_line     = integer(abs_line) 
                t_ponbr    = abs_order 
                t_vend     = "" 
                t_rcp_date = abs_shp_date
                t_cu_ln    = if avail xxcpt_mstr     then xxcpt_ln else 0 
                t_cu_part  = if avail xxcpt_mstr     then xxcpt_cu_part else v_error 
                t_ctry     = if avail xxccpt_mstr    then xxccpt_ctry else v_error 
                t_part     = abs_item
                t_um       = abs__qad02
                t_um_conv1 = integer(abs__qad03) 
                t_um_conv2 = if avail xxccpt_mstr    then xxccpt_um_conv else 1
                t_rcvd     = abs_qty - abs__dec02 
                t_yn       = if v_error <> ""then no else v_all .


        end. /*for each abs_mstr */

        find first temp  no-error.
        if avail temp then do:
            hide frame h2 no-pause.
            {gprun.i ""xxqmbkmt07a.p""}        
        end.
        else do:
            message "警告:无符合条件的货运单." .
            undo ,retry.
        end.

        if info_correct then do:

             for each temp where t_yn = yes :
                    find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t_part no-lock no-error .
                    if not avail xxccpt_mstr then do:
                        message "警告:海关零件" t_part "不存在" ".货运单号:" t_nbr .
                        next .
                    end.
                    else do:
                        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                        if not avail xxcpt_mstr then do:
                            message "警告:零件" t_part ",商品序" xxccpt_ln "无对应海关商品" ".货运单号:" t_nbr .
                            next .
                        end.
                    end. 
                    
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xxexp_bk_nbr 
                            and xxcbkd_cu_ln    = t_cu_ln 
                    no-error.
                    if not avail xxcbkd_det then do:
                        message "警告:手册无此商品序:" t_cu_ln "零件" t_part ".货运单号:" t_nbr .
                        next.
                    end.
                    else do: 
                        if round(t_rcvd  * round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) , v_round2 ) > 
                           ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) then do:
                            message  "警告:手册余数不足:" t_cu_ln "零件" t_part ".货运单号:" t_nbr .
                            next.
                        end.
                        else do:
                            find last xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-lock no-error.
                            if avail xxexpd_det then do:
                                v_line = xxexpd_line + 1 .
                            end.
                            else v_line  = 1 .  
                            
                            find xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr and xxexpd_line = v_line  no-error.
                            if not avail xxexpd_det then do:
                                new_add = yes .
                                create xxexpd_det .
                                xxexpd_domain    = global_domain .
                                xxexpd_type      = v_form_type .
                                xxexpd_nbr       = v_nbr .
                                xxexpd_line      = v_line .
                                xxexpd_iss_nbr   = t_nbr.
                                xxexpd_iss_ln    = t_line . 
                                xxexpd_iss_order = t_ponbr.
                                xxexpd_iss_part  = t_part.
                                xxexpd_iss_qty   = t_rcvd  .  
                                xxexpd_iss_date  = t_rcp_date .
                                xxexpd_um        = t_um.
                                xxexpd_um_conv   = round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) .                                
                                xxexpd_cu_ln     = xxcbkd_cu_ln .
                                xxexpd_cu_part   = xxcbkd_cu_part .                                
                                xxexpd_cu_um     = xxcbkd_um .
                                xxexpd_cu_qty    = round(t_rcvd  * xxexpd_um_conv, v_round2) . 
                                xxexpd_ctry      = t_ctry .
                                xxexpd_price     = xxcbkd_price .
                                xxexpd_amt       = xxexpd_price * xxexpd_cu_qty .

                                xxcbkd_qty_io   = xxcbkd_qty_io + xxexpd_cu_qty .     /*扣减手册数量*/

                                find first abs_mstr where abs_domain = global_domain and abs_par_id = "S" + t_nbr and integer(abs_line) = t_line no-error .
                                if avail abs_mstr then do :
                                    abs__dec02 = abs__dec02  + xxexpd_iss_qty .  /*扣减abs数量*/
                                end.
                            end.  
                        end. /*手册余数足*/
                    end. /*if avail xxcbkd_det*/
            end. /*for each temp*/
        end. /*if info_correct */
        else do:
            undo , retry .
        end.
    end. /*if v_add then do:*/

    {gprun.i ""xxqmbkmt07b.p""}   /*details*/

    view frame h1 .
    view frame h2 .
    if new_add then do:        
        xxexp_amt = 0 .
        for each  xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
            xxexp_amt = xxexpd_amt + xxexp_amt .
        end.
    end.
    else do:
        v_amt = 0 .
        for each  xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
            v_amt = xxexpd_amt + v_amt .
        end.
        if v_amt <> xxexp_amt then do:
            message "警告:总金额不一致:" v_amt "" xxexp_amt .
        end.
    end.

    {gprun.i ""xxqmbkmt07c.p""} 
    
    release xxexpd_det no-error.
    release xxexp_mstr no-error .

end.   /*  mainloop: */
status input.