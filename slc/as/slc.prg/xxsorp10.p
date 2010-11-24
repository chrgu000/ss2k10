/* SS - 100312.1 By: Kaine Zhang */

{mfdtitle.i "100312.1"}

define variable sSoA like so_nbr no-undo.
define variable sSoB like so_nbr no-undo.
define variable sCustomerA like so_nbr no-undo.
define variable sCustomerB like so_nbr no-undo.
define variable sPartA like so_nbr no-undo.
define variable sPartB like so_nbr no-undo.
define variable decX as decimal format "->>>>>>>>>9.9<<<<" no-undo.

form
    sSoA        colon 15     label "订单"
    sSoB        colon 45     label "至"
    sCustomerA        colon 15     label "客户"
    sCustomerB        colon 45     label "至"
    sPartA        colon 15     label "物料"
    sPartB        colon 45     label "至"
    skip
with frame a side-labels width 80 three-d.
setframelabels(frame a:handle).

form
    so_nbr      column-label "订单"
    so_cust      column-label "客户"
    cm_sort      column-label "客户名称"
    sod_part      column-label "物料编码"
    pt_group      column-label "车型"
    pt_desc1      column-label "物料名称"
    sod_qty_ord      column-label "订单数量"
    sod_price      column-label "单价(含税)"
    decX      column-label "金额(含税)"
with frame b width 232 down no-box.
setframelabels(frame b:handle).




{wbrp01.i}
repeat:
    if sSoB = hi_char then sSoB = "".
    if sCustomerB = hi_char then sCustomerB = "".
    if sPartB = hi_char then sPartB = "".

    if c-application-mode <> 'web' then
        update
            sSoA
            sSoB
            sCustomerA
            sCustomerB
            sPartA
            sPartB
        with frame a.

    {wbrp06.i
        &command = update
        &fields = "
            sSoA
            sSoB
            sCustomerA
            sCustomerB
            sPartA
            sPartB
            "
        &frm = "a"
    }

    if (c-application-mode <> 'web')
        or (c-application-mode = 'web' and (c-web-request begins 'data'))
    then do:
        bcdparm = "".
        {mfquoter.i sSoA          }
        {mfquoter.i sSoB          }
        {mfquoter.i sCustomerA    }
        {mfquoter.i sCustomerB    }
        {mfquoter.i sPartA        }
        {mfquoter.i sPartB        }

        if sSoB = "" then sSoB = hi_char.
        if sCustomerB = "" then sCustomerB = hi_char.
        if sPartB = "" then sPartB = hi_char.
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


    form header
        "销售订单报表" at 25
    with frame frmTop page-top width 80.
    view frame frmTop.

    for each so_mstr
        no-lock
        where so_domain = global_domain
            and so_nbr >= sSoA
            and so_nbr <= sSoB
            and so_nbr begins "W"
            and so_cust >= sCustomerA
            and so_cust <= sCustomerB
        use-index so_nbr
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
        use-index sod_nbrln
        ,
    first pt_mstr
        no-lock
        where pt_domain = sod_domain
            and pt_part = sod_part
        use-index pt_part
        with frame b
    :
        display
            so_nbr
            so_cust
            cm_sort
            sod_part
            pt_group
            pt_desc1
            sod_qty_ord
            sod_price
            sod_price * sod_qty_ord @ decX
            .
        down.
    end.


    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}





