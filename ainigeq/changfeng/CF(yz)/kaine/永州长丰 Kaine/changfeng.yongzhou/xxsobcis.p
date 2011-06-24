/* xxsobcis.p -- */
/* Copyright 200909 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 09/23/2009   By: Kaine Zhang     Eco: *ss_20090923* */
/* SS - 090923.1 By: Kaine Zhang */

/* SS - 090923.1 - RNB
[090923.1]
零星销售发货.左才璋,090921邮件,仓库要把本工作量交到业务部去.
已经建议长丰,在销售出库的时候,通过条码扫描菜单71来做.但长丰未采纳.(物流科长等).
[090923.1]
SS - 090923.1 - RNE */

{mfdtitle.i "090923.1"}

define variable sSoNbr like so_nbr no-undo.
define variable dteEffDate as date no-undo.
define variable iSodLine like sod_line no-undo.
define variable sLocation like loc_loc no-undo.
define variable decShipQty like sod_qty_ord no-undo.
define variable b1 as logical no-undo.
define variable bHasError as logical no-undo.

form
    sSoNbr      colon 12    label "销售订单"
    so_cust     colon 30
    dteEffDate  colon 12    label "生效日期"
    so_site     colon 30    label "地点"
    sLocation   colon 50    label "库位"
with frame a side-labels width 80.
setframelabels(frame a:handle).

form
    iSodLine    colon 12    label "项"
    decShipQty  colon 42    label "发运数量"
    sod_qty_ord colon 12    label "订单数量"
    sod_qty_ship
                colon 42    label "已发数量"
    sod_part    colon 12
    sod_um      colon 42
    pt_desc1    colon 12
    pt_desc2    no-labels
with frame b side-labels width 80.
setframelabels(frame b:handle).


view frame a.
dteEffDate = today.

repeat on endkey undo, leave:
    update
        sSoNbr
        dteEffDate
        sLocation
    with frame a
    editing:
        if frame-field = "sSoNbr" then do:
            {xxkofmfnp1a.i
                so_mstr
                so_nbr
                so_nbr
                "input sSoNbr"
            }
            if recno <> ? then do:
                display
                    so_nbr @ sSoNbr
                    so_cust
                    so_site
                with frame a.
            end.
        end.
        else do:
            readkey.
            apply lastkey.
        end.
    end.

    find first so_mstr
        where so_nbr = sSoNbr
        no-error.
    if not(available(so_mstr)) then do:
        {pxmsg.i &msgnum=609 &errorlevel=3}
        next-prompt sSoNbr with frame a.
        undo, retry.
    end.
    if so_conf_date = ? then do:
        {pxmsg.i &msgnum=621 &errorlevel=3}
        next-prompt sSoNbr with frame a.
        undo, retry.
    end.

    find first loc_mstr
        no-lock
        where loc_site = so_site
            and loc_loc = sLocation
        no-error.
    if not(available(loc_mstr)) then do:
        {pxmsg.i &msgnum=709 &errorlevel=3}
        next-prompt sLocation with frame a.
        undo, retry.
    end.

    detailloop:
    repeat on endkey undo, leave:
        update
            iSodLine
        with frame b
        editing:
            {xxkofmfnp2.i
                sod_det
                sod_nbrln
                "sod_nbr = sSoNbr"
                sod_line
                "input iSodLine"
            }
            if recno <> ? then do:
                display
                    sod_line @ iSodLine
                    sod_qty_ord
                    sod_qty_ship
                    sod_part
                    sod_um
                with frame b.
                find first pt_mstr
                    no-lock
                    where pt_part = sod_part
                    no-error.
                if available(pt_mstr) then
                    display
                        pt_desc1
                        pt_desc2
                    with frame b.
                else
                    display
                        " " @ pt_desc1
                        " " @ pt_desc2
                    with frame b.
            end.
        end.    /* editing */

        find first sod_det
            where sod_nbr = so_nbr
                and sod_line = iSodLine
            no-error.
        if not(available(sod_det)) then do:
            {pxmsg.i &msgnum=764 &errorlevel=3}
            undo, retry.
        end.
        if not(sod_confirm) then do:
            {pxmsg.i &msgnum=646 &errorlevel=3}
            undo, retry.
        end.
        if sod_qty_ord <= 0 or sod_qty_ord <= sod_qty_ship then do:
            {pxmsg.i &msgnum=9024 &errorlevel=3}
            undo, retry.
        end.

        /* block.001.start # check qty */
        do on error undo, retry
            on endkey undo detailloop, retry detailloop:
            update
                decShipQty
            with frame b.
            if decShipQty > sod_qty_ord - sod_qty_ship then do:
                {pxmsg.i &msgnum=7200 &errorlevel=3}
                undo, retry.
            end.
            for each ld_det
                no-lock
                where ld_site = so_site
                    and ld_loc = sLocation
                    and ld_part = sod_part
                    and ld_ref = ""
                    and ld_qty_oh > 0
                use-index ld_loc_p_lot
            :
                accumulate ld_qty_oh (total).
            end.
            if (accum total ld_qty_oh) < decShipQty then do:
                {pxmsg.i &msgnum=9019 &errorlevel=3}
                undo, retry.
            end.
        end.
        /* block.001.finish # check qty */

        {pxmsg.i &msgnum=12 &confirm=b1}
        if b1 then do:
            status default "Shipping...".
            {gprun.i 
                ""xxsobciscim.p""
                "(
                    input sSoNbr,
                    input dteEffDate,
                    input iSodLine,
                    input sLocation,
                    input decShipQty,
                    output bHasError
                )"
            }
            if bHasError then do:
                {pxmsg.i &msgnum=9022}
            end.
            else do:
                {pxmsg.i &msgnum=9021}
            end.
            status default "".
        end.
        else do:
            {pxmsg.i &msgnum=9023}
        end.
    end.

    {pxmsg.i &msgnum=9999}
end.

