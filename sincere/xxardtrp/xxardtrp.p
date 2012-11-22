/* xxardtrp. - AR Detail Report 应收款项明细表 */
/*Version 20101116.01   by Hill Cheng of Softspeed
*/

/* DISPLAY TITLE */
{xxmfdtitle.i 20101116.02 "}

 DEFINE VARIABLE  cust    LIKE  cm_addr      NO-UNDO .
 DEFINE VARIABLE  cust1   LIKE  cm_addr      NO-UNDO .
 DEFINE VARIABLE  Pro_y   AS INTEGER FORMAT '9999' .
 DEFINE VARIABLE  Start_Month  AS INTEGER FORMAT '99'  NO-UNDO .
 DEFINE VARIABLE  End_Month    AS INTEGER FORMAT '99' NO-UNDO .
 DEFINE VARIABLE  init_date    AS Date  NO-UNDO .
 DEFINE VARIABLE  Monthdays    AS INTEGER FORMAT '99' NO-UNDO .


 /*定义变量*/
 Define variable Total_AR_Beginning_Balance As Dec format '->>>>,>>>,>>9.99' .
 Define variable total_amount_disc_month As Dec format '->>>>,>>>,>>9.99' .
 Define variable Total_Sales_AMT_Month As Dec format '->>>>,>>>,>>9.99' .
 Define variable Total_Sales_Qty_Month As Dec format '->>>>,>>>,>>9.99' .
 Define variable total_amount_payment As Dec format '->>>>,>>>,>>9.99' .
 Define variable total_amount_disc As Dec format '->>>>,>>>,>>9.99' .
 Define variable total_amount_payment_month As Dec format '->>>>,>>>,>>9.99' .
 Define variable total_amount_Prepayment As Dec format '->>>>,>>>,>>9.99' .
 Define variable total_amount_charge_payment As Dec format '->>>>,>>>,>>9.99' .
 Define variable Sales_amt As Dec format '->>>>,>>>,>>9.99' .
 DEFINE VARIABLE  flag_month  AS INT  .
 DEFINE VARIABLE desc1 LIKE pt_desc1 .
 DEFINE VARIABLE desc2 LIKE pt_desc2 .
 DEFINE VARIABLE state LIKE CODE_cmmt .
 DEFINE VARIABLE  sales_channel   LIKE code_cmmt .
 DEFINE VARIABLE  sales_category LIKE CODE_cmmt .

 /*AR Moduel Open Date*/
 assign init_date = 01/01/11 .

 FORM
   cust      colon 15
   cust1     label {t001.i} COLON 45 skip
   init_date label 'AR开账日期'  Colon 15
   pro_y     COLON 15
   start_month     colon 15
   end_month    label {t001.i} COLON 45 skip(1)

   '注意:如需重新开帐,请修改AR开账日期.'   at 8
   SKIP
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

REPEAT:

   /*初始化变量*/
   IF  cust1 = hi_char then cust1 = "".
   IF pro_y = 0  THEN  ASSIGN pro_y = YEAR(TODAY) .
   IF  Start_Month  = 0 then start_month = 1 .
   IF  end_month = 0 THEN ASSIGN END_month = MONTH(TODAY) .

   IF  c-application-mode <> 'web' THEN
      UPDATE  cust cust1 init_date  pro_y start_month end_month WITH  FRAME  a.
      {wbrp06.i &COMMAND  = UPDATE  &FIELDS  = " cust cust1 init_date pro_y start_month end_month " &frm = "a"}

    /*年度数据校验*/
    IF  pro_y < 1900  THEN DO:
      MESSAGE "年度数值不正确，请重新输入?" .
      UNDO,RETRY.
    END.

        /*开始月份数据校验*/
    IF  START_month < 1  THEN DO:
      MESSAGE "开始月份数值不正确，请重新输入?" .
      UNDO,RETRY.
    END.

        /*结束月份数据校验*/
    IF END_month > 12  THEN DO:
      MESSAGE "结束月份数值不正确，请重新输入?" .
      UNDO,RETRY.
    END.

        /*数据合理性校验开始和结束月份*/
    IF END_month < START_month  THEN DO:
      MESSAGE "结束月份不能小于开始月份，请重新输入?" .
      UNDO,RETRY.
    END.


     IF  (c-application-mode <> 'web') OR
      (c-application-mode = 'web' AND
      (c-web-request begins 'data')) THEN  DO :


     END .

     /* OUTPUT DESTINATION SELECTION */
     {gpselout.i &printType = "printer"
           &printWidth = 132
           &pagedFlag = " "
           &STREAM  = " "
           &appendToFile = " "
           &streamedOutputToTerminal = " "
           &withBatchOption = "no"
           &displayStatementType = 1
           &withCancelMessage = "yes"
           &pageBottomMargin = 6
           &withEmail = "yes"
           &withWinprint = "yes"
           &defineVariables = "yes"}
        /*Report Head subfile*/
    {xxmfphead.i}

        /*get data for AR_mstr
     *Re-Open AR Account due 2010.12.31 by Julei of Softspeed
     *Used Index:ar_bill:by ar_biill + ar_date + ar_nbr
     *Second Sort:by ar_effdate
  */

     /*initialize Variance*/
     assign Total_AR_Beginning_Balance = 0
     total_amount_disc_month =0
     Total_Sales_AMT_Month = 0
     Total_Sales_Qty_Month = 0
                total_amount_payment = 0
    total_amount_disc = 0
    total_amount_Prepayment = 0
    total_amount_charge_payment = 0
    total_amount_payment_month = 0
    flag_month = 0
    Sales_AMT = 0
                 desc1 = ''
     desc2 = ''
     sales_channel = ''
     sales_category = ''
     state = ''
        .

    if end_month = 2 then monthdays = 28  .
      else if end_month = 1 or end_month = 3 or  end_month = 5 or end_month = 7 or end_month = 8
      or end_month = 10  or end_month = 12 then  monthdays = 31.
      else monthdays = 30.
  For EACH  ar_mstr  WHERE ar_domain = global_domain AND  (ar_bill >= cust OR cust = "")
    AND (ar_bill <= cust1 OR cust1 = "")
    AND ar_effdate >= (init_date - 1) and ar_effdate <= DATE(end_month,monthdays,pro_y)  NO-LOCK BREAK BY ar_bill  by ar_effdate :

            /*Create Customer's Informations */

            IF  FIRST-OF (ar_bill) THEN DO :
             /*output report headline*/
               PUT  UNFORMAT  '客户代码' AT  0  '客户名称' AT  10 '生效日期' AT  39 '提货单号' AT 48 '凭证号码' AT 57 '零件编号' AT 66  '描述1' AT 85 '描述2' AT 110 '地点' TO  145 '数量' TO  155  '单价' TO  170 '金额' TO  186 '冲账金额' TO  202  '收款金额'  TO  218  '应收余额' TO  234 '渠道' AT  236  '销售方式' AT  255  '省份' at 274  '说明' AT   293  SKIP   .
               PUT  UNFORMAT  '-------- ---------------------------- -------- -------- -------- ------------------ ------------------------ ----------------------- -------- ------------ -------------- --------------- --------------- --------------- --------------- ------------------ ------------------ ------------------ ----------------------' skip .

    /*initialize value of flage_month*/
                assign flag_month = 0 .

            END . /*IF  FIRST-OF (ar_bill) THEN  DO :*/

            /*Get Customer's Informations */
             FIND  FIRST  ad_mstr WHERE  ad_domain = global_domain AND ad_addr = ar_bill NO-LOCK  NO-ERROR  .

            /*get customer's state from code_mstr*/
      FIND FIRST CODE_mstr WHERE CODE_domain = global_domain AND code_fldname = 'ad_state'
      AND code_value = ad_state NO-LOCK NO-ERROR .
      If AVAILABLE CODE_mstr THEN ASSIGN state = code_cmmt .
      ELSE ASSIGN  state =  ad_state .

            /*get AR Balance of past Years*/

            IF ar_effdate < DATE(1,1,pro_y) THEN DO:

                /*get AR Balance of past Years*/
                ASSIGN Total_AR_Beginning_Balance = Total_AR_Beginning_Balance + ar_amt  .

            END.  /*IF ar_effdate < DATE(1,1,pro_y) THEN DO: */
            ELSE DO :
        IF ar_effdate  <  date(start_month,1,pro_y) THEN DO:

          /*get AR Balance of past Months of year of report*/
          ASSIGN Total_AR_Beginning_Balance = Total_AR_Beginning_Balance + ar_amt  .

        END. /*IF ar_effdate  <  date(start_month,1,pro_y) THEN DO:*/

        ElSE DO :

          /*Get records of flag_month  and init-other-var*/
          if (flag_month <> 0) and flag_month <> month(ar_effdate) then do:
            /*output monthly total value to report by line*/
              PUT UNFORMAT ar_bill AT 0
                           ad_name AT 10
               String(flag_month,'99') + '月小计:' TO 132
                Total_Sales_Qty_Month TO 155
                Total_Sales_AMT_Month TO 186
                total_amount_disc_month  TO 202
                total_amount_payment_month TO 218
                Total_AR_Beginning_Balance TO 234   SKIP .
                          /*Init Month total values*/
                          assign  total_amount_disc_month =0
        Total_Sales_AMT_Month = 0
        Total_Sales_Qty_Month = 0
        total_amount_payment_month  = 0 .
          end.


          /*output  AR Beginning Balance by ar_bill*/
          if flag_month = 0 then PUT UNFORMAT AR_Bill AT 0
          ad_name AT 10
          '期初余额:' TO 132
          Total_AR_Beginning_Balance TO 224
          SKIP .

            /*Init Per-Records values*/
            assign  total_amount_payment = 0
            total_amount_disc = 0
            total_amount_Prepayment = 0
                total_amount_charge_payment = 0
                flag_month = month(ar_effdate)
                Sales_AMT = 0
                desc1 = ''
                desc2 = ''
                sales_channel = ''
                sales_category = ''
                state = ''
                .

          /*period AR Data*/

          CASE ar_type :

            /*if it's type is "i",
            so AR Voucher is  from shipping ,
            please and reference
            to Shengxi Project Docments about MFGPRO*/

            WHEN  'i' THEN  DO :

              /*get relation data from idh_hist and in_hist and so_mstr and sod_det */
              FOR  EACH  idh_hist WHERE  idh_domain = global_domain
                      AND  idh_inv_nbr = ar_nbr NO-LOCK
                use-index idh_invln  BREAK BY idh_inv_nbr :
                for each  ih_hist  WHERE  ih_domain = global_domain
                AND  ih_inv_nbr = idh_inv_nbr NO-LOCK use-index ih_inv_nbr :

                  for each so_mstr WHERE so_domain = GLOBAL_domain AND so_nbr = ih_nbr NO-LOCK
                  use-index so_nbr :
                    for each sod_det WHERE sod_domain = GLOBAL_domain AND sod_nbr = so_nbr
                    AND sod_line = idh_line NO-LOCK use-index sod_nbrln :

                    /*get information of parts from pt_mstr*/
                    FIND FIRST pt_mstr WHERE pt_domain = global_domain AND pt_part = sod_part
                    NO-LOCK NO-ERROR .
                    IF AVAILABLE pt_mstr THEN ASSIGN desc1 = pt_desc1 desc2 = pt_desc2 .
                    ELSE ASSIGN desc1 = '' desc2 = '' .

                    /*get sales channel from code_mstr*/
                    FIND FIRST CODE_mstr WHERE CODE_domain = global_domain
                    AND code_fldname = 'so_channel' AND code_value = ih_channel NO-LOCK NO-ERROR .
                    if available code_mstr then sales_channel = code_cmmt .
                    else sales_channel = '' .

                    /*get sales category from code_mstr*/
                    FIND FIRST CODE_mstr WHERE CODE_domain = global_domain
                    AND code_fldname = 'line_category' AND trim(code_value) = trim(sod_order_category)
                    NO-LOCK NO-ERROR .
                    IF AVAILABLE CODE_mstr THEN ASSIGN sales_category = code_cmmt .
                    ELSE ASSIGN  sales_category = '' .

                    /*accumulative total Total_AR_Beginning_Balance*/
                    assign Total_AR_Beginning_Balance = Total_AR_Beginning_Balance + idh_qty_inv * idh_price
                         Sales_AMT =  idh_qty_inv * idh_price
                         Total_Sales_Qty_Month = Total_Sales_Qty_Month + idh_qty_inv
                         Total_Sales_AMT_Month = Total_Sales_AMT_Month + Sales_AMT
                    .

                    /*ouput to report */
                    /*display Detail of AP Voucher*/
/*ss - 110701 -b                if Sales_AMT <> 0 then   */
                      PUT UNFORMAT ar_bill AT 0
                                   ad_name AT 10
                             ar_effdate AT 39
                             so_inv_nbr AT 48
                             ar_nbr AT 57
                             sod_part AT 66
                             desc1 AT 85
                             desc2 AT 110
                             sod_site to 145
                             idh_qty_inv TO 155
                             idh_price TO 170
                             Sales_AMT  TO 186
                             Total_AR_Beginning_Balance TO 234
                             sales_channel AT 236
                             sales_category AT 255
                             state AT 274
                             AR_PO AT 293 SKIP .


                    end.
                  end. /*get data from so_mstr*/
                end. /*get data from ih_hist*/
              End .  /*get data from idh_hist*/
            END . /*if it's type is "i"...*/

            /*if it is from Customer's Payment,so...*/
            WHEN  'p' THEN  DO:
              /*accumulative total customer payment and customer disc-payment and customer Pre-Payment by case*/
              FOR each ard_det WHERE ard_domain = GLOBAL_domain AND ard_nbr = ar_nbr NO-LOCK :

                /*accumulative total customer payment and customer disc-payment by month*/
                    assign total_amount_payment = total_amount_payment + ard_amt
                     total_amount_disc  = total_amount_disc + ard_disc
                .

                If ard_type = 'U' then assign total_amount_Prepayment = total_amount_Prepayment + ard_amt .
                If ard_type = 'N' then assign total_amount_charge_payment = total_amount_charge_payment + ard_amt .

              End . /*FOR each ard_det WHERE ard_domain = GLOBAL_domain AND ard_nbr = ar_nbr NO-LOCK :*/

              /*accumulative total customer payment and customer disc-payment and AR Balance by month*/
                 assign total_amount_payment_month = total_amount_payment_month + total_amount_payment
                    total_amount_disc_month = total_amount_disc_month + total_amount_disc
                    Total_AR_Beginning_Balance = Total_AR_Beginning_Balance - total_amount_payment -  total_amount_disc.
                .

                /*ouput to report */
                                                                if abs(total_amount_payment) + abs(total_amount_disc)  <> 0 then  do:
                   /*display Detail of MEMO AP Voucher*/
                  PUT UNFORMAT AR_BILl AT 0
                  ad_name AT 10
                  ar_effdate AT 39
                  ar_check AT 57
                  total_amount_disc TO 202
                  total_amount_payment TO 218
                  Total_AR_Beginning_Balance TO 234
                  state AT 264 .

                /*Remark Charge Payment*/
                if   total_amount_charge_payment <> 0  then do:
                  /*Remark Pre-payment*/
                  if total_amount_Prepayment <> 0 then
                  put unformat ar_po  + '预:' + string(total_amount_Prepayment) + '借:' + string(total_amount_charge_payment) AT 293  .
                  else put unformat
                  ar_po  + '借:' + string(total_amount_charge_payment) AT 293  .
                end.
                else if total_amount_Prepayment <> 0 then put unformat ar_po  + '预:' + string(total_amount_Prepayment) AT 293  .


                /*Ent Report Line*/
                put unformat skip .
                end .
            END. /*if it is from Customer's Payment,so...*/

            /*Memo Invoice*/
            WHEN 'M' THEN DO:
              /*accumulative total Total_AR_Beginning_Balance*/
              assign Total_AR_Beginning_Balance = Total_AR_Beginning_Balance + ar_amt
                                   Total_Sales_AMT_Month = Total_Sales_AMT_Month + ar_amt
              .

              /*ouput to report */
              /*display Detail of AP Voucher*/
              if Total_Sales_AMT_Month <> 0 then
              PUT UNFORMAT ar_bill AT 0
              ad_name AT 10
              ar_effdate AT 39
              ar_nbr AT 57
              ar_amt TO 186
              Total_AR_Beginning_Balance TO 234
              AR_PO AT 293 SKIP .
            END .
          End. /*CASE ar_type : */

        END. /*period AR Data*/

        /*output ending balance*/
        if last-of(ar_bill) then do:
            PUT UNFORMAT ar_bill AT 0
                         ad_name AT 10
                   String(month(ar_effdate),'99') + '月小计:' TO 132
                   Total_Sales_Qty_Month TO 155
                   Total_Sales_AMT_Month TO 186
                   total_amount_disc_month  TO 202
                   total_amount_payment_month TO 218
                   Total_AR_Beginning_Balance TO 234   SKIP .

          PUT UNFORMAT ar_bill AT 0
                       ad_name AT 10
                 '期末余额:' TO 132
                 Total_AR_Beginning_Balance TO 234 SKIP .

          /*initialize Variance*/
          assign Total_AR_Beginning_Balance = 0
                 total_amount_disc_month =0
                 Total_Sales_AMT_Month = 0
                 Total_Sales_Qty_Month = 0
               total_amount_payment = 0
               total_amount_disc = 0
               total_amount_Prepayment = 0
               total_amount_charge_payment = 0
               total_amount_payment_month = 0
               flag_month = 0  Sales_AMT = 0
               desc1 = ''
               desc2 = ''
               sales_channel = ''
               sales_category = ''
               state = ''
               .

        end. /*if last-of(ar_bill then do:*/

      End. /*Else do:*/

        End.

  /*  For EACH  ar_mstr  WHERE ar_domain = global_domain AND  (ar_bill >= cust OR cust = "")
              AND (ar_bill <= cust1 OR cust1 = "")
        AND ar_effdate >= 12/31/2010  NO-LOCK BREAK BY ar_bill  :
  */

  /*Report Trails*/
   {mfreset.i}
END .  /*Repeat*/

{wbrp04.i &frame-spec = a}

