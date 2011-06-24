/* xxtrrp10.p.p -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/27/2009   By: Kaine Zhang     Eco: *ss_20090727* */
/* SS - 090727.1 By: Kaine Zhang */

{mfdtitle.i "090727.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable sPartA like pt_part no-undo.
define variable sPartB like pt_part no-undo.
define variable sSite as character initial "CF" no-undo.
define variable sLocationA like ld_loc no-undo.
define variable sLocationB like ld_loc no-undo.
define variable sPartDesc like pt_desc1 no-undo.
define variable sTypeDesc AS CHARACTER no-undo.

FORM
    dteA         colon 15   label "����"
    dteB         colon 45   label "��"
    sPartA       colon 15   label "����"
    sPartB       colon 45   label "��"
    sLocationA   colon 15   label "��λ"
    sLocationB   colon 45   label "��"
    sSite        colon 70   label "�ص�"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).

/* SS - 090827.1 - B
form
    tr_date     label "����"
    tr_loc      label "��λ"
    tr_type     label "����"
    sTypeDesc   label "����˵��"
    tr_part     label "����"
    tr_nbr      label "����"
    tr_serial   label "����"
    tr_qty_loc  label "����"    format "->>>>9"
    sPartDesc   label "˵��"
with stream-io down frame b width 132 no-box.
setFrameLabels(frame b:handle).
SS - 090827.1 - E */

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

    if c-application-mode <> 'web' then
        update
            dteA
            dteB
            sPartA
            sPartB
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
        {mfquoter.i   sPartA     }
        {mfquoter.i   sPartB     }
        {mfquoter.i   sLocationA }
        {mfquoter.i   sLocationB }

        if dteA = ? then dteA = low_date.
        if dteB = ? then dteB = hi_date.
        if sPartB = "" then sPartB = hi_char.
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


    export
        delimiter ";"
        "����"    
        "����"
        "����˵��"
        "��λ"    
        "����"    
        "����"    
        "����"    
        "����"    
        "����˵��"
        .
    for each tr_hist
        no-lock
        where tr_date >= dteA
            and tr_date <= dteB
            and tr_part >= sPartA
            and tr_part <= sPartB
            and tr_site = sSite
            and tr_loc >= sLocationA
            and tr_loc <= sLocationB
            and tr_qty_loc <> 0
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

        case tr_type:
            when "ISS-SO" then sTypeDesc = "���۷���".
            when "RCT-WO" then sTypeDesc = "�������".
            when "RCT-PO" then sTypeDesc = "�ɹ��ջ�".
            when "RCT-UNP" then sTypeDesc = "�ƻ�����".
            when "ISS-UNP" then sTypeDesc = "�ƻ����".
            when "ISS-TR" then sTypeDesc = "ת�ַ���".
            when "RCT-TR" then sTypeDesc = "ת���յ�".
            when "ISS-WO" then sTypeDesc = "��������".
            otherwise sTypeDesc = "����".
        end case.

        export
            delimiter ";"
            tr_date
            tr_type
            sTypeDesc
            tr_loc
            tr_part
            tr_nbr
            tr_serial
            tr_qty_loc
            sPartDesc
            .

    end.


    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}

