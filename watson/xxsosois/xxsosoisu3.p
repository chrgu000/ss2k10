/* sosoisu3.p - SALES ORDER SHIPMENT UPDATE INVENTORY                         */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.65.1.1 $                                                               */

/******************************************************************
* This routine updates inventory based on the shipment information
* stored in sr_wkfl.
******************************************************************/

/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 7.0      LAST MODIFIED: 11/06/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/28/91   BY: sas *F017*                */
/* REVISION: 7.0      LAST MODIFIED: 12/26/91   BY: WUG *F034*                */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: WUG *F110*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: sas *F278*                */
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: afs *F459*                */
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: sas *F450*                */
/* REVISION: 7.0      LAST MODIFIED: 06/10/92   BY: tjs *F504*                */
/* REVISION: 7.0      LAST MODIFIED: 07/10/92   BY: pma *F748*                */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*                */
/* REVISION: 7.0      LAST MODIFIED: 07/28/92   BY: emb *F817*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/12/92   BY: WUG *G313*                */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: afs *G595*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: pma *G032*                */
/* REVISION: 7.3      LAST MODIFIED: 04/01/93   BY: WUG *G696*                */
/* REVISION: 7.3      LAST MODIFIED: 05/07/93   BY: WUG *GA74*                */
/* REVISION: 7.3      LAST MODIFIED: 06/14/93   BY: sas *GC18*                */
/* REVISION: 7.3      LAST MODIFIED: 07/12/93   BY: WUG *GD35*                */
/* REVISION: 7.3      LAST MODIFIED: 07/12/93   BY: tjs *GA64*                */
/* REVISION: 7.4      LAST MODIFIED: 09/16/94   BY: dpm *H075*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: tjs *H237*                */
/* REVISION: 7.4      LAST MODIFIED: 01/27/94   BY: afs *FL76*                */
/* REVISION: 7.4      LAST MODIFIED: 04/21/94   BY: WUG *GJ51*                */
/* REVISION: 7.4      LAST MODIFIED: 05/19/94   BY: afs *FN92*                */
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: dpm *FO23*                */
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*                */
/* REVISION: 7.4      LAST MODIFIED: 12/02/94   BY: qzl *FU24*                */
/* REVISION: 7.4      LAST MODIFIED: 12/07/94   BY: smp *FU33*                */
/* REVISION: 7.4      LAST MODIFIED: 02/24/95   BY: smp *F0H4*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: ais *G0YK*                */
/* REVISION: 7.4      LAST MODIFIED: 10/11/95   BY: jym *G0Z1*                */
/* REVISION: 7.4      LAST MODIFIED: 10/19/95   BY: ais *G19C*                */
/* REVISION: 7.4      LAST MODIFIED: 10/26/95   BY: ais *G1B1*                */
/* REVISION: 8.5      LAST MODIFIED: 08/11/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/04/96   BY: *G1WN* Robin McCarthy     */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *J125* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 08/16/96   BY: *G2CG* Sanjay Patil       */
/* REVISION: 8.5      LAST MODIFIED: 05/14/97   BY: *H0Z2* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 06/09/97   BY: *H0X6* Jim Williams       */
/* REVISION: 8.5      LAST MODIFIED: 08/29/97   BY: *H1DX* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone      */
/* REVISION: 8.6E     LAST MODIFIED: 07/03/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *J2SF* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 08/28/98   BY: *J2XY* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 10/30/98   BY: *M00D* Chris DeVitto      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/21/99   BY: *F0Y0* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02S* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 11/02/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 04/03/00   BY: *L0PZ* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 12/06/00   BY: *M0XJ* Nikita Joshi       */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0WB* Mudit Mehta        */
/* Revision: 1.35       BY: Katie Hilbert          DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.40       BY: Ashwini Ghaisas        DATE: 08/06/01 ECO: *M1GW* */
/* Revision: 1.41       BY: Rajiv Ramaiah          DATE: 09/19/01 ECO: *M1LM* */
/* Revision: 1.43       BY: Patrick Rowan          DATE: 03/14/02 ECO: *P00G* */
/* Revision: 1.44       BY: Kirti Desai            DATE: 04/18/02 ECO: *M1XM* */
/* Revision: 1.45       BY: Jean Miller            DATE: 04/18/02 ECO: *P074* */
/* Revision: 1.46       BY: Samir Bavkar           DATE: 05/15/02 ECO: *P042* */
/* Revision: 1.49       BY: Robin McCarthy         DATE: 07/03/02 ECO: *P08Q* */
/* Revision: 1.50       BY: Robin McCarthy         DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.51       BY: Samir Bavkar           DATE: 08/18/02 ECO: *P0FS* */
/* Revision: 1.52       BY: Manjusha Inglay        DATE: 08/27/02 ECO: *N1S3* */
/* Revision: 1.54       BY: Robin McCarthy         DATE: 11/15/02 ECO: *P0HD* */
/* Revision: 1.55       BY: Subramanian Iyer       DATE: 03/25/03 ECO: *M22J* */
/* Revision: 1.56      BY: Narathip Weerakitpanich DATE: 05/08/03 ECO: *P0RL* */
/* Revision: 1.58       BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.59       BY: Rajesh Kini            DATE: 08/25/03 ECO: *N2HN* */
/* Revision: 1.60       BY: Ed van de Gevel        DATE: 09/09/03 ECO: *Q033* */
/* Revision: 1.61       BY: Ed van de Gevel        DATE: 09/17/03 ECO: *Q03H* */
/* Revision: 1.62       BY: Nishit Vadhavkar       DATE: 10/29/03 ECO: *N2MB* */
/* Revision: 1.63       BY: Robin McCarthy         DATE: 04/19/04 ECO: *P15V* */
/* Revision: 1.64       BY: Gaurav Kerkar          DATE: 08/27/04 ECO: *P2H4* */
/* Revision: 1.65       BY: Vinod Kumar            DATE: 12/10/04 ECO: *P2TK* */
/* $Revision: 1.65.1.1 $         BY: Sunil Fegade           DATE: 03/22/05 ECO: *P3DL* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "SOSOISU3.P"}

{socnis.i}   /* CONSIGNMENT TEMP-TABLE DEFINITION */


define input parameter l_transtype      as character     no-undo.
define input parameter table            for tt_consign_shipment_detail.
define input-output parameter io_first_time as logical no-undo.
define input-output parameter countOfSrwkfl as integer no-undo.

    DEFINE SHARED TEMP-TABLE tt9
    FIELD tt9_type AS CHAR 
    FIELD tt9_line AS INTEGER         FORMAT ">>9"
    FIELD tt9_part AS CHAR            FORMAT "x(18)" 
    FIELD tt9_um   AS CHAR            FORMAT "x(2)" 
    FIELD tt9_qty_bo AS DECIMAL      format "->>>>>9" 
    FIELD tt9_qty_avail AS DECIMAL    format "->>>>>9"
    FIELD tt9_qty_chg   AS DECIMAL    format "->>>>>9"
    FIELD tt9_tr_um AS CHAR           FORMAT "x(2)"    
    FIELD tt9_tr_uom AS CHAR          FORMAT "x(2)" 
    FIELD tt9_conv AS DECIMAL         format ">>>9.9999<" 
    FIELD tt9_msg  AS CHAR            FORMAT "x(9)"
    FIELD tt9_site LIKE ld_site
    FIELD tt9_loc LIKE ld_loc
    FIELD tt9_lotser LIKE ld_lot
    FIELD tt9_ref LIKE ld_ref
    INDEX tt9line tt9_line .

define new shared variable trgl_recno as recid.
define new shared variable sct_recno as recid.
define new shared variable pt_recid  as recid.
define new shared variable accum_wip like tr_gl_amt.
define new shared variable nbr like tr_nbr.
define new shared variable cr_acct like trgl_cr_acct.
define new shared variable cr_sub like trgl_cr_sub.
define new shared variable cr_cc   like trgl_cr_cc.
define new shared variable cr_proj like trgl_cr_proj.
define new shared variable sct_recid as recid.
define new shared variable wip_entity  like si_entity.
define new shared variable tr_recno as recid.
define new shared variable prev_qty_ship    like sod_qty_ship.
define new shared variable prev_sod_qty_ord like sod_qty_ord no-undo.
define new shared variable l_prev_db        like si_db       no-undo.

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable qty_left like tr_qty_chg.
define shared variable trqty like tr_qty_chg.
define shared variable eff_date like glt_effdate label "Effective".
define shared variable trlot like tr_lot.
define shared variable ref like glt_ref.
define shared variable qty_req like in_qty_req.
define shared variable open_ref like sod_qty_ord.
define shared variable loc like pt_loc.
define shared variable prev_qty_ord like sod_qty_ord.
define shared variable prev_due like sod_due_date.
define shared variable i as integer.
define shared variable qty as decimal.
define shared variable part as character format "x(18)".
define shared variable prev_consume like sod_consume.
define shared variable sod_recno as recid.
define shared variable fas_so_rec as character.
define shared variable prev_site like sod_site.
define shared variable prev_type like sod_type.
define shared variable exch_rate like exr_rate.
define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable sod_entity like en_entity.
define shared variable ship_site like sod_site.
define shared variable so_db like global_db.
define shared variable ship_db like global_db.
define shared variable change_db like mfc_logical.
define shared variable ship_so like so_nbr.
define shared variable ship_line like sod_line.
define shared variable so_hist like soc_so_hist.
define shared variable qty_ord  like sod_qty_ord.
define shared variable qty_ship like sod_qty_ship.
define shared variable qty_cum_ship like sod_qty_ship.
define shared variable qty_inv  like sod_qty_inv.
define shared variable qty_chg  like sod_qty_chg.
define shared variable qty_bo   like sod_bo_chg.
define shared variable std_cost like sod_std_cost.
define shared variable qty_all  like sod_qty_all.
define shared variable qty_iss_rcv like tr_qty_loc.
define shared variable copyusr  like mfc_logical.
define shared variable site_to       like sod_site.
define shared variable loc_to        like sod_loc.
define shared variable l_undo_flag      like mfc_logical no-undo.
define shared variable trans_conv       like sod_um_conv.

define variable site like sod_site.
define variable location like sod_loc.
define variable lotser like sod_serial.
define variable gl_amt like glt_amt.
define variable dr_acct like sod_acct.
define variable dr_sub like sod_sub.
define variable dr_cc like sod_cc.
define variable open_qty like sod_qty_ord.
define variable from_entity like en_entity.
define variable icx_acct like sod_acct.
define variable icx_sub like sod_sub.
define variable icx_cc like sod_cc.
define variable lotrf like tr_ref.
define variable transtype as character.
define variable prev_found like mfc_logical.
define variable glcost like sct_cst_tot.
define variable assay like tr_assay.
define variable grade like tr_grade.
define variable expire like tr_expire.
define variable site_change as logical initial no.
define variable pend_inv    as logical initial no.
define variable sodreldate  like mrp_rel_date.
define variable know_date   as date.
define variable find_date   as date.
define variable interval    as integer.
define variable frwrd       as integer.
/* DEFINE GL_TMP_AMT FOR MFIVTR.I */
define variable gl_tmp_amt       as decimal no-undo.
define variable fseomode         as character initial "SHIP".
define variable trans-ok         like mfc_logical.
define variable mc-error-number  like msg_nbr no-undo.
define variable base-price       like tr_price no-undo.
define variable lg_sod_nbr       like sod_nbr.
define variable lg_sod_line      like sod_line.
define variable lg_eff_date      like eff_date.
define variable l_lotedited      like mfc_logical no-undo.
define variable l_qty_change     like mfc_logical no-undo.
define variable lgInvoice        as logical initial yes no-undo.
define variable l_ok             like mfc_logical no-undo.
define variable l_recid          as recid         no-undo.
define variable msg-arg          as character format "x(16)" no-undo.
define variable use-log-acctg    as logical no-undo.

/* SS - 20080812.1 - B */
DEF SHARED VAR v_loc LIKE tr_loc .
DEF SHARED VAR v_dn LIKE tr_loc .
DEF SHARED VAR v_bill LIKE so_bill.
DEF SHARED VAR v_ship LIKE so_ship.
/* SS - 20080812.1 - E */

/* SS - 20081226.1 - B */
DEFINE SHARED VAR v_flag_item AS LOGICAL .
/* SS - 20081226.1 - E */

{&SOSOISU3-P-TAG1}
define buffer soddet for sod_det.
{&SOSOISU3-P-TAG4}

/* CONSIGNMENT VARIABLES. THESE ARE USED IN mfivtr.i */
{socnvars.i}
{socnvar2.i}

/* DEFINE NEW INSTANCE OF DAYBOOKS VARIABLES */
{gldydef.i new}

/* DEFINE NEW INSTANCE OF NRM FOR THIS DATABASE */
{gldynrm.i new}

/* LOGISTICS ACCOUNTING FREIGHT TEMP-TABLE */
{lafrttmp.i}

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* FIND GL_CTRL FOR MFIVTR.I */
for first gl_ctrl
   fields (gl_domain gl_rnd_mthd)
   where   gl_domain = global_domain
no-lock: end.

for first so_mstr
   fields (so_domain so_app_owner so_curr so_cust so_nbr so_rev so_ship_date
           so_fr_terms)
   where   so_domain = global_domain
   and     so_nbr = ship_so
no-lock: end.

find sod_det
   where sod_domain = global_domain
   and   sod_nbr  = ship_so
   and   sod_line = ship_line
exclusive-lock no-error.

/* ASSIGN LOCAL CONSIGNMENT VARIABLES FOR mfivtr.i */
assign
   consigned_line_item          = no
   consigned_return_material    = no
   consigned_to_location        = ""
   l_rmks                       = "".

for first tt_consign_shipment_detail
   where tt_consign_shipment_detail.sales_order = sod_nbr
   and   tt_consign_shipment_detail.order_line  = sod_line
no-lock:
   assign
      consigned_line_item = tt_consign_shipment_detail.consigned_line_item
      consigned_to_location = tt_consign_shipment_detail.consigned_to_location
      l_rmks = getTermLabel("CONSIGNED",12).
end.

for first pt_mstr
   fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1 pt_desc2
           pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead
           pt_mrp pt_network pt_ord_max pt_ord_min pt_ord_mult
           pt_ord_per pt_ord_pol pt_ord_qty pt_part pt_plan_ord
           pt_pm_code pt_prod_line pt_pur_lead pt_rctpo_active
           pt_rctpo_status pt_rctwo_active pt_rctwo_status pt_routing
           pt_sfty_time pt_shelflife pt_timefence pt_um pt_yield_pct)
   where   pt_domain = global_domain
   and     pt_part = sod_part
no-lock:

   for first pl_mstr
      fields (pl_domain pl_inv_acct pl_inv_cc pl_inv_sub pl_prod_line)
      where   pl_domain = global_domain
      and     pl_prod_line = sod_prodline
   no-lock: end.

   if not available pl_mstr then
      for first pl_mstr
         fields (pl_domain pl_inv_acct pl_inv_cc pl_inv_sub pl_prod_line)
         where   pl_domain = global_domain and  pl_prod_line = pt_prod_line
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

sod_recno = recid(sod_det).

/* Set the update quantities from the main database SO line */
assign
   sod_qty_chg = qty_chg
   sod_bo_chg  = qty_bo.

do for sr_wkfl:
   for last sr_wkfl
      fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_site
              sr_userid)
       where  sr_domain = global_domain
       and    sr_userid = mfguser
   no-lock:
      l_recid = recid(sr_wkfl).
   end.
end. /* DO FOR SR_WKFL */

if execname = "fsrmamt.p"
   or sod_fsm_type begins "RMA"
then
   pend_inv = yes.

/* SS - 20081226.1 - B */
IF v_flag_item = YES THEN DO:
   UNDO,LEAVE .
END.
/* SS - 20081226.1 - E */

/*!***************************************************************
 * For 'normal' (other than Material Orders - MOs - and
 * Service Kit Replenishment) sales orders, use the 'normal' shipment
 * logic (which will do an ISS-SO, among other things).  For MO's and
 * Kit Replenishment, call FSEOIVTR.P (instead of MFIVTR.I) to transfer
 * inventory (ISS-TR and RCT-TR) instead of issuing it.
 ******************************************************************/
if sod_fsm_type <> "SEO"
   and sod_fsm_type <> "KITASS"
then do:

   if (clc_lotlevel <> 0)
      and sod_fsm_type begins "RMA"
   then do:

      qty_left = - sod_qty_chg.

      do for sr_wkfl while qty_left <> 0:

         assign
            trqty = qty_left
            site = sod_site.

         if lotser = "" then lotser =  sod_serial.

         find next sr_wkfl
            where sr_domain = global_domain
            and   sr_userid = mfguser
            and   sr_lineid = string(sod_line)
         no-error.

         if available sr_wkfl then
            assign
               lotser = sr_lotser
               trqty = - sr_qty.

         if lotser <> "" and (sod_type = "") then do:
            {gprun.i ""gpiclt.p""
                     "(input sod_part,
                       input lotser,
                       input """",
                       input """",
                       output trans-ok )"}

            if not trans-ok then do:
               /* CURRENT TRANSACTION REJECTED- CONTINUE */
               {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4}
               undo, leave.      /* WITH NEXT TRANSACTION */
            end. /* IF NOT TRANS-OK THEN DO: */
         end.  /* if lotser <> "" */

         qty_left = qty_left - trqty.

      end. /* DO FOR sr_wkfl  */

   end. /* IF CLC_LOTLEV <> 0 ... */

   /* CALL LOGISTICS TO CREATE A CONFIRM ISSUE BUSINESS OBJECT DOCUMENT */
   /* TO SEND TO Q/LINQ TO INFORM THE LOGISTICS SYSTEM OF SHIPMENTS */
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

         {gprunmo.i &module="LG" &program="lgshpex.p"
                    &param="""(input lg_sod_nbr,
                               input lg_sod_line,
                               input lg_eff_date)"""}
      end.
   end.   /* IF so_app_owner */

   if sod_type = "" then
      run p-inventory-check.

   /* SS - 20080812.1 - B */
   {xxmfivtr.i " " """update in_qty_req"""}
   {&SOSOISU3-P-TAG5}
   /* SS - 20080812.1 - E */

   if use-log-acctg
      and (available tr_hist)
   then do:
      /* IF LOGISTICS ACCOUNTING IS ENABLED, STORE THE INVENTORY TRANSACTION */
      /* NUMBER FOR USE WHEN CREATING TRGL_DET FOR THE FREIGHT ACCRUAL       */
      find tt-frcalc
         where tt_order = sod_nbr
         and tt_order_line = sod_line
      exclusive-lock no-error.

      if available tt-frcalc then
         tt_trans_nbr = tr_trnbr.

   end.   /* if use-log-acctg */

end.   /* if sod_fsm_type <> "SEO" and <> "KITASS" */
else do:
   /* STORE THE TO-SITE/LOC OF LAST SHIPMENT IN SOD_DET           */
   /* AND INDICATE THAT THIS RECORD MAY BE LOADED IN CALL ACT REC */
   assign
      sod_to_site   = site_to
      sod_to_loc    = loc_to
      sod_car_load  = yes
      copyusr       = no.

   if sod_type = "" then
      run p-inventory-check.

   {gprun.i ""fseoivtr.p""
            "(input ship_so,
              input ship_line,
              input trlot,
              input eff_date,
              input fseomode)"}
end.

/* Update WIP for backflushed items */
{gprun.i ""sowip01.p""}

if copyusr then
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
assign
   sod_qty_all  = sod_qty_all + sod_qty_pick
   sod_qty_pick = 0.

/* sod_qty_ship CONTAINS THE QTY FROM PRIOR SHIPPING TRANSACTIONS.
 * sod_qty_chg  CONTAINS THE QTY FROM THE CURRENT SHIPPING TRANSACTION.
 */

if not sod_sched then do:
   if sod_qty_ord <= 0 or sod_bo_chg < 0 then
      sod_qty_all = 0.
   else
   if sod_qty_ord < sod_qty_ship
   then
      sod_qty_all = sod_qty_all +
      max (0, sod_qty_ord - sod_qty_ship - sod_qty_chg).
   else
      sod_qty_all = sod_qty_all - min ( sod_qty_all, sod_qty_chg).
   sod_qty_all = min(sod_qty_all, max(0, sod_bo_chg)).
end.

else if (sod_qty_chg > 0)
then
   sod_qty_all = max(sod_qty_all - sod_qty_chg, 0).

/* PLANNING ITEM MASTER SCHEDULE */
sod_recno = recid(sod_det).
{gprun.i ""sopbms.p""}

if sod_sched then do:
   {mfdel.i pk_det "where pk_domain = global_domain
                    and   pk_user = mfguser"}
   part = sod_part.
   {gprun.i ""sopbex.p""}
end. /* IF sod_sched */

/*CAPTURE CURRENT CUM INTO PRIOR DAY CUM BEFORE UPDATING*/
if sod_cum_date[2] = ? then
   sod_cum_date[2] = eff_date - 1.
else
   if sod_cum_date[2] < eff_date - 1 then
   assign
      sod_cum_date[2] = eff_date - 1
      sod_cum_qty[2] = sod_cum_qty[1].

/* UPDATE SALES ORDER */
/* FOR LOGISTICS ORDERS, DON'T CHANGE THE */
/* QUANTITY TO INVOICE JUST BECAUSE IT WAS SHIPPED */
/* IT MAY HAVE ALREADY BEEN INVOICED. */
/* Normal case is lgInvoice = yes */

/* UPDATE Qty Shipped FOR PENDING INVOICE OR NON-BLANK SHIP TYPE */
if pend_inv
   or sod_type <> ""
then
   sod_qty_ship = sod_qty_ship + sod_qty_chg.

assign
   sod_cum_qty[1] = sod_cum_qty[1] + sod_qty_chg
   sod_sch_mrp    = yes
   sod_pickdate   = ?.                   /* reset last pick date */

/* UPDATE QTY INVOICED */
if can-find (first tt_consign_shipment_detail
   where sales_order = sod_nbr
   and   order_line  = sod_line)
then
   for each tt_consign_shipment_detail
      where sales_order = sod_nbr
      and   order_line  = sod_line
   no-lock:

      /* UPDATE QTY INVOICED IF CONSIGNED BUT RETURNED FOR CUSTOMER CREDIT */
      if tt_consign_shipment_detail.consigned_line_item and
         tt_consign_shipment_detail.ship_qty < 0 and
         tt_consign_shipment_detail.consigned_return_material = no
      then
         sod_qty_inv  = if lgInvoice then
                           sod_qty_inv + tt_consign_shipment_detail.ship_qty
                        else sod_qty_inv.
   end.
else
   sod_qty_inv  = if lgInvoice then sod_qty_inv + sod_qty_chg
                  else sod_qty_inv.

prev_sod_qty_ord = sod_qty_ord.

if ((sod_qty_ord >= 0 and sod_qty_ship < sod_qty_ord) or
    (sod_qty_ord <  0 and sod_qty_ship > sod_qty_ord)) and
   not sod_sched
then
   sod_qty_ord = sod_qty_ship + sod_bo_chg.

if sod_sched and sod_qty_ord <> 0 then sod_qty_ord = 0.

/* Store the new quantities for update of the main database */
assign
   qty_ord      = sod_qty_ord
   qty_ship     = sod_qty_ship
   qty_cum_ship = sod_cum_qty[1]
   qty_inv      = sod_qty_inv
   std_cost     = sod_std_cost
   qty_all      = sod_qty_all.

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

if sod_sched then do:
   {gprun.i ""rcmrw.p"" "(input sod_nbr, input sod_line, input no)"}
end.
else do:
   /* Test for RMA-RCT to prevent negative gross reqmt on partials */
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

/* CHECKING INVENTORY DURING SHIPMENT PROCESS */
PROCEDURE p-inventory-check:
   define buffer srwkfl for sr_wkfl.

   for each srwkfl
      fields (sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_site
              sr_userid)
      where   sr_domain = global_domain
      and     sr_userid = mfguser
      and     sr_lineid = string(sod_det.sod_line)
   no-lock:

      assign
         countOfSrwkfl = countOfSrwkfl + 1
         l_ok          = no.

      for first loc_mstr
         fields (loc_domain loc_date loc_loc loc_perm loc_site loc_status)
         where   loc_domain = global_domain
         and     loc_site = sr_site
         and     loc_loc  = sr_loc
      no-lock: end.

      /* LOCKING LD_DET AND IN_MSTR TO AVOID SHIPMENT BY ANY OTHER */
      /* USER FOR A PARTICULAR ITEM                                */
      find first ld_det
         where ld_domain = global_domain
         and   ld_site = sr_site
         and   ld_loc  = sr_loc
         and   ld_part = sod_det.sod_part
         and   ld_lot  = sr_lotser
         and   ld_ref  = sr_ref
      exclusive-lock no-error.

      find first in_mstr
         where in_domain = global_domain
         and   in_part   = sod_det.sod_part
         and   in_site = sr_site
      exclusive-lock no-error.

      if available in_mstr then
      for first si_mstr
         fields (si_domain si_cur_set si_db si_entity si_git_acct si_git_cc
                 si_gl_set si_site si_status)
         where   si_domain = global_domain
         and     si_site = in_site
      no-lock: end.

      if available ld_det then
         for first is_mstr
            fields (is_domain is_avail is_nettable is_overissue is_status)
            where   is_domain = global_domain
            and     is_status = ld_status
         no-lock: end.
      else
      if available loc_mstr then
         for first is_mstr
            fields (is_domain is_avail is_nettable is_overissue is_status)
            where   is_domain = global_domain
            and     is_status = loc_status
         no-lock: end.
      else
         for first is_mstr
            fields (is_domain is_avail is_nettable is_overissue is_status)
            where   is_domain = global_domain
            and     is_status = si_status
         no-lock: end.

      if not available is_mstr then do:
         /* Inventory status not defined */
         {pxmsg.i &MSGNUM=361 &ERRORLEVEL=3}
         l_undo_flag = yes.
      end. /* IF NOT AVAILABLE IS_MSTR */

      {&SOSOISU3-P-TAG2}
      if not is_mstr.is_overissue
         and sr_qty > 0
         and (not available ld_det
              or  (l_transtype begins "I"
                   and ld_det.ld_qty_oh < (sr_qty * trans_conv)))
      then do:

         do on endkey undo, leave:

            /* MAKE SURE SUFFICIENT QTY */
            msg-arg = if available ld_det
                      then
                         string(ld_qty_oh)
                      else
                         "0".

            {pxmsg.i &MSGNUM=208 &ERRORLEVEL=2 &MSGARG1=msg-arg}
            if c-application-mode <> "API" then do:
               if not batchrun
               then
                  pause.
            end. /* IF C-APPLICATION-MODE <> "API" THEN */

            if l_recid           = recid(srwkfl)
               and countOfSrwkfl = 1
            then do:
               /* OVERISSUE FOR THIS SITE/LOCATION NOT ALLOWED */
               {pxmsg.i &MSGNUM=1283 &ERRORLEVEL=3}
               if c-application-mode <> "API" then do:
                  if not batchrun
                  then
                     pause.
               end. /* IF C-APPLICATION-MODE <> "API" THEN */
            end. /* IF L_RECID = RECID(SRWKFL) AND ... */
            else do:
               /* OVERISSUE FOR THIS SITE/LOC NOT ALLOWED: SHIP OTHER */
               /* LINES Y/N                                           */
               {pxmsg.i &MSGNUM=3492 &ERRORLEVEL=4 &CONFIRM=l_ok}
            end. /* ELSE DO */

         end. /* DO ON ENDKEY */

         {&SOSOISU3-P-TAG3}
         if l_ok
         then do:
            find first sod_det
               where sod_domain = global_domain
               and   sod_nbr    = ship_so
               and   sod_line   = ship_line
            exclusive-lock no-error.
            if available sod_det
            then
               assign
                  sod_qty_chg = sod_qty_chg - sr_qty
                  sod_bo_chg  = sod_bo_chg  + sr_qty.
         end. /* IF L_OK THEN */
         else do:
            l_undo_flag = yes.
            /* UNDOING SHIPMENT ... */
            {pxmsg.i &MSGNUM=3493 &ERRORLEVEL=1}
            undo, leave.
         end. /* ELSE DO .. */

      end. /* IF NOT IS_MSTR.IS_OVERISSUE AND .. */

   end. /* FOR EACH SRWKFL */

end. /* PROCEDURE P-INVENTORY-CHECK */
