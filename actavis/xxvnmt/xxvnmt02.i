/* advnmt02.i - SUPPLIER MAINTENANCE FORMS a, b, and b1                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.2.11 $                                                     */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4      LAST MODIFIED: 08/17/93   BY: cdt  *H086**/
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs  *K007**/
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004*  Kurt De Wit       */
/* REVISION: 8.6      LAST MODIFIED: 02/27/97   BY: *K06F*  Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *K0DH*  Arul Victoria     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/14/00   BY: *N0VR* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.2.8   BY: Steve Nugent      DATE: 05/10/01  ECO: *M11Z*   */
/* Revision: 1.10.2.9   BY: Anil Sudhakaran   DATE: 11/30/01  ECO: *M1F2*   */
/* Revision: 1.10.2.10     BY: Ed van de Gevel DATE: 12/03/01 ECO: *N16R* */
/* $Revision: 1.10.2.11 $    BY: Narathip W.     DATE: 04/17/03 ECO: *P0Q4* */
/*111205.1 - add address columns to 66 character length.                      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{cxcustom.i "ADVNMT02.I"}

/* ********** Begin Translatable Strings Definitions ********* */

{&ADVNMT02-I-TAG1}
{&ADVNMT02-I-TAG2}

&SCOPED-DEFINE advnmt02_i_6 "Misc Creditor"
/* MaxLen: Comment: */

&SCOPED-DEFINE advnmt02_i_7 "Automatic PO Receipt"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{&ADVNMT02-I-TAG7}
form
   skip
   vd_addr        colon 10
   ad_temp
   batchdelete no-label colon 60
   ad_name        colon 10 format "x(86)"
   ad_line1       colon 10 format "x(86)"
   ad_line2       colon 10 format "x(86)"
   ad_line3       colon 10 format "x(86)"
   ad_city        colon 10
   ad_state
   ad_zip
   ad_format
   ad_country     colon 10
   ad_ctry                 no-label
   ad_county      colon 56
   ad_attn        colon 10
   ad_attn2       colon 43 label "[2]"
   ad_phone       colon 10
   ad_ext
   ad_phone2      colon 43 label "[2]"
   ad_ext2
   ad_fax         colon 10
   ad_fax2        colon 43 label "[2]"
   ad_date
with frame a title color normal (getFrameTitle("SUPPLIER_ADDRESS",24))
side-labels width 80 attr-space.
{&ADVNMT02-I-TAG8}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   vd_sort        colon 20
   vd_type        colon 20
   vd_pur_acct    colon 20
   vd_pur_sub              no-label
   vd_pur_cc               no-label
   vd_ap_acct     colon 20
   vd_ap_sub               no-label
   vd_ap_cc                no-label
   vd_shipvia     colon 20
   vd_rmks        colon 20
with frame b title color normal (getFrameTitle("SUPPLIER_DATA",20))
side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

{&ADVNMT02-I-TAG3}

form
   vd_bank        colon 22
   vd_ckfrm       colon 66
   vd_curr        colon 22
   vd_lang        colon 66
   vd_pur_cntct   colon 22
   vd_misc_cr     colon 66 label {&advnmt02_i_6}
   vd_ap_cntct    colon 22
   vd_promo       colon 22
with frame b1a title color normal (getFrameTitle("SUPPLIER_DATA",20))
side-labels width 80 attr-space.

{&ADVNMT02-I-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1a:handle).

{&ADVNMT02-I-TAG5}

form
   vd_buyer       colon 17
   vd_pr_list2    colon 17
   vd_pr_list     colon 17
   vd_fix_pr      colon 17
with frame b1 title color normal (getFrameTitle("SUPPLIER_PRICING_DATA",30))
side-labels width 80 attr-space.

{&ADVNMT02-I-TAG6}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).

form
   vd_rcv_so_price colon 23
   vd_tp_pct       colon 64
   vd_rcv_held_so  colon 23
   vd_tp_use_pct   colon 64
   emt-auto        colon 23
   vd__qadl01      colon 23  label {&advnmt02_i_7}
with frame btb
title color normal (getFrameTitle("ENTERPRISE_MATERIAL_TRANSFER_DATA",46))
side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame btb:handle).

form
   vd_cr_terms    colon 13
   vd_taxable     colon 32
   vd_tax_id      colon 44 format "x(18)"
   tid_notice     colon 75
   vd_disc_pct    colon 13
   vd_prepay      colon 52
   ad_coc_reg     colon 13
   vd_debtor      colon 52
   vd_partial     colon 13
   vd_1099        colon 52
   vd_hold        colon 13
   vd_pay_spec    colon 52
   db_nbr         colon 13
with frame c title color normal (getFrameTitle("SUPPLIER_TERMS_DATA",28))
side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
