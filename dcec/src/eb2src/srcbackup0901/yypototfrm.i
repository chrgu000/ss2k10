/* GUI CONVERTED from pototfrm.i (converter v1.76) Mon May 19 14:28:27 2003 */
/* pototfrm.i - DEFINE FORM PURCHASE ORDER TRAILER INCLUDE FILE         */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.14 $                                                    */
/*V8:ConvertMode=ReportAndMaintenance                                   */
/*V8:DontRefreshTitle=potot                                             */
/* REVISION: 7.4            CREATED: 06/10/93   BY: jjs *H006**/
/* REVISION: 7.4      LAST MODIFIED: 07/06/93   BY: jjs *H024**/
/* REVISION: 7.4      LAST MODIFIED: 04/11/94   BY: bcm *H334**/
/* REVISION: 8.5      LAST MODIFIED: 09/18/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 02/14/96   BY: rxm *H0JJ**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 02/06/99   BY: *M06R* Doug Norton  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.13       BY: Katie Hilbert       DATE: 04/01/01 ECO: *P002*  */
/* $Revision: 1.14 $    BY: Vandna Rohira       DATE: 04/28/03 ECO: *N1YL*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

FORM /*GUI*/ 
   

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
l_nontaxable_lbl /*tfq to 12*/          view-as text   
                             no-label no-attr-space
   nontaxable_amt            no-label
   po_curr
   lines_total      colon 60          no-attr-space
   l_taxable_lbl    /*tfq to 12 */         view-as text   
                             no-label no-attr-space
   taxable_amt               no-label
   tax_total        colon 60
   tax_date         colon 12
   order_amt        colon 60 skip(1)
   tax_edit_lbl     to 30    no-label no-attr-space format "x(28)"
   tax_edit         at 32    no-label


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame potot side-labels width 80 attr-space
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
 DEFINE VARIABLE F-potot-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame potot = F-potot-title.
 RECT-FRAME-LABEL:HIDDEN in frame potot = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame potot =
  FRAME potot:HEIGHT-PIXELS - RECT-FRAME:Y in frame potot - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME potot = FRAME potot:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame potot:handle).

assign
   l_nontaxable_lbl = getTermLabelRtColon("NON-TAXABLE", 12)
   l_taxable_lbl    = getTermLabelRtColon("TAXABLE", 12)
   tax_edit_lbl     = getTermLabelRtColon("VIEW/EDIT_TAX_DETAIL", 28).

/* SETUP DISPLAY FORMATS FOR ALL CURRENCY VARIABLES */
assign
   taxable_amt:format in frame potot   = taxable_fmt
   nontaxable_amt:format in frame potot = nontax_fmt
   lines_total:format in frame potot   = lines_tot_fmt
   tax_total:format in frame potot     = tax_tot_fmt
   order_amt:format in frame potot     = order_amt_fmt.

