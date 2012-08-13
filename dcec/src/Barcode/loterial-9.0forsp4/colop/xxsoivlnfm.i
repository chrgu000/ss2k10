/* xxsoivlnfm.i - DEFINE SHARED FRAMES C AND D FOR PENDING INVOICE LINES  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.5 $                                          */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 4.0      LAST MODIFIED: 10/12/89   BY: MLB *B338**/
/* REVISION: 6.0      LAST MODIFIED: 04/02/90   BY: ftb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: dld *F297**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: afs *F356**/
/* REVISION: 7.0      LAST MODIFIED: 06/09/92   BY: tjs *F504**/
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244**/
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: afs *G501**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/94   BY: dpm *FR95**/
/* REVISION: 7.4      LAST MODIFIED: 10/24/94   BY: ljm *GN62**/
/* REVISION: 7.4      LAST MODIFIED: 11/07/94   BY: ljm *GO33**/
/* REVISION: 8.5      LAST MODIFIED: 04/11/95   BY: DAH *J042**/
/* REVISION: 8.5      LAST MODIFIED: 05/31/96   BY: DAH *J0N2**/
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: svs *K007**/
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: jpm *K03Y**/
/* REVISION: 8.6      LAST MODIFIED: 03/14/97   BY: axv *K07R**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.10.1.4     BY: Russ Witt    DATE: 09/21/01 ECO: *P01H*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* $Revision: 1.10.1.5 $   BY: Steve Nugent  DATE: 10/15/01  ECO: *P004* */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivlnfm_i_1 "Invoice Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_2 "Discount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_3 "Pricing"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_4 "Manual"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_5 "Net Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_6 "Multiple"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_7 "Qty Backorder"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_9 "Comm%[1]"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_10 "Reprice"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_11 "Required"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_12 "Salesperson[1]"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_13 "UM Conv"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_14 "Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_15 "Desc"
/* MaxLen:4 Comment: Description*/

&SCOPED-DEFINE soivlnfm_i_16 "Loc"
/* MaxLen:4 Comment:Location */

/* ********** End Translatable Strings Definitions ********* */

FORM /*GUI*/ 
   line
   sod_part
   sod_qty_chg    label {&soivlnfm_i_1} format "->>>>,>>9.9<<<<"
   sod_um
   sod_list_pr                        format ">>>,>>>,>>9.99<<<"

   discount    label {&soivlnfm_i_2}          format "->>>9.9<<<"

   sod_price      label {&soivlnfm_i_5}
   sod__dec02    LABEL "Cu.Rate Applied "    FORMAT "->>>,>>9.99<<<<<"
with frame c clines down width 80 no-attr-space THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
desc1           colon  5    label {&soivlnfm_i_15} format "x(20)"
   sod_acct        colon 42                                  space(.1)   
   sod_sub                     no-label
   sod_cc                      no-label
   sod_project                 no-label

   sod_loc         colon  5    label {&soivlnfm_i_16}
   sod_site        colon 21
   sod_dsc_acct    colon 42                                space(.1)   
   sod_dsc_sub                no-label
   sod_dsc_cc                 no-label
   sod_dsc_project            no-label

   sod_serial      colon 15

   sod_bo_chg      colon 15   label {&soivlnfm_i_7}
   sod_confirm     colon 42
   sod_crt_int     colon 66

   sod_qty_all     colon 15
   sod_req_date    colon 42   label {&soivlnfm_i_11}
   sod_type        colon 66   label {&soivlnfm_i_14}

   sod_qty_pick    colon 15
   sod_due_date    colon 42
   sod_um_conv     colon 66   label {&soivlnfm_i_13}

   sod_qty_inv     colon 15
   sod_per_date    colon 42   label "Performance"
   sod_order_category colon 66
   base_curr       at 7       no-label no-attr-space
   sod_std_cost    colon 15
   sod_pricing_dt  colon 42   label {&soivlnfm_i_3}
   sod_fr_list     colon 66

   sod_slspsn[1]   colon 15   label {&soivlnfm_i_12}
   mult_slspsn                label {&soivlnfm_i_6}
   sod_taxable     colon 66
   sod_taxc                   no-label

   sod_comm_pct[1] colon 15   label {&soivlnfm_i_9}
   sod_fix_pr      colon 42
   sodcmmts        colon 66

 SKIP(.4)  /*GUI*/
with frame d side-labels

   /*V8+*/
   width 80 overlay
   /*V8+*/  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_pricing_dt colon 20
   sod_crt_int    colon 20
   reprice_dtl    colon 20 label {&soivlnfm_i_10}

   sod_bo_chg     colon 20 label {&soivlnfm_i_7} space(3)
   sod_pr_list    colon 20 label {&soivlnfm_i_4}
 SKIP(.4)  /*GUI*/
with frame line_pop overlay side-labels row 12 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-line_pop-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame line_pop = F-line_pop-title.
 RECT-FRAME-LABEL:HIDDEN in frame line_pop = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame line_pop =
  FRAME line_pop:HEIGHT-PIXELS - RECT-FRAME:Y in frame line_pop - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME line_pop = FRAME line_pop:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame line_pop:handle).
