/* arsbpap.p  - SELFBILLING PAYMENT APPLICATION                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.29.1.10 $                                                   */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6E   CREATED      : 08/18/98     BY: *K1DR* Suresh Nayak       */
/* REVISION: 8.6E   LAST MODIFIED: 01/08/99     BY: *L0D2* Steve Nugent       */
/* REVISION: 8.6E   LAST MODIFIED: 01/29/99     BY: *K1Z7* Steve Nugent       */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99     BY: *N014* Paul Johnson       */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 08/11/00     BY: *N0KK* jyn                */
/* REVISION: 8.6E   LAST MODIFIED: 01/13/01     BY: *L17C* Jean Miller        */
/* Revision: 1.29.1.7       BY: Katie Hilbert    DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.29.1.8       BY: Alok Thacker     DATE: 08/28/01 ECO: *M1JD*   */
/* Revision: 1.29.1.9       BY: Jean Miller      DATE: 03/01/02 ECO: *N1BJ*   */
/* $Revision: 1.29.1.10 $    BY: Manjusha Inglay  DATE: 08/16/02 ECO: *N1QP*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */


{mfdtitle.i "2+ "}

define new shared variable h-arpamtpl as handle no-undo.
define new shared variable shared_bill_to like so_bill no-undo.

define variable ardrecno as recid no-undo.
define variable acct like ar_acct no-undo.
define variable amt_to_apply like ard_amt no-undo.
define variable archeck like ar_check no-undo.
define variable ardate like ar_date no-undo.
define variable ba_recno as recid no-undo.
define variable bactrl as decimal no-undo.
define variable bank like ar_bank no-undo.
define variable bankdesc like bk_desc no-undo format "x(30)".
define variable batch like ar_batch no-undo.
define variable bill_to like so_bill no-undo.
define variable cc like ar_cc no-undo.
define variable check_is_open as logical no-undo.
define variable ctrl_amt like sbi_ctrl_amt no-undo.
define variable curr like ar_curr no-undo.
define variable currency_rndmthd like rnd_rnd_mthd no-undo.
define variable daybook_desc like dy_desc no-undo.
define variable dy_code like ar_dy_code no-undo.
define variable eff_date like ar_effdate no-undo.
define variable entity like gl_entity no-undo.
define variable errors as logical no-undo.
define variable ex_rate like ar_ex_rate no-undo.
define variable ex_rate2 like ar_ex_rate2 no-undo.
define variable ex_exru_seq like ar_exru_seq no-undo.
define variable ex_ratetype like ar_ex_ratetype no-undo.
define variable inbatch like ar_batch no-undo.
define variable open_amt like ard_amt no-undo.
define variable w_jrnl like glt_ref no-undo.
define variable ok as logical no-undo.
define variable payment_ar_recno as recid no-undo.
define variable selfbill_curr like sbi_curr no-undo.
define variable selfbill_nbr like sbi_nbr no-undo.
define variable selfbill_total_for_inv_memo like sbid_amt no-undo.
define variable selfbill_line_amt as decimal no-undo.
define variable sub like ar_sub no-undo.
define variable tempdate as date no-undo.
define variable tmpamt as decimal no-undo.
define variable total_amt_to_apply like ard_amt no-undo.
define variable transmission_nbr like sbi_xmission no-undo.
define variable unapplied_amt like ard_amt no-undo.
define variable unapplied_ref_nbr as character no-undo.
define variable not_successful as logical no-undo.
define variable undo_tran as logical no-undo.
define variable dummy_fixrate like so_fix_rate no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable yn like mfc_logical no-undo.
define variable AN_INVOICE as character no-undo initial "I".
define variable A_MEMO as character no-undo initial "M".
define variable A_PAYMENT as character no-undo initial "P".
define variable AN_UNAPPLIED_ENTRY as character no-undo initial "U".
define variable A_FINANCE_CHARGE as character no-undo initial "F".
define variable A_DRAFT as character no-undo initial "D".

{gpglefdf.i}    /*VARIABLE DEFINITIONS FOR gpglef.p*/
{gldydef.i new} /*VARIABLE DEFINITIONS FOR DAYBOOKS*/
{gldynrm.i new} /*VARIABLE DEFINITIONS FOR NRM*/

define workfile w_selfbill no-undo
   field w_selfbill_nbr like sbi_nbr.

form
   bill_to             colon 38
   ad_name             no-label
   transmission_nbr    colon 38
   selfbill_nbr        colon 38
   skip(1)
   sbi_ctrl_amt        colon 38
   skip(1)
   archeck             colon 38
   batch               colon 38
   ardate              colon 38
   eff_date            colon 38
   bank                colon 38
   bankdesc            no-label
   curr                colon 38
   entity              colon 38
   acct                colon 38
   sub                 no-label
   cc                  no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*LOAD THE PAYMENT MAINT PROCESS LOGIC PROGRAM USED FOR AUTO APPLY*/
{gprun.i ""arpamtpl.p"" "persistent set h-arpamtpl"}

/*GET THE GL CONTROL RECORD*/
find first gl_ctrl no-lock.

/* GET NEXT JOURNAL REFERENCE NUMBER */
do transaction:
   {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref w_jrnl}
end.

/*OBTAIN DEFAULT DAYBOOK*/
{gprun.i ""gldydft.p""
   "(input ""AR"",
     input ""P"",
     input gl_entity,
     output dy_code,
     output daybook_desc)"}

mainloop:
repeat transaction:
   /*GET BILL-TO, SELFBILL NBR, TRANSMISSION NBR FROM USER*/

   run get_bill_trans_selfbill(output undo_tran).
   if undo_tran then undo, leave.

   /*VALIDATE BILL-TO*/

   find cm_mstr where cm_addr = bill_to exclusive-lock no-error.

   if not available cm_mstr then do:
      /*NOT A VALID CUSTOMER*/
      {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
      next-prompt bill_to with frame a.
      undo, retry.
   end.

   find ad_mstr where ad_addr = cm_addr no-lock.
   display ad_name with frame a.

   /*VALIDATE EITHER A SELFBILL OR TRANSMISSION, NOT BOTH*/

   if selfbill_nbr <> "" and transmission_nbr <> "" then do:
      /*MUST SPECIFY A SELF-BILL OR TRANSMISSION NUMBER, NOT BOTH*/
      {pxmsg.i &MSGNUM=4332 &ERRORLEVEL=3}
      undo, retry.
   end.

   if selfbill_nbr > "" then do:
      /*VALIDATE SELF-BILL NBR*/
      find sbi_mstr where sbi_bill = bill_to
                      and sbi_nbr = selfbill_nbr
      no-lock no-error.

      if not available sbi_mstr then do:
         /*SELF-BILL DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=4333 &ERRORLEVEL=3}
         undo, retry.
      end.

      /*VALIDATE PAYMENT NOT ALREADY APPLIED*/
      if sbi_check > "" then do:
         run mfmsg02
            (input 4337, input 3, input sbi_nbr + ' ' + sbi_check).
         /*PAYMENT HAS ALREADY BEEN APPLIED.  SELF-BILL, CHECK:*/
         sbi_check.
         undo, retry.
      end.

      /*VALIDATE THE SELFBILL'S ROUND METHOD*/
      run get_invcmemo_rounding_method in h-arpamtpl
         (input sbi_curr,
          output currency_rndmthd).

      if currency_rndmthd = ? then do:
         run mfmsg02
            (input 4335, input 3, input sbi_curr).
         /*NO ROUNDING METHOD FOUND FOR CURRENCY*/
         undo, retry.
      end.

      /*VALIDATE CONTROL TOTAL EQUAL TO ENTRY TOTAL*/

      if sbi_amt <> sbi_ctrl_amt then do:
         run mfmsg02
            (input 4305, input 3, input sbi_nbr).
         /*SELF-BILL AMT TOTAL NOT EQUAL TO AMT CONTROL TOTAL*/
         undo, retry.
      end.

      selfbill_curr = sbi_curr.

      display sbi_ctrl_amt with frame a.

   end.

   else do:

      /*VALIDATE TRANSMISSION NBR*/
      find first sbi_mstr where sbi_bill = bill_to
         and sbi_xmission = transmission_nbr
      no-lock no-error.

      if not available sbi_mstr then do:
         /*NO SELF-BILLS IN THIS TRANSMISSION GROUP*/
         {pxmsg.i &MSGNUM=4336 &ERRORLEVEL=3}
         undo, retry.
      end.

      /*VALIDATE PAYMENT NOT ALREADY APPLIED*/

      errors = false.

      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_xmission = transmission_nbr
           and sbi_check > ""
      break by sbi_check:
         if first-of(sbi_check) then do:
            run mfmsg02
               (input 4337, input 3, input sbi_nbr + ' ' + sbi_check).
            /*PAYMENT HAS ALREADY BEEN APPLIED.  SELF-BILL, CHECK:*/
            errors = true.
         end.
      end.

      if errors then undo, retry.

      /* VALIDATE CONTROL TOTAL EQUALS ENTRY TOTAL FOR ALL
         SELFBILLS IN TRANSMISSION GROUP*/

      errors = false.

      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_xmission = transmission_nbr:

         /*CONTROL TOTAL HAS TO EQUAL ENTRY TOTAL*/
         if sbi_amt <> sbi_ctrl_amt then do:
            run mfmsg02
               (input 4305, input 3, input sbi_nbr).
            /*SELF-BILL AMT TOTAL NOT EQUAL TO AMT CONTROL TOTAL*/
            errors = true.
         end.

      end.

      if errors then undo, retry.

      /*VALIDATE THE SELFBILL'S ROUND METHOD*/

      errors = false.

      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_xmission = transmission_nbr:

         run get_invcmemo_rounding_method in h-arpamtpl
            (input sbi_curr, output currency_rndmthd).

         if currency_rndmthd = ? then do:
            run mfmsg02
               (input 4335, input 3, input sbi_curr).
            /*NO ROUNDING METHOD FOUND FOR CURRENCY*/
            errors = true.
         end.
      end.

      if errors then undo, retry.

      /* GET SUM OF CONTROL AMTS FOR ALL SELFBILLS
         IN TRANSMISSION GROUP*/

      ctrl_amt = 0.

      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_xmission = transmission_nbr:
         ctrl_amt = ctrl_amt + sbi_ctrl_amt.
      end.

      /*VALIDATE THAT ALL SELFBILLS HAVE SAME CURRENCY*/
      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_xmission = transmission_nbr
      break by sbi_curr:

         if last-of(sbi_curr) then do:

            selfbill_curr = sbi_curr.
            accumulate sbi_curr (count).

            if last(sbi_curr) and (accum count sbi_curr) > 1
            then do:
               /*MORE THAN ONE CURRENCY REFERENCED IN THIS TRANSMISSION*/
               {pxmsg.i &MSGNUM=4348 &ERRORLEVEL=3}
               undo mainloop, retry mainloop.
            end.
         end.
      end.

      display ctrl_amt @ sbi_ctrl_amt with frame a.
   end.

   /*BUILD LIST OF SELFBILLS TO PROCESS*/

   for each w_selfbill exclusive-lock:
      delete w_selfbill.
   end.

   if selfbill_nbr > "" then do:
      create w_selfbill.
      assign
         w_selfbill_nbr = selfbill_nbr.
   end.

   else do:
      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_xmission = transmission_nbr:
         create w_selfbill.
         assign
            w_selfbill_nbr = sbi_nbr.
      end.
   end.

   /* VALIDATE ALL REFERENCES ARE INVOICES OR MEMOS
      AND THAT THEY HAVE THE SAME CURRENCY AS THE SELFBILL*/

   errors = false.

   for each w_selfbill no-lock,
       each sbi_mstr no-lock
      where sbi_bill = bill_to
        and sbi_nbr = w_selfbill_nbr,
       each sbid_det no-lock
      where sbid_bill = sbi_bill
        and sbid_nbr = sbi_nbr
        and sbid_inv_nbr > ""
   break by sbid_inv_nbr:

      if last-of(sbid_inv_nbr) then do:

         find ar_mstr where ar_nbr = sbid_inv_nbr
                        and ar_bill = bill_to
                        and (ar_type = AN_INVOICE or ar_type = A_MEMO)
         no-lock no-error.

         if not available ar_mstr then do:
            /*NOT A VALID INVOICE OR MEMO NUMBER*/
            {pxmsg.i &MSGNUM=4319 &ERRORLEVEL=3}
            run mfmsg02
               (input 4338, input 3, input sbid_nbr + ' ' + sbid_inv_nbr).
            /*SELFBILL, INVOICE/MEMO:*/
            errors = true.
         end.

         if ar_curr <> sbi_curr then do:
            run mfmsg02
               (input 4339, input 3,
               input ar_nbr + ' ' + ar_curr + ' ' + sbi_curr).
            /*INVOICE/MEMO CURRENCY DIFFERENT FROM SELF-BILL CURRENCY*/
            errors = true.
         end.
      end.
   end.

   if errors then undo, retry.

   /*GET VARIOUS DEFAULTS*/

   assign
      archeck = ""
      batch = ""
      bank = ""
      acct = gl_cs_acct
      sub = gl_cs_sub
      cc = gl_cs_cc
      entity = gl_entity
      bankdesc = ""
      ardate = today
      eff_date = today
      .

   if selfbill_nbr > "" then
      find sbi_mstr where sbi_bill = bill_to and
                          sbi_nbr = selfbill_nbr
      no-lock no-error.
   else
      find first sbi_mstr where sbi_bill = bill_to
                            and sbi_xmission = transmission_nbr
      no-lock no-error.

   display
      ardate
      eff_date
      sbi_curr @ curr
   with frame a.

   if can-find(first cu_mstr where cu_curr >= "") then do:

      find first bk_mstr where bk_curr = sbi_curr
      no-lock no-error.

      if available bk_mstr then
         assign
            bank = bk_code
            acct = bk_acct
            sub = bk_sub
            cc = bk_cc
            entity = bk_entity
            bankdesc = bk_desc.
   end.

   display
      archeck
      batch
      bank
      acct
      sub
      cc
      entity
      bankdesc
   with frame a.

   /*VALIDATE ENTITY*/

   find en_mstr where en_entity = entity no-lock no-error.

   if not available en_mstr then do:
      run mfmsg02
         (input 3061, input 4, input entity).
      /*INVALID ENTITY*/
      undo mainloop, retry mainloop.
   end.

   /*GET CHECK#, BATCH, AR DATE, EFFECTIVE DATE FROM USER*/

   status input.

   setcheck:
   do on error undo, retry:
      pause before-hide.

      set
         archeck
         batch
         ardate
         eff_date
         bank
      with frame a.

      if batch <> "" then do:
         find first ar_mstr where ar_batch = batch no-lock no-error.

         if available ar_mstr and ar_type <> A_PAYMENT then do:
            {pxmsg.i &MSGNUM=1182 &ERRORLEVEL=3} /*BATCH ALREADY ASSIGNED*/
            next-prompt batch with frame a.
            undo, retry.
         end.
      end.

      /*USE GPGETBAT TO GET THE NEXT BATCH NUMBER AND CREATE*/
      /*THE BATCH MASTER (BA_MSTR).  IF THE BA_MSTR ALREADY */
      /*EXISTS THE RECORD WILL BE UPDATED.                  */

      inbatch = batch.

      {gprun.i ""gpgetbat.p""
         "(input  inbatch, /*IN-BATCH #     */
           input  ""AR"",    /*MODULE         */
           input  ""P"",     /*DOC TYPE       */
           input  bactrl,    /*CONTROL AMOUNT */
           output ba_recno,  /*NEW BATCH RECID*/
           output batch)"}   /*NEW BATCH #    */

      display batch with frame a.

      /*GET DEFAULT CHECK# IF USER ENTERED A <BLANK>*/

      if archeck = "" then do:
         {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_check archeck}
         display archeck with frame a.
      end.

      /*VALIDATE PAYMENT DOESN'T ALREADY EXIST*/

      find first ar_mstr
           where ar_type = A_PAYMENT
             and ar_check = archeck
             and ar_bill = bill_to
      use-index ar_check
      no-lock no-error.

      if available ar_mstr then do:
         /*CHECK HAS ALREADY BEEN ENTERED INTO AR*/
         {pxmsg.i &MSGNUM=4340 &ERRORLEVEL=3}
         next-prompt archeck with frame a.
         undo, retry.
      end.

      /* VALIDATE THAT NO OTHER SELFBILLS FOR THE BILL-TO
         REFERENCE THIS PAYMENT*/

      errors = false.

      for each sbi_mstr no-lock
         where sbi_bill = bill_to
           and sbi_check = archeck:
         run mfmsg02
            (input 4347, input 3, input sbi_nbr).
         /*OTHER SELF-BILLS REFERENCE THIS PAYMENT RECORD*/
         errors = true.
      end.

      if errors then do:
         next-prompt archeck with frame a.
         undo, retry.
      end.

      /*VALIDATE EFFECTIVE DATE AGAINST GL CALENDAR*/

      {gpglef02.i
         &module = ""AR""
         &entity = gl_entity
         &date   = eff_date
         &prompt = "eff_date"
         &frame  = "a"
         &loop   = "setcheck"}

      if bank = "" then
         /*SET CASH ACCT FIELDS ETC TO DEFAULT*/
         assign
            acct = gl_cs_acct
            sub = gl_cs_sub
            cc = gl_cs_cc
            entity = gl_entity
            bankdesc = ""
            .
      else do:
         /* VALIDATE BANK AND CURRENCY AND SET CASH ACCT FIELDS ETC
            FROM BANK MASTER*/

         find first bk_mstr where bk_code = bank no-lock no-error.

         if not available bk_mstr then do:
            {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}
            next-prompt bank with frame a.
            undo, retry.
         end.

         if bk_curr <> selfbill_curr then do:
            {pxmsg.i &MSGNUM=98 &ERRORLEVEL=3}
            /*PAYMENT CURRENCY SHOULD MATCH BANK CURRENCY*/
            undo, retry.
         end.

         assign
            acct = bk_acct
            sub = bk_sub
            cc = bk_cc
            entity = bk_entity
            bankdesc = bk_desc.
      end.

      /*DISPLAY CASH ACCT FIELDS ETC*/
      display
         acct
         sub
         cc
         entity
         bankdesc
      with frame a.

      /*VALIDATE ENTITY*/
      if entity <> glentity then do:
         find en_mstr where en_entity = entity no-lock no-error.

         if not available en_mstr then do:
            run mfmsg02
               (input 3061, input 3, input entity).
            /*INVALID ENTITY*/
            undo, retry.
         end.
      end.

      /*GET EXCHANGE RATE FROM THE USER*/
      ex_rate = 1.
      ex_rate2 = 1.

      {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
         "(input selfbill_curr,
           input base_curr,
           input ex_ratetype,
           input eff_date,
           output ex_rate,
           output ex_rate2,
           output ex_exru_seq,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         next-prompt archeck.
         undo setcheck, retry.
      end.

      setb_sub:
      do on error undo, retry:

         {gprunp.i "mcui" "p" "mc-ex-rate-input"
            "(input selfbill_curr,
              input base_curr,
              input eff_date,
              input ex_exru_seq,
              input false,
              input frame-row(a) + 4,
              input-output ex_rate,
              input-output ex_rate2,
              input-output dummy_fixrate)"}
         if keyfunction(lastkey) = "end-error"
            then undo setb_sub, leave.
      end. /* setb-sub */
   end.

   yn = false.
   /*PLEASE CONFIRM UPDATE*/
   {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}
   if not yn then undo mainloop, retry mainloop.

   /*CREATE THE PAYMENT AR MASTER RECORD*/
   create ar_mstr.
   assign
      ar_acct     = acct
      ar_bank     = bank
      ar_batch    = batch
      ar_bill     = cm_addr
      ar_cc       = cc
      ar_check    = archeck
      ar_curr     = selfbill_curr
      ar_cust     = cm_addr
      ar_date     = ardate
      ar_disc_acct = gl_term_acct
      ar_disc_cc  = gl_term_cc
      ar_disc_sub = gl_term_sub
      ar_due_date = ardate
      ar_dy_code  = dy_code
      ar_effdate  = eff_date
      ar_entity   = entity
      ar_ex_rate  = ex_rate
      ar_ex_rate2 = ex_rate2
      ar_exru_seq = ex_exru_seq
      ar_nbr      = string(bill_to,"X(8)") + archeck
      ar_sub      = sub
      ar_tax_date = ar_effdate
      ar_type     = A_PAYMENT.

   if recid(ar_mstr) = -1 then.
   payment_ar_recno = recid(ar_mstr).
   check_is_open = false.

   /* IF THE SELF-BILL/INVOICE CURRENCY DOES NOT MATCH THE BASE
      CURRENCY, A qad_wkfl  RECORD NEEDS TO BE CREATED TO STORE THE
      EXCHANGE RATES FROM THE SELF/BILL/INVOICE CURRENCY AND THE
      BASE CURRENCY. THIS IS IMPORTANT TO PROPERLY UNDO THE PAYMENT
      IF THE PAYMENT IS EVER UNDONE IN THE SELF-BILLING MODULE.
      NOTE: THE INVOICE CURRENCY AND THE SELF-BILL CURRENCY WILL
      ALWAYS BE THE SAME CURRENCY */
   if ar_curr <> gl_base_curr then do:
      {arupdwfl.i ar_nbr
         ar_ex_rate
         ar_ex_rate2}
   end.

   /*PROCESS LINES THAT ARE NOT PEGGED TO ANY INVOICE*/
   for each w_selfbill no-lock,
       each sbid_det no-lock
      where sbid_bill = bill_to
        and sbid_nbr = w_selfbill_nbr
        and sbid_inv_nbr = "":

      selfbill_line_amt = sbid_amt + sbid_tax_amt.

      run create_unapplied_ref_nbr
         (input sbid_nbr,
          input sbid_line,
          output unapplied_ref_nbr).

      run create_unapplied
         (input bill_to,
          input unapplied_ref_nbr,
          input selfbill_line_amt,
          input payment_ar_recno,
          input cm_ar_acct,
          input cm_ar_sub,
          input cm_ar_cc,
          input nrm-seq-num,
          input w_jrnl,
          output ok).

      if not ok then do:
         {pxmsg.i &MSGNUM=4344 &ERRORLEVEL=3}
         /*UNABLE TO CREATE UNAPPLIED ENTRY*/
         undo mainloop, retry mainloop.
      end.

      check_is_open = true.

   end.

   /*PROCESS LINES THAT ARE PEGGED TO INVOICES*/

   for each w_selfbill no-lock,
       each sbid_det no-lock
      where sbid_bill = bill_to
        and sbid_nbr = w_selfbill_nbr
        and sbid_inv_nbr > ""
   break by sbid_inv_nbr:

      selfbill_line_amt = sbid_amt + sbid_tax_amt.

      if sbid_trnbr > 0 then do:
         /***LINES PEGGED TO AN XREF RECORD***/
         /*CALCULATE AMT TO APPLY AND UNAPPLIED AMT*/
         find six_ref where six_trnbr = sbid_trnbr exclusive-lock.

         open_amt = six_amt - six_amt_appld.

         if (six_amt >= 0 and selfbill_line_amt > open_amt)
         or (six_amt <  0 and selfbill_line_amt < open_amt)
         then
            amt_to_apply = open_amt.
         else
            amt_to_apply = selfbill_line_amt.

         unapplied_amt = selfbill_line_amt - amt_to_apply.

         if unapplied_amt <> 0 then do:

            /*CREATE AN UNAPPLIED ENTRY*/
            run create_unapplied_ref_nbr
               (input sbid_nbr,
                input sbid_line,
                output unapplied_ref_nbr).

            run create_unapplied
               (input bill_to,
                input unapplied_ref_nbr,
                input unapplied_amt,
                input payment_ar_recno,
                input cm_ar_acct,
                input cm_ar_sub,
                input cm_ar_cc,
                input nrm-seq-num,
                input w_jrnl,
                output ok).

            if not ok then do:
               {pxmsg.i &MSGNUM=4344 &ERRORLEVEL=3}
               /*UNABLE TO CREATE UNAPPLIED ENTRY*/
               undo mainloop, retry mainloop.
            end.

            check_is_open = true.

         end.

         /*UPDATE THE AMOUNT APPLIED TO THE SHIPMENT XREF RECORD*/
         six_amt_appld = six_amt_appld + amt_to_apply.

      end.

      else
         /* LINES NOT PEGGED TO AN XREF RECORD BUT PEGGED TO SOME
            INVOICE (AKA ADJUSTMENT LINES)***/
         amt_to_apply = selfbill_line_amt.

      accumulate amt_to_apply (sub-total by sbid_inv_nbr).

      if last-of(sbid_inv_nbr) then do:

         total_amt_to_apply =
            accum sub-total by sbid_inv_nbr amt_to_apply.

         find ar_mstr where ar_nbr = sbid_inv_nbr no-lock.
         open_amt = ar_amt - ar_applied.

         if (ar_amt >= 0 and total_amt_to_apply > open_amt)
         or (ar_amt <  0 and total_amt_to_apply < open_amt)
         then
            amt_to_apply = open_amt.
         else
            amt_to_apply = total_amt_to_apply.

         unapplied_amt = total_amt_to_apply - amt_to_apply.

         if amt_to_apply <> 0 then do:
            /*APPLY PAYMENT TO THE INVOICE OR MEMO*/
            run apply_payment
               (input bill_to,
                input sbid_inv_nbr,
                input amt_to_apply,
                input payment_ar_recno,
                input nrm-seq-num,
                input w_jrnl,
                output ok).

            if not ok then do:
               run mfmsg02
                  (input 4343, input 3, input sbid_inv_nbr).
               /*UNABLE TO APPLY PAYMENT TO INVOICE OR MEMO*/
               undo mainloop, retry mainloop.
            end.
         end.

         if unapplied_amt <> 0 then do:
            /* NOTE WE CREATE AN UNAPPLIED REFERENCE USING
               THE INVOICE NUMBER*/

            run create_unapplied
               (input bill_to,
                input sbid_inv_nbr,
                input unapplied_amt,
                input payment_ar_recno,
                input cm_ar_acct,
                input cm_ar_sub,
                input cm_ar_cc,
                input nrm-seq-num,
                input w_jrnl,
                output ok).

            if not ok then do:
               {pxmsg.i &MSGNUM=4344 &ERRORLEVEL=3}
               /*UNABLE TO CREATE UNAPPLIED ENTRY*/
               undo mainloop, retry mainloop.
            end.

            check_is_open = true.

         end.

      end.

   end.

   /*UPDATE CUSTOMER LAST PAYMENT DATE*/

   tempdate = low_date.

   for each ar_mstr no-lock
      where ar_mstr.ar_bill = cm_addr and ar_type = A_PAYMENT:
      if ar_mstr.ar_date > tempdate then
         tempdate = ar_date.
   end.

   if tempdate = low_date then
      tempdate = ?.
   cm_pay_date = tempdate.

   /*SET OPEN FLAG IN PAYMENT RECORD*/

   find ar_mstr where recid(ar_mstr) = payment_ar_recno
   exclusive-lock.

   ar_open = check_is_open.

   /*MARK THE SELFBILL HEADER RECORD(S) WITH CHECK NUMBER*/
   for each w_selfbill no-lock,
       each sbi_mstr exclusive-lock
      where sbi_bill = bill_to
        and sbi_nbr = w_selfbill_nbr:
      sbi_check = archeck.
   end.

end.  /*mainloop*/

/*DELETE THE PAYMENT MAINT PROCESS LOGIC PROGRAM USED FOR AUTO APPLY*/
delete PROCEDURE h-arpamtpl no-error.

/*****************************************************/
/*****************************************************/
/**                  PROCEDURES                     **/
/*****************************************************/
/*****************************************************/

PROCEDURE get_bill_trans_selfbill:
   define output parameter p_undo_tran as logical no-undo.

   p_undo_tran = true.

   set
      bill_to
      transmission_nbr
      selfbill_nbr
   with frame a
   editing:

      if frame-field = 'bill_to' then do:
         {mfnp05.i
            sbi_mstr
            sbi_nbr
            yes
            sbi_bill
            "input frame a bill_to"}
      end.

      else
      if frame-field = 'selfbill_nbr' then do:
         {mfnp05.i
            sbi_mstr
            sbi_nbr
            "sbi_bill = input frame a bill_to"
            sbi_nbr
            "input frame a selfbill_nbr"}
      end.

      else do:
         {mfnp05.i
            sbi_mstr
            sbi_xmission
            "sbi_bill = input frame a bill_to"
            sbi_xmission
            "input frame a transmission_nbr"}
      end.

      if recno <> ? then do:
         find ad_mstr where ad_addr = sbi_bill no-lock.

         display
            sbi_bill @ bill_to
            ad_name
            sbi_nbr @ selfbill_nbr
            sbi_xmission @ transmission_nbr
         with frame a.
      end.

      shared_bill_to = input frame a bill_to.

      {gpbrparm.i &browse=gplu548.p &parm=c-brparm1 &val="shared_bill_to"}
      {gpbrparm.i &browse=gplu549.p &parm=c-brparm1 &val="shared_bill_to"}
      {gpbrparm.i &browse=gplu551.p &parm=c-brparm1 &val="shared_bill_to"}

   end.

   p_undo_tran = false.

END PROCEDURE.

PROCEDURE apply_payment:
   define input parameter p_bill_to like cm_addr no-undo.
   define input parameter p_invoice_memo_id like ar_nbr no-undo.
   define input parameter p_amt_to_apply like ar_amt no-undo.
   define input parameter p_payment_ar_recno as recid no-undo.
   define input parameter p_nrm_seq_num as character no-undo.
   define input parameter p_jrnl as character no-undo.
   define output parameter p_ok as logical no-undo.

   define buffer invcmemo_ar_mstr for ar_mstr.
   define buffer payment_ar_mstr for ar_mstr.
   define variable currency_rndmthd like rnd_rnd_mthd no-undo.

   p_ok = true.

   if p_amt_to_apply = 0 then leave.

   find payment_ar_mstr where recid(payment_ar_mstr) = p_payment_ar_recno
   exclusive-lock.

   find invcmemo_ar_mstr where invcmemo_ar_mstr.ar_nbr = p_invoice_memo_id
   exclusive-lock.

   /*GET THE INVOICE OR MEMO'S ROUND METHOD*/

   run get_invcmemo_rounding_method in h-arpamtpl
      (input invcmemo_ar_mstr.ar_curr,
       output currency_rndmthd).

   if currency_rndmthd = ? then do:
      run mfmsg02
         (input 4335, input 3, input invcmemo_ar_mstr.ar_curr).
      /*NO ROUNDING METHOD FOUND FOR CURRENCY*/
      p_ok = false.
      leave.
   end.

   /*UPDATE THE INVOICE OR MEMO WITH PAYMENT DETAIL*/
   run create_payment_detail in h-arpamtpl
      (input payment_ar_mstr.ar_nbr,
       input invcmemo_ar_mstr.ar_nbr,
       input invcmemo_ar_mstr.ar_acct,
       input invcmemo_ar_mstr.ar_sub,
       input invcmemo_ar_mstr.ar_cc,
       input invcmemo_ar_mstr.ar_entity,
       input invcmemo_ar_mstr.ar_type,
       input p_amt_to_apply,
       input 0,
       input payment_ar_mstr.ar_dy_code,
       input p_nrm_seq_num,
       output ardrecno,
       buffer invcmemo_ar_mstr,
       buffer payment_ar_mstr).

   /*CALCULATE TAX DETAIL*/
   run calculate_tax_adjustment in h-arpamtpl
      (input  ardrecno,
       buffer invcmemo_ar_mstr,
       buffer payment_ar_mstr).

   /*POST GL TRANSACTIONS*/
   run post_gl_transactions in h-arpamtpl
      (input recid(payment_ar_mstr),
       input ardrecno,
       input payment_ar_mstr.ar_curr,
       input payment_ar_mstr.ar_ex_rate,
       input payment_ar_mstr.ar_ex_rate2,
       input payment_ar_mstr.ar_ex_rate,
       input payment_ar_mstr.ar_ex_rate2,
       input p_amt_to_apply,
       input 0,
       input recid(invcmemo_ar_mstr),
       input invcmemo_ar_mstr.ar_ex_rate,
       input invcmemo_ar_mstr.ar_ex_rate2,
       input currency_rndmthd,
       input p_jrnl,
       output not_successful).

   if not_successful then do:
      /*UNABLE TO POST GL TRANSACTION*/
      {pxmsg.i &MSGNUM=4345 &ERRORLEVEL=3}
      p_ok = false.
      leave.
   end.

   /*UPDATE CUSTOMER BALANCE*/
   run update_customer_balance in h-arpamtpl
      (buffer invcmemo_ar_mstr,
       input ardrecno).

   /*UPDATE AMOUNTS IN AR PAYMENT RECORD*/
   assign
      payment_ar_mstr.ar_amt = payment_ar_mstr.ar_amt - p_amt_to_apply
      payment_ar_mstr.ar_applied = payment_ar_mstr.ar_applied  +
                                   (p_amt_to_apply * -1)
      payment_ar_mstr.ar_open = payment_ar_mstr.ar_amt <> payment_ar_mstr.ar_applied.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input payment_ar_mstr.ar_curr,
        input base_curr,
        input payment_ar_mstr.ar_ex_rate,
        input payment_ar_mstr.ar_ex_rate2,
        input payment_ar_mstr.ar_applied,
        input true,
        output payment_ar_mstr.ar_base_applied,
        output mc-error-number)"}

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input payment_ar_mstr.ar_curr,
        input base_curr,
        input payment_ar_mstr.ar_ex_rate,
        input payment_ar_mstr.ar_ex_rate2,
        input payment_ar_mstr.ar_amt,
        input true,
        output payment_ar_mstr.ar_base_amt,
        output mc-error-number)"}

   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   /*UPDATE INVOICE OR MEMO RECORD*/
   invcmemo_ar_mstr.ar_open =
      invcmemo_ar_mstr.ar_amt <> invcmemo_ar_mstr.ar_applied.

END PROCEDURE.

PROCEDURE create_unapplied:
   define input parameter p_bill_to like cm_addr no-undo.
   define input parameter p_unapp_ref as character no-undo.
   define input parameter p_amt_to_apply like ar_amt no-undo.
   define input parameter p_payment_ar_recno as recid no-undo.
   define input parameter p_ar_acct like cm_ar_acct no-undo.
   define input parameter p_ar_sub like cm_ar_sub no-undo.
   define input parameter p_ar_cc like cm_ar_cc no-undo.
   define input parameter p_nrm_seq_num as character no-undo.
   define input parameter p_jrnl as character no-undo.
   define output parameter p_ok as logical no-undo.

   define buffer invcmemo_ar_mstr for ar_mstr.
   define buffer payment_ar_mstr for ar_mstr.
   define variable currency_rndmthd like rnd_rnd_mthd no-undo.

   p_ok = true.
   find first gl_ctrl no-lock.

   find payment_ar_mstr where recid(payment_ar_mstr) = p_payment_ar_recno
   no-lock.

   /*GET THE PAYMENT'S ROUND METHOD*/
   run get_invcmemo_rounding_method in h-arpamtpl
      (input payment_ar_mstr.ar_curr,
       output currency_rndmthd).

   if currency_rndmthd = ? then do:
      run mfmsg02
         (input 4335, input 3, input payment_ar_mstr.ar_curr).
      /*NO ROUNDING METHOD FOUND FOR CURRENCY*/
      p_ok = false.
      leave.
   end.

   create ard_det.
   assign
      ard_acct = p_ar_acct
      ard_amt = p_amt_to_apply
      ard_cc = p_ar_cc
      ard_dy_code = payment_ar_mstr.ar_dy_code
      ard_dy_num = p_nrm_seq_num
      ard_entity = payment_ar_mstr.ar_entity
      ard_nbr = payment_ar_mstr.ar_nbr
      ard_ref = ""
      ard_sub = p_ar_sub
      ard_tax = p_unapp_ref
      ard_type = "U".

   if recid(ard_det) = -1 then.

   /*UPDATE TAXES*/
   {gprun.i ""txcalc19.p""
              "(input  '19',
                input  payment_ar_mstr.ar_nbr,
                input  '',
                input  0,
                input  '16',
                input  payment_ar_mstr.ar_effdate,
                input  payment_ar_mstr.ar_ex_rate,
                input  payment_ar_mstr.ar_ex_rate2,
                input  payment_ar_mstr.ar_ex_ratetype,
                input  0,
                input  payment_ar_mstr.ar_effdate)" }

   /*POST GL TRANSACTIONS*/
   run post_gl_transactions in h-arpamtpl
      (input recid(payment_ar_mstr),
       input recid(ard_det),
       input payment_ar_mstr.ar_curr,
       input payment_ar_mstr.ar_ex_rate,
       input payment_ar_mstr.ar_ex_rate2,
       input payment_ar_mstr.ar_ex_rate,
       input payment_ar_mstr.ar_ex_rate2,
       input p_amt_to_apply,
       input 0,
       input ?,
       input payment_ar_mstr.ar_ex_rate,
       input payment_ar_mstr.ar_ex_rate2,
       input currency_rndmthd,
       input p_jrnl,
       output not_successful).

   if not_successful then do:
      /*UNABLE TO POST GL TRANSACTION*/
      {pxmsg.i &MSGNUM=4345 &ERRORLEVEL=3}
      p_ok = false.
      leave.
   end.

   /*WE DO THIS HERE BECAUSE GPGL.I SETS NRM-SEQ-NUM*/
   ard_dy_num = nrm-seq-num.

   /*UPDATE CUSTOMER BALANCE*/
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input ar_curr,
        input base_curr,
        input ar_ex_rate,
        input ar_ex_rate2,
        input ard_amt,
        input true,
        output tmpamt,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   find cm_mstr where cm_addr = payment_ar_mstr.ar_bill exclusive-lock.
   cm_balance = cm_balance - tmpamt.

   /*UPDATE AMOUNTS IN AR PAYMENT RECORD*/
   payment_ar_mstr.ar_amt = payment_ar_mstr.ar_amt - p_amt_to_apply.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input payment_ar_mstr.ar_curr,
        input base_curr,
        input payment_ar_mstr.ar_ex_rate,
        input payment_ar_mstr.ar_ex_rate2,
        input payment_ar_mstr.ar_amt,
        input true,
        output payment_ar_mstr.ar_base_amt,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

END PROCEDURE.

PROCEDURE create_unapplied_ref_nbr:
   define input parameter p_sbid_nbr like sbid_nbr no-undo.
   define input parameter p_sbid_line like sbid_line no-undo.
   define output parameter p_unapplied_ref_nbr as character no-undo.

   define variable strlen as integer no-undo.

   p_unapplied_ref_nbr = p_sbid_nbr + "/" + string(p_sbid_line).

   /* SHORTEN IT DOWN TO LENGTH 8 SO IT WILL FIT IN THE AR
      UNAPPLIED REF FIELD.  DO IT BY DROPPING LEADING CHARS*/
   strlen = length(p_unapplied_ref_nbr).

   if strlen > 8 then
      p_unapplied_ref_nbr = substring(p_unapplied_ref_nbr, strlen - 7).

END PROCEDURE.

PROCEDURE mfmsg02:
   define input parameter p_msg_nbr as integer no-undo.
   define input parameter p_level as integer no-undo.
   define input parameter p_concat_string as character no-undo.

   {pxmsg.i &MSGNUM=p_msg_nbr &ERRORLEVEL=p_level &MSGARG1=p_concat_string}

END PROCEDURE.
