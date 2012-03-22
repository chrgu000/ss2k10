/* mftool.i - Include file for Toolbar Logic                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/


/******************************** History *******************************/
/* Revision: 8.3     Last Modified: 02/16/95   By: gui                  */
/* Revision: 8.5     Last Modified: 01/25/96   By: *J0CF* Jean Miller   */
/* Revision: 8.6F    Last Modified: 02/12/99   By: *M085* Jean Miller   */
/* Revision: 9.1     Last Modified: 06/10/99   By: *J3GX* John Corda    */
/* Revision: 9.1     Last Modified: 07/24/99   By: *J3JV* A. Philips    */
/* Revision: 9.1     Last Modified: 12/21/99   By: *M0H3* Raphael T     */
/* Revision: 9.1     Last Modified: 08/13/00   By: *N0KR* myb           */
/************************************************************************/

/********************************  Notes  *******************************/
/* Prior to patch M085 this include file just contained two includes    */
/* mftool1.i and mftool2.i. Here are the changes with this version:     */
/* 1. The two include files: mftool1 and mftool2 have been obsoleted    */
/*    and the logic is included in here.                                */
/* 2. mftoolf.i which was included only in mftool1.i has been           */
/*    incorporated in this logic                                        */
/* 3. All references to PP_PGM_MT have been removed - that was used for */
/*    the old full-gui maint programs which were replaced by OBCM       */
/* 4. All references to user-tool and user-rect are removed because they*/
/*    weren't used anywhere in the code                                 */
/* 5. There were two events on choose of print-tool, one running the    */
/*    procedure persistently and the other not - the extra one has been */
/*    removed                                                           */
/* 6. Removed all references to global-cursor-state - it is not used    */
/* 7. Removed all references to MOTIF - this was never suppported       */
/* 8. Added Translatable Strings Section - none was done for mftoolf.i  */
/************************************************************************/

/*M085*  {mftool1.i} */
/*M085*  {mftool2.i} */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mftool_i_1 "Drill-Down"
/* MaxLen: Comment: Button Label for Drill Down */

&SCOPED-DEFINE mftool_i_2 "Field Help"
/* MaxLen: Comment: Button Label for Field Help */

&SCOPED-DEFINE mftool_i_3 "Help"
/* MaxLen: Comment: Button Label for Procedure Help */

&SCOPED-DEFINE mftool_i_4 "Copy"
/* MaxLen: Comment: Button Label for Copy */

&SCOPED-DEFINE mftool_i_5 "Paste"
/* MaxLen: Comment: Button Label for Paste */

&SCOPED-DEFINE mftool_i_6 "Print"
/* MaxLen: Comment: Button Label for Print */

&SCOPED-DEFINE mftool_i_7 "Exit"
/* MaxLen: Comment: Button Label for Exit */


/* ********** End Translatable Strings Definitions ********* */

         /* Define variables from mftool1.i */
         define new shared variable user-tool as widget-handle extent 4.
         define new shared variable user-rect as widget-handle extent 4.
         define new shared variable user-tool-idx as integer.
         define variable t-idx as integer initial 1 no-undo.
         define variable tool-adjust as decimal no-undo.
         define variable button-string as character no-undo.

         /******* this section from mftoolf.i **************/
         /* Definitions of the field level widgets         */

         define rectangle rect-tool
         edge-pixels 2
         size 70 by 1.18
         fgcolor 1.

         define button drill-tool
         image-up file "drill1":U
         image-insensitive file "drill2":U
         label {&mftool_i_1}
         size 3.45 by 1.16
         font 1.

         /* Field and Procedure Help Buttons */
         define button field-help-tool
         image-up file "fldhlp1":U
         image-insensitive file "fldhlp2":U
         label {&mftool_i_2}
         size 3.45 by 1.16
         font 1.

         define button proc-help-tool
         image-up file "prochlp1":U
         image-insensitive file "prochlp2":U
         label {&mftool_i_3}
         size 3.45 by 1.16
         font 1.

         /* Copy & Paste Buttons */
         define button copy-tool
         image-up file "copy1":U
         image-insensitive file "copy2":U
         label {&mftool_i_4}
         size 3.45 by 1.16
         font 1.

         define button paste-tool
         image-up file "paste1":U
         image-insensitive file "paste2":U
         label {&mftool_i_5}
         size 3.45 by 1.16
         font 1.

         /* Print button for reports, browses, & maintenance pgms */
         define button print-tool
         image-up file "printer1":U
         image-insensitive file "printer2":U
         label {&mftool_i_6}
         size 3.45 by 1.16
         font 1.

         /* Exit tool for non-Full GUI report programs */
         &IF {&PP_ENV_GUI} &THEN
         &ELSE
         define button exit-tool
         image-up file "exit1":U
         image-insensitive file "exit2":U
         label {&mftool_i_7}
         size 3.45 by 1.16
         font 1.
         &ENDIF

         /* **********  Frame Definitions  *********** */

         define frame tool-bar-frame
            rect-tool       at row 1.0 column 1
            &IF {&PP_PGM_RP} &THEN
            print-tool      at row 1.0 column 53.32 no-label
            &ENDIF
            copy-tool       at row 1.0 column 46.38 no-label
            paste-tool      at row 1.0 column 49.85 no-label
            &IF {&PP_ENV_GUI} &THEN
            field-help-tool at row 1.0 column 60.26 no-label
            proc-help-tool  at row 1.0 column 63.73 no-label
            drill-tool      at row 1.0 column 67.2  no-label
            &ELSE
            field-help-tool at row 1.0 column 56.79 no-label
            proc-help-tool  at row 1.0 column 60.26 no-label
            drill-tool      at row 1.0 column 63.73 no-label
            exit-tool       at row 1.0 column 67.2  no-label
/*bn*/      EXECNAME        view-as text SIZE 14 BY 1 AT ROW 1.1 COL 2
                            FGCOLOR 15 no-label
            &ENDIF
         with 1 down overlay side-labels no-box
         at column 1 row 1 size 70 by 1.18 bgcolor 7
         font 1.
/*bn*/   display EXECNAME format "x(24)" with frame tool-bar-frame.
         /* Make frame size and right-buttons' positions relative
            to window size */
         run p-tool-adjust in THIS-PROCEDURE.

         run p-tool-help in THIS-PROCEDURE
           (INPUT button-string).

         /*** End of section originally from mftoolf.i ***/

         /*** This section of logic is from mftool1.i ***/
         global-tool-bar-handle = frame tool-bar-frame:handle.
         /* Make the tool bar */
         {gprun.i ""gpmktlbr.p""}    /* make tool bar */

         do while t-idx < user-tool-idx:
            on choose of user-tool[t-idx] do:
               run p-choose-user-tool in THIS-PROCEDURE.
               global-beam-me-up = false.                            /*J3GX*/
            end.
            t-idx = t-idx + 1.
         end.

         /* Size toolbar frame to font 1 */
         {gprun.i ""gpfontsz.p""
          "(frame tool-bar-frame:handle, no, yes, """rectangle,button""", no)"}

         on choose of drill-tool do:
            run p-choose-drill-tool in THIS-PROCEDURE.
         end.

         on choose of copy-tool do:
            run p-choose-copy-tool in THIS-PROCEDURE.
         end.

         on choose of paste-tool do:
            run p-choose-paste-tool in THIS-PROCEDURE.
         end.

         on choose of field-help-tool do:
            run p-choose-help in THIS-PROCEDURE.
         end.

         on choose of proc-help-tool do:
            {gprun.i 'gphelp.p':U "('PROCEDURE_HELP':U,execname,'')" }
            return no-apply.
         end.

         &IF {&PP_PGM_RP} &THEN
         on choose of print-tool
            persistent run p-tool-print in THIS-PROCEDURE.
         &ENDIF

         &IF {&PP_ENV_GUI} &THEN
         &ELSE
         on choose of exit-tool do:
            apply "WINDOW-CLOSE":U to current-window.
         end.
         &ENDIF

         /* Toolbar control from the menu */
         on choose,
           value-changed
         of menu-item options-tool-bar-ptr in menu menu-bar-ptr
           persistent run p-menu-toolbar in tools-hdl
             (INPUT GLOBAL-TOOL-BAR-HANDLE).
         /*** End of logic is from mftool1.i ***/

         /*** This logic was from mftool2.i ***/
         if global-tool-bar then do:
            frame tool-bar-frame:visible = true.
            if not batchrun then
               enable all with frame tool-bar-frame.
         end.


         /**************** INTERNAL PROCEDURES ******************/

         PROCEDURE p-all-select:
         /* -----------------------------------------------------------
          Purpose:     Enables all widgets for selection for field help
          Parameters:  sel-status
                       list-disabled-flds
          Notes:       Procedure is from mftool1.i
         -------------------------------------------------------------*/
         define input parameter sel-status as logical.
         define input-output parameter list-disabled-flds as character.

         define variable enabled-only   as logical   initial false no-undo.
         define variable valid-attr     as character initial ""    no-undo.
         define variable frm-grp-handle as widget-handle no-undo.
         define variable frm-handle     as widget-handle no-undo.

         frm-handle = current-window:first-child.
         repeat while frm-handle <> ?:
            frm-grp-handle = frm-handle:first-child.
            run p-widget-select
              (INPUT sel-status,
               INPUT frm-grp-handle,
               INPUT enabled-only,
               INPUT valid-attr,
               INPUT-OUTPUT list-disabled-flds).
            frm-handle:selectable = sel-status.
            frm-handle = frm-handle:next-sibling.
         end.

         END PROCEDURE.


         PROCEDURE p-choose-copy-tool:
         /* -----------------------------------------------------------
          Purpose:     Action to take when copy button is chosen
          Parameters:  None
          Notes:       New Procedure - the logic was in mftool1.i
         -------------------------------------------------------------*/
         define variable list-disabled-flds as character     no-undo.
         define variable focus-handle       as widget-handle no-undo.

         on selection anywhere
         do:
            clipboard:value = self:screen-value.
         end.

         on start-box-selection anywhere
         do:
            clipboard:multiple = true.
         end.

         on end-box-selection anywhere
         do:
            clipboard:multiple = false.
         end.

         on any-printable anywhere
         do:
            return no-apply.
         end.

         run p-copy-paste-select in THIS-PROCEDURE
           (input true,
            input false,
            input-output list-disabled-flds).
         local-result =
           current-window:load-mouse-pointer("copycur.cur").

         if not local-result then do:
            {mfmsg.i 7718 4} /* MOUSE CURSOR LOAD FAILED */
         end.
         else do on error undo, leave on end-key undo, leave:
            menu menu-bar-ptr:sensitive = false.

            wait-for selection, end-box-selection of current-window.

            on selection, end-box-selection, any-printable anywhere
               revert.

            local-result = current-window:load-mouse-pointer("").

         end. /* else do on error */

         on selection, end-box-selection, any-printable anywhere
            revert.

         run p-copy-paste-select in THIS-PROCEDURE
           (input false,
            input false,
            input-output list-disabled-flds).

         local-result = current-window:load-mouse-pointer("").
         menu menu-bar-ptr:sensitive = true.

         END PROCEDURE.


         PROCEDURE p-choose-drill-tool:
         /* -----------------------------------------------------------
          Purpose:     Action to take when drill button is chosen
          Parameters:  None
          Notes:       New Procedure - the logic was in mftool1.i
         -------------------------------------------------------------*/
         define variable list-disabled-flds as character no-undo.
         define variable focus-handle       as widget-handle no-undo.
         define variable pass-back          as logical no-undo.

         on selection anywhere
         do:
            focus-handle = self.
         end.

         on any-printable anywhere
         do:
            return no-apply.
         end.

         run p-all-select in THIS-PROCEDURE
           (input true,
            input-output list-disabled-flds).

         local-result =
            current-window:load-mouse-pointer("drillcur.cur").

         if not local-result then do:
            {mfmsg.i 7718 4} /* MOUSE CURSOR LOAD FAILED */
         end.
         else do on error undo, leave on end-key undo, leave:
            menu menu-bar-ptr:sensitive = false.

            wait-for SELECTION of current-window.

            on selection, any-printable anywhere
               revert.

            local-result = current-window:load-mouse-pointer("").

            if focus-handle <> ? then do:
               pass-back = true.
               if can-do(list-disabled-flds,string(focus-handle))
               then pass-back = false.
               {gprun.i 'hpdrill.p' "(focus-handle,pass-back)"}
            end.
            else do:
               {mfmsg.i 7720 4} /* NO DRILL DOWN AVAILABLE FOR TYPE */
            end.
         end. /* else do on error */

         on selection, any-printable anywhere
            revert.

         run p-all-select in THIS-PROCEDURE
           (input false,
            input-output list-disabled-flds).

         local-result = current-window:load-mouse-pointer("").
         menu menu-bar-ptr:sensitive = true.
         return no-apply.

         END PROCEDURE.

         PROCEDURE p-choose-help :
         /* -----------------------------------------------------------
          Purpose:     Action to take when help button is chosen
          Parameters:  None
          Notes:       New Procedure - the logic was in mftool1.i
         -------------------------------------------------------------*/
         define variable list-disabled-flds as character no-undo.
         define variable focus-handle as widget-handle   no-undo.

         on selection, empty-selection anywhere
         do:
            focus-handle = self.
         end.

         on any-printable anywhere
         do:
            return no-apply.
         end.

         local-result =
           current-window:load-mouse-pointer("question.cur").

         if not local-result then do:
            {mfmsg.i 7718 4} /* MOUSE CURSOR LOAD FAILED */
         end.
         else do on error undo, leave on end-key undo, leave:

            menu menu-bar-ptr:sensitive = false.

            run p-all-select in THIS-PROCEDURE
              (input true,
               input-output list-disabled-flds).

            wait-for selection, empty-selection of current-window.

            on selection, empty-selection, any-printable anywhere
               revert.

            local-result = current-window:load-mouse-pointer("").
            if focus-handle:name <> "" then do:
               {gprun.i 'gphelp.p':U
                "('FIELD_HELP':U,execname,focus-handle:name )" }
            end.
            else do:
               {mfmsg.i 7719 4} /* NO HELP AVAILABLE FOR THIS TYPE */
            end.

         end. /* else do on error */

         on selection, empty-selection, any-printable anywhere
            revert.

         run p-all-select in THIS-PROCEDURE
           (input false,
            input-output list-disabled-flds).

         local-result = current-window:load-mouse-pointer("").
         menu menu-bar-ptr:sensitive = true.
         return no-apply.

         END PROCEDURE.

         PROCEDURE p-choose-paste-tool:
         /* -----------------------------------------------------------
          Purpose:     Action to take when paste button is chosen
          Parameters:  None
          Notes:       New Procedure - the logic was in mftool1.i
         -------------------------------------------------------------*/
         define variable list-disabled-flds as character no-undo.

         on selection anywhere
         do:
            self:screen-value = clipboard:value.
         end.

         on start-box-selection anywhere
         do:
            clipboard:multiple = true.
         end.

         on end-box-selection anywhere
         do:
            clipboard:multiple = false.
         end.

         on any-printable anywhere
         do:
            return no-apply.
         end.

         run p-copy-paste-select in THIS-PROCEDURE
           (input true,
            input true,
            input-output list-disabled-flds).
         local-result =
           current-window:load-mouse-pointer("pastecur.cur").

         if not local-result then do:
            {mfmsg.i 7718 4} /* MOUSE CURSOR LOAD FAILED */
         end.
         else do on error undo, leave on end-key undo, leave:
            menu menu-bar-ptr:sensitive = false.

            wait-for selection, end-box-selection of current-window.

            on selection, end-box-selection, any-printable anywhere
               revert.

            local-result = current-window:load-mouse-pointer("").

         end. /* else do on error */

         on selection, end-box-selection, any-printable anywhere
            revert.

         run p-copy-paste-select in THIS-PROCEDURE
           (input false,
            input true,
            input-output list-disabled-flds).

         local-result = current-window:load-mouse-pointer("").
         menu menu-bar-ptr:sensitive = true.

         END PROCEDURE.

         PROCEDURE p-choose-user-tool :
         /* -----------------------------------------------------------
          Purpose:     Action to take when user tool button is chosen
          Parameters:  None
          Notes:       New Procedure - the logic was in mftool1.i
         -------------------------------------------------------------*/
         define variable run-pgm   as character no-undo.
         define variable run-label as character no-undo.
         define variable passedSecurity as logical initial no no-undo.
         define variable isProgram      as logical initial no no-undo.
         define variable last-execname  like execname.                /*J3JV*/
         define variable last-dtitle    like dtitle.                  /*M0H3*/

         /* STORE DTITLE IN LOCAL VAR. BEFORE CALLING SUB-PGM    */   /*M0H3*/
         /* REASSIGN DTITLE FROM VAR AFTER RETURN TO MAIN PGM    */   /*M0H3*/
         assign                                                       /*J3JV*/
            last-execname = execname                                  /*J3JV*/
            last-dtitle   = dtitle                                    /*M0H3*/
            run-pgm = self:PRIVATE-DATA.
         {gprun.i ""gpusrpgm.p"" "(input-output run-pgm,
                                   output run-label,
                                   output passedSecurity,
                                   output isProgram)"}

         execname = last-execname.                                    /*J3JV*/

         if passedSecurity then do:
            {gprun.i 'gpwinrun.p' "(input run-pgm, input run-label)"}
         end.
         dtitle = last-dtitle.                                        /*M0H3*/

         END PROCEDURE.

         PROCEDURE p-copy-paste-select:
         /* -----------------------------------------------------------
          Purpose:     Enables all widgets for selection for copy/paste
          Parameters:  sel-status
                       enabled-only
                       list-disabled-flds
          Notes:       Procedure is from mftool1.i
         -------------------------------------------------------------*/
         define input parameter sel-status   as logical.
         define input parameter enabled-only as logical.
         define input-output parameter list-disabled-flds as character.

         define variable frm-grp-handle as widget-handle no-undo.
         define variable frm-handle as  widget-handle no-undo.
         define variable valid-attr as character initial "screen-value":U no-undo.

         frm-handle = current-window:first-child.
         repeat while frm-handle <> ?:
            frm-handle:box-selectable = sel-status.
            frm-grp-handle = frm-handle:first-child.
            run p-widget-select
              (INPUT sel-status,
               INPUT frm-grp-handle,
               INPUT enabled-only,
               INPUT valid-attr,
               INPUT-OUTPUT list-disabled-flds).
            frm-handle = frm-handle:next-sibling.
         end.

         END PROCEDURE.

         PROCEDURE p-tool-adjust:
         /* -----------------------------------------------------------
          Purpose:     Shift all of the buttons slightly to make them
                       fit in the frame
          Parameters:  None
          Notes:       This procedure is from mftoolf.i and was created
                       by vrp with ECO M036 and was called tooladjust.
                       This new version includes additional code which
                       was left in the main block with that patch
         -------------------------------------------------------------*/
         tool-adjust =
           current-window:width-chars - frame tool-bar-frame:width-chars.
         frame tool-bar-frame:width-chars =
           frame tool-bar-frame:width-chars + tool-adjust.

         assign
            copy-tool:column       = copy-tool:column       + tool-adjust
            paste-tool:column      = paste-tool:column      + tool-adjust
            field-help-tool:column = field-help-tool:column + tool-adjust
            proc-help-tool:column  = proc-help-tool:column  + tool-adjust
            drill-tool:column      = drill-tool:column      + tool-adjust
            button-string          = string(copy-tool:handle)      + "," +
                                     string(paste-tool:handle)     + "," +
                                     string(proc-help-tool:handle) + "," +
                                     string(drill-tool:handle)     + "," +
                                     string(field-help-tool:handle).

         &IF {&PP_PGM_RP} &THEN
         print-tool:column      = print-tool:column + tool-adjust.
         if button-string <> "" then
            button-string = button-string + "," + string(print-tool:handle).
         else
            button-string = string(print-tool:handle).
         &ENDIF
         &IF {&PP_ENV_GUI} &THEN
         &ELSE
         exit-tool:column         = exit-tool:column + tool-adjust.
         if button-string <> "" then
            button-string = button-string + "," + string(exit-tool:handle).
         else
            button-string = string(exit-tool:handle).
         &ENDIF

         END PROCEDURE.

         PROCEDURE p-tool-help:
         /* -----------------------------------------------------------
          Purpose:     Get tool tips help
          Parameters:  but-strng  List of buttons
          Notes:       This procedure is from mftoolf.i and was created
                       by vrp with ECO M036 and was called toolhelp.
         -------------------------------------------------------------*/
         define input parameter but-strng like button-string no-undo.

         {tiphelp.i &button-handle = but-strng}

         END PROCEDURE.

         PROCEDURE p-widget-select:
         /* -----------------------------------------------------------
          Purpose:     Enables all widgets for selection
          Parameters:  sel-status
                       enabled-only
                       list-disabled-flds
          Notes:       Procedure is from mftool1.i
         -------------------------------------------------------------*/
         define input parameter sel-status as logical.
         define input parameter frm-grp-handle as widget-handle.
         define input parameter enabled-only as logical.
         define input parameter valid-attr as character.
         define input-output parameter list-disabled-flds as character.

         define variable wdgt-handle as widget-handle no-undo.

         wdgt-handle = frm-grp-handle:first-child.

         repeat while wdgt-handle <> ?:
            if valid-event(wdgt-handle,"selection":U) and
              (not(enabled-only) or wdgt-handle:sensitive = true) and
              (valid-attr = "" or can-do(list-set-attrs(wdgt-handle),valid-attr))
            then do:

               /* Keep track of currently disabled fields & their values*/
               if sel-status then do:
                  if wdgt-handle:sensitive = false then do:
                     list-disabled-flds = list-disabled-flds +
                     (if num-entries(list-disabled-flds) > 0 then "," else "") +
                     string(wdgt-handle).
                   wdgt-handle:sensitive = true.
                  end.
               end.

               /* Setting fields back to disabled; restore values in case
                 they were changed */
               else if can-do(list-disabled-flds,string(wdgt-handle))
               then
                  wdgt-handle:sensitive = false.
               wdgt-handle:selected = false.
               wdgt-handle:selectable = sel-status.
            end.

            wdgt-handle = wdgt-handle:next-sibling.

         end. /* repeat */

         END PROCEDURE.
