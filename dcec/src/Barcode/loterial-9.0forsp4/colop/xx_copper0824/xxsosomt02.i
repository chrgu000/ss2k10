/* xxsosomt02.i - SALES ORDER MAINTENANCE - SHARED FRAME B                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.15 $                                            */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3      LAST MODIFIED: 05/25/93   BY: afs *GB31**/
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78**/
/* REVISION: 7.5      LAST MODIFIED: 02/17/95   BY: dpm *J044**/
/* REVISION: 7.5      LAST MODIFIED: 03/10/95   BY: DAH *J042**/
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 11/19/96   BY: *J190* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00 BY: *N0WB* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.14     BY: Russ Witt  DATE: 09/21/01  ECO: *P01H*      */
/* $Revision: 1.15 $    BY: Patrick Rowan  DATE: 03/14/02  ECO: *P00G*      */

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


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   so_nbr label {&sosomt02_i_2}
   so_cust so_bill so_ship
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&SOSOMT02-I-TAG1}
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   so_ord_date     colon 15

   line_pricing    colon 38
   confirm         colon 58 so_conf_date no-label

   so_req_date     colon 15
   so_pr_list      colon 32
   so_curr         colon 52 so_lang

   promise_date    colon 15
   so_site         colon 32
   /*V8+*/
        
   so_taxable      colon 52
   view-as fill-in size 3.5 by 1
   so_taxc no-label so_tax_date to 77 no-label   

   so_due_date     colon 15
   so_channel      colon 38
   so_fix_pr       colon 68

   perform_date   colon 15
   so_project      colon 38
   so_cr_terms     colon 68

   so_pricing_dt   colon 15
   /**xx**/    so__chr01  COLON 38  LABEL "Fixed Copper Rate"
    socrt_int       colon 68

   so_po           colon 15
   reprice         colon 68

   so_rmks         colon 15
   so_userid       colon 68 label {&sosomt02_i_3}

 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/

{&SOSOMT02-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
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

 SKIP(.4)  /*GUI*/
with frame b1 overlay side-labels column 1 row 12 width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 = F-b1-title.
 RECT-FRAME-LABEL:HIDDEN in frame b1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b1 =
  FRAME b1:HEIGHT-PIXELS - RECT-FRAME:Y in frame b1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b1 = FRAME b1:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).
