/* soivtot8.i - CONSOLIDATED INVOICE TRAILER DETAIL DISPLAY FOR {txnew.i}  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.6.1.8 $                                                    */
/*V8:ConvertMode=Maintenance                                               */
/* REVISION: 7.4      LAST MODIFIED: 07/29/93   BY: jjs *H050*             */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: afs *GO53*             */
/* REVISION: 8.5      LAST MODIFIED: 11/27/97   BY: *J273* Nirav Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00L* Ed v.d.Gevel    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *J2WV* Surekha Joshi   */
/* REVISION: 8.6E     LAST MODIFIED: 10/05/99   BY: *L0JV* Anup Pereira    */
/* REVISION: 9.1      LAST MODIFIED: 12/17/99   BY: *J3MX* Surekha Joshi   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0F4* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.6.1.6       BY: Ellen Borden       DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.6.1.7       BY: Manisha Sawant     DATE: 08/16/02  ECO: *N1RB* */
/* $Revision: 1.6.1.8 $    BY: Vandna Rohira      DATE: 04/28/03  ECO: *N1YL* */
/* $Revision: 1.6.1.8 $    BY: Bill Jiang      DATE: 06/02/06  ECO: *SS - 20060602.1* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060602.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6soivrp0101.p
   a6soivrp0101a.p
   a6soivrp0101b.p,a6soivtot80101.i,a6soivtrl20101.p
   a6soivtrlc0101.p
   a6soivtrl20101.i
   a6sototfrm0101.i
*/
/* SS - 20060602.1 - E */

for first txc_ctrl
   fields (txc__qad03)
   no-lock:
end. /* FOR FIRST txc_ctrl */

if invtot_ord_amt < 0 then

assign invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
else assign invcrdt = "".

if not et_dc_print then
   do on endkey undo, leave:
   /* SS - 20060602.1 - B */
   /*
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame sotot:handle).

   if txc__qad03
   then
      display
         l_nontaxable_lbl
         nontaxable_amt
         l_taxable_lbl
         taxable_amt
         with frame sotot.
   else
      display
         "" @ l_nontaxable_lbl
         "" @ nontaxable_amt
         "" @ l_taxable_lbl
         "" @ taxable_amt
         with frame sotot.

   display
      invtot_line_total          @ line_total
      invtot_container_amt       @ container_charge_total
      invtot_linecharge_amt      @ line_charge_total
      (if invtot_line_total <> 0 and l_consolidate then
      (round(invtot_disc_amt / invtot_line_total * -100, 2))
      else
      (so_disc_pct))
      @ so_disc_pct
      invtot_disc_amt            @ disc_amt
      user_desc
      so_trl1_cd invtot_trl1_amt @ so_trl1_amt
      so_trl2_cd invtot_trl2_amt @ so_trl2_amt
      so_trl3_cd invtot_trl3_amt @ so_trl3_amt
      invtot_tax_amt             @ tax_amt
      so_curr
      invcrdt
      invtot_ord_amt             @ ord_amt
      tax_date
      "" when (not maint)        @ tax_edit
   with frame sotot.
   */
   FIND tta6soivrp0101 WHERE RECID(tta6soivrp0101) = rec1 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE tta6soivrp0101 THEN DO:
      CREATE tta6soivrp0101.
   END.

   if txc__qad03 then
      ASSIGN
         tta6soivrp0101_nontaxable_amt = nontaxable_amt
         tta6soivrp0101_taxable_amt = taxable_amt
         .
   ASSIGN
      tta6soivrp0101_invtot_line_total = invtot_line_total
      tta6soivrp0101_invtot_container = invtot_container_amt
      tta6soivrp0101_invtot_linecharge = invtot_linecharge_amt
      tta6soivrp0101_invtot_disc_amt = invtot_disc_amt
      tta6soivrp0101_user_desc[1] = user_desc[1]
      tta6soivrp0101_user_desc[2] = user_desc[2]
      tta6soivrp0101_user_desc[3] = user_desc[3]
      tta6soivrp0101_so_trl1_cd = so_trl1_cd 
      tta6soivrp0101_invtot_trl1_amt = invtot_trl1_amt
      tta6soivrp0101_so_trl2_cd = so_trl2_cd 
      tta6soivrp0101_invtot_trl2_amt = invtot_trl2_amt
      tta6soivrp0101_so_trl3_cd = so_trl3_cd 
      tta6soivrp0101_invtot_trl3_amt = invtot_trl3_amt
      tta6soivrp0101_invtot_tax_amt = invtot_tax_amt
      tta6soivrp0101_so_curr = so_curr
      tta6soivrp0101_invcrdt = invcrdt
      tta6soivrp0101_invtot_ord_amt = invtot_ord_amt
      tta6soivrp0101_tax_date = tax_date
      .
   if invtot_line_total <> 0 and l_consolidate THEN DO:
      ASSIGN
         tta6soivrp0101_so_disc_pct = (round(invtot_disc_amt / invtot_line_total * -100, 2))
         .
   END.
   ELSE DO:
      ASSIGN
         tta6soivrp0101_so_disc_pct = (so_disc_pct)
         .
   END.
   /* SS - 20060602.1 - B */
end. /* DO ON ENDKEY UNDO, LEAVE */
else
   do on endkey undo, leave:

   /* SS - 20060602.1 - B */
   /*
      if txc__qad03
      then
         display
            l_nontaxable_lbl
            nontaxable_amt
            l_taxable_lbl
            taxable_amt
            with frame sototeuro.
      else
         display
            "" @ l_nontaxable_lbl
            "" @ nontaxable_amt
            "" @ l_taxable_lbl
            "" @ taxable_amt
            with frame sototeuro.

   display
      invtot_line_total          @ line_total
      ettot_line_total @
      et_line_total
      (if invtot_line_total <> 0 and l_consolidate then
      (round(invtot_disc_amt / invtot_line_total * -100, 2))
      else
      (so_disc_pct))
      @ so_disc_pct
      invtot_disc_amt            @ disc_amt
      ettot_disc_amt @
      et_disc_amt
      user_desc
      so_trl1_cd invtot_trl1_amt @ so_trl1_amt
      ettot_trl1_amt @
      et_trl1_amt
      so_trl2_cd invtot_trl2_amt @ so_trl2_amt
      ettot_trl2_amt @
      et_trl2_amt
      so_trl3_cd invtot_trl3_amt @ so_trl3_amt
      ettot_trl3_amt @
      et_trl3_amt
      invtot_tax_amt             @ tax_amt
      ettot_tax_amt @
      et_tax_amt
      so_curr
      invcrdt
      invtot_ord_amt             @ ord_amt
      ettot_ord_amt @
      et_ord_amt
      tax_date
      "" when (not maint)        @ tax_edit
   with frame sototeuro.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame sototeuro:handle).
   */
   FIND tta6soivrp0101 WHERE RECID(tta6soivrp0101) = rec1 NO-LOCK NO-ERROR.
   IF NOT AVAILABLE tta6soivrp0101 THEN DO:
      CREATE tta6soivrp0101.
   END.

   if txc__qad03 then
      ASSIGN
         tta6soivrp0101_nontaxable_amt = nontaxable_amt
         tta6soivrp0101_taxable_amt = taxable_amt
         .
   ASSIGN
      tta6soivrp0101_invtot_line_total = invtot_line_total
      tta6soivrp0101_ettot_line_total = ettot_line_total
      tta6soivrp0101_invtot_disc_amt = invtot_disc_amt
      tta6soivrp0101_ettot_disc_amt = ettot_disc_amt
      tta6soivrp0101_user_desc[1] = user_desc[1]
      tta6soivrp0101_user_desc[2] = user_desc[2]
      tta6soivrp0101_user_desc[3] = user_desc[3]
      tta6soivrp0101_so_trl1_cd = so_trl1_cd 
      tta6soivrp0101_invtot_trl1_amt = invtot_trl1_amt
      tta6soivrp0101_ettot_trl1_amt = ettot_trl1_amt
      tta6soivrp0101_so_trl2_cd = so_trl2_cd 
      tta6soivrp0101_invtot_trl2_amt = invtot_trl2_amt
      tta6soivrp0101_ettot_trl2_amt = ettot_trl2_amt
      tta6soivrp0101_so_trl3_cd = so_trl3_cd 
      tta6soivrp0101_invtot_trl3_amt = invtot_trl3_amt
      tta6soivrp0101_ettot_trl3_amt = ettot_trl3_amt
      tta6soivrp0101_invtot_tax_amt = invtot_tax_amt
      tta6soivrp0101_ettot_tax_amt = ettot_tax_amt
      tta6soivrp0101_so_curr = so_curr
      tta6soivrp0101_invcrdt = invcrdt
      tta6soivrp0101_invtot_ord_amt = invtot_ord_amt
      tta6soivrp0101_ettot_ord_amt = ettot_ord_amt
      tta6soivrp0101_tax_date = tax_date
      .
   if invtot_line_total <> 0 and l_consolidate THEN DO:
      ASSIGN
         tta6soivrp0101_so_disc_pct = (round(invtot_disc_amt / invtot_line_total * -100, 2))
         .
   END.
   ELSE DO:
      ASSIGN
         tta6soivrp0101_so_disc_pct = (so_disc_pct)
         .
   END.
   /* SS - 20060602.1 - E */
end. /* DO ON ENDKEY UNDO, LEAVE */
