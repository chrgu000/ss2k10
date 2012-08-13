/*xxworcat03.p - CHANGE ATTRIBUTES -UPDATE PROGRAM                       */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9 $                                                    */
/* $Revision: 1.10 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 8.5    LAST MODIFIED: 12/10/97 BY: *J27X* Felcy D'Souza    */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E   LAST MODIFIED: 06/03/98 BY: *J2NL* Samir Bavkar     */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98 BY: *J314* Alfred Tan       */
/* REVISION: 8.6E   LAST MODIFIED: 03/25/99 BY: *J39K* Sanjeev Assudani */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00 BY: *N0KC* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.9 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*   */
/* Revision: 1.9     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*      */
/* $Revision: 1.10 $    BY: Vandna Rohira  DATE: 09/17/02 ECO: *N1V4*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* INCLUDE FILE SHARED VARIABLES */
{mfdeclre.i}
/* INPUT-OUTPUT PARAMETER DEFINITIONS */

define input parameter sr_recid as recid.
define input parameter tr_recid as recid.  /*RCT-TR TR_HIST*/
define input parameter tr_recno as recid.  /*RCT-WO TR_HIST*/
define input parameter part like wo_part.
define input parameter effect_date like glt_effdate no-undo.
define input-output parameter chg_assay  like tr_assay no-undo.
define input-output parameter chg_grade  like tr_grade no-undo.
define input-output parameter chg_expire like tr_expire no-undo.
define input-output parameter chg_status like tr_status no-undo.
define input-output parameter assay_actv like pt_rctwo_active no-undo.
define input-output parameter grade_actv like pt_rctwo_active no-undo.
define input-output parameter expire_actv like pt_rctwo_active no-undo.
define input-output parameter status_actv like pt_rctwo_active no-undo.
/* LOCAL VARIABLE DEFINITIONS */
define variable old_stat like ld_status no-undo.
define variable old_net as logical no-undo.
define variable new_net as logical no-undo.
define variable old_avail like mfc_logical no-undo.
define variable new_avail like mfc_logical no-undo.
define variable l_assay_actv  like pt_rctwo_active no-undo.
define variable l_grade_actv  like pt_rctwo_active no-undo.
define variable l_expire_actv like pt_rctwo_active no-undo.
define variable l_status_actv like pt_rctwo_active no-undo.

assign
   l_assay_actv  = assay_actv
   l_grade_actv  = grade_actv
   l_expire_actv = expire_actv
   l_status_actv = status_actv.

find sr_wkfl exclusive-lock
   where recid(sr_wkfl) = sr_recid
   no-error.
if not available sr_wkfl
then
   return.

find tr_hist exclusive-lock
   where recid(tr_hist) = tr_recid
   no-error.
if not available tr_hist
then
   return.

find ld_det
   where ld_part = part
   and ld_lot = sr_lotser
   and ld_ref = sr_ref
   and ld_site = sr_site
   and ld_loc = sr_loc
   exclusive-lock no-error.

if not available ld_det
then
   return.
old_stat = ld_status.

for first pt_mstr
   fields (pt_part pt_shelflife)
   where pt_part = part
   no-lock:

   if chg_expire = ?
      and pt_shelflife <> 0
   then
      chg_expire = effect_date + pt_shelflife.

end. /* FOR FIRST pt_mstr */

if l_assay_actv
   and chg_assay = ld_assay
then
   l_assay_actv = no.

if l_grade_actv
   and chg_grade = ld_grade
then
   l_grade_actv = no.

if l_expire_actv
   and chg_expire = ld_expire
then
   l_expire_actv = no.

if l_status_actv
   and chg_status = ld_status
then
   l_status_actv = no.

if l_assay_actv
   or l_grade_actv
   or l_expire_actv
   or l_status_actv
then do:
   /* CHANGE THE ATTRIBUTES */
   if l_assay_actv
   then
      assign
         ld_assay = chg_assay
         tr_assay = chg_assay.
   if l_grade_actv
   then
      assign
         ld_grade = chg_grade
         tr_grade = chg_grade.
   if l_expire_actv
   then
      assign
         ld_expire = chg_expire
         tr_expire = chg_expire.
   if l_status_actv
   then
      assign
         ld_status = chg_status
         tr_status = chg_status.
   
   /* UPDATE IN_MSTR VALUES */
   if old_stat <> ld_status
   then do:

      for first is_mstr
         fields (is_avail is_nettable is_status)
         where is_status = old_stat
         no-lock:

      assign
         old_avail = is_avail
         old_net = is_nettable.
      end. /* FOR FIRST is_mstr */

      for first is_mstr
         fields (is_avail is_nettable is_status)
         where is_status = ld_status
         no-lock:

      assign
         new_avail = is_avail
         new_net = is_nettable.
      end. /* FOR FIRST is_mstr */

      if old_net <> new_net or old_avail <> new_avail
      then do:

         find in_mstr
            where in_site = tr_site
            and   in_part = part
            exclusive-lock no-error.
         if available in_mstr
         then do:

            assign
               in_qty_oh = 0
               in_qty_nonet = 0
               in_qty_avail = 0.
   
            for each ld_det
               fields (ld_assay ld_expire ld_grade ld_loc  ld_lot
                       ld_part  ld_qty_oh ld_ref   ld_site ld_status)
               where ld_part = in_part
               and   ld_site = in_site
               no-lock ,
               each is_mstr
                  fields (is_avail is_nettable is_status)
                  where is_status = ld_status
                  no-lock:

               if is_nettable
               then
                  in_qty_oh = in_qty_oh + ld_qty_oh.
               else
                  in_qty_nonet = in_qty_nonet + ld_qty_oh.
               if is_avail
               then
                  in_qty_avail = in_qty_avail + ld_qty_oh.
               
               end. /* FOR EACH ld_det */
         end. /* IF AVAILABLE in_mstr */
      end. /* IF old_net <> new_net OR old_avail <> new_avail */
   end. /* IF old_stat <> ld_status */
   /* IF RCT SITE <> WIP SITE RESET ATTRIBUTES ON ORIGINAL RCT-WO */
   if tr_recid <> tr_recno
   then do:

      find tr_hist
         exclusive-lock
         where recid(tr_hist) = tr_recno
         no-error.
      if not available tr_hist
      then
         return.

      if l_assay_actv
      then
         tr_assay = chg_assay.

      if l_grade_actv
      then
         tr_grade = chg_grade.

      if l_expire_actv
      then
         tr_expire = chg_expire.

      if l_status_actv
      then
         tr_status = chg_status.

   end. /* IF tr_recid <> tr_recno */
end. /* IF l_assay_actv OR ... */
      
