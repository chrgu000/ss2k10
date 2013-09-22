/* mgcodemt.p - GENERAL PURPOSE CODES FILE MAINT                              */
/*V8:ConvertMode=Maintenance                                                  */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "130906.1"}

define variable del-yn like mfc_logical initial no.

define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   xpgt_group colon 25
   xpgt_part  colon 25
   xpgt_start colon 25 skip(1)
   xpgt_end   colon 25
   xpgt_desc  colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   if input xpgt_group <> "" and input xpgt_part <> "" then
      find xpgt_det where xpgt_det.xpgt_domain = global_domain and
      xpgt_group = input xpgt_group and xpgt_part = input xpgt_part
   no-lock no-error.
   if available xpgt_det then
      recno = recid(xpgt_det).

   prompt-for xpgt_group
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i xpgt_det xpgt_group_part " xpgt_det.xpgt_domain = global_domain "
             xpgt_group "input xpgt_group"}

      if recno <> ? then
         display  xpgt_group
                  xpgt_part
                  xpgt_start
                  xpgt_end
                  xpgt_desc.

   end. /* editing: */
   if input xpgt_group = "" then do:
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
      next-prompt xpgt_group.
      undo,retry.
   end.
   find first xpg_mstr no-lock where xpg_domain = global_domain and
              xpg_group = input xpgt_group no-error.
   if not available xpg_mstr then do:
      {pxmsg.i &MSGNUM=6080 &ERRORLEVEL=3}
      next-prompt xpgt_group.
      undo,retry.
   end.

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         xpgt_part xpgt_start
         batchdelete no-label when (batchrun)
      editing:
         if frame-field = "xpgt_part" then do:
         {mfnp05.i xpgt_det xpgt_group_part
            " xpgt_det.xpgt_domain = global_domain and xpgt_group  = input
            xpgt_group" xpgt_part
            "input xpgt_part"}
         end.
         else do:
            readkey.
            apply lastkey.
         end.
         if recno <> ? then
            display xpgt_group xpgt_part xpgt_start xpgt_end xpgt_desc.

      end. /* editing: */
      find first pt_mstr no-lock where pt_domain = global_domain
             and pt_part = input xpgt_part no-error.
      if not available pt_mstr then do:
          {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
          next-prompt xpgt_part.
          undo,retry.
      end.
   end. /* do on error undo, retry: */

   /* ADD/MOD/DELETE  */

   find first xpgt_det where xpgt_det.xpgt_domain = global_domain and
        xpgt_group = input xpgt_group and xpgt_part = input xpgt_part and
        xpgt_start = input xpgt_start no-error.

   if not available xpgt_det then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create xpgt_det. xpgt_det.xpgt_domain = global_domain.
      assign
         xpgt_group xpgt_part xpgt_start.
   end. /* if not available xpgt_det then do: */

   ststatus = stline[2].
   status input ststatus.

   update xpgt_end xpgt_desc
   go-on(F5 CTRL-D).

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      or input batchdelete = "x"
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete xpgt_det.
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */

end. /* prompt-for xpgt_group */

status input.
