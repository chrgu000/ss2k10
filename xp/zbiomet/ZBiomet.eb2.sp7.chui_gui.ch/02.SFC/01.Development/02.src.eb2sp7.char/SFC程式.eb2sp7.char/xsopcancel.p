/* xsopcancel.p 删除工序 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*反馈前的,变量定义及相关检查*/

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}



find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op )
        or xxwrd_wolot   < v_wolot)
    and xxwrd_close   = yes
no-lock no-error .
if avail xxwrd_Det then do:
    message "指令无法执行:当前/后续工序已经有做更新" view-as alert-box title "" .
    undo,leave .
end. 














define var v_del_or_not as logical .
v_del_or_not = yes .

/*后续工序不可已开始时间或数量反馈*/
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



/*后续工序不可有未结指令*/
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


/*当前工序不可已开始时间或数量反馈*/
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


/*当前工序不可有未结指令*/
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
    如果无反馈记录,则直接取消工序,不做更新, "D"状态
    否则终止工序的反馈,数据仍然更新至mfgpro,"J"状态
    */

    if  v_del_or_not = no then do:
        run xsopcancel03.p.
    end.
    else do:
        run xsopcancel01.p.
    end.
leave .
end. /*mainloop:*/
