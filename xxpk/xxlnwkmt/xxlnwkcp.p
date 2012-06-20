/* xxlnwkcp.p - xxlnwkcp.p Assembline work time copy                         */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:9.lD   QAD:eb2sp4    Interface:Character            */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy                             */
/* REVISION END                                                              */


/* DISPLAY TITLE */
{mfdtitle.i "120620"}

define variable line like ln_line.
define variable line1 like ln_line
define variable l_copy as logical.
/* DISPLAY SELECTION FORM */
form
   Line      colon 20
   line1     colon 20
   l_copy    colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for Line line1 editing:
      /* FIND NEXT/PREVIOUS RECORD */
      
   end.

   if input bc_batch = "" then do:
      {mfmsg.i 40 3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
   find bc_mstr using bc_batch no-error.
   if not available bc_mstr then do:
      {mfmsg.i 1 1}
      create bc_mstr.
      assign bc_batch.
      bc_perm = yes.
      bc_priority = 0.
   end.

   ststatus = stline[2].
   status input ststatus.

   update bc_perm bc_priority go-on(F5 CTRL-D).

   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      find first bcd_det where bcd_batch = bc_batch no-lock no-error.
      if available bcd_det then do:
/*N0GD*  {mfmsg02.i 78 3 msgdel}*/
/*N0GD*/ /* ---CANNOT DELETE. BATCH CONTROL DETAIL RECORDS EXIST"---*/
/*N0GD*/   {pxmsg.i &MSGNUM = 4142
               &ERRORLEVEL = 3}
         next.
      end.
      del-yn = yes.
      {mfmsg01.i 11 1 del-yn}
   end.

   if del-yn then do:
      delete bc_mstr.
      clear frame a.
   end.
   del-yn = no.
end.

status input.
