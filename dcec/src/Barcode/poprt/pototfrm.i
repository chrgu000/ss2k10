/* GUI CONVERTED from pototfrm.i (converter v1.75) Sun Aug 13 13:42:50 2000 */
/* pototfrm.i - DEFINE FORM PURCHASE ORDER TRAILER INCLUDE FILE         */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*H0JJ*/ /*F0PN*/ /*V8:ConvertMode=ReportAndMaintenance                 */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
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
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pototfrm_i_1 "PST 合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE pototfrm_i_2 "税"
/* MaxLen: Comment: */

&SCOPED-DEFINE pototfrm_i_3 "手续费"
/* MaxLen: Comment: */

&SCOPED-DEFINE pototfrm_i_4 "PST"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*J053  MOVED **ALL** PO TRAILER FRAME DEFINES INTO POTOTFRM.I IN ORDER TO */
/*J053  FACILITATE CURRENCY DEPENDENT ROUNDING FORMAT ASSIGNMENT FLOW      */
/*J053                ******* EXCEPT: *******                              */
/*J053  FORM 'POMTD' ( WHICH USED TO BE DEFINED AS FRAME 'D' ) REMAINS     */
/*J053  SEPARATELY DEFINED IN POMTDFRM.I BECAUSE ITS ATTRIBUTES ARE        */
/*J053  SPECIFIED BY USING PROGRAMS, NOT WITHIN THE FORM                   */
/*J053*/ find first gl_ctrl no-lock.

/*J053*/ if gl_can then do:

/*J053*/    /* FORM 'POCTTRL' USED TO BE DEFINED IN POCTTRL.I                */
/*J053*/    /* MODIFIED FORM: REMOVED FORMATS - THEY ARE DEFINED IN          */
/*J053*/    /* POTRLDEF.I  */
/*J053*/    FORM /*GUI*/ 
/*J053*/       

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
line_pst at 2
/*J053*/       line_total    colon 58
/*J053*/       po_frt        colon 58 format "-zz,zzz,zzz,zz9.99"
/*J053*/       po_serv_chg   colon 58 label {&pototfrm_i_3}
/*J053*/                              format "-zz,zzz,zzz,zz9.99"
/*J053*/       po_duty_type  to 49
/*J053*/       po_spec_chg   colon 58 label {&pototfrm_i_2}
/*J053*/                              format "-zz,zzz,zzz,zz9.99"
/*J053*/       po_tax_pct[2] label {&pototfrm_i_4} at 2
/*J053*/       tax_2         colon 58 label {&pototfrm_i_1}
/*J053*/       po_curr       to 49 no-label
/*J053*/       ord_amt       colon 58
/*J053*/    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame pocttrl side-labels width 80
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
 DEFINE VARIABLE F-pocttrl-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pocttrl = F-pocttrl-title.
 RECT-FRAME-LABEL:HIDDEN in frame pocttrl = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame pocttrl =
  FRAME pocttrl:HEIGHT-PIXELS - RECT-FRAME:Y in frame pocttrl - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pocttrl = FRAME pocttrl:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame pocttrl:handle).

/*J053*/    /* SETUP DISPLAY FORMATS FOR ALL CURRENCY VARIABLES */
/*J053*/    assign
/*J053*/        tax_2:format in frame pocttrl         = tax_fmt
/*J053*/        ord_amt:format in frame pocttrl       = ord_amt_fmt
/*J053*/        line_total:format in frame pocttrl    = line_tot_fmt
/*J053*/        line_pst:format in frame pocttrl      = line_pst_fmt
/*J053*/        po_frt:format in frame pocttrl        = frt_fmt
/*J053*/        po_spec_chg:format in frame pocttrl   = spec_chg_fmt
/*J053*/        po_serv_chg:format in frame pocttrl   = serv_chg_fmt.
/*J053*/ end.

/*J053*/ else if gl_vat then do:
/*J053*/    /* FORM 'POVTTRL' USED TO BE DEFINED IN POVTTRL.I               */
/*J053*/    FORM /*GUI*/ 
/*J053*/          

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
po_curr no-label at 2
/*J053*/          vtord_amt
/*J053*/    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame povttrl side-labels width 80
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
 DEFINE VARIABLE F-povttrl-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame povttrl = F-povttrl-title.
 RECT-FRAME-LABEL:HIDDEN in frame povttrl = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame povttrl =
  FRAME povttrl:HEIGHT-PIXELS - RECT-FRAME:Y in frame povttrl - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME povttrl = FRAME povttrl:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame povttrl:handle).

/*J053*/   /* SETUP DISPLAY FORMATS FOR ALL CURRENCY VARIABLES */
/*J053*/   assign
/*J053*/      vtord_amt:format in frame povttrl     = vtord_amt_fmt.
/*J053*/ end.

/*J053*/ else if {txnew.i} then do:

            FORM /*GUI*/ 
               

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
                 l_nontaxable_lbl to 12          view-as text   
                             no-label no-attr-space
   nontaxable_amt            no-label
                
               po_curr
               lines_total    colon 60 no-attr-space
                 l_taxable_lbl    to 12          view-as text   
                             no-label no-attr-space
                taxable_amt    NO-LABEL
               tax_total      colon 60
/*H334*/       tax_date       colon 12
               order_amt      colon 60 skip(1)
/*H024*/       tax_edit_lbl   format "x(28)" no-label no-attr-space to 30
/*H024*/       tax_edit       no-label at 32
/*H024         tax_edit       colon 30 */
            

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
            tax_edit_lbl = getTermLabelRtColon("VIEW/EDIT_TAX_DETAIL", 28). /*N08T*/

/*J053*/    /* SETUP DISPLAY FORMATS FOR ALL CURRENCY VARIABLES */
/*J053*/    assign
/*J053*/        taxable_amt:format in frame potot   = taxable_fmt
/*J053*/        nontaxable_amt:format in frame potot = nontax_fmt
/*J053*/        lines_total:format in frame potot   = lines_tot_fmt
/*J053*/        tax_total:format in frame potot     = tax_tot_fmt
/*J053*/        order_amt:format in frame potot     = order_amt_fmt.
/*J053*/ end.

/*J053*/ else do:
/*J053*/    /* FORM 'POTRAIL' USED TO BE DEFINED IN MFPOTRL.I                */
/*J053*/    FORM /*GUI*/ 
/*J053*/      

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
line_tax                          at 2   
/*J053*/      line_total     colon 58
/*J053*/      po_tax_pct[1]                     at 2   
/*J053*/      po_tax_pct[2]  label "[2]"
/*J053*/      po_tax_pct[3]  label "[3]"
/*J053*/      tax_amt        colon 58
/*J053*/      po_curr        to 48 no-label
/*J053*/      ord_amt        colon 58
/*J053*/    

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame potrail side-labels width 80
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
 DEFINE VARIABLE F-potrail-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame potrail = F-potrail-title.
 RECT-FRAME-LABEL:HIDDEN in frame potrail = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame potrail =
  FRAME potrail:HEIGHT-PIXELS - RECT-FRAME:Y in frame potrail - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME potrail = FRAME potrail:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


            /* SET EXTERNAL LABELS */
            setFrameLabels(frame potrail:handle).

/*J053*/    /* SETUP DISPLAY FORMATS FOR ALL CURRENCY VARIABLES */
/*J053*/    assign
/*J053*/        line_tax:format in frame potrail      = line_tax_fmt
/*J053*/        line_total:format in frame potrail    = line_tot_fmt
/*J053*/        tax_amt:format in frame potrail       = tax_amt_fmt
/*J053*/        ord_amt:format in frame potrail       = ord_amt_fmt.
/*J053*/ end.
