/* SS - 100603.1 By: Kaine Zhang */
/* SS - 100701.1 By: Kaine Zhang */
/* SS - 100715.1 By: Kaine Zhang */

put unformatted
    "ExcelFile;wooprp20" at 1
    "SaveFile;"
        + string(today, "99999999")
        + replace(string(time, "HH:MM:SS"), ":", "")
        + "wooprp20" at 1
    "BeginRow;1" at 1
    .

run putHeader.


/* SS - 100715.1 - B */
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
        and (bIncludeCloseWO or wo_status <> "C")
    use-index wo_part
    ,
each wr_route
    no-lock
    where wr_domain = wo_domain
        and wr_lot = wo_lot
    ,
first wc_mstr
    no-lock
    where wc_domain = wr_domain
        and wc_wkctr = wr_wkctr
        and wc_mch = wr_mch
    break
    by wo_lot
    by wr_op
:
    for first tr_hist
        no-lock
        where tr_domain = global_domain
            and tr_nbr = wo_nbr
            and tr_lot = wo_lot
            and tr_type = "ISS-WO"
        use-index tr_nbr_eff
    :
    end.
    sHasIssue = if available(tr_hist) then "*" else "".

    if not
        (
            can-find
            (first xop_hist
                no-lock
                where xop_domain = wr_domain
                    and xop_wo_lot = wr_lot
                    and xop_op = wr_op
                    and xop_date >= dteA
                    and xop_date <= dteB
                use-index xop_lot_op_seq
            )
        )
    then do:
        if wo_status = "R" then do:
            put unformatted
                sHasIssue at 1 ";"
                wo_part       ";"
                pt_desc1 + pt_desc2 ";"
                wo_nbr         ";"
                wr_op          ";"
                wr_desc         ";"
                wc_mch          ";"
                wc_desc         ";"
                .
        end.
    end.
    else do:
        for each xop_hist
            no-lock
            where xop_domain = wo_domain
                and xop_wo_lot = wo_lot
                and xop_op = wr_op
                and xop_date >= dteA
                and xop_date <= dteB
            use-index xop_lot_op_seq
        :

       assign usrname = ""
              empname = "".
       find first usr_mstr no-lock where usr_userid = xop_employee no-error.
       if available usr_mstr then do:
          assign usrname = usr_name.
       end.

       find first op_hist no-lock use-index op_trnbr
            where op_domain = xop_domain and op_trnbr = xop_qad_trnbr no-error.
       if available op_hist then do:
           find first emp_mstr no-lock where emp_domain = op_domain
                  and emp_addr = op_emp no-error.
           if available emp_mstr then do:
                 assign empname = emp_lname.
           end.
        end.

            put unformatted
                sHasIssue at 1 ";"
                wo_part       ";"
                pt_desc1 + pt_desc2 ";"
                wo_nbr         ";"
                wr_op          ";"
                wr_desc         ";"
                wc_mch          ";"
                wc_desc         ";"
                .

            if xop_type = "In" then do:
                put unformatted
                    xop_qty_in ";"
                    xop_date ";"
                    empname ";"
                    ";;;;;;;;;;;"
                    .
            end.
            else if xop_type = "CompX" or xop_type = "CompZ" then do:
                put unformatted
                    ";;" empname ";"
                    usrname ";"
                    xop_qty_comp ";"
                    xop_date ";"
                    .
                if available(op_hist) then do:
                    put unformatted
                        /* SS - 110221.1 - B
                        op_act_setup       ";"
                        SS - 110221.1 - E */
                        /* SS - 110221.1 - B */
                        (if xop_qty_comp = 0 then 0 else op_act_setup) ";"
                        /* SS - 110221.1 - E */
                        op_act_run ";"
                        op__qad01 ";"
                        op__qad02 ";"
                        .
                end.
                else do:
                    put unformatted
                        ";;;;"
                        .
                end.
                put unformatted
                    xop_qty_reject  ";"
                    xop_qty_rework  ";"
                    ";;"
                    .
            end.
            else if xop_type = "OutX" or xop_type = "OutZ" then do:
                put unformatted
                    ";;;;;;;;;;;;"
                    xop_qty_out     ";"
                    xop_date        ";"
                    .
            end.
            else do:
                put unformatted
                    ";;;;;;;;;;;;;"
                    .
            end.
            put unformatted
                xop_ld_qty_wip    ";"
                xop_ld_qty_zz     ";"
                xop_ld_qty_xc
                .
        end.
    end.
end.
/* SS - 100715.1 - E */






