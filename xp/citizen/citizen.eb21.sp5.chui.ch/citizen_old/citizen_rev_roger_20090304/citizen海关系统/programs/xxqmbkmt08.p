/* xxqmbkmt08.p ���ǽ��ڱ��ص�                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 03/13/2008   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/




{mfdtitle.i "1+ "}    /* DISPLAY TITLE */

{xxqmbkmt08.i "NEW" } /* all defines */

v_bk_type = "IMP" .
mainloop:
repeat with frame h1 :
    ststatus = stline[1].
    status input ststatus.

    new_add = no .
    for each temp : delete temp . end.
    for each temp2 : delete temp2 . end.


    hide frame d1 no-pause .
    hide frame d2 no-pause .
    hide frame d3 no-pause .
    hide frame h1 no-pause .
    hide frame h2 no-pause .
    view frame h1 .
    view frame h2 .
    
    
    prompt-for v_nbr with frame h1 editing:
         if frame-field = "v_nbr" then do:    
             {mfnp01.i xximp_mstr v_nbr xximp_nbr v_form_type "xximp_domain = global_domain and xximp_type " xximp_type }

             if recno <> ? then do:
                v_nbr = xximp_nbr .
                disp  v_nbr   xximp_rct_date xximp_req_date   xximp_bk_nbr  with frame h1 .
                disp xximp_cu_nbr    xximp_pre_nbr xximp_dept  xximp_ship_via  xximp_ship_tool xximp_bl_nbr xximp_trade_mtd xximp_tax_mtd   
                    xximp_tax_rate  xximp_license   xximp_appr_nbr  xximp_contract  xximp_container   xximp_from     
                    xximp_to xximp_port  xximp_fob xximp_box_num xximp_box_type xximp_net xximp_gross xximp_curr xximp_amt xximp_stat xximp_use xximp_rmks1 xximp_rmks2 
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
        message "���Ų�����Ϊ��" .
        undo,retry.
    end.

    find first xximp_mstr where xximp_domain = global_domain and xximp_nbr = v_nbr no-error .
    if avail xximp_mstr then do:
        if xximp_type <> v_form_type then do:
            message "����:�Ѵ���,�ҷ�'����'���ڱ��ص�,����������" .
            undo,retry .
        end.
        v_add = no .
        v_all = no .
        disp v_nbr v_add v_all xximp_rct_date xximp_req_date     xximp_bk_nbr  with frame h1 .
        disp xximp_cu_nbr    xximp_pre_nbr xximp_dept  xximp_ship_via  xximp_ship_tool xximp_bl_nbr xximp_trade_mtd xximp_tax_mtd   
            xximp_tax_rate  xximp_license   xximp_appr_nbr  xximp_contract  xximp_container   xximp_from     
            xximp_to xximp_port  xximp_fob xximp_box_num xximp_box_type xximp_net xximp_gross xximp_curr xximp_amt xximp_stat xximp_use xximp_rmks1 xximp_rmks2 
        with frame h2 .
    end .

    loopa:
    do on error undo , retry:
        
        find xximp_mstr where xximp_domain = global_domain and xximp_type = v_form_type and xximp_nbr = v_nbr  no-error .
        if not avail xximp_mstr then do:  

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
            
            message "������¼" .
            create xximp_mstr .
            assign  xximp_domain = global_Domain 
                    xximp_type   = v_form_type 
                    xximp_nbr    = v_nbr 
                    xximp_userid     = global_userid
                    xximp_crt_date   = today
                    xximp_rct_date   = today
                    xximp_req_date   = today
                    xximp_bk_nbr     = if avail xxcbk_mstr then xxcbk_bk_nbr else ""              
                    xximp_amt        = 0
                    xximp_curr       = "USD"
                    xximp_dept       = xxcbkc_dept
                    xximp_trade_mtd  = xxcbkc_trade
                    xximp_ship_via   = xxcbkc_ship_via 
                    xximp_ship_tool  = xxcbkc_ship_tool
                    xximp_tax_mtd    = xxcbkc_tax_mtd
                    xximp_tax_rate   = xxcbkc_tax_ratio
                    xximp_port       = xxcbkc_imp
                    xximp_fob        = xxcbkc_fob 
                    xximp_from       = xxcbkc_frm_loc
                    xximp_to         = xxcbkc_loc       
                    xximp_box_type   = xxcbkc_box_type
                    xximp_bl_nbr     = xxcbkc_bl_nbr
                    new_add = yes 
                    v_add = yes 
                    v_all = yes .

        end.
        else message "�޸ļ�¼" .

        disp v_nbr  v_add v_all xximp_rct_date xximp_req_date     xximp_bk_nbr  with frame h1 .
        disp xximp_cu_nbr    xximp_pre_nbr xximp_dept  xximp_ship_via  xximp_ship_tool xximp_bl_nbr xximp_trade_mtd xximp_tax_mtd   
            xximp_tax_rate  xximp_license   xximp_appr_nbr  xximp_contract  xximp_container   xximp_from     
            xximp_to xximp_port  xximp_fob xximp_box_num xximp_box_type xximp_net xximp_gross xximp_curr xximp_amt xximp_stat xximp_use xximp_rmks1 xximp_rmks2 
        with frame h2 .

        v_recid = recid(xximp_mstr) .
        update 
            xximp_rct_date 
            xximp_req_date
            xximp_bk_nbr when ( new_add ) 
            v_add when ( new_add )
            v_all when ( new_add ) 
             

        go-on ("F5" "CTRL-D") with frame h1 editing :
                if frame-field = "xximp_bk_nbr" then do:
                    {mfnp01.i xxcbk_mstr xximp_bk_nbr xxcbk_bk_nbr "global_domain and xxcbk_stat = '' " xxcbk_domain xxcbk_bk_nbr }
                    if recno <> ? then do:
                        display  xxcbk_bk_nbr @ xximp_bk_nbr with frame h1.
                    end.
                end.
                else do:
                    readkey.
                    if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                        if xximp_stat <> "" then do:
                            message "����:��δ��״̬,������ɾ��" . 
                            undo,retry .
                        end.
                        else do:
                            find first xximpd_det 
                                    where xximpd_domain = global_domain 
                                    and xximpd_nbr = v_nbr 
                                    and (xximpd_stat <> "" /*or xximpd_used > 0*/ )
                            no-lock no-error.
                            if avail xximpd_det then do :
                                message "����:��ϸ��δ��״̬���ѿ�ʼ���ת��,������ɾ��" . 
                                undo,retry .
                            end.
                            else do:
                                del-yn = yes.
                                {mfmsg01.i 11 1 del-yn}
                                if del-yn then do :
                                    for each xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr :
                                        find first prh_hist 
                                            where prh_domain = global_domain 
                                            and prh_receiver = xximpd_rct_nbr 
                                            and prh_line = xximpd_rct_ln 
                                        no-error.
                                        if avail prh_hist then assign prh__dec01 = prh__dec01 - xximpd_rct_qty . 

                                        find first xxcbk_mstr 
                                            where xxcbk_domain = global_domain 
                                            and xxcbk_bk_nbr = xximp_bk_nbr 
                                        no-error .       
                                        if avail xxcbk_mstr and xxcbk_stat <> "" then assign  xxcbk_stat = ""  .

                                        find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type = v_bk_type
                                            and xxcbkd_bk_nbr = xximp_bk_nbr 
                                            and xxcbkd_cu_ln  = xximpd_cu_ln
                                        no-error . 
                                        if avail xxcbkd_det then 
                                            assign xxcbkd_stat = ""  
                                                   xxcbkd_qty_io = xxcbkd_qty_io - xximpd_cu_qty  .

                                        delete xximpd_Det.
                                    end.
                                    delete xximp_mstr .
                                    clear frame h1 no-pause .
                                    next mainloop .
                                end.
                            end.
                        end.
                    end. /*   "F5" "CTRL-D" */
                    else apply lastkey.
                end.
        end. /* update ...EDITING */

        if xximp_rct_date = ? then do:
            message "����:��Ч��������,����������." .
            next-prompt xximp_rct_date with frame h1.
            undo,retry .
        end.
        if xximp_req_date = ? then do:
            message "����:��Ч�걨����,����������." .
            next-prompt xximp_req_date with frame h1.
            undo,retry .
        end.

        find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = xximp_bk_nbr  no-error .
        if not avail xxcbk_mstr then do:
            message "����:��Ч�ֲ���,����������." .
            next-prompt xximp_bk_nbr with frame h1.
            undo,retry .
        end.
        else if xxcbk_stat <> "" then do :
            message "����:�ֲ��ѽ�,����������." .
            next-prompt xximp_bk_nbr with frame h1.
            undo,retry .
        end.
        else do:
            find first xxcbkd_det 
                    where xxcbkd_domain = global_domain 
                    and xxcbkd_bk_type  = v_bk_type 
                    and xxcbkd_bk_nbr   = xximp_bk_nbr 
                    and xxcbkd_stat     = ""
            no-error.
            if not avail xxcbkd_det then do:
                message "����:��δ���ֲ���ϸ,����������." .
                next-prompt xximp_bk_nbr with frame h1.
                undo,retry .
            end.
        end.

       
    end. /*  loopa: */

    if v_add then do:

        for each prh_hist use-index prh_rcp_date 
            where prh_domain = global_domain 
            and prh_rcp_date = xximp_rct_date 
            and prh__chr01 = "HK"
            and prh__dec01 < prh_rcvd 
            no-lock :

            v_error = "" .



            find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = prh_part no-lock no-error .
            if not avail xxccpt_mstr then do:
                message "����: �������" prh_part "������" ".�ջ�����:" prh_receiver . 
                v_error = "*ERROR*" .
            end.
            else do:
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                if not avail xxcpt_mstr then do:
                    message "����:���" prh_part ",��Ʒ��" xxccpt_ln "�޶�Ӧ������Ʒ" ".�ջ�����:" prh_receiver . 
                    v_error = "*ERROR*" .
                end.
                else do:


                    
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xximp_bk_nbr 
                            and xxcbkd_cu_ln    = xxcpt_ln 
                    no-error.
                    if not avail xxcbkd_det then do:
                        message "����:�ֲ��޴����" prh_part ",��Ʒ��" xxccpt_ln ".�ջ�����:" prh_receiver .
                        v_error = "*ERROR*" .
                    end.
                    else do:
                        if round((prh_rcvd - prh__dec01) * round(prh_um_conv * xxccpt_um_conv,v_round2 + 2 ) , v_round2 ) >= 
                           ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) then do:
                            message  "����:�ֲ���������,���" prh_part ",��Ʒ��" xxccpt_ln ".�ջ�����:" prh_receiver . 
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
            {gprun.i ""xxqmbkmt08a.p""}        
        end.
        else do:
            message "����:�޷����������ջ���." .
            undo ,retry.
        end.

        if info_correct then do:

             for each temp where t_yn = yes :
                    find first xxccpt_mstr where xxccpt_domain = global_domain and xxccpt_part = t_part no-lock no-error .
                    if not avail xxccpt_mstr then do:
                        message "����:�������" t_part "������" ".�ջ�����:" t_nbr .
                        next .
                    end.
                    else do:
                        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxccpt_ln no-lock no-error .
                        if not avail xxcpt_mstr then do:
                            message "����:���" t_part ",��Ʒ��" xxccpt_ln "�޶�Ӧ������Ʒ" ".�ջ�����:" t_nbr .
                            next .
                        end.
                    end. 
                    
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xximp_bk_nbr 
                            and xxcbkd_cu_ln    = t_cu_ln 
                    no-error.
                    if not avail xxcbkd_det then do:
                        message "����:�ֲ��޴���Ʒ��:" t_cu_ln "���" t_part ".�ջ�����:" t_nbr .
                        next.
                    end.
                    else do: 
                        if round(t_rcvd  * round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) , v_round2 ) > 
                           ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) then do:
                            message  "����:�ֲ���������:" t_cu_ln "���" t_part ".�ջ�����:" t_nbr .
                            next.
                        end.
                        else do:
                            find last xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr no-lock no-error.
                            if avail xximpd_det then do:
                                v_line = xximpd_line + 1 .
                            end.
                            else v_line  = 1 .  
                            
                            find xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr and xximpd_line = v_line  no-error.
                            if not avail xximpd_det then do:
                                new_add = yes .
                                create xximpd_det .
                                xximpd_domain = global_domain .
                                xximpd_type   = v_form_type .
                                xximpd_nbr    = v_nbr .
                                xximpd_line   = v_line .
                                xximpd_rct_nbr   = t_nbr.
                                xximpd_rct_ln    = t_line . 
                                xximpd_rct_order = t_ponbr.
                                xximpd_rct_part  = t_part.
                                xximpd_rct_qty   = t_rcvd  .  
                                xximpd_rct_date  = t_rcp_date .
                                xximpd_um        = t_um.
                                xximpd_um_conv   = round(t_um_conv1 * t_um_conv2,v_round2 + 2 ) .                                
                                xximpd_cu_ln     = xxcbkd_cu_ln .
                                xximpd_cu_part   = xxcbkd_cu_part .                                
                                xximpd_cu_um     = xxcbkd_um .
                                xximpd_cu_qty    = round(t_rcvd  * xximpd_um_conv, v_round2) . 
                                xximpd_ctry      = t_ctry .
                                xximpd_price     = xxcbkd_price .
                                xximpd_amt       = xximpd_price * xximpd_cu_qty .

                                xxcbkd_qty_io   = xxcbkd_qty_io + xximpd_cu_qty .     /*�ۼ��ֲ�����*/

                                find first prh_hist where prh_domain = global_domain and prh_receiver = t_nbr and prh_line = t_line no-error .
                                if avail prh_hist then do :
                                    prh__dec01 = prh__dec01 + xximpd_rct_qty .  /*�ۼ�Prh����*/
                                end.
                            end.  
                        end. /*�ֲ�������*/
                    end. /*if avail xxcbkd_det*/
            end. /*for each temp*/
        end. /*if info_correct */
        else do:
            undo , retry .
        end.
    end. /*if v_add then do:*/

    {gprun.i ""xxqmbkmt08b.p""}   /*details*/

    view frame h1 .
    view frame h2 .
    if new_add then do:        
        xximp_amt = 0 .
        for each  xximpd_det where xximpd_domain = global_domain and xximpd_nbr = xximp_nbr :
            xximp_amt = xximpd_amt + xximp_amt .
        end.
    end.
    else do:
        v_amt = 0 .
        for each  xximpd_det where xximpd_domain = global_domain and xximpd_nbr = xximp_nbr :
            v_amt = xximpd_amt + v_amt .
        end.
        if v_amt <> xximp_amt then do:
            message "����:�ܽ�һ��:" v_amt "" xximp_amt .
        end.
    end.

    {gprun.i ""xxqmbkmt08c.p""} 
    
    release xximpd_det no-error.
    release xximp_mstr no-error .

end.   /*  mainloop: */
status input.