/* xxrcrp01.p - xxrcrp01.p                 /*成品提货单退货单报表xxrcrp01.p*/*/
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp6    Interface:Character          */
/* ss - 20101104.1 by: Apple Tam                                             */
/* REVISION END                                                              */

/* ss - 20101208.1 by: Apple Tam */  /*增加汇总及地点*/
/* ss - 20120724.1 by: Zhang Yun */ /*增加SO_PO筛选条件及在报表上显示此栏位*/
/******************************************************************************/
{mfdtitle.i "120725.1"}

{cxcustom.i "xxrcrp01.p"}

define variable cust like ad_addr.
define variable cust1 like ad_addr.
define variable rdate like abs_shp_date.
define variable rdate1 like abs_shp_date.
define variable part like tr_part.
define variable part1 like tr_part.
define variable nbr like so_nbr.
define variable nbr1 like so_nbr.
define variable sopo like so_po.
define variable sopo1 like so_po.
define variable channel like so_channel.
define variable channel1 like so_channel.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc2.
define variable um like pt_um.
define variable category like sod_order_category.
define variable v_name as character format "x(8)".
define variable price like tr_price.
define variable amount like tr_price.
define variable v_userid like tr_userid.
define variable qty_ord like sod_qty_ord.
define variable v_channel as character format "x(16)".
define variable v_category as character format "x(16)".
define variable i as integer.
define variable sodrmks as character format "x(42)".

define variable desc3 like ad_name.

/*ss-20101208*/ define variable total_1 like sod_qty_ord.
/*ss-20101208*/ define variable total_2 like sod_qty_ord.
/*ss-20101208*/ define variable total_3 like tr_price.

rdate = TODAY.
rdate1 =TODAY .

{&ICTRRP02-P-TAG4}
form

   cust           colon 20  label "客户"
   cust1          label "To" colon 49 skip
   sopo           colon 20 label "客户订单"
   sopo1          label "To" colon 49 skip
   rdate          colon 20  label "日期"
   rdate1         label "To" colon 49 skip
   part           colon 20  label "零件号"
   part1          label "To" colon 49 skip
   nbr            colon 20  label "销售订单"
   nbr1           label "To" colon 49 skip
   channel        colon 20  label "销售渠道"
   channel1       label "To" colon 49 skip
with overlay frame a side-labels.
{&ICTRRP02-P-TAG5}


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if cust1 = hi_char then cust1 = "".
    if sopo1 = hi_char then sopo1 = "".
    if rdate = low_date then rdate = TODAY.
    if rdate1 = hi_date then rdate1 = TODAY.
    if part1 = hi_char then part1 = "".
    if nbr1 = hi_char then nbr1 = "".
    if channel1 = hi_char then channel1 = "".

   {&ICTRRP02-P-TAG6}

   if c-application-mode <> 'web' then
   {&ICTRRP02-P-TAG7}
   UPDATE cust cust1 sopo sopo1 rdate rdate1 part part1 nbr nbr1
          channel channel1
   with frame a.

   {wbrp06.i &command = update &fields = " cust cust1 sopo sopo1 rdate rdate1
              part part1 nbr nbr1 channel channel1" &frm = "a"}

   {&ICTRRP02-P-TAG8}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
       {mfquoter.i cust}
       {mfquoter.i cust1}
       {mfquoter.i sopo}
       {mfquoter.i sopo1}
       {mfquoter.i rdate}
       {mfquoter.i rdate1}
       {mfquoter.i part}
       {mfquoter.i part1}
       {mfquoter.i nbr}
       {mfquoter.i nbr1}
       {mfquoter.i channel}
       {mfquoter.i channel1}


      {&ICTRRP02-P-TAG12}
      if cust1 = "" then cust1 = hi_char.
      if sopo1 = "" then sopo1 = hi_char.
      if rdate = ? then rdate = TODAY.
      if rdate1 = ? then rdate1 = TODAY.
      if part1 = "" then part1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if channel1 = "" then channel1 = hi_char.

      {&ICTRRP02-P-TAG13}

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 420
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

 /*  {mfphead.i}*/
  i = 1.
put skip(1).

/*ss-20101208*/ total_1 = 0.
/*ss-20101208*/ total_2 = 0.
/*ss-20101208*/ total_3 = 0.
/*ss-20101208 b********************/
   form
        "------------" to 99
  "------------" to 126
  "---------------" to 158
  "合计:" at 75
  total_1 to 99
  total_2 to 126
  total_3 to 158
   with frame f_trail width 300 no-box no-attr-space no-labels.

/*ss-20101208 e********************/


  for each  so_mstr no-lock  WHERE so_domain = GLOBAL_domain
               AND (so_nbr >= nbr AND so_nbr <= nbr1)
               AND (so_cust >= cust AND so_cust <= cust1)
               AND (so_po >= sopo and so_po <= sopo1)
               AND (so_channel >= channel AND so_channel <= channel1),
     each abs_mstr no-lock where abs_domain = global_domain
                             and abs_order = so_nbr
         and abs_item >= part and abs_item <= part1
         AND  (abs_shp_date >= rdate AND abs_shp_date <= rdate1):
            /* with frame bb width 260 no-attr-space no-box:*/


      {mfrpchk.i}
        desc1 = "".
        desc2 = "".
        um = "".
         find first pt_mstr where pt_domain = global_domain
                        and pt_part = abs_item
            no-lock no-error.
        if available pt_mstr then do:
           desc1 = pt_desc1.
           desc2 = pt_desc2.
           um = pt_um.
        end.

  v_category = "".
  qty_ord = 0.
  assign sodrmks = "".
  find first sod_det where sod_domain = global_domain
                                and sod_nbr = so_nbr
              and sod_line = integer(abs_line)
              no-lock no-error.
           find first cmt_det no-lock where cmt_domain = global_domain
                  and cmt_indx = sod_cmtindx and cmt_type = "SO" no-error.
           if available cmt_det then do:
              assign sodrmks = cmt_cmmt[1].
           end.
           if available sod_det then do:
              qty_ord = sod_qty_ord.
              find first code_mstr where code_domain = global_domain
                     and code_fldname = "line_category"
                     and code_value = sod_order_category
                   no-lock no-error.
              if available code_mstr then do:
                 v_category = code_cmmt.
              end.
           end.

  v_name = "".
  find first ad_mstr where ad_domain = global_domain
         and ad_addr = so_slspsn[1] no-lock no-error.
           if available ad_mstr then do:
               v_name = ad_name.
           end.

  desc3 = "".
  find first ad_mstr where ad_domain = global_domain
         and ad_addr = so_cust no-lock no-error.
           if available ad_mstr then do:
              desc3 = ad_name.
           end.
  v_channel = "".
  find first code_mstr where code_domain = global_domain
         and code_fldname = "so_channel"
         and code_value = so_channel no-lock no-error.
         if available code_mstr then do:
              v_channel = code_cmmt.
         end.
  price = 0.
  /* v_userid = "".*/
  amount = 0.
  find first tr_hist where tr_domain = global_domain
         and tr_type = "ISS-SO"
         and tr_nbr = so_nbr
         and tr_line = integer(abs_line) no-lock no-error.
   if available tr_hist then do:
        price = tr_price.
        /*v_userid = tr_userid.*/
        amount = price * abs_ship_qty.
   end.

  if abs_ship_qty <> 0 then do:

      if i = 1 then do:
        display so_po label "客户订单"
                abs_order label "销售订单"
                abs_line  label "项次" format "x(4)"
                desc3 label "客户名"
                substring(abs_id,3,8) label "货运单"
                abs_shp_date label "提货日期"
                abs_item  label "成品编码"
                desc1 label "描述1"
                desc2 label "描述2"
                um label "单位"  format "x(4)"
                qty_ord label "销售订单数量" format "->,>>>,>>9.9<<<<<<<<"
                abs_ship_qty label "提货数量" format "->,>>>,>>9.9<<<<<<<<"
                price label "单价" format "->>>,9.9<<<"
                amount label "金额"
                v_channel label "销售渠道"
                v_name label "业务员"
                v_category label "销售方式"
                so_userid label "提货人"
/*ss-20101208*/ so_site label "地点"
                sodrmks label "备注"
     with frame bb width 320 no-attr-space no-box.
  end.
  else do:
        display so_po no-label
                abs_order no-label
                abs_line no-label format "x(4)"
                desc3 no-label
                substring(abs_id,3,8) no-label
                abs_shp_date no-label
                abs_item no-label
                desc1 no-label
                desc2 no-label
                um no-label format "x(4)"
                qty_ord no-label  format "->,>>>,>>9.9<<<<<<<<"
                abs_ship_qty no-label  format "->,>>>,>>9.9<<<<<<<<"
                price no-label format "->>>,9.9<<<"
                amount no-label
                v_channel no-label
                v_name no-label
                v_category no-label
                so_userid no-label
/*ss-20101208*/ so_site no-label
                sodrmks no-label
      with frame cc width 320 no-attr-space no-box .
          end.
               i = 0.
/*ss-20101208*/ total_1 = total_1 + qty_ord.
/*ss-20101208*/ total_2 = total_2 + abs_ship_qty.
/*ss-20101208*/ total_3 = total_3 + amount.
        end.


   end.  /* FOR EACH */

/*ss-20101208 -b*/

    disp total_1 total_2 total_3 with frame f_trail.
/*ss-20101208 -e*/

   {mfrtrail.i}


end.  /* mainloop */

{wbrp04.i &frame-spec = a}

procedure getComm:

end procedure.
