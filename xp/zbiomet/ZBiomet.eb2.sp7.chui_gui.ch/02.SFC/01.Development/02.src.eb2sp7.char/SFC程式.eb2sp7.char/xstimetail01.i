/* xstimetail01.i   ����Ļ���,�������,�๤��ͬʱ����                   */
/* REVISION: 1.0         Last Modified: 2008/12/22   By: Roger   No ECO:   */
/*-Revision end------------------------------------------------------------*/



define var v_fld_tail  like xcode_fldname .  v_fld_tail = v_fldname + "-tail-mch" .
define var v_tail_wc   as logical .    


v_tail_wc = no . 
find first xcode_mstr where xcode_fldname = v_fld_tail and xcode_value = v_wc no-lock no-error .
if avail xcode_mstr then do: /*�������*/
    v_tail_wc = yes .
end. /*�������*/
