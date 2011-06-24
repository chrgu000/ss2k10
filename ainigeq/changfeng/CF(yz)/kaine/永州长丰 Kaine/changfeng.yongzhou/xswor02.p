/* xswor02.p -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090702.1 By: Kaine Zhang */

/* SS - 090702.1 - RNB
[090702.1]
条码程序,座椅入库.
[090702.1]
SS - 090702.1 - RNE */

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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswor02wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
        sTitle = "[座椅入库]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /* *ss_20090630* 工单ID */
    {xswor020020.i}
    
    detlp:
    repeat on endkey undo, retry:
        /* *ss_20090701* 零件号$批序号 --物料 */
        {xswor020030.i}
        
        /* *ss_20090701* 零件号$批序号 --批号 */
        {xswor020040.i}
        
        /* *ss_20090701* 库位 */
        {xswor020050.i}
        
        /* *ss_20090701* 数量 */
        {xswor020060.i}
        
        /* *ss_20090701* 确认 */
        {xswor020070.i}
        
        /* *ss_20090701* cim交易过程 */
        {xswor02trans.i}
        
        /* *ss_20090701* 显示交易信息 */
        {xswor020080.i}
    end.
end.


