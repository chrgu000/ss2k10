/* txdetrp.p - qad DISPLAY TAX DETAIL AMOUNTS FOR A TRANSACTION               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.27.3.1 $                                                        */
/*V8:ConvertMode=Report                                                       */
/*  This program displays a down frame of tax detail (by) for each            */
/*  tax type/class/usage shows the tax; descrip, amount, base amount & tax %  */
/* Revision: 7.4      CREATED: 06/08/92         By: skk *H002*                */
/* 7.4 07/21/93 bcm *H030*  Added 80-column display form & logic.             */
/* 7.4 07/22/93 bcm *H032*  Added tax control file switch to control printing. */
/* 7.4 07/28/93 bcm *H042*  Change 80 vs. 132 column indicator to parameter.  */
/*     07/28/93 jjs *H043*  Allow * as a value for nbr                        */
/*     09/21/93 jjs *H132*  add 'do' to else portion of if col-80 then        */
/*     09/29/93 bcm *H143*  Fix initialization when tax-by-line               */
/*     03/28/94 bcm *H306*  Changed tax class display field to 8 characters   */
/*     06/27/94 bcm *H407*  Changed tax% to display rate record% if base = 0  */
/* 8.5 07/11/95 taf *J053*  Currency Dependent display formatting.            */
/* 8.5 07/11/96 ruw *J0YQ*  Added a down 1 to fix a display problem           */
/* 8.6 09/03/96 jzw *K008*  Add VAT capabilities F010-01                      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/05/98   BY: *K1RY* A. Shobha          */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 12/28/98   BY: *J37L* Seema Varma        */
/* REVISION: 9.1      LAST MODIFIED: 05/08/00   BY: *J3P2* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0DX* BalbeerS Rajput    */
/* REVISION: 8.6      LAST MODIFIED: 11/13/96   BY: *H0N8* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LD*                */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 08/20/99   BY: *M0DM* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/19/00   BY: *N0G9* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W4* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.25     BY: Tiziana Giustozzi     DATE: 10/01/01  ECO: *N138*   */
/* Revision: 1.26     BY: Niranjan R.           DATE: 03/12/02  ECO: *P020*   */
/* Revision: 1.27     BY: Samir Bavkar          DATE: 07/07/02  ECO: *P0B0*   */
/* $Revision: 1.27.3.1 $    BY: Manish Dani         DATE: 06/24/03  ECO: *P0VZ*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
 * txdetrp.p   qad Display Tax Amounts For a Transaction
 */
/*!
 *  Any changes to this must be applied to txdetrp1.p
 *  ANY CHANGES TO THIS MIGHT ALSO BE REQUIRED IN txdetrp2.p
 */


/*!
Receives the following parameters
I/O     Name        Like            Description
-----   ----------- --------------- ------------------------------
input   tr_type     tx2d_tr_type    Transaction Type Code
input   ref         tx2d_ref        Document Reference
input   nbr         tx2d_nbr        Number (Shipper, etc.)
                                    "*" indicates all tx2d_nbr(s)
                                    for a given tx2d_ref
input   col-80      mfc_logical     True for 80 column report
input   page_break  integer         number of lines on first page

*/
/***************************************************************************/
/* NOTE ALTHOUGH EACH TX2D_DET RECORD HAS A CURRENCY, WE WILL NOT USE */
/* THIS CURRENCY FOR DISPLAY PURPOSES.  THIS IS THE TAX ROUND METHOD  */
/* AND WAS USED TO ROUND THE AMOUNTS PRIOR TO ROUNDING THEM TO THE    */
/* DOCUMENT CURRENCY.  ALL AMOUNTS DISPLAYED ON A DOCUMENT ARE        */
/* DISPLAYED IN DOCUMENT CURRENCY.  THE SHARED VARIABLE RNDMTHD       */
/* CONTAINS THE ROUNDING METHOD FOR THE DOCUMENT CURRENCY.            */

{mfdeclre.i }
{cxcustom.i "TXDETRP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* PARAMETERS */
define input  parameter tr_type     like tx2d_tr_type no-undo.
define input  parameter ref         like tx2d_ref     no-undo.
define input  parameter nbr         like tx2d_nbr     no-undo.
define input  parameter col-80      as logical        no-undo.
define input  parameter page_break  as integer        no-undo.
define input  parameter base_rpt    like ap_curr      no-undo.
define input  parameter mixed_rpt   like mfc_logical  no-undo.

/* WORKFILES */
{txdetdef.i}

/*SHARED VARIABLES */
define shared variable undo_txdetrp like mfc_logical.
define shared variable rndmthd like rnd_rnd_mthd.

/* LOCAL VARIABLES */
define variable first_page as logical initial true no-undo.
define variable ar_ap  as logical initial true no-undo.
define variable l_sign as integer              no-undo.
define variable l-taxdesc   like tx2_desc    no-undo.
define variable l-taxclass  like tx2_pt_taxc no-undo.
define variable l-nontax    like tx2d_tottax no-undo.
define variable c-cont      as character format "x(35)" no-undo.

c-cont = CAPS(dynamic-function('getTermLabelFillCentered' in h-label,
   input "CONTINUED",
   input 35,
   input "*")).

{txcurvar.i}
{gpcrfmt.i}

form header
   fill("-",77) format "x(77)" skip
   space(30)
   c-cont
   skip(8)
with frame continue page-bottom width 80.

form
   taxdesc column-label "Tax Type Description!Tax Rate Description"
   taxclass at 28 column-label "Tax Class!Tax Usage"
   taxtotal column-label "Tax Amount"
   taxpercnt column-label "Tax!Rate"
   nontax column-label "Taxable!Non-taxable" format "->>>>,>>>,>>9.99"
with frame det_80 width 80 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame det_80:handle).

form
   typedesc    column-label "Tax Type!Description"
   l-taxdesc   column-label "Tax!Description"
   l-taxclass  column-label "Tax!Class"
   taxusage    column-label "Tax!Usage"
   taxtotal    column-label "Tax!Amount"
   taxpercnt   column-label "Tax!Rate"
   taxbase     column-label "Taxable!Sales" format "->>>>,>>>,>>9.99"
   l-nontax    column-label "Non-Taxable!Sales"  format "->>>>,>>>,>>9.99"
with frame det_132 width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame det_132:handle).

assign
   gtm_taxbase_old = taxbase:format
   gtm_taxtot_old = taxtotal:format
   gtm_nontax_old = nontax:format.

for first txc_ctrl
   fields(txc_detrp txc__qad03) no-lock:
end.

if not txc_detrp
then do:
   /* PRINT ONLY IF FLAG = TRUE */
   undo_txdetrp = false.
   return.
end.

/* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */
{&TXDETRP-P-TAG1}
if lookup(tr_type,
    "20,21,22,23,24,25,26,27,28,29,40,41,42,43,44,45,46,47,48") <> 0 then
   ar_ap = false.
{&TXDETRP-P-TAG2}

/* MOST USER DOCS ARE 80-COLUMN FORMAT : SET ONLY IF 132 COLUMNS ARE NEEDED */
mainloop:
do on endkey undo, leave:

   /** ACCUMULATE TAX DETAILS  **/
   if tr_type = "33" or tr_type = "34" then do:
      {fstdetrp.i}
   end.
   else do:
      {txdetrpa.i}
   end.

   /* SET UP CURRENCY DEPENDENT FORMATS */
   /* SET UP TAXBASE FORMAT FOR FRAME DET_132 */
   gtm_taxbase_fmt = gtm_taxbase_old.

   run gpcrfmt (input-output gtm_taxbase_fmt, input rndmthd).

   taxbase:format in frame det_132 = gtm_taxbase_fmt.
   /* SET UP TAXTOTAL FORMAT FOR FRAMES DET_80 & DET_132 */
   gtm_taxtot_fmt = gtm_taxtot_old.

   run gpcrfmt (input-output gtm_taxbase_fmt, input rndmthd).

   taxtotal:format in frame det_80 = gtm_taxtot_fmt.
   taxtotal:format in frame det_132 = gtm_taxtot_fmt.

   /* SET UP NONTAX FORMAT FOR FRAMES DET_80 & DET_132 */
   gtm_nontax_fmt = gtm_nontax_old.

   run gpcrfmt (input-output gtm_taxbase_fmt, input rndmthd).

   /** DISPLAY TAX DETAILS    **/
   {txdetrpb.i}

   undo_txdetrp = false.

end. /* end mainloop do */
