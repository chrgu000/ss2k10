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
/* $Revision: 1.20 $ BY: Bill Jiang            DATE: 01/18/06 ECO: *SS - 20060118*    */
/* $Revision: 1.20 $ BY: Bill Jiang            DATE: 05/26/06 ECO: *SS - 20060526.1*    */

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

/* SS - 20060526.1 - B */
/*
1. 增加了以下输入条件:
   入库日期:____至:____
2. 增加了以下输出字段:
   入库数量
   加工单数量
3. 执行列表:
   a6woworp0505.p      
   a6woworp0505a.p
*/
/* SS - 20060526.1 - E */

/* SS - 20060118 - B */
{a6woworp0505.i}

/* SS - 20060526.1 - B */
define input parameter effdate   like tr_effdate.
define input parameter effdate1  like tr_effdate.
/* SS - 20060526.1 - E */
define input parameter acct_close like wo_acct_close.
define input parameter CLOSE_date   like wo_close_date.
define input parameter close_date1  like wo_close_date.
define input parameter CLOSE_eff   like wo_close_eff.
define input parameter close_eff1  like wo_close_eff.

DEFINE INPUT PARAMETER i_line LIKE pt_prod_line.
DEFINE INPUT PARAMETER i_line1 LIKE pt_prod_line.
/* SS - 20060118 - E */
                                                                                 
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

form
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
with frame b side-labels width 132 no-attr-space.

/* SET EXTERNAL LABELS */
/* SS - 20060118 - B */
/*
setFrameLabels(frame b:handle).
*/
/* SS - 20060118 - E */

form
   item
   accqty
   expcst
   acrvar
   acccst
   rtevar
   usevar
   wowipx
   wipamt
with frame c width 132 down no-attr-space.

/* SET EXTERNAL LABELS */
/* SS - 20060118 - B */
/*
setFrameLabels(frame c:handle).
*/
/* SS - 20060118 - E */

firstwo = yes.
find first gl_ctrl no-lock.

/* FORMAT RETURNED BY gpcurfmt.p IS STORED IN tmp_fmt AND IS   */
/* USED AS THE DISPLAY FORMAT FOR EVERY AMOUNT COLUMN VARIABLE.*/
/* THE FORMAT FOR THESE VARIABLES IS RE-INITIALIZED AFTER EVERY*/
/* UNDERLINE STATEMENT AS THE DISPLAY FORMAT GETS CHANGED.     */

tmp_fmt = expcst:format.
{gprun.i ""gpcurfmt.p"" "(input-output tmp_fmt,
                          input gl_rnd_mthd)"}

/* SS - 20060526.1 - B */
   FOR EACH tr_hist NO-LOCK
      WHERE tr_type = 'rct-wo'
      AND tr_effdate >= effdate
      AND tr_effdate <= effdate1
      BREAK BY tr_lot
      :
      ACCUMULATE tr_qty_loc (TOTAL BY tr_lot).
      IF LAST-OF(tr_lot) THEN DO:
         {a6woworp0505a.i}
      END.
   END.
/* SS - 20060526.1 - E */

{wbrp04.i}
