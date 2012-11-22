/* txdetrp1.p - qad DISPLAY TAX DETAIL AMOUNTS FOR A TRANSACTION              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.21.1.1 $                                                           */
/*V8:ConvertMode=Report                                                       */
/*  This program displays a down frame of tax detail (by) for each            */
/*  tax type/class/usage shows the tax; descrip, amount, base amount & tax %  */
/*  Depending on the control parameter it can accumulate and/or display tax   */
/*  details.                                                                  */
/******************************************************************************/
/* REVISION: 8.6            CREATED: 11/13/96   BY: *H0N8* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LD*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/28/98   BY: *J37L* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/08/00   BY: *J3P2* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *N0DX* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 07/19/00   BY: *N0G9* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00 BY: *N0W4* BalbeerS Rajput      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.19  BY: Tiziana Giustozzi     DATE: 10/01/01  ECO: *N138*      */
/* Revision: 1.20  BY: Samir Bavkar          DATE: 07/07/02  ECO: *P0B0*      */
/* Revision: 1.21  BY: Narathip W.           DATE: 05/07/03  ECO: *P0R9*      */
/* $Revision: 1.21.1.1 $  BY: Manish Dani           DATE: 06/24/03  ECO: *P0VZ*      */
/* $Revision: 1.21.1.1 $  BY: Bill Jiang           DATE: 06/02/06  ECO: *SS - 20060602.1*      */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*! /*H0N8*/ Any changes to this must be applied to txdetrp1.p                */

/*!  txdetrp1.p   qad Display Tax Amounts For a Transaction                   */

/*!
                receives the following parameters
        I/O     Name        Like            Description
        -----   ----------- --------------- ------------------------------
        input   tr_type     tx2d_tr_type    Transaction Type Code
        input   ref         tx2d_ref        Document Reference
        input   nbr         tx2d_nbr        Number (Shipper, etc.)
                                            "*" indicates all tx2d_nbr(s)
                                            for a given tx2d_ref
        input   col-80      mfc_logical     True for 80 column report
        input   page_break  integer         number of lines on first page
        input   l_control   integer         accumulate and/or print.
                        1 = accumulate only
                        2 = accumulate and display
                        3 = display only

*/
/***************************************************************************/
/*      NOTE ALTHOUGH EACH TX2D_DET RECORD HAS A CURRENCY, WE WILL NOT USE */
/*      THIS CURRENCY FOR DISPLAY PURPOSES.  THIS IS THE TAX ROUND METHOD  */
/*      AND WAS USED TO ROUND THE AMOUNTS PRIOR TO ROUNDING THEM TO THE    */
/*      DOCUMENT CURRENCY.  ALL AMOUNTS DISPLAYED ON A DOCUMENT ARE        */
/*      DISPLAYED IN DOCUMENT CURRENCY.  THE SHARED VARIABLE RNDMTHD       */
/*      CONTAINS THE ROUNDING METHOD FOR THE DOCUMENT CURRENCY.            */

{mfdeclre.i }
{cxcustom.i "TXDETRP1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


{wbrp02.i}

/* PARAMETERS */
define input  parameter tr_type     like tx2d_tr_type.
define input  parameter ref         like tx2d_ref.
define input  parameter nbr         like tx2d_nbr.
define input  parameter col-80      as logical.
define input  parameter page_break  as integer.
define input  parameter l_control   as integer.

/* WORKFILES */
{txdetdef.i "shared"}

/*SHARED VARIABLES */
define shared variable undo_txdetrp like mfc_logical.
define shared variable rndmthd like rnd_rnd_mthd.

/* LOCAL VARIABLES */
define variable first_page as logical initial true.
define variable ar_ap       as logical initial true.
define variable l_sign      as integer       no-undo.
define variable l-taxdesc   like tx2_desc    no-undo.
define variable l-taxclass  like tx2_pt_taxc no-undo.
define variable l-nontax    like tx2d_tottax no-undo.
define variable c-cont      as character format "x(35)" no-undo.
define variable base_rpt    like ap_curr     no-undo.
define variable mixed_rpt   like mfc_logical no-undo.

c-cont = CAPS(dynamic-function('getTermLabelFillCentered' in h-label,
              input "CONTINUED",
              input 35,
              input '*')).

{txcurvar.i}

form header
   fill("-",77)   format "x(77)" skip
   space(30)
   c-cont
   skip(8)
with frame continue page-bottom width 80.

form
   taxdesc        column-label "Tax Type Description!Tax Rate Description"
   taxclass at 28 column-label "Tax Class!Tax Usage"
   taxtotal       column-label "Tax Amount"
   taxpercnt      column-label "Tax!Rate"
   nontax         column-label "Taxable!Non-taxable" format "->>>>,>>>,>>9.99"
with frame det_80 width 80 down.

/* SS - 20060602.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame det_80:handle).
*/
/* SS - 20060602.1 - E */

form
   typedesc    column-label "Tax Type!Description"
   l-taxdesc   column-label "Tax!Description"
   l-taxclass  column-label "Tax!Class"
   taxusage    column-label "Tax!Usage"
   taxtotal    column-label "Tax!Amount"
   taxpercnt   column-label "Tax!Rate"
   taxbase     column-label "Taxable!Sales"     format "->>>>,>>>,>>9.99"
   l-nontax    column-label "Non-Taxable!Sales" format "->>>>,>>>,>>9.99"
with frame det_132 width 132 down.

/* SS - 20060602.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame det_132:handle).
*/
/* SS - 20060602.1 - E */

assign
   gtm_taxbase_old = taxbase:format
   gtm_taxtot_old  = taxtotal:format
   gtm_nontax_old  = nontax:format.

find first txc_ctrl no-lock no-error.

{&TXDETRP1-P-TAG3}
if not txc_detrp
then do:
   /* PRINT ONLY IF FLAG = TRUE */
   undo_txdetrp = false.
   return.
end.
{&TXDETRP1-P-TAG4}

/* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */
{&TXDETRP1-P-TAG1}

if lookup(tr_type,
    "20,21,22,23,24,25,26,27,28,29,40,41,42,43,44,45,46,47,48") <> 0 then
   ar_ap = false.

{&TXDETRP1-P-TAG2}

/* MOST USER DOCS ARE 80-COLUMN FORMAT : SET ONLY IF 132 COLUMNS ARE NEEDED */
mainloop:
do on endkey undo, leave:

   /* ACCUMULATE TAX DETAILS */
   if l_control = 1 or l_control = 2
   then do:
      {txdetrpa.i}
   end.

   /* SET UP CURRENCY DEPENDENT FORMATS       */
   /* SET UP TAXBASE FORMAT FOR FRAME DET_132 */
   gtm_taxbase_fmt = gtm_taxbase_old.

   {gprun.i ""gpcurfmt.p"" "(input-output gtm_taxbase_fmt,
        input rndmthd)"}

   taxbase:format in frame det_132 = gtm_taxbase_fmt.

   /* SET UP TAXTOTAL FORMAT FOR FRAMES DET_80 & DET_132 */
   gtm_taxtot_fmt = gtm_taxtot_old.

   {gprun.i ""gpcurfmt.p"" "(input-output gtm_taxtot_fmt,
        input rndmthd)"}

   taxtotal:format in frame det_80 = gtm_taxtot_fmt.
   taxtotal:format in frame det_132 = gtm_taxtot_fmt.

   /* SET UP NONTAX FORMAT FOR FRAMES DET_80 & DET_132 */
   gtm_nontax_fmt = gtm_nontax_old.

   {gprun.i ""gpcurfmt.p"" "(input-output gtm_nontax_fmt,
        input rndmthd)"}

   /* DISPLAY TAX DETAILS */
   if l_control = 2 or l_control = 3
   then do:
      /* SS - 20060602.1 - B */
      /*
      {txdetrpb.i}
      */
      {a6txdetrpb0101.i}
      /* SS - 20060602.1 - E */
   end.

   undo_txdetrp = false.

end. /* end mainloop do */

{wbrp04.i}