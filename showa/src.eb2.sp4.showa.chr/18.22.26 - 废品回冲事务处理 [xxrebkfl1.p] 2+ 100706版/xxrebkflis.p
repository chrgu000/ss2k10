/* GUI CONVERTED from rebkflis.p (converter v1.76) Sun May 18 22:31:33 2003 */
/* rebkflis.p - REPETITIVE                                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.26 $                                       */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*               */
/* REVISION: 7.3      LAST MODIFIED: 09/02/95   BY: qzl *G0W7*               */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*               */
/* REVISION: 8.5      LAST MODIFIED: 10/13/95   BY: TAF *J053*               */
/* REVISION: 7.2      LAST MODIFIED: 01/17/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 03/13/96   BY: jym *G1GD*               */
/* REVISION: 8.5      LAST MODIFIED: 05/16/96   BY: *G1VQ* Julie Milligan    */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates        */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/28/00   BY: *N0WD* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.15     BY: Sathish Kumar    DATE: 07/05/01 ECO: *M199*        */
/* Revision: 1.16     BY: Ellen Borden     DATE: 04/03/01 ECO: *P00G*        */
/* Revision: 1.17     BY: Jeff Wootton     DATE: 05/14/02 ECO: *P03G*        */
/* Revision: 1.19     BY: Patrick Rowan    DATE: 05/24/02 ECO: *P018*        */
/* Revision: 1.20     BY: Steve Nugent     DATE: 06/10/02  ECO: *P07Y*       */
/* Revision: 1.23     BY: Dorota Hohol     DATE: 02/25/03  ECO: *P0N6*       */
/* Revision: 1.25     BY: Narathip W.      DATE: 04/29/03  ECO: *P0Q9*       */
/* $Revision: 1.26 $    BY: Geeta Kotian     DATE: 05/16/03  ECO: *N289* */
/* $Revision: 1.43 $  BY: Mage.  DATE: 06/27/04 ECO: *zh003* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE.                                     */

/* BACKFLUSH TRANSACTION ISSUE COMPONENTS SUBPROGRAM (TAKEN FROM rewois.p)   */
{mfdeclre.i}
{cxcustom.i "REBKFLIS.P"}

define input parameter cumwo_lot as character.
define input parameter eff_date  as date.
define input parameter ophist_recid as recid no-undo.

define new shared variable transtype as character format "x(7)".
define buffer pkdet for pk_det.
define variable assay                 like tr_assay no-undo.
define variable component_cost_set     as character no-undo.
define variable component_costing_mthd as character no-undo.
define variable component_cur_mthd     as character no-undo.
define variable component_cur_set      as character no-undo.

define variable cur_mthd               like cs_method no-undo.
define variable cur_set                like cs_set  no-undo.
define variable cur_std_cost           like sct_cst_tot no-undo.
define variable del-yn                 like mfc_logical no-undo.

define variable expire                 like tr_expire   no-undo.
define variable from_cost              like glxcst      no-undo.
define variable from_entity            like en_entity   no-undo.
define variable gl_amt                 like glt_amt     no-undo.
define variable glcost                 like sct_cst_tot no-undo.
define variable glx_mthd               like cs_method   no-undo.
define variable glx_set                like cs_set      no-undo.
define variable grade                  like tr_grade    no-undo.
define variable i                      as integer       no-undo.

define variable lotqty                 like wod_qty_chg no-undo.
define variable open_ref               like mrp_qty     no-undo.
define variable prline                 like rps_line    no-undo.
define variable qty                    as decimal       no-undo.
define variable qty_left               like tr_qty_chg  no-undo.
define variable ref                    like glt_ref     no-undo.
define variable site                   like ld_site     no-undo.
define variable srloc                  as character     no-undo.
define variable srlotser               as character     no-undo.
define variable srqty                  as decimal       no-undo.
define variable srref                  as character     no-undo.
define variable srsite                 as character     no-undo.
define variable sr_recid               as recid         no-undo.
/*zh003*/ define variable sruser2       as character    no-undo.
define variable totlotqty              like wod_qty_chg no-undo.
define variable var_amt                like glt_amt     no-undo.
define variable wo_cost_set            as character     no-undo.
define variable wo_costing_mthd        as character     no-undo.
define variable wo_cur_mthd            as character     no-undo.
define variable wo_cur_set             as character     no-undo.
define variable wo_entity              like en_entity   no-undo.
define variable wod_recid              as recid         no-undo.
define variable wopart                 like wo_part     no-undo.
define variable yn                     like mfc_logical no-undo.
define variable op                     as integer       no-undo.
define variable gl_tmp_amt             as decimal       no-undo.
define variable lvar_lineid            like sr_lineid   no-undo.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
{&REBKFLIS-P-TAG8}

{pocnvars.i}
define variable is_xfer as logical initial false no-undo.
define variable io_batch like cnsu_batch no-undo.

define shared variable h_wiplottrace_procs as handle no-undo.
define shared variable h_wiplottrace_funcs as handle no-undo.

{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i}  /*CONSTANTS DEFINITIONS*/

/* PROCEDURE FOR ROUNDING FOR GIVEN ROUNDING METHOD */
{gpcrnd.i}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


{&REBKFLIS-P-TAG1}

for first icc_ctrl
fields (icc_cogs icc_gl_set icc_gl_sum icc_gl_tran icc_mirror)
no-lock:
end. /* FOR FIRST ICC_CTRL */

for first gl_ctrl
fields (gl_inv_acct gl_inv_sub gl_inv_cc gl_rnd_mthd)
no-lock:
end. /* FOR FIRST GL_CTRl */

for first wo_mstr
fields (wo_acct wo_sub wo_cc
        wo_line wo_lot wo_mtl_var
        wo_mvrr_acct wo_mvrr_sub wo_mvrr_cc
        wo_nbr wo_part wo_project wo_site wo_so_job wo_vend wo_wip_tot)
where wo_lot = cumwo_lot no-lock:
end. /* FOR FIRST WO_MSTR */

{gprun.i ""csavg01.p""
   "(input wo_part, input wo_site,
     output wo_cost_set, output wo_costing_mthd, output wo_cur_set,
     output wo_cur_mthd)"}
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


assign
   wopart = wo_part
   prline = wo_line
   site = wo_site.

for first si_mstr
fields (si_cur_set si_entity si_gl_set si_site si_status)
where si_site = wo_site no-lock:
end. /* FOR FIRST SI_MSTR */

wo_entity = si_entity.

for each pk_det
{&REBKFLIS-P-TAG9}
fields (pk_loc pk_part pk_qty pk_reference pk_user)
{&REBKFLIS-P-TAG10}
where pk_user = mfguser no-lock:

   op = integer(pk_reference).

   for first wo_mstr
   fields (wo_acct wo_sub wo_cc
           wo_line wo_lot wo_mtl_var
           wo_mvrr_acct wo_mvrr_sub wo_mvrr_cc
           wo_nbr wo_part
           wo_project wo_site wo_so_job wo_vend wo_wip_tot)
   where wo_lot = cumwo_lot no-lock:
   end. /* FOR FIRST WO_MSTR */

   if pk_qty <> 0 then do:

      {gprun.i ""csavg01.p""
         "(input pk_part, input wo_site,
           output component_cost_set, output component_costing_mthd,
           output component_cur_set, output component_cur_mthd)"}
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


      do transaction:
/* /*GUI*/ if global-beam-me-up then undo, leave.  */

         {gpsct01.i &set=component_cost_set &site=wo_site &part=pk_part}
         cur_std_cost = sct_cst_tot.
      end.
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


      for first pt_mstr
      fields (pt_abc pt_avg_int pt_cyc_int pt_loc pt_part
              pt_prod_line pt_rctpo_active pt_rctpo_status
              pt_rctwo_active pt_rctwo_status pt_shelflife pt_um)
      where pt_part = pk_part no-lock:
      end.  /* FOR FIRST PT_MSTR */

      if available pt_mstr then do:

         for first pl_mstr
         fields (pl_inv_acct pl_inv_sub pl_inv_cc pl_prod_line)
         where pl_prod_line = pt_prod_line no-lock:
         end. /* FOR FIRST PL_MSTR */

         if available pl_mstr then do:

            for first pld_det
            fields (pld_inv_acct pld_inv_sub pld_inv_cc
                   pld_loc pld_prodline pld_site)
            where pld_prodline = pl_prod_line
              and pld_site = wo_site no-lock:
            end. /* FOR FIRST PLD_DET */

         end.
      end.

      assign
         srqty = pk_qty
         srsite = wo_site
         srloc = pk_loc
         srlotser = ""
         srref = ""
         sr_recid = ?.

      assign
         lvar_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

      for first sr_wkfl
      fields (sr_lineid sr_loc sr_lotser sr_qty
              sr_ref sr_site sr_userid sr_user2)
      where sr_userid = mfguser
        and sr_lineid = lvar_lineid no-lock:
      end. /* FOR FIRST SR_WKFL */

      if available sr_wkfl then do:
         assign
            srqty = sr_qty
            srsite = sr_site
            srloc = sr_loc
            srlotser = sr_lotser
            srref = sr_ref
            sr_recid = recid(sr_wkfl)
/*zh003*/	sruser2 = sr_user2.
      end.

      repeat:

         {&REBKFLIS-P-TAG6}

         /*NO TRANSACTION SHOULD BE PENDING HERE*/
         for first wo_mstr
         fields (wo_acct wo_sub wo_cc
                 wo_line wo_lot wo_mtl_var
                 wo_mvrr_acct wo_mvrr_sub wo_mvrr_cc
                 wo_nbr wo_part
                 wo_project wo_site wo_so_job wo_vend wo_wip_tot)
         where wo_lot = cumwo_lot no-lock:
         end. /* FOR FIRST WO_MSTR */

         if srsite <> wo_site then do:
            assign
               global_part = pk_part
               transtype   = "ISS-TR".

            {&REBKFLIS-P-TAG2}
            {gprun.i
               ""icxfer.p""
               "(wo_lot,
                 srlotser,
                 srref,
                 srref,
                 srqty,
                 wo_nbr,
                 wo_so_job,
                 """",
                 wo_project,
                 eff_date,
                 srsite,
                 srloc,
                 wo_site,
                 pt_loc,
                 no,
                 """",
                 ?,
                 """",
                 0,
                 output glcost,
                 output iss_trnbr,
                 output rct_trnbr,
                 input-output assay,
                 input-output grade,
                 input-output expire)"}
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


            {&REBKFLIS-P-TAG13}
            {&REBKFLIS-P-TAG3}

         end.

         do transaction:
/* /*GUI*/ if global-beam-me-up then undo, leave.  */

            {gpsct01.i &set=component_cost_set &site=wo_site
               &part=pk_part}
            assign
               cur_std_cost = sct_cst_tot
               gl_amt       = srqty * cur_std_cost.
         end.
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


         /* ROUND PER BASE CURRENCY ROUND METHOD */
         run gpcrnd
            (input-output gl_amt,
             input gl_rnd_mthd).

         do transaction:
/* /*GUI*/ if global-beam-me-up then undo, leave.  */


            find wo_mstr where wo_lot = cumwo_lot exclusive-lock.

            find wod_det where wod_lot = wo_lot
                           and wod_part = pk_part
                           and wod_op = op
            exclusive-lock no-error.

            if not available wod_det then do:

               create wod_det.
               assign
                  wod_lot = wo_lot
                  wod_nbr = wo_nbr
                  wod_part = pk_part
                  wod_op = op
                  wod_site = wo_site
                  wod_loc = ?
                  wod_iss_date = ?
                  wod_bom_amt = cur_std_cost.

               create qad_wkfl.
               assign
                  qad_key1 = "MFWORLA"
                  qad_key2 = wod_lot + wod_part + string(wod_op)
                  qad_decfld[1] = pk_qty
                  qad_decfld[2] = 1.
            end.

            {&REBKFLIS-P-TAG11}
            {&REBKFLIS-P-TAG4}

            {ictrans.i
               &addrid=wo_vend
               &bdnstd=0
               &cracct="if available pl_mstr then
                           if available pld_det then pld_inv_acct
                           else pl_inv_acct
                       else gl_inv_acct"
               &crsub="if available pl_mstr then
                          if available pld_det then pld_inv_sub
                          else pl_inv_sub
                       else gl_inv_sub"
               &crcc="if available pl_mstr then
                         if available pld_det then pld_inv_cc
                         else pl_inv_cc
                      else gl_inv_cc"
               &crproj=""""
               &curr=""""
               &dracct=wo_acct
               &drsub=wo_sub
               &drcc=wo_cc
               &drproj=wo_project
               &effdate=eff_date
               &exrate=0
               &exrate2=0
               &exratetype=""""
               &exruseq=0
               &glamt=gl_amt
               &lbrstd=0
               &line=0
               &location="(if srsite <> wo_site then pt_loc
                           else srloc)"
               &lotnumber=wo_lot
               &lotserial=srlotser
               &lotref=srref
               &mtlstd=0
               &ordernbr=wo_nbr
               &ovhstd=0
               &part=pk_part
               &perfdate=?
               &price=cur_std_cost
               &quantityreq=srqty
               &quantityshort=0
               &quantity="- srqty"
               &revision=""""
/*zh003*/      &rmks="sruser2"
               &shiptype=""""
               &site=wo_site
               &slspsn1=""""
               &slspsn2=""""
               &sojob=wo_so_job
               &substd=0
               &transtype=""ISS-WO""
               &msg=0
               &ref_site=tr_site}

            {&REBKFLIS-P-TAG12}
            {&REBKFLIS-P-TAG5}

            if srsite <> wo_site then do:
               assign
                  tr_assay = assay
                  tr_grade = grade
                  tr_expire = expire.
            end.

            find wr_route where wr_lot = wo_lot and wr_op = op
            exclusive-lock.

            if wo_costing_mthd = "AVG" then do:
               assign
                  wo_wip_tot    = wo_wip_tot + gl_amt
                  wod_tot_std   = wod_tot_std + gl_amt
                  wr_mtl_ll_act = wr_mtl_ll_act + gl_amt.
            end.

            else do:

               var_amt = (cur_std_cost - wod_bom_amt) * srqty.

               /* ROUND PER BASE CURRENCY ROUND METHOD */
               run gpcrnd
                  (input-output var_amt,
                   input gl_rnd_mthd).

               if var_amt <> 0 then do:

                  create trgl_det.
                  assign
                     trgl_trnbr = tr_trnbr
                     trgl_type = "RATE VAR"
                     trgl_sequence = recid(trgl_det)
                     trgl_dr_acct = wo_mvrr_acct
                     trgl_dr_sub = wo_mvrr_sub
                     trgl_dr_cc = wo_mvrr_cc
                     trgl_dr_proj = ""
                     trgl_cr_acct = wo_acct
                     trgl_cr_sub = wo_sub
                     trgl_cr_cc = wo_cc
                     trgl_cr_proj = wo_project
                     trgl_gl_amt = var_amt.

                  tr_gl_amt = tr_gl_amt - var_amt.

                  {mficgl02.i &gl-amount=var_amt
                     &tran-type=tr_type
                     &order-no=tr_nbr
                     &dr-acct=trgl_dr_acct
                     &dr-sub=trgl_dr_sub
                     &dr-cc=trgl_dr_cc
                     &drproj=trgl_dr_proj
                     &cr-acct=trgl_cr_acct
                     &cr-sub=trgl_cr_sub
                     &cr-cc=trgl_cr_cc
                     &crproj=trgl_cr_proj
                     &entity=wo_entity
                     &find="false"
                     &same-ref="icc_gl_sum"}

               end. /* if var_amt <> 0 */

               assign
                  wod_mvrte_post = wod_mvrte_post + var_amt
                  wod_mvrte_accr = wod_mvrte_accr + var_amt
                  wod_tot_std    = wod_tot_std + gl_amt - var_amt
                  wr_mtl_ll_act  = wr_mtl_ll_act + gl_amt - var_amt
                  wo_wip_tot     = wo_wip_tot + gl_amt - var_amt
                  wo_mtl_var     = wo_mtl_var + var_amt.

            end. /* else do (if costing method is not AVG) */

            assign
               wod_qty_iss = wod_qty_iss + srqty
               wod_qty_req = wod_qty_iss
               wod_qty_chg = 0
               wod_bo_chg = 0.

             /* CREATE CONSIGNMENT USAGE RECORDS IF CONSIGNMENT ENABLED*/
             /* AND CONSIGNMENT INVENTORY EXISTS.                      */
            if using_supplier_consignment then do:
               {gprunmo.i
                  &program  = ""pocnsix4.p""
                  &module   = "ACN"
                  &param    =  """(input wod_part,
                                   input wo_site,
                                   input srlotser,
                                   input srref,
                                   output consign_flag)"""}

                /*IF CONSIGNED INVENTORY EXISTS, DETERMINE WHETHER TO */
                /*USE IT PRIOR TO UNCONSIGNED INVENTORY.              */
               if consign_flag then do:
                  {gprunmo.i
                     &program  = ""ictrancn.p""
                     &module   = "ACN"
                     &param    =  """(input wo_nbr,
                                      input wo_lot,
                                      input wod_op,
                                      input wo_so_job,
                                      input srqty,
                                      input srlotser,
                                      input pk_part,
                                      input wo_site,
                                      input (if srsite <> wo_site
                                             then pt_loc
                                             else srloc),
                                      input srref,
                                      input eff_date,
                                      input tr_trnbr,
                                      input is_xfer,
                                      input-output io_batch)"""}


               end. /*If consign_flag*/
            end. /*IF USING_SUPPLIER_CONSIGNMENT*/

            if is_wiplottrace_enabled()
               and is_operation_queue_lot_controlled
                  (wod_lot, wod_op, OUTPUT_QUEUE)
               and is_wocomp_wiplot_traced(wod_lot, pk_part)
            then do:

               /*REGISTER THE MATERIAL CONSUMED IN THE TRACING JOURNAL*/
               for first op_hist where recid(op_hist) = ophist_recid
               no-lock:
               end.

               run add_trace_record in h_wiplottrace_procs
                  (input OPERATION_HISTORY,
                   input op_trnbr,
                   input CONSUMED_MTL,
                   input ITEM_MTL,
                   input '',
                   input 0,
                   input pk_part,
                   input srlotser,
                   input if is_wocomp_reference_traced(wo_lot, pk_part) then
                            srref
                         else '',
                   input srqty).

            end.
/* /*GUI*/ if global-beam-me-up then undo, leave.  */
 /* if is_wiplottrace_enabled... */

            release wo_mstr.
            release wod_det.
            release wr_route.

            if sr_recid <> ? then do:
               find sr_wkfl where recid(sr_wkfl) = sr_recid
               exclusive-lock.
               delete sr_wkfl.
            end.

            assign
               lvar_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

            for first sr_wkfl
            fields (sr_lineid sr_loc sr_lotser sr_qty
                    sr_ref sr_site sr_userid sr_user2)
            where sr_userid = mfguser
              and sr_lineid = lvar_lineid no-lock:
            end. /* FOR FIRST SR_WKFl */

            if not available sr_wkfl then leave.

            assign
               srqty = sr_qty
               srsite = sr_site
               srloc = sr_loc
               srlotser = sr_lotser
               srref = sr_ref
               sr_recid = recid(sr_wkfl).

         end. /* do transaction */

      end. /* repeat */

   end. /* if pk_qty <> 0 */

   do transaction:
      find pkdet where recid(pkdet) = recid(pk_det) exclusive-lock.
      delete pkdet.
   end.

end.

{&REBKFLIS-P-TAG7}
