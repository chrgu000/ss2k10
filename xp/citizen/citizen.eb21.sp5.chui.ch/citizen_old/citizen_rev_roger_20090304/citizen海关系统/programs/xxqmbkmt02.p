/* xxqmbkmt02.p  �����ֲ�������ת--ת��                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 03/13/2008   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "1+ "}    /* DISPLAY TITLE */
define var v_nbr as char .
define var v_bk_type    like xxcbkd_bk_type initial  "IMP" .
define var v_form_type  like xximp_type initial "3" .
define var v_line  as integer format ">>9" label "��".

define var v_recid like recno  .
define var del-yn   as logical initial no .
define var v_all   as logical initial yes .
define var v_add   as logical initial yes .
define var new_add as logical initial no .
define var detail_add as logical initial no .
define var v_amt like xximp_amt .




define frame b.
define frame c.
define frame d .


form
    space(1)
    v_nbr                  label "���ص���"   
    xximp_bk_nbr           label "�ֲ���" 
    /*space(10)
    v_add                  label "�Զ�" 
    v_all               label "ȫ��"*/

with frame b  side-labels width 80 attr-space.


form                
        v_line                label "��"
        xximpd_cu_ln          label "��"
        /*xximpd_cu_part        label "��Ʒ����"*/
        xximpd_cu_qty         label "����"
        xximpd_cu_um          label "��λ"
        xximpd_ctry           label "ԭ����"
        xximpd_price          label "����"
        xximpd_amt            label "���"
        xximpd_stat           label "״̬" 

with frame c three-d overlay 13 down scroll 1 width 80 . 


form
    xximp_cu_nbr       label "���ر��"    colon 13 xximp_rct_date     label "��������"    colon 45  
    xximp_pre_nbr      label "Ԥ¼����"  colon 13 xximp_req_date     label "�걨����"    colon 45  
    xximp_bk_nbr       label "�ֲ���"    colon 13 xximp_crt_date     label "ά������"    colon 45  
    xximp_dept         label "���ڿڰ�"    colon 13 xximp_from         label "���˵�"      colon 45  
    xximp_ship_via     label "���䷽ʽ"    colon 13 xximp_to           label "Ŀ�ĵ�"      colon 45  
    xximp_ship_tool    label "���乤��"    colon 13 xximp_port         label "װ����"      colon 45  
    xximp_bl_nbr       label "���˵�"      colon 13 xximp_fob          label "�ɽ���ʽ"    colon 45  
    xximp_trade_mtd    label "ó�׷�ʽ"    colon 13 xximp_box_num      label "����"        colon 45  
    xximp_tax_mtd      label "��������"    colon 13 xximp_tax_rate     label "��˰����"    colon 45  
    xximp_box_type     label "��װ����"    colon 13 xximp_net          label "����"        colon 45  
    xximp_license      label "���֤��"    colon 13 xximp_gross        label "ë��"        colon 45  
    xximp_appr_nbr     label "��׼�ĺ�"    colon 13 xximp_curr         label "�ұ�"        colon 45  
    xximp_contract     label "��ͬЭ���"  colon 13 xximp_amt          label "���"        colon 45 
    xximp_container    label "��װ���"    colon 13 xximp_stat         label "״̬"        colon 45 
    xximp_rmks1        label "��ͷ"        colon 13 xximp_use          label "��;"        colon 45  
    xximp_rmks2        label "��ע"        colon 13                                               
with frame d side-labels width 80 attr-space .     


                                                                                 
mainloop:
repeat:

    view frame b  .
    view frame c .
    clear frame b no-pause .
    clear frame c no-pause .
    new_add = no .
    detail_add  = no .

    find first xximp_mstr where xximp_domain = global_domain and xximp_nbr = v_nbr no-error .
    if avail xximp_mstr then do:
        disp v_nbr xximp_bk_nbr with frame b .
    end .

    update v_nbr with frame b editing:
            if frame-field="v_nbr" then do:
                {mfnp01.i xximp_mstr v_nbr xximp_nbr v_form_type " xximp_domain = global_domain and xximp_type " xximp_type }
                if recno <> ? then do:
                    disp xximp_nbr @ v_nbr  with frame b .
                end.
            end.
            else do:
                status input ststatus.
                readkey.
                apply lastkey.
            end.
    end. /*update v_nbr*/
    assign v_nbr .

    if v_nbr = "" then do:
        message "����:���ص��Ų�����Ϊ��." .
        undo ,retry .
    end.

    find first xximp_mstr where xximp_domain = global_domain and xximp_nbr = v_nbr no-error .
    if avail xximp_mstr then do:
        if xximp_type <> v_form_type then do:
            message "����:�Ѵ���,�ҷ�'������ת'���ڱ��ص�,����������" .
            undo,retry .
        end.

        disp v_nbr xximp_bk_nbr with frame b .
    end .

    loopa :
    do on error undo,retry :
        find first xximp_mstr where xximp_domain = global_domain and xximp_nbr = v_nbr no-error .
        if not avail xximp_mstr then do:
            message "������¼" .

            find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-error.
            if not avail xxcbkc_ctrl then do:
                create xxcbkc_ctrl . xxcbkc_domain = global_domain .
            end.

            create xximp_mstr .
            assign 
                xximp_domain = global_domain 
                xximp_type    = v_form_type
                xximp_nbr    = v_nbr 
                xximp_userid     = global_userid
                xximp_crt_date   = today
                xximp_rct_date   = today
                xximp_req_date   = today
                xximp_bk_nbr     = ""                
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
                .   

            loopbk:
            do on error undo,retry :
                update xximp_bk_nbr with frame b editing:
                    if frame-field="xximp_bk_nbr" then do:
                        {mfnp01.i xxcbk_mstr xximp_bk_nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr }
                        if recno <> ? then do:
                            xximp_bk_nbr = xxcbk_bk_nbr .
                            disp 
                                xximp_bk_nbr  
                            with frame b.
                        end.
                    end.
                    else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                    end.              
                end. /*update xximp_bk_nbr*/
                assign xximp_bk_nbr .

                find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = xximp_bk_nbr no-lock no-error.
                if not avail xxcbk_mstr then do:
                    message "����:��Ч�ֲ��" .
                    undo,retry .
                end.
                else do:
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            /*and xxcbkd_bk_type  = v_bk_type */
                            and xxcbkd_bk_nbr   = xximp_bk_nbr
                            and (xxcbkd_stat = ""
                                /*or (xxcbkd_qty_ord + xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io + xxcbkd_qty_rjct ) > 0 */ )
                    no-lock no-error .
                    if not avail xxcbkd_det then do:
                        message "����:�ֲ���δ�����" .
                        undo,retry .
                    end.

                end.

            end. /*loopbk:*/
 
        end .        
        else message "�޸ļ�¼" .

        v_recid = recid(xximp_mstr) .

    end. /*loopa :*/


    find last xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr no-error.
    if avail xximpd_det then do:
        v_line = xximpd_line .
        disp v_line       
            xximpd_cu_ln     
            xximpd_cu_qty     
            xximpd_cu_um      
            xximpd_ctry       
            xximpd_price      
            xximpd_amt          
            xximpd_stat         
        with frame c.
    end.
    else v_line = 1 .

    loopb:
    repeat on endkey undo, leave:
        disp v_line with frame c .
        update v_line with frame c editing:
            if frame-field="v_line" then do:
                {mfnp01.i xximpd_det v_line xximpd_line v_nbr "xximpd_domain = global_domain and xximpd_nbr " xximpd_nbr}
                if recno <> ? then do:
                    v_line = xximpd_line .
                    disp v_line       
                        xximpd_cu_ln     
                        xximpd_cu_qty     
                        xximpd_cu_um      
                        xximpd_ctry       
                        xximpd_price      
                        xximpd_amt          
                        xximpd_stat         
                    with frame c.
                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xximpd_cu_ln no-lock no-error .
                    if avail xxcpt_mstr then  message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
                end.
            end.
            else do:
                status input ststatus.
                readkey.
                apply lastkey.
            end.                
        end. /*update v_line*/
        assign  v_line . 

        loopc:
        do on error undo,retry :
            find first xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr and xximpd_line = v_line  no-error .
            if not avail xximpd_det  then do:
                clear frame c no-pause .
                disp v_line with frame c .
                message "������¼" .

                create xximpd_det .
                assign 
                    xximpd_domain  = global_domain
                    xximpd_type    = v_form_type
                    xximpd_nbr     = v_nbr    
                    xximpd_line    = v_line  
                    detail_add  = yes 
                    .
                if detail_add then new_add = yes .

                loopd:
                do on error undo,retry :
                    update xximpd_cu_ln with frame c editing:
                        if frame-field="xximpd_cu_ln" then do:
                            {mfnp01.i xxcpt_mstr xximpd_cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
                            if recno <> ? then do:
                                xximpd_cu_ln = xxcpt_ln .
                                disp 
                                    xximpd_cu_ln 
                                with frame c.
                                message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
                            end.
                        end.
                        else do:
                            status input ststatus.
                            readkey.
                            apply lastkey.
                        end.      
                    end. /*update xximpd_cu_ln*/
                    assign xximpd_cu_ln .

                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xximpd_cu_ln no-lock no-error .
                    if avail xxcpt_mstr then  message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
                    else do:
                        message "����:��Ч��˾���,����������" .
                        undo,retry.
                    end.

                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            /*and xxcbkd_bk_type  = v_bk_type*/ 
                            and xxcbkd_bk_nbr   = xximp_bk_nbr
                            and xxcbkd_cu_ln    = xximpd_cu_ln 
                            and (xxcbkd_stat = ""
                                /*or (xxcbkd_qty_ord + xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) > 0 */ )
                    no-error .
                    if not avail xxcbkd_det then do:
                        message "����:�ֲ��޴���Ʒ��δ�����" .
                        undo,retry .
                    end.
                    else do:
                        xximpd_cu_ln   = xxcpt_ln .
                        xximpd_cu_part = xxcpt_cu_part .
                        xximpd_cu_um   = xxcpt_um.
                        xximpd_cu_qty  = 0 .
                        xximpd_ctry    = xxcbkd_ctry  .
                        xximpd_price   = xxcbkd_price .
                        xximpd_amt     = xxcbkd_price * xximpd_cu_qty .
                        
                    end.

                    disp v_line       
                        xximpd_cu_ln     
                        xximpd_cu_qty     
                        xximpd_cu_um      
                        xximpd_ctry       
                        xximpd_price      
                        xximpd_amt          
                        xximpd_stat         
                    with frame c.

                end. /*loopd*/

                loope :
                do on error undo, retry:
                    update xximpd_cu_qty with frame c .
                    if xximpd_cu_qty <= 0 then do:
                        message "����:��������������" .
                        undo,retry .
                    end.
                    xximpd_amt     = xxcbkd_price * xximpd_cu_qty .

                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xximp_bk_nbr
                            and xxcbkd_cu_ln    = xximpd_cu_ln 
                    no-error .
                    if avail xxcbkd_det then xxcbkd_qty_tsf = xxcbkd_qty_tsf + xximpd_cu_qty .
                end. /*loope*/

                disp v_line       
                    xximpd_cu_ln     
                    xximpd_cu_qty     
                    xximpd_cu_um      
                    xximpd_ctry       
                    xximpd_price      
                    xximpd_amt          
                    xximpd_stat         
                with frame c.

            end. /*if not avail xximpd_det */
            else do : /*if avail xximpd_det */
                    message "�޸ļ�¼".
                    disp v_line       
                        xximpd_cu_ln     
                        xximpd_cu_qty     
                        xximpd_cu_um      
                        xximpd_ctry       
                        xximpd_price      
                        xximpd_amt          
                        xximpd_stat         
                    with frame c.
                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xximpd_cu_ln no-lock no-error .
                    if avail xxcpt_mstr then  message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
            end. /*if avail xximpd_det */


            ctryloop:
            do on error undo, retry:
                update xximpd_ctry go-on(F5 CTRL-D) with frame c.
                
                find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = xximpd_ctry no-lock no-error .
                if not avail xxctry_mstr then do:
                    message "����:ԭ��������,����������" .
                    undo, retry.
                end.

                if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                then do:
                    if xximpd_stat <> "" then do:
                        message "����:�ѽ����,������ɾ��" .
                        undo,retry.
                    end.
                    else do:
                        find first  xxcbkd_det 
                                where xxcbkd_domain = global_domain 
                                and xxcbkd_bk_type  = v_bk_type 
                                and xxcbkd_bk_nbr   = xximp_bk_nbr
                                and xxcbkd_cu_ln    = xximpd_cu_ln 
                        no-error .
                        if xxcbkd_stat <> "" then do:
                            message "����:�ֲ�����ѽ�,������ɾ��" .
                            undo,retry.
                        end.
                        else do:
                            del-yn = yes.
                            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                            if del-yn then do:
                                find first xxcbkd_det 
                                        where xxcbkd_domain = global_domain 
                                        and xxcbkd_bk_type  = v_bk_type 
                                        and xxcbkd_bk_nbr   = xximp_bk_nbr
                                        and xxcbkd_cu_ln    = xximpd_cu_ln 
                                no-error .
                                if avail xxcbkd_det then xxcbkd_qty_tsf = xxcbkd_qty_tsf - xximpd_cu_qty .

                                delete xximpd_det .
                                new_add = yes .
                                clear frame c.
                                del-yn = no.
                                next.
                            end.
                        end.
                    end.
                end. /*if lastkey = keycode("F5")*/                  

            end. /*ctryloop*/

        end.  /*loopc:*/

    end. /*loopb:*/

    if new_add then do:
        find first xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr no-error .
        if avail xximpd_det then do:
            v_amt = 0 .
            for each xximpd_det where xximpd_domain = global_domain and xximpd_nbr = v_nbr no-lock :
                v_amt = v_amt + xximpd_amt . /*Ĭ��curr����USD*/
            end.
            if v_amt <> xximp_amt then message "�ۼƽ��:" v_amt .
        end.
    end.


    find xximp_mstr where xximp_domain = global_domain and xximp_nbr = v_nbr no-error.
    v_recid = if avail xximp_mstr then recid(xximp_mstr) else ? .
hide frame c no-pause .
view frame d .
    do transaction
        on error undo, 
        retry with frame d:       

        find xximp_mstr where recid(xximp_mstr) = v_recid no-error .
        if not avail xximp_mstr then leave .

            disp 
                xximp_cu_nbr    
                xximp_pre_nbr 
                xximp_bk_nbr    
                xximp_dept      
                xximp_ship_via  
                xximp_ship_tool 
                xximp_bl_nbr    
                xximp_trade_mtd 
                xximp_tax_mtd   
                xximp_tax_rate  
                xximp_license   
                xximp_appr_nbr  
                xximp_contract  
                xximp_container     
                xximp_rct_date    
                xximp_req_date      
                xximp_crt_date 
                xximp_from     
                xximp_to       
                xximp_port     
                xximp_fob      
                xximp_box_num  
                xximp_box_type 
                xximp_net      
                xximp_gross    
                xximp_curr     
                xximp_amt      
                xximp_stat     
                xximp_use      
                xximp_rmks1     
                xximp_rmks2 
            with frame d .

            update 
                xximp_cu_nbr    
                xximp_pre_nbr 
                xximp_dept      
                xximp_ship_via  
                xximp_ship_tool 
                xximp_bl_nbr    
                xximp_trade_mtd 
                xximp_tax_mtd   
                xximp_box_type  
                xximp_license   
                xximp_appr_nbr  
                xximp_contract  
                xximp_container     
                xximp_rct_date    
                xximp_req_date      
                xximp_from     
                xximp_to       
                xximp_port     
                xximp_fob      
                xximp_box_num  
                xximp_tax_rate 
                xximp_net      
                xximp_gross    
                xximp_curr     
                xximp_amt      
                xximp_stat     
                xximp_use      
                xximp_rmks1     
                xximp_rmks2 
            go-on("F5" "CTRL-D")
            with frame d .

            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
                if xximp_stat <> "" then do:
                    message "����:���ص��ѽ�,������ɾ��" .
                    undo,retry.
                end.
                for each xximpd_det where xximpd_domain = global_domain and xximpd_nbr = xximp_nbr :
                    if xximpd_stat <> "" then do:
                        message "����:�ѽ����,������ɾ��" .
                        undo,retry.
                    end.
                    else do:
                        find first  xxcbkd_det 
                                where xxcbkd_domain = global_domain 
                                and xxcbkd_bk_type  = v_bk_type 
                                and xxcbkd_bk_nbr   = xximp_bk_nbr
                                and xxcbkd_cu_ln    = xximpd_cu_ln 
                        no-error .
                        if xxcbkd_stat <> "" then do:
                            message "����:�ֲ�����ѽ�,������ɾ��" .
                            undo,retry.
                        end.
                        else do:
                            /*nothing*/
                        end.
                    end.                        
                end. /*check*/                
            
                {mfmsg01.i 11 1 del-yn}

                if not del-yn then undo, retry.

                if del-yn then do:

                    for each xximpd_det where xximpd_domain = global_domain and xximpd_nbr = xximp_nbr :
                        if xximpd_stat <> "" then do:
                            message "����:�ѽ����,������ɾ��" .
                            undo,retry.
                        end.
                        else do:
                            find first  xxcbkd_det 
                                    where xxcbkd_domain = global_domain 
                                    and xxcbkd_bk_type  = v_bk_type 
                                    and xxcbkd_bk_nbr   = xximp_bk_nbr
                                    and xxcbkd_cu_ln    = xximpd_cu_ln 
                            no-error .
                            if xxcbkd_stat <> "" then do:
                                message "����:�ֲ�����ѽ�,������ɾ��" .
                                undo,retry.
                            end.
                            else do:
                                    find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type  = v_bk_type 
                                            and xxcbkd_bk_nbr   = xximp_bk_nbr
                                            and xxcbkd_cu_ln    = xximpd_cu_ln 
                                    no-error .
                                    if avail xxcbkd_det then xxcbkd_qty_tsf = xxcbkd_qty_tsf - xximpd_cu_qty .

                                    delete xximpd_det .
                            end.
                        end.                        
                    end. /*delete*/
                    delete xximp_mstr.

                    clear frame d.
                    next.
                end.
            end.

            if xximp_rct_date = ? or xximp_req_date = ? then do:
                message "����:��Ч����,����������" .
                next-prompt xximp_rct_date .
                undo,retry .
            end.
            if xximp_amt <= 0 then do:
                message "����:��Ч���,����������" .
                next-prompt xximp_amt .
                undo,retry .
            end.
    end. /*do  transaction */ 


    hide frame d no-pause .
    hide frame b no-pause .
    
    release xximpd_det no-error.
    release xximp_mstr no-error .
end. /*mainloop*/

