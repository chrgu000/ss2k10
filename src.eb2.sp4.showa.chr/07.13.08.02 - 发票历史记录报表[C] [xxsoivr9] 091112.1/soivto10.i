/* soivto10.i - GTM CONSOLIDATED INVOICE TRAILER DETAIL DISPLAY FOR {txnew.i} */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.1.1.12 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 8.6E          CREATED: 12/04/98   BY: *J360* Poonam Bahl         */
/* REVISION: 9.0     LAST MODIFIED: 08/10/99   BY: *M0DM* Satish Chavan       */
/* REVISION: 9.0     LAST MODIFIED: 10/05/99   BY: *L0JV* Anup Pereira        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00   BY: *N0KN* myb                 */
/* Revision: 1.1.1.11     BY: Ellen Borden    DATE: 07/09/01  ECO: *P007*     */
/* $Revision: 1.1.1.12 $  BY: Vandna Rohira   DATE: 04/28/03  ECO: *N1YL*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

for first txc_ctrl
   fields (txc__qad03)
   no-lock:
end. /* FOR FIRST txc_ctrl */

if not et_dc_print then do with frame ihtot:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame ihtot:handle).

   if txc__qad03
   then
      display
         l_nontaxable_lbl
         invtot_nontaxable_amt @ nontaxable_amt
         l_taxable_lbl
         invtot_taxable_amt @ taxable_amt
         with frame ihtot.
   else
      display
         "" @ l_nontaxable_lbl
         "" @ nontaxable_amt
         "" @ l_taxable_lbl
         "" @ taxable_amt
         with frame ihtot.

   display
      ih_curr      when (base_rpt <> "")
      base_curr    when (base_rpt =  "")
                                 @ ih_curr
      invtot_line_total          @ line_total
      ih_disc_pct
      invtot_disc_amt            @ disc_amt
      tax_date
      user_desc[1]
      ih_trl1_cd invtot_trl1_amt @ ih_trl1_amt
      invtot_container_amt       @ container_charge_total
      user_desc[2]
      ih_trl2_cd invtot_trl2_amt @ ih_trl2_amt
      invtot_linecharge_amt      @ line_charge_total
      user_desc[3]
      ih_trl3_cd invtot_trl3_amt @ ih_trl3_amt
      invtot_tax_amt             @ tax_amt
      invtot_ord_amt             @ ord_amt
      invcrdt
   with frame ihtot.
end. /* if not et_dc_print then */
else do with frame ihtoteuro:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame ihtoteuro:handle).

   if txc__qad03
   then
      display
         l_nontaxable_lbl
         invtot_nontaxable_amt @ nontaxable_amt
         l_taxable_lbl
         invtot_taxable_amt @ taxable_amt
         with frame ihtoteuro.
   else
      display
         "" @ l_nontaxable_lbl
         "" @ nontaxable_amt
         "" @ l_taxable_lbl
         "" @ taxable_amt
         with frame ihtoteuro.

   display
      ih_curr      when (base_rpt <> "")
      base_curr    when (base_rpt = "" and ih_curr <> base_curr)
                                      @ ih_curr
      invtot_line_total               @ line_total
      ih_disc_pct
      invtot_disc_amt                 @ disc_amt
      tax_date
      user_desc[1]
      ih_trl1_cd invtot_trl1_amt      @ ih_trl1_amt
      invtot_container_amt            @ container_charge_total
      user_desc[2]
      ih_trl2_cd invtot_trl2_amt      @ ih_trl2_amt
      invtot_linecharge_amt           @ line_charge_total
      user_desc[3]
      ih_trl3_cd invtot_trl3_amt      @ ih_trl3_amt
      invtot_tax_amt                  @ tax_amt
      invtot_ord_amt                  @ ord_amt
      invcrdt
      ettot_line_total                @ et_line_total
      ettot_disc_amt                  @ et_disc_amt
      ettot_trl1_amt @
      et_trl1_amt
      ettot_trl2_amt @
      et_trl2_amt
      ettot_trl3_amt @
      et_trl3_amt
      ettot_tax_amt @
      et_tax_amt
      ettot_ord_amt @
      et_ord_amt
   with frame ihtoteuro.
end. /* else */
