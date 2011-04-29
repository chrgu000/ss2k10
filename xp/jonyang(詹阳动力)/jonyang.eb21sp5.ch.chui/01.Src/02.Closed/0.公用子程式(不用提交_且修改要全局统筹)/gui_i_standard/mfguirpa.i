/* mfguirpa.i - Report include file #2 for convert std reports to gui   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9 $                                                     */

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/
/******************************** History *******************************/
/* Revision: 8.3           Created: 05/02/94     By: gui                */
/* Revision: 8.3     Last Modified: 04/25/95     By: srk                */
/* Revision: 8.5     Last Modified: 03/04/96     By: jpm      /*J0CF*/  */
/* Revision: 8.5     Last Modified: 07/09/96     By: jpm      /*J0WM*/  */
/* Revision: 8.5     Last Modified: 07/30/96     By: jpm      /*J12Y*/  */
/* REVISION: 8.4     LAST MODIFIED: 02/07/98    *H1JG* Jean Miller      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 02/09/00   BY: *M0JQ* J. Fernando  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb          */
/* $Revision: 1.9 $    BY: Manisha Sawant        DATE: 23/06/04  ECO: *P27F*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/
/********************************* Notes ********************************/
/*!
   Parameters:
    {1} (required) "true/false" ("true" if batch options on print routines)
    {2}  Name of file to output to, e.g. "terminal", "printer"
    {3}  Width of page, e.g. 80 or 132
    {4} (optional) "nopage" for programs printing checks or labels
    {5} (optional) stream name (must also include in mfrtrail.i)
    {6} (optional) "append" (to append to disk files)
*/
/************************************************************************/

{gpprtrp.i {1} "{2}" {3} "{4} " "{5} " {6}}

rect-frame-label:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(rect-frame-label:SCREEN-VALUE + " ",
   rect-frame-label:FONT).

rect-frame-label:HEIGHT-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(rect-frame-label:FONT).

if rect-frame-label:MOVE-TO-TOP()
then .

frame a:HEIGHT-CHARS = max(4, frame a:HEIGHT-CHARS + 1).
rect-frame:HEIGHT-CHARS in frame a = frame a:HEIGHT-CHARS - .8.
rect-frame:WIDTH-CHARS = frame a:WIDTH-CHARS - .5.
view rect-frame-label.
message " ".
message " ".

/*GUI*  REPORT BUTTON DEFINITIONS */
define variable widget-first as widget-handle.

define button Button-Clear
   label "&Clear":L
   font 1
   size 10 by 1.

define button Button-Report
   auto-go
   label "&Print":L
   font 1
   size 10 by 1.

define button Button-Exit
   auto-endkey
   label "E&xit":L
   font 1
   size 10 by 1.

define rectangle Rect-But
   edge-pixels 1
   size 80 by 1
   fgcolor 1.

define frame frame-but
   Rect-But      at row 1.0  column 1
   Button-Clear  at row 1.0  column 47
   Button-Report at row 1.0  column 57
   Button-Exit   at row 1.0  column 71
   with 1 down no-box side-labels no-underline
   at column 1 row 17 size 80 by 1.0 bgcolor 7 font 1.

/* SET EXTERNALIZED LABELS. */
setFrameLabels(frame frame-but:handle).

assign
   frame frame-but:MOVABLE = true
   frame frame-but:VISIBLE = false
   frame frame-but:ROW     = frame a:ROW + frame a:HEIGHT-CHARS.

/* SIZE BUTTON FRAME TO FONT 1 */
{gprun.i ""gpfontsz.p""
         "(frame frame-but:HANDLE,
           no,
           yes,
           """button,rectangle""",
           no)"}

/* SET WINDOW HEIGHT DOWN (FIRST TIME ONLY) */
if frame frame-but:VISIBLE = false
then
   CURRENT-WINDOW:HEIGHT-CHARS =  frame frame-but:ROW +
      frame frame-but:HEIGHT-CHARS - 1.

/* ENABLE REPORT BUTTONS */
if not batchrun
then
   enable all with frame frame-but.

on "ALT-C" anywhere do:
   apply "CHOOSE" to Button-Clear in frame frame-but.
end. /* ON "ALT-C" ANYWHERE DO */

on leave of frame a do:
   run p-check-validations no-error.
   if ERROR-STATUS:ERROR
   then
      return no-apply.
end. /* ON LEAVE OF FRAME a DO */

/* FORCE A LEAVE EVENT TO ENSURE THAT THE CURRENT FIELD IS VALIDATED     */
/* J0WM - THIS WAS CHANGED TO CURRENT-WINDOW TO OVERRIDE THE TRIGGER SET */
/* IN gpwinrun.p.  THAT TRIGGER WAS CAUSING GO TO EXECUTE TWICE.  THE    */
/* ONE IN gpwinrun.p HAS TO STAY THERE SO THAT THE DIFFERENT INTERFACES  */
/* (OBJECT AND LEGACY WILL WORK CORRECTLY)                               */

on GO of current-window anywhere do:
   run p-check-validations no-error.

   if ERROR-STATUS:ERROR
   then
      return no-apply.

   run p-print-report.
   return no-apply.
end. /* ON GO OF CURRENT-WINDOW ANYWHERE DO */

on choose of Button-Report in frame frame-but do:
   run p-print-report.

   if valid-handle(widget-first)
   and widget-first:SENSITIVE
   then
      apply "ENTRY" to widget-first.
   return no-apply.
end. /* ON CHOOSE OF BUTTON-REPORT IN FRAME frame-but DO */

on choose of Button-Exit in frame frame-but do:
   apply "WINDOW-CLOSE" to current-window.
end. /* ON CHOOSE OF BUTTON-EXIT IN FRAME frame-but DO */

on choose of Button-Clear in frame frame-but do:

   local-handle = frame a:FIRST-CHILD. /* field group */
   local-handle = local-handle:FIRST-CHILD. /* first widget */

   repeat while local-handle <> ?:
      if can-do(list-set-attrs(local-handle),"screen-value")
      then
         if local-handle:SENSITIVE
         then
            local-handle:SCREEN-VALUE = local-handle:PRIVATE-DATA.
         local-handle = local-handle:NEXT-SIBLING.
   end. /* REPEAT WHILE local-handle <> ? */

   if  valid-handle(widget-first)
   and widget-first:SENSITIVE
   then
      apply "ENTRY" to widget-first.
   return no-apply.
end. /* ON CHOOSE OF BUTTON-CLEAR IN FRAME frame-but DO */

PROCEDURE p-field-store-values:
   /* -----------------------------------------------------------
   PURPOSE:     GET THE SCREEN VALUE OF EACH FIELD AND STORE IT
                IN THE PRIVATE-DATA ATTRIBUTE OF THE SCREEN HANDLE
   PARAMETERS:  <NONE>
   NOTES:
   -------------------------------------------------------------*/

   local-handle = frame a:FIRST-CHILD. /* FIELD GROUP */
   local-handle = local-handle:FIRST-CHILD. /* FIRST WIDGET */

   repeat while local-handle <> ?:
      if can-do(list-set-attrs(local-handle),"SCREEN-VALUE")
      then do:
         /* STORE WIDGET'S ORIGINAL VALUE */
         local-handle:PRIVATE-DATA = local-handle:SCREEN-VALUE.
      end. /* IF CAN-DO(LIST-SET-ATTRS(LOCAL-HANDLE),"SCREEN-VALUE") */

      local-handle = local-handle:NEXT-SIBLING.
   end. /* REPEAT WHILE local-handle <> ?: */

END PROCEDURE. /* p-field-store-values */

PROCEDURE p-tool-print:
   /* -----------------------------------------------------------
   PURPOSE:     RUN THE ROUTINE TO ASSIGN THE INPUT FIELDS AND
                QUOTE THEM THEN RUN THE ROUTINE TO SET THE
                OUTPUT TO PRINTER OR A FILE NAME.  THIS IS
                EXECUTED WHEN THE PRINTER BUTTON IS CHOSEn
                FROM THE TOOL BAR.
   PARAMETERS:  <NONE>
   NOTES:
   -------------------------------------------------------------*/

   mainDO:
   do with frame a on error undo,  leave
      on endkey undo, leave:

      run p-action-fields
        (input "ASSIGN").

      run p-report-quote.

      if file_it
      then do on error undo, leave mainDO
         on endkey undo, leave mainDO:

         run p-print-set-file
           (input-output file_name).
         if index (file_name,".") = 0
         then
            path = file_name + ".prn".
         else
            path = file_name.
      end. /* IF file_it */

      disable all.
      run p-report.

   end. /* DO WITH FRAME a ON ERROR UNDO,  LEAVE ... */

   if valid-handle(terminal-window)
   then do:
      if terminal-window:VISIBLE
      then do:
         current-window = save-window.
         delete widget terminal-window.
      end. /* IF TERMINAL-WINDOW:VISIBLE */
   end. /* IF VALID-HANDLE(terminal-window) */

   run p-enable-ui.

END PROCEDURE. /* p-tool-print */

PROCEDURE p-print-report:
   /* -----------------------------------------------------------
   PURPOSE:     RUN THE ROUTINE TO ASSIGN THE INPUT FIELDS AND
                QUOTE THEM. NEXT, RUN THE DIALOG BOX TO SET THE
                DEFAULT PRINTER OR OUTPUT FILE, THEN RUN THE
                ROUTINE TO SET THE OUTPUT TO PRINTER OR A FILE
                NAME.  THIS IS EXECUTED WHEN THE PRINT BUTTON IS
                CHOSEN FROM THE REPORT - NOT THE TOOL BAR.
   PARAMETERS:  <NONE>
   NOTES:
   -------------------------------------------------------------*/

   mainDO:
   do with frame a on error undo, leave
      on endkey undo, leave:

      run p-action-fields
         (input "assign").

      run p-report-quote.
      run p-set-print-options
         (input-output dev,
          input-output file_it,
          input-output batch_id,
          input {1}).

      /* JAVAUI IS THE DEFAULT OUTPUT DEVICE FOR NETUI     */
      /* AND WILL BE CONSIDERED INVALID IN CHUI & GUI      */
      if dev = 'JAVAUI'
      and c-application-mode <> 'WEB'
      then do:
         /*OUTPUT TO JAVAUI IS ONLY AVAILABLE WITH MFG/PRO */
         /*FOR NETUI.                                      */
         {pxmsg.i &MSGNUM=3451 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF dev = 'JAVAUI' */

      if file_it
      then do on error undo, leave mainDO
         on endkey undo, leave mainDO:

         run p-print-set-file
            (input-output file_name).

         if index (file_name,".") = 0
         then
            path = file_name + ".prn".
         else
            path = file_name.
      end. /* IF file_it */

      disable all.
      run p-report.

   end. /* DO WITH FRAME a */

   if valid-handle(terminal-window)
   then do:
      if terminal-window:VISIBLE
      then do:
         current-window = save-window.
         delete widget terminal-window.
      end. /* IF TERMINAL-WINDOW:VISIBLE */

   end. /* MAINDO: DO WITH */

   run p-enable-ui.

END PROCEDURE. /* p-print-report */

PROCEDURE p-check-validations:
   /* -----------------------------------------------------------
   PURPOSE:     IF THE USER PRESSES GO IN THE INPUT FRAME a,
                VALIDATE EACH FIELD BY WALKING THRU THE WIDGET
                TREE TO MAKE SURE THERE ARE NO ERRORS IN THE INPUT
   PARAMETERS:  <NONE>
   NOTES:
   -------------------------------------------------------------*/

   define variable tmp-handle as widget-handle.
   define variable c-chk-date as character no-undo.
   define variable d-chk-date as date      no-undo.

   tmp-handle = frame a:FIRST-CHILD.       /* FIELD GROUP */
   tmp-handle = tmp-handle:FIRST-CHILD.    /* FIRST WIDGET */

   validation-error = no.

   repeat while tmp-handle <> ?
      and validation-error = no:

      if tmp-handle:DATA-TYPE = "DATE"
      then do:
         c-chk-date = string(tmp-handle:SCREEN-VALUE).
         d-chk-date = date(c-chk-date) no-error.

         if ERROR-STATUS:ERROR
         then do:
            validation-error = yes.
            {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
         end. /* IF ERROR-STATUS:ERROR */

      end. /* IF TMP-HANDLE:DATA-TYPE = "DATE" */

      if (tmp-handle:TYPE = "FILL-IN")
      and (tmp-handle:SENSITIVE)
      then do:
         if validation-error = no
         then
            apply "LEAVE" to tmp-handle.

         if validation-error
         then
            return error.

      end. /* IF (TMP-HANDLE:TYPE = "FILL-IN") */

      tmp-handle = tmp-handle:NEXT-SIBLING.

   end. /* REPEAT WHILE TMP-HANDLE <> ? */

   if validation-error = yes
   then
      return error.
   else
      return "".

END PROCEDURE. /* p-check-validations */
