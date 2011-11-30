/* xxmsgmt.p - MESSAGE MAINTENANCE                                           */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* DISPLAY TITLE */
{mfdtitle.i "09Y1"}

define variable del-yn like mfc_logical initial no no-undo.
define variable msg_recno as recid no-undo.

/* DISPLAY SELECTION FORM */
form
   lng_lang       colon 16
   lng_desc       no-label
   skip(1)
   msg_nbr        colon 16   format ">>>>>>9"
   skip(1)
   space(1)
   msg_desc
/*V8!view-as fill-in size 60 by 1 */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

display
   global_user_lang @ lng_lang
with frame a.

mainloop:
repeat with frame a:

   prompt-for lng_lang editing:
      {mfnp05.i lng_mstr lng_lang yes lng_lang "input lng_lang"}
      if recno <> ? then display lng_lang lng_desc.
   end.

   find lng_mstr using lng_lang no-lock no-error.
   if available lng_mstr then
      display lng_desc.
   else
      display "" @ lng_desc.

   prompt-for msg_nbr editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i msg_mstr msg_ln "msg_lang = input lng_lang"
      msg_nbr "input msg_nbr"}
      if recno <> ? then display msg_nbr msg_desc.
   end.

   /* ADD/MOD/DELETE  */
   find msg_mstr exclusive-lock using msg_nbr
   where msg_lang = input lng_lang no-error.
   if not available msg_mstr then do:
      create msg_mstr.
      assign
         msg_lang = input lng_lang
         msg_nbr = input msg_nbr.
   end.

   display msg_nbr msg_desc.
   msg_recno = recid(msg_mstr).

   ststatus = stline[2].
   status input ststatus.

   update msg_desc go-on(F5 CTRL-D).

   /* DELETE */
   if lastkey = keycode("F5")
   or lastkey = keycode("CTRL-D")
   then do:
      del-yn = yes.
      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
      if del-yn then do:
         find msg_mstr exclusive-lock where recid(msg_mstr) = msg_recno.
         delete msg_mstr.
         clear frame a.
      end.
   end.
end.
status input.
