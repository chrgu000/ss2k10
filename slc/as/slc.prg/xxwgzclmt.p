/* xxwgzclmt.p ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100629.1 By: Kaine Zhang */

/* SS - 100629.1 - RNB
[100702.1]
1. 对于未挂账的库存,将改变它们的价格.以如实体现库存价值.
2. 相应的,做负数入库,正数入库.
[100702.1]
[100629.1]
前期未挂账的账目(,在本程序中进行处理.
处理后,将挂账日期设为今天.
[100629.1]
SS - 100629.1 - RNE */

{mfdtitle.i "100629.1"}

define var yr like glc_year.
define var per like glc_per.
define var vend like po_vend.
define var part like pt_part.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset like mfc_logical.
define var update-yn as logical.
define var site like in_site init "10000".
define var tnbr as char.

/* SS - 100702.1 - B */
define variable decWgzLdQty as decimal no-undo.
define variable decWgzLdAmt as decimal no-undo.
define variable decNewAmt as decimal no-undo.
/* SS - 100702.1 - E */

define temp-table tt1
    field tt1_f1 like po_vend
    field tt1_f2 like pt_part
    field tt1_f3 like pt_desc1
    field tt1_f4 like ld_qty_oh
    field tt1_f5 like pt_price
    field tt1_f6 like pt_price
    field tt1_f7 as char format "x(4)"
    field tt1_f8 as int
    field tt1_f9 as int
    .

form
    yr colon 25
    per colon 25
with frame a width 80 side-labels attr-space.

setFramelabels(frame a:handle).


form
    tt1_f1 label "供应商"
    tt1_f2 label "物料号"
    tt1_f4 label "数量"
    tt1_f7 label "期间"
    tt1_f5 label "期间价格"
    tt1_f6 label "本期价格"
with frame b width 80 5 down scroll 1.

mainloop:
repeat with frame a:

    hide frame b no-pause.

    update yr per with frame a.

    find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
    if not avail glc_cal then do:
        message "错误: 期间不存在".
        next.
    end.
    if glc_user1 <> "" then do:
        message "错误: 挂账已经关闭".
        next.
    end.

    find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per no-lock no-error.
    if not avail xxzgp_det then do:
        message "错误: 暂估价格没有处理".
        next.
    end.

    empty temp-table tt1.

    
    for each xxgzd_det
        no-lock
        where xxgzd_domain = global_domain
            and not(xxgzd_is_confirm)
            and not(xxgzd_year = yr and xxgzd_per = per)
    :
        find first xxzgp_det 
            where xxzgp_domain = global_domain 
                and xxzgp_year = yr 
                and xxzgp_per = per
                and xxzgp_vend = xxgzd_vend 
                and xxzgp_part = xxgzd_part 
                and xxzgp_type = "正常" 
            no-lock
            no-error.
        if not avail xxzgp_det then next.

        create tt1.
        assign 
            tt1_f1 = xxgzd_vend
            tt1_f2 = xxgzd_part
            tt1_f4 = xxgzd_qty
            tt1_f5 = xxgzd_price
            tt1_f6 = xxzgp_price
            tt1_f7 = substring(string(xxgzd_year),3,2) + string(xxgzd_per,"99")
            tt1_f8 = xxgzd_year
            tt1_f9 = xxgzd_per
            .
    end.

    find first tt1 no-lock no-error.
    if not avail tt1 then do:
        message "无记录".
        next.
    end.

    loop1:
    repeat on error undo,retry:

        {xuview.i
             &buffer = tt1
             &scroll-field = tt1_f1
             &framename = "b"
             &framesize = 5
             &display1     = tt1_f1
             &display2     = tt1_f2
             &display3     = tt1_f4
             &display4     = tt1_f7
             &display5     = tt1_f5
             &display6     = tt1_f6
             &searchkey    = true
             &logical1     = false
             &first-recid  = first-recid
             &exitlabel = loop1
             &exit-flag = true
             &record-id = tt_recid
             &cursordown = "
                         "
             &cursorup   = "

                         "
             }


        if keyfunction(lastkey) = "end-error" then do:
            update-yn = no.
      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       if update-yn = yes then next mainloop.
       else next loop1.
        end.

        if keyfunction(lastkey) = "go" then do:
            update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next loop1.
      for each tt1 no-lock,
        each xxgzd_det where xxgzd_domain = global_domain and xxgzd_vend = tt1_f1 and xxgzd_part = tt1_f2
            and xxgzd_year = tt1_f8 and xxgzd_per  = tt1_f9 :
        if tt1_f6 > 0 then do:
            
            /* SS - 100702.1 - B */
            for each xxld_det
                where xxld_vend = xxgzd_vend
                    and xxld_part = xxgzd_part
                    and 
                    (xxld_year < yr
                        or (xxld_year = yr and xxld_per < per)
                    )
                    and xxld_qty <> 0
                    and not(xxld_confirm_gz_price)
            :
                accumulate xxld_qty (total).
                accumulate (xxld_qty * xxld_tax_price) (total).
                accumulate (xxld_qty * tt1_f6) (total).
                assign
                    xxld_tax_price = tt1_f6
                    xxld_price = xxld_tax_price / ( 1 + xxld_tax_pct / 100 ).
                    .
            end.
            decWgzLdQty = accum total xxld_qty.
            decWgzLdAmt = accum total (xxld_qty * xxld_tax_price).
            decNewAmt = accum total (xxld_qty * tt1_f6).
            /* SS - 100702.1 - E */
            
            /* 事务处理 */
            create xxtr_hist.
            assign xxtr_domain = global_domain
                                xxtr_site = site
                                xxtr_year = yr
                                xxtr_per    = per
                                xxtr_vend = xxgzd_vend
                                xxtr_type = "RCT-WGZ"
                                xxtr_sort = "IN"
                                xxtr_part = xxgzd_part
                                xxtr_tax_pct = xxgzd_tax_pct
                                xxtr_price = xxgzd_price
                                xxtr_qty   = - decWgzLdQty
                                xxtr_amt   = - decWgzLdAmt
                                xxtr_effdate  = today
                                xxtr_time  = time
                                xxtr_rmks  = "未挂账处理"
                                .

                    /*增加总帐记录*/
                    tnbr = "PO" + substring(string(yr,"9999"),3,2) + string(per,"99") .
                    find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins tnbr no-error.
                    if avail xxglt_det then tnbr = tnbr + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
                    else tnbr = tnbr + "000001".

                    create  xxglt_det.
                    assign  xxglt_domain = global_domain
                                    xxglt_ref = tnbr
                                    xxglt_year = yr
                                    xxglt_per  = per
                                    xxglt_type = "POWGZ"
                                    xxglt_nbr  = ""
                                    xxglt_line = 0
                                    xxglt_effdate = today
                                    xxglt_date = today
                                    xxglt_price = xxgzd_price
                                    xxglt_part  = xxgzd_part
                                    xxglt_qty   = - decWgzLdQty
                                    xxglt_amt   = - decWgzLdAmt
                                    .
            assign
                xxgzd_is_confirm = yes
                xxgzd_confirm_date = today
                .
                
            xxtr_glnbr = xxglt_ref.

            create xxtr_hist.
            assign xxtr_domain = global_domain
                                xxtr_site = site
                                xxtr_year = yr
                                xxtr_per    = per
                                xxtr_vend = xxgzd_vend
                                xxtr_type = "RCT-WGZ"
                                xxtr_sort = "IN"
                                xxtr_part = xxgzd_part
                                xxtr_tax_pct = xxgzd_tax_pct
                                xxtr_price = tt1_f6
                                xxtr_qty   = decWgzLdQty
                                xxtr_amt   = decNewAmt
                                xxtr_effdate  = today
                                xxtr_time  = time
                                xxtr_rmks  = "未挂账处理"
                                .

            /*增加总帐记录*/
                    tnbr = "PO" + substring(string(yr,"9999"),3,2) + string(per,"99") .
                    find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins tnbr no-error.
                    if avail xxglt_det then tnbr = tnbr + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
                    else tnbr = tnbr + "000001".

                    create  xxglt_det.
                    assign  xxglt_domain = global_domain
                                    xxglt_ref = tnbr
                                    xxglt_year = yr
                                    xxglt_per  = per
                                    xxglt_type = "PO"
                                    xxglt_nbr  = ""
                                    xxglt_line = 0
                                    xxglt_effdate = today
                                    xxglt_date = today
                                    xxglt_price = xxtr_price
                                    xxglt_part  = xxtr_part
                                    xxglt_qty   = decWgzLdQty
                                    xxglt_amt   = decNewAmt
                                    .
            xxtr_glnbr = xxglt_ref.
            
            
            create xxtr_hist.
            assign xxtr_domain = global_domain
                                xxtr_site = site
                                xxtr_year = yr
                                xxtr_per    = per
                                xxtr_vend = xxgzd_vend
                                xxtr_type = "CY-WGZ"    /* 差异-未挂账 */
                                xxtr_sort = "IN"
                                xxtr_part = xxgzd_part
                                xxtr_tax_pct = xxgzd_tax_pct
                                xxtr_price = tt1_f6 - xxgzd_price
                                xxtr_qty   = 0
                                xxtr_amt   = decNewAmt - decWgzLdAmt
                                xxtr_effdate  = today
                                xxtr_time  = time
                                xxtr_rmks  = "未挂账处理"
                                xxtr_glnbr = xxglt_ref
                                .

            /*增加收货记录*/
            find first xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr
                        and xxglpod_per = per and xxglpod_nbr = "" and xxglpod_line = 0
                        and xxglpod_tax_pct = xxgzd_tax_pct and xxglpod_price  = tt1_f6
                        and xxglpod_vend = xxgzd_vend and xxglpod_part = xxgzd_part no-error.
                    if not avail xxglpod_det then do:
                        create xxglpod_det.
                        assign xxglpod_domain = global_domain
                                 xxglpod_year   = yr
                                 xxglpod_per    = per
                                 xxglpod_nbr    = ""
                                 xxglpod_line   = 0
                                 xxglpod_vend   = xxgzd_vend
                                 xxglpod_part   = xxgzd_part
                                 xxglpod_curr   = "RMB"
                                 xxglpod_tax_pct = xxgzd_tax_pct
                                 xxglpod_price  = tt1_f6
                                 xxglpod_qty    = xxgzd_qty
                                 xxglpod_amt    = tt1_f6 * xxgzd_qty
                                 xxglpod_type   = "正常"
                                 .
                    end.
                    else do:
                        xxglpod_qty   = xxglpod_qty + xxgzd_qty.
                        xxglpod_amt   = xxglpod_amt + tt1_f6 * xxgzd_qty.
                    end.
        end.
        end. /* for each tt1 */
        next mainloop.
        end.

    end. /* loop1 */
end. /* mainloop */
