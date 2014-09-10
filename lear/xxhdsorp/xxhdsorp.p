/* DISPLAY TITLE */
{mfdtitle.i "8.6"}

DEFINE VARIABLE cust LIKE cm_addr LABEL "客户".
DEFINE VARIABLE cust1 LIKE cm_addr.
DEFINE VARIABLE so-nbr LIKE so_nbr LABEL "客户订单".
DEFINE VARIABLE so-nbr1 LIKE so_nbr.
DEFINE VARIABLE js-nbr LIKE so_nbr LABEL "调整订单".
DEFINE VARIABLE js-nbr1 LIKE so_nbr.
DEFINE VARIABLE part LIKE pt_part LABEL "零件号".
DEFINE VARIABLE part1 LIKE pt_part.
DEFINE VARIABLE so-date LIKE tr_date LABEL "客户订单发运日期".
DEFINE VARIABLE so-date1 LIKE tr_date.
DEFINE VARIABLE so-effdate LIKE tr_effdate LABEL "客户订单发运生效日期".
DEFINE VARIABLE so-effdate1 LIKE tr_effdate.
DEFINE VARIABLE soiv-effdate LIKE tr_effdate LABEL "客户订单发票日期".
DEFINE VARIABLE soiv-effdate1 LIKE tr_effdate.
DEFINE VARIABLE soiv-efflg AS LOGICAL LABEL "使用" INITIAL NO.
DEFINE VARIABLE js-lg AS LOGICAL LABEL "包含JS订单" INITIAL YES.
DEFINE VARIABLE sp-lg2 AS LOGICAL LABEL "分割订单类型"  INITIAL YES.
DEFINE VARIABLE sp-lg1 AS LOGICAL LABEL "分割定价类型"  INITIAL YES.
DEFINE VARIABLE amt-round AS INTEGER FORMAT "9" LABEL "舍入位数" INITIAL 2.
DEFINE VARIABLE pctype AS CHAR FORMAT "x(2)" LABEL "定价类型" COLUMN-LABEL "定价!类型" .
DEFINE VARIABLE prtype LIKE pctype.
DEFINE VARIABLE js-date LIKE tr_date LABEL "调整订单发运日期".
DEFINE VARIABLE js-date1 LIKE tr_date.
DEFINE VARIABLE js-effdate LIKE tr_effdate LABEL "调整订单发运生效日期".
DEFINE VARIABLE js-effdate1 LIKE tr_effdate.
DEFINE VARIABLE jsiv-effdate LIKE tr_effdate LABEL "调整订单发票日期".
DEFINE VARIABLE jsiv-effdate1 LIKE tr_effdate.
DEFINE VARIABLE jsiv-efflg AS LOGICAL LABEL "使用" INITIAL NO.
DEFINE VARIABLE site like in_site LABEL "地点".
DEFINE VARIABLE site1 like in_site.
DEFINE VARIABLE inv-d-e AS LOGICAL LABEL "发票日期类型"  FORMAT "D)打印日期/E)生效日期"   INITIAL NO.
DEFINE VARIABLE dis-detail AS LOGICAL LABEL "打印发运明细" INITIAL YES.
DEFINE VARIABLE dis-invoice AS LOGICAL LABEL "打印模拟发票" INITIAL YES.
DEFINE VARIABLE dis-qty AS LOGICAL LABEL "计算数量"    FORMAT "R)发运数量/W)未开发票数量"      INITIAL NO.
DEFINE VARIABLE desc0 LIKE pt_desc1.
DEFINE VARIABLE desc1 LIKE ad_name.
DEFINE VARIABLE desc2 AS CHAR FORMAT "x(150)".
DEFINE VARIABLE desc3 AS CHAR FORMAT "x(150)".
DEFINE VARIABLE desc4 AS CHAR FORMAT "x(150)".
DEFINE VARIABLE desc5 AS CHAR FORMAT "x(150)".
DEFINE VARIABLE pc-log1 AS LOGICAL.
DEFINE VARIABLE taxc LIKE idh_taxc.
DEFINE VARIABLE tax_usage LIKE idh_tax_usage.
DEFINE VARIABLE taxable LIKE idh_taxable.
DEFINE VARIABLE d-qty LIKE sr_qty.
DEFINE VARIABLE d-amt LIKE tr_price.
DEFINE VARIABLE e-qty LIKE sr_qty.
DEFINE VARIABLE f-qty LIKE sr_qty.
DEFINE VARIABLE e-amt LIKE tr_price.
DEFINE VARIABLE a_amt LIKE tr_price.
DEFINE VARIABLE t_amt LIKE tr_price.
DEFINE VARIABLE p_amt LIKE tr_price.
DEFINE VARIABLE t_a_amt LIKE tr_price.
DEFINE VARIABLE t_t_amt LIKE tr_price.
DEFINE VARIABLE t_p_amt LIKE tr_price.
DEFINE VARIABLE d-type AS CHAR FORMAT "x(4)".
DEFINE TEMP-TABLE X_mstr
    FIELD X_part LIKE pt_part
    FIELD X_type AS CHAR FORMAT "x(4)"
    FIELD X_qty1 LIKE sr_qty
    FIELD X_qty2 LIKE sr_qty
    FIELD X_qty3 LIKE sr_qty
    FIELD X_price LIKE tr_price
    FIELD X_a_amt LIKE tr_price
    FIELD X_t_amt LIKE tr_price
    FIELD X_p_amt LIKE tr_price.

/* SELECT FORM */
form
   cust            COLON 20
   cust1           LABEL "至" colon 49 skip
   part            COLON 20
   part1           LABEL "至" colon 49 skip
   site            COLON 20
   site1           LABEL "至" colon 49 skip
   so-nbr          COLON 20
   so-nbr1         LABEL "至" colon 49 skip
   so-date         COLON 20
   so-date1        LABEL "至" colon 49 skip
   so-effdate      COLON 20
   so-effdate1     LABEL "至" colon 49 skip
   soiv-effdate    COLON 20
   soiv-effdate1   LABEL "至" colon 49  soiv-efflg  colon 65 SKIP
   js-nbr          COLON 20
   js-nbr1         LABEL "至" colon 49 skip
   js-date         COLON 20
   js-date1        LABEL "至" colon 49 skip
   js-effdate      COLON 20
   js-effdate1     LABEL "至" colon 49 skip
   jsiv-effdate    COLON 20
   jsiv-effdate1   LABEL "至" colon 49  jsiv-efflg  colon 65
   inv-d-e         COLON 20
   js-lg           COLON 20
   dis-qty         COLON 49   "R)发运数量"  AT 65
   pctype          COLON 20
   amt-round       COLON 49   "W)未开发票数量" AT 65 SKIP(1)

   dis-detail      COLON 20
   dis-invoice     COLON 49
   sp-lg1          COLON 20
   sp-lg2          COLON 49
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   IF cust1 = hi_char then cust1 = "".
   IF so-nbr1 = hi_char then so-nbr1 = "".
   IF js-nbr1 = hi_char then js-nbr1 = "".
   IF part1 = hi_char then part1 = "".
   IF site1 = hi_char then site1 = "".
   if so-date = low_date then so-date = ?.
   if so-date1 = hi_date then so-date1 = ?.
   if js-date = low_date then js-date = ?.
   if js-date1 = hi_date then js-date1 = ?.
   if so-effdate = low_date then so-effdate = ?.
   if so-effdate1 = hi_date then so-effdate1 = ?.
   if js-effdate = low_date then js-effdate = ?.
   if js-effdate1 = hi_date then js-effdate1 = ?.
   if soiv-effdate = low_date then soiv-effdate = ?.
   if soiv-effdate1 = hi_date then soiv-effdate1 = ?.
   if jsiv-effdate = low_date then jsiv-effdate = ?.
   if jsiv-effdate1 = hi_date then jsiv-effdate1 = ?.

   if c-application-mode <> 'web' then
      update cust cust1 part part1 site site1 so-nbr so-nbr1 so-date so-date1 so-effdate so-effdate1 soiv-effdate soiv-effdate1 soiv-efflg
    js-nbr js-nbr1 js-date js-date1 js-effdate js-effdate1 jsiv-effdate jsiv-effdate1 jsiv-efflg inv-d-e js-lg dis-qty pctype amt-round dis-detail dis-invoice sp-lg1 sp-lg2 with frame a.

   {wbrp06.i &command = update
      &fields = " cust cust1 part part1 site site1 so-nbr so-nbr1 so-date so-date1 so-effdate so-effdate1 soiv-effdate soiv-effdate1 soiv-efflg
    js-nbr js-nbr1 js-date js-date1 js-effdate js-effdate1 jsiv-effdate jsiv-effdate1 jsiv-efflg inv-d-e js-lg dis-qty pctype amt-round dis-detail dis-invoice sp-lg1 sp-lg2" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      bcdparm = "".
      {mfquoter.i cust        }
      {mfquoter.i cust1       }
      {mfquoter.i part        }
      {mfquoter.i part1       }
      {mfquoter.i site        }
      {mfquoter.i site1       }
      {mfquoter.i so-nbr      }
      {mfquoter.i so-nbr1     }
      {mfquoter.i so-date     }
      {mfquoter.i so-date1    }
      {mfquoter.i so-effdate  }
      {mfquoter.i so-effdate1 }
      {mfquoter.i soiv-effdate  }
      {mfquoter.i soiv-effdate1 }
      {mfquoter.i soiv-efflg  }
      {mfquoter.i js-nbr      }
      {mfquoter.i js-nbr1     }
      {mfquoter.i js-date     }
      {mfquoter.i js-date1    }
      {mfquoter.i js-effdate  }
      {mfquoter.i js-effdate1 }
      {mfquoter.i jsiv-effdate  }
      {mfquoter.i jsiv-effdate1 }
      {mfquoter.i jsiv-efflg  }
      {mfquoter.i inv-d-e     }
      {mfquoter.i js-lg       }
      {mfquoter.i pctype      }
      {mfquoter.i dis-detail  }
      {mfquoter.i dis-invoice }
      {mfquoter.i sp-lg1      }
      {mfquoter.i sp-lg2      }
      {mfquoter.i amt-round   }

          IF cust1 = "" then cust1 = hi_char.
          IF so-nbr1 = "" then so-nbr1 = hi_char.
          IF js-nbr1 = "" then js-nbr1 = hi_char.
          IF part1 = "" then part1 = hi_char.
          IF site1 = "" then site1 = hi_char.
          if so-date = ? then so-date = low_date.
          if so-date1 = ? then so-date1 = hi_date.
          if js-date = ? then js-date = low_date.
          if js-date1 = ? then js-date1 = hi_date.
          if so-effdate = ? then so-effdate = low_date.
          if so-effdate1 = ? then so-effdate1 = hi_date.
          if js-effdate = ? then js-effdate = low_date.
          if js-effdate1 = ? then js-effdate1 = hi_date.

          if soiv-effdate = ? then soiv-effdate = low_date.
          if soiv-effdate1 = ? then soiv-effdate1 = hi_date.
          if jsiv-effdate = ? then jsiv-effdate = low_date.
          if jsiv-effdate1 = ? then jsiv-effdate1 = hi_date.


          IF NOT soiv-efflg THEN ASSIGN soiv-effdate = so-effdate soiv-effdate1 = so-effdate1.

          IF NOT jsiv-efflg THEN ASSIGN jsiv-effdate = js-effdate jsiv-effdate1 = js-effdate1.

         IF pctype <> "" AND pctype <> "FP" AND pctype <> "NP" THEN DO:
              MESSAGE "定价类型必须为空、FP、NP，请重新输入" .
              undo,retry.
          END.
          IF amt-round > 5  THEN DO:
              MESSAGE "舍入位数必须小于等于5，请重新输入".
              undo,retry.
          END.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
   {mfphead.i}
       ASSIGN desc2 = "[发运明细：客户订单]" + "发运日期：（" + STRING(so-date) + " - " + STRING(so-date1) + "）"
       + "生效日期：（" + STRING(so-effdate) + " - " + STRING(so-effdate1) + "）"
       + "发票日期：（" + STRING(soiv-effdate) + " - " + STRING(soiv-effdate1) + "）"

              desc4 = "[发运明细：调整订单]" + "发运日期：（" + STRING(js-date) + " - " + STRING(js-date1) + "）"
       + "生效日期：（" + STRING(js-effdate) + " - " + STRING(js-effdate1) + "）"
       + "发票日期：（" + STRING(jsiv-effdate) + " - " + STRING(jsiv-effdate1) + "）" + "（" + STRING(js-lg) + "）"

              desc3 = "[模拟发票：客户订单]" + "发运日期：（" + STRING(so-date) + " - " + STRING(so-date1) + "）"
       + "生效日期：（" + STRING(so-effdate) + " - " + STRING(so-effdate1) + "）"
       + "发票日期：（" + STRING(soiv-effdate) + " - " + STRING(soiv-effdate1) + "）"

              desc5 = "[模拟发票：调整订单]" + "发运日期：（" + STRING(js-date) + " - " + STRING(js-date1) + "）"
       + "生效日期：（" + STRING(js-effdate) + " - " + STRING(js-effdate1) + "）"
       + "发票日期：（" + STRING(jsiv-effdate) + " - " + STRING(jsiv-effdate1) + "）" + "（" + STRING(js-lg) + "）".


 /*
   with frame b width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
*/
FOR EACH tr_hist NO-LOCK
     WHERE tr_domain = global_domain and tr_addr >= cust AND tr_addr <= cust1
     AND (
         (tr_nbr >= so-nbr AND tr_nbr <= so-nbr1
          AND tr_date >= so-date AND tr_date <= so-date1
          AND tr_effdate >= so-effdate AND tr_effdate <= so-effdate1)
         OR
         (js-lg AND SUBSTRING(tr_nbr,1,2) = "JS"
          AND tr_nbr >= js-nbr AND tr_nbr <= js-nbr1
          AND tr_date >= js-date AND tr_date <= js-date1
          AND tr_effdate >= js-effdate AND tr_effdate <= js-effdate1)
         )
     AND tr_part >= part AND tr_part <= part1
     AND tr_site >= site AND tr_site <= site1
     AND tr_type = "ISS-SO"
       BREAK BY tr_addr BY tr_nbr BY tr_line BY tr_part BY tr_date
       :

        IF FIRST-OF(tr_addr) THEN DO:
            FOR EACH X_mstr:
                DELETE X_mstr.
            END.
            FIND ad_mstr WHERE ad_domain = global_domain and ad_addr = tr_addr AND ad_type = "customer" NO-LOCK NO-ERROR.
            IF AVAIL ad_mstr THEN ASSIGN desc1 = ad_name.
            ELSE ASSIGN desc1 = "".
        END.
        IF FIRST-OF(tr_addr) AND dis-detail THEN DO:
            PUT
                SKIP(1)
                "客户： "  AT 2 tr_addr desc1 skip
                desc2 AT 2 SKIP
                desc4 AT 2 SKIP.
        END.
        IF FIRST-OF(tr_line) THEN DO:
            ASSIGN e-qty = 0.
        END.

FIND LAST idh_hist WHERE idh_domain = global_domain and
          idh_nbr = tr_nbr AND idh_line = tr_line AND
          idh_part = tr_part USE-INDEX idh_part NO-LOCK NO-ERROR.
IF AVAIL idh_hist THEN DO:
    IF ((pctype = "NP" AND idh_user1 = "NP") OR (pctype = "FP" AND idh_user1 = "FP") OR pctype = "") THEN
        ASSIGN pc-log1 = YES taxc = idh_taxc tax_usage = idh_tax_usage taxable = idh_taxable prtype = idh_user1.
    ELSE ASSIGN pc-log1 = NO.
END.
ELSE DO:
    FIND FIRST sod_det WHERE sod_domain = global_domain and
               sod_nbr = tr_nbr AND sod_line = tr_line USE-INDEX sod_part NO-LOCK NO-ERROR.
    IF AVAIL sod_det THEN DO:
        IF ((pctype = "NP" AND sod_user1 = "NP") OR (pctype = "FP" AND sod_user1 = "FP") OR pctype = "") THEN
            ASSIGN pc-log1 = YES taxc = sod_taxc tax_usage = sod_tax_usage taxable = sod_taxable prtype = sod_user1.
        ELSE ASSIGN pc-log1 = NO.
    END.
    ELSE ASSIGN pc-log1 = NO.
END.



IF pc-log1 = NO THEN NEXT.

       ASSIGN
           d-qty =  -1 * tr_qty_loc
           e-qty = e-qty + d-qty
           d-amt = ROUND((d-qty * tr_price),amt-round).

       IF dis-detail THEN DO:
           if page-size - line-counter < 4 then do:
               page.
               IF dis-detail THEN
           PUT
               SKIP(1)
               "客户： "  AT 2 tr_addr desc1 SKIP
                   desc2 AT 2 SKIP
                   desc4 AT 2 SKIP.
           END.
           FIND pt_mstr WHERE pt_domain = global_domain and pt_part = tr_part NO-LOCK NO-ERROR.
           IF AVAIL pt_mstr THEN ASSIGN desc0 = pt_desc1.
           ELSE ASSIGN desc0 = "".
           DISPLAY
           tr_nbr  COLUMN-LABEL "客户订单"
           tr_line COLUMN-LABEL "LN"
           prtype
           tr_part COLUMN-LABEL "零件号"
           desc0 COLUMN-LABEL "零件说明"
           tr_date COLUMN-LABEL "发运日期"
           tr_effdate COLUMN-LABEL "生效日期"
           d-qty   COLUMN-LABEL "发运数量"
           tr_price COLUMN-LABEL "价格"
           d-amt    COLUMN-LABEL "金额"
           WITH FRAME b DOWN WIDTH 200 STREAM-IO.
        END.
        IF LAST-OF(tr_line) THEN DO:
            /*
            FOR EACH ih_hist NO-LOCK WHERE ih_domain = global_domain and ih_nbr = tr_nbr
                AND
                (
                (NOT inv-d-e) OR
                (
                (SUBSTRING(ih_nbr,1,2) = "js" AND ih_inv_date >= jsiv-effdate AND ih_inv_date <= jsiv-effdate1)
                  OR
                (SUBSTRING(ih_nbr,1,2) <> "js" AND ih_inv_date >= soiv-effdate AND ih_inv_date <= soiv-effdate1)
                )
                )
                ,EACH ar_mstr NO-LOCK WHERE ar_domain = global_domain and ar_nbr = ih_inv_nbr
                AND
                (
                (inv-d-e) OR
                (
                (SUBSTRING(ih_nbr,1,2) = "js" AND ar_effdate >= jsiv-effdate AND ar_effdate <= jsiv-effdate1)
                  OR
                (SUBSTRING(ih_nbr,1,2) <> "js" AND ar_effdate >= soiv-effdate AND ar_effdate <= soiv-effdate1)
                )
                )
                ,EACH idh_hist NO-LOCK WHERE idh_domain = global_domain and idh_nbr = ih_nbr AND idh_line = tr_line AND idh_part = tr_part:

                ACCUMULATE idh_qty_inv (TOTAL).
            END.
            */
            ASSIGN f-qty = 0.
            FOR EACH idh_hist NO-LOCK WHERE idh_domain = global_domain and idh_nbr = tr_nbr AND idh_line = tr_line AND idh_part = tr_part:

                IF NOT inv-d-e THEN DO:
                    FIND FIRST ih_hist WHERE ih_domain = global_domain and ih_nbr = idh_nbr AND idh_inv_nbr = ih_inv_nbr
                        AND
                        (
                        (SUBSTRING(ih_nbr,1,2) = "js" AND ih_inv_date >= jsiv-effdate AND ih_inv_date <= jsiv-effdate1)
                          OR
                        (SUBSTRING(ih_nbr,1,2) <> "js" AND ih_inv_date >= soiv-effdate AND ih_inv_date <= soiv-effdate1)
                        )
                        NO-LOCK NO-ERROR.
                    IF NOT AVAIL ih_hist THEN NEXT.
                END.
                ELSE DO:
                    FIND ar_mstr WHERE ar_domain = global_domain and ar_nbr = idh_inv_nbr
                        AND
                        (
                        (SUBSTRING(ih_nbr,1,2) = "js" AND ar_effdate >= jsiv-effdate AND ar_effdate <= jsiv-effdate1)
                          OR
                        (SUBSTRING(ih_nbr,1,2) <> "js" AND ar_effdate >= soiv-effdate AND ar_effdate <= soiv-effdate1)
                         )
                        NO-LOCK NO-ERROR.
                    IF NOT AVAIL ar_mstr THEN NEXT.
                END.

                ASSIGN f-qty = f-qty + idh_qty_inv.
            END.

      for last tx2_mstr
        where tx2_domain = global_domain and
        tx2_tax_type  =  "VAT"  and
        tx2_pt_taxc   =  taxc and
        tx2_tax_usage =  tax_usage and
        tx2_effdate   <= tr_effdate  and
        (tx2_exp_date = ?          or
        tx2_exp_date >= tr_effdate)
        no-lock: end. /* FOR LAST b_tx2_mstr... */

        ASSIGN
            a_amt = IF dis-qty THEN ROUND((e-qty * tr_price),amt-round) ELSE ROUND(((e-qty - f-qty) * tr_price),amt-round)
            t_amt = IF AVAIL tx2_mstr THEN ROUND((a_amt * tx2_tax_pct / (100 + tx2_tax_pct)),amt-round) ELSE 0
            p_amt = a_amt - p_amt
            .
        IF sp-lg1 THEN DO:
            IF sp-lg2 THEN ASSIGN d-type = IF SUBSTRING(tr_nbr,1,2) = "JS" THEN TRIM(prtype) + "JS" ELSE TRIM(prtype) + "SO".
            ELSE ASSIGN d-type = TRIM(prtype).
        END.
        ELSE DO:
            IF sp-lg2 THEN ASSIGN d-type = IF SUBSTRING(tr_nbr,1,2) = "JS" THEN "  JS" ELSE "  SO".
            ELSE ASSIGN d-type = "".
        END.

            FOR FIRST X_mstr WHERE X_part = tr_part AND X_price = tr_price: END.
            IF NOT AVAIL X_mstr THEN DO:
                CREATE X_mstr.
                ASSIGN
                    X_part = tr_part
                    X_qty1 = e-qty
                    X_qty2 = f-qty
                    X_qty3 = e-qty - f-qty
                    X_price = tr_price
                    X_a_amt = a_amt
                    X_t_amt = t_amt
                    X_p_amt = p_amt
                    X_type = d-type
                    .
            END.
            ELSE DO:
                    ASSIGN
                        X_qty1 = X_qty1 + e-qty
                        X_qty2 = X_qty2 + f-qty
                        X_qty3 = X_qty3 + e-qty - f-qty
                        X_a_amt = X_a_amt + a_amt
                        X_t_amt = X_t_amt + t_amt
                        X_p_amt = X_p_amt + p_amt
                        .
            END.
        END. /*if last-of(tr_line)*/

        IF LAST-OF(tr_addr) AND dis-invoice THEN DO:
            FOR EACH X_mstr WHERE X_a_amt <> 0
                BREAK BY X_type BY X_part BY X_price
                WITH FRAME c DOWN WIDTH 200 STREAM-IO:
                IF FIRST(X_type) AND dis-detail THEN PAGE.
                IF FIRST(X_type) THEN DO:
                    PUT
                    SKIP(1)
                    "客户： "  AT 2 tr_addr desc1 SKIP
                        desc3 AT 2 SKIP
                        desc5 AT 2 SKIP.
                END.
                ASSIGN X_p_amt = X_a_amt - X_t_amt.
                ACCUMULATE X_a_amt (TOTAL BY X_type).
                ACCUMULATE X_t_amt (TOTAL BY X_type).

                if page-size - line-counter < 4 then do:
                    page.
                PUT
                    SKIP(1)
                    "客户： "  AT 2 tr_addr desc1 SKIP
                    desc3 AT 2 SKIP
                    desc5 AT 2 SKIP.
                END.
                FIND pt_mstr WHERE pt_domain = global_domain and pt_part = X_part NO-LOCK NO-ERROR.

                IF AVAIL pt_mstr THEN ASSIGN desc0 = pt_desc1.
                ELSE ASSIGN desc0 = "".

                DISPLAY
                    X_type WHEN X_type <> "" COLUMN-LABEL "分类"
                    X_part COLUMN-LABEL "零件号"
                    desc0 COLUMN-LABEL "零件说明"
                    X_price COLUMN-LABEL "价格"
                    X_qty1  COLUMN-LABEL "发运数量"
                    X_qty2  COLUMN-LABEL "发票数量"
                    X_qty3  COLUMN-LABEL "未开发票数量"
                    X_a_amt COLUMN-LABEL "总金额"
                    X_t_amt COLUMN-LABEL "纳税金额"
                    X_p_amt COLUMN-LABEL "不含税金额".
                IF LAST-OF(X_type) THEN DO:
                    ASSIGN
                        t_a_amt = ACCUM TOTAL BY X_type X_a_amt
                        t_t_amt = ACCUM TOTAL BY X_type X_t_amt
                        t_p_amt = t_a_amt - t_t_amt.
                    DOWN 1 WITH FRAME c.
                    UNDERLINE X_a_amt x_t_amt x_p_amt WITH FRAME c.
                    DISPLAY
                        t_a_amt @ X_a_amt
                        t_t_amt @ X_t_amt
                        t_p_amt @ X_p_amt
                        WITH FRAME c.
                    DOWN 1 WITH FRAME c.
                    UNDERLINE X_a_amt x_t_amt x_p_amt WITH FRAME c.

                END.

            END.
        END. /*if last-of(tr_addr)*/
        IF LAST-OF(tr_addr) AND (NOT LAST(tr_addr)) THEN PAGE.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
