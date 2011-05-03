/* SS - 090911.1 By: Bill Jiang */

/* SS - 090911.1 - RNB
[090911.1]

更改SCM状态

[090911.1]

SS - 090911.1 - RNE */

{mfdeclre.i}
{gplabel.i}

DEFINE INPUT PARAMETER pod_recno AS RECID.

form
   pod_user1 colon 30
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

   find pod_det
      where recid(pod_det) = pod_recno
      exclusive-lock no-error.

   if not available pod_det
   then
      leave.

   /*
   IF pod_user1 = "" THEN DO:
      pod_user1 = pt_um.
   END.
   */

   ststatus = stline[3].
   status input ststatus.

   display
      pod_user1
   with frame a1.

   setb:
   do on error undo, retry:

      set
         pod_user1
      with frame a1.

      /* SS - 090911.1 - B
      IF pod_user1 <> "" THEN DO:
         FIND FIRST CODE_mstr WHERE CODE_fldname = "pod_user1" AND code_value = pod_user1 NO-LOCK NO-ERROR.
         IF NOT AVAILABLE CODE_mstr THEN DO:
            FIND FIRST CODE_mstr WHERE CODE_fldname = "pod_user1" NO-LOCK NO-ERROR.
            IF AVAILABLE CODE_mstr THEN DO:
               /* 该值必须在通用代码中存在 */
               {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}.
               next-prompt pod_user1 with frame a1.
               undo, retry setb.
            END.
         END.
      END.
      SS - 090911.1 - E */
   end. /* setb */

end. /* END LOOP B */
