/************************************************************************
 * Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.
 * All rights reserved worldwide.  This is an unpublished work.
 *
 *          File: gpwinrun.p
 *
 *   Description: Run program in new window
 *
 * Primary Table: None
 *
 *   Input Parms: run-pgm   - Program to run
 *                run-title - Title to display in window
 *
 *  Output Parms: None
 *
 ************************************************************************/

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/************************************************************************/

/******************************** History *******************************
 * Revision: 8.0  Last modified: 01/06/94          By: Jerome Dayton
 * Revision: 8.0  Last modified: 03/03/94          By: Katrina Schmalbach
 * Revision: 8.0  Last modified: 05/02/94          By: Allan Doane
 * Revision: 8.0  Last modified: 09/28/95  *J08V*  By: Katrina Schmalbach
 * Revision: 8.0  Last modified: 11/17/95  *J099*  By: Jean Miller
 * Revision: 8.5  Last modified: 01/08/96  *J0B6*  By: Allan Doane
 * Revision: 8.5  Last modified: 01/13/96  *J0BN*  By: Katrina Schmalbach
 * Revision: 8.5  Last Modified: 02/05/96  *G1M3*  By: Rand Clark
 * Revision: 8.5  Last Modified: 02/21/96  *J0D0*  By: Jean Miller
 * Revision: 8.5  Last Modified: 03/11/96  *J0CH*  By: Bill Pedersen
 * Revision: 8.3  Last Modified: 04/02/96  *G1DC*  By: Jean Miller
 * Revision: 8.3  Last Modified: 04/02/96  *G1MJ*  By: Jean Miller
 * Revision: 8.3  Last Modified: 04/03/96  *G1MP*  By: Jean Miller
 * Revision: 8.5  Last Modified: 07/22/96  *J0Y7*  By: Allan Doane
 * Revision: 8.5  Last Modified: 09/10/96  *J14V*  By: Allan Doane
 * Revision: 8.5  Last Modified: 10/31/96  *J17B*  By: Tamra Farnsworth
 * Revision: 8.5  Last Modified: 04/07/97  *J1N3*  By: Mark B. Smith
 * Revision: 8.5  Last Modified: 04/25/97  *J1PW*  By: Allan Doane
 * Revision: 8.5  Last Modified: 06/05/97  *J1SQ*  By: Allan Doane
 * Revision: 8.5  Last Modified: 07/03/97  *J1VR*  By: Cynthia Terry
 * Revision: 8.5  Last Modified: 08/07/97  *J1YP*  By: Mark B. Smith
 * Revision: 8.5  Last Modified: 02/09/98  *J2DR*  By: Mark B. Smith
 * Revision: 8.6E Last Modified: 02/23/98  *L007*  By: A. Rahane
 * Revision: 8.5  Last Modified: 03/25/98  *J2HR*  By: Mark B. Smith
 * Revision: 8.6E Last Modified: 06/02/98  *K1NM*  By: Paul Knopf
 * Revision: 8.6E Last Modified: 01/24/00  *J3NT*  By: Raphael Thoppil
 * Revision: 9.0  Last Modified: 02/23/00  *J3PC*  By: Raphael Thoppil
 * Revision: 9.0  Last Modified: 03/09/00  *J3PD*  By: Raphael Thoppil
 * Revision: 9.0  Last Modified: 04/20/00  *J3PQ*  By: Falguni Dalal
 * Revision: 9.1  Last Modified: 08/13/00  BY: *N0KS* myb
 *************************************************************************/

/*************************************************************************/
/* NOTE: This programs makes windows currently opened unusable when a new
   program is spawned.  It does this by making all the frames and the
   menu-bar in the window insensitive.  There is a Progress bug with making
   the entire window insensitive: use of an alert-box message,
   set-wait-state, or dialog box will reactivate insensitive windows.
   MOD 09/28/95: Changed for character mode support: changed to hide
   frames instead of making them insensitive, and also changed to NOT spawn
   a new window, since character mode doesn't support multiple windows.
   Also allow for ".w" extension on programs
    Last change:  AED  24 Apr 97    4:35 pm
***************************************************************************/

{mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpwinrun_p_1 "Title to display in window"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpwinrun_p_2 "Program to run"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpwinrun_p_3 "Navigate"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpwinrun_p_4 "Batch"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define input parameter run-pgm   as character label {&gpwinrun_p_2}.
define input parameter run-title as character label {&gpwinrun_p_1} .

{mf1.i}
/*J08V*/ {gpmnsave.i}

define variable save-window         as widget-handle.
define variable save-focus          as widget-handle.
define variable save-tool-bar       as widget-handle.
define variable pgm-window          as widget-handle.
define variable insens-handle       as widget-handle extent 200.
define variable window-handle       as widget-handle.
define variable menu-handle         as widget-handle.
define variable frm-handle          as widget-handle.
define variable exec-rcode          as character no-undo.
define variable pgm-title           as character no-undo.
define variable save-execname       like execname.
define variable i                   as integer initial 0  no-undo.
define variable j                   as integer   no-undo.
define variable newpos              as decimal   no-undo.
define variable frame-handle        as handle    no-undo.
define variable c-use-run-pgm       as character no-undo. /*J08V*/
define variable h-save-menu-bar     as handle    no-undo. /*J08V*/
define variable h-save-frame-handle as handle    no-undo. /*J08V*/
define variable i-insens-counter    as integer   no-undo. /*J08V*/
define variable l-is-browse         as logical   no-undo. /*J1PW*/

/* /*K1NM*/ define variable v-lv-returnit  as logical   no-undo.  **J3PC*/
/*K1NM*/ define variable thismenu       as character no-undo.
/*K1NM*/ define variable v-old-prog     as character no-undo.
/*K1NM*/ define variable v-old-menu     as integer   no-undo.
/*K1NM*/ define variable v-old-sele     as character no-undo.

 /* clean up input parameter */
 if index(run-pgm, ".") > 0 then do:
/*J08V*/   /* ".W" is a permissable, explicit extension */
/*J08V*/   if index(run-pgm, ".W":U) = 0 then
     run-pgm = substring(run-pgm, 1, index(run-pgm, ".":U)) + "P":U.
 end.

 else
    run-pgm = run-pgm + ".P":U.

/* aed - do program substitution, as necessary */
/*J1VR******
/*J08V*/ &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
******J1VR*/

if global-do-menu-substitution then do:
    {gprun.i ""gpexcsub.p"" "(input-output run-pgm, output pgm-title)"}
    if pgm-title <> "" then run-title = pgm-title.
end.

/*J1VR******
/*J08V*/ &ENDIF
******J1VR*/

/*J08V*/ run-pgm = lc(run-pgm).

help_exec = run-pgm.               /* aed - make sure help is consistent. */

exec-rcode = replace(run-pgm, ".P":U, ".R":U).
/*J08V*/ exec-rcode = lc(replace(exec-rcode, ".W":U, ".R":U)).

/*J08V** minimize amount of searching & allow for .w's**
 * if search (run-pgm) = ? and search(exec-rcode) = ? and
 *    search(substr(run-pgm,1,2) + "/":U
 *    + substring(run-pgm,1,length(run-pgm) - 1) + "R":U) = ?
 * then do:
 *   {mfmsg02.i 7706 3 run-pgm} /* Program not in system */
 * end.
 * else do:
 *J08V**/

/*J08V*/ c-use-run-pgm = "".
/*J1PW*/ run check-for-browse in this-procedure
/*J1PW*/     (INPUT run-pgm,
/*J1PW*/      OUTPUT l-is-browse).
/*J1PW*/ if l-is-browse then do:
/*J1PW*/     c-use-run-pgm = "gpcn200.w".
/*J1PW*/ end.
/*J1PW*/ else do:
/*J08V*/ if search(global_user_lang_dir + substr(run-pgm,1,2) + "/":U + run-pgm) <> ?
/*J08V*/ then
/*J08V*/   c-use-run-pgm = run-pgm.

/*J08V*/ if search(global_user_lang_dir + substr(exec-rcode,1,2) + "/":U + exec-rcode) <> ?
/*J08V*/ then
/*J08V*/   c-use-run-pgm = exec-rcode.

/*J099*/ if index(run-pgm,"zzbr001.p") <> 0
/*J099*/   then run-pgm = "zzbr001.p".
/*J0CH*/ if index(run-pgm,"zzlu001.p") <> 0
/*J0CH*/   then run-pgm = "zzlu001.p".
/*J08V*/ if c-use-run-pgm = "" and
/*J08V*/  run-pgm <> "zzbr001.p" and
/*J08V*/  run-pgm <> "zzlu001.p" and
/*J1PW*/  not run-pgm begins "zzbr9":U and
/*J08V*/  run-title <> {&gpwinrun_p_4} then do:
/*J08V*/   {mfmsg02.i 7706 3 run-pgm} /* Program not in system */
/*J08V*/    return error "ERROR":U.
/*J08V*/ end.
/*J1PW*/ end.

  save-window = current-window.
  save-focus = focus.
/*J08V**  save-tool-bar = global-tool-bar-handle. */
/*J08V*/ /* Set the window's name to run window title (used in char mode & debugging) */
/*J14V*/ if valid-handle(current-window) then
/*J08V*/ current-window:name = run-title.

/*G1MJ*/    do on error undo, leave:

  /* If running in character mode, make all currently visible frames not visible */
/*J08V*/  &IF "{&window-system}" = "TTY":U &THEN
/*J08V*/     /* Save the current menu-bar, if any */
/*J08V*/     run q-save-menu-info in this-procedure.
/*J08V*/     i-insens-counter = 0.
/*J14V*/ if valid-handle(current-window) then
/*J08V*/     frame-handle = current-window:last-child.
/*J08V*/     repeat while frame-handle <> ?:
/*J08V*/        if i-insens-counter = 200 then leave.
/*J08V*/        if frame-handle:visible then do:
/*J08V*/           i-insens-counter = i-insens-counter + 1.
/*J08V*/           insens-handle[i-insens-counter] = frame-handle.
/*J08V*/           frame-handle:visible = false.
/*J08V*/        end.
/*J08V*/        frame-handle = frame-handle:prev-sibling.
/*J08V*/     end.

  /* If running in Windows/Motif ...*/
/*J08V*/  &ELSE
     /* Store list of all other windows' frames & menubars to make insensitive */
     /* (because Progress doesn't support MDI & isn't multi-threaded).         */
/*J08V*/ save-tool-bar = global-tool-bar-handle.
     window-handle = session:first-child. /* First Window */
     repeat while window-handle <> ?:
       if i = 200 then leave.
       /* Make sure that this is an MFG/PRO window */
/*J0Y7** if window-handle:private-data = "MFG/PRO":U then do: */
/*J0Y7*/ if entry(1, window-handle:private-data) = "MFG/PRO":U then do:
/*J0Y7*/   /* if window not marked insensitive, mark it */
/*J0Y7*/   if index(window-handle:private-data, "INSENSITIVE":U) = 0 then do:
/*J0Y7*/     window-handle:private-data = window-handle:private-data
/*J0Y7*/                                + ",INSENSITIVE":U.
/*J0Y7*/   end.

       /* Window's menu-bar */
          if VALID-HANDLE(window-handle:MENU-BAR) THEN DO:
             menu-handle = window-handle:menu-bar.
             if menu-handle:sensitive then do:
                i = i + 1.
                insens-handle[I] = window-handle:MENU-BAR.
             end.
          end.
          /* Frames in this window */
          FRM-HANDLE = window-handle:FIRST-CHILD.
          repeat while FRM-HANDLE <> ?:
             if frm-handle:type = "FRAME":U and FRM-HANDLE:SENSITIVE = TRUE THEN DO:
                FRM-HANDLE:SENSITIVE = FALSE.
                i = i + 1.
                insens-handle[I] = FRM-HANDLE.
             end.
             FRM-HANDLE = FRM-HANDLE:NEXT-SIBLING. /* next frame */
          end.
       end.
       window-handle = window-handle:NEXT-SIBLING. /* next window */
     END.

     /* Create window for called program to run in, but don't realize it */
     create window pgm-window
        assign
           title = run-title
/*J0D0*/   name = run-title
           width-chars = /* save-window:width-chars */ 80
           height-chars = /* save-window:height-chars   */ 23
           sensitive = yes
           bgcolor = 8
           visible = false
           scroll-bars = yes
           three-d = true
           private-data = "MFG/PRO":U
           .
     /* Calc new row */
     newpos = max(save-window:row + 1,1).
     if (newpos + save-window:height-chars) > session:height-chars then
        newpos = 1.
     pgm-window:row = newpos.
     /* Calc new column */
     newpos = max(save-window:column + 2,1).
     if (newpos + save-window:width-chars) > session:width-chars then
        newpos = 1.
     assign pgm-window:column = newpos         /*J2DR*/
            global-beam-me-up = no.            /*J2DR*/
     /* PSTUFF FOR NON-GUI MFG/PRO PROGRAMS.  Will be overridden in new GUI pgms*/
     /* This makes "window-close" or menu-item "Exit" act like an escape */
     /* (this is the best default for unconverted programs */
     on "WINDOW-CLOSE":U of pgm-window
     do:
/*J0Y7*/ /* if window is marked "INSENSITIVE", ignore close */
/*J0Y7*/ if index(self:private-data, "INSENSITIVE":U) > 0 then
/*J0Y7*/   return no-apply.
        global-beam-me-up = yes.
        if valid-handle(focus) then
           if focus:sensitive then
              apply "ENTRY":U to focus.
        apply "END-ERROR":U.
     end.
     on entry of pgm-window
     do:
        current-window = pgm-window.
      /*apply "ENTRY":U to pgm-window.          /*J1YP*/*/ /*J2HR*/
     end.

     CURRENT-WINDOW = PGM-WINDOW.
     apply "ENTRY":U to pgm-window.
     /*  view pgm-window. */

     /* New window is now created & in focus, make all other windows unusable */

     do j = 1 to i:
        insens-handle[J]:SENSITIVE = FALSE.
        /* Hide any "Navigate" windows */
        if insens-handle[j]:type = "FRAME":U then do:
           window-handle = insens-handle[j]:parent.
           if window-handle:title = {&gpwinrun_p_3} then
              window-handle:hidden = true.
        end.
     end.

     {gprun.i ""gpcursor.p"" "('WAIT')"}

/*J08V*/ &ENDIF

   session:APPL-ALERT-BOXES = false.


/*J14V*/ if valid-handle(current-window) then do:
/*J0B6*/ /*J08V*/ on "go" of current-window anywhere
/*J08V*/   do:

/*J08V*/         if valid-handle(self) then
                 do:                                           /*J3NT*/
/*J08V*/            apply "go" to self.
                 /* TO CHECK FAILURE IF FOCUS & SELF       */  /*J3NT*/
                 /* IS SAME AND EXECUTE INST BUTTON IF NOT */  /*J3NT*/
                 /* BEGIN OF ADDED CODE                    */  /*J3NT*/

         /* RUN p-instantiate-button ONLY IF       */  /*J3PQ*/
         /* global-drop-downs IS TRUE              */  /*J3PQ*/

                   if (session:display-type <> "tty":U )
                   and (self <> focus )
                   and valid-handle(global-drop-down-utilities)
                   and global-drop-downs                       /*J3PQ*/
           then
                     run p-instantiate-button in global-drop-down-utilities
                        (INPUT FOCUS).
                 end.
                 /* END OF ADDED CODE                      */  /*J3NT*/
/*J17B*/      return no-apply.
/*J08V*/   end.
/*J0B6*/ /*J08V*/   on "F4" of current-window anywhere
/*J08V*/   do:
/*J08V*/      if valid-handle(self) then
/*J08V*/         apply "F4" to self.
/*J08V*/   end.
/*J0B6*/ /*J08V*/   on "ESC" of current-window anywhere
/*J08V*/   do:
/*J08V*/      if valid-handle(self) then
/*J08V*/         apply "ESC" to self.
/*J08V*/   end.
/*J0B6*/ /*J08V*/   on "END-ERROR" of current-window anywhere
/*J08V*/    do:
/*J08V*/       if valid-handle(self) then
/*J08V*/          apply "END-ERROR" to self.
/*J08V*/   end.
/*J0B6*/ /*J08V*/   on "ESC-F" of current-window anywhere
/*J08V*/   do:
/*J08V*/      if valid-handle(self) then
/*J08V*/         apply "ESC-F" to self.
/*J08V*/   end.
/*J0BN*/ /* /*J08V*/   on F6 help. */
/*J14V*/ end.
   save-execname = execname.
   execname = run-pgm.

/* REMOVE CHECK OF PIN_MSTR IN Ver 9.0 AND ABOVE*/                      /*J3PC*/
/* /*K1NM*/{gprun.i ""lvcheck.p"" "(input ""1"",output v-lv-returnit)"} **J3PC*/
/* /*K1NM*/   if v-lv-returnit then do:                                 **J3PC*/
/*K1NM*/      {gprun.i ""lvmoniq.p"" "(output v-old-prog,
/*K1NM*/                               output v-old-sele,
/*K1NM*/                               output v-old-menu)"}
/*K1NM*/      find first mnd_det where mnd_exec = run-pgm no-lock no-error.
/*K1NM*/      if available mnd_det then
/*K1NM*/         thismenu = mnd_det.mnd_nbr +  "." + string(mnd_select).
/*K1NM*/      else
/*K1NM*/         thismenu = "".
/*K1NM*/      {gprun.i ""lvactmon.p"" "(thismenu,run-pgm, 1)"}
/* /*K1NM*/   end.                                                      **J3PC*/

           /* TO EXECUTE ADD WINDOW FOR ALL GUI */  /*J3PD*/
           /* PGMS TO ACCESS LOOKUP             */  /*J3PD*/
           /* BEGIN OF ADDED CODE               */  /*J3PD*/
           if (session:display-type <> "tty":U )
           and valid-handle(global-drop-down-utilities) then
              run p-add-window in global-drop-down-utilities
                 (INPUT execname,INPUT pgm-window).
           /* END OF ADDED CODE                 */  /*J3PD*/

/*J08V*/   if run-pgm = "zzbr001.p"
/*J0CH*/   or run-pgm = "zzlu001.p"
/*J08V*/   or run-title = {&gpwinrun_p_4}
           then do on error undo, leave:
/*G1DC*/     if run-title = {&gpwinrun_p_4} then dtitle = substring(dtitle,16,50).
/*J08V*/     run value(run-pgm).
/*J08V*/   end.
/*J08V*/   else do on error undo, leave:
/*G1MP*/      ststatus = stline[3].
/*G1MP*/      status input ststatus.
/*J1PW*/      if c-use-run-pgm = "gpcn200.w":U then do:
/*J1SQ** /*J1PW*/         {gprun.i c-use-run-pgm "(input run-pgm)"} */
/*J1SQ*/         {gprun.i ""gpcn200.w"" "(input run-pgm)"}
/*J1PW*/      end.
/*J1PW*/      else do:
/*J08V*/         {gprun1.i c-use-run-pgm}
/*J1PW*/      end.
/*The "hide all" cleared the buffer and eliminated a coredump in Progress 8.0*/
/*It also made the menus blank out when custom code is ran in GUI*/
/*/*J1N3*/          hide all.*/  /*J2DR*/
/*J08V*/   end.

/* /*K1NM*/{gprun.i ""lvcheck.p"" "(input ""1"",output v-lv-returnit)"} **J3PC*/
/* /*K1NM*/   if v-lv-returnit then do:                                 **J3PC*/
/*K1NM*/      {gprun.i ""lvactmon.p"" "(v-old-sele, v-old-prog, v-old-menu)"}
/* /*K1NM*/   end.                                                      **J3PC*/

   execname = save-execname.

/*J08V*/ /* Reset the window's name to blank (used in char mode & debugging) */
/*J14V*/ if valid-handle(current-window) then do:
/*J08V*/ current-window:name = "".

/*J0B6*/ /*J08V*/   on "go" of current-window anywhere
/*J08V*/      revert.
/*J0B6*/ /*J08V*/   on "F4" of current-window anywhere
/*J08V*/      revert.
/*J0B6*/ /*J08V*/   on "ESC" of current-window anywhere
/*J08V*/      revert.
/*J0B6*/ /*J08V*/   on "END-ERROR" of current-window anywhere
/*J08V*/      revert.
/*J0B6*/ /*J08V*/   on "ESC-F" of current-window anywhere
/*J08V*/      revert.
/*J14V*/ end.

/*G1MJ*/  end.

          /* TO EXECUTE DELETE WINDOW WHEN     */ /*J3NT*/
          /* ALL PGMS EXCEPT GPRPTWIN RETURN   */ /*J3NT*/
          /* BEGIN OF ADDED CODE */               /*J3NT*/
          /* NO NEED OF EXCEPTION FOR GPRPTWIN */ /*J3PD*/
          if (session:display-type <> "tty":U )
       /* and (not (run-pgm begins "gprptwin":U)) **J3PD*/
          and valid-handle(global-drop-down-utilities) then
              run p-delete-window in global-drop-down-utilities
                 (INPUT pgm-window).
          /* END OF ADDED CODE */                 /*J3NT*/

/*J14V*/  if valid-handle(save-window) then
/*J08V*/  current-window = save-window.
/*J08V*/   /* If running in character mode, make all currently visible frames not visible */
/*J08V*/   &IF "{&window-system}" = "TTY":U &THEN
/*J08V*/      /* Cleanup: hide the curretnly visible frames */
/*J14V*/ if valid-handle(current-window) then
/*J08V*/      frame-handle = current-window:last-child.
/*J08V*/      repeat while frame-handle <> ?:
/*J08V*/        h-save-frame-handle = frame-handle.
/*J08V*/        frame-handle = frame-handle:prev-sibling.
/*J08V*/        if h-save-frame-handle:visible then
/*J08V*/           h-save-frame-handle:visible = false.
/*J08V*/      end.
/*J08V*/      /* View the frames that where visible before */
/*J08V*/      DO J = 1 TO i-insens-counter:
/*J08V*/         if valid-handle(insens-handle[j]) then
/*J08V*/            insens-handle[j]:visible = TRUE.
/*J08V*/      END.
/*J08V*/     /* Reset the current menu-bar, if any */
/*J08V*/     run q-reset-menu-info in this-procedure.

   /* If running in Windows/Motif */
/*J08V*/   &ELSE
      /* Set current window and restore it (to normal size) */
/*J08V**  current-window = save-window. **/
/*G1M3**  save-window:window-state = window-normal. */
      current-window:sensitive = true.
      /* Get rid of the spawned window */
      if valid-handle(pgm-window) then
         delete widget pgm-window.
      /* Make all other windows that were sensitive sensitive again */
      DO J = 1 TO I:
        insens-handle[j]:SENSITIVE = TRUE.
      END.
      /* Reset toolbar handle */
      if valid-handle(save-tool-bar) then
         global-tool-bar-handle = save-tool-bar.
      else
         global-tool-bar-handle = ?.
/*J0Y7*/ /* remove "INSENSITIVE" marking */
/*J0Y7*/ save-window:private-data = "MFG/PRO":U.
      {gprun.i ""gpcursor.p"" "('')"}
/*J08V*/   &ENDIF
   /* Apply focus to widget or window that initiated the run */
   if valid-handle(save-focus) then if save-focus:sensitive then
      apply "ENTRY":U to save-focus.
   else
/*J14V*/ if valid-handle(save-window) then
      apply "ENTRY":U to save-window.

/*J08V* end. /* else do: */ **/

/* Set default "pause" behavior for standard programs, GUI will override */
pause before-hide.


PROCEDURE check-for-browse:
/*------------------------------------------------------------------------------
  Purpose:     to see if the input string conforms to browse naming conventions
  Parameters:  p-execname : character: name to be tested
               p-is-browse: logical  : yes it is or no it isn't
  Notes:       added J1PW
------------------------------------------------------------------------------*/
    define input  parameter p-execname  as character no-undo.
    define output parameter p-is-browse as logical   no-undo.
    define variable i-id as integer no-undo.

    assign i-id = integer(substring(p-execname, 5, 4, "RAW":U)) no-error.

    p-is-browse = (index(p-execname, "br":U) = 3) and not error-status:error.
END PROCEDURE.
