/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */
/* SS - 100423.1 By: Kaine Zhang */

/* *ss_20100423* 加入供应商 */
/*
20100412
订单出库明细表.
实际上,统计的是"工单发料数据"
*/


{mfdtitle.i "100423.1"}

define variable iYear as integer format ">>>9" label "年份" no-undo.
define variable iMonth as integer format ">9" label "期间" no-undo.
define variable sSoPoA like so_po label "订单号" no-undo.
define variable sSoPoB like so_po label "至" no-undo.
define variable sPartA like pt_part label "成品编码" no-undo.
define variable sPartB like pt_part label "至" no-undo.
define variable decPrice as decimal no-undo.
define variable decAmount as decimal format "->>>>>>>>9.9<<<" no-undo.
define variable s1Desc as character format "x(24)" no-undo.
define variable s2Desc as character format "x(24)" no-undo.

define temp-table t1_tmp no-undo
    field t1_wo_lot like wo_lot
    field t1_wo_part like wo_part
    field t1_wod_part like wod_part
    field t1_so_nbr like so_nbr
    field t1_so_po like so_po
    field t1_qty as decimal format "->>>>>>9.9<<"
    field t1_price as decimal format "->>>>>>9.9<<"
    /* SS - 100423.1 - B */
    field t1_vendor as character
    /* SS - 100423.1 - E */
    .
    
form
    iYear   colon 15
    iMonth  colon 15
    sSoPoA  colon 15
    sSoPoB  colon 45
    sPartA  colon 15
    sPartB  colon 45
with frame a side-labels width 80.
setframelabels(frame a:handle).
    
form
    t1_so_po    column-label "合同"
    t1_wo_part  column-label "成品编码"
    s1Desc      column-label "成品说明"
    t1_wod_part column-label "零件编码"
    s2Desc      column-label "零件说明"
    /* SS - 100423.1 - B */
    t1_vendor   column-label "供应商"
    ad_name     column-label "名称"
    /* SS - 100423.1 - E */
    t1_qty      column-label "数量"
    t1_price    column-label "单价"
    decAmount   column-label "金额"
/* SS - 100423.1 - B
with frame b down width 182.
SS - 100423.1 - E */
/* SS - 100423.1 - B */
with frame b down width 240.
/* SS - 100423.1 - E */
setframelabels(frame b:handle).
    


{wbrp01.i}
repeat on endkey undo, leave:
    if sSoPoB = hi_char then sSoPoB = "".
    if sPartB = hi_char then sPartB = "".

    if c-application-mode <> 'web' then
        update
            iYear
            iMonth
            sSoPoA
            sSoPoB
            sPartA
            sPartB
        with frame a .

    {wbrp06.i
        &command = update
        &fields = "
            iYear
            iMonth
            sSoPoA
            sSoPoB
            sPartA
            sPartB
            "
        &frm = "a"
    }
    


    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i iYear   }
        {mfquoter.i iMonth  }
        {mfquoter.i sSoPoA  }
        {mfquoter.i sSoPoB  }
        {mfquoter.i sPartA  }
        {mfquoter.i sPartB  }

        if sSoPoB = "" then sSoPoB = hi_char.
        if sPartB = "" then sPartB = hi_char.
    end.


    find first glc_cal where glc_domain = global_domain and glc_year = iYear and glc_per = iMonth no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	undo, retry.
	end.
	
    /* output destination selection */
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }



    empty temp-table t1_tmp.
    for each tr_hist
        no-lock
        where tr_domain = global_domain
            and tr_type = "ISS-WO"
            and tr_effdate >= glc_start
            and tr_effdate <= glc_end
        use-index tr_type
        ,
    each wo_mstr
        no-lock
        where wo_domain = global_domain
            and wo_lot = tr_lot
            and wo_part >= sPartA
            and wo_part <= sPartB
        use-index wo_lot
    :
        find first xxzgp_det 
            where xxzgp_domain = global_domain 
                and xxzgp_year = iYear
                and xxzgp_per = iMonth
                and xxzgp_vend = substring(tr_serial, 7)
                and xxzgp_part = tr_part
            use-index xxzgp_part
            no-lock 
            no-error.
        decPrice = if available(xxzgp_det) then xxzgp_price else 0.
        
        create t1_tmp.
        assign
            t1_wo_lot = tr_lot
            t1_so_nbr = wo_so_job
            t1_wo_part = wo_part
            t1_wod_part = tr_part
            t1_qty = tr_qty_loc
            t1_price = decPrice
            /* SS - 100423.1 - B */
            t1_vendor = substring(tr_serial,7)
            /* SS - 100423.1 - E */
            .
        find first so_mstr
            no-lock
            where so_domain = global_domain
                and so_nbr = t1_so_nbr
            use-index so_nbr
            no-error.
        if available(so_mstr) then do:
            t1_so_po = so_po.
        end.
        else do:
            find first ih_hist
                no-lock
                where ih_domain = global_domain
                    and ih_nbr = t1_so_nbr
                use-index ih_nbr
                no-error.
            if available(ih_hist) then t1_so_po = ih_po.
        end.
    end.

    for each t1_tmp
        where t1_so_po >= sSoPoA
            and t1_so_po <= sSoPoB
    /* SS - 100423.1 - B */
    ,
    each ad_mstr
        no-lock
        where ad_domain = global_domain
            and ad_addr = t1_vendor
    /* SS - 100423.1 - E */
    :
        find first pt_mstr
            no-lock
            where pt_domain = global_domain
                and pt_part = t1_wo_part
            no-error.
        s1Desc = if available(pt_mstr) then pt_desc1 else "".
        
        find first pt_mstr
            no-lock
            where pt_domain = global_domain
                and pt_part = t1_wod_part
            no-error.
        s2Desc = if available(pt_mstr) then pt_desc1 else "".
        
        display
            t1_so_po
            t1_wo_part
            s1Desc
            t1_wod_part
            s2Desc
            /* SS - 100423.1 - B */
            t1_vendor
            ad_name
            /* SS - 100423.1 - E */
            (- t1_qty) @ t1_qty
            t1_price
            (- t1_qty * t1_price) @ decAmount
        with frame b.
        down with frame b.
    end.

    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}










