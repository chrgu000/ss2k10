/* xxqmexmt01.p 出口申报单维护                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 03/13/2008   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/




{mfdtitle.i "1+ "}    /* DISPLAY TITLE */

{xxqmexmt01.i "NEW" } /* all defines */

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
             {mfnp01.i xxepr_mstr v_nbr xxepr_nbr global_domain xxepr_domain xxepr_nbr }

             if recno <> ? then do:
                v_nbr = xxepr_nbr .
                disp  v_nbr   xxepr_date xxepr_req_date  xxepr_bar_code xxepr_bk_nbr  with frame h1 .
                disp xxepr_box_num xxepr_gross xxepr_amt  xxepr_curr xxepr_dept xxepr_loc xxepr_car 
                     xxepr_driver xxepr_ship_nbr xxepr_license xxepr_stat xxepr_rmks1 with frame h2.
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

    find first xxepr_mstr where xxepr_domain = global_domain and xxepr_nbr = v_nbr no-lock no-error .
    if avail xxepr_mstr then do:
        v_add = no .
        v_all = no .
        disp v_nbr v_add v_all xxepr_date xxepr_req_date  xxepr_bar_code xxepr_bk_nbr  with frame h1 .
        disp xxepr_box_num xxepr_gross xxepr_amt  xxepr_curr xxepr_dept xxepr_loc xxepr_car 
                     xxepr_driver xxepr_ship_nbr xxepr_license xxepr_stat xxepr_rmks1 with frame h2.
    end.



    loopa:
    do on error undo , retry:
        
        find xxepr_mstr where xxepr_domain = global_domain and xxepr_nbr = v_nbr  no-error .
        if not avail xxepr_mstr then do:            
            find first xxcbk_mstr 
                            where xxcbk_domain = global_domain
                            and xxcbk_stat = "" 
            no-lock no-error . 

    clear frame h1 no-pause .
    clear frame h2 no-pause .
            
            message "新增记录" .
            create xxepr_mstr .
            assign xxepr_domain = global_Domain 
                   xxepr_nbr    = v_nbr 
                   xxepr_date     = today
                   xxepr_req_date = today 
                   xxepr_curr     = "USD"
                   xxepr_bk_nbr   = if avail xxcbk_mstr then xxcbk_bk_nbr else ""
                   new_add = yes 
                   v_add = yes 
                   v_all = yes .

        end.
        else message "修改记录" .

        disp v_nbr  v_add v_all xxepr_date xxepr_req_date  xxepr_bar_code xxepr_bk_nbr  with frame h1 .

        v_recid = recid(xxepr_mstr) .
        update 
            xxepr_date 
            xxepr_req_date 
            xxepr_bk_nbr when ( new_add )
            v_add when ( new_add )
            v_all when ( new_add ) 
            xxepr_bar_code when ( not new_add ) 

        go-on ("F5" "CTRL-D") with frame h1 editing :
                if frame-field = "xxepr_bk_nbr" then do:
                    {mfnp01.i xxcbk_mstr xxepr_bk_nbr xxcbk_bk_nbr "global_domain and xxcbk_stat = '' " xxcbk_domain xxcbk_bk_nbr }
                    if recno <> ? then do:
                        display  xxcbk_bk_nbr @ xxepr_bk_nbr with frame h1.
                    end.
                end.
                else do:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxepr_stat <> "" then do:
                            message "错误:非未结状态,不允许删除" . 
                            undo,retry .
                        end.
                        else do:
                            find first xxeprd_det 
                                    where xxeprd_domain = global_domain 
                                    and xxeprd_nbr = v_nbr 
                                    and (xxeprd_stat <> "" or xxeprd_used > 0)
                            no-lock no-error.
                            if avail xxeprd_det then do :
                                message "错误:明细非未结状态或已开始库存转移,不允许删除" . 
                                undo,retry .
                            end.
                            else do:
                                del-yn = yes.
                                {mfmsg01.i 11 1 del-yn}
                                if del-yn then do :
                                    for each xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = v_nbr :
                                        find first abs_mstr 
                                            where abs_domain   = global_domain 
                                            and abs_par_id     = "S" + xxeprd_iss_nbr 
                                            and abs_type       = "S"
                                            and integer(abs_line) = xxeprd_iss_ln 
                                        no-error.
                                        if avail abs_mstr then assign abs__dec02 = abs__dec02 - xxeprd_iss_qty . 

                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxepr_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xxepr_bk_nbr 
                                            and xxcbkd_cu_ln  = xxeprd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_io = xxcbkd_qty_io - xxeprd_cu_qty  .

                                        delete xxeprd_Det.
                                    end.
                                    delete xxepr_mstr .
                                    clear frame h1 no-pause .
                                    next mainloop .
                                end.
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end.
        end. /* update ...EDITING */

        if xxepr_date = ? then do:
            message "错误:无效出口日期,请重新输入." .
            next-prompt xxepr_date with frame h1.
            undo,retry .
        end.
        if xxepr_req_date = ? then do:
            message "错误:无效出口日期,请重新输入." .
            next-prompt xxepr_req_date with frame h1.
            undo,retry .
        end.
        find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = xxepr_bk_nbr  no-error .
        if not avail xxcbk_mstr then do:
            message "错误:无效手册编号,请重新输入." .
            next-prompt xxepr_bk_nbr with frame h1.
            undo,retry .
        end.
        else if xxcbk_stat <> "" then do :
            message "错误:手册已结,请重新输入." .
            next-prompt xxepr_bk_nbr with frame h1.
            undo,retry .
        end.
        else do:
            find first xxcbkd_det 
                    where xxcbkd_domain = global_domain 
                    and xxcbkd_bk_type  = v_bk_type 
                    and xxcbkd_bk_nbr   = xxepr_bk_nbr 
                    and xxcbkd_stat     = ""
            no-error.
            if not avail xxcbkd_det then do:
                message "错误:无未结手册明细,请重新输入." .
                next-prompt xxepr_bk_nbr with frame h1.
                undo,retry .
            end.
        end.
        
    end. /*  loopa: */

    if v_add then do:
        for each temp : delete temp . end.
        v_abs_id = "" .
        for each abs_mstr use-index abs_par_id 
            where abs_domain = global_domain 
            and abs_par_id > "" 
            and abs_shp_date = xxepr_date 
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
                            and xxcbkd_bk_nbr   = xxepr_bk_nbr 
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
            {gprun.i ""xxqmexmt01a.p""}        
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
                            and xxcbkd_bk_nbr   = xxepr_bk_nbr 
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
                            find last xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = v_nbr no-lock no-error.
                            if avail xxeprd_det then do:
                                v_line = xxeprd_line + 1 .
                            end.
                            else v_line  = 1 .  
                            
                            find xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = v_nbr and xxeprd_line = v_line  no-error.
                            if not avail xxeprd_det then do:
                                new_add = yes .
                                create xxeprd_det .
                                xxeprd_domain = global_domain .
                                xxeprd_nbr  = v_nbr .
                                xxeprd_line = v_line .
                                xxeprd_iss_nbr   = t_nbr.
                                xxeprd_iss_ln    = t_line . 
                                xxeprd_iss_order = t_ponbr.
                                xxeprd_iss_part  = t_part.
                                xxeprd_iss_qty   = t_rcvd  .  
                                xxeprd_iss_date  = t_rcp_date .
                                xxeprd_um        = t_um.
                                xxeprd_um_conv   = round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) .                                
                                xxeprd_cu_ln     = xxcbkd_cu_ln .
                                xxeprd_cu_part   = xxcbkd_cu_part .                                
                                xxeprd_cu_um     = xxcbkd_um .
                                xxeprd_cu_qty    = round(t_rcvd  * xxeprd_um_conv, v_round2) . 
                                xxeprd_ctry      = t_ctry .
                                xxeprd_price     = xxcbkd_price .
                                xxeprd_amt       = xxeprd_price * xxeprd_cu_qty .

                                xxcbkd_qty_io   = xxcbkd_qty_io + xxeprd_cu_qty .     /*扣减手册数量*/

                                find first abs_mstr where abs_domain = global_domain and abs_par_id = "S" + t_nbr and integer(abs_line) = t_line no-error .
                                if avail abs_mstr then do :
                                    abs__dec02 = abs__dec02  + xxeprd_iss_qty .  /*扣减abs数量*/
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

    {gprun.i ""xxqmexmt01b.p""}   /*details*/

    view frame h1 .
    view frame h2 .
    if new_add then do:        
        xxepr_amt = 0 .
        for each  xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = xxepr_nbr :
            xxepr_amt = xxeprd_amt + xxepr_amt .
        end.
    end.
    else do:
        v_amt = 0 .
        for each  xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = xxepr_nbr :
            v_amt = xxeprd_amt + v_amt .
        end.
        if v_amt <> xxepr_amt then do:
            message "警告:总金额不一致:" v_amt "" xxepr_amt .
        end.
    end.

    {gprun.i ""xxqmexmt01c.p""} 
    
    release xxeprd_det no-error.
    release xxepr_mstr no-error .

end.   /*  mainloop: */
status input.