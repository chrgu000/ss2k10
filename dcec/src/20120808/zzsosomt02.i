/* GUI CONVERTED from sosomt02.i (converter v1.69) Wed Nov 20 15:51:00 1996 */
/* sosomt02.i - SALES ORDER MAINTENANCE - SHARED FRAME B                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 05/25/93   BY: afs *GB31**/
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78**/
/* REVISION: 7.5      LAST MODIFIED: 02/17/95   BY: dpm *J044**/
/* REVISION: 7.5      LAST MODIFIED: 03/10/95   BY: DAH *J042**/
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak */
/* REVISION: 8.5      LAST MODIFIED: 11/19/96   BY: *J190* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*GM78*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
	    so_nbr label "订单"
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



/*H086*/ /* Rearranging frame b and creating frame b1. */

	 FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_ord_date     colon 15
/*J042**    so_pr_list2     colon 38*/
/*J042*/    line_pricing    colon 38
	    confirm         colon 58 so_conf_date no-label

	    so_req_date     colon 15
	    so_pr_list      colon 38
	    so_curr         colon 58 so_lang

	    promise_date    colon 15
	    so_site         colon 38
/*GM78*/ /*V8+*/
/*GM78*/      
	    so_taxable      colon 58
	    view-as fill-in size 3.5 by 1
	    so_taxc no-label so_tax_date to 79 no-label   

	    so_due_date     colon 15
	    so_channel      colon 38
	    so_fix_pr       colon 68

/*J042*/    so_pricing_dt   colon 15
	    so_project      colon 38
	    so_cr_terms     colon 68

	    so_po           colon 15
/*H184*/    socrt_int       colon 68

	    so_rmks         colon 15
/*J042*/    reprice         colon 68	
/*LB01*/    so_userid	colon 15 label "创建者"
	  SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/*G2D5** FORM STATEMENT MOVED BELOW
* /*H086*/ form
* 	    so_slspsn[1]    colon 15
* 	    so_fr_list      colon 40 so_weight_um no-label
* 	    consume         colon 73
*
* 	    mult_slspsn     colon 15 label "Multiple"
* 	    so_fr_min_wt    colon 40
* 	    so-detail-all   colon 73
*
* 	    so_comm_pct[1]  colon 15
* 	    so_fr_terms     colon 40
* 	    socmmts         colon 73
*
* 	    calc_fr         colon 40
* /*J044*/    impexp          colon 73 label "Imp/Exp"
* 	    disp_fr         colon 40
*
* 	 with frame b1 overlay side-labels column 1 row 12 width 80 attr-space.
*G2D5**/

/*G2D5** FORM DEFINITION MOVED FROM UP. THE FORM LAYOUT HAS BEEN CHANGED TO         */
/*G2D5** INCLUDE  THE FIELD all_days                                                */
/*G2D5*/ FORM /*GUI*/ 
/*G2D5*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_slspsn[1]    colon 15
/*G2D5*/    so_fr_list      colon 38 so_weight_um no-label
/*G2D5*/
/*G2D5*/    mult_slspsn     colon 15 label "多到期日"
/*G2D5*/    so_fr_min_wt    colon 38
/*G2D5*/    consume         colon 69
/*G2D5*/
/*G2D5*/    so_comm_pct[1]  colon 15
/*G2D5*/    so_fr_terms     colon 38
/*G2D5*/    so-detail-all   colon 69
/*G2D5*/
/*G2D5*/    calc_fr         colon 38
/*J190* /*G2D5*/    all_days        colon 69 label "Alloc SO Due in Days"   */
/*J190*/    all_days        colon 69 label "备料天数"
/*G2D5*/    disp_fr         colon 38
/*G2D5*/    socmmts         colon 69
/*G2D5*/    impexp          colon 69 label "输入/输出"
/*G2D5*/
/*G2D5*/   SKIP(.4)  /*GUI*/
with frame b1 overlay side-labels column 1 row 12 width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b1-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 = F-b1-title.
 RECT-FRAME-LABEL:HIDDEN in frame b1 = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b1 =
  FRAME b1:HEIGHT-PIXELS - RECT-FRAME:Y in frame b1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b1 = FRAME b1:WIDTH-CHARS - .5.  /*GUI*/

