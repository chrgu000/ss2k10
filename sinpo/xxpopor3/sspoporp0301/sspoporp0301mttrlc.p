/* pomttrlc.p - PURCHASE ORDER TRAILER - FOR REPORT MODE                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.3.2.10 $                                                       */
/*                                                                            */
/* REVISION: 7.4      CREATED:       02/12/96   BY: rxm *H0JJ*                */
/* REVISION: 7.4   LAST MODIFIED:    05/31/96   BY: las *H0LC*                */
/* REVISION: 8.6   LAST MODIFIED:    05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E  LAST MODIFIED:    03/02/00   BY: *L0SH* Santosh Rao        */
/* Revision: 1.3.2.2  BY: Jeff Wootton   DATE: 03/06/00  ECO: *N059*          */
/* Revision: 1.3.2.3  BY:Pat Pigatti     DATE: 08/15/00  ECO: *N0L4*          */
/* Revision: 1.3.2.4  BY:Larry leeth     DATE: 08/30/00  ECO: *N0QQ*          */
/* Revision: 1.3.2.5  BY: Manisha Sawant DATE: 08/16/02  ECO: *N1RB*          */
/* Revision: 1.3.2.6  BY:Vandna Rohira   DATE: 04/28/03  ECO: *N1YL*          */
/* Revision: 1.3.2.7  BY:Narathip W. DATE: 05/21/03 ECO: *P0S8* */
/* Revision: 1.3.2.9  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* $Revision: 1.3.2.10 $ BY: Manish Dani        DATE: 09/01/03 ECO: *P0VZ* */
/* $Revision: 1.3.2.10 $ BY: Bill Jiang        DATE: 04/11/08 ECO: *SS - 20080411.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20080411.1 - B */
{sspoporp0301.i}
/* SS - 20080411.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
/* EXTERNAL LABEL INCLUDE - FROM N08T IN POMTTRL2.I */
{gplabel.i}
{cxcustom.i "POMTTRLC.P"}
{pxmaint.i}

/* DEFINE ROUND VARIABLES REQUIRED FOR PURCHASE ORDERS & RTS */
{pocurvar.i}
/* DEFINE ROUND VARIABLES REQUIRED FOR TAX CALCULATIONS */
{txcurvar.i}
/* PURCHASE ORDER TRAILER FIELD DEFINITIONS */
{potrldef.i}

/* NEW SHARED VARIABLE(S) */
define new shared variable undo_txdetrp like mfc_logical.

/* L_TXCHG IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
/* THIS IS FROM N08T IN POMTTRL2.I                                 */
define new shared variable l_txchg like mfc_logical initial no.

/* SHARED VARIABLES */
define shared variable msg              as character format "X(60)".
define shared variable po_recno         as recid.
define shared variable rndmthd          like rnd_rnd_mthd.
define shared variable l_include_retain like mfc_logical no-undo.

/* LOCAL VARIABLES */
define variable col-80      as logical        initial true.
define variable page_break  as integer        initial 11.
define variable tax_tr_type like tx2d_tr_type initial "20".
define variable tax_nbr     like tx2d_nbr     initial "".
define variable tax_lines   like tx2d_line    initial 0.

/* USED IN JAVA, BUT NOT IN CHARACTER, NEEDED ONLY FOR OUTPUT */
/* OF PROCEDURE CALL TO calculateOrderTotal.                  */
define variable dummyTaxTotal as decimal no-undo.
{&POMTTRLC-P-TAG1}

/* DEFINES VARIABLES IN PROGRAMS THAT CALL TXCALC PROGRAMS */
{txcalvar.i}

for first gl_ctrl
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

for first txc_ctrl
   fields( txc_domain txc__qad03)
    where txc_ctrl.txc_domain = global_domain no-lock:
end. /* FOR FIRST txc_ctrl */

for first po_mstr
   where recid(po_mstr) = po_recno
   exclusive-lock:
end. /* FOR FIRST po_mstr */

{&POMTTRLC-P-TAG2}
{pxrun.i &PROC='getTaxTypeTaxNbr' &PROGRAM='popoxr.p'
   &PARAM="(input po_blanket,
            input po_fsm_type,
            output tax_nbr,
            output tax_tr_type)"
   &NOAPPERROR=true
   &CATCHERROR=true}

assign
   tax_edit_lbl = ""
   undo_txdetrp = true.

/* SS - 20080411.1 - B */
/*
/* ADDED SIXTH INPUT PARAMETER '' AND SEVENTH INPUT     */
/* PARAMETER yes TO ACCOMMODATE THE LOGIC INTRODUCED IN */
/* txdetrpa.i FOR DISPLAYING THE APPROPRIATE CURRENCY   */
/* AMOUNT.                                              */

{&POMTTRLC-P-TAG9}
{gprun.i  ""txdetrp.p""
          "(input tax_tr_type,
            input po_nbr,
            input tax_nbr,
            input col-80,
            input page_break,
            input '',
            input yes)" }
{&POMTTRLC-P-TAG10}

if undo_txdetrp = true
then
   undo, leave.

{&POMTTRLC-P-TAG3}
if page-size - line-counter < page_break
then
   page.
{&POMTTRLC-P-TAG4}

do while page-size - line-counter > page_break:
   put skip(1).
end. /* DO WHILE page-size - line-counter ... */

{&POMTTRLC-P-TAG5}
put msg skip.
put "-----------------------------------------"
   + "-----------------------------------------" format "x(80)".
{&POMTTRLC-P-TAG6}
*/
/* SS - 20080411.1 - E */

taxloop:
do on endkey undo, leave:
   {pxrun.i &PROC='getTaxDate' &PROGRAM='popoxr.p'
      &PARAM="(input po_tax_date,
               input po_due_date,
               input po_ord_date,
               output tax_date)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   /* TOTAL TAX TOTALS */
   {pxrun.i &PROC='calculateOrderTotal' &PROGRAM='popoxr.p'
      &PARAM="(input rndmthd,
               input tax_tr_type,
               input po_nbr,
               input tax_nbr,
               input tax_lines,
               input l_include_retain,
               output lines_total,
               output nontaxable_amt,
               output order_amt,
               output taxable_amt,
               output tax_total,
               output dummyTaxTotal)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   /* SS - 20080411.1 - B */
   /*
   /* SET EXTERNAL LABELS - FROM N08T IN POMTTRL2.I */
   setFrameLabels(frame potot:handle).

   {&POMTTRLC-P-TAG7}
   if txc__qad03
   then
      display
         l_nontaxable_lbl
         nontaxable_amt
         l_taxable_lbl
         taxable_amt
         with frame potot.
   else
      display
         "" @ l_nontaxable_lbl
         "" @ nontaxable_amt
         "" @ l_taxable_lbl
         "" @ taxable_amt
         with frame potot.

   display
      po_curr
      lines_total
      tax_date
      tax_total
      order_amt
      "" @ tax_edit
   with frame potot.
   {&POMTTRLC-P-TAG8}
   */
   CREATE ttsspoporp03012.
   
   ASSIGN
      ttsspoporp03012_po_nbr = po_nbr
      .

   if txc__qad03 THEN DO:
      ASSIGN
         ttsspoporp03012_nontaxable_amt = nontaxable_amt
         ttsspoporp03012_taxable_amt = taxable_amt
         .
   END.

   ASSIGN
      ttsspoporp03012_po_curr = po_curr
      ttsspoporp03012_lines_total = lines_total
      ttsspoporp03012_tax_date = tax_date
      ttsspoporp03012_tax_total = tax_total
      ttsspoporp03012_order_amt = order_amt
      .
   /* SS - 20080411.1 - E */

   undo_trl2 = false.

end. /* TAXLOOP */
