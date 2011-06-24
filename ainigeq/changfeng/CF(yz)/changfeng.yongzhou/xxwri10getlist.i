/* xxwri10getlist.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/27/2009   By: Kaine Zhang     Eco: *ss_20090727* */
/* SS - 090727.1 By: Kaine Zhang */

bEnoughQty = yes.
empty temp-table t1_tmp.
for each wod_det
    no-lock
    where wod_lot = wo_lot
    use-index wod_det
:
    /* validate to issue qty dec1 */
    if wod_qty_req <= 0 or wod_bom_qty <= 0 then do:
        if {1} = "showmsg" then do:
            {pxmsg.i &msgnum=9003 &msgarg1=wod_part}
        end.
        next.
    end.
    dec1 = wod_bom_qty * decBackQty.
    if dec1 > max(0, wod_qty_req - wod_qty_iss) then do:
        if {1} = "showmsg" then do:
            {pxmsg.i &msgnum=9004 &msgart1=wod_part}
        end.
        dec1 = max(0, wod_qty_req - wod_qty_iss).
    end.
    if dec1 = 0 then next.
    
    /* SS - 090924.1 - B */
    dec1 = round(dec1, 4).
    /* SS - 090924.1 - E */

    /* allocated qty detail */
    for each ld_det
        no-lock
        where ld_site = wo_site
            and ld_loc = sLocation
            and ld_part = wod_part
            and ld_ref = ""
            and ld_qty_oh > 0
        use-index ld_loc_p_lot
    :
        create t1_tmp.
        assign
            t1_part = wod_part
            t1_op = wod_op
            t1_lot = ld_lot
            t1_qty = min(dec1, ld_qty_oh)
            .
        dec1 = dec1 - t1_qty.
        if dec1 = 0 then leave.
    end.

    if dec1 > 0 then do:
        assign
            bEnoughQty = no
            sShortPart = wod_part
            .
        leave.
    end.
end.
    
