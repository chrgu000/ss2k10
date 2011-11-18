/* xxfcsimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdtitle.i "111116.1"}

{xxrccim.i "new"}
define variabl i as integer.
form
   skip(1)
   file_name
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
   update file_name with frame a.

   {wbrp06.i &command = update &fields = " file_name "
      &frm = "a"}

     IF SEARCH(FILE_name) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt FILE_name.
         undo, retry.
     END.

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
    {gprun.i ""xxrccim0.p""}

     if not can-find(first xsch_mstr) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
        {gprun.i ""xxrccim1.p""}
     end.


    for each xschd_det no-lock:
    	  display xschd_det with width 320.
    end.

   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
