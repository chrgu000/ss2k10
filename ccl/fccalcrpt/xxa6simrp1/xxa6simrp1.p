/*ss-130129.1 by steven add simular result*/
/*ss-130206.1 by steven */
/* ss - 130227.1 by: jack */  /* 输出显示调整 */
/* ss - 130301.1 by: jack */
/* ss - 130507.1 by: zy
 *  1.OPPO 数量,需要做转换. 若采购单位和PO单位不一致时,需要转换为库存单位.( G栏,牵涉到此栏位的计算不用更改)
 *  2.虚零件不显示
 *  3.父件已满足需求,对应的子件不应该在显示欠料.
 */
{mfdtitle.i "130301.1"}

define variable site       like wo_site.
define variable site1      like wo_site.
define variable cust       like a6rq_cust.
define variable cust1      like a6rq_cust.
define variable custpono   like a6rq_custpono.
define variable custpoln   like a6rq_custpoln init 0.
define variable creatdate  like a6rq_crea_date.
define variable creatdate1 like a6rq_crea_date.
define variable qty_oh     like a6rqd_rq_qty.
define variable ln         like mrp_line.
define variable nbr        like mrp_detail.
define variable desc1      like pt_desc1.
define new shared variable v_sort_opt  as integer format "9" initial 1.
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
define variable decOpenPOQtyum as decimal no-undo.
define variable decOpenWOQty as decimal no-undo.
define variable decDemandQty as decimal no-undo.
define variable decInventory as decimal no-undo.
define variable decPlan1 as decimal no-undo.
define variable decShort as decimal no-undo.
define variable dMOQ as decimal no-undo.
define variable sStatus like pt_status no-undo.
define variable decBomSummary as decimal format "->>>>>9.999<<" no-undo.
define variable decSaftyStock as decimal no-undo.
define variable mrpqty as decimal no-undo.
DEFINE VARIABLE v_phantom LIKE pt_phantom NO-UNDO.
define variable before_simdate_demand as decimal no-undo.
define variable after_simdate_oppo as decimal no-undo.
define variable before_simdate_oppo as decimal no-undo.
define variable v_a6rqd_rq_qty as decimal no-undo.
define variable v_a6rrd_rq_qty as decimal no-undo.
define variable conv           like um_conv no-undo.
{xxa6simbom.i "new"}

function getStart returns date(input f_dte1 as date) forward.
function convRemark returns character(input iPmCode as character, input izone as integer) forward.

assign
v_disp1 = "1 = " + gettermlabel("v_disp1",15)
v_disp2 = "2 = " + gettermlabel("v_disp2",15).
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
with  frame  a side-labels  width  80 attr-space.
setframelabels(frame  a:handle ).
{wbrp01.i}
{mfdemo.i 05/01/2013 08/30/2013}
repeat :
    if  site1      = hi_char  then site1        =  "".
    if  cust1      = hi_char  then cust1        =  "".
    if  creatdate1 = hi_date  then creatdate1   =  ?.
    if  creatdate  = low_date then creatdate    =  ?.

    display v_disp1 v_disp2 with frame a.

    if  c-application-mode <> 'web' then update  site site1 cust cust1 creatdate creatdate1 custpono custpoln v_sort_opt  with  frame  a.
    {wbrp06.i &command  = update  &fields  = "  site site1 cust cust1 creatdate creatdate1 custpono custpoln v_sort_opt " &frm = "a"}

    if  (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins  'data')) then  do :
        if  site1        =  ""     then   site1        = hi_char.
        if  cust1        =  ""     then   cust1        = hi_char.
        if  creatdate1   =  ?      then   creatdate1   = hi_date.
        if  creatdate    =  ?      then   creatdate    = low_date.
    end.

    /* output destination selection */
    /*{gpselout.i &printtype = "printer"
    &printwidth = 500
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
    &definevariables = "yes" } ss-130205.1 */

     {mfselbpr.i "printer" 320 nopage}

/*
    {mfphead.i}
*/

     put unformat '零件编号' '$' '零件描述' '$' '提前期' '$' '需求日期' '$'
            'um' '$' '物料用量' '$' 'OPPO' '$' '当天库存' '$' '总需求' '$'
            '扣出WO及FCS多出物料' '$' 'MOQ' '$' '组别' '$' '毛需求' '$'
            '预计库存' '$' '短缺数量' '$' '入库日期' '$' '下达日期' '$'
            '需求单号' '$' '编号/项次' '$'
            /*'明细' '$' *ss-130129.1*/
            'p/m' '$' '状态'
            /*ss-130129.1 -b */
            '$' '成品测料日期' '$' '测料需求量' '$' '测料日期前总需求'
            '$' '测料日期前Open_PO' '$' '测料日期后Open_PO'
            '$' '库存' '$' '是否欠料' '$' '测料明细说明'
            /*ss-130129.1 -e */
            skip.

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
                v_ord_mult = ptp_ord_mult
                v_phantom = ptp_phantom.
        end.

        find pt_mstr where pt_part = a6rq_part no-lock no-error.
        if available pt_mstr then do:
            assign
                desc1 = pt_desc1.
        end.

        if available(pt_mstr) and (not(available(ptp_det))) then do:
            assign
                v_buyer = pt_buyer
                v_pm_code = pt_pm_code
                v_ord_min = pt_ord_min
                v_ord_mult = pt_ord_mult
                v_phantom = pt_phantom.
        end.
        /*ss-130206.1 -b *
        put skip (2).
        put '地点:' at 2 a6rq_site
            '客户代码:' at 17 a6rq_cust
            '客户地址:' at 37 skip.
        put '物料编号:' at 2 a6rq_part
            '描述:' at  32   desc1
            '需求数量:' at 64  a6rq_rq_qty skip.
        put 'p/m:' at 2 v_pm_code
            'buyer  ' at 17 v_buyer
            'ord-min ' at 32 v_ord_min
            'ord_mult '  at 64 v_ord_mult skip.
        put '客采单号:'  at 2 a6rq_custpono
            '项次:'  at  17 a6rq_custpoln
            '需求日期:' at 64  a6rq_due_date  skip.
        put fill("=", 88) format 'x(200)' skip.
        *ss-130206.1 -b */

        /* put '项次     零件编号           零件描述                  提前期    需求日期 um        毛需求     预计库存    短缺数量 入库日期 下达日期 需求单号          编号/项次 明细     p/m   buyer ord_min   ord_mult' skip. */

        for each a6rqd_det
            where a6rqd_site = a6rq_site
                and a6rqd_cust = a6rq_cust
                and a6rqd_custpono = a6rq_custpono
                and a6rqd_custpoln = a6rq_custpoln
            no-lock
            break by a6rqd_custpono by a6rqd_custpoln by a6rqd_part: /* by a6rqd_sort */
            if first-of(a6rqd_part) then
               v_a6rqd_rq_qty = 0.

            v_a6rqd_rq_qty = v_a6rqd_rq_qty + a6rqd_rq_qty.
            if last-of(a6rqd_part) then do:
            /*ss-130129.1 -e */

                 find pt_mstr where pt_part = a6rqd_part no-lock no-error.
                 if available pt_mstr then do:
                     assign
                     desc1 = pt_desc1
                     sStatus = pt_status.
                     v_phantom = pt_phantom.
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
                     v_phantom = ptp_phantom.
                 end.

                 if available(pt_mstr) and (not(available(ptp_det))) then do:
                     assign
                         v_buyer = pt_buyer
                         v_pm_code = pt_pm_code
                         v_ord_min = pt_ord_min
                         v_ord_mult = pt_ord_mult
                         decSaftyStock = pt_sfty_stk
                         dMOQ = pt_ord_min
                         v_phantom = pt_phantom.
                 end.

                 if (a6rqd_rq_qty - a6rqd_short_qty ) >= 0 then assign qty_oh = a6rqd_rq_qty - a6rqd_short_qty.
                 else assign qty_oh = 0.

                 assign ln = string (a6rqd_custpoln )
                        nbr = a6rqd_custpono.


                 dtePeriodStart = getStart(a6rqd_rq_date).
                 dtePeriodFinish = dtePeriodStart + 6.

                 {xxa6simrp1openpo.i
                     a6rqd_part
                     a6rqd_site
                     a6rqd_rq_date
                     decOpenPOQty
                     decOpenPOQtyum
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


                 /*ss-130129.1 -b */
                 before_simdate_demand = 0. v_rmks = "".
                 after_simdate_oppo = 0. before_simdate_oppo = 0.

                 for each mrp_det no-lock where mrp_dataset = 'pod_det'
                 and mrp_type = 'supply' and mrp_part = a6rqd_part :
                     if mrp_due <= a6rq_due_date then
                        before_simdate_oppo = before_simdate_oppo + mrp_qty.
                     else
                        after_simdate_oppo = after_simdate_oppo + mrp_qty.
                 end.
                 for each mrp_det no-lock where mrp_type = 'demand'
                 and mrp_part = a6rqd_part and mrp_due <= a6rq_due_date:
                     before_simdate_demand = before_simdate_demand + mrp_qty.
                 end.
                 if (decInventory + before_simdate_oppo
                    - before_simdate_demand - v_a6rqd_rq_qty < 0) and
                    (decInventory + before_simdate_oppo + after_simdate_oppo
                    - before_simdate_demand - v_a6rqd_rq_qty < 0)
                 then v_rmks = "欠料区,库存不足,出新PO".
                 if (decInventory + before_simdate_oppo
                    - before_simdate_demand - v_a6rqd_rq_qty < 0) and
                    (decInventory + before_simdate_oppo + after_simdate_oppo
                    - before_simdate_demand - v_a6rqd_rq_qty >= 0)
                 then v_rmks = "欠料区,库存不足,加快PO".

                 if (decInventory + before_simdate_oppo
                    - before_simdate_demand - v_a6rqd_rq_qty >= 0) and
                    (decInventory - before_simdate_demand - v_a6rqd_rq_qty < 0)
                 then v_rmks = "过期区,库存不足,采购跟进".

                 /* ss - 130301.1 -b */
                  if (decInventory + before_simdate_oppo
                    - before_simdate_demand - v_a6rqd_rq_qty >= 0) and
                    (decInventory - before_simdate_demand - v_a6rqd_rq_qty >= 0)
                 then v_rmks = "潜在欠料区,可挪用加快PO，采购跟进".
                 /* ss - 130301.1 -e */
                 if (decInventory + before_simdate_oppo
                    - decDemandQty - v_a6rqd_rq_qty >= 0) and
                    (decInventory - decDemandQty - v_a6rqd_rq_qty >= 0)
                 then v_rmks = "安全区,库存足".
                 /*ss-130129.1 -e */
                 /*ss-130206.1-b*/


/*                  if v_sort_opt = 2 then do:                                                                                                        */
/*                      if a6rqd_zone = 2  or a6rqd_zone = 4 or a6rqd_zone = 6 then do:                                                               */
/*                          put skip (1).                                                                                                             */
/*                          put                                                                                                                       */
/*                          a6rqd_part at 1 '~t'                                                                                                      */
/*                          desc1 '~t'                                                                                                                */
/*                          a6rqd_lt '~t'                                                                                                             */
/*                          a6rqd_rq_date '~t'                                                                                                        */
/*                          pt_um '~t'                                                                                                                */
/*                          decBomSummary  '~t'                                                                                                       */
/*                          decOpenPOQty   '~t'                                                                                                       */
/*                          decInventory   '~t'                                                                                                       */
/*                          decDemandQty   '~t'                                                                                                       */
/*                          decPlan1 format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                              */
/*                          dMOQ           '~t'                                                                                                       */
/*                          v_buyer        '~t'                                                                                                       */
/*                          a6rqd_rq_qty '~t'                                                                                                         */
/*                          dec(a6rqd_char02)  format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                    */
/*                          decShort '~t'                                                                                                             */
/*                          a6rqd_due_date '~t'                                                                                                       */
/*                          a6rqd_rel_date '~t'                                                                                                       */
/*                          nbr   format "x(40)" '~t'                                                                                                 */
/*                          ln '~t'                                                                                                                   */
/*                          a6rqd_remark '~t'                                                                                                         */
/*                          v_pm_code '~t'                                                                                                            */
/*                          sStatus '~t'                                                                                                              */
/*                          /*ss-130129.1 -b */                                                                                                       */
/*                          a6rq_due_date         '~t'                                                                                                */
/*                          a6rqd_rq_qty          '~t'                                                                                                */
/*                          before_simdate_demand '~t'                                                                                                */
/*                          before_simdate_oppo   '~t'                                                                                                */
/*                          after_simdate_oppo    '~t'                                                                                                */
/*                          decInventory          '~t'                                                                                                */
/*                          decInventory + before_simdate_oppo                                                                                        */
/*                          - before_simdate_demand - a6rqd_rq_qty '~t'                                                                               */
/*                          v_rmks                                                                                                                    */
/*                          /*ss-130129.1 -e */                                                                                                       */
/*                                                                                                                                                    */
/*                          skip                                                                                                                      */
/* .                                                                                                                                                  */
/*                                                                                                                                                    */
/*                          for each a6rrd_det                                                                                                        */
/*                              where a6rrd_site = a6rqd_site                                                                                         */
/*                                  and a6rrd_cust = a6rqd_cust                                                                                       */
/*                                  and a6rrd_custpono = a6rqd_custpono                                                                               */
/*                                  and a6rrd_custpoln = a6rqd_custpoln                                                                               */
/*                                  and a6rrd_part = a6rqd_part                                                                                       */
/*                              no-lock :                                                                                                             */
/*                                                                                                                                                    */
/*                              if (a6rrd_rq_qty - a6rrd_short_qty ) >= 0 then assign qty_oh = a6rrd_rq_qty - a6rrd_short_qty.                        */
/*                              else assign qty_oh = 0.                                                                                               */
/*                                                                                                                                                    */
/*                              find first mrp_det where mrp_dataset = "ss_fcs_sum"  and  mrp_nbr = a6rrd_rel_ord use-index mrp_nbr no-lock no-error. */
/*                              if available mrp_det then                                                                                             */
/*                                  assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord + " " + mrp_detail.       */
/*                              else                                                                                                                  */
/*                                  assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord.                          */
/*                                                                                                                                                    */
/*                              dtePeriodStart = getStart(a6rrd_rq_date).                                                                             */
/*                              dtePeriodFinish = dtePeriodStart + 6.                                                                                 */
/*                                                                                                                                                    */
/*                              {xxa6simrp1openpo.i                                                                                                   */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  a6rrd_rq_date                                                                                                     */
/*                                  decOpenPOQty                                                                                                      */
/*                                  decOpenPOQtyum                                                                                                    */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              {xxa6simrp1inventory.i                                                                                                */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  decInventory                                                                                                      */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              {xxa6simrp1demand.i                                                                                                   */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  dtePeriodStart                                                                                                    */
/*                                  dtePeriodFinish                                                                                                   */
/*                                  decDemandQty                                                                                                      */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              {xxa6simrp1openwo.i                                                                                                   */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  a6rrd_rq_date                                                                                                     */
/*                                  decOpenWOQty                                                                                                      */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.                                 */
/*                              decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.                                                */
/*                                                                                                                                                    */
/*                              /*ss-130129.1 -b */                                                                                                   */
/*                              before_simdate_demand = 0. v_rmks = "".                                                                               */
/*                              after_simdate_oppo = 0. before_simdate_oppo = 0.                                                                      */
/*                              for each mrp_det no-lock where mrp_dataset = 'pod_det'                                                                */
/*                              and mrp_type = 'supply' and mrp_part = a6rrd_part :                                                                   */
/*                                  if mrp_due <= a6rq_due_date then                                                                                  */
/*                                     before_simdate_oppo = before_simdate_oppo + mrp_qty.                                                           */
/*                                  else                                                                                                              */
/*                                     after_simdate_oppo = after_simdate_oppo + mrp_qty.                                                             */
/*                              end.                                                                                                                  */
/*                              for each mrp_det no-lock where mrp_type = 'demand'                                                                    */
/*                              and mrp_part = a6rrd_part and mrp_due <= a6rq_due_date:                                                               */
/*                                  before_simdate_demand = before_simdate_demand + mrp_qty.                                                          */
/*                              end.                                                                                                                  */
/*                              if (decInventory + before_simdate_oppo                                                                                */
/*                                 - before_simdate_demand - a6rrd_rq_qty < 0) and                                                                    */
/*                                 (decInventory + before_simdate_oppo + after_simdate_oppo                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty < 0)                                                                        */
/*                              then v_rmks = "欠料区,库存不足,出新PO".                                                                               */
/*                              else if (decInventory + before_simdate_oppo                                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty < 0) and                                                                    */
/*                                 (decInventory + before_simdate_oppo + after_simdate_oppo                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty >= 0)                                                                       */
/*                              then v_rmks = "欠料区,库存不足,加快PO".                                                                               */
/*                              else if (decInventory + before_simdate_oppo                                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty >= 0) and                                                                   */
/*                                 (decInventory - before_simdate_demand - a6rrd_rq_qty < 0)                                                          */
/*                              then v_rmks = "过期区,库存不足,采购跟进".                                                                             */
/*                              else if (decInventory + before_simdate_oppo                                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty >= 0) and                                                                   */
/*                                 (decInventory - before_simdate_demand - a6rrd_rq_qty >= 0)                                                         */
/*                              then v_rmks = "安全区,库存足".                                                                                        */
/*                              /*ss-130129.1 -e */                                                                                                   */
/*                                                                                                                                                    */
/*                              put                                                                                                                   */
/*                              a6rrd_part at 1 '~t'                                                                                                  */
/*                              desc1 '~t'                                                                                                            */
/*                              a6rqd_lt '~t'                                                                                                         */
/*                              a6rrd_rq_date '~t'                                                                                                    */
/*                              pt_um  '~t'                                                                                                           */
/*                              decBomSummary   '~t'                                                                                                  */
/*                              decOpenPOQtyum  '~t'                                                                                                  */
/*                              decInventory    '~t'                                                                                                  */
/*                              decDemandQty    '~t'                                                                                                  */
/*                              decPlan1         format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                  */
/*                              dMOQ            '~t'                                                                                                  */
/*                              v_buyer         '~t'                                                                                                  */
/*                              a6rrd_rq_qty    '~t'                                                                                                  */
/*                              dec (a6rrd_desc) format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                  */
/*                              decShort '~t'                                                                                                         */
/*                              a6rrd_due_date '~t'                                                                                                   */
/*                              a6rrd_rel_date '~t'                                                                                                   */
/*                              nbr  format "x(40)" '~t'                                                                                              */
/*                              ln '~t'                                                                                                               */
/*                              a6rrd_remark '~t'                                                                                                     */
/*                              v_pm_code '~t'                                                                                                        */
/*                              sStatus                                                                                                               */
/*                              /*ss-130129.1 -b */                                                                                                   */
/*                              a6rq_due_date         '~t'                                                                                            */
/*                              a6rrd_rq_qty          '~t'                                                                                            */
/*                              before_simdate_demand '~t'                                                                                            */
/*                              before_simdate_oppo   '~t'                                                                                            */
/*                              after_simdate_oppo    '~t'                                                                                            */
/*                              decInventory          '~t'                                                                                            */
/*                              decInventory + before_simdate_oppo                                                                                    */
/*                              - before_simdate_demand - a6rrd_rq_qty '~t'                                                                           */
/*                              v_rmks                                                                                                                */
/*                              /*ss-130129.1 -e */                                                                                                   */
/*                              skip                                                                                                                  */
/* .                                                                                                                                                  */
/*                          end.                                                                                                                      */
/*                      end. /* end if a6rqd_zone = 2  or a6rqd_zone = 4 or a6rqd_zone = 6 */                                                         */
/*                                                                                                                                                    */
/*                      find first a6rrd_det                                                                                                          */
/*                          where a6rrd_site = a6rqd_site                                                                                             */
/*                              and a6rrd_cust = a6rqd_cust                                                                                           */
/*                              and a6rrd_custpono = a6rqd_custpono                                                                                   */
/*                              and a6rrd_custpoln = a6rqd_custpoln                                                                                   */
/*                              and a6rrd_part = a6rqd_part                                                                                           */
/*                          no-lock                                                                                                                   */
/*                          no-error.                                                                                                                 */
/*                      if available a6rrd_det and a6rqd_zone = 3  then do:   /*a6rqd_zone = 3 ??? */                                                 */
/*                                                                                                                                                    */
/*                                                                                                                                                    */
/*                            dtePeriodStart = getStart(a6rqd_rq_date).                                                                               */
/*                            dtePeriodFinish = dtePeriodStart + 6.                                                                                   */
/*                                                                                                                                                    */
/*                            {xxa6simrp1openpo.i                                                                                                     */
/*                                a6rqd_part                                                                                                          */
/*                                a6rrd_site                                                                                                          */
/*                                a6rqd_rq_date                                                                                                       */
/*                                decOpenPOQty                                                                                                        */
/*                                decOpenPOQtyum                                                                                                      */
/*                            }                                                                                                                       */
/*                                                                                                                                                    */
/*                            {xxa6simrp1inventory.i                                                                                                  */
/*                                a6rqd_part                                                                                                          */
/*                                a6rqd_site                                                                                                          */
/*                                decInventory                                                                                                        */
/*                            }                                                                                                                       */
/*                                                                                                                                                    */
/*                            {xxa6simrp1demand.i                                                                                                     */
/*                                a6rqd_part                                                                                                          */
/*                                a6rqd_site                                                                                                          */
/*                                dtePeriodStart                                                                                                      */
/*                                dtePeriodFinish                                                                                                     */
/*                                decDemandQty                                                                                                        */
/*                            }                                                                                                                       */
/*                                                                                                                                                    */
/*                            {xxa6simrp1openwo.i                                                                                                     */
/*                                a6rqd_part                                                                                                          */
/*                                a6rqd_site                                                                                                          */
/*                                a6rqd_rq_date                                                                                                       */
/*                                decOpenWOQty                                                                                                        */
/*                            }                                                                                                                       */
/*                                                                                                                                                    */
/*                            decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.                                   */
/*                            decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.                                                  */
/*                                                                                                                                                    */
/*                            put skip (1).                                                                                                           */
/*                            put                                                                                                                     */
/*                            a6rqd_part at 1                                                                                                         */
/*                            '~t'                                                                                                                    */
/*                            desc1                                                                                                                   */
/*                            '~t'                                                                                                                    */
/*                            a6rqd_lt                                                                                                                */
/*                            '~t'                                                                                                                    */
/*                            a6rqd_rq_date                                                                                                           */
/*                            '~t'                                                                                                                    */
/*                            pt_um                                                                                                                   */
/*                            '~t'                                                                                                                    */
/*                            decBomSummary   '~t'                                                                                                    */
/*                            decOpenPOQtyum  '~t'                                                                                                    */
/*                            decInventory    '~t'                                                                                                    */
/*                            decDemandQty    '~t'                                                                                                    */
/*                            decPlan1  format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                           */
/*                            dMOQ            '~t'                                                                                                    */
/*                            v_buyer         '~t'                                                                                                    */
/*                            a6rqd_rq_qty    '~t'                                                                                                    */
/*                            dec(a6rqd_char02)  format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                  */
/*                            decShort                    '~t'                                                                                        */
/*                            a6rqd_due_date          '~t'                                                                                            */
/*                            a6rqd_rel_date          '~t'                                                                                            */
/*                            nbr   format "x(40)"        '~t'                                                                                        */
/*                            ln                          '~t'                                                                                        */
/*                            a6rqd_remark '~t'                                                                                                       */
/*                            v_pm_code '~t'                                                                                                          */
/*                            sStatus '~t'                                                                                                            */
/*                            skip.                                                                                                                   */
/*                                                                                                                                                    */
/*                          for each a6rrd_det                                                                                                        */
/*                              where a6rrd_site = a6rqd_site                                                                                         */
/*                                  and a6rrd_cust = a6rqd_cust                                                                                       */
/*                                  and a6rrd_custpono = a6rqd_custpono                                                                               */
/*                                  and a6rrd_custpoln = a6rqd_custpoln                                                                               */
/*                                  and a6rrd_part = a6rqd_part                                                                                       */
/*                              no-lock :                                                                                                             */
/*                                                                                                                                                    */
/*                              if (a6rrd_rq_qty - a6rrd_short_qty ) >= 0 then assign qty_oh = a6rrd_rq_qty - a6rrd_short_qty.                        */
/*                              else assign qty_oh = 0.                                                                                               */
/*                                                                                                                                                    */
/*                              find first mrp_det where mrp_dataset = "ss_fcs_sum"  and  mrp_nbr = a6rrd_rel_ord use-index mrp_nbr no-lock no-error. */
/*                              if available mrp_det then                                                                                             */
/*                                  assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord + " " + mrp_detail.       */
/*                              else                                                                                                                  */
/*                                  assign ln = a6rrd_rel_id  nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord.                          */
/*                                                                                                                                                    */
/*                              dtePeriodStart = getStart(a6rrd_rq_date).                                                                             */
/*                              dtePeriodFinish = dtePeriodStart + 6.                                                                                 */
/*                                                                                                                                                    */
/*                              {xxa6simrp1openpo.i                                                                                                   */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  a6rrd_rq_date                                                                                                     */
/*                                  decOpenPOQty                                                                                                      */
/*                                  decOpenPOQtyum                                                                                                    */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              {xxa6simrp1inventory.i                                                                                                */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  decInventory                                                                                                      */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              {xxa6simrp1demand.i                                                                                                   */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  dtePeriodStart                                                                                                    */
/*                                  dtePeriodFinish                                                                                                   */
/*                                  decDemandQty                                                                                                      */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              {xxa6simrp1openwo.i                                                                                                   */
/*                                  a6rrd_part                                                                                                        */
/*                                  a6rrd_site                                                                                                        */
/*                                  a6rrd_rq_date                                                                                                     */
/*                                  decOpenWOQty                                                                                                      */
/*                              }                                                                                                                     */
/*                                                                                                                                                    */
/*                              decPlan1 = decInventory + decOpenPOQty + decOpenWOQty - decSaftyStock - decDemandQty.                                 */
/*                              decShort = decInventory + decOpenWOQty - decSaftyStock - decDemandQty.                                                */
/*                                                                                                                                                    */
/*                              /*ss-130129.1 -b */                                                                                                   */
/*                              before_simdate_demand = 0. v_rmks = "".                                                                               */
/*                              after_simdate_oppo = 0. before_simdate_oppo = 0.                                                                      */
/*                              for each mrp_det no-lock where mrp_dataset = 'pod_det'                                                                */
/*                              and mrp_type = 'supply' and mrp_part = a6rrd_part :                                                                   */
/*                                  if mrp_due <= a6rq_due_date then                                                                                  */
/*                                     before_simdate_oppo = before_simdate_oppo + mrp_qty.                                                           */
/*                                  else                                                                                                              */
/*                                     after_simdate_oppo = after_simdate_oppo + mrp_qty.                                                             */
/*                              end.                                                                                                                  */
/*                              for each mrp_det no-lock where mrp_type = 'demand'                                                                    */
/*                              and mrp_part = a6rrd_part and mrp_due <= a6rq_due_date:                                                               */
/*                                  before_simdate_demand = before_simdate_demand + mrp_qty.                                                          */
/*                              end.                                                                                                                  */
/*                              if (decInventory + before_simdate_oppo                                                                                */
/*                                 - before_simdate_demand - a6rrd_rq_qty < 0) and                                                                    */
/*                                 (decInventory + before_simdate_oppo + after_simdate_oppo                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty < 0)                                                                        */
/*                              then v_rmks = "欠料区,库存不足,出新PO".                                                                               */
/*                              else if (decInventory + before_simdate_oppo                                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty < 0) and                                                                    */
/*                                 (decInventory + before_simdate_oppo + after_simdate_oppo                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty >= 0)                                                                       */
/*                              then v_rmks = "欠料区,库存不足,加快PO".                                                                               */
/*                              else if (decInventory + before_simdate_oppo                                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty >= 0) and                                                                   */
/*                                 (decInventory - before_simdate_demand - a6rrd_rq_qty < 0)                                                          */
/*                              then v_rmks = "过期区,库存不足,采购跟进".                                                                             */
/*                              else if (decInventory + before_simdate_oppo                                                                           */
/*                                 - before_simdate_demand - a6rrd_rq_qty >= 0) and                                                                   */
/*                                 (decInventory - before_simdate_demand - a6rrd_rq_qty >= 0)                                                         */
/*                              then v_rmks = "安全区,库存足".                                                                                        */
/*                              /*ss-130129.1 -e */                                                                                                   */
/*                                                                                                                                                    */
/*                              put unformat                                                                                                          */
/*                              a6rrd_part at 1                                                                                                       */
/*                              '~t'                                                                                                                  */
/*                              desc1                                                                                                                 */
/*                              '~t'                                                                                                                  */
/*                              a6rqd_lt                                                                                                              */
/*                              '~t'                                                                                                                  */
/*                              a6rrd_rq_date                                                                                                         */
/*                              '~t'                                                                                                                  */
/*                              pt_um                                                                                                                 */
/*                              '~t'                                                                                                                  */
/*                              decBomSummary   '~t'                                                                                                  */
/*                              decOpenPOQtyum  '~t'                                                                                                  */
/*                              decInventory    '~t'                                                                                                  */
/*                              decDemandQty    '~t'                                                                                                  */
/*                              decPlan1  format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                         */
/*                              dMOQ            '~t'                                                                                                  */
/*                              v_buyer         '~t'                                                                                                  */
/*                              a6rrd_rq_qty    '~t'                                                                                                  */
/*                              dec (a6rrd_desc) format "->,>>>,>>>,>>9.<<<<<<" '~t'                                                                  */
/*                              decShort        '~t'                                                                                                  */
/*                              a6rrd_due_date '~t'                                                                                                   */
/*                              a6rrd_rel_date '~t'                                                                                                   */
/*                              nbr  format "x(40)" '~t'                                                                                              */
/*                              ln '~t'                                                                                                               */
/*                              a6rrd_remark '~t'                                                                                                     */
/*                              v_pm_code '~t'                                                                                                        */
/*                              sStatus '~t'                                                                                                          */
/*                              /*ss-130129.1 -b */                                                                                                   */
/*                              a6rq_due_date         '~t'                                                                                            */
/*                              a6rrd_rq_qty          '~t'                                                                                            */
/*                              before_simdate_demand '~t'                                                                                            */
/*                              before_simdate_oppo   '~t'                                                                                            */
/*                              after_simdate_oppo    '~t'                                                                                            */
/*                              decInventory          '~t'                                                                                            */
/*                              decInventory + before_simdate_oppo                                                                                    */
/*                              - before_simdate_demand - a6rrd_rq_qty '~t'                                                                           */
/*                              v_rmks                                                                                                                */
/*                              /*ss-130129.1 -e */                                                                                                   */
/*                              skip.                                                                                                                 */
/*                          end.                                                                                                                      */
/*                      end.                                                                                                                          */
/*                  end.                                                                                                                              */
/*                  else                                                                                                                              */
/*                                                                                                                                                    */

                 /*ss-130206.1-e*/
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
                     put skip (1).
                     /*v_rmks = convRemark(input v_pm_code,input a6rqd_zone). ss-130129.1 */
/*130507.1_2*/       if v_phantom = NO then do:
                        put /* ss - 130227.1 -b */ unformatted    /* ss - 130227.1 -b */
                        a6rqd_part                   '$'
                        desc1                        '$'
                        a6rqd_lt                     '$'
                        "'" + string(a6rqd_rq_date)  '$'
                        pt_um  '$'
                        decBomSummary                format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decOpenPOQtyum               format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decInventory                 format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decDemandQty                 format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decInventory  - decDemandQty format "->,>>>,>>>,>>9.<<<<<<" '$'
                        dMOQ                         '$'
                        v_buyer                      '$'
                        v_a6rqd_rq_qty               format "->,>>>,>>>,>>9.<<<<<<" '$'
                        /*a6rqd_rq_qty ss-130129.1*/
                        decOpenPOQty + decInventory  format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decInventory - mrpqty        format "->,>>>,>>>,>>9.<<<<<<" '$'
                        "'" + string(a6rqd_due_date) '$'
                        "'" + string(a6rqd_rel_date) '$'
                        nbr                          format "x(40)" '$'
                        ln                           '$'
                        /*v_rmks format "x(30)" '$'*/
                        v_pm_code                    '$'
                        sStatus                      '$'
                        /*ss-130129.1 -b */
                        "'" + string(a6rq_due_date)  '$'
                        v_a6rqd_rq_qty               format "->,>>>,>>>,>>9.<<<<<<" '$'
                        before_simdate_demand        format "->,>>>,>>>,>>9.<<<<<<" '$'
                        before_simdate_oppo          format "->,>>>,>>>,>>9.<<<<<<" '$'
                        after_simdate_oppo           format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decInventory                 format "->,>>>,>>>,>>9.<<<<<<" '$'
                        decInventory + before_simdate_oppo
                        - before_simdate_demand
                        - v_a6rqd_rq_qty             format "->,>>>,>>>,>>9.<<<<<<" '$'
                        v_rmks
                        /*ss-130129.1 -e */
                        skip.
/*130507.1_2*/       end. /* if v_phantom = NO then do: */
                     for each a6rrd_det where a6rrd_site = a6rqd_site and a6rrd_cust = a6rqd_cust
                         and a6rrd_custpono = a6rqd_custpono and a6rrd_custpoln = a6rqd_custpoln
                         and a6rrd_part = a6rqd_part no-lock
                         /*ss-130206.1 -b */
                         break by a6rrd_site by a6rrd_custpono by a6rrd_custpoln by a6rrd_part
                         :
                         if first-of(a6rrd_part) then
                            v_a6rrd_rq_qty = 0.

                            v_a6rrd_rq_qty = v_a6rrd_rq_qty + a6rrd_rq_qty.

                         if last-of(a6rrd_part) then do:
                         /*ss-130206.1 -e */
                             if (a6rrd_rq_qty - a6rrd_short_qty ) >= 0 then
                                assign qty_oh = a6rrd_rq_qty - a6rrd_short_qty.
                             else
                                assign qty_oh = 0.

                             assign ln  = a6rrd_rel_id
                                    nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord.

                             find first mrp_det where mrp_dataset = "ss_fcs_sum"
                             and  mrp_nbr = a6rrd_rel_ord use-index mrp_nbr no-lock no-error.
                             if available mrp_det then
                                assign ln = a6rrd_rel_id
                                       nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord + " " + mrp_detail.
                             else
                                assign ln = a6rrd_rel_id
                                       nbr = substring (a6rrd_ord_type , 1,2) + ":" +  a6rrd_rel_ord.

                             dtePeriodStart  = getStart(a6rrd_rq_date).
                             dtePeriodFinish = dtePeriodStart + 6.

                             {xxa6simrp1openpo.i
                                 a6rrd_part
                                 a6rrd_site
                                 a6rrd_rq_date
                                 decOpenPOQty
                                 decOpenPOQtyum
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

                             /*ss-130129.1 -b */
                             /*v_rmks = convRemark(input v_pm_code,input a6rrd_zone).**ss-130129.1*/
                             before_simdate_demand = 0. v_rmks = "".
                             after_simdate_oppo = 0. before_simdate_oppo = 0.
                             for each mrp_det no-lock where mrp_dataset = 'pod_det'
                             and mrp_type = 'supply' and mrp_part = a6rrd_part :
                                 if mrp_due <= a6rq_due_date then
                                    before_simdate_oppo = before_simdate_oppo + mrp_qty.
                                 else
                                    after_simdate_oppo = after_simdate_oppo + mrp_qty.
                             end.
                             for each mrp_det no-lock where mrp_type = 'demand'
                             and mrp_part = a6rrd_part and mrp_due <= a6rq_due_date:
                                 before_simdate_demand = before_simdate_demand + mrp_qty.
                             end.
                             if (decInventory + before_simdate_oppo
                                - before_simdate_demand - v_a6rrd_rq_qty < 0) and
                                (decInventory + before_simdate_oppo + after_simdate_oppo
                                - before_simdate_demand - v_a6rrd_rq_qty < 0)
                             then v_rmks = "欠料区,库存不足,出新PO".
                             if (decInventory + before_simdate_oppo
                                - before_simdate_demand - v_a6rrd_rq_qty < 0) and
                                (decInventory + before_simdate_oppo + after_simdate_oppo
                                - before_simdate_demand - v_a6rrd_rq_qty >= 0)
                             then v_rmks = "欠料区,库存不足,加快PO".
                             if (decInventory + before_simdate_oppo
                                - before_simdate_demand - v_a6rrd_rq_qty >= 0) and
                                (decInventory - before_simdate_demand - v_a6rrd_rq_qty < 0)
                             then v_rmks = "过期区,库存不足,采购跟进".
                             /* ss - 130301.1 -b */
                             if (decInventory + before_simdate_oppo
                                - before_simdate_demand - v_a6rrd_rq_qty >= 0) and
                                (decInventory - before_simdate_demand - v_a6rrd_rq_qty >= 0)
                             then v_rmks = "潜在欠料区,可挪用加快PO，采购跟进".
                             /* ss - 130301.1 -e */
                             if (decInventory + before_simdate_oppo
                                - decDemandQty - v_a6rrd_rq_qty >= 0) and
                                (decInventory - decDemandQty - v_a6rrd_rq_qty >= 0)
                             then v_rmks = "安全区,库存足".
                             /*ss-130129.1 -e */
/*130507.1_2*/       if v_phantom = NO then do:
                             put  /* ss - 130227.1 -b */ unformatted    /* ss - 130227.1 -b */
                             a6rrd_part                       '$'
                             desc1                            '$'
                             a6rqd_lt                         '$'
                             "'" + string(a6rrd_rq_date)      '$'
                             pt_um                            '$'
                             decBomSummary                    format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decOpenPOQtyum                   format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decInventory                     format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decDemandQty                     format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decPlan1                         format "->,>>>,>>>,>>9.<<<<<<" '$'
                             dMOQ                             '$'
                             v_buyer                          '$'
                             v_a6rrd_rq_qty                   format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decOpenPOQty + decInventory      format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decInventory - mrpqty            format "->,>>>,>>>,>>9.<<<<<<" '$'
                             "'" + string(a6rrd_due_date)     '$'
                             "'" + string(a6rrd_rel_date)     '$'
                             nbr                              format "x(40)" '$'
                             ln                               '$'
                             /*v_rmks format "x(30)"          '$' *ss-130129.1*/
                             v_pm_code                        '$'
                             sStatus                          '$'
                             /*ss-130129.1 -b */
                             "'" + string(a6rq_due_date)      '$'
                             v_a6rrd_rq_qty                   '$'
                             before_simdate_demand            format "->,>>>,>>>,>>9.<<<<<<" '$'
                             before_simdate_oppo              format "->,>>>,>>>,>>9.<<<<<<" '$'
                             after_simdate_oppo               format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decInventory                     format "->,>>>,>>>,>>9.<<<<<<" '$'
                             decInventory + before_simdate_oppo
                             - before_simdate_demand
                             - v_a6rrd_rq_qty                 format "->,>>>,>>>,>>9.<<<<<<" '$'
                             v_rmks
                             /*ss-130129.1 -e */
                             skip.
/*130507.1_2*/              end. /*if v_phantom = NO then do:*/
                         end. /*if last-of(a6rrd_part)*/
                     end. /*for each a6rrd_det*/
                 end. /*if v_sort_opt = 1*/
            end. /*if last-of(a6rqd_part)*/
        end. /*for each a6rqd_det*/
    end. /*for each a6rq_mstr*/
    /*
    {mfrtrail.i}
    */
    {mfreset.i}
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
