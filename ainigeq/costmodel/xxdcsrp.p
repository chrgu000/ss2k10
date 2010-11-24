/* xxdcsrp.p xxdcs_mstr record REPORT                                        */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable period1  like xxdcs_period.
define variable period2  like xxdcs_period.
define variable element1 like xxdcs_element.
define variable element2 like xxdcs_element.
define variable dept1    like xxdcs_dept.
define variable dept2    like xxdcs_dept.
define variable eledesc  as   character format "x(16)" label "因素说明".
define variable dptdesc  like dpt_desc.
form
   period1  colon 20 label "分配期间"
   period2  colon 40 label "至"
   element1 colon 20 label "分配因素"
   element2 colon 40 label "至"
   dept1    colon 20 label "分配部门"
   dept2    colon 40 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS
setFrameLabels(frame a:handle).
*/
/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:

   if period2 = hi_char then period2 = "".
   if element2 = hi_char then element2 = "".
   if dept2 = hi_char then dept2 = "".

   if c-application-mode <> 'web' then
      update period1 period2 element1 element2 dept1 dept2 with frame a.

   {wbrp06.i &command = update
             &fields = " period1 period2 element1 element2 dept1 dept2 "
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if period2 = "" then period2 = hi_char.
      if element2 = "" then element2 = hi_char.
      if dept2 = "" then dept2 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 92
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

   for each xxdcs_mstr no-lock where
            xxdcs_period >= period1 and xxdcs_period <= period2 and
            xxdcs_element >= element1 and xxdcs_element <= element2 and
            xxdcs_dept >= dept1 and xxdcs_dept <= dept2
   with frame b width 92 no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}
      find first code_mstr no-lock where code_fldname = "xxdcs_element"
             and code_value = xxdcs_element no-error.
      if avail code_mstr then do:
         assign eledesc = code_cmmt.
      end.
      else do:
         assign eledesc = "".
      end.
      find first dpt_mstr no-lock where dpt_dept = xxdcs_dept no-error.
      if avail dpt_mstr then do:
         assign dptdesc = dpt_desc.
      end.
      else do:
         assign dptdesc  = "".
      end.
      display xxdcs_period  column-label "分配期间"
              xxdcs_element column-label "因素"
              eledesc       column-label "因素说明"
              xxdcs_dept    column-label "部门"
              dptdesc       column-label "部门描述"
              xxdcs_amt     column-label "分配金额".
   end.
   {mfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
