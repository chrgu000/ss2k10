/* SS - 090906.1 By: Bill Jiang */

/* SS - 090906.1 - RNB
[090906.1]

包含以下字段:
  - SoftspeedSCM_Request_Prefix: 请求文件前缀

[090906.1]

SS - 090906.1 - RNE */

{mfdtitle.i "090906.1"}

define variable SoftspeedSCM_Request_Prefix like mfc_char.

/* DISPLAY SELECTION FORM */
form
   SoftspeedSCM_Request_Prefix          colon 38
with frame appm-a width 80 side-labels attr-space
/*V8! title color normal (getFrameTitle("ACCOUNTS_PAYABLE_CONTROL",41)) */.

/* SET EXTERNAL LABELS */
setFrameLabels(frame appm-a:handle).

/* DISPLAY */
ststatus = stline[3].
status input ststatus.
view frame appm-a.

repeat with frame appm-a:

   /* ADD MFC_CTRL FIELD SoftspeedSCM_Request_Prefix */
   for first mfc_ctrl where mfc_field = "SoftspeedSCM_Request_Prefix"
   exclusive-lock: end.

   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_field   = "SoftspeedSCM_Request_Prefix"
         mfc_type    = "C"
         mfc_module  = execname
         mfc_seq     = 10
         mfc_char = "TMP.SoftspeedSCM"
         .

   end.

   assign
      SoftspeedSCM_Request_Prefix = mfc_char.

   display
      SoftspeedSCM_Request_Prefix
   with frame appm-a.

   seta:
   do on error undo, retry:

      set
         SoftspeedSCM_Request_Prefix
      with frame appm-a.
      {&APPM-P-TAG3}

      /*
      if SoftspeedSCM_Request_Prefix = "" then do:
         /* Blank not allowed */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         next-prompt SoftspeedSCM_Request_Prefix.
         undo seta, retry.
      end.

      FIND FIRST vd_mstr
         WHERE vd_addr = SoftspeedSCM_Request_Prefix
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE vd_mstr THEN DO:
         /* Not a valid supplier */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
         next-prompt SoftspeedSCM_Request_Prefix.
         undo seta, retry.
      END.
      */
   end.

   find first mfc_ctrl where mfc_field = "SoftspeedSCM_Request_Prefix" no-error.
   if available mfc_ctrl then mfc_char = SoftspeedSCM_Request_Prefix.
end.

status input.
