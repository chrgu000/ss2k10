/* SS - 091223.1 By: Kaine Zhang */

{mfdtitle.i "091223.1"}

define variable sWoNbr like wo_nbr no-undo.
define variable sWoLot like wo_lot no-undo.
define variable bConfirm as logical no-undo.
define variable bDone as logical no-undo.
define variable sInputFile as character no-undo.
define variable sOutputFile as character no-undo.

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
with frame a side-labels width 80.
setframelabels(frame a:handle).



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


    bConfirm=yes.
    {pxmsg.i &msgnum=12 &Confirm=bConfirm}

    if bConfirm then
        cimlp:
        do transaction on error undo, leave:
            assign
                sInputFile = "tmp." + string(today, "99999999") + string(time, "99999") + mfguser + "woc.in"
                sOutputFile = "tmp." + string(today, "99999999") + string(time, "99999") + mfguser + "woc.out"
                .
            
            {xxwoclosecim.i}

            bDone = yes.
            if bDone then do:
                /* everything is ok */
                {pxmsg.i &msgnum=9001}
            end.
            else do:
                /* fail, donot issue */
                {pxmsg.i &msgnum=9002}
            end.
        end.
end.

