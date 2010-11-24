/* sosomtdi.i - Sales Order Maintenance Display header frame b               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13 $                                                         */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.3      LAST MODIFIED: 09/14/92   BY: tjs *G035*               */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086*               */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 06/29/94   BY: qzl *H419*               */
/* REVISION: 7.5      LAST MODIFIED: 03/10/95   BY: DAH *J042*               */
/* REVISION: 8.5      LAST MODIFIED: 10/02/96   BY: *J15C* Markus Barone     */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb                 */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00 BY: *N0WB* Mudit Mehta         */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.13 $    BY: Russ Witt  DATE: 09/21/01  ECO: *P01H*          */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{cxcustom.i "SOSOMTDI.I"}

{&SOSOMTDI-I-TAG5}
if new_order then

socmmts = if this-is-rma
   {&SOSOMTDI-I-TAG1}
   then
rmc_hcmmts
else soc_hcmmts.
{&SOSOMTDI-I-TAG2}
else
   socmmts = (so_cmtindx <> 0).
if not new_order then socrt_int = so__qad02.

/* Rearranged frame b, new format follows. */

{&SOSOMTDI-I-TAG3}
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
display
   so_ord_date

   line_pricing
   confirm
   so_conf_date
   so_req_date
   so_pr_list
   so_curr
   so_lang
   promise_date
   perform_date
   so_site
   so_taxable
   so_taxc
   so_tax_date
   so_due_date
   so_channel
   so_fix_pr
   so_pricing_dt
   so_project
   so__dte01
   so_cr_terms
   so_po
   socrt_int
   so_rmks
   reprice
   so_userid
with frame b.
{&SOSOMTDI-I-TAG4}
