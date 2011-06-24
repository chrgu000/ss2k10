/* xxreprp05.p -- */
/* Copyright 200909 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 09/14/2009   By: Kaine Zhang     Eco: *ss_20090914* */
/* SS - 090914.1 By: Kaine Zhang */

{mfdtitle.i "090914.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable sVinA like xcar_vin no-undo.
define variable sVinB like xcar_vin no-undo.

define variable i as integer no-undo.
define variable sDelimiter as character initial " " format "x(1)" no-undo.
define variable sSeat like xcard_seat extent 5 no-undo.

FORM
    dteA         colon 15   label "Date"
    dteB         colon 45   label "To"
    sVinA        colon 15   label "Vin"
    sVinB        colon 45   label "To"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).

form
    xcar_type column-label "车型"
    xmt_vin column-label "大架号"
    sSeat[1] column-label "驾驭座条码"
    sSeat[2] column-label "副驾驶座座条码"
    sSeat[3] column-label "中排座条码"
    sSeat[4] column-label "后左条码"
    sSeat[5] column-label "后右条码"
    xcar_sale_date column-label "销售日期"
    xcar_ship_to column-label "销售地"
    xmt_date column-label "维修日期"
    xmt_reason column-label "故障原因"
    xmt_solution column-label "处理结果"
    xcar_company column-label "单位"
    xcar_name column-label "姓名"
with frame b down width 220.
setframelabels(frame b:handle).





{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
    if dteA = low_date then dteA = ?.
    if dteB = hi_date then dteB = ?.
    if sVinB = hi_char then sVinB = "".

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
            sVinA
            sVinB
        WITH FRAME a .

    {wbrp06.i
        &command = update
        &fields = "
            dteA
            dteB
            sVinA
            sVinB
        "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    THEN DO:
        bcdparm = "".
        {mfquoter.i   dteA       }
        {mfquoter.i   dteB       }
        {mfquoter.i   sVinA  }
        {mfquoter.i   sVinB  }
    
        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
        if sVinB = "" then sVinB = hi_char.
    END.

    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i
        &printType = "printer"
        &printWidth = 132
        &pagedFlag = " "
        &stream = " "
        &appendToFile = " "
        &streamedOutputToTerminal = " "
        &withBatchOption = "yes"
        &displayStatementType = 1
        &withCancelMessage = "yes"
        &pageBottomMargin = 6
        &withEmail = "yes"
        &withWinprint = "yes"
        &defineVariables = "yes"
    }

    put
        "类型               大架号            驾驭座条码                       副驾驶座座条码                   中排座条码                       后左条码                         后右条码                         销售日期 销往                                     维修日期 原因                                                         解决                                                         单位               姓名" at 1.
    for each xmt_hist
        no-lock
        where xmt_date >= dteA
            and xmt_date <= dteB
            and xmt_vin >= sVinA
            and xmt_vin <= sVinB
        use-index xmt_date_vin
        ,
    first xcar_mstr
        no-lock
        where xcar_vin = xmt_vin
        use-index xcar_vin
    :
        assign
            sSeat = ""
            i = 0
            .
        for each xcard_det
            no-lock
            where xcard_vin = xmt_vin
            use-index xcard_vin_seat
            by xcard_seq
        :
            i = i + 1.
            sSeat[i] = xcard_seat.
            if i >= 5 then leave.
        end.
        /* SS - 090917.1 - B
        display
            xcar_type
            xmt_vin
            sSeat[1]
            sSeat[2]
            sSeat[3]
            sSeat[4]
            sSeat[5]
            xcar_sale_date
            xcar_ship_to
            xmt_date
            xmt_reason
            xmt_solution
            xcar_company
            xcar_name
        with frame b.
        down with frame b.
        SS - 090917.1 - E */
        put
            xcar_type at 1 sDelimiter
            xmt_vin sDelimiter
            sSeat[1] sDelimiter
            sSeat[2] sDelimiter
            sSeat[3] sDelimiter
            sSeat[4] sDelimiter
            sSeat[5] sDelimiter
            xcar_sale_date sDelimiter
            xcar_ship_to sDelimiter
            xmt_date sDelimiter
            xmt_reason sDelimiter
            xmt_solution sDelimiter
            xcar_company sDelimiter
            xcar_name sDelimiter
            .
    end.

    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}


