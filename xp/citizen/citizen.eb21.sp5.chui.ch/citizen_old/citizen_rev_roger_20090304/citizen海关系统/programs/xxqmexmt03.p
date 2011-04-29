/* xxqmexmt03.p                                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/15   BY: Softspeed RogerXiao         */
/******************************************************************************/

{mfdtitle.i "1.0"}

define var v_form_type as char . v_form_type = "1" .   /*customs declaration form type*/
define var v_bk_type  like xxcbkd_bk_type initial  "OUT" .


define var eff_date as date label "��������" .
define var eff_date1 as date label "��" .
define var nbr  as char format "x(18)" label "�걨����".
define var nbr1 as char format "x(18)" label "��".
define var cu_part  as char format "x(18)" label "��Ʒ���".
define var cu_part1 as char format "x(18)" label "��".
define var cu_ln   like xxcpt_ln format ">>>>>" label "��Ʒ��" .
define var cu_ln1  like xxcpt_ln  format ">>>>>" label "��" .
define var v_bk_nbr like xxcbk_bk_nbr  label "�ֲ��" .

define var v_nbr    like xxexp_nbr label "���ص���" .
define var v_add  as logical  initial yes format "Y-����/N-�޸�" label "����".
define var v_recid like recno .
define var del-yn as logical  initial yes .
define var jj  as integer format ">>9" label "��".
define var v_amt  like xxexp_amt.

define temp-table temp1
    field t1_nbr like xxexpd_nbr 
    field t1_line as integer format ">>9" 
    field t1_pr_nbr like xxexpd_nbr 
    field t1_pr_line as integer format ">>9" 
    field t1_cu_ln like xxcpt_ln
    field t1_cu_part like xxcpt_cu_part
    field t1_desc    like xxcpt_desc
    field t1_qty     like xxeprd_cu_qty
    field t1_um      like xxcpt_um
    field t1_ctry    like xxeprd_ctry
    field t1_price   like xxeprd_price
    field t1_amt     like xxeprd_amt
    field t1_bk_nbr  like xxcbkd_bk_nbr
    field t1_bk_ln   like xxcbkd_bk_ln
    field t1_del     as logical initial no 
    index t1_pr_nbr  t1_pr_nbr t1_pr_line
    index t1_line    t1_del t1_line
    .


define frame a .
define frame b .
define frame c .
define frame d .
 

form
    skip(1)
    v_add       colon 18
    skip(1)
    v_bk_nbr    colon 18
    skip(1)
    eff_Date    colon 18  
    eff_date1   colon 45 
    nbr         colon 18  
    nbr1        colon 45 
    cu_part     colon 18  
    cu_part1    colon 45 
    cu_ln      colon 18  
    cu_ln1     colon 45 


    skip(1)
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form
 space(1)   v_nbr 
with frame b side-labels width 80 attr-space .

form                
        jj            label "��"
        t1_pr_nbr     label "�걨����"
        t1_pr_line    label "��"
        t1_cu_ln      label "��Ʒ��"
        t1_qty        label "����"
        t1_um         label "��λ"
        t1_ctry       label "ԭ����"
        t1_price      label "����"
        t1_amt        label "���"
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


{wbrp01.i}                                                                                   
mainloop:
repeat:
    
    for each temp1: delete temp1. end.
    
    hide all no-pause . {xxtop.i}
    view frame  a  .
    clear frame a no-pause .
    if eff_date = low_date  then eff_date = ? .
    if eff_date1 = hi_date  then eff_date1 = ? .
    if cu_part1 = hi_char   then cu_part1 = "" .
    if cu_ln1 = 99999      then cu_ln1 = 0 .
    if nbr1 = hi_char       then nbr1 = "" .
    update v_add with frame a .
    if v_add then do:
        update v_bk_nbr eff_date eff_date1 nbr nbr1 cu_part cu_part1 cu_ln cu_ln1 with frame a editing:
            if frame-field="cu_part" then do:
                {mfnp01.i xxcpt_mstr cu_part xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
                if recno <> ? then do:
                    disp xxcpt_cu_part @ cu_part  
                    with frame a.
                end.
            end.
            else if frame-field="cu_part1" then do:
                {mfnp01.i xxcpt_mstr cu_part1 xxcpt_cu_part global_domain xxcpt_domain xxcpt_cu_part}
                if recno <> ? then do:
                    disp xxcpt_cu_part @ cu_part1  
                    with frame a.
                end.
            end.
            else if frame-field="cu_ln" then do:
                {mfnp01.i xxcpt_mstr cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
                if recno <> ? then do:
                    disp xxcpt_ln @ cu_ln  
                    with frame a.
                end.
            end.
            else if frame-field="cu_ln1" then do:
                {mfnp01.i xxcpt_mstr cu_ln1 xxcpt_ln global_domain xxcpt_domain xxcpt_ln}
                if recno <> ? then do:
                    disp xxcpt_ln @ cu_ln1  
                    with frame a.
                end.
            end.
            else do:
                status input ststatus.
                readkey.
                apply lastkey.
            end.
        end. /*update v_part*/
        assign v_bk_nbr eff_date eff_date1 nbr nbr1 cu_part cu_part1 cu_ln cu_ln1 .

        find first xxcbkd_det 
            where xxcbkd_domain = global_domain 
            and xxcbkd_bk_type = v_bk_type
            and xxcbkd_bk_nbr = v_bk_nbr 
        no-lock no-error .
        if not avail xxcbkd_det then do:
            message "����:�ֲ�Ų�����" view-as alert-box.
            undo,retry .
        end.


        if cu_ln1 = 0    then cu_ln1 = 99999 .
        if cu_part1 = ""  then cu_part1 = hi_char .
        if eff_date = ?   then eff_date = low_date .
        if eff_date1 = ?  then eff_date1 = hi_date .
        if nbr1 = ""      then nbr1 = hi_char .



        printloop:
        do on error undo, retry:

            {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}

            {mfphead.i}
            jj = 0 .
            for each xxepr_mstr 
                    where xxepr_domain = global_domain 
                    and xxepr_nbr >= nbr and xxepr_nbr <= nbr1
                    and xxepr_bk_nbr  = v_bk_nbr 
                    and xxepr_date >= eff_date and xxepr_date <= eff_date1
                    and xxepr_stat = "" no-lock ,
                each xxeprd_det 
                    where xxeprd_domain = global_domain 
                    and xxeprd_nbr = xxepr_nbr
                    and xxeprd_cu_part >= cu_part  and xxeprd_cu_part <= cu_part1 
                    and xxeprd_cu_ln  >= cu_ln   and xxeprd_cu_ln <= cu_ln1
                    and xxeprd_stat = "" 
                no-lock break by xxeprd_nbr by xxeprd_line :

                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxeprd_cu_ln no-lock no-error.
                find first xxcbkd_det 
                    where xxcbkd_domain = global_domain 
                    and xxcbkd_bk_type     = v_bk_type 
                    and xxcbkd_bk_nbr   = v_bk_nbr
                    and xxcbkd_cu_ln    = xxeprd_cu_ln
                no-lock no-error .
                


                find first temp1 
                    where t1_pr_nbr = xxeprd_nbr
                    and t1_pr_line  = xxeprd_line
                    and t1_cu_ln = xxeprd_cu_ln 
                no-error .
                if not avail temp1 then do:
                    jj = jj + 1 .
                    create temp1 .
                    assign 
                        t1_nbr   = ""
                        t1_line  = jj
                        t1_pr_nbr   = xxeprd_nbr
                        t1_pr_line  = xxeprd_line
                        t1_cu_ln    = xxeprd_cu_ln 
                        t1_cu_part = xxeprd_cu_part 
                        t1_desc    = if avail xxcpt_mstr then xxcpt_desc else ""
                        t1_qty     = xxeprd_cu_qty
                        t1_um      = xxeprd_cu_um 
                        t1_ctry    = xxeprd_ctry
                        t1_price   = xxeprd_price
                        t1_amt     = xxeprd_amt 
                        t1_bk_nbr  = v_bk_nbr 
                        t1_bk_ln   = if avail xxcbkd_det then xxcbkd_bk_ln else 0 .
                end.

            end. /*for each xxepr_mstr*/

            for each temp1 
                break by t1_nbr by t1_line by t1_cu_ln 
                with frame x width 300 :
                    disp
                        t1_nbr     label "���ص���"
                        t1_line    label "��" 
                        t1_pr_nbr  label "�걨����"
                        t1_pr_line label "��"
                        t1_cu_ln   label "��˾��"
                        t1_cu_part label "��Ʒ����"
                        t1_desc    label "��ƷƷ��"
                        t1_qty     label "����"
                        t1_um      label "��λ"
                        t1_ctry    label "ԭ����"
                        t1_price   label "����"
                        t1_amt     label "���"
                        t1_bk_nbr  label "�ֲ��"
                        t1_bk_ln   label "�ֲ���"
                    with frame x.
            end. /*for each temp1*/

            {mfreset.i}  /*{mfrtrail.i}   REPORT TRAILER  */
            {wbrp04.i &frame-spec = a}
        end. /*printloop:*/
    end. /*if v_add*/

hide all no-pause .    {xxtop.i}
v_nbr = "" .

chooseloop:
do on error undo,retry :

    view frame b .
    view frame c .
    clear frame b no-pause .
    clear frame c no-pause .

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
    if v_add then do:
        if not avail xxexp_mstr then do:
            message "������¼." .

            for each temp1 :
                t1_nbr = v_nbr .
            end.
        end.
        else do:
            message "����:�����Ѵ���,����������." .
            undo,retry .
        end.
    end. /*if v_add*/
    else do:
        if not avail xxexp_mstr then do:
            message "����:���ص��Ų�����,����������" .
            undo,retry .
        end.
        else if xxexp_type <> v_form_type then do:
            message "����:�Ѵ���,�ҷ�'�����±�'���ڱ��ص�,����������" .
            undo,retry .
        end.
        else do:
            message "�޸ļ�¼" .
            disp xxexp_nbr @ v_nbr with frame b .
            for each temp1 : delete temp1 . end .
            
            for each xxexpd_det where xxexpd_nbr = xxexp_nbr no-lock :
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxexpd_cu_ln no-lock no-error.
                find first xxcbkd_det 
                    where xxcbkd_domain = global_domain 
                    and xxcbkd_bk_type  = v_bk_type 
                    and xxcbkd_bk_nbr   = xxexp_bk_nbr
                    and xxcbkd_cu_ln    = xxexpd_cu_ln
                no-lock no-error .
                


                find first temp1 
                    where t1_nbr = xxexpd_nbr
                    and t1_line  = xxexpd_line
                no-error .
                if not avail temp1 then do:
                    create temp1 .
                    assign 
                        t1_nbr   = xxexpd_nbr
                        t1_line  = xxexpd_line
                        t1_pr_nbr  = xxexpd_pr_nbr
                        t1_pr_line = xxexpd_pr_line
                        t1_cu_ln   = xxexpd_cu_ln 
                        t1_cu_part = xxexpd_cu_part 
                        t1_desc    = if avail xxcpt_mstr then xxcpt_desc else ""
                        t1_qty     = xxexpd_cu_qty
                        t1_um      = xxexpd_cu_um 
                        t1_ctry    = xxexpd_ctry
                        t1_price   = xxexpd_price
                        t1_amt     = xxexpd_amt 
                        t1_bk_nbr  = xxexp_bk_nbr 
                        t1_bk_ln   = if avail xxcbkd_det then xxcbkd_bk_ln else 0 .
                end.
            end.

            find first temp1 no-error .
            if not avail temp1 then message "����:����ϸ��¼".

        end. /*�޸ļ�¼*/
    end. /*if not v_add*/

    find last temp1 no-error .
    if avail temp1 then do:
        jj = t1_line .
        disp jj 
            t1_pr_nbr    
            t1_pr_line  
            t1_cu_ln
            t1_qty    
            t1_um     
            t1_ctry   
            t1_price  
            t1_amt    
        with frame c.
    end.
    else jj = 1 .
    setloop:
    repeat on endkey undo, leave:
        disp jj with frame c .
        update jj with frame c editing:
            if frame-field="jj" then do:
                {mfnp01.i temp1 jj t1_line no t1_del t1_line}
                if recno <> ? then do:
                    disp 
                        t1_line @ jj 
                        t1_pr_nbr    
                        t1_pr_line  
                        t1_cu_ln
                        t1_qty    
                        t1_um     
                        t1_ctry   
                        t1_price  
                        t1_amt    
                    with frame c.
                    message "��Ʒ����" t1_cu_part "Ʒ��: " t1_desc .
                end.
            end.
            else do:
                status input ststatus.
                readkey.
                apply lastkey.
            end.                
        end. /*update jj*/
        assign  jj . 


        find first temp1 where t1_line = jj  no-error .
        if not avail temp1  then do:
            message "����:��β�����,����������" .
            undo,retry.
        end. 

        disp 
            t1_line @ jj 
            t1_pr_nbr    
            t1_pr_line  
            t1_cu_ln
            t1_qty    
            t1_um     
            t1_ctry   
            t1_price  
            t1_amt    
        with frame c.
        message "��Ʒ����" t1_cu_part "Ʒ��: " t1_desc .

        ctryloop:
        do on error undo, retry:
            update t1_ctry go-on(F5 CTRL-D) with frame c.
            
            find first xxctry_mstr where xxctry_domain = global_domain and xxctry_code = t1_ctry no-lock no-error .
            if not avail xxctry_mstr then do:
                message "����:ԭ��������,����������" .
                undo, retry.
            end.

            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn then do:
                    t1_del = yes .
                    clear frame c.
                    del-yn = no.
                    next.
               end.
            end.                   

        end. /*ctryloop*/
    end. /*setloop:*/

    if v_add then do:
        for each temp1 where t1_del = no  :
            find first xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = t1_nbr and xxexpd_line = t1_line no-error.
            if not avail xxexpd_det then do:
                    create xxexpd_det .
                    assign 
                        xxexpd_domain  = global_domain
                        xxexpd_type    = v_form_type
                        xxexpd_nbr     = t1_nbr    
                        xxexpd_line    = t1_line   
                        xxexpd_pr_nbr  = t1_pr_nbr 
                        xxexpd_pr_line = t1_pr_line
                        xxexpd_cu_ln   = t1_cu_ln  
                        xxexpd_cu_part = t1_cu_part
                        xxexpd_cu_qty  = t1_qty    
                        xxexpd_cu_um   = t1_um     
                        xxexpd_ctry    = t1_ctry   
                        xxexpd_price   = t1_price  
                        xxexpd_amt     = t1_amt    
                        .
                    find first xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = t1_pr_nbr and xxeprd_line = t1_pr_line no-error.
                    if avail xxeprd_det then xxeprd_stat = "C" .

                    find first xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = t1_pr_nbr and xxeprd_stat = ""  no-error.
                    if not avail xxeprd_det then do:
                        find first xxepr_mstr where xxepr_domain = global_domain and xxepr_nbr = t1_pr_nbr  no-error.
                        if avail xxepr_mstr then xxepr_stat = "C" .
                    end.
            end.
        end.  /*for each temp1*/

        find first xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-error .
        if avail xxexpd_det then do:
            v_amt = 0 .
            for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = v_nbr no-lock :
                v_amt = v_amt + xxexpd_amt . /*Ĭ��curr����USD*/
            end.
            find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-error.
            if not avail xxcbkc_ctrl then do:
                create xxcbkc_ctrl . xxcbkc_domain = global_domain .
            end.

            create xxexp_mstr .
            assign 
                xxexp_domain     = global_domain 
                xxexp_type       = v_form_type
                xxexp_nbr        = v_nbr 
                xxexp_userid     = global_userid
                xxexp_crt_date   = today
                xxexp_iss_date   = today
                xxexp_req_date   = today
                xxexp_bk_nbr     = v_bk_nbr
                xxexp_curr       = "USD"
                xxexp_amt        = v_amt
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
                .   

 
        end.
    end. /*if v_add then*/
    else do: /*if not v_add */
        for each temp1 :            
            find first xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = t1_nbr and xxexpd_line = t1_line no-error.
            if avail xxexpd_det then do:
                if  t1_del = yes then do: 
                    find first xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = t1_pr_nbr and xxeprd_line = t1_pr_line no-error.
                    if avail xxeprd_det then xxeprd_stat = "" .
                    find first xxepr_mstr where xxepr_domain = global_domain and xxepr_nbr = t1_pr_nbr  no-error.
                    if avail xxepr_mstr then xxepr_stat = "" .
                    delete xxexpd_det .
                end. 
                else xxexpd_ctry = t1_ctry .
            end.
        end.  /*for each temp1*/
    end.  /*if not v_add */


end. /*chooseloop:*/
    find xxexp_mstr where xxexp_domain = global_domain and xxexp_nbr = v_nbr no-error.
    v_recid = if avail xxexp_mstr then recid(xxexp_mstr) else ? .


    do transaction
        on error undo, 
        retry with frame d:
        view frame d .

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
                {mfmsg01.i 11 1 del-yn}

                if not del-yn then undo, retry.

                if del-yn then do:
                    for each xxexpd_det where xxexpd_domain = global_domain and xxexpd_nbr = xxexp_nbr :
                        find first xxeprd_det where xxeprd_domain = global_domain and xxeprd_nbr = xxexpd_pr_nbr and xxeprd_line = xxexpd_pr_line no-error.
                        if avail xxeprd_det then xxeprd_stat = "" .
                        find first xxepr_mstr where xxepr_domain = global_domain and xxepr_nbr = xxexpd_pr_nbr  no-error.
                        if avail xxepr_mstr then xxepr_stat = "" .
                        delete xxexpd_det .                           
                    end.
                    delete xxexp_mstr.

                    clear frame d.
                    leave.
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
    
    release xxexpd_det no-error.
    release xxexp_mstr no-error .
end. /*mainloop*/

