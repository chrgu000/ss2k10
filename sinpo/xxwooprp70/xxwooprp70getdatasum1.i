/* SS - 110815.1 By: Kaine Zhang */

for each t1_tmp
    break
    by t1_part
    by t1_wo_lot
    by t1_op
    by t1_employee
:
    accumulate t1_qty_wip (total by {&by1}).
    if last-of({&by1}) then do:
        create t3_tmp.
        assign
            t3_part = t1_part
            t3_wo_lot = t1_wo_lot
            t3_op = t1_op
            t3_employee = t1_employee
            t3_qty_wip = accum total by {&by1} t1_qty_wip
            .
        if sViewLevel < "4" then t3_employee = "".
        if sViewLevel < "3" then t3_op = 0.
        if sViewLevel < "2" then t3_wo_lot = "".
    end.
end.


for each t2_tmp
    break
    by t2_part
    by t2_wo_lot
    by t2_op
:
    accumulate t2_qty_xc (total by {&by2}).
    accumulate t2_qty_zz (total by {&by2}).

    if last-of({&by2}) then do:
        if sViewLevel = "1" then do:
            find first t3_tmp
                where t3_part = t2_part
                no-error.
            if not(available(t3_tmp)) then do:
                create t3_tmp.
                t3_part = t2_part.
            end.
        end.
        else if sViewLevel = "2" then do:
            find first t3_tmp
                where t3_part = t2_part
                    and t3_wo_lot = t2_wo_lot
                no-error.
            if not(available(t3_tmp)) then do:
                create t3_tmp.
                t3_part = t2_part.
                t3_wo_lot = t2_wo_lot.
            end.
        end.
        else if sViewLevel = "3" then do:
            find first t3_tmp
                where t3_part = t2_part
                    and t3_wo_lot = t2_wo_lot
                    and t3_op = t2_op
                no-error.
            if not(available(t3_tmp)) then do:
                create t3_tmp.
                t3_part = t2_part.
                t3_wo_lot = t2_wo_lot.
                t3_op = t2_op.
            end.
        end.
        else if sViewLevel = "4" then do:
            find first t3_tmp
                where t3_part = t2_part
                    and t3_wo_lot = t2_wo_lot
                    and t3_op = t2_op
                    and t3_employee = ""
                no-error.
            if not(available(t3_tmp)) then do:
                create t3_tmp.
                t3_part = t2_part.
                t3_wo_lot = t2_wo_lot.
                t3_op = t2_op.
                t3_employee = "".
            end.
        end.

        assign
            t3_qty_xc = accum total by {&by2} t2_qty_xc
            t3_qty_zz = accum total by {&by2} t2_qty_zz
            .
    end.
end.




