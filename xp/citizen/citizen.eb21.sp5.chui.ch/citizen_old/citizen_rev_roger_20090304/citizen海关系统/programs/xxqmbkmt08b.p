
{mfdeclre.i }
{gplabel.i}

{xxqmbkmt08.i }




        loopb:
        repeat :
            hide frame h1 no-pause .
            hide frame h2 no-pause .
            view frame d3 .
            view frame d1 .
            view frame d2 .
            clear frame d1 no-pause .
            clear frame d2 no-pause .
            detail_add = no .
            leave-yn = no .

            find last xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr no-lock no-error.
            if avail xximpd_det then do:
                v_line = xximpd_line + 1 .
            end.
            else v_line  = 1 .

            find first xximp_mstr 
                    where xximp_domain = global_domain 
                    and xximp_nbr = v_nbr
            no-error .
            disp xximp_nbr  xximp_bk_nbr with frame d3 .

            update v_line  with frame d1 editing:
                     if frame-field = "v_line" then do:    
                         {mfnp01.i xximpd_det  v_line xximpd_line  v_nbr "xximpd_domain = global_domain and xximpd_nbr "  xximpd_nbr }

                         if recno <> ? then do:
                            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xximpd_cu_ln no-lock no-error.

                            disp  xximpd_line @ v_line  xximpd_rct_nbr  xximpd_rct_ln  xximpd_rct_part xximpd_um xximpd_rct_qty xximpd_rct_order with frame d1 .
                            disp xximpd_amt xximpd_ctry xximpd_cu_ln xximpd_cu_part xximpd_cu_qty xximpd_cu_um xxcpt_desc
                                 xximpd_price xximpd_rct_date xximpd_um_conv xximpd_stat xximpd_used with frame d2.
                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.        
            end.
            assign v_line .

            find xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr and xximpd_line = v_line  no-error.
            if not avail xximpd_det then do:
                message "新增记录" .
                create xximpd_det .
                assign 
                    xximpd_domain = global_domain
                    xximpd_type   = v_form_type
                    xximpd_nbr    = v_nbr 
                    xximpd_line   = v_line
                    detail_add    = yes .
                    if detail_add = yes then new_add = yes .
            end.

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xximpd_cu_ln no-lock no-error.

            disp xximpd_amt xximpd_ctry xximpd_cu_ln xximpd_cu_part xximpd_cu_qty xximpd_cu_um xxcpt_desc when(avail xxcpt_mstr)
                 xximpd_price xximpd_rct_date xximpd_um_conv xximpd_stat xximpd_used with frame d2.


            if detail_add then do on error undo , retry:
                clear frame d1 no-pause.
                clear frame d2 no-pause.
                disp v_line with frame d1 .
                update xximpd_rct_nbr xximpd_rct_ln with frame d1 editing:
                     if frame-field = "xximpd_rct_nbr" then do:    
                         {mfnp.i prh_hist  xximpd_rct_nbr prh_receiver  xximpd_rct_nbr "prh_domain = global_domain and prh_receiver " prh_receiver}

                         if recno <> ? then do:
                            xximpd_rct_nbr = prh_receiver.
                            xximpd_rct_ln = prh_line . 
                            xximpd_rct_order = prh_nbr.

                            disp   xximpd_rct_nbr  xximpd_rct_ln prh_part @ xximpd_rct_part prh_um @ xximpd_um xximpd_rct_order with frame d1 .
                            
                         end . /* if recno <> ? then  do: */
                     end.
                     else if frame-field = "xximpd_rct_ln" then do:    
                         {mfnp01.i prh_hist   xximpd_rct_ln  prh_line xximpd_rct_nbr "prh_domain = global_domain and prh_receiver  "   prh_receiver}

                         if recno <> ? then do:
                            xximpd_rct_nbr = prh_receiver.
                            xximpd_rct_ln = prh_line . 
                            xximpd_rct_order = prh_nbr.

                            disp    xximpd_rct_nbr  xximpd_rct_ln prh_part @ xximpd_rct_part  prh_um @ xximpd_um xximpd_rct_order with frame d1 .

                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.                
                end. /* update ...EDITING */
                assign xximpd_rct_nbr xximpd_rct_ln xximpd_rct_order .


                find first prh_hist where prh_domain = global_domain and prh_receiver = xximpd_rct_nbr and prh_line = xximpd_rct_ln no-lock no-error.
                if not avail prh_hist then do:
                    message "错误:无效收货单号" .
                    undo ,retry .
                end.
                else do: /*avail prh_hist*/

                    if prh__chr01 <> "HK" then do:
                        message "错误:非进口类型收货单." .
                        undo,retry .
                    end.

                    /*已经转报关单的数量prh__dec01扣除*/
                    if prh_rcvd - prh__dec01 <= 0 then do:
                        message "错误:该项已全部转报关单" .
                        undo ,retry .
                    end.
                    else do:
                        message "收货数量:" prh_rcvd ",未转报关单数量:" prh_rcvd - prh__dec01 .                        
                        find first xxccpt_mstr where xxccpt_domain = global_domain  and xxccpt_part = prh_part no-lock no-error .
                        if not avail xxccpt_mstr then do:
                            message "错误:海关零件不存在:" prh_part .
                            undo,retry .
                        end.
                        else do:    

                            find first xxcpt_mstr where xxcpt_domain = global_domain  and xxcpt_ln = xxccpt_ln no-lock no-error .
                            if not avail xxcpt_mstr then do:
                                message  "错误:海关商品编码不存在:" xxccpt_ln .
                                undo ,retry.
                            end.
                            else do:
                                find first xxcbkd_det 
                                        where xxcbkd_domain = global_domain 
                                        and xxcbkd_bk_type  = v_bk_type
                                        and xxcbkd_bk_nbr = xximp_bk_nbr 
                                        and xxcbkd_cu_ln  = xxcpt_ln
                                no-lock no-error .
                                if not avail xxcbkd_det then do:
                                    message "错误:无此海关手册项次" .
                                    undo ,retry .
                                end.
                                if xxcbkd_stat = "C" then do:
                                    message "错误:此海关手册项次已结" .
                                    undo,retry .
                                end.
                                if (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) <= 0 then do:
                                    message "错误:此海关手册项次数量不足" .
                                    undo,retry .
                                end.

                                message "海关手册剩余数量:" xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct 
                                        ",单位:" xxcbkd_um .


                                xximpd_rct_part  = prh_part.                                
                                xximpd_rct_qty   = (prh_rcvd - prh__dec01) .    
                                xximpd_rct_nbr = prh_receiver.
                                xximpd_rct_ln = prh_line . 
                                xximpd_rct_order = prh_nbr.
                                xximpd_rct_date  = prh_rcp_date.
                                xximpd_um = prh_um.
                                xximpd_um_conv =  round(prh_um_conv * xxccpt_um_conv,v_round2 + 2 ) . 
                                xximpd_cu_um = xxcpt_um .
                                xximpd_cu_part = xxcpt_cu_part .
                                xximpd_cu_ln = xxccpt_ln .
                                xximpd_ctry  = xxccpt_ctry .
                                xximpd_price = xxcpt_price .
                                xximpd_cu_qty = round((prh_rcvd - prh__dec01)  * round(prh_um_conv * xxccpt_um_conv,v_round2 + 2 ) , v_round2 )  .
                                xximpd_amt       = xximpd_price * xximpd_cu_qty .

                                v_qty_b1 = 0 . /*qty_before*/ 
                                v_qty_b2 = 0.

                            end.
                        end.                            
                    end.
                end. /*avail prh_hist*/
                disp xximpd_rct_nbr xximpd_rct_ln xximpd_rct_part  xximpd_um xximpd_rct_order xximpd_rct_qty with frame d1 .
                disp xximpd_amt xximpd_ctry xximpd_cu_ln xximpd_cu_part xximpd_cu_qty xximpd_cu_um xxcpt_desc
                     xximpd_price xximpd_rct_date xximpd_um_conv xximpd_stat xximpd_used with frame d2.

 

                do on error undo, retry with frame d2:
                    update xximpd_um_conv with frame d2 .
                    if  xximpd_um_conv = 0 then do:
                        message "单位换算因子,不可为零" .
                        undo,retry .
                    end.

                end. /*do on error undo, retry with frame d2:*/        
                

            end. /*if detail_add then*/
            else   /*qty_before*/ assign v_qty_b1 = xximpd_rct_qty  v_qty_b2 = xximpd_cu_qty .

            find first prh_hist where prh_domain = global_domain and prh_receiver = xximpd_rct_nbr and prh_line = xximpd_rct_ln no-lock no-error.
            if not avail prh_hist then do:
                message "无效收货单号" .
                undo ,retry .
            end.    

            do on error undo, retry with frame d1:

                update xximpd_rct_qty go-on("F5" "CTRL-D")  with frame d1 editing:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xximpd_used > 0 then do :
                            message "错误:已开始库存转移,不可删除" .
                            undo,retry.
                        end.
                        else if xximpd_stat <> "" then do :
                            message "错误:非空状态,不可删除" .
                            undo,retry.
                        end.
                        else do:
                            del-yn = yes.
                            {mfmsg01.i 11 1 del-yn}
                            if del-yn then do :
                                if v_qty_b1 <> 0 then do:
                                    find first prh_hist 
                                            where prh_domain = global_domain 
                                            and prh_receiver = xximpd_rct_nbr 
                                            and prh_line = xximpd_rct_ln 
                                    no-error.
                                    if avail prh_hist then assign prh__dec01 = prh__dec01 - v_qty_b1 .

                                    find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xximp_bk_nbr 
                                    no-error .        
                                    if avail xxcbk_mstr then assign  xxcbk_stat = "" .

                                    find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_nbr = xximp_bk_nbr 
                                            and xxcbkd_cu_ln  = xximpd_cu_ln
                                    no-error .                                    
                                    if avail xxcbkd_det then assign 
                                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 
                                           xxcbkd_stat = "" .
                                end. 
                                /*else is detail_add*/

                                delete xximpd_Det.
                                clear frame d1 no-pause .
                                clear frame d2 no-pause .
                                next loopb .
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end. /*update xximpd_rct_qty go-on("F5" "CTRL-D")*/

                if xximpd_rct_qty <= 0 then do:
                    message "报关单数量必须为正" .
                    undo ,retry .
                end.
                if xximpd_rct_qty <> v_qty_b1  then do:

                    find first prh_hist 
                            where prh_domain = global_domain 
                            and prh_receiver = xximpd_rct_nbr 
                            and prh_line = xximpd_rct_ln 
                    no-error.
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type
                            and xxcbkd_bk_nbr = xximp_bk_nbr 
                            and xxcbkd_cu_ln  = xximpd_cu_ln
                    no-error .



                    if xximpd_rct_qty >  (prh_rcvd - prh__dec01 + v_qty_b1 ) then do:
                        message "错误:不可超过收货单的剩余数量" .
                        undo,retry.
                    end.

                    if xximpd_rct_qty < xximpd_used then do:
                        message "错误:不可少于报关单已转移的数量" .
                        undo,retry.
                    end.

                    if round(xximpd_rct_qty * xximpd_um_conv,v_round2)  > 
                       (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct + v_qty_b2) then do:
                            message "错误:海关手册的未结数量不足" .
                            undo,retry .
                    end.
                    
                    assign prh__dec01 = prh__dec01 - v_qty_b1 + xximpd_rct_qty 
                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 + round(xximpd_rct_qty * xximpd_um_conv,v_round2) 
                           xximpd_cu_qty = round(xximpd_rct_qty * xximpd_um_conv,v_round2) 
                           xximpd_amt = xximpd_cu_qty * xximpd_price 
                           .                

                end. /*if xximpd_rct_qty <> v_qty_b1*/
                disp xximpd_amt xximpd_ctry xximpd_cu_ln xximpd_cu_part xximpd_cu_qty xximpd_cu_um xxcpt_desc
                     xximpd_price xximpd_rct_date xximpd_um_conv xximpd_stat xximpd_used with frame d2.

            end. /*do on error undo, retry with frame d1:*/

            do on error undo, retry with frame d2:
                update xximpd_amt xximpd_stat with frame d2 .
                if  xximpd_price = 0 or xximpd_amt = 0 then do:
                    message "错误:单价和金额不可为零" .
                    undo,retry .
                end.

                if xximpd_stat <> "" and index("XC",xximpd_stat) = 0 then do:
                    message "错误:状态仅限 未结(空),已结(C),取消(X)" .
                    next-prompt xximpd_stat .
                    undo,retry .
                end.



            end. /*do on error undo, retry with frame d2:*/    


        end. /*  loopb: */
        hide frame d3 no-pause .
        hide frame d1 no-pause .
        hide frame d2 no-pause .