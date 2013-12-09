/* xxapvold.p - apvomt.p cim load                                             */
/*V8:ConvertMode=Report                                                       */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character           */
/* REVISION: 131115.1 LAST MODIFIED: 11/15/13   BY:Zy                         */
/* REVISION END                                                               */

/* DISPLAY TITLE */
{mfdtitle.i "131125.1"}
{xxapvold.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = os-getenv("HOME").
find first qad_wkfl where
           qad_key1 = "xxapvold.p_control" and
           qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   if qad_key3 <> "" then do:
      assign flhload = qad_key3.
   end.
end.

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
   find first qad_wkfl where
              qad_key1 = "xxapvold.p_control" and
              qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
          assign qad_key3 = flhload.
   end.
   else do:
       create qad_wkfl.
       assign qad_key1 = "xxapvold.p_control"
              qad_key2 = global_userid
              qad_key3 = flhload.
   end.
   empty temp-table xxapvotmp no-error.
   for each xxapvotmp exclusive-lock: delete xxapvotmp. end.
   {gprun.i ""xxapvold0.p""}
     if cloadfile then do:
        if not can-find(first xxapvotmp) then do:
             {mfmsg.i 1310 1}
        end.
        else do:
             {gprun.i ""xxapvold1.p""}
        end.
     end.
     for each xxapvotmp exclusive-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display xxapt_ref
                 xxapt_tot
                 xxapt_vd
                 xxapt_invoice
                 xxapt_taxable
                 xxapt_line
                 xxapt_acct
                 xxapt_amt
                 xxapt_cc
                 xxapt_proj
                 xxapt_cmmt
                .
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}