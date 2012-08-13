/* GUI CONVERTED from soivpstc.p (converter v1.76) Mon Jan 27 21:56:38 2003 */
/* soivpstc.p - SALES ORDER HEADER INVOICE POST                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.35 $                                                    */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.4      LAST MODIFIED: 01/11/94   BY: dpm *FL30*               */
/* REVISION: 7.4      LAST MODIFIED: 07/06/94   BY: WUG *GK60*               */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*               */
/* REVISION: 8.5      LAST MODIFIED: 08/18/95   BY: afs *J06R*               */
/* REVISION: 7.4      LAST MODIFIED: 07/17/95   BY: jym *G0RP*               */
/* REVISION: 8.5      LAST MODIFIED: 02/10/96   BY: DAH *J0FC*               */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007*               */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit       */
/* REVISION: 8.6      LAST MODIFIED: 09/30/96   BY: *K003* forrest mori      */
/* REVISION: 8.6      LAST MODIFIED: 03/19/97   BY: *K083* Srinivasa(SVS)    */
/* REVISION: 7.4      LAST MODIFIED: 07/25/97   BY: *H0ZZ* Doug Norton       */
/* REVISION: 8.6      LAST MODIFIED: 11/25/97   BY: *K1BM* Bryan Merich      */
/* REVISION: 8.6      LAST MODIFIED: 01/27/98   BY: *J2B3* Mandar K.         */
/* REVISION: 9.0      LAST MODIFIED: 09/30/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 11/25/98   BY: *M00D* Pat Pigatti       */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 10/27/99   BY: *N04P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED: 04/10/00   BY: *J3PR* Rajesh Kini       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0W8* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.31     BY: Steve Nugent        DATE: 07/09/01  ECO: *P007*    */
/* Revision: 1.32     BY: Jeff Wootton        DATE: 09/21/01  ECO: *P01H*    */
/* Revision: 1.33     BY: Katie Hilbert       DATE: 04/15/02  ECO: *P03J*    */
/* Revision: 1.34     BY: Laurene Sheridan    DATE: 11/01/02  ECO: *P09M* */
/* $Revision: 1.35 $   BY: Amit Chaturvedi   DATE: 01/20/03  ECO: *N20Y* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVPSTC.P"}

define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable undo_all like mfc_logic no-undo.

define variable i as integer no-undo.
define variable lg_sod_nbr like sod_nbr.
define variable lg_sod_line like sod_line.
define variable cmtindx like so_cmtindx no-undo.
define variable cfexists like mfc_logical.

define buffer cmtdet for cmt_det.

{gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}
/*GUI*/ if global-beam-me-up then undo, leave.


define shared temp-table work_trnbr
   field work_sod_nbr like sod_nbr
   field work_sod_line like sod_line
   field work_tr_recid  like tr_trnbr
   index work_sod_nbr work_sod_nbr ascending.

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}
/* DETERMINE IF CONTAINER/LINE CHARGES ARE ACTIVE */
{cclc.i}

{&SOIVPSTC-P-TAG1}
do transaction on error undo, leave:

   for first so_mstr
      fields(so_inv_nbr so_nbr so__qadc03)
      where recid(so_mstr) = so_recno
      no-lock :
   end.

   for first sod_det
      where recid(sod_det) = sod_recno
      no-lock :
   end.

   /* Call Logistics to create a Sync Salesorder Business Object Document */

   /* When external invoicing by the logistics system is not enabled */
   /* If the external system is invoicing, there is no need to tell */
   /* It what is being done, since it commanded it.  But if the */
   /* MFG/PRO user started the invoice, then tell the external system */

   if can-find(first lgs_mstr where lgs_app_id = so_app_owner
               and lgs_invc_imp = no)
      and
      can-find(esp_mstr where esp_app_id = so_app_owner
               and esp_doc_typ = "SYNC_SALESORDER"
               and esp_publ_flg)
   then do:

      assign
         lg_sod_nbr = sod_nbr
         lg_sod_line = sod_line
         .
      {gprunmo.i &module="LG"
         &program="lgivstex.p"
         &param="""(input lg_sod_nbr,
                    input lg_sod_line)"""}
   end.

   /*CREATE HISTORY FOR SALES ORDER LINES sod_det */
   if sod_cmtindx <> 0 then do:  /* Copy comments */
      {gpcmtcpy.i &old_index = sod_cmtindx
         &new_index = cmtindx
         &counter   = i}
   end.
   else cmtindx = 0.

   /* IF THE INVOICE IS POSTED THROUGH PRE-SHIPPER/SHIPPER CONFIRM, */
   /* THEN USE THE  TRANSACTION NUMBERS STORED IN THE */
   /* TEMP-TABLE WORK_TRNBR TO BRACKET THE SEARCH ON THE TRANSACTION */
   /* HISTORY AND HENCE IMPROVE THE PERFORMANCE. HOWEVER, IF THE    */
   /* INVOICE IS POSTED THROUGH INVOICE POST THEN THE EXISTING LOGIC */
   /* IS EXECUTED SINCE THE TEMP-TABLE IS NOT CREATED BY INVOICE POST*/

   {&SOIVPSTC-P-TAG2}
   for each work_trnbr no-lock
      where work_sod_nbr = so_nbr
        and work_sod_line = sod_line,
      each tr_hist no-lock
         where recid(tr_hist) = work_tr_recid
           and tr_type    =  "iss-so"
           and tr_rmks    =  so_inv_nbr:
      /* Find a tr_hist that matches the criteria and then leave */
      leave.
   end.
   {&SOIVPSTC-P-TAG3}

   if not available tr_hist then do:

      {&SOIVPSTC-P-TAG4}
      for first tr_hist
         fields(tr_line tr_nbr tr_rmks tr_serial tr_trnbr tr_type)
          where tr_type = "iss-so"
            and tr_nbr = so_nbr
            and tr_line = sod_line
            and tr_rmks = so_inv_nbr
            use-index tr_nbr_eff
            no-lock :
      end.
      {&SOIVPSTC-P-TAG5}

   end. /* IF NOT AVAILABLE tr_hist */

   /* CREATE INVOICE RELATIONSHIP DETAIL HISTORY */
   for each sodr_det no-lock
         where sodr_nbr  = sod_nbr
         and   sodr_line = sod_line:
      run create-invreldet-history.
   end.

   create idh_hist.
   assign
      idh_abnormal    = sod_abnormal
      idh_acct        = sod_acct
      idh_sub         = sod_sub
      idh_act_price   = sod_act_price
      idh_auto_ins    = sod_auto_ins
      idh_bo_chg      = sod_bo_chg
      idh_bonus       = sod_bonus
      idh_calc_isb    = sod_calc_isb
      idh_car_load    = sod_car_load
      idh_ca_nbr      = sod_ca_nbr
      idh_cc          = sod_cc
      idh_cfg_type    = sod_cfg_type
      idh_cmtindx     = cmtindx
      idh_comment[1]  = sod_comment[1]
      idh_comment[2]  = sod_comment[2]
      idh_comment[3]  = sod_comment[3]
      idh_comment[4]  = sod_comment[4]
      idh_comment[5]  = sod_comment[5]
      idh_comm_pct[1] = sod_comm_pct[1]
      idh_comm_pct[2] = sod_comm_pct[2]
      idh_comm_pct[3] = sod_comm_pct[3]
      idh_comm_pct[4] = sod_comm_pct[4]
      idh_conrep      = sod_conrep
      idh_consume     = sod_consume
      idh_covered_amt = sod_covered_amt
      idh_crt_int     = sod_crt_int
      idh_custpart    = sod_custpart
      idh_desc        = sod_desc
      idh_disc_pct    = sod_disc_pct
      idh_div         = sod_div
      idh_pl_priority = sod_pl_priority
      idh_prig1       = sod_prig1
      idh_prig2       = sod_prig2
      idh_dock        = sod_dock
      idh_drp_ref     = sod_drp_ref
      idh_dsc_acct    = sod_dsc_acct
      idh_dsc_sub     = sod_dsc_sub
      idh_dsc_cc      = sod_dsc_cc
      idh_dsc_project = sod_dsc_project
      idh_due_date    = sod_due_date
      idh_end_eff[1]  = sod_end_eff[1]
      idh_end_eff[2]  = sod_end_eff[2]
      idh_end_eff[3]  = sod_end_eff[3]
      idh_end_eff[4]  = sod_end_eff[4]
      idh_enduser     = sod_enduser
      idh_expire      = sod_expire
      idh_fab_days    = sod_fab_days
      idh_fa_nbr      = sod_fa_nbr
      idh_fixed_price = sod_fixed_price
      idh_fix_pr      = sod_fix_pr
      idh_fr_chg      = sod_fr_chg
      idh_fr_class    = sod_fr_class
      idh_fr_list     = sod_fr_list
      idh_fr_rate     = sod_fr_rate
      idh_fr_wt       = sod_fr_wt
      idh_fr_wt_um    = sod_fr_wt_um
      idh_inv_cost    = sod_inv_cost.

   assign
      idh_inv_nbr     = so_inv_nbr
      idh_isb_loc     = sod_isb_loc
      idh_isb_ref     = sod_isb_ref
      idh_line        = sod_line
      idh_list_pr     = sod_list_pr
      idh_ln_ref      = sod_ln_ref
      idh_loc         = sod_loc
      idh_owner       = sod_owner
      idh_site        = sod_site
      idh_tax_max     = sod_tax_max
      idh_lot         = sod_lot
      idh_nbr         = sod_nbr
      idh_out_po      = sod_out_po
      idh_override_lmt = sod_override_lmt
      idh_part        = sod_part
      idh_partial     = sod_partial
      idh_pastdue     = sod_pastdue
      idh_per_date    = sod_per_date
      idh_pickdate    = sod_pickdate
      idh_price       = sod_price
      idh_prodline    = sod_prodline
      idh_project     = sod_project
      idh_promise_date = sod_promise_date
      idh_pr_list     = sod_pr_list
      idh_pst         = sod_pst
      idh_qty_all     = sod_qty_all
      idh_qty_chg     = sod_qty_chg
      idh_qty_inv     = sod_qty_inv
      idh_qty_ord     = sod_qty_ord
      idh_qty_pick    = sod_qty_pick
      idh_qty_qote    = sod_qty_qote
      idh_qty_ship    = sod_qty_ship
      idh_raw_days    = sod_raw_days
      idh_rbkt_days   = sod_rbkt_days
      idh_rbkt_mths   = sod_rbkt_mths
      idh_rbkt_weeks  = sod_rbkt_weeks
      idh_req_date    = sod_req_date
      idh_sad_line    = sod_sad_line
      idh_sa_nbr      = sod_sa_nbr
      idh_sched_chgd  = sod_sched_chgd
      idh_serial      = if available tr_hist then tr_serial else sod_serial
      idh_ship        = sod_ship
      idh_slspsn[1]   = sod_slspsn[1]
      idh_slspsn[2]   = sod_slspsn[2]
      idh_slspsn[3]   = sod_slspsn[3]
      idh_slspsn[4]   = sod_slspsn[4]
      idh_sob_rev     = sod_sob_rev
      idh_sob_std     = sod_sob_std
      idh_start_eff[1] = sod_start_eff[1]
      idh_start_eff[2] = sod_start_eff[2]
      idh_start_eff[3] = sod_start_eff[3]
      idh_start_eff[4] = sod_start_eff[4]
      idh_status      = sod_status
      idh_std_cost    = sod_std_cost
      idh_sv_code     = sod_sv_code
      idh_taxable     = sod_taxable
      idh_taxc        = sod_taxc
      idh_tax_env     = sod_tax_env
      idh_tax_usage   = sod_tax_usage
      idh_translt_hrs = sod_translt_hrs
      idh_type        = sod_type
      idh_um          = sod_um
      idh_um_conv     = sod_um_conv.

   assign
      idh_for         = sod_for
      idh_for_serial  = sod_for_serial
      idh_qty_cons    = sod_qty_cons
      idh_qty_exch    = sod_qty_exch
      idh_qty_item    = sod_qty_item
      idh_qty_pend    = sod_qty_pend
      idh_qty_per     = sod_qty_per
      idh_qty_ret     = sod_qty_ret
      idh_ref         = sod_ref
      idh_rma_type    = sod_rma_type
      idh_fsm_type    = sod_fsm_type
      idh_to_loc      = sod_to_loc
      idh_to_ref      = sod_to_ref
      idh_to_site     = sod_to_site
      idh_upd_isb     = sod_upd_isb
      idh_user1       = sod_user1
      idh_user2       = sod_user2
      idh_warr_start  = sod_warr_start
      idh__qad01      = sod__qad01
      idh__qad02      = sod__qad02
      idh_tax_in      = sod_tax_in
      idh_fst_list    = sod_fst_list
      idh_contr_id    = sod_contr_id
      idh_curr_rlse_id[1] = sod_curr_rlse_id[1]
      idh_curr_rlse_id[2] = sod_curr_rlse_id[2]
      idh_curr_rlse_id[3] = sod_curr_rlse_id[3]
      idh_ord_mult    = sod_ord_mult
      idh_cum_date[1] = sod_cum_date[1]
      idh_cum_date[2] = sod_cum_date[2]
      idh_cum_date[3] = sod_cum_date[3]
      idh_cum_date[4] = sod_cum_date[4]
      idh_cum_qty[1]  = sod_cum_qty[1]
      idh_cum_qty[2]  = sod_cum_qty[2]
      idh_cum_qty[3]  = sod_cum_qty[3]
      idh_cum_qty[4]  = sod_cum_qty[4]
      idh_pkg_code    = sod_pkg_code
      idh_rlse_nbr    = sod_rlse_nbr
      idh_sch_data    = sod_sch_data
      idh_sch_mrp     = sod_sch_mrp
      idh_sched       = sod_sched
      idh_trans_lt    = sod_translt_day
      idh_retro_price = sod_price
      idh_btb_type    = sod_btb_type
      idh_btb_po      = sod_btb_po
      idh_btb_pod_line = sod_btb_pod_line
      idh_btb_vend    = sod_btb_vend
      idh_exp_del     = sod_exp_del
      idh__chr01      = sod__chr01
      idh__chr02      = sod__chr02
      idh__chr03      = sod__chr03
      idh__chr04      = sod__chr04
      idh__chr05      = sod__chr05
      idh__chr06      = sod__chr06
      idh__chr07      = sod__chr07
      idh__chr08      = sod__chr08
      idh__chr09      = sod__chr09
      idh__chr10      = sod__chr10
      idh__dec01      = sod__dec01
      idh__dec02      = sod__dec02
      idh__dte01      = sod__dte01
      idh__dte02      = sod__dte02
      idh__log01      = sod__log01
      idh_pricing_dt  = sod_pricing_dt
      idh_custref     = sod_custref
      idh_modelyr     = sod_modelyr

      /* SET INVOICE LINE AMOUNT BY AUTHORIZATION */
      idh__qadc06     = so__qadc03.

   if cfexists then
   assign
      idh__qadc01 = sod__qadc01
      idh__qadc02 = sod__qadc02
      idh__qadc03 = sod__qadc03.

   /* IF CONTAINER AND LINE CHARGES ARE ENABLED. CREATE idhlc_hist */
   /* FOR THE CHARGES.                                           */

   if using_container_charges or
      using_line_charges then do:
      /*CREATE IDHLC_HIST RECORDS FOR CONTAINERS AND LINE CHARGES */
      {gprunmo.i
         &program = ""soivpst4.p""
         &module = "ACL"
         &param = """(input so_nbr,
                      input sod_line,
                      input so_inv_nbr,
                      input so_tax_env,
                      input so_tax_usage,
                      input sod_um,
                      input sod_part)"""}

   end. /* IF using_container_charges or  */

   /* Copy price detail records to history */
   for each pih_hist where pih_doc_type = 1
         and pih_nbr      = sod_nbr
         and pih_line     = sod_line
         no-lock:

      create iph_hist.

      assign
         iph_accr_acct  = pih_accr_acct
         iph_accr_sub   = pih_accr_sub
         iph_accr_cc    = pih_accr_cc
         iph_accr_proj  = pih_accr_proj
         iph_accr_sub   = pih_accr_sub
         iph_amt        = pih_amt
         iph_amt_type   = pih_amt_type
         iph_bonus_line = pih_bonus_line
         iph_break_cat  = pih_break_cat
         iph_comb_type  = pih_comb_type
         iph_confg_disc = pih_confg_disc
         iph_cr_terms   = pih_cr_terms
         iph_disc_acct  = pih_disc_acct
         iph_disc_sub   = pih_disc_sub
         iph_disc_amt   = pih_disc_amt
         iph_disc_cc    = pih_disc_cc
         iph_disc_proj  = pih_disc_proj
         iph_disc_seq   = pih_disc_seq
         iph_disc_sub   = pih_disc_sub
         iph_feature    = pih_feature
         iph_fr_list    = pih_fr_list
         iph_fr_terms   = pih_fr_terms
         iph_inv_nbr    = so_inv_nbr
         iph_line       = pih_line
         iph_list       = pih_list
         iph_list_id    = pih_list_id
         iph_min_net    = pih_min_net
         iph_mod_date   = pih_mod_date
         iph_nbr        = pih_nbr
         iph_option     = pih_option
         iph_parent     = pih_parent
         iph_pid_qty    = pih_pid_qty
         iph_pig_code   = pih_pig_code
         iph_print      = pih_print
         iph_promo1     = pih_promo1
         iph_promo2     = pih_promo2
         iph_promo3     = pih_promo3
         iph_promo4     = pih_promo4
         iph_qty        = pih_qty
         iph_qty_type   = pih_qty_type
         iph_source     = pih_source
         iph_time       = pih_time
         iph_um         = pih_um
         iph_user1      = pih_user1
         iph_user2      = pih_user2
         iph_userid     = pih_userid
         iph__chr01     = pih__chr01
         iph__chr02     = pih__chr02
         iph__chr03     = pih__chr03
         iph__chr04     = pih__chr04
         iph__chr05     = pih__chr05
         iph__chr06     = pih__chr06
         iph__chr07     = pih__chr07
         iph__chr08     = pih__chr08
         iph__chr09     = pih__chr09
         iph__chr10     = pih__chr10
         iph__dec01     = pih__dec01
         iph__dec02     = pih__dec02
         iph__dte01     = pih__dte01
         iph__dte02     = pih__dte02
         iph__log01     = pih__log01
         iph__qadc01    = pih__qadc01
         iph__qadd01    = pih__qadd01
         .

   end.

   /*CREATE HISTORY FOR SALES ORDER BILL sob_det */
   for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line:
/*GUI*/ if global-beam-me-up then undo, leave.

      if sob_cmtindx <> 0 then do: /* Copy comments */
         {gpcmtcpy.i &old_index = sob_cmtindx
            &new_index = cmtindx
            &counter   = i}
      end.
      else cmtindx = 0.
      create ibh_hist.
      assign
         ibh_bo_chg   = sob_bo_chg
         ibh_cmtindx  = cmtindx

         ibh_feature = string(substring(sob_feature,1,12),"x(12)")
                     + " "
                     + string(so_nbr,"x(8)")
                     + string(substring(sob_feature,14,18),"x(18)")
                     + string(substring(sob_feature,32,12),"x(12)")
                     + substring(sob_parent,1,4)
         ibh_parent   = sob_parent
         ibh_cfg_type = sob_cfg_type
         ibh_inv_nbr  = so_inv_nbr
         ibh_iss_date = sob_iss_date
         ibh_line     = sob_line
         ibh_loc      = sob_loc
         ibh_site     = sob_site
         ibh_nbr      = sob_nbr
         ibh_part     = sob_part
         ibh_price    = sob_price
         ibh_qty_all  = sob_qty_all
         ibh_qty_chg  = sob_qty_chg
         ibh_qty_iss  = sob_qty_iss
         ibh_qty_pick = sob_qty_pick
         ibh_qty_req  = sob_qty_req
         ibh_serial   = sob_serial
         ibh_tot_std  = sob_tot_std
         ibh_user1    = sob_user1
         ibh_user2    = sob_user2.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each */

   return.
end. /* do transaction */

undo_all = yes.

PROCEDURE create-invreldet-history:
   /* -----------------------------------------------------------
   Purpose:     Creates the invoice history detail relationship
   records for each associated sodr_det record.
   Parameters:  <None>
   Notes:
   -------------------------------------------------------------*/

   create idhr_hist.
   assign
      idhr_div     = sodr_det.sodr_div
      idhr_group   = sodr_det.sodr_group
      idhr_inv_nbr = so_mstr.so_inv_nbr
      idhr_line    = sodr_det.sodr_line
      idhr_nbr     = sodr_det.sodr_nbr
      idhr_pricing = sodr_det.sodr_pricing
      idhr_seq     = sodr_det.sodr_seq
      idhr_type    = sodr_det.sodr_type
      idhr_user1   = sodr_det.sodr_user1
      idhr_user2   = sodr_det.sodr_user2
      idhr__qadc01 = sodr_det.sodr__qadc01
      idhr__qadc02 = sodr_det.sodr__qadc02
      idhr__qadc03 = sodr_det.sodr__qadc03
      idhr__qadd01 = sodr_det.sodr__qadd01
      idhr__qadd02 = sodr_det.sodr__qadd02
      idhr__qadi01 = sodr_det.sodr__qadi01
      idhr__qadi02 = sodr_det.sodr__qadi02
      idhr__qadl01 = sodr_det.sodr__qadl01
      idhr__qadl02 = sodr_det.sodr__qadl02
      idhr__qadt01 = sodr_det.sodr__qadt01
      idhr__qadt02 = sodr_det.sodr__qadt02.

END PROCEDURE.
