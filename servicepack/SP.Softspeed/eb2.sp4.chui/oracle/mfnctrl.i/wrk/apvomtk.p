/* apvomtk.p - AP VOUCHER MAINTENANCE PROCESS GL & COST IMPACT                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.17 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4            CREATED: 02/25/94   BY: pcd *H199*                */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 09/27/95   BY: jzw *G0YD*                */
/* REVISION: 8.5      LAST MODIFIED: 10/30/95   BY: mwd *J053*                */
/* REVISION: 8.6      LAST MODIFIED: 02/12/97   BY: *K01G* E. Hughart         */
/* REVISION: 8.6      LAST MODIFIED: 03/10/97   BY: *K084* Jeff Wootton       */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *J21B* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.6               */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 11/01/99   BY: *N053* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 04/26/00   BY: *N090* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *N0W0* Chris Green        */
/* REVISION: 9.1      LAST MODIFIED: 02/15/00   BY: *N0WX* Chris Green        */
/* Revision: 1.7.1.11    BY: Mamata Samant        DATE: 03/26/02  ECO: *P04F* */
/* Revision: 1.7.1.14    BY: Steve Nugent         DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.7.1.16    BY: Samir Bavkar         DATE: 06/20/02  ECO: *P09D* */
/* $Revision: 1.7.1.17 $ BY: Robin McCarthy       DATE: 07/15/02  ECO: *P0BJ* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* Pre-86E commented code removed, view in archive revision 1.6             */
/****************************************************************************/
/*!
   CARRY OUT ALL GL TRANSACTIONS. UNDO FROM BEFORE IMAGE, REDO FROM CURRENT
   STATE OF THE DATABASE.
*/
/*!
          DEFINE INPUT PARAMETER ACTION LIKE mfc_logical.
          FALSE ==> CAPTURE BI
          TRUE  ==> PROCESS GL - UNDO/REDO

*****************************************************************************/
{mfdeclre.i}
{cxcustom.i "APVOMTK.P"}
{gldydef.i}
{gldynrm.i}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

define input parameter action         as integer.

/* DEFINE 'BEFORE IMAGE' WORKFILES */
{apvobidf.i}

/* DEFINE PRH_HIST UPDATE TEMP-TABLE */
{apvoprdf.i}

define variable process_gl                like mfc_logical no-undo.
define variable mc-error-number           like msg_nbr     no-undo.
define variable old_db                    like si_db       no-undo.

define shared variable ap_recno       as   recid.
define shared variable vo_recno       as   recid.
define shared variable vod_recno      as   recid.
define shared variable new_vchr       like mfc_logical.
define shared variable jrnl           like glt_ref.
define shared variable curr_amt       like glt_curr_amt.
define shared variable base_amt       like ap_amt.
define shared variable base_det_amt   like glt_amt.
define shared variable undo_all       like mfc_logical.
define shared variable rndmthd        like rnd_rnd_mthd.

define new shared variable vodacct  like vod_acct extent 8.
define new shared variable vodsub   like vod_sub  extent 8.
define new shared variable vodcc    like vod_cc   extent 8.
define new shared variable vodamt   like vod_amt  extent 8.
define new shared variable new_site like si_site.
define new shared variable new_db   like si_db.

define variable vouchered_qty like pvo_vouchered_qty no-undo.
define variable last_voucher like pvo_last_voucher no-undo.
define variable ers_status like pvo_ers_status no-undo.
define variable RECEIVER-TYPE as character initial "07" no-undo.
define variable use-log-acctg as logical no-undo.
define variable logistics_charge_voucher like mfc_logical no-undo.

{&APVOMTK-P-TAG1}

for first apc_ctrl
   fields (apc_jrnl)
no-lock:
end. /* FOR FIRST apc_ctrl */

for first vo_mstr
   fields (vo_confirmed vo_ref)
   where recid(vo_mstr) = vo_recno
no-lock:
end. /* FOR FIRST vo_mstr */

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

if action = 0
then do:

   /* CAPTURE VOUCHER BEFORE IMAGE */
   /* START WITH CLEAN WORKFILES */

   for each vodbi_wkfl
   exclusive-lock:
      delete vodbi_wkfl.
   end. /* FOR EACH vodbi_wkfl */

   for each vphbi_wkfl
   exclusive-lock:
      delete vphbi_wkfl.
   end. /* FOR EACH vphbi_wkfl */

   if vo_recno = ?
   then
      return.
   for first vo_mstr
      fields (vo_confirmed vo_ref)
      where recid(vo_mstr) = vo_recno
   no-lock:
   end. /* FOR FIRST vo_mstr */

   for each vod_det
     fields (vod_acct vod_amt vod_base_amt vod_cc vod_desc vod_dy_num vod_entity
             vod_exp_acct vod_exp_cc vod_exp_sub vod_ln vod_pjs_line vod_project
             vod_ref vod_sub vod_tax vod_taxc vod_tax_at vod_tax_in
             vod_tax_usage vod_type vod_user1 vod_user2)
     where vod_ref = vo_ref
   no-lock:
      create vodbi_wkfl.
      assign
         vodbi_acct        = vod_acct
         vodbi_sub         = vod_sub
         vodbi_amt         = vod_amt
         vodbi_base_amt    = vod_base_amt
         vodbi_cc          = vod_cc
         vodbi_desc        = vod_desc
         vodbi_entity      = vod_entity
         vodbi_exp_acct    = vod_exp_acct
         vodbi_exp_sub     = vod_exp_sub
         vodbi_exp_cc      = vod_exp_cc
         vodbi_ln          = vod_ln
         vodbi_project     = vod_project
         vodbi_pjs_line    = vod_pjs_line
         vodbi_ref         = vod_ref
         vodbi_tax         = vod_tax
         vodbi_taxc        = vod_taxc
         vodbi_tax_at      = vod_tax_at
         vodbi_tax_in      = vod_tax_in
         vodbi_tax_usage   = vod_tax_usage
         vodbi_type        = vod_type
         vodbi_user1       = vod_user1
         vodbi_user2       = vod_user2.
   end. /* FOR EACH vod_det */

   for each vph_hist
     where vph_ref = vo_ref
   exclusive-lock:

      /* POPULATE CONFIRMED ADJUSTMENT AMOUNTS ADDED BY ECO M0BG */
      if  vo_confirm
      and vph_cf_adj_amt  = 0
      and vph_cf_dscr_amt = 0
      then
         assign
            vph_cf_adj_amt  = vph_adj_amt
            vph_cf_dscr_amt = vph_dscr_amt.

      /* FIND THE PENDING VOUCHER FOR THE RECEIVER NUMBER */
      for first pvo_mstr where
            pvo_lc_charge   = "" and
            pvo_internal_ref_type = {&TYPE_POReceiver} and
            pvo_id = vph_pvo_id
            no-lock: end.

      /* STORE VOUCHER RECEIPT HISTORY AS BEFORE-IMAGE */
      create vphbi_wkfl.
      assign
         vphbi_acct         = vph_acct
         vphbi_sub          = vph_sub
         vphbi_amt          = vph_amt
         vphbi_avg_post     = vph_avg_post
         vphbi_cc           = vph_cc
         vphbi_curr_amt     = vph_curr_amt
         vphbi_element      = vph_element
         vphbi_inv_cost     = vph_inv_cost
         vphbi_inv_date     = vph_inv_date
         vphbi_inv_qty      = vph_inv_qty
         vphbi_line         = (if available pvo_mstr then pvo_line
                                                     else 0)
         vphbi_pvod_id_line = vph_pvod_id_line
         vphbi_nbr          = vph_nbr
         vphbi_receiver     = (if available pvo_mstr then pvo_internal_ref
                                                     else "")
         vphbi_ref          = vph_ref
         vphbi_costadj_acct = vph_costadj_acct
         vphbi_costadj_sub  = vph_costadj_sub
         vphbi_costadj_cc   = vph_costadj_cc
         vphbi_dscr_acct    = vph_dscr_acct
         vphbi_dscr_sub     = vph_dscr_sub
         vphbi_dscr_cc      = vph_dscr_cc
         vphbi_project      = vph_project
         vphbi_user1        = vph_user1
         vphbi_user2        = vph_user2
         vphbi_adj_amt      = vph_adj_amt
         vphbi_dscr_amt     = vph_dscr_amt
         vphbi_cf_adj_amt   = vph_cf_adj_amt
         vphbi_cf_dscr_amt  = vph_cf_dscr_amt
         vphbi_adj_prv_cst  = vph_adj_prv_cst
         vphbi_qoh_at_adj   = vph_qoh_at_adj
         vphbi_adj_inv      = vph_adj_inv
         vphbi_adj_wip      = vph_adj_wip.

   end. /* FOR EACH vph_hist */

end. /* IF action = 0 */
else do: /* ACTION = 1 */
   if vo_confirm
   then
   /* PROCESS GL - BACK OUT BI & POST CURRENT STATE */

   gl_impact:
   do on error undo:

      for first vo_mstr
         fields (vo_confirmed vo_ref)
         where recid(vo_mstr) = vo_recno
      no-lock:
      end. /* FOR FIRST vo_mstr */

      /* COMPARE BEFORE IMAGE WITH CURRENT STATE */
      process_gl = false.

      for first vodbi_wkfl
         fields (vodbi_acct vodbi_amt vodbi_base_amt vodbi_cc vodbi_desc
                 vodbi_entity vodbi_exp_acct vodbi_exp_cc vodbi_exp_sub vodbi_ln
                 vodbi_pjs_line vodbi_project vodbi_ref vodbi_sub vodbi_tax
                 vodbi_taxc vodbi_tax_at vodbi_tax_in vodbi_tax_usage vodbi_type
                 vodbi_user1 vodbi_user2)
      no-lock:
      end. /* FOR FIRST vodbi_wkfl */
      compare_loop:
      for each vod_det
         fields (vod_acct vod_amt vod_base_amt vod_cc vod_desc vod_dy_num
                 vod_entity vod_exp_acct vod_exp_cc vod_exp_sub vod_ln
                 vod_pjs_line vod_project vod_ref vod_sub vod_tax vod_taxc
                 vod_tax_at vod_tax_in vod_tax_usage vod_type vod_user1
                 vod_user2)
         where vod_ref = vo_ref
      no-lock:
         if not available vodbi_wkfl
         or vodbi_acct        <> vod_acct
         or vodbi_sub         <> vod_sub
         or vodbi_amt         <> vod_amt
         or vodbi_base_amt    <> vod_base_amt
         or vodbi_cc          <> vod_cc
         or vodbi_entity      <> vod_entity
         or vodbi_exp_acct    <> vod_exp_acct
         or vodbi_exp_sub     <> vod_exp_sub
         or vodbi_exp_cc      <> vod_exp_cc
         or vodbi_ln          <> vod_ln
         or vodbi_pjs_line    <> vod_pjs_line
         or vodbi_project     <> vod_project
         or vodbi_tax         <> vod_tax
         or vodbi_taxc        <> vod_taxc
         or vodbi_tax_at      <> vod_tax_at
         or vodbi_tax_in      <> vod_tax_in
         or vodbi_tax_usage   <> vod_tax_usage
         or vodbi_type        <> vod_type
         then do:
            process_gl = true.
            leave compare_loop.
         end. /* IF NOT AVAILABLE vodbi_wkfl */
         find next vodbi_wkfl
         no-lock no-error.
      end. /* FOR EACH vod_det */

      /* HANDLE CASES WHERE FEWER vod_det THAN vodbi EXIST */
      process_gl = process_gl or
                   (not available(vod_det) and available (vodbi_wkfl)).

      if not process_gl
      then
         return.

      if jrnl = ""
      then do:
         /* GET NEXT JOURNAL REFERENCE NUMBER  */
         {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}
         release glt_det.
         release apc_ctrl.
      end. /* IF jrnl = "" */

      /* APVOMTK.p IS CALLED FROM APVOMT.P, APERSUPA.P AND EDIMIVLD.P */
      /* BOTH ERS AND EDI INVOICE LOADER DO NOT SUPPORT PENDING       */
      /* VOUCHERS FOR LOGISTICS CHARGES.                              */
      /* THEREFORE logistics_charge_voucher CAN BE TRUE ONLY  */
      /* WHEN APVOMTK.P IS CALLED FROM APVOMT.p                       */

      logistics_charge_voucher = false.
      if use-log-acctg then do:
         for first vph_hist no-lock
             where vph_ref = vo_ref
               and (can-find(first pvo_mstr where pvo_id = vph_pvo_id
                               and pvo_lc_charge <> "")):
         end. /* FOR FIRST VPH_HIST */
         if available vph_hist then
            logistics_charge_voucher = true.
      end. /* IF use-log-acctg */

      /* UNDO COST UPDATES FROM BI */
      if logistics_charge_voucher then do:
         {gprunmo.i &module="LA" &program="apvolacu.p"
                    &param  = """(input 0,
                                  input vo_ref)"""}
      end.
      else do:
         {gprun.i ""apvomtk1.p""}
      end.

      /* Undo GL post from bi */
      {&APVOMTK-P-TAG2}
      for each vodbi_wkfl
         fields (vodbi_acct vodbi_amt vodbi_base_amt vodbi_cc vodbi_desc
                 vodbi_entity vodbi_exp_acct vodbi_exp_cc vodbi_exp_sub vodbi_ln
                 vodbi_pjs_line vodbi_project vodbi_ref vodbi_sub vodbi_tax
                 vodbi_taxc vodbi_tax_at vodbi_tax_in vodbi_tax_usage vodbi_type
                 vodbi_user1 vodbi_user2)
       no-lock:
         assign
            base_amt     = - vodbi_base_amt
            curr_amt     = - vodbi_amt
            base_det_amt = base_amt
            vod_recno    = recid(vodbi_wkfl)
            undo_all     = yes.

         {gprun.i ""apapgl3.p""}
         if undo_all
         then
            undo gl_impact, leave.

      end. /* FOR EACH vodbi_wkfl */

      /* REDO GL POST FROM DB */
      {&APVOMTK-P-TAG3}
      for each vod_det
         fields (vod_acct vod_amt vod_base_amt vod_cc vod_desc vod_dy_num
                 vod_entity vod_exp_acct vod_exp_cc vod_exp_sub vod_ln
                 vod_pjs_line vod_project vod_ref vod_sub vod_tax vod_taxc
                 vod_tax_at vod_tax_in vod_tax_usage vod_type vod_user1
                 vod_user2)
         where vod_ref = vo_ref
      no-lock:
         {&APVOMTK-P-TAG4}
         assign
            base_amt     = vod_base_amt
            curr_amt     = vod_amt
            base_det_amt = base_amt
            vod_recno    = recid(vod_det)
            undo_all     = yes.

         {gprun.i ""apapgl.p""}
         if undo_all
         then
            undo gl_impact, leave.

         /* ASSIGN NRM-SEQ-NUM NOW THAT WE'VE DONE THE NR_DISPENSE */
         vod_dy_num = nrm-seq-num.

      end. /* FOR EACH vod_det */

      /* DO COST ADJUSTMENTS */
      if logistics_charge_voucher then do:
         {gprunmo.i &module="LA" &program="apvolacu.p"
                    &param  = """(input 1,
                                  input vo_ref)"""}
      end.
      else do:
         {gprun.i ""apvomtk3.p""}
      end.

   end. /* IF vo_confirm THEN GL_IMPACT */

   if global_db <> ""
   then do:

      /* BUILD TEMP-TABLE OF INVOICED RECEIVER QUANTITIES */
      for each prhup_wkfl
      exclusive-lock:
         delete prhup_wkfl.
      end. /* FOR EACH prhup_wkfl */
      /* USE THE PENDING VOUCHER TABLE TO DETERMINE */
      /* INVOICED RECEIVER QUANTITIES.              */

      for each vph_hist no-lock where
               vph_ref = vo_ref,
          first pvo_mstr no-lock where
                pvo_lc_charge   = "" and
                pvo_internal_ref_type = {&TYPE_POReceiver} and
                pvo_id = vph_pvo_id,
          first prh_hist no-lock where
                prh_receiver = pvo_internal_ref  and
                prh_line     = pvo_line,
          first si_mstr no-lock where
                si_site = prh_site               and
                si_db  <> global_db:

          /* DETERMINE THE VALUE FOR vouchered_qty */
          {gprun.i ""appvoinv.p""
                   "(input """",
                     input RECEIVER-TYPE,
                     input prh_receiver,
                     input prh_line,
                     input prh_ps_nbr,
                     output vouchered_qty,
                     output last_voucher,
                     output ers_status)"}

          /* SAVE UPDATE IN PRHUP_WKFL */
          {gprun.i ""apvopru2.p""
                   "(input prh_receiver,
                     input prh_line,
                     input prh_site,
                     input vouchered_qty)"}
      end. /* EACH vph_hist, FIRST pvo_mstr, prh_hist, si_mstr */

      /* UPDATE PRH_HIST ON INVENTORY DATABASE */
      {gprun.i ""apvopru1.p""
         "(input vo_ref)"}

   end. /* IF GLOBAL_DB <> "" */

end. /* IF action = 0 ELSE */
