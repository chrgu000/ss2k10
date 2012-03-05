/* arpamtpl.p - AR PAYMENT MAINT GENERAL INTERNAL PROCEDURES PROGRAM          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                         */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 8.6            CREATED: 12/03/97   by: B. Gates *K1DG*           */
/* REVISION: 8.6E     LAST MODIFIED: 04/18/98   by: *L00K*                    */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *K1SX* Prashanth Narayan  */
/* REVISION: 8.6E     LAST MODIFIED: 09/24/98   BY: *K1DR* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 01/14/99   BY: *J37X* Prashanth Narayan  */
/* REVISION: 8.6E     LAST MODIFIED: 02/01/99   BY: *L0CS* Geoff Schrepfer    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 01/25/00   BY: *N06R* Bud Woolsey        */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* REVISION: 8.6E     LAST MODIFIED: 01/13/01   BY: *L17C* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0WP* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.18 $    BY: Alok Thacker   DATE: 06/12/01 ECO: *M18Y*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
arpamtpl.p - AR PAYMENT MAINT GENERAL INTERNAL PROCEDURES PROGRAM
             WAS WRITTEN TO CONTAIN PROCEDURES USED FOR AUTO PAYMENT
             APPLICATION BUT CAN BE USED TO CONTAIN ANY OTHER PROCEDURES
             USED BY AR PAYMENT MAINT.
*/

{mfdeclre.i}
{cxcustom.i "ARPAMTPL.P"}

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}

define variable mc-error-number like msg_nbr no-undo.
define variable comb_exch_rate like ar_ex_rate no-undo.
define variable comb_exch_rate2 like ar_ex_rate2 no-undo.
define variable temp_exch_rate like ar_ex_rate no-undo.
define variable temp_exch_rate2 like ar_ex_rate2 no-undo.

/*THE FOLLOWING SHARED VARIABLES ARE NEEDED TO PASS DATA TO arargl1.p*/
define new shared variable apply2_rndmthd like rnd_rnd_mthd.
define new shared variable ar_recno as recid.
define new shared variable arbuff_recno as recid.
define new shared variable ard_recno    as recid.
define new shared variable base_amt     like ar_amt.
define new shared variable base_det_amt like ar_amt.
define new shared variable curr_amt     like ar_amt.
define new shared variable curr_disc    like glt_curr_amt.
define new shared variable disc_amt     like ar_amt.
define new shared variable gain_amt     like ar_amt.
define new shared variable gltline like glt_line.
define new shared variable jrnl like glt_ref.
define new shared variable undo_all as logical.

PROCEDURE get_invcmemo_rounding_method:
   define input parameter p_invcmemo_curr like ar_curr no-undo.
   define output parameter p_rndmthd like gl_rnd_mthd no-undo.

   define variable rndmthd like rnd_rnd_mthd no-undo.

   find first gl_ctrl no-lock.

   if p_invcmemo_curr = base_curr then
      p_rndmthd = gl_rnd_mthd.
   else do:

      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input p_invcmemo_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3 }
      end.
      p_rndmthd = rndmthd.
   end.
END PROCEDURE.

PROCEDURE create_payment_detail:
   define input parameter p_payment_ar_nbr like ar_nbr no-undo.
   define input parameter p_invcmemo_ar_nbr like ar_nbr no-undo.
   define input parameter p_ar_acct like ar_acct no-undo.
   define input parameter p_ar_sub like ar_sub no-undo.
   define input parameter p_ar_cc like ar_cc no-undo.
   define input parameter p_ar_entity like ar_entity no-undo.
   define input parameter p_ar_type like ar_type no-undo.
   define input parameter p_applied like ar_amt no-undo.
   define input parameter p_discount like ar_amt no-undo.
   define input parameter p_dft_daybook like dy_dy_code no-undo.
   define input parameter p_nrm_seq_num like glt_dy_num no-undo.
   define output parameter p_ard_recno as recid no-undo.

   define parameter buffer invcmemo_ar_mstr for ar_mstr.
   define parameter buffer payment_ar_mstr  for ar_mstr.

   define variable inv_to_base_rate like ar_ex_rate no-undo.
   define variable inv_to_base_rate2 like ar_ex_rate2 no-undo.

   /* GET INVOICE OR MEMO TO BASE EXCHNAGE RATE FROM qad_wkfl */
   {argetwfl.i
      payment_ar_mstr.ar_nbr
      inv_to_base_rate
      inv_to_base_rate2}

   create ard_det.

   assign
      ard_nbr    = p_payment_ar_nbr
      ard_ref    = p_invcmemo_ar_nbr
      ard_acct   = p_ar_acct
      ard_sub    = p_ar_sub
      ard_cc     = p_ar_cc
      ard_entity = p_ar_entity
      ard_type   = p_ar_type
      ard_amt    = p_applied
      ard_disc   = p_discount
      ard_dy_code = p_dft_daybook
      ard_dy_num  = p_nrm_seq_num
      .

   /*WHEN INV AND PMT CURR HAS EURO TRANSPARENCY, UPD ar_curr* ALSO*/
   if invcmemo_ar_mstr.ar_curr <> payment_ar_mstr.ar_curr then
   do:
      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      run get_invcmemo_rounding_method
         (input invcmemo_ar_mstr.ar_curr,
         output apply2_rndmthd).
      /* STORE INVOICE CURR EQUIVALENT IN ard_cur_amt */
      /* PMT CURR -> BASE -> INV CURR */

      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input payment_ar_mstr.ar_ex_rate,
           input payment_ar_mstr.ar_ex_rate2,
           input inv_to_base_rate2,
           input inv_to_base_rate,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input payment_ar_mstr.ar_curr,
           input invcmemo_ar_mstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input ard_amt,
           input true, /* ROUND */
           output ard_cur_amt,
           output mc-error-number)"}

      if mc-error-number <> 0 then
      do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.

      /* STORE INVOICE CURR EQUIVALENT IN ard_cur_disc */
      /* PMT CURR -> BASE -> INV CURR */

      /* COMBINE EXCHANGE RATES, THEN CONVERT CURRENCY. */
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input payment_ar_mstr.ar_ex_rate,
           input payment_ar_mstr.ar_ex_rate2,
           input inv_to_base_rate2,
           input inv_to_base_rate,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input payment_ar_mstr.ar_curr,
           input invcmemo_ar_mstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input ard_disc,
           input true, /* ROUND */
           output ard_cur_disc,
           output mc-error-number)"}

      if mc-error-number <> 0 then
      do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.

      /*TO AVOID ROUNDING DIFFERNCE, IF ard_cur_amt + ard_cur_disc*/
      /*EXCEEDS THE INVOICE VALUE, ADJUST ard_cur_amt.*/
      if invcmemo_ar_mstr.ar_amt - ( ard_cur_amt + ard_cur_disc) < 0
      then
         ard_cur_amt = ard_cur_amt - ( (ard_cur_amt + ard_cur_disc)
                     - invcmemo_ar_mstr.ar_amt ).

   end.

   if recid(ard_det) = -1 then.

   p_ard_recno = recid(ard_det).

   /* UPDATE THE APPLIED-TO DOCUMENT*/

   /*WHEN INV AND PMT CURR ARE DIFFERENT, ard_cur_amt/_disc CONTAINS */
   /*INVOICE CURRENCY AMOUNTS HENCE USE THEM INSTEAD OF ard_amt/_disc*/
   if invcmemo_ar_mstr.ar_curr = payment_ar_mstr.ar_curr then
      invcmemo_ar_mstr.ar_applied = invcmemo_ar_mstr.ar_applied
                                  + ard_amt + ard_disc.
   else
      invcmemo_ar_mstr.ar_applied = invcmemo_ar_mstr.ar_applied
                                  + ard_cur_amt + ard_cur_disc.

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   /* STORE BASE VALUE IN ar_base_applied */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input invcmemo_ar_mstr.ar_curr,
        input base_curr,
        input invcmemo_ar_mstr.ar_ex_rate,
        input invcmemo_ar_mstr.ar_ex_rate2,
        input invcmemo_ar_mstr.ar_applied,
        input true, /* ROUND */
        output invcmemo_ar_mstr.ar_base_applied,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
   end.

   /* UPDATE APPLIED FOR PAYMENT
   DO NOT UPDATE THE PAYMENT AR_MSTR RECORD HERE.
   THE APPLIED AMOUNT HAS ALREADY BEEN UPDATED IN ARSELON.I
   AND THIS WILL DOUBLE THE AR_APPLIED FIELD IF DONE HERE AS WELL*/

   if invcmemo_ar_mstr.ar_applied = 0 then
      invcmemo_ar_mstr.ar_paid_date = ?.
   else
      invcmemo_ar_mstr.ar_paid_date = payment_ar_mstr.ar_date.

   invcmemo_ar_mstr.ar_open =
      invcmemo_ar_mstr.ar_amt <> invcmemo_ar_mstr.ar_applied.
END PROCEDURE.

PROCEDURE calculate_tax_adjustment:

   define input parameter p_payment_appl_ard_recno as recid no-undo.
   define parameter buffer invcmemo_ar_mstr for ar_mstr.
   define parameter buffer payment_ar_mstr  for ar_mstr.

   define variable det_ex_rate like ar_ex_rate no-undo.
   define variable det_ex_rate2 like ar_ex_rate2 no-undo.
   define variable det_ex_ratetype like ar_ex_ratetype no-undo.
   define variable tax_tr_type like tx2d_tr_type initial "19" no-undo.
   define variable inv_type as character no-undo.
   define variable l_tax_date  like tx2_effdate no-undo.

   find ard_det where recid(ard_det) = p_payment_appl_ard_recno
      no-lock.

   /* GET THE TRANSACTION EXCHANGE RATE */

   assign
      det_ex_rate     = payment_ar_mstr.ar_ex_rate
      det_ex_rate2    = payment_ar_mstr.ar_ex_rate2
      det_ex_ratetype = payment_ar_mstr.ar_ex_ratetype
      l_tax_date      = payment_ar_mstr.ar_effdate.

   if ard_ref <> ""
   then
   assign
      det_ex_rate     = invcmemo_ar_mstr.ar_ex_rate
      det_ex_rate2    = invcmemo_ar_mstr.ar_ex_rate2
      det_ex_ratetype = invcmemo_ar_mstr.ar_ex_ratetype
      l_tax_date      = invcmemo_ar_mstr.ar_effdate.

   if ard_type = "I" then inv_type = "16".
   else
   if ard_type = "M" then inv_type = "18".

   /* CALCULATE TAX AMOUNT USING INVOICE/MEMO EXCHANGE RATE */
   /* WHEN DISCOUNT TAX AT PAYMENT IS SET TO YES            */

   if ard_ref <> "" and invcmemo_ar_mstr.ar_curr <> base_curr then do:
      for first tx2d_det
            fields(tx2d_ref tx2d_tr_type tx2d_tax_code)
            where tx2d_ref = ard_det.ard_ref and
            tx2d_tr_type = inv_type no-lock:
      end.
      if available tx2d_det then do:
         for first tx2_mstr fields(tx2_tax_code tx2_pmt_disc)
               where tx2_tax_code = tx2d_tax_code no-lock:
         end.
         if available tx2_mstr and tx2_pmt_disc then
         assign
            l_tax_date      = invcmemo_ar_mstr.ar_effdate
            det_ex_rate     = invcmemo_ar_mstr.ar_ex_rate
            det_ex_rate2    = invcmemo_ar_mstr.ar_ex_rate2
            det_ex_ratetype = invcmemo_ar_mstr.ar_ex_ratetype.
         release tx2_mstr.
         release tx2d_det.
      end.
   end. /* IF ard_ref <> "" ... */

   /*CALCULATE TAX ADJUSTMENT & CREATE DETAIL*/

   {gprun.i ""txcalc19.p""
      "(input  tax_tr_type,
        input  ard_det.ard_nbr, /*Payment detail reference*/
        input  ard_det.ard_ref, /*Payment application ref */
        input  0,               /* All Lines              */
        input  inv_type,
        input  payment_ar_mstr.ar_effdate,
        input  det_ex_rate,
        input  det_ex_rate2,
        input  det_ex_ratetype,
        input  if invcmemo_ar_mstr.ar_curr = payment_ar_mstr.ar_curr then
                   ard_det.ard_disc / invcmemo_ar_mstr.ar_amt
               else ard_det.ard_cur_disc / invcmemo_ar_mstr.ar_amt,
        input  l_tax_date
            )" }
END PROCEDURE.

PROCEDURE post_gl_transactions:
   define input parameter p_payment_ar_recno as recid no-undo.
   define input parameter p_payment_appl_ard_recno as recid no-undo.
   define input parameter p_payment_curr like ar_curr no-undo.
   /*MISLEADING NAMES p_payment_ex_rate, _rate2 - */
   /*THESE VARS RECEIVE INV/MEMO TO BASE CURRENCY EXCHANGE RATE */
   /*APPLICABLE ON PAYMENT DATE.*/
   define input parameter p_payment_ex_rate like ar_ex_rate no-undo.
   define input parameter p_payment_ex_rate2 like ar_ex_rate2 no-undo.
   /*MISLEADING NAMES p_inv_base_rate, _rate2 - */
   /*THESE VARS RECEIVE PAYMENT TO BASE CURRENCY EXCHANGE RATE */
   define input parameter p_inv_base_rate like ar_ex_rate no-undo.
   define input parameter p_inv_base_rate2 like ar_ex_rate2 no-undo.
   define input parameter p_payment_appl_amt like ard_amt no-undo.
   define input parameter p_payment_appl_disc_amt like ard_disc
      no-undo.
   define input parameter p_invcmemo_ar_recno as recid no-undo.
   /*VARIABLES p_invcmemo_ex_rate, _rate2 - */
   /*THESE VARS RECEIVE INV/MEMO TO BASE CURRENCY EXCHANGE RATE */
   /*FROM INV/MEMO RECORD */
   define input parameter p_invcmemo_ex_rate like ar_ex_rate no-undo.
   define input parameter p_invcmemo_ex_rate2 like ar_ex_rate2 no-undo.
   define input parameter p_apply2_rndmthd like rnd_rnd_mthd no-undo.
   define input parameter p_jrnl as character no-undo.
   define output parameter p_undo_all as log no-undo.

   define buffer invcmemo_ar_mstr for ar_mstr.

   find first gl_ctrl no-lock.

   find invcmemo_ar_mstr where
      recid(invcmemo_ar_mstr) = p_invcmemo_ar_recno
      no-lock no-error.

   assign
      ar_recno       = p_payment_ar_recno
      ard_recno      = p_payment_appl_ard_recno
      arbuff_recno   = p_invcmemo_ar_recno
      apply2_rndmthd = p_apply2_rndmthd
      base_amt       = p_payment_appl_amt
      base_det_amt   = p_payment_appl_amt + p_payment_appl_disc_amt
      gain_amt       = 0
      curr_amt       = p_payment_appl_amt
      curr_disc      = p_payment_appl_disc_amt
      undo_all       = true
      jrnl           = p_jrnl
      .

   if p_payment_curr <> base_curr then do:

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      /*FIELDS p_inv_base_rate, p_inv_base_rate2 HAS PAYMENT TO BASE */
      /*CURRENCY EXCHANGE RATES.                                    */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input p_payment_curr,
           input base_curr,
           input p_inv_base_rate,
           input p_inv_base_rate2,
           input base_amt,
           input true, /* ROUND */
           output base_amt,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.
      /* PAYMENT CURR -> BASE -> INV CURR -> BASE */
      /*FIELDS p_inv_base_rate, p_inv_base_rate2 HAS PAYMENT TO BASE */
      /*CURRENCY EXCHANGE RATES.                                     */
      /*FIELDS p_payment_ex_rate, p_payment_ex_rate2 HAS INV/MEMO TO */
      /*BASE CURRENCY EXCHANGE RATES.                                */

      /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input p_inv_base_rate,
           input p_inv_base_rate2,
           input p_payment_ex_rate2,
           input p_payment_ex_rate,
           output temp_exch_rate,
           output temp_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input temp_exch_rate,
           input temp_exch_rate2,
           input p_invcmemo_ex_rate,
           input p_invcmemo_ex_rate2,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input p_payment_curr,
           input base_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input base_det_amt,
           input true, /* ROUND */
           output base_det_amt,
           output mc-error-number)"}

      if mc-error-number <> 0 then
      do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.

   end.  /* if p_payment_curr <> base_curr then do: */

   {gprun.i ""arargl1.p"" "(input false)"} /* NOT A REVERSAL */
   p_undo_all = undo_all.
END PROCEDURE.

PROCEDURE update_customer_balance:

   define parameter buffer invcmemo_ar_mstr for ar_mstr.
   define input parameter p_payment_appl_ard_recno as recid no-undo.

   define variable tmpamt as decimal no-undo.

   find ard_det where recid(ard_det) = p_payment_appl_ard_recno
      no-lock.

   find cm_mstr where cm_addr = invcmemo_ar_mstr.ar_bill
      exclusive-lock.

   /* CONVERT FROM FOREIGN TO BASE CURRENCY. */
   /* FIELDS ar__dec01, ar__dec02 CONTAINS EXCHANGE RATE DEFINING */
   /* PAYMENT TO BASE CURRENCY RELATION.                          */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input invcmemo_ar_mstr.ar_curr,
        input base_curr,
        input invcmemo_ar_mstr.ar_ex_rate,
        input invcmemo_ar_mstr.ar_ex_rate2,
        input (ard_amt + ard_disc),
        input true, /* ROUND */
        output tmpamt,
        output mc-error-number)"}.
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
   end.

   cm_balance = cm_balance - tmpamt.

END PROCEDURE.

PROCEDURE create_payment_mstr:
   define input parameter p_arrecno    as recid.
   define input parameter p_batch      like ba_batch no-undo.
   define input parameter p_dft_daybook like dy_dy_code no-undo.
   define input parameter p_arnbr      like ar_nbr no-undo.
   define parameter buffer invcmemo_ar_mstr for ar_mstr.
   define parameter buffer payment_ar_mstr for ar_mstr.

   for first gl_ctrl
      fields (gl_cs_acct gl_cs_sub gl_cs_cc
              gl_term_acct gl_term_sub gl_term_cc)
      no-lock:
   end.
   for first bk_mstr fields(bk_code) no-lock
         where bk_curr = invcmemo_ar_mstr.ar_curr:
   end.

   create payment_ar_mstr.
   assign
      payment_ar_mstr.ar_nbr =
         string(invcmemo_ar_mstr.ar_bill,"X(8)") + string(p_arnbr)
      payment_ar_mstr.ar_bill      = invcmemo_ar_mstr.ar_bill
      payment_ar_mstr.ar_batch     = p_batch
      payment_ar_mstr.ar_date      = today
      payment_ar_mstr.ar_effdate   = today
      payment_ar_mstr.ar_cust      = invcmemo_ar_mstr.ar_bill
      payment_ar_mstr.ar_dy_code   = p_dft_daybook
      payment_ar_mstr.ar_check     = p_arnbr
      payment_ar_mstr.ar_type      = "P"
      payment_ar_mstr.ar_ex_rate   = 1
      payment_ar_mstr.ar_ex_rate2  = 1
      payment_ar_mstr.ar_curr      = invcmemo_ar_mstr.ar_curr
      payment_ar_mstr.ar_acct      = gl_cs_acct
      payment_ar_mstr.ar_sub       = gl_cs_sub
      payment_ar_mstr.ar_cc        = gl_cs_cc
      payment_ar_mstr.ar_disc_acct = gl_term_acct
      payment_ar_mstr.ar_disc_sub  = gl_term_sub
      payment_ar_mstr.ar_disc_cc   = gl_term_cc
      payment_ar_mstr.ar_entity    = invcmemo_ar_mstr.ar_entity
      payment_ar_mstr.ar_bank      = bk_code
      payment_ar_mstr.ar_amt       = - invcmemo_ar_mstr.ar_amt
      payment_ar_mstr.ar_applied   = - invcmemo_ar_mstr.ar_amt
      payment_ar_mstr.ar_base_amt  = - invcmemo_ar_mstr.ar_amt
      payment_ar_mstr.ar_open      = no
      payment_ar_mstr.ar_paid_date = today.
END PROCEDURE.

/* ADDED PROCEDURE TO GET THE NEXT JOURNAL REFERENCE */
/* THIS IS CALLED BEFORE ALL CALLS TO arargl1.p      */

PROCEDURE get_gl_ref:
   define input-output parameter jrnl as character no-undo.
   if jrnl = ""
   then do:
      /* GET NEXT JOURNAL REFERENCE NUMBER */
      {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
   end. /* IF jrnl = "" */
END PROCEDURE. /* PROCEDURE get_gl_ref */
