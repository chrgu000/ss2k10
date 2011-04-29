/* xsopcancel01.p ɾ������ ��/�������򲻿��ѿ�ʼ����:δ���ܵķ�������ʱ��,����δ��ָ��  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*����ǰ��,�������弰��ؼ��*/

/*����Ƿ���ͣ���û�,����,����,*/
/*֮ǰ����v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}


/*�������򲻿��ѿ�ʼʱ�����������*/
find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_op)
        or
        (xxwrd_wolot < v_wolot)
        )
    and (
        xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0
        or xxwrd_time_setup <> 0  or xxwrd_time_run <> 0 
        )
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:���������Ѿ���ʼ����." .
    undo,leave .
end. 



/*�������򲻿���δ��ָ��*/
find first xxfb_hist 
    where xxfb_wonbr  = v_wonbr 
    and ((xxfb_wolot    = v_wolot  and xxfb_op       > v_op)
        or xxfb_wolot   < v_wolot
        )
    and xxfb_date_end = ?
no-lock no-error .
if avail xxfb_hist then do:
    message "ָ���޷�ִ��:���������Ѿ���ʼ����," .
    undo,leave .
end.


/*��ǰ���򲻿��ѿ�ʼʱ�����������*/
find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and xxwrd_wolot   = v_wolot 
    and xxwrd_op      = v_op
    and (
        xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
        or xxwrd_time_setup <> 0  or xxwrd_time_run <> 0 
        )
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:��ǰ�����Ѿ���ʼ����." .
    undo,leave .
end. 


/*��ǰ���򲻿���δ��ָ��*/
find first xxfb_hist 
    where xxfb_wonbr  = v_wonbr 
    and (xxfb_wolot    = v_wolot  and xxfb_op       = v_op)
    and xxfb_date_end = ?
no-lock no-error .
if avail xxfb_hist then do:
    message "ָ���޷�ִ��:��ǰ�����Ѿ���ʼ����," .
    undo,leave .
end.

find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op )
        or xxwrd_wolot   < v_wolot)
    and xxwrd_close   = yes
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:��ǰ/���������Ѿ���������" .
    undo,leave .
end. 

{xsfbchk002.i} /*ȡ�����ȵ�Ĭ��ֵ:ǰ����,������,�¹���*/


define var v_del_op as logical format "Y/N" .

v_del_op = no .


form
    skip(1)
    v_wolot       colon 18 label "������־"
    v_op          colon 45 label "����" 
    v_part        colon 18 label "���Ʒ"  
    xpt_desc1      colon 45 label "Ʒ��"
    xpt_um         colon 18 label "��λ"
    xpt_desc2      colon 45 label "���"
    skip(1)
    v_qty_ord2    colon 18 label "������"
    v_inv_lot     colon 45 label "����"
    skip(3)
    v_del_op      colon 12 label "ȡ������"
    skip(5)
with frame a 
title color normal "ȡ������(�޷�����¼)"
side-labels width 80 .   



hide all no-pause .
view frame a .

mainloop:
repeat :
    
    do  on error undo,retry: /*update_loop*/
        clear frame a no-pause .

        disp v_wolot v_op v_part v_qty_ord2 v_inv_lot with frame a  .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        
        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        exclusive-lock no-wait no-error .
        if not avail xxwrd_det then do:
            if locked xxwrd_det then do:
                message  "�����������ڱ�ʹ��,��������˳�" view-as alert-box title "" .
                undo,leave mainloop.
            end.
        end.

        update v_del_op with frame a  .
        {xsfbchk002.i} /*��ֹ��������Ҳ�ڷ����˹���,��������һ��,�Ա�����������*/
        
        if v_del_op = no then do:
            message "��ǰѡ��:��ȡ��������," skip 
                    "��������˳�." 
            view-as alert-box title "".
            undo mainloop,leave mainloop  .
        end. /*if v_del_op = no */

        if v_del_op = yes then do:
            if v_lastwo and v_lastop then do:
                message "�׹���,������ɾ��!" .
                undo,retry .
            end.

            find first xxwrd_det 
                where xxwrd_wrnbr = integer(v_wrnbr)
                and xxwrd_wonbr   = v_wonbr 
                and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op)
                    or
                    (xxwrd_wolot < v_wolot)
                    )
                and (
                    xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
                    or xxwrd_time_setup <> 0  or xxwrd_time_run <> 0 
                    )
            no-lock no-error .
            if avail xxwrd_Det then do:
                message "ָ���޷�ִ��:��������򱾹����Ѿ���ʼ����:����:" + xxwrd_wolot + "+"  + string(xxwrd_op) .
                undo,retry .
            end. 
            
            find first xxfb_hist 
                where xxfb_wonbr  = v_wonbr 
                and ((xxfb_wolot    = v_wolot  and xxfb_op       >= v_op)
                    or xxfb_wolot   < v_wolot
                    )
                and xxfb_date_end = ?
            no-lock no-error .
            if avail xxfb_hist then do:
                message "ָ���޷�ִ��:��ǰ/���������Ѿ���ʼ����." .
                undo,retry .
            end.

            find first xxwrd_det 
                where xxwrd_wrnbr = integer(v_wrnbr)
                and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op )
                    or xxwrd_wolot   < v_wolot)
                and xxwrd_close   = yes
            no-lock no-error .
            if avail xxwrd_Det then do:
                message "ָ���޷�ִ��:��ǰ/���������Ѿ���������" .
                undo,retry .
            end. 


        end. /*if v_del_op = yes*/


    end. /*update_loop*/
    
/*  start ---------------------------------------------------------------------------------------*/  

v_date   = today.
v_time   = time - (time mod 60) . /*��֤ʱ���һ��*/
v_msgtxt = "" .   /*��ʾ��Ϣ*/


/*����:����ָ��*/
do  :  /*xxfb*/

    find first xxwrd_det 
        where xxwrd_wrnbr = integer(v_wrnbr)
        and xxwrd_wolot   = v_wolot 
        and xxwrd_op      = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close   = no
        and (
            xxwrd_qty_comp = 0 and xxwrd_qty_rework = 0 and xxwrd_qty_rejct = 0 
            )
    no-error .
    if avail xxwrd_Det then do: /*������*/               
            assign xxwrd_status = "D" .

            /*������ID�ж๤��,��ɾ���������һ������,��ѱ�������ǰ����ĳ�lastop = yes */
            if xxwrd_lastop = yes and v_wolot = v_prev_wolot then do:   /*ǰ����*/
                find first xxwrd_det 
                    where xxwrd_wrnbr = integer(v_wrnbr)
                    and xxwrd_wolot   = v_prev_wolot 
                    and xxwrd_op      = v_prev_op 
                    and (xxwrd_status = "" or xxwrd_status  = "N" )
                    and xxwrd_close   = no
                no-error .
                if avail xxwrd_Det then do:
                    assign xxwrd_lastop = yes .
                end. 
            end.  /*ǰ����*/
    end.  /*������*/

    /*֮ǰ��ָ��,����δ��ָ��,��ִ�б��γ�ʽ,ò����θ���������ִ��? */
    for each xxfb_hist where xxfb_wolot = v_wolot and xxfb_op = v_op and xxfb_date_end = ? :
            assign  xxfb_date_end    = v_date
                    xxfb_time_end    = v_time .
            message   "�û�/����:"  xxfb_user  "/"  xxfb_wc skip
                      "����/����:  "  xxfb_wolot "/"  xxfb_op skip
                      "ָ�����:"   xxfb_type2  "       "
            view-as alert-box title "".
    end. /*for each xxfb_hist*/



    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
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
            xxfb_wotype      = if v_yn3 then "R" else ""   
            xxfb_qty_fb      = 0   
            xxfb_rmks        = "ȡ������"   
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user  
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = v_line  
            xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
            xxfb_update      = no  
            .

    v_msgtxt = v_msgtxt + xxfb_type2 + ":ָ�����" .
    if v_next_wolot <> "" then do:
        message "�Զ�ת����һ����." .
        v_wolot = v_next_wolot .
        v_op    = v_next_op .
        v_sn1 = v_wolot + "+" + string(v_op) .
    end.
end.  /*xxfb*/


/*  end ---------------------------------------------------------------------------------------*/  




leave .
end. /*mainloop:*/

hide frame a no-pause .
