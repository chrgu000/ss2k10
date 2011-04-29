/* xschgplace.p  λ��ת��                                                  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
/*  
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*����ڼ���*/
           */


define var v_fld_locto as char label "ת��λ��,ͨ�ô�������ֶ���" .   v_fld_locto = v_fldname + "-loc-to" .


define var v_prev_wonbr like xwo_nbr .
define var v_prev_wolot like xwo_lot .
define var v_prev_op    as integer  .
define var v_prev_sn    as char format "x(11)" label "ID+OP����".
define var v_txt1 as char format "x(12)" .
define var v_txt2 as char format "x(12)" .
define var v_qty_now like xwo_qty_ord .
form
    skip(1)
    v_prev_sn    colon 20  label "ת�Թ�����������"
    v_prev_wolot colon 20  label "ת�Թ���"
    v_prev_op    colon 20  label "ת�Թ���"
    v_qty_now    colon 20  label "ת������"
    v_txt1       colon 20  label "ת��λ��"
    v_txt2       no-label
    skip(1)
with frame a 
title color normal "λ��ת��"
side-labels width 50 
row 8 centered overlay .   


v_prev_sn    = "" .
v_prev_op    = 0  .
v_prev_wolot = "" .
v_prev_wonbr = "" .
v_txt1 = "" .
v_txt2 = "" .
view frame a .

mainloop:
repeat :
    
    do  on error undo,retry: /*update_loop*/
        message "ָ��:λ��ת��,��ˢ��ת����������." .
        
        snloop:
        do on error undo,retry:
            clear frame a no-pause .
            disp v_prev_sn   
                 v_prev_wolot
                 v_prev_op   
                 v_qty_now   
                 v_txt1    
                 v_txt2
            with frame a  .

            update v_prev_sn with frame a  .
            if v_prev_sn = v_sn1 then do:
                message "ת��������ת�빤����ͬ".
                undo,retry.
            end.
            if v_prev_sn <> "" then do:
                if index(v_prev_sn, "+") = 0 then do:
                    message "�ӹ��������ʽ����,������ˢ��" .
                    undo,retry .
                end.
                v_prev_op    = integer(entry(2,trim(v_prev_sn),"+")) .
                v_prev_wolot = entry(1,trim(v_prev_sn),"+") .
                find first xwo_mstr where xwo_lot = v_prev_wolot no-lock no-error .
                if not avail xwo_mstr then do:
                    message "��Ч�ӹ���:" v_prev_wolot " ������ˢ������" .
                    undo,retry .
                end.
                else do:
                    /*if xwo_status <> "R" then do:
                        message "�ӹ���״̬:" xwo_status " ������ˢ������" .
                        undo,retry .
                    end.  *//*xp-wo-stat*/
                    v_prev_wonbr = xwo_nbr .
                end.
            end.
            else do:
                v_prev_op    = 0  .
                v_prev_wolot = "" .
                v_prev_wonbr = "" .
            end.

            find first xxwrd_det 
                where xxwrd_wolot   = v_prev_wolot 
                and xxwrd_op      = v_prev_op 
                and xxwrd_close   = no
            no-lock no-error .
            if not avail xxwrd_det then do:
                message "ת�������SFC������������,�����ڻ��Ѹ���" .
                undo,retry .
            end.
            else do:
                if xxwrd_qty_comp = 0 then do:
                    message "ת������ĺϸ�Ʒ�������Ϊ��" .
                    undo,retry .
                end.
            end.

            disp v_prev_sn   
                 v_prev_wolot
                 v_prev_op   
                 v_qty_now   
                 v_txt1       
            with frame a  .

            
            qtyloop:
            do on error undo,retry:
                v_qty_now = xxwrd_qty_comp.
                v_txt1    = "".
                
                update v_qty_now v_txt1 with frame a .

                {xserr001.i "v_qty_now" } /*���������λ�Ƿ��������ʺ�*/

                if v_qty_now > xxwrd_qty_comp then do:
                    message "���ɳ���ת������ϸ�Ʒ�������:" xxwrd_qty_comp .
                    undo,retry .
                end.

                if v_qty_now <= 0  then do:
                    message "ת��������������" .
                    undo,retry .
                end.

                find first xcode_mstr where xcode_fldname = v_fld_locto no-lock no-error.
                if avail xcode_mstr then do:
                    find first xcode_mstr where xcode_fldname = v_fld_locto and xcode_value = v_txt1 no-lock no-error.
                    if not avail xcode_mstr then do:
                        message "��Чת��λ��,����������." .
                        next-prompt v_txt1.
                        undo,retry.
                    end.
                    v_txt2 = if avail xcode_mstr then xcode_cmmt else v_txt1 .
                end.

            end. /*qtyloop*/
        end. /*snloop*/

    end. /*update_loop*/
    


    /*  start ---------------------------------------------------------------------------------------*/  

    v_date   = today .
    v_time   = time - (time mod 60) . /*��֤ʱ���һ��*/
    v_msgtxt = "" .   /*��ʾ��Ϣ*/


    /*����:����ָ�������ʷ��¼*/
    do  :  /*xxfb*/


        find first xwo_mstr where xwo_lot = v_prev_wolot no-lock no-error.
        find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

        v_trnbr = 0 .
        v_nbrtype =  "bctrnbr" . /*xxfb_hist,������ˮ��*/
        run getnbr(input v_nbrtype ,output v_trnbr) .

        create  xxfb_hist .
        assign  xxfb_trnbr       = integer(v_trnbr) 
                xxfb_date        = today  
                xxfb_date_end    = v_date  
                xxfb_date_start  = v_date  
                xxfb_time        = time - (time mod 60) 
                xxfb_time_end    = v_time  
                xxfb_time_start  = v_time   
                xxfb_nbr         = ""  
                xxfb_program     = execname
                xxfb_wotype      = ""
                xxfb_qty_fb      = v_qty_now   
                xxfb_rmks        = v_txt2  
                xxfb_rsn_code    = ""  
                xxfb_user        = v_user  
                xxfb_op          = v_prev_op  
                xxfb_wc          = v_wc  
                xxfb_wolot       = v_prev_wolot  
                xxfb_wonbr       = v_prev_wonbr 
                xxfb_part        = if avail xwo_mstr then xwo_part else ""   
                xxfb_type        = v_line  
                xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
                xxfb_update      = no  
                .
        v_msgtxt = v_msgtxt + xxfb_type2 + ":ָ�����" .
    end.  /*xxfb*/

    /*  end ---------------------------------------------------------------------------------------*/  


leave .
end. /*mainloop:*/
hide frame a no-pause .
