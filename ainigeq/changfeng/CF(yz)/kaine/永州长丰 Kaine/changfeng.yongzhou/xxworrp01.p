/* xxworrp01.p -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/27/2009   By: Kaine Zhang     Eco: *ss_20090727* */
/* SS - 090827.1 By: Kaine Zhang */

{mfdtitle.i "090827.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable sPartA like pt_part no-undo.
define variable sPartB like pt_part no-undo.
define variable sSite as character initial "CF" no-undo.
define variable sLocationA like ld_loc no-undo.
define variable sLocationB like ld_loc no-undo.
define variable sWoLotA like wo_lot no-undo.
define variable sWoLotB like wo_lot no-undo.

define variable sPartDesc like pt_desc1 no-undo.

FORM
    dteA         colon 15   label "����"
    dteB         colon 45   label "��"
    sPartA       colon 15   label "����"
    sPartB       colon 45   label "��"
    sLocationA   colon 15   label "��λ"
    sLocationB   colon 45   label "��"
    sSite        colon 70   label "�ص�"
    sWoLotA      colon 15   label "������"
    sWoLotB      colon 45   label "��"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).

form
    tr_date     label "����"
    tr_loc      label "��λ"
    tr_part     label "����"
    tr_lot      label "����"
    tr_serial   label "����"
    tr_qty_loc  label "����"    format "->>>>9"
    sPartDesc   label "˵��"
with stream-io down frame b width 132 no-box.
setFrameLabels(frame b:handle).

display
    sSite
with frame a.
assign
    dteA = today
    dteB = today
    .



{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
    if dteA = low_date then dteA = ?.
    if dteB = hi_date then dteB = ?.
    if sPartB = hi_char then sPartB = "".
    if sLocationB = hi_char then  sLocationB = "".
    if sWoLotB = hi_char then  sWoLotB = "".

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
            sPartA
            sPartB
            sLocationA
            sLocationB
            sWoLotA
            sWoLotB
        WITH FRAME a .

    {wbrp06.i
        &command = update
        &fields = "
            dteA
            dteB
            sPartA
            sPartB
            sLocationA
            sLocationB
            sWoLotA
            sWoLotB
        "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    THEN DO:
        bcdparm = "".
        {mfquoter.i   dteA       }
        {mfquoter.i   dteB       }
        {mfquoter.i   sPartA     }
        {mfquoter.i   sPartB     }
        {mfquoter.i   sLocationA }
        {mfquoter.i   sLocationB }
        {mfquoter.i   sWolotA }
        {mfquoter.i   sWolotB }

        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
        if sPartB = "" then sPartB = hi_char.
        if sLocationB = "" then sLocationB = hi_char.
        if sWoLotB = "" then sWoLotB = hi_char.
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


    for each tr_hist
        no-lock
        where tr_date >= dteA
            and tr_date <= dteB
            and tr_type = "RCT-WO"
            and tr_part >= sPartA
            and tr_part <= sPartB
            and tr_site = sSite
            and tr_loc >= sLocationA
            and tr_loc <= sLocationB
            and tr_lot >= sWoLotA
            and tr_lot <= sWoLotB
        use-index tr_date_trn
        break
        by tr_date
        by tr_loc
        by tr_part
        by tr_serial
    :
        if first-of(tr_part) then do:
            for first pt_mstr
                no-lock
                where pt_part = tr_part
            :
            end.
            sPartDesc = if available(pt_mstr) then pt_desc1 else "".
        end.

        display 
            tr_date
            tr_loc
            tr_part
            tr_lot
            tr_serial
            tr_qty_loc
            sPartDesc
        with frame b.
        down with frame b.

        accumulate tr_qty_loc (total by tr_part).

        if last-of(tr_part) then do:
            display
                "Total" @ tr_date
                tr_loc
                tr_part
                (accum total by tr_part tr_qty_loc) @ tr_qty_loc
            with frame b.
            down with frame b.
        end.
    end.


    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}

