/* xxioh10.p -- */
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
define variable iTr as integer no-undo.
define variable dec1 as decimal no-undo.
define variable dec2 as decimal no-undo.
define variable dec3 as decimal no-undo.
define variable dec4 as decimal no-undo.
define variable dec5 as decimal no-undo.
define variable dec6 as decimal no-undo.
define variable dec7 as decimal no-undo.
define variable s1 as character no-undo.
define variable s2 as character no-undo.
define variable s3 as character no-undo.
define temp-table t1_tmp no-undo
    field t1_loc like ld_loc
    field t1_part like ld_part
    field t1_lot like ld_lot
    field t1_begin_qty as decimal
    field t1_end_qty as decimal
    field t1_oh_qty as decimal
    field t1_overdate_qty as decimal
    field t1_1 as decimal
    field t1_2 as decimal
    field t1_3 as decimal
    field t1_4 as decimal
    field t1_5 as decimal
    field t1_6 as decimal
    field t1_7 as decimal
    .

FORM
    dteA         colon 15   label "Date"
    dteB         colon 45   label "To"
    sPartA       colon 15   label "Part"
    sPartB       colon 45   label "To"
    sSite        colon 15   label "Site"
    sLocationA   colon 15   label "Location"
    sLocationB   colon 45   label "To"
    SKIP
WITH FRAME a SIDE-LABELS WIDTH 80.
setFrameLabels(FRAME a:HANDLE).

form
    t1_part  column-label "物料编码"
    pt_desc1 column-label "产品名称"
    pt_desc2 column-label "规格"
    pt_um column-label "UM"
    t1_lot column-label "批号"
    s1 column-label "上月未开发票"
    dec1 format "->>>>>>9.9<<" column-label "实际库存"
    t1_1 format "->>>>>>9.9<<" column-label "采购收货"
    t1_2 format "->>>>>>9.9<<" column-label "车间入库"
    t1_3 format "->>>>>>9.9<<" column-label "料单入库"
    t1_4 format "->>>>>>9.9<<" column-label "股份销售"
    t1_5 format "->>>>>>9.9<<" column-label "其他销售"
    t1_6 format "->>>>>>9.9<<" column-label "企业自用"
    t1_7 format "->>>>>>9.9<<" column-label "其他"
    dec2 format "->>>>>>9.9<<" column-label "期末库存"
    s2 column-label "总未开发票数"
    s3 column-label "备注"
with stream-io down frame b width 260 no-box.
setFrameLabels(frame b:handle).

display
    sSite
with frame a.




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


    empty temp-table t1_tmp.

    /* get t1_oh_qty */
    for each ld_det
        no-lock
        where ld_site = sSite
            and ld_loc >= sLocationA
            and ld_loc <= sLocationB
            and ld_part >= sPartA
            and ld_part <= sPartB
        use-index ld_loc_p_lot
        break
        by ld_site
        by ld_loc
        by ld_part
        by ld_lot
    :
        accumulate ld_qty_oh (total by ld_lot).
        if last-of(ld_lot) then do:
            create t1_tmp.
            assign
                t1_loc = ld_loc
                t1_part = ld_part
                t1_lot = ld_lot
                t1_oh_qty = accum total by ld_lot ld_qty_oh
                .
        end.
    end.

    find last tr_hist
        no-lock
        use-index tr_trnbr
        no-error.
    iTr = if available(tr_hist) then tr_trnbr else 0.

    {xxioh10inout.i}

    form header
        "产品销售与库存" at 40
    with stream-io frame frm1 page-top.

    view frame frm1.

    for each t1_tmp
        no-lock
        where t1_1 <> 0
            or t1_2 <> 0
            or t1_3 <> 0
            or t1_4 <> 0
            or t1_5 <> 0
            or t1_6 <> 0
            or t1_7 <> 0
            or t1_oh_qty - t1_overdate_qty <> 0
        ,
    each pt_mstr fields(pt_part pt_desc1 pt_desc2 pt_um)
        no-lock
        where pt_part = t1_part
        break
        by t1_loc
        by t1_part
        by t1_lot
    :
        if first-of(t1_loc) then do:
            for first loc_mstr
                no-lock
                where loc_site = sSite
                    and loc_loc = t1_loc
            :
            end.
            display
                ("库位: " + t1_loc) @ t1_part
                (if available(loc_mstr) then loc_desc else "") @ pt_desc1
            with frame b.
            down with frame b.
        end.

        display
            t1_part
            pt_desc1
            pt_desc2
            pt_um
            t1_lot
            s1
            t1_oh_qty - t1_overdate_qty - t1_1 - t1_2 - t1_3 - t1_4 - t1_5 - t1_6 - t1_7
                @ dec1
            t1_1
            t1_2
            t1_3
            (- t1_4) @ t1_4
            (- t1_5) @ t1_5
            (- t1_6) @ t1_6
            t1_7
            t1_oh_qty - t1_overdate_qty
                @ dec2
            s2
            s3
        with frame b.
        down with frame b.
    end.

    put
        "制表人: " at 1
        global_userid
        "日期: " at 70
        today
        .


    {mfreset.i}
	{mfgrptrm.i}
END.
{wbrp04.i &frame-spec = a}

