
{mfdeclre.i }
{gplabel.i}

{xxqmbkmt07.i }




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

            find last xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-lock no-error.
            if avail xxexpd_det then do:
                v_line = xxexpd_line + 1 .
            end.
            else v_line  = 1 .

            find first xxexp_mstr 
                    where xxexp_domain = global_domain 
                    and xxexp_nbr = v_nbr
            no-error .
            disp xxexp_nbr  xxexp_bk_nbr with frame d3 .

            update v_line  with frame d1 editing:
                     if frame-field = "v_line" then do:    
                         {mfnp01.i xxexpd_det  v_line xxexpd_line  v_nbr "xxexpd_domain = global_domain and xxexpd_nbr "  xxexpd_nbr }

                         if recno <> ? then do:
                            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error.

                            disp  xxexpd_line @ v_line  xxexpd_iss_nbr  xxexpd_iss_ln  xxexpd_iss_part xxexpd_um xxexpd_iss_qty xxexpd_iss_order with frame d1 .
                            disp xxexpd_amt xxexpd_ctry xxexpd_cu_ln xxexpd_cu_part xxexpd_cu_qty xxexpd_cu_um xxcpt_desc
                                 xxexpd_price xxexpd_iss_date xxexpd_um_conv xxexpd_stat xxexpd_used with frame d2.
                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.        
            end.
            assign v_line .

            find xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr and xxexpd_line = v_line  no-error.
            if not avail xxexpd_det then do:
                message "������¼" .
                create xxexpd_det .
                assign 
                    xxexpd_domain = global_domain
                    xxexpd_type   = v_form_type
                    xxexpd_nbr    = v_nbr 
                    xxexpd_line   = v_line
                    detail_add    = yes .
                    if detail_add = yes then new_add = yes .
            end.

            find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error.

            disp xxexpd_amt xxexpd_ctry xxexpd_cu_ln xxexpd_cu_part xxexpd_cu_qty xxexpd_cu_um xxcpt_desc when(avail xxcpt_mstr)
                 xxexpd_price xxexpd_iss_date xxexpd_um_conv xxexpd_stat xxexpd_used with frame d2.


            if detail_add then do on error undo , retry:
                clear frame d1 no-pause.
                clear frame d2 no-pause.
                disp v_line with frame d1 .
                v_abs_id = "" .
                update xxexpd_iss_nbr xxexpd_iss_ln with frame d1 editing:
                     if frame-field = "xxexpd_iss_nbr" then do:    
                            {mfnp05.i   abs_mstr
                                        abs_par_id
                                        "abs_mstr.abs_domain = global_domain  
                                        and abs_par_id begins 'S' 
                                        and abs_type = 'S' "
                                        abs_par_id
                                        " 'S' + input xxexpd_iss_nbr "}

                         if recno <> ? then do:
                            xxexpd_iss_nbr = substring(abs_par_id,2,50) .
                            xxexpd_iss_ln = integer(abs_line) . 
                            xxexpd_iss_order = abs_order .
                            v_abs_id  = abs_par_id .

                            disp   xxexpd_iss_nbr  xxexpd_iss_ln abs_item @ xxexpd_iss_part abs__qad02 @ xxexpd_um xxexpd_iss_order with frame d1 .
                            
                         end . /* if recno <> ? then  do: */
                     end.
                     else if frame-field = "xxexpd_iss_ln" then do:    
                         {mfnp01.i abs_mstr xxexpd_iss_ln  integer(abs_line) v_abs_id "abs_domain = global_domain and abs_par_id "   abs_par_id }

                         if recno <> ? then do:
                            xxexpd_iss_nbr = substring(abs_par_id,2,50) .
                            xxexpd_iss_ln = integer(abs_line) . 
                            xxexpd_iss_order = abs_order .
                            v_abs_id  = abs_par_id .

                            disp   xxexpd_iss_nbr  xxexpd_iss_ln abs_item @ xxexpd_iss_part abs__qad02 @ xxexpd_um xxexpd_iss_order with frame d1 .

                         end . /* if recno <> ? then  do: */
                     end.
                     else do:
                               status input ststatus.
                               readkey.
                               apply lastkey.
                     end.                
                end. /* update ...EDITING */
                assign xxexpd_iss_nbr xxexpd_iss_ln xxexpd_iss_order .


                find first abs_mstr where abs_domain = global_domain and abs_type = "S" and abs_par_id = "S" + xxexpd_iss_nbr and integer(abs_line) = xxexpd_iss_ln no-lock no-error.
                if not avail abs_mstr then do:
                    message "����:��Ч���˵���" .
                    undo ,retry .
                end.
                else do: /*avail abs_mstr*/
                    /*�Ѿ�ת���ص��������۳�*/
                    if abs_qty - abs__dec02  <= 0 then do:
                        message "����:������ȫ��ת���ص�" .
                        undo ,retry .
                    end.
                    else do:
                        message "��������:" abs_qty   ",δת���ص�����:" abs_qty - abs__dec02  .                        
                        find first xxccpt_mstr where xxccpt_domain = global_domain  and xxccpt_part = abs_item no-lock no-error .
                        if not avail xxccpt_mstr then do:
                            message "����:�������������:" abs_item .
                            undo,retry .
                        end.
                        else do:                            
                            find first xxcpt_mstr where xxcpt_domain = global_domain  and xxcpt_ln = xxccpt_ln no-lock no-error .
                            if not avail xxcpt_mstr then do:
                                message  "����:������Ʒ���벻����,��:" xxccpt_ln ",���:" abs_item.
                                undo ,retry.
                            end.
                            else do:

                                find first xxcbkd_det 
                                        where xxcbkd_domain = global_domain 
                                        and xxcbkd_bk_type  = v_bk_type
                                        and xxcbkd_bk_nbr = xxexp_bk_nbr 
                                        and xxcbkd_cu_ln  = xxcpt_ln
                                no-lock no-error .
                                if not avail xxcbkd_det then do:
                                    message "����:�޴���Ʒ�ĺ����ֲ����" .
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

                                message "�����ֲ�ʣ������:" 
                                        xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct 
                                        ",��λ:" xxcbkd_um .


                                xxexpd_iss_part  = abs_item.                                
                                xxexpd_iss_qty   = (abs_qty - abs__dec02) .    
                                xxexpd_iss_nbr   = substring(abs_par_id,2,50) .
                                xxexpd_iss_ln    = integer(abs_line). 
                                xxexpd_iss_order = abs_order .
                                xxexpd_iss_date  = abs_shp_date.
                                xxexpd_um        = abs__qad02.
                                xxexpd_um_conv   =  round(integer(abs__qad03) * xxccpt_um_conv,v_round2 + 2 ) . 
                                xxexpd_cu_um     = xxcpt_um .
                                xxexpd_cu_part   = xxcpt_cu_part .
                                xxexpd_cu_ln     = xxccpt_ln .
                                xxexpd_ctry      = xxccpt_ctry .
                                xxexpd_price     = xxcpt_price .
                                xxexpd_cu_qty    = round((abs_qty - abs__dec02)  * round(integer(abs__qad03) * xxccpt_um_conv,v_round2 + 2 ) , v_round2 )  .
                                xxexpd_amt       = xxexpd_price * xxexpd_cu_qty .

                                v_qty_b1 = 0 . /*qty_before*/ 
                                v_qty_b2 = 0.

                            end.
                        end.                            
                    end.
                end. /*avail abs_mstr*/
                disp xxexpd_iss_nbr xxexpd_iss_ln xxexpd_iss_part  xxexpd_um xxexpd_iss_order xxexpd_iss_qty with frame d1 .
                disp xxexpd_amt xxexpd_ctry xxexpd_cu_ln xxexpd_cu_part xxexpd_cu_qty xxexpd_cu_um xxcpt_desc
                     xxexpd_price xxexpd_iss_date xxexpd_um_conv xxexpd_stat xxexpd_used with frame d2.

 

                do on error undo, retry with frame d2:
                    update xxexpd_um_conv with frame d2 .
                    if  xxexpd_um_conv = 0 then do:
                        message "����:��λ��������,����Ϊ��" .
                        undo,retry .
                    end.

                end. /*do on error undo, retry with frame d2:*/        
                

            end. /*if detail_add then*/
            else   /*qty_before*/ assign v_qty_b1 = xxexpd_iss_qty  v_qty_b2 = xxexpd_cu_qty .

            find first abs_mstr where abs_domain = global_domain and abs_type = "S" and abs_par_id = "S" + xxexpd_iss_nbr and integer(abs_line) = xxexpd_iss_ln no-lock no-error.
            if not avail abs_mstr then do:
                message "����:��Ч���˵���" .
                undo ,retry .
            end.

            do on error undo, retry with frame d1:

                update xxexpd_iss_qty go-on("F5" "CTRL-D")  with frame d1 editing:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xxexpd_used > 0 then do :
                            message "����:�ѿ�ʼ���ת��,����ɾ��" .
                            undo,retry.
                        end.
                        else if xxexpd_stat <> "" then do :
                            message "����:�ǿ�״̬,����ɾ��" .
                            undo,retry.
                        end.
                        else do:
                            del-yn = yes.
                            {mfmsg01.i 11 1 del-yn}
                            if del-yn then do :
                                if v_qty_b1 <> 0 then do:
                                    find first abs_mstr 
                                            where abs_domain = global_domain 
                                            and abs_par_id   = "S" + xxexpd_iss_nbr 
                                            and abs_type     = "S"
                                            and integer(abs_line) = xxexpd_iss_ln 
                                    no-error.
                                    if avail abs_mstr then assign abs__dec02 = abs__dec02 - v_qty_b1 .

                                    find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xxexp_bk_nbr 
                                    no-error .        
                                    if avail xxcbk_mstr then assign  xxcbk_stat = "" .

                                    find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_nbr = xxexp_bk_nbr 
                                            and xxcbkd_cu_ln  = xxexpd_cu_ln
                                    no-error .                                    
                                    if avail xxcbkd_det then assign 
                                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 
                                           xxcbkd_stat = "" .
                                end. 
                                /*else is detail_add*/

                                delete xxexpd_Det.
                                clear frame d1 no-pause .
                                clear frame d2 no-pause .
                                next loopb .
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end. /*update xxexpd_iss_qty go-on("F5" "CTRL-D")*/

                if xxexpd_iss_qty <= 0 then do:
                    message "���ص���������Ϊ��" .
                    undo ,retry .
                end.
                if xxexpd_iss_qty <> v_qty_b1  then do:

                    find first abs_mstr 
                            where abs_domain = global_domain 
                            and abs_par_id   = "S" + xxexpd_iss_nbr 
                            and abs_type     = "S"
                            and integer(abs_line) = xxexpd_iss_ln 
                    no-error.
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type
                            and xxcbkd_bk_nbr = xxexp_bk_nbr 
                            and xxcbkd_cu_ln  = xxexpd_cu_ln
                    no-error .

                    if xxexpd_iss_qty >  ((abs_qty - abs__dec02)  + v_qty_b1 ) then do:
                        message "���ɳ������˵���ʣ������" .
                        undo,retry.
                    end.

                    if xxexpd_iss_qty < xxexpd_used then do:
                        message "�������ڱ��ص���ת�Ƶ�����" .
                        undo,retry.
                    end.

                    if  round(xxexpd_iss_qty * xxexpd_um_conv,v_round2) > 
                       (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct + v_qty_b2) then do:
                            message "�����ֲ��δ����������" .
                            undo,retry .
                    end.
                    
                    assign abs__dec02 = abs__dec02 - v_qty_b1 + xxexpd_iss_qty 
                           xxcbkd_qty_io = xxcbkd_qty_io - v_qty_b2 + round(xxexpd_iss_qty * xxexpd_um_conv,v_round2) 
                           xxexpd_cu_qty = round(xxexpd_iss_qty * xxexpd_um_conv,v_round2) 
                           xxexpd_amt = xxexpd_cu_qty * xxexpd_price
                           .                

                end. /*if xxexpd_iss_qty <> v_qty_b1*/
                disp xxexpd_amt xxexpd_ctry xxexpd_cu_ln xxexpd_cu_part xxexpd_cu_qty xxexpd_cu_um xxcpt_desc
                     xxexpd_price xxexpd_iss_date xxexpd_um_conv xxexpd_stat xxexpd_used with frame d2.

            end. /*do on error undo, retry with frame d1:*/

            do on error undo, retry with frame d2:
                update xxexpd_amt xxexpd_stat with frame d2 .
                if  xxexpd_price = 0 or xxexpd_amt = 0 then do:
                    message "����:���ۺͽ���Ϊ��" .
                    undo,retry .
                end.

                if xxexpd_stat <> "" and index("XC",xxexpd_stat) = 0 then do:
                    message "����:״̬���� δ��(��),�ѽ�(C),ȡ��(X)" .
                    next-prompt xxexpd_stat .
                    undo,retry .
                end.



            end. /*do on error undo, retry with frame d2:*/    


        end. /*  loopb: */
        hide frame d3 no-pause .
        hide frame d1 no-pause .
        hide frame d2 no-pause .