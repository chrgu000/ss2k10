/* SS - 091029.1 By: Kaine Zhang */

for each tr_hist
    no-lock
    where tr_date >= dteA
        and tr_date <= dteB
        and tr_type = "ISS-SO"
        and tr_part >= sPartA
        and tr_part <= sPartB
        and tr_site = sSite
        and tr_loc >= sLocationA
        and tr_loc <= sLocationB
        and tr__chr01 <> ""
        and tr_serial <> ""
        and tr_qty_loc = -1
    use-index tr_date_trn
    ,
first pt_mstr
    no-lock
    where pt_part = tr_part
:
    i = integer(pt_drwg_size) no-error.
    if error-status:error then next.
    if i < 1 then next.

    create t1_tmp.
    assign
        t1_date = tr_date
        t1_time = tr__chr01
        t1_part = tr_part
        t1_lot = tr_serial
        t1_column = i
        .
end.
