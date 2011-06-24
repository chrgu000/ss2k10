/* xxwri10.p -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/27/2009   By: Kaine Zhang     Eco: *ss_20090727* */
/* SS - 090727.1 By: Kaine Zhang */

{mfdtitle.i "090819.1"}

define variable sWoNbr like wo_nbr no-undo.
define variable sWoLot like wo_lot no-undo.
define variable sSite like loc_site no-undo.
define variable sLocation like loc_loc no-undo.
define variable decBackQty like wo_qty_ord no-undo.
define variable bConfirm as logical no-undo.
define variable sInputFile as character no-undo.
define variable sOutputFile as character no-undo.
define variable bDone as logical no-undo.
define variable bEnoughQty as logical no-undo.
define variable sShortPart like pt_part no-undo.
define variable dec1 as decimal no-undo.
define variable iTr as integer no-undo.
define temp-table t1_tmp no-undo
    field t1_part like wod_part
    field t1_op like wod_op
    field t1_lot like ld_lot
    field t1_qty like wod_qty_req
    .


form
    sWoNbr      colon 10    label "工单"
    sWoLot      colon 42    label "标"
    wo_site     colon 65    label "Site"
    wo_status   no-labels
    wo_part     colon 10    label "Part"
    wo_qty_ord  colon 65
    pt_desc1    colon 10    label "说明"
    pt_desc2    no-labels   format "x(19)"
    wo_qty_comp colon 65    label "Comp Qty"
    sLocation   colon 10    label "库位"
    loc_desc    no-labels
    decBackQty  colon 65    label "回冲数量"
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
    t1_part
    t1_lot
    t1_qty
with frame b down width 80.
setframelabels(frame b:handle).




mainlp:
repeat on endkey undo, leave:
    /* block.001.start
     *  select work order, validate it, and display information.
     */
    do on endkey undo mainlp, leave mainlp:
        update
            sWoNbr
            sWoLot
        with frame a
        editing:
            if frame-field = "sWoNbr" then do:
                {mfnp.i
                    wo_mstr
                    sWoNbr
                    wo_nbr
                    sWoNbr
                    wo_nbr
                    wo_nbr
                }
            end.
            else if frame-field = "sWoLot" then do:
                {mfnp.i
                    wo_mstr
                    sWoLot
                    wo_lot
                    sWoLot
                    wo_lot
                    wo_lot
                }
            end.
            else do:
                readkey.
                apply lastkey.
            end.
            if recno <> ? then do:
                display
                    wo_nbr @ sWoNbr
                    wo_lot @ sWoLot
                    wo_part
                    wo_site
                    wo_qty_ord
                    wo_qty_comp
                    wo_status
                with frame a.
                for first pt_mstr
                    no-lock
                    where pt_part = wo_part
                :
                end.
                if available(pt_mstr) then do:
                    display
                        pt_desc1
                        pt_desc2
                    with frame a.
                end.
            end.
        end.
        
        if sWoNbr = "" and sWoLot = "" then do:
            {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3} /*  WORK ORDER DOES NOT EXIST.*/
            undo, retry.
        end.
        else if sWoNbr = "" and sWoLot <> "" then do:
            find first wo_mstr
                exclusive-lock
                where wo_lot = sWoLot
                use-index wo_lot
                no-error.
        end.
        else if sWoNbr <> "" and sWoLot = "" then do:
            find first wo_mstr
                exclusive-lock
                where wo_nbr = sWoNbr
                use-index wo_nbr
                no-error.
        end.
        else do:
            find first wo_mstr
                exclusive-lock
                where wo_nbr = sWoNbr
                    and wo_lot = sWoLot
                use-index wo_nbr
                no-error.
        end.
        if not(available(wo_mstr)) then do:
            {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3} /*  WORK ORDER DOES NOT EXIST.*/
            undo, retry.
        end.
        if wo_status <> "R" and wo_status <> "A" then do:
            {pxmsg.i
                &msgnum=525
                &msgarg1=wo_status
            }
            undo, retry.
        end.
        assign
            sWoNbr = wo_nbr
            sWoLot = wo_lot
            sSite = wo_site
            .
        display
            sWoNbr
            sWoLot
            wo_part
            wo_site
            wo_qty_ord
            wo_qty_comp
            wo_status
        with frame a.
        for first pt_mstr
            no-lock
            where pt_part = wo_part
        :
        end.
        if available(pt_mstr) then
            display
                pt_desc1
                pt_desc2
            with frame a.
        else
            display
                "" @ pt_desc1
                "" @ pt_desc2
            with frame a.
    end.
    /* block.001.finish */

    do on endkey undo mainlp, retry mainlp
        on error undo, retry:
        update
            sLocation
            decBackQty
        with frame a.

        for first loc_mstr
            no-lock
            where loc_site = wo_site
                and loc_loc = sLocation
        :
        end.
        if not(available(loc_mstr)) then do:
            {pxmsg.i &msgnum=709}
            undo, retry.
        end.
        display
            loc_desc
        with frame a.

        {xxwri10getlist.i ""showmseeage""}
        
        clear frame b all no-pause.
        if bEnoughQty then do:
            for each t1_tmp:
                display
                    t1_part
                    t1_lot
                    t1_qty
                with frame b.
                down with frame b.
            end.
        end.
        else do:
            {pxmsg.i &msgnum=9005 &msgarg1=sShortPart}
            undo, retry.
        end.
    end.

    bConfirm=yes.
    {pxmsg.i &msgnum=12 &Confirm=bConfirm}

    bDone = no.
    if bConfirm then
        cimlp:
        do transaction on error undo, leave:
            assign
                sInputFile = "tmp." + string(today, "99999999") + string(time, "99999") + mfguser + "wri.in"
                sOutputFile = "tmp." + string(today, "99999999") + string(time, "99999") + mfguser + "wri.out"
                .
            find last tr_hist
                no-lock
                use-index tr_trnbr
                no-error.
            iTr = if available(tr_hist) then tr_trnbr else 0.
            
            {xxwri10cim.i}

            bDone = yes.
        end.

    if bDone then do:
        /* everything is ok */
        {pxmsg.i &msgnum=9001}
    end.
    else do:
        /* fail, donot issue */
        {pxmsg.i &msgnum=9002}
    end.
end.
