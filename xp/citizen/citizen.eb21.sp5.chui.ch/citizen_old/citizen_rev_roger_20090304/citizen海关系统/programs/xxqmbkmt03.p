/* xxqmbkmt03.p  �����ֲ�������ת--ת��                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 03/13/2008   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "1+ "}    /* DISPLAY TITLE */
define var v_nbr as char .
define var v_bk_type    like xxcbkd_bk_type initial  "OUT" .
define var v_form_type  like xxexp_type initial "3" .
define var v_line  as integer format ">>9" label "��".

define var v_recid like recno  .
define var del-yn   as logical initial no .
define var v_all   as logical initial yes .
define var v_add   as logical initial yes .
define var new_add as logical initial no .
define var detail_add as logical initial no .
define var v_amt like xxexp_amt .




define frame b.
define frame c.
define frame d .


form
    space(1)
    v_nbr                  label "���ص���"   
    xxexp_bk_nbr           label "�ֲ���" 
    /*space(10)
    v_add                  label "�Զ�" 
    v_all               label "ȫ��"*/

with frame b  side-labels width 80 attr-space.


form                
        v_line                label "��"
        xxexpd_cu_ln          label "��"
        /*xxexpd_cu_part        label "��Ʒ����"*/
        xxexpd_cu_qty         label "����"
        xxexpd_cu_um          label "��λ"
        xxexpd_ctry           label "ԭ����"
        xxexpd_price          label "����"
        xxexpd_amt            label "���"
        xxexpd_stat           label "״̬" 

with frame c three-d overlay 13 down scroll 1 width 80 . 


form
    xxexp_cu_nbr       label "���ر��"    colon 13 xxexp_iss_date     label "��������"    colon 45  
    xxexp_pre_nbr      label "Ԥ¼����"  colon 13 xxexp_req_date     label "�걨����"    colon 45  
    xxexp_bk_nbr       label "�ֲ���"    colon 13 xxexp_crt_date     label "ά������"    colon 45  
    xxexp_dept         label "���ڿڰ�"    colon 13 xxexp_from         label "���˵�"      colon 45  
    xxexp_ship_via     label "���䷽ʽ"    colon 13 xxexp_to           label "Ŀ�ĵ�"      colon 45  
    xxexp_ship_tool    label "���乤��"    colon 13 xxexp_port         label "װ����"      colon 45  
    xxexp_bl_nbr       label "���˵�"      colon 13 xxexp_fob          label "�ɽ���ʽ"    colon 45  
    xxexp_trade_mtd    label "ó�׷�ʽ"    colon 13 xxexp_box_num      label "����"        colon 45  
    xxexp_tax_mtd      label "��������"    colon 13 xxexp_tax_rate     label "��˰����"    colon 45  
    xxexp_box_type     label "��װ����"    colon 13 xxexp_net          label "����"        colon 45  
    xxexp_license      label "���֤��"    colon 13 xxexp_gross        label "ë��"        colon 45  
    xxexp_appr_nbr     label "��׼�ĺ�"    colon 13 xxexp_curr         label "�ұ�"        colon 45  
    xxexp_contract     label "��ͬЭ���"  colon 13 xxexp_amt          label "���"        colon 45 
    xxexp_container    label "��װ���"    colon 13 xxexp_stat         label "״̬"        colon 45 
    xxexp_rmks1        label "��ͷ"        colon 13 xxexp_use          label "��;"        colon 45  
    xxexp_rmks2        label "��ע"        colon 13                                               
with frame d side-labels width 80 attr-space .     


                                                                                 
mainloop:
repeat:

    view frame b  .
    view frame c .
    clear frame b no-pause .
    clear frame c no-pause .
    new_add = no .
    detail_add  = no .

    find first xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr no-error .
    if avail xxexp_mstr then do: 
        disp v_nbr xxexp_bk_nbr with frame b .
    end .

    update v_nbr with frame b editing:
            if frame-field="v_nbr" then do:
                {mfnp01.i xxexp_mstr v_nbr xxexp_nbr v_form_type " xxexp_domain = global_domain and xxexp_type " xxexp_type }
                if recno <> ? then do:
                    disp xxexp_nbr @ v_nbr  with frame b .
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

    find first xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr no-error .
    if avail xxexp_mstr then do:
        if xxexp_type <> v_form_type then do:
            message "����:�Ѵ���,�ҷ�'������ת'���ڱ��ص�,����������" .
            undo,retry .
        end.

        disp v_nbr xxexp_bk_nbr with frame b .
    end .

    loopa :
    do on error undo,retry :
        find first xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr no-error .
        if not avail xxexp_mstr then do:
            message "������¼" .

            find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-error.
            if not avail xxcbkc_ctrl then do:
                create xxcbkc_ctrl . xxcbkc_domain = global_domain .
            end.

            create xxexp_mstr .
            assign 
                xxexp_domain = global_domain 
                xxexp_type    = v_form_type
                xxexp_nbr    = v_nbr 
                xxexp_userid     = global_userid
                xxexp_crt_date   = today
                xxexp_iss_date   = today
                xxexp_req_date   = today
                xxexp_bk_nbr     = ""                
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
                .   

            loopbk:
            do on error undo,retry :
                update xxexp_bk_nbr with frame b editing:
                    if frame-field="xxexp_bk_nbr" then do:
                        {mfnp01.i xxcbk_mstr xxexp_bk_nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr }
                        if recno <> ? then do:
                            xxexp_bk_nbr = xxcbk_bk_nbr .
                            disp 
                                xxexp_bk_nbr  
                            with frame b.
                        end.
                    end.
                    else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                    end.              
                end. /*update xxexp_bk_nbr*/
                assign xxexp_bk_nbr .

                find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = xxexp_bk_nbr no-lock no-error.
                if not avail xxcbk_mstr then do:
                    message "����:��Ч�ֲ��" .
                    undo,retry .
                end.
                else do:
                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            /*and xxcbkd_bk_type  = v_bk_type */
                            and xxcbkd_bk_nbr   = xxexp_bk_nbr
                            and (xxcbkd_stat = ""
                                /*or (xxcbkd_qty_ord + xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) > 0 */ )
                    no-lock no-error .
                    if not avail xxcbkd_det then do:
                        message "����:�ֲ���δ�����" .
                        undo,retry .
                    end.

                end.

            end. /*loopbk:*/
 
        end .        
        else message "�޸ļ�¼" .

        v_recid = recid(xxexp_mstr) .

    end. /*loopa :*/


    find last xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-error.
    if avail xxexpd_det then do:
        v_line = xxexpd_line .
        disp v_line       
            xxexpd_cu_ln     
            xxexpd_cu_qty     
            xxexpd_cu_um      
            xxexpd_ctry       
            xxexpd_price      
            xxexpd_amt          
            xxexpd_stat         
        with frame c.
    end.
    else v_line = 1 .

    loopb:
    repeat on endkey undo, leave:
        disp v_line with frame c .
        update v_line with frame c editing:
            if frame-field="v_line" then do:
                {mfnp01.i xxexpd_det v_line xxexpd_line v_nbr "xxexpd_domain = global_domain and xxexpd_nbr " xxexpd_nbr}
                if recno <> ? then do:
                    v_line = xxexpd_line .
                    disp v_line       
                        xxexpd_cu_ln     
                        xxexpd_cu_qty     
                        xxexpd_cu_um      
                        xxexpd_ctry       
                        xxexpd_price      
                        xxexpd_amt          
                        xxexpd_stat         
                    with frame c.
                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error .
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
            find first xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr and xxexpd_line = v_line  no-error .
            if not avail xxexpd_det  then do:
                clear frame c no-pause .
                disp v_line with frame c .
                message "������¼" .

                create xxexpd_det .
                assign 
                    xxexpd_domain  = global_domain
                    xxexpd_type    = v_form_type
                    xxexpd_nbr     = v_nbr    
                    xxexpd_line    = v_line  
                    detail_add  = yes 
                    .
                if detail_add then new_add = yes .

                loopd:
                do on error undo,retry :
                    update xxexpd_cu_ln with frame c editing:
                        if frame-field="xxexpd_cu_ln" then do:
                            {mfnp01.i xxcpt_mstr xxexpd_cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
                            if recno <> ? then do:
                                xxexpd_cu_ln = xxcpt_ln .
                                disp 
                                    xxexpd_cu_ln 
                                with frame c.
                                message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
                            end.
                        end.
                        else do:
                            status input ststatus.
                            readkey.
                            apply lastkey.
                        end.      
                    end. /*update xxexpd_cu_ln*/
                    assign xxexpd_cu_ln .

                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error .
                    if avail xxcpt_mstr then  message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
                    else do:
                        message "����:��Ч��˾���,����������" .
                        undo,retry.
                    end.

                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            /*and xxcbkd_bk_type  = v_bk_type */
                            and xxcbkd_bk_nbr   = xxexp_bk_nbr
                            and xxcbkd_cu_ln    = xxexpd_cu_ln 
                            and (xxcbkd_stat = ""
                                /*or (xxcbkd_qty_ord + xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) > 0 */ )
                    no-error .
                    if not avail xxcbkd_det then do:
                        message "����:�ֲ��޴���Ʒ��δ�����" .
                        undo,retry .
                    end.
                    else do:
                        xxexpd_cu_ln   = xxcpt_ln .
                        xxexpd_cu_part = xxcpt_cu_part .
                        xxexpd_cu_um   = xxcpt_um.
                        xxexpd_cu_qty  = ( xxcbkd_qty_tsf + xxcbkd_qty_sl + xxcbkd_qty_io  - xxcbkd_qty_rjct ) .
                        xxexpd_ctry    = xxcbkd_ctry  .
                        xxexpd_price   = xxcbkd_price .
                        xxexpd_amt     = xxcbkd_price * xxexpd_cu_qty .
                        
                    end.

                    disp v_line       
                        xxexpd_cu_ln     
                        xxexpd_cu_qty     
                        xxexpd_cu_um      
                        xxexpd_ctry       
                        xxexpd_price      
                        xxexpd_amt          
                        xxexpd_stat         
                    with frame c.

                end. /*loopd*/

                loope :
                do on error undo, retry:
                    update xxexpd_cu_qty with frame c .
                    if xxexpd_cu_qty <= 0 then do:
                        message "����:��������������" .
                        undo,retry .
                    end.
                    /*if xxexpd_cu_qty > ( xxcbkd_qty_tsf + xxcbkd_qty_sl + xxcbkd_qty_io  - xxcbkd_qty_rjct )  then do:
                        message "����:���������ɳ����ֲ�����" .
                        undo,retry .
                    end.*/
                    xxexpd_amt     = xxcbkd_price * xxexpd_cu_qty .

                    find first xxcbkd_det 
                            where xxcbkd_domain = global_domain 
                            and xxcbkd_bk_type  = v_bk_type 
                            and xxcbkd_bk_nbr   = xxexp_bk_nbr
                            and xxcbkd_cu_ln    = xxexpd_cu_ln 
                    no-error .
                    if avail xxcbkd_det then xxcbkd_qty_tsf = xxcbkd_qty_tsf - xxexpd_cu_qty .
                end. /*loope*/

                disp v_line       
                    xxexpd_cu_ln     
                    xxexpd_cu_qty     
                    xxexpd_cu_um      
                    xxexpd_ctry       
                    xxexpd_price      
                    xxexpd_amt          
                    xxexpd_stat         
                with frame c.

            end. /*if not avail xxexpd_det */
            else do : /*if avail xxexpd_det */
                    message "�޸ļ�¼".
                    disp v_line       
                        xxexpd_cu_ln     
                        xxexpd_cu_qty     
                        xxexpd_cu_um      
                        xxexpd_ctry       
                        xxexpd_price      
                        xxexpd_amt          
                        xxexpd_stat         
                    with frame c.
                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error .
                    if avail xxcpt_mstr then  message "��Ʒ����" xxcpt_cu_part "Ʒ��: " xxcpt_desc .
            end. /*if avail xxexpd_det */


            ctryloop:
            do on error undo, retry:
                update xxexpd_ctry go-on(F5 CTRL-D) with frame c.
                
                find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = xxexpd_ctry no-lock no-error .
                if not avail xxctry_mstr then do:
                    message "����:ԭ��������,����������" .
                    undo, retry.
                end.

                if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
                then do:
                    if xxexpd_stat <> "" then do:
                        message "����:�ѽ����,������ɾ��" .
                        undo,retry.
                    end.
                    else do:
                        find first  xxcbkd_det 
                                where xxcbkd_domain = global_domain 
                                and xxcbkd_bk_type  = v_bk_type 
                                and xxcbkd_bk_nbr   = xxexp_bk_nbr
                                and xxcbkd_cu_ln    = xxexpd_cu_ln 
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
                                        and xxcbkd_bk_nbr   = xxexp_bk_nbr
                                        and xxcbkd_cu_ln    = xxexpd_cu_ln 
                                no-error .
                                if avail xxcbkd_det then xxcbkd_qty_tsf = xxcbkd_qty_tsf + xxexpd_cu_qty .

                                delete xxexpd_det .
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
        find first xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-error .
        if avail xxexpd_det then do:
            v_amt = 0 .
            for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-lock :
                v_amt = v_amt + xxexpd_amt . /*Ĭ��curr����USD*/
            end.
            if v_amt <> xxexp_amt then message "�ۼƽ��:" v_amt .
        end.
    end.


    find xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr no-error.
    v_recid = if avail xxexp_mstr then recid(xxexp_mstr) else ? .
hide frame c no-pause .
view frame d .
    do transaction
        on error undo, 
        retry with frame d:       

        find xxexp_mstr where recid(xxexp_mstr) = v_recid no-error .
        if not avail xxexp_mstr then leave .

            disp 
                xxexp_cu_nbr    
                xxexp_pre_nbr 
                xxexp_bk_nbr    
                xxexp_dept      
                xxexp_ship_via  
                xxexp_ship_tool 
                xxexp_bl_nbr    
                xxexp_trade_mtd 
                xxexp_tax_mtd   
                xxexp_tax_rate  
                xxexp_license   
                xxexp_appr_nbr  
                xxexp_contract  
                xxexp_container     
                xxexp_iss_date    
                xxexp_req_date      
                xxexp_crt_date 
                xxexp_from     
                xxexp_to       
                xxexp_port     
                xxexp_fob      
                xxexp_box_num  
                xxexp_box_type 
                xxexp_net      
                xxexp_gross    
                xxexp_curr     
                xxexp_amt      
                xxexp_stat     
                xxexp_use      
                xxexp_rmks1     
                xxexp_rmks2 
            with frame d .

            update 
                xxexp_cu_nbr    
                xxexp_pre_nbr 
                xxexp_dept      
                xxexp_ship_via  
                xxexp_ship_tool 
                xxexp_bl_nbr    
                xxexp_trade_mtd 
                xxexp_tax_mtd   
                xxexp_box_type  
                xxexp_license   
                xxexp_appr_nbr  
                xxexp_contract  
                xxexp_container     
                xxexp_iss_date    
                xxexp_req_date      
                xxexp_from     
                xxexp_to       
                xxexp_port     
                xxexp_fob      
                xxexp_box_num  
                xxexp_tax_rate 
                xxexp_net      
                xxexp_gross    
                xxexp_curr     
                xxexp_amt      
                xxexp_stat     
                xxexp_use      
                xxexp_rmks1     
                xxexp_rmks2 
            go-on("F5" "CTRL-D")
            with frame d .

            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
                if xxexp_stat <> "" then do:
                    message "����:���ص��ѽ�,������ɾ��" .
                    undo,retry.
                end.
                for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
                    if xxexpd_stat <> "" then do:
                        message "����:�ѽ����,������ɾ��" .
                        undo,retry.
                    end.
                    else do:
                        find first  xxcbkd_det 
                                where xxcbkd_domain = global_domain 
                                and xxcbkd_bk_type  = v_bk_type 
                                and xxcbkd_bk_nbr   = xxexp_bk_nbr
                                and xxcbkd_cu_ln    = xxexpd_cu_ln 
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

                    for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
                        if xxexpd_stat <> "" then do:
                            message "����:�ѽ����,������ɾ��" .
                            undo,retry.
                        end.
                        else do:
                            find first  xxcbkd_det 
                                    where xxcbkd_domain = global_domain 
                                    and xxcbkd_bk_type  = v_bk_type 
                                    and xxcbkd_bk_nbr   = xxexp_bk_nbr
                                    and xxcbkd_cu_ln    = xxexpd_cu_ln 
                            no-error .
                            if xxcbkd_stat <> "" then do:
                                message "����:�ֲ�����ѽ�,������ɾ��" .
                                undo,retry.
                            end.
                            else do:
                                    find first xxcbkd_det 
                                            where xxcbkd_domain = global_domain 
                                            and xxcbkd_bk_type  = v_bk_type 
                                            and xxcbkd_bk_nbr   = xxexp_bk_nbr
                                            and xxcbkd_cu_ln    = xxexpd_cu_ln 
                                    no-error .
                                    if avail xxcbkd_det then xxcbkd_qty_tsf = xxcbkd_qty_tsf + xxexpd_cu_qty .

                                    delete xxexpd_det .
                            end.
                        end.                        
                    end. /*delete*/
                    delete xxexp_mstr.

                    clear frame d.
                    next.
                end.
            end.

            if xxexp_iss_date = ? or xxexp_req_date = ? then do:
                message "����:��Ч����,����������" .
                next-prompt xxexp_iss_date .
                undo,retry .
            end.
            if xxexp_amt <= 0 then do:
                message "����:��Ч���,����������" .
                next-prompt xxexp_amt .
                undo,retry .
            end.
    end. /*do  transaction */ 


    hide frame d no-pause .
    hide frame b no-pause .
    
    release xxexpd_det no-error.
    release xxexp_mstr no-error .
end. /*mainloop*/

