/* GUI CONVERTED from sosomt01.i (converter v1.71) Tue Oct  6 14:50:10 1998 */
/* sosomt01.i - SO MAINTENANCE FRAME D SECOND TRAILER FRAME             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: afs *G692**/
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: WUG *GB74**/
/* REVISION: 7.3      LAST MODIFIED: 03/16/95   BY: WUG *G0CW**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomt01_i_1 "打印发票历史记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt01_i_2 "EDI 发票记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosomt01_i_3 "EDI 确认书"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

def var print_ih like mfc_logical label {&sosomt01_i_1}.
def var edi_ih like mfc_logical label {&sosomt01_i_2}.
def var edi_ack like mfc_logical label {&sosomt01_i_3}.            /*G0CW*/

     FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_cr_init     colon 15 LABEL "信贷批准人"
      so_print_so    colon 39 LABEL "打印客户订单"
      so_ar_acct     colon 56 LABEL "应收款账户"
      so_ar_cc NO-LABEL

      so_cr_card     colon 15 LABEL "信用卡"
      so_print_pl    colon 39 LABEL "打印装箱单"
      so_prepaid     colon 56 LABEL "预付金"

      so_stat        colon 15 LABEL "执行壮态"
      print_ih   colon 39
      so_fob         colon 56 LABEL "FOB易主处"

      so_rev         colon 15 LABEL "版本"
      edi_ih         colon 39
      so_shipvia     colon 56 LABEL "运输代理"
      edi_ack    colon 15                   /*G0CW*/
      so_partial     colon 39 LABEL "分批发货"
      so_bol         colon 56 LABEL "提单"


      SKIP(.4)  /*GUI*/
with frame d side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/

