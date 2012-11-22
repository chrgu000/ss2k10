/* apvofmfm.i - AP VOUCHER Receiver matching maintenance                      */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.4            CREATED: 10/29/93   BY: pcd *H199*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/*                    LAST MODIFIED: 12/29/95   by: mys *G1HN*                */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.2.6       BY: Hareesh V.          DATE: 02/10/02 ECO: *P04C* */
/* Revision: 1.6.2.7       BY: Ellen Borden        DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.6.2.9       BY: Patrick Rowan       DATE: 05/15/02 ECO: *P06L* */
/* Revision: 1.6.2.10      BY: Patrick Rowan       DATE: 11/15/02 ECO: *P0K4* */
/* Revision: 1.6.2.11      BY: Jyoti Thatte        DATE: 12/03/02 ECO: *P0L6* */
/* Revision: 1.6.2.13      BY: Tiziana Giustozzi   DATE: 02/20/03 ECO: *P0MX* */
/* Revision: 1.6.2.14      BY: Shivanand H         DATE: 07/13/04 ECO: *P29R* */
/* Revision: 1.6.2.14.1.1  BY: Sarita Gonsalves    DATE: 03/24/08  ECO: *P6NC* */
/* $Revision: 1.6.2.14.1.2 $   BY: Pratik Dave     DATE: 10/07/08  ECO: *Q1VZ* */
/*-Revision end--------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                 */

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITIONS ********* */

&SCOPED-DEFINE apvofmfm_i_1 "Pack Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_2 "Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_4 "Open Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_6 "PO Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_7 "Inv Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_8 "Inv Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_9 "Item"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_10 "Supplier Item"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_11 "Voucher"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_12 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_13 "Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvofmfm_i_14 "Rct Qty"
/* MaxLen: Comment: */

/* ********** END TRANSLATABLE STRINGS DEFINITIONS ********* */
form
   ap_ref         colon 10 label {&apvofmfm_i_11} format "x(8)"
   ap_curr                 no-label
   aptotal        colon 34
   ap_amt         colon 60 label {&apvofmfm_i_12}
with frame d side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   tt_pvo_receiver    format "x(8)" column-label "Receiver"
   tt_pvo_line                      column-label "Line"
   vph_nbr
   pvo_part
   vp-part                                 label {&apvofmfm_i_10}
   vph_inv_qty
     format "->,>>>,>>>,>>9.99<<<<<<<"
with frame match_detail
   title color normal (getFrameTitle("RECEIVER_MATCHING_DETAIL",34))
   4 down width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame match_detail:handle).

form
   receiver       colon  9  attr-space
      format "x(8)"
   rcvr_line      colon 30                          attr-space
   pvo_taxable               label "Tax"
   pvo_trans_date              label {&apvofmfm_i_2}
   pvo_project
   pvo_part       colon  9   label {&apvofmfm_i_9}
   prh_um                    no-label
   pod_vpart                 no-label               format "x(21)"
   prh_type                  label {&apvofmfm_i_13}
   close_pvo                                        attr-space
   rcvd_open      colon  9   label {&apvofmfm_i_4}
      format "->,>>>,>>>,>>9.99<<<<<<<"
   prh_pur_cost   colon 35   label {&apvofmfm_i_6}
      format "->,>>>,>>>,>>9.99<<<<<<<<"
   ext_open       colon 63
   vph_inv_qty    colon  8   label {&apvofmfm_i_8}  attr-space
      format "->,>>>,>>>,>>9.99<<<<<<<"
   vph_curr_amt   colon 36   label {&apvofmfm_i_7}  attr-space
      format "->,>>>,>>>,>>9.99<<<<<<<<"
   invcst         colon 63
   prh_ps_qty     colon  9   label {&apvofmfm_i_1}
   stdcst         colon 34
   ext_rate_var   colon 63
   pvo_trans_qty  colon  8   label {&apvofmfm_i_14}
      format "->,>>>,>>>,>>9.99<<<<<<<"
   varstd         colon 34
   ext_usage_var  colon 63
with frame f
   side-labels title color normal
   (getFrameTitle("RECEIVER_MATCHING_MAINTENANCE",41))
   width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f:handle).

form
   receiver       colon  9  attr-space
      format "x(8)"
   rcvr_line      colon 30                          attr-space
   pvo_taxable               label "Tax"
   pvo_trans_date              label {&apvofmfm_i_2}
   pvo_part       colon  9   label {&apvofmfm_i_9}
   prh_um                    no-label
   pod_vpart                 no-label               format "x(21)"
   prh_type                  label {&apvofmfm_i_13}
   close_pvo                                        attr-space
   rcvd_open      colon  9   label {&apvofmfm_i_4}
      format "->,>>>,>>>,>>9.99<<<<<<<"
   prh_pur_cost   colon 35   label {&apvofmfm_i_6}
      format "->,>>>,>>>,>>9.99<<<<<<<<"
   ext_open       colon 63
   vph_inv_qty    colon  8   label {&apvofmfm_i_8}  attr-space
      format "->,>>>,>>>,>>9.99<<<<<<<"
   vph_curr_amt   colon 36   label {&apvofmfm_i_7}  attr-space
      format "->,>>>,>>>,>>9.99<<<<<<<<"
   invcst         colon 63
   prh_ps_qty     colon  9   label {&apvofmfm_i_1}
   ext_rate_var   colon 63
   vph_acct       colon 9                           attr-space
   vph_sub                   no-label               attr-space
   vph_cc                    no-label               attr-space
   vph_project               no-label               attr-space
   pvo_trans_qty  colon  8   label {&apvofmfm_i_14}
      format "->,>>>,>>>,>>9.99<<<<<<<<<"
   ext_usage_var  colon 63
with frame m
   side-labels title color normal
   (getFrameTitle("RECEIVER_MATCHING_MAINTENANCE",41))
   width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame m:handle).
