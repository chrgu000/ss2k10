/* xxrar010.p - customer ar report                                           */
/* revision: 110810.1   created on: 20110810   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb2sp6    Interface:Character         */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120106.1"}
{xxrar0101.i "new"}
define variable site like ld_site.
define variable site1 like ld_site.
define variable dept like dpt_dept.
define variable dept1 like dpt_dept.
define variable cate  as character.
define variable cate1 as character.
define variable dates  as date.
define variable dates1 as date initial today.
define variable adsort like ad_sort.
define variable dptdesc like dpt_desc.
define variable ptdesc1 like pt_desc1.
define variable cate0   as character.
define variable vprice  like sod_price.

/* SELECT FORM */
form
   site  colon 19
   site1 label {t001.i} colon 49 skip
   dept  colon 19
   dept1 label {t001.i} colon 49 skip
   cust  colon 19
   cust1 label {t001.i} colon 49 skip
   cate  colon 19
   cate1 label {t001.i} colon 49 skip
   dates colon 19
   dates1 label {t001.i} colon 49 skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */
{wbrp01.i}

repeat:

    FIND FIRST xcomppi_mstr WHERE xcomppi_domain = global_domain AND
               xcomppi_user = global_userid NO-LOCK NO-ERROR .
    if available xcomppi_mstr then do:
       ASSIGN dept = xcomppi_company
              dept1 = xcomppi_company.
     DISPLAY dept dept1 WITH FRAME a .
    END.
   if dates = ? then assign dates = today - day(today) + 1.
   if site1 = hi_char then site1 = "".
   if dept1 = hi_char then dept1 = "".
   if cust1 = hi_char then cust1 = "".
   if cate1 = hi_char then cate1 = "".
   if dates1 = hi_date then dates1 = ?.

   assign dates1 = dates - 1.
          dates = date(month(dates1),1,year(dates1)).

   IF dept1 = "0000" THEN DO:
      if c-application-mode <> 'web' then
      update site site1 dept dept1 cust cust1 cate cate1 dates dates1
      with frame a.
   END.
   ELSE DO:
      if c-application-mode <> 'web' then
      update site site1 cust cust1 cate cate1 dates dates1
      with frame a.
   END.

   {wbrp06.i &command = update
             &fields = "site site1 dept dept1 cust cust1
                        cate cate1 dates dates1 "
             &frm = "a"}

    IF NOT AVAILABLE xcomppi_mstr THEN DO: /*msgnbr=4040*/
        {pxmsg.i &MSGNUM=4040 &ERRORLEVEL=3}
        pause 100.
        leave.
    END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      bcdparm = "".
      {mfquoter.i site}
      {mfquoter.i site1}
      {mfquoter.i dept}
      {mfquoter.i dept1}
      {mfquoter.i cust}
      {mfquoter.i cust1}
      {mfquoter.i cate}
      {mfquoter.i cate1}
      {mfquoter.i dates}
      {mfquoter.i dates1}
      if site1 = "" then site1 = hi_char.
      if dept1 = "" then dept1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if cate1 = "" then cate1 = hi_char.
      if dates1 = ? then dates1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
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

/* {mfphead.i} */

{gprun.i ""xxrar0101.p""}

put unformat "" "~011" "" "~011" "" "~011" "" "~011" "" "~011" "" "~011"
             getTermLabel("CUSTMOER_ARREARS_DETAIL",16) skip.
put unformat getTermLabel("TYPE",12) "~011"
             getTermLabel("DEPARTMENT_CODES",12) "~011"
             getTermLabel("DEPARTMENT",12) "~011"
             getTermLabel("CUSTOMER_CODE",12) "~011"
             getTermLabel("CUSTOMERS",12) "~011"
             getTermLabel("OPORDER",12) "~011"
             getTermLabel("EFFECTIVE_DATE",12) "~011"
             getTermLabel("ITEM_NUMBER",12) "~011"
             getTermLabel("ITEM_DESCRIPTION",12) "~011"
             getTermLabel("QUANTITY",12) "~011"
             getTermLabel("UNIT_PRICE",12) "~011"
             getTermLabel("SHIP",12) "~011"
             getTermLabel("BILLED",12) "~011"
             getTermLabel("BILLED_WRITE_OFF",12) "~011"
             getTermLabel("COLLECTIONS",12) "~011"
             getTermLabel("COLLECTIONS_BILL",12) "~011"
             getTermLabel("COLLECTIONS_BILL_WRITE_OFF",12) "~011"
             getTermLabel("COMMENT",12) "~011"
             getTermLabel("REMARK",12)
             skip.
for each tr_hist no-lock where tr_domain = global_domain and
         tr_type = "RCT-TR" and
         substring(tr_loc,length(trim(tr_loc)) - 1) = "99"
         and tr_effdate >= dates and (tr_effdate <= dates1 or dates1 = ?),
    first so_mstr no-lock where so_domain = global_domain and
          so_nbr = tr_ref and
          so__chr01 >= dept and (so__chr01 <= dept1 or dept1 = "" )
    break by tr_type by tr_effdate:
    find first sod_det no-lock where sod_domain = global_domain and
               sod_nbr = so_nbr and sod_part = tr_part no-error.
    if availabl sod_det then do:
       assign vprice = sod_price.
    end.
    else do:
       assign vprice = 0.
    end.
    if substring(so_nbr,1,1) = "S" then do:
       assign cate0 = getTermLabel("DIGITAL_DISPLAY",12).   /*ÊýÏÔ*/
    end.
    else if substring(so_nbr,1,2) = "QT" then do:
       assign cate0 = getTermLabel("OTHER",12).     /*ÆäËû*/
    end.
    else do:
       assign cate0 = getTermLabel("INSTRUMENT",12).  /*ÒÇÆ÷*/
    end.
    find first code_mstr no-lock where code_domain = global_domain and
               code_fldname = "ss_20100423_001" and
               code_value = so__chr01 no-error.
    assign dptdesc = "" adsort = "" ptdesc1 = "".
    if availabl code_mstr then do:
       assign dptdesc = code_cmmt.
    end.
    FIND FIRST cm_mstr WHERE cm_domain = global_domain
           AND cm_addr = so_cust NO-LOCK NO-ERROR.
    if availabl cm_mstr then do:
       assign adsort = cm_sort.
    end.
    FIND FIRST pt_mstr WHERE pt_domain = global_domain
          AND pt_part = tr_part NO-LOCK NO-ERROR.
    if availabl pt_mstr then do:
       assign ptdesc1 = pt_desc1.
    end.
export delimiter "~011" cate0 so__chr01 dptdesc so_cust adsort so_nbr
        tr_effdate sod_part ptdesc1 tr_qty_loc vprice
        tr_qty_loc * vprice tr_trnbr.
end.

for each tmp_ar no-lock where ta_due_date >= dates and
         ta_due_date <= dates1 and ta_cust >= cust and ta_cust <= cust1
         by recid(tmp_ar):
    assign dptdesc = "" adsort = "" ptdesc1 = "".
    assign cate0 = "".
    if ta_sub = "HK001" then do:
       assign cate0 = getTermLabel("INSTRUMENT",12).
    end.
    else if ta_sub = "HK002" then do:
       assign cate0 = getTermLabel("DIGITAL_DISPLAY",12).
    end.
    else if ta_sub = "HK003" then do:
       assign cate0 = getTermLabel("OTHER",12).
    end.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain
           AND ad_addr = ta_cust NO-LOCK NO-ERROR.
    if availabl ad_mstr then do:
       assign adsort = ad_sort.
    end.
    find first code_mstr no-lock where code_domain = global_domain and
               code_fldname = "ss_20100423_001" and
               code_value = ta_cc no-error.
    if availabl code_mstr then do:
       assign dptdesc = code_cmmt.
    end.
if ta_type = "I" then do:
export delimiter "~011"
       cate0
       ta_cc
       dptdesc
       ta_cust
       adsort
       ta_nbr
       if ta_due_date <> ? then ta_due_date else ta_date
       ""
       ""
       ""
       ""
       ""
       ta_amt
       ""
       ""
       ""
       ""
       getTermLabel("BILLED",12).
       ta_check.
export delimiter "~011"
       cate0
       ta_cc
       dptdesc
       ta_cust
       adsort
       ta_nbr
       if ta_due_date <> ? then ta_due_date else ta_date
       ""
       ""
       ""
       ""
       ""
       ""
       ta_amt
       ""
       ""
       ""
       getTermLabel("COLLECTIONS",12).
       ta_check.
end.
else if ta_type = "P" then do:
export delimiter "~011"
       cate0
       ta_cc
       dptdesc
       ta_cust
       adsort
       ta_nbr
       if ta_due_date <> ? then ta_due_date else ta_date
       ""
       ""
       ""
       ""
       ""
       ""
       ""
       ta_amt
       ""
       ""
       getTermLabel("COLLECTIONS",12).
       ta_check.
end.
else if ta_type = "D" then do:
export delimiter "~011"
       ""
       ta_cc
       dptdesc
       ta_cust
       adsort
       ta_nbr
       if ta_due_date <> ? then ta_due_date else ta_date
       ""
       ""
       ""
       ""
       ""
       ""
       ""
       ""
       ta_amt
       ""
       getTermLabel("COLLECTIONS_BILL",12).
       ta_check.
export delimiter "~011"
       ""
       ta_cc
       dptdesc
       ta_cust
       adsort
       ta_nbr
       if ta_due_date <> ? then ta_due_date else ta_date
       ""
       ""
       ""
       ""
       ""
       ""
       ""
       ""
       ""
       ta_amt
       getTermLabel("EXCHANGE_RECIVE_MATURITY",12).
       ta_check.
end.
end.
   /* REPORT TRAILER  */
/*   {mfrtrail.i}  */
{mfreset.i}

end.

{wbrp04.i &frame-spec = a}
