/* xsworjt10.p -- */
/* Copyright By Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* SS - 100301.1 - RNB
[100301.1]
条码程序,工单退货.
[100301.1]
SS - 100301.1 - RNE */

{xsbcvariable01.i}

define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsworjt10wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

    
mainloop:
repeat:

    /* START  LINE :0010  地点[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.
        
        {xsvarform0010.i}
        
        {xsdefaultsite.i
            s0010_1
            s0010_2
        }
        
        s0010 = s0010_1.
        
        /* *ss_20090701* 标题行内容 */
        sTitle = "[工单入库]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /* 工单ID */
    {xsworjt100020.i}
    
        
    /* 零件号$批序号 --物料 */
    {xsworjt100030.i}
    
    /* 零件号$批序号 --批号 */
    {xsworjt100040.i}
    
    /* 库位 */
    {xsworjt100050.i}
    
    /* 数量 */
    {xsworjt100060.i}
    
    /* 确认 */
    {xsworjt100070.i}
    
    /* cim交易过程 */
    {xsworjt10trans.i}
    
    /* 显示交易信息 */
    {xsworjt100080.i}
end.


