/* yysparesdiscrp.p - sales discount report */
/* ss - 121029.1 by: Steven */

/*-Revision end-------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121029.1"}

/* ********** Begin Translatable Strings Definitions ********* */
define variable entity     as   char no-undo initial "DCEC".
define variable entity1    as   char no-undo initial "DCEC".
define variable effdate    as   date no-undo.
define variable effdate1   as   date no-undo.
define variable custtype   as   char format "x(1)"         no-undo.
define variable sel        as   logical extent 7 no-undo.
define variable yn         as   logical                    no-undo.
define variable rat        as   decimal                    no-undo.
define temp-table tt_temp
       field  tt_cust      like so_cust
       field  tt_name      like cm_sort
       field  tt_sonbr     like so_nbr
       field  tt_sormks    like so_rmks
       field  tt_mtlovh       as decimal
       field  tt_service      as decimal
       field  tt_inv_amt_year as decimal
       field  tt_inv_amt_ttl  as decimal
       field  tt_inv_amt_mth  as decimal format "->>,>>>,>>9.99"
       field  tt_disc         as decimal extent 8  format "->>,>>>,>>9.99"
       index  tt_idx
              tt_cust .

/* define Excel object handle */
 DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
 DEFINE VARIABLE chWorkSheet AS COM-HANDLE.
 define variable excel_row as integer init 1.
 define variable excel_col as integer init 1.
 define variable totalamt as   deci.
 define variable i        as   int.

assign effdate1 = date(month(today),1,year(today)) - 1.
assign effdate = date(month(effdate1),1,year(effdate1)).
do i = 1 to 7:     
	 assign sel[i] = yes.
end.
/*
 effdate  = date(string(month(today)) + '/01/' + string(year(today))).
 if month(today) = 12 then
    effdate1 = date('01/01/' + string(year(today) + 1)) - 1.
 else
    effdate1 = date(string(month(today) + 1) + '/01/' + string(year(today))) - 1.
*/
/*GUI preprocessor Frame A define */

&SCOPED-DEFINE PP_FRAME_NAME A

FORM
   skip(1)
   entity   colon 20 label "会计单位"  entity1  colon 50 label {t001.i} skip
   effdate  colon 20 label "生效日期"  effdate1 colon 50 label {t001.i} skip
   custtype colon 20 label "客户组(A/B/C)"
   validate(custtype = 'A' or custtype = 'B' or custtype = 'C' ,"Invalid Customer Type!") SKIP(1)
   sel[1] colon 22 label "选择方法" "1(CRM订单)"         skip
   sel[2] colon 22 no-label         "2(CRM销售订单超额)" skip
   sel[3] colon 22 no-label         "3(CRM长交期订单)"   skip
   sel[4] colon 22 no-label         "4(紧急订单)"        skip
   sel[5] colon 22 no-label         "5(三包)"            skip
   sel[6] colon 22 no-label         "6(全年已开票)"      skip
   sel[7] colon 22 no-label         "7(特殊计算)"        skip
   skip(1)
with frame a side-labels width 80  THREE-D title "备件收入折扣计算" /*GUI*/.

setFrameLabels(frame a:handle).
/* REPORT BLOCK */

{wbrp01.i}

repeat:
    if effdate  = low_date then effdate = ?.
    if effdate1 = hi_date  then effdate1 = ?.
    if entity1  = hi_char  then entity1 = "".
    sel = no.
    update entity  validate(can-find(first en_mstr where en_domain = global_domain
                            and en_entity = entity),"Entity not defined in General Ledger!")
           entity1 validate(can-find(first en_mstr where en_domain = global_domain
                            and en_entity = entity1),"Entity not defined in General Ledger!")
           effdate effdate1
           custtype sel[1] sel[1] sel[2] sel[3] sel[4] sel[5] sel[6] sel[7]
    with frame a.
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      {mfquoter.i entity    }
      {mfquoter.i entity1   }
      {mfquoter.i effdate   }
      {mfquoter.i effdate1  }
      if entity1 = "" then entity1 = hi_char.
   end.

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
               &defineVariables = "yes"
   }
   {mfphead.i}

   for EACH cm_mstr NO-LOCK WHERE cm_domain = global_domain
        AND cm_type = custtype,
       each ih_hist no-lock where ih_domain = global_domain
        and ih_cust = cm_addr and ih_inv_date >= date(1,1,year(today))
        and ih_inv_date <= today ,
       each idh_hist no-lock where idh_domain = global_domain
        and idh_nbr = ih_nbr and idh_inv_nbr = ih_inv_nbr ,
       each tx2d_det no-lock where tx2d_domain = global_domain
        and tx2d_ref = ih_inv_nbr and tx2d_nbr = idh_nbr
        and tx2d_line = idh_line ,
       each so_mstr no-lock where so_domain = global_domain
        and so_nbr = idh_nbr :

       find first tt_temp where tt_cust = so_cust  and tt_sonbr = so_nbr no-error.
       if not avail tt_temp then do:
          create tt_temp.
          assign tt_cust = so_cust
                 tt_sonbr = so_nbr.
       end.
       assign tt_sormks = so_rmks.
       tt_inv_amt_year = tt_inv_amt_year + tx2d_tax_amt + tx2d_taxable_amt.
       if year(ih_inv_date) = year(effdate1) and
          month(ih_inv_date) = month(effdate1) then do:
          tt_inv_amt_mth = tt_inv_amt_mth + tx2d_tax_amt + tx2d_taxable_amt.
       end.

        assign tt_name  = cm_sort .
     find first yyspares_disc where yysparesdisc_domain =  global_domain
       and yysparesdisc_cust = so_cust and yysparesdisc_effdate >= effdate
       and yysparesdisc_due_date <= effdate1 or yysparesdisc_due_date = ?
           no-lock no-error.
        if available yyspares_disc then do:
              assign tt_service = yysparesdisc_service
                     tt_inv_amt_ttl = yysparesdisc_ovh_mtl.
        end.
   end.

for each tt_temp exclusive-lock:
    if sel[1] then do:
       if tt_sormks begins "#CRM" then tt_disc[1] = tt_inv_amt_mth * 0.01.
    end.
    if sel[2] then do:
       if tt_sormks begins "#CRM" and tt_inv_amt_mth >= 50000
          then tt_disc[3] = tt_inv_amt_mth * 0.02.
    end.
    if sel[3] then do:
       if tt_sormks begins "#CRM#长交期" then tt_disc[3] = tt_inv_amt_mth * 0.02.
    end.
    if sel[4] then do:
       if tt_sormks begins "#CRM#长交期" then tt_disc[4] = 0.
    end.
    if sel[5] then do:
       assign rat = tt_inv_amt_ttl / tt_inv_amt_mth.
       if rat < 0.5 then
          assign tt_disc[5] = (tt_inv_amt_mth - tt_inv_amt_ttl) * 0.03.
       else if rat >= 0.5 and rat < 0.7 then
          assign tt_disc[5] = (tt_inv_amt_mth - tt_inv_amt_ttl) * 0.02.
       else if rat >= 0.7 and rat < 0.8 then
          assign tt_disc[5] = (tt_inv_amt_mth - tt_inv_amt_ttl) * 0.01.
       else
          assign tt_disc[5] = 0.
    end.
    if sel[6] then do:
       if tt_inv_amt_year >= 2000000 and tt_inv_amt_year <= 5000000 then
          assign tt_disc[6] = tt_inv_amt_year * .01.
       else if tt_inv_amt_year > 5000000 and tt_inv_amt_year <= 8000000 then
          assign tt_disc[6] = tt_inv_amt_year * .02.
       else if tt_inv_amt_year > 8000000 then
          assign tt_disc[6] = tt_inv_amt_year * .03.
    end.
    if sel[7] then do:
       assign tt_disc[7] = (tt_inv_amt_year - tt_service ) * .06.
    end.
end.
for each tt_temp exclusive-lock:
    do i = 1 to 7.
       assign tt_disc[8] = tt_disc[8] + tt_disc[i].
    end.
end.


/****** tx01 ********/
/******start tx01 ********/
   CREATE "Excel.Application" chExcelApplication.
   chExcelWorkbook = chExcelApplication:Workbooks:add().
   chWorkSheet = chExcelApplication:Sheets:Item(1).
   excel_row = 1.
   excel_col = 1.
   chWorkSheet:cells(1,6) = " ".
   excel_row = 1.
   excel_col = 1.

   chWorkSheet:cells(excel_row,excel_col) = "客户代码".
   excel_col = excel_col + 1.
   chWorkSheet:cells(excel_row,excel_col) = "客户描述".
   excel_col = excel_col + 1.
   chWorkSheet:cells(excel_row,excel_col) = "当月已开票额(含税)".
   excel_col = excel_col + 1.
   chWorkSheet:cells(excel_row,excel_col) = "当年已累计开票额(含税)".
   do i = 1 to 7 : 
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col)
      = "方法 " + string(i,"9") + "折扣额".
   end.
   chWorkSheet:cells(excel_row,excel_col + 1) = "当月折扣额合计".
   for each tt_temp no-lock:
      excel_row = excel_row + 1.
      excel_col = 1.
      chWorkSheet:cells(excel_row,excel_col) = "'" + tt_cust.
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col) = "'" + tt_name.
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col) = tt_inv_amt_mth.
      excel_col = excel_col + 1.
      chWorkSheet:cells(excel_row,excel_col) = tt_inv_amt_year.

      do i = 1 to 8:
        /* if sel[i] = no then next. */
         excel_col = excel_col + 1.
         chWorkSheet:cells(excel_row,excel_col) = tt_disc[i].
      end.
   end.
   chExcelApplication:visible = true.
   RELEASE OBJECT chExcelWorkbook.
   RELEASE OBJECT chExcelApplication.
   RELEASE OBJECT chWorkSheet.
/******end tx01 ********/
   {mfrtrail.i}
   hide message no-pause.
   {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.
