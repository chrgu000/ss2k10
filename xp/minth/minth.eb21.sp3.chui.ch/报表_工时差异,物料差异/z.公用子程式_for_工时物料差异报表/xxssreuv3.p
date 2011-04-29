/* reuvps3.p - REPETITIVE - POST WIP MATERIAL SCRAP USAGE VARIANCE            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.7 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 03/07/95   BY: WUG *G0GQ*                */
/* REVISION: 7.3      LAST MODIFIED: 03/31/95   BY: WUG *G0K0*                */
/* REVISION: 7.3      LAST MODIFIED: 01/09/96   BY: emb *G1K9*                */
/* REVISION: 8.5      LAST MODIFIED: 12/10/95   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/18/97   BY: *J1HC*   Russ Witt        */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.5  BY: Hualin Zhong DATE: 06/15/01 ECO: *N0ZF* */
/* $Revision: 1.6.1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */


/* SS - 100329.1  By: Roger Xiao */  /*取消相关表的锁定*/
/* SS - 100519.1  By: Roger Xiao */  /*"tt1_cc = wo_line" 直接替换为"tt1_cc = wr_wkctr"*/
/* ss - 100524.1 by: jack */  /* first wc_mstr*/

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 100524.1 by: jack */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{ssvdef.i " " } 
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reuvps3_p_1 "Cum Order Cumulative Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_2 "Cum Order Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_3 "Cumulative!Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_4 "Cumulative!Scrapped Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_5 "Variance!To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_6 "Variance!Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_7 "Standard!Yield Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps3_p_8 "Standard!Scrap Qty"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter cumwo_lot as character no-undo.
define input parameter eff_date as date no-undo.
define input-output parameter wo_cum_var_amt like glt_amt
   label {&reuvps3_p_1} no-undo.
define input-output parameter wo_var_to_post like glt_amt
   label {&reuvps3_p_2} no-undo.

define input parameter zero_unposted_var as logical no-undo.
define input parameter zero_cum_var as logical no-undo.
define input-output parameter orderprinted as logical no-undo.

define shared workfile work_op_recids no-undo
   field work_op_recid as recid.

define new shared variable op_recno as recid.
define new shared variable opgltype like opgl_type.
define new shared variable ref like glt_ref.
define new shared variable sf_cr_acct like dpt_lbr_acct.
define new shared variable sf_cr_sub like dpt_lbr_sub.
define new shared variable sf_cr_cc like dpt_lbr_cc.
define new shared variable sf_dr_acct like dpt_lbr_acct.
define new shared variable sf_dr_sub like dpt_lbr_sub.
define new shared variable sf_dr_cc like dpt_lbr_cc.
define new shared variable sf_entity like en_entity.
define new shared variable sf_gl_amt like tr_gl_amt.

define variable cum_var_amt like trgl_gl_amt
   column-label {&reuvps3_p_3} no-undo.
define variable cum_var_qty like wr_qty_cumproc
   column-label {&reuvps3_p_6} no-undo.
define variable dept as character no-undo.
define variable display_count as integer no-undo.
define variable emp as character no-undo.
define variable qty_per as decimal no-undo.

define variable qty_cumscrap like wr_qty_cumrscrap
   column-label {&reuvps3_p_4} no-undo.
define variable scrap_acct as character no-undo.
define variable scrap_sub as character no-undo.
define variable scrap_cc as character no-undo.
define variable shift as character no-undo.
define variable std_scrap_qty like wr_qty_cumproc
   column-label {&reuvps3_p_8} no-undo.
define variable std_yld_qty like wr_qty_cumproc
   column-label {&reuvps3_p_7} no-undo.
define variable trans_type as character no-undo.
define variable var_to_post like trgl_gl_amt
   column-label {&reuvps3_p_5} no-undo.
define variable glx_set like cs_set no-undo.
define variable glx_mthd like cs_method no-undo.
define variable cur_set like cs_set no-undo.
define variable cur_mthd like cs_method no-undo.
define variable dummy_recid as recid no-undo.

form
   wr_op
   wr_qty_cumproc
   wr_yield_pct
   std_yld_qty
   std_scrap_qty
   qty_cumscrap
   cum_var_qty
   iro_cost_tot
   cum_var_amt  at 100
   var_to_post
with frame f_a width 132
title color normal (getFrameTitle("WIP_MATERIAL_SCRAP_USAGE_VARIANCE",43)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f_a:handle).

find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
/* SS - 100329.1 - B 
exclusive-lock.
   SS - 100329.1 - E */
/* SS - 100329.1 - B */
no-lock.
/* SS - 100329.1 - E */
find si_mstr  where si_mstr.si_domain = global_domain and  si_site = wo_site
no-lock.
sf_entity = si_entity.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/*DETERMINE COSTING METHOD*/
{gprun.i ""csavg01.p"" "(input  wo_part,
                         input  wo_site,
                         output glx_set,
                         output glx_mthd,
                         output cur_set,
                         output cur_mthd)" }

/*GET DEFAULT SCRAP ACCOUNT*/
assign
   scrap_acct = gl_scrp_acct
   scrap_sub  = gl_scrp_sub
   scrap_cc   = gl_scrp_cc.

find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
no-lock.

if available pt_mstr then do:
   find pl_mstr  where pl_mstr.pl_domain = global_domain and  pl_prod_line =
   pt_prod_line no-lock.

   if pl_scrp_acct > "" then
      assign
         scrap_acct = pl_scrp_acct
         scrap_sub  = pl_scrp_sub
         scrap_cc   = pl_scrp_cc.

   find pld_det
    where pld_det.pld_domain = global_domain and  pld_prodline = pt_prod_line
     and pld_site = wo_site and pld_loc = "" no-lock no-error.

   if available pld_det and pld_scrpacct > "" then
      assign
         scrap_acct = pld_scrpacct
         scrap_sub  = pld_scrp_sub
         scrap_cc   = pld_scrp_cc.
end.

for each wr_route no-lock
    where wr_route.wr_domain = global_domain and  wr_lot = wo_lot
    break by wr_lot by wr_op with frame f_a down:

   find iro_det
    where iro_det.iro_domain = global_domain and  iro_part = wo_part
     and iro_site = wo_site
     and iro_cost_set = "cumorder"
     and iro_routing = wo_lot
     and iro_op = wr_op no-lock.

   dept = "".
   /* ss 100524.1 -b
   find wc_mstr
    where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr
     and wc_mch = wr_mch no-lock no-error.
     ss - 100524.1 -e */
   /* ss - 100524.1 -b */
     FIND FIRST  wc_mstr
    where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr
     and wc_mch = wr_mch no-lock no-error.
   /* ss - 100524.1 -e */
   if available wc_mstr then
      dept = wc_dept.

   assign
      std_yld_qty   = wr_qty_cumproc * (wr_yield_pct / 100)
      std_scrap_qty = wr_qty_cumproc - std_yld_qty
      qty_cumscrap  = wr_qty_cumoscrap + wr_qty_cumrscrap
      cum_var_qty   = qty_cumscrap - std_scrap_qty
      cum_var_amt   = cum_var_qty * iro_cost_tot.

   /* ROUND TRANSFERRED COST TO BASE CURRENCY PRECISION */
   {gprun.i ""gpcurrnd.p"" "(input-output cum_var_amt,
                             input        gl_rnd_mthd)"}
   var_to_post = cum_var_amt - wr_svuse_accr.

   if glx_mthd = "AVG" then
      assign
         cum_var_amt = 0
         var_to_post = 0.



   FOR EACH tt1  WHERE tt1_site = wo_site 
                   AND tt1_lot = wr_lot 
                   AND tt1_pare = wo_part
                   AND tt1_cc = wr_wkctr
                   :
   			ASSIGN tt1_qty_iss = tt1_qty_iss + qty_cumscrap 
   			       tt1_qty_comp = tt1_qty_comp +  wr_qty_cumproc
   			.
   END.   
   IF NOT AVAILABLE tt1 THEN DO:

   			CREATE tt1 .
   			ASSIGN tt1_site = wo_site 
   			       tt1_peri = STRING(YEAR(wo_rel_date),'9999') + "/" + STRING(MONTH(wo_rel_date),'99')
   			       tt1_pare = wo_part 
   			       tt1_lot = wr_lot
   			       tt1_cc = wr_wkctr
   			       tt1_qty_iss = qty_cumscrap 
   			       tt1_qty_comp = wr_qty_cumproc
   			       tt1_price = iro_cost_tot
   			       .  
   END.



end . /*for each wr_route*/
