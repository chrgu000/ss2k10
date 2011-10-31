/* xxlmnrp.p - part loc reference Report                                    */
/* revision: 110818.1   created on: 20110818   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110818.1"}

define variable line like ln_line.
define variable line1 like ln_line.

/* SELECT FORM */
form
   line  colon 15
   line1 label {t001.i} colon 49 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if line1 = hi_char then line1 = "".

   if c-application-mode <> 'web' then
      update line line1 with frame a.

   {wbrp06.i &command = update
      &fields = " line line1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i line   }
      {mfquoter.i line1  }

      if line1 = "" then line1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 240
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

   for each xxlnm_det no-lock
      where (xxlnm_line >= line and xxlnm_line <= line1),
      each ln_mstr no-lock where ln_line = xxlnm_line and ln_site = xxlnm_site,
      each si_mstr no-lock where si_site = xxlnm_site,
      each code_mstr no-lock where code_fldname = "xxlnm_type" and
           code_value = xxlnm_type
   break by xxlnm_line by xxlnm_site
   with frame b width 240:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      display
          ln_line
          ln_desc
          si_site
          si_desc
          xxlnm_type
          code_cmmt
          xxlnm_desc
          xxlnm_pkstart
          xxlnm_pkend
          xxlnm_sdstart
          xxlnm_sdend.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
