/* xxsototfrm.i - DEFINE FORM GTM SALES ORDER TRAILER INCLUDE FILE              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=ReportAndMaintenance                                         */
/*V8:DontRefreshTitle=sotot                                                   */
/* $Revision: 1.5.2.5 $                                                       */
/* REVISION: 7.3            CREATED: 02/04/93   BY: bcm *G415*                */
/* REVISION: 7.4            CREATED: 06/01/93   BY: bcm *H002*                */
/*                    DATE MODIFIED: 09/03/94   BY: srk *FQ79*                */
/*                    DATE MODIFIED: 10/20/95   BY: jym *G0XY*                */
/* REVISION: 8.5           MODIFIED: 07/14/95   BY: taf *J053*                */
/* REVISION: 8.6           MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0F8* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* Old ECO marker removed, but no ECO header exists *GB74*                    */
/* Revision: 1.5.2.4     BY: Ellen Borden  DATE: 07/09/01  ECO: *P007*        */
/* $Revision: 1.5.2.5 $  BY: Vandna Rohira DATE: 04/28/03  ECO: *N1YL*        */
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
    l_nontaxable_lbl            to 12         view-as text   
                                       no-label no-attr-space
   nontaxable_amt                      no-label
   so_curr
   line_total                  colon 60         no-attr-space
   l_taxable_lbl               to 12         view-as text   
                                       no-label no-attr-space
   taxable_amt                 no-label
   so_disc_pct                 to 49   no-label
   disc_amt                    colon 60         no-attr-space
   tax_date            /*V8+*/       colon 10   
   user_desc[1]                to 53   no-label
   so_trl1_cd format "x(2)"    to 58   no-label
   ":"                         at 60
   so_trl1_amt                         no-label
   container_charge_total      colon 13
   user_desc[2]                to 53   no-label
   so_trl2_cd format "x(2)"    to 58   no-label
   ":"                         at 60
   so_trl2_amt                         no-label
   line_charge_total           colon 13
   user_desc[3]                to 53   no-label
   so_trl3_cd format "x(2)"    to 58   no-label
   ":"                         at 60
   so_trl3_amt                         no-label
   invcrdt                     at 3    no-label
/**xx**/    surchange    COLON 60 SKIP 
    tax_amt                     colon 60 skip
   tax_edit_lbl format "x(28)" to 30   no-label no-attr-space
   tax_edit                    at 32   no-label
   ord_amt                     colon 60 skip



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


/* SET EXTERNAL LABELS */
setFrameLabels(frame sotot:handle).

assign
   l_nontaxable_lbl = getTermLabelRtColon("NON-TAXABLE", 12)
   l_taxable_lbl    = getTermLabelRtColon("TAXABLE", 12)
   tax_edit_lbl     = getTermLabelRtColon("VIEW/EDIT_TAX_DETAIL", 28).

/* ASSIGN CURRENCY DEPENDENT FORMATS */
assign
   nontaxable_amt:format in frame sotot = nontax_fmt
   taxable_amt:format in frame sotot = taxable_fmt
   line_total:format in frame sotot = line_tot_fmt
   disc_amt:format in frame sotot = disc_fmt
   so_trl1_amt:format in frame sotot = trl_amt_fmt
   so_trl2_amt:format in frame sotot = trl_amt_fmt
   so_trl3_amt:format in frame sotot = trl_amt_fmt
   tax_amt:format in frame sotot = tax_amt_fmt
   container_charge_total:format in frame sotot = container_fmt
   line_charge_total:format in frame sotot = line_charge_fmt
   ord_amt:format in frame sotot = ord_amt_fmt.
