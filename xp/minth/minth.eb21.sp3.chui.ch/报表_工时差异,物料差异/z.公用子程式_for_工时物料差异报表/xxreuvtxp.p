/* reuvpst.p - REPETITIVE - POST ACCUMULATED USAGE VARIANCE SUBPROGRAM        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.4 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/* REVISION: 7.3               LAST MODIFIED: 11/08/94   BY: WUG *GN98*       */
/* REVISION: 7.3               LAST MODIFIED: 01/10/96   BY: emb *G1K9*       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.2  BY: Hualin Zhong DATE: 06/15/01 ECO: *N0ZF* */
/* $Revision: 1.6.1.4 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */


/* SS - 100329.1  By: Roger Xiao */  /*取消相关表的锁定*/
/* SS - 100401.1  By: Roger Xiao */  /*直接抓数,不产生gl数据再undo*/

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{ssvdef.i " " }

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reuvpst_p_1 "Cum Order Variance To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE reuvpst_p_2 "Cum Order Cumulative Variance"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter cumwo_lot as character.
define input parameter eff_date as date.
define output parameter wo_cum_var_amt like glt_amt
   label {&reuvpst_p_2} no-undo.
define output parameter wo_var_to_post like glt_amt
   label {&reuvpst_p_1} no-undo.

define input parameter zero_unposted_var as logical no-undo.
define input parameter zero_cum_var as logical no-undo.
define variable orderprinted as logical initial no no-undo.

find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
/* SS - 100329.1 - B 
exclusive-lock.
   SS - 100329.1 - E */
/* SS - 100329.1 - B */
no-lock.
/* SS - 100329.1 - E */
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

assign
   wo_cum_var_amt = 0
   wo_var_to_post = 0.

/*ss - 2008.03.23 - B*/ 
/*
/*POST FLOORSTOCK EXPENSE*/

{gprun.i ""reuvps1.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

/*POST COMPONENT MATERIAL USAGE VARIANCE*/
*/
/*ss - 2008.03.23 - E*/ 

/* SS - 100401.1 - B 
{gprun.i ""ssreuvps21.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

   SS - 100401.1 - E */

/*POST WIP MATERIAL SCRAP USAGE VARIANCE*/

{gprun.i ""xxssreuv3.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

/*POST RUN LABOR USAGE VARIANCE*/

{gprun.i ""xxssreuv4.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

/*POST RUN LABOR BURDEN USAGE VARIANCE*/

{gprun.i ""xxssreuv5.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

/*POST SETUP LABOR USAGE VARIANCE*/

{gprun.i ""xxssreuv6.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

/*POST SETUP LABOR BURDEN USAGE VARIANCE*/

{gprun.i ""xxssreuv7.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}
                         
/*ss - 2008.03.23 - B*/
/*
/*POST SUBCONTRACT USAGE VARIANCE*/

{gprun.i ""reuvps8.p"" "(input        cumwo_lot,
                         input        eff_date,
                         input-output wo_cum_var_amt,
                         input-output wo_var_to_post,
                         input        zero_unposted_var,
                         input        zero_cum_var,
                         input-output orderprinted)"}

if orderprinted then do with frame f_a:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f_a:handle).

   display
      wo_cum_var_amt  colon 66 skip
      wo_var_to_post  colon 66
   with side-labels width 132.

END.
*/
/*ss - 2008.03.23 - E*/ 
