/* xxunisld.p - icunrc.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120704.1 LAST MODIFIED: 07/04/12 BY:                            */
/* REVISION END                                                              */


/* DISPLAY TITLE */
{mfdtitle.i "120828.1"}
{xxunrcld.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/*
find first qad_wkfl where
           qad_key1 = "xxunisld.p_filename" and
           qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   if qad_key3 <> "" then do:
      assign flhload =  qad_key3.
   end.
end.
*/
assign flhload = os-getenv("HOME").
display flhload with frame a.

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
   update flhload cloadfile with frame a.

   {wbrp06.i &command = update &fields = " flhload cloadfile "
      &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
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
   /*
   find first qad_wkfl where
              qad_key1 = "xxunisld.p_filename" and
              qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
          assign qad_key3 = flhload.
   end.
   else do:
       create qad_wkfl.
       assign qad_key1 = "xxunisld.p_filename"
              qad_key2 = global_userid
              qad_key3 = flhload.
   end.
   */
   empty temp-table tmpic no-error.
   for each tmpic exclusive-lock: delete tmpic. end.
   {gprun.i ""xxunisld0.p""}

     if not can-find(first tmpic) then do:
          {mfmsg.i 1310 1}
     end.
     else do:
     		  if cloadfile then do:
             {gprun.i ""xxunisld1.p""}
          end.
     end.
     for each tmpic exclusive-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display tmpic.
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
