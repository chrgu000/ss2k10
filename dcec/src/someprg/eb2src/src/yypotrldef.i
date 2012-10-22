/* GUI CONVERTED from potrldef.i (converter v1.76) Mon May 19 14:28:29 2003 */
/* potrldef.i - PURCHASE ORDER TRAILER FIELD DEFINITIONS                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.3.6 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/* REVISION: 7.4  BY: Bryan Merich DATE:04/11/94   ECO: *H334*                */
/* REVISION: 8.5  BY: ccc          DATE:09/08/95   ECO: *J053*                */
/* REVISION: 8.6E BY: A. Rahane    DATE:02/23/98   ECO: *L007*                */
/* REVISION: 8.6E BY:Alfred Tan    DATE:05/20/98   ECO: *K1Q4*                */
/* REVISION: 8.6E BY:Alfred Tan    DATE:10/04/98   ECO: *J314*                */
/* REVISION: 9.1  BY:Annasaheb Rahane DATE:03/24/00 ECO: *N08T*               */
/* Revision: 1.6.3.4    BY:Mark B. Smith DATE: 07/20/00   ECO: *N059*         */
/* Revision: 1.6.3.5    BY:Mudit Mehta   DATE: 08/17/00   ECO: *N0KM*         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.3.5    BY: Katie Hilbert  DATE: 04/01/01   ECO: *P002*       */
/* $Revision: 1.6.3.6 $ BY: Vandna Rohira  DATE: 04/28/03   ECO: *N1YL*       */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE potrldef_i_2 "Line Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_3 "Non-Taxable"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_4 "EDI PO"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_6 "Total Tax"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_9 "Taxable"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_10 "Total"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define {1} shared frame    potot.
define {1} shared frame    pomtd.

define {1} shared variable undo_trl2        like mfc_logical.
define {1} shared variable taxable_amt      as decimal
   format "->>>>,>>>,>>9.99"
   label {&potrldef_i_9}.
define {1} shared variable nontaxable_amt   like taxable_amt
   label {&potrldef_i_3}.
define {1} shared variable lines_total      as decimal
   format "-zzzz,zzz,zz9.99"
   label {&potrldef_i_2}.
define {1} shared variable tax_total        like lines_total
   label {&potrldef_i_6}.
define {1} shared variable tax_date         like po_tax_date.
define {1} shared variable tax_edit         like mfc_logical
   initial false.
define {1} shared variable tax_edit_lbl     like mfc_char
   format "x(28)".
define {1} shared variable order_amt        like lines_total
   label {&potrldef_i_10}.
define {1} shared variable edi_po           like mfc_logical
   label {&potrldef_i_4}.

define {1} shared variable l_nontaxable_lbl as character format "x(12)" no-undo.
define {1} shared variable l_taxable_lbl    as character format "x(12)" no-undo.

&IF (string("{1}") = "NEW") &THEN
   assign tax_edit_lbl = getTermLabelRtColon("VIEW/EDIT_TAX_DETAIL",28).
&ENDIF

/* WHEN THE VARS ARE "NEW", THE CURRENCY DEPENDENT FORMATS REQUIRED */
/* BY THE FORMS ARE NOT YET AVAILABLE                               */
if (string("{1}") <> "NEW") then do:
   /*tfq {pototfrm.i} */
   /*tfq*/  {yypototfrm.i} 
   FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{pomtdfrm.i}  SKIP(.4)  /*GUI*/
with frame pomtd attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-pomtd-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame pomtd = F-pomtd-title.
 RECT-FRAME-LABEL:HIDDEN in frame pomtd = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame pomtd =
  FRAME pomtd:HEIGHT-PIXELS - RECT-FRAME:Y in frame pomtd - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME pomtd = FRAME pomtd:WIDTH-CHARS - .5.  /*GUI*/

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame pomtd:handle).

   po_prepaid:format = prepaid_fmt.
end.
