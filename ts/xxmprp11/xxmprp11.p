/* xxmprp11.p - MRP SUMMARY REPORT WITH DETAIL & ACTION MESSAGES OPTIONAL     */
/* $Revision: 1.8.1.5 $                                                       */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=FullGUIReport                                                */

{mfdtitle.i "111008.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrmprp11_p_1 "Include Base Process Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_2 "Per Column"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_3 "Include Zero Requirements"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_4 "Print Action Messages"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_5 "Item Number/BOM Formula"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_6 "Print Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_7 "Print Substitute Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_8 "Day/Week/Month"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_9 "Use Cost Plans"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_10 "Sort by Item or BOM/Formula"
/* MaxLen: Comment: */

{xxmprp1a.i "new"}
/*  {xxbmwua.i "new"} */

form
   part        colon 27
   part1       label {t001.i} colon 52
   site        colon 27
   site1       label {t001.i} colon 52
   buyer       colon 27
   buyer1      label {t001.i} colon 52
   prod_line   colon 27
   prod_line1  label {t001.i} colon 52
   ptgroup     colon 27
   ptgroup1    label {t001.i} colon 52
   part_type   colon 27
   part_type1  label {t001.i} colon 52
   vendor      colon 27
   vendor1     label {t001.i} colon 52

   skip(1)
   start       colon 27
   ending      colon 47
   dwm         colon 27
   idays       colon 47
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first mrpc_ctrl  where mrpc_ctrl.mrpc_domain = global_domain no-lock
no-error.
start = today.
if (mrpc_sum_def > 0) and (mrpc_sum_def < 8) then
   do while not (weekday(start) = mrpc_sum_def):
   start = start - 1.
end.

site = global_site.
site1 = global_site.

{wbrp01.i}

repeat:

   if start = ? then start = today.
   if old_start <> ? then start = old_start.
   if dwm = "" then dwm = "W".
   if idays = 0 or idays = ? then idays = 1.
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if buyer1 = hi_char then buyer1 = "".
   if prod_line1 = hi_char then prod_line1 = "".
   if ptgroup1 = hi_char then ptgroup1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if vendor1 = hi_char then vendor1 = "".
   if ending = hi_date then ending = ?.

   if c-application-mode <> 'web' then
   update
      part
      part1
      site
      site1
      buyer
      buyer1
      prod_line
      prod_line1
      ptgroup
      ptgroup1
      part_type
      part_type1
      vendor
      vendor1
      start
      ending
      dwm
      idays
   with frame a.

   {wbrp06.i &command = update &fields = " part part1 site site1 buyer buyer1
         prod_line prod_line1 ptgroup ptgroup1 part_type part_type1
         vendor vendor1 start ending dwm idays " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i part      }
      {mfquoter.i part1     }
      {mfquoter.i site      }
      {mfquoter.i site1     }
      {mfquoter.i buyer     }
      {mfquoter.i buyer1    }
      {mfquoter.i prod_line }
      {mfquoter.i prod_line1 }
      {mfquoter.i ptgroup   }
      {mfquoter.i ptgroup1   }
      {mfquoter.i part_type }
      {mfquoter.i part_type1 }
      {mfquoter.i vendor    }
      {mfquoter.i vendor1    }
      {mfquoter.i start     }
      {mfquoter.i ending    }
      {mfquoter.i dwm       }
      {mfquoter.i idays     }

      /* STANDARD DWMP CRITERION VALIDATION */
      if index("dwmp",dwm) = 0 then do:
         {pxmsg.i &MSGNUM=14 &ERRORLEVEL=3}
         /* "INTERVAL MUST BE (D)ay (W)eek OR (M)onth.*/

         if c-application-mode = 'web' then return.
         else next-prompt dwm with frame a.
         undo, retry.
      end.

      if start = ? then start = today.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if buyer1 = "" then buyer1 = hi_char.
      if prod_line1 = "" then prod_line1 = hi_char.
      if ptgroup1 = "" then ptgroup1 = hi_char.
      if part_type1 = "" then part_type1 = hi_char.
      if vendor1 = "" then vendor1 = hi_char.
      if ending = ? then ending = hi_date.

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

   out_dev = dev.
   {mfphead.i}

   loopb:
   do on error undo , leave:
        {gprun.i ""xxmprp11a.p""}
   end. /* loopb */

   {mfrtrail.i}
end. /* repeat */

{wbrp04.i &frame-spec = a}
