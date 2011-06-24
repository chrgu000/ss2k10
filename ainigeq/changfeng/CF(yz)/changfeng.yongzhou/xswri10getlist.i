/* xswri10getlist.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/24/2009   By: Kaine Zhang     Eco: *ss_20090724* */

bEnoughQty = yes.
empty temp-table t1_tmp.

for each wod_det
    no-lock
    where wod_lot = s0020
    use-index wod_det
:
    assign
        dec1 = max(wod_bom_qty * dec0060, 0)
        .
    if dec1 <=0 then next.

    for each ld_det
        no-lock
        where ld_site = s0010
            and ld_loc = s0050
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
            sFailPart = wod_part
            decFailQty = max(wod_bom_qty * dec0060, 0)
            .

        for each ld_det
            no-lock
            where ld_site = s0010
                and ld_loc = s0050
                and ld_part = wod_part
                and ld_ref = ""
                and ld_qty_oh > 0
            use-index ld_loc_p_lot
        :
            accumulate ld_qty_oh (total).
        end.
        decFailStore = accum total ld_qty_oh.

        leave.
    end.

end.


