
{mfdtitle.i "120925.1"}
define variable site       like wo_site .
define variable site1      like wo_site .
define variable cust       like a6rq_cust.
define variable cust1      like a6rq_cust .
define variable custpono   like a6rq_custpono .
define variable custpoln   like a6rq_custpoln init 0  .
define variable creatdate  like a6rq_crea_date .
define variable creatdate1 like a6rq_crea_date .
define variable qty_oh     like a6rqd_rq_qty .
define variable ln         like mrp_line .
define variable nbr        like mrp_detail .
define variable desc1      like pt_desc1 .
define new shared variable v_sort_opt  as integer format "9" initial 2.
define variable v_disp1   as character format "x(30)" no-undo.
define variable v_disp2   as character format "x(30)" no-undo.
define variable v_buyer   like pt_buyer.
define variable v_pm_code like pt_pm_code.
define variable v_ord_min like pt_ord_min.
define variable v_ord_mult like pt_ord_mult.
define variable v_rmks as character format "x(30)".
define variable dtePeriodStart as date no-undo.
define variable dtePeriodFinish as date no-undo.
define variable decOpenPOQty as decimal no-undo.
define variable decOpenWOQty as decimal no-undo.
define variable decDemandQty as decimal no-undo.
define variable decInventory as decimal no-undo.
define variable decPlan1 as decimal no-undo.
define variable decShort as decimal no-undo.
define variable dMOQ as decimal no-undo.
define variable sStatus like pt_status no-undo.
define variable decBomSummary as decimal no-undo.
define variable decSaftyStock as decimal no-undo.
define variable mrpqty as decimal no-undo.
{xxa6simbom.i "new"}

function getStart returns date(input f_dte1 as date) forward.
function convRemark returns character(input iPmCode as character, input izone as integer) forward.

assign
v_disp1 = "1 = " + gettermlabel("v_disp1",15)
v_disp2 = "2 = " + gettermlabel("v_disp2",15) .
form
site  colon 20
site1 label {t001.i} colon  38 skip
cust  colon 20
cust1 label {t001.i} colon  38 skip
creatdate   colon 20
creatdate1  label  {t001.i} colon  38 skip
custpono  colon 20
custpoln  colon 20  skip
v_sort_opt colon 20
v_disp1    colon 24 no-label
v_disp2    colon 24 no-label skip
with  frame  a side-labels  width  80 attr-space .
setframelabels(frame  a:handle ).
{wbrp01.i}
repeat :
    if  site1        =  hi_char     then   site1        =  ""  .
    if  cust1        =  hi_char     then   cust1        =  ""  .
    if  creatdate1   =  hi_date     then   creatdate1   =  ?  .
    if creatdate = low_date then creatdate = ?.

    display v_disp1 v_disp2 with frame a.

    if  c-application-mode <> 'web' then update  site site1 cust cust1 creatdate creatdate1 custpono custpoln v_sort_opt  with  frame  a .
    {wbrp06.i &command  = update  &fields  = "  site site1 cust cust1 creatdate creatdate1 custpono custpoln v_sort_opt " &frm = "a"}

    if  (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins  'data')) then  do :
        if  site1        =  ""     then   site1        = hi_char  .
        if  cust1        =  ""     then   cust1        = hi_char  .
        if  creatdate1   =  ?      then   creatdate1   = hi_date  .
        if  creatdate    = ?       then  creatdate     = low_date .
    end .

    /* output destination selection */
    {gpselout.i &printtype = "printer"
    &printwidth = 200
    &pagedflag = " "
    &stream = " "
    &appendtofile = " "
    &streamedoutputtoterminal = " "
    &withbatchoption = "no"
    &displaystatementtype = 1
    &withcancelmessage = "yes"
    &pagebottommargin = 6
    &withemail = "yes"
    &withwinprint = "yes"
    &definevariables = "yes"}

    {mfphead.i}

    for each a6rq_mstr where (a6rq_site >= site ) and  ( a6rq_site <= site1 )
        and ( a6rq_cust >= cust )  and ( a6rq_cust <= cust1 )
        and ( a6rq_custpono = custpono  or custpono = '' )  and ( a6rq_custpoln = custpoln or custpoln = 0 )
        and  (a6rq_crea_date >= creatdate ) and ( a6rq_crea_date <= creatdate1 )
        no-lock  by a6rq_due_date  by a6rq_part  :
        empty temp-table temp3 no-error.
        run getSubQty(input a6rq_part,input today).
        find first ptp_det where ptp_site = a6rq_site and ptp_part = a6rq_part no-lock no-error.
        if available(ptp_det) then do:
            assign
                v_buyer = ptp_buyer
                v_pm_code = ptp_pm_code
                v_ord_min = ptp_ord_min
                v_ord_mult = ptp_ord_mult.
        end.

        find pt_mstr where pt_part = a6rq_part no-lock no-error .
        if available pt_mstr then do:
            assign
                desc1 = pt_desc1.
        end.

        if available(pt_mstr) and (not(available(ptp_det))) then do:
            assign
                v_buyer = pt_buyer
                v_pm_code = pt_pm_code
                v_ord_min = pt_ord_min
                v_ord_mult = pt_ord_mult.
        end.

        put skip (2) .
        put '地点:' at 2 a6rq_site
            '客户代码:' at 17 a6rq_cust
            '客户地址:' at 37 skip .
        put '物料编号:' at 2 a6rq_part
            '描述:' at  32   desc1
            '需求数量:' at 64  a6rq_rq_qty skip .
        put 'p/m:' at 2 v_pm_code
            'buyer  ' at 17 v_buyer
            'ord-min ' at 32 v_ord_min
            'ord_mult '  at 64 v_ord_mult skip.
        put '客采单号:'  at 2 a6rq_custpono
            '项次:'  at  17 a6rq_custpoln
            '需求日期:' at 64  a6rq_due_date  skip .
        put fill("=", 88) format 'x(200)' skip .
        /* put '项次     零件编号           零件描述                  提前期    需求日期 um        毛需求     预计库存    短缺数量 入库日期 下达日期 需求单号          编号/项次 明细     p/m   buyer ord_min   ord_mult' skip . */
        put '零件编号' '~t' '零件描述' '~t' '提前期' '~t' '需求日期' '~t'
            'um' '~t' '物料用量' '~t' 'OPPO' '~t' '当天库存' '~t' '总需求' '~t'
            '扣出WO及FCS多出物料' '~t' 'MOQ' '~t' '组别' '~t' '毛需求' '~t'
            '预计库存' '~t' '短缺数量' '~t' '入库日期' '~t' '下达日期' '~t'
            '需求单号' '~t' '编号/项次' '~t' '明细' '~t' 'p/m' '~t' '状态' at 1 skip .

        for each a6rqd_det
            where a6rqd_site = a6rq_site
                and a6rqd_cust = a6rq_cust
                and a6rqd_custpono = a6rq_custpono
                and a6rqd_custpoln = a6rq_custpoln
            no-lock
            by a6rqd_sort :

            find pt_mstr where pt_part = a6rqd_part no-lock no-error .
            if available pt_mstr then do:
                assign
                desc1 = pt_desc1
                sStatus = pt_status.
                .
            end.

            find first ptp_det where ptp_site = a6rqd_site and ptp_part = a6rqd_part no-lock no-error.
            if available(ptp_det) then do:
                assign
                v_buyer = ptp_buyer
                v_pm_code = ptp_pm_code
                v_ord_min = ptp_ord_min
                v_ord_mult = ptp_ord_mult.

                decSaftyStock = ptp_sfty_stk.
                dMOQ = ptp_ord_min.
            end.

            if available(pt_mstr) and (not(available(ptp_det))) then do:
                assign
                    v_buyer = pt_buyer
                    v_pm_code = pt_pm_code
                    v_ord_min = pt_ord_min
                    v_ord_mult = pt_ord_mult
                    decSaftyStock = pt_sfty_stk
                    dMOQ = pt_ord_min
                    .
            end.

            if (a6rqd_rq_qty - a6rqd_short_qty ) >= 0 then assign qty_oh = a6rqd_rq_qty - a6rqd_short_qty  .
            else assign qty_oh = 0  .

            assign ln = string (a6rqd_custpoln )  nbr = a6rqd_custpono .


            dtePeriodStart = getStart(a6rqd_rq_date).
            dtePeriodFinish = dtePeriodStart + 6.

            {xxa6simrp1openpo.i
                a6rqd_part
                a6rqd_site
                a6rqd_rq_date
                decOpenPOQty
            }

            {xxa6simrp1inventory.i
                a6rqd_part
                a6rqd_site
                decInventory
            }

            {xxa6simrp1demand.i
                a6rqd_part
                a6rqd_site
                dtePeriodStart
                dtePeriodFinish
                decDemandQty
            }

            {xxa6simrp1openwo.i
                a6rqd_part
                a6rqd_site
                a6rqd_rq_date
                decOpenWOQty
            }

            decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.
            decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.

            if v_sort_opt = 2 then do:
                if a6rqd_zone = 2  or a6rqd_zone = 4 or a6rqd_zone = 6 then do:
                    put skip (1) .
                    put
                    a6rqd_part at 1 '~t'
                    desc1 '~t'
                    a6rqd_lt '~t'
                    a6rqd_rq_date '~t'
                    pt_um '~t'
                    decBomSummary  '~t'
                    decOpenPOQty   '~t'
                    decInventory   '~t'
                    decDemandQty   '~t'
                    decPlan1       '~t'
                    dMOQ           '~t'
                    v_buyer        '~t'
                    a6rqd_rq_qty '~t'
                    dec(a6rqd_char02)  format "->,>>>,>>>,>>9.<<" '~t'
                    decShort '~t'
                    a6rqd_due_date '~t'
                    a6rqd_rel_date '~t'
                    nbr   format "x(40)" '~t'
                    ln '~t'
                    a6rqd_remark '~t'
                    v_pm_code '~t'
                    sStatus
                    skip
                    .

                    for each a6rrd_det
                        where a6rrd_site = a6rqd_site
                            and a6rrd_cust = a6rqd_cust
                            and a6rrd_custpono = a6rqd_custpono
                            and a6rrd_custpoln = a6rqd_custpoln
                            and a6rrd_part = a6rqd_part
                        no-lock :

                        if (a6rrd_rq_qty - a6rrd_short_qty ) >= 0 then assign qty_oh = a6rrd_rq_qty - a6rrd_short_qty  .
                        else assign qty_oh = 0  .

                        find first mrp_det where mrp_dataset = "ss_fcs_sum"  and  mrp_nbr = a6rrd_rel_ord use-index mrp_nbr no-lock no-error .
                        if available mrp_det then
                            assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord + " " + mrp_detail.
                        else
                            assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord .

                        dtePeriodStart = getStart(a6rrd_rq_date).
                        dtePeriodFinish = dtePeriodStart + 6.

                        {xxa6simrp1openpo.i
                            a6rrd_part
                            a6rrd_site
                            a6rrd_rq_date
                            decOpenPOQty
                        }

                        {xxa6simrp1inventory.i
                            a6rrd_part
                            a6rrd_site
                            decInventory
                        }

                        {xxa6simrp1demand.i
                            a6rrd_part
                            a6rrd_site
                            dtePeriodStart
                            dtePeriodFinish
                            decDemandQty
                        }

                        {xxa6simrp1openwo.i
                            a6rrd_part
                            a6rrd_site
                            a6rrd_rq_date
                            decOpenWOQty
                        }

                        decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.
                        decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.

                        put
                        a6rrd_part at 1 '~t'
                        desc1 '~t'
                        a6rqd_lt '~t'
                        a6rrd_rq_date '~t'
                        pt_um  '~t'
                        decBomSummary   '~t'
                        decOpenPOQty    '~t'
                        decInventory    '~t'
                        decDemandQty    '~t'
                        decPlan1        '~t'
                        dMOQ            '~t'
                        v_buyer         '~t'
                        a6rrd_rq_qty  '~t'
                        dec (a6rrd_desc) format "->,>>>,>>>,>>9.<<" '~t'
                        decShort '~t'
                        a6rrd_due_date '~t'
                        a6rrd_rel_date '~t'
                        nbr  format "x(40)" '~t'
                        ln '~t'
                        a6rrd_remark '~t'
                        v_pm_code '~t'
                        sStatus
                        skip
                        .
                    end.
                end. /* end if a6rqd_zone = 2  or a6rqd_zone = 4 or a6rqd_zone = 6 */

                find first a6rrd_det
                    where a6rrd_site = a6rqd_site
                        and a6rrd_cust = a6rqd_cust
                        and a6rrd_custpono = a6rqd_custpono
                        and a6rrd_custpoln = a6rqd_custpoln
                        and a6rrd_part = a6rqd_part
                    no-lock
                    no-error.
                if available a6rrd_det and a6rqd_zone = 3  then do:

                    dtePeriodStart = getStart(a6rqd_rq_date).
                    dtePeriodFinish = dtePeriodStart + 6.

                    {xxa6simrp1openpo.i
                        a6rqd_part
                        a6rrd_site
                        a6rqd_rq_date
                        decOpenPOQty
                    }

                    {xxa6simrp1inventory.i
                        a6rqd_part
                        a6rqd_site
                        decInventory
                    }

                    {xxa6simrp1demand.i
                        a6rqd_part
                        a6rqd_site
                        dtePeriodStart
                        dtePeriodFinish
                        decDemandQty
                    }

                    {xxa6simrp1openwo.i
                        a6rqd_part
                        a6rqd_site
                        a6rqd_rq_date
                        decOpenWOQty
                    }

                    decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.
                    decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.

                    put skip (1) .
                    put
                    a6rqd_part at 1
                    '~t'
                    desc1
                    '~t'
                    a6rqd_lt
                    '~t'
                    a6rqd_rq_date
                    '~t'
                    pt_um
                    '~t'
                    decBomSummary   '~t'
                    decOpenPOQty    '~t'
                    decInventory    '~t'
                    decDemandQty    '~t'
                    decPlan1        '~t'
                    dMOQ            '~t'
                    v_buyer         '~t'
                    a6rqd_rq_qty
                    '~t'
                    dec(a6rqd_char02)  format "->,>>>,>>>,>>9.<<"
                    '~t'
                    decShort
                    '~t'
                    a6rqd_due_date
                    '~t'
                    a6rqd_rel_date
                    '~t'
                    nbr   format "x(40)"
                    '~t'
                    ln
                    '~t'
                    a6rqd_remark
                    v_pm_code
                    '~t'
                    sStatus
                    skip
                    .

                    for each a6rrd_det
                        where a6rrd_site = a6rqd_site
                            and a6rrd_cust = a6rqd_cust
                            and a6rrd_custpono = a6rqd_custpono
                            and a6rrd_custpoln = a6rqd_custpoln
                            and a6rrd_part = a6rqd_part
                        no-lock :

                        if (a6rrd_rq_qty - a6rrd_short_qty ) >= 0 then assign qty_oh = a6rrd_rq_qty - a6rrd_short_qty  .
                        else assign qty_oh = 0  .

                        find first mrp_det where mrp_dataset = "ss_fcs_sum"  and  mrp_nbr = a6rrd_rel_ord use-index mrp_nbr no-lock no-error .
                        if available mrp_det then
                            assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord + " " + mrp_detail.
                        else
                            assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord .

                        dtePeriodStart = getStart(a6rrd_rq_date).
                        dtePeriodFinish = dtePeriodStart + 6.

                        {xxa6simrp1openpo.i
                            a6rrd_part
                            a6rrd_site
                            a6rrd_rq_date
                            decOpenPOQty
                        }

                        {xxa6simrp1inventory.i
                            a6rrd_part
                            a6rrd_site
                            decInventory
                        }

                        {xxa6simrp1demand.i
                            a6rrd_part
                            a6rrd_site
                            dtePeriodStart
                            dtePeriodFinish
                            decDemandQty
                        }

                        {xxa6simrp1openwo.i
                            a6rrd_part
                            a6rrd_site
                            a6rrd_rq_date
                            decOpenWOQty
                        }

                        decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.
                        decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.


                        put
                        a6rrd_part at 1
                        '~t'
                        desc1
                        '~t'
                        a6rqd_lt
                        '~t'
                        a6rrd_rq_date
                        '~t'
                        pt_um
                        '~t'
                        decBomSummary   '~t'
                        decOpenPOQty    '~t'
                        decInventory    '~t'
                        decDemandQty    '~t'
                        decPlan1        '~t'
                        dMOQ            '~t'
                        v_buyer         '~t'
                        a6rrd_rq_qty
                        '~t'
                        dec (a6rrd_desc) format "->,>>>,>>>,>>9.<<"
                        '~t'
                        decShort
                        '~t'
                        a6rrd_due_date
                        '~t'
                        a6rrd_rel_date
                        '~t'
                        nbr  format "x(40)"
                        ln
                        '~t'
                        a6rrd_remark
                        v_pm_code
                        '~t'
                        sStatus
                        skip
                        .
                    end.
                end.
            end.
            if v_sort_opt = 1 then do:
               assign mrpqty = 0
                      decBomSummary = 0.
               find first temp3 no-lock where t3_comp = a6rqd_part no-error.
               if available temp3 then do:
                  assign decBomSummary = t3_qty_per.
               end.
               for each mrp_det
                      no-lock
                      use-index mrp_site_due
                      where mrp_part = a6rqd_part
                          and mrp_site = a6rq_site
                          and mrp_type = "demand"
                          and mrp_due_date <= a6rq_due_date:
                      mrpqty = mrpqty + mrp_qty.
                  end.
                put skip (1) .
                v_rmks = convRemark(input v_pm_code,input a6rqd_zone).
                put
                a6rqd_part at 1  '~t'
                desc1 '~t'
                a6rqd_lt  '~t'
                a6rqd_rq_date '~t'
                pt_um  '~t'
                decBomSummary  '~t'
                decOpenPOQty   '~t'
                decInventory   '~t'
                decDemandQty   '~t'
                decInventory  - decDemandQty  '~t'
                dMOQ           '~t'
                v_buyer        '~t'
                a6rqd_rq_qty  '~t'
                decOpenPOQty + decInventory format "->,>>>,>>>,>>9.<<" '~t'
                decInventory - mrpqty - a6rqd_rq_qty format "->,>>>,>>>,>>9.<<" '~t'
                a6rqd_due_date '~t'
                a6rqd_rel_date '~t'
                nbr format "x(40)" '~t'
                ln '~t'
                v_rmks format "x(30)" '~t'
                v_pm_code '~t'
                sStatus
                skip
                .
                for each a6rrd_det where a6rrd_site = a6rqd_site and a6rrd_cust = a6rqd_cust and a6rrd_custpono = a6rqd_custpono and a6rrd_custpoln = a6rqd_custpoln
                     and a6rrd_part = a6rqd_part no-lock :
                    if (a6rrd_rq_qty - a6rrd_short_qty ) >= 0 then assign qty_oh = a6rrd_rq_qty - a6rrd_short_qty  .
                    else assign qty_oh = 0  .
                    assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord   .
                    find first mrp_det where mrp_dataset = "ss_fcs_sum"  and  mrp_nbr = a6rrd_rel_ord use-index mrp_nbr no-lock no-error .
                    if available mrp_det then
                    assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord + " " + mrp_detail.
                    else
                    assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord .

                    dtePeriodStart = getStart(a6rrd_rq_date).
                    dtePeriodFinish = dtePeriodStart + 6.

                    {xxa6simrp1openpo.i
                        a6rrd_part
                        a6rrd_site
                        a6rrd_rq_date
                        decOpenPOQty
                    }

                    {xxa6simrp1inventory.i
                        a6rrd_part
                        a6rrd_site
                        decInventory
                    }

                    {xxa6simrp1demand.i
                        a6rrd_part
                        a6rrd_site
                        dtePeriodStart
                        dtePeriodFinish
                        decDemandQty
                    }

                    {xxa6simrp1openwo.i
                        a6rrd_part
                        a6rrd_site
                        a6rrd_rq_date
                        decOpenWOQty
                    }

                    decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.
                    decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.
                    v_rmks = convRemark(input v_pm_code,input a6rrd_zone).
                    put
                    a6rrd_part at 1 '~t'
                    desc1 '~t'
                    a6rqd_lt '~t'
                    a6rrd_rq_date '~t'
                    pt_um '~t'
                    decBomSummary '~t'
                    decOpenPOQty '~t'
                    decInventory '~t'
                    decDemandQty '~t'
                    decPlan1 '~t'
                    dMOQ '~t'
                    v_buyer '~t'
                    a6rrd_rq_qty '~t'
                    decOpenPOQty + decInventory format "->,>>>,>>>,>>9.<<" '~t'
                    decInventory - mrpqty format "->,>>>,>>>,>>9.<<" '~t'
                    a6rrd_due_date '~t'
                    a6rrd_rel_date '~t'
                    nbr format "x(40)" '~t'
                    ln '~t'
                    v_rmks format "x(30)" '~t'
                    v_pm_code '~t'
                    sStatus
                    skip
                    .
                end.
            end.
        end.

        page .
    end.
    {mfrtrail.i}
end.
{wbrp04.i &frame-spec = a}

function getStart returns date(input f_dte1 as date):
    define variable f_dte2 as date no-undo.
    do f_dte2 = f_dte1 to f_dte1 - 7 by -1:
        if weekday(f_dte2) = 2 then
            leave.
    end.
    return f_dte2.
end.

FUNCTION getMsg RETURNS character(inbr as integer):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  find first msg_mstr no-lock where msg_lang = "ch" and msg_nbr = inbr no-error.
  if available msg_mstr then do:
      return msg_desc.
  end.
  else do:
      return string(inbr).
  end.
END FUNCTION. /*FUNCTION getMsg*/

function convRemark returns character(
				 input iPmCode as character, input izone as integer):
    define variable vmsg as character format "x(30)".
    if ipmcode = "P" then do:
       case izone:
          WHEN 1 THEN assign vmsg = getmsg(7806).
          WHEN 2 THEN assign vmsg = getmsg(7807).
          WHEN 3 THEN assign vmsg = getmsg(7808).
          WHEN 4 THEN assign vmsg = getmsg(7809).
          WHEN 5 THEN assign vmsg = getmsg(7810).
          WHEN 6 THEN assign vmsg = getmsg(7811).
          WHEN 7 THEN assign vmsg = getmsg(7812).
      END CASE.
    end.
    else do:
       case izone:
          WHEN 1 THEN ASSIGN vmsg = getmsg(7806).
          WHEN 2 THEN ASSIGN vmsg = getmsg(7813).
          WHEN 3 THEN ASSIGN vmsg = getmsg(7808).
          WHEN 4 THEN ASSIGN vmsg = getmsg(7814).
          WHEN 5 THEN ASSIGN vmsg = getmsg(7810).
          WHEN 6 THEN ASSIGN vmsg = getmsg(7815).
          WHEN 7 THEN ASSIGN vmsg = getmsg(7816).
      END CASE.
    end.
    return vmsg.
end Function.
