/* xxbackward.p ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100512.1 By: Kaine Zhang */

{mfdtitle.i "1+"}

define variable sBarcode as character format "x(45)" no-undo.
define variable sWoPart like wo_part no-undo.
define variable sLot like ld_lot no-undo.

define variable sWoNbr like wo_nbr no-undo.
define variable sWoLot like wo_lot no-undo.
define variable decWoQtyOrder like wo_qty_ord no-undo.
define variable decWoQtyBefore like wo_qty_ord no-undo.
define variable decWoQtyThisLot like wo_qty_ord no-undo.

define variable sWodPtDesc as character format "x(24)" no-undo.
define variable decWodQtyBefore like wo_qty_ord no-undo.
define variable decWodQtyThisLot like wo_qty_ord no-undo.

define variable dec1 as decimal format "->>>,>>9.9<<" no-undo.

define temp-table t1_tmp no-undo
    field t1_seq like tr_trnbr
    field t1_part like ld_part
    field t1_lot like ld_lot
    field t1_ref like ld_ref
    field t1_qty as decimal format "->>>,>>9.9<<"
    .

form   
    sBarcode colon 15 label "条码"
    sWoPart colon 15 label "物料"
    sLot colon 15 label "批号"
    skip
with frame a side-labels width 80.
setframelabels(frame a:handle).

    



{wbrp01.i}
repeat on endkey undo, leave:
    if c-application-mode <> 'web' then
        set
            sBarcode
        with frame a .

    {wbrp06.i
        &command = update
        &fields = "
            sBarcode
            "
        &frm = "a"
    }



    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i sBarcode      }
    end.

    if sBarcode = "" then do:
        {pxmsg.i &msgnum = 40}
        undo, retry.
    end.

    {gprun.i
        ""xxgetpartlotfrombarcode.p""
        "(
            input sBarcode,
            output sWoPart,
            output sLot
        )"
    }
    display
        sWoPart
        sLot
    with frame a.

    if sWoPart = "" or sLot = "" then do:
        {pxmsg.i &msgnum = 16}
        undo, retry.
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

    empty temp-table t1_tmp.

    /* 输出成品基本信息 */
    {xxbackward001.i}


    /* 输出工单基本信息 */
    {xxbackward002.i}

    /* 输出追溯信息 */
    {xxbackward003.i}

    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}






