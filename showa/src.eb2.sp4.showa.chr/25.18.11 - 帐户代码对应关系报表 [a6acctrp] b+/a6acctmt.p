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
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.

define variable fieldname like code_fldname no-undo.

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
FORM
   xxac_code      colon 25 LABEL "对应代码"   
   xxac_code_desc colon 25 LABEL "描述" SKIP(1)
   xxac_drcr      colon 25 LABEL "DR/CR" 
   xxac_name      COLON 25 LABEL "自定义帐户" 
   xxac_name_desc COLON 25 LABEL "自定义帐户描述" 
   xxac_acctfrom  COLON 25 
   xxac_acctto    COLON 50 
   xxac_subfrom   COLON 25
   xxac_subto     COLON 50
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   if input xxac_code <> "" then
      find xxac_det WHERE xxac_code = input xxac_code no-lock no-error.
      if available xxac_det THEN recno = recid(xxac_det).

   prompt-for xxac_code xxac_code_desc
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i xxac_det acct_code "xxac_code <>
               ""gluserid"" " xxac_code "input xxac_code"}

      if recno <> ? then
         display
            xxac_code
            xxac_code_desc
            xxac_drcr
            xxac_name
            xxac_name_desc
            xxac_acctfrom
            xxac_acctto
            xxac_subfrom
            xxac_subto
            .

   end. /* editing: */

   /* DO NOT ALLOW INPUT OF FIELD-NAME gluserid */
   if input xxac_code = "gluserid" then do:
      {pxmsg.i &MSGNUM=3147 &ERRORLEVEL=3}
      /* USE OF THIS FIELD NAME NOT ALLOWED IN
         GENERALIZED CODES */
      undo, retry.
   end. /* if input code_fldname = "gluserid" then do: */

   ststatus = stline[2].
   status input ststatus.

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         xxac_drcr
         xxac_name
         xxac_name_desc
         xxac_acctfrom
         xxac_acctto
         xxac_subfrom
         xxac_subto
         batchdelete no-label when (batchrun)
         GO-ON(F5 CTRL-D) 
      editing:

        IF FRAME-FIELD = "xxac_drcr" THEN DO:
           {mfnp05.i xxac_det acct_code
            "xxac_code = input xxac_code " xxac_drcr
            "input xxac_drcr"}

           if recno <> ? then
               display xxac_code xxac_code_desc xxac_drcr xxac_name xxac_name_desc xxac_acctfrom xxac_acctto xxac_subfrom xxac_subto  .

        END.
        ELSE IF FRAME-FIELD = "xxac_name" THEN DO:
           {mfnp05.i xxac_det acct_code
            "xxac_code = input xxac_code and xxac_drcr = input xxac_drcr " xxac_name
            "input xxac_name"}

           if recno <> ? then
               display xxac_code xxac_code_desc xxac_drcr xxac_name xxac_name_desc xxac_acctfrom xxac_acctto xxac_subfrom xxac_subto  .

        END.
        ELSE do:
            readkey.
            /* ASSIGN THE SCREEN VALUES */
            ASSIGN .
            apply lastkey.
        END.
 

       
      end. /* editing: */

      IF NOT (INPUT xxac_drcr = '借方' OR INPUT xxac_drcr = "贷方"
         OR caps(INPUT xxac_drcr) = "DR" OR caps(INPUT xxac_drcr) = "CR") THEN DO:
          {pxmsg.i &MSGNUM=902 &ERRORLEVEL= 3 &MSGARG1 = xxac_drcr:SCREEN-VALUE }
          UNDO, RETRY .
      END. 
      FIND FIRST ac_mstr WHERE ac_code = INPUT xxac_acctfrom NO-LOCK NO-ERROR.
      IF NOT AVAIL ac_mstr THEN DO:
         {pxmsg.i &MSGNUM=902 &ERRORLEVEL= 3 &MSGARG1 = xxac_acctfrom:SCREEN-VALUE }
          UNDO, RETRY .
      END.
      FIND FIRST ac_mstr WHERE ac_code = INPUT xxac_acctto NO-LOCK NO-ERROR.
      IF NOT AVAIL ac_mstr THEN DO:
         {pxmsg.i &MSGNUM=902 &ERRORLEVEL= 3 &MSGARG1 = xxac_acctto:SCREEN-VALUE }
          UNDO, RETRY .
      END.
      FIND FIRST sb_mstr WHERE sb_sub = INPUT xxac_subfrom NO-LOCK NO-ERROR.
      IF NOT AVAIL sb_mstr THEN DO:
         {pxmsg.i &MSGNUM=902 &ERRORLEVEL= 3 &MSGARG1 = xxac_subfrom:SCREEN-VALUE }
          UNDO, RETRY .
      END.
      FIND FIRST ac_mstr WHERE ac_code = INPUT xxac_acctto NO-LOCK NO-ERROR.
      IF NOT AVAIL sb_mstr THEN DO:
         {pxmsg.i &MSGNUM=902 &ERRORLEVEL= 3 &MSGARG1 = xxac_subto:SCREEN-VALUE }
          UNDO, RETRY .
      END.

   end. /* do on error undo, retry: */

   /* ADD/MOD/DELETE  */

   FIND xxac_det where xxac_code = input xxac_code
                   and xxac_drcr = INPUT xxac_drcr
                   AND xxac_name = INPUT xxac_name
                   AND xxac_acctfrom = INPUT xxac_acctfrom
                   AND xxac_acctto   = INPUT xxac_acctto
                   AND xxac_subfrom  = INPUT xxac_subfrom
                   AND xxac_subto    = INPUT xxac_subto 
                   no-error.
   if not available xxac_det then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create xxac_det.
      assign
          xxac_code xxac_code_desc xxac_drcr xxac_name xxac_name_desc xxac_acctfrom xxac_acctto xxac_subfrom xxac_subto  .
   end. /* if not available code_mstr then do: */
   ELSE DO:
      IF xxac_name_desc <> INPUT xxac_name_desc THEN DO:
         ASSIGN
            xxac_name_desc = INPUT xxac_name_desc
            .
      END.
   END.

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      or input batchdelete = "x"
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete xxac_det .
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */

end. /* prompt-for code_fldname */

status input.
