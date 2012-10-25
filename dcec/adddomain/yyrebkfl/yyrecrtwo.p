/* recrtwo.p - REPETITIVE                                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: WUG *GN98*                */
/* REVISION: 7.3      LAST MODIFIED: 12/02/94   BY: emb *GO69*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: rmh *J04R*                */
/* REVISION: 7.3      LAST MODIFIED: 08/23/95   BY: dzs *G0TL*                */
/* REVISION: 7.3      LAST MODIFIED: 10/25/95   BY: str *G1B2*                */
/* REVISION: 8.5      LAST MODIFIED: 03/02/96   BY: bxw *J0DM*                */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: *G1VW* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 09/04/96   BY: *G2DH* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 11/20/96   by: *G2J5* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *L0Y1* Kirti Desai        */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.19     BY: Irine D'Mello  DATE: 09/10/01  ECO: *M164*          */
/* $Revision: 1.20 $   BY: Kedar Deherkar DATE: 01/03/03  ECO: *M1R2*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SUBPROGRAM TO CREATE A CUM WORKORDER AND CALCULATE OPERATION COSTS         */

/* THE CREATION OF wo_mstr IS MADE SINGLE THREADED. THIS IS DONE IN ORDER TO */
/* PREVENT CREATION OF 2 DIFFERENT CUMULATIVE ORDERS, WHEN BOTH THE USERS    */
/* (AT DIFFERENT OPERATIONS) TRY TO REPORT PRODUCTION AT THE SAME TIME FOR   */
/* THE SAME PART/SITE/PRODUCTION LINE COMBINATION.                           */

/* qadlock (BUFFER OF qad_wkfl) IS USED FOR THIS PURPOSE. THE LOGIC IS       */
/* DIVIDED INTO 2 TRANSACTIONS. THE FIRST TRANSACTION DEALS WITH CREATION OF */
/* qadlock RECORD FOR PART/SITE/PRODUCTION LINE. SECOND TRANSACTION INCLUDES */
/* wo_mstr CREATION LOGIC. USER LOCKS qadlock RECORD AT START OF THE SECOND  */
/* TRANSACTION. IT RELEASES THE LOCK ON qadlock AT THE END OF THE SECOND     */
/* TRANSACTION. THIS ENSURES THAT ONLY ONE USER CAN EXECUTE wo_mstr CREATION */
/* LOGIC AT A TIME.                                                          */

/* LIMITATION : PROGRESS ERROR IS DISPLAYED WHEN 2 USERS TRY TO CREATE       */
/*              qadlock AT THE SAME TIME. PAUSE 0-USED TO SUPPRESS THE ERROR.*/

/* NOTE : ANY CHANGES IN TRANSACTION SCOPE OF THE CALLING PROGRAM OR THIS    */
/*        PROGRAM MAY AFFECT THIS FUNCTIONALITY.                             */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE recrtwo_p_1 "Include Yield"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* IF THIS PROGRAM RETURNS ? IN WOLOT, THEN THAT ITEM IS RESTRICTED   */
/* FOR THIS PROCEDURE, YOU MUST TEST FOR THIS IN YOUR CALLING PROGRAM */
{mfdeclre.i}
{pxmaint.i}

{pxphdef.i wocmnrtn}

define input parameter site as character no-undo.
define input parameter part as character no-undo.
define input parameter eff_date as date  no-undo.
define input parameter line as character no-undo.
define input parameter routing as character  no-undo.
define input parameter bom_code as character no-undo.
define output parameter wolot as character   no-undo.

define variable bdn_ll   as decimal     no-undo.
define variable cur_mthd like cs_method no-undo.
define variable cur_set  like cs_set    no-undo.
define variable earliest_begin_date as date no-undo.
define variable eff_dflt as character   no-undo.
define variable glx_mthd like cs_method no-undo.
define variable glx_set  like cs_set    no-undo.
define variable latest_end_date as date no-undo.
define variable lbr_ll   as decimal     no-undo.
define variable matl_cost as decimal    no-undo.
define variable mm       as integer     no-undo.
define variable mtl_ll   as decimal     no-undo.
define variable run_labor as decimal    no-undo.
define variable run_burden as decimal   no-undo.
define variable setup_labor as decimal  no-undo.
define variable setup_burden as decimal no-undo.
define variable sub_ll       as decimal no-undo.
define variable temp_bom_code as character no-undo.
define variable temp_routing  as character no-undo.
define variable yy            as integer   no-undo.
define variable rpc_inc_yld   like mfc_logical label {&recrtwo_p_1} no-undo.
define variable temp_recid    as recid     no-undo.
define variable ptstatus    like pt_status no-undo.
define variable l_errorno     as integer   no-undo.

define variable l_cumwo_lot like wolot     no-undo.
define variable l_recid     as   recid     no-undo.
define variable l_qad_key1  like qad_key1  no-undo.
define variable l_qad_key2  like qad_key2  no-undo.
define variable oldwk like wr_wkctr .
define buffer   qadlock     for  qad_wkfl.

/**************tfq added begin***************************************/
define new shared temp-table xxpk_det 
        field xxpk_user like pk_user
        field xxpk_part like pk_part
        field xxpk_ref like pk_reference
        field xxpk_op like ps_op  .
 define  temp-table zzpk_det 
              field  zzpk_user      like pk_user
              field  zzpk_part      like pk_part
/*G656*/      field  zzpk_reference like pk_reference
              field  zzpk_loc       like pk_loc
              field  zzpk_start     like pk_start
              field  zzpk_end       like pk_end 
              field  zzpk_lot like pk_lot
              field  zzpk_user1 like pk_user1
              field  zzpk_user2 like pk_user2
              field  zzpk__qadc01 like pk__qadc01 
              field  zzpk_qty like pk_qty .
   for each zzpk_det where zzpk_user = mfguser :
   delete zzpk_det .
   end.           
           
/*************tfq added end******************************************/

for first clc_ctrl
   fields (clc_domain clc_relot_rcpt)
   no-lock where clc_domain = global_domain:
end. /* FOR FIRST CLC_CTRL */

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields (clc_relot_rcpt)
      no-lock where clc_domain = global_domain:
   end. /* FOR FIRST CLC_CTRL */

end.

/*DETERMINE THE LARGEST DATE INTERVAL THAT WE CAN USE TO
CREATE THE CUM WO EFFECTIVE DATES.  THIS INTERVAL IS IDENTIFIED
BY earliest_begin_date, latest_end_date*/

for each wo_mstr
   fields (wo_domain wo_acct wo_sub wo_bom_code wo_cc wo_due_date wo_flr_acct
           wo_flr_sub wo_flr_cc wo_line wo_lot wo_lot_rcpt wo_mvar_acct
           wo_mvar_sub wo_mvar_cc wo_mvrr_acct wo_mvrr_sub
           wo_mvrr_cc wo_nbr wo_ord_date wo_part
           wo_qty_ord wo_rel_date wo_routing wo_site wo_status
           wo_svar_acct wo_svar_sub wo_svar_cc wo_svrr_acct wo_svrr_sub
           wo_svrr_cc wo_type wo_xvar_acct wo_xvar_sub wo_xvar_cc)
   no-lock
   where wo_domain = global_domain 
   	 and wo_type = "c"
     and wo_part = part
     and wo_site = site
     and wo_line = line
     and wo_routing = routing
     and wo_bom_code = bom_code
     and wo_due_date < eff_date
     and wo_nbr = ""
   use-index wo_type_part
   by wo_due_date descending:

   earliest_begin_date = wo_due_date + 1.
   leave.

end.

for each wo_mstr
   fields (wo_domain wo_acct wo_sub wo_bom_code wo_cc wo_due_date wo_flr_acct wo_flr_sub
           wo_flr_cc wo_line wo_lot wo_lot_rcpt wo_mvar_acct wo_mvar_sub
           wo_mvar_cc wo_mvrr_acct wo_mvrr_sub
           wo_mvrr_cc wo_nbr wo_ord_date wo_part wo_qty_ord
           wo_rel_date wo_routing wo_site wo_status wo_svar_acct wo_svar_sub
           wo_svar_cc wo_svrr_acct wo_svrr_sub wo_svrr_cc wo_type wo_xvar_acct
           wo_xvar_sub wo_xvar_cc)
   no-lock
   where wo_domain = global_domain
     and wo_type = "c"
     and wo_part = part
     and wo_site = site
     and wo_line = line
     and wo_routing = routing
     and wo_bom_code = bom_code
     and wo_rel_date > eff_date
     and wo_nbr = ""
   use-index wo_type_part
   by wo_rel_date:

   latest_end_date = wo_rel_date - 1.
   leave.
end.

/* DO NOT ALLOW CREATION OF A CUMULATIVE WORK ORDER WHERE      */
/* THE PART STATUS IS RESTRICTED AGAINST REPETITVE.             */
/* THE # IN PT_STATUS IS USED TO DEFINE AN ITEM STATUS CODE,   */
/* NO # IS FOR INVENTORY STATUS CODE.                          */

for first pt_mstr
   fields (pt_domain pt_loc pt_ord_qty pt_part pt_prod_line pt_status)
   where pt_domain = global_domain and pt_part = part no-lock:
end. /* FOR FIRST PT_MSTR */

assign
   ptstatus = pt_status
   substring(ptstatus,9,1) = "#".

if can-find(isd_det where isd_domain = global_domain and isd_status  = ptstatus
                      and isd_tr_type = "ADD-RE")
then do:

   /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
   {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
   wolot = ?.
   return.
end.

assign
   l_qad_key1 = "CUMWOCRT"
   l_qad_key2 = string (site, "x(8)") +
                string (line, "x(8)") +
                string (part, "x(18)").

create-qad:
repeat:

   /* USING  qadlock    RECORD FOR PART/SITE/LINE COMBINATION,TO */
   /* MAKE CUMULATIVE ORDER CREATION CODE SINGLE THREADED        */

   do transaction on error undo create-qad, retry create-qad:

      /* PAUSE 0 INTRODUCED TO SUPPRESS PROGRESS ERROR WHEN 2 USERS */
      /* TRY TO CREATE qadlock AT THE SAME TIME.                    */

      pause 0.

      find first qadlock
         where qadlock.qad_domain = global_domain 
         	 and qadlock.qad_key1 = l_qad_key1
           and qadlock.qad_key2 = l_qad_key2
         exclusive-lock no-error no-wait.

      if locked qadlock
      then
         next create-qad.

      if not available qadlock
      then do:

         create qadlock. qadlock.qad_domain = global_domain.
         assign
            qadlock.qad_key1 = l_qad_key1
            qadlock.qad_key2 = l_qad_key2
            no-error.
         l_recid = recid(qadlock) no-error.

         /* IN ORACLE,qadlock  RECORD WILL BE SAVED AT THE END OF  */
         /* TRANSACTION. WHEN TWO USERS TRY TO SAVE RECORD AT SAME */
         /* TIME ONE USER WILL GET l_recid AS ? OR 0 WHILE OTHER   */
         /* USER WILL SAVE THE RECORD  AND GO AHEAD                */

         if l_recid  = 0
         or l_recid  = ?
         then
            undo create-qad, retry create-qad.
      end. /* IF NOT AVAILABLE qad_lock */

   end. /* DO TRANSACTION ON ERRROR ... */

   do transaction:

      /* qadlock RECORD SHOULD BE PRESENT BEFORE ACTUALLY CREATING */
      /* CUMULATIVE ORDER                                          */
      repeat:
         find first qadlock
            where qadlock.qad_domain = global_domain
              and qadlock.qad_key1 = l_qad_key1
              and qadlock.qad_key2 = l_qad_key2
            exclusive-lock no-wait no-error.

         if locked qadlock
         then
            next.
         else if not available qadlock
         then
            next create-qad.
         else
            leave.
      end. /* REPEAT */

      /* CHECK WHETHER CUMULATIVE WO IS ALREADY PRESENT */
      {gprun.i ""regetwo.p""
         "(input  site,
           input  part,
           input  eff_date,
           input  line,
           input  routing,
           input  bom_code,
           output l_cumwo_lot)"}

      if l_cumwo_lot <> ?
      then do:
         wolot = l_cumwo_lot.
         delete qadlock.
         leave create-qad.
      end. /* IF l_cumwo_lot <> ? */
      else do:
         /* GET NEXT CUMULATIVE ORDER ID */
/*         {mfnxtsq.i wo_mstr wo_lot woc_sq01 wolot}   */
         {mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot
         woc_sq01 wolot}
      end. /* IF l_cumwo_lot = ? */

      /*NOTE: wo_nbr IS KEPT BLANK INTENTIONALLY, TO INDICATE THE
      CUMORDER WAS CREATED BY THE NEW REPETITIVE SO AS TO NOT COMINGLE
      WITH THE OLD REPETITIVE IN RPTS/INQS ETC.*/

      create wo_mstr. wo_domain = global_domain.

      assign
         wo_lot = wolot
         wo_nbr = ""
         wo_site = site
         wo_part = part
         wo_bom_code = bom_code
         wo_routing = routing
         wo_line = line
         wo_status = "R"
         wo_type = "C"
         wo_lot_rcpt = clc_relot_rcpt
         wo_ord_date = today.

      if recid(wo_mstr) = -1 then .

      temp_recid = recid(wo_mstr).

      {gprun.i ""csavg01.p""
         "(input wo_part,
           input wo_site,
           output glx_set,
           output glx_mthd,
           output cur_set,
           output cur_mthd)"}

      for first pt_mstr
         fields (pt_domain pt_loc pt_ord_qty pt_part pt_prod_line pt_status)
         where pt_domain = global_domain and pt_part = part no-lock:
      end. /* FOR FIRST PT_MSTR */

      /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
      {pxrun.i &PROC    = 'get_default_wo_rctstat'
               &PROGRAM = 'wocmnrtn.p'
               &HANDLE  = ph_wocmnrtn
               &PARAM   = "(
                            input  wo_part,
                            input  wo_site,
                            output wo_rctstat,
                            output wo_rctstat_active,
                            output l_errorno
                           )"
      }

      /* ASSIGN DEFAULT VARIANCE ACCOUNT SUB-ACCOUNT AND COST CENTER CODE. */
      run assign_default_wo_acct(buffer wo_mstr,
                                 input  pt_prod_line).

      /***********************************************************
      SET THE WORKORDER START/END EFFECTIVE DATES BASED ON
      THE CONTROL FILE INDICATOR:

      Indicator
      Value   Meaning
      ---------   --------------------
      <blank>   No expiration date processing is done
      1   Use G/L period start/end dates
      2   Month begin-end dates
      3   Number of days past prior end-effective date
      ***********************************************************/

      {gprun.i ""rerepma.p""}

      for first mfc_ctrl
         fields (mfc_domain mfc_char mfc_field mfc_integer mfc_logical)
         where mfc_domain = global_domain and mfc_field = "rpc_eff_dflt" no-lock:
      end. /* FOR FIRST MFC_CTRL */

      eff_dflt = mfc_char.

      for first mfc_ctrl
         fields (mfc_domain mfc_char mfc_field mfc_integer mfc_logical)
         where mfc_domain = global_domain and mfc_field = "rpc_inc_yld" no-lock:
      end. /* FOR FIRST MFC_CTRL */

      rpc_inc_yld = mfc_logical.

      if eff_dflt = "1"
      then do:

         /*USE G/L PERIOD START/END DATES*/
         for first glc_cal
            fields (glc_domain glc_end glc_start)
            where glc_domain = global_Domain and glc_start <= eff_date
              and glc_end >= eff_date no-lock:
         end. /* FOR FIRST GLC_CAL */

         if available glc_cal
         then
            assign
               wo_rel_date = glc_start
               wo_due_date = glc_end.

         else do:

            /*USE MONTH BEGIN-END DATES*/
            assign
               mm = month(eff_date)
               yy = year(eff_date)
               wo_rel_date = date(mm,1,yy)
               mm = mm + 1.

            if mm = 13
            then
               assign
                  yy = yy + 1
                  mm = 1.

            wo_due_date = date(mm,1,yy) - 1.
         end.
      end.

      else
      if eff_dflt = "2"
      then do:

         /*USE MONTH BEGIN-END DATES*/
         assign
            mm = month(eff_date)
            yy = year(eff_date)
            wo_rel_date = date(mm,1,yy)
            mm = mm + 1.

         if mm = 13
         then
            assign
               yy = yy + 1
               mm = 1.

         wo_due_date = date(mm,1,yy) - 1.
      end.

      else
      if eff_dflt = "3"
      then do:

         /*NUMBER OF DAYS PAST PRIOR END-EFFECTIVE DATE.  IF THERE  WAS
         A  PREVIOUS  WO,  AS INDICATED BY earliest_begin_date <> ?, WE
         ENSURE THAT THE START/END DATES FOR THIS ORDER  ARE  "ALIGNED"
         ON  THE  TIME  INTERVAL SOME NUMBER OF INTERVALS PAST THE LAST
         EFFECTIVE DATE FOUND.  */

         for first mfc_ctrl
            fields (mfc_domain mfc_char mfc_field mfc_integer mfc_logical)
            where mfc_domain = global_domain and mfc_field = "rpc_eff_days" no-lock:
         end. /* FOR FIRST MFC_CTRL */

         if earliest_begin_date = ?
         then do:

            assign
               wo_rel_date = eff_date
               wo_due_date = wo_rel_date + mfc_integer - 1.

            if wo_due_date < wo_rel_date
            then
               wo_due_date = wo_rel_date.
         end.

         else do:

            if mfc_integer > 0
            then
               assign
                  wo_due_date = eff_date + mfc_integer - 1
                                - ((eff_date - (earliest_begin_date))
                                modulo mfc_integer)
                  wo_rel_date = wo_due_date - mfc_integer + 1.
            else
               assign
                  wo_rel_date = eff_date
                  wo_due_date = wo_rel_date.
         end.
      end.

      if wo_rel_date = ?
      then
         wo_rel_date = earliest_begin_date.

      else
      if wo_rel_date < earliest_begin_date
      then
         wo_rel_date = earliest_begin_date.

      if wo_due_date = ?
      then
         wo_due_date = latest_end_date.

      else
      if wo_due_date > latest_end_date
      then
         wo_due_date = latest_end_date.

      /* CREATE CUM ORDER ROUTING AND BOM RECORDS
      AND CALCULATE OPERATION COSTS */

      for each pk_det exclusive-lock
         where pk_domain = global_domain and pk_user = mfguser:

         delete pk_det.
      end.

      wo_qty_ord = 1.

      for first pt_mstr
         fields (pt_domain pt_loc pt_ord_qty pt_part pt_prod_line pt_status)
         where pt_domain = global_domain and pt_part = wo_part no-lock:
      end. /* FOR FIRST PT_MSTR */

      if pt_ord_qty <> 0
      then
         wo_qty_ord = pt_ord_qty.

      for first ptp_det
         fields (ptp_domain ptp_ord_qty ptp_part ptp_site)
         where ptp_domain = global_domain and ptp_part = wo_part
           and ptp_site = wo_site no-lock:
      end. /* FOR FIRST PTP_DET */

      if available ptp_det
         and ptp_ord_qty <> 0
      then
         wo_qty_ord = ptp_ord_qty.

      assign
         temp_routing = if wo_routing = "" then wo_part else wo_routing
         temp_bom_code = if wo_bom_code = "" then wo_part else wo_bom_code.

      /*EXPLODE THE WORKORDER PART*/
      {gpxpld01.i "new shared"}

      incl_nopk = yes.                /*INCLUDE FLOORSTOCK*/

     /*tfq {gpxpldps.i
         &date=eff_date &site=wo_site &comp=temp_bom_code &op=? &op_list=?} */
         
        {yygpxpldps.i
         &date=eff_date &site=wo_site &comp=temp_bom_code &op=? &op_list=?}
        
      for each ro_det
         fields (ro_domain ro_auto_lbr ro_desc ro_end ro_mch ro_mch_op ro_men_mch
                 ro_milestone ro_move ro_mv_nxt_op ro_op ro_po_line
                 ro_po_nbr ro_queue ro_routing ro_run ro_setup ro_setup_men
                 ro_start ro_std_op ro_sub_cost ro_sub_lead ro_tool
               ro_tran_qty ro_vend ro_wait ro_wipmtl_part ro_wkctr ro_yield_pct)
         no-lock
         where ro_domain = global_domain and ro_routing = temp_routing
           and (eff_date = ? or ro_start = ? or ro_start <= eff_date)
           and (eff_date = ? or ro_end = ? or eff_date <= ro_end)
         by ro_op:

         for first wc_mstr
            fields (wc_domain wc_bdn_pct wc_bdn_rate wc_lbr_rate wc_mch
                    wc_mch_bdn wc_setup_rte wc_wkctr)
            where wc_domain = global_domain and wc_wkctr = ro_wkctr
              and wc_mch = ro_mch no-lock:
         end. /* FOR FIRST WC_MSTR */

         create wr_route. wr_domain = global_domain.

         assign
            wr_nbr = wo_nbr
            wr_lot = wo_lot
            wr_part = wo_part
            wr_op = ro_op
            wr_wkctr = ro_wkctr
            wr_mch = ro_mch
            wr_std_op = ro_std_op
            wr_desc = ro_desc
            wr_setup = ro_setup
            wr_run = ro_run
            wr_move = ro_move
            wr_tool = ro_tool
            wr_vend = ro_vend
            wr_yield_pct = if rpc_inc_yld then ro_yield_pct else 100
            wr_setup_men = ro_setup_men
            wr_men_mch = ro_men_mch
            wr_tran_qty = ro_tran_qty
            wr_mch_op = ro_mch_op
            wr_queue = ro_queue
            wr_wait = ro_wait
            wr_milestone = ro_milestone
            wr_sub_lead = ro_sub_lead
            wr_sub_cost = ro_sub_cost
            wr_setup_rte = if available wc_mstr then wc_setup_rte else 0
            wr_lbr_rate = if available wc_mstr then wc_lbr_rate else 0
            wr_bdn_pct = if available wc_mstr then wc_bdn_pct else 0
            wr_bdn_rate = if available wc_mstr then wc_bdn_rate else 0
            wr_mch_bdn = if available wc_mstr then wc_mch_bdn else 0
            wr_mv_nxt_op = ro_mv_nxt_op
            wr_po_nbr = ro_po_nbr
            wr_po_line = ro_po_line
            wr_wipmtl_part = ro_wipmtl_part
            wr_auto_lbr = ro_auto_lbr .

         /*FOLLOWING IRO_DET IS USED FOR AVERAGE COST COLLECTION*/
         create iro_det. iro_domain = global_domain.

         assign
            iro_part = wo_part
            iro_site = wo_site
            iro_cost_set = "cumorderavg"
            iro_routing = wo_lot
            iro_op = ro_op.

         /*FOLLOWING IRO_DET IS USED FOR CUM ORDER COSTS*/
         create iro_det. iro_domain = global_domain.

         assign
            iro_part = wo_part
            iro_site = wo_site
            iro_cost_set = "cumorder"
            iro_routing = wo_lot
            iro_op = ro_op.

         /* Note:                         */
         /* Yield handled differently for */
         /* subcontract.  You normally    */
         /* only pay for GOOD sub parts,  */
         /* while you expend lbr & bdn to */
         /* make both GOOD and BAD parts  */

         iro_sub_tl = ro_sub_cost * (wr_yield_pct * .01).

         if available wc_mstr
         then do:

            /*SETUP LABOR AND BURDEN*/
            setup_labor = (ro_setup / wo_qty_ord) * wc_setup_rte.
            if recid(iro_det) = -1 then . /* MAKE AVAILABLE TO ORACLE */

            {gprun.i ""rwbdncal.p""
               "( input 'SETUP',
                  input no,
                  input (wc_bdn_pc * 0.01),
                  input wc_bdn_rate,
                  input 0,
                  input wc_mch_bdn,
                  input ro_mch_op,
                  input wo_qty_ord,
                  input 0,
                  input wc_setup_rte,
                  input ro_setup,
                  input 1,
                  input-output setup_burden)"
            }

            /*RUN LABOR AND BURDEN*/

            run_labor = ro_run * wc_lbr_rate.

            {gprun.i ""rwbdncal.p""
               "( input 'RUN',
                  input no,
                  input (wc_bdn_pc * 0.01),
                  input wc_bdn_rate,
                  input wc_lbr_rate,
                  input wc_mch_bdn,
                  input 0,
                  input 1,
                  input ro_run,
                  input 0,
                  input 0,
                  input 1,
                  input-output run_burden)"
            }

            assign
               iro_lbr_tl = setup_labor + run_labor
               iro_bdn_tl = setup_burden + run_burden.
         end.

         matl_cost = 0.

         for each pk_det exclusive-lock
            where pk_domain = global_domain and pk_user = mfguser
              and integer(pk_reference) = ro_op:

            {gprun.i ""csavg01.p""
               "(input pk_part, input wo_site,
                  output glx_set, output glx_mthd, output cur_set,
                  output cur_mthd)"}

            {gpsct01.i &part=pk_part &set=glx_set &site=wo_site}

            find wod_det exclusive-lock
               where wod_domain = global_domain and wod_lot = wo_lot
                 and wod_part = pk_part
                 and wod_op = integer(pk_reference) no-error.

            for first pt_mstr
               fields (pt_domain pt_loc pt_ord_qty pt_part pt_prod_line pt_status)
               where pt_domain = global_domain and pt_part = pk_part no-lock:
            end. /* FOR FIRST PT_MSTR */

            if not available wod_det
            then
               create wod_det. wod_domain = global_domain.

            assign
               wod_lot = wo_lot
               wod_nbr = wo_nbr
               wod_part = pk_part
               wod_op = integer(pk_reference)
               wod_site = wo_site
               wod_bom_qty = wod_bom_qty + pk_qty / bombatch
               wod_loc = pt_loc
               wod_iss_date = ?
               wod_bom_amt = sct_cst_tot.

            find qad_wkfl exclusive-lock
               where qad_domain = global_domain and qad_key1 = "MFWORLA"
                 and qad_key2 = wod_lot + wod_part + string(wod_op) no-error.

            if not available qad_wkfl
            then
               create qad_wkfl. qad_domain = global_domain.

            assign
               qad_key1 = "MFWORLA"
               qad_key2 = wod_lot + wod_part + string(wod_op)
               qad_decfld[1] = qad_decfld[1] + pk_qty
               qad_decfld[2] = bombatch
               qad_charfld[1] = "s"     /*INDICATES STANDARD COMPONENT*/
               matl_cost = matl_cost + (wod_bom_amt * (pk_qty / bombatch)).
         end.

         assign
            iro_mtl_ll   = mtl_ll
            iro_lbr_ll   = lbr_ll
            iro_bdn_ll   = bdn_ll
            iro_sub_ll   = sub_ll
            iro_mtl_tl   = matl_cost
            iro_mtl_ll   = (iro_mtl_ll * 100) / wr_yield_pct
            iro_lbr_ll   = (iro_lbr_ll * 100) / wr_yield_pct
            iro_bdn_ll   = (iro_bdn_ll * 100) / wr_yield_pct
            iro_sub_ll   = (iro_sub_ll * 100) / wr_yield_pct
            iro_mtl_tl   = (iro_mtl_tl * 100) / wr_yield_pct
            iro_lbr_tl   = (iro_lbr_tl * 100) / wr_yield_pct
            iro_bdn_tl   = (iro_bdn_tl * 100) / wr_yield_pct
            iro_sub_tl   = (iro_sub_tl * 100) / wr_yield_pct
            iro_cost_tot =   iro_mtl_ll + iro_mtl_tl + iro_lbr_ll + iro_lbr_tl
                           + iro_bdn_ll + iro_bdn_tl + iro_sub_ll + iro_sub_tl
            mtl_ll       = iro_mtl_ll + iro_mtl_tl
            lbr_ll       = iro_lbr_ll + iro_lbr_tl
            bdn_ll       = iro_bdn_ll + iro_bdn_tl
            sub_ll       = iro_sub_ll + iro_sub_tl.
      end.
/********tfq added begin********************/
for each pk_det where pk_domain= global_domain and pk_user = mfguser :
find first xxpk_det where xxpk_user = mfguser and xxpk_part = pk_part and xxpk_ref = pk_reference no-error .
if available xxpk_det and pk_reference <> string(xxpk_op) then do:
         pk_reference = string(xxpk_op) .
      end.
end.
for each  xxpk_det where xxpk_user = mfguser :
delete xxpk_det .
end.
for each pk_det where pk_domain = global_domain and pk_user = mfguser :
  find first zzpk_det where zzpk_user = pk_user
                        and zzpk_part = pk_part 
                        and zzpk_reference = pk_reference no-error .
        if not available zzpk_det then
        do:                
            create zzpk_det.
                   assign zzpk_user      = pk_user
                          zzpk_part      = pk_part
/*G656*/                  zzpk_reference = pk_reference
                          zzpk_loc       = pk_loc
                          zzpk_start     = pk_start
                          zzpk_end       = pk_end 
                          zzpk_lot = pk_lot
                          zzpk_user1= pk_user1
                          zzpk_user2 = pk_user2
                          zzpk__qadc01 = pk__qadc01 .
                          zzpk_qty = pk_qty .
           end.               
                          
           else       zzpk_qty = pk_qty + zzpk_qty .
           delete pk_det .
           end.               
                  
for each zzpk_det where zzpk_user = mfguser :
                  create pk_det.
                   assign pk_user      = zzpk_user
                          pk_part      = zzpk_part
/*G656*/                  pk_reference = zzpk_reference
                          pk_loc       = zzpk_loc
                          pk_start     = zzpk_start
                          pk_end       = zzpk_end 
                          pk_lot = zzpk_lot
                          pk_user1= zzpk_user1
                          pk_user2 = zzpk_user2
                          pk__qadc01 = zzpk__qadc01 .
                          pk_qty = zzpk_qty .
                 delete zzpk_det .
           end.               

/**********tfq added end***************/

      for each pk_det exclusive-lock where pk_domain = global_domain and pk_user = mfguser:
       /**********tfq added begin***********************************/
         find first wr_route where wr_domain = global_domain and wr_nbr = wo_nbr
                    and  wr_lot = wo_lot
                    and wr_part = wo_part
                    and string(wr_op) = pk_reference no-error .
          if not available wr_route then
            do:
            find first wod_det where wod_domain = global_domain and wod_part = pk_part and wod_lot = wo_loc and
            wod_nbr = wo_nbr no-lock no-error .
            if available wod_det then
            do:
            find first wr_route where wr_domain = global_domain and wr_nbr = wo_nbr
                    and  wr_lot = wo_lot
                    and wr_part = wo_part
                    and wr_op  =  wod_op no-lock no-error .
              if available wr_route then oldwk = wr_wkctr .
                    wod_op = integer(pk_reference) .
            end .
            create wr_route . wr_domain = global_domain.
            assign  wr_nbr = wo_nbr
            wr_lot = wo_lot
            wr_part = wo_part
            wr_op = integer(pk_reference)
            wr_wkctr = oldwk .
            end .
            /*****************
            wr_wkctr = ro_wkctr
            wr_mch = ro_mch
            wr_std_op = ro_std_op
            wr_desc = ro_desc
            wr_setup = ro_setup
            wr_run = ro_run
            wr_move = ro_move
            wr_tool = ro_tool
            wr_vend = ro_vend
            wr_yield_pct = if rpc_inc_yld then ro_yield_pct else 100
            wr_setup_men = ro_setup_men
            wr_men_mch = ro_men_mch
            wr_tran_qty = ro_tran_qty
            wr_mch_op = ro_mch_op
            wr_queue = ro_queue
            wr_wait = ro_wait
            wr_milestone = ro_milestone
            wr_sub_lead = ro_sub_lead
            wr_sub_cost = ro_sub_cost
            ******************************************************/
            assign wr_setup_rte =  0
            wr_lbr_rate =  0
            wr_bdn_pct = 0
            wr_bdn_rate = 0
            wr_mch_bdn = 0 .
            /************
            wr_mv_nxt_op = ro_mv_nxt_op
            wr_po_nbr = ro_po_nbr
            wr_po_line = ro_po_line
            wr_wipmtl_part = ro_wipmtl_part
            wr_auto_lbr = ro_auto_lbr .
                *************/

         /***********tfq added end*****************************/
         delete pk_det.
      end.

      delete qadlock.

   end.  /* DO TRANSACTION */

   leave create-qad.

end. /* CREATE-QAD */

/* DELETE STRANDED qadlock RECORDS */
repeat:
   find first qadlock
      where qadlock.qad_domain = global_domain and qadlock.qad_key1 = l_qad_key1
      exclusive-lock no-error no-wait.
   if available qadlock
   then
      delete qadlock.
   else
      leave.
end. /* REPEAT */

/* INCLUDE FILE WHICH CONTAINS PROCEDURE assign_default_wo_acct */
{woacct.i}

