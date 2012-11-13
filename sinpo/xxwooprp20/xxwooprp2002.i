/* SS - 100603.1 By: Kaine Zhang */
/* SS - 100605.1 By: Kaine Zhang */
/* SS - 100624.1 By: Kaine Zhang */
/* SS - 100715.1 By: Kaine Zhang */

/* SS - 100602.1 - RNB
[100624.1]
20100613下午的培训上,陈涛,吴师傅提出的需求:
在汇总方式打印的时候:
1. 对于"R"状态工单.即使它的某工序未发生过反馈,投入,等动作,也将该道工序显示出来.
2. 显示工作中心的说明.
[100624.1]
[100605.1]
1. 成品,如果输入为空,则默认查找范围为所有制造件.
2. 汇总显示中,将完成人员的名称,相加后显示出来.
[100605.1]
[100602.1]
ref: 20100517.新天系统优化方案 -1.0.simon.doc
[100602.1]
SS - 100602.1 - RNE */

put
    unformatted
    "ExcelFile;wooprp20sum" at 1
    "SaveFile;"
        + string(today, "99999999")
        + replace(string(time, "HH:MM:SS"), ":", "")
        + "wooprp20sum" at 1
    "BeginRow;1" at 1
    .

run putHeadersum.

/* SS - 100701.1 - B
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
        /* SS - 100605.1 - B */
        and (bIncludeCloseWO or wo_status <> "C")
        /* SS - 100605.1 - E */
    use-index wo_part
    ,
each xop_hist
    no-lock
    where xop_domain = wo_domain
        and xop_wo_lot = wo_lot
        and xop_date >= dteA
        and xop_date <= dteB
    use-index xop_lot_op_seq
    ,
first wr_route
    no-lock
    where wr_domain = xop_domain
        and wr_lot = xop_wo_lot
        and wr_op = xop_op
    break
    by xop_wo_lot
    by xop_op
:
    assign
        decBuCha = 0
        decTotal = 0
        .
    find first op_hist
        no-lock
        where op_domain = xop_domain
            and op_trnbr = xop_qad_trnbr
        use-index op_trnbr
        no-error.
    if available(op_hist) then
        assign
            decBuCha = decimal(op__qad01)
            decTotal = decimal(op__qad02)
            no-error
            .

    if xop_type = "CompX" then
        assign
            decCompX = xop_qty_comp
            decCompZ = 0
            decOutX = 0
            decOutZ = 0
            .
    else if xop_type = "CompZ" then
        assign
            decCompX = 0
            decCompZ = xop_qty_comp
            decOutX = 0
            decOutZ = 0
            .
    else if xop_type = "OutX" then
        assign
            decCompX = 0
            decCompZ = 0
            decOutX = xop_qty_out
            decOutZ = 0
            .
    else if xop_type = "OutZ" then
        assign
            decCompX = 0
            decCompZ = 0
            decOutX = 0
            decOutZ = xop_qty_out
            .
    else
        assign
            decCompX = 0
            decCompZ = 0
            decOutX = 0
            decOutZ = 0
            .


    accumulate xop_qty_in (total by xop_op).
    accumulate xop_qty_comp (total by xop_op).
    accumulate xop_qty_reject (total by xop_op).
    accumulate xop_qty_rework (total by xop_op).
    accumulate xop_qty_out (total by xop_op).
    accumulate xop_qty_xc2zzk (total by xop_op).
    accumulate decBuCha (total by xop_op).
    accumulate decTotal (total by xop_op).
    accumulate decCompX (total by xop_op).
    accumulate decCompZ (total by xop_op).
    accumulate decOutX (total by xop_op).
    accumulate decOutZ (total by xop_op).
    accumulate xop_qty_xc2zzk (total by xop_op).


    /* SS - 100605.1 - B */
    if first-of(xop_op) then
        assign
            sWorkerIDList = ""
            sWorkerNameList = ""
            .
    if xop_type = "CompX" or xop_type = "CompZ" then do:
        if lookup(sWorkerIDList, xop_employee) = 0 then
            sWorkerIDList = sWorkerIDList + xop_employee + ",".
    end.
    /* SS - 100605.1 - E */

    if last-of(xop_op) then do:
        /* SS - 100605.1 - B */
        repeat i = 1 to num-entries(sWorkerIDList):
            find first emp_mstr
                no-lock
                where emp_domain = global_domain
                    and emp_addr = entry(i, sWorkerIDList)
                no-error.
            if available(emp_mstr) then
                sWorkerNameList = sWorkerNameList + emp_lname + ",".
        end.
        if length(sWorkerNameList) > 0 then
            sWorkerNameList = substring(sWorkerNameList, 1, length(sWorkerNameList, "RAW") - 1, "RAW").
        /* SS - 100605.1 - E */

        put
            unformatted
            wo_part at 1    ";"
            pt_desc1 + pt_desc2 ";"
            xop_wo_nbr        ";"
            xop_op          ";"
            wr_desc         ";"
            accumulate total by xop_op xop_qty_in   ";"
            accumulate total by xop_op xop_qty_comp ";"
            wr_setup                                ";"
            wr_run                                  ";"
            accumulate total by xop_op decBuCha     ";"
            accumulate total by xop_op decTotal     ";"
            accumulate total by xop_op xop_qty_reject       ";"
            accumulate total by xop_op xop_qty_rework       ";"
            accumulate total by xop_op xop_qty_out          ";"
            (accumulate total by xop_op xop_qty_in)
                - (accumulate total by xop_op xop_qty_comp)
                - (accumulate total by xop_op xop_qty_reject)
                ";"
            (accumulate total by xop_op decCompZ)
                - (accumulate total by xop_op decOutZ)
                + (accumulate total by xop_op xop_qty_xc2zzk)
                ";"
            (accumulate total by xop_op decCompX)
                - (accumulate total by xop_op decOutX)
                - (accumulate total by xop_op xop_qty_xc2zzk)
            /* SS - 100605.1 - B */
            ";"
            sWorkerNameList
            /* SS - 100605.1 - E */
            .
    end.
end.
SS - 100701.1 - E */



/* SS - 100715.1 - B
/* SS - 100701.1 - B */
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
    break
    by wo_lot
:
    for each wr_route
        no-lock
        where wr_domain = wo_domain
            and wr_lot = wo_lot
        ,
    first wc_mstr
        no-lock
        where wc_domain = wr_domain
            and wc_wkctr = wr_wkctr
            and wc_mch = wr_mch
    :
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
            put
                unformatted
                wo_part at 1    ";"
                pt_desc1 + pt_desc2 ";"
                wo_nbr        ";"
                wr_op          ";"
                wr_desc         ";"
                wc_desc
                .
        end.
    end.

    for each xop_hist
        no-lock
        where xop_domain = wo_domain
            and xop_wo_lot = wo_lot
            and xop_date >= dteA
            and xop_date <= dteB
        use-index xop_lot_op_seq
        ,
    first wr_route
        no-lock
        where wr_domain = xop_domain
            and wr_lot = xop_wo_lot
            and wr_op = xop_op
        ,
    first wc_mstr
        no-lock
        where wc_domain = wr_domain
            and wc_wkctr = wr_wkctr
            and wc_mch = wr_mch
        break
        by xop_wo_lot
        by xop_op
    :
        assign
            decBuCha = 0
            decTotal = 0
            .
        find first op_hist
            no-lock
            where op_domain = xop_domain
                and op_trnbr = xop_qad_trnbr
            use-index op_trnbr
            no-error.
        if available(op_hist) then
            assign
                decBuCha = decimal(op__qad01)
                decTotal = decimal(op__qad02)
                no-error
                .

        if xop_type = "CompX" then
            assign
                decCompX = xop_qty_comp
                decCompZ = 0
                decOutX = 0
                decOutZ = 0
                .
        else if xop_type = "CompZ" then
            assign
                decCompX = 0
                decCompZ = xop_qty_comp
                decOutX = 0
                decOutZ = 0
                .
        else if xop_type = "OutX" then
            assign
                decCompX = 0
                decCompZ = 0
                decOutX = xop_qty_out
                decOutZ = 0
                .
        else if xop_type = "OutZ" then
            assign
                decCompX = 0
                decCompZ = 0
                decOutX = 0
                decOutZ = xop_qty_out
                .
        else
            assign
                decCompX = 0
                decCompZ = 0
                decOutX = 0
                decOutZ = 0
                .


        accumulate xop_qty_in (total by xop_op).
        accumulate xop_qty_comp (total by xop_op).
        accumulate xop_qty_reject (total by xop_op).
        accumulate xop_qty_rework (total by xop_op).
        accumulate xop_qty_out (total by xop_op).
        accumulate xop_qty_xc2zzk (total by xop_op).
        accumulate decBuCha (total by xop_op).
        accumulate decTotal (total by xop_op).
        accumulate decCompX (total by xop_op).
        accumulate decCompZ (total by xop_op).
        accumulate decOutX (total by xop_op).
        accumulate decOutZ (total by xop_op).
        accumulate xop_qty_xc2zzk (total by xop_op).


        if first-of(xop_op) then
            assign
                sWorkerIDList = ""
                sWorkerNameList = ""
                .
        if xop_type = "CompX" or xop_type = "CompZ" then do:
            if lookup(sWorkerIDList, xop_employee) = 0 then
                sWorkerIDList = sWorkerIDList + xop_employee + ",".
        end.

        if last-of(xop_op) then do:
            repeat i = 1 to num-entries(sWorkerIDList):
                find first emp_mstr
                    no-lock
                    where emp_domain = global_domain
                        and emp_addr = entry(i, sWorkerIDList)
                    no-error.
                if available(emp_mstr) then
                    sWorkerNameList = sWorkerNameList + emp_lname + ",".
            end.
            if length(sWorkerNameList) > 0 then
                sWorkerNameList = substring(sWorkerNameList, 1, length(sWorkerNameList, "RAW") - 1, "RAW").

            put
                unformatted
                wo_part at 1    ";"
                pt_desc1 + pt_desc2 ";"
                xop_wo_nbr        ";"
                xop_op          ";"
                wr_desc         ";"
                wc_desc         ";"
                accumulate total by xop_op xop_qty_in   ";"
                accumulate total by xop_op xop_qty_comp ";"
                wr_setup                                ";"
                wr_run                                  ";"
                accumulate total by xop_op decBuCha     ";"
                accumulate total by xop_op decTotal     ";"
                accumulate total by xop_op xop_qty_reject       ";"
                accumulate total by xop_op xop_qty_rework       ";"
                accumulate total by xop_op xop_qty_out          ";"
                (accumulate total by xop_op xop_qty_in)
                    - (accumulate total by xop_op xop_qty_comp)
                    - (accumulate total by xop_op xop_qty_reject)
                    ";"
                (accumulate total by xop_op decCompZ)
                    - (accumulate total by xop_op decOutZ)
                    + (accumulate total by xop_op xop_qty_xc2zzk)
                    ";"
                (accumulate total by xop_op decCompX)
                    - (accumulate total by xop_op decOutX)
                    - (accumulate total by xop_op xop_qty_xc2zzk)
                ";"
                sWorkerNameList
                .
        end.
    end.
end.
/* SS - 100701.1 - E */
SS - 100715.1 - E */




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
    use-index wr_lot
    ,
first wc_mstr
    no-lock
    where wc_domain = wr_domain
        and wc_wkctr = wr_wkctr
        and wc_mch = wr_mch
    use-index wc_wkctr
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
            put
                unformatted
                sHasIssue at 1 ";"
                wo_part       ";"
                pt_desc1 + pt_desc2 ";"
                wo_nbr        ";"
                wr_op          ";"
                wr_desc         ";"
                wc_mch      ";"
                wc_desc
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
        break
            by xop_wo_lot
            by xop_op
        :
            assign
                decBuCha = 0
                decTotal = 0
                .
            find first op_hist
                no-lock
                where op_domain = xop_domain
                    and op_trnbr = xop_qad_trnbr
                use-index op_trnbr
                no-error.
            if available(op_hist) then
                assign
                    decBuCha = decimal(op__qad01)
                    decTotal = decimal(op__qad02)
                    no-error
                    .

            if xop_type = "CompX" then
                assign
                    decCompX = xop_qty_comp
                    decCompZ = 0
                    decOutX = 0
                    decOutZ = 0
                    .
            else if xop_type = "CompZ" then
                assign
                    decCompX = 0
                    decCompZ = xop_qty_comp
                    decOutX = 0
                    decOutZ = 0
                    .
            else if xop_type = "OutX" then
                assign
                    decCompX = 0
                    decCompZ = 0
                    decOutX = xop_qty_out
                    decOutZ = 0
                    .
            else if xop_type = "OutZ" then
                assign
                    decCompX = 0
                    decCompZ = 0
                    decOutX = 0
                    decOutZ = xop_qty_out
                    .
            else
                assign
                    decCompX = 0
                    decCompZ = 0
                    decOutX = 0
                    decOutZ = 0
                    .


            accumulate xop_qty_in (total by xop_op).
            accumulate xop_qty_comp (total by xop_op).
            accumulate xop_qty_reject (total by xop_op).
            accumulate xop_qty_rework (total by xop_op).
            accumulate xop_qty_out (total by xop_op).
            accumulate xop_qty_xc2zzk (total by xop_op).
            accumulate decBuCha (total by xop_op).
            accumulate decTotal (total by xop_op).
            accumulate decCompX (total by xop_op).
            accumulate decCompZ (total by xop_op).
            accumulate decOutX (total by xop_op).
            accumulate decOutZ (total by xop_op).
            accumulate xop_qty_xc2zzk (total by xop_op).


            if first-of(xop_op) then
                assign
                    sWorkerIDList = ""
                    sWorkerNameList = ""
                    .
            if xop_type = "CompX" or xop_type = "CompZ" then do:
                if lookup(sWorkerIDList, xop_employee) = 0 then
                    sWorkerIDList = sWorkerIDList + xop_employee + ",".
            end.

            if last-of(xop_op) then do:
                repeat i = 1 to num-entries(sWorkerIDList):
                    find first emp_mstr
                        no-lock
                        where emp_domain = global_domain
                            and emp_addr = entry(i, sWorkerIDList)
                        no-error.
                    if available(emp_mstr) then
                        sWorkerNameList = sWorkerNameList + emp_lname + ",".
                end.
                if length(sWorkerNameList) > 0 then
                    sWorkerNameList = substring(sWorkerNameList, 1, length(sWorkerNameList, "RAW") - 1, "RAW").

                put
                    unformatted
                    sHasIssue at 1 ";"
                    wo_part        ";"
                    pt_desc1 + pt_desc2 ";"
                    xop_wo_nbr        ";"
                    xop_op          ";"
                    wr_desc         ";"
                    wc_mch          ";"
                    wc_desc         ";"
                    accumulate total by xop_op xop_qty_in   ";"
                    accumulate total by xop_op xop_qty_comp ";"
                    wr_setup                                ";"
                    wr_run                                  ";"
                    accumulate total by xop_op decBuCha     ";"
                    accumulate total by xop_op decTotal     ";"
                    accumulate total by xop_op xop_qty_reject       ";"
                    accumulate total by xop_op xop_qty_rework       ";"
                    accumulate total by xop_op xop_qty_out          ";"
                    (accumulate total by xop_op xop_qty_in)
                        - (accumulate total by xop_op xop_qty_comp)
                        - (accumulate total by xop_op xop_qty_reject)
                        ";"
                    (accumulate total by xop_op decCompZ)
                        - (accumulate total by xop_op decOutZ)
                        + (accumulate total by xop_op xop_qty_xc2zzk)
                        ";"
                    (accumulate total by xop_op decCompX)
                        - (accumulate total by xop_op decOutX)
                        - (accumulate total by xop_op xop_qty_xc2zzk)
                    ";"
                    sWorkerNameList
                    .
            end.
        end.
    end.
end.
/* SS - 100715.1 - E */



