/* xxvdrctpmt.p - vendor recive type maintenance                             */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "120619.1"}
/* ********** End Translatable Strings Definitions ********* */

/* DISPLAY SELECTION FORM */
form
   vd_addr       colon 20
   vd_sort       colon 20 skip(1)
   vd__chr03     colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   prompt-for vd_addr editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i vd_mstr vd_addr vd_addr vd_addr vd_addr vd_addr}
      if recno <> ? then do:
         display vd_addr vd_sort vd__chr03.
      end.
   end.

   if input vd_addr = "" then do:
      {mfmsg.i 40 3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
   find vd_mstr using vd_addr no-error.
   if not available  vd_mstr then do:
      {mfmsg.i 8405 3}
      undo,retry.
   end.
   else do:
      display vd_addr vd_sort vd__chr03 with frame a.
   end.

   ststatus = stline[2].
   status input ststatus.
   repeat:
      update vd__chr03 with frame a.
      find first code_mstr no-lock where code_fldname = "vd__chr03" and
                 code_value = input vd__chr03 no-error.
      if not available code_mstr then do:
         {pxmsg.i &ERRORLEVEL=3 &MSGTEXT=""到货方式错误""}
         undo,retry.
      end.
      leave.
   end.
end.

status input.
