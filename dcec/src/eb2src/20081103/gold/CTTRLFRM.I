/* GUI CONVERTED from cttrlfrm.i (converter v1.69) Sat Mar 30 01:06:20 1996 */
/* cttrlfrm.i - DEFINE FORM CANADIAN SALES ORDER TRAILER INCLUDE FILE   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G0XY*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/* REVISION: 6.0      LAST MODIFIED: 12/12/90   BY: MLB *D238**/
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015**/
/* REVISION: 7.0      LAST MODIFIED: 03/19/92   BY: TMD *F263**/
/* REVISION: 7.2      LAST MODIFIED: 08/02/94   BY: RXM *FP61**/
/* REVISION: 7.2      LAST MODIFIED: 10/24/94   BY: ljm *FS80**/
/* REVISION: 7.3      LAST MODIFIED: 10/20/95   BY: jym *G0XY**/
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053**/

      FORM /*GUI*/ 
      

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
taxable_amt colon 12 label "ÄÉË° GST"
      so_mstr.so_curr
      line_total   colon 60 no-attr-space
      line_pst colon 12
      so_mstr.so_disc_pct to 49 no-label   disc_amt     colon 60 no-attr-space
      so_pst_pct label "PST" colon 12
      user_desc[1] to 53 no-label so_mstr.so_trl1_cd to 58 no-label
				      ":" at 60 so_mstr.so_trl1_amt no-label
/*F263*/ tax_date colon 12

      user_desc[2] to 53 no-label so_mstr.so_trl2_cd to 58 no-label
					":" at 60 so_mstr.so_trl2_amt no-label

/*F263*/      invcrdt no-label
/*FS80*/       at 3   

      user_desc[3] to 53 no-label so_mstr.so_trl3_cd to 58 no-label
					":" at 60 so_mstr.so_trl3_amt no-label

/*FP61    vtclass[1] no-label to 4                               */
/*FP61    so_mstr.so_tax_pct[1] no-label format "-zz9.99%" to 15 */
/*FP61    vtclass[2] no-label to 20                              */
/*FP61    so_mstr.so_tax_pct[2] no-label format "-zz9.99%" to 30 */
/*FP61    vtclass[3] no-label to 36                              */
/*FP61    so_mstr.so_tax_pct[3] no-label format "-zz9.99%" to 46 */

/*FP61*/  vtclass[1] no-label
/*FS80*/ /*V8+*/       at    3
/*FP61*/  so_mstr.so_tax_pct[1] no-label format "-zz9.999%" to 14
/*FP61*/  vtclass[2] no-label to 19
/*FP61*/  so_mstr.so_tax_pct[2] no-label format "-zz9.999%" to 30
/*FP61*/  vtclass[3] no-label to 35
/*FP61*/  so_mstr.so_tax_pct[3] no-label format "-zz9.999%" to 46
					 tax_amt label "GST ºÏ¼Æ" colon 60 skip

/*FP61    amt[1] no-label to 15 no-attr-space                     */
/*FP61*/  amt[1] no-label to 14 no-attr-space
	  amt[2] no-label to 30 no-attr-space
	  amt[3] no-label to 46 no-attr-space
				      total_pst colon 60 skip
/*FP61    tax[1] no-label to 15 no-attr-space                     */
/*FP61*/  tax[1] no-label to 14 no-attr-space
	  tax[2] no-label to 30 no-attr-space
	  tax[3] no-label to 46 no-attr-space
				      ord_amt      colon 60 skip
      

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame cttrail side-labels width 80 attr-space
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-cttrail-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame cttrail = F-cttrail-title.
 RECT-FRAME-LABEL:HIDDEN in frame cttrail = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame cttrail =
  FRAME cttrail:HEIGHT-PIXELS - RECT-FRAME:Y in frame cttrail - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME cttrail = FRAME cttrail:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/*J053*/ /* SET CURRENCY DEPENDENT FORMATS */
/*J053*/ assign
/*J053*/    taxable_amt:format in frame cttrail = taxable_fmt
/*J053*/    line_total:format in frame cttrail = line_tot_fmt
/*J053*/    /*line_pst:format in frame cttrail = line_pst_fmt*/
/*J053*/    disc_amt:format in frame cttrail = disc_fmt
/*J053*/    so_trl1_amt:format in frame cttrail = trl_amt_fmt
/*J053*/    so_trl2_amt:format in frame cttrail = trl_amt_fmt
/*J053*/    so_trl3_amt:format in frame cttrail = trl_amt_fmt
/*J053*/    tax_amt:format in frame cttrail = tax_amt_fmt
/*
/*J053*/    amt[1]:format in frame cttrail = amt_fmt
/*J053*/    amt[2]:format in frame cttrail = amt_fmt
/*J053*/    amt[3]:format in frame cttrail = amt_fmt

/*J053*/    total_pst:format in frame cttrail = tot_pst_fmt

/*J053*/    tax[1]:format in frame cttrail = tax_fmt
/*J053*/    tax[2]:format in frame cttrail = tax_fmt
/*J053*/    tax[3]:format in frame cttrail = tax_fmt
*/
/*J053*/    ord_amt:format in frame cttrail = ord_amt_fmt.

