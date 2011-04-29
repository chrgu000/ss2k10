/* gpmp01.p - Recalculate Materials Plan - MRP/DRP - Net Change or Regen      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.4 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.2       LAST EDIT: 01/25/95   MODIFIED BY: *F0GM* Evan Bishop  */
/* REVISION: 8.5       LAST EDIT: 02/13/96   MODIFIED BY: *J0CW* TJS          */
/* REVISION: 8.5       LAST EDIT: 10/01/97   MODIFIED BY: *J225* VRP          */
/* REVISION: 8.6   LAST MODIFIED: 03/03/98   BY: *J23R* Sandesh Mahagaokar    */
/* REVISION: 9.1   LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane      */
/* REVISION: 9.1   LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown            */
/* $Revision: 1.9.1.4 $  BY: Jean Miller        DATE: 12/12/01  ECO: *P03N*  */
/* $Revision: 1.9.1.4 $ BY: Tony Brooks    DATE: 05/02/02  ECO: *P05X*          */


/* $Revision: ss - 090616.1  $    BY: mage chen : 05/14/09 ECO: *090616.1*    */


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
{mfdtitle.i "090616.1"}

define input parameter module-code as integer no-undo.
define input parameter calculation-mode as integer no-undo.

/* Define the shared variables used here and in called subroutines */
{gpmpvar2.i "new shared" }

/* Define constants for mrp/drp net-change/regen/selective options */
{gpmpvar.i}

define variable use-app-server       like mfc_logical no-undo.
define variable returned-value       as character no-undo.
define variable threads-setup        as logical no-undo.


form
   site1          colon 30 site2 label {t001.i} colon 45 skip(1)
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
         (calculation-mode = net-change or calculation-mode = regeneration)
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

for first drp_ctrl
   fields(drp_mrp)
no-lock: end.

if available drp_ctrl then
   drp = drp_mrp.

for first mrpc_ctrl
   fields(mrpc_drp)
no-lock: end.

if available mrpc_ctrl then
   mrp = mrpc_drp.

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


if module-code = mrp-module then mrp = yes.
if module-code = drp-module then drp = yes.

assign
   site1 = global_site
   site2 = global_site.

main-loop:
repeat:

   if part2 = hi_char then part2 = "".
   if site2 = hi_char then site2 = "".

   update
      site1 site2
      sync_calc sync_code
      apps_threads
   with frame a.

   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,5,
        site1,site2,string(sync_calc),sync_code,
        string(apps_threads),
        null_char,null_char,null_char,
        null_char,null_char,null_char,null_char,
        null_char,null_char,null_char,null_char,
        null_char,null_char,null_char,null_char)"}


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
   if can-find (first in_mstr where in_level = 99999)
   or can-find (first in_mstr where in_level = 88888)
   then do:
      /* Low level codes unresolved, items may not plan in proper sequence */
      {pxmsg.i &MSGNUM=255 &ERRORLEVEL=2}
   end.

   /* Select printed output device and batch processing ID (if any) */
   {mfselbpr.i "printer" 80 " " "stream log"}

   local-path = path.

   if batchrun = no then hide frame a.

   /* Main processing routine for MRP/DRP calculation */
/* ss - 090616.1 - b*
   {gprun.i ""gpmpup.p""}
* ss - 090616.1 - e*/
/* ss - 090616.1 - b*/
   {gprun.i ""xxgpmpup.p""}
/* ss - 090616.1 - e*/
   {mfphead2.i "stream log" "(log)"}

   page_counter = 0.

   {mftrl080.i "stream log" "(log)" }

   /* Process complete */
   {pxmsg.i &MSGNUM=1107 &ERRORLEVEL=1}

end.
