/* reuvps7.p - REPETITIVE - POST SETUP LABOR BURDEN USAGE VARIANCE            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.9 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 03/31/95   BY: WUG *G0K0*                */
/* REVISION: 7.3      LAST MODIFIED: 12/11/95   BY: JYM *G1FZ*                */
/* REVISION: 7.3      LAST MODIFIED: 01/09/96   BY: emb *G1K9*                */
/* REVISION: 8.5      LAST MODIFIED: 12/10/95   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 11/04/96   BY: *H0NQ* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 02/18/97   BY: *J1HC* Russ Witt          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.5       BY: Hualin Zhong     DATE: 06/15/01  ECO: *N0ZF*   */
/* Revision: 1.8.1.6       BY: Mark Christian   DATE: 10/05/01  ECO: *N13H*   */
/* Revision: 1.8.1.7  BY: Seema Tyagi DATE: 12/30/02 ECO: *N233* */
/* $Revision: 1.8.1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */


/* SS - 100329.1  By: Roger Xiao */  /*取消相关表的锁定*/
/* SS - 100519.1  By: Roger Xiao */  /*"tt1_cc = wo_line" 直接替换为"tt1_cc = wr_wkctr"*/
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{ssvdef.i " "  }
define input parameter cumwo_lot as character no-undo.
define input parameter eff_date as date no-undo.
define input-output parameter wo_cum_var_amt like glt_amt
   label  "Cum Order Cumulative Variance" no-undo.
define input-output parameter wo_var_to_post like glt_amt
   label "Cum Order Variance To Post" no-undo.

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

define variable burden_rate like wc_lbr_rate
   label "Burden Rate" no-undo.
define variable cum_var_amt like trgl_gl_amt
   column-label "Cumulative!Variance" no-undo.
define variable cum_var_hours like wr_qty_cumproc
   column-label "Variance!Hours" no-undo.
define variable dept as character no-undo.
define variable emp as character no-undo.
define variable setup_time_per_unit like wr_run
   column-label  "Std Setup Time!Per Unit" no-undo.
define variable shift as character no-undo.
define variable std_issue_qty like wr_qty_cumproc no-undo.
define variable std_lbr_hrs like wr_act_run
   column-label  "Std Labor!Hours" no-undo.
define variable trans_type as character no-undo.
define variable var_to_post like trgl_gl_amt
   column-label "Variance!To Post" no-undo.
define variable glx_set like cs_set no-undo.
define variable glx_mthd like cs_method no-undo.
define variable cur_set like cs_set no-undo.
define variable cur_mthd like cs_method no-undo.
define variable displaycount as integer no-undo.

form
   wr_op
   wr_qty_cumproc
   wr_setup       column-label "Std Setup Time"
   std_lbr_hrs
   wr_act_setup   column-label "Actual Labor!Hours"
   cum_var_hours
   burden_rate
   cum_var_amt    at 100
   var_to_post
with width 132
down
title color normal
getFrameTitle("SETUP_LABOR_BURDEN_USAGE_VARIANCE", 35)
frame f_a.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f_a:handle).

find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot no-lock.
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
                         output cur_mthd)"}


for each wr_route no-lock
   where wr_route.wr_domain = global_domain and  wr_lot = wo_lot
   break by wr_lot
         by wr_op
   with frame f_a:

/* SETUP Burden =
         (( routing setup time / order quantity ) *
          ( work center setup rate * work center burden percent ) +
            work center burden rate +
          ( work center machine burden rate * routing machines used )
         ) * item yield percentage

   HERE rwbdncal.p IS NOT USED TO CALCULATE SETUP BURDEN BUT TO
   CALCULATE BURDEN  RATE USING PART OF SETUP BURDEN FORMULA OF
   rwbdncal.p STANDARD PROGRAM **/

   {gprun.i ""rwbdncal.p"" "(input 'SETUP'              /* BURDEN COST TYPE */,
                             input no                  /* ACCUMULATE TOTAL? */,
                             input (wr_bdn_pct * 0.01)    /* BURDEN PERCENT */,
                             input wr_bdn_rate               /* BURDEN RATE */,
                             input 0                          /* LABOR RATE */,
                             input wr_mch_bdn        /* MACHINE BURDEN RATE */,
                             input wr_mch_op               /* MACHINES USED */,
                             input 1                      /* ORDER QUANTITY */,
                             input 1                        /* STD RUN TIME */,
                             input wr_setup_rte               /* SETUP RATE */,
                             input 1                  /* ROUTING SETUP TIME */,
                             input 1                  /* ITEM YIELD PERCENT */,
                             input-output burden_rate     /* BURDEN RATE */ )"}

   assign
      setup_time_per_unit = wr_setup / wo_qty_ord
      std_lbr_hrs         = wr_qty_cumproc * setup_time_per_unit
      cum_var_hours       = wr_act_setup - std_lbr_hrs
      cum_var_amt         = cum_var_hours * burden_rate.

   {gprun.i ""gpcurrnd.p"" "(input-output cum_var_amt,
                             input gl_rnd_mthd)"}
   if glx_mthd = "AVG" then
      assign
         cum_var_amt = 0
         var_to_post = 0.

   FOR EACH tt1   WHERE tt1_site = wo_site 
                   AND tt1_lot = wo_lot 
                   /*
                   AND tt1_pare = wo_part
                   AND tt1_cc = wr_wkctr 
                   */
                   :
   			ASSIGN 
   			       tt1_setup_burden_rte =  cum_var_amt
   			.
   END.   



end.  /*for each wr_route*/
