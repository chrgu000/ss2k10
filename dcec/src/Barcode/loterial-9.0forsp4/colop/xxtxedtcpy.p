/* xxtxedtcpy.p - COPY EDITED VALUES FROM PREVIOUS TRANSACTION            */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.14 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.4      LAST MODIFIED: 11/22/94   BY: bcm *H606*          */
/* REVISION: 8.5      LAST MODIFIED: 03/22/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* jzw          */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.14 $    BY: Katie Hilbert         DATE: 12/31/02  ECO: *P0LM*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define input parameter tr_type     like tx2d_tr_type no-undo.
define input parameter ref         like tx2d_ref     no-undo.
define input parameter nbr         like tx2d_nbr     no-undo.
define input parameter new_tr_type like tx2d_tr_type no-undo.
define input parameter new_ref     like tx2d_ref     no-undo.
define input parameter new_nbr     like tx2d_nbr     no-undo.
define input parameter lines       like tx2d_line    no-undo.

define buffer tx2dtemp             for tx2d_det.
define variable sign               as decimal initial 1 no-undo.

/* IN CERTAIN INSTANCES WE REALLY WANT TO REVERSE THE AMOUNTS */
if new_tr_type = '25' /* PO Returns */
then
   sign = ( - 1 ).

for each tx2d_det
   where tx2d_ref        = new_ref
    and  (tx2d_nbr       = new_nbr or new_nbr = "*")
    and  tx2d_tr_type    = new_tr_type
    and  (tx2d_line      = lines or lines = 0)
exclusive-lock:

   /* FIND SOURCE TRANSACTION RECORD */
   /* SERVICE CONTRACT ADD'L CHARGE LINES HAVE AN 'A' LOADED IN THE */
   /* TX2D_TRL FIELD TO DISTINGUISH THEM FROM 'NORMAL' CONTRACT     */
   /* LINES.  THEREFORE, THE TRAILER FIELD MUST MATCH ALSO TO       */
   /* PREVENT THE NORMAL CONTRACT LINE'S TAX INFO. FROM OVERWRITING */
   /* THE ADD'L CHARGE LINE'S TAX DETAIL.                           */

   for first tx2dtemp
      fields(tx2d_abs_ret_amt tx2d_cur_abs_ret_amt tx2d_cur_nontax_amt
             tx2d_cur_recov_amt tx2d_cur_tax_amt tx2d_edited tx2d_ref
             tx2d_ent_abs_ret_amt tx2d_ent_nontax_amt tx2d_ent_recov_amt
             tx2d_ent_tax_amt tx2d_line tx2d_nbr tx2d_nontax_amt
             tx2d_recov_amt tx2d_taxable_amt tx2d_tax_amt tx2d_tax_code
             tx2d_totamt tx2d_tottax tx2d_trl tx2d_tr_type)
      where tx2dtemp.tx2d_ref       = ref                    and
            (tx2dtemp.tx2d_nbr      = nbr or nbr = "*")      and
            tx2dtemp.tx2d_tr_type   = tr_type                and
            tx2dtemp.tx2d_line      = tx2d_det.tx2d_line     and
            tx2dtemp.tx2d_tax_code  = tx2d_det.tx2d_tax_code and
            tx2dtemp.tx2d_trl       = tx2d_det.tx2d_trl
   no-lock :

      /* COPY AMOUNTS */
      if tx2dtemp.tx2d_edited
      then
         assign
            tx2d_det.tx2d_edited          = yes
            tx2d_det.tx2d_tottax          = tx2dtemp.tx2d_tottax * sign
            tx2d_det.tx2d_totamt          = tx2dtemp.tx2d_totamt * sign
            tx2d_det.tx2d_cur_tax_amt     = tx2dtemp.tx2d_cur_tax_amt * sign
            tx2d_det.tx2d_tax_amt         = tx2dtemp.tx2d_tax_amt * sign
            tx2d_det.tx2d_ent_tax_amt     = tx2dtemp.tx2d_ent_tax_amt * sign
            tx2d_det.tx2d_cur_nontax_amt  = tx2dtemp.tx2d_cur_nontax_amt * sign
            tx2d_det.tx2d_nontax_amt      = tx2dtemp.tx2d_nontax_amt * sign
            tx2d_det.tx2d_ent_nontax_amt  = tx2dtemp.tx2d_ent_nontax_amt * sign
            tx2d_det.tx2d_taxable_amt     = tx2dtemp.tx2d_taxable_amt * sign
            tx2d_det.tx2d_cur_recov_amt   = tx2dtemp.tx2d_cur_recov_amt * sign
            tx2d_det.tx2d_recov_amt       = tx2dtemp.tx2d_recov_amt * sign
            tx2d_det.tx2d_ent_recov_amt   = tx2dtemp.tx2d_ent_recov_amt * sign
            tx2d_det.tx2d_cur_abs_ret_amt = tx2dtemp.tx2d_cur_abs_ret_amt * sign
            tx2d_det.tx2d_abs_ret_amt     = tx2dtemp.tx2d_abs_ret_amt * sign
            tx2d_det.tx2d_ent_abs_ret_amt = tx2dtemp.tx2d_ent_abs_ret_amt * sign.

   end.

end.
