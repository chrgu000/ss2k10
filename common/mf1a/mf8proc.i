/* mf8proc.i - Internal Procedures for MFG/PRO GUI Sign-On Program            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.25 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
/*V8:RunMode=Windows                                                          */
/*********************************** History **********************************/
/* Revision: 8.3     Last Modified: 05/31/95     By: jzs                      */
/* Revision: 8.3     Last Modified: 06/16/95     By: aed                      */
/* Revision: 8.3     Last Modified: 11/01/95     By: jzs      /*G1BX*/        */
/* Revision: 8.5     Last Modified: 01/25/96     By: jpm      /*J0CF*/        */
/* REVISION: 8.3     LAST MODIFIED: 03/20/96     BY: qzl      /*G1QT*/        */
/* REVISION: 8.5     LAST MODIFIED: 03/20/96     BY: aed      /*J0G1*/        */
/* REVISION: 8.5     LAST MODIFIED: 04/05/96     BY: aed      /*J0HB*/        */
/* REVISION: 8.5     LAST MODIFIED: 04/05/96     BY: jpm      /*J0HZ*/        */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96     BY: jpm      /*J0L0*/        */
/* REVISION: 8.5     LAST MODIFIED: 07/05/96     BY: jpm      /*J0XT*/        */
/* REVISION: 8.5     LAST MODIFIED: 04/04/97     BY: dks      /*J1JH*/        */
/* REVISION: 8.5     LAST MODIFIED: 07/07/97     BY: *J1VR* Cynthia Terry     */
/* REVISION: 8.6     LAST MODIFIED: 08/07/97     BY: vrp      /*J1YF*/        */
/* REVISION: 8.6     LAST MODIFIED: 09/16/97     BY: vrp      /*H1F3*/        */
/* REVISION: 8.6     LAST MODIFIED: 07/24/98     BY: *J2TM* Raphael T.        */
/* REVISION: 8.6E    LAST MODIFIED: 03/07/00     BY: *L0TB* Falguni D.        */
/* Revision: 9.1     Last Modified: 03/23/00     By: *N08T* D.Taylor          */
/* Revision: 9.1     Last Modified: 05/08/00     By: *L0XJ* J. Fernando       */
/* Revision: 9.1     Last Modified: 08/13/00     By: *N0KR* Mark Brown        */
/* Revision: 1.21    By: Jean Miller       Date: 06/20/02       ECO: *P09H*   */
/* Revision: 1.20    By: Neil Curzon       Date: 07/22/03       ECO: *Q018*   */
/* Revision: 1.21    By: Michael Hansen    Date: 11/17/03       ECO: *Q04K*   */
/* Revision: 1.23    By: Michael Hansen    Date: 10/19/04       ECO: *Q0D7*   */
/* $Revision: 1.25 $   By: Sandy Brown       Date: 01/04/05       ECO: *P2HX* */
/*  $Revision: 101122.1 $ BY: zhangyun      DATE: 11/22/10        ECO: *YM*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

&SCOPED-DEFINE Save-Settings 1
&SCOPED-DEFINE Tool-bar 2
&SCOPED-DEFINE Menu-Subs 4
&SCOPED-DEFINE Nav-Bar 8
&SCOPED-DEFINE Hide-Menus 16
&SCOPED-DEFINE Drop-Downs 32
&SCOPED-DEFINE Max-Logical 64

/********************************************************************/
/********************* Internal Procedures **************************/
/********************************************************************/

PROCEDURE p-menu-driver:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
   define input parameter pmenu-type as character no-undo.

   define variable rmenu-type          as character no-undo.
   define variable save-window-title   as character no-undo.
   define variable run_pgm             as character no-undo.
   define variable save-virtual-width  as decimal no-undo.
   define variable save-virtual-height as decimal no-undo.
   define variable save-max-width      as decimal no-undo.
   define variable save-max-height     as decimal no-undo.
   define variable save-window-menubar as widget-handle no-undo.
   define variable font1-height        as integer.
   define variable fontd-height        as integer.

   hide all.

   save-virtual-width  = current-window:virtual-width-chars.
   save-virtual-height = current-window:virtual-height-chars.
   save-window-title   = current-window:title.
   save-window-menubar = current-window:menu-bar.
   save-max-width      = current-window:max-width-chars.
   save-max-height     = current-window:max-height-chars.

   menu = fill("~367",11).
   create widget-pool.

   run restore-settings
      (input global_userid,
       input-output pmenu-type).

   run p-show-hide-dropdowns in global-drop-down-utilities
      (input global-drop-downs).

   CASE pmenu-type:
      when "a" then run_pgm = "mfnewa3.p".
      when "b" then run_pgm = "mfnewb3.p".
      when "c" then run_pgm = "mfnewc3.p".
      otherwise run_pgm = "mfnewa3.p".
   END CASE.

   if false then do:
      {gprun.i ""mfnewa3.p""}
      {gprun.i ""mfnewb3.p""}
      {gprun.i ""mfnewc3.p""}
   end.

   {gprun1.i run_pgm}

   run save-settings
      (input global_userid,
       input pmenu-type).

   if global-exiting then do:
      leave.
   end.

   pause 0.
   delete widget-pool.

   assign
      current-window:menubar                  = save-window-menubar
      current-window:title                    = save-window-title
      current-window:virtual-width-chars      = save-virtual-width
      current-window:virtual-height-chars     = save-virtual-height
      current-window:max-height               = save-max-height
      current-window:max-width                = save-max-width.

   assign
      font1-height = font-table:get-text-height-pixels(1)
      fontd-height = font-table:get-text-height-pixels().

   frame signon-frame:height-pixels =
      truncate((frame signon-frame:height-pixels * fontd-height) /
               font1-height, 0).

   {gprun.i ""gpfontsz.p""
      "(frame signon-frame:handle, yes, yes, """none""", no)"}

   run p-reset-signon.

END PROCEDURE.

PROCEDURE p-reset-signon:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:       Reset password to null (forces passwd re-entry)
-------------------------------------------------------------*/

   assign
      c-userid           = ""
      passwd             = ""
      global_passwd      = ""
      global_user_groups = ""
      global_user_name   = ""
      global_db          = ""
      global_domain      = "".

   if l_enforce_os_userid then
      c-userid = global_userid.

   /*AT STARTUP, BEFORE USER IS ESTABLISHED*/
   /*USE THE SYSTEM DOMAIN AS THE CURRENT SESSION DOMAIN.*/
   /*IF NO SYSTEM DOMAIN IS PRESENT, USE THE CONSTANT - QAD */
   for first dom_mstr
   fields (dom_domain dom_type)
   no-lock
   where dom_type = "SYSTEM":
      global_domain = dom_domain.
   end.
   if global_domain = "" then
      global_domain = "QAD".

   assign global_db = global_domain.

   display
      c-userid @ global_userid
      passwd
      "" @ lv_domain
      "" @ dom_name with frame signon-frame.
   view frame signon-frame.

   apply "ENTRY" to frame signon-frame.

   {gprun.i ""gpcursor.p"" "('')"}
   pause 0.

   if global-exiting then do:
      apply "CHOOSE" to button-cancel.
      run p-save-userid.
   end.

END PROCEDURE.

PROCEDURE p-save-userid:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   assign
      frame signon-frame
      global_userid
      .

END PROCEDURE.

PROCEDURE disable_UI :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   hide frame signon-frame.
   global-beam-me-up = no.

END PROCEDURE.

PROCEDURE enable_UI :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   /* Do all enabling and viewing before Security Option handling */
   enable
      Button-Ok
      Button-Cancel
      Button-Help
   with frame signon-frame.

   frame frame-setup-options:hidden = true.

   enable
      button-setup-ok
      button-setup-cancel
   with frame frame-setup-options.

   view WINDOW-1.

   if not l_enforce_os_userid then do:
      c-userid = "".
      global_userid:sensitive in frame signon-frame = true.
      passwd:sensitive in frame signon-frame = true.
      apply "ENTRY" to global_userid in frame signon-frame.
   end.
   else do:
      c-userid = global_userid.
      global_userid:sensitive in frame signon-frame = false.
      if password_required then do:
         passwd:sensitive in frame signon-frame = true.
         apply "ENTRY" to passwd in frame signon-frame.
      end.
   end.
/*YM*/ if c-userid <> "" then
          display c-userid @ global_userid with frame signon-frame.
/*YM*/ else
/*YM*/    display "mfg" @ global_userid with frame signon-frame.

END PROCEDURE.

PROCEDURE p-get-preferred-menu-type:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
   define input parameter uid AS CHARACTER.
   define output parameter pref-menu AS CHARACTER.

   /*TO GLOBALLY ACCESS USER PROFILE       */
   for first uip_mstr
      fields (uip_userid uip_style)
      where uip_userid = uid
   no-lock: end.

   if not available uip_mstr and uid <> "" then
   for first uip_mstr
      fields (uip_userid uip_style)
      where uip_userid = ""
   no-lock: end.

   pref-menu = if available(uip_mstr) then uip_style else "A".

   release uip_mstr.

END PROCEDURE.

PROCEDURE restore-settings:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
   define input parameter uid as character no-undo.
   define input-output parameter menu-type as character no-undo.

   define variable i as integer init 1 NO-UNDO.

   find first uss_mstr where uss_mstr.uss_userid = uid
   no-lock no-error.


   /*TO GLOBALLY ACCESS USER PROFILE       */
   run p-get-preferred-menu-type
      (input uid,
       output menu-type).

   if not available(uss_mstr) then do:
      run default-settings.
      return.
   end.

   do while i < {&Max-Logical}:

      CASE i:

         when ({&Save-Settings}) then do:
            global-save-settings = uss_logicals mod 2 <> 0.
         end.
         when ({&Tool-bar}) then do:
            global-tool-bar = truncate(uss_logicals / {&Tool-bar}, 0) mod 2 <> 0.
         end.
         when {&Nav-Bar} then do:
            global-nav-bar = truncate(uss_logicals / {&Nav-Bar}, 0) mod 2 <> 0.
         end.
         when {&Hide-Menus} then do:
            global-hide-menus =
               truncate(uss_logicals / {&Hide-Menus}, 0) mod 2 <> 0.
         end.
         when {&Drop-Downs} then do:
            global-drop-downs =
               truncate(uss_logicals / {&Drop-Downs}, 0) mod 2 <> 0.
         end.

      END CASE.

      i = i * 2.

   end.

   /* Menuinfo is style-specific, so wipe out menuinfo if current style
     doesn't match currently selected style. */
   global-menuinfo = if menu-type = uss_style then uss_menuinfo else "".

END PROCEDURE.

PROCEDURE save-settings:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
   define input parameter uid as character no-undo.
   define input parameter menu-type as character no-undo.

   define variable i     as integer initial 1 no-undo.
   define variable flags as integer initial 0 no-undo.

   do while i < {&Max-Logical}:

      CASE i:

         when {&Save-Settings} then do:
            if global-save-settings then do:
               flags = flags + {&Save-Settings}.
            end.
         end.

         when {&Tool-bar} then do:
            if global-tool-bar then do:
               flags = flags + {&Tool-bar}.
            end.
         end.

         when {&Menu-Subs} then do:
            if global-menu-substitution then do:
               flags = flags + {&Menu-Subs}.
            end.
         end.

         when {&Nav-Bar} then do:
            if global-nav-bar then do:
               flags = flags + {&Nav-Bar}.
            end.
         end.

         when {&Hide-Menus} then do:
            if global-hide-menus then do:
               flags = flags + {&Hide-Menus}.
            end.
         end.

         when {&Drop-Downs} then do:
            if global-drop-downs then do:
               flags = flags + {&Drop-Downs}.
            end.
         end.

      END CASE.

      i = i * 2.

   end.

   find first uss_mstr where uss_mstr.uss_userid = uid
   exclusive-lock no-error.

   if not available(uss_mstr) then do:
      create uss_mstr.
      assign
         uss_userid = uid.
   end.

   if global-save-settings then do:
      assign
         uss_style       = menu-type
         uss_logicals    = flags
         uss_menuinfo    = global-menuinfo.
   end.

   release uss_mstr.

END PROCEDURE.

PROCEDURE default-settings:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   assign
      global-menuinfo = ""
      global-hide-menus = no
      global-tool-bar = yes
      global-nav-bar = yes
      global-save-settings = yes
      global-drop-downs = yes.

END PROCEDURE.

PROCEDURE p-gui-setup:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   assign
      CURRENT-WINDOW             = WINDOW-1
      SESSION:SYSTEM-ALERT-BOXES = (CURRENT-WINDOW:MESSAGE-AREA = NO)
      current-window:width-chars = 80
      current-window:height-chars = 17.

   /* Best default for GUI applications is...    */
   pause 0.

   local-menu-type           = "?".
   session:suppress-warnings = yes.
   session:data-entry-return = true.
   global-beam-me-up         = no.

   /* This is run to make sure that the local copy of global_user_lang_dir */
   /* within mfdpers.p is current. */
   {gprun1.i ""gplkup.p""   " " "PERSISTENT SET global-drop-down-utilities"}
   {gprun1.i ""gpclndob.p"" "(global_user_lang_dir)" "PERSISTENT"}
   {gprun1.i ""gpcalcob.p"" "(global_user_lang_dir)" "PERSISTENT"}

END PROCEDURE.


PROCEDURE p-fix-frame-size:
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/

   {gprun.i ""gpfontsz.p""
      "(frame signon-frame:handle, yes, yes, """button,rectangle""", yes)"}
   {gprun.i ""gpfontsz.p""
       "(frame frame-setup-options:handle, yes, yes, """all""", yes)"}

END PROCEDURE.
