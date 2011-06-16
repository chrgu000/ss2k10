/* mgcodemt.p - GENERAL PURPOSE CODES FILE MAINT                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0      LAST MODIFIED: 02/27/89   BY: WUG                       */
/* REVISION: 7.0      LAST MODIFIED: 02/24/92   by: jms   *F228*              */
/* REVISION: 7.0      LAST MODIFIED: 09/10/92   by: emb   *F885*              */
/* REVISION: 7.3      LAST MODIFIED: 10/12/93   by: rwl   *GG28*              */
/* REVISION: 7.3      LAST MODIFIED: 06/08/95   by: yep   *G0PL*              */
/* REVISION: 7.3      LAST MODIFIED: 07/28/95   by: str   *G0SV*              */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan         */
/* REVISION: 8.6      LAST MODIFIED: 12/16/98   BY: *J36C* Santhosh Nair      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *M0PC*                    */
/* Revision: 1.13       BY: Anil Sudhakaran      DATE: 04/09/01  ECO: *M0PC*  */
/* $Revision: 1.14 $    BY: Anil Sudhakaran      DATE: 05/09/02  ECO: *P05V*  */
/* $Revision: 1.14 $    BY: Bill Jiang      DATE: 12/06/05  ECO: *SS - 20051206*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080512.1 - B */
/*
1. code_fldname = "glta_acct1_fmpos"
2. code_user1
*/
/* SS - 20080512.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.

/* SS - 20051206 - B */
/*
define variable fieldname like code_fldname no-undo.
*/
define variable fieldname like code_fldname INITIAL "glta_acct1_fmpos" no-undo.
/* SS - 20051206 - E */

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
    /* SS - 20051206 - B */
    /*
   code_fldname   colon 25
    */
    /* SS - 20051206 - E */
   code_value     colon 25 LABEL "资金帐格式位置" format "x(30)" skip(1)
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

   /* SS - 20051206 - B */
   /*
   if input code_fldname <> "" and input code_value <> "" then
      find code_mstr where code_fldname = input code_fldname
                       and code_value = input code_value
   no-lock no-error.
   if available code_mstr then
      recno = recid(code_mstr).

   prompt-for code_fldname
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i code_mstr code_fldval "code_fldname <>
               ""gluserid"" " code_fldname "input code_fldname"}

      if recno <> ? then
         display
            code_fldname
            code_value
            code_cmmt.

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
   */
   if fieldname <> "" and input code_value <> "" then
      find code_mstr where code_fldname = fieldname
                       and code_value = input code_value
   no-lock no-error.
   if available code_mstr then
      recno = recid(code_mstr).

   /* DO NOT ALLOW INPUT OF FIELD-NAME gluserid */
   if fieldname = "gluserid" then do:
      {pxmsg.i &MSGNUM=3147 &ERRORLEVEL=3}
      /* USE OF THIS FIELD NAME NOT ALLOWED IN
         GENERALIZED CODES */
      undo, retry.
   end. /* if input code_fldname = "gluserid" then do: */

   {gpfield.i &field_name = fieldname}
   /* SS - 20051206 - E */

   /* Determine length of field as defined in db schema */
   {gpfldlen.i}

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         code_value
         batchdelete no-label when (batchrun)
      editing:
         /* SS - 20051206 - B */
         /*
         {mfnp05.i code_mstr code_fldval
            "code_fldname = input code_fldname" code_value
            "input code_value"}

         if recno <> ? then
            display code_fldname code_value code_cmmt.
         */
          {mfnp05.i code_mstr code_fldval
             "code_fldname = fieldname" code_value
             "input code_value"}

          if recno <> ? then
             display code_value code_cmmt.
         /* SS - 20051206 - E */

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
   /* SS - 20051206 - B */
   /*
   find code_mstr where code_fldname = input code_fldname
                    and code_value = input code_value
   no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr.
      assign
         code_fldname code_value.
   end. /* if not available code_mstr then do: */
   */
   find code_mstr where code_fldname = fieldname
                    and code_value = input code_value
   no-error.

   if not available code_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create code_mstr.
      assign
         code_value.
      CODE_fldname = fieldname.
   end. /* if not available code_mstr then do: */
   /* SS - 20051206 - E */

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

end. /* prompt-for code_fldname */

status input.
