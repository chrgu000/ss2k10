/* xsfbchk001.i ����ǰ��,�������弰��ؼ��                                */
/* REVISION: 1.0         Last Modified: 2008/12/11   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*************
1.called by �ϸ�,����,����,׼��ʱ��,����ʱ��
2.to define vars needed 
3.to check �Ƿ�����ִ�з���
4.���ü�鲻�豸ע,��������� if v_line = v_line_prev[xx] then do:  end. ������
************/ 


/*  
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*����ڼ���*/
*/


define var v_ii         as integer .
define var v_prev       as logical . /*�Ƿ���ǰ����*/
define var v_prev_wolot as char   format "x(18)".
define var v_prev_op    as integer .
define var v_prev_part  as char  format "x(18)".
define var v_qty_prev   as decimal  .

define var v_next       as logical . /*�Ƿ��к���*/
define var v_next_wolot as char   format "x(18)".
define var v_next_op    as integer .
define var v_next_part  as char  format "x(18)" .
define var v_qty_next   as decimal  .
define var v_next_bom   as decimal  .

define var v_lastwo   as logical  format "x(18)".
define var v_lastop   as logical .

define var v_part     as char format "x(18)".
define var v_inv_lot  as char  .
define var v_qty_ord2 as decimal  .
define var v_qty_comp as decimal  .
define var v_qty_rjct as decimal  .
define var v_qty_now  as decimal .
define var v_qty_bom  as decimal  .
define var v_qty_rework  as decimal  .
define var v_qty_return  as decimal .
define var v_qty_check   as decimal .

define var rwkreason     as char .
define var rejreason     as char .

define var v_yn1 as logical format "Y/N". /*�Ƿ������?*/
define var v_yn2 as logical format "Y/N". /*�Ƿ�������?*/
define var v_yn3 as logical format "Y/N". /*�Ƿ񷵹����ϸ�?*/
define var v_yn4 as logical format "Y/N". /*�Ƿ������?*/
define var v_sub as logical format "Y/N". /*�Ƿ���Э�ӹ���?*/
define var v_sub_nbr   as char format "x(12)" . /*��Э�ӹ������ͼ쵥��*/
define var v_sub_ponbr as char format "x(8)" . /*��Э�ӹ�����PO��*/


define var v_tol_pct like xxfb_qty_fb . v_tol_pct = 100 .
define var v_fld_std as char label "�����깤�޶�ٷֱ�" . v_fld_std = v_fldname + "-tol-pct" .

find first xcode_mstr where xcode_fldname = v_fld_std and xcode_value = "*" no-lock no-error.
if not avail xcode_mstr then do:
    v_tol_pct = 100 .
end.
else do:
    v_tol_pct = 100 + decimal(xcode_cmmt) .
end.



/*����Ƿ������Ļ���v_tail_wc*/
{xstimetail01.i}



v_qty_bom    = 1 . /*Ĭ��ֵ:��biomet����1*/
v_wrnbr      = 0 . /*shared var*/

v_lastwo     = no .
v_lastop     = no .

rejreason    = "" . 
rwkreason    = "" . 

v_part       = "" .
v_inv_lot    = "" .
v_qty_ord2   = 0 .
v_qty_comp   = 0 .
v_qty_rjct   = 0 .
v_qty_rework = 0 .
v_qty_return = 0 .
v_qty_now    = 0 .
v_qty_check  = 0 .

v_prev_part  = "" .
v_prev_wolot = "" .
v_prev_op    = 0 .
v_qty_prev   = 0 .
v_prev       = no .

v_next_part  = "" .
v_next_wolot = "" .
v_next_op    = 0 .
v_qty_next   = 0 .
v_next       = no .
v_next_bom   = 1 .  /*Ĭ��ֵ:��biomet����1*/



/* var defines end ---------------------------------------------------------------------------------------*/  


/*���:����״̬*/
if v_wolot = "" then do:
    message "ָ���޷�ִ��:��ǰ����Ϊ��."  view-as alert-box title ""  .
    undo,leave .
end.
find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
if not avail xwo_mstr then do:
    message "ָ���޷�ִ��:��ǰ����������"  view-as alert-box title ""  .
    undo,leave .
end.
else do:
    /*if index("R",xwo_status ) = 0 then do:
        message "ָ���޷�ִ��:��ǰ����״̬����" xwo_status  view-as alert-box title ""  .
        undo,leave .
    end.  *//*xp-wo-stat*/
end. /*else do:*/






/*���������״�ˢ��,���¹������̼�¼*/
{xswofirsttime.i}



/*���:�������������Ƿ����,��״̬*/
find first xxwrd_det where xxwrd_wonbr = v_wonbr no-lock no-error .
if not avail xxwrd_det then do:
    message "ָ���޷�ִ��:SFC�����������̲�����,"  view-as alert-box title "" .
    undo,leave .
end. /*if not avail xxwrd_det*/
find first xxwrd_det 
    where xxwrd_wolot = v_wolot 
    and xxwrd_op    = v_op 
no-lock no-error .
if not avail xxwrd_Det then do:
    message "ָ���޷�ִ��:SFC�����������̲�����."  view-as alert-box title "" .
    undo,leave .
end.
else do: 
    v_wrnbr    = xxwrd_Wrnbr .   
    v_part     = xxwrd_part .
    v_wonbr    = xxwrd_wonbr .
    if (xxwrd_status  <> "" and xxwrd_status <> "N") or xxwrd_close = yes then do:
        message "ָ���޷�ִ��:SFC�������������ѽ����ɾ��."  view-as alert-box title "" .
        undo,leave .
    end .
end. 


/*���:���湤������Ѹ���,�Ͳ������ٷ���*/
find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_op)
        or
        (xxwrd_wolot < v_wolot)
        )
    and xxwrd_close   = yes
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:���������Ѹ���"  view-as alert-box title "" .
    undo,leave .
end. 



/*���:�Ƿ���Э�ӹ���v_sub*/
find first xpod_det
    use-index xpod_part
    where xpod_part = v_part 
    and xpod_wo_lot = v_wolot
    and xpod_op     = v_op
no-lock no-error .
v_sub        = if avail xpod_det then yes else no .
v_sub_ponbr  = if avail xpod_det then xpod_nbr else "".
v_sub_nbr    = "" .

/* check end  ---------------------------------------------------------------------------------------*/  
