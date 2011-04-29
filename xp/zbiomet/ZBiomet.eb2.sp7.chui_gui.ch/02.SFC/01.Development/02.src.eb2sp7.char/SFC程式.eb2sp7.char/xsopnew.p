/* xsopnew.p ��������                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*����ǰ��,�������弰��ؼ��*/

/*����Ƿ���ͣ���û�,����,����,*/
/*֮ǰ����v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}

find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_op)
        or
        (xxwrd_wolot < v_wolot)
        )
    and (
        xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
        )
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:���������Ѿ���ʼ����,����:" + xxwrd_wolot + "+"  + string(xxwrd_op) .
    undo,leave .
end. 


find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and xxwrd_wolot   = v_wolot 
    and xxwrd_op      = v_op
    and (
        xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
        )
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:��ǰ�����Ѿ���ʼ����." .
    undo,leave .
end. 

find first xxfb_hist 
    where xxfb_wonbr  = v_wonbr 
    and ((xxfb_wolot    = v_wolot  and xxfb_op       <= v_op)
        or xxfb_wolot   < v_wolot
        )
    and xxfb_date_end = ?
no-lock no-error .
if avail xxfb_hist then do:
    message "ָ���޷�ִ��:��ǰ/���������Ѿ���ʼ����." .
    undo,leave .
end.




{xsfbchk002.i} /*ȡ�����ȵ�Ĭ��ֵ:ǰ����,������,�¹���*/


define var v_add_op as integer  .
define var v_add_wc like xwr_wkctr .
define var v_opname like xwr_desc .
define var v_std_setup like xwr_setup .
define var v_std_run   like xwr_run .
define var v_printer   as char . 

define var v_fld_prn as char label "SFC��������Ĭ�ϴ�ӡ��,ͨ�ô�������ֶ���" .   v_fld_prn = v_fldname + "-printer" .


find first xcode_mstr where xcode_fldname = v_fld_prn  and xcode_value = v_user no-lock no-error.
if available xcode_mstr then v_printer = xcode_cmmt .
else do:
    find first xcode_mstr where xcode_fldname = v_fld_prn  and xcode_value = "*" no-lock no-error.
    v_printer = if available xcode_mstr then xcode_cmmt else  "" .
end.

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
    v_add_op      colon 18 label "��������"
    v_add_wc      colon 18 label "��������"
    v_opname      colon 18 label "����˵��"

    v_std_setup   colon 18 label "��׼׼��ʱ��(h)"
    v_std_run     colon 18 label "��׼����ʱ��(h)"
    
    v_printer     colon 18 label  "�����ӡ��"


    skip(3)
with frame a 
title color normal "��������"
side-labels width 80 .   



hide all no-pause .
view frame a .

mainloop:
repeat :
    
    do  on error undo,retry: /*update_loop*/
        clear frame a no-pause .

        v_add_op = v_op .
        v_add_wc = v_wc .
        find first xwc_mstr where xwc_wkctr = v_add_wc no-lock no-error .
        v_opname = if avail xwc_mstr then entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/")  else "" .

        disp v_wolot v_op v_part v_qty_ord2 v_inv_lot v_add_op v_add_wc v_opname with frame a  .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        
        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        no-lock no-error .

        update v_add_op v_add_wc with frame a editing:
                if frame-field = "v_add_wc" then do:
                    {xstimeout02.i " quit "    } 
                    {xsmfnp11.i xwc_mstr xwc_wkctr  xwc_wkctr "input v_add_wc"  }
                    if recno <> ? then do:
                        v_opname = entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") .
                        display xwc_wkctr @ v_add_wc   v_opname   with frame a .
                    end. /* if recno <> ? */
                end. /* if frame-field = "v_add_wc" */   
                else do:
                    status input.
                    readkey.
                    apply lastkey.                
                end. /* else do */
        end. /*update...editing:*/
        assign v_add_op v_add_wc v_opname.

        {xserr001.i "v_add_op" } /*���������λ�Ƿ��������ʺ�*/


        {xsfbchk002.i} /*��ֹ��������Ҳ�ڷ����˹���,��������һ��,�Ա�����������*/

        if v_add_op >= v_op then do:
            message "����:ֻ���������ڵ�ǰ����֮ǰ" .
            undo,retry .
        end.

        find first xxwrd_Det where xxwrd_wolot = v_wolot and xxwrd_op = v_add_op no-lock no-error .
        if avail xxwrd_det then do:
            message "����:�ù����Ѵ���." .
            undo,retry .
        end.

        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wonbr   = v_wonbr 
            and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_add_op)
                or
                (xxwrd_wolot < v_wolot)
                )
            and (
                xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
                )
        no-lock no-error .
        if avail xxwrd_Det then do:
            message "ָ���޷�ִ��:���������Ѿ���ʼ����:����:" + xxwrd_wolot + "+"  + string(xxwrd_op) .
            undo,retry .
        end. 


        
        find first xxfb_hist 
            where xxfb_wonbr  = v_wonbr 
            and ((xxfb_wolot    = v_wolot  and xxfb_op       <= v_op)
                or xxfb_wolot   < v_wolot
                )
            and xxfb_date_end = ?
        no-lock no-error .
        if avail xxfb_hist then do:
            message "ָ���޷�ִ��:��ǰ/���������Ѿ���ʼ����." .
            undo,retry .
        end.

        
        find first xwc_mstr where xwc_wkctr = v_add_wc no-lock no-error .
        if not avail xwc_mstr then do :
            message "��Ч��������,����������." .
            next-prompt v_add_wc.
            undo,retry .
        end.
        v_opname = entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/")  .

        do on error undo,retry :
            update v_opname v_std_setup v_std_run  v_printer  with frame a editing:
                    if frame-field = "v_printer" then do:
                        {xstimeout02.i " quit "    } 
                        {xsmfnp01.i xprd_Det v_printer xprd_dev ""barcode"" xprd_type xprd_dev}
                        if recno <> ? then do:
                            display xprd_dev @ v_printer with frame a.
                        end. /* if recno <> ? */
                    end. /* if frame-field = "v_printer" */ 
                    else do:
                        status input.
                        readkey.
                        apply lastkey.                
                    end. /* else do */
            end . /*update...editing*/
            
            {xserr001.i "v_std_setup" } /*���������λ�Ƿ��������ʺ�*/
            {xserr001.i "v_std_run" }   /*���������λ�Ƿ��������ʺ�*/

            if v_std_setup < 0 or v_std_run < 0 then do:
                message "��׼ʱ�䲻��Ϊ����" .
                undo,retry .
            end.

            find first xprd_det where xprd_dev = trim(v_printer) no-lock no-error.
            if not available xprd_det then do:
                message "��Ч��ӡ��,����������." .
                next-prompt v_printer .
                undo,retry .
            end.

        end.

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
    no-lock no-error .
    if avail xxwrd_Det then do: /*������*/               
            v_qty_ord2    = xxwrd_qty_ord  .
            v_part        = xxwrd_part .
            v_inv_lot     = xxwrd_inv_lot .
            v_lastwo      = xxwrd_lastwo .
            v_lastop      = no .
    end.  /*������*/


    find first xxwrd_Det 
        where xxwrd_wrnbr = integer(v_wrnbr) 
        and xxwrd_wolot   = v_wolot
        and xxwrd_op      = v_add_op 
    no-lock no-error .
    if not avail xxwrd_det then do:
        create  xxwrd_det .
        assign  xxwrd_wonbr    = v_wonbr 
                xxwrd_wolot    = v_wolot
                xxwrd_op       = v_add_op
                xxwrd_part     = v_part 
                xxwrd_wc       = v_add_wc /*Ĭ�ϵĹ�������(����)*/
                xxwrd_opname   = v_opname 
                xxwrd_wrnbr    = integer(v_wrnbr) 
                xxwrd_qty_ord  = v_qty_ord2
                xxwrd_inv_lot  = v_inv_lot /*��С����ID������*/
                xxwrd_qty_bom  = 1   /*Ĭ�ϵ�λ����Ϊ1*/
                xxwrd_status   = "N" /*������-��,����ɾ��-D,�����Ĺ���-N,��ֹ�Ĺ���-J */
                xxwrd_opfinish = no  /*�������*/
                xxwrd_issok    = no  /*�������,��ȫ����ԭ���ϵĹ���ID��ʹ���������*/
                xxwrd_lastwo   = v_lastwo 
                xxwrd_lastop   = v_lastop 
                xxwrd_std_setup = v_std_setup * 3600  /*��׼����ʱ��*/
                xxwrd_std_run   = v_std_run   * 3600  /*��׼����ʱ��*/
                .
    end. /*if not avail xxwrd_det*/

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
            xxfb_qty_fb      = v_qty_now   
            xxfb_rmks        = "��������"   
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user  
            xxfb_op          = v_add_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = v_line  
            xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
            xxfb_update      = no  
            .


    v_msgtxt = v_msgtxt + xxfb_type2 + ":ָ�����" .
    message "�Զ�ת����������." .
    v_op = v_add_op .
    v_sn1 = v_wolot + "+" + string(v_op) .
end.  /*xxfb*/


/*  end ---------------------------------------------------------------------------------------*/  


define var v_print_bc as char format "x(30)" .
if search("xsroutprt.p") <> ? then do:
    assign v_print_bc = search("xsroutprt.p") .
    hide all no-pause .
    run value(v_print_bc) (input v_user , input v_wolot , input v_add_op ,input v_add_wc ,input v_opname ,input v_printer ).
end.
else do:
    message "��ӡ������������ĳ�ʽ������:xsroutprt.p" view-as alert-box title ""  .
    leave .
end.


leave .
end. /*mainloop:*/

hide frame a no-pause .
