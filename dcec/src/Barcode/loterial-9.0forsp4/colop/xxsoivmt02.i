/* xxsoivmt02.i - PENDING INVOICE MAINTENANCE - SHARED FRAMES A & B       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11.1.3 $                                                 */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3      LAST MODIFIED: 05/28/93   BY: kgs *GB31*          */
/* REVISION: 7.4      LAST MODIFIED: 09/27/93   BY: cdt *H086*          */
/* REVISION: 7.4      LAST MODIFIED: 10/02/93   BY: cdt *H184*          */
/*                                   09/10/94   BY: bcm *GM05*          */
/*                                   09/21/94   BY: ljm *GM77*          */
/* REVISION: 7.5      LAST MODIFIED: 02/20/95   BY: dpm *J044*          */
/* REVISION: 7.5      LAST MODIFIED: 04/07/95   BY: DAH *J042*          */
/* REVISION: 8.6      LAST MODIFIED: 06/03/97   BY: *K0DQ* Taek-Soo Chang */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Old ECO marker removed, but no ECO header exists *G035*               */
/* $Revision: 1.11.1.3 $    BY: Jeff Wootton    DATE: 09/21/01 ECO: *P01H*          */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivmt02_i_1 "Entered By"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_2 "Multiple"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_3 "Cr Terms"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_4 "Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_5 "Last Ship"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_6 "Imp/Exp"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   so_nbr label {&soivmt02_i_4}
   so_cust
   so_bill
   so_ship
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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

/* Rearranging frame b and creating frame b1. */

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   so_ord_date    colon 15

   line_pricing   colon 38
   so_ship_date   colon 58 label {&soivmt02_i_5}

   so_req_date    colon 15
   so_pr_list     colon 36
   so_curr        colon 58
   so_lang        colon 70

   so_due_date   colon 15
   so_site        colon 36
   so_taxable     colon 58
        view-as fill-in size 3.5 by 1 space(.5)   
   so_taxc no-label
        space(.5)   
   so_tax_date to
   /*V8+*/       78    no-label

   perform_date  colon 15
   so_channel     colon 36
   so_fix_pr      colon 58

   so_pricing_dt  colon 15
   so_project     colon 36
   so_cr_terms    colon 58 label {&soivmt02_i_3}

   so_po          colon 15
   socrt_int      colon 58

   so_rmks        colon 15
   reprice        colon 67
   so_userid      colon 15 label {&soivmt02_i_1}
   /**xx**/    so__chr01  COLON 58  LABEL "Fixed Copper Rate"
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 

   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   so_slspsn[1]    colon 16
   so_fr_list      colon 56 so_weight_um no-label

   mult_slspsn     colon 16 label {&soivmt02_i_2}
   so_fr_min_wt    colon 56

   so_comm_pct[1]  colon 16
   so_fr_terms     colon 56

   so_shipvia      colon 16
   calc_fr         colon 56
   impexp          colon 73 label {&soivmt02_i_6}
   so_bol          colon 16
   disp_fr         colon 56
   socmmts         colon 73

 SKIP(.4)  /*GUI*/
with frame b1 overlay side-labels row 12 width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 = F-b1-title.
 RECT-FRAME-LABEL:HIDDEN in frame b1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b1 =
  FRAME b1:HEIGHT-PIXELS - RECT-FRAME:Y in frame b1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b1 = FRAME b1:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).


