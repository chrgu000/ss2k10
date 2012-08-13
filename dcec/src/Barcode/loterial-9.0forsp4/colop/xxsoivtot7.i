/* GUI CONVERTED from soivtot7.i (converter v1.75) Thu Jul 19 05:36:47 2001 */
/* soivtot7.i - CONSOLIDATED INVOICE TOTAL VARIABLE SUMMATION FOR {txnew.i}   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.3 $            */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4      LAST MODIFIED: 07/29/93   BY: jjs *H050*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/05/99   BY: *L0JV* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.3.1.3 $  BY: Ellen Borden    DATE: 07/09/01   ECO: *P007* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


assign
   invtot_nontaxable_amt = invtot_nontaxable_amt + nontaxable_amt
   invtot_taxable_amt    = invtot_taxable_amt    + taxable_amt
   invtot_line_total     = invtot_line_total     + line_total
   invtot_disc_amt       = invtot_disc_amt       + disc_amt
   invtot_trl1_amt       = invtot_trl1_amt       + so_trl1_amt
   invtot_trl2_amt       = invtot_trl2_amt       + so_trl2_amt
   invtot_trl3_amt       = invtot_trl3_amt       + so_trl3_amt
   invtot_tax_amt        = invtot_tax_amt        + tax_amt
   invtot_container_amt = invtot_container_amt + container_charge_total
   invtot_linecharge_amt = invtot_linecharge_amt + line_charge_total
   invtot_ord_amt        = invtot_ord_amt        + ord_amt.

/* ACCUMULATE TRAILER VARIABLES FOR DUAL CURRENCY */
if et_dc_print then
assign
   ettot_line_total = ettot_line_total + et_line_total
   ettot_disc_amt   = ettot_disc_amt   + et_disc_amt
   ettot_trl1_amt   = ettot_trl1_amt   + et_trl1_amt
   ettot_trl2_amt   = ettot_trl2_amt   + et_trl2_amt
   ettot_trl3_amt   = ettot_trl3_amt   + et_trl3_amt
   ettot_tax_amt    = ettot_tax_amt    + et_tax_amt
   ettot_ord_amt    = ettot_ord_amt    + et_ord_amt.
