 /* xxpkdmins.p - package d type item lead minutes maintenance                */
 /*V8:ConvertMode=Maintenance                                                 */
 /* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
 /* REVISION: 24YP LAST MODIFIED: 06/21/12 BY: zy                             */
 /* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "110621.1"}

define variable del-yn   like mfc_logical initial no.
/* SS - 090910.1 - B */

define variable fldname  like code_fldname initial "PACK-ITEM-LEAD-MINS".
define variable codevalue like code_value initial "DEFAULT-MINUTS".
define variable i as integer.
/* SS - 090910.1 - E */

/* DISPLAY SELECTION FORM */
form
   code_fldname label "KEY" colon 25
   code_value label "VENDOR" colon 25 format "x(32)"
   skip(1)
   code_cmmt                 colon 25
with frame a side-labels width 80  attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

  /* SS - 090910.1 - B */
   /* gp973.p支持 */
  GLOBAL_addr = fldname.
   /* SS - 090910.1 - E */

   /* ADD/MOD/DELETE  */
   find code_mstr where code_fldname = fldname and code_value = codevalue
   exclusive-lock no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr.
      assign code_fldname = fldname
             code_value = codevalue.
   end.

   display code_fldname code_value code_cmmt.

   ststatus  =  stline[2].
   status input ststatus.
   del-yn = no.

   seta:
   do on error undo, retry:

      set code_cmmt go-on (F5 CTRL-D).
      DO i = 1 to length(input code_cmmt).
         If index("0987654321", substring(input code_cmmt,i,1)) = 0 then do:
            {mfmsg.i 69 3}
            undo, retry.
         end.
      end.
      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:

         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then undo, retry.

         /* SS - 090910.1 - B */
         /*
         /* VERIFY THAT NONE OF THE FOLLOWING EXISTS */
         /* TAX ENVIRONMENT DETAIL */
         find first txed_det  where
         txed_tax_type = code_value no-error.
         if available(txed_det) then do:
            /* Tax type exists in tax environment.  Cannot delete */
            {pxmsg.i &MSGNUM=895 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.

         /* TAX BASE MASTER */
         find first txbd_det  where
         txbd_tax_type = code_value no-error.
         if available(txbd_det) then do:
            /* Tax type exists in tax base.  Cannot delete */
            {pxmsg.i &MSGNUM=894 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.

         /* TAX MASTER */
         find first tx2_mstr  where
         tx2_tax_type = code_value no-error.
         if available(tx2_mstr) then do:
            /* Tax type exists in tax master.  Cannot delete */
            {pxmsg.i &MSGNUM=896 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.

         /* TRAILER DETAIL */
         find first trld_det  where
         trld_tax_type = code_value no-error.
         if available(trld_det) then do:
            /* Tax type exists in trailer tax .  Cannot delete */
            {pxmsg.i &MSGNUM=897 &ERRORLEVEL=4}
            undo mainloop, retry.
         end.
         */
         /* SS - 090910.1 - E */

         delete code_mstr.
         clear frame a.
         next mainloop.

      end.

      /* SS - 090910.1 - B */
      /* gp972.p支持 */
      ASSIGN
         CODE_cmmt = code_cmmt
         .
      /* SS - 090910.1 - E */

   end.    /* seta: */

   release code_mstr.

end.    /* mainloop: */
