/* SS - 091029.1 By: Kaine Zhang */

do dteD = dteMin to dteMax:
    find first t2_tmp
        no-lock
        where t2_date = dteD
            and not(t2_printed)
        use-index t2_date_time_part_lot
        no-error.
    if available(t2_tmp) then
        put
            unformatted
            "~"" at 1
            t2_date
            "~""
            .

    repeat while(available(t2_tmp)):
        do i = iMin to iMax:
            find first t2_tmp
                where t2_date = dteD
                    and t2_column = i
                    and not(t2_printed)
                use-index t2_date_time_part_lot
                no-error.
            if available(t2_tmp) then do:
                sPut = t2_part + sDelimiter
                    + (t2_lot_start + "-"
                        + (if t2_lot_finish = t2_lot_start then "" else t2_lot_finish)
                    )
                    + sDelimiter
                    + string(t2_time, "xx:xx") + sDelimiter
                    .
                t2_printed = yes.
            end.
            else
                sPut = fill(sDelimiter, 3).
            if i = 1 then
                put
                    unformatted
                    sPut at 1
                    .
            else
                put
                    unformatted
                    sPut
                    .
        end.
        find first t2_tmp
            no-lock
            where t2_date = dteD
                and not(t2_printed)
            use-index t2_date_time_part_lot
            no-error.
    end.
end.

