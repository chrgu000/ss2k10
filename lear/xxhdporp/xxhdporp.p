/* DISPLAY TITLE */
{mfdtitle.i "93"}

/*********
1 定价类型不需要了,去掉相关内容吧.
2 明细行增加已开票价格（本位币及外币）
3 汇总行是未开票数  （本位币及外币）
4 支持供应商寄售业务

mv /home/yzhang32/qad2011/ch/xx/xxhdporp.r /tmp
cp /tmp/xxhdporp.r /corp/apps/China/Seating/qad/lear/rhqdvlp/dvlp1/ch/xx
***********/

define variable rdate like tr_date.
define variable rdate1 like tr_date.
define variable supp like vd_addr.
define variable supp1 like vd_addr.
define variable part like tr_part.
define variable part1 like tr_part.
define variable site like in_site.
define variable site1 like in_site.
define variable po-nbr like po_nbr.
define variable po-nbr1 like po_nbr.
DEFINE VARIABLE po-receiver LIKE prh_receiver.
DEFINE VARIABLE po-receiver1 LIKE prh_receiver.

/* define variable pctype AS CHAR FORMAT "x(2)" LABEL "定价类型".            */
define variable only-pz AS LOGICAL  LABEL "只显示未作凭证"  INITIAL NO.
DEFINE VARIABLE dis-detail AS LOGICAL LABEL "显示收货明细" INITIAL YES.
DEFINE VARIABLE dis-invoice AS LOGICAL LABEL "显示模拟发票" INITIAL YES.
DEFINE VARIABLE dis-qty AS LOGICAL FORMAT "R)收货数量/W)为作凭证数量" LABEL "使用 R)收货数量/W)未作凭证数量" INITIAL NO.
DEFINE VARIABLE dis-round AS INTEGER FORMAT "9" LABEL "采购金额精确位数"  INITIAL 2.
DEFINE VARIABLE dis-sp AS LOGICAL LABEL "分割收货单"  INITIAL NO.
DEFINE VARIABLE dis-group AS LOGICAL LABEL "分割零件组"  INITIAL NO.
DEFINE VARIABLE d_qty LIKE sr_qty.
DEFINE VARIABLE d_t_price LIKE prh_pur_cost.
DEFINE VARIABLE d_p_amt LIKE prh_pur_cost.
DEFINE VARIABLE d_t_amt LIKE prh_pur_cost.
DEFINE VARIABLE d_a_amt LIKE prh_pur_cost.
DEFINE VARIABLE e_qty LIKE sr_qty.
DEFINE VARIABLE e_p_amt LIKE prh_pur_cost.
DEFINE VARIABLE e_t_amt LIKE prh_pur_cost.
DEFINE VARIABLE e_a_amt LIKE prh_pur_cost.
DEFINE VARIABLE desc0 LIKE pt_desc1.
DEFINE VARIABLE desc1 LIKE ad_name.
DEFINE VARIABLE desc2 AS CHAR FORMAT "x(40)".
DEFINE VARIABLE desc3 AS CHAR FORMAT "x(40)".
DEFINE VARIABLE vouchered_base_amt AS decimal.
DEFINE VARIABLE v_vouchered_qty like pvo_vouchered_qty.
DEFINE VARIABLE v_vouchered_amt like vph_curr_amt.
DEFINE VARIABLE v_vouchered_price like vph_curr_amt.
DEFINE VARIABLE mc-erro-number AS INTEGER.
DEFINE VARIABLE base_pamt like prh_pur_cost.
DEFINE VARIABLE base_tamt like prh_pur_cost.
define variable base_aamt like prh_pur_cost.
DEFINE VARIABLE tot_base_pamt like prh_pur_cost.
DEFINE VARIABLE tot_base_tamt like prh_pur_cost.
define variable tot_base_aamt like prh_pur_cost.
define variable cnsuqty like cnsud_qty_used.

DEFINE TEMP-TABLE X_mstr
    FIELD X_curr LIKE prh_curr
    FIELD X_part LIKE pt_part
    FIELD X_qty LIKE sr_qty
    FIELD X_price LIKE prh_pur_cost
    FIELD X_p_amt LIKE prh_pur_cost
    FIELD X_t_amt LIKE prh_pur_cost
    FIELD X_group LIKE pt_group.

form
   rdate        colon 20
   rdate1       label "至" colon 49 skip
   supp         LABEL "供应商" colon 20
   supp1        label "至" colon 49 skip
   part         colon 20
   part1        label "至" colon 49 skip
   site         colon 20
   site1        label "至" colon 49 skip
   po-nbr       LABEL "采购单号"  colon 20
   po-nbr1      label "至" colon 49
   po-receiver  LABEL "收货单号"  colon 20
   po-receiver1 label "至" colon 49 skip(1)
/*   pctype       colon 40                                                   */
   only-pz      colon 40 SKIP
   dis-detail   colon 40 skip
   dis-invoice  colon 40 skip
   dis-qty      colon 40 skip
   dis-sp       colon 40 skip
   dis-group    colon 40 skip
   dis-round    colon 40 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if supp1 = hi_char then supp1 = "".
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if po-nbr1 = hi_char then po-nbr1 = "".
   if po-receiver1 = hi_char then po-receiver1 = "".
   if rdate = low_date then rdate = ?.
   if rdate1 = hi_date then rdate1 = ?.

   if c-application-mode <> 'web' then
      update rdate rdate1 supp supp1 part part1 site site1 po-nbr po-nbr1
             po-receiver po-receiver1 /* pctype */ only-pz dis-detail
             dis-invoice dis-qty dis-sp dis-group dis-round with frame a.

   {wbrp06.i &command = update &fields = " rdate rdate1 supp supp1 part part1
             site site1 po-nbr po-nbr1 po-receiver po-receiver1 /* pctype */ only-pz
             dis-detail dis-invoice dis-qty dis-sp dis-group dis-round" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if part1 = "" then part1 = hi_char.
      if supp1 = "" then supp1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if po-nbr1 = "" then po-nbr1 = hi_char.
      if po-receiver1 = "" then po-receiver1 = hi_char.
      if rdate = ? then rdate = low_date.
      if rdate1 = ? then rdate1 = hi_date.
      if dis-round > 5  then DO:
          MESSAGE "采购金额精确位数必须小于等于5，请重新输入"  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          return error.
      END.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

         ASSIGN desc2 = "收货明细(" + STRING(rdate) + " - " + STRING(rdate1) + ")"
                desc3 = "模拟发票(" + STRING(rdate) + " - " + STRING(rdate1) + ")".

         FOR EACH prh_hist NO-LOCK USE-INDEX prh_vend
            WHERE prh_domain = global_domain
             and (prh_rcp_date >= rdate AND prh_rcp_date <= rdate1)
             AND (prh_vend >= supp AND prh_vend <= supp1)
             AND (prh_part >= part AND prh_part <= part1)
             AND (prh_site >= site AND prh_site <= site1)
             AND (prh_nbr >= po-nbr AND prh_nbr <= po-nbr1)
             AND (prh_receiver >= po-receiver AND prh_receiver <= po-receiver1)
         BREAK BY prh_vend BY prh_curr BY prh_receiver BY prh_nbr BY prh_line :

         IF FIRST-OF(prh_vend) THEN DO:
             FIND FIRST ad_mstr WHERE ad_domain = global_domain and
                        ad_addr = prh_vend AND ad_type = "supplier" NO-LOCK NO-ERROR.
             IF AVAIL ad_mstr THEN ASSIGN desc1 = ad_name.
             ELSE ASSIGN desc1 = "".
         END.
         IF FIRST-OF(prh_vend) AND dis-invoice THEN DO:
            FOR EACH X_mstr: DELETE X_mstr. END.
         END.
         IF FIRST-OF(prh_vend) AND dis-detail THEN DO:
            PUT
                    "供应商： "  AT 2 prh_vend desc1 desc2 AT 60 SKIP.
         END.
         if first-of(prh_curr) then do:
            assign tot_base_pamt = 0
                   tot_base_tamt = 0
                   tot_base_aamt = 0.
         end.
     /****
         FIND FIRST pod_det WHERE pod_domain = global_domain
                and pod_nbr = prh_nbr AND pod_line = prh_line
             /* AND (pod_user1 = pctype OR pctype = "")                      */
                    NO-LOCK NO-ERROR .
         IF  NOT AVAIL pod_det THEN NEXT.
     *****/

        assign v_vouchered_qty = 0
               v_vouchered_amt = 0
               v_vouchered_price = 0.
         FIND pvo_mstr WHERE pvo_domain = global_domain and
                  pvo_lc_charge         = ""            and
                  pvo_internal_ref_type = "07"          and
                  pvo_internal_ref      = prh_receiver  and
                  pvo_line              = prh_line      NO-LOCK NO-ERROR.
       if available pvo_mstr then do:
          for each pvod_det no-lock where pvod_domain = pvo_domain and
                   pvod_id = pvo_id:
              for each vph_hist no-lock where vph_domain = pvod_domain and
                       vph_pvo_id = pvod_id and vph_pvod_id_line = pvod_id_line:
                     v_vouchered_qty = v_vouchered_qty + vph_inv_qty.
                     v_vouchered_amt = v_vouchered_amt + (vph_inv_qty * vph_curr_amt).
                     v_vouchered_price = vph_curr_amt.  /* 发票成本 */
             end.
          end.
    end.
/*********************************************************
/*roger 20060727*
         IF (NOT AVAIL pvo_mstr)
             OR
         ((AVAIL pvo_mstr) AND (pvo_last_voucher <> "" OR (pvo_trans_qty = pvo_vouchered_qty)) AND only-pz) THEN NEXT.
*roger 20060727*/
/*roger 20060727*/
         IF NOT AVAIL pvo_mstr THEN NEXT.
         ELSE DO:
             IF only-pz AND  (pvo_last_voucher <> "" OR (pvo_trans_qty = pvo_vouchered_qty)) THEN NEXT.
         END.
/*roger 20060727*/
/*
         ASSIGN
             d_qty = prh_rcvd - pvo_vouchered_qty.
*/
*************************************************************/
         cnsuqty = 0.
         for each cnsu_mstr no-lock where cnsu_domain = global_domain
              and cnsu_part = prh_part and cnsu_po_nbr = prh_nbr
              and cnsu_pod_line = prh_line,
             each cnsud_det no-lock where cnsud_domain = global_domain
              and cnsud_cnsu_pkey = cnsu_pkey
              and cnsud_receiver = prh_receiver:
             assign cnsuqty = cnsuqty + cnsud_qty_used.
         end.
     find first pod_det no-lock where pod_domain = global_domain
        and pod_nbr = prh_nbr and pod_line = prh_line no-error.
       if available pod_det then do:
            if pod_consignment then
               ASSIGN d_qty = cnsuqty - v_vouchered_qty.
            else
         assign d_qty = prh_rcvd - v_vouchered_qty.
     end.
         for last tx2_mstr
         where tx2_domain = global_domain and tx2_tax_type = "VAT"  and
         tx2_pt_taxc   =  prh_taxc and
         tx2_tax_usage =  prh_tax_usage and
         tx2_effdate   <= prh_rcp_date  and
         (tx2_exp_date = ? or tx2_exp_date >= prh_rcp_date)
         no-lock: end. /* FOR LAST b_tx2_mstr... */

          IF AVAIL tx2_mstr THEN
          ASSIGN
              d_p_amt = IF dis-qty THEN ROUND((prh_pur_cost * prh_rcvd),dis-round) ELSE ROUND((prh_pur_cost * d_qty),dis-round)
              d_t_amt = IF dis-qty THEN ROUND(((prh_pur_cost * tx2_tax_pct / 100) * prh_rcvd),dis-round) ELSE ROUND(((prh_pur_cost * tx2_tax_pct / 100) * d_qty),dis-round).
          ELSE
          ASSIGN
              d_p_amt = IF dis-qty THEN ROUND((prh_pur_cost * prh_rcvd),dis-round) ELSE ROUND((prh_pur_cost * d_qty),dis-round)
              d_t_amt = 0.

         IF dis-detail THEN DO:
             FIND pt_mstr WHERE pt_domain = global_domain and pt_part = prh_part NO-LOCK NO-ERROR.
             IF AVAIL pt_mstr THEN ASSIGN desc0 = pt_desc1.
             ELSE ASSIGN desc0 = "".
            if page-size - line-counter < 4 then do:
            page.
            PUT
             "供应商： "  AT 2 prh_vend desc1 desc2 AT 60 SKIP.
            END.
             vouchered_base_amt = v_vouchered_amt.
             if avail pvo_mstr and pvo_curr <> base_curr  then do:
                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input prh_curr,
                           input base_curr,
                           input prh_ex_rate,
                           input prh_ex_rate2,
                           input v_vouchered_amt,
                           input true,
                           output vouchered_base_amt,
                           output mc-erro-number)"}
             end.
             DISPLAY
                   prh_curr COLUMN-LABEL "货币"
                   prh_receiver COLUMN-LABEL "收货单号"
                   prh_nbr  COLUMN-LABEL "采购单号"
                   prh_line COLUMN-LABEL "LN"
/*730              pod_user1 FORMAT "x(2)" COLUMN-LABEL "定价!类型"          */
                   prh_part   COLUMN-LABEL "零件号"
                   desc0  COLUMN-LABEL "零件说明"
                   prh_rcp_date  COLUMN-LABEL "收货日期"
                   prh_rcvd  COLUMN-LABEL "收货数量"
                   v_vouchered_qty  COLUMN-LABEL "挂帐数量"
                   d_qty  COLUMN-LABEL "未挂帐数量"
                   cnsuqty column-label "寄售使用量"
                   v_vouchered_price COLUMN-LABEL "开票价格"
                   v_vouchered_amt format "->>>,>>>,>>>,>>9.9<" COLUMN-LABEL "已开票金额(原币)"
                   vouchered_base_amt COLUMN-LABEL "已开票金额(本币)"
            WITH FRAME b DOWN WIDTH 200 STREAM-IO.
             IF LAST-OF(prh_receiver) AND dis-sp THEN DO:
                 PUT FILL("-",142) FORMAT "x(142)" AT 1 SKIP.
             END.
         END.

         FOR FIRST X_mstr WHERE X_part = prh_part AND X_curr = prh_curr
               AND X_price = prh_pur_cost: END.
         IF NOT AVAIL X_mstr THEN DO:
             FIND FIRST pt_mstr WHERE pt_domain = global_domain and
                        pt_part = prh_part NO-LOCK NO-ERROR.
             CREATE X_mstr.
                 ASSIGN
                 X_part = prh_part
                 X_curr = prh_curr
                 X_price = prh_pur_cost
                 X_p_amt = d_p_amt
                 X_t_amt = d_t_amt
                 X_qty = IF dis-qty THEN prh_rcvd - v_vouchered_qty ELSE d_qty
                 X_group = IF (AVAIL pt_mstr) THEN pt_group ELSE "".
         END.
         ELSE DO:
                ASSIGN
                    X_p_amt = X_p_amt + d_p_amt
                    X_t_amt = X_t_amt + d_t_amt
                    X_qty = IF dis-qty THEN x_qty + prh_rcvd ELSE X_qty + d_qty.
         END.


         IF LAST-OF(prh_vend) AND dis-invoice THEN DO:
         FOR EACH X_mstr WHERE X_qty > 0
             BREAK BY X_curr BY X_group BY X_part BY X_price
             WITH FRAME c DOWN WIDTH 200 STREAM-IO:

             IF FIRST(X_curr) THEN DO:
                 IF dis-detail THEN PAGE.
                 PUT
                         "供应商： "  AT 2 prh_vend desc1 desc3 AT 60 SKIP.
             END.

/*           ACCUMULATE X_qty(TOTAL BY X_curr).  */
             ACCUMULATE X_p_amt (TOTAL BY X_curr).
             ACCUMULATE X_t_amt (TOTAL BY X_curr).
             ASSIGN
                 d_a_amt = X_p_amt + X_t_amt.
             FIND pt_mstr WHERE pt_domain = global_domain and
                  pt_part = X_part NO-LOCK NO-ERROR.
             IF AVAIL pt_mstr THEN ASSIGN desc0 = pt_desc1.
             ELSE ASSIGN desc0 = "".
             if page-size - line-counter < 4 then do:
                 page.
                 PUT
                 "供应商： "  AT 2 prh_vend desc1 desc3 AT 60 SKIP.
             END.
             if prh_curr <> base_curr then do:
                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input prh_curr,
                           input base_curr,
                           input prh_ex_rate,
                           input prh_ex_rate2,
                           input X_p_amt,
                           input true,
                           output base_pamt,
                           output mc-erro-number)"}
                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input prh_curr,
                           input base_curr,
                           input prh_ex_rate,
                           input prh_ex_rate2,
                           input X_t_amt,
                           input true,
                           output base_tamt,
                           output mc-erro-number)"}
             end.
             else do:
                  base_pamt = x_p_amt.
                  base_tamt = x_t_amt.
             end.
             base_aamt = base_pamt + base_tamt.
             tot_base_pamt = tot_base_pamt + base_pamt.
             tot_base_tamt = tot_base_tamt + base_tamt.
             tot_base_aamt = tot_base_pamt + tot_base_tamt.
             DISPLAY
                 X_curr  COLUMN-LABEL "货币"
                 X_group COLUMN-LABEL "零件组"
                 X_part  COLUMN-LABEL "零件号"
                 desc0   COLUMN-LABEL "零件说明"
                 X_price COLUMN-LABEL "采购价格"
                 X_qty   COLUMN-LABEL "待开票数量"
                 X_p_amt COLUMN-LABEL "不含税金额"
                 X_t_amt COLUMN-LABEL "纳税金额"
                 d_a_amt COLUMN-LABEL "含税金额(原币)"
                 base_aamt column-label "含税金额(本币)".

             IF (LAST-OF(X_group) AND (NOT LAST(X_group))) AND dis-group THEN  PUT FILL("-",142) FORMAT "x(142)" AT 1 SKIP.

             IF LAST-OF(X_curr) THEN DO:
                 ASSIGN
/*                   e_qty = ACCUM TOTAL BY X_curr X_qty*/
                     e_p_amt = ACCUM TOTAL BY X_curr X_p_amt
                     e_t_amt = ACCUM TOTAL BY X_curr X_t_amt
                     e_a_amt = e_p_amt + e_t_amt.
                 DOWN 1 WITH FRAME c.
                 UNDERLINE /*X_qty*/ X_p_amt X_t_amt d_a_amt base_aamt WITH FRAME c.
                 DISPLAY
/*                   e_qty @ X_qty */
                     e_p_amt @ X_p_amt
                     e_t_amt @ X_t_amt
                     e_a_amt @ d_a_amt
                     tot_base_aamt @ base_aamt
                     WITH FRAME c.
             END.

         END.
         END.
         IF LAST-OF(prh_vend) AND (NOT LAST(prh_vend)) THEN PAGE.
         END. /*for each prh_hist*/

   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
