/* GUI CONVERTED from soivmt02.i (converter v1.71) Tue Oct  6 14:49:15 1998 */
/* soivmt02.i - PENDING INVOICE MAINTENANCE - SHARED FRAMES A & B       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
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

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivmt02_i_1 "录入人"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_2 "多个"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_3 "支付方式"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_4 "订单"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_5 "发货日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivmt02_i_6 "输入/输出"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*GM05*/    
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



/*H086*/ /* Rearranging frame b and creating frame b1. */

     FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_ord_date    colon 15 LABEL "订货日期"
/*J042***   so_pr_list2    colon 36*/
/*J25N*/ line_pricing   colon 38
        so_ship_date   colon 58 label {&soivmt02_i_5}

        so_req_date    colon 15 LABEL "需求日期"
        so_pr_list     colon 36
        so_curr        colon 58  LABEL "货币"
        so_lang        colon 74

        promise_date   colon 15
        so_site        colon 36 LABEL "地点"
        so_taxable     colon 58 LABEL "纳税"
/*GM77*/      view-as fill-in size 3.5 by 1 space(.5)   
        so_taxc no-label
/*GM77*/      space(.5)   
        so_tax_date to
/*GM77*/ /*V8+*/       78    no-label

        so_due_date    colon 15 LABEL "到期日"
        so_channel     colon 36 LABEL "渠道"
        so_fix_pr      colon 58 LABEL "固定价格"

/*J042*/    so_pricing_dt  colon 15 LABEL "定价日"
        so_project     colon 36 LABEL "项目"
        so_cr_terms    colon 58 label {&soivmt02_i_3}

        so_po          colon 15 LABEL "采购单号"
/*H184*/    socrt_int      colon 58 LABEL "支付方式利息"

        so_rmks        colon 15 LABEL "备注"
/*J042*/    reprice        colon 67
/*K0DQ*/    so_userid      colon 15 label {&soivmt02_i_1}

      SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/



/*H086*/ FORM /*GUI*/ 

        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_slspsn[1]    colon 16 LABEL "推销员1"
        so_fr_list      colon 56  LABEL "运价表"   so_weight_um no-label

        mult_slspsn     colon 16 label {&soivmt02_i_2}
        so_fr_min_wt    colon 56 LABEL "运货最轻重量"

        so_comm_pct[1]  colon 16 LABEL "佣金1"
        so_fr_terms     colon 56 LABEL "运输条件"

        so_shipvia      colon 16 LABEL "运输代理"
        calc_fr         colon 56
/*J044*/    impexp          colon 73 label {&soivmt02_i_6}
        so_bol          colon 16 LABEL "提单"
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





     /*
/*G035*/ form
/*G035*/    so_fr_min_wt     colon 16
/*G035*/    fr_um            no-label
/*G035*/    so_fr_terms      colon 16
/*G035*/    calc_fr          colon 16
/*G035*/ with frame d overlay side-labels centered row 16 width 36.
       */
