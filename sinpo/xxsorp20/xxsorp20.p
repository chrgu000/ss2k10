/* xxsorp20.p -- */
/* Copyright 201003 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100606.1 By: Kaine Zhang */
/* SS - 100913.1 By: Kaine Zhang */


/* SS - 100913.1 - RNB
[100913.1]
20100824.QAD优化100805.何红宇.xls的第一点. -- 添加1列"订单项次说明".
[100913.1]
SS - 100913.1 - RNE */

{mfdtitle.i "120705.1"}

define variable dteOrderA like so_ord_date no-undo.
define variable dteOrderB like so_ord_date no-undo.
define variable sSoA like so_nbr no-undo.
define variable sSoB like so_nbr no-undo.
define variable sCustomerA like so_cust no-undo.
define variable sCustomerB like so_cust no-undo.
define variable sCompanyA as character no-undo.
define variable sCompanyB as character no-undo.
define variable sPartA as character no-undo.
define variable sPartB as character no-undo.
define variable sBuyerA as character no-undo.
define variable sBuyerB as character no-undo.

define variable sCompanyName as character no-undo.
define variable sSales as character no-undo.
define variable decPrice as decimal no-undo.
define variable usrname as character format "x(10)".
/* SS - 100913.1 - B */
define variable i as integer no-undo.
define variable sSodCmt as character no-undo.
/* SS - 100913.1 - E */

form
    dteOrderA   colon 15    label "下单日期"
    dteOrderB   colon 45    label "至"
    sSoA        colon 15    label "订单"
    sSoB        colon 45    label "至"
    sCustomerA  colon 15    label "客户"
    sCustomerB  colon 45    label "至"
    sCompanyA   colon 15    label "公司"
    sCompanyB   colon 45    label "至"
    sPartA      colon 15    label "物料"
    sPartB      colon 45    label "至"
    sBuyerA     colon 15    label "计划员"
    sBuyerB     colon 45    label "至"
    skip(1)
with frame a side-labels width 80.
setframelabels(frame a:handle).





{wbrp01.i}
repeat on endkey undo, leave:
    if dteOrderA = low_date then dteOrderA = ? .
    if dteOrderB = hi_date then dteOrderB = ? .
    if sSoB = hi_char then sSoB = "".
    if sCustomerB = hi_char then sCustomerB = "".
    if sCompanyB = hi_char then sCompanyB = "".
    if sPartB = hi_char then sPartB = "".
    if sBuyerB = hi_char then sBuyerB = "".

    update
        dteOrderA 
        dteOrderB 
        sSoA      
        sSoB      
        sCustomerA
        sCustomerB
        sCompanyA 
        sCompanyB 
        sPartA    
        sPartB    
        sBuyerA   
        sBuyerB   
    with frame a.
    
    if dteOrderA = ? then dteOrderA = low_date.
    if dteOrderB = ? then dteOrderB = hi_date.
    if sSoB = "" then sSoB = hi_char.
    if sCustomerB = "" then sCustomerB = hi_char.
    if sCompanyB = "" then sCompanyB = hi_char.
    if sPartB = "" then sPartB = hi_char.
    if sBuyerB = "" then sBuyerB = hi_char.
    
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

    put
        unformatted
        "ExcelFile;sorp20" at 1
        "SaveFile;"
            + string(today, "99999999")
            + replace(string(time, "HH:MM:SS"), ":", "")
            + "sorp20" at 1
        "BeginRow;1" at 1
        .
    
    put
        unformatted
        /* SS - 100913.1 - B
        "销售订单;订单日期;客户编码;客户名称;公司代码;公司名称;推销员;物料编码;物料名称/规格;计量单位;订单数量;含税单价;含税金额"
        SS - 100913.1 - E */
        /* SS - 100913.1 - B */
        "销售订单;订单日期;录入人ID;录入人;客户编码;客户名称;公司代码;公司名称;推销员;物料编码;物料名称/规格;计量单位;订单数量;含税单价;含税金额;项次说明"
        /* SS - 100913.1 - E */
        at 1
        .
    for each so_mstr
        no-lock
        where so_domain = global_domain
            and so_nbr >= sSoA
            and so_nbr <= sSoB
            and so_ord_date >= dteOrderA
            and so_ord_date <= dteOrderB
            and so_cust >= sCustomerA
            and so_cust <= sCustomerB
            and so__chr01 >= sCompanyA
            and so__chr01 <= sCompanyB
        /* todo: use-index date,order */
        ,
    first cm_mstr
        no-lock
        where cm_domain = so_domain
            and cm_addr = so_cust
        use-index cm_addr
        ,
    each sod_det
        no-lock
        where sod_domain = so_domain
            and sod_nbr = so_nbr
            and sod_part >= sPartA
            and sod_part <= sPartB
        use-index sod_nbrln
        ,
    first pt_mstr
        no-lock
        where pt_domain = sod_domain
            and pt_part = sod_part
            and pt_buyer >= sBuyerA
            and pt_buyer <= sBuyerB
        use-index pt_part
    :
        find first code_mstr
            no-lock
            where code_domain = global_domain
                and code_fldname = "ss_20100423_001"
                and code_value = so__chr01
            no-error.
        sCompanyName = if available(code_mstr) then code_cmmt else "".

        find first sp_mstr
            no-lock
            where sp_domain = global_domain
                and sp_addr = so_slspsn[1]
            no-error.
        sSales = if available(sp_mstr) then sp_sort else "".

        decPrice = sod_list_pr.
        if not(sod_tax_in) then do:
            find first tx2d_det
                no-lock
                where tx2d_domain = global_domain
                    and tx2d_ref = sod_nbr
                    and tx2d_line = sod_line
                    and tx2d_tr_type = "11"             /* 11 ???? what */
                no-error. 
            if available(tx2d_det) and tx2d_totamt <> 0 then
                decPrice = sod_list_pr * (1 + tx2d_cur_tax_amt / tx2d_totamt).
        end.

        /* SS - 100913.1 - B */
        sSodCmt = "".
        for each cmt_det
            no-lock
            where cmt_domain = global_domain
                and cmt_indx = sod_cmtindx
            use-index cmt_ref
        :
            do i = 1 to 15:
                sSodCmt = sSodCmt + cmt_cmmt[i].
            end.
        end.
        /* SS - 100913.1 - E */

        assign usrname = "".
				find first usr_mstr no-lock where usr_userid = so_userid no-error.
			  if available usr_mstr then do:
			 		 assign usrname = usr_name.
			  end.
			  
        put
            unformatted
            so_nbr at 1 ";"
            so_ord_date ";"
            so_userid ";"
            usrname ";"
            so_cust ";"
            cm_sort ";"
            so__chr01 ";"
            sCompanyName ";"
            sSales ";"
            sod_part ";"
            pt_desc1 + pt_desc2 ";"
            sod_um ";"
            sod_qty_ord ";"
            decPrice ";"
            sod_qty_ord * decPrice
            /* SS - 100913.1 - B */
            ";"
            sSodCmt
            /* SS - 100913.1 - E */
            .
            
    end.

    {xxmfreset.i}
	{mfgrptrm.i}

end.
{wbrp04.i &frame-spec = a}



