/* podw.t PURCHASE ORDER LINE WRITE TRIGGER                                   */
/*Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.9 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/*  !Description : This program is a database trigger running                 */
/*          : everytime a record is changed.  It will create a                */
/*          : worktable and then call another program                         */
/*          :                                                                 */
/******************************************************************************/
/*                             MODIFY LOG                                     */
/******************************************************************************/
/* REVISION 8.5      LAST MODIFIED: 01/19/96   BY: *J0FY* BHolmes             */
/* REVISION 8.5      LAST MODIFIED: 06/25/96   BY: *J0M9* BHolmes             */
/* REVISION 8.5      LAST MODIFIED: 01/07/97   BY: *J1DM* jpm                 */
/* REVISION 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                 */
/* Old ECO marker removed, but no ECO header exists *J12B*                    */
/* Revision: 1.4       BY: Mark Christian        DATE: 09/09/01  ECO: *M1KG*  */
/* Revision: 1.5       BY: Jean Miller           DATE: 06/13/02  ECO: *P082*  */
/* Revision: 1.8       BY: Jean Miller           DATE: 08/01/02  ECO: *P0CL*  */
/* $Revision: 1.9 $    BY: Jean Miller           DATE: 08/17/02  ECO: *P0FN*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF POD_DET OLD BUFFER OLD_POD_DET.


/*ss - 20090401.1 - B*/
define var v_file as char format "x(60)" label "导入导出临时文件" initial "xxdbsync01.d" .

do:
    find first xpod_det 
	where xpod_nbr  = pod_det.pod_nbr 
	and   xpod_line = pod_det.pod_line 
    no-error .
    if not avail xpod_det then do:
	{xpod_det.i}
	/*{xxdbsync01.i "pod_det"  "xpod_det"}*/
    end.
    else /*if 
	 xpod_part   <> pod_det.pod_part
      or xpod_wo_lot <> pod_det.pod_wo_lot
      or xpod_op     <> pod_det.pod_op
    then*/ do:
	delete xpod_det .
	{xpod_det.i}
	/*{xxdbsync01.i "pod_det"  "xpod_det"}*/
    end. 
end.
/*ss - 20090401.1 - E*/


{mfdeclre.i }

define new shared work-table wf_old_pod_det like pod_det.

define new shared variable w-recid       as recid.
define new shared variable w-site-loc-id as character.
define new shared variable w-te_type     as character.

define variable w-file      as character format "x(24)".
define variable l-qualifier as character format "x(8)".

/* WAREHOUSING INTERFACE PROCESSING */

WI:
do:

   /* IF THERE IS NO ACTIVE EXTERNAL WAREHOUSE THAT IS FLAGGED TO     */
   /* RECEIVE PURCHASE ORDER EXPORT TRANSACTIONS, THEN DO NOT PROCESS */
   if not can-find(first whl_mstr no-lock
   where whl_mstr.whl_act
   and   whl_mstr.whl_po_exp)
   then
      leave WI.

   /* IF NO PERTINENT FIELDS HAVE BEEN CHANGED, THEN DO NOT PROCESS */
   if (old_pod_det.pod_nbr        = pod_det.pod_nbr
   and old_pod_det.pod_line       = pod_det.pod_line
   and old_pod_det.pod_part       = pod_det.pod_part
   and old_pod_det.pod_vpart      = pod_det.pod_vpart
   and old_pod_det.pod_desc       = pod_det.pod_desc
   and old_pod_det.pod_site       = pod_det.pod_site
   and old_pod_det.pod_loc        = pod_det.pod_loc
   and old_pod_det.pod_rev        = pod_det.pod_rev
   and old_pod_det.pod_qty_ord    = pod_det.pod_qty_ord
   and old_pod_det.pod_um         = pod_det.pod_um
   and old_pod_det.pod_um_conv    = pod_det.pod_um_conv
   and old_pod_det.pod_wo_lot     = pod_det.pod_wo_lot
   and old_pod_det.pod_op         = pod_det.pod_op
   and old_pod_det.pod_pur_cost   = pod_det.pod_pur_cost
   and old_pod_det.pod_status     = pod_det.pod_status
   and old_pod_det.pod_sched      = pod_det.pod_sched
   and old_pod_det.pod_due_date   = pod_det.pod_due_date
   and old_pod_det.pod_user1      = pod_det.pod_user1
   and old_pod_det.pod_user2      = pod_det.pod_user2
   and old_pod_det.pod_cum_qty[3] = pod_det.pod_cum_qty[3]
   and old_pod_det.pod_cmtindx    = pod_det.pod_cmtindx)
   then
      leave WI.

   /* MOVE OLD pod_det VALUES TO WORK TABLE FOR SUBSEQUENT PROCESSING */
   w-recid = recid(pod_det).

   create wf_old_pod_det.

   if recid(wf_old_pod_det)= -1
   then .

   assign
      wf_old_pod_det.pod_nbr        = old_pod_det.pod_nbr
      wf_old_pod_det.pod_line       = old_pod_det.pod_line
      wf_old_pod_det.pod_part       = old_pod_det.pod_part
      wf_old_pod_det.pod_vpart      = old_pod_det.pod_vpart
      wf_old_pod_det.pod_desc       = old_pod_det.pod_desc
      wf_old_pod_det.pod_site       = old_pod_det.pod_site
      wf_old_pod_det.pod_loc        = old_pod_det.pod_loc
      wf_old_pod_det.pod_rev        = old_pod_det.pod_rev
      wf_old_pod_det.pod_qty_ord    = old_pod_det.pod_qty_ord
      wf_old_pod_det.pod_um         = old_pod_det.pod_um
      wf_old_pod_det.pod_um_conv    = old_pod_det.pod_um_conv
      wf_old_pod_det.pod_wo_lot     = old_pod_det.pod_wo_lot
      wf_old_pod_det.pod_op         = old_pod_det.pod_op
      wf_old_pod_det.pod_pur_cost   = old_pod_det.pod_pur_cost
      wf_old_pod_det.pod_status     = old_pod_det.pod_status
      wf_old_pod_det.pod_sched      = old_pod_det.pod_sched
      wf_old_pod_det.pod_due_date   = old_pod_det.pod_due_date
      wf_old_pod_det.pod_user1      = old_pod_det.pod_user1
      wf_old_pod_det.pod_user2      = old_pod_det.pod_user2
      wf_old_pod_det.pod_cum_qty[3] = old_pod_det.pod_cum_qty[3]
      wf_old_pod_det.pod_cmtindx    = old_pod_det.pod_cmtindx.

   /* CALL SUBPROGRAM TO CREATE EXPORT TRANSACTIONS */
   w-file = "wipodw.p".

   {gprunmo.i &module="WI"
      &program="wipodw.p"}

end. /* WI */

/* Track Capacity Units */
if new pod_det and
  (old_pod_det.pod_nbr  <> pod_det.pod_nbr  or
   old_pod_det.pod_line <> pod_det.pod_line)
then do:

   l-qualifier = "".

   /* See if this is a Blanket PO */
   if can-find(first po_mstr where po_mstr.po_nbr = pod_det.pod_nbr
                               and po_mstr.po_blanket <> "")
   then
      l-qualifier = "BLANKET".
   else
      l-qualifier = "".

   /* If not a Blanket PO, is this a scheduled Line */
   if l-qualifier = "" and pod_det.pod_sched then
      l-qualifier = "SCHED".

   {lvucap.i &TABLE="pod_det" &QUALIFIER="l-qualifier"}

end.
