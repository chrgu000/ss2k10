/* GUI CONVERTED from txtotal.i (converter v1.75) Sun Jun 24 21:41:56 2001 */
/* txtotal.i - QAD CALCULATE TAX TOTALS FOR A TRANSACTION                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.10 $                                                            */
/*V8:ConvertMode=Maintenance                                               */
/* REVISION: 8.6         CREATED: 05/07/99         BY: *J3DQ* Niranjan R.  */
/* REVISION: 8.6   LAST MODIFIED: 12/22/99         BY: *J3N6* Santosh Rao  */
/* REVISION: 9.1   LAST MODIFIED: 09/05/00         BY: *N0RF* Mark Brown   */
/* REVISION: 9.1   LAST MODIFIED: 09/06/00         BY: *N0D0* Santosh Rao  */
/* $Revision: 1.10 $    BY: Rajaneesh S. DATE: 05/25/01 ECO: *M18D*             */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*
    I/O     Name        Like            Description
    -----   ----------- --------------- ------------------------------
    Input   tr_type     tx2d_tr_type    Transaction Type Code
    Input   ref         tx2d_ref        Document Reference
    Input   nbr         tx2d_nbr        Number (Related Document)
    Input   line        tx2d_line       Line Number
    I/O     taxable_amt tx2d_tottax     Total Taxable Amt on Transaction
    I/O     nontaxable_amt tx2d_ntaxamt[1] Total Taxable Amt on Transaction

*/

/* THIS PROCEDURE CALCULATES TOTAL TAXABLE AND  NONTAXABLE AMOUNT */

PROCEDURE p-tottax:

   define input  parameter tr_type              like tx2d_tr_type no-undo.
   define input  parameter ref                  like tx2d_ref     no-undo.
   define input  parameter nbr                  like tx2d_nbr     no-undo.
   define input  parameter line                 like tx2d_line    no-undo.
   define input-output parameter taxable_amt    like tx2d_totamt  no-undo.
   define input-output parameter nontaxable_amt like tx2d_totamt  no-undo.

   define buffer                 tx2ddet        for  tx2d_det.

   assign
      taxable_amt    = 0
      nontaxable_amt = 0 .

   for each tx2d_det no-lock where tx2d_domain = global_domain
      and tx2d_ref = ref
      and  (tx2d_nbr = nbr or nbr = "*")
      and   tx2d_tr_type = tr_type
     and  (line = 0 or tx2d_line = line)
     break by tx2d_line
            by tx2d_trl:
             if tx2d_line = 0 THEN NEXT.
             if tx2d_line <> 0  and
                can-find(first tx2ddet
                         where tx2ddet.tx2d_domain = global_domain
                           and tx2ddet.tx2d_ref       = tx2d_det.tx2d_ref
                           and tx2ddet.tx2d_nbr       = tx2d_det.tx2d_nbr
                           and tx2ddet.tx2d_line      = 0
                           and tx2ddet.tx2d_trl       = tx2d_det.tx2d_trl
                           and tx2ddet.tx2d_tr_type   = tx2d_det.tx2d_tr_type
                           and tx2ddet.tx2d_tax_env   = tx2d_det.tx2d_tax_env
                           and tx2ddet.tx2d_taxc      = tx2d_det.tx2d_taxc
                           and tx2ddet.tx2d_tax_usage = tx2d_det.tx2d_tax_usage)
             then
                next.

             if first-of (tx2d_trl) THEN DO:
             assign
                taxable_amt    = taxable_amt    + tx2d_tottax
                nontaxable_amt = nontaxable_amt + tx2d_cur_nontax_amt.

             END.
          end. /* FOR EACH TX2D_DET */
       end. /* P-TOTTAX */
