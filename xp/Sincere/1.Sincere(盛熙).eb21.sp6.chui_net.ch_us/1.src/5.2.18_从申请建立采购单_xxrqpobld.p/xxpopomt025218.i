/* popomt02.i - PURCHASE ORDER MAINTENANCE HEADER FORMS                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */

/* $Revision: 1.6.3.4 $ */

/* REVISION: 7.4     LAST MODIFIED: 09/07/93    BY: tjs *H082**/
/* REVISION: 7.4     LAST MODIFIED: 10/06/93    BY: cdt *H086**/
/* REVISION: 7.4     LAST MODIFIED: 10/23/93    BY: cdt *H184**/
/* REVISION: 7.4     LAST MODIFIED: 09/20/94    BY: ljm *GM74**/
/* REVISION: 7.5     LAST MODIFIED: 02/21/95    BY: dpm *J044**/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen  */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* Revision: 1.6.3.2       BY: Niranjan R.  Date: 05/24/00  ECO: *N0C7*     */
/* Revision: 1.6.3.3       BY: Mark B.Smith Date: 06/27/00  ECO: *N059*     */
/* $Revision: 1.6.3.4 $  BY: Steve Nugent Date: 05/01/02  ECO: *P018*   */


form
   space(1)
   po_nbr
   po_vend
   po_ship
   skip  space(5) v_to_po label "ÊÖ¹¤ÐÞ¸ÄPO"  /* SS - 101208.1  */
   with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   po_ord_date    colon 14
   po_pr_list2    colon 35
   po_confirm     colon 58
   impexp         colon 73 label "Imp/Exp"
   po_due_date    colon 14
   po_pr_list     colon 35
   po_curr        colon 58 po_lang
   po_buyer       colon 14
   disc           colon 35
   po_taxable     colon 58
   /*V8!view-as fill-in size 4 by 1 */
   po_taxc                 no-label
   po_tax_date    to    77 no-label
   po_bill        colon 14
   po_site        colon 35
   po_fix_pr      colon 58
   po_consignment     colon 73 label "Consign"
   so_job         colon 14
   po_project     colon 35
   po_cr_terms    colon 58
   po_crt_int     no-label
   po_contract    colon 14
   po_user_id     colon 58
   po_contact     colon 14
   po_req_id      colon 58
   po_rmks        colon 14
   pocmmts        colon 68
with frame b attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
