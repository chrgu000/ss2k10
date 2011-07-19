/* woworlb.p - PRINT WORK ORDER PICKLIST                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6 $                                                        */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0          LAST EDIT: 06/14/89    MODIFIED BY: MLB             */
/* REVISION: 4.0          LAST EDIT: 01/22/90    MODIFIED BY: emb *A802*      */
/* REVISION: 6.0          LAST EDIT: 05/03/90    MODIFIED BY: MLB *D024*      */
/* REVISION: 8.6          LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6 $    BY: Manisha Sawant       DATE: 04/03/01  ECO: *P008*   */
/*By: Neil Gao 08/05/08 ECO: *SS 20080508* */
/* SS - 100623.1 By: Kaine Zhang */
/* SS - 100701.1 By: Kaine Zhang */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable picklistprinted like mfc_logical.
define shared variable deliv like wod_deliver.
define shared variable wo_des like pt_desc1.
define shared variable wo_qty like wo_qty_ord.
define shared variable wo_um like pt_um.
define shared variable wo_recno as recid.
/*17YJ*/ define shared variable sets like wo_qty_ord.
define variable i as integer.
define variable par_rev like pt_rev.

/* SS 091021.1 - B */
define shared variable xxloc  like ld_loc.
define shared variable xxloc1 like ld_loc.
/* SS 091021.1 - E */

/* SS - 100701.1 - B
/* SS - 100623.1 - B */
define variable sLocWIP as character format "x(8)" initial "309" label "车间库位" no-undo.
define variable sQtyWIP as character format "x(8)" initial "" label "车间库存" no-undo.
/* SS - 100623.1 - E */
SS - 100701.1 - E */
/* SS - 100701.1 - B */
define variable sLocWIP as character format "x(8)" initial "309" label "车间库位" no-undo.
define variable decQtyWIP like ld_qty_oh label "车间库存" no-undo.
/* SS - 100701.1 - E */

find wo_mstr no-lock where recid(wo_mstr) = wo_recno no-error.
if not available wo_mstr then
   leave.

/* Print Picklist */
/*SS 20080508 - B*/
/*
{mfworlb.i}
*/
{xxmfworlb.i}
/*SS 20080508 - E*/