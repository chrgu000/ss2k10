/* xxmndld.p - mgpwmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "813"}
{xxmndld.i "new"}
define variable filename as character format "x(60)".
define variable vchk as logical.
define stream history.
form
   "文件格式为以逗号隔开的文本文件"  colon 2
   "栏位顺序:" colon 2
   '菜单,"用户1,用户2,用户3"' colon 2
   "注意:用户列表用双引号引起来" colon 2 skip(2)
   flhload colon 14 view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)

   filename colon 14
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = os-getenv("HOME").
assign filename = "mnd"
            + substring(string(year(today),"9999"),3,2)
            + string(month(today),"99")
            + string(day(today),"99")
            + string(time,"999999")
            + ".hst".
display filename with frame a.


{pxmsg.i &MSGNUM=51 &ERRORLEVEL=1}
         /* Note: archive files should be backed up
            and deleted from disk */

         if search(filename) <> ?
         then do:
            {pxmsg.i
               &MSGNUM=52
               &ERRORLEVEL=2
               &MSGARG1=filename
               &MSGARG2=""""
               &MSGARG3=""""
            }
          end.

find first qad_wkfl where
           qad_key1 = execname and
           qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   if qad_key3 <> "" then do:
      assign flhload =  qad_key3.
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
              qad_key1 = execname and
              qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
          assign qad_key3 = flhload.
   end.
   else do:
       create qad_wkfl.
       assign qad_key1 = execname
              qad_key2 = global_userid
              qad_key3 = flhload.
   end.
   empty temp-table xxtmp no-error.
   for each xxtmp exclusive-lock: delete xxtmp. end.
   {gprun.i ""xxmndld0.p""}

    /*  if not can-find(first xxtmp) then do:                               */
    /*       {mfmsg.i 1310 1}                                               */
    /*  end.                                                                */
    /*  else do:                                                            */
    /*       output stream history to value(filename).                      */
    /*       export stream history "mnd_det".                               */
    /*       for each mnd_det no-lock:                                      */
    /*           export stream history mnd_det.                             */
    /*       end.                                                           */
    /*       output stream history close.                                   */
    /*       assign vchk = yes.                                             */
    /*       if not can-find(first xxtmp where xxt_chk <> "") then do:      */
    /*          assign vchk = no.                                           */
    /*          {gprun.i ""xxmndld1.p""}                                    */
    /*       end.                                                           */
    /*  end.                                                                */
     if not can-find(first xxtmp) then do:
          {mfmsg.i 1310 1}
     end.
     else do:
          if can-find (first xxtmp no-lock where xxt_chk <> "") then do:
             for each xxtmp no-lock where xxt_chk <> "" with width 320 frame b:
                 setFrameLabels(frame b:handle).
                 display xxt_nbr xxt_select xxt_run xxt_chk format "x(80)".
                 {mfrpchk.i}
             end.
          end.
          else do:
              if cloadfile then do:
                  output stream history to value(filename).
                  export stream history "mnd_det".
                  for each mnd_det no-lock:
                      export stream history mnd_det.
                  end.
                  output stream history close.
                  {gprun.i ""xxmndld1.p""}
              end.
              for each xxdta no-lock  with width 320 frame x:
                  display xxd_nbr xxd_select xxd_run format "x(80)" xxd_old xxd_chk.
                  {mfrpchk.i}
              end.
          end.
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
