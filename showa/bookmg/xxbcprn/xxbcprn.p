/* xxbkrp.p - book report                                                     */
/*V8:ConvertMode=FullGUIReport                                                */

/* DISPLAY TITLE */
{mfdtitle.i "120115.1"}
{xxbkmg.i}

define variable v_bc like xxbc_id.
define variable v_bc1 like xxbc_id.
define variable v_lendcnt as integer.
define variable v_latecnt as integer.
define variable v_onhand  as integer.
define variable v_onlate  as integer.
define variable v_days as integer.
define variable v_maxlate as integer.
define variable v_avail like mfc_logical.
define variable v_start as date.
define variable v_start1 as date.
define variable v_bctype as character format "x(10)".
define variable v_bcstat as character format "x(10)".
define variable v_bk like xxbk_id.
define variable v_bkname like xxbk_name.
define variable report_detail like mfc_logical initial yes.
define variable v_late like mfc_logical.

form
   v_bc   colon 12
   v_bc1  colon 40 label {t001.i}
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if v_bc1 = hi_char then v_bc1 = "".
   if c-application-mode <> 'web' then
      update v_bc v_bc1 with frame a.

   {wbrp06.i &command = update
             &fields = " v_bc v_bc1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if v_bc1 = "" then v_bc1 = hi_char.
      if v_start = ? then v_start = low_date.
      if v_start1 = ? then v_start1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
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

{xxbcprn.i}
   for each xxbc_lst no-lock
      where xxbc_id >= v_bc and xxbc_id <= v_bc1
   with frame b width 320 no-attr-space:
 			run printbc(input "bc",
 									input xxbc_id,
 								  input "",
 								  input "",
 								  input "").
      {mfrpchk.i}
   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
