/* pomttrld.p - PURCHASE ORDER TRAILER - FOR MAINT MODE                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.3.2.21 $                                                      */
/*                                                                            */
/* REVISION: 7.4        CREATED: 02/12/96   BY: *H0JJ* rxm                    */
/* REVISION: 7.4  LAST MODIFIED: 05/31/96   BY: *H0LC* las                    */
/* REVISION: 8.6  LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan             */
/* REVISION: 8.6E LAST MODIFIED: 03/02/00   BY: *L0SH* Santosh Rao            */
/* Revision: 1.3.2.2     BY: Jeff Wootton        DATE: 03/06/00  ECO: *N059*  */
/* Revision: 1.3.2.3     BY:Pat Pigatti          DATE: 08/14/00  ECO: *N0L4*  */
/* Revision: 1.3.2.6   BY:Larry leeth            DATE: 08/30/00  ECO: *N0QQ*  */
/* Revision: 1.3.2.8   BY: Tiziana Giustozzi     DATE: 07/29/02  ECO: *P09N*  */
/* Revision: 1.3.2.9   BY: Tiziana Giustozzi     DATE: 09/11/02  ECO: *P0DR*  */
/* Revision: 1.3.2.10  BY: Karan Motwani         DATE: 09/28/02  ECO: *M20N*  */
/* Revision: 1.3.2.12       BY:Andrea Suchankova DATE:10/17/02 ECO: *N13P*    */
/* Revision: 1.3.2.13       BY:Mamata Samant     DATE:01/23/03 ECO: *N23T*    */
/* Revision: 1.3.2.16  BY: Vandna Rohira DATE:04/28/03 ECO: *N1YL* */
/* Revision: 1.3.2.18  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Revision: 1.3.2.19  BY: Rajaneesh S.       DATE: 01/08/04 ECO: *P1GK* */
/* $Revision: 1.3.2.21 $  BY: Manish Dani        DATE: 09/20/04 ECO: *P2L3* */


/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/12  ECO: *xp002*  */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE - FROM N08T IN POMTTRL2.I */
{pxmaint.i}

/* DEFINE ROUND VARIABLES REQUIRED FOR PURCHASE ORDERS & RTS */
{pocurvar.i}
/* DEFINE ROUND VARIABLES REQUIRED FOR TAX CALCULATIONS */
{txcurvar.i}
/* PURCHASE ORDER TRAILER FIELD DEFINITIONS */
{potrldef.i}
{apconsdf.i}

/* NEW SHARED VARIABLE(S) */
define new shared variable undo_txdetrp like mfc_logical.
/* L_TXCHG IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
/* THIS IS FROM N08T IN POMTTRL2.I                                 */
define new shared variable l_txchg like mfc_logical initial no.

/* SHARED VARIABLES */
define shared variable po_recno         as recid.
define shared variable rndmthd          like rnd_rnd_mthd.
define shared variable l_include_retain like mfc_logical no-undo.

/* LOCAL VARIABLES */
define variable tax_tr_type like tx2d_tr_type initial "20".
define variable tax_nbr     like tx2d_nbr initial "".
define variable all_lines   like tx2d_line initial 0.
define variable recalc      like mfc_logical initial true.
/* USED IN JAVA, BUT NOT IN CHARACTER, NEEDED ONLY FOR OUTPUT */
/* OF PROCEDURE CALL TO calculateOrderTotal. */
define variable dummyTaxTotal as decimal no-undo.
define variable use-log-acctg as logical    no-undo.
define variable ref-type      like lacd_internal_ref_type no-undo.

/* DEFINES VARIABLES IN PROGRAMS THAT CALL TXCALC PROGRAMS */
{txcalvar.i}

define variable l_yn             like mfc_logical     no-undo.
define variable l_tax_total      as   decimal         no-undo.
define variable l_nontax_amt     like tx2d_nontax_amt no-undo.

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* Purchase Order API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
{popoit01.i}

{mftdit01.i}  /*Tax api temp tables*/
{mftxit01.i}

for first txc_ctrl
   fields( txc_domain txc__qad03)
    where txc_ctrl.txc_domain = global_domain no-lock:
end. /* FOR FIRST txc_ctrl */

if c-application-mode = "API" then do on error undo, return:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
             "(output ApiMethodHandle,
               output ApiProgramName,
               output ApiMethodName,
               output apiContextString)"}

   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrder.
   run getPurchaseOrderRecord in ApiMethodHandle
      (buffer ttPurchaseOrder).

end.  /* If c-application-mode = "API" */

for first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
end.

for first po_mstr where recid(po_mstr) = po_recno
   exclusive-lock:
end.

{pxrun.i &PROC='getTaxTypeTaxNbr' &PROGRAM='popoxr.p'
   &PARAM="(input po_blanket,
     input po_fsm_type,
     output tax_nbr,
     output tax_tr_type)"
   &NOAPPERROR=true
   &CATCHERROR=true}

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}


taxloop:
do on endkey undo, leave:
   {pxrun.i &PROC='getTaxDate' &PROGRAM='popoxr.p'
      &PARAM="(input po_tax_date,
        input po_due_date,
        input po_ord_date,
        output tax_date)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
   if {pxfunct.i &FUNCTION='isTaxEdited' &PROGRAM='txtxxr.p'
      &PARAM="input po_nbr, input po_blanket, input tax_tr_type"}
   then do:
      /* MESSAGE #917 - PREVIOUS TAX VALUES EDITED; RECALCULATE? */
      {pxmsg.i
         &MSGNUM=917
         &ERRORLEVEL={&WARNING-RESULT}
         &CONFIRM=recalc}
   end.

   l_nontax_amt = 0.
   for first tx2d_det
      fields( tx2d_domain tx2d_cur_nontax_amt tx2d_edited tx2d_line   tx2d_nbr
             tx2d_nontax_amt     tx2d_ref    tx2d_tottax tx2d_trl tx2d_tr_type)
       where tx2d_det.tx2d_domain = global_domain and  tx2d_ref        = po_nbr
        and tx2d_tr_type    = tax_tr_type
        and tx2d_nontax_amt <> 0
   no-lock:
      l_nontax_amt = tx2d_nontax_amt.
   end. /* FOR FIRST tx2d_det */

   /* CALCULATE THE TAX AMOUNT BEFORE TXTXXR.P CALCULATES THE NEW */
   /* TAXES SO AS TO COMPARE IF THE TAX AMOUNT HAS BEEN CHANGED  */

   /* TOTAL TAX TOTALS */
   {pxrun.i &PROC='calculateOrderTotal' &PROGRAM='popoxr.p'
      &PARAM="(input rndmthd,
        input tax_tr_type,
        input po_nbr,
        input tax_nbr,
        input all_lines,
        input l_include_retain,
        output lines_total,
        output nontaxable_amt,
        output order_amt,
        output taxable_amt,
        output l_tax_total,
        output dummyTaxTotal)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   if recalc then do:
      /* THE POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT */
      /* CREATING QUANTUM REGISTER */
      /* CALCULATE TAX FOR ALL LINES AND STORE IN TX2D_DET */
      {pxrun.i &PROC='calculateTax' &PROGRAM='txtxxr.p'
         &PARAM="(input tax_tr_type,
           input po_nbr,
           input tax_nbr,
           input all_lines,
           input no,
           input no, /* Retain Edited Taxes */
           output result-status)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if use-log-acctg and po_tot_terms_code <> "" then do:

         ref-type = {&TYPE_PO}.
         for each pod_det
               fields( pod_domain pod_nbr pod_part pod_line pod_um pod_site
               pod_qty_ord)
                where pod_det.pod_domain = global_domain and  pod_nbr = po_nbr
            no-lock:

            {gprunmo.i
               &program=""lapotax.p""
               &module="LA"
               &param="""(input ref-type,
                 input pod_nbr,
                 input tax_nbr,
                 input pod_line,
                 input pod_qty_ord)"""}

         end. /* for each pod_det */

      end. /* if use-log-acctg */

   end.

   /* TOTAL TAX TOTALS */
   {pxrun.i &PROC='calculateOrderTotal' &PROGRAM='popoxr.p'
      &PARAM="(input rndmthd,
        input tax_tr_type,
        input po_nbr,
        input tax_nbr,
        input all_lines,
        input l_include_retain,
        output lines_total,
        output nontaxable_amt,
        output order_amt,
        output taxable_amt,
        output tax_total,
        output dummyTaxTotal)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   /* EDIT TRAILER, INIT, CALC EXTENDED, */
   /* TOTAL, SET CR., DISP TOTS          */
   do on endkey undo taxloop, leave:
      pause 0.
      /* SET EXTERNAL LABELS - FROM N08T IN POMTTRL2.I */
      setFrameLabels(frame potot:handle).
      if c-application-mode <> "API"
      then do:

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
            tax_edit_lbl
            tax_edit
         with frame potot.

      end. /* IF c-application-mode <> "API" */

      do with frame pomtd:
         /* SET EXTERNAL LABELS - FROM N08T IN POMTTRL2.I */
         setFrameLabels(frame pomtd:handle).
         if c-application-mode <> "API" then
            display
               po_rev
               po_print
               po_ap_acct
               po_ap_sub
               po_ap_cc
               po_shipvia
               po_del_to
               po_prepaid
               po_stat
               po_cls_date
               po_fob
            with frame pomtd.
      end. /* do with */

      if c-application-mode <> "API"
      then do:
			looproger:   /*xp002*/ /*remove:F4,ESCÍË³ö*/
			do on  error undo looproger ,retry 
			   on endkey undo looproger ,retry:

				 update
					tax_edit with frame potot
				 editing:

					readkey.
					apply lastkey.
				 end. /* EDITING */
			end.  /*xp002*/
      end. /* If c-applicaiton-mode <> API*/
      else
         assign tax_edit = true.

      /* DO TAX DETAIL DISPLAY / EDIT HERE */
      if tax_edit then do:
         hide frame potot no-pause.
         hide frame pomtd no-pause.

         if c-application-mode = "API" then
         do:
            {gpttcp.i ttTaxDet
                      ttTransTaxAmount
                      "ttTaxDet.apiExternalKey =
                      ttPurchaseOrder.apiExternalKey"}
            run setTransTaxAmount in ApiMethodHandle
               (input table ttTransTaxAmount).
         end.

         /* ADDED po_curr,po_ex_ratetype,po_ex_rate,po_ex_rate2  */
         /* AND tax_date AS SIXTH, SEVENTH, EIGTH, NINTH         */
         /* AND TENTH INPUT PARAMETER RESPECTIVELY.              */

         {gprun.i ""txedit.p""
            "(input  tax_tr_type,
              input  po_nbr,
              input  tax_nbr,
              input  all_lines, /* ALL LINES  */
              input  po_tax_env,
              input  po_curr,
              input  po_ex_ratetype,
              input  po_ex_rate,
              input  po_ex_rate2,
              input  tax_date,
              output tax_total)"}

         if c-application-mode <> "API" then do:
            view frame potot.
            view frame pomtd.
         end.   /*if c-application-mode <> "API"*/
      end.

      /* CALCULATE TOTALS */
      {pxrun.i &PROC='calculateOrderTotal' &PROGRAM='popoxr.p'
         &PARAM="(input rndmthd,
           input tax_tr_type,
           input po_nbr,
           input tax_nbr,
           input all_lines,
           input l_include_retain,
           output lines_total,
           output nontaxable_amt,
           output order_amt,
           output taxable_amt,
           output tax_total,
           output dummyTaxTotal)"
         &NOAPPERROR=true
         &CATCHERROR=true}

   end.    /* end if maint block */

   if c-application-mode <> "API"
   then do:

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
      with frame potot.

   end. /* IF c-application-mode <> "API" */

   undo_trl2 = false.
end. /* TAXLOOP */
