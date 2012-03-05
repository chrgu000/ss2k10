/* spmrpuc.p - OPERATIONS PLAN APPROVAL (PO REQUISITIONS)                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.6.1.7 $                                                       */
/* REVISION: 8.5      LAST MODIFIED:  09/29/95     BY: amw  *J078*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.5      LAST MODIFIED: 08/13/98   BY: *J2V2* Patrick Rowan  */
/* REVISION: 8.6E     LAST MODIFIED: 09/28/98   BY: *L09T* A. Philips     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 08/01/00   BY: *N0HB* Arul Victoria  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown     */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *N0TN* Jean Miller    */
/* Revision: 1.6.1.5    BY: Reetu Kapoor   DATE: 05/02/01 ECO: *M162*         */
/* Revision: 1.6.1.6    BY: Niranjan R.    DATE: 07/13/01 ECO: *P00L*         */
/* $Revision: 1.6.1.7 $   BY: Sandeep P.   DATE: 08/24/01 ECO: *M1J7*         */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}

define new shared variable wo_recno    as   recid.
define new shared variable prev_status like wo_status.
define new shared variable prev_qty    like wo_qty_ord.
define new shared variable prev_due    like wo_due_date.
define new shared variable due_date    like wo_due_date.
define new shared variable del-joint   like mfc_logical.

define variable del_wo    like mfc_logical.
define variable leadtime  like pt_mfg_lead.
define variable glx_mthd  like cs_method.
define variable glx_set   like cs_set.
define variable cur_mthd  like cs_method.
define variable cur_set   like cs_set.
define variable prev_mthd like cs_method.
define variable know_date as date.
define variable find_date as date.
define variable interval  as integer.
define variable frwrd     as integer.

define shared variable a_recid as recid no-undo.

define shared variable using_grs   like mfc_logical no-undo.
define shared variable grs_req_nbr like req_nbr no-undo.
define shared variable a_ok_cntr   as integer no-undo.
define variable grs_return_code
   as integer no-undo.

define variable remarks_text like rqm_rmks no-undo.

assign
   remarks_text =  getTermLabel("OPERATIONS_PLANNED_ORDER", 40).

define shared workfile a no-undo
   field a_part   like fp1_part
   field a_site   like fp1_site
   field a_line   like flp_line
   field a_date   like mfc_date
   field a_qty    like mrp_qty
   field a_id     like wo_lot
   field a_ok     like mfc_logical
   field a_req    like req_nbr
   field a_req_line like pod_line
   field a_recno  as   recid
   field a_bucket like mfc_integer.

define new shared temp-table tt-rqm-mstr no-undo
    field tt-vend   like rqm_mstr.rqm_vend
    field tt-nbr    like rqm_mstr.rqm_nbr
    field tt-line   like rqd_det.rqd_line
    field tt-part   like rqd_det.rqd_part
    field tt-yn     like mfc_logical
    field tt-wo-nbr like wo_nbr
    field tt-wo-lot like wo_lot
    index vend is primary
       tt-vend
       tt-nbr
       tt-line
    index ttnbrlot
       tt-wo-nbr
       tt-wo-lot
    index ttnbr
       tt-nbr.

/* NOW WE HAVE TO CREATE REQUSITIONS */
find first gl_ctrl no-lock no-error.

find a where recid(a) = a_recid no-error.
find wo_mstr where wo_lot = a_id no-error.
if available wo_mstr then do:
/* DELETE OPERATIONS PLANNING EXPLOSION WORK ORDER */
   wo_recno = recid(wo_mstr).
   {gprun.i ""wowomte.p""}
end.

a_id = "".

if using_grs then do:

   if a_ok_cntr = 1 then do:

      /* GET NEXT GRS REQUISITION NUMBER */
      {gprunmo.i
         &program = "mrprapa1.p"
         &module="GRS"
         &param="""(output grs_return_code,
                               output grs_req_nbr)"""}

      if grs_return_code <> 0 then
         undo, leave.

   end.  /* END - if a_ok_cntr = 1 */

   /* CREATE GRS REQUISITION LINE */
   {gprunmo.i
      &program = "mrprapa2.p"
      &module="GRS"
      &param="""(input a_ok_cntr,
                               input grs_req_nbr,
                               input a_part,
                               input a_site,
                               input a_qty,
                               input a_date,
                               input a_date,
                               input remarks_text,
                               output grs_return_code)"""}

   if grs_return_code <> 0 then
      undo, leave.

   /* UPDATE WORK TABLE WITH REQ. AND LINE */
   assign
      a_req       = grs_req_nbr
      a_req_line  = a_ok_cntr.

end.  /* END - if using_grs */
else do:

   find first req_det where
      req_part = a_part and
      req_site = a_site and
      req_need = a_date no-error.
   if available req_det then do:
      req_qty = a_qty.

      /* Changed pre-processor to Term: PURCHASE_REQUISITION */
      {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
         req_rel_date req_need
         "req_qty" "SUPPLYF" PURCHASE_REQUISITION req_site}
   end.

   else if a_qty <> 0 then do:
      create req_det.
      assign
         req_line = 0
         req_part = a_part
         req_site = a_site
         req_qty  = a_qty
         req_acct = (if available gl_ctrl then gl_pur_acct else "")
         req_sub  = (if available gl_ctrl then gl_pur_sub  else "")
         req_cc   = (if available gl_ctrl then gl_pur_cc   else "")
         req_need = a_date.

         if recid(req_det) = -1 then .

      {mfnctrl.i woc_ctrl woc_nbr req_det req_nbr req_nbr}
      /* GET ACCOUNTS */
      find pt_mstr where pt_part = req_part no-lock no-error.
      if available pt_mstr then do:
         req_um = pt_um.
         find pl_mstr
            where pl_prod_line = pt_prod_line no-lock no-error.
         if available pl_mstr and pl_pur_acct <> "" then do:
            {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                                      input pl_prod_line,
                                      input a_site,
                                      input """",
                                      input """",
                                      input no,
                                      output req_acct,
                                      output req_sub,
                                      output req_cc)"}
         end.
      end.

      /* GET PO SITE */
      find ptp_det where ptp_part = a_part and ptp_site = a_site
         no-lock no-error.
      if available ptp_det then
            req_po_site = ptp_po_site.
      else
            req_po_site = req_site.

      if available pt_mstr then
         leadtime = pt_pur_lead.
      if req_rel_date = ? then
         req_rel_date = req_need - leadtime.
      {mfhdate.i req_rel_date -1 req_site}

      /* Changed pre-processor to Term: PURCHASE_REQUISITION */
      {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
         req_rel_date req_need
         "req_qty" "SUPPLYF" PURCHASE_REQUISITION req_site}

      /* default approval codes */
      {gppacal.i}

   end.  /* else if a_qty <> 0 */

   /* UPDATE WORK TABLE WITH REQ. AND LINE */
   assign
      a_req       = req_nbr
      a_req_line  = req_line.

end.  /* else do */
