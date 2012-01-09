/* sosoisu5.p - SALES ORDER SHIPMENT UPDATE INVENTORY                         */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.68.1.3 $                                                               */
/*                                                                            */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: *F0PN* Doug Norton        */
/* REVISION: 8.5      LAST MODIFIED: 11/16/97   BY: *K18W* Taek-Soo Chang     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone      */
/* REVISION: 8.6E     LAST MODIFIED: 07/03/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *J2SF* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *J2WG* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 10/30/98   BY: *M00D* Chris DeVitto      */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *K1YG* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/29/99   BY: *J3BM* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 06/22/99   BY: *J3BX* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson    */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02S* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 11/02/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/28/00   BY: *K25V* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0WB* Mudit Mehta        */
/* Revision: 1.29        BY: Katie Hilbert       DATE: 04/01/01   ECO: *P002* */
/* Revision: 1.36        BY: Ashwini Ghaisas     DATE: 08/06/01   ECO: *M1GW* */
/* Revision: 1.38        BY: Ashwini Ghaisas     DATE: 12/15/01   ECO: *M1LD* */
/* Revision: 1.39        BY: Nikita Joshi        DATE: 01/18/02   ECO: *M1K6* */
/* Revision: 1.42        BY: Patrick Rowan       DATE: 03/14/02   ECO: *P00G* */
/* Revision: 1.43        BY: Kirti Desai         DATE: 04/18/02   ECO: *M1XM* */
/* Revision: 1.44        BY: Samir Bavkar        DATE: 08/15/02   ECO: *P09K* */
/* Revision: 1.45        BY: Samir Bavkar        DATE: 08/18/02   ECO: *P0FS* */
/* Revision: 1.46        BY: Manjusha Inglay     DATE: 08/27/02   ECO: *N1S3* */
/* Revision: 1.48        BY: Robin McCarthy      DATE: 11/15/02   ECO: *P0HD* */
/* Revision: 1.49        BY: Manjusha Inglay     DATE: 12/27/02   ECO: *M21P* */
/* Revision: 1.50        BY: Amit Chaturvedi     DATE: 01/20/03   ECO: *N20Y* */
/* Revision: 1.52        BY: Deepali Kotavadekar DATE: 03/24/03   ECO: *N27F* */
/* Revision: 1.53        BY: Narathip W.         DATE: 05/08/03   ECO: *P0RL* */
/* Revision: 1.55        BY: Paul Donnelly (SB)  DATE: 06/28/03   ECO: *Q00L* */
/* Revision: 1.56        BY: Orlando D'Abreo     DATE: 08/07/03   ECO: *P0Z7* */
/* Revision: 1.58        BY: Jean Miller         DATE: 08/25/03   ECO: *P10V* */
/* Revision: 1.59        BY: Shilpa Athalye      DATE: 10/30/03   ECO: *P183* */
/* Revision: 1.60        BY: Salil Pradhan       DATE: 03/02/04   ECO: *P1GM* */
/* Revision: 1.61        BY: Reena Ambavi        DATE: 04/14/04   ECO: *P1XF* */
/* Revision: 1.62        BY: Robin McCarthy      DATE: 04/19/04   ECO: *P15V* */
/* Revision: 1.64        BY: Sukhad Kulkarni     DATE: 05/18/04   ECO: *P21N* */
/* Revision: 1.65        BY: Robin McCarthy      DATE: 06/30/04   ECO: *P287* */
/* Revision: 1.66        BY: Robin McCarthy      DATE: 08/09/04   ECO: *Q0BZ* */
/* Revision: 1.67        BY: Sukhad Kulkarni     DATE: 08/25/04   ECO: *P2GY* */
/* Revision: 1.68        BY: Binoy John          DATE: 01/27/05   ECO: *P35M* */
/* Revision: 1.68.1.1    BY: Sunil Fegade        DATE: 03/22/05   ECO: *P3DL* */
/* $Revision: 1.68.1.3 $          BY: Binoy John          DATE: 05/28/05   ECO: *Q0JM* */
/* $Revision: 1.53.1.12 $ BY: Bill Jiang     DATE: 03/06/06   ECO: *SS - 20060306* */
/* By: Neil Gao Date: *ss 20070225 ECO: *ss 20070225.1 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************
* This routine updates inventory based on the shipment information
* stored in sr_wkfl.
* This parallels sosoisu3.p but is able to handle multiple shipments
* for a single sales order line item and is used by Preshipper/Shipper
* confirm. sosoisu3.p is refered by Sales Order Shipments processing
* that does not create abs_mstr record for the shipped line items.
******************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "SOSOISU5.P"}

define input parameter item_absid like abs_id       no-undo.
define input parameter l_shipper  like abs_id       no-undo.
define input parameter l_shp_date like tr_ship_date no-undo.
define input parameter l_inv_mov  like abs_inv_mov  no-undo.

define new shared variable trgl_recno as recid.
define new shared variable sct_recno as recid.
define new shared variable pt_recid  as recid.
define new shared variable accum_wip like tr_gl_amt.
define new shared variable nbr like tr_nbr.
define new shared variable cr_acct like trgl_cr_acct.
define new shared variable cr_sub like trgl_cr_sub.
define new shared variable cr_cc   like trgl_cr_cc.
define new shared variable cr_proj like trgl_cr_proj.
define new shared variable wip_entity  like si_entity.
define new shared variable sct_recid as recid.
define new shared variable prev_sod_qty_ord like sod_qty_ord no-undo.
define new shared variable prev_qty_ship       like sod_qty_ship.
define new shared variable tr_recno as recid.
define new shared variable l_prev_db like si_db no-undo.

define     shared variable rndmthd like rnd_rnd_mthd.
define     shared variable qty_left like tr_qty_chg.
define     shared variable trqty like tr_qty_chg.
define     shared variable eff_date like glt_effdate label "Effective".
define     shared variable trlot like tr_lot.
define     shared variable ref like glt_ref.
define     shared variable qty_req like in_qty_req.
define     shared variable open_ref like sod_qty_ord.
define     shared variable loc like pt_loc.
define     shared variable prev_qty_ord like sod_qty_ord.
define     shared variable prev_due like sod_due_date.
define     shared variable i as integer.
define     shared variable qty as decimal.
define     shared variable part as character format "x(18)".
define     shared variable prev_consume like sod_consume.
define     shared variable sod_recno as recid.
define     shared variable fas_so_rec as character.
define     shared variable prev_site like sod_site.
define     shared variable prev_type like sod_type.
define     shared variable exch_rate like exr_rate.
define     shared variable exch_rate2 like exr_rate2.
define     shared variable exch_ratetype like exr_ratetype.
define     shared variable exch_exru_seq like exru_seq.
define     shared variable sod_entity like en_entity.
define     shared variable ship_site like sod_site.
define     shared variable so_db like global_db.
define     shared variable ship_db like global_db.
define     shared variable change_db like mfc_logical.
define     shared variable ship_so like so_nbr.
define     shared variable ship_line like sod_line.
define     shared variable so_hist like soc_so_hist.
define     shared variable qty_ord  like sod_qty_ord.
define     shared variable qty_ship like sod_qty_ship.
define     shared variable qty_cum_ship like sod_qty_ship.
define     shared variable qty_inv  like sod_qty_inv.
define     shared variable qty_chg  like sod_qty_chg.
define     shared variable qty_bo   like sod_bo_chg.
define     shared variable std_cost like sod_std_cost.
define     shared variable qty_all  like sod_qty_all.
define     shared variable qty_pick  like sod_qty_pick.
define     shared variable qty_iss_rcv like tr_qty_loc.
define     shared variable copyusr like mfc_logical.
define     shared variable site_to      like sod_site.
define     shared variable loc_to       like sod_loc.
define     shared variable confirm_mode like mfc_logical no-undo.
define     shared variable l_undo       like mfc_logical no-undo.

define            variable prev_abnormal like sod_abnormal.
define            variable effdate like glt_effdate.
define            variable site like sod_site.
define            variable location like sod_loc.
define            variable lotser like sod_serial.
define            variable open_qty like sod_qty_ord.
define            variable gl_amt like glt_amt.
define            variable dr_acct like sod_acct.
define            variable dr_sub like sod_sub.
define            variable dr_cc like sod_cc.
define            variable from_entity like en_entity.
define            variable icx_acct like sod_acct.
define            variable icx_sub like sod_sub.
define            variable icx_cc like sod_cc.
define            variable v_confirm_qty like sod_qty_pick.
define            variable v_pick_qty like sod_qty_pick.
define            variable lotrf like tr_ref.
define            variable transtype as character.
define            variable prev_found like mfc_logical.
define            variable glcost like sct_cst_tot.
define            variable assay like tr_assay.
define            variable grade like tr_grade.
define            variable expire like tr_expire.
define            variable site_change as logical initial no.
define            variable pend_inv as logical initial no.
define            variable sodreldate like mrp_rel_date.
define            variable know_date as date.
define            variable find_date as date.
define            variable interval as integer.
define            variable frwrd as integer.
/* DEFINE GL_TMP_AMT FOR MFIVTR.I */
define            variable gl_tmp_amt as decimal no-undo.
define            variable fseomode      as character initial "SHIP".
define            variable trans-ok       like mfc_logical.
define            variable mc-error-number  like msg_nbr no-undo.
define            variable base-price       like tr_price no-undo.
define            variable lg_sod_nbr like sod_nbr.
define            variable lg_sod_line like sod_line.
define            variable lg_eff_date like eff_date.
define            variable lgInvoice as logical initial yes no-undo.
{&SOSOISU5-P-TAG1}
define            variable err_flag  as   integer           no-undo.
define            variable l_db      like global_db         no-undo.
define            variable use-log-acctg as logical no-undo.
define            variable trans_conv like sod_um_conv no-undo.
define            variable sum_tr_item    like mfc_logical no-undo.
define            variable sum_abs_qty like abs_qty.
define            variable l_curr_base like base_curr no-undo.

define shared temp-table work_trnbr no-undo
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line
   field work_tr_recid  like tr_trnbr
   index work_sod_nbr work_sod_nbr ascending.

define shared temp-table work_ldd no-undo
   field work_ldd_id  like abs_id
   index work_ldd_id  work_ldd_id.

{&SOSOISU5-P-TAG2}

{lafrttmp.i}   /* LOGISTICS ACCOUNTING FREIGHT TEMP-TABLE */

{rcwabsdf.i}   /* work_abs_mstr SHARED TEMP-TABLE */

define            buffer   soddet           for sod_det.
define            buffer   trhist           for tr_hist.
define            buffer   workabs1         for work_abs_mstr.

/* DEFINE NEW INSTANCE OF DAYBOOKS VARIABLES */
{gldydef.i new}

/* DEFINE NEW INSTANCE OF NRM FOR THIS DATABASE */
{gldynrm.i new}

run preliminaryProcessing
   (buffer gl_ctrl,
    buffer so_mstr,
    buffer sod_det,
    buffer pt_mstr,
    buffer pl_mstr,
    buffer clc_ctrl,
    buffer soc_ctrl,
    input-output use-log-acctg,
    input-output sum_tr_item,
    input-output sod_recno).

/*
/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* FIND GL_CTRL FOR MFIVTR.I */
for first gl_ctrl
   fields (gl_domain gl_rnd_mthd gl_base_curr)
   where   gl_domain = global_domain
no-lock: end.

/* GET SHIPPER SUM HISTORY SETTING */
sum_tr_item = false.
for first mfc_ctrl
   fields (mfc_field mfc_logical mfc_module mfc_seq)
   where mfc_field = "shc_sum_tr_item"
no-lock:
   sum_tr_item = mfc_logical.
end.

for first so_mstr
   fields (so_domain so_app_owner so_curr so_cust so_nbr so_rev so_ship_date
           so_fr_terms)
   where   so_domain = global_domain
   and     so_nbr = ship_so
no-lock: end.

find sod_det
   where sod_domain = global_domain
   and   sod_nbr    = ship_so
   and   sod_line   = ship_line
exclusive-lock.

for first pt_mstr
   fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
           pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead
           pt_mrp pt_network pt_ord_max pt_ord_min pt_ord_mult
           pt_ord_per pt_ord_pol pt_ord_qty pt_part pt_plan_ord
           pt_pm_code pt_prod_line pt_pur_lead pt_rctpo_active
           pt_rctpo_status pt_rctwo_active pt_rctwo_status pt_routing
           pt_sfty_time pt_shelflife pt_timefence pt_um pt_yield_pct)
    where  pt_domain = global_domain
    and    pt_part = sod_part
no-lock: end.

if available pt_mstr then do:

   for first pl_mstr
      fields (pl_domain pl_inv_acct pl_inv_sub pl_inv_cc pl_prod_line)
      where   pl_domain = global_domain
      and     pl_prod_line = sod_prodline
   no-lock: end.

   if  not available pl_mstr then
      for first pl_mstr
         fields (pl_domain pl_inv_acct pl_inv_sub pl_inv_cc pl_prod_line)
         where   pl_domain = global_domain
         and     pl_prod_line = pt_prod_line
      no-lock: end.

end.   /* IF AVAILABLE pt_mstr */

for first clc_ctrl
   fields (clc_domain clc_lotlevel)
   where   clc_domain = global_domain
no-lock: end.

if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields (clc_domain clc_lotlevel)
      where   clc_domain = global_domain
   no-lock: end.
end.

find first soc_ctrl
   where soc_domain = global_domain
no-lock no-error.

sod_recno = recid(sod_det).

*/
/* Set the update quantities from the main database SO line */
assign
   sod_qty_chg = qty_chg
   sod_bo_chg  = qty_bo.

/*!***************************************************************
 * For 'normal' (other than Material Orders - MOs - and
 * Service Kit Replenishment) sales orders, use the 'normal' shipment
 * logic (which will do an ISS-SO, among other things).  For MO's and
 * Kit Replenishment, call FSEOIVTR.P (instead of MFIVTR.I) to transfer
 * inventory (ISS-TR and RCT-TR) instead of issuing it.
 ******************************************************************/
if sod_fsm_type <> "SEO" and sod_fsm_type <> "KITASS" then do:

   /*  CALL GPICLT.P TO CHECK FOR AND ADD THE LOT/SERIAL TO THE LOT_MSTR */
   if (clc_lotlevel <> 0)
      and sod_fsm_type begins "RMA"
   then do:
      qty_left = - sod_qty_chg.
      do for sr_wkfl while qty_left <> 0:
         assign
            trqty = qty_left
            site  = sod_site.

         if lotser = "" then lotser =  sod_serial.

         find next sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
            and  trim(sr_lineid) = trim(string(sod_line))
         no-lock no-error.

         if available sr_wkfl then
            assign
               lotser = sr_lotser
               trqty  = - sr_qty.

         if lotser <> "" then do:
            {gprun.i ""gpiclt.p""
                     "(input sod_part,
                       input lotser,
                       input """",
                       input """",
                       output trans-ok )"}

            if not trans-ok then do:
               /* CURRENT TRANSACTION REJECTED- CONTINUE */
               {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4}
               undo, leave. /* WITH NEXT TRANSACTION */

            end. /* IF NOT TRANS-OK THEN DO: */
         end.  /* if lotser <> "" */

         qty_left = qty_left - trqty.

      end. /* DO FOR sr_wkfl  */
   end. /* IF CLC_LOTLEV <> 0 ... */

   /* CALL LOGISTICS TO CREATE A CONFIRM ISSUE BUSINESS OBJECT DOCUMENT */
   /* TO SEND TO Q/LINQ TO INFORM THE LOGISTICS SYSTEM OF SHIPMENTS     */
   run logisticsProcessing
      (input global_domain,
       input so_app_owner,
       input sod_nbr,
       input sod_line,
       input eff_date).

   /* PROCEDURE TO CHECK THE INVENTORY */
   run p-invchk
      (input  recid(sod_det),
       output l_undo).

   if l_undo then
      undo, leave.

   assign
      l_curr_base = base_curr
      base_curr   = gl_base_curr.

   {mfivtr2.i " " """update in_qty_req"""}

   {&SOSOISU5-P-TAG3}

   base_curr = l_curr_base.

   /* Build work_trnbr file to be used by invoice post */
   create work_trnbr.
   assign
      work_sod_nbr  = sod_nbr
      work_sod_line = sod_line
      work_tr_recid = recid(tr_hist).

   /* IF sod_qty_inv IS NOT ZERO DURING SHIPPER CONFIRM THEN WE HAVE */
   /* PREVIOUSLY SHIPPED ITEMS FOR THIS SCHEDULED ORDER THAT HAVE    */
   /* NOT BEEN INVOICED YET WHEN THE INVOICE IS SUBSEQUENTLY POSTED  */
   /* WE NEED TO UPDATE THE tr_rmks FIELD FOR THESE TRANSACTIONS TO  */
   /* INDICATE WHICH INVOICE THEY WERE INCLUDED ON.                   */
   if sod_sched
      and confirm_mode
   then do:

      /* REMOVED THE CONDITION tr_ship_id SO THAT THE AUTHORIZATION */
      /* NUMBER RELATED TO THAT SHIPPER ONLY WILL BE PRINTED ON THE */
      /* INVOICE FOR THE SHIPPER.                                   */
      /*                                                            */
      /* THE tr_site AND tr_part WAS REMOVED FROM THE WHERE CLAUSE  */
      /* SO THAT ALL THE LINES OF THE CONSOLIDATED INVOICES tr_rmks */
      /* FIELD IS UPDATED WITH THE INVOICE NUMBER.                  */
      for each trhist
         fields (tr_domain tr_type tr_effdate tr_nbr tr_line tr_site tr_part
                 tr_ship_id tr_rmks)
         where trhist.tr_domain   = global_domain
         and   trhist.tr_type     = tr_hist.tr_type
         and   trhist.tr_effdate <= today
         and   trhist.tr_nbr      = tr_hist.tr_nbr
         and   trhist.tr_rmks     = ""
      no-lock:
         create work_trnbr.

         /* FOR CONSOLIDATED INVOICES THE tr_hist.tr_line IS ASSIGNED TO */
         /* THE WORK_SOD_LINE OF WORK_TRNBR, THIS FILE IS USED TO UPDATE */
         /* THE tr_rmks FIELD DURING INVOICE POST WHEN tr_rmks IS BLANK. */
         assign
            work_sod_nbr  = sod_nbr
            work_sod_line = tr_hist.tr_line
            work_tr_recid = recid(trhist).
      end. /* FOR EACH trhist */
   end. /* IF sod_sched */

   if use-log-acctg
      and available tr_hist
   then do:
      /* IF LOGISTICS ACCOUNTING IS ENABLED, STORE THE INVENTORY TRANSACTION */
      /* NUMBER FOR USE WHEN CREATING TRGL_DET FOR THE FREIGHT ACCRUAL       */
      find tt-frcalc
         where tt_order = sod_nbr
         and   tt_order_line = sod_line
      exclusive-lock no-error.

      if available tt-frcalc then
         tt_trans_nbr = tr_trnbr.

   end.   /* IF USE-LOG-ACCTG */

end. /* if sod_fsm_type <> "SEO" and <> "KITASS" */
else do:
   /* STORE THE TO-SITE/LOC OF LAST SHIPMENT IN SOD_DET           */
   /* AND INDICATE THAT THIS RECORD MAY BE LOADED IN CALL ACT REC */
   assign
      sod_to_site   = site_to
      sod_to_loc    = loc_to
      sod_car_load  = yes
      copyusr       = no.

   {gprun.i ""fseoivtr.p""
            "(input ship_so,
              input ship_line,
              input trlot,
              input eff_date,
              input fseomode)"}
end.

/* Update WIP for backflushed items */
{gprun.i ""sowip01.p""}

if copyusr  then
   assign
      tr__chr01    = sod__chr01
      tr__chr02    = sod__chr02
      tr__chr03    = sod__chr03
      tr__chr04    = sod__chr04
      tr__chr05    = sod__chr05
      tr__chr06    = sod__chr06
      tr__chr07    = sod__chr07
      tr__chr08    = sod__chr08
      tr__chr09    = sod__chr09
      tr__chr10    = sod__chr10
      tr__dec01    = sod__dec01
      tr__dec02    = sod__dec02
      tr_user1     = sod_user1
      tr_user2     = sod_user2.

/* UPDATE QTY ALLOCATED AND PICKED */
/* sod_qty_ship CONTAINS THE QTY FROM PRIOR SHIPPING TRANSACTIONS.
 * sod_qty_chg CONTAINS THE QTY FROM THE CURRENT SHIPPING TRANSACTION.
 */

/* NEGATIVE PICK QTY SHOULD NOT BE UPDATED AS POSITIVE PICK QTY IN */
/* DB FIELD sod_qty_pick, HENCE THE CONDITION                      */
if (qty_pick > 0 and confirm_mode)
   or (qty_pick < 0 and not confirm_mode)
then
   sod_qty_pick = max(sod_qty_pick - qty_pick,0).

if not sod_sched then do:
   if (sod_cfg_type <> "2"
      or execname  <> "rcunis.p")
   then do:
      if sod_qty_ord <= 0 or sod_bo_chg < 0 then
         sod_qty_all = 0.
      else
      if sod_qty_ord < sod_qty_ship then
         sod_qty_all = sod_qty_all
                     + max (0, sod_qty_ord - sod_qty_ship - sod_qty_chg).
      else
         sod_qty_all = max(sod_qty_all - (sod_qty_chg - qty_pick),0).

      sod_qty_all = min(sod_qty_all, max(0, sod_bo_chg)).
   end. /* IF sod_cfg_type <> "2" */
end.
else
if (sod_qty_chg > 0 and confirm_mode )
   or (sod_qty_chg < 0 and not confirm_mode )
then
   sod_qty_all = max(sod_qty_all - (sod_qty_chg - qty_pick), 0).

/* PLANNING ITEM MASTER SCHEDULE */
sod_recno = recid(sod_det).
{gprun.i ""sopbms.p""}

/* CAPTURE CURRENT CUM INTO PRIOR DAY CUM BEFORE UPDATING */
if sod_cum_date[2] = ? then
   sod_cum_date[2] = eff_date - 1.
else
   if sod_cum_date[2] < eff_date - 1 then
      assign
         sod_cum_date[2] = eff_date - 1
         sod_cum_qty[2] = sod_cum_qty[1].

/* UPDATE SALES ORDER */
assign
   sod_qty_ship   = sod_qty_ship + sod_qty_chg
   sod_cum_qty[1] = sod_cum_qty[1] + sod_qty_chg
   sod_sch_mrp    = yes
   sod_pickdate   = ?                   /* RESET LAST PICK DATE */
   prev_sod_qty_ord = sod_qty_ord.

/* CONVERT SHIPPER UM BACK TO SO LINE UM */
trans_conv = 1.
if work_abs_mstr.abs__qad02 <> sod_um
then do:
   {gprun.i ""gpumcnv.p""
            "(input  sod_um,
              input  work_abs_mstr.abs__qad02,
              input sod_part,
              output trans_conv)"}
end.

/* FOR LOGISTICS ORDERS, DON'T CHANGE THE */
/* QUANTITY TO INVOICE JUST BECAUSE IT WAS SHIPPED */
/* IT MAY HAVE ALREADY BEEN INVOICED. */
/* Normal case is lgInvoice = yes */
if work_abs_mstr.abs_consign_flag = no then
   run updateInvoiceQty
         (input yes,             /* UNCONSIGNED IS ALWAYS CONFIRM_MODE = YES */
          input lgInvoice,
          input sod_qty_chg,
          input 1,               /* SHIP QTY ALREADY IN SAME UOM AS INVC QTY */
          input-output sod_qty_inv).
else
/* CONFIRMING OR UNCONFIRMING NEGATIVE SHIPPER AS CONSIGNED CUSTOMER CREDIT */
if work_abs_mstr.abs_qty < 0
   and work_abs_mstr.abs__qadc01 = ""          /* CONSIGNED CUSTOMER CREDIT */
then do:

   if sum_tr_item then do:
      sum_abs_qty = 0.
      for each workabs1
         where workabs1.abs_shipfrom = work_abs_mstr.abs_shipfrom
         and   workabs1.abs_order    = work_abs_mstr.abs_order
         and   workabs1.abs_line     = work_abs_mstr.abs_line
         and   workabs1.abs_loc      = work_abs_mstr.abs_loc
         and   workabs1.abs_lotser   = work_abs_mstr.abs_lotser
         and   workabs1.abs_ref      = work_abs_mstr.abs_ref
         and   workabs1.abs__qadc01  = " "
      no-lock:
         sum_abs_qty = sum_abs_qty + workabs1.abs_qty.
      end.

      run updateInvoiceQty
         (input confirm_mode,
          input lgInvoice,
          input sum_abs_qty,
          input trans_conv,
          input-output sod_qty_inv).

   end.  /* IF sum_tr_item  */
   else
      run updateInvoiceQty
         (input confirm_mode,
          input lgInvoice,
          input work_abs_mstr.abs_qty,
          input trans_conv,
          input-output sod_qty_inv).

end.  /* ELSE < 0 (CONSIGNED AND NEGATIVE SHIPMENT) */

if ((sod_qty_ord >= 0 and sod_qty_ship < sod_qty_ord)
   or (sod_qty_ord <  0 and sod_qty_ship > sod_qty_ord))
   and not sod_sched
then
   sod_qty_ord = sod_qty_ship + sod_bo_chg.

if sod_sched and sod_qty_ord <> 0 then
   sod_qty_ord = 0.

/* Store the new quantities for update of the main database */
assign
   qty_ord      = sod_qty_ord
   qty_ship     = sod_qty_ship
   qty_cum_ship = sod_cum_qty[1]
   qty_inv      = sod_qty_inv
   std_cost     = sod_std_cost
   qty_all      = sod_qty_all
   qty_pick     = sod_qty_pick.

/* FORECAST RECORD */
sod_recno = recid(sod_det).
{gprun.i ""sosofc.p""}

/* CALCULATE DEMAND UPDATE RELEASE DATES FOR NORMAL & CONFIG ITEMS */
{gprun.i ""sosoisu4.p""}

/* MRP WORKFILE */
if sod_qty_ord >= 0 then
   open_qty = max(sod_qty_ord - max(sod_qty_ship,0),0) * sod_um_conv.
else
   open_qty = min(sod_qty_ord - min(sod_qty_ship,0),0) * sod_um_conv.

if sod_type <> "" then open_qty = 0.

/* RELIEVE MRP REQUIREMENTS FOR CUM ORDERS HERE.   */
/* FOR NON-CUM ORDERS DO IT AFTER SCHD_SHIP_QTY IS */
/* UPDATED VIA RCSOIS3A.P IN RCSOIS1A.P            */
if sod_sched and so_cum_acct then do:
   {gprun.i ""rcmrw.p""
            "(input sod_nbr,
              input sod_line,
              input no)"}
end.
else do:
   if sod_fsm_type <> "RMA-RCT" then do:
      {mfmrw.i "sod_det" sod_part sod_nbr string(sod_line) """"
         ? sod_due_date open_qty "DEMAND" SALES_ORDER sod_site}
   end.
end.

if sod_fsm_type begins "RMA" then do:
   {gprun.i ""sosoisr1.p""}
end.

assign
   sod_qty_chg = 0
   sod_bo_chg  = 0.

PROCEDURE p-invchk:
/*-----------------------------------------------------------------------
 * Purpose:      To check the inventory for Overissue Status for non kit
 *               components
 * Parameters:   p_sorecid     recid   field to find sod_det record
 *               l_undo        logical field to undo
 *
 * Note:
 * -----------------------------------------------------------------------*/

   define input  parameter p_sorecid as   recid       no-undo.
   define output parameter l_undo    like mfc_logical no-undo.

   define variable trans_conv like sod_um_conv.
   define buffer   pt_mstr    for  pt_mstr.

   for first sod_det
      fields(sod_nbr sod_line)
      where recid(sod_det) = p_sorecid
      no-lock:
   end. /* FOR FIRST sod_det */

   for each work_abs_mstr
      fields (abs_id abs_item abs_line abs_order abs_qty
              abs_shipfrom abs_ship_qty abs_site abs__qad03
              abs__qad06 abs__qad07)
      where   work_abs_mstr.abs_order = sod_nbr
      and     work_abs_mstr.abs_line  = string(sod_line)
      and     work_abs_mstr.abs_id    begins "i"
      and not work_abs_mstr.abs_par_id begins "i"
   no-lock:
      trans_conv = 1.
      if can-find (first work_ldd
         where work_ldd_id = work_abs_mstr.abs_id )
      then
         next.

      if (confirm_mode = yes and work_abs_mstr.abs_qty > 0 )
         or
         (confirm_mode = no and work_abs_mstr.abs_qty < 0 )
      then do:

         /* SKIP INVENTORY CHECK FOR MEMO, KIT PARENT AND (ATO      */
         /* PARENT IF RECEIVE F/A IN SO = YES IN CONFIGURED PRODUCTS*/
         /* CONTROL FILE */
         for first fac_ctrl
            fields (fac_domain fac_so_rec)
            where   fac_domain = global_domain
         no-lock: end.

         if can-find(first sod_det
            where sod_domain = global_domain
            and  (sod_nbr  = work_abs_mstr.abs_order
            and   sod_part = work_abs_mstr.abs_item
            and   sod_line = integer(work_abs_mstr.abs_line)
            and ((sod_type = "M")
            or (can-find (first sob_det
            where sob_domain = global_domain
            and  (sob_nbr    = sod_nbr
            and   sob_line   = sod_line
            and   sod_type   = ""
            and available fac_ctrl
            and ( (fac_so_rec = yes
            and   sod_cfg_type = "1")
            or   (sod_cfg_type = "2") ))) ) ) ))
         then
            next.

         /* GET THE CORRECT UM */
         for first pt_mstr
            fields (pt_domain pt_part pt_um)
            where   pt_domain = global_domain
            and     pt_part   = abs_item
         no-lock:
            if work_abs_mstr.abs__qad02 <> pt_um
            then do:
               {gprun.i ""gpumcnv.p""
                        "(input work_abs_mstr.abs__qad02,
                          input pt_um,
                          input pt_part,
                          output trans_conv)"}
            end. /* IF work_abs_mstr .. */
         end. /* FOR FIRST pt_mstr */

         l_db = global_db.
         for first si_mstr
            fields (si_domain si_db si_site)
             where si_domain = global_domain
             and   si_site   = work_abs_mstr.abs_site
         no-lock:

            if si_db <> global_db then do:
               {gprun.i ""gpalias3.p"" "(input si_db, output err_flag)"}
            end.
         end.

         {gprun.i ""rcinvchk.p""
                  "(input  work_abs_mstr.abs_item,
                    input  work_abs_mstr.abs_site,
                    input  work_abs_mstr.abs_loc,
                    input  work_abs_mstr.abs_lot,
                    input  work_abs_mstr.abs_ref,
                    input  work_abs_mstr.abs_qty * trans_conv,
                    input  work_abs_mstr.abs_id,
                    input  yes,
                    output l_undo)"}

         if l_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(input l_db, output err_flag)"}
         end.

         if l_undo = yes then
            return.

      end. /* IF confirm_mode ... */
   end. /* FOR EACH work_abs_mstr.. */

END PROCEDURE.   /* p-invchk */

PROCEDURE updateInvoiceQty:
   define input parameter confirm_mode        as logical       no-undo.
   define input parameter lgInvoice           as logical       no-undo.
   define input parameter qty                 like abs_qty     no-undo.
   define input parameter trans_conv          as decimal       no-undo.
   define input-output parameter invoice_qty  like sod_qty_inv no-undo.

/* ss 20070225.1 - b */
/*
   if confirm_mode then
      invoice_qty = if lgInvoice then (invoice_qty + (qty / trans_conv))
                    else invoice_qty.
   else
      invoice_qty = if lgInvoice then (invoice_qty - (qty / trans_conv))
                    else invoice_qty.
 */
   invoice_qty = 0 .
/* ss 20070225.1 - e */

END PROCEDURE.   /* updateInvoiceQty */

PROCEDURE preliminaryProcessing:

   define              parameter buffer gl_ctrl  for gl_ctrl.
   define              parameter buffer so_mstr  for so_mstr.
   define              parameter buffer sod_det  for sod_det.
   define              parameter buffer pt_mstr  for pt_mstr.
   define              parameter buffer pl_mstr  for pl_mstr.
   define              parameter buffer clc_ctrl for clc_ctrl.
   define              parameter buffer soc_ctrl for soc_ctrl.
   define input-output parameter use-log-acctg   as logical.
   define input-output parameter sum_tr_item     as logical.
   define input-output parameter sod_recno       as recid.

   /* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
   {gprun.i ""lactrl.p"" "(output use-log-acctg)"}

   /* FIND GL_CTRL FOR MFIVTR.I */
   for first gl_ctrl
      fields (gl_domain gl_rnd_mthd gl_base_curr)
      where   gl_domain = global_domain
   no-lock: end.

   /* GET SHIPPER SUM HISTORY SETTING */
   sum_tr_item = false.
   for first mfc_ctrl
      fields (mfc_domain mfc_field mfc_logical mfc_module mfc_seq)
      where   mfc_domain = global_domain
      and     mfc_field = "shc_sum_tr_item"
   no-lock:
      sum_tr_item = mfc_logical.
   end.

   for first so_mstr
      fields (so_domain so_app_owner so_curr so_cust so_nbr so_rev so_ship_date
              so_fr_terms)
      where   so_domain = global_domain
      and     so_nbr = ship_so
   no-lock: end.

   find sod_det
      where sod_domain = global_domain
      and   sod_nbr    = ship_so
      and   sod_line   = ship_line
   exclusive-lock.

   for first pt_mstr
      fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1
              pt_desc2 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead
              pt_mrp pt_network pt_ord_max pt_ord_min pt_ord_mult
              pt_ord_per pt_ord_pol pt_ord_qty pt_part pt_plan_ord
              pt_pm_code pt_prod_line pt_pur_lead pt_rctpo_active
              pt_rctpo_status pt_rctwo_active pt_rctwo_status pt_routing
              pt_sfty_time pt_shelflife pt_timefence pt_um pt_yield_pct)
      where   pt_domain = global_domain
      and     pt_part = sod_part
   no-lock:

      for first pl_mstr
         fields (pl_domain pl_inv_acct pl_inv_sub pl_inv_cc pl_prod_line)
         where   pl_domain = global_domain
         and     pl_prod_line = sod_prodline
      no-lock: end.

      if  not available pl_mstr then
         for first pl_mstr
            fields (pl_domain pl_inv_acct pl_inv_sub pl_inv_cc pl_prod_line)
            where   pl_domain = global_domain
            and     pl_prod_line = pt_prod_line
         no-lock: end.

   end.   /* FOR FIRST pt_mstr */

   for first clc_ctrl
      fields (clc_domain clc_lotlevel)
      where   clc_domain = global_domain
   no-lock: end.

   if not available clc_ctrl then do:
      {gprun.i ""gpclccrt.p""}

      for first clc_ctrl
         fields (clc_domain clc_lotlevel)
         where   clc_domain = global_domain
      no-lock: end.
   end.

   find first soc_ctrl
      where soc_domain = global_domain
   no-lock no-error.

   sod_recno = recid(sod_det).

END PROCEDURE.   /* preliminaryProcessing */

PROCEDURE logisticsProcessing:
   define input parameter global_domain as character no-undo.
   define input parameter so_app_owner  as character no-undo.
   define input parameter sod_nbr       as character no-undo.
   define input parameter sod_line      as integer   no-undo.
   define input parameter eff_date      as date      no-undo.

   if so_app_owner > "" then do:
      for first lgs_mstr
         where lgs_domain = global_domain
         and   lgs_app_id = so_app_owner
      no-lock:
         /* IF THIS IS A LOGISTICS ORDER, SEE IF PRE BILLING */
         /* IS ACTIVE. PRE-BILLING IMPLIES THAT SHIPPING DOES */
         /* NOT CAUSE A CHANGE IN THE QUANTITY TO INVOICE AS */
         /* THE LINE MAY HAVE BEEN INVOICED ALREADY. */
         assign
            lg_sod_nbr = sod_nbr
            lg_sod_line = sod_line
            lg_eff_date = eff_date
            lgInvoice = not lgs_invc_imp.

         {gprunmo.i &program="lgshpex.p"  &module="LG"
                    &param="""(input lg_sod_nbr,
                               input lg_sod_line,
                               input lg_eff_date)"""}
      end.
   end.
END PROCEDURE.   /* logisticsProcessing */
