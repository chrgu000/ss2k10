/* xxschimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdtitle.i "111111.1"}
{gplabel.i}
{xxschimp.i "new"}
define variabl i as integer.
define variable tit  as character format "x(36)".

form
   skip(1)
   tit colon 14 no-label skip(1)
   file_name colon 20
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign tit = getTermlabel("SUPPLIER_SCHEDULES_IMPORT",28).
display tit with frame a.
{wbrp01.i}
find first qad_wkfl no-lock where qad_domain = global_domain
		   and qad_key1 = "xxschimp-filename" and qad_key2 = global_userid no-error.
if available qad_wkfl then do:
	 assign file_name = qad_charfld[1].
end.		   
repeat:
   if c-application-mode <> 'web' then
   update file_name with frame a.

   {wbrp06.i &command = update &fields = " file_name "
      &frm = "a"}

     IF SEARCH(FILE_name) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt file_name.
         undo, retry.
     END.
	 find first qad_wkfl where qad_domain = global_domain
	 		   and qad_key1 = "xxschimp-filename" 
	 		   and qad_key2 = global_userid no-error.
	 if available qad_wkfl then do:
	    if not locked(qad_wkfl) and qad_charfld[1] <> input file_name	then do:
	 			   assign qad_charfld[1] = file_name.
	 		end.
	 end.	
	 else do:
	 		create qad_wkfl. qad_domain = global_domain.
	 		assign qad_key1 = "xxschimp-filename" 
	 					 qad_key2 = global_userid
	 					 qad_charfld[1] = file_name.
	 end.
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
    {gprun.i ""xxschimp0.p""}

     if not can-find(first xsch_data) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
         {gprun.i ""xxschimp1.p""}
     end.

     for each xsch_data no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display xsch_data.
     end.

   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
