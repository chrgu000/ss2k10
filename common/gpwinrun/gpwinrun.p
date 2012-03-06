/* gpwinrun.p  - Run Program in a new window                                  */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/********************************** History **********************************
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
 * Revision: 9.1  Last Modified: 08/13/00  BY: *N0KS* myb                     */
/* Revision: 1.20        BY: Sathish Kumar       DATE: 08/01/01  ECO: *M1G7*  */
/* Revision: 1.21        BY: Jean Miller         DATE: 03/08/02  ECO: *N1BW*  */
/* Revision: 1.26        BY: Rajesh Lokre        DATE: 07/18/02  ECO: *P08G*  */
/* Revision: 1.28        BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00F*  */
/* Revision: 1.29        BY: Dayanand Jethwa     DATE: 02/04/04  ECO: *P1MC*  */
/* Revision: 1.30        BY: Bharath Kumar       DATE: 12/29/04  ECO: *P31X*  */
/* Revision: 1.31        BY: Manish Dani         DATE: 02/01/05  ECO: *P32Q*  */
/* Revision: 1.33        BY: Matthew Lee         DATE: 08/12/05  ECO: *P3SD*  */
/* Revision: 1.33.3.1    BY: Prashant Parab      DATE: 11/09/06  ECO: *P5DN*  */
/* $Revision: 1.33.3.3 $          BY: Dilip Manawat       DATE: 03/13/07  ECO: *P5R6*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/* NOTE: This programs makes windows currently opened unusable when a new
   program is spawned.  It does this by making all the frames and the
   menu-bar in the window insensitive.  There is a Progress bug with making
   the entire window insensitive: use of an alert-box message,
   set-wait-state, or dialog box will reactivate insensitive windows.
   MOD 09/28/95: Changed for character mode support: changed to hide
   frames instead of making them insensitive, and also changed to NOT spawn
   a new window, since character mode doesn't support multiple windows.
   Also allow for ".w" extension on programs
 ***************************************************************************/

/*V8:ConvertMode=NoConvert                                                    */
{mfdeclre.i}
{gplabel.i}
{pxsevcon.i}

define input parameter run-pgm   as character label "Program to run".
define input parameter run-title as character label "Title to display in window".

{mf1.i}
{gpmnsave.i}

define variable save-window         as widget-handle.
define variable save-focus          as widget-handle.
define variable save-tool-bar       as widget-handle.
define variable pgm-window          as widget-handle.
define variable insens-handle       as widget-handle extent 200.
define variable insens-handle-row   as decimal extent 200.
define variable insens-handle-col   as decimal extent 200.
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
define variable c-use-run-pgm       as character no-undo.
define variable h-save-menu-bar     as handle    no-undo.
define variable h-save-frame-handle as handle    no-undo.
define variable i-insens-counter    as integer   no-undo.
define variable l-is-browse         as logical   no-undo.

define variable thismenu       as character no-undo.
define variable v-old-prog     as character no-undo.
define variable v-old-menu     as integer   no-undo.
define variable v-old-sele     as character no-undo.

define variable l_application as character no-undo.
define variable l_undo        as logical   no-undo.
define variable l_sid         as character no-undo.
define variable l_mid         as character no-undo.
define variable l_runpgm      as character no-undo.
define variable l-sudden-exit as logical no-undo.

if index(run-pgm, ".") > 0
then do:
   if index(run-pgm, ".W") = 0 then
      run-pgm = substring(run-pgm, 1, index(run-pgm, ".")) + "P".
end.
else
   run-pgm = run-pgm + ".P".

/* STORE INITIAL VALUE BECAUSE IF THE 'MENU SUBSTITUTION' IS ACTIVATED */
/* EXECUTABLE FILE NAME STORED IN mnd_det WILL NOT MATCH run-pgm       */
l_runpgm = run-pgm.

if global-do-menu-substitution
then do:
   {gprun.i ""gpexcsub.p"" "(input-output run-pgm, output pgm-title)"}
   if pgm-title <> "" then
      run-title = pgm-title.
end.

assign
   run-pgm = lc(run-pgm)
   help_exec = run-pgm
   exec-rcode = replace(run-pgm, ".P", ".R")
   exec-rcode = lc(replace(exec-rcode, ".W", ".R"))
   c-use-run-pgm = "".

run check-for-browse
   (input run-pgm,
    output l-is-browse).

if l-is-browse then
   c-use-run-pgm = "gpcn200.w".
else do:

   if search(global_user_lang_dir +
             substring(run-pgm,1,2) + "/" + run-pgm) <> ?
   then
      c-use-run-pgm = run-pgm.

   if search(global_user_lang_dir + substring(exec-rcode,1,2) + "/"
                                  + exec-rcode) <> ?
   then
      c-use-run-pgm = exec-rcode.

   /* Browse Preview */
   if index(run-pgm,"zzbr001.p") <> 0 then
      run-pgm = "zzbr001.p".

   /* Lookup Preview */
   if index(run-pgm,"zzlu001.p") <> 0 then
      run-pgm = "zzlu001.p".

   if c-use-run-pgm = "" and
      run-pgm <> "zzbr001.p" and
      run-pgm <> "zzlu001.p" and
      not run-pgm begins "zzbr9" and
      run-title <> getTermLabel("BATCH",10)
   then do:
      /* PROGRAM NOT IN SYSTEM */
      {pxmsg.i &MSGNUM=7706 &ERRORLEVEL=3
               &MSGARG1=run-pgm}
      return error "ERROR".
   end.
end.

assign
   save-window = current-window
   save-focus = focus.

/* SET THE WINDOW'S NAME TO RUN WINDOW TITLE (USED IN CHAR MODE & DEBUGGING) */
if valid-handle(current-window) then
   current-window:name = run-title.

do on error undo, leave:

   /* IF RUNNING IN CHARACTER MODE, MAKE ALL CURRENTLY VISIBLE  */
   /* FRAMES NOT VISIBLE */
   &IF "{&window-system}" = "TTY" &THEN
      /* SAVE THE CURRENT MENU-BAR, IF ANY */
      run q-save-menu-info.

      i-insens-counter = 0.

      if valid-handle(current-window) then
         frame-handle = current-window:last-child.

      repeat while frame-handle <> ?:

         if i-insens-counter = 200 then
            leave.

         if frame-handle:visible
         then do:
            /* STORE THE ROW AND COLUMN OF THE FRAME TO DISPLAY IT IN */
            /* THE SAME POSITION, WHERE IT IS MADE INVISIBLE */
            assign
               i-insens-counter                    = i-insens-counter + 1
               insens-handle[i-insens-counter]     = frame-handle
               insens-handle-row[i-insens-counter] = frame-handle:row
               insens-handle-col[i-insens-counter] = frame-handle:col
               frame-handle:visible                = false.
         end.

         frame-handle = frame-handle:prev-sibling.

      end.

   /* IF RUNNING IN WINDOWS/MOTIF ...*/
   &ELSE
      /* STORE LIST OF ALL OTHER WINDOWS' FRAMES & MENUBARS TO */
      /* MAKE INSENSITIVE */
      /* (BECAUSE PROGRESS DOESN'T SUPPORT MDI & ISN'T MULTI-THREADED). */
      save-tool-bar = global-tool-bar-handle.
      window-handle = session:first-child. /* FIRST WINDOW */

      repeat while window-handle <> ?:

         if i = 200 then
            leave.

         /* MAKE SURE THAT THIS IS AN MFG/PRO WINDOW */
         if entry(1, window-handle:private-data) = "MFG/PRO"
         then do:

            if index(window-handle:private-data, "INSENSITIVE") = 0
            then do:
               window-handle:private-data = window-handle:private-data
               + ",INSENSITIVE".
            end.

            /* WINDOW'S MENU-BAR */
            if valid-handle(window-handle:MENU-BAR)
            then do:
               menu-handle = window-handle:menu-bar.
               if menu-handle:sensitive then
                  assign
                     i = i + 1
                     insens-handle[I] = window-handle:MENU-BAR.
            end.

            /* FRAMES IN THIS WINDOW */
            frm-handle = window-handle:FIRST-CHILD.
            repeat while frm-handle <> ?:
               if frm-handle:type = "FRAME" and
                  frm-handle:SENSITIVE = true
               then
                  assign
                     frm-handle:SENSITIVE = false
                     i = i + 1
                     insens-handle[I] = frm-handle.
               frm-handle = frm-handle:NEXT-SIBLING. /* NEXT FRAME */
            end.

         end.

         window-handle = window-handle:NEXT-SIBLING. /* NEXT WINDOW */

      end.

      /* CREATE WINDOW FOR CALLED PROGRAM TO RUN IN, BUT DON'T REALIZE IT */
      create window pgm-window
      assign
         title = run-title
         name = run-title
         width-chars = 80
         height-chars = 23
         sensitive = yes
         bgcolor = 8
         visible = false
         scroll-bars = yes
         three-d = true
         private-data = "MFG/PRO".

      /* CALC NEW ROW */
      newpos = max(save-window:row + 1,1).

      if (newpos + save-window:height-chars) > session:height-chars then
         newpos = 1.

      pgm-window:row = newpos.

      /* CALC NEW COLUMN */
      newpos = max(save-window:column + 2,1).

      if (newpos + save-window:width-chars) > session:width-chars then
         newpos = 1.

      assign
         pgm-window:column = newpos
         global-beam-me-up = no.

      /* PSTUFF FOR NON-GUI MFG/PRO PROGRAMS.  WILL BE OVERRIDDEN */
      /* IN NEW GUI PGMS*/
      /* THIS MAKES "WINDOW-CLOSE" OR MENU-ITEM "EXIT" ACT LIKE AN ESCAPE */
      /* (THIS IS THE BEST DEFAULT FOR UNCONVERTED PROGRAMS */
      on "WINDOW-CLOSE" of pgm-window do:

         if index(self:private-data, "INSENSITIVE") > 0 then
            return no-apply.

         global-beam-me-up = yes.

         if valid-handle(focus) then
         if focus:sensitive then
            apply "ENTRY" to focus.

         apply "END-ERROR".

      end.

      on entry of pgm-window do:
         current-window = pgm-window.
      end.

      current-window = PGM-WINDOW.
      apply "ENTRY" to pgm-window.

      /* NEW WINDOW IS NOW CREATED & IN FOCUS, MAKE ALL OTHER */
      /* WINDOWS UNUSABLE */
      do j = 1 to i:
         insens-handle[J]:SENSITIVE = false.
         /* HIDE ANY "NAVIGATE" WINDOWS */
         if insens-handle[j]:type = "FRAME"
         then do:
            window-handle = insens-handle[j]:parent.
            if window-handle:title = getTermLabel("NAVIGATE",16)
            then
               window-handle:hidden = true.
         end.
      end.

      {gprun.i ""gpcursor.p"" "('WAIT')"}

   &ENDIF

   session:APPL-ALERT-BOXES = false.

   if valid-handle(current-window)
   then do:

      on "go" of current-window anywhere do:

         if valid-handle(self)
         then do:
            apply "go" to self.
            /* TO CHECK FAILURE IF FOCUS & SELF       */
            /* IS SAME AND EXECUTE INST BUTTON IF NOT */
            if (session:display-type <> "tty" )
               and (self <> focus )
               and valid-handle(global-drop-down-utilities)
               and global-drop-downs
            then
               run p-instantiate-button in global-drop-down-utilities
                  (input focus).
         end.
         return no-apply.

      end.

      on "F4" of current-window anywhere do:
         if valid-handle(self) then
            apply "F4" to self.
      end.

      on "ESC" of current-window anywhere do:
         if valid-handle(self) then
            apply "ESC" to self.
      end.

      on "END-ERROR" of current-window anywhere do:
         if valid-handle(self) then
            apply "END-ERROR" to self.
      end.

      on "ESC-F" of current-window anywhere do:
         if valid-handle(self) then
            apply "ESC-F" to self.
      end.

   end.

   assign
      save-execname = execname
      execname = run-pgm.

   /* FIND mnd_det USING THE VALUE OF run-pgm PRIOR TO MENU SUBSTITUTION */
   find first mnd_det where mnd_exec = l_runpgm
   no-lock no-error.

   if available mnd_det then
      thismenu = mnd_det.mnd_nbr +  "." + string(mnd_select).
   else
      thismenu = "".

   /* Get the name of the Application this executable belongs to */
   {gprunp.i "lvgenpl" "p" "getApplicationOwner"
      "(input  execname,
        input  yes,
        output l_application)"}

   if return-value = {&INVALID-LICENSE}
   then do:
      l_undo = yes.
      return error "ERROR".
   end.

   assign
      l_sid = mfguser
      l_mid = mfguser.

   /* RECORD ACTIVITY OF USER FOR MFG/PRO AND ADD-ON MODULE */
   {gprun.i ""lvalogin.p""
      "(input  thismenu,
        input  run-pgm,
        input  1,
        input  l_application,
        output l_undo,
        input-output l_sid,
        input-output l_mid)"}

   if l_undo
   then do:

      run reset_original_window.
      return error "ERROR".

   end. /* IF l_undo */

   /* TO EXECUTE ADD WINDOW FOR ALL GUI */
   /* PGMS TO ACCESS LOOKUP             */
   if (session:display-type <> "tty" )
      and valid-handle(global-drop-down-utilities)
   then
      run p-add-window in global-drop-down-utilities
         (input execname,
          input pgm-window).

   /* If Preview of Browse or running Batch */
   if run-pgm = "zzbr001.p"
   or run-pgm = "zzlu001.p"
   or run-title = getTermLabel("BATCH",10)
   then do on error undo, leave:
      if run-title = getTermLabel("BATCH",10) then
         dtitle = substring(dtitle,16,50).
      run value(run-pgm).
   end.

   /* All other Programs */
   else do on error undo, leave:

      ststatus = stline[3].
      status input ststatus.

      run clear-browse-tables.

      if c-use-run-pgm = "gpcn200.w" /* if launching CHUI PowerBrowse */
      then do:
         l-sudden-exit = true.
         trap-interrupt-a:
         do on stop undo, leave trap-interrupt-a:
            {gprun.i ""gpcn200.w"" "(input run-pgm)"}
            l-sudden-exit = false.
         end.
         /* Get rid of mon_mstr/cnt_mstr record if user abruptly
          * exit from the CHAR UI PowerBrowse.
          */
         if l-sudden-exit
         then do:
            /* PERFORM CLEANUP ON BROWSE COMPONENTS */
            run destructor.

            /* REMOVE RELATED mon_mstr/cnt_mstr RECORD */
            {gprun.i ""lvalogin.p""
               "(input  thismenu,
                 input  run-pgm,
                 input  2,
                 input  l_application,
                 output l_undo,
                 input-output l_sid,
                 input-output l_mid)"}
            run clear-browse-tables.

            /* DELETE THE AUDIT TEMPFILES IF ANY */
            run tmpclean.

            stop. /* RETURN TO START PROCEDURE ON CTRL-C */
         end. /* IF l-sudden-exit */
      end. /* IF c-use-run-pgm */
      else do: /* i.e. if not dealing with a CHAR UI Power Browse */
         /* use 'l-sudden-exit' to track whether an interrupt was sent
          * to stop the execution of the invoked program via gprun1.i */
         l-sudden-exit = true.
         trap-interrupt-b:
         do on stop undo, leave trap-interrupt-b:
            {gprun1.i c-use-run-pgm}
            l-sudden-exit = false.
         end. /* trap-interrupt-b */

         /* Under DTUI (either HTML or emb telnet), need to remove
          * mon_mstr/cnt_mstr records regardless of how the user exited
          * the program */
         if {gpiswrap.i} or c-application-mode = "web-chui" then do:

            /* remove related mon_mstr/cnt_mstr record */
            {gprun.i ""lvalogin.p""
               "(input  thismenu,
                 input  run-pgm,
                 input  2,
                 input  l_application,
                 output l_undo,
                 input-output l_sid,
                 input-output l_mid)"}

            /* if user exited program using ctrl-C or equivalent under DT
             * then return error to calling pgm */
            if l-sudden-exit
            then do:
               /* DELETE THE AUDIT TEMPFILES IF ANY */
               run tmpclean.

               return error.
            end.
         end. /* if {gpiswrap.i} or c-application-mode ... */
         else do:  /* i.e. running CHAR UI */
            /* if running CHAR UI, then only remove mon_mstr/cnt_mstr
             * completely if encountered a ctrl-c */
            if l-sudden-exit then do:
               /* remove related mon_mstr/cnt_mstr record */
               {gprun.i ""lvalogin.p""
                  "(input  thismenu,
                    input  run-pgm,
                    input  2,
                    input  l_application,
                    output l_undo,
                    input-output l_sid,
                    input-output l_mid)"}

               /* DELETE THE AUDIT TEMPFILES IF ANY */
               run tmpclean.

               stop. /* return to start procedure on ctrl-C */
            end.
         end. /* running CHAR UI */
      end.  /* i.e. if not dealing with a CHAR UI Power Browse */

   end. /* else do on error undo, leave: */

   /* If this program runs to this point, it indictes that the user
    * has exited a function screen "gracefully" (i.e. no ctrl-c), so the
    * following invocation of lvalogin.p will tidy up mon_mstr/cnt_mstr
    * (if any is stranded), AND update the license useage table
    * (lua_det) for non-MFGPRO functions (i.e. where
    *  l_application <> "MFG/PRO"). */

   /* RECORD ACTIVITY OF USER FOR MFG/PRO AND ADD-ON MODULE */
   {gprun.i ""lvalogin.p""
      "(input  thismenu,
        input  run-pgm,
        input  0,
        input  l_application,
        output l_undo,
        input-output l_sid,
        input-output l_mid)"}

   if l_undo then
      return error "ERROR".

   execname = save-execname.

   /* RESET THE WINDOW'S NAME TO BLANK (USED IN CHAR MODE & DEBUGGING) */
   if valid-handle(current-window)
   then do:

      current-window:name = "".

      on "go" of current-window anywhere
         revert.
      on "F4" of current-window anywhere
         revert.
      on "ESC" of current-window anywhere
         revert.
      on "END-ERROR" of current-window anywhere
         revert.
      on "ESC-F" of current-window anywhere
         revert.
   end.

end.

/* TO EXECUTE DELETE WINDOW WHEN     */
/* ALL PGMS EXCEPT GPRPTWIN RETURN   */
if (session:display-type <> "tty" )
   and valid-handle(global-drop-down-utilities)
then
   run p-delete-window in global-drop-down-utilities
      (input pgm-window).

run reset_original_window.


/* SET DEFAULT "PAUSE" BEHAVIOR FOR STANDARD PROGRAMS, */
/* GUI WILL OVERRIDE */
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

   assign i-id = integer(substring(p-execname, 5, 4, "RAW")) no-error.

   p-is-browse = (index(p-execname, "br") = 3) and not error-status:error.

END PROCEDURE.

PROCEDURE clear-browse-tables:
/*------------------------------------------------------------------------------
  Purpose:     Run routines inside gpbrqgen.p to clear temp tables
  Parameters:  None
  Notes:       added N1BW
------------------------------------------------------------------------------*/

   define variable h-manager as handle no-undo.
   define buffer qadwkfl for qad_wkfl.

   /* GET THE HANDLE OF THE BROWSE MANAGER */
   h-manager = session:first-procedure.

   do while valid-handle(h-manager):
      if index(h-manager:filename, "gpbrqgen") > 0 then leave.
      h-manager = h-manager:next-sibling.
   end.

   /* REMOVE THE TEMP-TABLE RECORDS FOR THE BROWSE PARAMETERS */
   if valid-handle(h-manager)
   then do:
      run findBrowseID        in h-manager.
      run removeLookupContext in h-manager.
   end.  /* IF VALID-HANDLE(h-manager) */

   /* Remove the Browse Branch Records */
   for each qadwkfl  where qadwkfl.qad_domain = global_domain and  qad_key1 =
   mfguser + "Lookup"
   exclusive-lock:
      delete qadwkfl.
   end.

END PROCEDURE. /* clear-browse-tables */

PROCEDURE reset_original_window:

   if valid-handle(save-window)
   then
      current-window = save-window.

   /* IF RUNNING IN CHARACTER MODE, MAKE ALL CURRENTLY VISIBLE FRAMES */
   /* NOT VISIBLE */
   &IF "{&window-system}" = "TTY"
   &THEN

      /* CLEANUP: HIDE THE CURRENTLY VISIBLE FRAMES */
      if valid-handle(current-window)
      then
         frame-handle = current-window:last-child.

      repeat while frame-handle <> ?:

         assign
            h-save-frame-handle = frame-handle
            frame-handle        = frame-handle:prev-sibling.

         if h-save-frame-handle:visible
         then
            h-save-frame-handle:visible = false.

      end. /* REPEAT WHILE frame-handle <> ? */

      /* VIEW THE FRAMES THAT WERE VISIBLE BEFORE */
      do j = 1 to i-insens-counter:

         if valid-handle(insens-handle[j])
         then do:

            /* POSITION THE FRAME IN THE SAME PLACE WHERE IT */
            /* IS MADE INVISIBLE */
            insens-handle[j]:visible = true.

            /* OVERLAY FRAME SHOULD NOT ASK FOR AN EXTRA KEY STROKE */
            pause 0.

         end. /* IF VALID-HANDLE(insens-handle[j]) */

      end.  /* DO j = 1 TO i-insens-counter */

      /* RESET THE CURRENT MENU-BAR, IF ANY */
      run q-reset-menu-info.

   /* IF RUNNING IN WINDOWS/MOTIF */
   &ELSE

      /* SET CURRENT WINDOW AND RESTORE IT (TO NORMAL SIZE) */
      current-window:sensitive = true.

      /* GET RID OF THE SPAWNED WINDOW */
      if valid-handle(pgm-window)
      then
         delete widget pgm-window.

      /* MAKE ALL OTHER WINDOWS THAT WERE INSENSITIVE SENSITIVE AGAIN */
      do j = 1 to i:
         insens-handle[j]:sensitive = true.
      end. /* DO j = 1 TO i */

      /* RESET TOOLBAR HANDLE */
      if valid-handle(save-tool-bar)
      then
         global-tool-bar-handle = save-tool-bar.
      else
         global-tool-bar-handle = ?.

      save-window:private-data = "MFG/PRO".

      {gprun.i ""gpcursor.p"" "('')"}

   &ENDIF

   /* APPLY FOCUS TO WIDGET OR WINDOW THAT INITIATED THE RUN */
   if valid-handle(save-focus)
   then
      if save-focus:sensitive
      then
         apply "ENTRY" to save-focus.
      else
         if valid-handle(save-window)
         then
            apply "ENTRY" to save-window.

END PROCEDURE. /* reset_original_window */

PROCEDURE destructor:
/* ---------------------------------------------------------------------
   Purpose:     Perform cleanup on Browse Components
   Parameters:  <none>
   Notes:
 -----------------------------------------------------------------------*/

   define variable h-manager    as handle no-undo.
   define variable h-browse     as handle no-undo.
   define variable h-bframe     as handle no-undo.
   define variable h-lib-handle as handle no-undo.

   if valid-handle(h-bframe)
   then do:
      run q-hide-frame in h-browse.
   end. /* IF VALID-HANDLE(h-bframe) */

   if valid-handle(h-lib-handle)
   then do:
     run lib-destroy-records in h-lib-handle
        (input this-procedure).
   end. /* IF VALID-HANDLE(h-lib-handle) */

   if valid-handle(h-browse)
   then
      delete procedure h-browse no-error.

   return "".

END PROCEDURE. /* destructor */

PROCEDURE tmpclean:
/* ---------------------------------------------------------------------
   Purpose:     Delete Audit Temp files
   Parameters:  <none>
   Notes:
 -----------------------------------------------------------------------*/
   define variable l_cnt        as integer.
   define variable l_file_name  as character.
   define variable l_file_nameb as character.

   for first gl_ctrl where gl_ctrl.gl_domain = global_domain no-lock:
   end.
   if available gl_ctrl and gl__qad01 = 1
   then do:
      do l_cnt = 0 to 99 :
         l_file_name  = string(mfguser) + "." +  string(l_cnt, "99").
         l_file_nameb = search(l_file_name).
         if l_file_nameb <> ?
         then do:
            {gpfldel2.i &filename = l_file_nameb}
         end. /*IF file_nameb*/
      end. /*DO l_cnt*/
   end. /*IF AVAILABLE gl_ctrl*/

   return "".

END PROCEDURE. /* tmpclean */
