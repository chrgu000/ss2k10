/* xxioh10inout.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */

for each tr_hist
    no-lock
    where tr_date >= dteA
        and tr_date <= dteB
        and tr_trnbr <= iTr
        and tr_site = sSite
        and tr_loc >= sLocationA
        and tr_loc <= sLocationB
        and tr_part >= sPartA
        and tr_part <= sPartB
        and tr_qty_loc <> 0
    use-index tr_date_trn
    break
    by tr_site
    by tr_loc
    by tr_part
    by tr_serial
:
    assign
        dec1 = 0
        dec2 = 0
        dec3 = 0
        dec4 = 0
        dec5 = 0
        dec6 = 0
        dec7 = 0
        .

    if tr_type = "ISS-SO" then do:
        if tr_qty_loc > 0 then do:
            dec7 = tr_qty_loc.
        end.
        else do:
            if tr_addr = "1001" then
                dec4 = tr_qty_loc.
            else
                dec5 = tr_qty_loc.
        end.
    end.
    else if tr_type = "RCT-WO" then do:
        dec2 = tr_qty_loc.
    end.
    else if tr_type = "RCT-UNP" then do:
        dec3 = tr_qty_loc.
    end.
    else if tr_type = "ISS-UNP" then do:
        dec6 = tr_qty_loc.
    end.
    else if tr_type = "RCT-PO" then do:
        dec1 = tr_qty_loc.
    end.
    else do:
        dec7 = tr_qty_loc.
    end.

    accumulate dec1 (total by tr_serial).
    accumulate dec2 (total by tr_serial).
    accumulate dec3 (total by tr_serial).
    accumulate dec4 (total by tr_serial).
    accumulate dec5 (total by tr_serial).
    accumulate dec6 (total by tr_serial).
    accumulate dec7 (total by tr_serial).

    if last-of(tr_serial) then do:
        find first t1_tmp
            where t1_loc = tr_loc
                and t1_part = tr_part
                and t1_lot = tr_serial
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            assign
                t1_loc = tr_loc
                t1_part = tr_part
                t1_lot = tr_serial
                .
        end.
        assign
            t1_1 = accum total by tr_serial dec1
            t1_2 = accum total by tr_serial dec2
            t1_3 = accum total by tr_serial dec3
            t1_4 = accum total by tr_serial dec4
            t1_5 = accum total by tr_serial dec5
            t1_6 = accum total by tr_serial dec6
            t1_7 = accum total by tr_serial dec7
            .
    end.
end.

for each tr_hist
    no-lock
    where tr_date > dteB
        and tr_trnbr <= iTr
        and tr_site = sSite
        and tr_loc >= sLocationA
        and tr_loc <= sLocationB
        and tr_part >= sPartA
        and tr_part <= sPartB
        and tr_qty_loc <> 0
    use-index tr_date_trn
    break
    by tr_site
    by tr_loc
    by tr_part
    by tr_serial
:
    accumulate tr_qty_loc (total by tr_serial).

    if last-of(tr_part) then do:
        find first t1_tmp
            where t1_loc = tr_loc
                and t1_part = tr_part
                and t1_lot = tr_serial
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            assign
                t1_loc = tr_loc
                t1_part = tr_part
                t1_lot = tr_serial
                .
        end.
        assign
            t1_overdate_qty = accumulate total by tr_serial tr_qty_loc
            .
    end.
end.


