/* GUI CONVERTED from solinfrm.i (converter v1.69) Mon Jun 10 17:31:11 1996 */
/* solinfrm.i - DEFINES FORMS FOR SALES ORDER LINE ENTRY                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 04/02/90   BY: ftb *Dftb**/
/* REVISION: 6.0      LAST MODIFIED: 04/11/90   BY: MLB *D021**/
/* REVISION: 6.0      LAST MODIFIED: 12/19/90   BY: afs *D266**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 03/23/92   BY: dld *F297**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356**/
/* REVISION: 7.0      LAST MODIFIED: 06/01/92   BY: tjs *F504**/
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 10/28/92   BY: afs *G244**/
/* REVISION: 7.3      LAST MODIFIED: 01/04/93   BY: afs *G501**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184**/
/* REVISION: 7.4      LAST MODIFIED: 09/21/94   BY: ljm *GM77**/
/* REVISION: 7.4      LAST MODIFIED: 10/16/94   BY: dpm *FR95**/
/* REVISION: 7.4      LAST MODIFIED: 04/03/95   BY: jpm *G0FB**/
/* REVISION: 7.4      LAST MODIFIED: 04/23/95   BY: jpm *H0D9**/
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 09/11/95   BY: jym *G0WJ**/
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

         FORM /*GUI*/ 
            line
            sod_part
            sod_qty_ord                    format "->>>>,>>9.9<<<<"
            sod_um
            sod_list_pr                    format ">>>,>>>,>>9.99<<<"
/*J042** USE GENERIC DISPLAY FORMAT FOR EITHER DISCOUNT % OR FACTOR
	 DEPENDING ON pic_so_fact
** /*G244*/ sod_disc_pct label "Disc%"     format "->>>>9.99"
**J042*/
/*J042*/    discount     label "折扣" format "->>>9.9<<<"
            sod_price    label "净价"
         no-attr-space
/*J04C*  with frame c clines down width 80 .    */
/*J04C*/ with frame c clines down width 80
/*J04C*/ title color normal frametitle THREE-D /*GUI*/.


   /*F040* - Rearranged form to put description and site at the top */
   /*F297* - Added hook to multiple salesperson screen              */
   /*F356* - Added project, confirm; moved FAS WO info to config subscreen */
   /*G501* - Reversed site, location                                */
   FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
desc1           colon 15
      sod_acct        colon 62
/*GM77*/      view-as fill-in size 9 by 1 space(.5)   
      sod_cc             no-label
/*GM77*/      view-as fill-in size 5 by 1   

      sod_loc         colon 15
      sod_site        colon 31
      sod_dsc_acct    colon 62
/*GM77*/      view-as fill-in size 9 by 1 space(.5)   
      sod_dsc_cc         no-label
/*GM77*/      view-as fill-in size 5 by 1   

      sod_serial      colon 15
/*F504*/ sod_confirm     colon 47
      sod_project     colon 62

/*G0WJ*      sod_qty_all     colon 15 format "->,>>>,>>9.9999" */
/*G0WJ*/     sod_qty_all     colon 15
/*J042*/ sod_pricing_dt colon 42 label "定价"
/*F504*  sod_req_date    colon 43 label "Required" */
/*F504*  sod_confirm     colon 66 */
/*J042**
** /*H184*/ sod_crt_int  colon 66
**J042*/
/*J042*/ sod_crt_int  colon 68 label "支付方式间隔"

/*G0WJ*      sod_qty_pick    colon 15 format "->,>>>,>>9.9999" */
/*G0WJ*/     sod_qty_pick    colon 15
/*F504*/ sod_req_date    colon 42 label "需求"
/*F504*  sod_per_date    colon 43 label "Promised" */
      sod_type        colon 66 label "类型"

/*G0WJ*      sod_qty_ship    colon 15 format "->,>>>,>>9.9999" no-attr-space */
/*G0WJ*/     sod_qty_ship    colon 15 no-attr-space
/*F504*/ sod_per_date    colon 42 label "承诺日期"
/*F504*  sod_due_date    colon 43 */
      sod_um_conv     colon 66 label "换算因子"

/*G0WJ*      sod_qty_inv     colon 15 format "->,>>>,>>9.9999" no-attr-space */
/*G0WJ*/     sod_qty_inv     colon 15 no-attr-space
/*F504*/ sod_due_date    colon 42
      sod_consume     colon 66 label "消耗预测量"

/*      base_curr       at 7 no-label no-attr-space */
/*LB01*/      /*sod_std_cost    colon 15*/
/*G035*/ sod_fr_list  colon 42 label "运价表"
      sod-detail-all  colon 66 label "明细备料"

      sod_slspsn[1]   colon 15 label "推销员[1]"
      mult_slspsn              label "多到期日"
      sod_taxable     colon 66
      sod_taxc           no-label

      sod_comm_pct[1] colon 15 label "佣金%[1]"
/*H184*/ sod_fix_pr   colon 42
      sodcmmts        colon 66
/*G0FB*/  SKIP(.4)  /*GUI*/
with frame d side-labels /*V8+*/ width 80
/*G0FB*/ attr-space overlay
/*GM77*/ /*V8+*/  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


/*J042**
** /*H086*/ form
** /*H086*/    sod_due_date  colon 20
** /*H0D9*/   /*V8! space(2) */
** /*H184*/    sod_crt_int   colon 20
** /*H0D9*/   /*V8! space(2) */
** /*H086*/ with frame line_pop overlay side-labels row 12 column 25.
**J042*/
/*J042*/ FORM /*GUI*/ 
/*J042*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_pricing_dt colon 20
/*J042*/         space(2)   
/*J042*/    sod_crt_int    colon 20
/*J042*/         space(2)   
/*J042*/    reprice_dtl    colon 20 label "重新定价"
/*J042*/         space(2)   
/*J0N2*/    sod_pr_list    colon 20 label "手工"
/*J0N2*/         space(2)   
/*J042*/  SKIP(.4)  /*GUI*/
with frame line_pop overlay side-labels row 12 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-line_pop-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame line_pop = F-line_pop-title.
 RECT-FRAME-LABEL:HIDDEN in frame line_pop = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame line_pop =
  FRAME line_pop:HEIGHT-PIXELS - RECT-FRAME:Y in frame line_pop - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME line_pop = FRAME line_pop:WIDTH-CHARS - .5.  /*GUI*/

