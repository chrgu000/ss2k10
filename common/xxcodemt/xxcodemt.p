/* xxcodemt.p - GENERAL PURPOSE CODES FILE MAINT INCLUDE ALL FIELDS          */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */ 
/* REVISION: 14YP LAST MODIFIED: 01/08/19 BY: zy Add EB common            *EB*/
/* REVISION END                                                              */

{mfdtitle.i "18YJ"}

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.

define variable fieldname like code_fldname no-undo.

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   code_fldname   colon 18
   code_value     colon 18 format "x(50)" skip(1)
   code_cmmt      colon 18 format "x(50)" skip(1)
   code_desc      colon 18 format "x(50)"
   code_user1     colon 18 format "x(50)"
   code_user2     colon 18 format "x(50)"
   code__qadc01   colon 18 format "x(50)"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   if input code_fldname <> "" and input code_value <> "" then
      find code_mstr where
/*EB       code_mstr.code_domain = global_domain and                         */
           code_fldname = input code_fldname and
           code_value = input code_value
   no-lock no-error.
   if available code_mstr then
      recno = recid(code_mstr).

   prompt-for code_fldname
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
/*   {mfnp05.i code_mstr code_fldval " code_mstr.code_domain = global_domain */
/*   and code_fldname  <>                                                    */
/*            ""gluserid"" " code_fldname "input code_fldname"}              */
/*EB*/   {mfnp05.i code_mstr code_fldval " code_fldname  <>
           ""gluserid"" " code_fldname "input code_fldname"}
/*EB*/

      if recno <> ? then
         display
            code_fldname
            code_value
            code_cmmt
            code_desc
            code_user1
            code_user2
            code__qadc01.

   end. /* editing: */

   /* DO NOT ALLOW INPUT OF FIELD-NAME gluserid */
   if input code_fldname = "gluserid" then do:
      {pxmsg.i &MSGNUM=3147 &ERRORLEVEL=3}
      /* USE OF THIS FIELD NAME NOT ALLOWED IN
         GENERALIZED CODES */
      undo, retry.
   end. /* if input code_fldname = "gluserid" then do: */

   fieldname = input code_fldname.
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
/*EB    {mfnp05.i code_mstr code_fldval                                       */
/*EB       " code_mstr.code_domain = global_domain and code_fldname  = input  */
/*EB       code_fldname" code_value                                           */
/*EB       "input code_value"}                                                */

/*EB*/  {mfnp05.i code_mstr code_fldval
           " code_fldname  = input code_fldname" code_value
           "input code_value"}
/*EB*/
         if recno <> ? then
            display code_fldname code_value code_cmmt code_desc
                    code_user1 code_user2 code__qadc01.

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

   find code_mstr  where
/*EB    code_mstr.code_domain = global_domain and                            */
   code_fldname = input code_fldname
                    and code_value = input code_value
   no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr.
/*eb      code_mstr.code_domain = global_domain.                             */
      assign
         code_fldname code_value.
   end. /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   update
      code_cmmt
      code_desc
      code_user1
      code_user2
      code__qadc01
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

end. /* prompt-for code_fldname */

status input.
