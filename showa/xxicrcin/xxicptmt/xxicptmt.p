/* xxicptmt.p - pt__dec02 (material MAXIMUM Loc) MAINTENANCE                 */
/* revision: 110715.1    created on: 20110715   by: zhang yun                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110715.1"}

define variable del-yn like mfc_logical initial no.
/* DISPLAY SELECTION FORM */

form
   pt_part    colon 18 space(0)
   pt_desc1   colon 52
   pt_um      colon 18
   pt_desc2   at 54 no-label
   skip(2)
   pt__dec02 colon 18
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for pt_part editing:
      /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
         if recno <> ? then do:
            display pt_part
                    pt_desc1
                    pt_um
                    pt_desc2
                    pt__dec02
                    with frame a.
         end.
   end.

   if input pt_part = "" then do:
      {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
  find pt_mstr where pt_part = input pt_part exclusive-lock no-error.
   if not available pt_mstr then do:
      {pxmsg.i &MSGNUM=8601 &ERRORLEVEL=3}
      undo , retry.
   end.
   ststatus = stline[2].
   status input ststatus.

   update pt__dec02 go-on(F5 CTRL-D).

   /* disble DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      del-yn = no.
      {pxmsg.i &MSGNUM=1021 &ERRORLEVEL=3}
   end.
end.

status input.
