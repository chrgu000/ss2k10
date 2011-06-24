/* xxioh20inout.i -- */
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
:
    if tr_type = "ISS-SO" then do:
        if tr_qty_loc > 0 then
            assign
                dec1 = tr_qty_loc
                dec2 = 0
                .
        else
            assign
                dec1 = 0
                dec2 = tr_qty_loc
                .
        assign
            dec3 = 0
            dec4 = 0
            dec5 = 0
            dec6 = 0
            .
    end.
    else if tr_type = "RCT-WO" then do:
        dec3 = tr_qty_loc.
        assign
            dec1 = 0
            dec2 = 0
            dec4 = 0
            dec5 = 0
            dec6 = 0
            .
    end.
    else if tr_type = "RCT-UNP" then do:
        dec4 = tr_qty_loc.
        assign
            dec1 = 0
            dec2 = 0
            dec3 = 0
            dec5 = 0
            dec6 = 0
            .
    end.
    else if tr_type = "ISS-UNP" then do:
        dec5 = tr_qty_loc.
        assign
            dec1 = 0
            dec2 = 0
            dec3 = 0
            dec4 = 0
            dec6 = 0
            .
    end.
    else do:
        dec6 = tr_qty_loc.
        assign
            dec1 = 0
            dec2 = 0
            dec3 = 0
            dec4 = 0
            dec5 = 0
            .
    end.

    accumulate dec1 (total by tr_part).
    accumulate dec2 (total by tr_part).
    accumulate dec3 (total by tr_part).
    accumulate dec4 (total by tr_part).
    accumulate dec5 (total by tr_part).
    accumulate dec6 (total by tr_part).

    if last-of(tr_part) then do:
        find first t1_tmp
            where t1_loc = tr_loc
                and t1_part = tr_part
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            assign
                t1_loc = tr_loc
                t1_part = tr_part
                .
        end.
        assign
            t1_1 = accum total by tr_part dec1
            t1_2 = accum total by tr_part dec2
            t1_3 = accum total by tr_part dec3
            t1_4 = accum total by tr_part dec4
            t1_5 = accum total by tr_part dec5
            t1_6 = accum total by tr_part dec6
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
:
    accumulate tr_qty_loc (total by tr_part).

    if last-of(tr_part) then do:
        find first t1_tmp
            where t1_loc = tr_loc
                and t1_part = tr_part
            no-error.
        if not(available(t1_tmp)) then do:
            create t1_tmp.
            assign
                t1_loc = tr_loc
                t1_part = tr_part
                .
        end.
        assign
            t1_overdate_qty = accumulate total by tr_part tr_qty_loc
            .
    end.
end.


