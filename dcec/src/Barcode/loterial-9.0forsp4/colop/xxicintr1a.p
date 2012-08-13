/*icintr1a.p - GENERATE ADDITIONAL GL TRANSACTIONS FOR BACK EXPLODE RECEIPTS*/
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.17 $                                               */
/* REVISION: 6.0      LAST MODIFIED: 06/22/90   BY: emb *D033*               */
/* REVISION: 6.0      LAST MODIFIED: 10/12/90   BY: emb *D098*               */
/* REVISION: 6.0      LAST MODIFIED: 03/13/91   BY: WUG *D472*               */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F748*               */
/* REVISION: 7.0      LAST MODIFIED: 07/31/92   BY: pma *F821*               */
/*           7.3                     10/29/94   BY: bcm *GN73*               */
/*           7.3                     01/16/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 07/31/95   BY: taf *J053*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Bill Reckard      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CF* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* $Revision: 1.17 $   BY: Niranjan R.  DATE: 07/12/01 ECO: *P00L*   */
/* Revision: 1.17     BY: Niranjan R.  DATE: 07/12/01 ECO: *P00L*   */
/* Revision: 1.17.3.1 BY: Veena Lad  DATE: 03/26/04 ECO: *P1VV*   */
/* $Revision: 1.17.3.2 $ BY: Inna Fox     DATE: 05/19/04 ECO: *P22P*   */
/*V8:ConvertMode=Maintenance                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdeclre.i}
/* ********** Begin Translatable Strings Definitions ********* */
&SCOPED-DEFINE icintr1a_p_1 "Effective"
/* MaxLen: Comment: */
/* ********** End Translatable Strings Definitions ********* */
define input parameter ipCreateLabor as logical no-undo.

define shared variable pt_recid as recid.
define shared variable eff_date like glt_effdate label {&icintr1a_p_1}.
define shared variable nbr like tr_nbr.
define shared variable cr_acct like trgl_cr_acct.
define shared variable cr_sub like trgl_cr_sub.
define shared variable cr_cc like trgl_cr_cc.
define shared variable qty_iss_rcv like tr_qty_loc.
define shared variable accum_wip like trgl_gl_amt.
define shared variable cr_proj like trgl_cr_proj.
define shared variable lotserial_qty like sr_qty no-undo.
define variable gl_amt like trgl_gl_amt.
define variable ref like glt_ref.
define variable assy_wip_proj like trgl_cr_proj.
define variable assy_wip_acct like pl_wip_acct.
define variable assy_wip_sub like pl_wip_sub.
define variable assy_wip_cc like pl_wip_cc.
define shared variable wip_entity like si_entity.
define shared variable sct_recid as recid.
define shared variable tr_recno as recid.
define variable mc-error-number like msg_nbr no-undo.
         define variable dftOVHAcct       like pl_ovh_acct no-undo.
         define variable dftOVHSubAcct    like pl_ovh_sub  no-undo.
         define variable dftOVHCostCenter like pl_ovh_cc   no-undo.
         define variable dftWVARAcct       like pl_flr_acct no-undo.
         define variable dftWVARSubAcct    like pl_flr_sub  no-undo.
         define variable dftWVARCostCenter like pl_flr_cc   no-undo.
         define variable dftCOPAcct       like pl_cop_acct no-undo.
         define variable dftCOPSubAcct    like pl_cop_sub  no-undo.
         define variable dftCOPCostCenter like pl_cop_cc   no-undo.
for first gl_ctrl
      fields(gl_bdn_acct gl_bdn_cc gl_bdn_sub gl_lbr_acct gl_lbr_cc
      gl_lbr_sub gl_rnd_mthd)
      no-lock:
end. /* FOR FIRST GL_CTRL */
for first pt_mstr
      fields(pt_prod_line)
      where recid(pt_mstr) = pt_recid no-lock:
end. /* FOR FIRST PT_MSTR */
for first pl_mstr
      fields(pl_cop_acct pl_cop_cc pl_cop_sub pl_ovh_acct pl_ovh_cc
      pl_ovh_sub pl_prod_line pl_wvar_acct pl_wvar_cc pl_wvar_sub)
      where pl_prod_line = pt_prod_line no-lock:
end. /* FOR FIRST PL_MSTR */
for first sct_det
      fields(sct_bdn_tl sct_lbr_tl sct_ovh_tl sct_sub_tl)
      where recid(sct_det) = sct_recid no-lock:
end. /* FOR FIRST SCT_DET */
for first tr_hist
         fields(tr_trnbr tr_site)
      where recid(tr_hist) = tr_recno no-lock:
end. /* FOR FIRST TR_HIST */
assign
   assy_wip_acct = cr_acct
   assy_wip_sub  = cr_sub
   assy_wip_cc   = cr_cc
   assy_wip_proj = cr_proj.
if ipCreateLabor and sct_lbr_tl <> 0 then do:
   gl_amt = sct_lbr_tl * qty_iss_rcv.
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
                 input gl_rnd_mthd,
                 output mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   accum_wip = accum_wip + gl_amt.
   if available tr_hist then do:
      create trgl_det.
      assign trgl_trnbr = tr_trnbr
         trgl_type = "RCT-LBR"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct = assy_wip_acct
         trgl_dr_sub  = assy_wip_sub
         trgl_dr_cc   = assy_wip_cc
         trgl_dr_proj = assy_wip_proj
         trgl_cr_acct = gl_lbr_acct
         trgl_cr_sub  = gl_lbr_sub
         trgl_cr_cc   = gl_lbr_cc
         trgl_cr_proj = assy_wip_proj
         trgl_gl_amt  = gl_amt.
   end.
   {mficgl02.i
      &gl-amount=gl_amt      &tran-type=""RCT-WO""  &order-no=nbr
      &dr-acct=assy_wip_acct &dr-cc=assy_wip_cc     &drproj=assy_wip_proj
      &dr-sub=assy_wip_sub   &cr-sub=gl_lbr_sub
      &cr-acct=gl_lbr_acct   &cr-cc=gl_lbr_cc       &crproj=assy_wip_proj
      &entity=wip_entity     &same-ref="icc_gl_sum"
      }
end.
if ipCreateLabor and sct_bdn_tl <> 0 then do:
   gl_amt = sct_bdn_tl * qty_iss_rcv.
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
                 input gl_rnd_mthd,
                 output mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   accum_wip = accum_wip + gl_amt.
   if available tr_hist then do:
      create trgl_det.
      assign trgl_trnbr = tr_trnbr
         trgl_type = "RCT-BDN"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct = assy_wip_acct
         trgl_dr_sub  = assy_wip_sub
         trgl_dr_cc   = assy_wip_cc
         trgl_dr_proj = assy_wip_proj
         trgl_cr_acct = gl_bdn_acct
         trgl_cr_sub  = gl_bdn_sub
         trgl_cr_cc   = gl_bdn_cc
         trgl_cr_proj = assy_wip_proj
         trgl_gl_amt  = gl_amt.
   end.
   {mficgl02.i
      &gl-amount=gl_amt      &tran-type=""RCT-WO""  &order-no=nbr
      &dr-acct=assy_wip_acct &dr-cc=assy_wip_cc     &drproj=assy_wip_proj
      &dr-sub=assy_wip_sub   &cr-sub=gl_bdn_sub
      &cr-acct=gl_bdn_acct   &cr-cc=gl_bdn_cc       &crproj=assy_wip_proj
      &entity=wip_entity     &same-ref="icc_gl_sum"
      }
end.
if sct_ovh_tl <> 0 then do:
   gl_amt = sct_ovh_tl * qty_iss_rcv.
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
                 input gl_rnd_mthd,
                 output mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   accum_wip = accum_wip + gl_amt.
   if available tr_hist then do:
         /* Determine if default GL account exists */
         /* see if address is a vendor.. if so, use it */
      for first vd_mstr
         fields (vd_addr vd_type)
         where vd_addr = tr_addr
         no-lock:
      end.
      {gprun.i ""glactdft.p"" "(input ""PO_OVH_ACCT"",
                                input pt_prod_line,
                                input tr_site,
                                input if available vd_mstr then
                                      vd_type else """",
                                input """",
                                input no,
                                output dftOVHAcct,
                                output dftOVHSubAcct,
                                output dftOVHCostCenter)"}
      create trgl_det.
      assign trgl_trnbr = tr_trnbr
         trgl_type = "RCT-OVH"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct = assy_wip_acct
         trgl_dr_sub  = assy_wip_sub
         trgl_dr_cc   = assy_wip_cc
         trgl_dr_proj = assy_wip_proj
         trgl_cr_acct = dftOVHAcct
         trgl_cr_sub  = dftOVHSubAcct
         trgl_cr_cc   = dftOVHCostCenter
         trgl_cr_proj = assy_wip_proj
         trgl_gl_amt  = gl_amt.
   end.
          /* Replaced pl_ovh_acct, pl_ovh_sub AND pl_ovh_cc with */
          /* dftOVHAcct, dftOVHSubAcct and dftOVHCostCenter      */
   {mficgl02.i
      &gl-amount=gl_amt      &tran-type=""RCT-WO""  &order-no=nbr
      &dr-acct=assy_wip_acct &dr-cc=assy_wip_cc     &drproj=assy_wip_proj
      &dr-sub=assy_wip_sub   &cr-sub=dftOVHSubAcct
      &cr-acct=dftOVHAcct    &cr-cc=dftOVHCostCenter &crproj=assy_wip_proj
      &entity=wip_entity     &same-ref="icc_gl_sum"
      }
end.
if ipCreateLabor and sct_sub_tl <> 0 then do:
   gl_amt = sct_sub_tl * qty_iss_rcv.
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
                 input gl_rnd_mthd,
                 output mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   accum_wip = accum_wip + gl_amt.
   if available tr_hist then do:
      /* Determine if default gl account exists */
      {gprun.i ""glactdft.p"" "(input ""WO_COP_ACCT"",
                                input pt_prod_line,
                                input tr_site,
                                input """",
                                input """",
                                input no,
                                output dftCOPAcct,
                                output dftCOPSubAcct,
                                output dftCOPCostCenter)"}
      create trgl_det.
      assign trgl_trnbr = tr_trnbr
         trgl_type = "RCT-SUB"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct = assy_wip_acct
         trgl_dr_sub  = assy_wip_sub
         trgl_dr_cc   = assy_wip_cc
         trgl_dr_proj = assy_wip_proj
         trgl_cr_acct = dftCOPAcct
         trgl_cr_sub  = dftCOPSubAcct
         trgl_cr_cc   = dftCOPCostCenter
         trgl_cr_proj = assy_wip_proj
         trgl_gl_amt  = gl_amt.
   end.
         /* Replaced pl_cop_acct, pl_cop_sub AND pl_cop_cc with */
         /* dftCOPAcct, dftCOPSubAcct and dftCOPCostCenter      */
   {mficgl02.i
      &gl-amount=gl_amt      &tran-type=""RCT-WO""  &order-no=nbr
      &dr-acct=assy_wip_acct &dr-cc=assy_wip_cc     &drproj=assy_wip_proj
      &dr-sub=assy_wip_sub   &cr-sub=dftCOPSubAcct
      &cr-acct=dftCOPAcct    &cr-cc=dftCOPCostCenter &crproj=assy_wip_proj
      &entity=wip_entity     &same-ref="icc_gl_sum"
      }
end.
if accum_wip <> 0 then do:
   gl_amt = - accum_wip.
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
                 input gl_rnd_mthd,
                 output mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   if available tr_hist then do:
      /* Determine if default gl account exists */
      {gprun.i ""glactdft.p"" "(input ""WO_WVAR_ACCT"",
                                input pt_prod_line,
                                input tr_site,
                                input """",
                                input """",
                                input no,
                                output dftWVARAcct,
                                output dftWVARSubAcct,
                                output dftWVARCostCenter)"}
      create trgl_det.
      assign trgl_trnbr = tr_trnbr
         trgl_type = "RCT-WOVAR"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct = assy_wip_acct
         trgl_dr_sub  = assy_wip_sub
         trgl_dr_cc   = assy_wip_cc
         trgl_dr_proj = assy_wip_proj
         trgl_cr_acct = dftWVARAcct
         trgl_cr_sub  = dftWVARSubAcct
         trgl_cr_cc   = dftWVARCostCenter
         trgl_cr_proj = assy_wip_proj
         trgl_gl_amt  = gl_amt.
   end.
   if lotserial_qty = 0
   then
      assign
         dftwvaracct       = pl_wvar_acct
         dftwvarsubacct    = pl_wvar_sub
         dftwvarcostcenter = pl_wvar_cc.

         /* REPLACED pl_wvar_acct, pl_wvar_sub AND pl_wvar_cc WITH */
         /* dftWVARAcct, dftWVARSubAcct and dftWVARCostCenter      */
   {mficgl02.i
      &gl-amount=gl_amt      &tran-type=""WIP-ADJ"" &order-no=nbr
      &dr-acct=assy_wip_acct &dr-cc=assy_wip_cc     &drproj=assy_wip_proj
      &dr-sub=assy_wip_sub   &cr-sub=dftWVARSubAcct
      &cr-acct=dftWVARAcct   &cr-cc=dftWVARCostCenter &crproj=assy_wip_proj
      &entity=wip_entity     &same-ref="icc_gl_sum"
      }
end.
