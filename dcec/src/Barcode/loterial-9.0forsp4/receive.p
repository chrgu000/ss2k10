/* GUI CONVERTED from receive.p (converter v1.75) Tue Apr 25 01:59:41 2000 */
/* receive.p  - REPETITIVE   RECEIVE FINISHED MATERIAL SUBPROGRAM            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*V8:RunMode=Character,Windows */
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
/* REVISION: 8.6     LAST MODIFIED: 02/13/98 BY: *J2F9* Santhosh Nair        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 05/15/99   BY: *J39K* Sanjeev Assudani  */
/* REVISION: 9.0      LAST MODIFIED: 04/22/00   BY: *L0WN* Santhosh Nair     */

/*J2DG*/ /* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO */
/*J2DG*/ /* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST  */
/*J2DG*/ /* STATEMENTS FOR ORACLE PERFORMANCE.                            */

/* TAKEN FROM reisrc04.p, woovhd.p                                           */
         {mfdeclre.i}

         define input parameter cumwo_lot as character no-undo.
         define input parameter effdate   as date      no-undo.
         define input parameter ophist_recid as recid  no-undo.

         define new shared variable eff_date like glt_effdate.
         define new shared variable ref like glt_ref.
         define new shared variable sf_cr_acct like dpt_lbr_acct.
         define new shared variable sf_cr_cc like dpt_lbr_cc.
         define new shared variable sf_dr_acct like dpt_lbr_acct.
         define new shared variable sf_dr_cc like dpt_lbr_cc.
         define new shared variable sf_entity like en_entity.
         define new shared variable sf_gl_amt like tr_gl_amt.
         define new shared variable tr_recno as recid.
         define new shared variable transtype as character format "x(7)".
         define new shared variable wo_recno as recid.
         define buffer rpsmstr for rps_mstr.
         define buffer srwkfl for sr_wkfl.
         define variable assay    like tr_assay  no-undo.
         define variable cur_mthd like cs_method no-undo.
         define variable cur_set  like cs_set    no-undo.
         define variable expire   like tr_expire no-undo.
         define variable gl_cost  like sct_cst_tot  no-undo.
         define variable unit_cost like sct_cst_tot no-undo.
         define variable glx_mthd like  cs_method   no-undo.
         define variable glx_set  like  cs_set      no-undo.
         define variable grade    like  tr_grade    no-undo.
         define variable i        as    integer     no-undo.
         define variable msgref   like  tr_msg      no-undo.
         define variable newbdn_ll as decimal no-undo.
         define variable newbdn_tl as decimal no-undo.
         define variable newcst    as decimal no-undo.
         define variable newlbr_ll as decimal no-undo.
         define variable newlbr_tl as decimal no-undo.
         define variable newmtl_ll as decimal no-undo.
         define variable newmtl_tl as decimal no-undo.
         define variable newovh_ll as decimal no-undo.
         define variable newovh_tl as decimal no-undo.
         define variable newsub_ll as decimal no-undo.
         define variable newsub_tl as decimal no-undo.
         define variable null_ch   as character initial "" no-undo.
         define variable qty_chg   like tr_qty_loc         no-undo.
         define variable qty_left  like op_qty_comp        no-undo.
         define variable reavg_yn  as logical              no-undo.
         define variable rmks      like tr_rmks            no-undo.
         define variable rpsnbr    like mrp_nbr            no-undo.
         define variable rpsrecord like rps_record         no-undo.
         define variable ovhd_amt  like glt_amt            no-undo.
         define variable inventory_amt like glt_amt        no-undo.
         define variable mcv_amt   like glt_amt            no-undo.
         define variable wip_amt   like glt_amt            no-undo.
         define variable trans-ok  like mfc_logical        no-undo.
         define variable gl_tmp_amt as decimal             no-undo.
/*J2DG*/ define variable lvar_lineid like sr_lineid        no-undo.
        DEF SHARED VAR vendlot LIKE tr_vend_lot.
         {rewrsdef.i}
         /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
         {gpatrdef.i "shared"}

/*J2DG*/ {gpcrnd.i}

         eff_date = effdate.

/*J2DG** BEGIN DELETE **
 *       find wo_mstr where wo_lot = cumwo_lot no-lock.
 *       find first gl_ctrl no-lock no-error.
 *       find pt_mstr where pt_part = wo_part no-lock.
 *       find pl_mstr where pl_prod_line = pt_prod_line no-lock.
 *       find si_mstr where si_site = wo_site no-lock.
 *       find in_mstr where in_part = wo_part and in_site = wo_site
 *       no-lock no-error.
 *J2DG** END DELETE **/

/*J2DG*/ for first wo_mstr
/*J2DG*/    fields (wo_acct wo_cc wo_lot wo_nbr wo_ovh_tot wo_part
/*J2DG*/            wo_project wo_site wo_so_job wo_vend wo_wip_tot)
/*J2DG*/    where wo_lot = cumwo_lot no-lock:
/*J2DG*/ end. /* FOR FIRST WO_MSTR */

/*J2DG*/ for first gl_ctrl
/*J2DG*/    fields (gl_inv_acct gl_inv_cc gl_rnd_mthd) no-lock:
/*J2DG*/ end. /* FOR FIRST GL_CTRL */

/*J2DG*/ for first pt_mstr
/*J2DG*/    fields (pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_prod_line
/*J2DG*/            pt_rctpo_active pt_rctpo_status pt_rctwo_active
/*J2DG*/            pt_rctwo_status pt_shelflife pt_um)
/*J2DG*/    where pt_part = wo_part no-lock:
/*J2DG*/ end. /* FOR FIRST PT_MSTR */

/*J2DG*/ for first pl_mstr
/*J2DG*/    fields (pl_inv_acct pl_inv_cc pl_ovh_acct pl_ovh_cc
/*J2DG*/            pl_prod_line pl_wvar_acct pl_wvar_cc)
/*J2DG*/    where pl_prod_line = pt_prod_line no-lock:
/*J2DG*/ end. /* FOR FIRST PL_MSTR */

/*J2DG*/ for first si_mstr
/*J2DG*/    fields (si_cur_set si_entity si_gl_set si_site si_status)
/*J2DG*/    where si_site = wo_site no-lock:
/*J2DG*/ end. /* FOR FIRST SI_MSTR */

/*J2DG*/ for first in_mstr
/*J2DG*/    fields (in_abc in_avg_date in_avg_int in_cnt_date in_cur_set
/*J2DG*/            in_cyc_int in_gl_set in_iss_chg in_iss_date in_level
/*J2DG*/            in_mrp in_part in_qty_avail in_qty_nonet in_qty_oh
/*J2DG*/            in_rctpo_active in_rctpo_status in_rctwo_active
/*J2DG*/            in_rctwo_status in_rec_date in_site in_sls_chg)
/*J2DG*/    where in_part = wo_part
/*J2DG*/      and in_site = wo_site no-lock:
/*J2DG*/ end. /* FOR FIRST IN_MSTR */

/*J2DG** find first clc_ctrl no-lock no-error. */
/*J2DG*/ for first clc_ctrl fields (clc_lotlevel) no-lock:
/*J2DG*/ end. /* FOR FIRST CLC_CTRL */

         if not available clc_ctrl then do:
            {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2DG**    find first clc_ctrl no-lock no-error. */
/*J2DG*/    for first clc_ctrl fields (clc_lotlevel) no-lock:
/*J2DG*/    end. /* FOR FIRST CLC_CTRL */
         end.

         /*DETERMINE COSTING METHOD*/
         {gprun.i ""csavg01.p"" "(input wo_part, input wo_site,
         output glx_set, output glx_mthd, output cur_set, output cur_mthd)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2DG*/ assign lvar_lineid = "+" + wo_part.
         sr-loop:
         for each sr_wkfl
/*J2DG*/    fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_site sr_userid)
            no-lock
/*J2DG**    where sr_userid = mfguser and sr_lineid = "+" + wo_part: */
/*J2DG*/    where sr_userid = mfguser
/*J2DG*/      and sr_lineid = lvar_lineid:
/*GUI*/ if global-beam-me-up then undo, leave.

            /*NO TRANSACTION SHOULD BE PENDING HERE*/

            do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

               find wo_mstr where wo_lot = cumwo_lot exclusive-lock.

               /*ADD CALL TO GPICLT.P TO CREATE LOT_MSTR */
               if (clc_lotlevel <> 0) and (sr_lotser <> "") then do:
                  {gprun.i ""gpiclt.p"" "(wo_part,
                                          sr_lotser,
                                          wo_nbr,
                                          wo_lot,
                                          output trans-ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if not trans-ok then do:
                     /*CURRENT XACTION REJECTED CONTINUE WITH NEXT XACTION*/
                     {mfmsg.i 2740 4}
                     undo sr-loop, next sr-loop.
                  end. /* IF NOT TRANS-OK */
               end. /* IF (CLC_LOTLEVEL <> 0) */

               find op_hist where recid(op_hist) = ophist_recid exclusive-lock.
               op_qty_wip = op_qty_wip + sr_qty.

               if glx_mthd = "avg" then do:
                  /*GET G/L AVG COST AND UPDATE G/L AVG COST*/
                  {gprun.i ""reupdgac.p""
                  "(input wo_lot, input sr_qty, output unit_cost)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               else do:
/*L0WN**          CALL TO GPSCT01.I IS COMMENTED OUT AND MOVED BELOW TO   */
/*                CONDITONALLY CALL WHEN SCT_DET RECORD IS NOT AVAILABLE  */
/*                FOR STANDARD COST SET, PART AND WO SITE.                */
/*                THIS WILL PREVENT UNNECESSARY LOCKING OF SCT_DET WHEN   */
/*                RECORD EXISTS.                                          */
/*L0WN**          {gpsct01.i &set=glx_set &part=pt_part &site=wo_site}    */

/*L0WN*/          for first sct_det
/*L0WN*/              fields (sct_bdn_ll sct_bdn_tl sct_cst_date sct_cst_tot
/*L0WN*/                      sct_lbr_ll sct_lbr_tl sct_mtl_ll sct_mtl_tl
/*L0WN*/                      sct_ovh_ll sct_ovh_tl sct_part sct_sim sct_site
/*L0WN*/                      sct_sub_ll sct_sub_tl)
/*L0WN*/              where sct_sim  = glx_set
/*L0WN*/                and sct_part = pt_part
/*L0WN*/                and sct_site = wo_site
/*L0WN*/              no-lock:
/*L0WN*/          end. /* FOR FIRST sct_det */
/*L0WN*/          if not available sct_det then
/*L0WN*/          do:
                     /*GET STANDARD G/L UNIT COST*/
/*L0WN*/             {gpsct01.i &set=glx_set &part=pt_part &site=wo_site}
/*L0WN*/          end. /* IF NOT AVAILABLE sct_det */

                  unit_cost = sct_cst_tot.

                  if cur_mthd = "avg" or cur_mthd = "last" then do:
                     /*UPDATE CURRENT COST*/
                     {gprun.i ""reupdcac.p""
                     "(input wo_lot, input sr_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               /*CREATE TRANSACTION HISTORY RECORD*/
               inventory_amt = unit_cost * sr_qty.

               /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J2DG**       {gprun.i ""gpcurrnd.p"" "(input-output inventory_amt,  */
/*J2DG**                                 input gl_rnd_mthd)"}         */
/*J2DG*/       run gpcrnd (input-output inventory_amt,input gl_rnd_mthd).

/*L00Y*/       /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
               {ictrans.i
               &addrid=wo_vend
               &bdnstd=0
               &cracct=wo_acct
               &crcc=wo_cc
               &crproj=wo_project
               &curr=""""
               &dracct="
                  if available pt_mstr then
                  if available pld_det then pld_inv_acct
                  else pl_inv_acct
                  else gl_inv_acct"
               &drcc="
                  if available pt_mstr then
                  if available pld_det then pld_inv_cc
                  else pl_inv_cc
                  else gl_inv_cc"
               &drproj=""""
               &effdate=eff_date
               &exrate=0
               &exrate2=0
               &exratetype=""""
               &exruseq=0
               &glamt=inventory_amt
               &lbrstd=0
               &line=0
               &location="(if sr_site <> wo_site then pt_loc
                           else sr_loc)"
               &lotnumber=wo_lot
               &lotserial=sr_lotser
               &lotref=sr_ref
               &mtlstd=0
               &ordernbr=wo_nbr
               &ovhstd=0
               &part=wo_part
               &perfdate=?
               &price=unit_cost
               &quantityreq=0
               &quantityshort=0
               &quantity="sr_qty"
               &revision=""""
               &rmks=rmks
               &shiptype=""""
               &site=wo_site
               &slspsn1=""""
               &slspsn2=""""
               &sojob=wo_so_job
               &substd=0
               &transtype=""RCT-WO""
               &msg=msgref
               &ref_site=tr_site
               }

               wo_wip_tot = wo_wip_tot - inventory_amt.
               tr_recno = recid(tr_hist).

               if glx_mthd = "AVG" then do:
                  trgl_type = "RCT-AVG".
               end.

               /*POST OVERHEAD.  NOTE WE DR WIP BECAUSE WE ALREADY TOOK
                 OVHD  OUT  OF  WIP  IN  THE PRECEDING ICTRANS, BY WAY OF
                 sct_ovh_tl ALREADY INCLUDED IN sct_cst_tot*/

               /*GET COST SET*/
               {gpsct01.i &set=glx_set &part=wo_part &site=wo_site}

               ovhd_amt = sr_qty * sct_ovh_tl.

               /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J2DG**       {gprun.i ""gpcurrnd.p"" "(input-output ovhd_amt, */
/*J2DG**                                 input gl_rnd_mthd)"}   */
/*J2DG*/       run gpcrnd (input-output ovhd_amt,input gl_rnd_mthd).

               if ovhd_amt <> 0 then do:
                  create trgl_det.

                  assign
                     trgl_trnbr = tr_trnbr
                     trgl_sequence = recid(trgl_det)

                     trgl_dr_acct = wo_acct
                     trgl_dr_cc = wo_cc
                     trgl_dr_proj = wo_project

                     trgl_cr_acct = pl_ovh_acct
                     trgl_cr_cc = pl_ovh_cc
                     trgl_cr_proj = wo_project

                     trgl_gl_amt = ovhd_amt.

                  {mficgl02.i &gl-amount=trgl_gl_amt
                              &tran-type=trgl_type
                              &order-no=wo_nbr
                              &dr-acct=trgl_dr_acct
                              &dr-cc=trgl_dr_cc
                              &drproj=trgl_dr_proj
                              &cr-acct=trgl_cr_acct
                              &cr-cc=trgl_cr_cc
                              &crproj=trgl_cr_proj
                              &entity=si_entity
                              &same-ref="icc_gl_sum"
                  }

                  wo_ovh_tot = wo_ovh_tot + trgl_gl_amt.
                  wo_wip_tot = wo_wip_tot + ovhd_amt.
               end. /*if ovhd_amt <> 0 */

               if glx_mthd <> "AVG" then do:

                  /*POST  DIFFERENCE  BETWEEN  FINISHED   MATERIAL   COST,
                    OVERHEAD   POSTED,  AND  COST  AT  THE  LAST  OPERATION,
                    EXTENDED TO METHOD CHANGE  VARIANCE.   NOTE  WE  DR  WIP
                    BECAUSE  WE ALREADY TOOK MCV OUT OF WIP IN THE PRECEDING
                    ICTRANS.*/

/*J2DG**          find last wr_route where wr_lot = cumwo_lot no-lock. */
/*J2DG*/          for last wr_route
/*J2DG*/             fields (wr_lot wr_op wr_qty_cummove wr_qty_outque)
/*J2DG*/             where wr_lot = cumwo_lot no-lock:
/*J2DG*/          end. /* FOR LAST WR_ROUTE */

/*J2DG** BEGIN DELETE **
 *                find iro_det where iro_part = wo_part
 *                               and iro_site = wo_site
 *                               and iro_cost_set = "cumorder"
 *                               and iro_routing = wo_lot
 *                               and iro_op = wr_op
 *                               no-lock.
 *J2DG** END DELETE **/

/*J2DG*/         for first iro_det
/*J2DG*/            fields (iro_cost_set iro_cost_tot iro_op iro_part
/*J2DG*/                    iro_routing iro_site)
/*J2DG*/            where iro_part = wo_part
/*J2DG*/              and iro_site = wo_site
/*J2DG*/              and iro_cost_set = "cumorder"
/*J2DG*/              and iro_routing = wo_lot
/*J2DG*/              and iro_op = wr_op no-lock:
/*J2DG*/         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST IRO_DET */

                    wip_amt = sr_qty * iro_cost_tot.

                  /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J2DG**          {gprun.i ""gpcurrnd.p"" "(input-output wip_amt,   */
/*J2DG**                                    input gl_rnd_mthd)"}    */
/*J2DG*/          run gpcrnd (input-output wip_amt,input gl_rnd_mthd).

                  mcv_amt = wip_amt - (inventory_amt - ovhd_amt).

                  if mcv_amt <> 0 then do:
                     create trgl_det.

                     assign
                        trgl_trnbr = tr_trnbr
                        trgl_type = "MTHD CHG"
                        trgl_sequence = recid(trgl_det)

                        trgl_dr_acct = pl_wvar_acct
                        trgl_dr_cc = pl_wvar_cc
                        trgl_dr_proj = wo_project

                        trgl_cr_acct = wo_acct
                        trgl_cr_cc = wo_cc
                        trgl_cr_proj = wo_project

                        trgl_gl_amt = mcv_amt.

                     {mficgl02.i &gl-amount=trgl_gl_amt
                              &tran-type=trgl_type
                              &order-no=wo_nbr
                              &dr-acct=trgl_dr_acct
                              &dr-cc=trgl_dr_cc
                              &drproj=trgl_dr_proj
                              &cr-acct=trgl_cr_acct
                              &cr-cc=trgl_cr_cc
                              &crproj=trgl_cr_proj
                              &entity=si_entity
                              &same-ref="icc_gl_sum"
                     }

                     wo_wip_tot = wo_wip_tot - mcv_amt.

                   end. /* IF mcv_amt <> 0 */

               end. /* IF glx_mthd <> "AVG"  */

               /*IF FROM DIFFERENT SITE THAN CUM WO DO AN INVENTORY TRANSFER*/

               if sr_site <> wo_site then do:
/*J2DG*/          assign
                     global_part = wo_part
                     global_addr = wo_vend.

                  /* CHANGED wo_site LOCATION FROM sr_loc TO pt_loc */
                  /* Added ship_nbr, ship_date, inv_mov */
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
                       output gl_cost,
                       input-output assay,
                       input-output grade,
                       input-output expire)" }
/*GUI*/ if global-beam-me-up then undo, leave.


                  /*CHANGE ATTRIBUTES*/
/*J2DG**          find tr_hist no-lock where tr_trnbr = trmsg no-error. */
/*J2DG*/          for first tr_hist
/*J2DG*/             where tr_trnbr = trmsg no-lock:
/*J2DG*/          end. /* FOR FIRST TR_HIST */

               end.

               /*CHANGE ATTRIBUTES*/
               if available tr_hist then do:
/*J39K*/          /* ADDED FIFTH PARAMETER EFF_DATE */
                  {gprun.i ""worcat03.p"" "(input recid(sr_wkfl),
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
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

               /*REGISTER QTY RECEIVED WITH CUM ORDER ROUTING RECORD*/

               find last wr_route where wr_lot = cumwo_lot exclusive-lock.
               {rewrsget.i &lot=wr_lot &op=wr_op &lock=exclusive-lock}
/*J2DG*/       assign
                  wr_qty_cummove = wr_qty_cummove + sr_qty
                  wr_qty_outque = wr_qty_outque - sr_qty.
               {rewrsput.i &lot=wr_lot &op=wr_op}

               /*UPDATE REPETITIVE SCHEDULE*/

               {gprun.i ""reupdscf.p"" "(input cumwo_lot, input sr_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               release wo_mstr.
               release wr_route.
            end.

            do for srwkfl transaction:
               find srwkfl where recid(srwkfl) = recid(sr_wkfl) exclusive-lock.
               delete srwkfl.
            end.

         end.
