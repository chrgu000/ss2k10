/* apvomta2.p - AP VOUCHER MAINTENANCE AVG COST DIALOG BOXES                  */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.10 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0     LAST MODIFIED: 03/03/92   BY: pma *F085*                 */
/*                                  04/10/92   BY: MLV *F380*                 */
/* REVISION: 7.2     LAST MODIFIED: 08/02/94   BY: pmf *FP80*                 */
/* REVISION: 7.3     LAST MODIFIED: 09/11/94   by: slm *GM17*                 */
/*                                  11/08/94   BY: str *FT48*                 */
/* REVISION: 7.4     LAST MODIFIED: 08/09/95   BY: jzw *G0VB*                 */
/*                                  09/26/95   by: jzw *G0YD*                 */
/* REVISION: 8.5     LAST MODIFIED: 07/26/96   BY: *J10X* Markus Barone       */
/*                                  09/17/96   BY: jzw *G2FM*                 */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane           */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan          */
/* REVISION: 8.6E    LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton        */
/* Pre-86E commented code removed, view in archive revision 1.7               */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas   */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.0     LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton        */
/* REVISION: 9.1     LAST MODIFIED: 11/01/99   BY: *N053* Jeff Wootton        */
/* REVISION: 9.1     LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.6  BY: Hareesh V.            DATE: 02/20/02  ECO: *P04F*  */
/* Revision: 1.8.1.7  BY: Jyoti Thatte DATE: 02/20/03 ECO: *P0MX* */
/* Revision: 1.8.1.9  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.8.1.10 $    BY: Steve Nugent DATE: 07/26/05  ECO: *P2PJ*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define new shared variable new_site   like si_site.
define new shared variable new_db     like si_db.
define            variable old_db     like si_db         no-undo.
define input parameter p-receipt-type like prh_type      no-undo.
define input parameter ip_vph_recid   as recid           no-undo.
define input-output parameter io_process_gl as logical   no-undo.
define input-output parameter io_vodamt2 like vod_amt    no-undo.


find vph_hist
   where recid(vph_hist) = ip_vph_recid
exclusive-lock.

/* CLEAR THE DEFAULT FROM THE INVENTORY/WIP FLAG */
assign
   vph_adj_inv = false
   vph_adj_wip = false.

if io_vodamt2 = 0
then
   return.
if     p-receipt-type <> " "
   and p-receipt-type <> "S"
then
   return.

/* NOTIFY APVOMTA.P THAT GL PROCESSING WILL BE NEEDED */
io_process_gl = yes.

for first pvo_mstr
   fields( pvo_domain pvo_id pvo_part pvo_shipto pvo_order pvo_line)
    where pvo_mstr.pvo_domain = global_domain and  pvo_id   = vph_pvo_id
   no-lock:
end. /* FOR FIRST pvo_mstr */

for first pod_det
   fields( pod_domain pod_line
          pod_nbr
          pod_op
          pod_wo_lot)
    where pod_det.pod_domain = global_domain and  pod_nbr  = pvo_order
   and   pod_line = pvo_line
no-lock:
end. /* FOR FIRST pod_det */


/* RUN INVENTORY/VARIANCE POPUP ON INVENTORY DATABASE */
assign
   old_db   = global_db
   new_site = pvo_shipto.
{gprun.i ""gpalias.p""}

{gprun.i ""apvomtab.p""
   "(input pvo_part,
     input pvo_shipto,
     input p-receipt-type,
     input pod_wo_lot,
     input pod_op,
     input-output vph_adj_inv,
     input-output vph_adj_wip
    )"}
new_db = old_db.
{gprun.i ""gpaliasd.p""}
