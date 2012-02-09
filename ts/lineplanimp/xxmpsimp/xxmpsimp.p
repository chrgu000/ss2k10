/*Gui */
/*V8:ConvertMode=Report                                                       */
/*SS - 111220.1 BY EKN*/
/*
{mfdtitle.i "111031.1"}
*/

{mfdtitle.i "120209.1"}

{xxmpsimp.i "new"}
FORM /*GUI*/
    SKIP(1)
    FILE_name COLON 14 skip(1)
with frame a side-labels width 80 ATTR-SPACE NO-BOX.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}

find first qad_wkfl no-lock where qad_domain = global_domain
       and qad_key1 = "xxmpsimp.p" and qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   assign file_name = qad_charfld[1].
end.

repeat on error undo, retry:
       if c-application-mode <> 'web' then
          update FILE_name with frame a
       editing:
           status input.
           readkey.
           apply lastkey.
       end.
       {wbrp06.i &command = update &fields = "file_name"
          &frm = "a"}

       IF SEARCH(FILE_name) = ? THEN DO:
           {mfmsg.i 53 3}
           next-prompt FILE_name.
           undo, retry.
       END.

   find first qad_wkfl where qad_domain = global_domain
         and qad_key1 = "xxmpsimp.p"
         and qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
      if not locked(qad_wkfl) and qad_charfld[1] <> input file_name then do:
           assign qad_charfld[1] = file_name.
      end.
   end.
   else do:
      create qad_wkfl. qad_domain = global_domain.
      assign qad_key1 = "xxmpsimp.p"
             qad_key2 = global_userid
             qad_charfld[1] = file_name.
   end.

    MESSAGE "正在处理请等待......".

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "window"
               &printWidth = 300
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


    {mfphead.i}

    {gprun.i ""xxmpsimp01.p""}

     IF v_flag = "1" THEN DO:
        PUT "无数据,请重新输入".
     END.

     IF v_flag = "2" THEN DO:
         FOR EACH xxmps WHERE xxmps_error <> "" NO-LOCK:
             DISP xxmps WITH WIDTH 200.
         END.
     END.

     IF v_flag = "3" THEN DO:
         FOR EACH xxmps:
             DISP xxmps WITH WIDTH 200.
         END.
     END.


     {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
