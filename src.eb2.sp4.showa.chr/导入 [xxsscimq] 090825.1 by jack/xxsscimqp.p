/* SS - 090428.1 By: Bill Jiang */
/* ss - 090825.1 by: jack */

{mfdeclre.i}
{cxcustom.i "ADCSMTP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

{xxcimimp.i}

define variable directory as character format "x(45)" no-undo.

form
   log_directory     colon 30 label "Log Directory"
   temporary_directory     colon 30 label "Temporary Directory"
   file_prefix     colon 30 label "File Prefix"
   audit_trail     colon 30 label "Audit Trail"
   allow_errors     colon 30 label "Allow Errors"
   delete_options     colon 30 label "Delete Options"
   skip(1)
with frame popup overlay row (frame-row(b2) - 1)
   centered side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame popup:handle).

{gprun.i ""xxcimpwd.p"" "(
   OUTPUT current_DIRECTORY
   )"}
{xxcimcode.i ""CIM_Log_Directory"" log_DIRECTORY CURRENT_directory}
{xxcimcode.i ""CIM_Temporary_Directory"" temporary_DIRECTORY CURRENT_directory}
{xxcimcode.i ""CIM_File_Prefix"" FILE_prefix ""TMPCIM""}
{xxcimcode.i ""CIM_Audit_Trail"" audit_trail ""E""}
{xxcimcode.i ""CIM_Allow_Errors"" allow_errors ""N""}
{xxcimcode.i ""CIM_Delete_Options"" delete_options ""A""}

loopb:
{&ADCSMTP-P-TAG2}
do on endkey undo, leave:
{&ADCSMTP-P-TAG3}

   ststatus = stline[3].
   status input ststatus.

   DISPLAY
      log_directory
      temporary_directory
      file_prefix
      audit_trail
      allow_errors
      delete_options
      WITH FRAME popup.

   setb:
   do on error undo, retry:

      /*
      hide frame popup.
      */

      set
         log_directory
         temporary_directory
         file_prefix
         audit_trail
         allow_errors
         delete_options
      with frame popup.

      /* DETERMINE INPUT DIRECTORY AND FILENAME */
      {gpdirpre.i}

      if log_directory <> "" and
         substring(log_directory,length(log_directory),1) = dir_prefix THEN DO:
         log_DIRECTORY = substring(log_directory,1,length(log_directory) - 1).
         DISPLAY log_DIRECTORY WITH FRAME popup.
      END.
      if temporary_directory <> "" and
         substring(temporary_directory,length(temporary_directory),1) = dir_prefix THEN DO:
         temporary_DIRECTORY = substring(temporary_directory,1,length(temporary_directory) - 1).
         DISPLAY temporary_DIRECTORY WITH FRAME popup.
      END.

      /*
      FIND FIRST loc_mstr 
         WHERE loc_domain = GLOBAL_domain 
      AND loc_site = ap_site
      AND loc_loc = ap_user1 
      NO-LOCK NO-ERROR.
      IF NOT AVAILABLE loc_mstr THEN DO:
         /* Location does not exist */
         {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}.
         next-prompt ap_user1 with frame popup.
         undo, retry setb.
      END.
      */
   end. /* setb */

   {&ADCSMTP-P-TAG5}
end. /* END LOOP B */

HIDE FRAME popup NO-PAUSE.
