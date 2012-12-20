/* xxbmrld.p - BOM replease LOAD                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120807.1 LAST MODIFIED: 08/07/12 BY:                            */
/* REVISION END                                                              */


/* DISPLAY TITLE */
{mfdtitle.i "121203.1"}
{xxbmld.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = OS-GETENV("HOME").
display flhload with frame a.
{wbrp01.i}
repeat:
/*   find first usrw_wkfl no-lock where                                  */
/*              usrw_key1 = "xxbmld.p_filename" and                      */
/*              usrw_key2 = global_userid no-error.                      */
/*   if available usrw_wkfl then do:                                     */
/*      if usrw_key4 <> "" then do:                                      */
/*         assign flhload =  usrw_key4.                                  */
/*      end.                                                             */
/*   end.                                                                */
/*   release usrw_wkfl.                                                  */
   if c-application-mode <> 'web' then
   update flhload cloadfile with frame a.

   {wbrp06.i &command = update &fields = " flhload cloadfile "
      &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
/*   else do:                                                               */
/*        find first usrw_wkfl exclusive-lock where                         */
/*                   usrw_key1 = "xxbmld.p_filename" and                    */
/*                   usrw_key2 = global_userid no-error.                    */
/*        if available usrw_wkfl and locked(usrw_wkfl) then do:             */
/*              assign usrw_key4 = flhload no-error.                        */
/*        end.                                                              */
/*        else do:                                                          */
/*            create usrw_wkfl.                                             */
/*            assign usrw_key1 = "xxbmld.p_filename"                        */
/*                   usrw_key2 = global_userid                              */
/*                   usrw_key4 = flhload no-error.                          */
/*        end.                                                              */
/*        release usrw_wkfl.                                                */
/*   end.                                                                   */

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
   {gprun.i ""xxbmsld0.p""}

     if not can-find(first tmpbom) then do:
          {mfmsg.i 1310 1}
     end.
     else do:
          {gprun.i ""xxbmld1.p""}
     end.
     for each tmpbom no-lock with width 320 frame x:
            display tbm_par tbm_old tbm_new.
     end.
     for each tmpbomn no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display tmpbomn.
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
