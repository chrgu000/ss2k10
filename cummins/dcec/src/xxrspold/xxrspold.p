/* xxrspold.p - rspoamt.p 2+  cim_load                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "c2a"}
{xxrspold.i "new"}
{gpcdget.i "UT"}
form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = os-getenv("HOME").
       errload = os-getenv("HOME").
/*   find first usrw_wkfl no-lock where                              */
/*             usrw_domain = global_domain and                       */
/*              usrw_key1 = vusrwkey1 and                            */
/*              usrw_key2 = global_userid no-error.                  */
/*   if available usrw_wkfl then do:                                 */
/*      if usrw_key3 <> "" then do:                                  */
/*         assign flhload =  usrw_key3                               */
/*               errload =  usrw_key4.                               */
/*      end.                                                         */
/*   end.                                                            */
/*   release usrw_wkfl.                                              */
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
               &pagedFlag = " nopage "
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

/*    find first usrw_wkfl exclusive-lock where                          */
/*                usrw_domain = global_domain and                        */
/*               usrw_key1 = vusrwkey1 and                               */
/*               usrw_key2 = global_userid no-error.                     */
/*    if not available usrw_wkfl then do:                                */
/*        create usrw_wkfl. usrw_domain = global_domain.                 */
/*        assign usrw_key1 = vusrwkey1                                   */
/*               usrw_key2 = global_userid.                              */
/*    end.                                                               */
/*    assign usrw_key3 = flhload                                         */
/*            usrw_key4 = errload.                                       */
/*    release usrw_wkfl.                                                 */
   empty temp-table xxtmp no-error.
    {mfphead.i}
   {gprun.i ""xxrspold0.p""}

     if not can-find(first xxtmp) then do:
          {mfmsg.i 1310 1}
     end.
     else do:
            if cloadfile then do:
               display string(time,"HH:MM:SS") label "Start at:".
               {gprun.i ""xxrspold1.p""}
               display string(time,"HH:MM:SS")  label "End at:".
            end.
     end.
     for each xxtmp no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display xxtmp.
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
