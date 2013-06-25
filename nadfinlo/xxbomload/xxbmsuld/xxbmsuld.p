/* xxbmld.p - BOM LOAD                                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "120907.1"}
{xxbmpsci.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14 view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = OS-GETENV("HOME").
display flhload with frame a.
{wbrp01.i}
repeat:
   find first usrw_wkfl where
              usrw_key1 = "common_filename" and
              usrw_key2 = global_userid no-lock no-error.
   if available usrw_wkfl then do:
      if usrw_key4 <> "" then do:
         assign flhload =  usrw_key4.
      end.
   end.
   if c-application-mode <> 'web' then
   update flhload cloadfile with frame a.

   {wbrp06.i &command = update &fields = " flhload cloadfile "
      &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
     else do:
          find first usrw_wkfl where
                     usrw_key1 = "common_filename" and
                     usrw_key2 = global_userid no-error.
          if not available usrw_wkfl then do:
              create usrw_wkfl.
              assign usrw_key1 = "common_filename"
                     usrw_key2 = global_userid.
          end.
          assign usrw_key4 = flhload.
     end.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
      hide frame c.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "PAGE"
               &printWidth = 320
               &pagedFlag = " NOPAGE "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "no"
               &pageBottomMargin = 6
               &withEmail = "no"
               &withWinprint = "no"
               &defineVariables = "yes"}
   {mfmsg.i 832 1}
   {mfphead.i}
   empty temp-table tmpd_det no-error.
   empty temp-table xps_wkfl no-error.
   for each tmpd_det exclusive-lock: delete tmpd_det. end.
   for each xps_wkfl exclusive-lock: delete xps_wkfl. end.
   {gprun.i ""xxbmsuld0.p""}

     if not can-find(first tmpd_det) then do:
          {mfmsg.i 1310 1}
     end.
     else do:
              {gprun.i ""xxbmpsci.p""}
     end.
     for each tmpd_det no-lock with width 320 frame c:
         setFrameLabels(frame c:handle).
         display tmpd_det.
     end.
     for each xps_wkfl exclusive-lock with width 320 frame d:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame d:handle).
         display xps_par
                 xps_comp
                 xps_ref
                 xps_start
                 xps_qty_per
                 xps_ps_code
                 xps_end
                 xps_rmks
                 xps_scrp_pct
                 xps_lt_off
                 xps_op
                 xps_fcst_pct
                 xps_group
                 xps_process
                 xps_chk
                 .
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}