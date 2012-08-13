/* GUI CONVERTED from solinfrm.i (converter v1.75) Tue Nov 28 21:10:50 2000 */
/* solinfrm.i - DEFINES FORMS FOR SALES ORDER LINE ENTRY                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
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
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: svs *K007**/
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: jpm *K03Y**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 11/24/00   BY: *M0WH* Falguni D.   */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE solinfrm_i_1 "消耗预测量"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_2 "运价表"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_3 "折扣"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_4 "佣金%[1]"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_5 "手工"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_6 "明细备料"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_7 "支付方式间隔"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_8 "定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_9 "多个"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_10 "净价"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_11 "承诺日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_12 "重新定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_13 "需求"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_14 "推销员[1]"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_15 "换算因子"
/* MaxLen: Comment: */

&SCOPED-DEFINE solinfrm_i_16 "类型"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         FORM /*GUI*/ 
            LINE LABEL "项"
            sod_part LABEL "零件代码"
/*M0WH*/             view-as fill-in size 18 by 1   
            sod_qty_ord    LABEL "订货数量"                format "->>>>,>>9.9<<<<"
            sod_um  LABEL "单位"
            sod_list_pr      LABEL  "价格表"             format ">>>,>>>,>>9.99<<<"
/*J042** USE GENERIC DISPLAY FORMAT FOR EITHER DISCOUNT % OR FACTOR
     DEPENDING ON pic_so_fact
** /*G244*/ sod_disc_pct label "Disc%"     format "->>>>9.99"
**J042*/
/*J042*/    discount     label {&solinfrm_i_3} format "->>>9.9<<<"
            sod_price    label {&solinfrm_i_10}
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
desc1           colon 15 LABEL "摘要
      sod_acct        colon 62 LABEL "销售账户"
/*GM77*/      view-as fill-in size 9 by 1 space(.5)   
      sod_cc             no-label
/*GM77*/      view-as fill-in size 5 by 1   

      sod_loc         colon 15 LABEL "库位"
      sod_site        colon 31 LABEL "地点"
/*K03Y*/ /* /*K007*/ sod_bonus    colon 47 label "Bonus" */
      sod_dsc_acct    colon 62 LABEL "折扣账户"
/*GM77*/      view-as fill-in size 9 by 1 space(.5)   
      sod_dsc_cc         no-label
/*GM77*/      view-as fill-in size 5 by 1   

      sod_serial      colon 15 LABEL "批/序号"
/*F504*/ sod_confirm     colon 47 LABEL "确认"
      sod_project     colon 62 LABEL "项目"

/*G0WJ*      sod_qty_all     colon 15 format "->,>>>,>>9.9999" */
/*G0WJ*/     sod_qty_all     colon 15 LABEL "备料量"
/*J042*/ sod_pricing_dt colon 42 label {&solinfrm_i_8}
/*F504*  sod_req_date    colon 43 label "Required" */
/*F504*  sod_confirm     colon 66 */
/*J042**
** /*H184*/ sod_crt_int  colon 66
**J042*/
/*J042*/ sod_crt_int  colon 68 label {&solinfrm_i_7}

/*G0WJ*      sod_qty_pick    colon 15 format "->,>>>,>>9.9999" */
/*G0WJ*/     sod_qty_pick    colon 15 LABEL "已令料量"
/*F504*/ sod_req_date    colon 42 label {&solinfrm_i_13}
/*F504*  sod_per_date    colon 43 label "Promised" */
      sod_type        colon 66 label {&solinfrm_i_16}

/*G0WJ*      sod_qty_ship    colon 15 format "->,>>>,>>9.9999" no-attr-space */
/*G0WJ*/     sod_qty_ship    colon 15 NO-ATTR-SPACE LABEL "已发货量"
/*F504*/ sod_per_date    colon 42 label {&solinfrm_i_11}
/*F504*  sod_due_date    colon 43 */
      sod_um_conv     colon 66 label {&solinfrm_i_15}

/*G0WJ*      sod_qty_inv     colon 15 format "->,>>>,>>9.9999" no-attr-space */
/*G0WJ*/     sod_qty_inv     colon 15 no-attr-space
/*F504*/ sod_due_date    colon 42 LABEL "到期日"
      sod_consume     colon 66 label {&solinfrm_i_1}

      base_curr       at 7 no-label no-attr-space
      sod_std_cost    colon 15 LABEL "成本"
/*G035*/ sod_fr_list  colon 42 label {&solinfrm_i_2}
      sod-detail-all  colon 66 label {&solinfrm_i_6}

      sod_slspsn[1]   colon 15 label {&solinfrm_i_14}
      mult_slspsn              label {&solinfrm_i_9}
      sod_taxable     colon 66 LABEL "纳税"
      sod_taxc           no-label

      sod_comm_pct[1] colon 15 label {&solinfrm_i_4}
/*H184*/ sod_fix_pr   colon 42 LABEL "固定价格"
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
sod_pricing_dt colon 20 LABEL "定价日期"
/*J042*/         space(2)   
/*J042*/    sod_crt_int    colon 20 LABEL "支付方式利息"
/*J042*/         space(2)   
/*J042*/    reprice_dtl    colon 20 label {&solinfrm_i_12}
/*J042*/         space(2)   
/*J0N2*/    sod_pr_list    colon 20 label {&solinfrm_i_5}
/*J0N2*/         space(2)   
/*J042*/  SKIP(.4)  /*GUI*/
with frame line_pop overlay side-labels row 12 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-line_pop-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame line_pop = F-line_pop-title.
 RECT-FRAME-LABEL:HIDDEN in frame line_pop = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame line_pop =
  FRAME line_pop:HEIGHT-PIXELS - RECT-FRAME:Y in frame line_pop - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME line_pop = FRAME line_pop:WIDTH-CHARS - .5.  /*GUI*/

