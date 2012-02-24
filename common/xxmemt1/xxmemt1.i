/* xxmemt1.i - CONTROL PARAMETER FORMS                                       */

/*V8:ConvertMode=Maintenance                                                  */
define variable del-yn like mfc_logical initial no.
define variable yn     like mfc_logical initial no.
define variable mndnbr as character extent 9 format "x(18)" no-undo.
define variable sel    as integer extent 9 format ">>9" no-undo.
define variable exec   as character extent 9 format "x(22)" no-undo.
define variable sortkey as character extent 9 format "x(4)" no-undo.
define variable dsc    as  character extent 9 format "x(16)" no-undo.

form
   "MENU" colon 1
   "SELECT" colon 18
   "EXEC_PROCEDURE" colon 24
   "QUICK_KEY" colon 46
   "COMMENT" colon 56 skip(1)

   mndnbr[1] colon 1 no-label
   sel[1] colon 22 no-label
   exec[1] colon 28 no-label
   sortkey[1] colon 52 no-label
   dsc[1] colon 58 no-label

   mndnbr[2] colon 1 no-label
   sel[2] colon 22 no-label
   exec[2] colon 28 no-label
   sortkey[2] colon 52 no-label
   dsc[2] colon 58 no-label

   mndnbr[3] colon 1 no-label
   sel[3] colon 22 no-label
   exec[3] colon 28 no-label
   sortkey[3] colon 52 no-label
   dsc[3] colon 58 no-label

   mndnbr[4] colon 1 no-label
   sel[4] colon 22 no-label
   exec[4] colon 28 no-label
   sortkey[4] colon 52 no-label
   dsc[4] colon 58 no-label

   mndnbr[5] colon 1 no-label
   sel[5] colon 22 no-label
   exec[5] colon 28 no-label
   sortkey[5] colon 52 no-label
   dsc[5] colon 58 no-label

   mndnbr[6] colon 1 no-label
   sel[6] colon 22 no-label
   exec[6] colon 28 no-label
   sortkey[6] colon 52 no-label
   dsc[6] colon 58 no-label

   mndnbr[7] colon 1 no-label
   sel[7] colon 22 no-label
   exec[7] colon 28 no-label
   sortkey[7] colon 52 no-label
   dsc[7] colon 58 no-label

   mndnbr[8] colon 1 no-label
   sel[8] colon 22 no-label
   exec[8] colon 28 no-label
   sortkey[8] colon 52 no-label
   dsc[8] colon 58 no-label

   mndnbr[9] colon 1 no-label
   sel[9] colon 22 no-label
   exec[9] colon 28 no-label
   sortkey[9] colon 52 no-label
   dsc[9] colon 58 no-label

   skip(2)

   yn colon 60 skip(.2)
with frame frame-a width 80 side-labels attr-space
/*V8! title color normal (getFrameTitle("LABEL_CONTROL",60)) */ .

/* Set External Labels */
setFrameLabels(frame frame-a:handle).
