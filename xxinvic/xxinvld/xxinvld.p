/* xxinvld.p - 日供发票导入，可以提示错误                                    */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */


/* DISPLAY TITLE */
{mfdtitle.i "120525.1"}
{xxinvld.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   find first code_mstr where
              code_fldname = "xxinvld.p_filename" and
              code_value = global_userid no-error.
   if available code_mstr then do:
      if code_cmmt <> "" then do:
         assign flhload =  code_cmmt.
      end.
   end.
   if c-application-mode <> 'web' then
   update flhload with frame a.

   {wbrp06.i &command = update &fields = " flhload "
      &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
     else do:
          find first code_mstr where
                      code_fldname = "xxinvld.p_filename" and
                      code_value = global_userid no-error.
          if available code_mstr then do:
                 assign code_cmmt = flhload.
          end.
          else do:
              create code_mstr.
              assign code_fldname = "xxinvld.p_filename"
                     code_value = global_userid
                     code_cmmt = flhload.
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
   {gpselout.i &printType = "printer1"
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
   empty temp-table tmpinv no-error.
   for each tmpinv exclusive-lock: delete tmpinv. end.
   {gprun.i ""xxinvld0.p""}

     if not can-find(first tmpinv) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
         if not can-find(first tmpinv no-lock where tiv_chk <> "") then do:
            {gprun.i ""xxinvld1.p""}
         end.
     end.

     for each tmpinv no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display tmpinv.
     end.

   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
