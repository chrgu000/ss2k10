/* dmdmap.p - DRAFT MANAGEMENT--DRAFT APPROVAL FUNCTION                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.15.1.20 $                                             */
/*V8:ConvertMode=Maintenance                                              */
/* REVISION: 7.0      LAST MODIFIED: 12/04/91   by: jms   *F065*          */
/*                                   01/28/92   by: jms   *F102*          */
/*                                   03/16/92   by: jjs   *F198*          */
/*                                                  (major re-write)      */
/*                                   03/23/92   by: jjs   *F310*          */
/*                                   04/16/92   by: jjs   *F406*          */
/*                                   06/18/92   BY: JJS   *F672*(rev only)*/
/*                                   06/24/92   by: jjs   *F681*          */
/* REVISION: 7.3      LAST MODIFIED: 07/27/92   by: jms   *G008*          */
/* REVISION: 7.4      LAST MODIFIED: 12/04/92   by: mpp   *G478*          */
/* Revision: 7.3        Last edit:   11/11/92   By: jcd   *G247*          */
/*                                   11/05/92   BY: JJS   *G280*(rev)     */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd   *H039*          */
/*                                   09/13/93   by: jms   *H112*          */
/*                                   02/09/94   by: srk   *GI33*          */
/*                                   08/24/94   BY: rxm   *GL40*          */
/* Oracle changes (share-locks)    09/11/94           BY: rwl *GM24*      */
/*                                   11/03/94   BY: str   *FT26*          */
/*                                   05/11/95   by: wjk   *F0RH*          */
/* REVISION: 8.5      LAST MODIFIED: 01/02/96   BY: taf   *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 05/29/96   BY: ruw   *J0PB*          */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh   *K001*          */
/*                                   07/15/96   BY: *J0VY* M. Deleeuw     */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf   *J101*          */
/* REVISION: 8.5      LAST MODIFIED: 08/26/96   BY: *G2D0* Sanjay Patil   */
/*       ORACLE PERFORMANCE FIX      11/18/96   by: rxm *H0P7*            */
/* REVISION: 8.6      LAST MODIFIED: 12/11/96   by: bjl *K01S*            */
/*                                   01/23/97   by: bjl *K01G*            */
/*                                   02/17/97   by: *K01R* E. Hughart     */
/*                                   03/11/97   by: *K077* E. Hughart     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *K1SH* Dana Tunstall  */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *N00D* Adam Harris    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson   */
/* REVISION: 9.1      LAST MODIFIED: 10/06/99   BY: *K237* Jose Alex      */
/* REVISION: 9.1      LAST MODIFIED: 12/01/99   BY: *J3MP* Jose Alex      */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/21/00   BY: *N0DB* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *L14K* Jean Miller      */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *N0WP* Ed van de Gevel  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.15.1.17    BY: Katie Hilbert   DATE: 04/01/01 ECO: *P002*    */
/* Revision: 1.15.1.18    BY: Abbas Hirkani   DATE: 07/26/01 ECO: *M1G4*    */
/* Revision: 1.15.1.19    BY: Kirti Desai     DATE: 02/20/02 ECO: *N19Q*    */
/* $Revision: 1.15.1.20 $ BY: Manjusha Inglay DATE: 07/29/02 ECO: *N1P4*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/****************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "DMDMAP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE dmdmap_p_1 "Print Audit Trail"
/* MaxLen: Comment: */

&SCOPED-DEFINE dmdmap_p_4 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE dmdmap_p_6 "Total of Invoices"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable rndmthd       like rnd_rnd_mthd.
define new shared variable jrnl          like glt_ref.
define new shared variable ref           like glt_ref.
define new shared variable ar_recno      as recid.
define new shared variable base_amt      like ar_amt.
define new shared variable disc_amt      like ar_amt.
define new shared variable curr_amt      like ar_amt.
define new shared variable base_det_amt  like ar_amt.
define new shared variable curr_disc     like ar_amt.
define new shared variable gltline       like glt_line.
define new shared variable ard_recno     as recid.
define new shared variable ardbuff_recno as recid.
define new shared variable arbuff_recno  as recid.
define new shared variable artotal1      like ar_amt.
define new shared variable summary       like arc_sum_lvl.
define new shared variable gendesc       like ard_desc.
define new shared variable mstrdesc      like ard_desc.
define new shared variable audit_yn      like mfc_logical
   initial true
   label {&dmdmap_p_1}.

define variable oldcurr       like ar_curr.
define variable ar_amt_fmt    as character.
define variable ar_amt_old    as character.
define variable artotal      like ar_amt label {&dmdmap_p_6}.
define variable drft_acc     like arc_drft_acc.
define variable drft_sub     like arc_drft_sub.
define variable drft_cc      like arc_drft_cc.
define variable batch        like ba_batch.
define variable bactrl       like ba_ctrl.
define variable valid_acct   like mfc_logical.
define variable ba_recno     as recid.
define variable inbatch      like ba_batch.
define variable mc-error-number like msg_nbr no-undo.
define variable fixed_rate      like mfc_logical no-undo.
define variable tmpamt          like ard_amt     no-undo.
define variable tmpamt2         like ard_amt     no-undo.

define buffer a1        for ar_mstr.

{&DMDMAP-P-TAG25}
assign gendesc = getTermLabel("DRAFT_APPROVAL",24).

{gpglefdf.i}

{&DMDMAP-P-TAG1}
/* DEFINE FORM */
form
   ar_nbr       colon 19
   ar_bill      colon 48
   cm_sort      at 50 no-label
   ar_date      colon 19
   ar_effdate   colon 48
   ar_curr      colon 19
   ar_entity    colon 48
   ar_amt       colon 19
   ar_acct      colon 48
   ar_sub       no-label
   ar_cc        no-label
   artotal      colon 19
   ar_disc_acct colon 48
   ar_disc_sub  no-label
   ar_disc_cc   no-label
   ar_due_date  colon 19
   ar_po        colon 48
   ar_expt_date colon 19
   ar_dy_code   colon 48
with frame a side-labels width 80.
{&DMDMAP-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   ard_entity
   ard_acct
   ard_sub
   ard_cc
   ard_tax_at
   ard_amt
with frame unapplied_box row 16 column 15 overlay
   title color normal (getFrameTitle("UNAPPLIED_AMOUNT",24)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame unapplied_box:handle).

ar_amt_old = ar_amt:format.

/* ADD FORMATS FOR BA_TOTAL and BACTRL TO ALLOW FOR THE MAXIMUM */
/* DECIMAL DIGITS FOR CURRENCY DEPENDENT ROUNDING*/
form
   batch          colon 8 deblank
   bactrl         label {&dmdmap_p_4}
   format "->>>>>>>,>>>,>>9.999"
   ba_total
   format "->>>>>>>,>>>,>>9.999"
with side-labels frame ba width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame ba:handle).

/* DO NOT CREATE AUDIT TRAIL RECORDS */
audit_yn = false.

/* READ CONTROL FILES */
find first gl_ctrl no-lock.
find first arc_ctrl no-lock no-error.
if available arc_ctrl then do:
   assign
      drft_acc = arc_drft_acc
      drft_sub = arc_drft_sub
      drft_cc = arc_drft_cc
      summary = arc_sum_lvl.
   release arc_ctrl.
end.

{&DMDMAP-P-TAG3}
{&DMDMAP-P-TAG4}

/* IF THE RECORDS ARE SUMMARIZED ONE REFERENCE NUMBER IS USED FOR */
/* THE ENTIRE BATCH.  IF DETAIL IS USED THE REFERENCE NUMBER WILL */
/* BE PICKED UP ONCE THE DRAFT IS COMMITTED FOR APPROVAL.         */

if summary = 2 then do:
   do transaction:
      /* GET NEXT JOURNAL REFERENCE NUMBER  */

      /* CHANGED THE FOURTH PARAMETER FROM                          */
      /* "glt_ref matches '*' + string(arc_jrnl) and                */
      /* string(arc_jrnl)" TO "glt_tr_type = 'AR' and  glt_ref      */
      /* matches '*' + string(arc_jrnl)" TO IMPROVE THE PERFORMANCE */
      {&DMDMAP-P-TAG5}
      {mfnctrle.i arc_ctrl arc_jrnl glt_det
         "glt_tr_type = 'AR' and
          glt_ref matches '*' + string(arc_jrnl)"
         jrnl}
      {&DMDMAP-P-TAG6}

      /* GET JOURNAL ENTRY REFERENCE NUMBER */
      /* JRNL IS CONVERTED TO INTEGER AND BACK IN ORDER TO */
      /* GET THE CORRECT 6 CHARACTER FORMAT                */
      ref = "AR" + substring(string(year(today),"9999"),3,2)
         + string(month(today),"99")
         + string(day(today),"99")
         + string(integer(jrnl),"999999").
   end.
end.

view frame ba.

mainloop:
repeat with frame ba:
   /* ALLOW ENTRY OF AN EXISTING OR NEW BATCH NUMBER */
   do transaction:
      bactrl = 0.
      batch = "".
      display bactrl batch 0 @ ba_total with frame ba.
      set batch with frame ba.

      if batch <> "" then do:
         find first ar_mstr where ar_batch = batch no-lock
            no-error.
         if available ar_mstr and index("D",ar_type) = 0 then do:
            {pxmsg.i &MSGNUM=1170 &ERRORLEVEL=3}  /* NOT A VALID BATCH */
            next-prompt batch with frame ba.
            undo, retry.
         end.

         if can-find(first gltr_hist where gltr_batch = batch)
         then do:
            {pxmsg.i &MSGNUM=3523 &ERRORLEVEL=3}
            /* BATCH HAS BEEN POSTED IN G/L */
            next-prompt batch with frame ba.
            undo, retry.
         end.

         find ba_mstr where ba_batch = batch and ba_module = "AR"
            exclusive-lock no-error.
         if available ba_mstr then do:
            bactrl = ba_ctrl.

            /* INSURE BATCH TOTAL = SUM OF DRAFTS */
            ba_total = 0.
            for each ar_mstr where ar_batch = batch no-lock:
               ba_total = ba_total + ar_amt.
            end.
            display ba_total with frame ba.
         end.  /* AVAILABLE BA_MSTR */

         else do:
            /* THE ACTUAL BA_MSTR WILL BE CREATED LATER */
            {pxmsg.i &MSGNUM=3524 &ERRORLEVEL=1}  /* ADDING NEW BATCH */
         end.
      end.  /* BATCH <> "" */

      else do:
         display 0 @ bactrl 0 @ ba_total with frame ba.
      end.

      update bactrl with frame ba.

      /*DON'T CHG BA_CTRL IF MODIFIATION AND LEFT AT 0*/
      if available ba_mstr and bactrl <> 0 then ba_ctrl = bactrl.

      /*USE GPGETBAT.P TO GET THE NEXT BATCH NUMBER AND CREATE */
      /*THE BATCH MASTER (BA_MSTR)                             */
      inbatch = batch.
      {gprun.i ""gpgetbat.p"" "(input  inbatch, /*IN-BATCH #     */
                                input  ""AR"",  /*MODULE         */
                                input  ""D"",   /*DOC TYPE       */
                                input  bactrl,  /*CONTROL AMOUNT */
                                output ba_recno,/*NEW BATCH RECID*/
                                output batch)"} /*NEW BATCH #    */
      display batch with frame ba.

   end. /* TRANSACTION */

   loopb:
   repeat with frame a:
      /* UPDATE DRAFT DATA */
      do transaction:
         /* ENTER DRAFT NUMBER */
         {&DMDMAP-P-TAG7}
         prompt-for ar_nbr
         editing:
            {&DMDMAP-P-TAG8}
            /* FIND NEXT/PREVIOUS RECORD - OPEN, UNAPPROVED DRAFTS */

            /*REPLACED NEXT/PREV TO FIND ONLY THOSE DRAFTS FOR*/
            /*THE BATCH SPECIFIED.                            */
            {mfnp01.i ar_mstr ar_nbr ar_nbr batch ar_batch ar_batch}

            if recno <> ? then do:

               if (oldcurr <> ar_curr) or (oldcurr = "") then do:

                  if ar_curr = gl_base_curr then
                     rndmthd = gl_rnd_mthd.
                  else do:
                     /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                     {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input ar_curr,
                          output rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        undo loopb, retry.
                     end.
                  end.
                  /* SET AR_AMT_FMT */
                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                                      input rndmthd)"}
                  assign
                     ar_amt:format = ar_amt_fmt
                     ard_amt:format = ar_amt_fmt
                     artotal:format = ar_amt_fmt
                     oldcurr = ar_curr.
               end.

               display
                  ar_nbr
                  ar_date
                  ar_curr
                  ar_amt
                  ar_due_date
                  ar_expt_date
                  ar_bill
                  ar_effdate
                  ar_entity
                  ar_acct
                  ar_sub
                  ar_cc
                  ar_disc_acct
                  ar_disc_sub
                  ar_disc_cc
                  ar_po when (summary = 1 or summary = 3)
                  getTermLabel("DRAFT_APPROVAL",22) when (summary = 2)
                  @ ar_po
                  ar_dy_code
               with frame a.

               {&DMDMAP-P-TAG26}
               find cm_mstr where cm_addr = ar_bill no-lock no-error.
               if available cm_mstr then display cm_sort with frame a.
               else display " " @ cm_sort with frame a.

               artotal = 0.
               for each ard_det where ard_ref = ar_nbr
                     and (ard_type = "I"
                     or   ard_type = "M"
                     or   ard_type = "F")
                     no-lock:

                  do for a1:
                     find a1 where a1.ar_nbr = ard_nbr no-lock.
                     tmpamt = ard_amt.
                     /* CONVERT ONLY WHEN CURRENCIES ARE NOT SAME */
                     if ar_mstr.ar_curr <> a1.ar_curr
                     then
                        run convert_amt_from_doc_to_draft
                           (input a1.ar_curr,
                            input a1.ar_ex_rate,
                            input a1.ar_ex_rate2,
                            input-output tmpamt).
                     artotal = artotal + tmpamt.
                  end.
               end.
               display artotal with frame a.
               {&DMDMAP-P-TAG9}
            end.
         end.  /* PROMPT-FOR EDITING */

         /* GET DRAFT RECORD */
         find ar_mstr using ar_nbr no-error.
         if not available ar_mstr then do:
            {pxmsg.i &MSGNUM=3500 &ERRORLEVEL=3} /* DRAFT NOT FOUND */
            undo, retry.
         end.

         if ar_type <> "D" then do:
            {pxmsg.i &MSGNUM=3502 &ERRORLEVEL=3} /* RECORD IS NOT A DRAFT */
            undo loopb, retry.
         end.
         if ar_draft then do:
            {pxmsg.i &MSGNUM=3501 &ERRORLEVEL=3} /* DRAFT ALREADY APPROVED */
            undo loopb, retry.
         end.
         if not ar_draft and not ar_open then do:
            {pxmsg.i &MSGNUM=3505 &ERRORLEVEL=3} /* CANCELLED DRAFT */
            undo loopb, retry.
         end.

         if (oldcurr <> ar_curr) or (oldcurr = "") then do:

            if ar_curr = gl_base_curr then
               rndmthd = gl_rnd_mthd.
            else do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input ar_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo loopb, retry.
               end.
            end.
            /* SET AR_AMT_FMT */
            ar_amt_fmt = ar_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                                 input rndmthd)"}
            assign
               ar_amt:format = ar_amt_fmt
               ard_amt:format = ar_amt_fmt
               artotal:format = ar_amt_fmt
               oldcurr = ar_curr.
         end.

         /* GET DEFAULTS */
         assign
            ar_effdate = today
            ar_tax_date = ar_effdate
            ar_entity = gl_entity
            {&DMDMAP-P-TAG10}
            ar_acct = drft_acc
            ar_sub = drft_sub
            ar_cc = drft_cc
            {&DMDMAP-P-TAG11}
            ar_disc_acct = gl_term_acct
            ar_disc_sub = gl_term_sub
            ar_disc_cc = gl_term_cc

            .
         if daybooks-in-use then do:
            /* Added entity parameter */
            {gprun.i ""gldydft.p"" "(input ""AR"",
                                     input ""D"",
                                     input ar_entity,
                                     output dft-daybook,
                                     output daybook-desc)"}
            ar_dy_code = dft-daybook.
         end.

         /* DISPLAY RECORD */
         display
            ar_date
            ar_curr
            ar_amt
            ar_due_date
            ar_expt_date
            ar_bill
            ar_effdate
            ar_entity
            ar_acct
            ar_sub
            ar_cc
            ar_disc_acct
            ar_disc_sub
            ar_disc_cc
            ar_po  when (summary = 1 or summary = 3)
            getTermLabel("DRAFT_APPROVAL",22) when (summary = 2)
            @ ar_po
            ar_dy_code
         with frame a.

         {&DMDMAP-P-TAG27}
         find cm_mstr where cm_addr = ar_bill no-lock no-error.
         if available cm_mstr then display cm_sort with frame a.
         else display " " @ cm_sort with frame a.
         artotal = 0.
         for each ard_det where ard_ref = ar_nbr
               and (ard_type = "I"
               or   ard_type = "M"
               or   ard_type = "F")
               no-lock:

            do for a1:
               find a1 where a1.ar_nbr = ard_nbr no-lock.
               tmpamt = ard_amt.
               /* CONVERT ONLY WHEN CURRENCIES ARE NOT SAME */
               if ar_mstr.ar_curr <> a1.ar_curr
               then
                  run convert_amt_from_doc_to_draft
                     (input a1.ar_curr,
                      input a1.ar_ex_rate,
                      input a1.ar_ex_rate2,
                      input-output tmpamt).
               /* DO NOT APPROVE IF INVOICE/MEMO/FINANCE CHARGES */
               /* OPEN AMOUNT IS LESS THAN DRAFT LINE AMOUNT     */
               tmpamt2 = a1.ar_amt - a1.ar_applied.
               /* CONVERT ONLY WHEN CURRENCIES ARE NOT SAME */
               if ar_mstr.ar_curr <> a1.ar_curr
               then
                  run convert_amt_from_doc_to_draft
                     (input a1.ar_curr,
                      input a1.ar_ex_rate,
                      input a1.ar_ex_rate2,
                      input-output tmpamt2).
               if tmpamt2 < tmpamt then do:
                  /* OPEN INVOICE AMOUNT LESS THAN DRAFT AMOUNT */
                  {pxmsg.i &MSGNUM=3405 &ERRORLEVEL=3}
                  undo loopb, retry.
               end. /* if a1.ar.amt - a1.ar_applied */
               artotal = artotal + tmpamt.
            end.
         end.
         {&DMDMAP-P-TAG12}
         display artotal with frame a.
         if artotal <> ar_amt then do:
            {&DMDMAP-P-TAG13}
            {pxmsg.i &MSGNUM=3532 &ERRORLEVEL=3}
            /* CANNOT APPROVE.  DRAFT AMOUNT <> TOTAL OF INVOICES */
            undo loopb, retry.
         end.

         /* SET EFFDATE, ACCTS, ETC.*/
         setb:
         do on error undo, retry:
            {&DMDMAP-P-TAG28}
            /*REMOVED ABILTIY TO UPDATE AR_AMT, WHEN UNAPPLIED */
            /*AMOUNTS ARE ALLOWED AR_AMT SHOULD BE INSERTED INTO */
            /*THIS SET STATEMENT. */
            set
               ar_date
               ar_due_date
               ar_expt_date
               ar_effdate
               ar_entity
               ar_acct
               ar_sub
               ar_cc
               ar_disc_acct
               ar_disc_sub
               ar_disc_cc
               ar_po      when (summary = 1 or summary = 3)
               ar_dy_code when (daybooks-in-use)
            with frame a.
            {&DMDMAP-P-TAG29}

            {&DMDMAP-P-TAG14}
            if artotal > ar_amt then do:
               {&DMDMAP-P-TAG15}
               {pxmsg.i &MSGNUM=3522 &ERRORLEVEL=4}
               /* INVOICES TOTAL MUST BE LESS
               THAN OR EQUAL TO DRAFT AMOUNT */
               next-prompt ar_amt with frame a.
               undo loopb, retry.
            end.

            /* CHECK EFFECTIVE DATE AGAINST GL CALENDAR */
            /* CHANGED SECOND PARAMETER FROM glentity TO ar_entity */
            {gpglef.i ""AR"" ar_entity ar_effdate}
            ar_tax_date = ar_effdate.

            /* IF FOREIGN CURRENCY, GET EXCHANGE RATE */
            if base_curr <> ar_curr then do:

               /* GET EXCHANGE RATE AND ALSO CREATE THE*/
               /* RATE USAGE RECORD IF TRIANGULATED RATE */
               {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_ratetype,
                    input ar_effdate,   /*SET TO today (SEE ABOVE)*/
                    output ar_ex_rate,
                    output ar_ex_rate2,
                    output ar_exru_seq,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo, retry.
               end.
            end.

            /* VERIFY ENTITY*/
            if ar_entity <> glentity then do:
               find en_mstr where en_entity = ar_entity no-lock
                  no-error.
               if not available en_mstr then do:
                  {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}  /*INVALID ENTITY*/
                  next-prompt ar_entity with frame a.
                  undo, retry.
               end.
            end.

            /* CHECK GL ACCOUNT/SUB-ACCOUNT/COST CENTER */

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}
            /* SET PROJECT VERIFICATION TO NO */
            {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
            /* ACCT/SUB/CC VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input ar_acct,
                 input ar_sub,
                 input ar_cc,
                 input """",
                 output valid_acct)"}

            if valid_acct = no then do:
               next-prompt ar_acct with frame a.
               undo, retry.
            end.

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}
            /* SET PROJECT VERIFICATION TO NO */
            {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
            /* ACCT/SUB/CC VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input ar_disc_acct,
                 input ar_disc_sub,
                 input ar_disc_cc,
                 input """",
                 output valid_acct)"}

            if valid_acct = no then do:
               next-prompt ar_disc_acct with frame a.
               undo, retry.
            end.

            /* CHECK THAT DRAFT REC ACCT IS BASE CURR OR = DFT CURR */
            find ac_mstr where
               ac_code = ar_acct
               no-lock no-error.
            if available ac_mstr and ac_curr <> base_curr and
               ac_curr <> ar_curr then do:
               {pxmsg.i &MSGNUM=3503 &ERRORLEVEL=3}
               /* DRAFT REC ACCT MUST BE IN CURRENCY OF DRAFT OR BASE */
               next-prompt ar_acct with frame a.
               undo, retry.
            end.

            /* VERIFY DAYBOOK */
            if daybooks-in-use then do:
               if not can-find(dy_mstr where dy_dy_code = ar_dy_code)
               then do:
                  {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
                  /* ERROR: INVALID DAYBOOK */
                  next-prompt ar_dy_code with frame a.
                  undo, retry.
               end.
               else do:
                  /* Added trans, doc, entity parameters */
                  {gprun.i ""gldyver.p"" "(input ""AR"",
                                           input ""D"",
                                           input ar_dy_code,
                                           input ar_entity,
                                           output daybook-error)"}
                  if daybook-error then do:
                     {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                     /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                     pause.
                  end. /* if daybook-error */

                  {gprunp.i "nrm" "p" "nr_can_dispense"
                     "(input ar_dy_code,
                       input ar_effdate)"}

                  {gprunp.i "nrm" "p" "nr_check_error"
                     "(output daybook-error,
                       output return_int)"}

                  if daybook-error then do:
                     {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                     next-prompt ar_dy_code with frame a.
                     undo, retry.
                  end.

                  find dy_mstr where dy_dy_code = ar_dy_code
                     no-lock no-error.
                  if available dy_mstr then
                     assign daybook-desc = dy_desc.
               end. /* ELSE DO */
            end. /* if daybooks-in-use */

            /* SET EXCHANGE RATE*/
            if ar_curr <> base_curr then do:
               setb_sub:
               do on error undo, retry:

                  {gprunp.i "mcui" "p" "mc-ex-rate-input"
                     "(input ar_curr,
                       input base_curr,
                       input ar_effdate,
                       input ar_exru_seq,
                       input false, /* DO NOT PROMPT FOR fixed (y/n)*/
                       input frame a:row + 7,
                       input-output ar_ex_rate,
                       input-output ar_ex_rate2,
                       input-output fixed_rate)"}

                  {&DMDMAP-P-TAG16}
               end. /* SETB_SUB */

            end. /* AR_CURR <> BASE_CURR */
         end. /* SETB */
      end.  /* TRANSACTION */
      {&DMDMAP-P-TAG17}
      /* APPROVE THE DRAFT */
      do transaction:

         if summary = 2 then do:
            /* THE REFERENCE NUMBER WAS PICKED UP AT THE BEGINNING; */
            /* HOWEVER, IF THIS DRAFT IS PART OF THE AN OLDER BATCH */
            /* IT MUST HAVE THE SAME REFERENCE NUMBER AND EFFECTIVE */
            /* DATE IN ORDER TO POST CORRECTLY IN G/L               */
            find glt_det where glt_batch = ar_batch no-lock no-error.
            if available glt_det then
            assign
               ar_effdate = glt_effdate
               ar_tax_date = ar_effdate
               ref = glt_ref.

            mstrdesc = getTermLabel("DRAFT_APPROVAL",24).
         end.

         else if summary = 1 or summary = 3 then do:
            /* GET NEXT JOURNAL REFERENCE NUMBER  */

            /* REPLACED mfnctrl.i WITH mfnctrle.i TO KEEP CONSISTENCY  */
            /* WITH VER 86.      */

            {&DMDMAP-P-TAG18}
            {mfnctrle.i arc_ctrl arc_jrnl glt_det
               "glt_tr_type = 'AR' and
                glt_ref matches '*' + string(arc_jrnl)"
               jrnl}
            {&DMDMAP-P-TAG19}

            /* GET JOURNAL ENTRY REFERENCE NUMBER */
            /* JRNL IS CONVERTED TO INTEGER AND BACK IN ORDER TO */
            /* GET THE CORRECT 6 CHARACTER FORMAT                */
            ref = "AR" + substring(string(year(today),"9999"),3,2)
               + string(month(today),"99")
               + string(day(today),"99")
               + string(integer(jrnl),"999999").
            {&DMDMAP-P-TAG20}
            mstrdesc = ar_po.
            if mstrdesc = "" then
               {&DMDMAP-P-TAG21}
               mstrdesc = getTermLabel("APPROVAL_OF_DRAFT", 15) + " "
                        + ar_nbr.
         end.

         ar_batch = batch.

         /*PLACE EXCLUSIVE LOCK ON BATCH FOR PROCESSING*/
         find ba_mstr where ba_batch = batch and ba_module = "AR"
            exclusive-lock no-error.

         ar_recno = recid(ar_mstr).
         dft-daybook = ar_dy_code.

         /* CYCLE THROUGH INVOICES ATTACHED TO DRAFT */
         {&DMDMAP-P-TAG22}
         for each ard_det where ard_ref = ar_nbr
               and (ard_type = "I"
               or   ard_type = "M"
               or   ard_type = "F")
               no-lock:
            ard_recno = recid(ard_det).
            {gprun.i ""dmdmapa.p""}
            {&DMDMAP-P-TAG23}
         end.
         {&DMDMAP-P-TAG30}
         assign
            ar_mstr.ar_applied = 0
            ar_mstr.ar_base_applied = 0
            ar_mstr.ar_open = true   /* CHANGED TO FALSE WHEN PAID */
            ar_mstr.ar_draft = true
            ba_total = ba_total + ar_mstr.ar_amt.
         display ba_total with frame ba.
      end.  /* TRANSACTION */
   end.  /* LOOPB */

   clear frame a no-pause.

   do transaction:
      find ba_mstr where ba_batch = batch and ba_module = "AR"
         exclusive-lock no-error.
      if available ba_mstr then do:
         if can-find(first ar_mstr where ar_batch = ba_batch) then do:
            if ba_ctrl <> ba_total then do:
               ba_status = "UB".       /* UNBALANCED */
               if ba_ctrl <> 0 then do:
                  {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=2}
                  do on endkey undo, leave:
                     pause.
                  end.
               end.
            end.
            else
                  ba_status = "".         /* OPEN & BALANCED */
         end.  /* if can-find */
         else   /* EMPTY BATCH */
         assign
            ba_status = "NU"            /* NOT USED */
            ba_ctrl = 0.                /* RESET CONTROL VALUE */
         release ba_mstr.
      end. /* if available */
   end. /* transaction */      /*END GI33*/

end.  /* MAINLOOP */

/* DELETE WORKFILES USED FOR THE AUDIT TRAIL */
for each gltw_wkfl exclusive-lock
      where gltw_userid = mfguser:
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input gltw_wkfl.gltw_exru_seq)" }
   delete gltw_wkfl.
end.
{&DMDMAP-P-TAG24}

PROCEDURE convert_amt_from_doc_to_draft:

   define input        parameter doc-curr       like ar_mstr.ar_curr.
   define input        parameter doc-ex-rate    like ar_mstr.ar_ex_rate.
   define input        parameter doc-ex-rate2   like ar_mstr.ar_ex_rate2.
   define input-output parameter amt-to-convert like ar_mstr.ar_amt.

   /* Convert Foreign Currency amt of Invoice to Base Currency */
   if doc-curr <> base_curr then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input doc-curr,
           input base_curr,
           input doc-ex-rate,
           input doc-ex-rate2,
           input amt-to-convert,
           input false, /* DO NOT ROUND */
           output amt-to-convert,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.
   end.

   /* Convert Base Currency amt to Currency of the Draft */
   if ar_mstr.ar_curr <> base_curr then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input base_curr,
           input ar_mstr.ar_curr,
           input ar_mstr.ar_ex_rate2,
           input ar_mstr.ar_ex_rate,
           input amt-to-convert,
           input false, /* DO NOT ROUND */
           output amt-to-convert,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.
   end.

   /* USE DRAFT ROUNDING METHOD, NOT */
   /* ROUNDING METHOD OF APPLY-TO MEMO/INV. */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output amt-to-convert,
        input        rndmthd,
        output       mc-error-number)"}

   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end.

END PROCEDURE.
