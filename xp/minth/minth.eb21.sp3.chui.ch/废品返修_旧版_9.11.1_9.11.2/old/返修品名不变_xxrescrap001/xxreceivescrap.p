/* receive.p  - REPETITIVE   RECEIVE FINISHED MATERIAL SUBPROGRAM            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.32 $                                                         */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*               */
/* REVISION: 7.3      LAST MODIFIED: 11/08/94   BY: WUG *GO42*               */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*               */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*               */
/* REVISION: 8.5      LAST MODIFIED: 10/24/95   BY: taf *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 01/16/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 03/13/96   BY: jym *G1GD*               */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: jym *G1VQ*               */
/* REVISION: 8.5      LAST MODIFIED: 06/06/96   BY: jym *G1XF*               */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/*                                   03/21/97   BY: *K08P* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 02/13/98   BY: *J2F9* Santhosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 05/15/99   BY: *J39K* Sanjeev Assudani  */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates        */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte       */
/* REVISION: 9.1      LAST MODIFIED: 04/22/00   BY: *L0WN* Santhosh Nair     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0WD* BalbeerS Rajput   */
/* Revision: 1.20     BY: Niranjan R.           DATE: 07/13/01 ECO: *P00L*   */
/* Revision: 1.21     BY: Ellen Borden          DATE: 04/03/01 ECO: *P00G*   */
/* Revision: 1.22     BY: Samir Bavkar          DATE: 04/05/02 ECO: *P000*   */
/* Revision: 1.23     BY: Jeff Wootton          DATE: 05/14/02 ECO: *P03G*   */
/* Revision: 1.24     BY: Amit Chaturvedi      DATE: 12/13/02 ECO: *N225*   */
/* Revision: 1.25      BY: Dorota Hohol       DATE: 02/25/03  ECO: *P0N6* */
/* Revision: 1.28      BY: Narathip W.        DATE: 04/19/03  ECO: *P0Q7* */
/* Revision: 1.29      BY: Narathip W. DATE: 05/09/03 ECO: *P0RN* */
/* Revision: 1.31      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.32 $     BY: Shoma Salgaonkar   DATE: 08/25/04 ECO: *Q0CJ* */
/*-Revision end---------------------------------------------------------------*/


/* SS - 090622.1  By: Roger Xiao */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE.                                     */

/* TAKEN FROM reisrc04.p, woovhd.p                                        */
{mfdeclre.i}
{cxcustom.i "RECEIVE.P"}

define input parameter cumwo_lot    as character no-undo.
define input parameter effdate      as date      no-undo.
define input parameter ophist_recid as recid     no-undo.

/* SS - 090622.1 - B */
define shared variable line1 like ln_line label "返修生产线".
define shared variable v_loc like loc_loc label "废品库位".
/* SS - 090622.1 - E */

define new shared variable eff_date   like glt_effdate.
define new shared variable ref        like glt_ref.
define new shared variable sf_cr_acct like dpt_lbr_acct.
define new shared variable sf_cr_sub  like dpt_lbr_sub.
define new shared variable sf_cr_cc   like dpt_lbr_cc.
define new shared variable sf_dr_acct like dpt_lbr_acct.
define new shared variable sf_dr_sub  like dpt_lbr_sub.
define new shared variable sf_dr_cc   like dpt_lbr_cc.
define new shared variable sf_entity  like en_entity.
define new shared variable sf_gl_amt  like tr_gl_amt.
define new shared variable tr_recno     as recid.
define new shared variable transtype    as character format "x(7)".
define new shared variable wo_recno     as recid.
define buffer rpsmstr for rps_mstr.
define buffer srwkfl  for sr_wkfl.
define variable assay                 like tr_assay             no-undo.
define variable cur_mthd              like cs_method            no-undo.
define variable cur_set               like cs_set               no-undo.
define variable expire                like tr_expire            no-undo.
define variable gl_cost               like sct_cst_tot          no-undo.
define variable unit_cost             like sct_cst_tot          no-undo.
define variable glx_mthd              like cs_method            no-undo.
define variable glx_set               like cs_set               no-undo.
define variable grade                 like tr_grade             no-undo.
define variable i                       as integer              no-undo.
define variable msgref                like tr_msg               no-undo.
define variable newbdn_ll               as decimal              no-undo.
define variable newbdn_tl               as decimal              no-undo.
define variable newcst                  as decimal              no-undo.
define variable newlbr_ll               as decimal              no-undo.
define variable newlbr_tl               as decimal              no-undo.
define variable newmtl_ll               as decimal              no-undo.
define variable newmtl_tl               as decimal              no-undo.
define variable newovh_ll               as decimal              no-undo.
define variable newovh_tl               as decimal              no-undo.
define variable newsub_ll               as decimal              no-undo.
define variable newsub_tl               as decimal              no-undo.
define variable null_ch                 as character initial "" no-undo.
define variable qty_chg               like tr_qty_loc           no-undo.
define variable qty_left              like op_qty_comp          no-undo.
define variable reavg_yn                as logical              no-undo.
define variable rmks                  like tr_rmks              no-undo.
define variable rpsnbr                like mrp_nbr              no-undo.
define variable rpsrecord             like rps_record           no-undo.
define variable ovhd_amt              like glt_amt              no-undo.
define variable inventory_amt         like glt_amt              no-undo.
define variable mcv_amt               like glt_amt              no-undo.
define variable wip_amt               like glt_amt              no-undo.
define variable trans-ok              like mfc_logical          no-undo.
define variable gl_tmp_amt              as decimal              no-undo.
define variable lvar_lineid           like sr_lineid            no-undo.
{&RECEIVE-P-TAG1}
define shared variable h_wiplottrace_procs as handle            no-undo.
define shared variable h_wiplottrace_funcs as handle            no-undo.
define variable temp_recid                 as recid             no-undo.
define variable iss_trnbr                like tr_trnbr          no-undo.
define variable rct_trnbr                like tr_trnbr          no-undo.
{&RECEIVE-P-TAG4}

{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "shared"}

{gpcrnd.i}

eff_date = effdate.

for first wo_mstr
   fields( wo_domain wo_acct    wo_sub     wo_cc   wo_lot    wo_nbr  wo_ovh_tot
           wo_part    wo_project wo_site wo_so_job wo_vend wo_wip_tot)
    where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
   no-lock:
end. /* FOR FIRST wo_mstr */

for first gl_ctrl
   fields( gl_domain gl_inv_acct gl_inv_sub gl_inv_cc gl_rnd_mthd)
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

for first pt_mstr
   fields( pt_domain pt_abc          pt_avg_int      pt_cyc_int      pt_loc
           pt_part         pt_prod_line    pt_rctpo_active pt_rctpo_status
           pt_rctwo_active pt_rctwo_status pt_shelflife    pt_um)
    where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
   no-lock:
end. /* FOR FIRST pt_mstr */

for first pl_mstr
   fields( pl_domain pl_inv_acct pl_inv_sub   pl_inv_cc    pl_ovh_acct
   pl_ovh_sub
           pl_ovh_cc   pl_prod_line pl_wvar_acct pl_wvar_sub pl_wvar_cc)
    where pl_mstr.pl_domain = global_domain and  pl_prod_line = pt_prod_line
   no-lock:
end. /* FOR FIRST pl_mstr */

for first si_mstr
   fields( si_domain si_cur_set si_entity si_gl_set si_site si_status)
    where si_mstr.si_domain = global_domain and  si_site = wo_site
   no-lock:
end. /* FOR FIRST si_mstr */

for first in_mstr
   fields( in_domain in_abc     in_avg_date in_avg_int   in_cnt_date  in_cur_set
           in_cyc_int in_gl_set   in_iss_chg   in_iss_date  in_level
           in_mrp     in_part     in_qty_avail in_qty_nonet in_qty_oh
           in_rctpo_active        in_rctpo_status           in_rctwo_active
           in_rctwo_status        in_rec_date  in_site      in_sls_chg
           in_gl_cost_site)
    where in_mstr.in_domain = global_domain and  in_part = wo_part
     and in_site = wo_site
   no-lock:
end. /* FOR FIRST in_mstr */

for first clc_ctrl
   fields( clc_domain clc_lotlevel)
    where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:

   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields( clc_domain clc_lotlevel)
       where clc_ctrl.clc_domain = global_domain no-lock:
   end. /* FOR FIRST clc_ctrl */
end. /* IF NOT AVAILABLE clc_ctrl */

/*DETERMINE COSTING METHOD*/
{gprun.i ""csavg01.p""
   "(input wo_part,
     input wo_site,
     output glx_set,
     output glx_mthd,
     output cur_set,
     output cur_mthd)" }

lvar_lineid = "+" + wo_part.

sr-loop:
for each sr_wkfl
   fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_site sr_userid)
    where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
     and sr_lineid = lvar_lineid:

   /*NO TRANSACTION SHOULD BE PENDING HERE*/
   do transaction:

/* SS - 090622.1 - B */
if sr_qty > 0 then do:
    if pt_article = "wkctrloc" then  sr_loc = line1 .
    else  sr_loc = pt_loc.  
end.
else sr_loc = v_loc .
/* SS - 090622.1 - E */

      find wo_mstr
       where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
      exclusive-lock.

      {&RECEIVE-P-TAG2}

      /*ADD CALL TO GPICLT.P TO CREATE LOT_MSTR */
      if (clc_lotlevel <> 0)
         and (sr_lotser <> "")
      then do:

         {gprun.i ""gpiclt.p""
            "(wo_part,
              sr_lotser,
              wo_nbr,
              wo_lot,
              output trans-ok)"}
         if not trans-ok
         then do:

            /*CURRENT XACTION REJECTED CONTINUE WITH NEXT XACTION*/
            {pxmsg.i &MSGNUM=2740 &ERRORLEVEL=4}
            undo sr-loop, next sr-loop.
         end. /* IF NOT trans-ok */
      end. /* IF (clc_lotlevel <> 0) */

      find op_hist
         where recid(op_hist) = ophist_recid
         exclusive-lock.
      op_qty_wip = op_qty_wip + sr_qty.

      if glx_mthd = "avg"
      then do:

         /*GET G/L AVG COST AND UPDATE G/L AVG COST*/
         {gprun.i ""reupdgac.p""
            "(input wo_lot, input sr_qty, output unit_cost)"}
      end. /* IF glx_mthd = "avg" */
      else do:

         /* CONDITONALLY CALL WHEN SCT_DET RECORD IS NOT AVAILABLE  */
         /* FOR STANDARD COST SET, PART AND WO SITE.                */
         /* THIS WILL PREVENT UNNECESSARY LOCKING OF SCT_DET WHEN   */
         /* RECORD EXISTS.                                          */

         for first sct_det
            fields( sct_domain sct_bdn_ll sct_bdn_tl sct_cst_date sct_cst_tot
                    sct_lbr_ll sct_lbr_tl sct_mtl_ll sct_mtl_tl
                    sct_ovh_ll sct_ovh_tl sct_part sct_sim sct_site
                    sct_sub_ll sct_sub_tl)
             where sct_det.sct_domain = global_domain and  sct_sim  = glx_set
              and sct_part = pt_part
              and sct_site = wo_site
            no-lock:
         end. /* FOR FIRST sct_det */
         if not available sct_det
         then do:

            /*GET STANDARD G/L UNIT COST*/
            {gpsct01.i &set=glx_set &part=pt_part &site=wo_site}
         end. /* IF NOT AVAILABLE sct_det */

         unit_cost = sct_cst_tot.

         if cur_mthd = "avg"
            or cur_mthd = "last"
         then do:

            /*UPDATE CURRENT COST*/
            {gprun.i ""reupdcac.p""
               "(input wo_lot, input sr_qty)"}
         end. /* IF cur_mthd = "avg"*/
      end. /* ELSE DO */

      /*CREATE TRANSACTION HISTORY RECORD*/
      inventory_amt = unit_cost * sr_qty.

      /* ROUND PER BASE CURRENCY ROUND METHOD */

      run gpcrnd (input-output inventory_amt,input gl_rnd_mthd).

      /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
      /* ADDED CRSUB AND DRSUB BELOW */
      {ictrans.i
         &addrid       =wo_vend
         &bdnstd       =0
         &cracct       =wo_acct
         &crsub        =wo_sub
         &crcc         =wo_cc
         &crproj       =wo_project
         &curr         =""""
         &dracct       ="
                         if available pt_mstr
                         then
                            if available pld_det
                            then
                               pld_inv_acct
                            else
                               pl_inv_acct
                         else
                            gl_inv_acct"
         &drsub        ="
                         if available pt_mstr
                         then
                            if available pld_det
                            then
                               pld_inv_sub
                            else
                               pl_inv_sub
                         else
                            gl_inv_sub"
         &drcc         ="
                         if available pt_mstr
                         then
                           if available pld_det
                           then
                              pld_inv_cc
                           else
                              pl_inv_cc
                         else
                            gl_inv_cc"
         &drproj       =""""
         &effdate      =eff_date
         &exrate       =0
         &exrate2      =0
         &exratetype   =""""
         &exruseq      =0
         &glamt        =inventory_amt
         &lbrstd       =0
         &line         =0
         &location     ="(if sr_site <> wo_site
                          then
                             pt_loc
                          else
                             sr_loc)"
         &lotnumber    =wo_lot
         &lotserial    =sr_lotser
         &lotref       =sr_ref
         &mtlstd       =0
         &ordernbr     =wo_nbr
         &ovhstd       =0
         &part         =wo_part
         &perfdate     =?
         &price        =unit_cost
         &quantityreq  =0
         &quantityshort=0
         &quantity     ="sr_qty"
         &revision     =""""
         &rmks         =rmks
         &shiptype     =""""
         &site         =wo_site
         &slspsn1      =""""
         &slspsn2      =""""
         &sojob        =wo_so_job
         &substd       =0
         &transtype    =""RCT-WO""
         &msg          =msgref
         &ref_site     =tr_site
         }

      {&RECEIVE-P-TAG5}
      assign
         wo_wip_tot = wo_wip_tot - inventory_amt
         tr_recno   = recid(tr_hist).

      if glx_mthd = "AVG"
      then
         trgl_type = "RCT-AVG".

      /*POST OVERHEAD.  NOTE WE DR WIP BECAUSE WE ALREADY TOOK
      OVHD  OUT  OF  WIP  IN  THE PRECEDING ICTRANS, BY WAY OF
      sct_ovh_tl ALREADY INCLUDED IN sct_cst_tot*/

      /*GET COST SET*/
      {gpsct01.i &set=glx_set &part=wo_part &site=wo_site}

      ovhd_amt = sr_qty * sct_ovh_tl.

      /* ROUND PER BASE CURRENCY ROUND METHOD */

      run gpcrnd (input-output ovhd_amt,input gl_rnd_mthd).

      if ovhd_amt <> 0
      then do:

         create trgl_det. trgl_det.trgl_domain = global_domain.
         /* GL TRANSACTION TYPE POPULATED WITH DESCRIPTION */
         assign
            trgl_trnbr    = tr_trnbr
            trgl_type     = "OVH POST"
            trgl_sequence = recid(trgl_det)
            trgl_dr_acct  = wo_acct
            trgl_dr_sub   = wo_sub
            trgl_dr_cc    = wo_cc
            trgl_dr_proj  = wo_project
            trgl_cr_proj  = wo_project
            trgl_gl_amt   = ovhd_amt.

         {gprun.i ""glactdft.p"" "(input ""PO_OVH_ACCT"",
                                   input pl_prod_line,
                                   input wo_site,
                                   input """",
                                   input """",
                                   input no,
                                   output trgl_cr_acct,
                                   output trgl_cr_sub,
                                   output trgl_cr_cc)"}

         /* ADDED DR-SUB AND CR-SUB BELOW */
         {mficgl02.i
            &gl-amount=trgl_gl_amt
            &tran-type=trgl_type
            &order-no =wo_nbr
            &dr-acct  =trgl_dr_acct
            &dr-sub   =trgl_dr_sub
            &dr-cc    =trgl_dr_cc
            &drproj   =trgl_dr_proj
            &cr-acct  =trgl_cr_acct
            &cr-sub   =trgl_cr_sub
            &cr-cc    =trgl_cr_cc
            &crproj   =trgl_cr_proj
            &entity   =si_entity
            &same-ref ="icc_gl_sum"
            }

         assign
            wo_ovh_tot = wo_ovh_tot + trgl_gl_amt
            wo_wip_tot = wo_wip_tot + ovhd_amt.
      end. /* IF ovhd_amt <> 0 */

      if glx_mthd <> "AVG"
      then do:

         /*POST  DIFFERENCE  BETWEEN  FINISHED   MATERIAL   COST,
         OVERHEAD   POSTED,  AND  COST  AT  THE  LAST  OPERATION,
         EXTENDED TO METHOD CHANGE  VARIANCE.   NOTE  WE  DR  WIP
         BECAUSE  WE ALREADY TOOK MCV OUT OF WIP IN THE PRECEDING
         ICTRANS.*/

         for last wr_route
            fields( wr_domain wr_lot wr_op wr_qty_cummove wr_qty_outque)
             where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
            no-lock:
         end. /* FOR LAST wr_route */

         for first iro_det
            fields( iro_domain iro_cost_set iro_cost_tot iro_op iro_part
                    iro_routing iro_site)
             where iro_det.iro_domain = global_domain and  iro_part     =
             wo_part
              and iro_site     = wo_site
              and iro_cost_set = "cumorder"
              and iro_routing  = wo_lot
              and iro_op       = wr_op
            no-lock:
         end. /* FOR FIRST iro_det */

         wip_amt = sr_qty * iro_cost_tot.

         /* ROUND PER BASE CURRENCY ROUND METHOD */

         run gpcrnd (input-output wip_amt,input gl_rnd_mthd).

         mcv_amt = wip_amt - (inventory_amt - ovhd_amt).

         if mcv_amt <> 0
         then do:

            create trgl_det. trgl_det.trgl_domain = global_domain.

            assign
               trgl_trnbr    = tr_trnbr
               trgl_type     = "MTHD CHG"
               trgl_sequence = recid(trgl_det)
               trgl_dr_proj  = wo_project
               trgl_cr_acct  = wo_acct
               trgl_cr_sub   = wo_sub
               trgl_cr_cc    = wo_cc
               trgl_cr_proj  = wo_project
               trgl_gl_amt   = mcv_amt.
            {gprun.i ""glactdft.p"" "(input ""WO_WVAR_ACCT"",
                                      input pl_prod_line,
                                      input wo_site,
                                      input """",
                                      input """",
                                      input no,
                                      output trgl_dr_acct,
                                      output trgl_dr_sub,
                                      output trgl_dr_cc)"}

            /* ADD DR-SUB AND CR-SUB BELOW */
            {mficgl02.i
               &gl-amount=trgl_gl_amt
               &tran-type=trgl_type
               &order-no =wo_nbr
               &dr-acct  =trgl_dr_acct
               &dr-sub   =trgl_dr_sub
               &dr-cc    =trgl_dr_cc
               &drproj   =trgl_dr_proj
               &cr-acct  =trgl_cr_acct
               &cr-sub   =trgl_cr_sub
               &cr-cc    =trgl_cr_cc
               &crproj   =trgl_cr_proj
               &entity   =si_entity
               &same-ref ="icc_gl_sum"
               }

            wo_wip_tot = wo_wip_tot - mcv_amt.

         end. /* IF mcv_amt <> 0 */

      end. /* IF glx_mthd <> "AVG"  */

      /*IF FROM DIFFERENT SITE THAN CUM WO DO AN INVENTORY TRANSFER*/

      if sr_site <> wo_site
      then do:

         assign
            global_part = wo_part
            global_addr = wo_vend.

         {gprun.i
            ""icxfer.p""
            "(wo_lot,
              sr_lotser,
              sr_ref,
              sr_ref,
              sr_qty,
              wo_nbr,
              wo_so_job,
              rmks,
              wo_project,
              eff_date,
              wo_site,
              pt_loc,
              sr_site,
              sr_loc,
              no,
              """",
              ?,
              """",
              0,
              """",
              output gl_cost,
              output iss_trnbr,
              output rct_trnbr,
              input-output assay,
              input-output grade,
              input-output expire)" }
         {&RECEIVE-P-TAG6}

         /*CHANGE ATTRIBUTES*/

         for first tr_hist
             where tr_hist.tr_domain = global_domain and  tr_trnbr = trmsg
            no-lock:
         end. /* FOR FIRST tr_hist */

      end. /* IF sr_site <> wo_site */

      /*CHANGE ATTRIBUTES*/
      if available tr_hist
      then do:

         /* ADDED FIFTH PARAMETER EFF_DATE */
         {gprun.i ""worcat03.p""
            "(input recid(sr_wkfl),
              input recid(tr_hist),
              input tr_recno,
              input wo_part,
              input eff_date,
              input-output chg_assay,
              input-output chg_grade,
              input-output chg_expire,
              input-output chg_status,
              input-output assay_actv,
              input-output grade_actv,
              input-output expire_actv,
              input-output status_actv)"}
      end. /* IF AVAILABLE tr_hist */

      /*REGISTER QTY RECEIVED WITH CUM ORDER ROUTING RECORD*/

      find last wr_route
          where wr_route.wr_domain = global_domain and  wr_lot = cumwo_lot
         exclusive-lock.

      assign
         wr_qty_cummove = wr_qty_cummove + sr_qty
         wr_qty_outque  = wr_qty_outque - sr_qty.

      /*UPDATE REPETITIVE SCHEDULE*/

/* SS - 090622.1 - B */
{gprun.i ""xxreupdscfscrap.p"" "(input cumwo_lot, input sr_qty)"}
/* SS - 090622.1 - E */

      for first op_hist
         where recid(op_hist) = ophist_recid
         no-lock:
      end. /* FOR FIRST op_hist */

      if is_wiplottrace_enabled()
         and is_operation_queue_lot_controlled(wo_lot, op_wo_op,
         OUTPUT_QUEUE)
      then do:

         /*DO THE EQUIVALENT OF A MOVE TO FINISHED MATL INVENTORY*/

         {gprun.i ""reophist.p""
            "(input op_type,
              input op_wo_lot, input op_wo_op, input op_emp,
              input op_wkctr, input op_mch, input op_dept, input op_shift,
              input op_date,
              output temp_recid)"}

         /*CONSUME A WIPLOT IN THE OUTPUT QUEUE OF THE
         /*N002*/ SAME LOT AND REF AS WHAT WILL BE RECEIVED*/

         for first op_hist
            where recid(op_hist) = temp_recid
            exclusive-lock:
         end. /* FOR FIRST op_hist */

         run consume_wip_lot
            in h_wiplottrace_procs
            (
            input op_wo_lot,
            input op_wo_op,
            input sr_lotser,
            input sr_ref,
            input wo_site,
            input op_wkctr,
            input op_mch,
            input op_wo_lot,
            input op_wo_op,
            input OUTPUT_QUEUE,
            input sr_qty,
            input op_trnbr).

         /*REGISTER THE FINISHED MATERIAL RECEIVED
         /*N002*/          IN THE TRACING JOURNAL*/

         run add_trace_record
            in h_wiplottrace_procs
            (
            input OPERATION_HISTORY,
            input op_trnbr,
            input PRODUCED_MTL,
            input ITEM_MTL,
            input '',
            input 0,
            input wo_part,
            input sr_lotser,
            input '',
            input sr_qty).
      end. /* IF is_wiplottrace_enabled() */

      release wo_mstr.
      release wr_route.
   end. /* DO TRANSACTION */

   do for srwkfl transaction:
      find srwkfl
      where recid(srwkfl) = recid(sr_wkfl)
      exclusive-lock.
      delete srwkfl.
   end. /* DO For srwkfl TRANSACTION */

end. /* FOR EACH sr_wkfl */

{&RECEIVE-P-TAG3}
