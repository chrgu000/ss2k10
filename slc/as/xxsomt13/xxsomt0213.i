/* xxsomt0213.i - SALES ORDER MAINTENANCE - SHARED FRAME B                    */
/* REVISION:101027.1 LAST MODIFIED: 10/27/10 BY: zy              *ar*         */
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1B   QAD:eb21sp5                                  */
 
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{cxcustom.i "SOSOMT02.I"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomt02_i_1 "Imp/Exp"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt02_i_2 "Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt02_i_3 "Entered By"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt02_i_4 "Multiple"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt02_i_5 "Allocate Days"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

form
   space(1)
   so_nbr label {&sosomt02_i_2}
   so_cust so_bill so_ship
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&SOSOMT02-I-TAG1}
form
   so_ord_date     colon 15

   line_pricing    colon 38
   confirm         colon 58 so_conf_date no-label

   so_req_date     colon 15
   so_pr_list      colon 38
   so_curr         colon 58 so_lang

   promise_date    colon 15
   so_site         colon 38
   /*V8-*/
   so_taxable      colon 58 so_taxc no-label so_tax_date to 77 no-label
   /*V8+*/
   /*V8!
   so_taxable      colon 58
   view-as fill-in size 3.5 by 1
   so_taxc no-label so_tax_date to 79 no-label */

   so_due_date     colon 15
   so_channel      colon 38
   so_fix_pr       colon 68

   perform_date   colon 15
   so_project      colon 38
   so_cr_terms     colon 68

   so_pricing_dt   colon 15
/*ar*/   so__dte01       colon 38
   socrt_int       colon 68

   so_po           colon 15
   reprice         colon 68

   so_rmks         colon 15
   so_userid       colon 68 label {&sosomt02_i_3}

with frame b side-labels width 80 attr-space.
{&SOSOMT02-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   so_slspsn[1]    colon 15
   so_fr_list      colon 38 so_weight_um no-label

   so_consignment  colon 69
   mult_slspsn     colon 15 label {&sosomt02_i_4}
   so_fr_min_wt    colon 38
   consume         colon 69

   so_comm_pct[1]  colon 15
   so_fr_terms     colon 38
   so-detail-all   colon 69

   calc_fr         colon 38

   all_days        colon 69 label {&sosomt02_i_5}
   disp_fr         colon 38
   socmmts         colon 69
   impexp          colon 69 label {&sosomt02_i_1}

with frame b1 overlay side-labels column 1 row 12 width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).
