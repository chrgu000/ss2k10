/* xxschimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdtitle.i "111124.1"}

{xxschexp.i "new"}
define variable i as integer.

form
  skip(.1)
   vpo     colon 15
   vrlseid    colon 15
   skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if c-application-mode <> 'web' then
   update vpo vrlseid with frame a.

   {wbrp06.i &command = update &fields = " vpo vrlseid "
      &frm = "a"}
 if vpo = "" or vrlseid = "" then do:
 		 {mfmsg.i 40 3}
 		 undo,retry.
 end.
 if not can-find(first sch_mstr no-lock where sch_domain = global_domain
        and sch_nbr = vpo and sch_rlse_id = vrlseid) then do:
     {mfmsg.i 2362 3}    
     undo,retry.
 end.
/*
     IF SEARCH(FILE_name) <> ? THEN DO:
         {mfmsg.i 3122 3}
         next-prompt FILE_name.
         undo, retry.
     END.
*/

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
      hide frame c.
   end.

 
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
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
   {mfmsg.i 832 1}
   {mfphead.i}
/**
    if not can-find(first scx_ref where scx_domain = global_domain
       and scx_po = vpo and scx_line = vline and scx_type = 2) then do:
       undo,retry.
    end.
**/
    {gprun.i ""xxschexp0.p""}
/*
     if not can-find(first xsch_data) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
         {gprun.i ""xxschimp1.p""}
     end.
*/

   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
