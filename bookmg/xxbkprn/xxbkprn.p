/* xxbkrp.p - book report                                                     */
/*V8:ConvertMode=FullGUIReport                                                */

/* DISPLAY TITLE */
{mfdtitle.i "120115.1"}
{xxbkmg.i}

define variable v_book like xxbk_id.
define variable v_book1 like xxbk_id.
define variable vprice as character.
define variable v_bktype as character format "x(20)".
define variable v_bkstat as character format "x(10)".
define variable v_lendcnt as integer.
define variable v_days as integer.
define variable v_avail like mfc_logical.
define variable v_start as date.
define variable v_start1 as date.
/* define variable v_bc like xxbc_id. */
define variable v_bcname like xxbc_name.
/* define variable v_blstart as date.           */
/* define variable v_end like xxbl_end.         */
define variable v_latecnt as integer.
define variable v_onhand  as integer.
define variable v_onlate  as integer.
/* define variable v_days as integer. */
define variable v_maxlate as integer.
define variable v_late like mfc_logical.
define variable report_detail like mfc_logical initial yes.
form
   v_book   colon 12
   v_book1  colon 40 label {t001.i}
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:

   if v_book1 = hi_char then v_book1 = "".
   if c-application-mode <> 'web' then
      update v_book v_book1 with frame a.

   {wbrp06.i &command = update
             &fields = " v_book v_book1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if v_book1 = "" then v_book1 = hi_char.
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
   for each xxbk_lst no-lock
      where xxbk_id >= v_book and xxbk_id <= v_book1
   with frame b width 320 no-attr-space:
			assign vprice = string(xxbk_price,">>>>9.<<").
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
			run printbc(input "BK",
								  input xxbk_id,
									input xxbk_name,
								  input xxbk_desc,
								  input vprice).
      {mfrpchk.i}

   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
