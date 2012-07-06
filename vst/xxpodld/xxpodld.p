/* xxpodld.p - popomt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdtitle.i "120706.1"}
{xxpodld.i "new"}
{gpcdget.i "UT"}

form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.
/*
find first usrw_wkfl no-lock where 
           usrw_key1 = "xxpopoim.p" and usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
   assign file_name = usrw_key3.
end.
*/
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}

repeat on error undo, retry:
       if c-application-mode <> 'web' then
          update FILE_name with frame a
       editing:
           status input.
           readkey.
           apply lastkey.
       end.
       {wbrp06.i &command = update &fields = "file_name" &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
    

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "window"
               &printWidth = 80
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

    {gprun.i ""xxpodld0.p""}

     IF v_flag = "1" THEN DO:
        PUT "无数据,请重新输入".
     END.

     IF v_flag = "2" THEN DO:
         FOR EACH xxpod_det WHERE xxpod_error <> "" NO-LOCK:
             DISP xxpod_det WITH WIDTH 200.
         END.
     END.

     IF v_flag = "3" THEN DO:
         FOR EACH xxpod_det  NO-LOCK:
             DISP xxpod_det WITH WIDTH 200.
         END.
     END.


     {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
