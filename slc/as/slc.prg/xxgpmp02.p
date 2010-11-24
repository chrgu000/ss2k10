/* gpmp02.p - Recalculate Materials Plan - MRP/DRP - Selective                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.6 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.2       LAST EDIT: 01/25/95   MODIFIED BY: *F0GM* Evan Bishop  */
/* REVISION: 8.5       LAST EDIT: 02/13/96   MODIFIED BY: *J0CW* TJS          */
/* REVISION: 8.5       LAST EDIT: 10/01/97   MODIFIED BY: *J225* VRP          */
/* REVISION: 8.6       LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan            */
/* REVISION: 9.1   LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane      */
/* REVISION: 9.1   LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown            */
/* $Revision: 1.7.1.6 $  BY: Jean Miller         DATE: 12/12/01  ECO: *P03N*  */
/* Revision: 1.7.1.4  BY: Tony Brooks DATE: 05/02/02 ECO: *P05X* */
/* $Revision: 1.7.1.6 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00F* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*****************************************************************************
 * Parameter definitions:
 *    module-code = the passed parameter indicating MRP or DRP module
 *              This is an integer value of either 1 or 2.
 *    calculation-mode = the passed parameter for net change/regen/selective
 *              This will have an integer value of 1, 2 or 3.
 * These values are determined by the menu level program which the user
 * selects and are not parameters over which the user has direct input
 * control.
 ******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define input parameter module-code as integer no-undo.
define input parameter calculation-mode as integer no-undo.

/* Define the shared variables used here and in called subroutines */
{gpmpvar2.i "new shared" }

/* define constants for mrp/drp net-change/regen/selective options */
{gpmpvar.i}

define variable use-app-server         like mfc_logical no-undo.
define variable returned-value         as character no-undo.
define variable threads-setup          as logical no-undo.

form
   part1          colon 25 part2 label {t001.i} colon 50
   site1          colon 25 site2 label {t001.i} colon 50 skip(1)
   ms             colon 30 buyer          colon 50
   non_ms         colon 30 prod_line      colon 50
   mrp            colon 30 ptgroup        colon 50
   drp            colon 30 part_type      colon 50
   mrp_req        colon 30 vendor         colon 50
   lowlevel       colon 30 pm_code        colon 50
   skip(1)
   sync_calc      colon 30
   sync_code      colon 30
   apps_threads   colon 30
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* Validate that correct software configuration values were used */
check-parms:
repeat:
   repeat:
      if (module-code = mrp-module or module-code = drp-module) and
         calculation-mode = selective
      then
         leave check-parms.

      /* Please contact your software support organization */
      {pxmsg.i &MSGNUM=971 &ERRORLEVEL=1}

      /* Software configuration error -- improper parameter value */
      {pxmsg.i &MSGNUM=970 &ERRORLEVEL=4}

      if batchrun = no then pause.
         leave.
   end.
   return.
end.

if calculation-mode = regeneration then mrp_req = no.

find first drp_ctrl  where drp_ctrl.drp_domain = global_domain no-lock no-error.
if available drp_ctrl then drp = drp_mrp.

find first mrpc_ctrl  where mrpc_ctrl.mrpc_domain = global_domain no-lock
no-error.
if available mrpc_ctrl then mrp = mrpc_drp.

if module-code = mrp-module then mrp = yes.
if module-code = drp-module then drp = yes.

site1 = global_site.
site2 = global_site.

/* Get default values from mfc_ctrl for AppServer*/

assign returned-value = "no".

if module-code = drp-module then do:
   {mfctrl01.i mfc_ctrl drp_use_apps returned-value}
end.
else do:
   {mfctrl01.i mfc_ctrl mrpc_use_apps returned-value}
end.

assign use-app-server = if returned-value = "yes" then yes else no.

if use-app-server = yes then do:

   assign sync_calc = no
          threads-setup = yes
      returned-value = "0".

   if module-code = drp-module then do:
      {mfctrl01.i mfc_ctrl drp_default_threads returned-value}
      {mfctrl01.i mfc_ctrl drp_apps_name apps-name}
   end.
   else do:
      {mfctrl01.i mfc_ctrl mrpc_default_threads returned-value}
      {mfctrl01.i mfc_ctrl mrpc_apps_name apps-name}
   end.

   assign apps_threads = integer(returned-value).

end.

main-loop:
repeat:

   if part2 = hi_char then part2 = "".
   if site2 = hi_char then site2 = "".

   update
      part1 part2
      site1 site2
      ms
      non_ms
      mrp
      drp
      mrp_req
      lowlevel
      sync_calc sync_code
      apps_threads
      buyer
      prod_line
      ptgroup
      part_type
      vendor
      pm_code
   with frame a.

   /* The drp control file gives MRP calculations permission
    * to calculate DRP items by setting the fields drp_mrp to yes.
    * If the user has changed a default value of no to yes, we'll
    * stop the process from proceeding. */
   if module-code = mrp-module and drp and
      ((available drp_ctrl and drp_ctrl.drp_mrp = no)
      or not available drp_ctrl)
   then do:
      /* Selection not permitted by <DRP> control file */
      {pxmsg.i &MSGNUM=292 &ERRORLEVEL=3 &MSGARG1="DRP"}
      next-prompt drp with frame a.
      undo, retry.
   end.

   /* The mrp control file gives DRP calculations permission
    * to calculate MRP items by setting the fields mrp_drp to yes.
    * If the user has changed a default value of no to yes, we'll
    * stop the process from proceeding. */
   if module-code = drp-module and mrp and
      ((available mrpc_ctrl and mrpc_ctrl.mrpc_drp = no)
      or not available mrpc_ctrl)
   then do:
      /* Selection not permitted by <MRP> control file */
      {pxmsg.i &MSGNUM=292 &ERRORLEVEL=3 &MSGARG1="MRP"}
      next-prompt mrp with frame a.
      undo, retry.
   end.

   /* Check to see if old sync_calc is selected and new apps_threads */

   if (sync_calc = yes or sync_code <> "") and apps_threads > 0 then do:
      /*Cannot use Synchronized Calculation with AppServer Threads*/
      {pxmsg.i &MSGNUM=5270 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* Check to see if threads > 99 */

   if apps_threads > 99 or apps_threads < 0 then do:
      /*Number of Threads cannot be greater than 99*/
      {pxmsg.i &MSGNUM=5268 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* check to see if appserver threads are setup */

   if threads-setup = no and apps_threads > 0 then do:
      /*No AppServer setup but number of Threads is greater than zero*/
      {pxmsg.i &MSGNUM=5271 &ERRORLEVEL=3}
      undo, retry.
   end.

   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,19,
        part1,part2,site1,site2,string(ms),string(non_ms),
        string(mrp),string(drp),string(mrp_req),string(lowlevel),
        string(sync_calc),sync_code,string(apps_threads),
        buyer,prod_line,ptgroup,part_type,vendor,pm_code,
        null_char)"}

   if part2 = "" then part2 = hi_char.
   if site2 = "" then site2 = hi_char.

   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site1, input site2, output return_int)"}
      if return_int = 0 then do:
         next-prompt site1 with frame a.
         undo main-loop, retry main-loop.
      end.
   end.

   hide message.

   /* Low level codes of 99999 indicate that something changed in the
    * definition of this item/site and its low level code needs to
    * be recalculated. Values of 88888 indicate a low level code
    * recalculation that was interrupted prior to completion and the
    * item in question still needs to have a valid level calculated. */
   if lowlevel = no then
   if can-find (first in_mstr  where in_mstr.in_domain = global_domain and (
   in_level = 99999))
   or can-find (first in_mstr  where in_mstr.in_domain = global_domain and (
   in_level = 88888))
   then do:
      /* Low level codes unresolved, items may not plan in proper sequence */
      {pxmsg.i &MSGNUM=255 &ERRORLEVEL=2}
   end.

   /* Select printed output device and batch processing ID (if any) */
   {mfselbpr.i "printer" 80 " " "stream log"}

   local-path = path.

   if batchrun = no then hide frame a.

   /* Main processing routine for MRP/DRP calculation */
/* ss 20071121 - b */
/*
   {gprun.i ""gpmpup.p""}
*/
   {gprun.i ""xxgpmpup.p""}
/* ss 20071121 - e */

   {mfphead2.i "stream log" "(log)"}

   page_counter = 0.

   {mftrl080.i "stream log" "(log)" }

   /* Process Complete */
   {pxmsg.i &MSGNUM=1107 &ERRORLEVEL=1}

end.
