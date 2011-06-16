/* SS - 090829.1 By: Neil Gao */

{mfdtitle.i "090829.1"}

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 8 no-undo.
define variable fieldname like code_fldname no-undo.
define variable batchdelete as character format "x(1)" no-undo.


/* DISPLAY SELECTION FORM */
form
   code_fldname   colon 25
   code_value     colon 25 format "x(30)" skip(1)
   code_cmmt      colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

fieldname = "po_user1.update.allow".
disp fieldname @ code_fldname with frame a.

mainloop:
repeat with frame a:

   batchdelete = "".


   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         code_value
         batchdelete no-label when (batchrun)
      editing:

         {mfnp05.i code_mstr code_fldval
            "code_fldname = input code_fldname" code_value
            "input code_value"}

         if recno <> ? then
            display code_fldname code_value code_cmmt.

      end. /* editing: */

      if length(input code_value) > fieldlen then do:

         /* Length of code value cannot be longer than definition */
         {pxmsg.i &MSGNUM=480 &ERRORLEVEL=4}
         /* MAX ALLOWABLE CHARACTERS */
         {pxmsg.i &MSGNUM=768 &ERRORLEVEL=1 &MSGARG1=fieldlen}

         /* IN BATCHRUN SKIP RECORDS, IF LENGTH OF VALUE IS     */
         /* GREATER THAN FIELD WIDTH                            */
         if batchrun then do:
            import ^.
            next mainloop.
         end. /* if batchrun then do: */
         else
            next-prompt code_value with frame a.
         undo, retry.

      end. /* if length(input code_value) > fieldlen then do: */

   end. /* do on error undo, retry: */

   /* ADD/MOD/DELETE  */

   find code_mstr where code_fldname = input code_fldname
                    and code_value = input code_value
   no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr.
      assign
         code_fldname code_value.
   end. /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   update
      code_cmmt
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
         delete code_mstr.
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */

end. /* mainloop */

