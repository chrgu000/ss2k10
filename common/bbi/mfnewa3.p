/* mfnewa3.p - Menu Style A Driver (Icons)                              */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.23.2.2 $                                                    */

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/
/*!
   NOTE: This program program was changed from .w to .p in 8.5 because
     it cannot be maintained through the UIB
*/
/******************************** History *******************************/
/* REVISION: 8.3      Last MODIFIED: 02/12/95   By: gui                 */
/* REVISION: 8.3      Last MODIFIED: 03/28/95   By: aed                 */
/* REVISION: 8.3      Last MODIFIED: 05/17/95   By: aed                 */
/* REVISION: 8.5      Last MODIFIED: 03/01/96   BY: jpm  /*J0CF*/       */
/* REVISION: 8.3      LAST MODIFIED: 04/05/96   by: qzl  /*G1SH*/       */
/* REVISION: 8.3      LAST MODIFIED: 05/20/96   by: rkc  /*G1VJ*/       */
/* REVISION: 8.5      LAST MODIFIED: 07/08/96   by: jpm  /*J0XT*/       */
/* REVISION: 8.5      LAST MODIFIED: 09/05/97   by: jpm  /*J20F*/       */
/* REVISION: 8.5      LAST MODIFIED: 09/26/97   by: vrp  /*J21V*/       */
/* REVISION: 8.5      LAST MODIFIED: 12/17/97   by: vrp  /*G2QL*/       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* Revision: 8.6E     Last Modified: 05/08/98   BY: *J2JB* Suhas Bhargave*/
/* Revision: 8.6e     Last Modified: 07/31/98   BY: *H1MQ* Vijaya Pakala*/
/* Revision: 8.6E     Last Modified: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 12/17/98   by: *J378* A. Philips   */
/* REVISION: 9.1      LAST MODIFIED: 03/15/00   by: *N08T* D.Taylor     */
/* REVISION: 9.1      LAST MODIFIED: 04/10/00   by: *J3PD* Raphael T    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   by: *N0KR* myb          */
/* Old ECO marker removed, but no ECO header exists *G1MP*              */
/* Revision: 1.20     BY: John Corda         DATE: 09/06/01 ECO: *M1KB* */
/* Revision: 1.21     BY: Katie Hilbert      DATE: 01/31/03 ECO: *P0MJ* */
/* Revision: 1.22     BY: Neil Curzon        DATE: 08/07/03 ECO: *Q01T* */
/* Revision: 1.23     BY: Shoma Salgaonkar   DATE: 01/04/05 ECO: *Q0G6* */
/* $Revision: 1.23.2.2 $    BY: Meng Ge           DATE: 07/06/07 ECO: *Q178* */
/************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitl1.i}
{mfdtitl2.i}
{mf1.i}
{mfgmenu.i}

/* OBSOLETED IN MFDTITL1.I BUT REQD IN MENU PGM */
run P-ADD-WINDOW in global-drop-down-utilities
   (input execname, input current-window).

&SCOPED-DEFINE window-name   WINDOW-1
&GLOBAL-define max-levels 4
&GLOBAL-define ellipsis ...
&GLOBAL-define enabled-connector -
&GLOBAL-define disabled-connector x

define variable menu-level as integer initial 0 no-undo.
define variable current-menu-nbr    like mnd_det.mnd_nbr no-undo.
define variable current-menu-select like mnd_det.mnd_select no-undo.
define variable signon-flg as logical no-undo.
define shared variable menu_log as decimal.
define variable h_mfinitpl as handle no-undo.

/* KEEP HACKERS OUT OF EXPIRED DEMOS */
if menu_log <> 55702683.14
then
   quit.

menu = "".

/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window */
define variable WINDOW-1 as widget-handle no-undo.

/* Definitions of the field level widgets */
define button sub-menu-1
   image-up file "main"
   label ""
   size 5.43 by 1.58.

define button sub-menu-2
   image-up file "sub1"
   image-insensitive file "sub1h"
   label ""
   size 5.43 by 1.58.

define button sub-menu-3
   image-up file "sub2"
   image-insensitive file "sub2h"
   label ""
   size 5.43 by 1.58.

define button sub-menu-4
   image-up file "sub3"
   image-insensitive file "sub3h"
   label ""
   size 5.43 by 1.58.

define button sub-menu-5
   image-up file "sub4"
   image-insensitive file "sub4h"
   label ""
   size 5.43 by 1.58.

define button sub-menu-6
   image-up file "sub5"
   image-insensitive file "sub5h"
   label ""
   size 5.43 by 1.58.

define variable sub-menu-text-1 as character format "X(18)"
   view-as text
   size 16.43 by 1
   font 1 no-undo.

define variable sub-menu-text-2 as character format "X(50)"
   view-as text
   size 32 by 1
   font 1 no-undo.

define variable sub-menu-text-3 as character format "X(50)"
   view-as text
   size 32 by 1
   font 1 no-undo.

define variable sub-menu-text-4 as character format "X(50)"
   view-as text
   size 32 by 1
   font 1 no-undo.

define variable sub-menu-text-5 as character format "X(50)"
   view-as text
   size 32 by 1
   font 1 no-undo.

define variable sub-menu-text-6 as character format "X(50)"
   view-as text
   size 32 by 1
   font 1 no-undo.

define button button-custom
   image-up file "custom"
   font 1
   size-pixels 115 by 44.

define button button-dist
   image-up file "drp"
   font 1
   size-pixels 115 by 44.

define button button-exit
   label "E&xit":L
   font 1
   size 12 by 1.

define button button-fin
   image-up file "finan"
   font 1
   size-pixels 115 by 44.

define button button-fs
   image-up file "field"
   font 1
   size-pixels 115 by 44.

define button button-mfg
   image-up file "fact"
   font 1
   size-pixels 115 by 44.

define button button-sc
   image-up file "chain"
   font 1
   size-pixels 115 by 44.

define button button-signon
   label "&Sign On":L
   font 1
   size 12 by 1.

define button button-sys
   image-up file "sys"
   label "Master Files":L
   font 1
   size-pixels 115 by 44.

define variable menu-list as character
   view-as selection-list single scrollbar-vertical
   size 37 by 12.38
   bgcolor 15
   fgcolor 0
   font 20 no-undo.

define variable Menu-title as character format "X(32)"
   view-as text
   size 35.43 by .67
   font 1 no-undo.

define rectangle RECT-1
   edge-pixels 2 graphic-edge no-fill
   size 37 by 1.

define variable text-custom as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

define variable text-dist as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

define variable text-fin as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

define variable text-fs as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

define variable text-mfg as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

define variable text-sc as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

define variable text-sys as character format "X(17)"
   view-as text
   size 17 by 1 no-undo.

/* ************************  Frame Definitions  *********************** */

&SCOPED-DEFINE frame-name sub-menu-frame

define frame sub-menu-frame
   sub-menu-1      at row 2    COLUMN 2 NO-LABEL
   sub-menu-text-1 at row 2.1  COLUMN 8 NO-LABEL
   sub-menu-2      at row 4.5  COLUMN 2 NO-LABEL
   sub-menu-text-2 at row 4.6  COLUMN 8 NO-LABEL
   sub-menu-3      at row 7    COLUMN 2 NO-LABEL
   sub-menu-text-3 at row 7.1  COLUMN 8 NO-LABEL
   sub-menu-4      at row 9.5  COLUMN 2 NO-LABEL
   sub-menu-text-4 at row 9.6  COLUMN 8 NO-LABEL
   sub-menu-5      at row 12   COLUMN 2 NO-LABEL
   sub-menu-text-5 at row 12.1 COLUMN 8 NO-LABEL
   sub-menu-6      at row 14.5 COLUMN 2 NO-LABEL
   sub-menu-text-6 at row 14.6 COLUMN 8 NO-LABEL
with 1 down no-box side-labels overlay
   at COLUMN 1 row 1
   size 40 by 17
   bgcolor 8 .

define frame main-frame
   BUTTON-dist   at row 1.8  COLUMN 3  NO-LABEL
   BUTTON-sys    at row 1.8  COLUMN 23 NO-LABEL
   text-dist     at row 4.1  COLUMN 3  NO-LABEL font 1
   text-sys      at row 4.1  COLUMN 23 NO-LABEL font 1
   BUTTON-mfg    at row 6.0  COLUMN 3  NO-LABEL
   BUTTON-custom at row 6.0  COLUMN 23 NO-LABEL
   text-mfg      at row 8.3  COLUMN 3  NO-LABEL font 1
   text-custom   at row 8.3  COLUMN 23 NO-LABEL font 1
   BUTTON-fin    at row 10.2 COLUMN 3  NO-LABEL
   BUTTON-sc     at row 10.2 COLUMN 23 NO-LABEL
   text-fin      at row 12.5 COLUMN 3  NO-LABEL font 1
   text-sc       at row 12.5 COLUMN 23 NO-LABEL font 1
   BUTTON-fs     at row 14.4 COLUMN 3  NO-LABEL
   text-fs       at row 16.7 COLUMN 3  NO-LABEL font 1
with 1 down no-box side-labels no-underline overlay
   at COLUMN 1 row 1
   size 40 by 17
   bgcolor 8 .

/* NO EXTERNALIZATION NECESSARY ON FRAME MAIN-FRAME */
/* LABELS ALREADY TRANSLATED.                       */

define frame list-frame
   RECT-1        at row 1.2 COLUMN 3
   Menu-title    at row 1.33 COLUMN 3.2 NO-LABEL
   menu-list     at row 2.08 COLUMN 3 NO-LABEL
   button-signon at row 16.5 COLUMN 13
   BUTTON-exit   at row 16.5 COLUMN 27
with 1 down no-box side-labels no-underline
   at COLUMN 41 row 1
   size 40 by 17
   bgcolor 8
   three-d
   .

/* SET EXTERNALIZED LABELS. */
setFrameLabels(frame list-frame:handle).

/***************** OBLIGATIONS FOR MFGMENU.I *****************/

run create-current-selection
   (input frame list-frame:HANDLE).
run OverrideRedrawMenus
   (input yes).
run OverrideReturnPreprocess
   (input yes).
run OverrideRunMenu
   (input yes).
run OverrideRunPostProcess
   (input yes).
run relabel-cselection
   (input getTermLabel("&MENU_SELECTION",15) + ": ").

run rc-place-cselection
   (input 15,
    input menu-list:COLUMN in frame list-frame + (menu-list:WIDTH-CHARS / 2)).

/* LOAD THE INITIALIZATION PROCEDURE LIBRARY */
run mfinitpl.p persistent set h_mfinitpl.

/*************** END OBLIGATIONS FOR MFGMENU.I **************/

WINDOW-1 = current-window.

/* ***************  Runtime Attributes and UIB Settings  ************** */

assign
   sub-menu-1:HIDDEN in frame sub-menu-frame           = true
   sub-menu-2:HIDDEN in frame sub-menu-frame           = true
   sub-menu-3:HIDDEN in frame sub-menu-frame           = true
   sub-menu-4:HIDDEN in frame sub-menu-frame           = true
   sub-menu-5:HIDDEN in frame sub-menu-frame           = true
   sub-menu-6:HIDDEN in frame sub-menu-frame           = true
   .

/* ************************  Control Triggers  ************************ */

on choose of sub-menu-1 in frame sub-menu-frame /* 99 */
do:
   run reset-menu-list.
   return no-apply.
end.

on choose of sub-menu-2 in frame sub-menu-frame /* 99 */
do:
   run reset-menu-list.
   return no-apply.
end.

on choose of sub-menu-3 in frame sub-menu-frame /* 99 */
do:
   run reset-menu-list.
   return no-apply.
end.

on choose of sub-menu-4 in frame sub-menu-frame /* 99 */
do:
   run reset-menu-list.
   return no-apply.
end.

on choose of sub-menu-5 in frame sub-menu-frame /* 99 */
do:
   run reset-menu-list.
   return no-apply.
end.

on choose of sub-menu-6 in frame sub-menu-frame /* 99 */
do:
   run reset-menu-list.
   return no-apply.
end.

&SCOPED-DEFINE frame-name main-frame

on choose of button-custom in frame main-frame /* Custom */
do:
   run set-main-menu-list.
end.

on choose of button-dist in frame main-frame /* Distribution */
do:
   run set-main-menu-list.
end.

on choose of button-exit in frame list-frame /* Exit */
do:
   define variable do-exit as logical no-undo.
   run declare-Exiting (output do-exit).

   if not do-exit
   then
      return no-apply.
end.

on choose of button-signon in frame list-frame /* Signon */
do:
   signon-flg = true.
   pause 0 no-message.
end.

on choose of button-fin in frame main-frame /* Financial */
do:
   run set-main-menu-list.
end.

on choose of button-fs in frame main-frame /* Field Service */
do:
   run set-main-menu-list.
end.

on choose of button-mfg in frame main-frame /* Manufacturing */
do:
   run set-main-menu-list.
end.

on choose of button-sc in frame main-frame /* Supply Chain */
do:
   run set-main-menu-list.
end.

on choose of button-sys in frame main-frame /* System */
do:
   run set-main-menu-list.
end.

on VALUE-CHANGED of menu-list in frame list-frame
do:
   run p-set-cselection.
end.

on DEFAULT-ACTION of menu-list in frame list-frame
do:
   run p-set-cselection.
   run p-run-program
      (input cselection:SCREEN-VALUE).
   return no-apply.
end.

/* ***************************  Main Block  *************************** */

/* Send messages to alert boxes because there is no message area. */
assign
   current-window             = {&WINDOW-NAME}
   SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = no).

/* Best default for GUI applications is... */
pause 0.

run set-main-menu.

on choose of exit-item-ptr or
   window-close of {&WINDOW-NAME}
do:
   define variable do-exit as logical no-undo.
   apply "CHOOSE" to button-exit in frame list-frame.

   if not do-exit
   then
      return no-apply.
end.

on ALT-M anywhere
do:
   run Apply-cselection-event (input "ENTRY").
end.

on ALT-X anywhere
do:
   apply "CHOOSE" to button-exit in frame list-frame.
end.

on ALT-S anywhere
do:
   apply "CHOOSE" to button-signon in frame list-frame.
end.

run p-get-company-name.

current-window:title = return-value.

/* Now enable the interface and wait for the exit condition. */

run enable_UI.

{gprun.i 'gpcursor.p' "('')"}

run Apply-cselection-event (input "ENTRY").

/* WAIT-BLOCK: */
do on error undo, retry on endkey undo, retry:
   if retry then do:
      run p-pop-menu-level.

      if return-value = "LEAVE"
      then
         leave.
   end.

   if global_timeout_min > 0
   then do:
      wait-for WINDOW-CLOSE of {&WINDOW-NAME} or choose of
         button-exit in frame list-frame, exit-item-ptr,
         button-signon
         pause (global_timeout_min * 60).

      if lastkey = -1 and global_timeout_min > 0
      then do:
         if signon-flg
         then do:
            pause 0 no-message.
            run disable_UI.
            leave.
         end.
         else do:
            pause 0 no-message.
            run disable_UI.
            global-exiting = yes.
         end.
      end.
   end.
   else do:
      wait-for WINDOW-CLOSE of {&WINDOW-NAME} or choose of
         button-exit in frame list-frame, exit-item-ptr,
         button-signon.
   end. 
end.


run disable_UI.

/* **********************  Internal Procedures  *********************** */

PROCEDURE p-pop-menu-level:
   /* -----------------------------------------------------------
      Purpose:     Find lowest-level menu button that's sensitive
                   and push it
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/

   if frame main-frame:VISIBLE
   then
      return "LEAVE".
   else if sub-menu-6:SENSITIVE in frame sub-menu-frame
   then
      apply "CHOOSE" to sub-menu-6.
   else if sub-menu-5:SENSITIVE in frame sub-menu-frame
   then
      apply "CHOOSE" to sub-menu-5.
   else if sub-menu-4:SENSITIVE in frame sub-menu-frame
   then
      apply "CHOOSE" to sub-menu-4.
   else if sub-menu-3:SENSITIVE in frame sub-menu-frame
   then
      apply "CHOOSE" to sub-menu-3.
   else if sub-menu-2:SENSITIVE in frame sub-menu-frame
   then
      apply "CHOOSE" to sub-menu-2.
   else if sub-menu-1:SENSITIVE in frame sub-menu-frame
   then
      apply "CHOOSE" to sub-menu-1.

   return "".
END PROCEDURE.

PROCEDURE enable_UI:
   /* -----------------------------------------------------------
      Purpose:     Enable the User Interface
      Parameters:  <none>
      Notes:       Here we display/view/enable the widgets in the
                   user-interface.  The statements here are based
                   on the "Default Enabling" section of the widget
                   Property Sheets.
   -------------------------------------------------------------*/
   define variable restored as logical initial false no-undo.

   {gprun.i ""gpfontsz.p""
      "(frame sub-menu-frame:HANDLE, yes, yes, """all""", yes)"}

   {gprun.i ""gpfontsz.p""
      "(frame main-frame:HANDLE, yes, yes, """all""", yes)"}

   {gprun.i ""gpfontsz.p""
      "(frame list-frame:HANDLE, yes, yes, """all""", yes)"}

   if global-menuinfo <> ""
   then
      run restore-menus (OUTPUT restored).

   if not restored  /* For one reason or another, display main menu */
   then
      run enable-main-frame.

   enable
      menu-list
      button-signon
      button-exit
      with frame list-frame.

   run setBaseCurrencyEntity in h_mfinitpl.

   view WINDOW-1.

END PROCEDURE.

PROCEDURE enable-main-frame:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/

   display
      text-dist
      text-sys
      text-mfg
      text-custom
      text-fin
      text-sc
      text-fs
   with frame main-frame.

   enable
      button-dist
      button-sys
      button-mfg
      button-custom
      button-fin
      button-sc
      button-fs
   with frame main-frame.

END PROCEDURE.

PROCEDURE get-main-handle:
   /* -----------------------------------------------------------
      Purpose:     Get the handle of the main menu button pointed
                   to by menu number
      Parameters:  menu-select = Menu selection number from main menu.
                   main-menu-handle = Handle to main menu button.
      Notes:
   -------------------------------------------------------------*/
   define input  parameter menu-select like mnd_det.mnd_select NO-UNDO.
   define output parameter main-menu-handle as widget-handle NO-UNDO.

   CASE menu-select:
      when (1) then
         main-menu-handle = button-dist:HANDLE in frame main-frame.
      when (2) then
         main-menu-handle = button-mfg:HANDLE in frame main-frame.
      when (3) then
         main-menu-handle = button-fin:HANDLE in frame main-frame.
      when (4) then
         main-menu-handle = button-fs:HANDLE in frame main-frame.
      when (5) then
         main-menu-handle = button-sys:HANDLE in frame main-frame.
      when (6) then
         main-menu-handle = button-custom:HANDLE in frame main-frame.
      when (7) then
         main-menu-handle = button-sc:HANDLE in frame main-frame.
      otherwise
         main-menu-handle = ?.
   END CASE.

END PROCEDURE.

PROCEDURE disable_UI:
   /* -----------------------------------------------------------
      Purpose:     DISABLE the User Interface
      Parameters:  <none>
      Notes:       Here we clean-up the user-interface by deleting
                   dynamic widgets we have created and/or hide
                   frames.  This procedure is usually called
                   we are ready to "clean-up" after running.
   ------------------------------------------------------------ */

   run save-menus.

   hide frame main-frame.
   hide frame sub-menu-frame.
   hide frame list-frame.

END PROCEDURE.

PROCEDURE set-menu-list:
   /* -----------------------------------------------------------
      Purpose:     Set menu selection list
      Parameters:  menu-nbr = Value of mnd-nbr for which to display
                              menu.
                   menu-select = value of mnd-select for which to
                                 display menu.
      Notes:
   -------------------------------------------------------------*/
   define input parameter menu-nbr    like mnd_det.mnd_nbr no-undo.
   define input parameter menu-select like mnd_det.mnd_select no-undo.

   assign
      current-menu-nbr = menu-nbr
      current-menu-select = menu-select.

   run drawMenu.

END PROCEDURE.

PROCEDURE reset-menu-list:
   /* -----------------------------------------------------------
      Purpose:     Reset menus as a result of a submenu button choose
      Parameters:  self handle.
      Notes:
   -------------------------------------------------------------*/
   define variable menu-nbr    like mnd_det.mnd_nbr no-undo.
   define variable menu-select like mnd_det.mnd_select no-undo.
   define variable level-idx   as integer no-undo.
   define variable temp-result as logical no-undo.
   define variable sub-menu-handle  as widget-handle no-undo.
   define variable main-menu-handle as widget-handle no-undo.
   define variable menu-title-ptr   as widget-handle no-undo.
   define variable button-ptr       as widget-handle no-undo.
   define variable text-ptr         as widget-handle no-undo.

   {gprun.i 'gpcursor.p' "('wait')"}

   assign
      sub-menu-handle = self
      menu-level = integer(entry(1, sub-menu-handle:PRIVATE-DATA)) - 1
      menu-nbr = entry(2, sub-menu-handle:PRIVATE-DATA)
      menu-select = integer(entry(3, sub-menu-handle:PRIVATE-DATA)).

   repeat level-idx = menu-level + 1 to
      {&max-levels} + 1 with frame sub-menu-frame:

      CASE level-idx:
         when (0)
         then do:
            assign
               button-ptr = sub-menu-1:HANDLE
               text-ptr = sub-menu-text-1:HANDLE.

            run enable-main-frame.
            run get-main-handle
               (input 1,
                output main-menu-handle).

            if main-menu-handle <> ?
            then
               apply "ENTRY" to main-menu-handle.

            assign
               frame sub-menu-frame:SENSITIVE = false
               menu = ""        /* Set global to null */
               menu-title-ptr = menu-title:HANDLE in frame list-frame
               menu-title-ptr:PRIVATE-DATA = "".
         end.
         when (1)
         then do:
            assign
               button-ptr = sub-menu-2:HANDLE
               text-ptr = sub-menu-text-2:HANDLE.

            run enable-main-frame.

            assign
               frame sub-menu-frame:SENSITIVE = no
               temp-result = frame sub-menu-frame:move-to-bottom().

            run get-main-handle
               (input menu-select,
                output main-menu-handle).

            if main-menu-handle <> ?
            then
               apply "ENTRY" to main-menu-handle.

            frame main-frame:VISIBLE = yes.
         end.
         when (2) then
            assign
               button-ptr = sub-menu-3:HANDLE
               text-ptr = sub-menu-text-3:HANDLE.
         when (3) then
            assign
               button-ptr = sub-menu-4:HANDLE
               text-ptr = sub-menu-text-4:HANDLE.
         when (4) then
            assign
               button-ptr = sub-menu-5:HANDLE
               text-ptr = sub-menu-text-5:HANDLE.
         when (5) then
            assign
               button-ptr = sub-menu-6:HANDLE
               text-ptr = sub-menu-text-6:HANDLE.
         otherwise
            assign
               button-ptr = ?
               text-ptr = ?.
      END CASE.

      if button-ptr <> ?
      then
         if level-idx = menu-level + 1
         then
            button-ptr:SENSITIVE = false.
         else
            assign button-ptr:HIDDEN = true.

      if text-ptr <> ? and
         level-idx > menu-level + 1
      then
         text-ptr:SCREEN-VALUE = "".
   end.

   menu-level = maximum(menu-level, 0).

   run set-menu-list
      (input menu-nbr,
       input menu-select).

   run update-cselection (input "").

   run Apply-cselection-event (input "ENTRY").

   {gprun.i 'gpcursor.p' "('')"}

END PROCEDURE.

PROCEDURE set-main-menu-list:
   /* -----------------------------------------------------------
      Purpose:     Set the mainmenu selection list parameters
      Parameters:
      Notes:
   -------------------------------------------------------------*/
   define variable menu-select like mnd_det.mnd_select no-undo.

   {gprun.i 'gpcursor.p' "('wait')"}

   menu-select = integer(entry(3, self:PRIVATE-DATA)).

   run set-menu-list
      (input "A",
       input menu-select).

   {gprun.i 'gpcursor.p' "('')"}

END PROCEDURE.

PROCEDURE set-main-menu:
   /* -----------------------------------------------------------
      Purpose:     Set main menu bar w/only user menu selections
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/

   {gprun.i ""gpns2lbl.p"" "("""A""", 1)"}

   assign
      text-dist = if return-value <> "" then return-value else "Distribution"
      button-dist:PRIVATE-DATA in frame main-frame = text-dist + ",drp" + ",1".

   {gprun.i ""gpns2lbl.p"" "("""A""", 2)"}

   assign
      text-mfg = if return-value <> "" then return-value else "Manufacturing"
      button-mfg:PRIVATE-DATA in frame main-frame = text-mfg + ",fact" + ",2".

   {gprun.i ""gpns2lbl.p"" "("""A""", 3)"}

   assign
      text-fin = if return-value <> "" then return-value else "Financial"
      button-fin:PRIVATE-DATA in frame main-frame = text-fin + ",finan" + ",3".

   {gprun.i ""gpns2lbl.p"" "("""A""", 4)"}

   assign
      text-fs = if return-value <> "" then return-value else "Field Service"
      button-fs:PRIVATE-DATA in frame main-frame = text-fs + ",field" + ",4".

   {gprun.i ""gpns2lbl.p"" "("""A""", 5)"}

   assign
      text-sys = if return-value <> "" then return-value else "Master Files"
      button-sys:PRIVATE-DATA in frame main-frame = text-sys + ",sys" + ",5".

   {gprun.i ""gpns2lbl.p"" "("""A""", 6)"}

   assign
      text-custom = if return-value <> "" then return-value else "Custom"
      button-custom:PRIVATE-DATA in frame main-frame = text-custom +
      ",custom" + ",6".

   {gprun.i ""gpns2lbl.p"" "("""A""", 7)"}

   assign
      text-sc = if return-value <> "" then return-value else "Supply Chain"
      button-sc:PRIVATE-DATA in frame main-frame = text-sc + ",chain" + ",7".

END PROCEDURE.

PROCEDURE restore-menus:
   /* -----------------------------------------------------------
      Purpose:     Process a triplet from global-menuinfo, where
                   a triplet is a null, a menu-level and a menu
                   id
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define output parameter menus-restored as logical initial false no-undo.

   define variable x-char as decimal   no-undo.
   define variable menuid as character no-undo.
   define variable i      as integer initial 1 no-undo.
   define variable menu-nbr    like mnd_det.mnd_nbr no-undo.
   define variable menu-select like mnd_det.mnd_select no-undo.

   assign
      x-char = decimal(entry(i, global-menuinfo))
      menu-level = integer(entry(i + 1, global-menuinfo))
      menuid = entry(i + 2, global-menuinfo).

      if menuid = ""
      then
         leave.

   run parse-menu-name
      (input menuid,
       output current-menu-nbr,
       output current-menu-select).

   if current-menu-nbr = "0" and
      current-menu-select = ?
   then do:
      menu-level = 0.
      leave.
   end.
   else do:
      /* If the menu bar saved in GUI database does not apply to or  */
      /* exist in current database, default screen will be displayed */

      for first mnd_det
         fields(mnd_canrun mnd_exec mnd_nbr mnd_select)
         no-lock
         where mnd_nbr = current-menu-nbr
         and   mnd_select = current-menu-select :
      end.

      can_do_menu = false.

      if available mnd_det
      then do:
         {gprun1.i ""mfsec.p""
            "(input mnd_det.mnd_nbr,
              input mnd_det.mnd_select,
              input false,       /* Don't display message */
              output can_do_menu)"
         }
      end.

      /* Either they have no permission or there is no mnd_det available */
      if not can_do_menu
      then do:
         menu-level = 0.
         leave.
      end.
   end.

   if current-menu-nbr = "A"
   then do:
      run enable-main-frame.
      run set-menu-list
         (current-menu-nbr,
          current-menu-select). /* Setup main */
   end.
   else
      run myRunMenu (input menuid).

   menus-restored = true.

END PROCEDURE.

PROCEDURE save-menus:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define variable menu-title-ptr as widget-handle no-undo.
   define variable menustr as character no-undo.

   menu-title-ptr = menu-title:HANDLE in frame list-frame.

   if menu-title:PRIVATE-DATA <> ""
   then
      menustr = entry(1, menu-title-ptr:PRIVATE-DATA) + "." +
                entry(2, menu-title-ptr:PRIVATE-DATA).

   global-menuinfo = "," +     /* Unused in this style */
                     string(menu-level) + "," + menustr.

END PROCEDURE.

PROCEDURE p-set-cselection:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define variable menu-list-input as character no-undo.
   define variable tmpstr          as character no-undo.
   define variable menu-select like mnd_det.mnd_select no-undo.
   define variable menu-nbr    like mnd_det.mnd_nbr no-undo.
   define variable temp as integer no-undo.
   define variable menu-title-ptr as widget-handle no-undo.

   assign
      menu-list-input = input frame list-frame menu-list
      menu-title-ptr = menu-title:HANDLE in frame list-frame
      menu-select = integer(substring(menu-list-input,1,2))
      menu-nbr = entry(1,menu-title-ptr:PRIVATE-DATA) + "."
      + entry(2,menu-title-ptr:PRIVATE-DATA).

   run update-cselection
      (input string(menu-select)).

END PROCEDURE.

PROCEDURE myReturnPreprocess:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define variable menu-list-input as character no-undo.
   define variable menu-title-ptr as widget-handle no-undo.

   assign
      menu-title-ptr = menu-title:HANDLE in frame list-frame
      menu = entry(1,menu-title-ptr:PRIVATE-DATA) + "."
           + entry(2,menu-title-ptr:PRIVATE-DATA) no-error.

   if menu = ?
   then
      menu = "".

   run cleanup-menu-name (input-output menu).
END PROCEDURE.

PROCEDURE myRunPostProcess:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/

   if menu-level > 0
   then do:
      assign
         frame main-frame:VISIBLE = no
         frame sub-menu-frame:VISIBLE = yes
         frame sub-menu-frame:SENSITIVE = yes.
      apply "ENTRY" to frame sub-menu-frame.
   end.

   run update-cselection (input "").

END PROCEDURE.

PROCEDURE myRunMenu:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define input parameter menu-name as character no-undo.

   run cleanup-menu-name
      (input-output menu-name).

   run parse-menu-name
      (input menu-name,
       output current-menu-nbr,
       output current-menu-select).

   run paintSubMenuFrame
      (input menu-name).

   run drawMenu.

   run update-cselection (input "").

END PROCEDURE.

PROCEDURE paintSubMenuFrame:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  theMenu (fully qualified menu spec)
      Notes:
   -------------------------------------------------------------*/
   define input parameter theMenu as character no-undo.

   define variable tempstr         as character no-undo.
   define variable theAbbrMenu     as character no-undo.
   define variable lastperiod      as integer no-undo.
   define variable periods         as integer no-undo.
   define variable levels-on-panel as integer no-undo.
   define variable menu-nbr        like mnd_det.mnd_nbr no-undo.
   define variable menu-select     like mnd_det.mnd_select no-undo.
   define variable dbg-log         as logical no-undo.

   run analyze-menu-name
      (input theMenu,
       output lastperiod,
       output periods).

   levels-on-panel = periods + 2.

   run initSubMenuFrame
      (input levels-on-panel).

   do with frame sub-menu-frame:
      /* Level 1 */
      run getAreaName
         (input theMenu,
          output tempstr,
          output theAbbrMenu).

      run parse-menu-name
         (input theAbbrMenu,
           output menu-nbr,
           output menu-select).

      assign
         sub-menu-text-2:SCREEN-VALUE = tempstr
         sub-menu-2:PRIVATE-DATA = "1," + menu-nbr + "," + string(menu-select).

      /* Level 2 */
      run lookupMenuLabel
         (input 2,
         input theMenu,
         output tempstr,
         output theAbbrMenu).

      assign
         sub-menu-text-3:SCREEN-VALUE = tempstr
         sub-menu-3:PRIVATE-DATA = "2,0," + theAbbrMenu.

      /* Level 3 */
      run lookupMenuLabel
         (input 3,
          input theMenu,
          output tempstr,
          output theAbbrMenu).

      run parse-menu-name
         (input theAbbrMenu,
          output menu-nbr,
          output menu-select).

      assign
         sub-menu-text-4:SCREEN-VALUE = tempstr
         sub-menu-4:PRIVATE-DATA = "3," + menu-nbr + "," + string(menu-select).

      /* Level 4 */
      run lookupMenuLabel
         (input 4,
          input theMenu,
          output tempstr,
          output theAbbrMenu).

      run parse-menu-name
         (input theAbbrMenu,
          output menu-nbr,
          output menu-select).

      assign
         sub-menu-text-5:SCREEN-VALUE = tempstr
         sub-menu-5:PRIVATE-DATA = "4," + menu-nbr + "," + string(menu-select).

      /* Level 5 */
      run lookupMenuLabel
         (input 5,
          input theMenu,
          output tempstr,
          output theAbbrMenu).

      run parse-menu-name
         (input theAbbrMenu,
          output menu-nbr,
          output menu-select).

      assign
         sub-menu-text-6:SCREEN-VALUE = tempstr
         sub-menu-6:PRIVATE-DATA = "5," + menu-nbr + "," + string(menu-select).
   end.
END PROCEDURE.

PROCEDURE getAreaName:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define input parameter  theMenu  as character no-undo.
   define output parameter theLabel as character no-undo.
   define output parameter abbrMenu as character no-undo.

   define variable ix as integer no-undo.
   define variable menu-nbr like mnd_det.mnd_nbr no-undo.

   ix = index(theMenu, ".", 1).
   if ix > 0
   then
      abbrMenu = substring(theMenu, 1, ix - 1).
   else
      abbrMenu = theMenu.

   for first mnd_det
      fields(mnd_canrun mnd_exec mnd_nbr mnd_select)
      where mnd_det.mnd_exec = abbrMenu
      and   mnd_det.mnd_nbr begins "A." no-lock:
   end.

   if available mnd_det
   then do:
      menu-nbr = mnd_det.mnd_nbr.

      for first mnd_det
         fields(mnd_canrun mnd_exec mnd_nbr mnd_select)
         where mnd_det.mnd_exec = menu-nbr
         and   mnd_det.mnd_nbr = "A" no-lock:
      end.

      if available mnd_det
      then do:
         abbrMenu = mnd_det.mnd_exec.

         {gprun.i ""gpns2lbl.p""
            "(mnd_det.mnd_nbr,
              mnd_det.mnd_select)"}

         theLabel = return-value.
      end.
   end.
END PROCEDURE.

PROCEDURE lookupMenuLabel:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define input  parameter theLevel as integer no-undo.
   define input  parameter theMenu  as character no-undo.
   define output parameter theLabel as character no-undo.
   define output parameter abbrMenu as character no-undo.

   define variable lastperiod as integer no-undo.
   define variable periods    as integer no-undo.
   define variable ix         as integer no-undo.
   define variable cnt        as integer no-undo.
   define variable startpos   as integer no-undo.

   run analyze-menu-name
      (input theMenu,
       output lastperiod,
       output periods).

   if theLevel > periods + 2
   then
      leave.

   if theLevel = periods + 2
   then
      abbrMenu = theMenu.
   else do:                    /* The hard way */
      assign
         startpos = 1
         cnt = 1.

      do while cnt < theLevel:
         assign
            ix = index(theMenu, ".", startpos)
            startpos = ix + 1
            cnt = cnt + 1.
      end.
      abbrMenu = substring(theMenu, 1, ix - 1).
   end.

   for first mnd_det
      fields(mnd_canrun mnd_exec mnd_nbr mnd_select)
      where mnd_det.mnd_exec = abbrMenu no-lock:
   end.

   if available mnd_det
   then do:
      {gprun.i ""gpns2lbl.p""
         "(mnd_det.mnd_nbr,
           mnd_det.mnd_select)"}

      theLabel = abbrMenu + " - " + return-value.
   end.
END PROCEDURE.

PROCEDURE initSubMenuFrame:
   /* -----------------------------------------------------------
      Purpose:
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define input parameter levelsShowing as integer no-undo.

   define variable temp-result as logical no-undo.

   assign
      frame main-frame:VISIBLE = false
      frame sub-menu-frame:VISIBLE = false.

   do with frame sub-menu-frame:
      /* Level 0 button is constant */
      assign
         sub-menu-1:HIDDEN = no
         sub-menu-1:SENSITIVE = yes
         sub-menu-1:PRIVATE-DATA = "0,0,0"
         sub-menu-text-1:SCREEN-VALUE = getTermLabel("MAIN_MENU",18)
         sub-menu-text-1:HIDDEN = no
         /* Level 1 button is semi-constant */
         sub-menu-2:HIDDEN = no
         sub-menu-2:SENSITIVE = yes
         sub-menu-text-2:SCREEN-VALUE = ""
         sub-menu-text-2:HIDDEN = no
         /* Level 2 button is semi-constant */
         sub-menu-3:HIDDEN = no
         sub-menu-3:SENSITIVE = levelsShowing > 2
         sub-menu-text-3:SCREEN-VALUE = ""
         sub-menu-text-3:HIDDEN = no
         /* Level 3 button is variable */
         sub-menu-4:HIDDEN = levelsShowing < 3
         sub-menu-4:SENSITIVE = levelsShowing > 3
         sub-menu-text-4:SCREEN-VALUE = ""
         sub-menu-text-4:HIDDEN = no
         /* Level 4 button is variable */
         sub-menu-5:HIDDEN = levelsShowing < 4
         sub-menu-5:SENSITIVE = levelsShowing > 4
         sub-menu-text-5:SCREEN-VALUE = ""
         sub-menu-text-5:HIDDEN = no
         /* Level 5 button is variable */
         sub-menu-6:HIDDEN = levelsShowing < 5
         sub-menu-6:SENSITIVE = levelsShowing > 5
         sub-menu-text-6:SCREEN-VALUE = ""
         sub-menu-text-6:HIDDEN = no.
   end.

   assign
      frame sub-menu-frame:VISIBLE = true
      frame sub-menu-frame:SENSITIVE  = true
      temp-result = frame sub-menu-frame:move-to-top().
END PROCEDURE.

PROCEDURE drawMenu:
   /* -----------------------------------------------------------
      Purpose:     Local Override for redrawing menus
      Parameters:  <none>
      Notes:
   -------------------------------------------------------------*/
   define variable menu-selection-list as character initial "" no-undo.
   define variable menu-exec-list      as character initial "" no-undo.
   define variable menu-exec   like mnd_det.mnd_exec no-undo.
   define variable menu-test   like mnd_det.mnd_exec no-undo.
   define variable theExec     like mnd_det.mnd_exec no-undo.
   define variable menu-label  as character no-undo.
   define variable theLabel    as character no-undo.
   define variable tmpstr      as character no-undo.
   define variable connector   as character no-undo.
   define variable temp        as integer no-undo.
   define variable title-width as integer no-undo.
   define variable rect-width  as integer no-undo.

   if (current-menu-nbr = "0" or current-menu-nbr = "") and
      current-menu-select = 0
   then do:
      assign
         menu-title:SCREEN-VALUE in frame list-frame = ""
         menu-title:PRIVATE-DATA in frame list-frame = ""
         menu-list:LIST-ITEMS in frame list-frame = ""
         menu-list:PRIVATE-DATA in frame list-frame = "".
   end.
   else do:
      if current-menu-nbr begins "A." and
         index(current-menu-nbr, ".", 3) > 0
      then do:
         temp = index(current-menu-nbr, ".", 3).

         if temp > 0    /* There is another "." to get rid of */
         then
            assign
               tmpstr = substring(current-menu-nbr, 1, temp)
               current-menu-nbr = replace(current-menu-nbr, tmpstr, "").
      end.

      for first mnd_det
         fields(mnd_canrun mnd_exec mnd_nbr mnd_select mnd_uri)
         no-lock
         where mnd_det.mnd_nbr = current-menu-nbr
         and   mnd_det.mnd_select = current-menu-select :
      end.

      if not available mnd_det
      then do:
         tmpstr = current-menu-nbr + "-" + string(current-menu-select).
         /* Menu not available */
         {pxmsg.i &MSGNUM=7725 &ERRORLEVEL=4 &MSGARG1=tmpstr}
         return.
      end.

      if available mnd_det and
         mnd_det.mnd_exec = "" and
         mnd_det.mnd_uri <> ""
      then do:
         /* Menu Option Only available thru App Shell */
         {pxmsg.i &MSGNUM=1621 &ERRORLEVEL=3}
         return.
      end.

      /* 1. shrink it down so that it is adjustable anywhere */
      assign
         menu-title:SCREEN-VALUE in frame list-frame = ""
         menu-title:width-pixels = 1.

      /* 2. calculate new metrics */
      {gprun.i ""gpns2lbl.p""
         "(mnd_det.mnd_nbr,
           mnd_det.mnd_select)"}

      assign
         title-width  = font-table:GET-TEXT-WIDTH-PIXELS(return-value, 1)
         rect-width   = rect-1:width-pixels in frame list-frame
         menu-title:x = rect-1:x in frame list-frame
                        + ((rect-width - title-width) / 2).

      /* 3. make it full-sized */
      assign
         menu-title:PRIVATE-DATA in frame list-frame = current-menu-nbr + ","
            + trim(string(current-menu-select,">9"))
         menu-title:width-pixels = MAX(title-width, 1)
         menu-title:SCREEN-VALUE in frame list-frame = return-value
         menu-title:HIDDEN in frame list-frame = false
         menu-exec = mnd_det.mnd_exec.

      for each mnd_det
         fields(mnd_canrun mnd_exec mnd_nbr mnd_select)
         no-lock
         where mnd_det.mnd_nbr = menu-exec
         and   mnd_det.mnd_exec <> ""
         break by mnd_det.mnd_nbr:

         {mfsec2.i
            &mndnbr=mnd_det.mnd_nbr
            &mndselect=mnd_det.mnd_select
            &show_message=false}

         if can_do_menu or not global-hide-menus
         then do:
            run p-get-menu-label
               (input mnd_det.mnd_nbr,
                input mnd_det.mnd_select,
                input mnd_det.mnd_exec,
                output theLabel,
                output theExec).

            if return-value = ""
            then
               next.

            assign
               menu-test = mnd_det.mnd_exec
               connector = if can_do_menu
                           then " {&ENABLED-CONNECTOR} "
                           else " {&DISABLED-CONNECTOR} "
               menu-label = string(mnd_det.mnd_select,">9")
                          + connector + replace(theLabel,"&","").

            if can-find(first mnd_det where mnd_det.mnd_nbr = menu-test)
            then
               substring(menu-label, length(menu-label) + 1) = " {&ellipsis}".

            if not first-of(mnd_det.mnd_nbr)
            then
               assign
                  menu-selection-list = menu-selection-list + ","
                  menu-exec-list      = menu-exec-list + ",".

            assign
               menu-selection-list = menu-selection-list + menu-label
               menu-exec-list      = menu-exec-list + theExec.
         end. /* if can_do_menu */
      end. /*for each */

      assign
         menu-list:LIST-ITEMS in frame list-frame = menu-selection-list
         menu-list:PRIVATE-DATA in frame list-frame = menu-exec-list.
   end.
END PROCEDURE.