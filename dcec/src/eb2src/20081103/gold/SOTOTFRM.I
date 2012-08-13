/* GUI CONVERTED from sototfrm.i (converter v1.69) Sat Mar 30 01:23:55 1996 */
/* sototfrm.i - DEFINE FORM GTM SALES ORDER TRAILER INCLUDE FILE        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G0XY*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/* REVISION: 7.3            CREATED: 02/04/93   BY: bcm *G415**/
/* REVISION: 7.4            CREATED: 06/01/93   BY: bcm *H002**/
/*                    DATE MODIFIED: 09/03/94   BY: srk *FQ79**/
/*                    DATE MODIFIED: 10/20/95   BY: jym *G0XY**/
/* REVISION: 8.5           MODIFIED: 07/14/95   BY: taf *J053**/

      FORM /*GUI*/ 
         

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
nontaxable_amt           colon 12
         so_curr
         line_total               colon 60 no-attr-space
         taxable_amt              colon 12
         so_disc_pct              to 49 no-label
         disc_amt                 colon 60 no-attr-space
         tax_date                 colon 12
         user_desc[1]             to 53 no-label
         so_trl1_cd format "x(2)" to 58 no-label
         ":"                      at 60
         so_trl1_amt                    no-label
         user_desc[2]             to 53 no-label
         so_trl2_cd format "x(2)" to 58 no-label
         ":"                      at 60
         so_trl2_amt                    no-label
/*FQ79*  invcrdt                        no-label */
/*FQ79*/ invcrdt                  at 3  no-label
         user_desc[3]             to 53 no-label
         so_trl3_cd format "x(2)" to 58 no-label
         ":"                      at 60
         so_trl3_amt                    no-label
         tax_amt                  colon 60 skip
/*H002*/ tax_edit_lbl format "x(28)"    no-label no-attr-space to 30
	 tax_edit                 at 32 no-label /*GB74*/
         ord_amt                  colon 60 skip
      /*GB74 tax_edit colon 30 */
      

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame sotot side-labels width 80 attr-space
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
 DEFINE VARIABLE F-sotot-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sotot = F-sotot-title.
 RECT-FRAME-LABEL:HIDDEN in frame sotot = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sotot =
  FRAME sotot:HEIGHT-PIXELS - RECT-FRAME:Y in frame sotot - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sotot = FRAME sotot:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/*J053*/ /* ASSIGN CURRENCY DEPENDENT FORMATS */
/*J053*/ assign
/*J053*/    nontaxable_amt:format in frame sotot = nontax_fmt
/*J053*/    taxable_amt:format in frame sotot = taxable_fmt
/*J053*/    line_total:format in frame sotot = line_tot_fmt
/*J053*/    disc_amt:format in frame sotot = disc_fmt
/*J053*/    so_trl1_amt:format in frame sotot = trl_amt_fmt
/*J053*/    so_trl2_amt:format in frame sotot = trl_amt_fmt
/*J053*/    so_trl3_amt:format in frame sotot = trl_amt_fmt
/*J053*/    tax_amt:format in frame sotot = tax_amt_fmt
/*J053*/    ord_amt:format in frame sotot = ord_amt_fmt.

