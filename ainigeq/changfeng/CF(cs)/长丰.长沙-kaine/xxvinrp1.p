/* xxvinrp1.p -- */
/* Copyright 200911 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 091113.1 By: Kaine Zhang */

{mfdtitle.i "091113.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable sVinA as character format "x(17)" no-undo.
define variable sVinB as character format "x(17)" no-undo.

define variable sDelimiter as character initial "~t" no-undo.

FORM
    dteA         colon 15   label "����"
    dteB         colon 45   label "��"
    sVinA       colon 15    label "VIN"
    sVinB       colon 45    label "��"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).





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
        {mfquoter.i   sVinA       }
        {mfquoter.i   sVinB      }
    
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
        unformatted
        "VIN" at 1 sDelimiter
        "���ʹ���" sDelimiter
        "�ɳ�����" sDelimiter
        "��ɫ" sDelimiter
        "��������" sDelimiter
        "ͨ��ʱ��" sDelimiter
        "��������" sDelimiter
        "����ʱ��"
        .

    for each xvin_det
        no-lock
        where xvin_import_date >= dteA
            and xvin_import_date <= dteB
            and xvin_vin >= sVinA
            and xvin_vin <= sVinB
        use-index xvin_import_datetime
    :
        put
            unformatted
            xvin_vin at 1 sDelimiter
            xvin_serial sDelimiter
            xvin_car sDelimiter
            xvin_color sDelimiter
            xvin_base_wo_id sDelimiter
            xvin_pass_time sDelimiter
            xvin_import_date sDelimiter
            string(xvin_import_time, "HH:MM:SS")
            .
    end.

    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}


