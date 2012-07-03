/* xxbmld.p - BOM LOAD                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */


/* DISPLAY TITLE */
{mfdtitle.i "12072.1"}
{xxbmld.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
/*   find first usrw_wkfl where                                          */
/*              usrw_key1 = "xxbmld.p_filename" and                      */
/*              usrw_key2 = global_userid no-error.                      */
/*   if available usrw_wkfl then do:                                     */
/*      if usrw_key3 <> "" then do:                                      */
/*         assign flhload =  usrw_key3.                                  */
/*      end.                                                             */
/*   end.                                                                */
   if c-application-mode <> 'web' then
   update flhload cloadfile with frame a.

   {wbrp06.i &command = update &fields = " flhload cloadfile "
      &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
/*     else do:                                                          */
/*          find first usrw_wkfl where                                   */
/*                     usrw_key1 = "xxbmld.p_filename" and               */
/*                     usrw_key2 = global_userid no-error.               */
/*          if available usrw_wkfl then do:                              */
/*                 assign usrw_key3 = flhload.                           */
/*          end.                                                         */
/*          else do:                                                     */
/*              create usrw_wkfl.                                        */
/*              assign usrw_key1 = "xxbmld.p_filename"                   */
/*                     usrw_key2 = global_userid                         */
/*                     usrw_key3 = flhload.                              */
/*          end.                                                         */
/*     end.                                                              */

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
   empty temp-table tmpbom no-error.
   for each tmpbom exclusive-lock: delete tmpbom. end.
   {gprun.i ""xxbmld0.p""}

     if not can-find(first tmpbom) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
          if not can-find(first tmpbom no-lock where tbm_chk <> "")
             and cloadfile then do:
             {gprun.i ""xxbmld1.p""}
          end.
     end.
     for each tmpbom no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display tmpbom.
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
