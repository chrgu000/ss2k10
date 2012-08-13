/* GUI CONVERTED from sotrlfra.i (converter v1.69) Mon Aug 12 14:35:40 1996 */
/* sotrlfra.i - FORM DEFINITION FOR FRAME sotrail IN SALES ORDER       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=ReportAndMaintenance                                   */
/* REVISION: 8.5            CREATED: 07/22/96   BY: *G1ZR* Suresh Nayak */

/*!
  THIS ROUTINE WAS DERIVED FROM sotrlfrm.i AND IS USED BY SALES ORDER.
  THE PROGRAM sqqtrlfrm.i HAS FORM DEFINITION AND SOME ASSIGN STATEMENTS.
  HENCE IT WAS ALLOWING THE USER WHO DOES NOT HAVE ACCESS TO THIS FIELD
  (SET UP IN 36.5.4 FIELD SECURITY MAINTENANCE) TO UPDATE THIS FIELD.
  THIS FILE WAS CREATED TO FIX THIS PROBLEM .

  CALLED BY sosomtc4.p & sotrlfrm.i (USED BY SALES ORDER )
*/

      FORM /*GUI*/ 
      

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
nontaxable_amt colon 12
         so_mstr.so_curr
      line_total   colon 60 no-attr-space
      taxable_amt colon 12
      so_mstr.so_disc_pct to 49 no-label   disc_amt     colon 60 no-attr-space
         tax_date     colon 12
      user_desc[1] to 53 no-label so_mstr.so_trl1_cd to 58 no-label
					":" at 60 so_mstr.so_trl1_amt no-label
      user_desc[2] to 53 no-label so_mstr.so_trl2_cd to 58 no-label
					":" at 60 so_mstr.so_trl2_amt no-label
         invcrdt no-label at 2
      user_desc[3] to 53 no-label so_mstr.so_trl3_cd to 58 no-label
					":" at 60 so_mstr.so_trl3_amt no-label

         vtclass[1] no-label at 3
         so_mstr.so_tax_pct[1] no-label format "-zz9.999%" to 14
         vtclass[2] no-label to 19
         so_mstr.so_tax_pct[2] no-label format "-zz9.999%" to 30
         vtclass[3] no-label to 35
         so_mstr.so_tax_pct[3] no-label format "-zz9.999%" to 46
					 tax_amt      colon 60 skip
         amt[1] no-label to 14 no-attr-space
	 amt[2] no-label to 30 no-attr-space
	 amt[3] no-label to 46 no-attr-space
					ord_amt      colon 60
         tax[1] no-label to 14 no-attr-space
	 tax[2] no-label to 30 no-attr-space
	 tax[3] no-label to 46 no-attr-space
      

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame sotrail side-labels width 80 attr-space
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
 DEFINE VARIABLE F-sotrail-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sotrail = F-sotrail-title.
 RECT-FRAME-LABEL:HIDDEN in frame sotrail = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sotrail =
  FRAME sotrail:HEIGHT-PIXELS - RECT-FRAME:Y in frame sotrail - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sotrail = FRAME sotrail:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/

