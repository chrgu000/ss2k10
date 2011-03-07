/* xxbmpsrpcd.p - GENERAL PURPOSE CODES FILE MAINT                            */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION:110217.1 LAST MODIFIED: 02/17/11 BY: zy                       *2h**/
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.C04   QAD:eb21sp6                                 */

/* DISPLAY TITLE */
{mfdtitle.i "110217.1"}

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.

define variable fieldname like code_fldname no-undo initial "xxbmpsrp10-wkctr".

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   code_value     colon 25 format "x(30)" skip(1)
   code_user1     colon 25
   code_cmmt      colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   if input code_value <> "" then
      find code_mstr  where code_mstr.code_domain = global_domain and
      code_fldname = fieldname and code_value = input code_value
   no-lock no-error.
   if available code_mstr then
      recno = recid(code_mstr).

   {gpfield.i &field_name = fieldname}

   /* Determine length of field as defined in db schema */
   {gpfldlen.i}

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         code_value
         batchdelete no-label when (batchrun)
      editing:

         {mfnp05.i code_mstr code_fldval
            " code_mstr.code_domain = global_domain and
              code_fldname  = fieldname" code_value
            "input code_value"}

         if recno <> ? then
            display code_value code_user1 code_cmmt.

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

   find code_mstr  where code_mstr.code_domain = global_domain and
        code_fldname = fieldname and code_value = input code_value no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr.
      assign code_mstr.code_domain = global_domain
             code_mstr.code_fldname = fieldname.
      assign
          code_value
          code_user1.
   end. /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   update
     code_user1 code_cmmt
   go-on(F5 CTRL-D).

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      or input batchdelete = "x"
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=4010 &ERRORLEVEL=1}

   end. /* then do: */

end. /* prompt-for code_fldname */

status input.
