/* porctrl2.i - PURCHASE ORDER RECEIPTS TRAILER                               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.23.1.1 $                                                          */
/*                                                                            */
/*                                                                            */
/* REVISION: 7.4            CREATED:           06/22/93   BY: JJS *H010*      */
/*                                             07/06/93   BY: JJS *H024*      */
/*                                             07/14/93   BY: bcm *H035*      */
/*                                             07/28/93   BY: bcm *H042*      */
/*                                             04/12/94   BY: bcm *H334*      */
/*                                             04/12/94   BY: dpm *H074*      */
/*                                             09/08/94   BY: bcm *H509*      */
/*                                             11/17/94   BY: bcm *GO37*      */
/*                                             11/30/94   BY: bcm *H606*      */
/*                                             06/01/95   BY: tvo *H0BJ*      */
/*                                             08/09/95   BY: jym *H0FH*      */
/*                                             01/17/96   BY: rxm *H0J4*      */
/* REVISION: 8.5           MODIFIED:           10/13/95   BY: taf *J053*      */
/* REVISION: 8.5           MODIFIED:           02/14/96   BY: rxm *H0JJ*      */
/* REVISION: 8.6           MODIFIED:           11/25/96   BY: jzw *K01X*      */
/* REVISION: 8.6      LAST MODIFIED: 05/06/97   BY: *H0YT* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 03/22/99   BY: *J39B* Santosh Rao        */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 09/15/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 05/26/00   BY: Strip/Beautify:  3.0      */
/* REVISION: 9.1      LAST MODIFIED: 06/10/00   BY: *L0Z4* Abhijeet Thakur    */
/* Revision: 1.18    BY: Jack Rief      DATE: 06/13/00 ECO: *N0DK*            */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Revision: 1.20      BY: Zheng Huang    DATE: 10/10/00 ECO: *N0SQ*          */
/* Revision: 1.21      BY: Manisha Sawant        DATE: 08/16/02  ECO: *N1RB*  */
/* Revision: 1.22      BY: Dan Herman            DATE: 08/21/02  ECO: *P0GD*  */
/* Revision: 1.23      BY: Vandna Rohira         DATE: 04/28/03  ECO: *N1YL*  */
/* $Revision: 1.23.1.1 $     BY: Manish Dani           DATE: 06/24/03  ECO: *P0VZ*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{pxmaint.i}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

define new shared variable undo_txdetrp   like mfc_logical.

define shared variable rndmthd        like rnd_rnd_mthd.
define shared variable maint          like mfc_logical no-undo.
define shared variable receivernbr    like prh_receiver.
define shared variable eff_date       like glt_effdate.
define shared variable tax_tr_type    like tx2d_tr_type no-undo.
define shared variable fiscal_id      like prh_receiver.
define shared variable po_recno       as   recid.
define shared variable fiscal_rec     as   logical initial false.

define variable ext_actual     like pod_pur_cost               no-undo.
define variable tax_lines      like tx2d_line     initial 0    no-undo.
define variable found_modified like mfc_logical.
define variable switch_id      like prh_receiver               no-undo.
define variable recalc         like mfc_logical   initial true no-undo.
define variable page_break     as   integer       initial 10   no-undo.
define variable col-80         as   logical       initial true no-undo.
define variable sign           as   decimal                    no-undo.

{pocurvar.i }
{txcurvar.i }
{potrldef.i }
{gpcrnd.i}

for first txc_ctrl
   fields (txc__qad03)
   no-lock:
end. /* FOR FIRST txc_ctrl */

/* LOCK THE RECORD */
if maint
then
   find po_mstr
      where recid(po_mstr) = po_recno
   exclusive-lock no-error.

/* PRINTING - DON'T LOCK THE RECORD */
else
   for first po_mstr
      fields (po_ap_acct   po_ap_sub    po_ap_cc  po_cls_date po_curr
              po_del_to    po_duty_type po_fob    po_frt      po_fsm_type
              po_nbr       po_prepaid   po_print  po_rev      po_serv_chg
              po_shipvia   po_spec_chg  po_stat   po_tax_date po_tax_pct)
      where recid(po_mstr) = po_recno no-lock:
   end. /* FOR FIRST PO_MSTR */

/**** FORMS ****/

if not maint
then do:
   assign
      tax_edit_lbl = ""
      undo_txdetrp = true.

   /* ADDED SIXTH INPUT PARAMETER '' AND SEVENTH INPUT     */
   /* PARAMETER yes TO ACCOMMODATE THE LOGIC INTRODUCED IN */
   /* txdetrpa.i FOR DISPLAYING THE APPROPRIATE CURRENCY   */
   /* AMOUNT.                                              */

   {gprun.i  ""txdetrp.p""
             "(input tax_tr_type,
               input receivernbr,
               input po_nbr,
               input col-80,
               input page_break,
               input '',
               input yes)" }

   if undo_txdetrp = true
   then
      undo, leave.

   if page-size - line-counter < page_break
   then
      page.

   do while page-size - line-counter > page_break:
      put skip(1).
   end. /* DO WHILE page-size - line-counter > page_break: */

   put "-----------------------------------------"
      + "-----------------------------------------" format "x(80)".
end. /* if not MAINT */

taxloop:
do on endkey undo, leave:
   /*** GET TOTALS FOR LINES ***/

   if not maint
   then do:
      /* GET TAX DATE TO PRINT ON RECEIVER OR RETURN DOCUMENT */

      for first tx2d_det
         fields (tx2d_edited tx2d_effdate tx2d_line tx2d_nbr
                 tx2d_ref    tx2d_trl     tx2d_tr_type)
         where tx2d_ref     = receivernbr
         and   tx2d_nbr     = po_nbr
         and   tx2d_tr_type = tax_tr_type
         no-lock:
      end. /* FOR FIRST TX2D_DET */

      if available tx2d_det
      then
         eff_date = tx2d_effdate.
   end. /* IF NOT maint */

   tax_date = eff_date.

   {pxrun.i &PROC = 'calculateExtendedTotals' &PROGRAM = 'porcxr.p'
            &PARAM = "(input po_nbr,
                       input receivernbr,
                       input rndmthd,
                       input tax_tr_type,
                       output lines_total,
                       output taxable_amt,
                       output nontaxable_amt)"
            &CATCHERROR = true
            &NOAPPERROR = true
   }

   /* THIS WOULD BE THE ERROR WHERE A rnd_mstr WAS NOT FOUND.  PREVIOUSLY THE */
   /* CALL TO gpcrnd INSIDE gpcrnd.i EXECUTED THE MESSAGE AND LEAVE           */
   /* STATEMENTS.                                                             */
   if return-value = {&APP-ERROR-RESULT}
   then
      leave.

   if fiscal_rec
   then
      switch_id = fiscal_id .

   else
      switch_id = receivernbr.

   {pxrun.i &PROC = 'calculateOrderAndTaxTotal' &PROGRAM = 'porcxr.p'
            &PARAM = "(input po_nbr,
                       input tax_tr_type,
                       input switch_id,
                       input tax_lines,
                       input-output lines_total,
                       input-output taxable_amt,
                       output tax_total,
                       output order_amt)"
            &CATCHERROR = true
            &NOAPPERROR = true
   }

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame potot:handle).

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
      tax_edit_lbl when ( maint )
      tax_edit     when ( maint )
      ""           when (not maint) @ tax_edit
   with frame potot.

   undo_trl2 = false.

end. /* TAXLOOP */

if  maint
and (not batchrun)
then
   do on endkey undo, leave:
      {gpwait.i &INCLUDEPAUSE=YES}
   end. /* DO ON ENDKEY */

hide frame potot no-pause.
