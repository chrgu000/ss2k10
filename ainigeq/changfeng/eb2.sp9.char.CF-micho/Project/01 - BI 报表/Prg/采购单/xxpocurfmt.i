/* pocurfmt.i - FORMAT ROUND VARIABLES REQUIRED FOR PURCH ORDERS / RTS       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.10 $                                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 8.5      LAST MODIFIED: 07/13/95   BY: ccc *J053*               */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kappor      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb               */
/* $Revision: 1.10 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ADDED ASSIGN STATEMENT FOR ORACLE PERFORMANCE               */

/*** RESET ALL CURRENCY DEPENDENT ROUNNDING FORMAT VARIABLES */
/*** RESTORE <VAR-NAME>_FMT TO ORIGINAL DEFAULT VALUE CONTAINED IN _OLD;    */
/*** CALL GPCURFMT.P TO GET NEW _FMT BASED ON ROUNDING METHOD, THEN         */
/*** SET <VAR-NAME>:FORMAT TO _FMT                                          */

{gpcrfmt.i}

/* TAXABLE_AMT */
taxable_fmt = taxable_old.

run gpcrfmt (input-output taxable_fmt,input rndmthd).

/* NONTAXABLE_AMT */
nontax_fmt = nontax_old.

run gpcrfmt (input-output nontax_fmt,input rndmthd).

/* LINES_TOTAL */
lines_tot_fmt = lines_tot_old.

run gpcrfmt (input-output lines_tot_fmt,input rndmthd).

/* TAX_TOTAL */
tax_tot_fmt = tax_tot_old.

run gpcrfmt (input-output tax_tot_fmt,input rndmthd).

/* ORDER_AMT */
order_amt_fmt = order_amt_old.

run gpcrfmt (input-output order_amt_fmt,input rndmthd).

/* PREPAID */
prepaid_fmt = prepaid_old.

run gpcrfmt (input-output prepaid_fmt,input rndmthd).

po_prepaid:format = prepaid_fmt.

assign
    /*
   nontaxable_amt:format in frame potot = nontax_fmt          */
   lines_total:format in frame potot = lines_tot_fmt
   /* taxable_amt:format in frame potot = taxable_fmt              */
   tax_total:format in frame potot = tax_tot_fmt
   order_amt:format in frame potot = order_amt_fmt.
