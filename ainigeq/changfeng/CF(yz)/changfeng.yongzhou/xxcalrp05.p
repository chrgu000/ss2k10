/* xxcalrp05.p -- */
/* Copyright 200909 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 09/14/2009   By: Kaine Zhang     Eco: *ss_20090914* */
/* SS - 090914.1 By: Kaine Zhang */

{mfdtitle.i "090914.1"}

define variable dteA as date no-undo.
define variable dteB as date no-undo.
define variable decSalary as decimal no-undo.

define variable i as integer no-undo.
define variable dec1 as decimal no-undo.
define variable decMaterialCost as decimal no-undo.
define variable decTravelExpense as decimal no-undo.
define variable decTransportExpense as decimal no-undo.
define variable sDelimiter as character initial ";" no-undo.

FORM
    dteA         colon 15   label "Date"
    dteB         colon 45   label "To"
    decSalary    colon 15   label "Salary"
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
            decSalary
        WITH FRAME a .

    {wbrp06.i
        &command = update
        &fields = "
            dteA
            dteB
            decSalary
        "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    THEN DO:
        bcdparm = "".
        {mfquoter.i   dteA       }
        {mfquoter.i   dteB       }
        {mfquoter.i   decSalary  }
    
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


    run putheader.

    for each xmt_hist
        no-lock
        where xmt_date >= dteA
            and xmt_date <= dteB
        use-index xmt_date_vin
    :
        accumulate (xmt_material_cost + xmt_travel_expense + xmt_transport_expense) (total).
    end.
    dec1 = accum total (xmt_material_cost + xmt_travel_expense + xmt_transport_expense).

    i = 0.
    if dec1 = 0 then do:
        for each xmt_hist
            no-lock
            where xmt_date >= dteA
                and xmt_date <= dteB
            use-index xmt_date_vin
        :
            i = i + 1.
            put
                unformatted
                i at 1 sDelimiter
                xmt_reason sDelimiter
                xmt_material_cost sDelimiter
                xmt_travel_expense sDelimiter
                xmt_transport_expense sDelimiter
                0 sDelimiter
                xmt_material_cost + xmt_travel_expense + xmt_transport_expense sDelimiter
                .
            accumulate xmt_material_cost (total).
            accumulate xmt_travel_expense (total).
            accumulate xmt_transport_expense (total).
        end.
    end.
    else do:
        for each xmt_hist
            no-lock
            where xmt_date >= dteA
                and xmt_date <= dteB
            use-index xmt_date_vin
        :
            i = i + 1.
            put
                unformatted
                i at 1 sDelimiter
                xmt_reason sDelimiter
                xmt_material_cost sDelimiter
                xmt_travel_expense sDelimiter
                xmt_transport_expense sDelimiter
                round((xmt_material_cost + xmt_travel_expense + xmt_transport_expense) / dec1 * decSalary, 2) sDelimiter
                round((xmt_material_cost + xmt_travel_expense + xmt_transport_expense) * ( 1 + decSalary / dec1), 2) sDelimiter
                .
            accumulate xmt_material_cost (total).
            accumulate xmt_travel_expense (total).
            accumulate xmt_transport_expense (total).
        end.
    end.
    assign
        decMaterialCost = accum total xmt_material_cost
        decTravelExpense = accum total xmt_travel_expense
        decTransportExpense = accum total xmt_transport_expense
        .

    put
        unformatted
        sDelimiter at 1
        sDelimiter
        decMaterialCost sDelimiter
        decTravelExpense sDelimiter
        decTransportExpense sDelimiter
        decSalary sDelimiter
        (decMaterialCost + decTravelExpense + decTransportExpense + decSalary) sDelimiter
        .

    for each xclaim_det
        no-lock
        where xclaim_date >= dteA
            and xclaim_date <= dteB
        use-index xclaim_date
    :
        accumulate xclaim_claim (total).
        accumulate xclaim_travel_expense (total).
    end.
    put
        unformatted
        (accum total xclaim_claim)            sDelimiter
        (accum total xclaim_travel_expense)   sDelimiter
        (decMaterialCost + decTravelExpense + decTransportExpense + decSalary)
            + (accum total xclaim_claim)
            + (accum total xclaim_travel_expense)
            sDelimiter
        .

    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}




procedure putheader:
    put
        unformatted
        sDelimiter at 1
        sDelimiter
        "���ϳ�������ɳ���������ι�˾"
        sDelimiter at 1
        sDelimiter
        "��(��)β����ʧ�ɱ�ͳ����ϸ��"
        "�����: ҵ���" at 1
        sDelimiter
        sDelimiter
        sDelimiter
        Today
        sDelimiter
        sDelimiter
        "��λ: Ԫ"
        sDelimiter
        sDelimiter
        "CFS/QRP2706(A/O)"
        "���" at 1
        sDelimiter
        "��Ʒԭ��"
        sDelimiter
        "����"
        sDelimiter
        "���÷�"
        sDelimiter
        "������"
        sDelimiter
        "���ʷ�̯"
        sDelimiter
        "С��"
        sDelimiter
        "����"
        sDelimiter
        "���÷�"
        sDelimiter
        "�ϼ�"
        sDelimiter
        .
end procedure.

procedure putheaderold:
    put
        unformatted
        sDelimiter at 1
        sDelimiter
        sDelimiter
        "���ϳ�������ɳ���������ι�˾"
        sDelimiter at 1
        sDelimiter
        sDelimiter
        "��(��)β����ʧ�ɱ�ͳ����ϸ��"
        "�����: ҵ���" at 1
        sDelimiter
        sDelimiter
        sDelimiter
        sDelimiter
        Today
        sDelimiter
        "��λ: Ԫ"
        sDelimiter
        sDelimiter
        "CFS/QRP2706(A/O)"
        "���" at 1
        sDelimiter
        "��Ʒԭ��"
        sDelimiter
        "�ۺ�����"
        sDelimiter
        sDelimiter
        sDelimiter
        sDelimiter
        sDelimiter
        "���⼰���߷�"
        sDelimiter
        sDelimiter
        "�ϼ�"
        sDelimiter at 1
        sDelimiter
        "����"
        sDelimiter
        "���÷�"
        sDelimiter
        "������"
        sDelimiter
        "���ʷ�̯"
        sDelimiter
        "С��"
        sDelimiter
        "����"
        sDelimiter
        "���÷�"
        .
end procedure.

