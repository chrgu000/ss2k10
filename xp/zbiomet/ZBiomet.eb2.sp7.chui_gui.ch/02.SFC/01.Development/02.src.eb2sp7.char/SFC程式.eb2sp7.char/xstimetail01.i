/* xstimetail01.i   后处理的机器,允许多人,多工单同时操作                   */
/* REVISION: 1.0         Last Modified: 2008/12/22   By: Roger   No ECO:   */
/*-Revision end------------------------------------------------------------*/



define var v_fld_tail  like xcode_fldname .  v_fld_tail = v_fldname + "-tail-mch" .
define var v_tail_wc   as logical .    


v_tail_wc = no . 
find first xcode_mstr where xcode_fldname = v_fld_tail and xcode_value = v_wc no-lock no-error .
if avail xcode_mstr then do: /*后处理机器*/
    v_tail_wc = yes .
end. /*后处理机器*/
