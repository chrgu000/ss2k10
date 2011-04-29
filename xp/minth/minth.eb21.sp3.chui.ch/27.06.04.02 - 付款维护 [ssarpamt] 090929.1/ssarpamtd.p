/* arpamtd.p - AR PAYMENT MAINTENANCE DELETE                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.42 $                                                */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.4      LAST MODIFIED: 09/03/93   BY: wep *H105*              */
/*                                   11/04/94   by: srk *FS79*              */
/*                                   08/28/95   by: wjk *F0TX*              */
/*                                   12/13/95   by: mys *G1G7*              */
/* REVISION: 8.5      LAST MODIFIED: 01/13/96   by: ccc *J053*              */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   by: taf *J101*              */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00K* rup              */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L02L* Karel Groos      */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L01K* Jaydeep Parikh   */
/* REVISION: 8.6E     LAST MODIFIED: 03/23/99   BY: *L0DG* Jose Alex        */
/* REVISION: 8.6E     LAST MODIFIED: 04/20/99   BY: *L0CS* Geoff Schrepfer  */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/99   BY: *J3KD* Ranjit Jain      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 8.6E     LAST MODIFIED: 01/12/01   BY: *L17C* Jean Miller      */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *N0WP* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *H133*                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/*  Revision: 1.31      BY: Katie Hilbert    DATE: 04/01/01 ECO: *P002*     */
/*  Revision: 1.31      BY: Vihang Talwalkar DATE: 05/02/01 ECO: *M15J*     */
/*  Revision: 1.32      BY: Alok Thacker     DATE: 06/12/01 ECO: *M18Y*     */
/*  Revision: 1.33      BY: Hareesh V.       DATE: 06/13/02 ECO: *M1Z9*     */
/*  Revision: 1.34      BY: Hareesh V.       DATE: 09/12/02 ECO: *M209*     */
/*  Revision: 1.35      BY: Jose Alex        DATE: 10/10/02 ECO: *N1WN*     */
/* Revision: 1.36       BY: Geeta Kotian     DATE: 11/20/02 ECO: *N1ZL*     */
/* Revision: 1.37       BY: W.Palczynski     DATE: 05/13/03 ECO: *P0R8* */
/* Revision: 1.38       BY: Orawan S.        DATE: 05/20/03 ECO: *P0RX* */
/* Revision: 1.40       BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.41       BY: Orawan S.          DATE: 10/08/03 ECO: *P14R* */
/* $Revision: 1.42 $ BY: Shivganesh Hegde DATE: 06/15/04 ECO: *P24Y* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 080830.1 By: Bill Jiang */
/* SS - 090929.1 By: Bill Jiang */
/* SS - 100330.1  By: Roger Xiao */  /*参照ssapvomt.p修改,eco:091218.1,需求见call:ss-396,共四只程式全部需要修改*/










{mfdeclre.i}
{cxcustom.i "ARPAMTD.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arpamtd_p_1 "Amt to Apply"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* SS - 080830.1 - B */
define shared variable batch        like ar_batch.

DEFINE SHARED VARIABLE ref_glt LIKE glt_det.glt_ref.
DEFINE SHARED VARIABLE user1_glt LIKE glt_det.glt_user1.
DEFINE SHARED VARIABLE nbr_ar LIKE ar_mstr.ar_nbr.
/* SS - 080830.1 - E */

define new shared variable arbuff_recno as recid.

define shared variable apply2_rndmthd like rnd_rnd_mthd.
define shared variable old_doccurr    like ar_curr.
define shared variable rndmthd  like rnd_rnd_mthd.
define shared variable undo_all like mfc_logical.
define shared variable base_amt like ar_amt.
define shared variable disc_amt like ar_amt.
define shared variable curr_amt like ar_amt.
define shared variable gain_amt like ar_amt.
define shared variable curr_disc like glt_curr_amt.
define shared variable base_det_amt like glt_amt.
define shared variable gltline like glt_line.
define shared variable jrnl like glt_ref.
define shared variable ar_recno as recid.
define shared variable ard_recno as recid.

define variable amt_to_apply like ap_amt label {&arpamtd_p_1}.
define variable tax_tr_type like tx2d_tr_type initial "19".
define variable tmpamt as decimal.
define variable tempdate like ar_effdate.
define variable oldmthd like rnd_rnd_mthd.
/*VARS. inv_to_base_rate, rate2 REPLACES ar__dec01 INTRODUCED IN ETK*/
define variable inv_to_base_rate  like ar_ex_rate      no-undo.
define variable inv_to_base_rate2 like ar_ex_rate2     no-undo.
define variable comb_exch_rate    like ar_ex_rate      no-undo.
define variable comb_exch_rate2   like ar_ex_rate2     no-undo.
define variable temp_exch_rate    like ar_ex_rate      no-undo.
define variable temp_exch_rate2   like ar_ex_rate2     no-undo.
define variable base_amt_disc     like ar_amt          no-undo.
define variable l_unrnd_appl_amt  like ar_applied      no-undo.
define variable l_rnd_appl_amt    like ar_base_applied no-undo.

{&ARPAMTD-P-TAG4}
define buffer armstr  for ar_mstr.
define buffer armstr_temp for ar_mstr.
{etvar.i}                /* COMMON EURO TOOLKIT VARIABLES */
{&ARPAMTD-P-TAG1}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
find ar_mstr where recid(ar_mstr) = ar_recno.
/*GET INVOICE OR MEMO TO BASE EXCHANGE RATE FROM qad_wkfl */
{argetwfl.i
   ar_mstr.ar_nbr
   inv_to_base_rate
   inv_to_base_rate2}

for each ard_det  where ard_det.ard_domain = global_domain and  ard_nbr =
ar_nbr:
   assign
      base_amt = - ard_amt
      gain_amt = 0
      curr_amt = - ard_amt
      curr_disc = - ard_disc
      base_det_amt = - (ard_amt + ard_disc).
   if ard_ref <> "" then do:
      /* FIND DOCUMENT (INVOICE, DRAFT, ETC) THIS ARD_DET IS FOR */
      find armstr  where armstr.ar_domain = global_domain and  armstr.ar_nbr =
      ard_ref.

      /* IF THE APPLY-TO DOCUMENT CURRENCY IS DIFFERENT FROM THE */
      /* CURRENCY OF THE PAYMENT (AR_CURR), WE NEED THE DOCUMENT  */
      /* CURRENCY'S ROUNDMETHOD ALSO.  NOTE: IF THE CURRENCIES    */
      /* ***ARE*** DIFFERENT, THE PAYMENT WILL BE IN BASE CURR    */
      if armstr.ar_curr <> ar_mstr.ar_curr then do:
         if armstr.ar_curr <> old_doccurr or
            old_doccurr = "" then do:
            oldmthd = rndmthd.

            if armstr.ar_curr = base_curr then
               rndmthd = gl_rnd_mthd.
            else do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input armstr.ar_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo_all = yes.
                  leave.
               end.
            end.
            assign
               apply2_rndmthd = rndmthd
               rndmthd = oldmthd
               old_doccurr = armstr.ar_curr.
         end.
      end.

      if armstr.ar_type = "D" and
         ( ar_dd_ex_rate <>  1 or
         ar_dd_ex_rate2 <> 1 or
         ar_dd_curr <> "" ) then do:
         /* DISCOUNTED DRAFT, USE DISC EXCHANGE RATE AND CURRENCY */
         /* PER DRAFT DISCOUNTING PROGRAM 'DMDISC.P', THE CURRENCY  */
         /* STORED IN AR_SLSPSN[1] MAY **ONLY*** BE AR_CURR OR BASE */
         /* USE NEW VARS DEFINED FOR DRAFT DISC CURRENCY & RATE */

         if armstr.ar_dd_curr   = base_curr
            then rndmthd = gl_rnd_mthd.
         else
         if armstr.ar_dd_curr   <> ar_mstr.ar_curr
            then next.
         assign
            ar_mstr.ar_ex_rate  = armstr.ar_dd_ex_rate
            ar_mstr.ar_ex_rate2 = armstr.ar_dd_ex_rate2
            ar_mstr.ar_curr     = armstr.ar_dd_curr.
      end.
   end.

   if base_curr <> ar_mstr.ar_curr then do:
      /* CONVERT TO BASE */
      if ard_ref <> ""
         /* INVOICE/MEMO ATTACHED                                */
         and base_amt = - ard_amt
         /* BASE_AMOUNT CAME FROM PAYMENT AMOUNT                 */
         and ard_cur_amt + ard_cur_disc <> 0
         /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT         */
         and ard_cur_amt + ard_cur_disc = armstr.ar_amt
         /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS                */
         /*  INVOICE/MEMO AMOUNT                                  */
         and inv_to_base_rate  = armstr.ar_ex_rate
         and inv_to_base_rate2 = armstr.ar_ex_rate2
         /*INVOICE TO BASE RATE ON PMT DATE EQUALS THAT ON INV DATE*/
      then do:
         assign base_amt_disc = armstr.ar_base_applied
                          /* USE INVOICE/MEMO BASE APPLIED AMOUNT */
            * ard_disc / (ard_amt + ard_disc).
                          /* IN SAME PROPORTION AS DISCOUNT       */
         /* ROUND TO BASE METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output base_amt_disc,
              input gl_ctrl.gl_rnd_mthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
         /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
         assign base_amt = - (armstr.ar_base_amt - base_amt_disc).
      end.
      else do:
         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input base_amt,
              input true, /* ROUND */
              output base_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.
      end.

      if ard_ref <> "" then do:
          /* INVOICE/MEMO ATTACHED                           */
         if base_det_amt = (-1) * (ard_amt + ard_disc)
            /* BASE_DET_AMOUNT CAME FROM PAYMENT AMOUNT     */
            and ard_cur_amt + ard_cur_disc <> 0
            /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT */
            and ard_cur_amt + ard_cur_disc = armstr.ar_amt
            /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS        */
            /*  INVOICE/MEMO APPLIED AMOUNT                  */
            then
            assign base_det_amt = - armstr.ar_base_amt.
                /* USE INVOICE/MEMO BASE AMOUNT              */
         else do:
            /* PAYMENT CURR -> BASE -> INV CURR -> BASE */
            /* CONVERT FROM FOREIGN TO BASE CURRENCY */

            /* First combine all the exchange rates, then convert. */
            {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
               "(input ar_mstr.ar_ex_rate,
                 input ar_mstr.ar_ex_rate2,
                 input inv_to_base_rate2,
                 input inv_to_base_rate,
                 output temp_exch_rate,
                 output temp_exch_rate2)"}

            {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
               "(input temp_exch_rate,
                 input temp_exch_rate2,
                 input armstr.ar_ex_rate,
                 input armstr.ar_ex_rate2,
                 output comb_exch_rate,
                 output comb_exch_rate2)"}

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input armstr.ar_curr,
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input base_det_amt,
                 input true, /* ROUND */
                 output base_det_amt,
                 output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
            end.
         end.  /* ELSE DO                 */
      end.     /* IF ARD_REF <> ""        */
      else do:
         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input base_det_amt,
              input true, /* ROUND */
              output base_det_amt,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.
      end.

   end.    /* IF BASE_CURR <> AR_MSTR.AR_CURR */
   /* UPDATE CURRENCY APPLICATION AMOUNTS */
   else if ard_ref <> "" then do:
      if armstr.ar_curr <> base_curr then do:

         /* CHANGED 6TH INPUT PARAMETER FROM FALSE TO */
         /* TRUE TO GET curr_amt AS A ROUNDED VALUE   */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input armstr.ar_curr,
              input base_curr,
              input inv_to_base_rate2,
              input inv_to_base_rate ,
              input - ard_amt,
              input true, /* ROUND */
              output curr_amt,
              output mc-error-number)"}.

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
         end. /* IF mc-error-number <> 0 */

         /* CHANGED 6TH INPUT PARAMETER FROM FALSE TO */
         /* TRUE TO GET curr_disc AS A ROUNDED VALUE  */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input armstr.ar_curr,
              input base_curr,
              input inv_to_base_rate2,
              input inv_to_base_rate ,
              input - ard_disc,
              input true, /* ROUND */
              output curr_disc,
              output mc-error-number)"}.

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
         end. /* IF mc-error-number <> 0 */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input armstr.ar_curr,
              input base_curr,
              input armstr.ar_ex_rate,
              input armstr.ar_ex_rate2,
              input (curr_amt + curr_disc),
              input true, /* ROUND */
              output base_det_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.
      end.   /* ARMSTR.AR_CURR <> BASE_CURR  */
   end.      /* ARD_REF <> ""                */

   if ard_ref <> "" then do:
      /* BACK OUT MEMO APPLIED */
      amt_to_apply = ard_amt + ard_disc.
      if armstr.ar_curr <> ar_mstr.ar_curr then
      do:
         /* FOREIGN TO BASE TO FOREIGN */

         {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
            "(input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input inv_to_base_rate2,
              input inv_to_base_rate,
              output comb_exch_rate,
              output comb_exch_rate2)"}

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input ar_mstr.ar_curr,
              input comb_exch_rate,
              input comb_exch_rate2,
              input amt_to_apply,
              input true, /* ROUND */
              output amt_to_apply,
              output mc-error-number)"}

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
         end.
         /* TO AVOID ROUNDING PROBLEMS USE ard_cur* FIELDS */
         if ard_det.ard_cur_amt + ard_det.ard_amt <> 0 then
               amt_to_apply = ard_det.ard_cur_amt + ard_det.ard_cur_disc.
      end.
      assign
         armstr.ar_applied = armstr.ar_applied - amt_to_apply
         l_unrnd_appl_amt  = amt_to_apply
         armstr.ar_open    = (armstr.ar_amt <> armstr.ar_applied).

      if armstr.ar_applied = 0 then armstr.ar_paid_date = ?.

      /* CHANGES MADE TO CONVERT amt_to_apply TO BASE CURRENCY */
      /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID    */
      /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.        */

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input armstr.ar_curr,
           input base_curr,
           input armstr.ar_ex_rate,
           input armstr.ar_ex_rate2,
           input l_unrnd_appl_amt,
           input true, /* ROUND */
           output l_rnd_appl_amt,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.

      armstr.ar_base_applied = armstr.ar_base_applied - l_rnd_appl_amt.

   end.

   {&ARPAMTD-P-TAG6}
   /* GET CUSTOMER RECORD FOR UPDATE */
   find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
   ar_mstr.ar_bill exclusive-lock.

   /* BACKOUT CUSTOMER BALANCE */
   if ard_type <> "N" then do:
      if ard_ref <> "" then do:

         /* FIX DESCRIBED IN ECO J2ML APPLIED BY L01K ON TOP OF
            THE ETK CHANGES OF ECO L00K -
            USE ORIGINAL INVOICE EXCHANGE RATE IN PLACE OF
            THE LATEST EXCHANGE RATE APPLICABLE ON PAYMENT DATE
            AND CONVERT THE FOREIGN AMOUNT FROM amt_to_apply.
            OLD LOGIC WORKS OK EXCEPT WHEN INV AND PMT CURR
            ARE SAME BUT THERE IS RATE FLUCTUATION BETWEEN
            THE TWO.
            ar_mstr.ar_ex_rate REPLACED WITH armstr.ar_ex_rate,
            ar_mstr.ar_ex_rate2 REPLACED WITH armstr.ar_ex_rate2.
            ard_amt + ard_disc REPLACED WITH amt_to_apply */
         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input armstr.ar_ex_rate,
              input armstr.ar_ex_rate2,
              input amt_to_apply,
              input true, /* ROUND */
              output tmpamt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.
         {&ARPAMTD-P-TAG8}
         cm_balance = cm_balance + tmpamt.
         end.   /* ARD_REF <> "" */
         else do:
            if ar_mstr.ar_curr <> base_curr then
            do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY             */

               /* PAYMENT EXCHANGE RATE SHOULD BE PASSED INSTEAD OF */
               /* INVOICE TO BASE RATE FOR UNAPPLIED PAYMENT        */

               /* MODIFIED THIRD PARAMETER FROM inv_to_base_rate TO */
               /* ar_mstr.ar_ex_rate AND FOURTH PARAMETER FROM      */
               /* inv_to_base_rate2 TO ar_mstr.ar_ex_rate2          */

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                    input base_curr,
                    input ar_mstr.ar_ex_rate,
                    input ar_mstr.ar_ex_rate2,
                    input (ard_amt + ard_disc),
                    input true,
                    output tmpamt,
                    output mc-error-number)"}.

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end.
               {&ARPAMTD-P-TAG8}
               cm_balance = cm_balance + tmpamt.
            end.
            else do:
               {&ARPAMTD-P-TAG8}
               cm_balance = cm_balance + ard_amt + ard_disc.
            end.
         end.
      end.  /* FOR EACH ARD_DET */
      {&ARPAMTD-P-TAG7}

      /* DELETE GL DETAIL POSTINGS */
      assign
         ar_recno = recid(ar_mstr)
         ard_recno = recid(ard_det).
      if available armstr then arbuff_recno = recid(armstr).
      undo_all = yes.

      {&ARPAMTD-P-TAG3}
      /* FIRST INPUT PARAMETER INDICATES REVERSAL AND SECOND INPUT */
      /* PARAMETER INDICATES THAT SEQUENCE NUMBER GERERATION WILL  */
      /* BE DELAYED                                                */
      {gprun.i ""arargl1.p""
         "(input true,
           input true)"}

      if undo_all then undo, leave.
      {&ARPAMTD-P-TAG2}

      /* DELETE TAX DETAIL */
      {gprun.i ""txdelete.p""
            "(input tax_tr_type,
              input ard_det.ard_nbr,
              input ard_det.ard_ref)"}

      {&ARPAMTD-P-TAG5}
      assign
         ar_mstr.ar_applied = ar_mstr.ar_applied - ard_amt
         l_unrnd_appl_amt   = ard_amt.

      /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY   */
      /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID */
      /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.     */

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input base_curr,
           input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input l_unrnd_appl_amt,
           input true, /* ROUND */
           output l_rnd_appl_amt,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.

      ar_mstr.ar_base_applied = ar_mstr.ar_base_applied - l_rnd_appl_amt.
      delete ard_det.
   end.
   /* DELETE EXCHANGE RATE USAGE (exru_usage) RECORDS */
   run delete_rate_usage_records.
   run delete_wkfl_record.
   /* SS - 080830.1 - B */
   /* SS - 090929.1 - B
   nbr_ar = ar_mstr.ar_bill.
   nbr_ar = nbr_ar + FILL(" ", 8 - LENGTH(nbr_ar)).
   nbr_ar = nbr_ar + ar_mstr.ar_check.
   {gprun.i ""ssgltrrefdocbd.p"" "(
      INPUT 'AR',
      INPUT 'P',
      INPUT nbr_ar,
      INPUT (BATCH),
      OUTPUT ref_glt,
      OUTPUT user1_glt
      )"}

   /* New reference number for document # */
   IF ref_glt <> "" THEN DO:
      {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
   END.
   SS - 090929.1 - E */
   /* SS - 090929.1 - B */
/* SS - 100330.1 - B 
   FIND FIRST arc_ctrl
      WHERE arc_domain = GLOBAL_domain
      NO-LOCK NO-ERROR.
   IF AVAILABLE arc_ctrl THEN DO:
      IF arc_sum_lvl = 3 THEN DO:
         nbr_ar = ar_mstr.ar_bill.
         nbr_ar = nbr_ar + FILL(" ", 8 - LENGTH(nbr_ar)).
         nbr_ar = nbr_ar + ar_mstr.ar_check.
         {gprun.i ""ssgltrrefdocbd.p"" "(
            INPUT 'AR',
            INPUT 'P',
            INPUT nbr_ar,
            INPUT (BATCH),
            OUTPUT ref_glt,
            OUTPUT user1_glt
            )"}

         /* New reference number for document # */
         IF ref_glt <> "" THEN DO:
            {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
         END.
      END.
   END.
   SS - 100330.1 - E */
/* SS - 100330.1 - B */
         nbr_ar = ar_mstr.ar_bill.
         nbr_ar = nbr_ar + FILL(" ", 8 - LENGTH(nbr_ar)).
         nbr_ar = nbr_ar + ar_mstr.ar_check.
         {gprun.i ""ssgltrrefdocbd.p"" "(
            INPUT 'AR',
            INPUT 'P',
            INPUT nbr_ar,
            INPUT (BATCH),
            OUTPUT ref_glt,
            OUTPUT user1_glt
            )"}

         /* New reference number for document # */
         IF ref_glt <> "" THEN DO:
            {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
         END.
/* SS - 100330.1 - E */
   /* SS - 090929.1 - E */
   /* SS - 080830.1 - E */
   delete ar_mstr.

   /* SET CUSTOMER'S LAST PAYMENT DATE EQUAL TO
   * AR_DATE OF MOST RECENT PAYMENT */
   if available cm_mstr then do:
      do for armstr_temp:
         tempdate = low_date.
         for each armstr_temp  where armstr_temp.ar_domain = global_domain and
               ar_bill = cm_addr and ar_type = "P":
            if ar_date > tempdate then
               tempdate = ar_date.
         end.
         if tempdate = low_date then tempdate = ?.
         cm_pay_date = tempdate.
      end.
   end. /* IF AVAILABLE CM_MSTR */

   undo_all = no.

   PROCEDURE delete_rate_usage_records:
/*  BEING CALLED UPON CTRL-D (DELETE) AND WHEN NO LINE DETAIL ENTERED */
      /* DELETE ANY EXCHANGE RATE USAGE (exru_usage) RECORDS */
      if ar_mstr.ar_exru_seq <> 0 then
      do:
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input ar_mstr.ar_exru_seq)"}
      end.
      if ar_mstr.ar_dd_exru_seq <> 0 then
      do:
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input ar_mstr.ar_dd_exru_seq)"}
      end.
   END PROCEDURE.

   PROCEDURE delete_wkfl_record:
      for first qad_wkfl fields( qad_domain qad_decfld[1] qad_decfld[2])
             where qad_wkfl.qad_domain = global_domain and  qad_key1 =
             "AR_MSTR" and qad_key2 = ar_mstr.ar_nbr:
      end.
      if available qad_wkfl then delete qad_wkfl.
   END PROCEDURE.
