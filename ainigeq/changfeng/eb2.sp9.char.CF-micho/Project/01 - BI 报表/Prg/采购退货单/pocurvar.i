/* pocurvar.i - DEFINE ROUND VARIABLES REQUIRED FOR PURCHASE ORDERS & RTS */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.3.1.2 $                                               */
/*V8:ConvertMode=Maintenance                                              */
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: ccc *J053**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb            */
/* $Revision: 1.3.1.2 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/** DEFINE VARIABLES NEEDED FOR CURRENCY DEPENDENT FORMATTING */

/* TO HOLD 'TAXABLE_AMT' FORMATS: */
define {1} shared variable taxable_fmt     as character no-undo.
define {1} shared variable taxable_old     as character no-undo.

/* TO HOLD 'NONTAXABLE_AMT' FORMATS: */
define {1} shared variable nontax_fmt      as character no-undo.
define {1} shared variable nontax_old      as character no-undo.

/* TO HOLD 'LINES_TOTAL' FORMATS: */
define {1} shared variable lines_tot_fmt   as character no-undo.
define {1} shared variable lines_tot_old   as character no-undo.

/* TO HOLD 'TAX_TOTAL' FORMATS: */
define {1} shared variable tax_tot_fmt     as character no-undo.
define {1} shared variable tax_tot_old     as character no-undo.

/* TO HOLD 'ORDER_AMT' FORMATS: */
define {1} shared variable order_amt_fmt   as character no-undo.
define {1} shared variable order_amt_old   as character no-undo.

/* TO HOLD 'PO_PREPAID' FORMATS: */
define {1} shared variable prepaid_fmt     as character no-undo.
define {1} shared variable prepaid_old     as character no-undo.
