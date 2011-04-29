/* xsopcancel.p ɾ������ */
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
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op )
        or xxwrd_wolot   < v_wolot)
    and xxwrd_close   = yes
no-lock no-error .
if avail xxwrd_Det then do:
    message "ָ���޷�ִ��:��ǰ/���������Ѿ���������" view-as alert-box title "" .
    undo,leave .
end. 














define var v_del_or_not as logical .
v_del_or_not = yes .

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
    v_del_or_not = no .
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
    v_del_or_not = no .
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
    v_del_or_not = no .
end. 


/*��ǰ���򲻿���δ��ָ��*/
find first xxfb_hist 
    where xxfb_wonbr  = v_wonbr 
    and (xxfb_wolot    = v_wolot  and xxfb_op       = v_op)
    and xxfb_date_end = ?
no-lock no-error .
if avail xxfb_hist then do:
    v_del_or_not = no .
end.

hide all no-pause .
mainloop:
repeat :

    /*
    ����޷�����¼,��ֱ��ȡ������,��������, "D"״̬
    ������ֹ����ķ���,������Ȼ������mfgpro,"J"״̬
    */

    if  v_del_or_not = no then do:
        run xsopcancel03.p.
    end.
    else do:
        run xsopcancel01.p.
    end.
leave .
end. /*mainloop:*/
