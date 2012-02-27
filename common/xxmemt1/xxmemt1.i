/* xxmemt1.i - CONTROL PARAMETER FORMS                                       */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C   QAD:eb21sp7    Interface:Character          */
/* REVISION: 21YA LAST MODIFIED: 02/27/12 BY: zy                             */
/* REVISION END                                                              */

define variable del-yn like mfc_logical initial no.
define variable yn     like mfc_logical initial no.
define variable mndnbr like mnd_det.mnd_nbr extent 10 format "x(16)" no-undo.
define variable sel    like mnd_det.mnd_select extent 10 format ">>9" no-undo.
define variable exec   as character extent 10 format "x(22)" no-undo.
define variable sortkey as character extent 10 format "x(4)" no-undo.
define variable dsc    as  character extent 10 format "x(18)" no-undo.
define variable cdref  as character format "x(40)" no-undo.
define variable cLoadFile like itsd_loaded no-undo.

form
   cdref  colon 16 skip(1)

   "MENU" colon 1
   "SELECT" colon 18
   "EXEC_PROCEDURE" colon 24
   "QUICK_KEY" colon 46
   "COMMENT" colon 56 skip

   mndnbr[1] colon 1 no-label
   sel[1] colon 20 no-label
   exec[1] colon 26 no-label
   sortkey[1] colon 50 no-label
   dsc[1] colon 56 no-label

   mndnbr[2] colon 1 no-label
   sel[2] colon 20 no-label
   exec[2] colon 26 no-label
   sortkey[2] colon 50 no-label
   dsc[2] colon 56 no-label

   mndnbr[3] colon 1 no-label
   sel[3] colon 20 no-label
   exec[3] colon 26 no-label
   sortkey[3] colon 50 no-label
   dsc[3] colon 56 no-label

   mndnbr[4] colon 1 no-label
   sel[4] colon 20 no-label
   exec[4] colon 26 no-label
   sortkey[4] colon 50 no-label
   dsc[4] colon 56 no-label

   mndnbr[5] colon 1 no-label
   sel[5] colon 20 no-label
   exec[5] colon 26 no-label
   sortkey[5] colon 50 no-label
   dsc[5] colon 56 no-label

   mndnbr[6] colon 1 no-label
   sel[6] colon 20 no-label
   exec[6] colon 26 no-label
   sortkey[6] colon 50 no-label
   dsc[6] colon 56 no-label

   mndnbr[7] colon 1 no-label
   sel[7] colon 20 no-label
   exec[7] colon 26 no-label
   sortkey[7] colon 50 no-label
   dsc[7] colon 56 no-label

   mndnbr[8] colon 1 no-label
   sel[8] colon 20 no-label
   exec[8] colon 26 no-label
   sortkey[8] colon 50 no-label
   dsc[8] colon 56 no-label

   mndnbr[9] colon 1 no-label
   sel[9] colon 20 no-label
   exec[9] colon 26 no-label
   sortkey[9] colon 50 no-label
   dsc[9] colon 56 no-label

   mndnbr[10] colon 1 no-label
   sel[10] colon 20 no-label
   exec[10] colon 26 no-label
   sortkey[10] colon 50 no-label
   dsc[10] colon 56 no-label

   skip(1)
   cLoadFile colon 26
   skip(2)

   yn colon 60 skip(.2)
with frame frame-a width 80 side-labels attr-space
/*V8! title color normal (getFrameTitle("MENU_MAINTENANCE",60)) */ .
setFrameLabels(frame frame-a:handle).
