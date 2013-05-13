/* xxpild.p - xxppctmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "130116.1"}
{xxpild.i "new"}
{gpcdget.i "UT"}
define variable vusrwkey1 as character initial "xxcimload_filename_default_value".
form
   skip(1)
   flhload colon 14  view-as fill-in size 40 by 1 skip(1)
   cloadfile colon 14 skip(2)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
assign flhload = os-getenv("HOME").
find first qad_wkfl where qad_domain = global_domain and
           qad_key1 = vusrwkey1 and
           qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   if qad_key4 <> "" then do:
      assign flhload =  qad_key4.
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
   find first qad_wkfl where qad_domain = global_domain and
              qad_key1 = vusrwkey1 and
              qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
         assign qad_key4 = flhload.
   end.
   else do:
       create qad_wkfl. qad_domain = global_domain.
       assign qad_key1 = vusrwkey1
              qad_key2 = global_userid
              qad_key4 = flhload.
   end.
   empty temp-table xxtmppi no-error.
   for each xxtmppi exclusive-lock: delete xxtmppi. end.
   {gprun.i ""xxpild0.p""}

     if not can-find(first xxtmppi) then do:
          {mfmsg.i 1310 1}
     end.
     else do:
            if cloadfile then do:
               {gprun.i ""xxpild1.p""}
            end.
     end.
     for each xxtmppi exclusive-lock with width 320 frame c:
      /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display xxtmppi.
     end.
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}

/*
OUTPUT TO pc.txt.
FOR EACH pc_mstr NO-LOCK WHERE pc_domain = "dcec":
    EXPORT DELIMITER "," pc_list pc_curr pc_part pc_start pc_expir pc_um pc_amt[1].
END.
*/

