/* SS - 090911.1 By: Bill Jiang */

/* SS - 090911.1 - RNB
[090911.1]

更改SCM状态

[090911.1]

SS - 090911.1 - RNE */

{mfdeclre.i}
{gplabel.i}

DEFINE input-output PARAMETER scmtbcont AS logical.

form
   scmtbcont colon 30 label "确认"
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


   display
      scmtbcont
   with frame a1.

   setb:
   do on error undo, retry:

      set
         scmtbcont
      with frame a1.
   end. /* setb */

end. /* END LOOP B */
