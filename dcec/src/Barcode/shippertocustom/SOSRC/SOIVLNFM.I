/* GUI CONVERTED from soivlnfm.i (converter v1.71) Tue Oct  6 14:49:14 1998 */
/* soivlnfm.i - DEFINE SHARED FRAMES C AND D FOR PENDING INVOICE LINES  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
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


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivlnfm_i_1 "发票数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_2 "折扣"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_3 "定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_4 "手工"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_5 "净价"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_6 "多个"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_7 "欠交量"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_8 "承诺日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_9 "佣金%[1]"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_10 "重新定价"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_11 "需求"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_12 "推销员[1]"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_13 "换算因子"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivlnfm_i_14 "类型"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

   FORM /*GUI*/ 
      LINE LABEL "项"
      sod_part LABEL "零件代码"
      sod_qty_chg    label {&soivlnfm_i_1} format "->>>>,>>9.9<<<<"
      sod_um LABEL "单位"
      sod_list_pr      LABEL  "价格表"                       format ">>>,>>>,>>9.99<<<"

/*J042** USE GENERIC DISPLAY FORMAT FOR EITHER DISCOUNT % OR FACTOR
**       DEPENDING ON pic_so_fact
**
** /*G244** sod_disc_pct label "Disc%"         format "->9.99" **/
** /*G244*/ sod_disc_pct label "Disc%"         format "->>>>9.99"
**J042*/
/*J042*/ discount    label {&soivlnfm_i_2}          format "->>>9.9<<<"

      sod_price      label {&soivlnfm_i_5}
   with frame c clines down width 80 no-attr-space THREE-D /*GUI*/.


   /*F040 - Rearranged form to put description and site at the top */
   /*F356 - Added project, confirm                                 */
   /*G501 - Reversed site, location                                */
   FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
desc1           colon 15  LABEL "摘要
/*GN62*/  sod_acct        colon 62  LABEL "销售账户"      space(.1)   
      sod_cc             no-label

      sod_loc         colon 15 LABEL "库位"
      sod_site        colon 31 LABEL "地点"
/*K03Y*/ /* /*K007*/ sod_bonus    colon 47 label "Bonus" */
/*GN62*/  sod_dsc_acct    colon 62  LABEL "折扣账户"      space(.1)   
      sod_dsc_cc         no-label

      sod_serial      colon 15 LABEL "批/序号"
/*F504*/ sod_confirm     colon 47 LABEL "确认"
      sod_project     colon 62 LABEL "项目"

      sod_bo_chg      colon 15 label {&soivlnfm_i_7}
/*F504* sod_req_date    colon 43 label "Required" */
/*F504* sod_confirm     colon 66 */
/*H184*/ sod_crt_int  colon 66 LABEL "支付方式利息"

      sod_qty_all     colon 15 LABEL "备料量"
/*F504*/ sod_req_date    colon 42 label {&soivlnfm_i_11}
/*F504*  sod_per_date    colon 43 label "Promised" */
      sod_type        colon 66 label {&soivlnfm_i_14}

      sod_qty_pick    colon 15 LABEL "已令料量"
/*F504*/ sod_per_date    colon 42 label {&soivlnfm_i_8}
/*F504*  sod_due_date    colon 43 */
      sod_um_conv     colon 66 label {&soivlnfm_i_13}

      sod_qty_inv     colon 15 LABEL "待开数量
/*F504*/ sod_due_date    colon 42 LABEL "到期日"
      base_curr       at 7 no-label no-attr-space
      sod_std_cost    colon 15 LABEL "成本"
/*J042*/ sod_pricing_dt  colon 42 label {&soivlnfm_i_3}
/*G035*/ sod_fr_list     colon 66 LABEL "价格表"

      sod_slspsn[1]   colon 15 label {&soivlnfm_i_12}
/*F297*/ mult_slspsn   label {&soivlnfm_i_6}
      sod_taxable     colon 66 LABEL "纳税"
      sod_taxc           no-label

      sod_comm_pct[1] colon 15 label {&soivlnfm_i_9}
/*H086*/ sod_fix_pr   colon 42 LABEL "固定价格"
      sodcmmts        colon 66

     SKIP(.4)  /*GUI*/
with frame d side-labels
/*GO33*/ /*V8+*/
    width 80 overlay
/*GO33*/ /*V8+*/  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/



/*J042**
** /*H086*/ form
** /*H086*/    sod_due_date  colon 20
** /*H184*/    sod_crt_int   colon 20
** /*H086*/ with frame line_pop overlay side-labels row 12 column 25.
**J042*/

/*J042*/ FORM /*GUI*/ 
/*J042*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
sod_pricing_dt colon 20 LABEL "定价日期"
/*J042*/    sod_crt_int    colon 20 LABEL "支付方式利息"
/*J042*/    reprice_dtl    colon 20 label {&soivlnfm_i_10}
/*K07R /*J042*/    sod_bo_chg     colon 20 label "Qty Backorder" */
/*K07R*/    sod_bo_chg     colon 20 label {&soivlnfm_i_7} space(3)
/*J0N2*/    sod_pr_list    colon 20 label {&soivlnfm_i_4}
/*J042*/  SKIP(.4)  /*GUI*/
with frame line_pop overlay side-labels row 12 column 25 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-line_pop-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame line_pop = F-line_pop-title.
 RECT-FRAME-LABEL:HIDDEN in frame line_pop = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame line_pop =
  FRAME line_pop:HEIGHT-PIXELS - RECT-FRAME:Y in frame line_pop - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME line_pop = FRAME line_pop:WIDTH-CHARS - .5.  /*GUI*/

