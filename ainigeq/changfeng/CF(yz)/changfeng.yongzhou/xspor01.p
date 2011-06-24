/* xspor01.p -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 090702.1 - RNB
[090702.1]
条码程序,采购单收货
[090702.1]
SS - 090702.1 - RNE */

{xsbcvariable01.i}
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
{xspor01deftemptable.i}

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xspor01wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).



mainloop:
repeat:
    pause 0 before-hide.
    
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
        sTitle = "[采购单收货]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    
    /* *ss_20090630* 零件号$批序号 --零件号 */
    {xspor010020.i}
    
    /* *ss_20090701* 零件号$批序号 --批号 */
    {xspor010030.i}
    
    /* *ss_20090701* 供应商 */
    {xspor010040.i}
    
    /* *ss_20090701* 收货库位 */
    {xspor010050.i}
    
    lp-qty-yn:
    do on endkey undo, retry
        on error undo, retry:
    
        /* *ss_20090701* 数量 */
        {xspor010060.i}
        
        /* *ss_20090701* 确认 */
        {xspor010070.i}
    
        leave lp-qty-yn.
    end.    /* lp-qty-yn */
    
    /* *ss_20090701* cim交易过程 */
    {xspor01trans.i}
    
    /* *ss_20090701* 显示收货信息 */
    {xspor010080.i}
                
end.


