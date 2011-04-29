
{mfdeclre.i }
{gplabel.i}

{xxqminmt10.i }




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

            find last xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = v_nbr no-lock no-error.
            if avail xxiprd_det then do:
                v_line = xxiprd_line + 1 .
            end.
            else v_line  = 1 .

            find first xxipr_mstr 
                    where xxipr_domain = global_domain 
                    and xxipr_nbr = v_nbr
            no-error .
            disp xxipr_nbr xxipr_bar_code xxipr_bk_nbr with frame d3 .

            update v_line  with frame d1 editing:
                     if frame-field = "v_line" then do:    
                         {mfnp01.i xxiprd_det  v_line xxiprd_line  v_nbr "xxiprd_domain = global_domain and xxiprd_nbr "  xxiprd_nbr }

                         if recno <> ? then do:
                            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxiprd_cu_ln no-lock no-error.

                            disp  xxiprd_line @ v_line  xxiprd_rct_nbr  xxiprd_rct_ln  xxiprd_rct_part xxiprd_um xxiprd_rct_qty xxiprd_rct_order with frame d1 .
                            disp xxiprd_amt xxiprd_ctry xxiprd_cu_ln xxiprd_cu_part xxiprd_cu_qty xxiprd_cu_um xxcpt_desc
                                 xxiprd_price xxiprd_rct_date xxiprd_um_conv xxiprd_stat xxiprd_used with frame d2.
                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.        
            end.
            assign v_line .

            find xxiprd_det where xxiprd_domain = global_domain and xxiprd_nbr = v_nbr and xxiprd_line = v_line  no-error.
            if not avail xxiprd_det then do:
                message "������¼" .
                create xxiprd_det .
                assign 
                    xxiprd_domain = global_domain
                    xxiprd_nbr  = v_nbr 
                    xxiprd_line = v_line
                    detail_add = yes .
                    if detail_add = yes then new_add = yes .
            end.

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxiprd_cu_ln no-lock no-error.

            disp xxiprd_amt xxiprd_ctry xxiprd_cu_ln xxiprd_cu_part xxiprd_cu_qty xxiprd_cu_um xxcpt_desc when(avail xxcpt_mstr)
                 xxiprd_price xxiprd_rct_date xxiprd_um_conv xxiprd_stat xxiprd_used with frame d2.


            if detail_add then do on error undo , retry:
                clear frame d1 no-pause.
                clear frame d2 no-pause.
                disp v_line with frame d1 .
                update xxiprd_rct_nbr xxiprd_rct_ln with frame d1 editing:
                     if frame-field = "xxiprd_rct_nbr" then do:    
                         {mfnp.i prh_hist  xxiprd_rct_nbr prh_receiver  xxiprd_rct_nbr "prh_domain = global_domain and prh_receiver " prh_receiver}

                         if recno <> ? then do:
                            xxiprd_rct_nbr = prh_receiver.
                            xxiprd_rct_ln = prh_line . 
                            xxiprd_rct_order = prh_nbr.

                            disp   xxiprd_rct_nbr  xxiprd_rct_ln prh_part @ xxiprd_rct_part prh_um @ xxiprd_um xxiprd_rct_order with frame d1 .
                            
                         end . /* if recno <> ? then  do: */
                     end.
                     else if frame-field = "xxiprd_rct_ln" then do:    
                         {mfnp01.i prh_hist   xxiprd_rct_ln  prh_line xxiprd_rct_nbr "prh_domain = global_domain and prh_receiver  "   prh_receiver}

                         if recno <> ? then do:
                            xxiprd_rct_nbr = prh_receiver.
                            xxiprd_rct_ln = prh_line . 
                            xxiprd_rct_order = prh_nbr.

                            disp    xxiprd_rct_nbr  xxiprd_rct_ln prh_part @ xxiprd_rct_part  prh_um @ xxiprd_um xxiprd_rct_order with frame d1 .

                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.                
                end. /* update ...EDITING */
                assign xxiprd_rct_nbr xxiprd_rct_ln xxiprd_rct_order .


                find first prh_hist where prh_domain = global_domain and prh_receiver = xxiprd_rct_nbr and prh_line = xxiprd_rct_ln no-lock no-error.
                if not avail prh_hist then do:
                    message "��Ч�ջ�����" .
                    undo ,retry .
                end.
                else do: /*avail prh_hist*/
                    /*�Ѿ�ת���ص�������prh__dec01�۳�*/
                    if prh_rcvd - prh__dec01 <= 0 then do:
                        message "����:������ȫ��ת���ص�" .
                        undo ,retry .
                    end.
                    else do:
                        message "�ջ�����:" prh_rcvd ",δת���ص�����:" prh_rcvd - prh__dec01 .                        
                        find first xxccpt_mstr where xxccpt_domain = global_domain  and xxccpt_part = prh_part no-lock no-error .
                        if not avail xxccpt_mstr then do:
                            message "����:�������������:" prh_part .
                            undo,retry .
                        end.
                        else do:                            
                            find first xxcpt_mstr where xxcpt_domain = global_domain  and xxcpt_ln = xxccpt_ln no-lock no-error .
                            if not avail xxcpt_mstr then do:
                                message  "����:������Ʒ���벻����:" xxccpt_ln .
                                undo ,retry.
                            end.
                            else do:
                                find first xxcbkd_det 
                                        where xxcbkd_domain = global_domain 
                                        and xxcbkd_bk_type  = v_bk_type
                                        and xxcbkd_bk_nbr = xxipr_bk_nbr 
                                        and xxcbkd_cu_ln  = xxcpt_ln
                                no-lock no-error .
                                if not avail xxcbkd_det then do:
                                    message "����:�޴˺����ֲ����" .
                                    undo ,retry .
                                end.
                                if xxcbkd_stat = "C" then do:
                                    message "����:�˺����ֲ�����ѽ�" .
                                    undo,retry .
                                end.
                                if (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) <= 0 then do:
                                    message "����:�˺����ֲ������������" .
                                    undo,retry .
                                end.

                                message "�����ֲ�ʣ������:" xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct 
                                        ",��λ:" xxcbkd_um .


                                xxiprd_rct_part  = prh_part.                                
                                xxiprd_rct_qty   = (prh_rcvd - prh__dec01) .    
                                xxiprd_rct_nbr = prh_receiver.
                                xxiprd_rct_ln = prh_line . 
                                xxiprd_rct_order = prh_nbr.
                                xxiprd_rct_date  = prh_rcp_date.
                                xxiprd_um = prh_um.
                                xxiprd_um_conv =  round(prh_um_conv * xxccpt_um_conv,v_round2 + 2 ) . 
                                xxiprd_cu_um = xxcpt_um .
                                xxiprd_cu_part = xxcpt_cu_part .
                                xxiprd_cu_ln = xxccpt_ln .
                                xxiprd_ctry  = xxccpt_ctry .
                                xxiprd_price = xxcpt_price .
                                xxiprd_cu_qty = round((prh_rcvd - prh__dec01)  * round(prh_um_conv * xxccpt_um_conv,v_round2 + 2 ) , v_round2 )  .
                                xxiprd_amt       = xxiprd_price * xxiprd_cu_qty .

                                v_qty_b1 = 0 . /*qty_before*/ 
                                v_qty_b2 = 0.

                            end.
                        end.                            
                    end.
                end. /*avail prh_hist*/
                disp xxiprd_rct_nbr xxiprd_rct_ln xxiprd_rct_part  xxiprd_um xxiprd_rct_order xxiprd_rct_qty with frame d1 .
                disp xxiprd_amt xxiprd_ctry xxiprd_cu_ln xxiprd_cu_part xxiprd_cu_qty xxiprd_cu_um xxcpt_desc
                     xxiprd_price xxiprd_rct_date xxiprd_um_conv xxiprd_stat xxiprd_used with frame d2.

 

                do on error undo, retry with frame d2:
                    update xxiprd_um_conv with frame d2 .
                    if  xxiprd_um_conv = 0 then do:
                        message "��λ��������,����Ϊ��" .
                        undo,retry .
                    end.

                end. /*do on error undo, retry with frame d2:*/        
                

            end. /*if detail_add then*/
            else   /*qty_before*/ assign v_qty_b1 = xxiprd_rct_qty  v_qty_b2 = xxiprd_cu_qty .

            find first prh_hist where prh_domain = global_domain and prh_receiver = xxiprd_rct_nbr and prh_line = xxiprd_rct_ln no-lock no-error.
            if not avail prh_hist then do:
                message "��Ч�ջ�����" .
                undo ,retry .
            end.    

            do on error undo, retry with frame d1:

                update xxiprd_rct_qty go-on("F5" "CTRL-D")  with frame d1 editing:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxiprd_used > 0 then do :
                            message "����:�ѿ�ʼ���ת��,����ɾ��" .
                            undo,retry.
                        end.
                        else if xxiprd_stat <> "" then do :
                            message "����:�ǿ�״̬,����ɾ��" .
                            undo,retry.
                        end.
                        else do:
                            del-yn = yes.
                            {mfmsg01.i 11 1 del-yn}
                            if del-yn then do :
                                if v_qty_b1 <> 0 then do:
                                    find first prh_hist 
                                            where prh_domain = global_domain 
                                            and prh_receiver = xxiprd_rct_nbr 
                                            and prh_line = xxiprd_rct_ln 
                                    no-error.
                                    if avail prh_hist then assign prh__dec01 = prh__dec01 - v_qty_b1 .

                                    find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxipr_bk_nbr 
                                    no-error .        
                                    if avail xxcbk_mstr then assign  xxcbk_stat = "" .

                                    find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_nbr = xxipr_bk_nbr 
                                            and xxcbkd_cu_ln  = xxiprd_cu_ln
                                    no-error .                                    
                                    if avail xxcbkd_det then assign 
                                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 
                                           xxcbkd_stat = "" .
                                end. 
                                /*else is detail_add*/

                                delete xxiprd_Det.
                                clear frame d1 no-pause .
                                clear frame d2 no-pause .
                                next loopb .
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end. /*update xxiprd_rct_qty go-on("F5" "CTRL-D")*/

                if xxiprd_rct_qty <= 0 then do:
                    message "���ص���������Ϊ��" .
                    undo ,retry .
                end.
                if xxiprd_rct_qty <> v_qty_b1  then do:

                    find first prh_hist 
                            where prh_domain = global_domain 
                            and prh_receiver = xxiprd_rct_nbr 
                            and prh_line = xxiprd_rct_ln 
                    no-error.
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type
                            and xxcbkd_bk_nbr = xxipr_bk_nbr 
                            and xxcbkd_cu_ln  = xxiprd_cu_ln
                    no-error .
                    if xxiprd_rct_qty >  (prh_rcvd - prh__dec01 + v_qty_b1 ) then do:
                        message "���ɳ����ջ�����ʣ������" .
                        undo,retry.
                    end.

                    if xxiprd_rct_qty < xxiprd_used then do:
                        message "�������ڱ��ص���ת�Ƶ�����" .
                        undo,retry.
                    end.

                    if xxiprd_rct_qty * xxiprd_um_conv > 
                       (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct + v_qty_b2) then do:
                            message "�����ֲ��δ����������" .
                            undo,retry .
                    end.

                    
                    assign prh__dec01 = prh__dec01 - v_qty_b1 + xxiprd_rct_qty 
                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 + round(xxiprd_rct_qty * xxiprd_um_conv,v_round2) 
                           xxiprd_cu_qty = round(xxiprd_rct_qty * xxiprd_um_conv,v_round2) 
                           xxiprd_amt = xxiprd_cu_qty * xxiprd_price 
                           .                

                end. /*if xxiprd_rct_qty <> v_qty_b1*/
                disp xxiprd_amt xxiprd_ctry xxiprd_cu_ln xxiprd_cu_part xxiprd_cu_qty xxiprd_cu_um xxcpt_desc
                     xxiprd_price xxiprd_rct_date xxiprd_um_conv xxiprd_stat xxiprd_used with frame d2.

            end. /*do on error undo, retry with frame d1:*/

            do on error undo, retry with frame d2:
                update xxiprd_amt xxiprd_stat with frame d2 .
                if  xxiprd_price = 0 or xxiprd_amt = 0 then do:
                    message "����:���ۺͽ���Ϊ��" .
                    undo,retry .
                end.

                if xxiprd_stat <> "" and index("XC",xxiprd_stat) = 0 then do:
                    message "����:״̬���� δ��(��),�ѽ�(C),ȡ��(X)" .
                    next-prompt xxiprd_stat .
                    undo,retry .
                end.



            end. /*do on error undo, retry with frame d2:*/    


        end. /*  loopb: */
        hide frame d3 no-pause .
        hide frame d1 no-pause .
        hide frame d2 no-pause .