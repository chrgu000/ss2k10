/* pomttrlc.p - PURCHASE ORDER TRAILER - FOR REPORT MODE                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.3.2.5 $                                                       */
/*                                                                            */
/* REVISION: 7.4      CREATED:       02/12/96   BY: rxm *H0JJ*                */
/* REVISION: 7.4   LAST MODIFIED:    05/31/96   BY: las *H0LC*                */
/* REVISION: 8.6   LAST MODIFIED:    05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E  LAST MODIFIED:    03/02/00   BY: *L0SH* Santosh Rao        */
/* Revision: 1.3.2.2  BY: Jeff Wootton   DATE: 03/06/00  ECO: *N059*          */
/* Revision: 1.3.2.3  BY:Pat Pigatti     DATE: 08/15/00  ECO: *N0L4*          */
/* Revision: 1.3.2.4  BY:Larry leeth     DATE: 08/30/00  ECO: *N0QQ*          */
/* $Revision: 1.3.2.5 $    BY: Manisha Sawant        DATE: 08/16/02  ECO: *N1RB*  */
/* $Revision: 1.3.2.5 $    BY: Micho Yang            DATE: 03/20/06  ECO: *SS - 20060320*  */
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
{pxmaint.i}

/* DEFINE ROUND VARIABLES REQUIRED FOR PURCHASE ORDERS & RTS */
{pocurvar.i}
/* DEFINE ROUND VARIABLES REQUIRED FOR TAX CALCULATIONS */
{txcurvar.i}
/* PURCHASE ORDER TRAILER FIELD DEFINITIONS */
{xxpotrldef.i}

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
define variable page_break  as integer        initial 20.
define variable tax_tr_type like tx2d_tr_type initial "20".
define variable tax_nbr     like tx2d_nbr     initial "".
define variable tax_lines   like tx2d_line    initial 0.

/* USED IN JAVA, BUT NOT IN CHARACTER, NEEDED ONLY FOR OUTPUT */
/* OF PROCEDURE CALL TO calculateOrderTotal.                  */
define variable dummyTaxTotal as decimal no-undo.

/* DEFINES VARIABLES IN PROGRAMS THAT CALL TXCALC PROGRAMS */
{txcalvar.i}

for first gl_ctrl
   no-lock:
end. /* FOR FIRST gl_ctrl */

for first po_mstr
   where recid(po_mstr) = po_recno
   exclusive-lock:
end. /* FOR FIRST po_mstr */

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

/*
{gprun.i  ""xxtxdetrp.p""
          "(input tax_tr_type,
            input po_nbr,
            input tax_nbr,
            input col-80,
            input page_break)" }

if undo_txdetrp = true
then
   undo, leave.
*/

if page-size - line-counter < page_break
then
   page.

do while page-size - line-counter > page_break:
   put skip(1).
end. /* DO WHILE page-size - line-counter ... */

put msg skip.
put "========================================="
   + "=========================================" format "x(80)".

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

   /* SET EXTERNAL LABELS - FROM N08T IN POMTTRL2.I */
   setFrameLabels(frame potot:handle).

   display
      /*
      nontaxable_amt   */
      po_curr
      lines_total
     /*  taxable_amt */
     /* tax_date */
      tax_total
      order_amt
     /* "" @ tax_edit */
   with frame potot.

   undo_trl2 = false.

end. /* TAXLOOP */
