/* reuvps6.p - REPETITIVE - POST SETUP LABOR USAGE VARIANCE                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.8 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 03/31/95   BY: WUG *G0K0*                */
/* REVISION: 7.3      LAST MODIFIED: 01/09/96   BY: emb *G1K9*                */
/* REVISION: 8.5      LAST MODIFIED: 12/10/95   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/18/97   BY: *J1HC*   Russ Witt        */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 12/21/99   BY: *J3N1* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.6  BY: Hualin Zhong DATE: 06/15/01 ECO: *N0ZF* */
/* $Revision: 1.6.1.8 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
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
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reuvps6_p_1 "Std Labor!Hours"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_2 "Std Setup Time!Per Unit"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_3 "Variance!To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_5 "Variance!Hours"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_7 "Cumulative!Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_8 "Cum Order Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_9 "Cum Order Cumulative Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvps6_p_10 "Actual Labor!Hours"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter cumwo_lot as character no-undo.
define input parameter eff_date as date no-undo.
define input-output parameter wo_cum_var_amt like glt_amt
   label {&reuvps6_p_9} no-undo.
define input-output parameter wo_var_to_post like glt_amt
   label {&reuvps6_p_8} no-undo.

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
   column-label {&reuvps6_p_7} no-undo.
define variable cum_var_hours like wr_qty_cumproc
   column-label {&reuvps6_p_5} no-undo.
define variable dept as character no-undo.
define variable emp as character no-undo.
define variable qty_per as decimal no-undo.
define variable setup_time_per_unit like wr_run
   column-label {&reuvps6_p_2} no-undo.
define variable shift as character no-undo.
define variable std_lbr_hrs like wr_act_run
   column-label {&reuvps6_p_1} no-undo.
define variable trans_type as character no-undo.
define variable var_to_post like trgl_gl_amt
   column-label {&reuvps6_p_3} no-undo.
define variable glx_set like cs_set no-undo.
define variable glx_mthd like cs_method no-undo.
define variable cur_set like cs_set no-undo.
define variable cur_mthd like cs_method no-undo.
define variable displaycount as integer no-undo.

form
   wr_op
   wr_qty_cumproc
   setup_time_per_unit
   std_lbr_hrs
   wr_act_setup   column-label {&reuvps6_p_10}
   cum_var_hours
   wr_setup_rte
   cum_var_amt    at 100
   var_to_post
with frame f_a width 132
title color normal (getFrameTitle("SETUP_LABOR_USAGE_VARIANCE",34)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame f_a:handle).

find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
exclusive-lock.
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

for each wr_route exclusive-lock
 where wr_route.wr_domain = global_domain and  wr_lot = wo_lot
break by wr_lot by wr_op with frame f_a down:

   dept = "".

   find wc_mstr
    where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr
     and wc_mch = wr_mch no-lock no-error.
   if available wc_mstr then dept = wc_dept.

   assign
      setup_time_per_unit = wr_setup / wo_qty_ord
      std_lbr_hrs         = wr_qty_cumproc * setup_time_per_unit
      cum_var_hours       = wr_act_setup - std_lbr_hrs
      cum_var_amt         = cum_var_hours * wr_setup_rte.

   /* ROUND TRANSFERRED COST TO BASE CURRENCY PRECISION */
   {gprun.i ""gpcurrnd.p"" "(input-output cum_var_amt,
                             input        gl_rnd_mthd)"}
   var_to_post = cum_var_amt - wr_slvuse_post.

   if glx_mthd = "AVG" then
      assign
         cum_var_amt = 0
         var_to_post = 0.

   if (zero_unposted_var = yes or var_to_post <> 0)
      and (zero_cum_var = yes or cum_var_amt <> 0) then do:

      if orderprinted = no then DO:
      	 /*ss - 2008.03.23 - B*/  
         {gprun.i ""ssrewodi.p"" "(input wo_lot)"}
          /*ss - 2008.03.23 - E*/  
         orderprinted = yes.
      end.

      displaycount = displaycount + 1.
/*ss - 2008.03.23 - B*/
/*
      display
         wr_op
         wr_qty_cumproc
         setup_time_per_unit
         std_lbr_hrs
         wr_act_setup
         cum_var_hours
         wr_setup_rte
         cum_var_amt
         var_to_post.
      down 1.
*/  

   FOR EACH tt1  WHERE tt1_site = wo_site 
                   AND tt1_lot = wo_lot 
                   /*
                   AND tt1_pare = wo_part
                   AND tt1_cc = wo_line 
                   */
                   :
   			ASSIGN 
    			       tt1_setup_per_time = setup_time_per_unit
   			       tt1_setup_std_hrs =  std_lbr_hrs
   			       tt1_setup_act_hrs =  wr_act_setup
    			     tt1_setup_lbr_rte = cum_var_amt 
   			.
   END.   
   /*
   IF NOT AVAILABLE tt1 THEN DO:

   			CREATE tt1 .
   			ASSIGN tt1_site = wo_site 
   			       tt1_lot = wo_lot
   			       tt1_peri = STRING(YEAR(wo_rel_date),'9999') + "/" + STRING(MONTH(wo_rel_date),'99')
   			       tt1_pare = wo_part 
   			       tt1_cc = wo_line
   			       tt1_setup_per_time = setup_time_per_unit
   			       tt1_setup_std_hrs =  std_lbr_hrs
   			       tt1_setup_act_hrs =  wr_act_setup
    			     tt1_setup_lbr_rte = cum_var_amt 
   			       .
		       
   END. 
  */
/*ss - 2008.03.23 - E*/
      wr_slvuse_post = cum_var_amt.

      if var_to_post <> 0 then do:

         trans_type = "SLUV".

         {gprun.i ""reophist.p"" "(input  trans_type,
                                   input  wr_lot,
                                   input  wr_op,
                                   input  emp,
                                   input  wr_wkctr,
                                   input  wr_mch,
                                   input  dept,
                                   input  shift,
                                   input  eff_date,
                                   output op_recno)"}

         create work_op_recids.
         work_op_recid = op_recno.

         assign
            sf_dr_acct = gl_lvar_acct
            sf_dr_sub  = gl_lvar_sub
            sf_dr_cc   = gl_lvar_cc.

         find wc_mstr
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr
           and wc_mch = wr_mch no-lock no-error.

         if available wc_mstr then do:
            find dpt_mstr  where dpt_mstr.dpt_domain = global_domain and
            dpt_dept = wc_dept no-lock no-error.

            if available dpt_mstr and dpt_lvar_acc <> "" then
               assign
                  sf_dr_acct = dpt_lvar_acc
                  sf_dr_sub  = dpt_lvar_sub
                  sf_dr_cc   = dpt_lvar_cc.
         end.

         assign
            sf_cr_acct = wo_acct
            sf_cr_sub  = wo_sub
            sf_cr_cc   = wo_cc
            sf_gl_amt  = var_to_post
            opgltype   = trans_type.

         {gprun.i ""sfopgl.p""}

         wo_wip_tot = wo_wip_tot - var_to_post.
      end.

      accumulate cum_var_amt (total).
      accumulate var_to_post (total).
   end.
/*ss - 2008.03.23 - B*/
/*
   if last(wr_op) and displaycount <> 0 then do:
      underline cum_var_amt var_to_post.
      down 1.

      display
         accum total cum_var_amt @ cum_var_amt
         accum total var_to_post @ var_to_post.

      assign
         wo_cum_var_amt = wo_cum_var_amt + accum total cum_var_amt
         wo_var_to_post = wo_var_to_post + accum total var_to_post.
   end.
*/
/*ss - 2008.03.23 - E*/   
end.
