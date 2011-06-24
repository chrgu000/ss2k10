/* xxshprp30.p -- */
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
define variable sSoNbrA like wo_lot no-undo.
define variable sSoNbrB like wo_lot no-undo.
define variable sFlagA as character no-undo.
define variable sFlagB as character no-undo.

define variable sPartDesc like pt_desc1 no-undo.

FORM
    dteA         colon 15   label "日期"
    dteB         colon 45   label "至"
    sPartA       colon 15   label "物料"
    sPartB       colon 45   label "至"
    sLocationA   colon 15   label "库位"
    sLocationB   colon 45   label "至"
    sSite        colon 70   label "地点"
    sSoNbrA      colon 15   label "销售订单"
    sSoNbrB      colon 45   label "至"
    sFlagA       colon 15   label "发货标记"
    sFlagB       colon 45   label "至"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).

form
    tr_date     label "日期"
    tr__chr01   label "发货标记"
    tr_loc      label "库位"
    tr_part     label "物料"
    tr_nbr      label "单号"
    tr_serial   label "批号"
    tr_qty_loc  label "数量"    format "->>>>9"
    sPartDesc   label "说明"
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
    if sSoNbrB = hi_char then  sSoNbrB = "".
    if sFlagB = hi_char then  sFlagB = "".

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
            sPartA
            sPartB
            sLocationA
            sLocationB
            sSoNbrA
            sSoNbrB
            sFlagA
            sFlagB
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
            sSoNbrA
            sSoNbrB
            sFlagA
            sFlagB
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
        {mfquoter.i   sSoNbrA }
        {mfquoter.i   sSoNbrB }
        {mfquoter.i   sFlagA }
        {mfquoter.i   sFlagB }

        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
        if sPartB = "" then sPartB = hi_char.
        if sLocationB = "" then sLocationB = hi_char.
        if sSoNbrB = "" then sSoNbrB = hi_char.
        if sFlagB = "" then sFlagB = hi_char.
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
            and tr_type = "ISS-SO"
            and tr_part >= sPartA
            and tr_part <= sPartB
            and tr_site = sSite
            and tr_loc >= sLocationA
            and tr_loc <= sLocationB
            and tr_nbr >= sSoNbrA
            and tr_nbr <= sSoNbrB
            and tr__chr01 >= sFlagA
            and tr__chr01 <= sFlagB
        use-index tr_date_trn
        break
        by tr_date
        by tr__chr01
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
            tr__chr01
            tr_loc
            tr_part
            tr_nbr
            tr_serial
            (- tr_qty_loc) @ tr_qty_loc
            sPartDesc
        with frame b.
        down with frame b.

        accumulate tr_qty_loc (total by tr_part).

        if last-of(tr_part) then do:
            display
                "Total" @ tr_date
                tr_loc
                tr_part
                (- accum total by tr_part tr_qty_loc) @ tr_qty_loc
            with frame b.
            down with frame b.
        end.
    end.


    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}

