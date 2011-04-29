/* fscarmtp.p - POST CONTRACT LIMITS AND CREDIT WIP FOR PARTS             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.19 $                                              */
/* REVISION: 7.5      LAST MODIFIED: 09/18/93   BY: sas *J04C*            */
/* REVISION: 8.5      LAST MODIFIED: 10/04/95   BY: *J04C* Sue Poland     */
/* REVISION: 8.5      LAST MODIFIED: 03/07/96   BY: *J04C* Markus Barone  */
/* REVISION: 8.5      LAST MODIFIED: 06/28/97   BY: *J1VB* Molly Balan    */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2M4* Niranjan R.    */
/* REVISION: 9.0      LAST MODIFIED: 09/29/98   BY: *J2CZ* Reetu Kapoor   */
/* REVISION: 9.0      LAST MODIFIED: 12/17/98   BY: *J376* Rajesh Talele  */
/* REVISION: 9.0      LAST MODIFIED: 02/08/99   BY: *J39D* Satish Chavan  */
/* REVISION: 9.0      LAST MODIFIED: 02/12/99   BY: *L0D4* Satish Chavan  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N014* Murali Ayyagari*/
/* REVISION: 9.1      LAST MODIFIED: 11/01/99   BY: *J3LS* Sachin Shinde  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder  */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *J3Q7* Rajesh Kini    */
/* Revision: 1.16     BY: Niranjan R.  DATE: 07/12/01 ECO: *P00L*         */
/* Revision: 1.17     BY: Rajesh Kini  DATE: 10/30/01 ECO: *N159*         */
/* Revision: 1.18     BY: Rajesh Kini  DATE: 11/07/01 ECO: *N15V*         */
/* $Revision: 1.19 $   BY: K Paneesh    DATE: 06/05/02 ECO: *N1KG*        */
/*V8:ConvertMode=Maintenance                                              */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*J2CZ** ADDED NO-UNDO, ASSIGN THROUGHOUT **/
/*!
    FSCARMTP.P processes all inventory records for the invoiced reports.
    For each wod_det on the report, it calls FSSALPST.P to post consumed
    dollars against any limits.
    For each (ISS-WO) tr_hist on this report, debit COGS and credit WIP.
*/

{mfdeclre.i}

define input        parameter wolot            like wo_lot     no-undo.
define input        parameter sanbr            as   character  no-undo.
define input        parameter sadline          as   integer    no-undo.
define input        parameter part             as   character  no-undo.
define input        parameter serial           as   character  no-undo.
define input        parameter saprefix         as   character  no-undo.
define input        parameter eff_date         like glt_effdate no-undo.

define  parameter buffer wo_mstr for wo_mstr.
define input    parameter sales-channel    like so_channel no-undo.
define input    parameter customer-type    like cm_type    no-undo.
define input    parameter open_date        as   date       no-undo.

define            variable total-limit         like sod_price  no-undo.
define            variable fissort             as   character  no-undo.
define            variable fsccode             as   character  no-undo.
define            variable fwkcode             as   character  no-undo.
define            variable file-type           as   character  no-undo.
define            variable salprefix           as   character  no-undo.
define            variable nbr                 as   character  no-undo.
define            variable trqty           like tr_qty_chg no-undo.
/* REF IS NEEDED BY MFICGL02.I... */
define            variable ref             like glt_ref  no-undo.
define            variable cmtl-acct       like pl_cmtl_acct no-undo.
define            variable cmtl-sub        like pl_cmtl_sub no-undo.
define            variable cmtl-cc         like pl_cmtl_cc   no-undo.
define            variable clbr-acct       like pl_clbr_acct no-undo.
define            variable clbr-sub        like pl_clbr_sub no-undo.
define            variable clbr-cc         like pl_clbr_cc   no-undo.
define            variable covh-acct       like pl_covh_acct no-undo.
define            variable covh-sub        like pl_covh_sub no-undo.
define            variable covh-cc         like pl_covh_cc   no-undo.
define            variable csub-acct       like pl_csub_acct no-undo.
define            variable csub-sub        like pl_csub_sub no-undo.
define            variable csub-cc         like pl_csub_cc   no-undo.
define            variable cbdn-acct       like pl_cbdn_acct no-undo.
define            variable cbdn-sub        like pl_cbdn_sub no-undo.
define            variable cbdn-cc         like pl_cbdn_cc   no-undo.
define            variable wip-acct        like pl_wip_acct  no-undo.
define            variable wip-sub         like pl_wip_sub  no-undo.
define            variable wip-cc          like pl_wip_cc    no-undo.
define            variable mvrr-acct       like pl_mvrr_acct no-undo.
define            variable mvrr-sub        like pl_mvrr_sub no-undo.
define            variable mvrr-cc         like pl_mvrr_cc   no-undo.
define            variable wip-amount          like tr_gl_amt no-undo.
define            variable trans-amount        like tr_gl_amt no-undo.

define            buffer   itm_pl_mstr         for  pl_mstr.
define            variable mc-error-number     like msg_nbr   no-undo.
define            variable rndmthd             like rnd_rnd_mthd no-undo.
define            variable l_tr_trnbr          like tr_trnbr  no-undo.
define new shared variable l_newrec            as recid       no-undo.

{fsconst.i}

for first sac_ctrl fields(sac_lim_hist) no-lock:
end.

for first itm_det
      fields(itm_itm_line itm_line itm_nbr itm_prefix itm_prod_line
             itm_site
             itm_sa_sv itm_type)
      where itm_nbr      = wo_nbr
      and   itm_prefix   = "CA"
      and   itm_type     = " "
      and   itm_itm_line = 0
      and   itm_line     = wo_itm_line no-lock:
end.

for each wod_det
      where wod_lot = wolot
      exclusive-lock:

   assign total-limit = wod_covered_amt - wod_covered_post.

   if total-limit   <> 0          and
      (wod_fcg_index =  warranty_c  or
      wod_fcg_index =  contract_c  or
      wod_fcg_index =  covered_c)
   then do:

      /* Added input parameter sadline below */
      /* Changed 1st input parm from eff_date to open_date */
      /* Added input parms 12-17 for salh_hist */
      /* Added input param for itm_sa_sv */
      {gprun.i ""fssalpst.p""
         "(input  open_date,
               input  wod_sv_code,
               input  itm_sa_sv,
               input  sanbr,
               input  sadline,
               input  saprefix,
               input  wod_fis_sort,
               input  wod_ca_int_type,
               input  wod_fsc_code,
               input  part,
               input  serial,
               input  total-limit,
               input  wod_part,
               input  wod_lot,
               input  wod_nbr,
               input  ""0"",
               input  wod_itm_line,
               input  wod_op,
               input  sac_lim_hist)"}

   end. /* if total-limit <> 0 */

   assign wod_covered_post  = wod_covered_amt.

end. /*  for each wod_det   */

find si_mstr where si_site = wo_site no-lock no-error.

for first itm_pl_mstr
      fields(pl_cbdn_acct
      pl_cbdn_sub
      pl_cbdn_cc pl_clbr_acct
      pl_clbr_sub
      pl_clbr_cc pl_cmtl_acct
      pl_cmtl_sub
      pl_cmtl_cc pl_covh_acct
      pl_covh_sub
      pl_covh_cc pl_csub_acct
      pl_csub_sub
      pl_csub_cc
      pl_mvrr_acct
      pl_mvrr_sub
      pl_mvrr_cc pl_prod_line pl_wip_acct
      pl_wip_sub
      pl_wip_cc)
      where itm_pl_mstr.pl_prod_line = itm_prod_line no-lock:
end.

/* IF WIP ACCOUNT ON THIS PRODUCT LINE IS BLANK, CHECK GL-CTRL */
if available itm_pl_mstr then do:
   {gprun.i ""glactdft.p"" "(input ""WO_WIP_ACCT"",
                             input itm_pl_mstr.pl_prod_line,
                             input itm_site,
                             input """",
                             input """",
                             input yes,
                             output wip-acct,
                             output wip-sub,
                             output wip-cc)"}
end.

/* EACH INVENTORY ISSUE DONE FOR THIS REPORT DEBITED WIP.  */
/* NOW, CREATE GL TRANSACTIONS TO CREDIT WIP AND DEBIT     */
/* COGS. THE COGS ACCOUNTS COME FROM THE WOD_DET PRODUCT   */
/* LINE (THE CHARGE P/L).  THE WIP ACCOUNT COMES FROM THE  */
/* ITM_DET PRODUCT LINE.                                   */
for each tr_hist
   fields(tr_bdn_std  tr_gl_amt       tr_lbr_std   tr_lot     tr_mtl_std
          tr_nbr      tr_effdate      tr_loc       tr_ref     tr_serial
          tr_ship_id  tr_ship_date    tr_price     tr_site    tr_so_job
          tr_ref_site tr_ship_inv_mov tr_ship_type tr_qty_loc tr_ovh_std
          tr_part     tr_sub_std      tr_type      tr_wod_op  tr_trnbr)
   where tr_nbr = wo_nbr
   no-lock
   use-index tr_nbr_eff
   break by tr_trnbr:

   /* WE ONLY NEED TO CLEAR COGS FOR THE ISSUES */
   /* AND WE SHOULD ONLY PICK UP TR_HISTS FOR   */
   /* THE CURRENT WO_LOT.                       */
   if tr_type = "ISS-WO"
      and tr_ship_type <> "M"
      and tr_lot = wo_lot then .
   else next.

   /* SAVE THE TOTAL DOLLARS ORIGINALLY DEBITED WIP, IN   */
   /* CASE STANDARD COSTS HAVE CHANGED SINCE, AND WE      */
   /* HAVE SOME VARIANCE AFTER HITTING ALL THE COGS ACCTS */
   assign wip-amount = tr_gl_amt.

   for first wod_det
         fields(wod_ca_int_type wod_covered_amt wod_covered_post wod_fcg_index
                wod_site
                wod_fis_sort wod_fsc_code wod_itm_line wod_lot wod_nbr
                wod_op wod_part wod_prod_line wod_qty_req wod_sv_code)
         where wod_lot  = wo_lot
         and   wod_op   = tr_wod_op
         and   wod_part = tr_part no-lock:
   end.

   assign cmtl-acct = ""
      cmtl-sub  = ""
      cmtl-cc   = ""
      clbr-acct = ""
      clbr-sub  = ""
      clbr-cc   = ""
      cbdn-acct = ""
      cbdn-sub  = ""
      cbdn-cc   = ""
      covh-acct = ""
      covh-sub  = ""
      covh-cc   = ""
      csub-acct = ""
      csub-sub  = ""
      csub-cc   = "".

   /* LOAD PLSD_DET ACCOUNTS FOR USE LATER */

   for first plsd_det
         fields(plsd_cbdn_acct
         plsd_cbdn_sub
         plsd_cbdn_cc plsd_channel plsd_clbr_acct
         plsd_clbr_sub
         plsd_clbr_cc plsd_cmtl_acct
         plsd_cmtl_sub
         plsd_cmtl_cc plsd_cmtype
         plsd_covh_acct
         plsd_covh_sub
         plsd_covh_cc plsd_csub_acct
         plsd_csub_sub
         plsd_csub_cc
         plsd_prodline plsd_site)
         where plsd_prodline = wod_prod_line
         and   plsd_site     = wo_site
         and   plsd_cmtype   = customer-type
         and   plsd_channel  = sales-channel
         no-lock:
   end.

   /* MATCH WITH ANY CHANNEL */
   if not available plsd_det then

   for first plsd_det
         fields(plsd_cbdn_acct
         plsd_cbdn_sub
         plsd_cbdn_cc plsd_channel plsd_clbr_acct
         plsd_clbr_sub
         plsd_clbr_cc plsd_cmtl_acct
         plsd_cmtl_sub
         plsd_cmtl_cc plsd_cmtype
         plsd_covh_acct
         plsd_covh_sub
         plsd_covh_cc plsd_csub_acct
         plsd_csub_sub
         plsd_csub_cc
         plsd_prodline plsd_site)
         where plsd_prodline = wod_prod_line
         and   plsd_site     = wo_site
         and   plsd_cmtype   = customer-type
         and   plsd_channel  = ""
         no-lock:
   end.

   /* MATCH WITH ANY CHANNEL, ANY CUSTOMER TYPE */
   if not available plsd_det then

   for first plsd_det
         fields(plsd_cbdn_acct
         plsd_cbdn_sub
         plsd_cbdn_cc plsd_channel plsd_clbr_acct
         plsd_clbr_sub
         plsd_clbr_cc plsd_cmtl_acct
         plsd_cmtl_sub
         plsd_cmtl_cc plsd_cmtype
         plsd_covh_acct
         plsd_covh_sub
         plsd_covh_cc plsd_csub_acct
         plsd_csub_sub
         plsd_csub_cc
         plsd_prodline plsd_site)
         where plsd_prodline =  wod_prod_line
         and   plsd_site     = wo_site
         and   plsd_cmtype   = ""
         and   plsd_channel  = ""
         no-lock:
   end.

   if available plsd_det then
   assign  cmtl-acct = plsd_cmtl_acct
      cmtl-sub  = plsd_cmtl_sub
      cmtl-cc   = plsd_cmtl_cc
      clbr-acct = plsd_clbr_acct
      clbr-sub  = plsd_clbr_sub
      clbr-cc   = plsd_clbr_cc
      cbdn-acct = plsd_cbdn_acct
      cbdn-sub  = plsd_cbdn_sub
      cbdn-cc   = plsd_cbdn_cc
      covh-acct = plsd_covh_acct
      covh-sub  = plsd_covh_sub
      covh-cc   = plsd_covh_cc
      csub-acct = plsd_csub_acct
      csub-sub  = plsd_csub_sub
      csub-cc   = plsd_csub_cc.

   /* IF ANY ACCOUNTS ARE BLANK, CHECK PL_MSTR */
   if cmtl-acct = "" or
      clbr-acct = "" or
      cbdn-acct = "" or
      covh-acct = "" or
      csub-acct = "" then do:

      for first pl_mstr
            fields(pl_cbdn_acct
            pl_cbdn_sub
            pl_cbdn_cc pl_clbr_acct
            pl_clbr_sub
            pl_clbr_cc pl_cmtl_acct
            pl_cmtl_sub
            pl_cmtl_cc pl_covh_acct
            pl_covh_sub
            pl_covh_cc pl_csub_acct
            pl_csub_sub
            pl_csub_cc
            pl_mvrr_acct
            pl_mvrr_sub
            pl_mvrr_cc pl_prod_line pl_wip_acct
            pl_wip_sub
            pl_wip_cc)
            where pl_prod_line  = wod_prod_line no-lock:
      end.

      if available pl_mstr then do:
         if cbdn-acct = "" then
         assign cbdn-acct = pl_mstr.pl_cbdn_acct
            cbdn-sub  = pl_mstr.pl_cbdn_sub
            cbdn-cc   = pl_mstr.pl_cbdn_cc.
         if clbr-acct = "" then
         assign clbr-acct = pl_mstr.pl_clbr_acct
            clbr-sub  = pl_mstr.pl_clbr_sub
            clbr-cc   = pl_mstr.pl_clbr_cc.
         if cmtl-acct = "" then
         assign cmtl-acct = pl_mstr.pl_cmtl_acct
            cmtl-sub  = pl_mstr.pl_cmtl_sub
            cmtl-cc   = pl_mstr.pl_cmtl_cc.
         if covh-acct = "" then
         assign covh-acct = pl_mstr.pl_covh_acct
            covh-sub  = pl_mstr.pl_covh_sub
            covh-cc   = pl_mstr.pl_covh_cc.
         if csub-acct = "" then
         assign csub-acct = pl_mstr.pl_csub_acct
            csub-sub  = pl_mstr.pl_csub_sub
            csub-cc   = pl_mstr.pl_csub_cc.
      end.  /* if available pl_mstr */
   end.    /* if cmtl-acct = "" ... */

   /* THE PART'S COST COMPONENTS ARE INCLUDED IN TR_HIST */

   trans-amount = tr_mtl_std * (- tr_qty_loc).

   for first ca_mstr
         fields(ca_category ca_curr ca_nbr)
         where ca_category = "0"
         and   ca_nbr      = wod_nbr no-lock:
   end. /* FOR FIRST CA_MSTR */

   if available ca_mstr then do:
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input ca_curr,
                           output rndmthd,
                           output mc-error-number)"}
      if mc-error-number <> 0 then
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output trans-amount,
                           input rndmthd,
                           output mc-error-number)"}
      if mc-error-number <> 0 then
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   /* CREATING A TRANSACTION HISTORY RECORD              */
   /* CHANGED 10TH PARAMETER FROM tr_effdate TO eff_date */

   {gprun.i ""fsictran.p""
      "(input global_addr,
        input wip-acct,
        input wip-sub,
        input wip-cc,
        input wo_project,
        input cmtl-acct,
        input cmtl-sub,
        input cmtl-cc,
        input wo_project,
        input eff_date,
        input trans-amount,
        input tr_loc,
        input tr_lot,
        input tr_ref,
        input tr_serial,
        input tr_nbr,
        input wod_part,
        input tr_price,
        input tr_site,
        input tr_ship_id,
        input tr_ship_date,
        input tr_ship_inv_mov,
        input tr_so_job,
        input tr_ref_site,
        output l_tr_trnbr)"
   }

   /* GL TRANSACTION - COGS-MTRL WILL NOW BE CREATED IN FSICTRAN.P */

   assign
      wip-amount   = wip-amount - trans-amount
      /* CREDITING WIP.                   */
      wo_wip_tot   = wo_wip_tot - trans-amount
      trans-amount = tr_bdn_std * (- tr_qty_loc).

   run proc_rnd_amt.

   /* CREATING TRGL_DET RECORD */
   create trgl_det.
   assign
      trgl_trnbr    = l_tr_trnbr
      trgl_type     = tr_type
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = cbdn-acct
      trgl_dr_sub   = cbdn-sub
      trgl_dr_cc    = cbdn-cc
      trgl_dr_proj  = wo_project
      trgl_cr_acct  = wip-acct
      trgl_cr_sub   = wip-sub
      trgl_cr_cc    = wip-cc
      trgl_cr_proj  = wo_project
      trgl_gl_amt   = trans-amount.

   /* GL TRANSACTIONS - COGS-BURDEN */
   /* ADDED DR-SUB AND CR-SUB REFERENCES BELOW */

   run P_MFICGL02
      (input trans-amount,
      input tr_type,
      input tr_nbr,
      input cbdn-acct,
      input cbdn-sub,
      input cbdn-cc,
      input wo_project,
      input wip-acct,
      input wip-sub,
      input wip-cc,
      input wo_project,
      input si_entity).

   assign
      wip-amount   = wip-amount - trans-amount
      /* CREDITING WIP.                   */
      wo_wip_tot   = wo_wip_tot - trans-amount
      trans-amount = tr_lbr_std * (- tr_qty_loc).

   run proc_rnd_amt.

   /* CREATING TRGL_DET RECORD */
   create trgl_det.
   assign
      trgl_trnbr    = l_tr_trnbr
      trgl_type     = tr_type
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = clbr-acct
      trgl_dr_sub   = clbr-sub
      trgl_dr_cc    = clbr-cc
      trgl_dr_proj  = wo_project
      trgl_cr_acct  = wip-acct
      trgl_cr_sub   = wip-sub
      trgl_cr_cc    = wip-cc
      trgl_cr_proj  = wo_project
      trgl_gl_amt   = trans-amount.

   /* GL TRANSACTIONS - COGS-LABOR */
   /* ADDED DR-SUB AND CR-SUB REFERENCES BELOW */

   run P_MFICGL02
      (input trans-amount,
      input tr_type,
      input tr_nbr,
      input clbr-acct,
      input clbr-sub,
      input clbr-cc,
      input wo_project,
      input wip-acct,
      input wip-sub,
      input wip-cc,
      input wo_project,
      input si_entity).

   assign
      wip-amount   = wip-amount - trans-amount
      /* CREDITING WIP.                   */
      wo_wip_tot   = wo_wip_tot - trans-amount
      trans-amount = tr_ovh_std * (- tr_qty_loc).

   run proc_rnd_amt.

   /* CREATING TRGL_DET RECORD */
   create trgl_det.
   assign
      trgl_trnbr    = l_tr_trnbr
      trgl_type     = tr_type
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = covh-acct
      trgl_dr_sub   = covh-sub
      trgl_dr_cc    = covh-cc
      trgl_dr_proj  = wo_project
      trgl_cr_acct  = wip-acct
      trgl_cr_sub   = wip-sub
      trgl_cr_cc    = wip-cc
      trgl_cr_proj  = wo_project
      trgl_gl_amt   = trans-amount.

   /* GL TRANSACTIONS - COGS-OVERHEAD */
   /* ADDED DR-SUB AND CR-SUB BELOW */

   run P_MFICGL02
      (input trans-amount,
      input tr_type,
      input tr_nbr,
      input covh-acct,
      input covh-sub,
      input covh-cc,
      input wo_project,
      input wip-acct,
      input wip-sub,
      input wip-cc,
      input wo_project,
      input si_entity).

   assign
      wip-amount   = wip-amount - trans-amount
      /* CREDITING WIP.                   */
      wo_wip_tot   = wo_wip_tot - trans-amount
      trans-amount = tr_sub_std * (- tr_qty_loc).

   run proc_rnd_amt.

   /* CREATING TRGL_DET RECORD */
   create trgl_det.
   assign
      trgl_trnbr    = l_tr_trnbr
      trgl_type     = tr_type
      trgl_sequence = recid(trgl_det)
      trgl_dr_acct  = csub-acct
      trgl_dr_sub   = csub-sub
      trgl_dr_cc    = csub-cc
      trgl_dr_proj  = wo_project
      trgl_cr_acct  = wip-acct
      trgl_cr_sub   = wip-sub
      trgl_cr_cc    = wip-cc
      trgl_cr_proj  = wo_project
      trgl_gl_amt   = trans-amount.

   /* GL TRANSACTIONS - COGS-SUBCONTRACT */
   /* ADDED DR-SUB AND CR-SUB BELOW */

   run P_MFICGL02
      (input trans-amount,
      input tr_type,
      input tr_nbr,
      input csub-acct,
      input csub-sub,
      input csub-cc,
      input wo_project,
      input wip-acct,
      input wip-sub,
      input wip-cc,
      input wo_project,
      input si_entity).

   assign
      wip-amount    = wip-amount - trans-amount
      /* CREDITING WIP.                   */
      wo_wip_tot    = wo_wip_tot - trans-amount.

   /* NOW, DEAL WITH ANY VARIANCE WE'VE GOT LEFT */
   /* HOWEVER, THERE SHOULDN'T BE ANY...         */
   if wip-amount = 0 then .
   else do:
      assign
         mvrr-acct = " "
         mvrr-sub  = " "
         mvrr-cc   = " ".
      for first pl_mstr
          fields(pl_cbdn_acct pl_cbdn_sub pl_cbdn_cc
                 pl_clbr_acct pl_clbr_sub pl_clbr_cc
                 pl_cmtl_acct pl_cmtl_sub pl_cmtl_cc
                 pl_covh_acct pl_covh_sub pl_covh_cc
                 pl_csub_acct pl_csub_sub pl_csub_cc
                 pl_mvrr_acct pl_mvrr_sub pl_mvrr_cc
                 pl_prod_line
                 pl_wip_acct pl_mvrr_sub pl_wip_cc)
          where pl_prod_line = wod_prod_line no-lock:
          {gprun.i ""glactdft.p"" "(input ""WO_MVRR_ACCT"",
                                    input pl_mstr.pl_prod_line,
                                    input wod_site,
                                    input """",
                                    input """",
                                    input no,
                                    output mvrr-acct,
                                    output mvrr-sub,
                                    output mvrr-cc)"}
      end.

      /* CREATING TRGL_DET RECORD */
      create trgl_det.
      assign
         trgl_trnbr    = l_tr_trnbr
         trgl_type     = tr_type
         trgl_sequence = recid(trgl_det)
         trgl_dr_acct  = mvrr-acct
         trgl_dr_sub   = mvrr-sub
         trgl_dr_cc    = mvrr-cc
         trgl_dr_proj  = wo_project
         trgl_cr_acct  = wip-acct
         trgl_cr_sub   = wip-sub
         trgl_cr_cc    = wip-cc
         trgl_cr_proj  = wo_project
         trgl_gl_amt   = wip-amount.

      run P_MFICGL02
         (input wip-amount,
         input tr_type,
         input tr_nbr,
         input mvrr-acct,
         input mvrr-sub,
         input mvrr-cc,
         input wo_project,
         input wip-acct,
         input wip-sub,
         input wip-cc,
         input wo_project,
         input si_entity).

      /* CREDITING WIP.                   */
      assign wo_wip_tot = wo_wip_tot - wip-amount.

   end.    /* else, wip-amount <> 0, do */

end.  /* for each tr_hist */

/* PROCEDURE TO ROUND TRANSACTION AMOUNT AS PER THE ROUNDING FORMAT */

PROCEDURE proc_rnd_amt:

   for first ca_mstr
         fields(ca_nbr ca_curr ca_category)
         where ca_category = "0"
         and   ca_nbr      = wod_det.wod_nbr
         no-lock:
   end. /* FOR FIRST CA_MSTR */

   if available ca_mstr then do:
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input ca_curr,
                        output rndmthd,
                        output mc-error-number)"}

      if mc-error-number <> 0 then
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output trans-amount,
                        input rndmthd,
                        output mc-error-number)"}

      if mc-error-number <> 0 then
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

END PROCEDURE. /* PROCEDURE proc_rnd_amt */

PROCEDURE P_MFICGL02:
   /***************************************************************/
   /* IN ORDER TO PASS THE RECID OF THE tr_hist CREATED IN        */

   /* TO gpicgl.p, INSTEAD OF MODIFYING mficgl02.i THE SAME LOGIC */
   /* HAS BEEN RE-WRITTEN AS AN INTERNAL PROCEDURE                */
   /***************************************************************/

   define input parameter l_transamount like trans-amount.
   define input parameter l_trtype      like tr_type.
   define input parameter l_trnbr       like tr_nbr.
   define input parameter l_cogsacct    as   character format "x(8)".
   define input parameter l_cogssub     as   character format "x(8)".
   define input parameter l_cogscc      as   character format "x(4)".
   define input parameter l_woproject   like wo_project.
   define input parameter l_wipacct     like wip-acct.
   define input parameter l_wipsub      like wip-acct.
   define input parameter l_wipcc       like wip-cc.
   define input parameter l_woproject1  like wo_project.
   define input parameter l_sientity    like si_entity.

   if l_transamount <> 0
   then do:

      if eff_date = ?
         then
         eff_date = today.

      for first icc_ctrl no-lock:
      end. /* FOR FIRST icc_ctrl */

      if icc_gl_tran
      then do:
         msg_temp = l_trtype.
         {gprun.i ""gpicgl.p""
            "(input l_transamount,
                          input msg_temp,
                          input l_trnbr,
                          input l_cogsacct,
                          input l_cogssub,
                          input l_cogscc,
                          input l_woproject,
                          input l_wipacct,
                          input l_wipsub,
                          input l_wipcc,
                          input l_woproject1,
                          input l_sientity,
                          input eff_date,
                          input icc_gl_sum,
                          input icc_mirror,
                          input-output ref,
                          input recid(trgl_det),
                          input l_newrec)"
            }
      end. /* IF icc_gl_tran THEN DO */

      release icc_ctrl.

   end. /* IF l_transamount <> 0 */

END PROCEDURE.
