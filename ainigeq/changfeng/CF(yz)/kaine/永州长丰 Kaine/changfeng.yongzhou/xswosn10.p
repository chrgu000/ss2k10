/* xswosn10.p -- */
/* Copyright 201003 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

/* SS - 100301.1 - RNB
[100301.1]
条码打印程序,半成品条码打印.
输入开始,结束日期,计划员,找wo_mstr,
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswoi10wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
        sTitle = "[半成品条码打印]*" + s0010.
        
        leave lp0010.
    END.
    /* END    LINE :0010  地点[SITE]  */

    /*开始日期*/
    {xswosn100020.i}

    /*结束日期*/
    {xswosn100030.i}

    /*计划员*/
    {xswosn100040.i}

    /*每张工单打印条码张数*/
    {xswosn100050.i}

    /*打印机*/
    {xswosn100060.i}

    for each pt_mstr where pt_buyer = s0040 no-lock ,
        each wo_mstr use-index wo_part_rel 
                     where wo_part  = pt_part 
                     and (wo_rel_date >= s0020 and wo_rel_date <= s0030)
                     no-lock :

        /*实际打印*/ 
        {xswosn100070.i}

    end.  /*for each pt_mstr*/

end. /*mainloop:*/


