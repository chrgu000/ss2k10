/*                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 03/13/2008   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/




{mfdtitle.i "1+ "}    /* DISPLAY TITLE */

{xxqminmt10.i "NEW" } /* all defines */

v_bk_type = "IMP" .
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
             {mfnp01.i xxipr_mstr v_nbr xxipr_nbr global_domain xxipr_domain xxipr_nbr }

             if recno <> ? then do:
                v_nbr = xxipr_nbr .
                disp  v_nbr   xxipr_date xxipr_req_date  xxipr_bar_code xxipr_bk_nbr  with frame h1 .
                disp xxipr_box_num xxipr_gross xxipr_amt  xxipr_curr xxipr_dept xxipr_loc xxipr_car 
                     xxipr_driver xxipr_ship_nbr xxipr_license xxipr_stat xxipr_rmks1 with frame h2.
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

    find first xxipr_mstr where xxipr_domain = global_domain and xxipr_nbr = v_nbr no-lock no-error .
    if avail xxipr_mstr then do:
        v_add = no .
        v_all = no .
        disp v_nbr v_add v_all xxipr_date xxipr_req_date  xxipr_bar_code xxipr_bk_nbr  with frame h1 .
        disp xxipr_box_num xxipr_gross xxipr_amt  xxipr_curr xxipr_dept xxipr_loc xxipr_car 
                     xxipr_driver xxipr_ship_nbr xxipr_license xxipr_stat xxipr_rmks1 with frame h2.
    end.



    loopa:
    do on error undo , retry:
        
        find xxipr_mstr where xxipr_domain = global_domain and xxipr_nbr = v_nbr  no-error .
        if not avail xxipr_mstr then do:            
            find first xxcbk_mstr 
                            where xxcbk_domain = global_domain
                            and xxcbk_stat = "" 
            no-lock no-error . 

            clear frame h1 no-pause .
            clear frame h2 no-pause .
            
            message "新增记录" .
            create xxipr_mstr .
            assign xxipr_domain = global_Domain 
                   xxipr_nbr    = v_nbr 
                   xxipr_date     = today
                   xxipr_req_date = today 
                   xxipr_curr     = "USD"
                   xxipr_bk_nbr   = if avail xxcbk_mstr then xxcbk_bk_nbr else ""
                   new_add = yes 
                   v_add = yes 
                   v_all = yes .

        end.
        else message "修改记录" .

        disp v_nbr  v_add v_all xxipr_date xxipr_req_date  xxipr_bar_code xxipr_bk_nbr  with frame h1 .

        v_recid = recid(xxipr_mstr) .
        update 
            xxipr_date 
            xxipr_req_date 
            xxipr_bk_nbr when ( new_add )
            v_add when ( new_add )
            v_all when ( new_add ) 
            xxipr_bar_code when ( not new_add ) 

        go-on ("F5" "CTRL-D") with frame h1 editing :
                if frame-field = "xxipr_bk_nbr" then do:
                    {mfnp01.i xxcbk_mstr xxipr_bk_nbr xxcbk_bk_nbr "global_domain and xxcbk_stat = '' " xxcbk_domain xxcbk_bk_nbr }
                    if recno <> ? then do:
                        display  xxcbk_bk_nbr @ xxipr_bk_nbr with frame h1.
                    end.
                end.
                else do:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxipr_stat <> "" then do:
                            message "错误:非未结状态,不允许删除" . 
                            undo,retry .
                        end.
                        else do:
                            find first xxiprd_det 
                                    where xxiprd_domain = global_domain 
                                    and xxiprd_nbr = v_nbr 
                                    and (xxiprd_stat <> "" or xxiprd_used > 0)
                            no-lock no-error.
                            if avail xxiprd_det then do :
                                message "错误:明细非未结状态或已开始库存转移,不允许删除" . 
                                undo,retry .
                            end.
                            else do:
                                del-yn = yes.
                                {mfmsg01.i 11 1 del-yn}
                                if del-yn then do :
                                    for each xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = v_nbr :
                                        find first prh_hist 
                                            where prh_domain = global_domain 
                                            and prh_receiver = xxiprd_rct_nbr 
                                            and prh_line = xxiprd_rct_ln 
                                        no-error.
                                        if avail prh_hist then assign prh__dec01 = prh__dec01 - xxiprd_rct_qty . 

                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxipr_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xxipr_bk_nbr 
                                            and xxcbkd_cu_ln  = xxiprd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_io = xxcbkd_qty_io - xxiprd_cu_qty  .

                                        delete xxiprd_Det.
                                    end.
                                    delete xxipr_mstr .
                                    clear frame h1 no-pause .
                                    next mainloop .
                                end.
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end.
        end. /* update ...EDITING */

        if xxipr_date = ? then do:
            message "错误:无效进口日期,请重新输入." .
            next-prompt xxipr_date with frame h1.
            undo,retry .
        end.
        if xxipr_req_date = ? then do:
            message "错误:无效进口日期,请重新输入." .
            next-prompt xxipr_req_date with frame h1.
            undo,retry .
        end.
        find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = xxipr_bk_nbr  no-error .
        if not avail xxcbk_mstr then do:
            message "错误:无效手册编号,请重新输入." .
            next-prompt xxipr_bk_nbr with frame h1.
            undo,retry .
        end.
        else if xxcbk_stat <> "" then do :
            message "错误:手册已结,请重新输入." .
            next-prompt xxipr_bk_nbr with frame h1.
            undo,retry .
        end.
        else do:
            find first xxcbkd_det 
                    where xxcbkd_domain = global_domain 
                    and xxcbkd_bk_type  = v_bk_type 
                    and xxcbkd_bk_nbr   = xxipr_bk_nbr 
                    and xxcbkd_stat     = ""
            no-error.
            if not avail xxcbkd_det then do:
                message "错误:无未结手册明细,请重新输入." .
                next-prompt xxipr_bk_nbr with frame h1.
                undo,retry .
            end.
        end.
        
    end. /*  loopa: */

    if v_add then do:
        for each temp : delete temp . end.

        for each prh_hist use-index prh_rcp_date 
            where prh_domain = global_domain 
            and prh_rcp_date = xxipr_date 
            and prh__chr01 = "HK"
            and prh__dec01 < prh_rcvd 
            no-lock :

            v_error = "" .


            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = prh_part no-lock no-error .
            if not avail xxccpt_mstr then do:
                message "警告: 海关零件" prh_part "不存在" ".收货单号:" prh_receiver . 
                v_error = "*ERROR*" .
            end.
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                if not avail xxcpt_mstr then do:
                    message "警告:零件" prh_part ",商品序" xxccpt_ln "无对应海关商品" ".收货单号:" prh_receiver . 
                    v_error = "*ERROR*" .
                end.
                else do:
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xxipr_bk_nbr 
                            and xxcbkd_cu_ln    = xxcpt_ln 
                    no-error.
                    if not avail xxcbkd_det then do:
                        message "警告:手册无此零件" prh_part ",商品序" xxccpt_ln ".收货单号:" prh_receiver .
                        v_error = "*ERROR*" .
                    end.
                    else do:
                        if round((prh_rcvd - prh__dec01) * round(prh_um_conv * xxccpt_um_conv,v_round2 + 2 ) , v_round2 ) > 
                           ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) then do:
                            message  "警告:手册余数不足,零件" prh_part ",商品序" xxccpt_ln ".收货单号:" prh_receiver . 
                            v_error = "*ERROR*" .
                        end.
                    end.
                end.
            end.
            if v_error <> "" then pause .
            
            create temp .
            assign 
                t_nbr      = prh_receiver 
                t_line     = prh_line 
                t_ponbr    = prh_nbr 
                t_vend     = prh_vend
                t_rcp_date = prh_rcp_date
                t_cu_ln    = if avail xxcpt_mstr     then xxcpt_ln else 0 
                t_cu_part  = if avail xxcpt_mstr     then xxcpt_cu_part else v_error 
                t_ctry     = if avail xxccpt_mstr    then xxccpt_ctry else v_error 
                t_part     = prh_part
                t_um       = prh_um
                t_um_conv1 = prh_um_conv 
                t_um_conv2 = if avail xxccpt_mstr    then xxccpt_um_conv else 1
                t_rcvd     = prh_rcvd - prh__dec01 
                t_yn       = if v_error <> ""then no else v_all .


        end. /*for each prh_hist */

        find first temp  no-error.
        if avail temp then do:
            hide frame h2 no-pause.
            {gprun.i ""xxqminmt10a.p""}        
        end.
        else do:
            message "警告:无符合条件的收货单." .
            undo ,retry.
        end.

        if info_correct then do:

             for each temp where t_yn = yes :
                    find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t_part no-lock no-error .
                    if not avail xxccpt_mstr then do:
                        message "警告:海关零件" t_part "不存在" ".收货单号:" t_nbr .
                        next .
                    end.
                    else do:
                        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                        if not avail xxcpt_mstr then do:
                            message "警告:零件" t_part ",商品序" xxccpt_ln "无对应海关商品" ".收货单号:" t_nbr .
                            next .
                        end.
                    end. 
                    
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xxipr_bk_nbr 
                            and xxcbkd_cu_ln    = t_cu_ln 
                    no-error.
                    if not avail xxcbkd_det then do:
                        message "警告:手册无此商品序:" t_cu_ln "零件" t_part ".收货单号:" t_nbr .
                        next.
                    end.
                    else do: 
                        if round(t_rcvd  * round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) , v_round2 ) > 
                           ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) then do:
                            message  "警告:手册余数不足:" t_cu_ln "零件" t_part ".收货单号:" t_nbr .
                            next.
                        end.
                        else do:
                            find last xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = v_nbr no-lock no-error.
                            if avail xxiprd_det then do:
                                v_line = xxiprd_line + 1 .
                            end.
                            else v_line  = 1 .  
                            
                            find xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = v_nbr and xxiprd_line = v_line  no-error.
                            if not avail xxiprd_det then do:
                                new_add = yes .
                                create xxiprd_det .
                                xxiprd_domain = global_domain .
                                xxiprd_nbr  = v_nbr .
                                xxiprd_line = v_line .
                                xxiprd_rct_nbr   = t_nbr.
                                xxiprd_rct_ln    = t_line . 
                                xxiprd_rct_order = t_ponbr.
                                xxiprd_rct_part  = t_part.
                                xxiprd_rct_qty   = t_rcvd  .  
                                xxiprd_rct_date  = t_rcp_date .
                                xxiprd_um        = t_um.
                                xxiprd_um_conv   = round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) .                                
                                xxiprd_cu_ln     = xxcbkd_cu_ln .
                                xxiprd_cu_part   = xxcbkd_cu_part .                                
                                xxiprd_cu_um     = xxcbkd_um .
                                xxiprd_cu_qty    = round(t_rcvd  * xxiprd_um_conv, v_round2) . 
                                xxiprd_ctry      = t_ctry .
                                xxiprd_price     = xxcbkd_price .
                                xxiprd_amt       = xxiprd_price * xxiprd_cu_qty .

                                xxcbkd_qty_io   = xxcbkd_qty_io + xxiprd_cu_qty .     /*扣减手册数量*/

                                find first prh_hist where prh_domain = global_domain and prh_receiver = t_nbr and prh_line = t_line no-error .
                                if avail prh_hist then do :
                                    prh__dec01 = prh__dec01 + xxiprd_rct_qty .  /*扣减Prh数量*/
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

    {gprun.i ""xxqminmt10b.p""}   /*details*/

    view frame h1 .
    view frame h2 .
    if new_add then do:        
        xxipr_amt = 0 .
        for each  xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = xxipr_nbr :
            xxipr_amt = xxiprd_amt + xxipr_amt .
        end.
    end.
    else do:
        v_amt = 0 .
        for each  xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = xxipr_nbr :
            v_amt = xxiprd_amt + v_amt .
        end.
        if v_amt <> xxipr_amt then do:
            message "警告:总金额不一致:" v_amt "" xxipr_amt .
        end.
    end.

    {gprun.i ""xxqminmt10c.p""} 
    
    release xxiprd_det no-error.
    release xxipr_mstr no-error .

end.   /*  mainloop: */
status input.