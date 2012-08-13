/* sosomtf8.p  - SALES ORDER MAINTENANCE - CONFIGURED ITEM                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.39.3.1 $                                                               */
/*                                                                            */
/* REVISION: 7.3      LAST MODIFIED: 09/09/94   BY: afs *H510*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN90*                */
/* REVISION: 7.3      LAST MODIFIED: 11/04/94   BY: afs *FT39*                */
/* REVISION: 7.3      LAST MODIFIED: 11/11/94   BY: qzl *FT43*                */
/* REVISION: 7.4      LAST MODIFIED: 02/10/95   BY: rxm *F0HM*                */
/* REVISION: 7.4      LAST MODIFIED: 02/17/95   BY: bcm *F0JJ*                */
/* REVISION: 7.4      LAST MODIFIED: 03/07/95   BY: kjm *F0LT*                */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jpm *H0BZ*                */
/* REVISION: 7.4      LAST MODIFIED: 03/21/95   BY: rxm *F0MV*                */
/* REVISION: 7.4      LAST MODIFIED: 04/17/95   BY: jpm *H0CJ*                */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95   BY: DAH *J042*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW*                */
/* REVISION: 7.4      LAST MODIFIED: 11/01/95   BY: rxm *G1B4*                */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*                */
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: DAH *J0GT*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: DAH *J0HR*                */
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: DAH *J0N2*                */
/* REVISION: 8.5      LAST MODIFIED: 07/05/96   BY: DAH *J0XR*                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: kxn *J0YR*                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: ajw *J0Z6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *G29J* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 07/24/96   BY: *J116* Dennis Henson      */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 08/21/96   BY: *F0X9* Tony Patel         */
/* REVISION: 8.5      LAST MODIFIED: 09/13/96   BY: *G2F4* Aruna P.Patil      */
/* REVISION: 8.6      LAST MODIFIED: 10/28/96   BY: flm *K003*                */
/* REVISION: 8.6      LAST MODIFIED: 03/06/97   BY: *H0TB* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 09/12/97   BY: *H1F4* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 10/03/97   BY: *K0H6* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *K15N* Jerry Zhou         */
/* REVISION: 8.6      LAST MODIFIED: 12/08/97   by: *K1BN* Val Portugal       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2JJ* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Luke Pokic         */
/* REVISION: 9.0      LAST MODIFIED: 02/11/99   BY: *M07N* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 06/09/99   BY: *J3GV* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *M0X4* Seema Tyagi        */
/* Revision: 1.29       BY: Seema Tyagi          DATE: 12/12/00  ECO: *M0X4*  */
/* Revision: 1.30       BY: Mudit Mehta          DATE: 10/16/00  ECO: *N0WW*  */
/* Revision: 1.31       BY: Anitha Gopal         DATE: 03/15/02  ECO: *M1WM*  */
/* Revision: 1.32       BY: Jean Miller          DATE: 04/17/02  ECO: *P05M*  */
/* Revision: 1.37       BY: Anitha Gopal         DATE: 06/17/02  ECO: *N1KQ*  */
/* Revision: 1.38       BY: Nishit V             DATE: 12/23/02  ECO: *N22D*  */
/* Revision: 1.39       BY: K Paneesh            DATE: 02/06/03  ECO: *N266*  */
/* $Revision: 1.39.3.1 $         BY: Preeti Sattur        DATE: 03/18/04  ECO: *P1T4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */
/* REVISION: eb2+sp7     retrofit: 06/21/05   BY: *tfq1* tao fengqin         */

{mfdeclre.i}
/*tfq {cxcustom.i "SOSOMTF8.P"}*/
/*tfq*/  {cxcustom.i "yySOSOMTF8.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable cpex_prefix          as   character.
define new shared variable cpex_ordernbr        as   character.
define new shared variable cpex_orderline       as   integer.
define new shared variable cpex_rev_date        as   date.
define new shared variable cpex_order_due_date  as   date.
define new shared variable cpex_site            as   character.
define new shared variable cpex_ex_rate         like so_ex_rate.
define new shared variable cpex_ex_rate2        like so_ex_rate2.
define new shared variable cpex_mfg_lead        like ptp_mfg_lead.
define new shared variable cpex_last_id         as   integer.
define new shared variable config_changed       like mfc_logical
                                                initial no.
define new shared variable rfact                as   integer.
define new shared variable cf_um                like sod_um.
define new shared variable cf_um_conv           like sod_um_conv.

define shared variable sod_recno            as   recid.
define shared variable new_line             like mfc_logical.
define shared variable prev_qty_ord         like sod_qty_ord.
define shared variable sngl_ln              like soc_ln_fmt.
define shared variable line                 like sod_line.
define shared variable clines               as   integer.
define shared variable desc1                like pt_desc1.
define shared variable mult_slspsn          like mfc_logical no-undo.
define shared variable sod-detail-all       like soc_det_all.
define shared variable sodcmmts             like soc_lcmmts.
define shared variable lineffdate           like so_due_date.
define shared variable undo_all2            like mfc_logical.
define shared variable old_price            like sod_price.
define shared variable old_list_pr          like sod_list_pr.
define shared variable old_disc             like sod_disc_pct.
define shared variable picust               like cm_addr.
define shared variable pics_type            like pi_cs_type.
define shared variable part_type            like pi_part_type.
define shared variable discount             as   decimal.
define shared variable line_pricing         like mfc_logical.
define shared variable reprice_dtl          like mfc_logical.
define shared variable new_order            like mfc_logical.
define shared variable cf_config            like mfc_logical.
define shared variable cf_error_bom         like mfc_logical.
define shared variable cf_rm_old_bom        like mfc_logical.
define shared variable soc_pt_req           like mfc_logical.
define shared variable prev_site            like sod_site.
define shared variable sonbr                like sod_nbr.
define shared variable soline               like sod_line.
define shared variable so_db                like dc_name.
define shared variable err-flag             as   integer.

define shared frame c.
define shared frame d.
define shared frame bom.

define variable cpex_sod_part        like sod_part.
define variable config_edited        like mfc_logical.
define variable modify_sob           like mfc_logical initial no
                                                label "Review Bill".
define variable save_sod_price       like sod_price.
define variable yn                   like mfc_logical.
define variable pcqty                like sod_qty_ord.
define variable match_pt_um          like mfc_logical.
define variable minprice             like pc_min_price.
define variable maxprice             like pc_min_price.
define variable pc_recno             as   recid.
define variable warning              like mfc_logical initial no.
define variable warmess              like mfc_logical initial yes.
define variable minmaxerr            like mfc_logical.
define variable par_absid            like abs_id no-undo.
define variable par_shipfrom         like abs_shipfrom no-undo.
define variable prev_qty_req         like sob_qty_req.
define variable sobparent            like sob_parent.
define variable sobfeature           like sob_feature.
define variable sobpart              like sob_part.
define variable update_accum_qty     like mfc_logical.
define variable err_flag             as   integer.
define variable frametitle           as   character.
define variable cfg                  like sod_cfg_type format "x(3)" no-undo.
define variable cfglabel             as character format "x(24)"
                                                label "" no-undo.
define variable cfgcode              as character format "x(1)" no-undo.
define variable valid_mnemonic       like mfc_logical no-undo.
define variable valid_lngd           like mfc_logical no-undo.
define variable disc_pct_err         as   decimal.
define variable disc_min_max         like mfc_logical.
define variable mc-error-number      like msg_nbr no-undo.

define buffer abs_tmp for abs_mstr.

{&SOSOMTF8-P-TAG1}
{rcinvtbl.i new}  /* PRE-SHIPPER/SHIPPER VARIABLES */
{rcinvcon.i}      /* INTERNAL PROCEDURES FOR PRE-SHIPPERS/SHIPPERS */
{pppivar.i }      /*SHARED VARIABLES FOR PRICING ROUTINE*/
{pppiwkpi.i }     /*PRICING WORKFILE DEFINITIONS*/
{pppiwqty.i }     /*ACCUM QTY WORKFILES DEFINITIONS*/
/*tfq*/ {yysolinfrm.i} 
/*tfq {solinfrm.i} */ /* DEFINE SHARED FORMS FOR LINE DETAIL */

if can-find(first lngd_det
            where lngd_lang = global_user_lang
            and   lngd_dataset = "pt_mstr"
            and   lngd_field = "pt_cfg_type")
then
   valid_lngd = yes.
else
   valid_lngd = no.

form
   sod_sob_std colon 17
   sod_sob_rev colon 17 label "Effective"
   sod_fa_nbr  colon 17
   space(2)
   sod_lot     colon 17
   cfg         colon 17
with frame bom overlay attr-space side-labels row 9 column 25.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bom:handle).

form
   modify_sob  colon 17
   sod_sob_rev colon 17 label "Effective"
   sod_fa_nbr  colon 17
   space(2)
   sod_lot     colon 17
   cfg         colon 17
with frame bom1 overlay attr-space side-labels row 9 column 25.

/* SET EXTERNAL LABELS */
setFrameLabels(frame bom1:handle).

for first pic_ctrl
fields(pic_so_fact pic_so_rfact)
no-lock: end.

if pic_so_fact then
   rfact = pic_so_rfact.
else
   rfact = pic_so_rfact + 2.

find sod_det where recid(sod_det) = sod_recno
exclusive-lock no-error.

for first so_mstr
fields(so_curr so_cust so_ex_rate so_ex_rate2 so_nbr)
   where so_nbr = sod_nbr
no-lock: end.

assign
   cpex_prefix         = ""
   cpex_ordernbr       = sod_nbr
   cpex_orderline      = sod_line
   cpex_rev_date       = sod_sob_rev
   cpex_order_due_date = sod_due_date
   cpex_site           = sod_site
   cpex_ex_rate        = so_ex_rate
   cpex_ex_rate2       = so_ex_rate2
   cpex_mfg_lead       = 0
   cpex_sod_part       = sod_part
   cpex_last_id        = 0.

/* GET LAST SOB_DET RECORD IDENTIFIER */
{gprun.i ""sosomtf7.p""}

for first pt_mstr
fields(pt_abc        pt_avg_int   pt_bom_code  pt_cfg_type pt_cyc_int
       pt_desc1      pt_desc2     pt_insp_lead pt_insp_rqd pt_joint_type
       pt_loc        pt_mfg_lead  pt_mrp       pt_network  pt_ord_max
       pt_ord_min    pt_ord_mult  pt_ord_per   pt_ord_pol  pt_ord_qty
       pt_part       pt_plan_ord  pt_pm_code   pt_price    pt_prod_line
       pt_promo      pt_pur_lead  pt_rctpo_active          pt_rctpo_status
       pt_rctwo_active            pt_rctwo_status pt_routing
       pt_sfty_time  pt_timefence pt_um        pt_yield_pct)
   where pt_part = sod_part
no-lock: end.

if available pt_mstr
then
   cpex_mfg_lead = pt_mfg_lead.

for first ptp_det
fields(ptp_bom_code   ptp_cfg_type ptp_ins_lead ptp_ins_rqd
       ptp_joint_type ptp_mfg_lead ptp_network  ptp_ord_max
       ptp_ord_min    ptp_ord_mult ptp_ord_per  ptp_ord_pol
       ptp_ord_qty    ptp_part     ptp_plan_ord ptp_pm_code
       ptp_pur_lead   ptp_routing  ptp_sfty_tme ptp_site
       ptp_timefnce   ptp_yld_pct)
   where ptp_part = sod_part
   and   ptp_site = sod_site
no-lock: end.

if available ptp_det
then
   cpex_mfg_lead = ptp_mfg_lead.

/* FOR NON-EMT ORDER LINE, ON SITE CHANGE IF THE ITEM IN NEW SITE */
/* IS CONFIGURED THEN DELETE SALES ORDER BILL RECORDS (sob_det),  */
/* ALLOCATION DETAIL RECORDS (lad_det), COST RECORDS (sct_det);   */
/* UPDATES FORECAST AND MRP DETAIL (mrp_det) AND UPDATES          */
/* INVENTORY DETAIL BY LOCATION (ld_det) FOR PREVIOUS SITE        */

if not new_line
   and prev_site <> sod_site
   and sod_btb_type = "01"
   and not ((can-find (first pt_mstr
                where pt_part    =  sod_part
                and   pt_pm_code <> "c" )
      or can-find (first ptp_det
                   where ptp_part    =  sod_part
                   and   ptp_site    =  prev_site
                   and   ptp_pm_code <> "c"))
      and (can-find (first ptp_det
                     where ptp_part    =  sod_part
                     and   ptp_site    =  sod_site
                     and   ptp_pm_code <> "c" )))
then do:

   assign
      sonbr  = sod_nbr
      soline = sod_line.

   /* WE DON'T CREATE THE REMOTE LINES UNLESS THE LINE IS CONFIRMED */

   for first si_mstr
      fields(si_cur_set si_db   si_entity si_git_acct si_git_cc si_git_sub
             si_gl_set  si_site si_status)
      where si_site = prev_site
      no-lock:
   end. /* FOR FIRST si_mstr */

   if so_db <> si_db
      and sod_confirm
   then do:
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }

      if err-flag    = 0
         or err-flag = 9
      then do:
         {gprun.i ""solndel.p""
                  "(input no)"}
      end. /* IF err-flag */

      /* RESET THE DB ALIAS TO THE SALES ORDER DATABASE */
      {gprun.i ""gpalias3.p""
                "(so_db, output err-flag)" }

      sod_recno = recid(sod_det).
   end. /* IF AVAILABLE so_mstr */

   else do:
      {gprun.i ""solndel1.p""}
   end. /* ELSE DO */

end. /* IF NOT new_line */

for first si_mstr
   fields(si_cur_set si_db   si_entity si_git_acct si_git_cc si_git_sub
          si_gl_set  si_site si_status)
   where si_site = sod_site
   no-lock:
end. /* FOR FIRST si_mstr */

if not new_line
   and prev_site <> sod_site
   and sod_btb_type = "01"
   and (can-find (first ptp_det
                     where ptp_part    = sod_part
                     and   ptp_site    = sod_site
                     and   ptp_pm_code = "c")
        or can-find (first pt_mstr
                        where pt_part    = sod_part
                        and   pt_pm_code = "c"))
then do:
  if available ptp_det
  then
      sod_cfg_type = ptp_cfg_type.
   else if available pt_mstr
   then
      sod_cfg_type = pt_cfg_type.

   /* IF SALES ORDER LINE ITEM IS KIT THEN ASSIGN QTY ALLOACTED */
   /* TO ZERO                                                   */

   if sod_cfg_type = "2"
   then
      sod_qty_all = 0.

   assign
      reprice_dtl = yes
      modify_sob  = yes.
end. /* IF NOT new_line */

for first soc_ctrl
fields (soc_apm)
no-lock: end.

if soc_apm then
for first cm_mstr
fields (cm_promo)
   where cm_addr = so_cust
no-lock: end.

/* IF PARAMETER IS YES, THEN UPDATE "accum qty" WORKFILES */
/* BEFORE PROCESSING DISCOUNT TYPE PRICE LISTS */
if line_pricing or not new_order then
   update_accum_qty = yes.
else
   update_accum_qty = no.

/* PROMPT FOR CONFIGURATION IF NEW LINE */
/* OR FOR NON-EMT ORDER LINE, ON SITE CHANGE IF THE ITEM */
/* IN NEW SITE IS CONFIGURED                             */
/* FOR CALICO CONFIGURED ITEMS THE USER IS NOT TO BE PROMPTED WITH */
/* STD. BILL AS THE USER HAS BUILT THE CONFIGURATION THEY WILL BE  */
/* PROMPTED IF THEY WISH TO REVIEW THE BILL.                       */
if (new sod_det or prev_qty_ord = 0)
or (cf_config and cf_rm_old_bom)
or (not new_line and prev_site <> sod_site
    and sod_btb_type = "01"
    and (can-find (first ptp_det
                   where ptp_part    =  sod_part
                   and   ptp_site    =  sod_site
                   and   ptp_pm_code = "c")
          or can-find (first pt_mstr
                       where pt_part    =  sod_part
                       and   pt_pm_code = "c")))
then do:

   assign
      sod_sob_rev   = sod_due_date
      cpex_rev_date = sod_due_date.

   /* GET THE COST FROM REMOTE DB IF NECESSARY */
   {gprun.i ""gpsct05x.p""
      "(pt_part, sod_site, 1,
        output glxcst, output curcst)" }

   sod_std_cost = glxcst * sod_um_conv.
   if sod_qty_ord <> 0
   then do:
      if sod_due_date <> ?
      then
         sod_sob_rev = sod_due_date.
      else
         sod_sob_rev = today.
      pause 0.
      sod_sob_std = yes.

      if cf_config
      then do:

         modify_sob = no.

         pause 0.

         display
            modify_sob
            sod_sob_rev
            sod_fa_nbr
            sod_lot
         with frame bom1.

         set
            modify_sob
         with frame bom1.

         if (sod_fa_nbr > "" or sod_lot > "") and
            ((prev_qty_ord <> sod_qty_ord * sod_um_conv and prev_qty_ord <> 0)
            or modify_sob)
         then do:
            /* LINE ITEM ALREADY RELEASED TO FAS */
            {pxmsg.i &MSGNUM=420 &ERRORLEVEL=2}
         end. /* IF (sod_fa_nbr > "" */

         hide frame bom1.

      end. /* IF cf_config */

      if new sod_det and available ptp_det then
         sod_cfg_type = ptp_cfg_type.
      else
      if new sod_det and available pt_mstr then
         sod_cfg_type = pt_cfg_type.

      assign
         cfg = sod_cfg_type
         cfglabel = ""
         cfgcode = "".

      /* GET MNEMONIC cfg AND cfglabel FROM LNGD_DET */
      {gplngn2a.i &file     = ""pt_mstr""
                  &field    = ""pt_cfg_type""
                  &code     = sod_cfg_type
                  &mnemonic = cfg
                  &label    = cfglabel}

      display
         sod_sob_std
         sod_sob_rev
         cfg
         sod_fa_nbr
         sod_lot
      with frame bom.

      set
         sod_sob_std
         sod_sob_rev
         cfg
      with frame bom.

      /* VALIDATE CFG MNEMONIC AGAINST LNGD_DET */
      if valid_lngd
      then do:
         {gplngv.i &file     = ""pt_mstr""
                   &field    = ""pt_cfg_type""
                   &mnemonic = cfg
                   &isvalid  = valid_mnemonic}

         if not valid_mnemonic
         then do:
            /* INVALID CHARACTER */
            {pxmsg.i &MSGNUM=3093 &ERRORLEVEL=3}
            next-prompt
               cfg
            with frame bom.
            undo, retry.
         end. /* IF NOT valid_mnemonic */

         /* GET cfgcode & cfglabel FROM LNGD_DET */
         {gplnga2n.i &file     = ""pt_mstr""
                     &field    = ""pt_cfg_type""
                     &mnemonic = cfg
                     &code     = cfgcode
                     &label    = cfglabel}

      end. /* IF valid_lngd */

      if valid_lngd and available lngd_det
      then
         sod_cfg_type = cfgcode.
      else
         sod_cfg_type = cfg.

      hide frame bom.

      cpex_rev_date = sod_sob_rev.

      /* FOLLOWING 2 MESSAGE STATEMENTS CAUSE A PAUSE IF ANY */
      /* MESSAGES ARE ON THE SCREEN ALREADY*/
      message.
      message.

      /* CREATE SO BILL RECORDS */
      if cf_config then
         assign
            cf_um = sod_um
            cf_um_conv = sod_um_conv.

      if new sod_det
         or prev_qty_ord = 0
         or cf_rm_old_bom
         or (not new_line and prev_site <> sod_site
             and sod_btb_type = "01"
             and (can-find (first ptp_det
                            where ptp_part    = sod_part
                            and   ptp_site    = sod_site
                            and   ptp_pm_code = "c")
                  or can-find (first pt_mstr
                               where pt_part    = sod_part
                               and   pt_pm_code = "c")))
      then
         {gprun.i ""sosomtf1.p""
            "(input sod_part,
              input """",
              input sod_qty_ord * sod_um_conv,
              input 0,
              input cpex_sod_part)"}

      if cf_config and cf_error_bom
      then do:
         undo_all2 = true.
         leave.
      end. /* IF cf_config */

      /* CALCULATE THE PRICE OF THE RESULTING CONFIGURATION */
      {gprun.i ""sopccala.p"" "(update_accum_qty, yes)"}

      /* CHECK IF CONFIGURATION NEEDS REPRICING DUE "ACCUM QTY" */
      /* CAPABILITY OF BEST PRICING */
      find first wrep_wkfl
         where wrep_line = sod_line
         and   wrep_part = sod_part
         and   wrep_parent
         and   wrep_rep
      exclusive-lock no-error.

      if available wrep_wkfl
      then
         /* FORCES REPRICING DURING RECONFIG */
         assign
            config_edited  = yes
            config_changed = yes
            wrep_rep       = no.

      if not cf_config
      then do:

         if sod_sob_std = no
         then do:
            /* EDIT SO BILL */
            {gprun.i ""sosomtf2.p""
               "(input sod_part,
                 input """",
                 input sod_qty_ord * sod_um_conv, input 0,
                 input cpex_sod_part)"}
            config_edited = yes.
         end. /* IF sod_sob_std = no */

      end. /* IF NOT cf_config */

      else do:

         if modify_sob then do:
            {gprun.i ""sosomtf2.p""
               "(input sod_part,
                 input """",
                 input sod_qty_ord * sod_um_conv, input 0,
                 input cpex_sod_part)"}

            config_edited = yes.
         end. /* IF modify_sob */

      end. /* IF NOT cf_config */

   end. /* IF sod_qty_ord <> 0 */

   if sngl_ln then
      display
       /*tfq  sod_std_cost */
         sod_um_conv
   with frame d.

end. /* IF (new sod_det */

/* REVIEW CONFIGURATION IF OLD CONFIGURED PART */
else do:
   if sod_qty_ord = 0
   then do:

      for each sob_det
         where sob_nbr  = sod_nbr
         and   sob_line = sod_line
      exclusive-lock:

         /*UPDATE ACCUM QTY WORKFILES WITH REVERSAL*/
         if line_pricing or not new_order
         then do:
            /* QUALIFIED THE QTY (sob_qty_req) AND EXTENDED LIST    */
            /* (sob_qty_req * sob_tot_std) PARAMETERS TO DIVIDE BY  */
            /* U/M CONVERSION RATIO SINCE THESE INCLUDE THIS FACTOR */
            /* ALREADY.                                             */
            {gprun.i ""gppiqty2.p""
               "(sod_line,
                 sob_part,
                 - (sob_qty_req / sod_um_conv),
                 - (sob_qty_req * sob_tot_std / sod_um_conv),
                 sod_um,
                 no,
                 yes,
                 yes)"}
         end. /* IF line_pricing  */

         {inmrp.i &part=sob_part &site=sob_site}
         {mfmrwdel.i "sob_det" sob_part sob_nbr
            "string(sob_line) + ""-"" + sob_feature" sob_parent }

         delete sob_det.

      end. /* FOR EACH sob_det EXCLUSIVE-LOCK */

      /* Get the cost from remote db if necessary */
      {gprun.i ""gpsct05x.p""
         "(pt_part, sod_site, 1,
           output glxcst, output curcst)" }

      sod_std_cost = glxcst * sod_um_conv.

      /* DELETE ALL RELATED PRICE LIST HISTORY AND CURRENT  */
      /* PRICE LIST WORKFILE ENTRIES FOR THIS SALES ORDER   */
      /* BILL.  SET sod_list_pr TO THE VALUE OF THE PARENT  */
      /* LIST PRICE AND UPON RETURN TO THE CALLING PROCEDURE*/
      /* SUBSEQUENT PROCESSING WILL RESULT IN NO DISCOUNTS  */
      /* AND LIST AND NET PRICES WILL BE THE SAME.          */

      sod_list_pr = 0.

      for each pih_hist
         where pih_doc_type = 1
         and   pih_nbr      = sod_nbr
         and   pih_line     = sod_line
      exclusive-lock:
         if pih_amt_type = "1" and pih_option = "" then
            sod_list_pr  = pih_amt.
         else
            delete pih_hist.
      end. /* FOR EACH pih_hist */

      for each wkpi_wkfl exclusive-lock:
         if wkpi_amt_type = "1" and wkpi_option = ""
         then
            sod_list_pr = wkpi_amt.
         else
            delete wkpi_wkfl.
      end. /* FOR EACH wkpi_wkfl */

      assign                      /*make sure nothing else happens*/
         exclude_confg_disc = no  /*upon returning to the calling */
         select_confg_disc  = no  /*procedure.                    */
         found_confg_disc   = no
         sod_disc_pct       = 0
         sod_price          = sod_list_pr.

      /*DETERMINE DISCOUNT DISPLAY FORMAT*/
      {gppidisc.i pic_so_fact sod_disc_pct pic_so_rfact}

      display
         sod_list_pr
         discount
         sod_price
      with frame c.

   end. /* IF sod_qty_ord = 0 */

   else do:
      if prev_qty_ord <> sod_qty_ord * sod_um_conv
         and prev_qty_ord <> 0
      then do:

         for each sob_det
            where sob_nbr = sod_nbr
              and sob_line  = sod_line
         exclusive-lock:

            assign
               /* UPDATE ACCUM QTY WORKFILES WITH DIFFERENCE */
               prev_qty_req = sob_qty_req
               sob_qty_req  = sob_qty_req * sod_qty_ord
                            * sod_um_conv / prev_qty_ord
               substring(sob_serial,17,18) =
                  string(sob_qty_req,"-9999999.999999999").

            if line_pricing or not new_order
            then do:
               /* QUALIFIED THE QTY (sob_qty_req) AND EXTENDED LIST    */
               /* (sob_qty_req * sob_tot_std) PARAMETERS TO DIVIDE BY  */
               /* U/M CONVERSION RATIO SINCE THESE INCLUDE THIS FACTOR */
               /* ALREADY.                                             */
               {gprun.i ""gppiqty2.p""
                  "(sod_line,
                    sob_part,
                    (sob_qty_req - prev_qty_req) / sod_um_conv,
                    (sob_qty_req - prev_qty_req) * sob_tot_std / sod_um_conv,
                    sod_um,
                    no,
                    yes,
                    yes)"}
            end. /* IF line_pricing */
         end. /* FOR EACH sob_det */

         assign
            config_changed = yes
            config_edited  = yes.
      end. /* IF prev_qty_ord <> sod_qty_ord * sod_um_conv */

      /*!      *******************************************
      sob_serial subfield positions:
      1-4     operation number (old - now 0's)
      5-10    scrap percent
      11-14   id number of this record
      15-15   structure code
      16-16   "y" (indicates "new" format sob_det record)
      17-34   original qty per parent
      35-35   original mandatory indicator (y/n)
      36-36   original default indicator (y/n)
      37-39   leadtime offset
      40-40   price manually updated (y/n)
      41-46   operation number (new - 6 digits)
      *******************************************/

      for first sob_det
      fields(sob_feature sob_line   sob_nbr  sob_parent sob_part
             sob_qty_req sob_serial sob_site sob_tot_std)
         where sob_nbr  = sod_nbr
         and   sob_line = sod_line no-lock:
      end. /* FOR FIRST SOB_DET */

      pause 0.
      modify_sob = no.

      /* ALLOW FOR CONFIGURATION MODIFICATION ONLY IF REPRICING  */
      /* IS YES.  OTHERWISE IF A CONFIGURATION CHANGE OCCURS (ADD*/
      /* AN OPTION, DELETE AN OPTION, SETTING QTY TO 0, WILL     */
      /* REFLECT IN A CHANGE TO THE LINE ITEM LIST AND NET PRICE */
      /* WHICH WILL NOT BE REFLECTED IN PRICE LIST HISTORY.  IF  */
      /* PRICE LIST HISTORY IS NOT MAINTAINED, THEN WHEN POSTING */
      /* TO THE G/L, DISCOUNTS WILL BE OUT OF BALANCE.           */
      if reprice_dtl or new_order
      then do:

         assign
            cfg      = sod_cfg_type
            cfglabel = ""
            cfgcode  = "".

         /* GET MNEMONIC CFG AND cfglabel FROM LNGD_DET */
         {gplngn2a.i &file     = ""pt_mstr""
                     &field    = ""pt_cfg_type""
                     &code     = sod_cfg_type
                     &mnemonic = cfg
                     &label    = cfglabel}

         display
            modify_sob
            sod_sob_rev
            cfg
            sod_fa_nbr
            sod_lot
        with frame bom1.

         set
            modify_sob
         with frame bom1.

         /* UPDATE CONFIGURATION TYPE IF NOT CONFIRMED */
         if sod_confirm = no
         then do:

            set
               cfg
            with frame bom1.

            /* VALIDATE CFG MNEMONIC AGAINST LNGD_DET */
            if valid_lngd
            then do:

               {gplngv.i &file     = ""pt_mstr""
                         &field    = ""pt_cfg_type""
                         &mnemonic = cfg
                         &isvalid  = valid_mnemonic}

               if not valid_mnemonic
               then do:
                  /* INVALID CHARACTER */
                  {pxmsg.i &MSGNUM=3093 &ERRORLEVEL=3}
                  next-prompt cfg with frame bom.
                  undo, retry.
               end. /* IF NOT valid_mnemonic */

               /* GET cfgcode & cfglabel FROM LNGD_DET */
               {gplnga2n.i &file     = ""pt_mstr""
                           &field    = ""pt_cfg_type""
                           &mnemonic = cfg
                           &code     = cfgcode
                           &label    = cfglabel}
            end. /* IF valid_lngd */

            if valid_lngd and available lngd_det then
               sod_cfg_type = cfgcode.
            else
               sod_cfg_type = cfg.

         end. /* IF sod_confirm = no */

         if modify_sob
         then do:

            absloop:
            for each abs_mstr
               where abs_shipfrom = sod_site
               and   abs_order    = sod_nbr
               and   abs_line = string(sod_line)
            no-lock:

               run get_abs_parent
                 (input abs_mstr.abs_id,
                  input abs_mstr.abs_shipfrom,
                  output par_absid,
                  output par_shipfrom).

               if par_absid <> ? then do:

                  for first abs_tmp
                  fields(abs_canceled abs_dataset abs_id       abs_line
                         abs_order    abs_par_id  abs_shipfrom abs_status)
                     where abs_tmp.abs_shipfrom = par_shipfrom
                     and   abs_tmp.abs_id       = par_absid
                  no-lock: end.

                  if available abs_tmp
                     and (abs_tmp.abs_canceled = no
                     or substring(abs_tmp.abs_status,2,1) <> "y")
                  then do:
                     /* PRE-SHIPPER/SHIPPER EXISTS FOR FOR THIS LINE */
                     {pxmsg.i &MSGNUM=5934 &ERRORLEVEL=2}
                     pause.
                     leave absloop.
                  end. /* IF AVAILABLE abs_tmp */

               end. /* IF par_absid <> ? */

            end. /* FOR EACH abs_mstr WHERE abs_shipfrom = sod_site */

         end. /* IF modify_sob  */

         hide frame bom1.

      end. /* if reprice_dtl */

      if modify_sob then do:
         if sngl_ln then hide frame d.

         config_edited = yes.

         {gprun.i ""sosomtf2.p""
            "(input sod_part,
              input """",
              input sod_qty_ord * sod_um_conv,
              input 0,
              input cpex_sod_part)"}

         if sngl_ln then view frame d.
      end. /* IF modify_sob */

      /* REPRICE CURRENT CONFIGURATION */
      else if line_pricing or reprice_dtl
      then do:

         /* GET THE COST FROM REMOTE DB IF NECESSARY */
         {gprun.i ""gpsct05x.p""
            "(pt_part, sod_site, 1,
              output glxcst, output curcst)" }

         sod_std_cost = glxcst * sod_um_conv.

         /* CHANGED PARAMETER FROM "update_accum_qty" TO "no"*/
         {gprun.i ""sopccala.p"" "(no, yes)"}

      end. /* ELSE IF line_pricing */

   end. /* ELSE DO */

end. /* else do */

/* REPRICE COMPLETE CONFIGURATION */

if (line_pricing or reprice_dtl)and config_edited
then do:

   /* INITIALIZE PRICING VARIABLES */

   assign
      best_list_price = 0
      best_net_price  = 0
      min_price       = 0
      max_price       = 0.

   /* INITIALIZE PRICING WORKFILE, RETAIN ANY MANUAL ENTRIES */
   {gprun.i ""gppiwkdl.p"" "(1)"}

   /* GET BEST LIST TYPE PRICE LIST, SET MIN/MAX FIELDS */

   assign
      sobparent  = ""
      sobfeature = ""
      sobpart    = "".

   /* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM
    * THEN CALL THE APM PRICE LIST SELECTION ROUTINE        */
   if soc_apm
      and available cm_mstr
      and cm_promo <> ""
      and pt_promo <> ""
   then do:
      {gprun.i ""gppiapm1.p""
         "(pics_type,
           picust,
           part_type,
           sod_part,
           sobparent,
           sobfeature,
           sobpart,
           1,
           so_curr,
           sod_um,
           sod_pricing_dt,
           soc_pt_req,
           sod_site,
           so_ex_rate,
           so_ex_rate2,
           sod_nbr,
           sod_line,
           sod_div,
           output err_flag)"}
   end. /* IF SOC_APM */

   else do: /* IF NOT SOC_APM */
      {gprun.i ""gppibx.p""
         "(pics_type,
           picust,
           part_type,
           sod_part,
           sobparent,
           sobfeature,
           sobpart,
           1,
           so_curr,
           sod_um,
           sod_pricing_dt,
           soc_pt_req,
           sod_site,
           so_ex_rate,
           so_ex_rate2,
           sod_nbr,
           sod_line,
           output err_flag)"}
   end. /* IF NOT SOC_APM */

   /* TEST FOR REQUIRED PRICE LIST BASED ON MATCHING PART# AND UM
      OR IF ANY LIST TYPE PRICE LIST WAS FOUND*/

   if soc_pt_req
   or best_list_price = 0
   then do:

      find first wkpi_wkfl where wkpi_parent   = ""
         and wkpi_feature  = ""
         and wkpi_option   = ""
         and wkpi_amt_type = "1"
      no-lock no-error.

      if soc_pt_req then do:

         if not available wkpi_wkfl
         then do:
            /* PRICE TABlE FOR sod_part IN sod_um NOT FOUND */
            {pxmsg.i &MSGNUM=6231 &ERRORLEVEL=3
                     &MSGARG1=sod_part &MSGARG2=sod_um}
            if not batchrun
            then
               pause.
            undo, return.
         end. /* IF NOT AVAILABLE wkpi_wkfl */

      end. /* IF soc_pt_req */

      if best_list_price = 0
      then do:

         if not available wkpi_wkfl
         then do:

            if available pt_mstr
            then do:

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input so_curr,
                    input so_ex_rate2,
                    input so_ex_rate,
                    input pt_price * sod_um_conv,
                    input false,
                    output best_list_price,
                    output mc-error-number)"}.

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end. /* IF mc-error-number <> 0 */

               /* CREATE LIST TYPE PRICE LIST RECORD IN wkpi_wkfl */
               {gprun.i ""gppiwkad.p""
                  "(sod_um,
                    sobparent,
                    sobfeature,
                    sobpart,
                    ""4"",
                    ""1"",
                    best_list_price,
                    0,
                    no)"}
            end. /* IF AVAILABLE pt_mstr */

            else do:
               /* CREATE LIST TYPE PRICE LIST RECORD IN wkpi_wkfl  */
               /* FOR MEMO TYPE */
               best_list_price = sod_list_pr.
               {gprun.i ""gppiwkad.p""
                  "(sod_um,
                    sobparent,
                    sobfeature,
                    sobpart,
                    ""7"",
                    ""1"",
                    best_list_price,
                    0,
                    no)"}
            end. /* ELSE DO */

         end. /* IF NOT AVAILABLE wkpi_wkfl */
         else
            best_list_price = wkpi_amt.

      end. /* IF best_list_price = 0 */

   end. /* IF soc_pt_req */

   assign
      sod_list_pr = best_list_price
      sod_price   = best_list_price.

   /*CALCULATE TERMS INTEREST*/
   if sod_crt_int <> 0 and
      (available pt_mstr or sod_type <> "")
   then do:

      assign
         sod_list_pr     = (100 + sod_crt_int) / 100 * sod_list_pr
         sod_price       = sod_list_pr
         best_list_price = sod_list_pr.

      /* CREATE CREDIT TERMS INTEREST wkpi_wkfl RECORD */
      {gprun.i ""gppiwkad.p""
         "(sod_um,
           sobparent,
           sobfeature,
           sobpart,
           ""5"",
           ""1"",
           sod_list_pr,
           0,
           no)"}
   end. /* IF sod_crt_int <> 0 */

   parent_list_price = best_list_price. /*gppiwk02.p needs this*/

   /* GET BEST DISCOUNT TYPE PRICE LISTS */

   /* IF APM IS IN USE AND CUSTOMER AND ITEM ARE USED BY APM
    * THEN CALL THE APM PRICE LIST SELECTION ROUTINE        */
   if soc_apm
      and available cm_mstr
      and cm_promo <> ""
      and pt_promo <> ""
   then do:
      {gprun.i ""gppiapm1.p""
         "(pics_type,
           picust,
           part_type,
           sod_part,
           sobparent,
           sobfeature,
           sobpart,
           2,
           so_curr,
           sod_um,
           sod_pricing_dt,
           no,
           sod_site,
           so_ex_rate,
           so_ex_rate2,
           sod_nbr,
           sod_line,
           sod_div,
           output err_flag)"}
   end. /* IF SOC_APM */

   else do: /* IF NOT SOC_APM*/
      {gprun.i ""gppibx.p""
         "(pics_type,
           picust,
           part_type,
           sod_part,
           sobparent,
           sobfeature,
           sobpart,
           2,
           so_curr,
           sod_um,
           sod_pricing_dt,
           no,
           sod_site,
           so_ex_rate,
           so_ex_rate2,
           sod_nbr,
           sod_line,
           output err_flag)"}
   end. /* IF NOT SOC_APM */

   /* CALCULATE BEST PRICE */
   {gprun.i ""gppibx04.p""
      "(sobparent,
        sobfeature,
        sobpart,
        no,
        rfact)"}

   assign
      sod_price    = best_net_price
      sod_list_pr  = best_list_price
      sod_disc_pct = if sod_list_pr <> 0
                     then
                        (1 - (sod_price / sod_list_pr)) * 100
                     else
                        0.

   /* GET THE COST FROM REMOTE DB IF NECESSARY */
   {gprun.i ""gpsct05x.p""
      "(pt_part, sod_site, 1,
        output glxcst, output curcst)" }

   sod_std_cost = glxcst * sod_um_conv.

   {gprun.i ""sopccala.p"" "(no, yes)"}

  /*tfq if sngl_ln then
      display
         sod_std_cost
      with frame d.    */

end. /* line_pricing OR reprice_dtl AND config_edited */

/* ADDED CODE TO DELETE THE WORKFILE FOR DELETED/DESELECTED */
/* COMPONENT INCASE OF CONFIGURED ITEMS WHEN THERE IS NO    */
/* MANUAL OVERRIDE.                                         */

for each wkpi_wkfl
exclusive-lock:
   if not can-find(first sob_det
      where sob_nbr  = sod_nbr
      and   sob_part = wkpi_option)
   then
      delete wkpi_wkfl.
end.  /* FOR EACH wkpi_wkfl */

undo_all2 = false.  /* FLAG SUCCESSFUL COMPLETION OF THIS ROUTINE */

