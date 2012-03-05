/* arfinupc.p - A/R CREATE FINANCE CHARGES SUBROUTINE                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.27 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 8.5      LAST MODIFIED: 05/28/96   BY:     jxz   *J0NL*         */
/* REVISION: 8.6      LAST MODIFIED: 01/08/97   BY:     bkm   *H0QK*         */
/*                                   01/23/97   BY:     bjl   *K01G*         */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/*                                   04/01/97   BY: *J1MG* Robin McCarthy    */
/*                                   05/05/97   BY: *K0CX* E. Hughart        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/02/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/03/00   BY: *N0VV* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.26     BY: Vandna Rohira         DATE: 01/16/02  ECO: *M1TC*  */
/* $Revision: 1.27 $    BY: Rajiv Ramaiah         DATE: 03/05/02  ECO: *N1BN*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARFINUPC.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arfinupc_p_1 "As Of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_3 "Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_4 "Amt Subject!to Finance Chg"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_7 "Days!Charged"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_8 "Last Run Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_11 "Finance!Charge"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_13 "Grace Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_14 "Less Unapplied!Credit"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_16 "Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinupc_p_17 "Summary Only"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}
{gldydef.i}
{gldynrm.i}

define input parameter p_ex_rate  like ar_ex_rate  no-undo.
define input parameter p_ex_rate2 like ar_ex_rate2 no-undo.

define shared variable rndmthd                     like rnd_rnd_mthd.
define shared variable last_run_date               as date
   label {&arfinupc_p_8}.
define shared variable as_of_date                  as date
   label {&arfinupc_p_1}.
define shared variable eff_date                    like ar_effdate.
define shared variable gracedays                   as integer
   label {&arfinupc_p_13}.
define shared variable intrate                     as decimal
   format ">>>9.99%".
define shared variable currency                    like ar_curr.
define shared variable cm_recid                    as recid.
define shared variable ref                         like glt_ref.
define shared variable batch                       like ar_batch.
define shared variable undo_all                    like mfc_logical.
define shared variable jrnl                        like glt_ref.
define shared variable customer_gets_a_finance_chg as logical.
define shared variable include_prev_fin_chgs       as logical.
define shared variable summary_only                as logical
   label {&arfinupc_p_17} initial no.
define shared variable min_fin_chg                 as decimal
   format ">>>>,>>9.99".

define variable entity                  like ar_entity.
define variable gl_sum                  like mfc_logical initial no.
define variable type                    like ar_type     format "X(12)".
define variable finance_chg             as decimal       format ">>>>,>>9.99"
   column-label {&arfinupc_p_11}.
define variable days_overdue            as integer       format ">>>9"
   column-label {&arfinupc_p_7}.
define variable unapplied_credits_total as decimal
   format "->>,>>>,>>9.99".
define variable customer_finance_chg    like finance_chg.
define variable open_ref                as decimal
   format "->>,>>>,>>9.99"
   column-label {&arfinupc_p_3}.
define variable to_apply                as decimal.
define variable ardate                  like ar_effdate.
define variable acct                    like ar_acct.
define variable sub                     like ar_sub.
define variable cc                      like ar_cc.
define variable dr_amt                  as decimal
   format "->>>,>>>,>>>.99".
define variable cr_amt                  as decimal
   format "->>>,>>>,>>>.99".
define variable arnbr                   like ar_nbr.
define variable ar-amt-to-apply         like ar_amt.
define variable due-date                like ar_due_date.
define variable amt-due                 like ar_amt.
define variable amt-open                like ar_amt.
define variable base_amt                like ar_amt.
define variable curr_amt                like glt_curr_amt.
define variable ard_recno               as recid.
define variable mc-error-number         like msg_nbr no-undo.
define variable l_ref_label             as character no-undo.
define variable l_type_label            as character no-undo.

{&ARFINUPC-P-TAG1}

define buffer cr_ar_mstr   for ar_mstr.
define buffer armstr       for ar_mstr.

for first gl_ctrl
   fields (gl_ar_acct gl_ar_cc gl_ar_sub
           gl_fin_acct gl_fin_cc gl_fin_sub)
   no-lock:
end. /* FOR FIRST gl_ctrl */

for first cm_mstr
   fields (cm_addr cm_ar_acct cm_ar_cc
           cm_ar_sub cm_balance)
   where recid(cm_mstr) = cm_recid
   no-lock:
end. /* FOR FIRST cm_mstr */

detailloop:
do transaction on error undo,leave:

   for each ar_mstr no-lock
       where ar_bill = cm_addr
         and ar_open
         and (not ar_type = "D" or ar_draft)  /* ONLY APPROVED DRAFTS */
         and ar_amt - ar_applied > 0
         and (ar_due_date + gracedays <= as_of_date
         or  (ar_due_date = ? and
         ar_date + gracedays <= as_of_date))
         and (include_prev_fin_chgs or ar_type <> "F")
         and ar_contested = no
         and ar_curr = currency
         use-index ar_bill_open
         break by ar_entity
      with frame c title (getFrameTitle("OVERDUE_ITEMS",17)) color
         normal down width 132:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
      if daybooks-in-use
      then
         {gprun.i ""gldydft.p""
            "(input ""AR"",
              input ""F"",
              input ar_entity,
              output dft-daybook,
              output daybook-desc)"}

      if first-of (ar_entity)
      then do:

         /* VERIFY OPEN GL PERIOD FOR SITE ENTITY */
         {gpglef2.i &module  = ""AR""
                    &entity  = ar_entity
                    &date    = eff_date
                    &loop    = "detailloop" }

         if not summary_only
         then do with frame enty:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame enty:handle).
            display
               skip(1)
               ar_entity
            with frame enty side-labels no-box.
         end. /* IF NOT summary_only */

         /* FIND AND REPORT OPEN CREDITS */
         assign
            customer_finance_chg    = 0
            unapplied_credits_total = 0.

         for each cr_ar_mstr no-lock
             where ar_bill = cm_addr
               and ar_open
               and ar_amt - ar_applied < 0
               and ar_curr = currency
               and ar_entity = ar_mstr.ar_entity
               use-index ar_bill_open
               break by ar_bill
            with frame b title
               (getFrameTitle("UNAPPLIED_PAYMENTS_AND_CREDITS",39))
               color normal width 132 down:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            type = "".

            if ar_type = "M"
            then
               type = getTermLabel("MEMO",12).
            else
            if ar_type = "I"
            then
               type = getTermLabel("INVOICED",12).
            else
            if ar_type = "F"
            then
               type = getTermLabel("FINANCE_CHARGE",12).
            else
            if ar_type = "D"
            then
               type = getTermLabel("DRAFT",12).
            else
            if ar_type = "P"
            then
               type = getTermLabel("PAYMENT",12).

            open_ref = 0 - (ar_amt - ar_applied).
            if not summary_only
            then
               display
                  ar_nbr
                  type column-label {&arfinupc_p_16}
                  ar_due_date
                  (0 - ar_amt)  @ ar_amt
                  (0 - ar_applied) @ ar_applied
                  open_ref.
            unapplied_credits_total = unapplied_credits_total
                                      - (ar_amt - ar_applied).

            if last (ar_bill)
            then do with frame b:
               /* DISPLAY SUBTOTAL OF CREDITS */
               if not summary_only
               then do:
                  down 1.
                  display "--------------" @ open_ref.
                  down 1.
                  display unapplied_credits_total @ open_ref.
               end. /* IF NOT summary_only */
            end. /* IF LAST (ar_bill) */

         end.  /* CREDIT SEARCH */

      end.  /* IF FIRST (debit) ar_entity */

      type = "".

      if ar_type = "M"
      then
         type = getTermLabel("MEMO",12).
      else
      if ar_type = "I"
      then
         type = getTermLabel("INVOICED",12).
      else
      if ar_type = "F"
      then
         type = getTermLabel("FINANCE_CHARGE",12).
      else
      if ar_type = "D"
      then
         type = getTermLabel("DRAFT",12).
      else
      if ar_type = "P"
      then
         type = getTermLabel("PAYMENT",12).

      /* DETERMINE AMOUNT PAST DUE BASED ON CREDIT TERMS */
      for first ct_mstr
         fields (ct_code ct_dating ct_due_date
                 ct_due_days ct_due_inv)
         where ct_code = ar_cr_terms
         no-lock:
      end. /* FOR FIRST ct_mstr */
      if available ct_mstr and
         ct_dating = yes
      then do:
         ar-amt-to-apply = ar_applied.

         for each ctd_det
            where ctd_code = ar_cr_terms
            no-lock
            use-index ctd_cdseq:

            for first ct_mstr
               fields (ct_code ct_dating ct_due_date
                       ct_due_days ct_due_inv)
               where ct_code = ctd_date_cd
               no-lock:
            end. /* FOR FIRST ct_mstr */
            if available ct_mstr
               then do:
               {&ARFINUPC-P-TAG2}
               if (ct_due_inv = 1)
               then
                  due-date  = ar_date + ct_due_days.
               else
                  due-date = date((month(ar_date) + 1) modulo 12
                             + if month(ar_date) = 11 then 12 else 0, 1,
                               year(ar_date)
                             + if month(ar_date) >= 12 then 1 else 0)
                             + integer(ct_due_days)
                             - if ct_due_days <> 0 then 1 else 0.
               if ct_due_date <> ?
               then
                  due-date = ct_due_date.
               {&ARFINUPC-P-TAG3}

               /*CALCULATE BREAK DOWN OF INVOICE BY DUE DATES*/
               amt-due = ar_amt * (ctd_pct_due / 100).

               /* ROUND PER DOC CURRENCY RNDMTHD */

               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output amt-due,
                    input rndmthd,
                    output mc-error-number)"}
               if ar-amt-to-apply >= amt-due
               then
                  assign
                     amt-open        = 0
                     ar-amt-to-apply = ar-amt-to-apply - amt-due.
               else do:
                  assign
                     amt-open        = amt-due - ar-amt-to-apply
                     ar-amt-to-apply = 0
                     to_apply        = min(amt-open,unapplied_credits_total)
                     open_ref        = amt-open  - to_apply.

                  if due-date < as_of_date
                  then do:
                     assign
                        days_overdue = min(as_of_date - last_run_date,
                                           as_of_date - due-date)
                        finance_chg = open_ref * (days_overdue / 365) *
                                      (intrate / 100).

                     /* ROUND PER DOC CURRENCY RNDMTHD */

                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output finance_chg,
                          input rndmthd,
                          output mc-error-number)"}

                     /*DISPLAY THIS SEGMENT*/
                     if not summary_only
                     then do:
                        display
                           ar_nbr
                           type     column-label {&arfinupc_p_16}
                           due-date
                           amt-open format "->>,>>>,>>9.99"
                                    column-label {&arfinupc_p_3}
                           to_apply format "->>,>>>,>>9.99"
                                    column-label {&arfinupc_p_14}
                           open_ref format "->>,>>>,>>9.99"
                                    column-label {&arfinupc_p_4}
                           days_overdue
                           finance_chg
                        with frame c.
                        down 1 with frame c.
                     end. /* IF NOT summary */

                     assign
                        customer_finance_chg    = customer_finance_chg
                                                  + finance_chg.
                        unapplied_credits_total = unapplied_credits_total
                                                  - to_apply.
                  end. /* IF due-date ... */
               end. /* ELSE DO */
            end. /* IF AVAILABLE ct_mstr */

         end. /* FOR EACH ctd_det */
      end. /* ct_dating = YES */

      else do:   /*dating = no*/
         assign
            open_ref     = ar_amt - ar_applied
            to_apply     = min(open_ref,unapplied_credits_total)
            open_ref     = open_ref - to_apply
            ardate       = ar_due_date
            ardate       = if ardate = ? then ar_date else ardate
            days_overdue = min(as_of_date - last_run_date,
                               as_of_date - ardate)
            finance_chg = open_ref * (days_overdue / 365) * (intrate / 100).

         /* ROUND PER DOC CURRENCY RNDMTHD */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output finance_chg,
              input rndmthd,
              output mc-error-number)"}
         if not summary_only
         then
            display
               ar_nbr
               type     column-label {&arfinupc_p_16}
               ar_due_date @ due-date
               ar_amt - ar_applied
                        format "->>,>>>,>>9.99" @ amt-open
               to_apply format "->>,>>>,>>9.99"
                        column-label {&arfinupc_p_14}
               open_ref format "->>,>>>,>>9.99"
                        column-label {&arfinupc_p_4}
               days_overdue
               finance_chg
            with frame c.

         assign
            customer_finance_chg    = customer_finance_chg + finance_chg
            unapplied_credits_total = unapplied_credits_total - to_apply.
      end. /* ELSE DO */

      if last-of (ar_entity) and
         customer_finance_chg <> 0
      then do:
         if customer_finance_chg < min_fin_chg
         then
            customer_finance_chg = min_fin_chg.

         assign
            acct   = cm_ar_acct
            sub    = cm_ar_sub
            cc     = cm_ar_cc
            entity = ar_entity.
            if acct = ""
         then
            assign
               acct = gl_ar_acct
               sub  = gl_ar_sub
               cc   = gl_ar_cc.

         /* CREATE THE A/R DEBIT ITEM */
         do for armstr:
            create armstr.
            assign
               ar_acct     = acct
               ar_sub      = sub
               ar_cc       = cc
               ar_entity   = entity
               ar_amt      = customer_finance_chg
               ar_base_amt = ar_amt  /*IF FOREIGN AMT, CONV TO BASE LATER*/
               ar_batch    = batch
               ar_bill     = cm_addr
               ar_date     = eff_date
               ar_due_date = eff_date
               ar_effdate  = eff_date
               ar_ship     = ar_bill
               ar_cust     = ar_bill
               ar_type     = "F"
               ar_curr     = currency
               ar_dy_code  = dft-daybook.

            if currency <> base_curr
            then do:

               /* GET EXCHANGE RATE */
               {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input currency,
                    input base_curr,
                    input ar_ex_ratetype,
                    input eff_date,
                    output ar_ex_rate,
                    output ar_ex_rate2,
                    output ar_exru_seq,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               end. /* IF mc-error-number <> 0 */

               /*COMPUTE BASE EQUIV OF ar_amt AND STORE IN ar_base_amt */
               /* AND STORE IT IN ar_base_amt.                         */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input ar_amt,
                    input true, /* ROUND */
                    output ar_base_amt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
               end. /* IF mc-error-number <> 0 */
            end. /* IF currency <> base_curr */

            {mfnctrl.i arc_ctrl arc_memo armstr ar_nbr ar_nbr}
            assign
               arnbr  = ar_nbr
               ardate = ar_date.

            /* CREATE BATCH MASTER IF FIRST OF BATCH AND UPDATE*/
            find ba_mstr
               where ba_module = "AR"
               and   ba_batch  = batch
               exclusive-lock no-error.

            assign
               ba_total  = ba_total + armstr.ar_amt
               ba_ctrl   = ba_ctrl + armstr.ar_amt
               ba_status = "".

         end. /* DO FOR armstr */

         /* CREATE THE FINANCE CHARGE CREDIT DETAIL */
         create ard_det.
         assign
            ard_nbr     = arnbr
            ard_acct    = gl_fin_acct
            ard_sub     = gl_fin_sub
            ard_cc      = gl_fin_cc
            ard_entity  = ar_entity
            ard_amt     = customer_finance_chg
            ard_type    = "F"
            ard_dy_code = dft-daybook
            ard_dy_num  = nrm-seq-num
            ard_recno   = recid(ard_det).

         for first ac_mstr
            fields (ac_code ac_desc)
            where ac_code = ard_acct
            no-lock:
         end. /* FOR FIRST ac_mstr */
         if available ac_mstr
         then
            ard_desc = ac_desc.

         /* CONVERT TO BASE TO STORE IN GL*/
         assign
            base_amt = customer_finance_chg
            curr_amt = customer_finance_chg.

         if ar_curr <> base_curr
         then do:

            /*USE EXCH RATE FROM eff_date NOT ORIG DATE*/

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */

            /* USE CURRENT EXCHANGE RATE TO CALCULATE BASE AMOUNT       */
            /* MODIFIED THIRD  PARAMETER FROM ar_ex_rate  TO p_ex_rate  */
            /* AND      FOURTH PARAMETER FROM ar_ex_rate2 TO p_ex_rate2 */

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_curr,
                 input base_curr,
                 input p_ex_rate,
                 input p_ex_rate2,
                 input base_amt,
                 input true, /* ROUND */
                 output base_amt,
                 output mc-error-number)"}.

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
            end. /* IF mc-error-number <> 0 */
         end. /* IF ar_curr <> base_curr */
         else
            curr_amt = 0.

         assign
            l_ref_label  = getTermLabel("UNPOSTED",18)
            l_type_label = getTermLabel("FINANCE_CHARGE",11).

         /* ADDED DAYBOOK PARAMETER TO MFGLTW.I STATEMENTS */
         /* DEBIT A/R */

         {mfgltw.i
            &acct=acct
            &sub=sub
            &cc=cc
            &entity=ar_entity
            &project=""""
            &ref=l_ref_label
            &date=eff_date
            &type=l_type_label
            &docnbr=cm_addr
            &amt=base_amt
            &curramt=curr_amt
            &daybook=dft-daybook}

         /* CREDIT FINANCE CHARGES */

         {mfgltw.i
            &acct=gl_fin_acct
            &sub=gl_fin_sub
            &cc=gl_fin_cc
            &entity=ar_entity
            &project=""""
            &ref=l_ref_label
            &date=eff_date
            &type=l_type_label
            &docnbr=cm_addr
            &amt="- base_amt"
            &curramt="- curr_amt"
            &daybook=dft-daybook}

         if not summary_only
         then do:
            down 1.
            display "-----------" @ finance_chg.
            down 1.
            display
               arnbr @ ar_nbr
               getTermLabel("FINANCE_CHARGE",12) @ type
               ardate @ due-date
               customer_finance_chg
               format ">>>>,>>9.99" @ finance_chg.
         end. /* IF NOT summary_only */
         else do with frame d:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame d:handle).
            display
               arnbr
               ar_entity
               ardate
               customer_finance_chg format ">>>>,>>9.99"
            with frame d down.
         end. /* ELSE */

         /* UPDATE CUSTOMER BALANCE */
         cm_balance = cm_balance + customer_finance_chg.

      end. /* IF LAST ar_entity */

      if last-of (ar_entity) and
         customer_finance_chg = 0 and
         not summary_only
      then
         put (dynamic-function('getTermLabelFillCentered' in h-label,
            input "NO_FINANCE_CHARGE_FOR_THIS_ENTITY",
            input 40,
            input "*"))  format "x(40)".

   end. /* FOR EACH ar_mstr */
end. /* detailloop */
