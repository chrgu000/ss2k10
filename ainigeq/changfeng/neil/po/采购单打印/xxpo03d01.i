/* po03d01.i - PO PRINT FORM STATEMENT FOR FRAME C                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.3 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 8.5      LAST MODIFIED: 10/09/95   BY: taf *J053**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.1.3 $   BY: Jean Miller        DATE: 04/16/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* By: Neil Gao Date: 20061128 ECO: *ss 20061128.1 * */

/*        This file compiles into porp0301.p                  */

/* ss 20061128.1 - b 
form
   pod_line       at 1
   pod_part
   tax_flag       column-label "T"
   pod_due_date
   qty_open       column-label "Qty Open"
   pod_um
   pod_pur_cost   column-label "Unit Cost"     format "->,>>>,>>9.99<<<"
   ext_cost       column-label "Extended Cost"
with frame c no-box width 80 down.
 * ss 20061128.1 - e */
/* ss 20061128.1 - b */
 form 
   pod_line 
   pod_part
   pt_desc1 label "物料名称&型号规格"
/* pt_desc2 */
   pod_qty_ord
   pod_um
   pod_due_date
   pod__qad11 label "备注"
 with frame c no-box width 120 down.
/* ss 20061128.1 - e */
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
