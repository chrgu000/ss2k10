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
assign flhload = OS-GETENV("HOME").
find first usrw_wkfl no-lock where
           usrw_key1 = global_userid and usrw_key2 = execname no-error.
if available usrw_wkfl then do:
   assign flhload = usrw_key3.
end.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}
display flhload with frame a.
repeat on error undo, retry:
       if c-application-mode <> 'web' then
          update flhload cloadfile with frame a
       editing:
           status input.
           readkey.
           apply lastkey.
       end.
       {wbrp06.i &command = update &fields = "flhload cloadfile " &frm = "a"}

     IF SEARCH(flhload) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt flhload.
         undo, retry.
     END.
     do transaction:
        find first usrw_wkfl exclusive-lock where
                   usrw_key1 = global_userid and usrw_key2 = execname no-error.
        if not available usrw_wkfl then do:
           create usrw_wkfl.
           assign usrw_key1 = global_userid
                  usrw_key2 = execname.
        end.
        assign  usrw_key3 = flhload.
        release usrw_wkfl.
     end.
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
    assign v_flag = "0".
     FIND FIRST xxpod_det  NO-ERROR.
     IF NOT AVAIL xxpod_det THEN DO:
        v_flag = "1".
     END.
     IF v_flag = "1" THEN DO:
        {pxmsg.i &MSGNUM=2482
                 &ERRORLEVEL=3
                 &MSGARG1=""flhload""}
     END.
     ELSE DO:
          {gprun.i ""xxpodld1.p""}
          for each xxpod_det exclusive-lock :
              find first pod_det no-lock where pod_nbr = xxpod_nbr
                     and pod_line = xxpod_line no-error.
              if available pod_det then do:
                 assign xxpod_due_date = pod_due_date
                        xxpod_stat = pod_status.
              end.
          end.
          for each xxpod_det no-lock with frame x width 130:
              display xxpod_det.
          end.
     END.

     {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
