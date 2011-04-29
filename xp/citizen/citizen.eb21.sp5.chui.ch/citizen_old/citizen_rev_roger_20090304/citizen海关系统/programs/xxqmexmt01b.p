
{mfdeclre.i }
{gplabel.i}

{xxqmexmt01.i }




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

            find last xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = v_nbr no-lock no-error.
            if avail xxeprd_det then do:
                v_line = xxeprd_line + 1 .
            end.
            else v_line  = 1 .

            find first xxepr_mstr 
                    where xxepr_domain = global_domain 
                    and xxepr_nbr = v_nbr
            no-error .
            disp xxepr_nbr xxepr_bar_code xxepr_bk_nbr with frame d3 .

            update v_line  with frame d1 editing:
                     if frame-field = "v_line" then do:    
                         {mfnp01.i xxeprd_det  v_line xxeprd_line  v_nbr "xxeprd_domain = global_domain and xxeprd_nbr "  xxeprd_nbr }

                         if recno <> ? then do:
                            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxeprd_cu_ln no-lock no-error.

                            disp  xxeprd_line @ v_line  xxeprd_iss_nbr  xxeprd_iss_ln  xxeprd_iss_part xxeprd_um xxeprd_iss_qty xxeprd_iss_order with frame d1 .
                            disp xxeprd_amt xxeprd_ctry xxeprd_cu_ln xxeprd_cu_part xxeprd_cu_qty xxeprd_cu_um xxcpt_desc
                                 xxeprd_price xxeprd_iss_date xxeprd_um_conv xxeprd_stat xxeprd_used with frame d2.
                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.        
            end.
            assign v_line .

            find xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = v_nbr and xxeprd_line = v_line  no-error.
            if not avail xxeprd_det then do:
                message "新增记录" .
                create xxeprd_det .
                assign 
                    xxeprd_domain = global_domain
                    xxeprd_nbr  = v_nbr 
                    xxeprd_line = v_line
                    detail_add = yes .
                    if detail_add = yes then new_add = yes .
            end.

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxeprd_cu_ln no-lock no-error.

            disp xxeprd_amt xxeprd_ctry xxeprd_cu_ln xxeprd_cu_part xxeprd_cu_qty xxeprd_cu_um xxcpt_desc when(avail xxcpt_mstr)
                 xxeprd_price xxeprd_iss_date xxeprd_um_conv xxeprd_stat xxeprd_used with frame d2.


            if detail_add then do on error undo , retry:
                clear frame d1 no-pause.
                clear frame d2 no-pause.
                disp v_line with frame d1 .
                v_abs_id = "" .
                update xxeprd_iss_nbr xxeprd_iss_ln with frame d1 editing:
                     if frame-field = "xxeprd_iss_nbr" then do:    
                            {mfnp05.i   abs_mstr
                                        abs_par_id
                                        "abs_mstr.abs_domain = global_domain  
                                        and abs_par_id begins 'S' 
                                        and abs_type = 'S' "
                                        abs_par_id
                                        " 'S' + input xxeprd_iss_nbr "}

                         if recno <> ? then do:
                            xxeprd_iss_nbr = substring(abs_par_id,2,50) .
                            xxeprd_iss_ln = integer(abs_line) . 
                            xxeprd_iss_order = abs_order .
                            v_abs_id  = abs_par_id .

                            disp   xxeprd_iss_nbr  xxeprd_iss_ln abs_item @ xxeprd_iss_part abs__qad02 @ xxeprd_um xxeprd_iss_order with frame d1 .
                            
                         end . /* if recno <> ? then  do: */
                     end.
                     else if frame-field = "xxeprd_iss_ln" then do:    
                         {mfnp01.i abs_mstr xxeprd_iss_ln  integer(abs_line) v_abs_id "abs_domain = global_domain and abs_par_id "   abs_par_id }

                         if recno <> ? then do:
                            xxeprd_iss_nbr = substring(abs_par_id,2,50) .
                            xxeprd_iss_ln = integer(abs_line) . 
                            xxeprd_iss_order = abs_order .
                            v_abs_id  = abs_par_id .

                            disp   xxeprd_iss_nbr  xxeprd_iss_ln abs_item @ xxeprd_iss_part abs__qad02 @ xxeprd_um xxeprd_iss_order with frame d1 .

                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.                
                end. /* update ...EDITING */
                assign xxeprd_iss_nbr xxeprd_iss_ln xxeprd_iss_order .


                find first abs_mstr where abs_domain = global_domain and abs_type = "S" and abs_par_id = "S" + xxeprd_iss_nbr and integer(abs_line) = xxeprd_iss_ln no-lock no-error.
                if not avail abs_mstr then do:
                    message "错误:无效货运单号" .
                    undo ,retry .
                end.
                else do: /*avail abs_mstr*/
                    /*已经转报关单的数量扣除*/
                    if abs_qty - abs__dec02  <= 0 then do:
                        message "错误:该项已全部转报关单" .
                        undo ,retry .
                    end.
                    else do:
                        message "发货数量:" abs_qty   ",未转报关单数量:" abs_qty - abs__dec02  .                        
                        find first xxccpt_mstr where xxccpt_domain = global_domain  and xxccpt_part = abs_item no-lock no-error .
                        if not avail xxccpt_mstr then do:
                            message "错误:海关零件不存在:" abs_item .
                            undo,retry .
                        end.
                        else do:                            
                            find first xxcpt_mstr where xxcpt_domain = global_domain  and xxcpt_ln = xxccpt_ln no-lock no-error .
                            if not avail xxcpt_mstr then do:
                                message  "错误:海关商品编码不存在,序:" xxccpt_ln ",零件:" abs_item.
                                undo ,retry.
                            end.
                            else do:
                                find first xxcbkd_det 
                                        where xxcbkd_domain = global_domain 
                                        and xxcbkd_bk_type  = v_bk_type
                                        and xxcbkd_bk_nbr = xxepr_bk_nbr 
                                        and xxcbkd_cu_ln  = xxcpt_ln
                                no-lock no-error .
                                if not avail xxcbkd_det then do:
                                    message "错误:无此商品的海关手册项次" .
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

                                message "海关手册剩余数量:" 
                                        xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct 
                                        ",单位:" xxcbkd_um .


                                xxeprd_iss_part  = abs_item.                                
                                xxeprd_iss_qty   = (abs_qty - abs__dec02) .    
                                xxeprd_iss_nbr   = substring(abs_par_id,2,50) .
                                xxeprd_iss_ln    = integer(abs_line). 
                                xxeprd_iss_order = abs_order .
                                xxeprd_iss_date  = abs_shp_date.
                                xxeprd_um        = abs__qad02.
                                xxeprd_um_conv   =  round(integer(abs__qad03) * xxccpt_um_conv,v_round2 + 2 ) . 
                                xxeprd_cu_um     = xxcpt_um .
                                xxeprd_cu_part   = xxcpt_cu_part .
                                xxeprd_cu_ln     = xxccpt_ln .
                                xxeprd_ctry      = xxccpt_ctry .
                                xxeprd_price     = xxcpt_price .
                                xxeprd_cu_qty    = round((abs_qty - abs__dec02)  * round(integer(abs__qad03) * xxccpt_um_conv,v_round2 + 2 ) , v_round2 )  .
                                xxeprd_amt       = xxeprd_price * xxeprd_cu_qty .

                                v_qty_b1 = 0 . /*qty_before*/ 
                                v_qty_b2 = 0.

                            end.
                        end.                            
                    end.
                end. /*avail abs_mstr*/
                disp xxeprd_iss_nbr xxeprd_iss_ln xxeprd_iss_part  xxeprd_um xxeprd_iss_order xxeprd_iss_qty with frame d1 .
                disp xxeprd_amt xxeprd_ctry xxeprd_cu_ln xxeprd_cu_part xxeprd_cu_qty xxeprd_cu_um xxcpt_desc
                     xxeprd_price xxeprd_iss_date xxeprd_um_conv xxeprd_stat xxeprd_used with frame d2.

 

                do on error undo, retry with frame d2:
                    update xxeprd_um_conv with frame d2 .
                    if  xxeprd_um_conv = 0 then do:
                        message "错误:单位换算因子,不可为零" .
                        undo,retry .
                    end.

                end. /*do on error undo, retry with frame d2:*/        
                

            end. /*if detail_add then*/
            else   /*qty_before*/ assign v_qty_b1 = xxeprd_iss_qty  v_qty_b2 = xxeprd_cu_qty .

            find first abs_mstr where abs_domain = global_domain and abs_type = "S" and abs_par_id = "S" + xxeprd_iss_nbr and integer(abs_line) = xxeprd_iss_ln no-lock no-error.
            if not avail abs_mstr then do:
                message "错误:无效货运单号" .
                undo ,retry .
            end.

            do on error undo, retry with frame d1:

                update xxeprd_iss_qty go-on("F5" "CTRL-D")  with frame d1 editing:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxeprd_used > 0 then do :
                            message "错误:已开始库存转移,不可删除" .
                            undo,retry.
                        end.
                        else if xxeprd_stat <> "" then do :
                            message "错误:非空状态,不可删除" .
                            undo,retry.
                        end.
                        else do:
                            del-yn = yes.
                            {mfmsg01.i 11 1 del-yn}
                            if del-yn then do :
                                if v_qty_b1 <> 0 then do:
                                    find first abs_mstr 
                                            where abs_domain = global_domain 
                                            and abs_par_id   = "S" + xxeprd_iss_nbr 
                                            and abs_type     = "S"
                                            and integer(abs_line) = xxeprd_iss_ln 
                                    no-error.
                                    if avail abs_mstr then assign abs__dec02 = abs__dec02 - v_qty_b1 .

                                    find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxepr_bk_nbr 
                                    no-error .        
                                    if avail xxcbk_mstr then assign  xxcbk_stat = "" .

                                    find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_nbr = xxepr_bk_nbr 
                                            and xxcbkd_cu_ln  = xxeprd_cu_ln
                                    no-error .                                    
                                    if avail xxcbkd_det then assign 
                                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 
                                           xxcbkd_stat = "" .
                                end. 
                                /*else is detail_add*/

                                delete xxeprd_Det.
                                clear frame d1 no-pause .
                                clear frame d2 no-pause .
                                next loopb .
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end. /*update xxeprd_iss_qty go-on("F5" "CTRL-D")*/

                if xxeprd_iss_qty <= 0 then do:
                    message "报关单数量必须为正" .
                    undo ,retry .
                end.
                if xxeprd_iss_qty <> v_qty_b1  then do:

                    find first abs_mstr 
                            where abs_domain = global_domain 
                            and abs_par_id   = "S" + xxeprd_iss_nbr 
                            and abs_type     = "S"
                            and integer(abs_line) = xxeprd_iss_ln 
                    no-error.
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type
                            and xxcbkd_bk_nbr = xxepr_bk_nbr 
                            and xxcbkd_cu_ln  = xxeprd_cu_ln
                    no-error .
                    if xxeprd_iss_qty >  ((abs_qty - abs__dec02)  + v_qty_b1 ) then do:
                        message "不可超过货运单的剩余数量" .
                        undo,retry.
                    end.

                    if xxeprd_iss_qty < xxeprd_used then do:
                        message "不可少于报关单已转移的数量" .
                        undo,retry.
                    end.

                    if round(xxeprd_iss_qty * xxeprd_um_conv,v_round2)  > 
                       (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct + v_qty_b2) then do:
                            message "海关手册的未结数量不足" .
                            undo,retry .
                    end.

                    
                    assign abs__dec02 = abs__dec02 - v_qty_b1 + xxeprd_iss_qty 
                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 + round(xxeprd_iss_qty * xxeprd_um_conv,v_round2) 
                           xxeprd_cu_qty = round(xxeprd_iss_qty * xxeprd_um_conv,v_round2) 
                           xxeprd_amt = xxeprd_cu_qty * xxeprd_price 
                           .                

                end. /*if xxeprd_iss_qty <> v_qty_b1*/
                disp xxeprd_amt xxeprd_ctry xxeprd_cu_ln xxeprd_cu_part xxeprd_cu_qty xxeprd_cu_um xxcpt_desc
                     xxeprd_price xxeprd_iss_date xxeprd_um_conv xxeprd_stat xxeprd_used with frame d2.

            end. /*do on error undo, retry with frame d1:*/

            do on error undo, retry with frame d2:
                update xxeprd_amt xxeprd_stat with frame d2 .
                if  xxeprd_price = 0 or xxeprd_amt = 0 then do:
                    message "错误:单价和金额不可为零" .
                    undo,retry .
                end.

                if xxeprd_stat <> "" and index("XC",xxeprd_stat) = 0 then do:
                    message "错误:状态仅限 未结(空),已结(C),取消(X)" .
                    next-prompt xxeprd_stat .
                    undo,retry .
                end.



            end. /*do on error undo, retry with frame d2:*/    


        end. /*  loopb: */
        hide frame d3 no-pause .
        hide frame d1 no-pause .
        hide frame d2 no-pause .