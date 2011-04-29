/* txcalc20.p - CALCULATE TAX FOR A PO TRANSACTION LINE ITEMS                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.6.1.6 $                                                              */
/*V8:ConvertMode=Maintenance                                                 */
/* Revision: 7.4        CREATED:     06/22/93  By: wep *H010*                */
/*                                   09/27/93  By: bcm *H138*                */
/*                                   12/29/93  By: bcm *H270*                */
/*                                   02/23/95  By: jzw *H0BM*                */
/* Revision  8.6                     10/20/97  By: *K0JV* Shankar Subramanian*/
/* REVISION: 8.6E     LAST MODIFIED: 04/22/98  BY: *J2D9* Sachin Shah        */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98  BY: *L061* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00  BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.6.1.4       BY: Rajaneesh S.       DATE: 05/08/01 ECO: *M0W6* */
/* Revision: 1.6.1.5       BY: Rajiv Ramaiah      DATE: 06/26/01 ECO: *M1C8* */
/* $Revision: 1.6.1.6 $     BY: Vandna Rohira       DATE: 10/16/01 ECO: *N14H* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{txcaldef.i}
/* SET RECORD ACCESS VARIABLE FROM TXCALC PARAMETER(S) */
mstr_ref = txc_ref.

for first po_mstr
  fields (po_cr_terms po_curr po_due_date po_ex_rate
          po_ex_rate2 po_ex_ratetype
          po_nbr po_ord_date po_ship po_site po_tax_date
          po_tax_env po_vend)
  where po_nbr = mstr_ref
  no-lock :
end.

if not available po_mstr
then do:
   /* PURCHASE ORDER DOES NOT EXIST */
   {pxmsg.i &MSGNUM=343 &ERRORLEVEL=4}
   undo.
end.

/* SET TAX DATE */
if po_tax_date <> ?
then
   tax_date = po_tax_date.
else
if po_due_date <> ?
then
   tax_date = po_due_date.
else
if po_ord_date <> ?
then
   tax_date = po_ord_date.
else
   tax_date = today.

/* SET GL EFFECTIVE DATE */
if po_due_date <> ?
then
   tax_gl_date = po_due_date.
else
if po_ord_date <> ?
then
   tax_gl_date = po_ord_date.
else
   tax_gl_date = today.

for first ct_mstr
   fields (ct_code ct_disc_pct)
   where ct_code = po_cr_terms
   no-lock :
end.
if available ct_mstr
then
   inv_disc_pct = ct_disc_pct.

/* SET TAX VARIABLES AND CALCULATE TAX */

{xxxtxcalca.i  &det_prefix  = "pod"
            &mstr_prefix = "po"
            &det_file    = "pod_det"
            &det_key     = "pod_nbr"
            &criteria    = "and (pod_status = ' ')"
            &det_index   = "pod_nbrln"
            &tax_qty     = "if ((pod__qad02 = 0 or pod__qad02 = ?)
                            and (pod__qad09 = 0 or pod__qad09 = ?))
                            then
                               ((pod_qty_ord - pod_qty_rcvd)
                                * pod_pur_cost)
                               * (1 - (pod_disc_pct / 100))
                            else
                                ((pod_qty_ord - pod_qty_rcvd)
                                 * (pod__qad09 + (pod__qad02 / 100000)))"
            &taxable     = "pod_taxable"
            &tax_date    = "tax_date"
            &ship_to1    = "pod_site"
            &ship_to2    = "po_ship"
            &ship_from1  = "po_vend"
            &ship_from2  = """"
            &qty         = "((pod_qty_ord - pod_qty_rcvd) *
                              pod_pur_cost)"}
