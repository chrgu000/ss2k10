/* socost02.p - SALE ORDER COST OF GOODS SOLD (COGS) SUBROUTINE              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.27 $                                                         */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.0      LAST MODIFIED: 11/12/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 05/08/92   BY: afs *F459*               */
/* REVISION: 7.0      LAST MODIFIED: 06/17/92   BY: tjs *F646*               */
/* REVISION: 7.0      LAST MODIFIED: 08/19/92   BY: tjs *F859*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 06/14/93   BY: afs *GC26*               */
/* REVISION: 7.3      LAST MODIFIED: 07/01/93   BY: cdt *GC90*               */
/* REVISION: 7.3      LAST MODIFIED: 02/09/94   BY: ais *FL95*               */
/* REVISION: 7.3      LAST MODIFIED: 02/28/94   BY: ais *FM47*               */
/*           7.3                     10/29/94   BY: bcm *GN73*               */
/* REVISION: 7.3      LAST MODIFIED: 02/23/95   BY: jxz *F0K2*               */
/* REVISION: 7.3      LAST MODIFIED: 04/03/95   BY: dxk *G0K7*               */
/* REVISION: 7.3      LAST MODIFIED: 05/27/95   BY: rxm *G0NL*               */
/* REVISION: 7.3      LAST MODIFIED: 06/14/95   BY: bcm *F0SR*               */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 01/16/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: vrn *G1S1*               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 06/08/00   BY: *M0ND* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0W8* Mudit Mehta       */
/* Revision: 1.25  BY: W.Palczynski DATE: 05/05/03 ECO: *P0P6* */
/* $Revision: 1.27 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080905.1 - B */
/*
将"ISS-SO" 改为 "rct-sor" ，用于 3.21.1 
*/
/* SS - 20080905.1 - E */
                                                             
{mfdeclre.i}
{cxcustom.i "SOCOST02.P"}

define input parameter qty        like tr_qty_loc  no-undo.
define input parameter entity     like si_entity no-undo.
define input parameter trgl_recid as recid no-undo.
define input parameter tr_recid   as recid no-undo.

define shared variable ord-db-cmtype like cm_type no-undo.

define shared variable sct_recno  as recid.
define shared variable sod_recno  as recid.
define shared variable trgl_recno as recid.
define shared variable eff_date   as date.
define shared variable ref        like glt_det.glt_ref.
define shared variable rndmthd    like rnd_rnd_mthd.

define variable cogsmtl         like sct_cst_tot  no-undo.
define variable cogslbr         like sct_cst_tot  no-undo.
define variable cogsbdn         like sct_cst_tot  no-undo.
define variable cogsovh         like sct_cst_tot  no-undo.
define variable cogssub         like sct_cst_tot  no-undo.
define variable cogstot         like sct_cst_tot  no-undo.
define variable gl_amt          like sct_cst_tot  no-undo.
define variable dr_acct         like trgl_dr_acct no-undo.
define variable dr_sub          like trgl_dr_sub  no-undo.
define variable dr_cc           like trgl_dr_cc   no-undo.
define variable dr_proj         like trgl_dr_proj no-undo.
define variable cr_acct         like trgl_cr_acct no-undo.
define variable cr_sub          like trgl_cr_sub  no-undo.
define variable cr_cc           like trgl_cr_cc   no-undo.
define variable cr_proj         like trgl_cr_proj no-undo.
define variable nbr             like tr_nbr       no-undo.
define variable current_db      like dc_name      no-undo.
define variable err-flag        as integer        no-undo.
define variable sonbr           like so_nbr       no-undo.
define variable cmtype          like cm_type      no-undo.
define variable mc-error-number like msg_nbr      no-undo.

for first sod_det
   fields( sod_domain sod_fsm_type sod_line sod_loc sod_nbr sod_part
          sod_prodline sod_rma_type sod_site sod_type)
   where recid(sod_det) = sod_recno no-lock:
end.

{&SOCOST02-P-TAG1}

for first pt_mstr
   fields( pt_domain pt_part pt_prod_line)
    where pt_mstr.pt_domain = global_domain and  pt_part = sod_part no-lock :
end.

if available pt_mstr and sod_type = "" then do:

   for first icc_ctrl
      fields( icc_domain icc_cogs icc_gl_sum icc_gl_tran icc_mirror)
    where icc_ctrl.icc_domain = global_domain no-lock:
   end.

   for first sct_det
      fields( sct_domain sct_bdn_ll sct_bdn_tl sct_lbr_ll sct_lbr_tl sct_mtl_ll
             sct_ovh_tl sct_sub_ll sct_sub_tl sct_mtl_tl sct_ovh_ll)
      where recid(sct_det) = sct_recno no-lock:
   end.

   for first so_mstr
      fields( so_domain so_channel so_cust so_nbr so_ship)
       where so_mstr.so_domain = global_domain and  so_nbr = sod_nbr no-lock:
   end.

   find first tr_hist
      where recid(tr_hist) = tr_recid
   exclusive-lock no-error.

   find trgl_det
      where recid(trgl_det) = trgl_recid
   exclusive-lock no-error.

   if sod_fsm_type <> "" and sod_rma_type <> "" then

      for first pl_mstr
         fields( pl_domain pl_cbdn_acct pl_cbdn_cc pl_clbr_acct pl_clbr_cc
                pl_cmtl_acct pl_cmtl_cc pl_covh_acct pl_covh_cc
                pl_cbdn_sub pl_clbr_sub pl_cmtl_sub pl_covh_sub
                pl_csub_sub pl_dscr_sub pl_csub_acct pl_csub_cc
                {&SOCOST02-P-TAG12}
                pl_dscr_acct pl_dscr_cc pl_prod_line)
          where pl_mstr.pl_domain = global_domain and  pl_prod_line =
          sod_prodline no-lock:
      end.

   else

      for first pl_mstr
         fields( pl_domain pl_cbdn_acct pl_cbdn_cc pl_clbr_acct pl_clbr_cc
                pl_cmtl_acct pl_cmtl_cc pl_covh_acct pl_covh_cc
                pl_cbdn_sub pl_clbr_sub pl_cmtl_sub pl_covh_sub
                pl_csub_sub pl_dscr_sub pl_csub_acct pl_csub_cc
                {&SOCOST02-P-TAG13}
                pl_dscr_acct pl_dscr_cc pl_prod_line)
          where pl_mstr.pl_domain = global_domain and  pl_prod_line =
          pt_prod_line no-lock:
      end.

   for first gl_ctrl
      fields( gl_domain gl_rnd_mthd)
    where gl_ctrl.gl_domain = global_domain no-lock:
   end.

   {&SOCOST02-P-TAG14}

   /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF AVAILABLE */
   /* ELSE USE BILL-TO INFO */
   if so_cust <> so_ship and
      can-find(cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
      so_ship)
   then

      for first cm_mstr
         fields( cm_domain cm_addr cm_type)
          where cm_mstr.cm_domain = global_domain and  cm_addr = so_ship
          no-lock:
      end.

   else

      for first cm_mstr
         fields( cm_domain cm_addr cm_type)
          where cm_mstr.cm_domain = global_domain and  cm_addr = so_cust
          no-lock :
      end.

   if available cm_mstr then
      cmtype = cm_type.
   else
      cmtype = "".
   if cmtype <= "" then cmtype = ord-db-cmtype.

   /* Complete Sales Account Match */

   for first plsd_det
      fields( plsd_domain plsd_cbdn_acct plsd_cbdn_cc plsd_channel
      plsd_clbr_acct
             plsd_clbr_cc plsd_cmtl_acct plsd_cmtl_cc plsd_cmtype
             plsd_covh_acct plsd_covh_cc plsd_csub_acct plsd_csub_cc
             plsd_cbdn_sub  plsd_clbr_sub plsd_cmtl_sub
             plsd_covh_sub  plsd_csub_sub
             plsd_prodline plsd_site)
       where plsd_det.plsd_domain = global_domain and  plsd_prodline  =
       sod_prodline
        and plsd_site      = sod_site
        and plsd_cmtype    = cmtype   /* cm_type */
        and plsd_channel   = so_channel
   no-lock :
   end.

   /* Match with any Channel */
   if not available plsd_det then

      for first plsd_det
         fields( plsd_domain plsd_cbdn_acct plsd_cbdn_cc plsd_channel
         plsd_clbr_acct
                plsd_clbr_cc plsd_cmtl_acct plsd_cmtl_cc plsd_cmtype
                plsd_covh_acct plsd_covh_cc plsd_csub_acct plsd_csub_cc
                plsd_cbdn_sub  plsd_clbr_sub plsd_cmtl_sub
                plsd_covh_sub  plsd_csub_sub
                plsd_prodline plsd_site)
          where plsd_det.plsd_domain = global_domain and  plsd_prodline  =
          sod_prodline
           and plsd_site      = sod_site
           and plsd_cmtype    = cmtype   /* cm_type */
           and plsd_channel   = ""
      no-lock :
      end.

   /* Match with any Channel, any Customer Type */
   if not available plsd_det then

      for first plsd_det
         fields( plsd_domain plsd_cbdn_acct plsd_cbdn_cc plsd_channel
         plsd_clbr_acct
                plsd_clbr_cc plsd_cmtl_acct plsd_cmtl_cc plsd_cmtype
                plsd_covh_acct plsd_covh_cc plsd_csub_acct plsd_csub_cc
                plsd_cbdn_sub  plsd_clbr_sub plsd_cmtl_sub
                plsd_covh_sub  plsd_csub_sub
                plsd_prodline plsd_site)
          where plsd_det.plsd_domain = global_domain and  plsd_prodline  =
          sod_prodline
           and plsd_site      = sod_site
           and plsd_cmtype    = ""
           and plsd_channel   = ""
      no-lock :
      end.

   qty = - qty.
   nbr = sod_nbr + "." + string(sod_line).

   if icc_cogs then
      assign
         cogsmtl = sct_mtl_tl + sct_mtl_ll
                 + sct_lbr_ll + sct_bdn_ll
                 + sct_ovh_ll + sct_sub_ll
         cogslbr = sct_lbr_tl
         cogsbdn = sct_bdn_tl
         cogsovh = sct_ovh_tl
         cogssub = sct_sub_tl.
   else
      assign
         cogsmtl = sct_mtl_tl + sct_mtl_ll
         cogslbr = sct_lbr_tl + sct_lbr_ll
         cogsbdn = sct_bdn_tl + sct_bdn_ll
         cogsovh = sct_ovh_tl + sct_ovh_ll
         cogssub = sct_sub_tl + sct_sub_ll.

   cogstot = (cogsmtl + cogslbr + cogsbdn + cogsovh + cogssub)
           * qty.

   /* ROUND EXTENDED COST TOTAL */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output cogstot,
        input        gl_rnd_mthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   assign
      cr_acct = trgl_cr_acct
      cr_sub  = trgl_cr_sub
      cr_cc   = trgl_cr_cc
      dr_proj = trgl_dr_proj
      cr_proj = trgl_cr_proj.

   /* MATERIAL COST OF SALES*/

   /* CALCULATE GL_AMT AND ROUND */
   gl_amt = qty * cogsmtl.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
        input        gl_rnd_mthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   cogstot = cogstot - gl_amt.
   if available plsd_det then
      assign
         dr_acct = plsd_cmtl_acct
         dr_sub  = plsd_cmtl_sub
         dr_cc   = plsd_cmtl_cc.
   else
      assign
         dr_acct = pl_cmtl_acct
         dr_sub  = pl_cmtl_sub
         dr_cc   = pl_cmtl_cc.

   /* TO CORRECT THE GLT_DET RECORD BY UPDATING GL_AMT TO REFLECT */
   /* ENTIRE CONFIGURATION COST                                   */
   assign
      tr_gl_amt    = tr_gl_amt + gl_amt
      trgl_gl_amt  = trgl_gl_amt + gl_amt
      gl_amt       = trgl_gl_amt
      trgl_dr_acct = dr_acct
      trgl_dr_sub  = dr_sub
      trgl_dr_cc   = dr_cc.

   if gl_amt <> 0 then do:
      /* ADDED DRSUB and CRSUB Parameters */
      {mficgl02.i
         &gl-amount=gl_amt
         &tran-type=trgl_type
         &order-no=nbr
         &dr-acct=trgl_dr_acct
         &dr-sub=trgl_dr_sub
         &dr-cc=trgl_dr_cc
         &drproj=trgl_dr_proj
         &cr-acct=trgl_cr_acct
         &cr-sub=trgl_cr_sub
         &cr-cc=trgl_cr_cc
         &crproj=trgl_cr_proj
         &entity=entity
         &find="false"
         &same-ref="icc_gl_sum"
      }
   end. /* if gl_amt */

   {&SOCOST02-P-TAG15}

   release trgl_det.
   /*LABOR COST OF SALES*/
   /* CALCULATE GL_AMT AND ROUND */
   gl_amt = qty * cogslbr.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
        input        gl_rnd_mthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   cogstot = cogstot - gl_amt.
   if available plsd_det then
      assign
         dr_acct = plsd_clbr_acct
         dr_sub  = plsd_clbr_sub
         dr_cc   = plsd_clbr_cc.
   else
      assign
         dr_acct = pl_clbr_acct
         dr_sub  = pl_clbr_sub
         dr_cc   = pl_clbr_cc.

   tr_gl_amt = tr_gl_amt + gl_amt.

   create trgl_det. trgl_det.trgl_domain = global_domain.
   {&SOCOST02-P-TAG2}
   assign
      trgl_trnbr    = tr_trnbr
      trgl_type     = "RCT-SOR"
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = dr_acct
      trgl_dr_sub   = dr_sub
      trgl_dr_cc    = dr_cc
      trgl_dr_proj  = dr_proj
      trgl_cr_acct  = cr_acct
      trgl_cr_sub   = cr_sub
      trgl_cr_cc    = cr_cc
      trgl_cr_proj  = cr_proj
      trgl_gl_amt   = gl_amt.
   {&SOCOST02-P-TAG3}

   if gl_amt <> 0 then do:
      /* ADDED DRSUB and CRSUB References */
      {mficgl02.i
         &gl-amount=gl_amt
         &tran-type=trgl_type
         &order-no=nbr
         &dr-acct=trgl_dr_acct
         &dr-sub=trgl_dr_sub
         &dr-cc=trgl_dr_cc
         &drproj=trgl_dr_proj
         &cr-acct=trgl_cr_acct
         &cr-sub=trgl_cr_sub
         &cr-cc=trgl_cr_cc
         &crproj=trgl_cr_proj
         &entity=entity
         &find="false"
         &same-ref="icc_gl_sum"
      }
   end. /* if gl_amt */

   {&SOCOST02-P-TAG16}

   /*BURDEN COST OF SALES*/
   /* CALCULATE GL_AMT AND ROUND */
   gl_amt = (qty * cogsbdn).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
        input        gl_rnd_mthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   cogstot = cogstot - gl_amt.
   if available plsd_det then
      assign
         dr_acct = plsd_cbdn_acct
         dr_sub  = plsd_cbdn_sub
         dr_cc   = plsd_cbdn_cc.
   else
      assign
         dr_acct = pl_cbdn_acct
         dr_sub  = pl_cbdn_sub
         dr_cc   = pl_cbdn_cc.

   tr_gl_amt = tr_gl_amt + gl_amt.

   create trgl_det. trgl_det.trgl_domain = global_domain.
   {&SOCOST02-P-TAG4}
   assign
      trgl_trnbr    = tr_trnbr
      trgl_type     = "RCT-SOR"
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = dr_acct
      trgl_dr_sub   = dr_sub
      trgl_dr_cc    = dr_cc
      trgl_dr_proj  = dr_proj
      trgl_cr_acct  = cr_acct
      trgl_cr_sub   = cr_sub
      trgl_cr_cc    = cr_cc
      trgl_cr_proj  = cr_proj
      trgl_gl_amt   = gl_amt.
   {&SOCOST02-P-TAG5}

   if gl_amt <> 0 then do:
      /* ADDED DRSUB and CRSUB References */
      {mficgl02.i
         &gl-amount=gl_amt
         &tran-type=trgl_type
         &order-no=nbr
         &dr-acct=trgl_dr_acct
         &dr-sub=trgl_dr_sub
         &dr-cc=trgl_dr_cc
         &drproj=trgl_dr_proj
         &cr-acct=trgl_cr_acct
         &cr-sub=trgl_cr_sub
         &cr-cc=trgl_cr_cc
         &crproj=trgl_cr_proj
         &entity=entity
         &find="false"
         &same-ref="icc_gl_sum"
      }
   end. /* if gl_amt */

   {&SOCOST02-P-TAG17}

   /* OVERHEAD COST OF SALES*/
   gl_amt = (qty * cogsovh).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
        input        gl_rnd_mthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   cogstot = cogstot - gl_amt.
   if available plsd_det then
      assign
         dr_acct = plsd_covh_acct
         dr_sub  = plsd_covh_sub
         dr_cc   = plsd_covh_cc.
   else
      assign
         dr_acct = pl_covh_acct
         dr_sub  = pl_covh_sub
         dr_cc   = pl_covh_cc.

   tr_gl_amt = tr_gl_amt + gl_amt.

   create trgl_det. trgl_det.trgl_domain = global_domain.
   {&SOCOST02-P-TAG6}
   assign
      trgl_trnbr    = tr_trnbr
      trgl_type     = "RCT-SOR"
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = dr_acct
      trgl_dr_sub   = dr_sub
      trgl_dr_cc    = dr_cc
      trgl_dr_proj  = dr_proj
      trgl_cr_acct  = cr_acct
      trgl_cr_sub   = cr_sub
      trgl_cr_cc    = cr_cc
      trgl_cr_proj  = cr_proj
      trgl_gl_amt   = gl_amt.
   {&SOCOST02-P-TAG7}

   if gl_amt <> 0 then do:
      /* ADDED DRSUB and CRSUB Parameters */
      {mficgl02.i
         &gl-amount=gl_amt
         &tran-type=trgl_type
         &order-no=nbr
         &dr-acct=trgl_dr_acct
         &dr-sub=trgl_dr_sub
         &dr-cc=trgl_dr_cc
         &drproj=trgl_dr_proj
         &cr-acct=trgl_cr_acct
         &cr-sub=trgl_cr_sub
         &cr-cc=trgl_cr_cc
         &crproj=trgl_cr_proj
         &entity=entity
         &find="false"
         &same-ref="icc_gl_sum"
      }
   end. /* if gl_amt */

   {&SOCOST02-P-TAG18}

   /*SUBCONTRACT COST OF SALES*/
   /* CALCULATE GL_AMT AND ROUND */
   gl_amt = (qty * cogssub).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output gl_amt,
        input        gl_rnd_mthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   cogstot = cogstot - gl_amt.
   if available plsd_det then
      assign
         dr_acct = plsd_csub_acct
         dr_sub  = plsd_csub_sub
         dr_cc = plsd_csub_cc.
   else
      assign
         dr_acct = pl_csub_acct
         dr_sub  = pl_csub_sub
         dr_cc = pl_csub_cc.

   tr_gl_amt = tr_gl_amt + gl_amt.

   create trgl_det. trgl_det.trgl_domain = global_domain.
   {&SOCOST02-P-TAG8}
   assign
      trgl_trnbr    = tr_trnbr
      trgl_type     = "RCT-SOR"
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = dr_acct
      trgl_dr_sub   = dr_sub
      trgl_dr_cc    = dr_cc
      trgl_dr_proj  = dr_proj
      trgl_cr_acct  = cr_acct
      trgl_cr_sub   = cr_sub
      trgl_cr_cc    = cr_cc
      trgl_cr_proj  = cr_proj
      trgl_gl_amt   = gl_amt.
   {&SOCOST02-P-TAG9}

   if gl_amt <> 0 then do:
      /* ADDED DRSUB and CRSUB Parameters */
      {mficgl02.i
            &gl-amount=gl_amt
            &tran-type=trgl_type
            &order-no=nbr
            &dr-acct=trgl_dr_acct
            &dr-sub=trgl_dr_sub
            &dr-cc=trgl_dr_cc
            &drproj=trgl_dr_proj
            &cr-acct=trgl_cr_acct
            &cr-sub=trgl_cr_sub
            &cr-cc=trgl_cr_cc
            &crproj=trgl_cr_proj
            &entity=entity
            &find="false"
            &same-ref="icc_gl_sum"
            }
   end. /* if gl_amt */

   {&SOCOST02-P-TAG19}

   /* ADJUSTMENT DUE TO ROUNDING *** ADDED THE FOLLOWING SECTION */
   /* COGSTOT COMPRISED OF ROUNDED AMOUNTS - NO NEED TO ROUND HERE */
   if cogstot <> 0 then do:

      for first pld_det
         fields( pld_domain pld_dscracct pld_dscr_sub pld_dscr_cc pld_loc
                pld_prodline pld_site)
          where pld_det.pld_domain = global_domain and  pld_prodline =
          sod_prodline
           and pld_site     = sod_site
           and pld_loc      = sod_loc
      no-lock:
      end.

      if not available pld_det then do:

         for first pld_det
            fields( pld_domain pld_dscracct pld_dscr_sub pld_dscr_cc
                   pld_loc pld_prodline pld_site)
             where pld_det.pld_domain = global_domain and  pld_prodline =
             sod_prodline
              and pld_site     = sod_site
              and pld_loc      = ""
         no-lock:
         end.

         if not available pld_det then do:

            for first pld_det
               fields( pld_domain pld_dscracct pld_dscr_sub pld_dscr_cc
                      pld_loc pld_prodline pld_site)
                where pld_det.pld_domain = global_domain and  pld_prodline =
                sod_prodline
                 and pld_site     = ""
                 and pld_loc      = ""
            no-lock:
            end.
         end.
      end.
      if available pld_det
      then
         assign
            dr_acct = pld_dscracct
            dr_sub  = pld_dscr_sub
            dr_cc   = pld_dscr_cc.
      else
         assign
            dr_acct = pl_dscr_acct
            dr_sub  = pl_dscr_sub
            dr_cc   = pl_dscr_cc.
      gl_amt = cogstot.

      tr_gl_amt = tr_gl_amt + gl_amt.

      create trgl_det. trgl_det.trgl_domain = global_domain.
      {&SOCOST02-P-TAG10}
      assign
         trgl_trnbr    = tr_trnbr
         trgl_type     = "RCT-SOR"
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct  = dr_acct
         trgl_dr_sub   = dr_sub
         trgl_dr_cc    = dr_cc
         trgl_dr_proj  = dr_proj
         trgl_cr_acct  = cr_acct
         trgl_cr_sub   = cr_sub
         trgl_cr_cc    = cr_cc
         trgl_cr_proj  = cr_proj
         trgl_gl_amt   = gl_amt.
         {&SOCOST02-P-TAG11}

      /* ADDED DRSUB and CRSUB References */
      {mficgl02.i
            &gl-amount=gl_amt
            &tran-type=trgl_type
            &order-no=nbr
            &dr-acct=trgl_dr_acct
            &dr-sub=trgl_dr_sub
            &dr-cc=trgl_dr_cc
            &drproj=trgl_dr_proj
            &cr-acct=trgl_cr_acct
            &cr-sub=trgl_cr_sub
            &cr-cc=trgl_cr_cc
            &crproj=trgl_cr_proj
            &entity=entity
            &find="false"
            &same-ref="icc_gl_sum"
      }
   end. /* if cogstot */
   /*UPDATE RCT-FAS TRGL_DET RECORD*/
   find trgl_det
      where recid(trgl_det) = trgl_recno
   exclusive-lock no-error.
   if available trgl_det then trgl_trnbr = tr_trnbr.
end.

{&SOCOST02-P-TAG20}
