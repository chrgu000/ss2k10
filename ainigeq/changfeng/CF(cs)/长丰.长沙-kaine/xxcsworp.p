/* xxcsworp.p -- */
/* Copyright 200911 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 091113.1 By: Kaine Zhang */

{mfdtitle.i "091113.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.

define variable sDelimiter as character initial "~t" no-undo.

FORM
    dteA         colon 15   label "日期"
    dteB         colon 45   label "至"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).





{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
    if dteA = low_date then dteA = ?.
    if dteB = hi_date then dteB = ?.

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
        WITH FRAME a .

    {wbrp06.i
        &command = update
        &fields = "
            dteA
            dteB
        "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    THEN DO:
        bcdparm = "".
        {mfquoter.i   dteA       }
        {mfquoter.i   dteB       }
    
        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
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
        unformatted
        "导入日期" at 1 sDelimiter
        "导入时间" sDelimiter
        "车型代号" sDelimiter
        "颜色" sDelimiter
        "沙发编码" sDelimiter
        "数量" sDelimiter
        "转WO成功" sDelimiter
        "转WO日期" sDelimiter
        "转WO时间" sDelimiter
        "转WO错误" sDelimiter
        "转WO标志"
        .
    
    for each xcswo_mstr
        no-lock
        where xcswo_import_date >= dteA
            and xcswo_import_date <= dteB
        use-index xcswo_datetime_serial_color
    :
        put
            unformatted
            xcswo_import_date at 1 sDelimiter
            string(xcswo_import_time, "HH:MM:SS") sDelimiter
            xcswo_serial sDelimiter
            xcswo_color sDelimiter
            xcswo_sf_part sDelimiter
            xcswo_qty sDelimiter
            xcswo_trans_to_sf sDelimiter
            xcswo_trans_date sDelimiter
            string(xcswo_trans_time, "HH:MM:SS") sDelimiter
            xcswo_is_trans_error sDelimiter
            xcswo_wo_id
            .
    end.

    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}


