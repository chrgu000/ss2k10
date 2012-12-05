/* xxarrp01.p - ar report 01                                                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "121203.1"}

{xxardrrp0001.i "new"}
{xxarparp0001.i "new"}
{xxdmdmrp0001.i "new"}
{xxarrp01.i "new"}

define variable cust    like ar_bill                  no-undo.
define variable cust1   like ar_bill                  no-undo.
define variable type    like ard_sub                  no-undo.
define variable type1   like ard_sub                  no-undo.
define variable dept    like ard_cc                   no-undo.
define variable dept1   like ard_cc                   no-undo.
define variable efdate  like tr_effdate               no-undo.
define variable efdate1 like tr_effdate initial today no-undo.
define variable f1date  as   date                     no-undo.
define variable vtype   as   character                no-undo.
define variable vdept   like dpt_desc                 no-undo.
define variable vsort   like cm_sort                  no-undo.
define variable summary like mfc_logical format "Summary/Detail"
                initial yes label "Summary/Detail" no-undo.

/* SELECT FORM */
form
   cust    colon 19
   cust1   label {t001.i} colon 49 skip
   type    colon 19
   type1   label {t001.i} colon 49 skip
   dept    colon 19
   dept1   label {t001.i} colon 49 skip
   efdate  colon 19
   efdate1 label {t001.i} colon 49 skip(1)
   summary colon 28 skip(2)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign efdate1 = date(month(efdate1),1,year(efdate1)) - 1.
assign efdate = date(month(efdate1),1,year(efdate1)).
/* REPORT BLOCK */
{wbrp01.i}

repeat:

   if cust1 = hi_char then cust1 = "".
   if type1 = hi_char then type1 = "".
   if dept1 = hi_char then dept1 = "".
   if efdate = low_date then efdate = ?.
   if efdate1 = hi_date then efdate1 = ?.

   if c-application-mode <> 'web' then
   update cust cust1 type type1 dept dept1 efdate efdate1 summary
   with frame a.

   {wbrp06.i &command = update
             &fields = "cust cust1 type type1 dept dept1 efdate efdate1 summary"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i cust    }
      {mfquoter.i cust1   }
      {mfquoter.i type    }
      {mfquoter.i type1   }
      {mfquoter.i dept    }
      {mfquoter.i dept1   }
      {mfquoter.i efdate  }
      {mfquoter.i efdate1 }

      if cust1   = "" then cust1  = hi_char.
      if type1   = "" then type1  = hi_char.
      if dept1   = "" then dept1   = hi_char.
      if efdate  = ?  then efdate  = low_date.
      if efdate1 = ?  then efdate1 = hi_date.
   end.
   assign f1date = date(1,1,year(efdate1)).  /*年累计*/
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

   EMPTY TEMP-TABLE ttssardrrp0001 no-error.
   EMPTY TEMP-TABLE ttxxarparp0001 no-error.
   EMPTY TEMP-TABLE ttssdmdmrp0001_det no-error.
   EMPTY TEMP-TABLE tab0 no-error.
   EMPTY TEMP-TABLE tab1 no-error.

   {gprun.i ""xxarparp0001.p"" "(
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT cust,
      INPUT cust1,
      INPUT '',
      INPUT hi_char,
      INPUT low_date,
      INPUT hi_date,
      INPUT f1date,
      INPUT efdate1,
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT '',
      INPUT NO,
      INPUT NO
      )"}

   {gprun.i ""xxdmdmrp0001.p"" "(
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT low_date,
      INPUT hi_date,
      INPUT low_date,
      INPUT hi_date,
      INPUT f1date,
      INPUT efdate1,
      INPUT '',
      INPUT ''
      )"}

  {gprun.i ""xxardrrp0001.p"" "(
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT '',
      INPUT hi_char,
      INPUT low_date,
      INPUT hi_date,
      INPUT f1date,
      INPUT efdate1,
      INPUT ''
      )"}

/****** 9.1.24.9 pa 不含 ARD_TYPE = "D" 的********/
for each ttxxarparp0001 no-lock where
         ttxxarparp0001_ard_type <> "D" and
         ttxxarparp0001_ard_sub >= type and
         ttxxarparp0001_ard_sub <= type1 and
         ttxxarparp0001_ard_cc >= dept and
         ttxxarparp0001_ard_cc <= dept1 and
         ttxxarparp0001_ar_bill >= cust and
         ttxxarparp0001_ar_bill <= cust1:
   create tab0.
   assign t0_type = ttxxarparp0001_ard_sub
          t0_dept = ttxxarparp0001_ard_cc
          t0_cust = ttxxarparp0001_ar_bill
          t0_eff  = ttxxarparp0001_ar_effdate
          t0_pa_amt = t0_pa_amt + ttxxarparp0001_base_aramt.

   find first tab1 exclusive-lock where
        t1_type = ttxxarparp0001_ard_sub and
        t1_dept = ttxxarparp0001_ard_cc and
        t1_cust = ttxxarparp0001_ar_bill no-error.
   if not available tab1 then do:
      create tab1.
      assign t1_type = ttxxarparp0001_ard_sub
             t1_dept = ttxxarparp0001_ard_cc
             t1_cust = ttxxarparp0001_ar_bill.
   end.
   assign t1_pa_amty = t1_pa_amty + ttxxarparp0001_base_aramt.
   if month(ttxxarparp0001_ar_effdate) = month(efdate1)
   then do:
      assign t1_pa_amtm = t1_pa_amtm + ttxxarparp0001_base_aramt.
   end.
   if ttxxarparp0001_ar_effdate >= efdate and
      ttxxarparp0001_ar_effdate <= efdate1
   then do:
      assign t1_pa_amt = t1_pa_amt + ttxxarparp0001_base_aramt.
   end.
end.

/****** 9.1.24.10 dm ：9 pa ARD_TYPE = "D" 的对收********/
for each ttssdmdmrp0001_det no-lock where
         ttssdmdmrp0001_ard_sub >= type and
         ttssdmdmrp0001_ard_sub <= type1 and
         ttssdmdmrp0001_ard_cc >= dept and
         ttssdmdmrp0001_ard_cc <= dept1 and
         ttssdmdmrp0001_ar_bill >= cust and
         ttssdmdmrp0001_ar_bill <= cust1:
   create tab0.
   assign t0_type = ttssdmdmrp0001_ard_sub
          t0_dept = ttssdmdmrp0001_ard_cc
          t0_cust = ttssdmdmrp0001_ar_bill
          t0_eff  = ttssdmdmrp0001_ar_effdate
          t0_dm_amt = t0_dm_amt + ttssdmdmrp0001_base_damt.
   find first tab1 exclusive-lock where
        t1_type = ttssdmdmrp0001_ard_sub and
        t1_dept = ttssdmdmrp0001_ard_cc and
        t1_cust = ttssdmdmrp0001_ar_bill no-error.
   if not available tab1 then do:
      create tab1.
      assign t1_type = ttssdmdmrp0001_ard_sub
             t1_dept = ttssdmdmrp0001_ard_cc
             t1_cust = ttssdmdmrp0001_ar_bill.
   end.
   assign t1_dm_amty = t1_dm_amty + ttssdmdmrp0001_base_damt.
   if month(ttssdmdmrp0001_ar_effdate) = month(efdate1) then do:
      assign t1_dm_amtm = t1_dm_amtm + ttssdmdmrp0001_base_damt.
   end.
   if ttssdmdmrp0001_ar_effdate >= efdate and
      ttssdmdmrp0001_ar_effdate <= efdate1 then do:
      assign t1_dm_amt = t1_dm_amt + ttssdmdmrp0001_base_damt.
   end.
end.

/****** 9.1.24.8 invoice ard_sub = "S0105" 是税，其他的是发票 ********/
FOR EACH ttssardrrp0001 no-lock where
         ttssardrrp0001_ar_sub >= type and
         ttssardrrp0001_ar_sub <= type1 and
         ttssardrrp0001_ar_cc >= dept and
         ttssardrrp0001_ar_cc <= dept1 and
         ttssardrrp0001_ar_bill >= cust and
         ttssardrrp0001_ar_bill <= cust1:
    create tab0.
    assign t0_type = ttssardrrp0001_ar_sub
           t0_dept = ttssardrrp0001_ar_cc
           t0_cust = ttssardrrp0001_ar_bill
           t0_eff  = ttssardrrp0001_ar_effdate.
    assign t0_tx_amt = t0_tx_amt + ttssardrrp0001_ard_base_amt
                        when ttssardrrp0001_ard_sub = "S0105"
           t0_dr_amt = t0_dr_amt + ttssardrrp0001_ard_base_amt
                        when ttssardrrp0001_ard_sub <> "S0105".
    find first tab1 exclusive-lock where
               t1_type = ttssardrrp0001_ar_sub and
               t1_dept = ttssardrrp0001_ar_cc and
               t1_cust = ttssardrrp0001_ar_bill
         no-error.
    if not available tab1 then  do:
    create tab1.
    assign t1_type = ttssardrrp0001_ar_sub
           t1_dept = ttssardrrp0001_ar_cc
           t1_cust = ttssardrrp0001_ar_bill.
    end.
    assign t1_tx_amty = t1_tx_amty + ttssardrrp0001_ard_base_amt
                        when ttssardrrp0001_ard_sub = "S0105"
           t1_dr_amty = t1_dr_amty + ttssardrrp0001_ard_base_amt
                        when ttssardrrp0001_ard_sub <> "S0105".
    if month(ttssardrrp0001_ar_effdate) = month(efdate1) then do:
    assign t1_tx_amtm = t1_tx_amtm + ttssardrrp0001_ard_base_amt
                        when ttssardrrp0001_ard_sub = "S0105"
           t1_dr_amtm = t1_dr_amtm + ttssardrrp0001_ard_base_amt
                        when ttssardrrp0001_ard_sub <> "S0105".

    end.
    if ttssardrrp0001_ar_effdate >= efdate and
       ttssardrrp0001_ar_effdate <= efdate1
    then do:
    assign t1_tx_amt = t1_tx_amt + ttssardrrp0001_ard_base_amt
                       when ttssardrrp0001_ard_sub = "S0105"
           t1_dr_amt = t1_dr_amt + ttssardrrp0001_ard_base_amt
                       when ttssardrrp0001_ard_sub <> "S0105".

    end.
END.

if summary then do:
   export delimiter ";" "分类代码" "分类" "部门代码" "部门" "客户代码" "客户"
                        "回款额" "承兑到账" "月累计回款" "年累计回款"
                        "销售额" "销项税" "月累计开票" "年累计开票".
   for each tab1 no-lock:
   assign vtype = ""
          vdept = ""
          vsort = "".
   if t1_type = "HK001" then assign vtype = '仪器'.
   else if t1_type = "HK002" then assign vtype = '数显'.
                             else assign vtype = '其他'.
   find first code_mstr no-lock where code_domain = global_domain and
              code_fldname = "ss_20100423_001" and 
              code_value = t1_dept no-error.
   if available code_mstr then do:
      assign vdept = code_cmmt.
   end.
   find first cm_mstr no-lock where cm_domain = global_domain and
              cm_addr = t1_cust no-error.
   if available cm_mstr then do:
      assign vsort = cm_sort.
   end.
   EXPORT DELIMITER ";" t1_type
                        vtype
                        t1_dept
                        vdept
                        t1_cust
                        vsort
                        t1_pa_amt
                        t1_dm_amt
                        t1_pa_amtm + t1_dm_amtm
                        t1_pa_amty + t1_dm_amty
                        t1_dr_amt
                        t1_tx_amt
                        t1_dr_amtm + t1_tx_amtm
                        t1_dr_amty + t1_tx_amty
                        .
   end.
   put unformat "<EOF>".
end.
else do:
  export delimiter ";" "分类代码" "分类" "部门代码" "部门" "客户代码" "客户"
                       "生效日" "回款额" "承兑到账"  "销售额" "销项税".
  for each tab0 no-lock:
      assign vtype = ""
             vdept = ""
             vsort = "".
      if t0_type = "HK001" then assign vtype = '仪器'.
          else if t0_type = "HK002" then assign vtype = '数显'.
                                    else assign vtype = '其他'.
      find first code_mstr no-lock where code_domain = global_domain and
                 code_fldname = "ss_20100423_001" and 
                 code_value = t1_dept no-error.
      if available code_mstr then do:
         assign vdept = code_cmmt.
      end.
      find first cm_mstr no-lock where cm_domain = global_domain and
                 cm_addr = t0_cust no-error.
      if available cm_mstr then do:
         assign vsort = cm_sort.
      end.
      export delimiter ";" t0_type
                           vtype
                           t0_dept
                           vdept
                           t0_cust
                           vsort
                           string(year(t0_eff),"9999") + "-" +
                           string(month(t0_eff),"99") + "-" +
                           string(day(t0_eff),"99")
                           t0_pa_amt
                           t0_dm_amt
                           t0_dr_amt
                           t0_tx_amt.
  end.
  put unformat "<EOF>".
end.
      {mfreset.i}
end.

{wbrp04.i &frame-spec = a}
