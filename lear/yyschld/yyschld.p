/* xxschld.p - customer schedule import from csv                             */
/*V8:ConvertMode=Report                                                      */

/* DISPLAY TITLE */
{mfdtitle.i "902"}
{gplabel.i}
{yyschld.i "new"}
define variabl i as integer.

form
   skip(.1)
   flhload colon 14 view-as fill-in size 50 by 1
   cate colon 14 /* "(1.Customer Plan 2.Customer Ship 3.Required Ship)" */
   inc_sum colon 14
   effdate colon 14 skip(1)
   cloadfile colon 14 skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
/* assign tit = getTermlabel("SUPPLIER_SCHEDULES_IMPORT",28).   */
/* display tit with frame a.                                    */
{wbrp01.i}
find first qad_wkfl no-lock where qad_domain = global_domain
       and qad_key1 = global_userid and qad_key2 = execname no-error.
if available qad_wkfl then do:
   assign flhload = qad_charfld[1]
          cate = qad_intfld[1]
          inc_sum = qad_logfld[1].
end.
effdate = today - 1.
repeat:
   if c-application-mode <> 'web' then
   update flhload cate inc_sum effdate cloadfile with frame a.

   {wbrp06.i &command = update &fields = " flhload cate inc_sum effdate cloadfile"
             &frm = "a"}

   IF SEARCH(flhload) = ? THEN DO:
       {mfmsg.i 4839 3}
       next-prompt flhload.
       undo, retry.
   END.
   IF cate < 1 OR cate > 3 then do:
      {mfmsg.i 6427 3}
       next-prompt cate with frame a.
       undo, retry.
   end.
   find first qad_wkfl where qad_domain = global_domain
         and qad_key1 = global_userid
         and qad_key2 = execname  exclusive-lock no-error.
   if available qad_wkfl then do:
      assign qad_charfld[1] = flhload
                   qad_intfld[1] = cate
                   qad_logfld[1] = inc_sum.
   end.
   else do:
      create qad_wkfl. qad_domain = global_domain.
      assign qad_key1 = global_userid
             qad_key2 = execname
             qad_charfld[1] = flhload
             qad_intfld[1] = cate
             qad_logfld[1] = inc_sum.
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
    {gprun.i ""yyschld0.p""}

     if not can-find(first xsch_data) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
         {gprun.i ""yyschld1.p""}
     end.

     for each xsch_data no-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display xsd_sn xsd_data format "x(260)" xsd_chk format "x(20)".
     end.

   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
