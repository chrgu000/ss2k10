/* xxfcsimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdtitle.i "111117.1"}

{xxsoimp.i "new"}
define variabl i as integer.
form
   skip(1)
   file_name
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   find first code_mstr where code_domain = global_domain and 
              code_fldname = "xxsoimp.p_filename" and 
              code_value = global_userid no-error.
   if available code_mstr then do:
      if code_cmmt <> "" then do:
         assign file_name =  code_cmmt.
      end.
   end. 
   if c-application-mode <> 'web' then
   update file_name with frame a.

   {wbrp06.i &command = update &fields = " file_name "
      &frm = "a"}

     IF SEARCH(FILE_name) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt FILE_name.
         undo, retry.
     END.
     else do:
          find first code_mstr where code_domain = global_domain and 
                      code_fldname = "xxsoimp.p_filename" and 
                      code_value = global_userid no-error.
          if available code_mstr then do:
                 assign code_cmmt = file_name.
          end.          
          else do:
              create code_mstr. 
              assign code_domain = global_domain
                     code_fldname = "xxsoimp.p_filename"
                     code_value = global_userid
                     code_cmmt = file_name.
          end.
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
   {gprun.i ""xxsoimp0.p""}

     if not can-find(first tmp-so) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
       	 if not can-find(first tmp-so no-lock where tsod_chk <> "") then do:
   			     {gprun.i ""xxsoimp1.p""}
         end.
     end.
    
     for each tmp-so no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

         display tmp-so.

     end.

   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
