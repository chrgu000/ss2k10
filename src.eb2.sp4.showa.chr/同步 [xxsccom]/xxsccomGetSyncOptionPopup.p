/* SS - 090908.1 By: Bill Jiang */

/* SS - 090908.1 - RNB
[090908.1]

是否同步

[090908.1]

SS - 090908.1 - RNE */

{mfdeclre.i}
{gplabel.i}

DEFINE INPUT-OUTPUT PARAMETER sync AS LOGICAL.

form
   sync colon 30
   with frame a1 
   /*
   title color normal (getFrameTitle("GT_DATA",20)) 
   */
   row 8 centered overlay side-labels
   WIDTH 60
   /*
   attr-space
   */
   .

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

loopb:
do on endkey undo, leave:

   /*
   find pt_mstr
      where recid(pt_mstr) = pt_recno
      exclusive-lock no-error.

   if not available pt_mstr
   then
      leave.

   IF sync = "" THEN DO:
      sync = pt_um.
   END.
   */

   ststatus = stline[3].
   status input ststatus.

   display
      sync
   with frame a1.

   setb:
   do on error undo, retry:

      set
         sync
      with frame a1.

      /* SS - 090908.1 - B
      IF sync <> "" THEN DO:
         FIND FIRST CODE_mstr WHERE CODE_fldname = "sync" AND code_value = sync NO-LOCK NO-ERROR.
         IF NOT AVAILABLE CODE_mstr THEN DO:
            FIND FIRST CODE_mstr WHERE CODE_fldname = "sync" NO-LOCK NO-ERROR.
            IF AVAILABLE CODE_mstr THEN DO:
               /* 该值必须在通用代码中存在 */
               {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}.
               next-prompt sync with frame a1.
               undo, retry setb.
            END.
         END.
      END.
      SS - 090908.1 - E */
   end. /* setb */

end. /* END LOOP B */
