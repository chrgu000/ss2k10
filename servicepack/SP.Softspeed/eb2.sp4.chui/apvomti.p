/* apvomti.p - AP VOUCHER MAINTENANCE Create VOD Tax Lines and Display      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.26.2.47.1.1 $                                                             */
/* REVISION: 7.4      CREATED      : 07/13/93              BY: wep *H037*   */
/*                                   09/29/93              BY: bcm *H143*   */
/*                                   11/29/93              BY: bcm *H244*   */
/*                                   02/25/94              BY: pcd *H199*   */
/*                                   03/17/94              BY: bcm *H296*   */
/*                                   03/24/94              BY: bcm *H303*   */
/*                                   04/11/94              BY: pcd *H313*   */
/*                                   06/14/94              BY: bcm *H383*   */
/*                                   07/22/94              by: pmf *FP44*   */
/*                                   09/17/94              by: bcm *H519*   */
/*                                   09/20/94              By: bcm *H531*   */
/*                                   10/27/94              BY: ame *FS90*   */
/*                                   11/18/94              By: bcm *GO37*   */
/*                                   12/05/94              By: bcm *H606*   */
/*                                   12/04/95              By: jzw *H0HJ*   */
/*                                   12/08/95              By: jzw *H0HK*   */
/*                                   01/17/96              By: jzw *H0J8*   */
/* REVISION: 8.5    LAST MODIFIED:   10/12/95              BY: MWD *J053*   */
/*                                   04/10/96              BY: mzh *J0HN*   */
/*                                   04/26/96              BY: ajw *J0JP*   */
/* REVISION: 8.6    LAST MODIFIED:   09/03/96              BY: jzw *K008*   */
/*                                   09/06/96              BY: jzw *K00F*   */
/*                                   10/15/96              BY: jzw *K016*   */
/*                                   11/25/96              BY: jzw *K01X*   */
/*                                   01/23/97              BY: bjl *K01G*   */
/*                                   02/19/97              BY: rxm *H0RQ*   */
/*                                   03/10/97   BY: *K084*  Jeff Wootton    */
/* REVISION: 8.6    LAST MODIFIED:   09/10/97   BY: *J20P* Irine D'mello    */
/* REVISION: 8.6E   LAST MODIFIED:   02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E   LAST MODIFIED:   03/08/98   BY: *H1J9* D. Tunstall      */
/* REVISION: 8.6E   LAST MODIFIED:   04/03/98   BY: *H1K2* Samir Bavkar     */
/* REVISION: 8.6E   LAST MODIFIED:   04/22/98   BY: *J2JT* Niranjan R.      */
/* REVISION: 8.6E   LAST MODIFIED:   05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E   LAST MODIFIED:   07/30/98   BY: *L03K* Jeff Wootton     */
/* Pre-86E commented code removed, view in archive revision 1.21            */
/* Old ECO marker removed, but no ECO header exists *GD32*                  */
/* REVISION: 8.6E   LAST MODIFIED:   12/01/98   BY: *L0CP* Jeff Wootton     */
/* REVISION: 8.6E   LAST MODIFIED:   12/28/98   BY: *H1NM* Hemali Desai     */
/* REVISION: 9.0    LAST MODIFIED:   03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0    LAST MODIFIED:   03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0    LAST MODIFIED:   03/15/99   BY: *M0BG* Jeff Wootton      */
/* REVISION: 9.0    LAST MODIFIED:   05/10/99   BY: *J3CT* Ranjit Jain       */
/* REVISION: 9.1    LAST MODIFIED:   06/28/99   BY: *J3HG* Hemali Desai      */
/* REVISION: 9.1    LAST MODIFIED:   10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1    LAST MODIFIED:   11/01/99   BY: *N053* Jeff Wootton      */
/* REVISION: 9.1    LAST MODIFIED:   03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1    LAST MODIFIED:   04/19/00   BY: *J3MZ* Ranjit Jain       */
/* REVISION: 9.1    LAST MODIFIED:   04/28/00   BY: *N09Y* Luke Pokic        */
/* REVISION: 9.1    LAST MODIFIED:   06/30/00   BY: *N009* Luke Pokic        */
/* REVISION: 9.1    LAST MODIFIED:   07/10/00   BY: *L10G* Vivek Gogte       */
/* REVISION: 9.1    LAST MODIFIED:   08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1    LAST MODIFIED:   09/07/00   BY: *L138* Jose Alex         */
/* REVISION: 9.1    LAST MODIFIED:   10/31/00   BY: *M0T6* Shilpa Athalye    */
/* REVISION: 9.1    LAST MODIFIED:   12/08/00   BY: *L16F* Rajesh Lokre      */
/* REVISION: 9.1    LAST MODIFIED:   12/13/00   BY: *M0XG* Jose Alex         */
/* REVISION: 9.1    LAST MODIFIED:   10/04/00   BY: *N0W0* Mudit Mehta       */
/* REVISION: 9.1    LAST MODIFIED:   02/19/01   BY: *M11W* Seema Tyagi       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.26.2.26     BY: Katie Hilbert     DATE: 04/01/01 ECO: *P002*  */
/* Revision: 1.26.2.27     BY: Rajesh Lokre      DATE: 07/09/01 ECO: *M19Z*  */
/* Revision: 1.26.2.29     BY: Niranjan R.       DATE: 07/23/01 ECO: *P00L*  */
/* Revision: 1.26.2.30     BY: Ed van de Gevel   DATE: 12/03/01 ECO: *N16R*  */
/* Revision: 1.26.2.33     BY: Ellen Borden      DATE: 04/17/02 ECO: *P043*  */
/* Revision: 1.26.2.34     BY: Patrick Rowan     DATE: 05/15/02 ECO: *P06L*  */
/* Revision: 1.26.2.35     BY: Patrick Rowan     DATE: 05/17/02 ECO: *P06W*  */
/* Revision: 1.26.2.36     BY: Patrick Rowan     DATE: 05/24/02 ECO: *P018*  */
/* Revision: 1.26.2.38     BY: Ed van de Gevel   DATE: 07/04/02 ECO: *P0B4*  */
/* Revision: 1.26.2.39     BY: Ed van de Gevel   DATE: 12/03/02 ECO: *N1SW*  */
/* Revision: 1.26.2.42     BY: Ashish Maheshwari DATE: 01/02/03 ECO: *M21M*  */
/* Revision: 1.26.2.45     BY: Jyoti Thatte      DATE: 02/21/03 ECO: *P0MX*  */
/* Revision: 1.26.2.46     BY: Rajaneesh S.      DATE: 03/19/03 ECO: *N29N*  */
/* Revision: 1.26.2.47     BY: Orawan S.         DATE: 04/21/03 ECO: *P0Q8*  */
/* $Revision: 1.26.2.47.1.1 $    BY: Rajiv Ramaiah     DATE: 08/14/03 ECO: *N2JV*  */
/* $Revision: 1.26.2.47.1.1 $    BY: Bill Jiang     DATE: 04/19/07 ECO: *SS - 20070419.1*  */

/* SS - 20070419.1 - B */
/*
3. 修正了以下BUG:
   1) 采购单维护:应纳税 - NO
   2) 凭证维护:应纳税 - YES
   3) 含税: - NO
2. 修正了编辑纳税明细的BUG
1. 修正了以下BUG:
   1) 采购单维护:应纳税 - NO
   2) 凭证维护:应纳税 - YES
   3) 含税: - YES
*/
/* SS - 20070419.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/****************************************************************************/
/* SOME OF THIS LOGIC ORIGINALLY EXISTED IN PROGRAM APVOMTB.P.  THIS LOGIC
   CONTROLS THE GENERATION OF THE VOD_DET RECORDS FOR THE TAX DISTRIBUTION
   AND THE GENERATION OF THE GL TRANSACTIONS FOR THE TAXLINES. THIS
   PROGRAM PROCESS FOR THE NEW TAX MANAGEMENT ONLY.
****************************************************************************/

{mfdeclre.i}
{cxcustom.i "APVOMTI.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvomti_p_1 "Control"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}
define shared variable undo_txdist like mfc_logical.
define shared variable base_det_amt like glt_amt.
define shared variable base_amt     like ap_amt.
define shared variable curr_amt     like glt_curr_amt.
define shared variable aptotal      like ap_amt label {&apvomti_p_1}.
define shared variable ap_recno     as recid.
define shared variable vo_recno     as recid.
define shared variable vd_recno     as recid.
define shared variable ba_recno     as recid.
define shared variable vod_recno    as recid.
define shared variable undo_all     like mfc_logical.
define shared variable jrnl         like glt_ref.
define shared variable tax_flag     like mfc_logical.
define shared variable recalc_tax   like mfc_logical initial true.
define shared variable no_taxrecs   like mfc_logical initial false.
define shared variable tax_tr_type  like tx2d_tr_type.
define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable vod_amt_fmt  as character.

define buffer   rcpt_det        for  tx2d_det.

define variable last_ln         like vod_ln.
define variable tax_entity      like vod_entity no-undo.
define variable tax_acct        like vod_acct.
define variable tax_sub         like vod_sub.
define variable tax_cc          like vod_cc.
define variable tax_project     like vod_project.
define variable tax_total       like tx2d_totamt.
define variable tax_edit        like mfc_logical initial false.
define variable recalc_frame    like mfc_logical initial false.
define variable edit_frame      like mfc_logical initial false.
define variable undo_edittx     like mfc_logical initial false.
define variable undo_recalctx   like mfc_logical initial false.
define variable update_vchr     like mfc_logical initial false.
define variable recov_amt       like tx2d_tottax.
define variable nonrecov_amt    like tx2d_tottax.
define variable recov_adj       like tx2d_tottax.
define variable nonrecov_adj    like tx2d_tottax.
define variable open_amt        like mfc_decimal.  /* Open Amount */
define variable rcv_amt         like mfc_decimal.  /* Rcvr Amount */
define variable ppv_amt         like mfc_decimal.  /* PPV Amount  */
define variable usg_amt         like mfc_decimal.  /* Usag Amount */
define variable rcv_tax         like mfc_decimal.  /* Rcvr Tax    */
define variable ppv_tax         like mfc_decimal.  /* PPV Tax     */
define variable usg_tax         like mfc_decimal.  /* Usage Tax   */
define variable rcv_rec         like mfc_decimal.  /* Rcvr Rec Tax*/
define variable rcv_rec_discrep like mfc_decimal.  /* Rcvr Rec Dsc*/
define variable ppv_rec         like mfc_decimal.  /* PPV Rec Tax */
define variable ppv_rec_discrep like mfc_decimal.  /* PPV Rec Dscr*/
define variable usg_rec         like mfc_decimal.  /* Usag Rec Tax*/
define variable rcpt_amt        like mfc_decimal.  /* Receipt Amt */
define variable l_por_amt       like mfc_decimal.  /* POR Amount  */
define variable l_exp_amt       like mfc_decimal.  /* Expense Amt */
define variable glx_mthd        like cs_method.
define variable cur_mthd        like cs_method.
define variable rcpt_adj_type   like tx2d_tr_type initial "23".
define variable rcpt_tr_type    like tx2d_tr_type.
define variable i               as integer.
define variable por_acct        like vod_acct.
define variable por_sub         like vod_sub.
define variable por_cc          like vod_cc.
define variable por_discrep_acct like vod_acct.
define variable por_discrep_sub like vod_sub.
define variable por_discrep_cc  like vod_cc.
define variable ppv_acct        like vod_acct.
define variable ppv_sub         like vod_sub.
define variable ppv_cc          like vod_cc.
define variable ppv_discrep_acct like vod_acct.
define variable ppv_discrep_sub like vod_sub.
define variable ppv_discrep_cc  like vod_cc.
define variable qty_oh          like in_qty_oh.
define variable qty_po          like pvo_trans_qty.
define variable pct_po          as decimal.
define variable pct_discrep     like mfc_decimal.
define variable acct_changed    as logical no-undo.
define variable rndamt          like vod_amt.
define variable ent_rndmthd     like rnd_rnd_mthd.
define variable tmp_rndmthd     like rnd_rnd_mthd.
define variable tax_round       like rnd_rnd_mthd.
define variable char_i          as character format "x(1)".
define variable mc-error-number like msg_nbr no-undo.
define variable rcp_date_vo_ex_rate  like vo_ex_rate no-undo.
define variable rcp_date_vo_ex_rate2 like vo_ex_rate2 no-undo.
define variable rcp_to_vo_ex_rate  like vo_ex_rate no-undo.
define variable rcp_to_vo_ex_rate2 like vo_ex_rate2 no-undo.
define variable old_db          like si_db no-undo.
/* VARIABLE l_vph_tax_code IS USED TO STORE THE TAX CODE  */
/* USED DURING VOUCHERING                                 */
define variable l_vph_tax_code  like tx2_tax_code no-undo.

define new shared variable new_site like si_site.
define new shared variable new_db   like si_db.

define variable prm_rate_var_acct      as character no-undo.
define variable prm_rate_var_sub       as character no-undo.
define variable prm_rate_var_cc        as character no-undo.
define variable prm_usage_var_acct     as character no-undo.
define variable prm_usage_var_sub      as character no-undo.
define variable prm_usage_var_cc       as character no-undo.
define variable prm_ppv_acct           as character no-undo.
define variable prm_ppv_sub            as character no-undo.
define variable prm_ppv_cc             as character no-undo.
define variable l_vod_ln               like vod_ln  no-undo.

define variable l_vod_type             like vod_type     no-undo.
define variable l_vod_desc             like vod_desc     no-undo.
define variable l_expacct              like vod_exp_acct no-undo.
define variable l_expsub               like vod_exp_sub  no-undo.
define variable l_expcc                like vod_exp_cc   no-undo.
define variable dftRCPTAcct       like pl_rcpt_acct no-undo.
define variable dftRCPTSubAcct    like pl_rcpt_sub  no-undo.
define variable dftRCPTCostCenter like pl_rcpt_cc   no-undo.
define variable dftAPVRAcct       like pl_apvr_acct no-undo.
define variable dftAPVRSubAcct    like pl_apvr_sub  no-undo.
define variable dftAPVRCostCenter like pl_apvr_cc   no-undo.
define variable dftAPVUAcct       like pl_apvu_acct no-undo.
define variable dftAPVUSubAcct    like pl_apvu_sub  no-undo.
define variable dftAPVUCostCenter like pl_apvu_cc   no-undo.
define variable dftPPVAcct        like pl_ppv_acct  no-undo.
define variable dftPPVSubAcct     like pl_ppv_sub   no-undo.
define variable dftPPVCostCenter  like pl_ppv_cc    no-undo.
define variable vouchered_qty     like pvo_vouchered_qty no-undo.
define variable last_voucher      like pvo_last_voucher no-undo.
define variable ers_status        like pvo_ers_status no-undo.
define variable RECEIVER          as character initial "07" no-undo.
define variable is_euro_trans     like mfc_logical no-undo.

/* VARIABLES FOR CONSIGNMENT INVENTORY */
define variable op_usage_point like mfc_logical no-undo.

{&APVOMTI-P-TAG18}
/* DEFINE SHARED VARIABLES FOR CURRENCY DEPENDENT FORMATTING */
{apcurvar.i}

define shared frame c.
define shared frame tax_dist.
{&APVOMTI-P-TAG10}

/* DEFINE TEMP-TABLE work_tx2d_det TO STORE THE TAX AMOUNTS   */
/* BASED ON  PO RECEIPTS                                      */
define temp-table work_tx2d_det no-undo
   field work_nbr like tx2d_nbr
   field work_ref like tx2d_ref
   field work_tr_type like tx2d_tr_type
   field work_tax_type like tx2_tax_type
   field work_line like tx2d_line
   field work_tax_code like tx2d_tax_code
   field work_rcv_tax like mfc_decimal
   field work_usg_tax like mfc_decimal
   field work_ppv_tax like mfc_decimal
   field work_rcv_rec like mfc_decimal
   field work_usg_rec like mfc_decimal
   field work_ppv_rec like mfc_decimal

   index order is primary
   work_ref
   work_nbr
   work_tr_type
   work_line
   work_tax_type.

/* DEFINE FORM TO DISPLAY TAX DISTRIBUTION */
{apvofmtx.i}

{&APVOMTI-P-TAG31}
find ap_mstr where recid(ap_mstr) = ap_recno no-lock no-error.
find vo_mstr where recid(vo_mstr) = vo_recno no-lock no-error.
find vd_mstr where recid(vd_mstr) = vd_recno no-lock no-error.
find ba_mstr where recid(ba_mstr) = ba_recno
   exclusive-lock no-error.

find first gl_ctrl no-lock.
find first icc_ctrl no-lock no-error.
if not available icc_ctrl then do:
   create icc_ctrl.
   if recid(icc_ctrl) = -1 then.
end.  /* if not available icc_ctrl */
find first apc_ctrl no-lock.
find first txc_ctrl no-lock.

/*DEFINE FRAME C FOR CONTROL TOTALS*/
{apvofmc.i}

/* CHECK IF PRM IS INSTALLED */
{pjchkprm.i}
/* PRM-ENABLED VARIABLE DEFINED IN PJCHKPRM.I */

/* CREATE TAX LINES IN VOD */
find last vod_det where vod_ref = vo_ref no-lock no-error.
if available vod_det then last_ln = vod_ln.

{gprunp.i "mcpl" "p" "mc-chk-union-transparency"
          "(input  vo_curr,
            input  base_curr,
            input  ap_mstr.ap_effdate,
            output is_euro_trans)"}

/* LOOP THROUGH VOUCHER RECEIPTS */
for each vph_hist where vph_ref = vo_ref:
    /* FIND THE pvo_mstr AND prh_hist RECORDS */
    for first pvo_mstr no-lock where
              pvo_id = vph_pvo_id and
              pvo_lc_charge   = "" and
              pvo_internal_ref_type = {&TYPE_POReceiver},
        first prh_hist no-lock where
              prh_receiver = pvo_internal_ref and
              prh_line = pvo_line:
    end.

    /* DETERMINE THE VALUE FOR vouchered_qty AND last_voucher */
    {gprun.i ""appvoinv.p""
             "(input """",
               input RECEIVER,
               input pvo_internal_ref,
               input pvo_line,
               input pvo_external_ref,
               output vouchered_qty,
               output last_voucher,
               output ers_status)"}

   assign
      l_expacct = if (prh_type = "" or prh_type = "S")
                   then ""
                   else pvo_accrual_acct
      l_expsub  = if (prh_type = "" or prh_type = "S")
                   then ""
                   else pvo_accrual_sub
      l_expcc   = if (prh_type = "" or prh_type = "S")
                   then ""
                   else pvo_accrual_cc
      l_vod_type = "R".

   if prh_rcp_type = "R" then
      rcpt_tr_type = '25'.
   else
      rcpt_tr_type = '21'.

   /* ASSIGN TAX ENTITY TO THE ENTITY USED DURING PO RECEIPTS */
   if prh_po_site <> "" then
      find si_mstr where si_site = prh_po_site no-lock no-error.
   else
      find si_mstr where si_site = pvo_shipto no-lock no-error.
   if available si_mstr then
      tax_entity = si_entity.
   else
      tax_entity = ap_entity.

   /* LOOP THROUGH RECEIVER TAX DETAIL */
   /* ("21" FOR RECEIPTS, "25" FOR RETURNS) */
   for each tx2d_det where tx2d_det.tx2d_ref = pvo_internal_ref and
         tx2d_det.tx2d_tr_type = rcpt_tr_type /* PO Receipts/Returns */
         and tx2d_det.tx2d_line = pvo_line no-lock:

      /* FIND PART/PRODUCT LINE */
      find pt_mstr where pt_part = pvo_part no-lock no-error.
      if available pt_mstr then
      find pl_mstr
         where pl_prod_line = pt_prod_line no-lock no-error.

      /* Determine supplier type */
      run getGLDefaults.

      {&APVOMTI-P-TAG1}
      /* FIND PO RECEIPTS ACCOUNT */
      if prh_type = "" or prh_type = "S" then do:
      {&APVOMTI-P-TAG2}
         assign
            por_acct = dftRCPTAcct
            por_sub  = dftRCPTSubAcct
            por_cc   = dftRCPTCostCenter.
      end.
      else do:  /*memo items*/
         assign
            por_acct = gl_rcptx_acct         /*receipts*/
            por_sub = gl_rcptx_sub
            por_cc   = gl_rcptx_cc.
         {&APVOMTI-P-TAG3}
      end.

      /* IF EXPENSE ACCOUNT IS CHANGED FOR MEMO ITEM THEN  */
      /* DEBIT NEW EXPENSE ACCOUNT AND CREDIT OLD EXPENSE  */
      /* ACCOUNT WITH THE TAX AMOUNT USED FOR CLEARING THE */
      /* PO RECEIPTS ACCOUNT                               */

      /* SET acct_changed = yes IF EXPENSE ACCOUNT IS      */
      /* CHANGED FOR MEMO ITEM                             */

      /* ASSIGN TAX PROJECT TO THE PROJECT USED DURING PO  */
      /* RECEIPTS                                          */
      assign
         tax_project  = pvo_project
         acct_changed = no.

      if prh_hist.prh_type <> "" and prh_hist.prh_type <> "S"
      then do:

         if vph_project = "" then
            vph_project = pvo_project.

         if (vph_hist.vph_acct <> pvo_mstr.pvo_accrual_acct or
            vph_hist.vph_sub <> pvo_mstr.pvo_accrual_sub or
            vph_hist.vph_cc <> pvo_mstr.pvo_accrual_cc or
            vph_hist.vph_project <> pvo_mstr.pvo_project) then

         acct_changed = yes.
      end. /* IF prh_hist.prh_type <> "" */

      /* GET TAX ROUNDING METHOD */
      find tx2_mstr where tx2_tax_code = tx2d_det.tx2d_tax_code
         no-lock no-error.

      find txed_det where
         txed_tax_env
         = tx2d_det.tx2d_tax_env and
         txed_tax_type = tx2_tax_type no-lock no-error.

      /* TRY TAX ENVIRONMENT DETAIL FIRST */
      if available txed_det and txed_round <> "" then
         tax_round = txed_round.
      else do:
         /* TRY TAX CONTROL FILE NEXT */
         find first txc_ctrl no-lock no-error.
         if available(txc_ctrl) and txc_round > "" then do:
            tax_round = txc_round.
            release txc_ctrl.
         end.
         else
            /* SET TAX_ROUND EQUAL TO RNDMTHD */
            tax_round = rndmthd.
      end.  /* TXED_ROUND WAS "" */

      /*------------------------------------------------------*/

      /* SECTION TO HANDLE PO RECEIPT RELIEF */
      /* TAX TR_TYPE '23'*/

      /* CLEAR PREVIOUS RECEIPT RECONCILING DETAIL */
      /* ("23" TYPE) */
      find first rcpt_det where rcpt_det.tx2d_ref = pvo_internal_ref
         and rcpt_det.tx2d_nbr = vo_ref
         and rcpt_det.tx2d_tr_type = rcpt_adj_type
         and rcpt_det.tx2d_line = pvo_line
         and rcpt_det.tx2d_trl  = ""
         and rcpt_det.tx2d_tax_code = tx2d_det.tx2d_tax_code
         exclusive-lock no-error.
      if not available rcpt_det then do:
         create rcpt_det.
         assign
            rcpt_det.tx2d_ref       = pvo_internal_ref
            rcpt_det.tx2d_nbr       = vo_ref
            rcpt_det.tx2d_tr_type   = rcpt_adj_type
            rcpt_det.tx2d_line      = pvo_line
            rcpt_det.tx2d_tax_code  = tx2d_det.tx2d_tax_code
            rcpt_det.tx2d_effdate   = tx2d_det.tx2d_effdate
            rcpt_det.tx2d_curr      = tx2d_det.tx2d_curr
            rcpt_det.tx2d_tax_env   = tx2d_det.tx2d_tax_env
            rcpt_det.tx2d_zone_from = tx2d_det.tx2d_zone_from
            rcpt_det.tx2d_zone_to   = tx2d_det.tx2d_zone_to
            rcpt_det.tx2d_tax_type  = tx2d_det.tx2d_tax_type
            rcpt_det.tx2d_trans_ent = tx2d_det.tx2d_trans_ent
            rcpt_det.tx2d_line_site_ent  =
            tx2d_det.tx2d_line_site_ent
            rcpt_det.tx2d_taxc      = tx2d_det.tx2d_taxc
            rcpt_det.tx2d_tax_usage = tx2d_det.tx2d_tax_usage
            rcpt_det.tx2d_tax_in    = tx2d_det.tx2d_tax_in
            rcpt_det.tx2d_by_line   = tx2d_det.tx2d_by_line
            rcpt_det.tx2d_edited    = tx2d_det.tx2d_edited
            rcpt_det.tx2d_rcpt_tax_point =
            tx2d_det.tx2d_rcpt_tax_point.
      end.
      rcpt_det.tx2d_posted_date      = ap_effdate.

      /* rcpt_det WITH TR TYPE = "23" IS USED TO CLEAR PREVIOUS */
      /* RECEIPT RECONCILING DETAIL WITH TR TYPE = "21"         */

      /* IF WE CREATE A PO RCPT WITH 10 QTY AND TWO VOUCHER     */
      /* FOR THE SAME PO WITH QTY OF 3 AND 12  AND  FOR THE     */
      /* SECOND VOUCHER CLOSE LINE = YES                        */
      /* THEN FOR THE SECOND VOUCHER rcpt_det SHOULD BE         */
      /* CREATED FOR OPEN QTY OF 7                              */

      run update_rcpt_det_for_partial_qty.

      /* IF WE CREATE A PO RCPT WITH 10 QTY AND TWO VOUCHER    */
      /* FOR THE SAME PO WITH QTY OF 3 AND 12  AND  FOR THE    */
      /* SECOND VOUCHER CLOSE LINE = YES                       */
      /* THEN FOR THE SECOND VOUCHER rcpt_det SHOULD BE        */
      /* CREATED FOR OPEN QTY OF 7                             */

      /* FOR SECOND VOUCHER SINCE FOR QTY OF 12 rcpd_det IS    */
      /* CREATED ABOVE BUT IT SHOULD BE CREATED FOR  OPEN QTY  */
      /* OF 7                                                  */

      /* prh_rcvd  = 10                                        */
      /* prh_inv_qty = 12 + 3 = 15                             */
      /* (prh_rcvd - prh_inv_qty) i.e (10 - 15 = -5) AND       */
      /* 12 (rcpt_det line created above)  - 5 = 7             */

      /* WHEN CLOSE LINE = YES WE SHOULD GO INTO THE LOOP BELOW TO */
      /* CLEAR PREVIOUS RECEIPT RECONCILLING DETAIL                */

      if last_voucher > ""
      then
         /* PARTIAL QTY WILL HAVE BEEN PROCESSED ABOVE. */
         /* NOW PROCESS THE REMAINING UN-INVOICED QTY.  */
         run update_rcpt_det_for_final_qty
             (input vouchered_qty).

      /*------------------------------------------------------*/
      /* FORMULAS FOR THE CALCULATION OF TAX ON PO RCPT,       */
      /* RATE VARIANCE AND USAGE VARIANCE                      */

      /* INV QTY           = vph_inv_qty                       */
      /* TOTAL INVOICE QTY = prh_inv_qty                       */
      /* OPEN QTY = prh_rcvd - (prh_inv_qty - vph_inv_qty)     */

      /* WHEN CLOSE LINE = YES                                 */
      /* PO RCPT TAX = PO COST * PO TAX RATE * OPEN QTY        */
      /* WHEN CLOSE LINE = NO                                  */
      /* PO RCPT TAX = PO COST * PO TAX RATE * INV QTY         */

      /* WHEN CLOSE LINE = YES AND                             */
      /* TOTAL INVOICE QTY <> RCPT QTY (prh_rcvd)              */
      /* USAGE VARIANCE TAX =                                  */
      /*   PO COST * PO TAX RATE * (INV QTY - OPEN QTY)        */

      /* = PO COST * PO TAX RATE * INV QTY (work_ppv_tax)      */
      /*             -                                         */
      /*   PO COST * PO TAX RATE * OPEN QTY (work_rcv_tax)     */
      /* RATE VARIANCE TAX = (INV COST * INV TAX RATE -        */
      /*                       PO COST * PO TAX RATE) * INV QTY */

      /* = INV COST * INV TAX RATE * INV QTY                   */
      /*             -                                         */
      /*   PO COST * PO TAX RATE * INV QTY  (work_ppv_tax)     */

      /* FIND THE TAX CODE APPLICABLE BASED ON THE TAX CLASS    */
      /* AND TAX USAGE DURING VOUCHERING                        */

      run p_tax_code(input tx2_tax_type,
         input right-trim(substring(vph__qadc01,9,3)),
         input right-trim(substring(vph__qadc01,1,8)),
         input vo_tax_date,
         output l_vph_tax_code).

      /* IF THE TAX CODES AT VOUCHER AND RECEIPTS ARE DIFFERENT */
      /* THEN CREATE TEMP-TABLE work_tx2d_det                   */
      if l_vph_tax_code <> tx2d_det.tx2d_tax_code and
         l_vph_tax_code <> ""
      then do:

         for first work_tx2d_det
               fields (work_nbr       work_ref      work_tr_type
               work_tax_type  work_line     work_tax_code
               work_rcv_tax   work_usg_tax  work_ppv_tax
               work_rcv_rec   work_usg_rec  work_ppv_rec)
               where
               work_tx2d_det.work_ref      = pvo_mstr.pvo_internal_ref and
               work_tx2d_det.work_nbr      = vo_mstr.vo_ref        and
               work_tx2d_det.work_tr_type  = tx2d_det.tx2d_tr_type and
               work_tx2d_det.work_line     = pvo_mstr.pvo_line     and
               work_tx2d_det.work_tax_type = tx2_mstr.tx2_tax_type
               no-lock:
         end.  /* FOR FIRST work_tx2d_det... */

         if not available work_tx2d_det
         then do:
            create work_tx2d_det.
            assign
               work_tx2d_det.work_ref      = pvo_mstr.pvo_internal_ref
               work_tx2d_det.work_nbr      = vo_mstr.vo_ref
               work_tx2d_det.work_tr_type  = tx2d_det.tx2d_tr_type
               work_tx2d_det.work_line     = pvo_mstr.pvo_line
               work_tx2d_det.work_tax_type = tx2_tax_type
               work_tx2d_det.work_tax_code = tx2d_det.tx2d_tax_code.
         end. /* IF NOT AVAILABLE work_tx2d_det */
      end. /* IF l_vph_tax_code <> ......*/

      if available work_tx2d_det
      then do:

         /* IN THE CALCULATION OF TAX ON RATE VARIANCE WE WANT    */
         /* PO COST * PO TAX RATE * INV QTY HENCE DIVIDE          */
         /* tx2d_det.tx2d_cur_tax_amt BY PO QTY (prh_rcvd).       */


         /* IN THE CALCULATION OF RECOVERABLE TAX ON RATE         */
         /* VARIANCE tx2d_det.tx2d_cur_recov_amt SHOULD BE USED   */

         /* CALCULATION OF TAX AMOUNT AND RECOVERABLE TAX         */
         /* AMOUNT ON PO RCPT AND RATE VARIANCE                   */
         assign
            work_tx2d_det.work_rcv_tax =
            - rcpt_det.tx2d_cur_tax_amt
            work_tx2d_det.work_rcv_rec =
            - rcpt_det.tx2d_cur_recov_amt
            work_tx2d_det.work_ppv_tax =
            (tx2d_det.tx2d_cur_tax_amt / pvo_trans_qty) * vph_inv_qty
            work_tx2d_det.work_ppv_rec =
            (tx2d_det.tx2d_cur_recov_amt / pvo_trans_qty) * vph_inv_qty.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output work_tx2d_det.work_ppv_tax,
              input rndmthd,
              output mc-error-number)"}

         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output work_tx2d_det.work_ppv_rec,
              input rndmthd,
              output mc-error-number)"}

         if mc-error-number <> 0 then
            run mc_warning.

         /* work_rcv_tax,work_rcv_rec,work_ppv_tax,work_ppv_rec */
         /* IS IN PRH CURRENCY                                  */
         if vo_curr <> pvo_curr
         then do:

            /* CONVERT work_rcv_tax,work_rcv_rec,work_ppv_tax,     */
            /* work_ppv_rec TO VOUCHER CURRENCY                    */

            run mc_get_vo_ex_rate_at_rcpt_date.

            run convert_receipt_to_voucher
               (input-output work_rcv_tax).

            run convert_receipt_to_voucher
               (input-output work_rcv_rec).

            run convert_receipt_to_voucher
               (input-output work_ppv_tax).

            run convert_receipt_to_voucher
               (input-output work_ppv_rec).
         end. /* IF vo_curr <> pvo_curr ... */
      end. /* IF AVAILABLE work_tx2d_det */

      /* IF USING SUPPLIER CONSIGNMENT MODULE, AND THE      */
      /* ACCRUE TAX AT RECEIPT IS NO, CHECK TO SEE IF       */
      /* THE LINE BEING WORKED ON IS A CONSIGNED LINE.      */
      /* IF IT IS, CHECK THE ACCRUE TAX AT USAGE FLAG IN    */
      /* ORDER TO DETERMINE WHEN TAXES WERE PROCESSED.      */

      if pvo_mstr.pvo_consignment and rcpt_det.tx2d_rcpt_tax_point = no
         then
            run determine_usage_tax_point
               (input rcpt_det.tx2d_nbr,
                input rcpt_det.tx2d_line,
                input rcpt_det.tx2d_tax_code,
                output op_usage_point).

      /* IF TAX WAS PROCESSED AT TIME OF PO RECEIPT, */
      /* CREATE VOD_DETS TO REVERSE IT */
      if rcpt_det.tx2d_rcpt_tax_point
         or (pvo_mstr.pvo_consignment and op_usage_point)
      then do:

         find tx2_mstr
            where tx2_tax_code = rcpt_det.tx2d_tax_code
            no-lock no-error.

         run p_taxacct.

         /* CREATE/MODIFY VOD_DET FOR PO RECEIPTS ACCOUNT */
         if rcpt_det.tx2d_cur_tax_amt <>
            rcpt_det.tx2d_cur_recov_amt
         then do:

            /* RCPT_DET.TX2D_CUR_TAX_AMT IS IN PRH CURRENCY */
            rcv_tax = rcpt_det.tx2d_cur_tax_amt.
            if vo_curr <> pvo_curr then do:
               /* CONVERT RCV_TAX TO VOUCHER CURRENCY */
               run mc_get_vo_ex_rate_at_rcpt_date.
               run convert_receipt_to_voucher
                  (input-output rcv_tax).
            end.

        run update_vod_det
               (rcv_tax).

        /* THE TAX AMOUNT SHOULD BE ADDED TO THE TOTAL AMOUNT */
            /* ONLY WHEN TAX INCLUDE FLAG IS SET TO NO.           */

            if acct_changed
               and not rcpt_det.tx2d_tax_in
            then do:
               run update-memo (- rcv_tax).

               run p_taxacct.

            end. /* IF acct_changed */

         end.

         /* CHECK FOR RECOVERABLE TAXES  */
         /* IF RECOV. AMOUNT <> 0 */
         /* RELIEVE PO RECEIPTS ACCOUNT */
         /* AND PUT INTO AP TAX ACCOUNT */
         if rcpt_det.tx2d_cur_recov_amt <> 0 then do:

            /* CREATE/MODIFY VOD_DET FOR PO RECEIPTS ACCOUNT */
            if rcpt_det.tx2d_cur_tax_amt <>
               rcpt_det.tx2d_cur_recov_amt
            then do:

               /* RCPT_DET.TX2D_CUR_RECOV_AMT IS IN PRH CURRENCY */
               recov_amt = rcpt_det.tx2d_cur_recov_amt.
               if vo_curr <> pvo_curr then do:
                  /* CONVERT RECOV_AMT TO VOUCHER CURRENCY */
                  run mc_get_vo_ex_rate_at_rcpt_date.
                  run convert_receipt_to_voucher
                     (input-output recov_amt).
               end.

               run update_vod_det
                  (- recov_amt).

               /* THE RECOVERABLE TAX AMOUNT SHOULD BE DEDUCTED FROM */
               /* THE SUM OF (THE TOTAL AMOUNT + THE TAX AMOUNT) FOR */
               /* BOTH THE CASES WITH TAX INCLUDE FLAG YES AND NO,   */
               /* AND FOR TAX RECOVERABLE PERCENTAGE LESS THAN 100   */

               if acct_changed then
                  run update-memo
                     (recov_amt).

            end.

            assign
               tax_acct = tx2_ap_acct
               tax_sub = tx2_ap_sub
               tax_cc   = tx2_ap_cc.

            /* RCPT_DET.TX2D_CUR_RECOV_AMT IS IN PRH CURRENCY */
            recov_amt = rcpt_det.tx2d_cur_recov_amt.
            if vo_curr <> pvo_curr then do:
               /* CONVERT RECOV_AMT TO VOUCHER CURRENCY */
               run mc_get_vo_ex_rate_at_rcpt_date.
               run convert_receipt_to_voucher
                  (input-output recov_amt).
            end.

            /* CREATE/MODIFY VOD_DET FOR AP TAX ACCOUNT */
            {&APVOMTI-P-TAG19}
            run update_vod_det
               (recov_amt).

            {&APVOMTI-P-TAG20}

            /* THE RECOVERABLE TAX AMOUNT SHOULD BE DEDUCTED FROM  */
            /* THE SUM OF (THE TOTAL AMOUNT + THE TAX AMOUNT) ONLY */
            /* FOR THE CASE WITH TAX INCLUDE FLAG YES, AND         */
            /* TAX RECOVERABLE PERCENTAGE EQUAL TO 100.            */

            if acct_changed
               and rcpt_det.tx2d_tax_in
               and (rcpt_det.tx2d_cur_tax_amt =
                    rcpt_det.tx2d_cur_recov_amt)
            then
               run update-memo
                  (recov_amt).

         end.

      end. /* IF RCPT_TAX_POINT */

      else /* ACCRUE TAX AT VOUCHER */
      if rcpt_det.tx2d_tax_in
         /* TAX INCLUDED IN PRICE */
      then do:
         assign
            tax_acct = por_acct
            tax_sub = por_sub
            tax_cc = por_cc.

         /* RCPT_DET.TX2D_CUR_TAX_AMT IS IN PRH CURRENCY */
         rcv_tax = rcpt_det.tx2d_cur_tax_amt.
         if vo_curr <> pvo_curr then do:
            /* CONVERT RECOV_AMT TO VOUCHER CURRENCY */
            run mc_get_vo_ex_rate_at_rcpt_date.
            run convert_receipt_to_voucher
               (input-output rcv_tax).
         end.

         run update_vod_det
            (rcv_tax).

         if acct_changed then
            run update-memo
               (rcv_tax).

      end.

      release rcpt_det.

      /*------------------------------------------------------*/

      /* IF TAX WAS PROCESSED AT TIME OF PO RECEIPT, */
      /* CREATE/MODIFY VOD_DETS FOR THE TAX APPLICABLE */
      /* TO THIS VOUCHERING OF THE RECEIPT. */
      if tx2d_det.tx2d_rcpt_tax_point
         or (pvo_mstr.pvo_consignment and op_usage_point)
      then do:

         /* USE A/P EXPENSE ACCOUNT IF AVAILABLE */
         find tx2_mstr where tx2_tax_code = tx2d_det.tx2d_tax_code
            no-lock no-error.

         /* PRO-RATE AGAINST INVOICED QTY */
         assign
            recov_amt    = tx2d_det.tx2d_cur_recov_amt *
            (vph_inv_qty / pvo_trans_qty)
            nonrecov_amt = (tx2d_det.tx2d_cur_tax_amt -
            tx2d_det.tx2d_cur_recov_amt) *
            (vph_inv_qty / pvo_trans_qty).

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output recov_amt,
             input rndmthd,
             output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output nonrecov_amt,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         /* RECOV_AMT IS IN PRH CURRENCY */
         /* NONRECOV_AMT IS IN PRH CURRENCY */
         if vo_curr <> pvo_curr then do:
            /* CONVERT RECOV_AMT TO VOUCHER CURRENCY */
            /* CONVERT NONRECOV_AMT TO VOUCHER CURRENCY */
            run mc_get_vo_ex_rate_at_rcpt_date.
            run convert_receipt_to_voucher
               (input-output recov_amt).
            run convert_receipt_to_voucher
               (input-output nonrecov_amt).
         end.

         run p_taxacct.

         /* CREATE/MODIFY VOD_DET FOR PO RECEIPTS ACCOUNT */
         if not tx2d_det.tx2d_tax_in
         then do:
            run update_vod_det
               (recov_amt + nonrecov_amt).

            /* THE EXPENSED ACCOUNTS HAVE ALREADY BEEN  */
            /* ADJUSTED IN THE PRIOR LOGIC.             */
         end.

         /* IF RECEIVER LINE IS CLOSED BUT NOT ALL INVOICED */
         /* THEN RELIEVE PO RECEIPTS; THE VOUCHER TAX DETAIL */
         /* SECTION HANDLES THE VARIANCE POSTINGS */
         if last_voucher > ""

            and not tx2d_det.tx2d_tax_in
         then do:

            assign
               recov_adj    = tx2d_det.tx2d_cur_recov_amt *
               ((pvo_trans_qty - vouchered_qty) / pvo_trans_qty)
               nonrecov_adj = (tx2d_det.tx2d_cur_tax_amt -
               tx2d_det.tx2d_cur_recov_amt) *
               ((pvo_trans_qty - vouchered_qty) / pvo_trans_qty).

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output recov_adj,
                 input rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then
               run mc_warning.

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output nonrecov_adj,
                 input rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then
               run mc_warning.

            /* RECOV_ADJ IS IN PRH CURRENCY */
            /* NONRECOV_ADJ IS IN PRH CURRENCY */
            if vo_curr <> pvo_curr then do:
               /* CONVERT RECOV_ADJ TO VOUCHER CURRENCY */
               /* CONVERT NONRECOV_ADJ TO VOUCHER CURRENCY */
               run mc_get_vo_ex_rate_at_rcpt_date.
               run convert_receipt_to_voucher
                  (input-output recov_adj).
               run convert_receipt_to_voucher
                  (input-output nonrecov_adj).
            end.

            /* CREATE/MODIFY VOD_DET FOR PO RECEIPTS ACCOUNT */
            run update_vod_det
               (recov_adj + nonrecov_adj).

            /* THE EXPENSED ACCOUNTS HAVE ALREADY BEEN  */
            /* ADJUSTED IN THE PRIOR LOGIC.             */

         end. /* CLOSED RECEIVER LINE LOOP */
      end. /* IF RCPT_TAX_POINT */
   end. /* RECEIVER TAX DETAIL LOOP */
end. /* VOUCHER RECEIPTS HISTORY LOOP */

/*-------------------------------------------------------------*/

if available pvo_mstr then.

/* LOOP THROUGH VOUCHER TAX DETAIL RECORDS */
/* "22" TYPE */
for each tx2d_det where tx2d_det.tx2d_ref = vo_ref and
      tx2d_det.tx2d_tr_type = tax_tr_type                 and
      tx2d_det.tx2d_cur_tax_amt <> 0:

   {&APVOMTI-P-TAG11}
   find tx2_mstr where tx2_tax_code = tx2d_det.tx2d_tax_code
      no-lock no-error.

   assign
      l_por_amt = 0
      l_exp_amt = 0.

   /* GET TAX ROUNDING METHOD */
   /* (FOR FIELD SERVICE, RTS, TAX TRANSACTION IS "37", */
   /* SO "21/25" WILL NOT BE FOUND, AND TAX_ROUND       */
   /* WILL NOT HAVE BEEN ASSIGNED).                     */

   find txed_det where
      txed_tax_env = tx2d_det.tx2d_tax_env and
      txed_tax_type = tx2_tax_type no-lock no-error.

   /* TRY TAX ENVIRONMENT DETAIL FIRST */
   if available txed_det and txed_round <> "" then
      tax_round = txed_round.
   else do:
      /* TRY TAX CONTROL FILE NEXT */
      find first txc_ctrl no-lock no-error.
      if available(txc_ctrl) and txc_round > "" then do:
         tax_round = txc_round.
         release txc_ctrl.
      end.
      else
         /* SET TAX_ROUND EQUAL TO RNDMTHD */
         tax_round = rndmthd.
   end.  /* TXED_ROUND WAS "" */

   /* PROCESS RECEIPTS WITH VARIANCES FIRST */
   if tx2d_det.tx2d_nbr > "" then do:

      for first vph_hist exclusive-lock where
                vph_ref = vo_ref and
                can-find (first pvo_mstr where
                                pvo_id = vph_pvo_id  and
                                pvo_internal_ref = tx2d_det.tx2d_nbr  and
                                pvo_line = tx2d_det.tx2d_line),
          first pvo_mstr no-lock where
                pvo_id = vph_pvo_id  and
                pvo_internal_ref = tx2d_det.tx2d_nbr  and
                pvo_line = tx2d_det.tx2d_line,
          first prh_hist no-lock where
                prh_receiver = pvo_internal_ref and
                prh_line = pvo_line:
      end.

      /* DETERMINE THE VALUE FOR vouchered_qty AND last_voucher */
         {gprun.i ""appvoinv.p""
                  "(input """",
                    input RECEIVER,
                    input pvo_internal_ref,
                    input pvo_line,
                    input pvo_external_ref,
                    output vouchered_qty,
                    output last_voucher,
                    output ers_status)"}
      /* ASSIGN TAX ENTITY TO THE ENTITY USED DURING PO RECEIPTS*/
      if prh_po_site <> "" then
         find si_mstr where si_site = prh_po_site no-lock no-error.
      else
         find si_mstr where si_site = pvo_shipto no-lock no-error.
      if available si_mstr then
         tax_entity = si_entity.
      else
         tax_entity = ap_entity.

      tax_project  = pvo_project.

      find pt_mstr where pt_part = pvo_part no-lock no-error.
      if available pt_mstr then
      do:
         find pl_mstr
            where pl_prod_line = pt_prod_line
            no-lock no-error.

         /* Determine supplier type */
         run getGLDefaults.

         find pld_det
            where pld_prodline = pt_prod_line
            and pld_site = pvo_shipto
            and pld_loc = "" no-lock no-error.
         if not available pld_det then
         find pld_det
            where pld_prodline = pt_prod_line
            and pld_site = ""
            and pld_loc = "" no-lock no-error.
      end.

      /* GET QOH AND COSTING METHOD FROM INVENTORY DATABASE */
      assign
         old_db = global_db
         new_site = pvo_shipto.
      {gprun.i ""gpalias.p""}
      {gprun.i ""apvomti0.p""
         "(input pvo_part,
           input pvo_shipto,
           output glx_mthd,
           output cur_mthd,
           output qty_oh
          )"}
      new_db = old_db.
      {gprun.i ""gpaliasd.p""}

      /* DEFAULT TO NO INVENTORY DISCREPANCY */
      pct_discrep = 0.

      /* FIND PRODUCT LINE INVENTORY ACCOUNT,  */
      /* INVENTORY DISCREPANCY ACCOUNT,        */
      /* AND DETERMINE DISCREPANCY PROPORTION. */

      if (prh_type = ""
         and (glx_mthd = "AVG"
         or cur_mthd = "AVG"
         or cur_mthd = "LAST"))
         /* (INVENTORY ITEM, WITH AVERAGE COSTING) */
         and (vph_adj_inv
         /* (A VARIANCE HAS BEEN SELECTED TO AFFECT INVENTORY) */
         or tx2d_det.tx2d_rcpt_tax_point = no)
         /* (TAX ON RECEIPT NEEDS TO AFFECT INVENTORY) */
      then do:

         if vph_adj_inv
         then do:
            /* A VARIANCE HAS BEEN SELECTED                 */
            /* TO AFFECT INVENTORY.                         */
            /* FIND THE INVENTORY AND DISCREPANCY ACCOUNTS. */
            if available pld_det then
               assign
                  ppv_acct = pld_inv_acct
                  ppv_sub = pld_inv_sub
                  ppv_cc  = pld_inv_cc
                  ppv_discrep_acct = pld_dscracct
                  ppv_discrep_sub = pld_dscr_sub
                  ppv_discrep_cc = pld_dscr_cc.
            else
               assign
                  ppv_acct = pl_inv_acct
                  ppv_sub = pl_inv_sub
                  ppv_cc  = pl_inv_cc
                  ppv_discrep_acct = pl_dscr_acct
                  ppv_discrep_sub = pl_dscr_sub
                  ppv_discrep_cc = pl_dscr_cc.
         end. /* IF INV_YN */
         else
         /* (TAX AT RECEIPT = NO) */
         /* IF THERE IS A RATE VARIANCE, IT NEEDS TO */
         /* AFFECT AP RATE VARIANCE ACCOUNT. */
            assign
               ppv_acct = dftAPVRAcct
               ppv_sub  = dftAPVRSubAcct
               ppv_cc   = dftAPVRCostCenter.

         /* CALCULATE PERCENTAGE OF RATE VARIANCE */
         /* WHICH SHOULD BE POSTED TO */
         /* INVENTORY DISCREPANCY ACCOUNT RATHER THAN */
         /* INVENTORY ACCOUNT (BECAUSE INSUFFICIENT QOH TO*/
         /* WHICH TO APPLY FULL COST ADJUSTMENT). */

         qty_po = pvo_trans_qty * prh_um_conv.
         if qty_po <= 0 then
            pct_po = 0.
         else
         /* DO FOR RECEIPTS, NOT RETURNS */
         pct_po = min(1, qty_oh / qty_po).
         if qty_oh > 0 and pct_po > 0 then
            pct_discrep = 1 - pct_po.
         else
            pct_discrep = 1.

      end. /* if (prh_type = "" .... */

      else if prh_type = "" or prh_type = "S" then do:
         assign
            ppv_acct = dftAPVRAcct
            ppv_sub  = dftAPVRSubAcct
            ppv_cc   = dftAPVRCostCenter.
      end.
      else do:  /*memo items*/
         if apc_expvar then
            assign
               tax_project = vph_project
               ppv_acct    = gl_apvrx_acct  /*rate variance*/
               ppv_sub     = gl_apvrx_sub
               ppv_cc      = gl_apvrx_cc.
         else   /*USE EXPENSE ACCOUNT FOR BOTH VARIANCES*/

            assign
               tax_project = vph_project
               ppv_acct    = vph_acct
               ppv_sub     = vph_sub
               ppv_cc      = vph_cc.
      end.

      /* FIND PO RECEIPTS ACCOUNT */
      if prh_type = "" or prh_type = "S" then do:
         if tx2d_det.tx2d_rcpt_tax_point /* ACCRUE AT RECEIPT */
            or (pvo_mstr.pvo_consignment and op_usage_point)
         then do:
            /* FIND THE PO RECEIPTS ACCOUNT. */
            /* ANY RECEIPT DISCREPANCY ALSO CLEARS */
            /* THE PO RECEIPTS ACCOUNT. */
            {&APVOMTI-P-TAG4}

            assign
               por_acct         = dftRCPTAcct
               por_sub          = dftRCPTSubAcct
               por_cc           = dftRCPTCostCenter
               por_discrep_acct = dftRCPTAcct
               por_discrep_sub  = dftRCPTSubAcct
               por_discrep_cc   = dftRCPTCostCenter.

            {&APVOMTI-P-TAG5}
         end. /* ACCRUE AT RECEIPT */
         else do: /* ACCRUE AT VOUCHER */
         if glx_mthd = "AVG" then
            /* FIND THE INVENTORY AND DISCREPANCY ACCOUNTS. */
            if available pld_det then
            assign
               por_acct = pld_inv_acct
               por_sub = pld_inv_sub
               por_cc  = pld_inv_cc
               por_discrep_acct = pld_dscracct
               por_discrep_sub = pld_dscr_sub
               por_discrep_cc = pld_dscr_cc.
            else
            assign
               por_acct = pl_inv_acct
               por_sub = pl_inv_sub
               por_cc  = pl_inv_cc
               por_discrep_acct = pl_dscr_acct
               por_discrep_sub = pl_dscr_sub
               por_discrep_cc = pl_dscr_cc.
         else
            /* GL COST SET = STD, */
            /* RECEIPT AND ANY RECEIPT DISCREPANCY */
            /* GO TO PURCHASE PRICE VARIANCE ACCOUNT. */
            assign
               por_acct         = dftPPVAcct
               por_sub          = dftPPVSubAcct
               por_cc           = dftPPVCostCenter
               por_discrep_acct = dftPPVAcct
               por_discrep_sub  = dftPPVSubAcct
               por_discrep_cc   = dftPPVCostCenter.

         end. /* ACCRUE AT VOUCHER */
      end.
      else do:  /*memo items*/
         if tx2d_det.tx2d_rcpt_tax_point
            then /* ACCRUE AT RECEIPT */
         /* FIND THE PO RECEIPTS ACCOUNT */
         assign
            tax_project = pvo_project
            {&APVOMTI-P-TAG6}
            por_acct    = gl_rcptx_acct           /*receipts*/
            por_sub     = gl_rcptx_sub
            por_cc      = gl_rcptx_cc.
            {&APVOMTI-P-TAG7}
         else /* ACCRUE AT VOUCHER */
         /* FIND THE VOUCHER DETAIL EXPENSE ACCOUNT */
         assign

            /* TO PRESERVE ORIGINAL BEHAVIOUR WHEN TAX INCLUDED */
            /* IS "YES"                                         */

            tax_project = if tx2d_det.tx2d_tax_in
                          then
                             pvo_project
                          else
                             vph_project
            por_acct    = vph_acct
            por_sub     = vph_sub
            por_cc      = vph_cc.
      end.

      acct_changed = no.

      if prh_hist.prh_type <> "" and prh_hist.prh_type <> "S"
      then do:

         if vph_project = "" then
            vph_project = pvo_project.

         if (vph_hist.vph_acct <> pvo_mstr.pvo_accrual_acct or
            vph_hist.vph_sub <> pvo_mstr.pvo_accrual_sub or
            vph_hist.vph_cc <> pvo_mstr.pvo_accrual_cc or
            vph_hist.vph_project <> pvo_mstr.pvo_project) then

         acct_changed = yes.
      end. /* IF prh_hist.prh_type <> "" */

      /* USE ONLY VARIANCES FROM THE RECEIPT */
      /* TAXES ARE CALCULATED AT RECEIPT FOR WHOLE AMOUNT */

      assign
         open_amt = (pvo_trans_qty * prh_curr_amt * prh_um_conv)
         rndamt   = vouchered_qty * prh_curr_amt * prh_um_conv
         rcpt_amt = vph_inv_qty * prh_curr_amt * prh_um_conv.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output open_amt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rndamt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rcpt_amt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      if vo_curr <> pvo_curr then do:
         run mc_get_vo_ex_rate_at_rcpt_date.
         run convert_receipt_to_voucher
            (input-output open_amt).
         run convert_receipt_to_voucher
            (input-output rndamt).
         run convert_receipt_to_voucher
            (input-output rcpt_amt).
      end.

      open_amt = open_amt - (rndamt - rcpt_amt).

      if last_voucher > " "
         then
         rcv_amt = open_amt.
      else
         rcv_amt = rcpt_amt.

      /* RATE VARIANCE AMOUNT */
      assign
         ppv_amt = vph_curr_amt * vph_inv_qty
         rndamt  = prh_curr_amt * prh_um_conv * vph_inv_qty.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ppv_amt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rndamt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      if vo_curr <> pvo_curr then do:
         run mc_get_vo_ex_rate_at_rcpt_date.
         run convert_receipt_to_voucher
            (input-output rndamt).
      end.

      ppv_amt = ppv_amt - rndamt.

      /* USAGE VARIANCE AMOUNT */
      /* ONLY SET USAGE VARIANCE IF RECEIVER LINE IS CLOSED */

      if  (last_voucher <> "")
         then usg_amt = rcpt_amt - open_amt.

      else
      if (open_amt >= 0 and rcpt_amt <  0 ) or
         (open_amt <  0 and rcpt_amt >= 0 )  then
         usg_amt = rcpt_amt.

      /* HAVE TAXES BEEN EDITED? */
      if tx2d_edited = no then do:
         assign
            rcv_tax = (tx2d_det.tx2d_cur_tax_amt
            * rcv_amt)
            ppv_tax = (tx2d_det.tx2d_cur_tax_amt
            * ppv_amt).
         /* FOR GLOBAL TAX MGMT, ROUND THE TAX AMTS          */
         /* USING THE TAX ROUNDING METHOD BEFORE ROUNDING    */
         /* ACCORDING TO THE TRANSACTION CURRENCY            */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         assign rcv_tax = rcv_tax / (rcv_amt + ppv_amt + usg_amt)
            ppv_tax = ppv_tax / (rcv_amt + ppv_amt + usg_amt).
         /* FOR GLOBAL TAX MGMT, ROUND THE TAX AMTS          */
         /* USING THE TAX ROUNDING METHOD BEFORE ROUNDING    */
         /* ACCORDING TO THE TRANSACTION CURRENCY            */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         /* SS - 20070419.1 - B */
         usg_tax = tx2d_det.tx2d_cur_tax_amt
         - rcv_tax - ppv_tax.
         /* SS - 20070419.1 - E */
      end.
      /* SS - 20070419.1 - B */
      /*
      else
      assign
         rcv_tax = tx2d_det.tx2d_cur_tax_amt
         ppv_tax = 0.

      usg_tax = tx2d_det.tx2d_cur_tax_amt
      - rcv_tax - ppv_tax.
      */
      ELSE DO:
         assign
            rcv_tax = tx2d_det.tx2d_cur_tax_amt
            ppv_tax = 0.

         usg_tax = tx2d_det.tx2d_cur_tax_amt
         - rcv_tax - ppv_tax.

         assign
            rcv_tax = (tx2d_det.tx2d_cur_tax_amt
            * rcv_amt)
            ppv_tax = (tx2d_det.tx2d_cur_tax_amt
            * ppv_amt).
         /* FOR GLOBAL TAX MGMT, ROUND THE TAX AMTS          */
         /* USING THE TAX ROUNDING METHOD BEFORE ROUNDING    */
         /* ACCORDING TO THE TRANSACTION CURRENCY            */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         assign 
            rcv_tax = rcv_tax / (rcv_amt + ppv_amt + usg_amt) + tx2d_cur_nontax_amt * rcv_amt /  (rcv_amt + ppv_amt + usg_amt)
            ppv_tax = ppv_tax / (rcv_amt + ppv_amt + usg_amt) - tx2d_cur_nontax_amt * rcv_amt /  (rcv_amt + ppv_amt + usg_amt)
            .
         /* FOR GLOBAL TAX MGMT, ROUND THE TAX AMTS          */
         /* USING THE TAX ROUNDING METHOD BEFORE ROUNDING    */
         /* ACCORDING TO THE TRANSACTION CURRENCY            */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_tax,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.
      END.
      /* SS - 20070419.1 - E */

      /* CALCULATE RECOVERABLE AMOUNTS */

      /* HAVE TAXES BEEN EDITED? */
      if tx2d_edited = no then do:
         assign
            rcv_rec = (tx2d_det.tx2d_cur_recov_amt
            * rcv_amt)
            ppv_rec = (tx2d_det.tx2d_cur_recov_amt
            * ppv_amt).

         /* ROUND THE RECOVERABLE TAX AMTS USING THE */
         /* TAX ROUNDING METHOD BEFORE ROUNDING      */
         /* ACCORDING TO THE TRANSACTION CURRENCY    */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output rcv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output ppv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         assign rcv_rec = rcv_rec / (rcv_amt + ppv_amt + usg_amt)
            ppv_rec = ppv_rec / (rcv_amt + ppv_amt + usg_amt).

         /* ROUND THE RECOVERABLE TAX AMTS USING THE */
         /* TAX ROUNDING METHOD BEFORE ROUNDING      */
         /* ACCORDING TO THE TRANSACTION CURRENCY    */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output rcv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.


         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output ppv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         /* SS - 20070419.1 - B */
         usg_rec = tx2d_det.tx2d_cur_recov_amt
         - rcv_rec - ppv_rec.
         /* SS - 20070419.1 - E */
      end.
      /* SS - 20070419.1 - B */
      /*
      else
      assign
         rcv_rec = tx2d_det.tx2d_cur_recov_amt
         ppv_rec = 0.

      usg_rec = tx2d_det.tx2d_cur_recov_amt
      - rcv_rec - ppv_rec.
      */
      ELSE DO:
         assign
            rcv_rec = tx2d_det.tx2d_cur_recov_amt
            ppv_rec = 0.

         usg_rec = tx2d_det.tx2d_cur_recov_amt
         - rcv_rec - ppv_rec.

         assign
            rcv_rec = (tx2d_det.tx2d_cur_recov_amt
            * rcv_amt)
            ppv_rec = (tx2d_det.tx2d_cur_recov_amt
            * ppv_amt).

         /* ROUND THE RECOVERABLE TAX AMTS USING THE */
         /* TAX ROUNDING METHOD BEFORE ROUNDING      */
         /* ACCORDING TO THE TRANSACTION CURRENCY    */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output rcv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output ppv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         assign 
            rcv_rec = rcv_rec / (rcv_amt + ppv_amt + usg_amt) + tx2d_cur_nontax_amt * rcv_amt /  (rcv_amt + ppv_amt + usg_amt)
            ppv_rec = ppv_rec / (rcv_amt + ppv_amt + usg_amt) - tx2d_cur_nontax_amt * rcv_amt /  (rcv_amt + ppv_amt + usg_amt)
            .

         /* ROUND THE RECOVERABLE TAX AMTS USING THE */
         /* TAX ROUNDING METHOD BEFORE ROUNDING      */
         /* ACCORDING TO THE TRANSACTION CURRENCY    */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output rcv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.


         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rcv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output ppv_rec,
               input        tax_round,
               output       mc-error-number)"}

         if mc-error-number <> 0
         then
            run mc_warning.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ppv_rec,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.
      END.
      /* SS - 20070419.1 - E */

      /* HAVE TAXES BEEN EDITED? */

      if tx2d_det.tx2d_edited = no
      then do:
         for first work_tx2d_det
               fields (work_nbr       work_ref      work_tr_type
               work_tax_type  work_line     work_tax_code
               work_rcv_tax   work_usg_tax  work_ppv_tax
               work_rcv_rec   work_usg_rec  work_ppv_rec)
               where
               work_tx2d_det.work_ref      = pvo_mstr.pvo_internal_ref and
               work_tx2d_det.work_nbr      = vo_mstr.vo_ref        and
               (work_tx2d_det.work_tr_type = "21"                  or
               work_tx2d_det.work_tr_type  = "25")                 and
               work_tx2d_det.work_line     = pvo_mstr.pvo_line     and
               work_tx2d_det.work_tax_type = tx2_mstr.tx2_tax_type
               no-lock:
         end.  /* FOR FIRST work_tx2d_det... */

         if available work_tx2d_det  and
            work_tx2d_det.work_tax_code <> tx2d_det.tx2d_tax_code
         then do:

            assign
               rcv_tax = work_rcv_tax
               ppv_tax = tx2d_det.tx2d_cur_tax_amt    - work_ppv_tax
               rcv_rec = work_rcv_rec
               ppv_rec = tx2d_det.tx2d_cur_recov_amt  - work_ppv_rec.

            /* SET USAGE VARIANCE WHEN RECEIVER LINE IS CLOSED */
            /* AND PO QTY IS NOT EQUAL TO INVOICE QTY          */

            if last_voucher > "" and
               pvo_trans_qty <> vouchered_qty
            then
               assign
                  usg_tax = work_ppv_tax - work_rcv_tax
                  usg_rec = work_ppv_rec - work_rcv_rec.

         end.  /* IF AVAILABLE work_tx2d_det... */
      end. /* IF tx2d_det.tx2d_edited = NO */

      if not tx2d_det.tx2d_tax_in
         or (not tx2d_det.tx2d_rcpt_tax_point
             and not (pvo_mstr.pvo_consignment and op_usage_point))
         then

      /* CALCULATE PORTION OF NON-RECOVERABLE TAX  */
      /* WHICH NEEDS TO BE ADDED TO INVENTORY      */
      /* DISCREPANCY ACCOUNT, (DUE TO INSUFFICIENT */
      /* QOH TO WHICH TO APPLY RATE VARIANCE).     */
      rcv_rec_discrep = (rcv_tax - rcv_rec) * pct_discrep.

      if not tx2d_det.tx2d_tax_in
         then
      /* CALCULATE PORTION OF NON-RECOVERABLE TAX  */
      /* WHICH NEEDS TO BE ADDED TO INVENTORY      */
      /* DISCREPANCY ACCOUNT, (DUE TO INSUFFICIENT */
      /* QOH TO WHICH TO APPLY RATE VARIANCE).     */
      ppv_rec_discrep = (ppv_tax - ppv_rec) * pct_discrep.

      if tx2d_det.tx2d_tax_in
         and (tx2d_det.tx2d_rcpt_tax_point
              or (pvo_mstr.pvo_consignment and op_usage_point))
         then
      /* TAX INCLUDED = YES. */
      /* CALCULATE PORTION OF RECOVERABLE TAX        */
      /* WHICH NEEDS TO BE SUBTRACTED FROM INVENTORY */
      /* DISCREPANCY ACCOUNT, (DUE TO INSUFFICIENT   */
      /* QOH TO WHICH TO APPLY RATE VARIANCE).       */
      rcv_rec_discrep = (- rcv_rec) * pct_discrep.

      if tx2d_det.tx2d_tax_in
         then
      /* TAX INCLUDED = YES. */
      /* CALCULATE PORTION OF RECOVERABLE TAX        */
      /* WHICH NEEDS TO BE SUBTRACTED FROM INVENTORY */
      /* DISCREPANCY ACCOUNT, (DUE TO INSUFFICIENT   */
      /* QOH TO WHICH TO APPLY RATE VARIANCE).       */
      ppv_rec_discrep = (- ppv_rec) * pct_discrep.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output rcv_rec_discrep,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ppv_rec_discrep,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then
         run mc_warning.

      /*-----------------------------------------------------*/
      /* CREATE VOD_DETS FOR TAX APPLICABLE TO VOUCHER */

      /* FIRST DO PO RECEIPTS TAXES */

         if tx2d_det.tx2d_rcpt_tax_point
         then
            run p_taxacct.

         /* TO EXCLUDE RE-ASSIGNMENT OF tax_acct TO por_acct */
         /* SINCE HERE por_acct HAS THE VALUE OF vph_acct    */
         else
            if not tx2d_det.tx2d_rcpt_tax_point
               and not icc_gl_tran
               and tx2d_det.tx2d_tax_in
            then .

         else
            assign
               tax_acct = por_acct
               tax_sub  = por_sub
               tax_cc   = por_cc.
               /* WHEN GL COST = STD, */
               /* THIS WILL BE AP RATE VARIANCE ACCOUNT) */

      run update_vod_det
         (rcv_tax - rcv_rec - rcv_rec_discrep).

      if tx2d_det.tx2d_rcpt_tax_point
         and not is_euro_trans
      then
         if prh_type    = ""
            or prh_type = "S"
         then
            l_por_amt = l_por_amt + (rcv_tax - rcv_rec - rcv_rec_discrep).
         else
            l_exp_amt = l_exp_amt + (rcv_tax - rcv_rec - rcv_rec_discrep).

      /* THE EXPENSED ACCOUNTS HAVE ALREADY BEEN  */
      /* ADJUSTED IN THE PRIOR LOGIC.             */

      assign
         tax_acct = por_discrep_acct
         tax_sub = por_discrep_sub
         tax_cc = por_discrep_cc.
      /* WHEN GL COST = STD, */
      /* THIS WILL BE AP RATE VARIANCE ACCOUNT) */

      /* CREATE/MODIFY VOD_DET FOR PO RECEIPT */
      /* TAX AFFECTING INVENTORY DISCREPANCY. */
      run update_vod_det
         (rcv_rec_discrep).

      if tx2d_det.tx2d_rcpt_tax_point
         and not is_euro_trans
      then
         if prh_type    = ""
            or prh_type = "S"
         then
            l_por_amt = l_por_amt + rcv_rec_discrep.
         else
            l_exp_amt = l_exp_amt + rcv_rec_discrep.

      assign
         tax_acct = tx2_ap_acct
         tax_sub = tx2_ap_sub
         tax_cc   = tx2_ap_cc.

      {&APVOMTI-P-TAG32}
      {&APVOMTI-P-TAG21}
      /* CREATE/MODIFY VOD_DET FOR AP TAX ACCOUNT */
      run update_vod_det (rcv_rec).

      /* SS - 20070419.1 - B */
      IF prh_tax_at = "" 
         AND prh_tax_in = YES
         THEN DO:
         assign
            tax_project = if (prh_type   = ""
                             or prh_type = "S" )
                          then
                             pvo_project
                          else
                             vph_project

            tax_acct    = ppv_acct
            tax_sub     = ppv_sub
            tax_cc      = ppv_cc.

                             run update_vod_det (- rcv_rec).
      END.
      /* SS - 20070419.1 - E */

      if tx2d_det.tx2d_rcpt_tax_point
         and not is_euro_trans
      then
         if prh_type = ""
            or prh_type = "S"
         then
            l_por_amt = l_por_amt + rcv_rec.
         else
            l_exp_amt = l_exp_amt + rcv_rec.

      if (l_por_amt      <> 0
          or l_exp_amt   <> 0)
      and vo_curr        <> base_curr
      and (vo_ex_rate2   <> pvo_ex_rate2
           or vo_ex_rate <> pvo_ex_rate)
      then do:
         if l_por_amt <> 0
         then
            run calculate_gain_loss (l_por_amt).

         if l_exp_amt <> 0
         then
            run calculate_gain_loss (l_exp_amt).

      end. /* IF l_por_amt <> 0 ... */

      {&APVOMTI-P-TAG22}

      /*----------------------------------------------------*/

      /* RATE VARIANCE FIRST */
      if ppv_tax <> 0 then do:

         assign
            tax_project = if (prh_type   = ""
                             or prh_type = "S" )
                          then
                             pvo_project
                          else
                             vph_project

            tax_acct    = ppv_acct
            tax_sub     = ppv_sub
            tax_cc      = ppv_cc.

         /* CREATE/MODIFY VOD_DET FOR RATE VARIANCE ACCOUNT */
         if not tx2d_det.tx2d_tax_in then
            run update_vod_det (ppv_tax).

         /* CHECK FOR RECOVERABLE TAXES  */
         /* IF RECOV. AMOUNT <> 0 */
         /* RELIEVE RATE VARIANCE AND MOVE TO AP TAX ACCOUNT */
         if ppv_rec <> 0
            or ppv_rec_discrep <> 0
         then do:

            /* CREATE/MODIFY VOD_DET FOR RATE VARIANCE */
            run update_vod_det
               (- ppv_rec - ppv_rec_discrep).

            if ppv_rec_discrep <> 0 then do:
               assign
                  tax_acct = ppv_discrep_acct
                  tax_sub = ppv_discrep_sub
                  tax_cc = ppv_discrep_cc.

               /* CREATE/MODIFY VOD_DET FOR INVENTORY DISCREP */
               run update_vod_det (ppv_rec_discrep).

            end.

            assign
               tax_acct = tx2_ap_acct
               tax_sub = tx2_ap_sub
               tax_cc = tx2_ap_cc.

            {&APVOMTI-P-TAG33}
            {&APVOMTI-P-TAG23}
            /* CREATE/MODIFY VOD_DET FOR AP TAX ACCOUNT */
            run update_vod_det (ppv_rec).
            {&APVOMTI-P-TAG24}

         end.

      end. /* RATE VARIANCE SECTION */

      /*-----------------------------------------------------*/

      /* USAGE VARIANCE SECTION */
      if usg_tax <> 0 then do:
         if prh_type = "" or prh_type = "S" then do:
            assign
               tax_acct = dftAPVUAcct
               tax_sub  = dftAPVUSubAcct
               tax_cc   = dftAPVUCostCenter.
         end.
         else do:  /*memo items*/
            if apc_expvar then
               assign
                  tax_project = vph_project
                  tax_acct    = gl_apvux_acct  /*usage variance*/
                  tax_sub     = gl_apvux_sub
                  tax_cc      = gl_apvux_cc.
            else   /*USE EXPENSE ACCOUNT FOR BOTH VARIANCES*/

            /* ASSIGN ACCOUNT ENTERED IN VOUCHER WHEN IT IS */
            /* CHANGED FOR USAGE VARIANCE OF MEMO ITEM      */

               assign
                  tax_acct    = vph_acct
                  tax_sub     = vph_sub
                  tax_cc      = vph_cc
                  tax_project = vph_project.

         end.

         /* CREATE/MODIFY VOD_DET FOR USAGE VARIANCE ACCOUNT */
         if not tx2d_det.tx2d_tax_in then
            run update_vod_det (usg_tax).

         /* CHECK FOR RECOVERABLE TAXES  */
         /* IF RECOV. AMOUNT <> 0 */
         /* RELIEVE USAGE VARIANCE AND MOVE TO AP TAX ACCOUNT */
         if usg_rec <> 0 then do:

            /* CREATE/MODIFY VOD_DET FOR USAGE VARIANCE */
            run update_vod_det (- usg_rec).
            assign
               tax_acct = tx2_ap_acct
               tax_sub = tx2_ap_sub
               tax_cc = tx2_ap_cc.
            {&APVOMTI-P-TAG34}
            {&APVOMTI-P-TAG25}
            /* CREATE/MODIFY VOD_DET FOR AP TAX ACCOUNT */
            run update_vod_det (usg_rec).
            {&APVOMTI-P-TAG26}

         end.

      end.    /* USAGE VARIANCE SECTION */
   end.

   /*---------------------------------------------------------*/

   /* MANUALLY ENTERED DISTRIBUTION LINES */
   /* OR RECEIVER LINES TAXED BY TOTAL */
   else do:

      l_vod_type = "".

      /* TAKE A SHORTCUT TO AVOID NEEDING THE ORIGINATING VOD-DET */
      if not tx2d_det.tx2d_tax_in
      and tx2d_det.tx2d_cur_recov_amt = tx2d_det.tx2d_cur_tax_amt
      /* TAX IS 100% RECOVERABLE, POST TO AP TAX ACCOUNT */
      then do:
         assign
            /* USING TX2D_TRL AS ENTITY CODE */
            tax_entity = tx2d_det.tx2d_trl
            /* PROJECT IS IGNORED FOR TAX-BY-TOTAL */
            tax_project = ""
            tax_acct = tx2_ap_acct
            tax_sub = tx2_ap_sub
            tax_cc = tx2_ap_cc.
         {&APVOMTI-P-TAG35}

         if tx2d_det.tx2d_line <> 0
         then do:
            for first vod_det
               fields(vod_ref vod_ln vod_entity vod_project)
               where vod_ref = vo_ref
               and   vod_ln  = tx2d_det.tx2d_line
               no-lock:
            end. /* FOR FIRST vod_det */
            if available vod_det
            then
               assign
                  tax_entity  = vod_entity
                  tax_project = vod_project.
         end. /* IF tx2d_det.tx2d_line <> 0 */

         {&APVOMTI-P-TAG27}
         /* CREATE/MODIFY VOD_DET FOR AP TAX ACCOUNT */
         run update_vod_det
            (tx2d_det.tx2d_cur_recov_amt).
         {&APVOMTI-P-TAG28}
      end.
      else do:
         /* TAX-INCLUDED, OR NOT 100% RECOVERABLE */

         find first vod_det where vod_ref = vo_ref and
         vod_ln = tx2d_det.tx2d_line no-lock no-error.

         assign
            tax_entity  = vod_entity
            tax_project = vod_project
            tax_acct    = vod_acct
            tax_sub     = vod_sub
            tax_cc      = vod_cc.

         /* CREATE/MODIFY VOD_DET FOR VOD ACCOUNT */

         if not tx2d_det.tx2d_tax_in then
            run update_vod_det
               (tx2d_det.tx2d_cur_tax_amt).

         /* CHECK FOR RECOVERABLE TAXES  */
         /* IF RECOV. AMOUNT <> 0 */
         /* RELIEVE VOD ACCOUNT AND PUT INTO AP TAX ACCOUNT */
         if tx2d_det.tx2d_cur_recov_amt <> 0 then do:

            /* CREATE/MODIFY VOD_DET FOR VOD ACCOUNT */

            run update_vod_det
               (- tx2d_det.tx2d_cur_recov_amt).

            assign
               tax_acct = tx2_ap_acct
               tax_sub = tx2_ap_sub
               tax_cc = tx2_ap_cc.

            {&APVOMTI-P-TAG36}
            {&APVOMTI-P-TAG29}
            /* CREATE/MODIFY VOD_DET FOR AP TAX ACCOUNT */
            run update_vod_det
               (tx2d_det.tx2d_cur_recov_amt).
            {&APVOMTI-P-TAG30}

         end.
      end. /* TAX-INCLUDED, OR NOT 100% RECOVERABLE */
   end.

   /*---------------------------------------------------------*/

   /* CHECK FOR RETAINED TAX ACCOUNT */
   /* IF RET. AMOUNT <> 0 AND RET. ACCOUNT <> BLANK */
   if tx2d_det.tx2d_cur_abs_ret_amt <> 0 and
      tx2_apr_use
   then do:
      assign
         tax_acct = tx2_apr_acct
         tax_sub = tx2_apr_sub
         tax_cc = tx2_apr_cc.

      /* CREATE/MODIFY VOD_DET FOR AP RETAINED TAX ACCOUNT */
      run update_vod_det
         (tx2d_det.tx2d_cur_abs_ret_amt).

   end.

end. /* for each tx2d_det */

/*------------------------------------------------------------*/

/* DELETE THE TEMP-TABLE work_tx2d_det */

for each work_tx2d_det exclusive-lock:
   delete work_tx2d_det.
end. /* FOR EACH work_tx2d_det */

for each vod_det exclusive-lock where vod_ref = vo_ref and
      vod_tax > "" and vod_amt = 0:
   delete vod_det.
end.

/* ADDED LOGIC TO PREVENT GAPS IN VOUCHER DISTRIBUTION LINES */
assign
   l_vod_ln = 1.
for each vod_det
      where vod_ref = vo_ref
      exclusive-lock:
   {&APVOMTI-P-TAG16}
   if vod_ln > l_vod_ln then
      assign
         vod_ln = l_vod_ln.
   {&APVOMTI-P-TAG17}
   assign
      l_vod_ln = l_vod_ln + 1.
end. /* FOR EACH VOD_DET ... */

assign
   tax_edit = false
   tax_flag = no
   no_taxrecs = false.

clear frame tax_dist all no-pause.

/*ADDED SEPERATE LOOP TO ACCUMULATE ap_amt TO AVOID INCORRECT*/
/*UPDATION AND DISPLAY OF ap_amt WHEN USER IS HITTING        */
/*F4 <I.E. ENDKEY> INSTEAD OF SPACE BAR                      */

for each vod_det
   fields(vod_ref vod_tax vod_amt vod_base_amt)
   where vod_ref = vo_ref
     and vod_tax > ""
   no-lock:

   /*UPDATE HEADER AMOUNT*/
   /*DON'T ADD RECOVERABLE TAXES */
   if vod_tax = "t"
   then
      {&APVOMTI-P-TAG14}
      assign
         ap_amt      = ap_amt      + vod_amt
         ap_base_amt = ap_base_amt + vod_base_amt.
      {&APVOMTI-P-TAG15}
end. /*FOR EACH vod_det*/

/* DISPLAY TAX DISTRIBUTION */
/*REWRITTEN for each vod_det TO INCLUDE no-lock AND FIELD LIST*/
for each vod_det
   fields(vod_ref vod_tax vod_acct vod_sub vod_cc vod_project
          vod_entity vod_desc vod_amt)
   where vod_ref = vo_ref
     and vod_tax > ""
   no-lock:

   assign vod_amt:format in frame tax_dist = vod_amt_fmt.
   {&APVOMTI-P-TAG12}
   display
      vod_acct
      vod_sub
      vod_cc
      vod_project
      vod_entity
      vod_desc
      vod_amt with frame tax_dist.
   {&APVOMTI-P-TAG13}
   down with frame tax_dist.

end.
/* IF NON-TAXABLE, NO VOD RECORDS WOULD BE FOUND; SO DISPLAY */
/* EMPTY TAX_DIST FRAME.                                     */
view frame tax_dist.

assign ap_amt:format in frame c = ap_amt_fmt.
display ap_amt ba_total + ap_amt @ ba_total with frame c.
pause 0.

/*---------------------------------------------------------------------------*/

PROCEDURE update_rcpt_det_for_partial_qty:

   /* THE INVOICE QTY IS LESS THAN THE QTY RECEIVED.           */
   /* PRORATE THE TAXABLE, NON-TAXABLE AND TOTAL SALES AMOUNTS */

   /* OBTAIN THE ROUNDING METHOD TO BE APPLIED FOR THE */
   /* AMOUNTS IN THE ENTITY CURRENCY                   */

   ent_rndmthd = gl_ctrl.gl_rnd_mthd.
   /* FIND en_mstr USING LINE SITE ENTITY IF NOT BLANK */
   if rcpt_det.tx2d_line_site_ent <> "" then
   find en_mstr where en_entity =
      rcpt_det.tx2d_line_site_ent no-lock no-error.
   else
   /* FIND en_mstr USING TRANSACTION ENTITY            */
   find en_mstr where en_entity =
      rcpt_det.tx2d_trans_ent no-lock no-error.

   if available en_mstr then do:
      /* IF ENTITY CURRENCY <> BASE CURRENCY           */
      if (gl_base_curr <> en_curr)
      then do:

         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input en_curr,
              output ent_rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then
            run mc_warning.

      end. /* IF gl_base_curr <> en_curr */
      else ent_rndmthd = gl_rnd_mthd.
   end. /* IF AVAILABLE en_mstr */

   assign
      rcpt_det.tx2d_tottax = (- tx2d_det.tx2d_tottax
                           * (vph_hist.vph_inv_qty / pvo_mstr.pvo_trans_qty))
      rcpt_det.tx2d_totamt = (- tx2d_det.tx2d_totamt
                           * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_cur_tax_amt = (- tx2d_det.tx2d_cur_tax_amt
                                * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_tax_amt = (- tx2d_det.tx2d_tax_amt
                            * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_ent_tax_amt = (- tx2d_det.tx2d_ent_tax_amt
                                * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_cur_nontax_amt = (- tx2d_det.tx2d_cur_nontax_amt
                                   * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_nontax_amt = (- tx2d_det.tx2d_nontax_amt
                               * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_ent_nontax_amt = (- tx2d_det.tx2d_ent_nontax_amt
                                   * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_taxable_amt = (- tx2d_det.tx2d_taxable_amt
                                * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_cur_recov_amt = (- tx2d_det.tx2d_cur_recov_amt
                                  * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_recov_amt = (- tx2d_det.tx2d_recov_amt
                              * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_ent_recov_amt = (- tx2d_det.tx2d_ent_recov_amt
                                  * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_cur_abs_ret_amt = (- tx2d_det.tx2d_cur_abs_ret_amt
                                    * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_abs_ret_amt = (- tx2d_det.tx2d_abs_ret_amt
                                * (vph_inv_qty / pvo_trans_qty))
      rcpt_det.tx2d_ent_abs_ret_amt = (- tx2d_det.tx2d_ent_abs_ret_amt
                                    * (vph_inv_qty / pvo_trans_qty)).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_tottax,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_totamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_cur_tax_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_tax_amt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_ent_tax_amt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_cur_nontax_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_nontax_amt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_ent_nontax_amt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_taxable_amt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_cur_recov_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_recov_amt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_ent_recov_amt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_cur_abs_ret_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_abs_ret_amt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rcpt_det.tx2d_ent_abs_ret_amt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

END PROCEDURE.

/*---------------------------------------------------------------------------*/

PROCEDURE update_rcpt_det_for_final_qty:
define input parameter vouchered_qty like pvo_vouchered_qty no-undo.

   /* THE RECEIVER IS BEING CLOSED,                             */
   /* BUT THE TOTAL INVOICED QTY IS LESS THAN THE QTY RECEIVED. */
   /* PROCESS THE UN-INVOICED AMOUNTS.                          */

   /* MUST HAVE BEEN THROUGH update_rcpt_det_for_partial_qty FIRST, */
   /* SO ENT_RNDMTHD IS ALREADY AVAILABLE                           */

   rndamt = (tx2d_det.tx2d_tottax * ((pvo_mstr.pvo_trans_qty - vouchered_qty)
             / pvo_mstr.pvo_trans_qty)).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_tottax = rcpt_det.tx2d_tottax - rndamt.

   rndamt = (tx2d_det.tx2d_totamt * ((pvo_trans_qty - vouchered_qty) / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_totamt = rcpt_det.tx2d_totamt - rndamt.

   rndamt = (tx2d_det.tx2d_cur_tax_amt * ((pvo_trans_qty - vouchered_qty)
                                       / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_cur_tax_amt = rcpt_det.tx2d_cur_tax_amt - rndamt.

   rndamt = (tx2d_det.tx2d_tax_amt * ((pvo_trans_qty - vouchered_qty) / pvo_trans_qty)).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input gl_ctrl.gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_tax_amt =
   rcpt_det.tx2d_tax_amt - rndamt.

   rndamt = (tx2d_det.tx2d_ent_tax_amt * ((pvo_trans_qty - vouchered_qty)
                                       / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_ent_tax_amt = rcpt_det.tx2d_ent_tax_amt - rndamt.

   rndamt = (tx2d_det.tx2d_cur_nontax_amt * ((pvo_trans_qty - vouchered_qty)
                                          / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_cur_nontax_amt = rcpt_det.tx2d_cur_nontax_amt - rndamt.

   rndamt = (tx2d_det.tx2d_nontax_amt * ((pvo_trans_qty - vouchered_qty)
                                      / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_nontax_amt = rcpt_det.tx2d_nontax_amt - rndamt.

   rndamt = (tx2d_det.tx2d_ent_nontax_amt * ((pvo_trans_qty - vouchered_qty)
                                          / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_ent_nontax_amt = rcpt_det.tx2d_ent_nontax_amt - rndamt.

   rndamt = (tx2d_det.tx2d_taxable_amt * ((pvo_trans_qty - vouchered_qty)
                                       / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_taxable_amt = rcpt_det.tx2d_taxable_amt - rndamt.

   rndamt = (tx2d_det.tx2d_cur_recov_amt * ((pvo_trans_qty - vouchered_qty)
                                         / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_cur_recov_amt = rcpt_det.tx2d_cur_recov_amt - rndamt.

   rndamt = (tx2d_det.tx2d_recov_amt * ((pvo_trans_qty - vouchered_qty) / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_recov_amt = rcpt_det.tx2d_recov_amt - rndamt.

   rndamt = (tx2d_det.tx2d_ent_recov_amt * ((pvo_trans_qty - vouchered_qty)
                                         / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_ent_recov_amt = rcpt_det.tx2d_ent_recov_amt - rndamt.

   rndamt = (tx2d_det.tx2d_cur_abs_ret_amt * ((pvo_trans_qty - vouchered_qty)
                                           / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_cur_abs_ret_amt = rcpt_det.tx2d_cur_abs_ret_amt - rndamt.

   rndamt = (tx2d_det.tx2d_abs_ret_amt * ((pvo_trans_qty - vouchered_qty)
                                       / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input gl_rnd_mthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_abs_ret_amt = rcpt_det.tx2d_abs_ret_amt - rndamt.

   rndamt = (tx2d_det.tx2d_ent_abs_ret_amt * ((pvo_trans_qty - vouchered_qty)
                                           / pvo_trans_qty)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input ent_rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.
   rcpt_det.tx2d_ent_abs_ret_amt = rcpt_det.tx2d_ent_abs_ret_amt - rndamt.

END PROCEDURE.

/*---------------------------------------------------------------------------*/

PROCEDURE mc_get_vo_ex_rate_at_rcpt_date:

   /* GET EXCHANGE RATE BETWEEN VOUCHER AND BASE */
   /* AS OF RECEIPT DATE */
   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
      "(input vo_mstr.vo_curr,
        input base_curr,
        input vo_ex_ratetype,
        input pvo_mstr.pvo_trans_date,
        output rcp_date_vo_ex_rate,
        output rcp_date_vo_ex_rate2,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

   /* COMBINE PRH-TO-BASE EX RATE WITH BASE-TO-VO EX RATE */
   {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
      "(input pvo_mstr.pvo_ex_rate,
        input pvo_mstr.pvo_ex_rate2,
        input rcp_date_vo_ex_rate2,
        input rcp_date_vo_ex_rate,
        output rcp_to_vo_ex_rate,
        output rcp_to_vo_ex_rate2)"}

END PROCEDURE.

/*---------------------------------------------------------------------------*/

PROCEDURE convert_receipt_to_voucher:

   define input-output parameter amt as decimal.

   /* CONVERT FROM RECEIPT TO VOUCHER CURRENCY */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input pvo_mstr.pvo_curr,
        input vo_mstr.vo_curr,
        input rcp_to_vo_ex_rate,
        input rcp_to_vo_ex_rate2,
        input amt,
        input true, /* ROUND */
        output amt,
        output mc-error-number)"}
   if mc-error-number <> 0 then
      run mc_warning.

END PROCEDURE.

/*---------------------------------------------------------------------------*/

PROCEDURE update_vod_det:

   /* Copied from apvomti.i, which is now obsolete from 8.6 on */

   define input parameter tax_amt as decimal.
   {&APVOMTI-P-TAG8}

   if tax_amt <> 0 then do:

      for first vod_det
          fields(vod_ref vod_type vod_entity vod_acct vod_sub vod_cc
                 vod_project vod_exp_acct vod_exp_sub vod_exp_cc
                 vod_desc)
          where vod_ref      = vo_mstr.vo_ref
            and vod_type     = l_vod_type
            and vod_entity   = tax_entity
            and vod_acct     = tax_acct
            and vod_sub      = tax_sub
            and vod_cc       = tax_cc
            and vod_project  = tax_project
            and vod_exp_acct = l_expacct
            and vod_exp_sub  = l_expsub
            and vod_exp_cc   = l_expcc
          no-lock:
      end. /* FOR FIRST vod_det */
      if available vod_det
      then
         l_vod_desc = vod_desc.
      else do:
         for first ac_mstr
            fields(ac_code ac_desc)
            where ac_code = tax_acct
            no-lock:
         end. /* FOR FIRST ac_mstr */
         if available ac_mstr
         then
            l_vod_desc = ac_desc.
      end. /* IF NOT AVAILABLE vod_det */

      find first vod_det where
         vod_ref   = vo_mstr.vo_ref
         and vod_entity  = tax_entity
         and vod_acct  = tax_acct
         and vod_sub  = tax_sub
         and vod_cc    = tax_cc
         and vod_project = tax_project
         and vod_tax   = "t"
         exclusive-lock no-error.

      if not available vod_det then do:
         create vod_det.
         assign
            vod_entity  = tax_entity
            vod_ref     = vo_mstr.vo_ref
            vod_ln      = last_ln + 1
            vod_acct    = tax_acct
            vod_sub    = tax_sub
            vod_cc      = tax_cc
            vod_project = tax_project
            vod_tax     = "t"
            vod_type    = "T"
            vod_tax_at  = "no"
            vod_amt     = tax_amt
            vod_dy_code = ap_mstr.ap_dy_code
            vod_dy_num  = nrm-seq-num
            last_ln     = vod_ln.
         if recid(vod_det) = -1 then .

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input vod_amt,
              input true, /* ROUND */
              output vod_base_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then
            run mc_warning.

         vod_desc = l_vod_desc.

      end. /* if not available vod_det */

      else
         do:
         vod_amt = vod_amt + tax_amt.
         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input vod_amt,
              input true, /* ROUND */
              output vod_base_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then
            run mc_warning.
      end.

      if prm-enabled and available pvo_mstr
         and pvo_mstr.pvo_project <> "" then
      do:
         /* DETERMINE ACCOUNTS */
         run determine_accounts
            (input recid (pvo_mstr),
            output prm_rate_var_acct,
            output prm_rate_var_sub,
            output prm_rate_var_cc,
            output prm_usage_var_acct,
            output prm_usage_var_sub,
            output prm_usage_var_cc,
            output prm_ppv_acct,
            output prm_ppv_sub,
            output prm_ppv_cc).

         /* IF THIS IS ONE OF THE VARIANCE ACCOUNTS THEN */
         /* MARK WITH PROJECT LINE FOR REVERSING LATER */
         if tax_acct <> ""
            and
            (tax_acct = prm_rate_var_acct
            or tax_acct = prm_usage_var_acct
            or tax_acct = prm_ppv_acct) then
         for first pod_det
               fields(pod_pjs_line)
               where pod_det.pod_nbr = pvo_mstr.pvo_order
               and pod_det.pod_line = pvo_mstr.pvo_line
               no-lock:
            vod_pjs_line = pod_det.pod_pjs_line.
         end.
      end.

   end. /* if tax_amt <> 0 */

{&APVOMTI-P-TAG9}
END PROCEDURE.

/*------------------------------------------------------------------*/

PROCEDURE update-memo:

   define input parameter tax_amt as decimal.

   if tax_amt <> 0 then do:

      if icc_ctrl.icc_gl_tran
      then do:

         assign
            tax_acct    = pvo_mstr.pvo_accrual_acct
            tax_sub     = pvo_mstr.pvo_accrual_sub
            tax_cc      = pvo_mstr.pvo_accrual_cc
            tax_project = pvo_mstr.pvo_project.

         /* CREATE/MODIFY VOD_DET FOR OLD EXPENSE ACCOUNT */
         run update_vod_det (- tax_amt).

         assign
            tax_acct            = vph_hist.vph_acct
            tax_sub            = vph_hist.vph_sub
            tax_cc              = vph_hist.vph_cc
            tax_project         = vph_hist.vph_project.

         /* CREATE/MODIFY VOD_DET FOR NEW EXPENSE ACCOUNT */
         run update_vod_det ( tax_amt).

      end. /* IF icc_ctrl.icc_gl_tran */

      assign tax_project = pvo_mstr.pvo_project.

   end. /* IF tax_amt <> 0 */

END PROCEDURE.

/*------------------------------------------------------------------*/

PROCEDURE mc_warning:

   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}

END PROCEDURE.

/* FIND THE TAX CODE APPLICABLE BASED ON THE TAX CLASS    */
/* AND TAX USAGE DURING VOUCHERING                        */

PROCEDURE p_tax_code:

   define input  parameter tax_type  like tx2_tax_type  no-undo.
   define input  parameter tax_class like tx2_pt_taxc   no-undo.
   define input  parameter tax_usage like tx2_tax_usage no-undo.
   define input  parameter tax_date  like tx2_effdate   no-undo.
   define output parameter tax_code  like tx2_tax_code  no-undo.

   define buffer b_tx2_mstr for tx2_mstr.

   for last b_tx2_mstr
         fields(tx2_ap_acct    tx2_ap_cc    tx2_effdate
                tx2_tax_code   tx2_tax_type tx2_tax_usage
                tx2_apr_acct   tx2_apr_cc   tx2_apr_use
                tx2_exp_date   tx2_pt_taxc)
         where  tx2_tax_type  =  tax_type  and
         tx2_pt_taxc   =  tax_class and
         tx2_tax_usage =  tax_usage and
         tx2_effdate   <= tax_date  and
         (tx2_exp_date = ?          or
         tx2_exp_date >= tax_date)
         no-lock:
   end. /* FOR LAST b_tx2_mstr... */

   if not available(b_tx2_mstr)
   then
   for last b_tx2_mstr
         fields(tx2_ap_acct    tx2_ap_cc    tx2_effdate
                tx2_tax_code   tx2_tax_type tx2_tax_usage
                tx2_apr_acct   tx2_apr_cc   tx2_apr_use
                tx2_exp_date   tx2_pt_taxc)
         where  tx2_tax_type  =  tax_type  and
         tx2_pt_taxc   =  tax_class and
         tx2_tax_usage =  ""        and
         tx2_effdate   <= tax_date  and
         (tx2_exp_date =  ?         or
         tx2_exp_date >= tax_date)
         no-lock:
   end. /* FOR LAST b_tx2_mstr... */

   if not available(b_tx2_mstr)
   then
   for last b_tx2_mstr
         fields(tx2_ap_acct    tx2_ap_cc    tx2_effdate
                tx2_tax_code   tx2_tax_type tx2_tax_usage
                tx2_apr_acct   tx2_apr_cc   tx2_apr_use
                tx2_exp_date   tx2_pt_taxc)
         where  tx2_tax_type  =  tax_type  and
         tx2_pt_taxc   =  ""        and
         tx2_tax_usage =  tax_usage and
         tx2_effdate   <= tax_date  and
         (tx2_exp_date =  ?         or
         tx2_exp_date >= tax_date)
         no-lock:
   end. /* FOR LAST b_tx2_mstr... */
   if not available(b_tx2_mstr)
   then
   for last b_tx2_mstr
         fields(tx2_ap_acct    tx2_ap_cc    tx2_effdate
                tx2_tax_code   tx2_tax_type tx2_tax_usage
                tx2_apr_acct   tx2_apr_cc   tx2_apr_use
                tx2_exp_date   tx2_pt_taxc)
         where  tx2_tax_type  =  tax_type  and
         tx2_pt_taxc   =  ""        and
         tx2_tax_usage =  ""        and
         tx2_effdate   <= tax_date  and
         (tx2_exp_date =  ?         or
         tx2_exp_date >= tax_date)
         no-lock:
   end. /* FOR LAST b_tx2_mstr... */
   if available(b_tx2_mstr) then
   assign
      tax_code = tx2_tax_code.
   else
   assign
      tax_code = "".

END PROCEDURE.  /* PROCEDURE p_tax_code */

/* --------------------------------------------------------------- */
PROCEDURE determine_accounts:
/* --------------------------------------------------------------- */

   /* INPUT PARAMETERS */
   define input parameter in_pvo_recid as recid no-undo.

   /* OUTPUT PARAMETERS */
   define output parameter out_prm_rate_var_acct as character no-undo.
   define output parameter out_prm_rate_var_sub  as character no-undo.
   define output parameter out_prm_rate_var_cc   as character no-undo.
   define output parameter out_prm_usage_var_acct
      as character no-undo.
   define output parameter out_prm_usage_var_sub as character no-undo.
   define output parameter out_prm_usage_var_cc  as character no-undo.
   define output parameter out_prm_ppv_acct as character no-undo.
   define output parameter out_prm_ppv_sub  as character no-undo.
   define output parameter out_prm_ppv_cc   as character no-undo.

   /* ASSIGN SPACE TO ALL OUTPUT ACCOUNTS */
   assign
      out_prm_rate_var_acct = ""
      out_prm_rate_var_sub = ""
      out_prm_rate_var_cc = ""
      out_prm_usage_var_acct = ""
      out_prm_usage_var_sub = ""
      out_prm_usage_var_cc = ""
      out_prm_ppv_acct = ""
      out_prm_ppv_sub = ""
      out_prm_ppv_cc = "".

   /* RETRIEVE TABLES */
   for first gl_ctrl no-lock:

      for first pvo_mstr
            fields (pvo_order pvo_line)
            where recid (pvo_mstr) = in_pvo_recid
            no-lock:

         for first pod_det
               fields (pod_part pod_type)
               where pod_nbr = pvo_order     and
               pod_line = pvo_line
               no-lock:

            /* MEMO ITEM W/ EXPENSED ITEM VARIANCE */
            if pod_type = "M" then
            assign
               out_prm_rate_var_acct  = gl_apvrx_acct
               out_prm_rate_var_sub   = gl_apvrx_sub
               out_prm_rate_var_cc    = gl_apvrx_cc
               out_prm_usage_var_acct = gl_apvux_acct
               out_prm_usage_var_sub  = gl_apvux_sub
               out_prm_usage_var_cc   = gl_apvux_cc.

            /* INVENTORY ITEM */
            else if pod_type = "" or pod_type = "S" then do:

               for first pt_mstr
                     fields (pt_prod_line)
                     where pt_part = pod_part
                     no-lock:
               end. /* FOR FIRST PT_MSTR */

               /* RETRIEVE ACCOUNTS FROM PRODUCT LINE */
               if available pt_mstr then
                  for first pl_mstr where
                  pl_prod_line = pt_prod_line
                  no-lock:
            end.
            /* DETERMINE SUPPLIER TYPE */
            run getGLDefaults.
            assign
               out_prm_rate_var_acct  = dftAPVRAcct
               out_prm_rate_var_sub   = dftAPVRSubAcct
               out_prm_rate_var_cc    = dftAPVRCostCenter
               out_prm_usage_var_acct = dftAPVUAcct
               out_prm_usage_var_sub  = dftAPVUSubAcct
               out_prm_usage_var_cc   = dftAPVUCostCenter
               out_prm_ppv_acct       = dftPPVAcct
               out_prm_ppv_sub        = dftPPVSubAcct
               out_prm_ppv_cc         = dftPPVCostCenter.

         end.  /* IF POD_TYPE = "" OR POD_TYPE = "S" */
      end. /* FOR FIRST POD_DET */
   end. /* FOR FIRST PVO_MSTR */
end. /* FOR FIRST GL_CTRL */

END PROCEDURE. /* DETERMINE_ACCOUNTS */

/* PICK ACCOUNT ENTERED IN VOUCHER FOR MEMO ITEMS */
/* AND PURCHASE LINE ACCOUNT FOR INVENTORY ITEMS  */
/* WHEN CREATE GL TRANS FLAG IS SET TO "NO"       */

PROCEDURE p_taxacct :

   for first pod_det
      fields(pod_acct pod_cc pod_line pod_nbr pod_sub)
      where pod_nbr   = pvo_mstr.pvo_order
      and   pod_line  = pvo_mstr.pvo_line
      no-lock :
   end. /* FOR FIRST pod_det */

   if not icc_ctrl.icc_gl_tran
   then do:
      if prh_hist.prh_type     <> ""
         and prh_hist.prh_type <> "s"
      then
         assign
            tax_acct    = vph_hist.vph_acct
            tax_sub     = vph_hist.vph_sub
            tax_cc      = vph_hist.vph_cc
            tax_project = vph_hist.vph_project.
      else
      if available pod_det
      then
         assign
            tax_acct    = pod_det.pod_acct
            tax_sub     = pod_det.pod_sub
            tax_cc      = pod_det.pod_cc
            tax_project = pvo_mstr.pvo_project.
   end. /* IF NOT icc_ctrl.icc_gl_tran */

   else
      assign
         tax_acct = por_acct
         tax_sub  = por_sub
         tax_cc   = por_cc.

END PROCEDURE. /* PROCEDURE p_taxacct */

PROCEDURE getGLDefaults:
   for first vd_mstr
      fields (vd_addr vd_type)
      where vd_addr = ap_mstr.ap_vend no-lock: end.

     {gprun.i ""glactdft.p"" "(input ""PO_RCPT_ACCT"",
                               input if available pt_mstr then
                                        pt_mstr.pt_prod_line else """",
                               input pvo_mstr.pvo_shipto,
                               input if available vd_mstr then
                                     vd_type else """",
                               input """",
                               input yes,
                               output dftRCPTAcct,
                               output dftRCPTSubAcct,
                               output dftRCPTCostCenter)"}

     {gprun.i ""glactdft.p"" "(input ""PO_APVU_ACCT"",
                               input if available pt_mstr then
                                        pt_mstr.pt_prod_line else """",
                               input pvo_mstr.pvo_shipto,
                               input if available vd_mstr then
                                     vd_type else """",
                               input """",
                               input yes,
                               output dftAPVUAcct,
                               output dftAPVUSubAcct,
                               output dftAPVUCostCenter)"}

     {gprun.i ""glactdft.p"" "(input ""PO_APVR_ACCT"",
                               input if available pt_mstr then
                                        pt_mstr.pt_prod_line else """",
                               input pvo_mstr.pvo_shipto,
                               input if available vd_mstr then
                                     vd_type else """",
                               input """",
                               input yes,
                               output dftAPVRAcct,
                               output dftAPVRSubAcct,
                               output dftAPVRCostCenter)"}

     {gprun.i ""glactdft.p"" "(input ""PO_PPV_ACCT"",
                               input if available pt_mstr then
                                        pt_mstr.pt_prod_line else """",
                               input pvo_mstr.pvo_shipto,
                               input if available vd_mstr then
                                     vd_type else """",
                               input """",
                               input yes,
                               output dftPPVAcct,
                               output dftPPVSubAcct,
                               output dftPPVCostCenter)"}
END PROCEDURE.


PROCEDURE determine_usage_tax_point:
   define input parameter ip_po_nbr as character no-undo.
   define input parameter ip_pod_line as integer no-undo.
   define input parameter ip_tax_code as character no-undo.
   define output parameter op_usage_point as logical no-undo.

   for first tx2_mstr
      fields(tx2_usage_tax_point)
      where tx2_tax_code = ip_tax_code
      no-lock:
      op_usage_point = tx2_usage_tax_point.
   end.
END PROCEDURE. /* PROCEDURE determine_usage_tax_point */

/* PROCEDURE calculate_gain_loss PASSES THE TAX AMOUNT ON EXCHANGE   */
/* GAIN LOSS TO PURCHASE PRICE VARIANCE ACCOUNT BY SUBTRACTING IT    */
/* FROM PO RECEIPTS FOR INVENTORY ITEM AND EXPENSED ITEM RECEIPT FOR */
/* MEMO ITEM WHEN ACCRUE TAX AT RECEIPT IS YES                       */

PROCEDURE calculate_gain_loss :

   define input parameter p_amt like mfc_decimal no-undo.

   define variable l_amt        like p_amt       no-undo.
   define variable l_gl         like p_amt       no-undo.

   l_amt = p_amt * vo_mstr.vo_ex_rate / vo_mstr.vo_ex_rate2
                 * pvo_mstr.pvo_ex_rate2 / pvo_mstr.pvo_ex_rate.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output l_amt,
        input ent_rndmthd,
        output mc-error-number)"}

   if mc-error-number <> 0
   then
      run mc_warning.

   l_gl = p_amt - l_amt.

   if l_exp_amt <> 0
   then
      assign
         tax_acct  = gl_ctrl.gl_rcptx_acct
         tax_sub   = gl_ctrl.gl_rcptx_sub
         tax_cc    = gl_ctrl.gl_rcptx_cc.
   else
      assign
         tax_acct  = dftRCPTAcct
         tax_sub   = dftRCPTSubAcct
         tax_cc    = dftRCPTCostCenter.

   run update_vod_det (- l_gl).

   if glx_mthd = "AVG"
   then
      if available pld_det
      then
         assign
            tax_acct = pld_det.pld_inv_acct
            tax_sub  = pld_det.pld_inv_sub
            tax_cc   = pld_det.pld_inv_cc.
      else
         assign
            tax_acct = pl_mstr.pl_inv_acct
            tax_sub  = pl_mstr.pl_inv_sub
            tax_cc   = pl_mstr.pl_inv_cc.
   else
      assign
         tax_acct = dftPPVAcct
         tax_sub  = dftPPVSubAcct
         tax_cc   = dftPPVCostCenter.

   run update_vod_det (l_gl).

END PROCEDURE. /* PROCEDURE calculate_gain_loss */
