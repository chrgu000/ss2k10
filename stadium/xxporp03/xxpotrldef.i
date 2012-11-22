/* potrldef.i - PURCHASE ORDER TRAILER FIELD DEFINITIONS                      */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/
/* $Revision: 1.6.3.4 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/* REVISION: 7.4  BY: Bryan Merich DATE:04/11/94   ECO: *H334*                */
/* REVISION: 8.5  BY: ccc          DATE:09/08/95   ECO: *J053*                */
/* REVISION: 8.6E BY: A. Rahane    DATE:02/23/98   ECO: *L007*                */
/* REVISION: 8.6E BY:Alfred Tan    DATE:05/20/98   ECO: *K1Q4*                */
/* REVISION: 8.6E BY:Alfred Tan    DATE:10/04/98   ECO: *J314*                */
/* REVISION: 9.1  BY:Annasaheb Rahane DATE:03/24/00 ECO: *N08T*               */
/* $Revision: 1.6.3.4 $   BY:Mark B. Smith DATE: 07/20/00   ECO: *N059*       */
/* REVISION: 9.1  BY:Mudit Mehta   DATE:08/17/00   ECO: *N0KM*                */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE potrldef_i_1 "Discount"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_2 "Line Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_3 "Non-Taxable"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_4 "EDI PO"
/* MaxLen: Comment: */

/*N0KM*
 * &SCOPED-DEFINE potrldef_i_5 "       View/Edit Tax Detail:"
 * /* MaxLen: Comment: */
 *N0KM*/

&SCOPED-DEFINE potrldef_i_6 "Total Tax"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_7 "Taxable PST"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_8 "Taxable Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_9 "Taxable"
/* MaxLen: Comment: */

&SCOPED-DEFINE potrldef_i_10 "Total"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define {1} shared frame    potot.
define {1} shared frame    potrail.
define {1} shared frame    pocttrl.
define {1} shared frame    povttrl.
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
   format "x(28)"
/*N0KM*   initial {&potrldef_i_5} */ .
define {1} shared variable order_amt         like lines_total
   label {&potrldef_i_10}.
define {1} shared variable edi_po            like mfc_logical
   label {&potrldef_i_4}.
define {1} shared variable line_tax    as decimal
   format "(>>,>>>,>>>,>>9.99)"
   label {&potrldef_i_8}.
define {1} shared variable line_total  as decimal
   format "(zz,zzz,zzz,zz9.99)"
   label {&potrldef_i_2}.
define {1} shared variable tax_amt     like line_total
   label {&potrldef_i_6}.
define {1} shared variable tax_1       like line_total.
define {1} shared variable tax_2       like line_total.
define {1} shared variable tax_3       like line_total.
define {1} shared variable ord_amt     like line_total
   label {&potrldef_i_10}.
define {1} shared variable vtln_total  as decimal
   format "(zzzz,zzz,zz9.99)"
   label {&potrldef_i_2}.
define {1} shared variable vtdisc_amt  like vtln_total
   label {&potrldef_i_1}.
define {1} shared variable vtord_amt   like vtln_total
   label {&potrldef_i_10}.
define {1} shared variable line_pst    as decimal
   format "->>,>>>,>>>,>>9.99"
   label {&potrldef_i_7}.
define {1} shared variable gst_taxed   like po_taxable.
define {1} shared variable pst_taxed   like po_pst.
define {1} shared variable frt_amt     as decimal
   format "->>,>>>,>>9.99".
define {1} shared variable duty_amt    as decimal
   format "->>,>>>,>>9.99".
define {1} shared variable bkage_amt   as decimal
   format "->>,>>>,>>9.99".
define {1} shared variable duty_type   like vp_duty_type.

/*N0KM********ADDED START********* */
&IF (string("{1}") = "NEW") &THEN
    assign tax_edit_lbl = getTermLabelRtColon("VIEW/EDIT_TAX_DETAIL",28).
&ENDIF
/*N0KM********ADDED END*********** */

/* WHEN THE VARS ARE "NEW", THE CURRENCY DEPENDENT FORMATS REQUIRED */
/* BY THE FORMS ARE NOT YET AVAILABLE                               */
if (string("{1}") <> "NEW") then do:
   {xxpototfrm.i}
   form {pomtdfrm.i} with frame pomtd attr-space side-labels width 80.
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame pomtd:handle).

   tax_edit_lbl = getTermLabelRtColon("VIEW/EDIT_TAX_DETAIL", 28).
   po_prepaid:format = prepaid_fmt.
end.
