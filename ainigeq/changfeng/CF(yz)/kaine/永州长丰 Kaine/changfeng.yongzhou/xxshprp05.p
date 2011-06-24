/* xxshprp05.p -- */
/* Copyright 200910 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 091029.1 By: Kaine Zhang */

{mfdtitle.i "091029.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable sPartA like pt_part no-undo.
define variable sPartB like pt_part no-undo.
define variable sSite as character no-undo.
define variable sLocationA as character no-undo.
define variable sLocationB as character no-undo.

define variable i as integer no-undo.
define variable dteD as date no-undo.
define variable iMin as integer no-undo.
define variable iMax as integer no-undo.
define variable dteMin as date no-undo.
define variable dteMax as date no-undo.
define variable dec1 as decimal no-undo.
define variable dec2 as decimal no-undo.
define variable sDelimiter as character initial ";" format "x(1)" no-undo.
define variable sPut as character no-undo.

define temp-table t1_tmp no-undo
    field t1_date as date
    field t1_time as character
    field t1_part as character
    field t1_lot as character
    field t1_column as integer
    index t1_date_time_part_lot
        is primary
        t1_date
        t1_time
        t1_part
        t1_lot
        .

define temp-table t2_tmp no-undo
    field t2_date as date
    field t2_time as character
    field t2_part as character
    field t2_lot_start as character
    field t2_lot_finish as character
    field t2_column as integer
    field t2_printed as logical
    index t2_date_time_part_lot
        is primary
        t2_date
        t2_time
        t2_part
        t2_lot_start
        .

FORM
    dteA        colon 15    label "Date"
    dteB        colon 45    label "To"
    sPartA      colon 15    label "Part"
    sPartB      colon 45    label "To"
    sSite       colon 15    label "Site"
    sLocationA  colon 15    label "Location"
    sLocationB  colon 45    label "To"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).

assign
    dteA = date(month(today), 1, year(today))
    dteB = today
    sSite = "CF"
    .




{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
    if dteA = low_date then dteA = ?.
    if dteB = hi_date then dteB = ?.
    if sPartB = hi_char then sPartB = "".
    if sLocationB = hi_char then sLocationB = "".

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
            sPartA
            sPartB
            sSite
            sLocationA
            sLocationB
        WITH FRAME a .

    {wbrp06.i
        &command = update
        &fields = "
            dteA
            dteB
            sPartA
            sPartB
            sSite
            sLocationA
            sLocationB
        "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    THEN DO:
        bcdparm = "".
        {mfquoter.i   dteA       }
        {mfquoter.i   dteB       }
        {mfquoter.i   sPartA }
        {mfquoter.i   sPartB }
        {mfquoter.i   sSite }
        {mfquoter.i   sLocationA }
        {mfquoter.i   sLocationB }
    
        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
        if SPartB = "" then sPartB = hi_char.
        if sLocationB = "" then sLocationB = hi_char.
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

    empty temp-table t1_tmp.
    empty temp-table t2_tmp.
    /* get all shipment detail -- t1_tmp */
    {xxshprp0501.i}

    /* collect t1's lot --> t2_tmp */
    {xxshprp0502.i}

    /* display */
    {xxshprp0503.i}

    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}


