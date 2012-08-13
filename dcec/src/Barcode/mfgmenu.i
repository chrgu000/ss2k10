/* mfgmenu.i - Windows Menus Include File                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.24 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
/*V8:RunMode=Windows                                                          */
/******************************** History *************************************/
/* Revision: 8.3      Last Modified: 05/10/94     By: aed                     */
/* Revision: 8.3      Last Modified: 03/28/95     By: aed                     */
/* Revision: 8.3      Last Modified: 04/04/95     By: aed                     */
/* Revision: 8.3      Last Modified: 05/17/95     By: aed                     */
/* Revision: 8.3      Last Modified: 01/11/96     By: qzl      /*G1JS*/       */
/* Revision: 8.3      Last Modified: 01/30/96     By: rkc      /*G1KY*/       */
/* Revision: 8.3      Last Modified: 02/07/96     By: qzl      /*G1MM*/       */
/* Revision: 8.5      Last Modified: 01/25/96     By: jpm      /*J0CF*/       */
/* Revision: 8.5      Last Modified: 05/06/96     By: jpm      /*J0LD*/       */
/* Revision: 8.5      last Modified: 06/19/96     BY: dxb      /*G1YC*/       */
/* Revision: 8.5      last Modified: 12/02/96     BY: taf      /*G2J9*/       */
/* Revision: 8.5      last Modified: 01/22/97     BY: dks      /*J1FS*/       */
/* Revision: 8.5      last Modified: 05/27/97     BY: dks      /*G2N4*/       */
/* Revision: 8.5      last Modified: 05/27/97     BY: dks      /*G2N5*/       */
/* Revision: 8.5      last Modified: 05/27/97     BY: dks      /*G2N6*/       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane        */
/* Revision: 8.6E     Last Modified: 05/07/98     BY: *J2JB* Suhas Bhargave   */
/* Revision: 8.6E     Last Modified: 05/13/98     By: *K1NM* Claudio Argote   */
/* REVISION: 8.6E     Last Modified: 02/23/00     By: *J3PC* Raphael T        */
/* REVISION: 9.1      LAST MODIFIED: 03/23/00     by: *N08T* D.Taylor         */
/* REVISION: 9.1      LAST MODIFIED: 05/17/00     BY: *M0LJ* Vihang Talwalkar */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00     BY: *N0KR* Mark Brown       */
/* Revision: 1.18       BY: Katie Hilbert        DATE: 04/06/01  ECO: *P008*  */
/* Revision: 1.22       BY: Jean Miller          DATE: 06/20/02  ECO: *P09H*  */
/* $Revision: 1.24 $    BY: Jean Miller          DATE: 06/25/02  ECO: *P08G*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/************************************************************************
USAGE NOTES FOR MFGMENU.I --

This file contains procedures, variable definitions and some "virtual"
methods.

To use mfgmenu.i, you must define or implement the following things:
    1) a procedure called drawMenu that takes NO arguments.  This procedure
        will be called from the procedure redrawMenus.  It should contain
        all the necessary information to draw the current menu view from
        the state of known variables.  This is used when the user toggles
        the Hide Menu Items selection of the Options menu.  Make sure you
        have called "OverrideRedrawMenus(yes)".

    2) a frame in which you would like to display the "Current Selection".
        This include file will create the Current Selection widget (along
        with some other stuff).  This is the field into which the user can
        type a menu specification, hit RETURN, and have the GUI menu driver
        act as if the user had mouse-clicked or alt-keyed the selection.

    3) after you have created the frame mentioned in note 1, you must call
        Create-Current-Selection and pass that frame's widget handle.  This
        provides the glue to the Current Selection widget.

    4) to keep the field in synch with what the user is doing with the mouse
        (for example, if the user clicks on a button which represents a sub-
        menu, the value of that submenu should be reflected in the Current
        Selection Widget) run the procedure "update-cselection" with the
        "stringized" version of the submenu (e.g. "5.5.3") as the parameter.

    5) when the user has selected an item to run, run the procedure
        "run-pgm" with two parameters (the program name (e.g. xxx.p) and
        the title that will go in the title bar).

    6) if you have any special handling of non-printable keystrokes that
        you want done in the Current Selection widget, you must provide a
        procedure called "myHandleAnyKey" that takes the widget's handle
        as a parameter.  Make sure that you indicate its
        existance by calling OverrideHandleAnyKey(yes).

    7) if you have any special handling of printable keystrokes that
        you want done in the Current Selection widget, you must provide a
        procedure called "myHandlePrintable" that takes the widget's handle
        as a parameter.  Make sure that you indicate its
        existance by calling OverrideHandlePrintable(yes).

    8) make sure you DECLARE(!) your overrides so that this include file can
        be able to use them.  You do this by calling the so-called "Override"
        procedures.  NOTE: these procedures can allow you to temporarily (or
        permanently turn off an override, too).

    9) If you want to move the Current Selection widget around before you show
        it, you can run "RC-place-cselection(input row, input col)".  If you
        want to use pixels you can use "XY-place-selection(input x-pix, input y-pix)".

    10) I'm looking forward to binding all mfsec.i calls here and all post-selection,
        pre-run processing, as well.

    11) If you want to apply events to the Current Selection widget, run the
        procedure "Apply-cselection-event(eventname)"

    12) When "return" is hit in the Current Selection widget, the contents of the
        widget are analysed and the results put in public variables which the
        using program can interrogate.

    13) Utility functions included in this file are:
        parse-menu-name(input menuname, output menu-nbr, output menu-select)
            This takes a menu name string and breaks it into two parts which
            the menu drivers need to construct menus.
        declare-exiting
            This simply sets a global shared variable to TRUE.  It is used
            by a higher level program to determine when/how to leave.

************************************************************************/

/* Setup for persistent procedure */
{gprunpdf.i "lvgenpl" "p" }

/* This is so we can redraw from mfdeclre.i */
menu-item options-menu-subs-ptr:private-data = "redrawMenus".

define shared variable menu as character.
define shared variable global-exiting as logical.
define variable user_excluded like mfc_logical no-undo.
define variable tmp_canrun  as character no-undo.
define variable can_do_menu as logical no-undo.
define variable issensitive as logical no-undo.
define variable group_indx  as integer no-undo.
define variable options-hide-menus-ptr    as widget-handle no-undo.
define variable options-save-settings-ptr as widget-handle no-undo.
define variable user-progress-edit        as widget-handle no-undo.
define variable cselection                as widget-handle no-undo.
define variable csellabel                 as widget-handle no-undo.

/* vertical distance between fill-in and label */
define variable label-delta-y as integer no-undo.
/* horiz distance from end of label to beg. of fill-in */
define variable label-delta-x as integer no-undo.

define variable OvRedrawMenus      as logical no-undo.
define variable OvHandlePrintable  as logical no-undo.
define variable OvHandleAnyKey     as logical no-undo.
define variable OvNullValue        as logical no-undo.
define variable OvReturnPreProcess as logical no-undo.
define variable OvRunPreProcess    as logical no-undo.
define variable OvRunPostProcess   as logical no-undo.
define variable OvRunMenu          as logical no-undo.

define variable return-save-state as logical no-undo.

/* INITIALIZE REPORT TRAILER USER ID. USED TO BE DONE IN mfmenu.p */
assign report_userid = global_userid.

create menu-item options-hide-menus-ptr
   assign
   toggle-box = yes
   parent     = sub-menu options-bar-ptr:handle
   label      = "Hide Menu Items"
   triggers:
      on choose, VALUE-CHANGED
         persistent run p-menu-hide-menus.
   end triggers.

do transaction:

   if not can-find (first qad_wkfl where
                          qad_key1 = global_userid and
                          qad_key2 = "save-set")
   then do:
      create qad_wkfl.
      assign
         qad_key1 = global_userid
         qad_key2 = "save-set"
         qad_key3 = "yes".
      global-save-settings = yes.
   end.

   else do:

      for first qad_wkfl
         fields(qad_key1 qad_key2 qad_key3)
         where qad_key1 = global_userid and
               qad_key2 = "save-set":
      end.

      if qad_key3 = "yes" then
         assign global-save-settings = yes.
      else
         assign global-save-settings = no.

   end.

end.

if global-save-settings then do:
   create menu-item options-save-settings-ptr
   assign
      toggle-box = yes
      parent     = sub-menu options-bar-ptr:handle
      label      = "Save Settings on Exit"
      checked    = yes
   triggers:
      on choose, VALUE-CHANGED
         persistent run p-menu-save-settings.
   end triggers.
end.

else do:
   create menu-item options-save-settings-ptr
   assign
      toggle-box = yes
      parent     = sub-menu options-bar-ptr:handle
      label      = "Save Settings on Exit"
      checked    = no
   triggers:
      on choose, VALUE-CHANGED
         persistent run p-menu-save-settings.
   end triggers.
end.

create menu-item temp-hand-ptr
assign
   subtype = "rule"
   parent  = sub-menu user-bar-ptr:handle.

run p-can-do-editor (output issensitive).

create menu-item user-progress-edit
assign
   parent      = sub-menu user-bar-ptr:handle
   label       = "Pro&gress Editor"
   sensitive   = issensitive
   accelerator = "ALT-G"
triggers:
   on choose do:
      return-save-state = session:data-entry-return.
      run value("adeedit\_proedit.r")("", "").
      assign
         session:data-entry-return = return-save-state.
   end.
end triggers.

assign
   options-hide-menus-ptr:checked = global-hide-menus
   options-save-settings-ptr:checked = global-save-settings.

/* WALK THE MENU TREE AND SET EXTERNALIZED LABELS BEFORE */
/* MENU IS SET TO CURRENT WINDOW AND VISUALIZED.         */
if valid-handle(menu menu-bar-ptr:handle) then do:
   setMenuLabels(menu menu-bar-ptr:handle).
   /* ASSIGN MENU BAR TO CURRENT WINDOW */
   assign current-window:menubar = menu menu-bar-ptr:handle.
end.

PROCEDURE p-menu-hide-menus:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

   global-hide-menus = self:checked.
   run redrawMenus.

END PROCEDURE.

PROCEDURE p-menu-save-settings:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

   assign global-save-settings = self:checked.

   do transaction:
      if not can-find (first qad_wkfl where
                             qad_key1 = global_userid and
                             qad_key2 = "save-set")

      then do:
         create qad_wkfl.
         assign
            qad_key1 = global_userid
            qad_key2 = "save-set"
            qad_key3 = string(global-save-settings).
      end.
      else do:

         for first qad_wkfl
            fields(qad_key1 qad_key2 qad_key3)
            where qad_key1 = global_userid and
                  qad_key2 = "save-set":
         end.

         if global-save-settings = yes then
            assign qad_key3 = "yes".
         else
            assign qad_key3 = "no".
      end.
   end.

END PROCEDURE.

PROCEDURE OverrideRedrawMenus:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvRedrawMenus = p-overriding.

END PROCEDURE.

PROCEDURE OverrideHandlePrintable:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvHandlePrintable = p-overriding.

END PROCEDURE.

PROCEDURE OverrideHandleAnyKey:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvHandleAnyKey = p-overriding.

END PROCEDURE.

PROCEDURE OverrideNullValue:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvNullValue = p-overriding.

END PROCEDURE.

PROCEDURE OverrideRunPreProcess:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvRunPreProcess = p-overriding.

END PROCEDURE.

PROCEDURE OverrideRunPostProcess:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvRunPostProcess = p-overriding.

END PROCEDURE.

PROCEDURE OverrideRunMenu:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvRunMenu = p-overriding.

END PROCEDURE.

PROCEDURE OverrideReturnPreProcess:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter p-overriding as logical no-undo.

   assign OvReturnPreprocess = p-overriding.

END PROCEDURE.

PROCEDURE HandlePrintable:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

   if OvHandlePrintable then do:
      run myHandlePrintable (input self).
      leave.
   end.

END PROCEDURE.

PROCEDURE HandleAnyKey:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

   if OvHandleAnyKey then
      run myHandleAnyKey (input self).
   else apply lastkey to self.
   return error.

END PROCEDURE.

PROCEDURE Handlereturn:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

   run p-run-program (input self:screen-value).
   return error.

END PROCEDURE.

PROCEDURE p-run-program:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter run-pgm-name   as character no-undo.

   define variable mn-pgm-name       as character no-undo.
   define variable mn-pgm-title      as character no-undo.
   define variable mn-passedSecurity as logical no-undo.
   define variable mn-isaprogram     as logical no-undo.

   assign mn-pgm-name = run-pgm-name.

   if OvReturnPreprocess then run myReturnPreprocess.

   {gprun.i 'gpusrpgm.p'
      "(input-output mn-pgm-name,
        output mn-pgm-title,
        output mn-passedSecurity,
        output mn-isaprogram)"}

   if mn-pgm-name = "" and OvNullValue then run myNullValue.

   if not mn-PassedSecurity then leave.
   if mn-isaprogram then do:

      assign
         batchrun = no.

      if OvRunPreProcess then do:
         run myRunPreProcess.        /* do user set-up */
      end.

      run run-pgm
         (input mn-pgm-name,
          input mn-pgm-title).

      /* Updates mon_mstr when a user goes to a menu screen */
      {gprunp.i "lvgenpl" "p" "setMonitorRecord"
         "(input ""MFG/PRO"",
           input global_userid,
           input mfguser,
           input program-name(1),
           input menu,
           input 0)" }

      if OvRunPostProcess then do:
         run myRunPostProcess.       /* do user clean-up */
      end.
      else do:
         run update-cselection
            (input "").               /* default action */
      end.

   end.

   /* Probably a menu, but could be blank */
   else do:
      if OvRunMenu then do:
         /* Updates mon_mstr when a user goes to a menu screen */
         {gprunp.i "lvgenpl" "p" "setMonitorRecord"
            "(input ""MFG/PRO"",
              input global_userid,
              input mfguser,
              input program-name(1),
              input mn-pgm-name,
              input 0)" }


         run myRunMenu (input mn-pgm-name).
      end.
   end.

END PROCEDURE.

PROCEDURE p-get-menu-label:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input  parameter  pmenu-nbr like mnd_nbr no-undo.
   define input  parameter  pmenu-selection like mnd_select no-undo.
   define input  parameter  pmenu-exec like mnd_exec no-undo.
   define output parameter pLabel as character no-undo.
   define output parameter pExec as character no-undo.

   /* Updates mon_mstr when a user goes to a menu screen */
   {gprunp.i "lvgenpl" "p" "setMonitorRecord"
      "(input ""MFG/PRO"",
        input global_userid,
        input mfguser,
        input program-name(1),
        input pmenu-nbr,
        input 0)" }

   {gprun.i ""gpns2lbl.p"" "(pmenu-nbr, pmenu-selection)"}

   if return-value = "" then return "".
   assign
      pLabel = return-value
      pExec = "".   /* initialize */

   if global-menu-substitution then do:
      if can-find(first mnds_det where mnds_exec = pmenu-exec) then do:

         for first mnds_det
               fields(mnds_exec mnds_exec_sub)
               where mnds_exec = pmenu-exec :
         end.

         assign pExec = mnds_exec_sub.
      end.
   end.

   if pExec = "" then
      assign pExec = pmenu-exec.

   /* THIS OK IS NEVER USED ON UI NO NEED TO TRANSLATE */

   return "OK".

END PROCEDURE.

PROCEDURE redrawMenus:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

   if OvRedrawMenus then
      run drawMenu.

END PROCEDURE.

PROCEDURE create-current-selection:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter frame-hdl as widget-handle no-undo.

   define variable initialprompt as character no-undo initial " ".
   define variable promptwidth   as integer   no-undo.

   assign
      promptwidth =
         font-table:get-text-width-pixels(initialprompt, frame-hdl:font).

   create text csellabel
   assign
      frame = frame-hdl
      format = "X(1)"
      font = frame-hdl:font
      width-pixels = promptwidth
      screen-value = initialprompt
      row = 1.2
      column = 1.5.

   create fill-in cselection
   assign
      side-label-handle = csellabel
      frame = frame-hdl
      format = "X(16)"
      name = "cselection"
      font = frame-hdl:font
      sensitive = yes
      bgcolor = 15
      row = 1
      x = promptwidth + 1
   triggers:
      on return persistent run HandleReturn.
      on F2 persistent run HandleReturn.
      on any-printable persistent run HandlePrintable.
   end triggers.
   .

   assign
      label-delta-y = csellabel:y - cselection:y
      label-delta-x = (cselection:x - csellabel:x) - csellabel:width-pixels.

END PROCEDURE.

PROCEDURE update-cselection:
/* -----------------------------------------------------------
   Purpose:     Update screen display widget that shows where
   we are in the menu treee
   Parameters:  newValue = new menu string to display
   Notes:
 -------------------------------------------------------------*/
   define input parameter newValue as character no-undo.

   assign cselection:screen-value = newValue.

END PROCEDURE.

PROCEDURE RC-place-cselection:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter theRow as decimal no-undo.
   define input parameter theCol as decimal no-undo.

   if theRow <> ? then
      assign cselection:row = theRow.
   if theCol <> ? then
      assign cselection:col = theCol.

   assign
      csellabel:y = cselection:y + label-delta-y
      csellabel:x = cselection:x - csellabel:width-pixels - label-delta-x.

END PROCEDURE.

PROCEDURE XY-place-cselection:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter theX as integer no-undo.
   define input parameter theY as integer no-undo.

   if theX <> ? then
      assign cselection:X = theX.
   if theY <> ? then
      assign cselection:Y = theY.

   assign
      csellabel:y = cselection:y + label-delta-y
      csellabel:x = cselection:x - csellabel:width-pixels - label-delta-x.

END PROCEDURE.

PROCEDURE relabel-cselection:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter theLabel as character no-undo.

   assign
      csellabel:width-pixels =
         font-table:get-text-width-pixels(theLabel, csellabel:font)
      csellabel:format       = "X(" + string(length(theLabel, "raw")) + ")"
      csellabel:screen-value = theLabel
      csellabel:x = cselection:x - csellabel:width-pixels - label-delta-x.

END PROCEDURE.

PROCEDURE Apply-cselection-event:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter eventname as character no-undo.

   apply eventname to cselection.

END PROCEDURE.

PROCEDURE run-pgm:
/* -----------------------------------------------------------
   Purpose:     run program from menu
   Parameters:  menu-exec = program to execute
   menu-title = title to display in window of
   called program
   Notes:
 -------------------------------------------------------------*/
   define input parameter menu-exec like mnd_exec no-undo.
   define input parameter menu-title as character no-undo.
   define variable c-this-menu as character no-undo.

   assign
      c-this-menu = THIS-PROCEDURE:file-name
      c-this-menu = substring(c-this-menu,r-index(c-this-menu,"/") + 1)
      c-this-menu = substring(c-this-menu,r-index(c-this-menu,"~\") + 1)
      c-this-menu = substring(c-this-menu,1,r-index(c-this-menu,".") - 1)
      execname = c-this-menu + ".p" .

   {gprun.i 'gpwinrun.p' "(input menu-exec, input menu-title)"}

   assign
      global-beam-me-up = no
      global_program_rev = "".

   /* To find the correct company name if 1) it has been changed  */
   /* since last run; 2) database has been switched in multi      */
   /* database environment.                                       */
   run p-get-company-name.
   assign current-window:title = return-value + " : " + ldbname("qaddb").

   pause 0 before-hide.

END PROCEDURE.

PROCEDURE declare-Exiting:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define output parameter do-exit as logical no-undo.

   define variable msg_temp as character no-undo.

   /* This will end your MFG/PRO session */
   {pxmsg.i &MSGNUM=7737 &ERRORLEVEL=1 &MSGBUFFER=msg_temp}

   message
      msg_temp
   view-as alert-box information
   buttons ok-cancel
   title getFrameTitle("EXIT_MFG/PRO",30)
   update do-exit.

   assign global-exiting = do-exit.

END PROCEDURE.

PROCEDURE analyze-menu-name:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input  parameter menu-name as character no-undo.
   define output parameter lastperiod as integer no-undo.
   define output parameter numperiods as integer no-undo.

   define variable selchar as character no-undo.
   define variable i       as integer   no-undo initial 1.

   /* Parse fully specified menu-name */
   assign
      lastperiod = 0
      numperiods = 0.

   do while i <= length(menu-name):
      assign selchar = substring(menu-name, i, 1).
      if selchar = "." then
         assign
            lastperiod = i
            numperiods = numperiods + 1.
      assign i = i + 1.
   end. /* do while */

END PROCEDURE.

PROCEDURE parse-menu-name:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input parameter  menu-name as character no-undo.
   define output parameter menu-nbr    like mnd_nbr no-undo.
   define output parameter menu-select like mnd_select no-undo.

   define variable lastperiod as integer no-undo.
   define variable periods    as integer no-undo.

   /* Parse fully specified menu-name */
   run analyze-menu-name
      (input menu-name,
      output lastperiod,
      output periods).

   if lastperiod > 0 then
      assign
         menu-nbr    = substring(menu-name, 1, lastperiod - 1)
         menu-select = integer(substring(menu-name, lastperiod + 1,
                               length(menu-name) - lastperiod)).
   else
      assign
         menu-nbr = "0"
         menu-select = integer(menu-name).

END PROCEDURE.

PROCEDURE cleanup-menu-name:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define input-output parameter menu-name as character no-undo.

   define variable temp   as integer   no-undo.
   define variable tmpstr as character no-undo.

   if menu-name begins "A." then do:
      temp = index(menu-name, ".", 3). /* look for another "." */
      if temp > 0 then   /* there is one */
         assign
            tmpstr = substring(menu-name, 1, temp)
            menu-name = replace(menu-name, tmpstr, "").
      else
         assign menu-name = "".
   end.
   else
      if menu-name begins "0." then
         assign menu-name = replace(menu-name, "0.", "").

END PROCEDURE.

PROCEDURE p-get-company-name:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define variable pname as character no-undo.

   assign pname = "qad.inc".

   /* To find the correct company name if 1) it has been changed  */
   /* since last run; 2) database has been switched in multi      */
   /* database environment.                                       */
   {gprun.i ""gplkconm.p"" "(input-output pname)"}

   return pname.

END PROCEDURE.

PROCEDURE p-can-do-editor:
/* -----------------------------------------------------------
   Purpose:     Determine if Progress Editor can be menu item
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
   define output parameter pcando as logical initial "no" no-undo.

   for first mnd_det
         fields(mnd_det.mnd_canrun mnd_det.mnd_exec mnd_det.mnd_nbr
                mnd_det.mnd_select mnd_det.mnd_label)
         where
         mnd_det.mnd_nbr = "" and
         mnd_det.mnd_select = 1 no-lock :
   end.

   if available mnd_det then do:
      {mfsec.i "mnd_det"}
      assign
         pcando = can_do_menu and (search("adeedit\_proedit.r") <> ?).
   end.

END PROCEDURE.
