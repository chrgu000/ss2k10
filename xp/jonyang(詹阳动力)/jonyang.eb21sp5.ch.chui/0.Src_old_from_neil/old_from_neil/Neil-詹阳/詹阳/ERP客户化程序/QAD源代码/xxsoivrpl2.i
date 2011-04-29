/* soivrpl2.i - DEFINE VARIABLES & FORMS USED BY S/O TRAILER INCLUDE FILE     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                         */
/*                                                                            */
/* REVISION: 7.4   CREATED: 06/29/93   BY: SKK    *H002* add defs 4 soivtrl2.p*/
/* REVISION: 8.5  MODIFIED: 07/20/95   BY: TAF    *J053*                      */
/* REVISION: 8.5  MODIFIED: 02/28/96   BY: *J04C* Markus Barone               */
/* REVISION: 8.5  MODIFIED: 07/02/96   BY: *J0WF* Sue Poland                  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb                  */
/* $Revision: 1.6.1.4 $    BY: Ellen Borden  DATE: 03/13/02  ECO: *P00G*  */
/* SS - 090924.1 By: Neil Gao */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*J053* INDENTED FILE TO BRING UP TO STANDARD */
/*J04C* Changed ConverMode token from Report to ReportAndMaintenance. */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrpl2_i_1 "Invoiced!Backorder"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrpl2_i_2 "Ext Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrpl2_i_3 "Tax!TaxUsage"
/* MaxLen: Comment: */
/* ********** End Translatable Strings Definitions ********* */

define  new shared frame d.
define new shared frame e.

define  new shared variable undo_trl2 like mfc_logical initial false.
/* Dummy Variable to combine Taxable and Tax Class in the report. */
define  variable taxandtaxc like mfc_char format "x(8)".

if (string("{1}") <> "NEW") then do:
   form
      so_cr_init     colon 15
      so_inv_nbr     colon 40

      so_cr_card     colon 15
      so_to_inv      colon 40
      so_print_so    colon 63
      so_stat        colon 15
      so_invoiced    colon 40
      so_print_pl    colon 63
      so_rev         colon 15
      so_prepaid     colon 40
      so_fob         colon 15
      so_ar_acct     colon 40 so_ar_sub no-label so_ar_cc no-label
   with frame d side-labels width 80.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame d:handle).

   form
      sod_line
      sod_part format "x(24)" sod_um

      sod_acct   sod_sub sod_cc
/* SS 090924.1 - B */
/*
      sod_qty_inv column-label {&soivrpl2_i_1}
*/
      sod_qty_inv column-label "SHIPQTY!OPENQTY"
/* SS 090924.1 - E */
      taxandtaxc column-label {&soivrpl2_i_3}
      net_price  
/* SS 090924.1 - B */
			column-label "NET_PRICE!EXT_PRICE"  
/* SS 090924.1 - E */    
      format  "->>>>,>>>,>>9.99<<<"
/* SS 090924.1 - B */
/*
      ext_price label {&soivrpl2_i_2} space(4)
      ext_gr_margin
*/
/* SS 090924.1 - E */

   with frame e width 132.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame e:handle).
   /*SET CURRENCY DEPENDENT FORMATS */
/* SS 090924.1 - B */
/*
   ext_price:format = ext_price_fmt.
   ext_gr_margin:format = ext_gr_marg_fmt.
*/
/* SS 090924.1 - E */

end.
