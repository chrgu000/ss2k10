/* xxcsmt02.i - CUSTOMER MAINTENANCE FORMS a, b,                        */
/* COPYRIGHT infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 1.0E     LAST MODIFIED: 09/21/2000   BY: *ifp006* Frankie Xu    */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE xxcsmt02_1 "推销员 1"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxcsmt02_2 "多个"
/* MaxLen: Comment: */

&SCOPED-DEFINE xxcsmt02_3 " 客户地址 "
/* MaxLen: Comment: */

&SCOPED-DEFINE xxcsmt02_4 " 客户数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE xxcsmt02_5 " 推销数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE xxcsmt02_6 "语言"
/* MaxLen: Comment: */

/*L01N*/
&SCOPED-DEFINE xxcsmt02_7 "双重定价货币"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

            cm_addr        colon 15
            ad_name        colon 15 format "x(50)"
            ad_line1       colon 15 format "x(25)"
            ad_line2       colon 15 format "x(25)"
            ad_line3       colon 15 format "x(4)" label "简称"

            ad_format      colon 15 label "国内/国外"  space(8) ad_zip
            ad_attn        colon 15
            ad_phone       colon 15
            ad__chr01      colon 15 label "客户银行及帐号" format "x(50)"
            ad_vat_reg     colon 15 format "x(15)"

          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = {&xxcsmt02_3}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/************8
         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
cm_sort        colon 10
            cm_type        colon 48
            cm_taxable     colon 67
               view-as fill-in size 3.5 by 1   
            cm_taxc                 no-label
            cm_slspsn[1]   colon 10 label {&xxcsmt02_1}
            mult_slspsn    colon 33 label {&xxcsmt02_2}
            cm_region      colon 48
            cm_pr_list2    colon 67

            cm_shipvia     colon 10
            cm_curr        colon 48
            cm_pr_list     colon 67

            cm_ar_acct     colon 10
            cm_ar_cc                no-label
/*L01N /*L00R*/    scur_lbl       no-attr-space to 48 no-label */
/*L01N /*L00R*/    cm_scurr       no-label */
/*L01N*/    cm_scurr       colon 48 label {&xxcsmt02_7}
/*L00R*     cm_lang        colon 48  */
            cm_fix_pr      colon 67

            cm_resale      colon 10
            cm_site
/*L00R*                    colon 48   */
/*L00R*/    cm_lang                 label {&xxcsmt02_6}
            cm_class       colon 67

            cm_rmks        colon 10
            cm_partial     colon 67

          SKIP(.4)  /*GUI*/
with frame b  side-labels
         width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = {&xxcsmt02_4}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/


         /*** Form for Promotion Data ***/
         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
skip(1)
            cm_promo    colon 17
            space(2)
            skip (1)
          SKIP(.4)  /*GUI*/
with frame p width 30 row 15 column 27 overlay
         side-labels no-attr-space
          NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-p-title AS CHARACTER.
 F-p-title = {&xxcsmt02_5}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame p = F-p-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame p =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame p + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame p =
  FRAME p:HEIGHT-PIXELS - RECT-FRAME:Y in frame p - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME p = FRAME p:WIDTH-CHARS - .5. /*GUI*/
 
**********/
