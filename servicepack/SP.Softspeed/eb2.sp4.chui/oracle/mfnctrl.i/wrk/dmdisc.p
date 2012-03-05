/* dmdisc.p - DRAFT MANAGEMENT DISCOUNT                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18.1.13 $                                              */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 03/10/92   BY: JJS   *F198*              */
/*                                   03/23/92   BY: JJS   *F310*              */
/*                                   06/18/92   BY: JJS   *F672*(rev only)    */
/*                                   06/24/92   BY: JJS   *F681*              */
/* REVISION: 7.3      LAST MODIFIED: 07/27/92   by: jms   *G008*              */
/*                                   09/27/93   by: jcd   *G247*              */
/*                                   11/10/92   by: mpp   *G306*              */
/* REVISION: 7.4      LAST MODIFIED: 09/09/92   BY: MPP   *G478*              */
/*                                   07/22/93   BY: pcd   *H051*              */
/*                                   02/07/94   BY: srk   *GI33*              */
/*                                   04/27/94   BY: srk   *FN70*              */
/* Oracle changes (share-locks)      09/11/94   BY: rwl   *GM24*              */
/*                                   09/15/94   BY: ljm   *GM57*              */
/*                                   10/17/94   BY: ljm   *GN36*              */
/* REVISION: 8.5      LAST MODIFIED: 01/02/96   BY: taf   *J053*              */
/* REVISION: 8.6      LAST MODIFIED: 06/18/96   BY: bjl   *K001*              */
/*                                   07/15/96   BY: *J0VY* M. Deleeuw         */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf   *J101*              */
/* REVISION: 8.6      LAST MODIFIED: 12/11/96   BY: bjl   *K01S*              */
/*                                   02/17/97   BY: *K01R* E. Hughart         */
/*                                   03/11/97   BY: *K077* E. Hughart         */
/* REVISION: 8.6      LAST MODIFIED: 08/29/97   BY: *H1DV* Samir Bavkar       */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *G2Q0* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Old ECO marker removed, but no ECO header exists *F102*                    */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *L07D* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 05/27/99   BY: *N00D* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/21/00   BY: *N0DB* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0WP* Ed van de Gevel    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18.1.10    BY: Vinod Nair      DATE: 06/29/01 ECO: *M1CN*      */
/* Revision: 1.18.1.11    BY: Kirti Desai     DATE: 02/20/02 ECO: *N19Q*      */
/* Revision: 1.18.1.12    BY: Ed van de Gevel DATE: 05/08/02 ECO: *P069*      */
/* $Revision: 1.18.1.13 $           BY: Manjusha Inglay DATE: 07/29/02 ECO: *N1P4* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}
{cxcustom.i "DMDISC.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE dmdisc_p_3 "Print Audit Trail"
/* MaxLen: Comment: */

&SCOPED-DEFINE dmdisc_p_4 "Discount Charges Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE dmdisc_p_5 "Open Amount"
/* MaxLen: Comment: */

{&DMDISC-P-TAG1}

&SCOPED-DEFINE dmdisc_p_9 "Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE dmdisc_p_10 "Bank Clearing Acct"
/* MaxLen: Comment: */

&SCOPED-DEFINE dmdisc_p_11 "Cash Acct"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable rndmthd like rnd_rnd_mthd.

define variable retval     as integer.
define variable oldcurr    like ar_curr.
define variable tmp_amt    as decimal.
define variable ar_amt_fmt as character.
define variable ar_amt_old as character.
define variable open_amt   like ar_amt label {&dmdisc_p_5}.
define variable dsc        like ard_desc.
define variable gendsc     like ard_desc.
define variable effdate    like ar_effdate.
define variable cash_acct  like ar_acct label {&dmdisc_p_11}.
define variable cash_sub   like ar_sub.
define variable cash_cc    like ar_cc.
define variable cash_amt   like ar_amt.
define variable disc_acct  like ar_acct label {&dmdisc_p_4}.
define variable disc_sub   like ar_sub.
define variable disc_cc    like ar_cc.
define variable disc_amt   like ar_amt.
define variable clear_acct like ar_acct label {&dmdisc_p_10}.
define variable clear_sub  like ar_sub.
define variable clear_cc   like ar_cc.
define variable clear_amt  like ar_amt.
{&DMDISC-P-TAG33}
define variable ref        like glt_ref.
define variable jrnl       like glt_ref.
{&DMDISC-P-TAG34}
define variable gltline    like glt_line.
define variable curr       like ar_curr.
define variable ex_rate    like ar_ex_rate.
define variable ex_rate2   like ar_ex_rate2.
define variable ex_ratetype like ar_ex_ratetype.
define variable exruseq    like ar_exru_seq.
define variable cr_or_dr_amt like ar_amt.
define variable cr_or_dr   as character format "x(2)".
define variable trns-yn    like mfc_logical.
{&DMDISC-P-TAG35}
define variable batch      like ba_batch.
{&DMDISC-P-TAG36}
define variable bactrl     like ba_ctrl.
define variable summary    like arc_sum_lvl.
define variable audit_yn   like mfc_logical label {&dmdisc_p_3}
   initial false.
define variable mc-error-number like msg_nbr no-undo.
define variable fixed_rate      like mfc_logical no-undo.

define variable valid_acct like mfc_logical.
define variable inbatch    like ba_batch.
define variable barecno    as recid.
define variable ar_recno   as recid.

{&DMDISC-P-TAG24}
define new shared frame b.

{gpglefdf.i}
assign
   gendsc = getTermLabel("DISCOUNT_OF_DRAFT",24)
   dsc    = gendsc.

{gprunpdf.i "gpglvpl" "p"}

/* DISPLAY FORM */
/* ADD FORMAT TO ACCOUNT FOR UP TO 3 DECIMAL DIGITS, THIS IS THE */
/* LARGEST POSSIBLE VALUE FOR CURRENCY DEPENDENT FORMATTING */
form
   batch    colon 8 deblank
   bactrl   label {&dmdisc_p_9} format "->>>>>>>,>>>,>>9.999"
   ba_total                     format "->>>>>>>,>>>,>>9.999"
with side-labels frame ba width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame ba:handle).

{&DMDISC-P-TAG2}
form
   ar_nbr       colon 15  format "x(8)"
   ar_bill      colon 45
   cm_sort         at 47  no-label
   effdate      colon 15
   dsc          colon 45
   ar_bank      colon 15
   ar_due_date  colon 45
   ar_entity    colon 65
   ar_amt       colon 15
   open_amt     colon 45
   ar_curr                no-label
   ar_dy_code   colon 15
   curr         colon 65
   cash_acct    colon 23
   cash_sub               no-label
   cash_cc                no-label
   cash_amt     colon 60
   disc_acct    colon 23
   disc_sub               no-label
   disc_cc                no-label
   disc_amt     colon 60
   clear_acct   colon 23
   clear_sub              no-label
   clear_cc               no-label
   clear_amt    colon 60
with frame a side-labels width 80.
{&DMDISC-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GENERAL LEDGER TRANSACTION DISPLAY FORM */
form
   /*V8! space(1) */
   ref
   /*V8! view-as text size 14 by 1 */
   gltline
   ar_acct
   ar_sub
   ar_cc
   ar_entity
   cr_or_dr_amt
   cr_or_dr no-label
with down frame b width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* ASSIGN FORMATS TO _OLD VARIABLES */
assign
   ar_amt_old = ar_amt:format
   effdate = today.

/* READ CONTROL FILES */
find first gl_ctrl no-lock.

find first arc_ctrl no-lock no-error.
if available arc_ctrl
then do:
   summary = arc_sum_lvl.
   release arc_ctrl.
end.

view frame ba.

mainloop:
repeat with frame ba:
   /* IF THE RECORDS ARE SUMMARIZED ONE REFERENCE NUMBER IS USED FOR */
   /* THE ENTIRE BATCH.  IF DETAIL IS USED THE REFERENCE NUMBER WILL */
   /* BE PICKED UP ONCE THE DRAFT IS COMMITTED FOR APPROVAL.         */

   if summary = 2
   then do:
      do transaction:
         /* GET NEXT JOURNAL REFERENCE NUMBER  */

         {&DMDISC-P-TAG4}
         {mfnctrl.i arc_ctrl arc_jrnl glt_det
            "glt_ref matches '*' + string(arc_jrnl) and string(arc_jrnl)"
            jrnl}
         {&DMDISC-P-TAG5}

         /* GET JOURNAL ENTRY REFERENCE NUMBER */
         ref = "AR" + substring(string(year(today),"9999"),3,2)
                    + string(month(today),"99")
                    + string(day(today),"99")
                    + string(integer(jrnl),"999999").
      end.  /* transaction */
   end.  /* if summary */
   {&DMDISC-P-TAG6}

   /* ALLOW ENTRY OF AN EXISTING OR NEW BATCH NUMBER */
   do transaction:
      assign
         bactrl = 0
         batch  = "".

      set batch with frame ba.

      if batch <> ""
      then do:
         find first ar_mstr where ar_batch = batch no-lock
            no-error.
         if available ar_mstr and index("D",ar_type) = 0
         then do:
            /* NOT A VALID BATCH */
            {pxmsg.i &MSGNUM=1170 &ERRORLEVEL=3}
            next-prompt batch with frame ba.
            undo, retry.
         end.

         if can-find(first gltr_hist where gltr_batch = batch)
         then do:
            /* BATCH HAS BEEN POSTED IN G/L */
            {pxmsg.i &MSGNUM=3523 &ERRORLEVEL=3}
            next-prompt batch with frame ba.
            undo, retry.
         end.

         find ba_mstr where ba_batch = batch and ba_module = "AR"
            exclusive-lock no-error.
         if available ba_mstr
         then do:
            assign
               bactrl = ba_ctrl
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

      else
         display
            0 @ bactrl
            0 @ ba_total
         with frame ba.

      update bactrl with frame ba.

      /*ADDED PROCEDURE TO GET THE NEXT BATCH NUMBER AND CREATE*/
      /*THE BATCH MASTER (BA_MSTR).                            */
      inbatch = batch.
      {gprun.i ""gpgetbat.p"" "(input inbatch,  /*IN-BATCH#      */
                                input ""AR"",   /*MODULE         */
                                input ""D"",    /*DOC TYPE       */
                                input bactrl,   /*CONTROL AMT    */
                                output barecno, /*NEW BATCH RECID*/
                                output batch)"} /*NEW BATCH #    */
      display batch with frame ba.

   end. /* TRANSACTION */
   {&DMDISC-P-TAG7}

   loopb:
   repeat with frame a:
      do transaction:
         clear frame b all.
         clear frame a no-pause.

         /* RE-INITIALIZE CASH AND DISCOUNT CHARGES AMOUNT */
         assign
            cash_amt = 0
            disc_amt = 0.

         prompt-for ar_nbr with frame a
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i ar_mstr ar_nbr ar_nbr batch ar_batch ar_batch}
            if recno <> ?
            then do:
               if (oldcurr <> ar_curr) or (oldcurr = "")
               then do:
                  if ar_curr = gl_base_curr
                  then
                     rndmthd = gl_rnd_mthd.
                  else do:
                     /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                     {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input ar_curr,
                          output rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        undo loopb.
                     end.
                  end.

                  /* SET AR_AMT_FMT */
                  ar_amt_fmt = ar_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                            input rndmthd)"}
                  assign
                     ar_amt:format   = ar_amt_fmt
                     open_amt:format = ar_amt_fmt
                     cash_amt:format = ar_amt_fmt
                     disc_amt:format = ar_amt_fmt
                     clear_amt:format = ar_amt_fmt
                     oldcurr = ar_curr.
               end.  /* if (oldcurr <> ar_curr) or (oldcurr = "") */

               assign
                  open_amt = ar_amt - ar_applied
                  dsc      = getTermLabel("DISCOUNT_OF_DRAFT",15) + " " + ar_nbr.

               display
                  ar_nbr
                  ar_bill
                  ar_bank
                  ar_due_date
                  ar_curr
                  ar_entity
                  ar_amt
                  open_amt
               with frame a.
               {&DMDISC-P-TAG8}
               find cm_mstr where cm_addr = ar_bill no-lock
                  no-error.
               if available cm_mstr then display cm_sort with frame a.
               else display " " @ cm_sort with frame a.
            end.  /* RECNO <> ? */
         end.  /* EDITING */

         find ar_mstr using ar_nbr no-error.
         if not available ar_mstr
         then do:
            /* DRAFT NOT FOUND */
            {pxmsg.i &MSGNUM=3500 &ERRORLEVEL=3}
            undo loopb.
         end.
         if ar_type <> "D"
         then do:
            /* RECORD IS NOT DRAFT */
            {pxmsg.i &MSGNUM=3502 &ERRORLEVEL=3}
            undo loopb.
         end.
         {&DMDISC-P-TAG25}
         if not (ar_draft and ar_open)
         then do:
         /* DRAFT IS NOT APPROVED OR ALREADY CLOSED */
            {pxmsg.i &MSGNUM=3528 &ERRORLEVEL=3}
            undo loopb.
         end.
         find first ard_det where ard_ref = ar_nbr
            and ard_type begins "C" no-lock no-error.
         {&DMDISC-P-TAG26}
         if available ard_det
         then do:
            /* DRAFT HAS ALREADY BEEN DISCOUNTED */
            {pxmsg.i &MSGNUM=3531 &ERRORLEVEL=3}
            undo loopb.
         end.

         if (oldcurr <> ar_curr) or (oldcurr = "")
         then do:
            if ar_curr = gl_base_curr
            then
               rndmthd = gl_rnd_mthd.
            else do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input ar_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo loopb.
               end.
            end.

            /* SET AR_AMT_FMT */
            ar_amt_fmt = ar_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                      input rndmthd)"}
            assign
               curr             = ar_curr
               ar_amt:format    = ar_amt_fmt
               open_amt:format  = ar_amt_fmt
               cash_amt:format  = ar_amt_fmt
               disc_amt:format  = ar_amt_fmt
               clear_amt:format = ar_amt_fmt
               oldcurr          = ar_curr.
         end.  /* if (oldcurr <> ar_curr) or (oldcurr = "") */

         assign
            dsc      = getTermLabel("DISCOUNT_OF_DRAFT",15) + " " + ar_nbr
            open_amt = ar_amt - ar_applied.

         display
            ar_nbr
            ar_bill
            ar_bank
            ar_due_date
            ar_curr
            ar_entity
            ar_dy_code
            ar_amt
            open_amt
         with frame a.

         find cm_mstr where cm_addr = ar_bill no-lock no-error.
         if available cm_mstr then display cm_sort with frame a.
         else display " " @ cm_sort with frame a.

         find bk_mstr where bk_code = ar_bank no-lock no-error.
         {&DMDISC-P-TAG9}
         if available bk_mstr
         then do:
            assign
               cash_acct = bk_acct
               cash_sub  = bk_sub
               cash_cc   = bk_cc.

            display
               cash_acct
               cash_sub
               cash_cc
            with frame a.
         end.
         {&DMDISC-P-TAG10}

         curr = ar_curr.
         display curr with frame a.

         display
            effdate
            dsc
            ar_bank
            cash_acct
            cash_sub
            cash_cc
            cash_amt
            ar_dy_code
            disc_acct
            disc_sub
            disc_cc
            disc_amt
            clear_acct
            clear_sub
            clear_cc
         with frame a.
         {&DMDISC-P-TAG11}

         loopa:
         do on error undo, retry:
            allow-gaps = no.
            if daybooks-in-use and ar_dy_code > ""
            then do:
               {gprunp.i "nrm" "p" "nr_can_void"
                  "(input  ar_dy_code,
                    output allow-gaps)"}
            end. /* if daybooks-in-use and ar_dy_code > "" */

            {&DMDISC-P-TAG12}
            set
               effdate
               dsc
               ar_bank
               ar_dy_code when (daybooks-in-use and
                               (new ar_mstr or allow-gaps))
               cash_acct
               cash_sub
               cash_cc
               cash_amt
               disc_acct
               disc_sub
               disc_cc
               disc_amt
               clear_acct
               clear_sub
               clear_cc
            with frame a.

            if (cash_amt <> 0)
            then do:
               {gprun.i ""gpcurval.p"" "(input cash_amt,
                                         input rndmthd,
                                         output retval)"}
               if (retval <> 0)
               then do:
                  next-prompt cash_amt.
                  undo loopa, retry loopa.
               end.
            end.

            if (disc_amt <> 0)
            then do:
               {gprun.i ""gpcurval.p"" "(input disc_amt,
                                         input rndmthd,
                                         output retval)"}
               if (retval <> 0)
               then do:
                  next-prompt disc_amt.
                  undo loopa, retry loopa.
               end.
            end.

            clear_amt = cash_amt + disc_amt.
            display clear_amt with frame a.
            {&DMDISC-P-TAG13}

            /* CHECK EFFECTIVE DATE AGAINST GL CALENDAR */
            find first gl_ctrl no-lock no-error.
            if available gl_ctrl and gl_verify = yes
            then do:
               /* CHANGED SECOND PARAMETER FROM glentity TO ar_entity */
               {gpglef.i ""AR"" ar_entity effdate "loopa"}
            end.

            find bk_mstr where bk_code = ar_bank no-lock no-error.
            if not available bk_mstr
            then do:
               /* INVALID BANK */
               {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}
               next-prompt ar_bank with frame a.
               undo loopa, retry.
            end.
            {&DMDISC-P-TAG14}

            if curr <> ar_curr and curr <> base_curr
            then do:
               /* CURRENCY MUST BE ar_curr OR base_curr */
               {pxmsg.i &MSGNUM=3100
                        &ERRORLEVEL=3
                        &MSGARG1=ar_curr
                        &MSGARG2=base_curr}

               next-prompt curr with frame a.
               undo loopa, retry.
            end.
            {&DMDISC-P-TAG15}

            if clear_amt <> open_amt
            then do:
               /* DISCOUNTED AMOUNT MUST EQUAL DRAFT AMOUNT */
               {pxmsg.i &MSGNUM=3529 &ERRORLEVEL=3}
               next-prompt cash_amt with frame a.
               undo loopa, retry.
            end.

            /* CHECK GL ACCOUNT/COST CENTER */

            /* ACCT/SUB/CC VALIDATION */
            {&DMDISC-P-TAG27}
            run ip-validate
               (input cash_acct, input cash_sub, input cash_cc).

            if valid_acct = no
            then do:
               next-prompt cash_acct with frame a.
               undo, retry.
            end.
            {&DMDISC-P-TAG28}

            run ip-validate
               (input disc_acct, input disc_sub, input disc_cc).

            if valid_acct = no
            then do:
               next-prompt disc_acct with frame a.
               undo, retry.
            end.

            {&DMDISC-P-TAG29}
            run ip-validate
               (input clear_acct, input clear_sub, input clear_cc).

            if valid_acct = no
            then do:
               next-prompt clear_acct with frame a.
               undo, retry.
            end.
            {&DMDISC-P-TAG30}

            /* CHECK THAT ACCOUNTS ARE BASE CURR OR DRAFT CURR */
            find ac_mstr where
               ac_code = cash_acct
               no-lock no-error.

            if available ac_mstr and ac_curr <> ar_curr
                                 and ac_curr <> base_curr
            then do:
               /* ACCOUNT CURRENCY MUST BE DOCUMENT CURRENCY */
               /* OR BASE CURRENCY                           */
               {pxmsg.i &MSGNUM=2254 &ERRORLEVEL=3}
               next-prompt cash_acct with frame a.
               undo loopa, retry.
            end.
            find ac_mstr where
               ac_code = disc_acct
               no-lock no-error.

            if available ac_mstr and ac_curr <> ar_curr
                                 and ac_curr <> base_curr
            then do:
               /* ACCOUNT CURRENCY MUST BE DOCUMENT CURRENCY */
               /* OR BASE CURRENCY                           */
               {pxmsg.i &MSGNUM=2254 &ERRORLEVEL=3}
               next-prompt disc_acct with frame a.
               undo loopa, retry.
            end.

            find ac_mstr where
               ac_code = clear_acct
               no-lock no-error.

            if available ac_mstr and ac_curr <> ar_curr
                                 and ac_curr <> base_curr
            then do:
               /* ACCOUNT CURRENCY MUST BE DOCUMENT CURRENCY */
               /* OR BASE CURRENCY                           */
               {pxmsg.i &MSGNUM=2254 &ERRORLEVEL=3}
               next-prompt clear_acct with frame a.
               undo loopa, retry.
            end.

            /* VERIFY DAYBOOK */
            if daybooks-in-use and (new ar_mstr or allow-gaps)
            then do:
               if not can-find(dy_mstr where dy_dy_code = ar_dy_code)
               then do:
                  /* ERROR: INVALID DAYBOOK */
                  {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
                  next-prompt ar_dy_code with frame a.
                  undo loopa, retry.
               end.
               else do:
                  {gprun.i ""gldyver.p"" "(input ""AR"",
                                           input ar_type,
                                           input ar_dy_code,
                                           input ar_entity,
                                           output daybook-error)"}
                  if daybook-error
                  then do:
                     /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                     {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                     pause.
                  end. /* if daybook-error */

                  {gprunp.i "nrm" "p" "nr_can_dispense"
                     "(input ar_dy_code,
                       input effdate)"}

                  {gprunp.i "nrm" "p" "nr_check_error"
                     "(output daybook-error,
                       output return_int)"}

                  if daybook-error
                  then do:
                     {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                     next-prompt ar_dy_code with frame a.
                     undo loopa, retry.
                  end.

                  find dy_mstr where dy_dy_code = ar_dy_code
                     no-lock no-error.
                  if available dy_mstr
                  then
                     assign
                        dft-daybook = ar_dy_code
                        daybook-desc = dy_desc.
               end. /* ELSE DO */
            end. /* if daybooks-in-use and ... */
         end.  /* LOOPA */

         /* SET EXCHANGE RATE*/
         if ar_curr <> base_curr
         then do:
            setb_sub:
            do on error undo, retry:
               /* GET EXCHANGE RATE AND ALSO CREATE THE  */
               /* RATE USAGE RECORD IF TRIANGULATED RATE */
               {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input curr,
                    input base_curr,
                    input ex_ratetype,
                    input effdate,
                    output ex_rate,
                    output ex_rate2,
                    output exruseq,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               end.

               /* PROC mc-ex-rate-input TO PROMPT THE USER FOR EXCHANGE RATE */
               {gprunp.i "mcui" "p" "mc-ex-rate-input"
                  "(input curr,
                    input base_curr,
                    input effdate,
                    input exruseq,
                    input false, /* DO NOT PROMPT FOR fixed (y/n) */
                    input frame a:row + 7,
                    input-output ex_rate,
                    input-output ex_rate2,
                    input-output fixed_rate)"}
            end. /* SETB_SUB */
         end. /* AR_CURR <> BASE_CURR */
         {&DMDISC-P-TAG31}
      end.  /* TRANSACTION */

      do transaction:
         {&DMDISC-P-TAG32}
         /* CREATE DETAIL AND GL TRANSACTIONS */
         /* THE ARD_TYPE FIELD IS SET TO C1, C2 OR C3 TO HELP */
         /* RELOCATE THE ARD_DET DURING REVERSAL.  SINCE THE  */
         /* FORMAT ON TYPE IS "X(1)" ONLY THE "C" WILL PRINT  */
         /* ON REPORTS - IF THESE RECORDS ARE EVERY SHOWN ON  */
         /* A REPORT.                                         */

         if summary = 2
         then do:
            /* THE REFERENCE NUMBER WAS PICKED UP AT THE BEGINNING; */
            /* HOWEVER, IF THIS DRAFT IS PART OF THE AN OLDER BATCH */
            /* IT MUST HAVE THE SAME REFERENCE NUMBER AND EFFECTIVE */
            /* DATE IN ORDER TO POST CORRECTLY IN G/L               */
            find glt_det where glt_batch = ar_batch no-lock no-error.
            if available glt_det
            then
               assign
                  effdate = glt_effdate
                  ref     = glt_ref.
         end.

         else if summary = 1 or summary = 3
         then do:
            /* GET NEXT JOURNAL REFERENCE NUMBER  */

            {&DMDISC-P-TAG16}
            {mfnctrl.i arc_ctrl arc_jrnl glt_det
               "glt_ref matches '*' + string(arc_jrnl) and
                                      string(arc_jrnl)" jrnl}
            {&DMDISC-P-TAG17}

            /* GET JOURNAL ENTRY REFERENCE NUMBER */
            ref = "AR" + substring(string(year(today),"9999"),3,2)
                       + string(month(today),"99")
                       + string(day(today),"99")
                       + string(integer(jrnl),"999999").
         end.

         /* CREATE BATCH IF NEW */
         assign
            ar_batch = batch
            ar_recno = recid(ar_mstr).

         /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
         /* ADDED cash_sub, disc_sub and clear_sub */
         {&DMDISC-P-TAG18}
         {gprun.i ""dmdiscgl.p"" "(input curr,
                                   input audit_yn,
                                   input batch,
                                   input effdate,
                                   input ar_recno,
                                   input ref,
                                   input ex_rate,
                                   input ex_rate2,
                                   input ex_ratetype,
                                   input exruseq,
                                   input cash_acct,
                                   input cash_sub,
                                   input cash_cc,
                                   input cash_amt,
                                   input disc_acct,
                                   input disc_sub,
                                   input disc_cc,
                                   input disc_amt,
                                   input clear_acct,
                                   input clear_sub,
                                   input clear_cc,
                                   input clear_amt)"}
         {&DMDISC-P-TAG19}

         trns-yn = true.

         /* ARE TRANASACTIONS CORRECT? */
         {pxmsg.i &MSGNUM=3530
                  &ERRORLEVEL=1
                  &CONFIRM=trns-yn}

         if not trns-yn then undo loopb, retry.

         /* THE FOLLOWING NEW FIELDS FOR DRAFT DISCOUNTING HAVE BEEN
          * ADDED (SEE NEW CODE BELOW) -
          * 1) ar_sale_amt (rate) WILL NOW BE STORED IN ar_dd_ex_rate,
          * 2) ar_mrgn_amt NOT TO BE UPDATED ANY MORE DUE TO 2 PART RATE,
          * 3) ar_slspsn[1] WILL NOW BE STORED IN ar_dd_curr.       */
         /* UNTIL FIELDS FOR DRAFT DISCOUNTING CAN BE ADDED TO THE  */
         /* AR_MSTR THESE 'OTHER' FIELDS WILL BE USED.  THE POSSIBLE*/
         /* COMPLICATION IS THE WAY REPORTS MIGHT PICK UP THESE     */
         /* FIELDS.  IT IS NECESSARY TO MAKE SURE THAT REPORTS THAT */
         /* REFERENCE THE AR_MSTR DON'T LOOK AT TYPE "D" RECORDS,   */
         /* UNLESS THEY ARE SPECIFICALLY REQUESTED                  */
         assign
            ar_dd_ex_rate  = ex_rate       /* FOREIGN PART */
            ar_dd_ex_rate2 = ex_rate2      /* BASE PART */
            ar_dd_exru_seq = exruseq       /* RATE USAGE SEQ NO */
            ar_dd_curr     = curr
            ar_slspsn[2]   = batch
            ar_tax_date    = effdate.

         {&DMDISC-P-TAG20}
         find ba_mstr where ba_batch = batch and ba_module = "AR"
            no-error.
         ba_total = ba_total + ar_mstr.ar_amt.
         display ba_total with frame ba.
      end.  /* TRANSACTION */
   end.  /* LOOPB */

   /* UPDATE BATCH STATUS */
   {&DMDISC-P-TAG21}
   if not available ba_mstr
   then
      find ba_mstr where ba_batch = batch and ba_module = "AR"
         no-error.

   do transaction:
      {&DMDISC-P-TAG22}
      if can-find(first ar_mstr where ar_batch = ba_batch)
      then do:
         if ba_ctrl <> ba_total
         then do:
            ba_status = "UB".   /*UNBALANCED*/
            if ba_ctrl <> 0
            then do:
               /*BATCH CONTROL TOTAL DOES NOT EQUAL TOTAL */
               {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=2}
               pause.
            end.
         end.
         else ba_status = "".   /*OPEN,BALANCED*/
      end.
      else
         assign
            ba_status = "NU"   /*NOT USED*/
            ba_ctrl   = 0.

      release ba_mstr.
   end.   /* TRANSACTION */

end.  /* MAINLOOP */

for each gltw_wkfl exclusive-lock where gltw_userid = mfguser:
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input gltw_wkfl.gltw_exru_seq)" }
   delete gltw_wkfl.
end.

PROCEDURE ip-validate:
   define input parameter ip-acct as character no-undo.
   define input parameter ip-sub  as character no-undo.
   define input parameter ip-cc   as character no-undo.

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* SET PROJECT VERIFICATION TO NO */
   {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

   /* ACCT/SUB/CC VALIDATION */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input ip-acct,
        input ip-sub,
        input ip-cc,
        input """",
        output valid_acct)"}

END PROCEDURE.  /* ip-validate */
{&DMDISC-P-TAG23}
