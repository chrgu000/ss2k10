/* apvomta3.p - AP VOUCHER MAINTENANCE COST UPDATE ROUTINES                   */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* REVISION: 7.0     LAST MODIFIED: 03/03/92   BY: pma *F085*                 */
/* REVISION: 7.0     LAST MODIFIED: 04/10/92   BY: MLV *F380*                 */
/* REVISION: 7.0     LAST MODIFIED: 04/14/92   BY: PMA *F387*                 */
/* REVISION: 7.3     LAST MODIFIED: 02/25/93   BY: pma *G032*                 */
/* REVISION: 7.3     LAST MODIFIED: 05/15/93   BY: pma *GB00*                 */
/*                                  06/08/93   by: jms *GB87*                 */
/* REVISION: 7.4     MAJOR REWRITE: 02/25/94   BY: pcd *H199*                 */
/*                   LAST MODIFIED: 04/04/94   by: pcd *H313*                 */
/*                                  01/19/95   by: pmf *F0DC*                 */
/*                                  09/01/95   by: jzw *G0VB*                 */
/* REVISION: 8.5     LAST MODIFIED: 10/06/95   BY: mwd *J053*                 */
/* REVISION: 8.5     LAST MODIFIED: 07/26/96   BY: *J10X* Markus Barone       */
/* REVISION: 8.6     LAST MODIFIED: 09/03/96   BY: jzw *K008*                 */
/* REVISION: 8.6     LAST MODIFIED: 10/13/97   BY: *H0ZP* Samir Bavkar        */
/* REVISION: 8.6E    LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton        */
/* Pre-86E commented code removed, view in archive revision 1.12              */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas   */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.0     LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton        */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari     */
/* REVISION: 9.1     LAST MODIFIED: 11/01/99   BY: *N053* Jeff Wootton        */
/* REVISION: 9.1     LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14.1.7    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.14.1.8    BY: Ellen Borden   DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.14.1.9    BY: Patrick Rowan  DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.14.1.10   BY: Jose Alex     DATE: 08/02/02  ECO: *M1XR* */
/* Revision: 1.14.1.11  BY: Jyoti Thatte DATE: 02/21/03 ECO: *P0MX* */
/* Revision: 1.14.1.13  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.14.1.14 $  BY: Steve Nugent DATE: 07/26/05 ECO: *P2PJ*        */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/
/* Cost posting code moved to apvomtk3.p with patch H199.               */
/* All code here is new code extracted from the old apvomta3.p          */
/* The new job of apvomta3.p, after rewrite, is to determine which      */
/* accounts to use for variances; see the parameter list for details.   */
/************************************************************************/

{mfdeclre.i}
{apconsdf.i}

define input parameter vo_recno                as recid.
define input parameter vph_recno               as recid.
define input parameter prh_recno               as recid.

define input-output parameter apratevar_amt    like vod_amt.
define input-output parameter apdiscrep_amt    like vod_amt.
define input-output parameter apratevar_acc    like vod_acct.
define input-output parameter apdiscrep_acc    like vod_acct.
define input-output parameter apratevar_sub    like vod_sub.
define input-output parameter apdiscrep_sub    like vod_sub.
define input-output parameter apratevar_cc     like vod_cc.
define input-output parameter apdiscrep_cc     like vod_cc.

define variable totl_amt       like glt_amt.

define variable taxamt           like glt_amt             no-undo.
define variable taxamt_this_tx2d like glt_amt             no-undo.
define variable tax_on_vph_price like sct_mtl_tl          no-undo.
define variable tax_on_receipt   like sct_mtl_tl          no-undo.
define variable rcpt_tr_type     like tx2d_tr_type        no-undo.
define variable i                as   integer             no-undo.

define variable tax_ref          like tx2d_ref            no-undo.
define variable tax_nbr          like tx2d_nbr            no-undo.
define variable l_adj_inv        like mfc_logical         no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable old_db           like si_db no-undo.
define variable pickup_pl_accts as logical no-undo.

define shared variable rndmthd like rnd_rnd_mthd.

define new shared variable new_site like si_site.
define new shared variable new_db like si_db.

/* VARIABLE DEFINITIONS AND COMMON PROCEDURE TO GET NEW pvod_det FIELDS FROM  */
/* THE qtbl_ext TABLE USING gpextget.i.                                       */
{pocnpvod.i}
for first vo_mstr
      fields( vo_domain vo_curr
      vo_confirmed
      vo_ex_rate
      vo_ex_rate2)
      where recid(vo_mstr) = vo_recno
      no-lock:
end.

for first vph_hist
      fields( vph_domain vph_ref
      vph_inv_cost
      vph_adj_amt
      vph_dscr_amt
      vph_adj_inv
      vph_qoh_at_adj
      vph_pvo_id
      vph_pvod_id_line
      vph_adj_wip)
      where recid(vph_hist) = vph_recno
      no-lock:
end.

for first pvo_mstr
    where pvo_mstr.pvo_domain = global_domain and  pvo_id = vph_pvo_id
     and pvo_internal_ref_type = {&TYPE_POReceiver}
     and pvo_lc_charge    = ""
   no-lock:
end.

for first prh_hist
      fields( prh_domain prh_nbr
      prh_line
      prh_part
      prh_site
      prh_po_site
      prh_type
      prh_rcp_type
      prh_receiver
      prh_um_conv)
      where recid(prh_hist) = prh_recno
      no-lock:
end.

for first pod_det
      fields( pod_domain pod_wo_lot pod_consignment pod_op pod_nbr)
       where pod_det.pod_domain = global_domain and  pod_nbr = prh_nbr
      and pod_line = prh_line
      no-lock:
end.

for first gl_ctrl
      fields( gl_domain gl_rnd_mthd)
       where gl_ctrl.gl_domain = global_domain no-lock:
end.
for first pvod_det no-lock where
          pvod_domain = global_domain
      and pvod_id = vph_pvo_id
      and pvod_id_line = vph_pvod_id_line:

      run getExtTableRecord
          (input "10074a",
           input global_domain,
           input pvod_id,
           input pvod_id_line,
           output pvod_trans_qty,
           output pvod_vouchered_qty,
           output pvod_pur_cost,
           output pvod_pur_std,
           output pvod-dummy-dec1,
           output pvod_trans_date,
           output pvod-dummy-char).
end.

if prh_type = "" and vph_adj_inv
then do:

   if vo_curr <> base_curr
      and vo_ex_rate <> 0
      and vo_ex_rate2 <> 0 then do:

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input vo_curr,
                  input base_curr,
                  input vo_ex_rate,
                  input vo_ex_rate2,
                  input apratevar_amt,
                  input false, /* DO NOT ROUND */
                  output totl_amt,
                  output mc-error-number)"}.
   end.
   else
      totl_amt = apratevar_amt.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output totl_amt,
               input gl_rnd_mthd,
               output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   assign
      tax_on_receipt   = 0
      taxamt           = 0
      tax_on_vph_price = 0
      l_adj_inv        = yes.

   if prh_rcp_type = "R" then
      rcpt_tr_type = "25". /* RETURNS */
   else
      rcpt_tr_type = "21". /* RECEIPTS */

   assign
      tax_ref = prh_receiver
      tax_nbr = prh_nbr.

   /* IN 8.6 GTM ENVIRONMENT, INVENTORY IS ADJUSTED ONLY IF THE   */
   /* ACCRUE TAX AT RECEIPT FLAG IS YES. WHEN IT IS NO, THE       */
   /* TX2D_DET RECORD OF TAX TYPE "22"(VOUCHER) WHICH IS REQUIRED */
   /* BY apvotax.i ROUTINE IS NOT AVAILABLE AT THIS POINT, IT     */
   /* IS CREATED AT A LATER STAGE OF VOUCHER MAINTENANCE. THIS    */
   /* CAUSES A DESIGN LIMITATION WHEN THE FLAG IS SET TO NO.      */

   /* ACCUMULATE TAXES */
   {apvotax.i}

   if pod_consignment then do:
      if available (tx2_mstr)
      then l_adj_inv = tx2_usage_tax_point.
   end.
   else
      l_adj_inv = can-find(first tx2d_det where
                                 tx2d_domain = global_domain
                             and tx2d_ref = prh_receiver
                             and tx2d_nbr = prh_nbr
                             and tx2d_line = prh_line
                             and tx2d_rcpt_tax_point = yes).

end. /* if prh_type = "" */

/* RUN COSTING CALCULATIONS ON INVENTORY SITE DATABASE */
assign
   old_db = global_db
   new_site = prh_site.
{gprun.i ""gpalias.p""}

/* ADDED vph_qoh_at_adj & vo_confirmed */
/* AS 21ST & 22ND INPUT PARAMETERS     */

{gprun.i ""apvomtac.p""
            "(input vo_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input prh_part,
              input prh_site,
              input prh_type,
              input pvod_trans_qty,
              input prh_um_conv,
              input pvod_pur_cost,
              input vph_inv_cost,
              input pod_wo_lot,
              input pod_op,
              input rndmthd,
              input vph_adj_inv,
              input vph_adj_wip,
              input totl_amt,
              input taxamt,
              input tax_on_vph_price,
              input tax_on_receipt,
              input l_adj_inv,
              input vph_qoh_at_adj,
              input vo_confirmed,
              output pickup_pl_accts,
              input-output apratevar_amt,
              input-output apratevar_acc,
              input-output apratevar_sub,
              input-output apratevar_cc,
              input-output apdiscrep_amt,
              input-output vph_adj_amt,
              input-output vph_dscr_amt
            )"}
new_db = old_db.
{gprun.i ""gpaliasd.p""}

if pickup_pl_accts then do:

   for first pt_mstr
         fields( pt_domain pt_prod_line)
          where pt_mstr.pt_domain = global_domain and  pt_part = prh_part
          no-lock:
      for first pl_mstr
            fields( pl_domain pl_inv_acct
            pl_inv_sub
            pl_inv_cc
            pl_dscr_acct
            pl_dscr_sub
            pl_dscr_cc)
             where pl_mstr.pl_domain = global_domain and  pl_prod_line =
             pt_prod_line no-lock:
      end.
      for first pld_det
            fields( pld_domain pld_inv_acct
            pld_inv_sub
            pld_inv_cc
            pld_dscracct
            pld_dscr_sub
            pld_dscr_cc)
             where pld_det.pld_domain = global_domain and  pld_prodline =
             pt_prod_line
            and pld_site = prh_site
            and pld_loc = "" no-lock:
      end.
      if not available pld_det then do:
         for first pld_det
               fields( pld_domain pld_inv_acct
               pld_inv_sub
               pld_inv_cc
               pld_dscracct
               pld_dscr_sub
               pld_dscr_cc)
                where pld_det.pld_domain = global_domain and  pld_prodline =
                pt_prod_line
               and pld_site = ""
               and pld_loc = "" no-lock:
         end.
      end.
   end.

   if available pld_det
   then do:
      if prh_type = "" then
      assign
         apratevar_acc = pld_inv_acct
         apratevar_sub = pld_inv_sub
         apratevar_cc  = pld_inv_cc.
      assign
         apdiscrep_acc = pld_dscracct
         apdiscrep_sub = pld_dscr_sub
         apdiscrep_cc  = pld_dscr_cc.
   end.
   else do:
      if prh_type = "" then
      assign
         apratevar_acc = pl_inv_acct
         apratevar_sub = pl_inv_sub
         apratevar_cc  = pl_inv_cc.
      assign
         apdiscrep_acc = pl_dscr_acct
         apdiscrep_sub = pl_dscr_sub
         apdiscrep_cc  = pl_dscr_cc.
   end.

end.
