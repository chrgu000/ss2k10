/* GUI CONVERTED from woworp5a.p (converter v1.75) Mon May 14 22:48:39 2001 */
/* woworp5a.p - WORK ORDER COST REPORT                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: ram *D611*                */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*                */
/* REVISION: 7.0     LAST MODIFIED: 03/02/92    BY: pma *F085*                */
/* REVISION: 7.0     LAST MODIFIED: 06/17/92    BY: pma *F664*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 04/28/93    BY: pma *GA47*                */
/* REVISION: 7.2     LAST MODIFIED: 04/12/94    BY: pma *FN34*                */
/* REVISION: 7.3     LAST MODIFIED: 09/23/94    BY: cpp *FQ88*                */
/* REVISION: 7.5     LAST MODIFIED: 10/19/94    BY: TAF *J035*                */
/* REVISION: 7.3     LAST MODIFIED: 12/07/94    BY: pxd *FU43*                */
/* REVISION: 7.5     LAST MODIFIED: 02/27/94    BY: tjs *J027*                */
/* REVISION: 8.5     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.5     LAST MODIFIED: 10/25/95    BY: sxb *J053*                */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW* Julie Milligan     */
/* REVISION: 8.5     LAST MODIFIED: 08/11/97    BY: *J1WK* Molly Balan        */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: *K0XV* A. Swaminathan     */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 01/21/99    BY: *M066* Patti Gaultney     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 11/23/99    BY: *J3MM* Jyoti Thatte       */
/* REVISION: 9.1     LAST MODIFIED: 03/06/00    BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 07/29/00    BY: *N0GV* Mudit Mehta        */
/* Revision: 1.17    BY: Katie Hilbert          DATE: 04/01/01 ECO: *P008*    */
/* $Revision: 1.20 $ BY: Vivek Gogte            DATE: 04/30/01 ECO: *P001*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/**************************************************************/
/*   MOST OF THE ROUNDING FUNCTIONS IN THIS PROGRAM HAVE BEEN */
/*   REMOVED BECAUSE THE VALUES ARE DERIVED FROM AMOUNTS THAT */
/*   HAVE BEEN ROUNDED ELSEWHERE IN MFG/PRO.                  */
/*   WHERE WE DID NEED TO ROUND, WE ROUNDED BASED ON THE      */
/*   DECIMAL PRECISION OF THE BASE CURRENCY.                  */
/**************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}

define shared variable nbr    like wo_nbr.
define shared variable nbr1   like wo_nbr.
define shared variable lot    like wo_lot.
define shared variable lot1   like wo_lot.
define shared variable site   like wo_site no-undo.
define shared variable site1  like wo_site no-undo.
define shared variable part   like wo_part.
define shared variable part1  like wo_part.
define shared variable due    like wo_due_date.
define shared variable due1   like wo_due_date.
define shared variable vend   like wo_vend.
define shared variable so_job like wo_so_job.
define shared variable stat   like wo_status.
define shared variable mtlyn  like mfc_logical initial yes
   label "Material"           format "Detail/Summary".
define shared variable lbryn  like mfc_logical initial yes
   label "Labor"              format "Detail/Summary".
define shared variable bdnyn  like mfc_logical initial yes
   label "Burden"             format "Detail/Summary".
define shared variable subyn  like mfc_logical initial yes
   label "Subcontract"        format "Detail/Summary".
define shared variable skpage like mfc_logical initial yes
   label "Page Break on Work Order".

define variable desc1    like pt_desc1.
define variable acctot   like wod_tot_std.
define variable exptot   like wod_tot_std.
define variable rtetot   like wod_mvrte_post.
define variable usetot   like wod_mvuse_post.
define variable acrtot   like wod_mvuse_accr.
define variable wiptot   like wo_wip_tot.
define variable accqty   like wod_qty_iss
   column-label "Accumulated!Quantity".
define variable acccst   like wod_mvrte_post no-undo
   column-label "Accumulated!Cost".
define variable expcst   like wod_mvrte_post no-undo
   column-label "Expected !Cost   !(Ref Only)".
define variable rtevar   like wod_mvrte_post
   column-label "Rate  !Variance!Posted ".
define variable usevar   like wod_mvuse_post
   column-label "Usage  !Variance!Posted ".
define variable acrvar   like wod_mvuse_accr
   column-label "Accrued!Variance!(Ref Only)".
define variable wipamt   like wod_mvrte_post
   column-label "Balance".
define variable premsg   as character.
define variable item     like wod_part format "x(20)".
define variable i        as integer.
define variable glx_mthd like cs_method.
define variable glx_set  like cs_set.
define variable cur_mthd like cs_method.
define variable cur_set  like cs_set.
define variable wowipx   like wod_mvrte_post no-undo
   column-label "Avg Cost!Received to!Finished Goods".
define variable wototx   like wod_tot_std.
define variable firstwo  like mfc_logical.
define variable display_det like mfc_logical.
define variable tmp_fmt  as   character no-undo.

define buffer wo_mstr1 for wo_mstr.

define variable status-type as character no-undo.
define variable status-label as character no-undo.

/*judy 07/06/05*/ define variable sum_1200 as decimal label "国产件" format "->,>>>,>>>,>>9.99".
/*judy 07/06/05*/ define variable sum_1100 as decimal label "进口件" format "->,>>>,>>>,>>9.99".
/*judy 07/06/05*/ define variable sum_2000 as decimal label "外购半成品" format "->,>>>,>>>,>>9.99".
/*judy 07/06/05*/ define variable sum_7000 as decimal label "产成品改制" format "->,>>>,>>>,>>9.99".
/*judy 07/06/05*/ define variable sum_qty_comp as decimal .

/*judy 07/06/05*//* workfile wolist 存储所有加工单明细信息，包括加工单号，加工的零件号，使用的零件号，使用零件的产品类，使用零件数量，金额，完工数量 */
/*judy 07/06/05*/ define workfile wolist field wl_nbr like wo_nbr
/*judy 07/06/05*/                        field wl_part like wo_part  
/*judy 07/06/05*/                        field wl_type like wo_type
/*judy 07/06/05*/                         field wl_item like pt_part
/*judy 07/06/05*/                         field wl_prod_line like pt_prod_line
/*judy 07/06/05*/                         field wl_accqty as decimal 
/*judy 07/06/05*/                         field wl_acccst as decimal
/*judy 07/06/05*/                         field wl_qty_comp like wo_qty_comp.
                        
/*judy 07/06/05*//* workfile wosum 存储加工单汇总信息，包括加工的零件号，各产品类用量金额，*/                        
/*judy 07/06/05*/ define workfile wosum field ws_part like wo_part
/*judy 07/06/05*/                        field ws_1200 as decimal  label "国产件"  format "->,>>>,>>>,>>9.99"
/*judy 07/06/05*/                        field ws_1100 as decimal  label "进口件"  format "->,>>>,>>>,>>9.99"
/*judy 07/06/05*/                        field ws_2000 as decimal  label "外购半成品"  format "->,>>>,>>>,>>9.99"
/*judy 07/06/05*/                        field ws_7000 as decimal  label "产成品改制"  format "->,>>>,>>>,>>9.99"
/*judy 07/06/05*/                        /* ws_qty_comp1 存储日程排产完工数量 */
/*judy 07/06/05*/                        field ws_qty_comp1 like wo_qty_comp  label "生产完工数量"
/*judy 07/06/05*/                        /* ws_qty_comp2 存储利用iss_wo发出改制数量 */
/*judy 07/06/05*/                        field ws_qty_comp2 like wo_qty_comp  label "改制完工数量"
/*judy 07/06/05*/                        field ws_qty_comp like wo_qty_comp.
/*judy 07/06/05*/ FOR EACH wolist:
/*judy 07/06/05*/         DELETE wolist.
/*judy 07/06/05*/ END.
/*judy 07/06/05*/ FOR EACH wosum:
/*judy 07/06/05*/         DELETE wosum.
/*judy 07/06/05*/ END.


FORM /*GUI*/ 
   wo_nbr         colon 15
   wo_lot         colon 45
   wo_batch       colon 71
   wo_rmks        colon 71
   wo_part        colon 15
   wo_so_job      colon 45
   wo_qty_ord     colon 71
   wo_ord_date    colon 104
   glx_mthd       no-label
   desc1          at 17 no-label
   wo_qty_comp    colon 71
   wo_rel_date    colon 104
   premsg         no-label
   wo_status      colon 15
   wo_vend        colon 45
   wo_qty_rjct    colon 71
   wo_due_date    colon 104
with STREAM-IO /*GUI*/  frame b side-labels width 132 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   item
   accqty
   expcst
   acrvar
   acccst
   rtevar
   usevar
   wowipx
   wipamt
with STREAM-IO /*GUI*/  frame c width 132 down no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

firstwo = yes.
find first gl_ctrl no-lock.

/* FORMAT RETURNED BY gpcurfmt.p IS STORED IN tmp_fmt AND IS   */
/* USED AS THE DISPLAY FORMAT FOR EVERY AMOUNT COLUMN VARIABLE.*/
/* THE FORMAT FOR THESE VARIABLES IS RE-INITIALIZED AFTER EVERY*/
/* UNDERLINE STATEMENT AS THE DISPLAY FORMAT GETS CHANGED.     */

tmp_fmt = expcst:format.
{gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                          input gl_rnd_mthd)"}

/* FIND AND DISPLAY */
for each wo_mstr
      where (wo_nbr >= nbr) and (wo_nbr <= nbr1)
      and (wo_lot >= lot) and (wo_lot <= lot1 )
      and (wo_part >= part) and (wo_part <= part1 or part1 = "" )
      and (wo_site >= site) and (wo_site <= site1)
      and (wo_due_date >= due or due = ?)
      and (wo_due_date <= due1 or due1 = ?)
      and (wo_vend = vend or vend = "" )
      and (wo_so_job = so_job or so_job = "" )
      and (wo_status = stat or stat = "")
      and (wo_joint_type = "" or wo_joint_type = "5")
      no-lock break by wo_nbr by wo_lot with frame c width 132
      no-attr-space:

   find pt_mstr no-lock
      where pt_part = wo_part no-error.

   find ptp_det no-lock
      where ptp_part = wo_part
      and ptp_site = wo_site no-error.

   /* PLANNED ORDERS(wo_status = P)PRINT ONLY IF pm_code = M,SPACE OR L */
   if wo_status = "P"
      and ((available ptp_det and
      ptp_pm_code <> "M" and ptp_pm_code <> "" and ptp_pm_code <> "L")
      or (not available ptp_det and available pt_mstr and
      pt_pm_code <> "M" and pt_pm_code <> "" and pt_pm_code <> "L"))
      then next.

   assign
      acctot = 0
      exptot = 0
      rtetot = 0
      usetot = 0
      wiptot = 0
      acrtot = 0
      wototx = 0

      display_det = yes.

   /* DETERMINE THE COST SET METHOD FOR MEMO ITEMS */
   if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
   then do:
      if not available pt_mstr then do:
         find si_mstr where si_site = wo_site no-lock no-error.
         if available si_mstr then do:
            if si_gl_set > "" then
               find cs_mstr where cs_set = si_gl_set no-lock no-error.
            else do:
               find first icc_ctrl no-lock no-error.
               if available icc_ctrl then
                  find cs_mstr where cs_set = icc_gl_set no-lock no-error.
            end. /* ELSE DO */
            if available cs_mstr then glx_mthd = cs_method.
         end. /* IF AVAILABLE si_mstr */
      end. /* IF NOT AVAILABLE pt_mstr */
   end. /* IF wo_fsm_type = "FSM-RO" */

   /* DETERMINE COSTING METHOD                             */
   /* COST METHOD IS BEING DETERMINED EARLIER FOR "FSM-RO" */
   /* csavg01.p NEED NOT BE EXECUTED FOR CAR-RELATED WO'S. */
   if wo_fsm_type <> "FSM-RO"
      and wo_fsm_type <> "PRM"
      or available pt_mstr
   then do:
      {gprun.i ""csavg01.p"" "(input wo_part,
                               input wo_site,
                               output glx_set,
                               output glx_mthd,
                               output cur_set,
                               output cur_mthd)"
      }
   end. /* IF wo_fsm_type <> "FSM-RO" */

   if glx_mthd = "AVG"
      and (wo_qty_ord < 0 or wo_rjct_tot <> 0 or wo_mthd_var <> 0)
   then display_det = no.

   if not firstwo and skpage then page.
   if not firstwo and not skpage then
      display fill("=",130) format "x(130)"
      with frame d width 132 no-attr-space STREAM-IO /*GUI*/ .

   assign
      firstwo = no
      desc1 = "".

   if available pt_mstr then desc1 = pt_desc1.

   premsg = "".
   if substring(wo_rev,3,1) = "#" then premsg = "PRE-7.0".

   /* CONVERT wo_status INTO ITS ALPHA MNEMONIC FOR CAR WO'S      */
   if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
   then do:
      {gplngn2a.i
         &file       =  ""wo_mstr""
         &field      =  ""wo_status""
         &code       =    wo_status
         &mnemonic   =    status-type
         &label      =    status-label}
   end. /* IF wo_fsm_type <> "FSM-RO" */
/****judy 07/06/05  begin delete********
   display
      wo_nbr
      wo_lot
      wo_batch
      wo_qty_ord
      wo_ord_date
      glx_mthd
      wo_part
      desc1
      wo_qty_comp
      wo_rel_date
      premsg
      wo_so_job
      wo_qty_rjct
      wo_due_date
      wo_vend
      if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
      then status-type
      else wo_status @ wo_status
      wo_rmks
   with frame b side-labels STREAM-IO /*GUI*/ .      
  ****judy 07/06/05  end  delete****/

   assign
      expcst:format = tmp_fmt
      acrvar:format = tmp_fmt
      acccst:format = tmp_fmt
      rtevar:format = tmp_fmt
      usevar:format = tmp_fmt
      wowipx:format = tmp_fmt
      wipamt:format = tmp_fmt.

   for each wod_det where wod_lot = wo_lot no-lock break by wod_lot
         by wod_part with frame c:
      assign
         accqty = wod_qty_iss
         acccst = wod_tot_std.
      if glx_mthd = "AVG"
      then do:
         if display_det
         then wowipx = wod_mtl_totx.
         else wowipx = 0.
         assign
            wipamt = wod_tot_std - wowipx
            expcst = 0
            rtevar = 0
            usevar = 0
            acrvar = 0.
      end.
      else do:
         expcst = ((wo_qty_comp + wo_qty_rjct)
                   * wod_bom_qty * wod_bom_amt)
                   - wod_mvrte_rval.
         /* ROUND expcst TO BASE CURRENCY PRECISION */
         {gprun.i ""gpcurrnd.p"" "(input-output expcst,
                                   input gl_rnd_mthd)"}
         assign
            rtevar = wod_mvrte_post
            usevar = wod_mvuse_post
            wipamt = acccst - (rtevar + usevar)
            acrvar = (wod_mvrte_accr + wod_mvuse_accr)
            wowipx = 0.
      end.

      accumulate acccst (total by wod_lot).
      accumulate expcst (total by wod_lot).
      accumulate rtevar (total by wod_lot).
      accumulate usevar (total by wod_lot).
      accumulate wipamt (total by wod_lot).
      accumulate acrvar (total by wod_lot).
      accumulate wowipx (total by wod_lot).

/****judy 07/06/05  begin delete********
      if page-size - line-counter < 4 then page.

      if mtlyn then do with frame c:
         display
            "  " + wod_part @ item
            accqty
            expcst
            acrvar
            acccst
            rtevar
            usevar
            wowipx
            wipamt WITH STREAM-IO /*GUI*/ .
         down 1.
      end.

      if last(wod_lot) then do with frame c:
         if mtlyn then
         do:
            underline
               expcst
               acrvar
               acccst
               rtevar
               usevar
               wowipx
               wipamt.

            /* RE-INITIALIZE FORMAT */
            assign
               expcst:format = tmp_fmt
               acrvar:format = tmp_fmt
               acccst:format = tmp_fmt
               rtevar:format = tmp_fmt
               usevar:format = tmp_fmt
               wowipx:format = tmp_fmt
               wipamt:format = tmp_fmt.
         end.

         display
            getTermLabel("MATERIAL_TOTAL",19) + ":" @ item
            accum total by wod_lot expcst @ expcst
            accum total by wod_lot acccst @ acccst
            accum total by wod_lot acrvar @ acrvar
            accum total by wod_lot rtevar @ rtevar
            accum total by wod_lot usevar @ usevar
            accum total by wod_lot wowipx @ wowipx
            accum total by wod_lot wipamt @ wipamt WITH STREAM-IO /*GUI*/ .
         down 2.

         assign
            exptot = exptot + accum total by wod_lot expcst
            acctot = acctot + accum total by wod_lot acccst
            acrtot = acrtot + accum total by wod_lot acrvar
            rtetot = rtetot + accum total by wod_lot rtevar
            usetot = usetot + accum total by wod_lot usevar
            wototx = wototx + accum total by wod_lot wowipx
            wiptot = wiptot + accum total wipamt.
      end.
  ****judy 07/06/05  end  delete****/
      
/*GUI*/ {mfguichk.i  &warn=no} /*Replace mfrpchk*/

/*judy 07/06/05*/     find pt_mstr where pt_part = wod_part no-lock no-error.
/*judy 07/06/05*/    create wolist.
/*judy 07/06/05*/              wl_part=wo_part.
/*judy 07/06/05*/              wl_nbr=wo_nbr.
/*judy 07/06/05*/              wl_type=wo_type.
/*judy 07/06/05*/              wl_item=wod_part.
/*judy 07/06/05*/              wl_prod_line=pt_prod_line.
/*judy 07/06/05*/              wl_accqty=accqty.
/*judy 07/06/05*/              wl_acccst=acccst.
/*judy 07/06/05*/              wl_qty_comp=wo_qty_comp.

   end.  /*for each wod_det*/

/*judy 07/06/05 begin delete 
   do i = 1 to 3:
      for each wr_route where wr_lot = wo_lot no-lock
            break by wr_lot by wr_op with frame c:

         /* LABOR */
         if i = 1 then do:
            assign
               accqty = wr_qty_comp + wr_qty_rjct
               acccst = wr_lbr_act.
            if glx_mthd = "AVG" then do:
               if display_det
               then wowipx = wr_lbr_totx.
               else wowipx = 0.
               assign
                  wipamt = wr_lbr_act - wowipx
                  expcst = 0
                  rtevar = 0
                  usevar = 0
                  acrvar = 0.
            end.
            else
               assign
                  expcst = wr_lbr_std
                  rtevar = wr_lvrte_post
                  usevar = wr_lvuse_post
                  wipamt = acccst - (rtevar + usevar)
                  acrvar = wr_lvrte_accr + wr_lvuse_accr
                  wowipx = 0.
         end.

         /* BURDEN */
         if i = 2 then do:
            assign
               accqty = wr_qty_comp + wr_qty_rjct
               acccst = wr_bdn_act.
            if glx_mthd = "AVG" then do:
               if display_det
               then wowipx = wr_bdn_totx.
               else wowipx = 0.
               assign
                  wipamt = wr_bdn_act - wowipx
                  expcst = 0
                  rtevar = 0
                  usevar = 0
                  acrvar = 0.

            end.
            else
               assign
                  expcst = wr_bdn_std
                  rtevar = wr_bvrte_post
                  usevar = wr_bvuse_post
                  wipamt = acccst - (rtevar + usevar)
                  acrvar = wr_bvrte_accr + wr_bvuse_accr
                  wowipx = 0.
         end.

         /* SUBCONTRACT */
         if i = 3 then do:
            assign
               accqty = wr_sub_comp
               acccst = wr_sub_act.
            if glx_mthd = "AVG" then do:
               if display_det
               then wowipx = wr_sub_totx.
               else wowipx = 0.
               assign
                  wipamt = wr_sub_act - wowipx
                  expcst = 0
                  rtevar = 0
                  usevar = 0
                  acrvar = 0.
            end.
            else
               assign
                  expcst = wr_sub_std
                  rtevar = wr_svrte_post
                  usevar = wr_svuse_post
                  wipamt = acccst - (rtevar + usevar)
                  acrvar = wr_svrte_accr + wr_svuse_accr
                  wowipx = 0.
         end.

         accumulate acccst (total by wr_lot).
         accumulate expcst (total by wr_lot).
         accumulate rtevar (total by wr_lot).
         accumulate usevar (total by wr_lot).
         accumulate wipamt (total by wr_lot).
         accumulate acrvar (total by wr_lot).
         accumulate wowipx (total by wr_lot).

         if page-size - line-counter < 4 then page.

         if (i = 1 and lbryn) or (i = 2 and bdnyn) or
            (i = 3 and subyn) then do with frame c:

            display
               getTermLabelRt("OPERATION",12) + ": " +
               string(wr_op,">>>>>9") @ item
               accqty
               expcst
               acrvar
               acccst
               rtevar
               usevar
               wowipx
               wipamt WITH STREAM-IO /*GUI*/ .
            down 1.
         end.

         if last(wr_lot) then do with frame c:
            if (i = 1 and lbryn) or (i = 2 and bdnyn)
               or (i = 3 and subyn) then
            do:
               underline
                  expcst
                  acrvar
                  acccst
                  rtevar
                  usevar
                  wowipx
                  wipamt.

               /* RE-INITIALIZE FORMAT */
               assign
                  expcst:format = tmp_fmt
                  acrvar:format = tmp_fmt
                  acccst:format = tmp_fmt
                  rtevar:format = tmp_fmt
                  usevar:format = tmp_fmt
                  wowipx:format = tmp_fmt
                  wipamt:format = tmp_fmt.
            end.

            if i = 1 then
               display getTermLabel("LABOR_TOTAL",19) + ":"
               @ item WITH STREAM-IO /*GUI*/ .
            else
            if i = 2 then
               display getTermLabel("BURDEN_TOTAL",19)
               + ":" @ item WITH STREAM-IO /*GUI*/ .
            else
            if i = 3 then
               display
               getTermLabel("SUBCONTRACT_TOTAL",19) + ":" @ item WITH STREAM-IO /*GUI*/ .

            display
               accum total by wr_lot expcst @ expcst
               accum total by wr_lot acccst @ acccst
               accum total by wr_lot acrvar @ acrvar
               accum total by wr_lot rtevar @ rtevar
               accum total by wr_lot usevar @ usevar
               accum total by wr_lot wowipx @ wowipx
               accum total by wr_lot wipamt @ wipamt WITH STREAM-IO /*GUI*/ .
            down 2.

            assign
               exptot = exptot + accum total by wr_lot expcst
               acctot = acctot + accum total by wr_lot acccst
               acrtot = acrtot + accum total by wr_lot acrvar
               rtetot = rtetot + accum total by wr_lot rtevar
               usetot = usetot + accum total by wr_lot usevar
               wototx = wototx + accum total by wr_lot wowipx
               wiptot = wiptot + accum total wipamt.

         end.

         
/*GUI*/ {mfguichk.i  &warn=no} /*Replace mfrpchk*/

      end.  /*for each wr_route*/
   end.  /*do i = 1 to 3*/

   do with frame c:
      underline
         expcst
         acrvar
         acccst
         rtevar
         usevar
         wowipx
         wipamt.

      /* RE-INITIALIZE FORMAT */
      assign
         expcst:format = tmp_fmt
         acrvar:format = tmp_fmt
         acccst:format = tmp_fmt
         rtevar:format = tmp_fmt
         usevar:format = tmp_fmt
         wowipx:format = tmp_fmt
         wipamt:format = tmp_fmt.

      display
         getTermLabel("WORK_ORDER_SUBTOTAL",18) + ":" @ item
         exptot @ expcst
         acctot @ acccst
         acrtot @ acrvar
         rtetot @ rtevar
         usetot @ usevar
         wototx @ wowipx
         wiptot @ wipamt WITH STREAM-IO /*GUI*/ .
      down 1.

      /* REGULAR PRODUCTS (AVG) */
      if glx_mthd = "AVG" and wo_joint_type = "" then do:
         if display_det then do:
            display
               " - " + getTermLabel("DISCREPANCY",16) + ":" @ item
               -1 * wo_mthd_var @ wipamt WITH STREAM-IO /*GUI*/ .
            underline wipamt.

            /* RE-INITIALIZE FORMAT */
            wipamt:format = tmp_fmt.

            display
               getTermLabel("BALANCE",19) + ":" @ item
               wo_wip_tot @ wipamt WITH STREAM-IO /*GUI*/ .
         end.
         else do:

            display
               " - " + getTermLabel("COST_RECEIVED_TO_FG",16)
               + ":" @ item
               -1 *
               (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
               - wo_rjct_tot - wo_wip_tot - wo_mthd_var) @ wipamt WITH STREAM-IO /*GUI*/ .
            down 1.

            display
               " - " + getTermLabel("SCRAPPED",16) + ":" @ item
               -1 * wo_rjct_tot @ wipamt WITH STREAM-IO /*GUI*/ .
            down 1.

            display
               " - " + getTermLabel("DISCREPANCY",16) + ":" @ item
               -1 * wo_mthd_var @ wipamt WITH STREAM-IO /*GUI*/ .
            underline wipamt.

            /* RE-INITIALIZE FORMAT */
            wipamt:format = tmp_fmt.

            display
               getTermLabel("BALANCE",19) + ":" @ item
               wo_wip_tot @ wipamt WITH STREAM-IO /*GUI*/ .
         end.
      end.

      /* REGULAR PRODUCTS (STD) AND JOINT PRODUCTS (AVG & STD) */
      else do:

         /*  JOINT PRODUCTS (AVG & STD) */
         if wo_joint_type = "5" then do: /* base process */
            do for wo_mstr1:
               do i = 1 to 3:
                  if i = 3 and glx_mthd = "AVG" then leave.
                  down 1.
                  if i = 1 then do:

                     display getTermLabel("CO/BY-PRODUCTS",20) @ item WITH STREAM-IO /*GUI*/ .
                     down 1.
                     if glx_mthd = "AVG" then
                        display
                        " - " + getTermLabel("COST_RECEIVED_TO_FG",16)
                        + ":" @ item WITH STREAM-IO /*GUI*/ .
                     else
                        display
                        " - " + getTermLabel("STANDARD_COST_RECEIVED",16)
                        + ":" @ item WITH STREAM-IO /*GUI*/ .
                  end.
                  else
                  if i = 2 then
                     display " - " + getTermLabel("SCRAPPED",16) + ":"
                     @ item WITH STREAM-IO /*GUI*/ .
                  else
                  if i = 3 then  /* glx_mthd = "STD" */
                     display " - " + getTermLabel("MIX_VARIANCES",16)
                     + ":" @ item WITH STREAM-IO /*GUI*/ .
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
                           -1 *
                           ((wo_mstr1.wo_mtl_totx +
                           wo_mstr1.wo_lbr_totx +
                           wo_mstr1.wo_bdn_totx +
                           wo_mstr1.wo_sub_totx +
                           wo_mstr1.wo_rjct_tot)) @ wipamt WITH STREAM-IO /*GUI*/ .
                        down 1.
                     end.
                     else
                     if i = 2 and wo_mstr1.wo_qty_rjct <> 0
                     then do:  /* SCRAP */
                        display
                           "  " + wo_mstr1.wo_part            @ item
                           wo_mstr1.wo_qty_rjct               @ accqty
                           -1 * wo_mstr1.wo_rjct_tot          @ wipamt WITH STREAM-IO /*GUI*/ .
                        down 1.
                     end.
                     else
                     if i = 3 and wo_mstr1.wo_mix_var <> 0
                        and glx_mthd <> "AVG"
                     then do: /* MIX VARIANCES */
                        display
                           "  " + wo_mstr1.wo_part           @ item
                           wo_mstr1.wo_qty_comp +
                           wo_mstr1.wo_qty_rjct              @ accqty
                           -1 * wo_mstr1.wo_mix_var          @ wipamt WITH STREAM-IO /*GUI*/ .
                        down 1.
                     end.
                  end. /* for each wo_mstr1 */
               end. /* i = 1 to 3 */
            end. /* do for wo_mstr1 */
            down 1.
         end. /* if wo_joint_type = "5" */

         /* REGULAR PRODUCTS (STD)  wo_joint_type = ""  */
         else do:

            display
               " - " + getTermLabel("STANDARD_COST_RECEIVED",16)
               + ":" @ item
               -1 *
               (wo_mtl_tot + wo_lbr_tot + wo_bdn_tot + wo_sub_tot
               - wo_rjct_tot - wo_wip_tot - wo_mthd_var) @ wipamt WITH STREAM-IO /*GUI*/ .
            down 1.
         end.

         display
            " - " + getTermLabel("SCRAPPED",16) + ":" @ item
            -1 * wo_rjct_tot @ wipamt WITH STREAM-IO /*GUI*/ .
         down 1.

         /* DISPLAY DISCREPANCY FOR BASE PROCESS ORDERS */
         /* AND METHOD CHANGE FOR BASE PROCESS & REGULAR ORDERS */
         if glx_mthd = "AVG" then
            display " - " + getTermLabel("DISCREPANCY",16) + ":" @ item WITH STREAM-IO /*GUI*/ .
         else
            display " - " + getTermLabel("METHOD_CHANGE_VARIANCE",16)
            + ":" @ item
            -1 * wo_mthd_var @ wipamt WITH STREAM-IO /*GUI*/ .
         underline wipamt.

         /* RE-INITIALIZE FORMAT */
         wipamt:format = tmp_fmt.

         /* BALANCE FOR JOINT PRODUCTS (AVG & STD) & REGULAR (STD) */
         display
            getTermLabel("BALANCE",19) + ":" @ item
            wo_wip_tot @ wipamt WITH STREAM-IO /*GUI*/ .
      end. /* REGULAR PRODUCTS (STD) AND JOINT PRODUCTS (AVG & STD) */
   end.

   
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
************judy 07/06/05 end delete***/
end.

/*judy 07/06/05 begin add*/
for each wolist by wl_part:
find first wosum where ws_part =  wl_part no-error.
  if not available wosum then do:
   create wosum.
   ws_part=wl_part.

  for each tr_hist where tr_part = wl_part and tr_date >= due and tr_date <= due1 and tr_type = "RCT-WO" :
    if tr_nbr <> "" then
    ws_qty_comp2 = ws_qty_comp2 + tr_qty_chg.
    else 
    ws_qty_comp1 = ws_qty_comp1 + tr_qty_chg.
  end.
 
 end.

if wl_prod_line="1200" or wl_prod_line = "1500" then 
     ws_1200 = ws_1200 + wl_acccst.
     else if wl_prod_line="1100" then 
     ws_1100 = ws_1100 + wl_acccst.
     else if wl_prod_line >= "2000" and wl_prod_line <= "2999" then
     ws_2000 = ws_2000 + wl_acccst.
     else 
     ws_7000 = ws_7000 + wl_acccst.
     	
end.

sum_1100 = 0.
sum_1200 = 0.
sum_2000 = 0.
sum_7000 = 0.
sum_qty_comp = 0.

for each wosum:
find pt_mstr where pt_part = ws_part.
if pt_prod_line >= "7000" and pt_prod_line <= "7999" and (ws_qty_comp1 <> 0 or ws_qty_comp2 <> 0) then do:
sum_1100 = sum_1100 + ws_1100.
sum_1200 = sum_1200 + ws_1200.
sum_2000 = sum_2000 + ws_2000.
sum_7000 = sum_7000 + ws_7000.
sum_qty_comp = sum_qty_comp + ws_qty_comp1 + ws_qty_comp2.
disp ws_part column-label "零件号" ws_1200 ws_1100 ws_2000 ws_7000 ws_qty_comp1 ws_qty_comp2 ws_qty_comp1 + ws_qty_comp2 column-label "完工总计  " format ">>>,>>9" with STREAM-IO width 180.
end.

end.
disp "合计：" sum_1200 column-label "国产件用量  " format "->>>,>>>,>>>,999.99" sum_1100 column-label "进口件用量   " format "->>>,>>>,>>>,999.99" sum_2000 column-label "外购半成品  " format "->>>,>>>,>>>,999.99"  sum_7000 column-label "产成品改制  " format "->>>,>>>,>>>,999.99" sum_qty_comp column-label "完工数量  " format "->>,>>>,>>>,>>9" with width 256 STREAM-IO.

/*judy 07/06/05 end add*/


{wbrp04.i}
