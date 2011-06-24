/* SS - 091029.1 By: Kaine Zhang */

for each t1_tmp
    no-lock
    use-index t1_date_time_part_lot
:
    accumulate t1_column (max).
    accumulate t1_date (min).
    accumulate t1_date (max).

    dec1 = decimal(t1_lot) no-error.

    if error-status:error then do:
        create t2_tmp.
        assign
            t2_date = t1_date
            t2_time = t1_time
            t2_part = t1_part
            t2_lot_start = t1_lot
            t2_lot_finish = t1_lot
            t2_column = t1_column
            .
        next.
    end.

    find last t2_tmp
        where t2_date = t1_date
            and t2_time = t1_time
            and t2_part = t1_part
        use-index t2_date_time_part_lot
        no-error.
    if not(available(t2_tmp)) then do:
        create t2_tmp.
        assign
            t2_date = t1_date
            t2_time = t1_time
            t2_part = t1_part
            t2_lot_start = t1_lot
            t2_lot_finish = t1_lot
            t2_column = t1_column
            .
    end.
    else do:
        dec2 = decimal(t2_lot_finish) no-error.
        if not(error-status:error) and dec1 - dec2 = 1 then do:
            t2_lot_finish = t1_lot.
        end.
        else do:
            create t2_tmp.
            assign
                t2_date = t1_date
                t2_time = t1_time
                t2_part = t1_part
                t2_lot_start = t1_lot
                t2_lot_finish = t1_lot
                t2_column = t1_column
                .
        end.
    end.
end.
assign
    iMin = 1
    iMax = accum max t1_column
    dteMin = accum min t1_date
    dteMax = accum max t1_date
    .
