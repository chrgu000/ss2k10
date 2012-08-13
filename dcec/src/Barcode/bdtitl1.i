/* mfdtitl1.i - Setup Title and defined variables                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */


/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/


/******************************** History *******************************/
/* REVISION: 8.3     LAST MODIFIED: 01/16/95    BY: jpm                 */
/* REVISION: 8.3     LAST MODIFIED: 03/28/95    BY: jpm                 */
/* REVISION: 8.3     LAST MODIFIED: 05/16/95    BY: aed                 */
/* REVISION: 8.3     LAST MODIFIED: 06/27/95    BY: str                 */
/* REVISION: 8.3     LAST MODIFIED: 10/06/95    BY: *G0YV* Allan Doane  */
/* REVISION: 8.5     LAST MODIFIED: 01/14/96    BY: *J0BN* Jean Miller  */
/* Revision: 8.5     Last Modified: 01/17/96    By: *J090* Kevin Schantz*/
/* REVISION: 8.5     LAST MODIFIED: 07/24/96    BY: *J0WN* Jean Miller  */
/* REVISION: 8.5     LAST MODIFIED: 08/11/97    BY: *J1YV* Cynthia Terry*/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan   */
/* REVISION: 8.6F    LAST MODIFIED: 02/12/99    BY: *M085* Jean Miller  */
/* REVISION: 9.1     LAST MODIFIED: 03/15/00    BY: *N08T* D.Taylor     */
/* REVISION: 9.1     LAST MODIFIED: 04/07/00    BY: *J3PD* Raphael T    */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb          */
/************************************************************************/

/********************************  Notes  *******************************/
/* Patch M085 cleaned up this include file:                             */
/* 1. All patch markers were removed                                    */
/* 2. All references to PP_PGM_MT and PP_PGM_NAV have been removed -    */
/*    these were used for the old full-gui maint programs which were    */
/*    replaced by OBCM                                                  */
/* 3. Tool bar references to security and navigation were removed       */
/************************************************************************/
{mfdeclre.i}

/*N08T*/ {gplabel.i &ClearReg = yes}

/* ********** Begin Translatable Strings Definitions ********* */
/*N08T*/ /*** NOTE: ALL TRANSLATABLE STRING DEFINITIONS HAVE BEEN ***/
/*N08T*/ /*** HANDLED BY EXTERNALIZED LABELS IN THIS PROGRAM.     ***/

&SCOPED-DEFINE mfdtitl1_i_2 "&Options"
/* MaxLen: Comment: Menu Bar entry for Options Submenu */

&SCOPED-DEFINE mfdtitl1_i_3 "About..."
/* MaxLen: Comment: Menu Bar entry for "Help About"*/

&SCOPED-DEFINE mfdtitl1_i_4 "Cu&t"
/* MaxLen: Comment: Menu Bar entry for "Cut" - gui functionality*/

&SCOPED-DEFINE mfdtitl1_i_5 "&Help"
/* MaxLen: Comment: Menu Bar entry for Help Submenu */

&SCOPED-DEFINE mfdtitl1_i_6 " not selected."
/* MaxLen: Comment: */

&SCOPED-DEFINE mfdtitl1_i_7 "&User Menu"
/* MaxLen: Comment: Menu Bar entry for the User Submenu*/

&SCOPED-DEFINE mfdtitl1_i_8 "&Edit"
/* MaxLen: Comment: Menu Bar entry for Edit Submenu */

&SCOPED-DEFINE mfdtitl1_i_9 "&Paste"
/* MaxLen: Comment: Menu Bar entry for "Paste" - gui functionality*/

&SCOPED-DEFINE mfdtitl1_i_10 "&Copy"
/* MaxLen: Comment: Menu Bar entry for "Copy" - gui functionality*/

&SCOPED-DEFINE mfdtitl1_i_11 "&Contents"
/* MaxLen: Comment: Menu Bar entry for Help table of contents*/

&SCOPED-DEFINE mfdtitl1_i_12 "&Queue"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfdtitl1_i_13 " selected."
/* MaxLen: Comment: */

&SCOPED-DEFINE mfdtitl1_i_15 "Drill Down"
/* MaxLen: Comment: Menu Bar entry for Drill Down Browse*/

&SCOPED-DEFINE mfdtitl1_i_16 "Show Drop Downs"
/* MaxLen: Comment: Menu Bar entry for toggle on drop downs*/

&SCOPED-DEFINE mfdtitl1_i_17 "Field Help"
/* MaxLen: Comment: Menu Bar entry for Field Help*/

&SCOPED-DEFINE mfdtitl1_i_19 "Edit &Image"
/* MaxLen: Comment: Menu Bar entry for "Edit Image" - gui functionality*/

&SCOPED-DEFINE mfdtitl1_i_20 "Menu Substitutions"
/* MaxLen: Comment: Menu Bar entry for toggle for Menu Subs*/

&SCOPED-DEFINE mfdtitl1_i_23 "Look-Up Browse"
/* MaxLen: Comment: Menu Bar entry for Lookup Browse*/

&SCOPED-DEFINE mfdtitl1_i_25 "Interface Help"
/* MaxLen: Comment: Menu Bar entry GUI Interface Help */

&SCOPED-DEFINE mfdtitl1_i_26 "Procedure Help"
/* MaxLen: Comment: Menu Bar entry for Procedure Help*/

&SCOPED-DEFINE mfdtitl1_i_27 "Tool Bar"
/* MaxLen: Comment: Menu Bar entry for toggle on show tool bar*/

/*N08T*/ /*** NOTE: ALL TRANSLATABLE STRING DEFINITIONS HAVE BEEN ***/
/*N08T*/ /*** HANDLED BY EXTERNALIZED LABELS IN THIS PROGRAM.     ***/
/* ********** End Translatable Strings Definitions ********* */

         define variable temp-hand-ptr       as widget-handle.
         define variable prev-menu-bar-ptr   as widget-handle.

         define variable menu-bar-ptr        as widget-handle.
         define variable user-bar-ptr        as widget-handle.
         define variable exit-item-ptr       as widget-handle.
         define variable queue-bar-ptr       as widget-handle.

         define variable edit-bar-ptr        as widget-handle.
         define variable edit-cut-ptr        as widget-handle.
         define variable edit-copy-ptr       as widget-handle.
         define variable edit-paste-ptr      as widget-handle.

         define variable options-bar-ptr          as widget-handle.
         define variable options-tool-bar-ptr     as widget-handle.
         define variable options-drop-downs-ptr   as widget-handle.
         define variable options-menu-subs-ptr    as widget-handle.

         define variable help-bar-ptr             as widget-handle.
         define variable help-fld-bar-ptr         as widget-handle.
         define variable help-proc-bar-ptr        as widget-handle.
         define variable help-drill-bar-ptr       as widget-handle.
         define variable help-about-bar-ptr       as widget-handle.


         /* User Menu Selections */
         define sub-menu user-bar-ptr.
         define sub-menu queue-bar-ptr.

         /* Edit Menu Selections */
         define sub-menu edit-bar-ptr
            menu-item edit-cut-ptr             label {&mfdtitl1_i_4}
                      accelerator "CTRL-X"
            menu-item edit-copy-ptr            label {&mfdtitl1_i_10}
                      accelerator "CTRL-C"
            menu-item edit-paste-ptr           label {&mfdtitl1_i_9}
                      accelerator "CTRL-V"
            rule
            menu-item edit-image-ptr           label {&mfdtitl1_i_19}.

         /* Options Menu Selections */
         define sub-menu options-bar-ptr
            menu-item options-menu-subs-ptr    label {&mfdtitl1_i_20}
                      toggle-box
            menu-item options-tool-bar-ptr     label {&mfdtitl1_i_27}
                      toggle-box
            menu-item options-drop-downs-ptr   label {&mfdtitl1_i_16}
                      toggle-box.

         /* Help Menu Selections */
         define sub-menu help-bar-ptr
            menu-item help-contents-ptr        label {&mfdtitl1_i_11}
            menu-item help-interface-ptr       label {&mfdtitl1_i_25}
            rule
            menu-item help-fld-bar-ptr         label {&mfdtitl1_i_17}
                      accelerator "F1"
            menu-item help-proc-bar-ptr        label {&mfdtitl1_i_26}
                      accelerator "SHIFT-F1"
            menu-item help-drill-bar-ptr       label {&mfdtitl1_i_15}
                      accelerator "ALT-F1"
            menu-item help-scroll-win-ptr      label {&mfdtitl1_i_23}
                      accelerator "ALT-F2"
            rule
            menu-item help-about-bar-ptr       label {&mfdtitl1_i_3}
                      accelerator "CTRL-F1".

         /* Define the Menu Bar with the submenus */
         define menu menu-bar-ptr      menubar
            sub-menu user-bar-ptr              label {&mfdtitl1_i_7}
            sub-menu edit-bar-ptr              label {&mfdtitl1_i_8}
            sub-menu queue-bar-ptr             label {&mfdtitl1_i_12}
            sub-menu options-bar-ptr           label {&mfdtitl1_i_2}
            sub-menu help-bar-ptr              label {&mfdtitl1_i_5}.

         /* SET DEFAULT "PAUSE" BEHAVIOR FOR STANDARD (non-gui) PROGRAMS */
         if batchrun then
            pause 0 .
         else
            pause before-hide.
         global_program_name = PROGRAM-NAME(1).

/*
         /* MENU TRIGGERS */

         on choose of menu-item help-contents-ptr in menu menu-bar-ptr do:
            {gprun.i 'gphelp.p' "('CONTENTS':U,'','')" }
         end.

         on choose of menu-item help-interface-ptr in menu menu-bar-ptr do:
            {gprun.i 'gphelp.p' "('INTERFACE':U,'','')" }
         end.

         on choose of menu-item help-fld-bar-ptr in menu menu-bar-ptr
            persistent run p-menu-field-help in tools-hdl.

         on choose of menu-item help-proc-bar-ptr in menu menu-bar-ptr do:
            {gprun.i 'gphelp.p' "('PROCEDURE_HELP':U,execname,'')" }
         end.

         on choose of menu-item help-drill-bar-ptr in menu menu-bar-ptr
            persistent run p-menu-drill in tools-hdl.

         on choose of menu-item help-scroll-win-ptr in menu menu-bar-ptr
            persistent run p-menu-scroll in tools-hdl.

         on choose of menu-item help-about-bar-ptr in menu menu-bar-ptr
            persistent run p-menu-about in tools-hdl.

         on value-changed of menu-item options-tool-bar-ptr
         in menu options-bar-ptr do:
            run p-menu-toolbar-menu in tools-hdl.
         end.

         on value-changed of menu-item options-drop-downs-ptr
         in menu options-bar-ptr do:
            run p-menu-dropdowns-menu in tools-hdl.
         end.

         on value-changed of menu-item options-menu-subs-ptr
         in menu options-bar-ptr do:
            run p-menu-substitution in tools-hdl.
            if self:private-data <> ? then do:
               run value(self:private-data).
            end.
         end.

         on menu-drop of menu options-bar-ptr do:
            run p-options-bar-ptr-drop in THIS-PROCEDURE.
         end.

         on menu-drop of menu edit-bar-ptr do:
            run p-edit-bar-ptr-drop in THIS-PROCEDURE.
         end.

         on choose of menu-item edit-cut-ptr in menu edit-bar-ptr do:
            run p-choose-cut in THIS-PROCEDURE.
         end.

         on choose of menu-item edit-copy-ptr in menu edit-bar-ptr do:
            run p-choose-copy in THIS-PROCEDURE.
         end.

         on choose of menu-item edit-paste-ptr in menu edit-bar-ptr DO:
            run p-choose-paste in THIS-PROCEDURE.
         end.

         on choose of menu-item edit-image-ptr in menu edit-bar-ptr
            persistent run p-edit-image in tools-hdl.

         /* Hooks for Drop Downs */
         /* HANDLED IN GPWINRUN SO OBSOLETED */            /*J3PD*/
         /* run p-add-window in global-drop-down-utilities **J3PD*/
         /* (INPUT execname,                               **J3PD*/
         /*  INPUT CURRENT-WINDOW).                        **J3PD*/

         on entry of CURRENT-WINDOW anywhere
            persistent run p-handle-entry in global-drop-down-utilities.

         on leave of CURRENT-WINDOW anywhere do:
            do on error undo, leave:
               run q-leave in global-drop-down-utilities.
            end.
            run q-set-window-recid in global-drop-down-utilities.
            if return-value = "ERROR":U then return no-apply.
         end.


         /**************** INTERNAL PROCEDURES ******************/

         PROCEDURE p-choose-copy :
         /* -----------------------------------------------------------
          Purpose:     Action to take when Copy chosen from menu
          Parameters:  None
          Notes:       Moved to internal procedure to reduce segment size
         -------------------------------------------------------------*/
         if focus:type = "EDITOR":U then
            if focus:selection-start <> focus:selection-end then
               clipboard:value = focus:selection-text.
            else
               clipboard:value = focus:screen-value.
         else if focus:type = "RADIO-SET":U then
            clipboard:value = entry(lookup(focus:screen-value,
                    focus:radio-buttons) - 1,
                    focus:radio-buttons).
         else if focus:type = "TOGGLE-BOX":U then
            if focus:screen-value = "yes" then
               /* clipboard:value = focus:label + {&mfdtitl1_i_13}. */ /*N08T*/
               clipboard:value = focus:label + " " +                   /*N08T*/
                                 getTermLabel("LC_SELECTED",15) + ".". /*N08T*/
            else
               /* clipboard:value = focus:label + {&mfdtitl1_i_6}. */  /*N08T*/
               clipboard:value = focus:label + " " +                   /*N08T*/
                                 getTermLabel("LC_NOT_SELECTED",15)    /*N08T*/
                                 + ".".                                /*N08T*/
         else /* For FILL-IN */
            clipboard:value = focus:screen-value.

         END PROCEDURE.

         PROCEDURE p-choose-cut :
         /* -----------------------------------------------------------
          Purpose:     Action to take when Cut chosen from menu
          Parameters:  None
          Notes:       Moved to internal procedure to reduce segment size
         -------------------------------------------------------------*/
         if focus:type = "EDITOR":U then do:
            if focus:selection-start <> focus:selection-end then do:
               clipboard:value = focus:selection-text.
               local-result    = focus:replace-selection-text("").
            end.
            else do:
               clipboard:value = focus:screen-value.
               focus:screen-value = "".
            end.
         end.
         else do: /* For FILL-IN */
            clipboard:value = focus:screen-value.
            focus:screen-value = "".
         end.

         END PROCEDURE.

         PROCEDURE p-choose-paste :
         /* -----------------------------------------------------------
          Purpose:     Action to take when Paste chosen from menu
          Parameters:  None
          Notes:       Moved to internal procedure to reduce segment size
         -------------------------------------------------------------*/
         if focus:type = "EDITOR":U then do:
            if focus:selection-start <> focus:selection-end then
               local-result = focus:replace-selection-text(clipboard:value).
            else
               local-result = focus:insert-string(clipboard:value).
         end.
         else /* For FILL-IN */
            focus:screen-value = clipboard:value.

         END PROCEDURE.

         PROCEDURE p-edit-bar-ptr-drop :
         /* -----------------------------------------------------------
          Purpose:     Sets the sensitivity of each menu item depending
                       on focus and type in the Edit Bar
          Parameters:  None
          Notes:       Moved to internal procedure to reduce segment size
         -------------------------------------------------------------*/
         if focus = ? then do:
            menu-item edit-cut-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-copy-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-paste-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-image-ptr:sensitive in menu edit-bar-ptr = false.
            return no-apply.
         end.
         if focus:type = "EDITOR":U then do:
            menu-item edit-cut-ptr:sensitive in menu edit-bar-ptr =
               (length(focus:selection-text) > 0).
            menu-item edit-copy-ptr:sensitive in menu edit-bar-ptr =
               (length(focus:selection-text) > 0).
            menu-item edit-paste-ptr:sensitive in menu edit-bar-ptr =
               (clipboard:num-formats > 0).
            menu-item edit-image-ptr:sensitive in menu edit-bar-ptr = false.
         end.
         else if focus:type = "RADIO-SET":U      OR
                 focus:type = "SELECTION-LIST":U OR
                 focus:type = "SLIDER":U         OR
                 focus:type = "TOGGLE-BOX":U then do:
            menu-item edit-cut-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-copy-ptr:sensitive in menu edit-bar-ptr = true.
            menu-item edit-paste-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-image-ptr:sensitive in menu edit-bar-ptr = false.
         end.
         else if focus:type = "FILL-IN":U OR
                 focus:type = "TEXT_GROUP":U then do:
            menu-item edit-cut-ptr:sensitive in menu edit-bar-ptr =
               (length(focus:screen-value) > 0).
            menu-item edit-copy-ptr:sensitive in menu edit-bar-ptr =
               (length(focus:screen-value) > 0).
            menu-item edit-paste-ptr:sensitive in menu edit-bar-ptr =
               (clipboard:num-formats > 0).
            menu-item edit-image-ptr:sensitive in menu edit-bar-ptr =
               true.
         end.
         else do:
            menu-item edit-cut-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-copy-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-paste-ptr:sensitive in menu edit-bar-ptr = false.
            menu-item edit-image-ptr:sensitive in menu edit-bar-ptr = false.
         end.

         END PROCEDURE.

         PROCEDURE p-options-bar-ptr-drop :
         /* -----------------------------------------------------------
          Purpose:     Sets the sensitivity of each menu item depending
                       on focus and type in the Options Menu
          Parameters:  None
          Notes:       Moved to internal procedure to reduce segment size
         -------------------------------------------------------------*/
         assign
            menu-item options-tool-bar-ptr:checked in menu options-bar-ptr =
               global-tool-bar
            menu-item options-drop-downs-ptr:checked in menu options-bar-ptr =
               global-drop-downs
            menu-item options-menu-subs-ptr:checked in menu options-bar-ptr =
               global-menu-substitution.

         END PROCEDURE.

*/
