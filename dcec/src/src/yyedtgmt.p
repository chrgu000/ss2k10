/* GUI CONVERTED from edtgmt.p (converter v1.76) Thu Feb 20 12:24:59 2003 */
/* edtgmt.p - Transmission Group File Maintenance - for Ecommerce      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                 */
/* All rights reserved worldwide.  This is an unpublished work.        */
/* $Revision: 1.25 $                                                         */
/*V8:ConvertMode=Maintenance                                           */
/* REVISION: 9.0       CREATED: 07/15/98    BY: *M030* Paul Dreslinski */
/* REVISION: 9.0   LAST MODIFIED: 02/04/99  BY: *M07H* Dan Herman      */
/* REVISION: 9.0   LAST MODIFIED: 03/13/99  BY: *M0BD* Alfred Tan      */
/* REVISION: 9.0   LAST MODIFIED: 07/13/99  BY: *M0D5* Reetu Kapoor    */
/* REVISION: 9.1   LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1   LAST MODIFIED: 08/14/00  BY: *N0KW* Jacolyn Neder   */
/* REVISION: 9.1   LAST MODIFIED: 08/29/00  BY: *N0PB* Rajinder Kamra  */
/* Old ECO marker removed, but no ECO header exists *M048*                    */
/* Revision: 1.22     BY: Katie Hilbert         DATE: 12/05/01  ECO: *P03C*  */
/* Revision: 1.23     BY: Paul Dreslinski       DATE: 12/05/01  ECO: *P04S*  */
/* $Revision: 1.25 $    BY: Paul Dreslinski       DATE: 02/15/03  ECO: *P0MQ* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Use EDTG__QADC01 FOR PROCESSING PROGRAM.          */
/* Use EDTG__QADI01 FOR PROCESSING PROGRAM AS A TIMEOUT.   */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

/* ************** Begin Translatable Strings Definitions ******** */

&SCOPED-DEFINE edtgmt_p_1 "Transmission Name"
/* MaxLen:34    Comment: field label for
"Document Transmission Group Name"   */

&SCOPED-DEFINE edtgmt_p_2 "Description"
/* MaxLen:34    Comment: Description */

&SCOPED-DEFINE edtgmt_p_3 "Control Number"
/* MaxLen:34    Comment: Abbreviation for "Control Number" */

&SCOPED-DEFINE edtgmt_p_4 "Destination"
/* MaxLen:34    Comment: Field label for "Destination Directory" */

&SCOPED-DEFINE edtgmt_p_5 "Destination Prefix"
/* MaxLen:34    Comment: Abbreviation for "Destination Prefix" */

&SCOPED-DEFINE edtgmt_p_6 "Processing Script"
/* MaxLen:34    Comment: Abbreviation for "Processing Script" */

&SCOPED-DEFINE edtgmt_p_7 " Transmission Group Maintenance "
/* MaxLen:70    Comment: Frame Title */

&SCOPED-DEFINE edtgmt_p_9 "Processing Program"
/* MaxLen:34    Comment: Abbreviation for "Processing Program" */

/* ************** End Translatable Strings Definitions ******** */
define variable del-yn   like mfc_logical no-undo.
define variable crdir-yn like mfc_logical no-undo.

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
edtg_dtg_name    colon 35 label {&edtgmt_p_1} skip(1)
   edtg_dtg_desc    colon 35 label {&edtgmt_p_2}
   edtg_dtg_ctrl    colon 35 label {&edtgmt_p_3}
   edtg_dest_dir    colon 35 label {&edtgmt_p_4}
                    view-as fill-in size 40 by 1
   edtg_dest_prefix colon 35 label {&edtgmt_p_5} /*james*/ FORMAT "x(30)"
   edtg_proc_scr    colon 35 label {&edtgmt_p_6} format "x(40)"
   edtg__qadc01     colon 35 label {&edtgmt_p_9} format "x(30)"
   edtg_http_id     colon 35
   edtg__qadi01     colon 35 label "HTTP Timeout"
   edtg_subsys      colon 35
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   prompt-for edtg_dtg_name
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i edtg_mstr edtg_dtg_name edtg_dtg_name edtg_dtg_name
         edtg_dtg_name edtg_dtg_name}

      if recno <> ? then
      display
         edtg_dtg_name
         edtg_dtg_desc
         edtg_dtg_ctrl
         edtg_dest_dir
         edtg_dest_prefix
         edtg_proc_scr
         edtg__qadc01
         edtg_http_id
         edtg__qadi01
         edtg_subsys.
   end.

   if input edtg_dtg_name = "" then do:
      /* BLANK Trans Group FILE NAME NOT ALLOWED */
      {pxmsg.i &MSGNUM=4737 &ERRORLEVEL=3}
      undo mainloop, retry mainloop.
   end.

   /* ADD/MOD/DELETE  */
   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

      find edtg_mstr using edtg_dtg_name exclusive-lock no-error.
      if not available edtg_mstr then do:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create edtg_mstr.
         assign edtg_dtg_name.
         if recid(edtg_mstr) = -1 then.
      end.

      display
         edtg_dtg_name
         edtg_dtg_desc
         edtg_dtg_ctrl
         edtg_dest_dir
         edtg_dest_prefix
         edtg_proc_scr
         edtg__qadc01
         edtg_http_id
         edtg__qadi01
         edtg_subsys.

      ststatus = stline[2].
      status input ststatus.
      del-yn = no.

      setblk:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         update
            edtg_dtg_desc
            edtg_dest_dir
            edtg_dest_prefix
            edtg_proc_scr
            edtg__qadc01
            edtg_http_id
            edtg__qadi01
            edtg_subsys
            go-on (F5 CTRL-D) with frame a editblk:
         editing:

            readkey.
            apply lastkey.

            /* Validate destination directory */
            if go-pending and lastkey <> keycode("F5") and
               keylabel(lastkey) <> "CTRL-D" and
               keyfunction(lastkey) <> "DELETE-CHARACTER"  then do:

               hide message no-pause.
               crdir-yn = no.

               find edss_mstr where edss_subsys =
                  input edtg_subsys no-lock no-error.
               if not available edss_mstr then do:
                  /* Subsystem does not exist */
                  {pxmsg.i &MSGNUM=4411 &ERRORLEVEL=3}
                  next-prompt edtg_subsys.
                  next editblk.
               end.
               if input edtg_http_id <> "" then do:
               find edhttp_mstr where edhttp_id = input edtg_http_id
                    no-lock no-error.
                 if not available edhttp_mstr then do:
                    /* HTTP CONNECTION DOES NOT EXIST*/
                    {pxmsg.i &MSGNUM=907 &ERRORLEVEL=3}
                    next-prompt edtg_http_id.
                    next editblk.
                 end.
               end.

               file-info:file-name = input edtg_dest_dir.

               if file-info:full-pathname = ? then do:
                  /* Directory does not exist: #.  Create it */
                  {pxmsg.i &MSGNUM=4736 &ERRORLEVEL=4
                           &MSGARG1="input edtg_dest_dir"
                           &CONFIRM=crdir-yn
                           &CONFIRM-TYPE='LOGICAL'}

                  if crdir-yn then
                     os-create-dir value(input edtg_dest_dir).
                  else do:
                     next-prompt edtg_dest_dir.
                     next editblk.
                  end.

                  file-info:file-name = input edtg_dest_dir.

                  if crdir-yn and file-info:full-pathname = ?
                  then do:
                     /* Unable to create directory: */
                     {pxmsg.i &MSGNUM=4424 &ERRORLEVEL=3
                              &MSGARG1="input edtg_dest_dir"}
                     next-prompt edtg_dest_dir.
                     next editblk.
                  end.

               end.

            end. /* if go-pending */

         end. /* EDITING Block */

         /* DELETE */
         if lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D") then do:

            run del_recs
               (input recid(edtg_mstr),
                input-output del-yn).

            /* PLEASE CONFIRM DELETE */
            if del-yn = no then undo setblk, retry setblk.

            clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
            hide message no-pause.
            next mainloop.
         end. /* lastkey = keycode("F5") */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* setblk */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* transaction */

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* mainloop */

status input.

/**************** INTERNAL PROCEDURES *********************/
PROCEDURE del_recs:

   define input  parameter i_edtg_recid    as recid           no-undo.
   define input-output parameter io_del-yn like mfc_logical   no-undo.

   find edtg_mstr where recid(edtg_mstr) = i_edtg_recid
   exclusive-lock no-error.

   if not available edtg_mstr then do:
      io_del-yn = no.
      return.
   end.

   else
      DEL_LOOP:
   do on error undo DEL_LOOP, leave DEL_LOOP
         on endkey undo DEL_LOOP, leave DEL_LOOP:
/*GUI*/ if global-beam-me-up then undo, leave.


      io_del-yn = no.
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=io_del-yn}
      if io_del-yn = no then
         return.

      /* VALIDATE DOE NOT EXIST ON MAP OR IN PARAM FUNCTION */
      for first edtpd_det where edtpd_dtg_name = edtg_dtg_name no-lock:
      end.
/*GUI*/ if global-beam-me-up then undo, leave.

      if available edtpd_det then do:
         /* Can not delete due to related record in edtpd_det,
         "Trading partner documents "*/
         {pxmsg.i &MSGNUM=4474 &ERRORLEVEL=4
            &MSGARG1=getTermLabel(""TRADING_PARTNER_DOCUMENTS"",40)}
         hide message.
         return.
      end. /* if available edtpd_det */

      delete edtg_mstr.

   end. /* do on error undo */

END PROCEDURE.
