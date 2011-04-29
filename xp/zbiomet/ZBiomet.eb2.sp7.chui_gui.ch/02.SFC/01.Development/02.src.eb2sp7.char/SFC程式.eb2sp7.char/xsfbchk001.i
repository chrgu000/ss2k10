/* xsfbchk001.i 反馈前的,变量定义及相关检查                                */
/* REVISION: 1.0         Last Modified: 2008/12/11   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*************
1.called by 合格,报废,返工,准备时间,运行时间
2.to define vars needed 
3.to check 是否允许执行反馈
4.共用检查不需备注,特殊检查可用 if v_line = v_line_prev[xx] then do:  end. 来处理
************/ 


/*  
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*会计期间检查*/
*/


define var v_ii         as integer .
define var v_prev       as logical . /*是否有前工序*/
define var v_prev_wolot as char   format "x(18)".
define var v_prev_op    as integer .
define var v_prev_part  as char  format "x(18)".
define var v_qty_prev   as decimal  .

define var v_next       as logical . /*是否有后工序*/
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

define var v_yn1 as logical format "Y/N". /*是否工序完成?*/
define var v_yn2 as logical format "Y/N". /*是否有退料?*/
define var v_yn3 as logical format "Y/N". /*是否返工件合格?*/
define var v_yn4 as logical format "Y/N". /*是否评审件?*/
define var v_sub as logical format "Y/N". /*是否外协加工单?*/
define var v_sub_nbr   as char format "x(12)" . /*外协加工单的送检单号*/
define var v_sub_ponbr as char format "x(8)" . /*外协加工单的PO号*/


define var v_tol_pct like xxfb_qty_fb . v_tol_pct = 100 .
define var v_fld_std as char label "超量完工限额百分比" . v_fld_std = v_fldname + "-tol-pct" .

find first xcode_mstr where xcode_fldname = v_fld_std and xcode_value = "*" no-lock no-error.
if not avail xcode_mstr then do:
    v_tol_pct = 100 .
end.
else do:
    v_tol_pct = 100 + decimal(xcode_cmmt) .
end.



/*检查是否后处理工序的机器v_tail_wc*/
{xstimetail01.i}



v_qty_bom    = 1 . /*默认值:在biomet等于1*/
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
v_next_bom   = 1 .  /*默认值:在biomet等于1*/



/* var defines end ---------------------------------------------------------------------------------------*/  


/*检查:工单状态*/
if v_wolot = "" then do:
    message "指令无法执行:当前工单为空."  view-as alert-box title ""  .
    undo,leave .
end.
find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
if not avail xwo_mstr then do:
    message "指令无法执行:当前工单不存在"  view-as alert-box title ""  .
    undo,leave .
end.
else do:
    /*if index("R",xwo_status ) = 0 then do:
        message "指令无法执行:当前工单状态有误" xwo_status  view-as alert-box title ""  .
        undo,leave .
    end.  *//*xp-wo-stat*/
end. /*else do:*/






/*工单工序首次刷读,更新工艺流程记录*/
{xswofirsttime.i}



/*检查:工单工艺流程是否存在,及状态*/
find first xxwrd_det where xxwrd_wonbr = v_wonbr no-lock no-error .
if not avail xxwrd_det then do:
    message "指令无法执行:SFC工单工艺流程不存在,"  view-as alert-box title "" .
    undo,leave .
end. /*if not avail xxwrd_det*/
find first xxwrd_det 
    where xxwrd_wolot = v_wolot 
    and xxwrd_op    = v_op 
no-lock no-error .
if not avail xxwrd_Det then do:
    message "指令无法执行:SFC工单工艺流程不存在."  view-as alert-box title "" .
    undo,leave .
end.
else do: 
    v_wrnbr    = xxwrd_Wrnbr .   
    v_part     = xxwrd_part .
    v_wonbr    = xxwrd_wonbr .
    if (xxwrd_status  <> "" and xxwrd_status <> "N") or xxwrd_close = yes then do:
        message "指令无法执行:SFC工单工艺流程已结或已删除."  view-as alert-box title "" .
        undo,leave .
    end .
end. 


/*检查:后面工序如果已更新,就不允许再反馈*/
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
    message "指令无法执行:后续工序已更新"  view-as alert-box title "" .
    undo,leave .
end. 



/*检查:是否外协加工单v_sub*/
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
