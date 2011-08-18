/* xxptlorp.p - part loc reference Report                                    */
/* revision: 110818.1   created on: 20110818   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110818.1"}

define variable part like pt_part.
define variable part1 like pt_part.
define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable um like pt_um.

/* SELECT FORM */
form
   part           colon 15
   part1          label "To" colon 49 skip
   site           colon 15
   site1          label "To" colon 49 skip
   loc            colon 15
   loc1           label "To" colon 49 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".

   if c-application-mode <> 'web' then
      update part part1 site site1 loc loc1 with frame a.

   {wbrp06.i &command = update
      &fields = "  part part1 site site1 loc loc1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }

      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 160
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

   for each xxpl_ref no-lock
      where (xxpl_part >= part and xxpl_part <= part1)
      and (xxpl_site >= site and xxpl_site <= site1)
      and (xxpl_loc >= loc and xxpl_loc <= loc1)
      use-index xxpl_part,
      each pt_mstr no-lock where pt_part = xxpl_part,
      each loc_mstr no-lock where loc_loc = xxpl_loc and loc_site = xxpl_site,
      each si_mstr no-lock where si_site = xxpl_site
   break by xxpl_part by xxpl_site by xxpl_loc
   with frame b width 160:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      display pt_part pt_desc1 xxpl_site si_desc xxpl_loc loc_desc
              xxpl_type xxpl_rank xxpl_panel xxpl_rank xxpl_cap.

      if last-of(xxpl_part) then do:
         down 1.
      end.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
