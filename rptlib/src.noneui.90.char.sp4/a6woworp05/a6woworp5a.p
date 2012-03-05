/* woworp5a.p - WORK ORDER COST REPORT                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K0XV*//*V8:ConvertMode=Report                                */

/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: ram *D611*          */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 03/02/92    BY: pma *F085*          */
/* REVISION: 7.0     LAST MODIFIED: 06/17/92    BY: pma *F664*          */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*          */
/* REVISION: 7.3     LAST MODIFIED: 04/28/93    BY: pma *GA47*          */
/* REVISION: 7.2     LAST MODIFIED: 04/12/94    BY: pma *FN34*          */
/* REVISION: 7.3     LAST MODIFIED: 09/23/94    BY: cpp *FQ88*          */
/* REVISION: 7.5     LAST MODIFIED: 10/19/94    BY: TAF *J035*          */
/* REVISION: 7.3     LAST MODIFIED: 12/07/94    BY: pxd *FU43*          */
/* REVISION: 7.5     LAST MODIFIED: 02/27/94    BY: tjs *J027*          */
/* REVISION: 8.5     LAST MODIFIED: 10/25/95    BY: sxb *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW* Julie Milligan */
/* REVISION: 8.5     LAST MODIFIED: 08/11/97    BY: *J1WK* Molly Balan    */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0XV*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 01/21/99   BY: *M066* Patti Gaultney */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/05   BY: *SS - 20050804* Bill Jiang       */
/******************************************************************/
/*F003   REPLACED PREVIOUSLY EXISTING LOGIC IN ITS ENTIRETY       */
/******************************************************************/
/*J053   MOST OF THE ROUNDING FUNCTIONS IN THIS PROGRAM HAVE BEEN */
/*J053   REMOVED BECAUSE THE VALUES ARE DERIVED FROM AMOUNTS THAT */
/*J053   HAVE BEEN ROUNDED ELSEWHERE IN MFG/PRO (WITH THIS ECO).  */
/*J053   WHERE WE DID NEED TO ROUND, WE ROUNDED BASED ON THE      */
/*J053   DECIMAL PRECISION OF THE BASE CURRENCY.                  */
/******************************************************************/
/* SS - 20050804 - B */
{a6woworp05.i}

define input parameter nbr   like wo_nbr.
define input parameter nbr1  like wo_nbr.
define input parameter lot   like wo_lot.
define input parameter lot1  like wo_lot.
define input parameter part  like wo_part.
define input parameter part1 like wo_part.
define input parameter due   like wo_due_date.
define input parameter due1  like wo_due_date.

define input parameter acct_close like wo_acct_close.
define input parameter CLOSE_date   like wo_close_date.
define input parameter close_date1  like wo_close_date.
define input parameter CLOSE_eff   like wo_close_eff.
define input parameter close_eff1  like wo_close_eff.

define input parameter so_job like wo_so_job.
define input parameter vend  like wo_vend.
define input parameter stat like wo_status.

define input parameter mtlyn like mfc_logical.
define input parameter lbryn like mfc_logical.
define input parameter bdnyn like mfc_logical.
define input parameter subyn like mfc_logical.

define input parameter skpage like mfc_logical.
/* SS - 20050804 - E */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp5a_p_1 "过帐的!使用!差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_2 "过帐的!费率差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_3 "转包成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_4 "转包合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_5 "加工单小计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_6 "预期成本!(仅作参考)"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_7 "复合/副产品"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_8 "按加工单分页"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_9 "D-明细/S-汇总"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_10 "附加成本合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_11 "人工合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_12 "应计!差异!(仅为参考)"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_13 "人工"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_14 "附加费"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_15 "物料合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_16 "累计成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_17 "物料成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_18 "累计数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_19 "余额:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_20 "余额"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_21 "收到的成品!平均成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_22 "       工序: "
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_23 "- 收到的成本到成品:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_24 " - 差异:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_25 " - 混合差异:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_26 " - 方法改变差异:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_27 " - 报废:"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp5a_p_28 " - 收到的标准成本:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*K0XV*/ {wbrp02.i}


             /* SS - 20050804 - B */
             /*
         define shared variable nbr like wo_nbr.
         define shared variable nbr1 like wo_nbr.
         define shared variable lot like wo_lot.
         define shared variable lot1 like wo_lot.
         define shared variable part like wo_part.
         define shared variable part1 like wo_part.
         define shared variable due like wo_due_date.
         define shared variable due1 like wo_due_date.
         define shared variable vend like wo_vend.
         define shared variable so_job like wo_so_job.
         define shared variable stat like wo_status.
         define shared variable mtlyn like mfc_logical initial yes
            label {&woworp5a_p_17}     format {&woworp5a_p_9}.
         define shared variable lbryn like mfc_logical initial yes
            label {&woworp5a_p_13}        format {&woworp5a_p_9}.
         define shared variable bdnyn like mfc_logical initial yes
            label {&woworp5a_p_14}       format {&woworp5a_p_9}.
         define shared variable subyn like mfc_logical initial yes
            label {&woworp5a_p_3}  format {&woworp5a_p_9}.
         define shared variable skpage like mfc_logical initial yes
            label {&woworp5a_p_8}.
         */
         /* SS - 20050804 - E */

         define variable desc1    like pt_desc1.
         define variable acctot   like wod_tot_std.
         define variable exptot   like wod_tot_std.
         define variable rtetot   like wod_mvrte_post.
         define variable usetot   like wod_mvuse_post.
         define variable acrtot   like wod_mvuse_accr.
         define variable wiptot   like wo_wip_tot.
/*F085   define variable vartot   like wo_wip_tot.         */
         define variable accqty   like wod_qty_iss
            column-label {&woworp5a_p_18}.
         define variable acccst   like wod_tot_std
            column-label {&woworp5a_p_16}.
         define variable expcst   like wod_tot_std
            column-label {&woworp5a_p_6}.
         define variable rtevar   like wod_mvrte_post
            column-label {&woworp5a_p_2}.
         define variable usevar   like wod_mvuse_post
            column-label {&woworp5a_p_1}.
         define variable acrvar   like wod_mvuse_accr
            column-label {&woworp5a_p_12}.
/*J053** define variable wipamt   like wo_wip_tot ***********/
/*J053*/ define variable wipamt   like wod_mvrte_post
            column-label {&woworp5a_p_20}.
/*F085   define variable varamt   like wod_tot_std            */
/*F085      column-label "Residual!Variance!in WIP ".       */
         define variable premsg   as character.
         define variable item     like wod_part format "x(20)".
         define variable i        as integer.
/*F085*/ define variable glx_mthd like cs_method.
/*F085*/ define variable glx_set  like cs_set.
/*F085*/ define variable cur_mthd like cs_method.
/*F085*/ define variable cur_set  like cs_set.
/*F085*/ define variable wowipx   like wod_tot_std
            column-label {&woworp5a_p_21}.
/*F085*/ define variable wototx   like wod_tot_std.
/*GA24*/ define variable firstwo  like mfc_logical.
/*FN34*/ define variable display_det like mfc_logical.
/*J053*/ define variable tmp_fmt  as   character no-undo.

/*J027*/ define buffer wo_mstr1 for wo_mstr.

/*J1WK*/ define variable status-type as character no-undo.
/*J1WK*/ define variable status-label as character no-undo.

         form
            wo_nbr         colon 15
            wo_lot         colon 45
/*J035*/    wo_batch       colon 71
            wo_rmks        colon 71
            wo_part        colon 15
            wo_so_job      colon 45
            wo_qty_ord     colon 71
            wo_ord_date    colon 104
/*F085*/    glx_mthd       no-label
            desc1          at 17 no-label
            wo_qty_comp    colon 71
            wo_rel_date    colon 104
            premsg         no-label
            wo_status      colon 15
            wo_vend        colon 45
            wo_qty_rjct    colon 71
            wo_due_date    colon 104
         with frame b side-labels width 132 no-attr-space.

/*J053*/ form
/*J053*/    item
/*J053*/    accqty
/*J053*/    expcst
/*J053*/    acrvar
/*J053*/    acccst
/*J053*/    rtevar
/*J053*/    usevar
/*J053*/    wowipx
/*J053*/    wipamt
/*J053*/ with frame c width 132 down no-attr-space.

/*GA24*/ firstwo = yes.
/*J053*/ find first gl_ctrl no-lock.

/* SS - 20050804 - B */
OUTPUT TO "a6woworp5a".
/* SS - 20050804 - E */

         /* FIND AND DISPLAY */
         for each wo_mstr
            where (wo_nbr >= nbr) and (wo_nbr <= nbr1)
            and (wo_lot >= lot) and (wo_lot <= lot1 )
            and (wo_part >= part) and (wo_part <= part1 or part1 = "" )
            and (wo_due_date >= due or due = ?)
            and (wo_due_date <= due1 or due1 = ?)
            and (wo_vend = vend or vend = "" )
            and (wo_so_job = so_job or so_job = "" )
            and (wo_status = stat or stat = "")
/*J027*/    and (wo_joint_type = "" or wo_joint_type = "5")
             /* SS - 20050804 - B */
             AND (wo_acct_close = acct_close OR acct_close = NO)
             and (wo_close_date >= CLOSE_date or CLOSE_date = ?)
             and (wo_close_date <= close_date1 or close_date1 = ?)
             and (wo_close_eff >= CLOSE_eff or CLOSE_eff = ?)
             and (wo_close_eff <= close_eff1 or close_eff1 = ?)
             /* SS - 20050804 - E */
         no-lock break by wo_nbr by wo_lot with frame c width 132
         no-attr-space:

/*GA24*/    find pt_mstr no-lock
/*GA24*/    where pt_part = wo_part no-error.

/*GA24*/    find ptp_det no-lock
/*GA24*/    where ptp_part = wo_part
/*GA24*/    and ptp_site = wo_site no-error.

/*FQ88******BEGIN REMOVED CODE *******************************************
 *          if wo_status = "P"
 *          and ((available ptp_det and ptp_pm_code <> "M")
 *          or (not available ptp_det
 *          and available pt_mstr and pt_pm_code <> "M"))
 *          then next.
 *FQ88******END REMOVED CODE */

/*FQ88* PLANNED ORDERS (WO_STATUS = P) PRINT ONLY IF PM_CODE = M OR = SPACE */
/*M066* PLANNED ORDERS(WO_STATUS = P)PRINT ONLY IF PM_CODE = M,SPACE OR L */
/*FQ88*/    if wo_status = "P"
/*FQ88*/    and ((available ptp_det and
/*M066 /*FQ88*/ ptp_pm_code <> "M" and ptp_pm_code <> "") */
/*M066*/    ptp_pm_code <> "M" and ptp_pm_code <> "" and ptp_pm_code <> "L")
/*FQ88*/       or (not available ptp_det and available pt_mstr and
/*M066 /*FQ88*/ pt_pm_code <> "M" and pt_pm_code <> "")) */
/*M066*/        pt_pm_code <> "M" and pt_pm_code <> "" and pt_pm_code <> "L"))
/*FQ88*/    then next.


            acctot = 0.
            exptot = 0.
            rtetot = 0.
            usetot = 0.
            wiptot = 0.
            acrtot = 0.
/*F085      vartot = 0. */
/*F085*/    wototx = 0.

/*FN34*/    display_det = yes.

/*J1WK*/    /* DETERMINE THE COST SET METHOD FOR MEMO ITEMS */
/*J1WK*/    if wo_fsm_type = "FSM-RO" then do:
/*J1WK*/     if not available pt_mstr then do:
/*J1WK*/        find si_mstr where si_site = wo_site no-lock no-error.
/*J1WK*/        if available si_mstr then do:
/*J1WK*/           if si_gl_set > "" then
/*J1WK*/              find cs_mstr where cs_set = si_gl_set no-lock no-error.
/*J1WK*/           else do:
/*J1WK*/              find first icc_ctrl no-lock no-error.
/*J1WK*/              if available icc_ctrl then
/*J1WK*/              find cs_mstr where cs_set = icc_gl_set no-lock no-error.
/*J1WK*/           end. /* ELSE DO */
/*J1WK*/           if available cs_mstr then glx_mthd = cs_method.
/*J1WK*/        end. /* IF AVAILABLE si_mstr */
/*J1WK*/     end. /* IF NOT AVAILABLE pt_mstr */
/*J1WK*/    end. /* IF wo_fsm_type = "FSM-RO" */

/*F085*/    /*DETERMINE COSTING METHOD*/
/*J1WK*/    /* COST METHOD IS BEING DETERMINED EARLIER FOR "FSM-RO" */
/*J1WK*/    /* csavg01.p NEED NOT BE EXECUTED FOR CAR-RELATED WO'S. */
/*J1WK*/    if wo_fsm_type <> "FSM-RO" or available pt_mstr then do:
/*F085*/    {gprun.i ""csavg01.p"" "(input wo_part,
                                     input wo_site,
                                     output glx_set,
                                     output glx_mthd,
                                     output cur_set,
                                     output cur_mthd)"
            }
/*J1WK*/    end. /* IF wo_fsm_type <> "FSM-RO" */

/*FN34*/    if glx_mthd = "AVG"
/*FN34*/    and (wo_qty_ord < 0 or wo_rjct_tot <> 0 or wo_mthd_var <> 0)
/*FN34*/    then display_det = no.

/*GA24      if not first(wo_nbr) and skpage then page.                  */
/*GA24      if not skpage then display fill("=",130) format "x(130)"    */
/*GA24      with frame d width 132 no-attr-space.                       */
/*GA24*/    if not firstwo and skpage then page.
/*GA24*/    if not firstwo and not skpage then
/*GA24*/       display fill("=",130) format "x(130)"
/*GA24*/       with frame d width 132 no-attr-space.

/*GA24*/    firstwo = no.

            desc1 = "".
/*GA24      find pt_mstr where pt_part = wo_part no-lock no-wait no-error. */
            if available pt_mstr then desc1 = pt_desc1.

            premsg = "".
            if substring(wo_rev,3,1) = "#" then premsg = "PRE-7.0".


/*J1WK*/    /* CONVERT wo_status INTO ITS ALPHA MNEMONIC FOR CAR WO'S      */
/*J1WK*/    if wo_fsm_type = "FSM-RO" then do:
/*J1WK*/       {gplngn2a.i &file       =  ""wo_mstr""
/*J1WK*/                   &field      =  ""wo_status""
/*J1WK*/                   &code       =    wo_status
/*J1WK*/                   &mnemonic   =    status-type
/*J1WK*/                   &label      =    status-label}
/*J1WK*/    end. /* IF wo_fsm_type <> "FSM-RO" */

            display
               wo_nbr
               wo_lot
/*J035*/       wo_batch
               wo_qty_ord
               wo_ord_date
/*F085*/       glx_mthd
               wo_part
               desc1
               wo_qty_comp
               wo_rel_date
               premsg
               wo_so_job
               wo_qty_rjct
               wo_due_date
               wo_vend
/*J1WK**       wo_status */
/*J1WK*/       if wo_fsm_type = "FSM-RO" then status-type
/*J1WK*/                                 else wo_status @ wo_status
               wo_rmks
            with frame b side-labels.

                                              /* SS - 20050804 - B */
                                              CREATE tta6woworp05.
                                              ASSIGN
                                                  tta6woworp05_part = wo_part
                                                  tta6woworp05_nbr = wo_nbr
                                                  tta6woworp05_lot = wo_lot
                                                  tta6woworp05_qty_comp = wo_qty_comp
                                                  .
                                              /* SS - 20050804 - E */

/*J053*/    /* REFORMAT DISPLAYS TO BASE CURRENCY PRECISION */
/*J053*/    tmp_fmt = expcst:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    expcst:format = tmp_fmt.
/*J053*/    tmp_fmt = acrvar:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    acrvar:format = tmp_fmt.
/*J053*/    tmp_fmt = acccst:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    acccst:format = tmp_fmt.
/*J053*/    tmp_fmt = rtevar:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    rtevar:format = tmp_fmt.
/*J053*/    tmp_fmt = usevar:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    usevar:format = tmp_fmt.
/*J053*/    tmp_fmt = wowipx:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    wowipx:format = tmp_fmt.
/*J053*/    tmp_fmt = wipamt:format.
/*J053*/    {gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/    wipamt:format = tmp_fmt.

            for each wod_det where wod_lot = wo_lot no-lock break by wod_lot
            by wod_part with frame c:
               accqty = wod_qty_iss.
               acccst = wod_tot_std.
/*F085*/       if glx_mthd = "AVG" then do:
/*FN34*/          if display_det
/*FN34*/             then wowipx = wod_mtl_totx.
/*FN34*/             else wowipx = 0.
/*FN34*/          wipamt = wod_tot_std - wowipx.
/*F085*/          expcst = 0.
/*F085*/          rtevar = 0.
/*F085*/          usevar = 0.
/*F085*/          acrvar = 0.
/*FN34/*F085*/    wipamt = wod_tot_std - wod_mtl_totx.  */
/*FN34/*F085*/    wowipx = wod_mtl_totx.                */
/*F085*/       end.
/*F085*/       else do:
                  expcst = ((wo_qty_comp + wo_qty_rjct)
                     * wod_bom_qty * wod_bom_amt)
                     - wod_mvrte_rval.
/*J053*/          /* ROUND expcst TO BASE CURRENCY PRECISION */
/*J053*/          {gprun.i ""gpcurrnd.p"" "(input-output expcst,
                                            input gl_rnd_mthd)"}
                  rtevar = wod_mvrte_post.
                  usevar = wod_mvuse_post.
                  wipamt = acccst - (rtevar + usevar).
                  acrvar = (wod_mvrte_accr + wod_mvuse_accr).
/*F085            varamt = acrvar - (wod_mvrte_post + wod_mvuse_post).      */
/*F085*/          wowipx = 0.
/*F085*/       end.

/*J053*******  acccst = round(acccst,2). ***/
/*J053*******  expcst = round(expcst,2). ***/
/*J053*******  rtevar = round(rtevar,2). ***/
/*J053*******  usevar = round(usevar,2). ***/
/*J053*******  wipamt = round(wipamt,2). ***/
/*J053*******  acrvar = round(acrvar,2). ***/
/*F085*******  varamt = round(varamt,2). ***/
/*J053*F085**  wowipx = round(wowipx,2). ***/

               accumulate acccst (total by wod_lot).
               accumulate expcst (total by wod_lot).
               accumulate rtevar (total by wod_lot).
               accumulate usevar (total by wod_lot).
               accumulate wipamt (total by wod_lot).
               accumulate acrvar (total by wod_lot).
/*F085         accumulate varamt (total by wod_lot).  */
/*F085*/       accumulate wowipx (total by wod_lot).

               if page-size - line-counter < 4 then page.

               if mtlyn then do with frame c:
                  display "  " + wod_part @ item
                  accqty expcst acrvar acccst rtevar usevar
/*F085            varamt */
/*F085*/          wowipx
                  wipamt.
                  down 1.
               end.

               if last(wod_lot) then do with frame c:
                  if mtlyn then underline expcst acrvar acccst rtevar usevar
/*F085            varamt  */
/*F085*/          wowipx
                  wipamt.
                  display {&woworp5a_p_15} @ item
                          accum total by wod_lot expcst @ expcst
                          accum total by wod_lot acccst @ acccst
                          accum total by wod_lot acrvar @ acrvar
                          accum total by wod_lot rtevar @ rtevar
                          accum total by wod_lot usevar @ usevar
/*F085                    accum total by wod_lot varamt @ varamt    */
/*F085*/                  accum total by wod_lot wowipx @ wowipx
                          accum total by wod_lot wipamt @ wipamt.
                  down 2.

                  exptot = exptot + accum total by wod_lot expcst.
                  acctot = acctot + accum total by wod_lot acccst.
                  acrtot = acrtot + accum total by wod_lot acrvar.
                  rtetot = rtetot + accum total by wod_lot rtevar.
                  usetot = usetot + accum total by wod_lot usevar.
/*F085            vartot = vartot + accum total by wod_lot varamt.  */
/*GA47/*F085*/    wototx = wowipx + accum total by wod_lot wowipx.  */
/*GA47*/          wototx = wototx + accum total by wod_lot wowipx.
                  wiptot = wiptot + accum total wipamt.
               end.
/*GA24         {mfrpexit.i "false"} */
/*GA24*/       {mfrpchk.i &warn=no}
            end.  /*for each wod_det*/

            do i = 1 to 3:
               for each wr_route where wr_lot = wo_lot no-lock
               break by wr_lot by wr_op with frame c:

                  /* LABOR */
                  if i = 1 then do:
                     accqty = wr_qty_comp + wr_qty_rjct.
                     acccst = wr_lbr_act.
/*F085*/             if glx_mthd = "AVG" then do:
/*FN34*/                if display_det
/*FN34*/                   then wowipx = wr_lbr_totx.
/*FN34*/                   else wowipx = 0.
/*FN34*/                wipamt = wr_lbr_act - wowipx.
/*F085*/                expcst = 0.
/*F085*/                rtevar = 0.
/*F085*/                usevar = 0.
/*F085*/                acrvar = 0.
/*FN34/*F085*/          wipamt = wr_lbr_act - wr_lbr_totx.    */
/*FN34/*F085*/          wowipx = wr_lbr_totx.                 */
/*F085*/             end.
/*F085*/             else do:
                        expcst = wr_lbr_std.
                        rtevar = wr_lvrte_post.
                        usevar = wr_lvuse_post.
                        wipamt = acccst - (rtevar + usevar).
                        acrvar = (wr_lvrte_accr + wr_lvuse_accr).
/*F085                  varamt = acrvar - (wr_lvrte_post + wr_lvuse_post).  */
/*F085*/                wowipx = 0.
/*F085*/             end.
                  end.

                  /* BURDEN */
                  if i = 2 then do:
                     accqty = wr_qty_comp + wr_qty_rjct.
                     acccst = wr_bdn_act.
/*F085*/             if glx_mthd = "AVG" then do:
/*FN34*/                if display_det
/*FN34*/                   then wowipx = wr_bdn_totx.
/*FN34*/                   else wowipx = 0.
/*FN34*/                wipamt = wr_bdn_act - wowipx.
/*F085*/                expcst = 0.
/*F085*/                rtevar = 0.
/*F085*/                usevar = 0.
/*F085*/                acrvar = 0.
/*FN34/*F085*/          wipamt = wr_bdn_act - wr_bdn_totx.    */
/*FN34/*F085*/          wowipx = wr_bdn_totx.                 */
/*F085*/             end.
/*F085*/             else do:
                        expcst = wr_bdn_std.
                        rtevar = wr_bvrte_post.
                        usevar = wr_bvuse_post.
                        wipamt = acccst - (rtevar + usevar).
                        acrvar = (wr_bvrte_accr + wr_bvuse_accr).
/*F085                  varamt = acrvar - (wr_bvrte_post + wr_bvuse_post).  */
/*F085*/                wowipx = 0.
/*F085*/             end.
                  end.

                  /* SUBCONTRACT */
                  if i = 3 then do:
                     accqty = wr_sub_comp.
                     acccst = wr_sub_act.
/*F085*/             if glx_mthd = "AVG" then do:
/*FN34*/                if display_det
/*FN34*/                   then wowipx = wr_sub_totx.
/*FN34*/                   else wowipx = 0.
/*FN34*/                wipamt = wr_sub_act - wowipx.
/*F085*/                expcst = 0.
/*F085*/                rtevar = 0.
/*F085*/                usevar = 0.
/*F085*/                acrvar = 0.
/*FN34/*F085*/          wipamt = wr_sub_act - wr_sub_totx.    */
/*FN34/*F085*/          wowipx = wr_sub_totx.                 */
/*F085*/             end.
/*F085*/             else do:
                        expcst = wr_sub_std.
                        rtevar = wr_svrte_post.
                        usevar = wr_svuse_post.
                        wipamt = acccst - (rtevar + usevar).
                        acrvar = (wr_svrte_accr + wr_svuse_accr).
/*F085                  varamt = acrvar - (wr_svrte_post + wr_svuse_post).  */
/*F085*/                wowipx = 0.
/*F085*/             end.
                  end.

/*J053*******     acccst = round(acccst,2). ***/
/*J053*******     expcst = round(expcst,2). ***/
/*J053*******     rtevar = round(rtevar,2). ***/
/*J053*******     usevar = round(usevar,2). ***/
/*J053*******     wipamt = round(wipamt,2). ***/
/*J053*******     acrvar = round(acrvar,2). ***/
/*F085*******     varamt = round(varamt,2). ***/
/*J053*F085**     wowipx = round(wowipx,2). ***/

                  accumulate acccst (total by wr_lot).
                  accumulate expcst (total by wr_lot).
                  accumulate rtevar (total by wr_lot).
                  accumulate usevar (total by wr_lot).
                  accumulate wipamt (total by wr_lot).
                  accumulate acrvar (total by wr_lot).
/*F085            accumulate varamt (total by wr_lot).  */
/*F085*/          accumulate wowipx (total by wr_lot).

                  if page-size - line-counter < 4 then page.

                  if (i = 1 and lbryn) or (i = 2 and bdnyn) or
                  (i = 3 and subyn) then do with frame c:
                     display {&woworp5a_p_22} + string(wr_op,">>>>>9") @ item
                     accqty expcst acrvar acccst rtevar usevar
/*F085               varamt  */
/*F085*/             wowipx
                     wipamt.
                     down 1.
                  end.

                  if last(wr_lot) then do with frame c:
                     if (i = 1 and lbryn) or (i = 2 and bdnyn)
                     or (i = 3 and subyn) then underline expcst acrvar acccst
                     rtevar usevar
/*F085               varamt  */
/*F085*/             wowipx
                     wipamt.
                     if i = 1 then display {&woworp5a_p_11} @ item.
                     else if i = 2 then display {&woworp5a_p_10} @ item.
                     else if i = 3 then display {&woworp5a_p_4} @ item.
                     display accum total by wr_lot expcst @ expcst
                             accum total by wr_lot acccst @ acccst
                             accum total by wr_lot acrvar @ acrvar
                             accum total by wr_lot rtevar @ rtevar
                             accum total by wr_lot usevar @ usevar
/*F085                       accum total by wr_lot varamt @ varamt    */
/*F085*/                     accum total by wr_lot wowipx @ wowipx
                             accum total by wr_lot wipamt @ wipamt.
                     down 2.

                     exptot = exptot + accum total by wr_lot expcst.
                     acctot = acctot + accum total by wr_lot acccst.
                     acrtot = acrtot + accum total by wr_lot acrvar.
                     rtetot = rtetot + accum total by wr_lot rtevar.
                     usetot = usetot + accum total by wr_lot usevar.
/*F085               vartot = vartot + accum total by wr_lot varamt.  */
/*F085*/             wototx = wototx + accum total by wr_lot wowipx.
                     wiptot = wiptot + accum total wipamt.

                  end.
/*GA24            {mfrpexit.i "false"} */
/*GA24*/          {mfrpchk.i &warn=no}
               end.  /*for each wr_route*/
            end.  /*do i = 1 to 3*/

            do with frame c:
               underline expcst acrvar acccst rtevar usevar
/*F085         varamt  */
/*F085*/       wowipx
               wipamt.
               display {&woworp5a_p_5} @ item
                       exptot @ expcst
                       acctot @ acccst
                       acrtot @ acrvar
                       rtetot @ rtevar
                       usetot @ usevar
/*F085                 vartot @ varamt */
/*F085*/               wototx @ wowipx
                       wiptot @ wipamt.
               down 1.

               /* SS - 20050804 - B */
               ASSIGN 
                   tta6woworp05_acctot = acctot
                   .
               /* SS - 20050804 - E */

/*FN34/*F085*/ if glx_mthd = "AVG" then do:                  */
/*FN34            display "Discrepancy Posted:" @ item       */
/*FN34                    wo_mthd_var @ wipamt.              */

/*J027*        if glx_mthd = "AVG" and display_det then do:  */

/*J027*/       /* REGULAR PRODUCTS (AVG) */
/*J027*/       if glx_mthd = "AVG" and wo_joint_type = "" then do:
/*J027*/          if display_det then do:
/*FN34*/             display {&woworp5a_p_24} @ item
/*FN34*/                  -1 *
/*J053**FN34****          round(wo_mthd_var,2) @ wipamt. ****/
/*J053*/                  wo_mthd_var @ wipamt.
                  underline wipamt.
                  display {&woworp5a_p_19} @ item
/*F664                    wo_wip_tot - wo_mthd_var @ wipamt. */
/*FN34/*F664*/            round((wo_wip_tot - wo_mthd_var),2) @ wipamt.      */
/*J053**FN34****          round(wo_wip_tot,2) @ wipamt. ****/
/*J053*/                  wo_wip_tot @ wipamt.
                  end.
/*J027*        else if  glx_mthd = "AVG" then do:            */
/*J027*/          else do:
/*FN34*/             display {&woworp5a_p_23} @ item
/*FN34*/             -1 *
/*J053**FN34****  round((wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot) **/
/*J053**FN34****          - wo_rjct_tot **************************************/
/*J053**FN34****          - wo_wip_tot - wo_mthd_var,2) @ wipamt. ************/
/*J053*/                  (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
/*J053*/                  - wo_rjct_tot - wo_wip_tot - wo_mthd_var) @ wipamt.
/*FN34*/             down 1.
/*FN34*/             display {&woworp5a_p_27} @ item
/*FN34*/                  -1 *
/*J053**FN34****          round(wo_rjct_tot,2) @ wipamt. ********************/
/*J053*/                  wo_rjct_tot @ wipamt.
/*FN34*/             down 1.
/*FN34*/             display {&woworp5a_p_24} @ item
/*FN34*/                  -1 *
/*J053**FN34****          round(wo_mthd_var,2) @ wipamt. *******************/
/*J053*/                  wo_mthd_var @ wipamt.
/*FN34*/             underline wipamt.
/*FN34*/             display {&woworp5a_p_19} @ item
/*J053**FN34****          round(wo_wip_tot,2) @ wipamt. *******************/
/*J053*/                  wo_wip_tot @ wipamt.
/*FN34*/          end.
/*J027*/       end.

/*J027*/       /* REGULAR PRODUCTS (STD) AND JOINT PRODUCTS (AVG & STD) */
/*F085*/       else do:
/*FN34            display "Std Cost Rcvd to FG:" @ item                      */
/*F664                    (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot)*/
/*F664                    - wo_wip_tot @ wipamt.                             */

/*J027*/          /*  JOINT PRODUCTS (AVG & STD) */

    /* SS - 20050804 - B */
    /* TODO: JOINT PRODUCTS */
    /* SS - 20050804 - E */

                  if wo_joint_type = "5" then do: /* base process */
                     do for wo_mstr1:
                        do i = 1 to 3:
                           if i = 3 and glx_mthd = "AVG" then leave.
                           down 1.
                           if i = 1 then do:
/*J1GW*                       display "Joint Products" @ item. */
/*J1GW*/                      display {&woworp5a_p_7} @ item.
                              down 1.
                              if glx_mthd = "AVG" then
                              display {&woworp5a_p_23} @ item.
                              else
                              display {&woworp5a_p_28} @ item.
                           end.
                           else if i = 2 then
                           display {&woworp5a_p_27} @ item.
                           else if i = 3 then  /* glx_mthd = "STD" */
                              display {&woworp5a_p_25} @ item.
                           down 1.

                           /* CO- AND BY-PRODUCTS */
                           for each wo_mstr1 no-lock
                           where wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                           wo_mstr1.wo_lot <> wo_mstr.wo_lot and
                           wo_mstr1.wo_type = "" with frame c:

                              if i = 1 and (wo_mstr1.wo_qty_comp <> 0 or
                              (wo_mstr1.wo_mtl_totx + wo_mstr1.wo_lbr_totx +
                               wo_mstr1.wo_bdn_totx + wo_mstr1.wo_sub_totx +
                               wo_mstr1.wo_rjct_tot <> 0))
                              then do:  /* RECEIPTS */
                                 display
                                 "  " + wo_mstr1.wo_part        @ item
                                 wo_mstr1.wo_qty_comp           @ accqty
/*J053*******************        -1 * round                   ***/
/*J053*/                         -1 *
                                     ((wo_mstr1.wo_mtl_totx +
                                       wo_mstr1.wo_lbr_totx +
                                       wo_mstr1.wo_bdn_totx +
                                       wo_mstr1.wo_sub_totx +
/*J053*******************              wo_mstr1.wo_rjct_tot),2) @ wipamt. ***/
/*J053*/                               wo_mstr1.wo_rjct_tot)) @ wipamt.
                                 down 1.
                              end.
                              else if i = 2 and wo_mstr1.wo_qty_rjct <> 0
                              then do:  /* SCRAP */
                                 display
                                 "  " + wo_mstr1.wo_part            @ item
                                 wo_mstr1.wo_qty_rjct               @ accqty
/*J053**********                 -1 * round(wo_mstr1.wo_rjct_tot,2) @ wipamt. */
/*J053*/                         -1 * wo_mstr1.wo_rjct_tot          @ wipamt.
                                 down 1.
                              end.
                              else if i = 3 and wo_mstr1.wo_mix_var <> 0
                              and glx_mthd <> "AVG"
                              then do: /* MIX VARIANCES */
                                 display
                                 "  " + wo_mstr1.wo_part           @ item
                                 wo_mstr1.wo_qty_comp +
                                 wo_mstr1.wo_qty_rjct              @ accqty
/*J053**********                 -1 * round(wo_mstr1.wo_mix_var,2) @ wipamt. */
/*J053*/                         -1 * wo_mstr1.wo_mix_var          @ wipamt.
                                 down 1.
                              end.
                           end. /* for each wo_mstr1 */
                        end. /* i = 1 to 3 */
                     end. /* do for wo_mstr1 */
                     down 1.
                  end. /* if wo_joint_type = "5" */

                  /* REGULAR PRODUCTS (STD)  wo_joint_type = ""  */
                  else do:
/*J027*/ /* End added block */

/*FN34*/             display {&woworp5a_p_28} @ item
/*FN34*/             -1 *
/*J053**F664***     round((wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot)**/
/*J053**FN34***           - wo_rjct_tot ***************************************/
/*J053**F664***           - wo_wip_tot - wo_mthd_var,2) @ wipamt. *************/
/*J053*/                  (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
/*J053*/                  - wo_rjct_tot - wo_wip_tot - wo_mthd_var) @ wipamt.
                     down 1.

                     /* SS - 20050804 - B */
                     ASSIGN
                         tta6woworp05_wipamt = (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot - wo_rjct_tot - wo_wip_tot - wo_mthd_var)
                         .
                     /* SS - 20050804 - E */

/*J027*/          end.

/*FU43*/          display {&woworp5a_p_27} @ item
/*FU43*/                  -1 *
/*J053**FU43*****         round(wo_rjct_tot,2) @ wipamt. *****/
/*J053*/                  wo_rjct_tot @ wipamt.
/*FU43*/          down 1.

/*J027*/          /* DISPLAY DISCREPANCY FOR BASE PROCESS ORDERS */
/*J027*/          /* AND METHOD CHANGE FOR BASE PROCESS & REGULAR ORDERS */
/*J027*/          if glx_mthd = "AVG" then
/*J027*/             display {&woworp5a_p_24} @ item.
/*J027*/          else
/*FN34            display "Mthd Chg Var Taken:" @ item       */
/*F664                    wo_mthd_var @ wipamt.              */
/*FN34*/             display {&woworp5a_p_26} @ item
/*FN34*/             -1 *
/*J053**F664****     round(wo_mthd_var,2) @ wipamt. ****/
/*J053*/             wo_mthd_var @ wipamt.
                  underline wipamt.

/*J027*/          /* BALANCE FOR JOINT PRODUCTS (AVG & STD) & REGULAR (STD) */
                  display {&woworp5a_p_19} @ item
/*F664                    wo_wip_tot - wo_mthd_var @ wipamt. */
/*J053**F664****          round(wo_wip_tot,2) @ wipamt. ******/
/*J053*/                  wo_wip_tot @ wipamt.
/*F085*/       end. /* REGULAR PRODUCTS (STD) AND JOINT PRODUCTS (AVG & STD) */
            end.

/*GA24      {mfrpexit.i} */
/*GA24*/    {mfrpchk.i}
         end.

            /* SS - 20050804 - B */
            OUTPUT CLOSE.
            OS-DELETE "a6woworp5a".
            /* SS - 20050804 - E */

/*K0XV*/ {wbrp04.i}
