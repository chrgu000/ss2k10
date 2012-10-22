/* mfguirpa.i - Report include file #2 for convert std reports to gui   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


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

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfguirpa_i_1 "&Clear"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfguirpa_i_2 "&Print"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfguirpa_i_3 "E&xit"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         {gpprtrp.i {1} "{2}" {3} "{4} " "{5} " {6}}
run p-print-report.   
 return no-apply.
/*
         rect-frame-label:WIDTH-PIXELS in frame a =
            FONT-TABLE:GET-TEXT-WIDTH-PIXELS(rect-frame-label:SCREEN-VALUE + " ",
            rect-frame-label:FONT).

         rect-frame-label:HEIGHT-PIXELS in frame a =
            FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(rect-frame-label:FONT).

         if rect-frame-label:MOVE-TO-TOP() then .

         frame a:HEIGHT-CHARS = max(4, frame a:HEIGHT-CHARS + 1).
         rect-frame:HEIGHT-CHARS in frame a = frame a:HEIGHT-CHARS - .8.
         rect-frame:WIDTH-CHARS = frame a:WIDTH-CHARS - .5.
         view rect-frame-label.
         message " ".
         message " ".

         /*GUI*  Report Button definitions */
         define variable widget-first as widget-handle.

         define button Button-Clear
            LABEL {&mfguirpa_i_1}:L
            FONT 1
            SIZE 10 BY 1.

         define button Button-Report
            AUTO-GO
            LABEL {&mfguirpa_i_2}:L
            FONT 1
            SIZE 10 BY 1.

         define button Button-Exit
            AUTO-ENDKEY
            LABEL {&mfguirpa_i_3}:L
            FONT 1
            SIZE 10 BY 1.

         define rectangle Rect-But
            EDGE-PIXELS 1
            SIZE 80 BY 1
            FGCOLOR 1.

         define frame frame-but
            Rect-But      at row 1.0  column 1
            Button-Clear  at row 1.0  column 47
            Button-Report at row 1.0  column 57
            Button-Exit   at row 1.0  column 71
         with 1 down no-box no-labels no-underline
         at column 1 row 17 size 80 by 1.0 bgcolor 7 font 1.

         assign
            frame frame-but:MOVABLE = true
            frame frame-but:VISIBLE = false
            frame frame-but:ROW     = frame a:ROW + frame a:HEIGHT-CHARS.

         /* Size button frame to font 1 */
         {gprun.i ""gpfontsz.p""
          "(frame frame-but:HANDLE, no, yes, """button,rectangle""", no)"}

         /* Set window height down (first time only)*/
         if frame frame-but:VISIBLE = false then
            CURRENT-WINDOW:HEIGHT-CHARS =  frame frame-but:ROW +
            frame frame-but:HEIGHT-CHARS - 1.

         /* Enable report buttons */
         if not batchrun then enable all with frame frame-but.

         on "ALT-C" anywhere do:
            apply "CHOOSE":U to Button-Clear in frame frame-but.
         end.

         on leave of frame a do:
            run p-check-validations no-error.
            if ERROR-STATUS:ERROR then return no-apply.
         end.

         /* Force a leave event to ensure that the current field is validated */
         /* j0wm - This was changed to CURRENT-WINDOW to override the trigger set
            in gpwinrun.p.  That trigger was causing GO to execute twice.  The
            one in gpwinrun.p has to stay there so that the different interfaces
            (Object and Legacy will work correctly) */

/*J0WM*  on GO of frame a do: */
/*J0WM*/ on GO of CURRENT-WINDOW anywhere do:
            run p-check-validations no-error.
            if ERROR-STATUS:ERROR then return no-apply.
            run p-print-report.
/*J0WM*/    return no-apply.
         end.

         on CHOOSE of Button-Report in frame frame-but do:
            run p-print-report.
/*J12Y*/    if valid-handle(widget-first) and widget-first:SENSITIVE then
/*J12Y*/       apply "ENTRY":U to widget-first.
/*J12Y*/    return no-apply.
         end.

         on CHOOSE of Button-Exit in frame frame-but do:
            apply "WINDOW-CLOSE":U to CURRENT-WINDOW.
         end.

         on CHOOSE of Button-Clear in frame frame-but do:
            local-handle = frame a:FIRST-CHILD. /* field group */
            local-handle = local-handle:FIRST-CHILD. /* first widget */
            repeat while local-handle <> ?:
               if can-do(list-set-attrs(local-handle),"screen-value") then
                  if local-handle:SENSITIVE then
                     local-handle:SCREEN-VALUE = local-handle:PRIVATE-DATA.
                  local-handle = local-handle:NEXT-SIBLING.
            end.
            if valid-handle(widget-first) and widget-first:SENSITIVE then
            apply "ENTRY":U to widget-first.
            return no-apply.
         end.
*/
         PROCEDURE p-field-store-values :
         /* -----------------------------------------------------------
           Purpose:     Get the screen value of each field and store it
                        in the PRIVATE-DATA attribute of the screen handle
           Parameters:  <none>
           Notes:
         -------------------------------------------------------------*/

         local-handle = frame a:FIRST-CHILD. /* field group */
         local-handle = local-handle:FIRST-CHILD. /* first widget */

         repeat while local-handle <> ?:
            if can-do(list-set-attrs(local-handle),"SCREEN-VALUE":U) then do:
               /* Store widget's original value */
               local-handle:PRIVATE-DATA = local-handle:SCREEN-VALUE.
            end.
            local-handle = local-handle:NEXT-SIBLING.
         end.

         END PROCEDURE.

         PROCEDURE p-tool-print :
         /* -----------------------------------------------------------
           Purpose:     Run the routine to assign the input fields and
                        quote them then run the routine to set the
                        output to printer or a file name.  This is
                        executed when the printer button is chosen
                        from the tool bar.
           Parameters:  <none>
           Notes:
         -------------------------------------------------------------*/

         mainDO:
         do with frame a on error undo,  leave
                         on endkey undo, leave:

            run p-action-fields
              (INPUT "ASSIGN":U).
            run p-report-quote.

            if file_it then do on error undo, leave mainDO
                              on endkey undo, leave mainDO:
               run p-print-set-file
                 (INPUT-OUTPUT file_name).
               if index (file_name,".") = 0 then
                  path = file_name + ".prn".
               else
                  path = file_name.
            end.

            disable all.
            run p-report.

         end. /* do with frame a */

         if valid-handle(terminal-window) then do:
            if terminal-window:VISIBLE then do:
               current-window = save-window.
               delete widget terminal-window.
            end.
         end.

         run p-enable-ui.

         END PROCEDURE.

         PROCEDURE p-print-report:
         /* -----------------------------------------------------------
           Purpose:     Run the routine to assign the input fields and
                        quote them. Next, run the dialog box to set the
                        default printer or output file, then run the
                        routine to set the output to printer or a file
                        name.  This is executed when the Print button is
                        chosen from the report - not the tool bar.
           Parameters:  <none>
           Notes:
         -------------------------------------------------------------*/

         mainDO:
         do with frame a on error undo, leave
                         on endkey undo, leave:

/*            run p-action-fields
              (INPUT "assign").

            run p-report-quote.*/

            run p-set-print-options
              (INPUT-OUTPUT dev,
               INPUT-OUTPUT file_it,
               INPUT-OUTPUT batch_id,
               INPUT {1}).
            /* JAVAUI IS THE DEFAULT OUTPUT DEVICE FOR NETUI     */ /*M0JQ*/
            /* AND WILL BE CONSIDERED INVALID IN CHUI & GUI      */ /*M0JQ*/
            /* BEGIN ADDED CODE */                                  /*M0JQ*/
            if dev = 'JAVAUI':U
               and c-application-mode <> 'WEB':U then do:
               /*OUTPUT TO JAVAUI IS ONLY AVAILABLE WITH MFG/PRO */
               /*FOR NETUI.                                      */
               {mfmsg.i 3451 3}
               undo, retry.
            end.
            /* END ADDED CODE   */                                 /*M0JQ*/

            if file_it then do on error undo, leave mainDO
                              on endkey undo, leave mainDO:
               run p-print-set-file
                 (INPUT-OUTPUT file_name).

               if index (file_name,".") = 0 then
                  path = file_name + ".prn".
               else
                  path = file_name.
               end.

               disable all.
               run p-report.

            end. /* do with frame a */

            if valid-handle(terminal-window) then do:
               if terminal-window:VISIBLE then do:
                  current-window = save-window.
                  delete widget terminal-window.
            end.

         end. /* maindo: do with */

         /*run p-enable-ui.*/

         END PROCEDURE.

         PROCEDURE p-check-validations:
         /* -----------------------------------------------------------
           Purpose:     If the user presses GO in the input frame a,
                        validate each field by walking thru the widget
                        tree to make sure there are no errors in the input
           Parameters:  <none>
           Notes:
         -------------------------------------------------------------*/
         define variable tmp-handle as widget-handle.
/*H1JG*/ define variable c-chk-date as character no-undo.
/*H1JG*/ define variable d-chk-date as date      no-undo.

         tmp-handle = frame a:FIRST-CHILD.       /* field group */
         tmp-handle = tmp-handle:FIRST-CHILD.    /* first widget */

         validation-error = no.

/*H1JG*  repeat while tmp-handle <> ?: */
/*H1JG*/ repeat while tmp-handle <> ? and validation-error = no :

/*H1JG*/    if tmp-handle:DATA-TYPE = "DATE" then do:
/*H1JG*/       c-chk-date = string(tmp-handle:SCREEN-VALUE).
/*H1JG*/       d-chk-date = date(c-chk-date) no-error.
/*H1JG*/       if ERROR-STATUS:ERROR then do:
/*H1JG*/          validation-error = yes.
/*H1JG*/          {mfmsg.i 27 3}
/*H1JG*/       end.
/*H1JG*/    end.

            if (tmp-handle:TYPE = "FILL-IN":U) and (tmp-handle:SENSITIVE)
            then do:
/*H1JG*/       if validation-error = no then
                  apply "LEAVE":U to tmp-handle.
               if validation-error then return ERROR.
            end.

            tmp-handle = tmp-handle:NEXT-SIBLING.

         end.

/*H1JG*/ if validation-error = yes then return error.
/*H1JG*/ else return "".

         END PROCEDURE.
