/* xxbcldrp10.p ---- */
/* Copyright 2011 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 110322.1 By: Kaine Zhang */


{mfdtitle.i "110322.1"}

define variable sSite like si_site no-undo.
define variable sLocA like loc_loc format "x(9)" no-undo.
define variable sLocB like loc_loc format "x(9)" no-undo.
define variable sPartA like pt_part no-undo.
define variable sPartB like pt_part no-undo.
define variable sTip  as character format "x(40)" extent 4 no-undo.
define variable bInclude as logical no-undo.


assign
    sSite = global_site
    sLocA = "CSCF"
    sLocB = "CSCF"
    sTip[1] = "库位:"
    sTip[2] = "CSCF -- 长沙长丰"
    sTip[3] = "OUT -- 已出库"
    sTip[4] = "WORKPLACE -- 现场库位"
    .
    
form
    sSite   colon 15
    sLocA   colon 15
    sLocB   colon 45
    sPartA  colon 15
    sPartB  colon 45
    bInclude colon 15   label "显示零库存"
    skip(1)
    sTip[1]    at 17 no-labels
    sTip[2]    at 17 no-labels
    sTip[3]    at 17 no-labels
    sTip[4]    at 17 no-labels
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
    xbcld_loc    column-label "逻辑库位"
    xbcld_part   column-label "物料编码"
    pt_desc1     column-label "说明"
    xbcld_lot    column-label "批号"
    xbcld_qty_oh column-label "数量"
    xbcld_date   column-label "生成日期"
    xbcld_refloc column-label "参考库位"
with frame b width 320.
setframelabels(frame b:handle).






view frame a.
display
    sTip[1]
    sTip[2]
    sTip[3]
    sTip[4]
with frame a.

{wbrp01.i}
repeat on endkey undo, leave:
    if sLocB = hi_char then sLocB = "".
    if sPartB = hi_char then sPartB = "".
    
    if c-application-mode <> 'web' then
        update
            sSite 
            sLocA 
            sLocB 
            sPartA
            sPartB
            bInclude
        with frame a.

    {wbrp06.i
        &command = update
        &fields = "
            sSite 
            sLocA 
            sLocB 
            sPartA
            sPartB
            bInclude
            "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i sSite   }
        {mfquoter.i sLocA   }
        {mfquoter.i sLocB   }
        {mfquoter.i sPartA  }
        {mfquoter.i sPartB  }
        {mfquoter.i bInclude  }

        if sLocB = "" then sLocB = hi_char.
        if sPartB = "" then sPartB = hi_char.
    end.

    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }


    for each xbcld_det
        no-lock
        where xbcld_site = sSite
            and xbcld_loc >= sLocA
            and xbcld_loc <= sLocB
            and xbcld_part >= sPartA
            and xbcld_part <= sPartB
            and (xbcld_qty_oh <> 0 or bInclude)
        use-index xbcld_site_part
        ,
    first pt_mstr
        no-lock
        where pt_part = xbcld_part
    :
        display
            xbcld_loc    
            xbcld_part   
            pt_desc1
            xbcld_lot    
            xbcld_qty_oh 
            xbcld_date   
            xbcld_refloc 
        with frame b.
        down with frame b.
    end.


    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}





