/* SS - 110811.1 By: Kaine Zhang */

empty temp-table tsummarybom_tmp.
empty temp-table t1_tmp.
empty temp-table t2_tmp.
empty temp-table t3_tmp.

if sParent = "" then do:
    for each pt_mstr
        no-lock
        where pt_domain = global_domain
            and pt_pm_code = "M"
    :
        create tsummarybom_tmp.
        assign
            tsummarybom_par = ""
            tsummarybom_site = pt_site
            tsummarybom_comp = pt_part
            tsummarybom_qty = 1
            .
    end.
end.
else do:
    {gprun.i
        ""xxexportsummarybom.p""
        "(
            input sParent,
            input sParent,
            input ' ',
            input hi_char,
            input sSite,
            input dteEffect,
            input 99,
            input yes
        )"
    }
end.




for each tsummarybom_tmp
    ,
first pt_mstr
    no-lock
    where pt_domain = global_domain
        and pt_part = tsummarybom_comp
        and pt_pm_code = "M"
        and pt_part >= sPartA
        and pt_part <= sPartB
    use-index pt_part
    ,
each wo_mstr
    no-lock
    where wo_domain = global_domain
        and wo_part = tsummarybom_comp
        and wo_site = sSite
        and wo_nbr >= sWoNbrA
        and wo_nbr <= sWoNbrB
        and wo_due_date >= dteA
        and wo_due_date <= dteB
        and (bIncludeCloseWO or wo_status <> "C")
    use-index wo_part
    ,
each wr_route
    no-lock
    where wr_domain = wo_domain
        and wr_lot = wo_lot
    break
    by wr_lot
    by wr_op
:
    if first-of(wr_op) and not(last-of(wr_lot)) then do:
        for each xop_hist
            no-lock
            use-index xop_lot_op_seq
            where xop_domain = wr_domain
                and xop_wo_lot = wr_lot
                and xop_op = wr_op
                and xop_date <= dteDue
            break
            by xop_wo_lot
            by xop_op
            by xop_employee
            by xop_type
        :
            accumulate xop_qty_in (total by xop_type).
            accumulate xop_qty_comp (total by xop_type).
            accumulate xop_qty_reject (total by xop_type).
            accumulate xop_qty_rework (total by xop_type).
            accumulate xop_qty_xc2zzk (total by xop_type).
            accumulate xop_qty_out (total by xop_type).

            if last-of(xop_type) then do:
                find first t1_tmp
                    where t1_wo_lot = xop_wo_lot
                        and t1_op = xop_op
                        and t1_employee = xop_employee
                    no-error.
                if not(available(t1_tmp)) then do:
                    create t1_tmp.
                    assign
                        t1_wo_lot = xop_wo_lot
                        t1_part = wo_part
                        t1_op = xop_op
                        t1_employee = xop_employee
                        .
                end.
                find first t2_tmp
                    where t2_wo_lot = xop_wo_lot
                        and t2_op = xop_op
                    no-error.
                if not(available(t2_tmp)) then do:
                    create t2_tmp.
                    assign
                        t2_wo_lot = xop_wo_lot
                        t2_part = wo_part
                        t2_op = xop_op
                        .
                end.
                case xop_type:
                    when "In" then do:
                        t1_qty_wip = t1_qty_wip + accumu total by xop_type xop_qty_in.
                    end.
                    when "Compx" then do:
                        t1_qty_wip = t1_qty_wip - (accum total by xop_type xop_qty_comp) - (accum total by xop_type xop_qty_reject).
                        t2_qty_xc = t2_qty_xc + accum total by xop_type xop_qty_comp.
                    end.
                    when "CompZ" then do:
                        t1_qty_wip = t1_qty_wip - (accum total by xop_type xop_qty_comp) - (accum total by xop_type xop_qty_reject).
                        t2_qty_zz = t2_qty_zz + accum total by xop_type xop_qty_comp.
                    end.
                    when "TransX2Z" then do:
                        t2_qty_xc = t2_qty_xc - accum total by xop_type xop_qty_xc2zzk.
                        t2_qty_zz = t2_qty_zz + accum total by xop_type xop_qty_xc2zzk.
                    end.
                    when "OutX" then do:
                        t2_qty_xc = t2_qty_xc - accum total by xop_type xop_qty_out.
                    end.
                    when "OutZ" then do:
                        t2_qty_zz = t2_qty_zz - accum total by xop_type xop_qty_out.
                    end.
                end case.
            end.
        end.
    end.

    if last-of(wr_lot) then do:
        find first xwrld_det
            no-lock
            use-index xwrld_lot_op
            where xwrld_domain = global_domain
                and xwrld_wo_lot = wr_lot
                and xwrld_op = wr_op
            no-error.
        if available(xwrld_det) and xwrld_qty_wip <> 0 then do:
            create t1_tmp.
            assign
                t1_wo_lot = wr_lot
                t1_op = wr_op
                t1_qty_wip = xwrld_qty_wip
                .
        end.
    end.
end.


for each t1_tmp
    where t1_qty_wip = 0
:
    delete t1_tmp.
end.
for each t2_tmp
    where t2_qty_xc = 0 and t2_qty_zz = 0
:
    delete t2_tmp.
end.


if sViewLevel = "1" then do:
    {xxwooprp70getdatasum1.i
        &by1 = "t1_part"
        &by2 = "t2_part"
    }
end.
else if sViewLevel = "2" then do:
    {xxwooprp70getdatasum1.i
        &by1 = "t1_wo_lot"
        &by2 = "t2_wo_lot"
    }
end.
else if sViewLevel = "3" then do:
    {xxwooprp70getdatasum1.i
        &by1 = "t1_op"
        &by2 = "t2_op"
    }
end.
else if sViewLevel = "4" then do:
    {xxwooprp70getdatasum1.i
        &by1 = "t1_employee"
        &by2 = "t2_op"
    }
end.



