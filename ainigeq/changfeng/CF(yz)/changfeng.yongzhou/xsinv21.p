/* xsinv21.p -- */
/* Copyright 200906 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* UNPLANNED RECEIPT */
/* Revision: Version.ui    Modified: 06/30/2009   By: Kaine Zhang     Eco: *ss_20090630* */
/* SS - 090916.1 By: Kaine Zhang */

/* SS - 090916.1 - RNB
[090916.1]
列表显示备注说明.
[090916.1]
SS - 090916.1 - E */

{xsbcvariable01.i}
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
/* SS - 090916.1 - B */
define variable j as integer .
define variable s1 as character extent 6 .
/* SS - 090916.1 - E */

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv21wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
repeat:

    /* START  LINE :0010  地点[SITE]  */
    lp0010:
    repeat on endkey undo, retry:
        hide all.
        define variable s0010           as character format "x(50)".
        define variable s0010_1           as character format "x(50)".
        define variable s0010_2           as character format "x(50)".
        define variable s0010_3           as character format "x(50)".
        define variable s0010_4           as character format "x(50)".
        define variable s0010_5           as character format "x(50)".
        
        form
            sTitle
            s0010_1
            s0010_2
            s0010_3
            s0010_4
            s0010_5
            s0010
            sMessage
        with frame f0010 no-labels no-box.
        
        {xsdefaultsite.i
            s0010_1
            s0010_2
        }
        
        s0010 = s0010_1.
        
        /* *ss_20090701* 标题行内容 */
        sTitle = "[计划外出库]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    
    /* *ss_20090630* 备注. 长丰.计划外原因代码 */
    {xsinv210020.i}
    
    /* *ss_20090701* 零件号$批序号 --零件号 */
    {xsinv210030.i}
    
    /* *ss_20090701* 零件号$批序号 --批号 */
    {xsinv210040.i}
    
    /* *ss_20090701* 库位 */
    {xsinv210050.i}
    
    /* *ss_20090701* 数量 */
    {xsinv210060.i}
    
    /* *ss_20090701* 确认 */
    {xsinv210070.i}
    
    /* *ss_20090701* cim交易过程 */
    {xsinv21trans.i}
    
    /* *ss_20090701* 显示事务信息 */
    {xsinv210080.i}
                
end.


