/* apvofmb.i - DEFINE FORM FOR VOUCHER MAINTENANCE                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.2.13 $                                             */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 6.0      LAST MODIFIED: 09/06/90   BY: MLB D065*  */
/* REVISION: 6.0      LAST MODIFIED: 06/18/91   BY: MLB *D711* */
/* REVISION: 7.0      LAST MODIFIED: 08/12/91   BY: MLV *F002* */
/* REVISION: 7.0      LAST MODIFIED: 11/15/91   BY: MLV *F037* */
/* REVISION: 7.0      LAST MODIFIED: 11/15/91   BY: MLV *F082* */
/* REVISION: 7.0      LAST MODIFIED: 11/15/91   BY: MLV *F082* */
/* REVISION: 7.0      LAST MODIFIED: 02/05/92   BY: TMD *F169* */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: MLV *F238* */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: MLV *F256* */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: TMD *F303* */
/* REVISION: 7.0      LAST MODIFIED: 07/10/92   BY: MLV *F458* */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: bcm *G418* */
/*                                   01/12/93   by: jms *G537* */
/* REVISION: 7.4      LAST MODIFIED: 08/20/93   BY: pcd *H079* */
/* REVISION: 7.4         RE WRITTEN: 10/29/93   BY: pcd *H199* */
/* REVISION: 7.4      LAST MODIFIED: 08/23/94   BY: qzl *H486* */
/*                                   08/31/94   BY: bcm *H497* */
/*                                   02/09/95   by: srk *H0CG* */
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   BY: BJL *K001* */
/* REVISION: 8.6      LAST MODIFIED: 10/02/96   BY: svs *K007* */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0W0* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.2.7     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* REVISION: 9.2      LAST MODIFIED: 11/02/01 BY: *N15M* Ed van de Gevel  */
/* Revision: 1.9.2.9     BY: Samir Bavkar   DATE: 02/14/02 ECO: *P04G* */
/* Revision: 1.9.2.10     BY: Luke Pokic     DATE: 07/01/02 ECO: *P09Z* */
/* Revision: 1.9.2.12     BY: Orawan S.      DATE: 04/21/03 ECO: *P0Q8* */
/* $Revision: 1.9.2.13 $    BY: Orawan S.     DATE: 12/23/04 ECO: *P2ZF* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "APVOFMB.I"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvofmb_i_2 "Ck Form"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_3 "Exp Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_5 "Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_6 "ERS"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_7 "Auto Select"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_8 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_9 "Disc Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_10 "Prepay Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_11 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_13 "Supp Bk"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_14 "Terms"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_15 "Remit-To"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmb_i_16 "Separate Ck"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

form
   space(1)
   ap_ref               format "X(8)" deblank
with frame voucher no-labels
   /*V8-*/
   title color normal (getFrameTitle("VOUCHER",18))
   /*V8+*/
   /*V8! title color normal (getFrameTitle("VOUCHER",14)) */
   attr-space
   column 1.

/* Modified frame vohdr1 */
form
   aptotal        colon 10    label  {&apvofmb_i_8}
   ap_effdate     colon 40
   vo_is_ers      colon 57    label  {&apvofmb_i_6}
   ap_amt         colon 10    label  {&apvofmb_i_11}
   vo_tax_date    colon 40
   ap_vend        colon 10
   vd_sort                 no-label  format "x(20)"
   ad_line1       at    42 no-label  format "x(20)"

   /*V8-*/
   vatreglbl      to 10    no-label
   /*V8+*/
   /*V8! vatreglbl  to 12    no-label */
   vatreg                  no-label
   ad_city        at    42 no-label  format "x(18)"
   ad_state       at    61 no-label
   ad_addr        colon 10  label  {&apvofmb_i_15}
   ad_name        no-label  format "x(20)"
   vo_ship        colon 10
   ship-name      no-label
with frame vohdr1
   column 14 side-labels width 67 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame vohdr1:handle).

{&APVOFMB-I-TAG1}
{&APVOFMB-I-TAG4}

form
   vo_curr        colon 10
   ap_bank
   desc1                        no-label
   vo_invoice     colon 10      deblank
   ap_acct        colon 42         label {&apvofmb_i_5}
   ap_sub                       no-label
   ap_cc                        no-label
   ap_date        colon 10
   ap_disc_acct   colon 42         label {&apvofmb_i_9}
   ap_disc_sub                  no-label
   ap_disc_cc                   no-label
   vo_cr_terms    colon 10         label {&apvofmb_i_14}
   ap_entity      colon 42
   vo_disc_date   colon 10
   ap_rmk         colon 42
   vo_due_date    colon 10
   vo__qad02      colon 42         label {&apvofmb_i_13}
   format "x(8)"
   vo_separate    colon 66         label {&apvofmb_i_16}
   ap_expt_date   colon 10         label {&apvofmb_i_3}
   vo_type        colon 42
   ap_ckfrm       colon 66         label {&apvofmb_i_2} format "x(1)"
with frame vohdr2 side-labels width 80 no-attr-space.
{&APVOFMB-I-TAG5}
{&APVOFMB-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame vohdr2:handle).

{&APVOFMB-I-TAG3}
form
   vo_prepay               colon 20  label {&apvofmb_i_10}
   vo_hold_amt             colon 20
   vchr_logistics_chrgs    colon 70
   vo_ndisc_amt            colon 20
   incl_blank_suppliers    colon 70  label "Include Blank Suppliers"
   ap_dy_code              colon 20
   auto-select             colon 70  label {&apvofmb_i_7}
with frame vohdr2a
   side-labels width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame vohdr2a:handle).

{&APVOFMB-I-TAG6}
form
   skip
   ad_name        colon 13
   ad_line1       colon 13
   ad_line2       colon 13
   ad_line3       colon 13
   ad_city        colon 13
   ad_state       colon 45
   ad_zip
   ad_format
   ad_country     colon 13
   ad_county      colon 56
with frame vohdr3 side-labels title color normal
   (getFrameTitle("REMIT-TO",13))
   width 80.
{&APVOFMB-I-TAG7}

/* SET EXTERNAL LABELS */
setFrameLabels(frame vohdr3:handle).

{apvofmo.i}
