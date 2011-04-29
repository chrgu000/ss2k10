/* arpamt1a.p - AR APPLY UNAPPLIED PAYMENT APPLICATION LINES                  */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.57.1.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0      LAST MODIFIED: 04/11/89   BY: MLB *B099*                */
/* REVISION: 6.0      LAST MODIFIED: 08/28/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 10/11/90   BY: afs *D088*                */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: afs *D241*                */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: afs *D258*                */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: MLB *D360*                */
/* REVISION: 6.0      LAST MODIFIED: 05/03/91   BY: MLV *D595*                */
/* REVISION: 6.0      LAST MODIFIED: 06/17/91   BY: afs *D709*                */
/* REVISION: 6.0      LAST MODIFIED: 08/08/91   BY: afs *D817*                */
/* REVISION: 6.0      LAST MODIFIED: 09/04/91   BY: MLV *D848*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*                */
/* REVISION: 6.0      LAST MODIFIED: 12/04/91   BY: MLV *D956*                */
/* REVISION: 7.0      LAST MODIFIED: 03/30/92   by: jms *F332*                */
/*                                                  (cosmetic changes)        */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   by: mpp *G476*                */
/*                                   03/22/93   by: jjs *G856*                */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   by: slm *GM15*                */
/* REVISION: 7.3      LAST MODIFIED: 10/17/94   by: ljm *GN36*                */
/* REVISION: 7.3      LAST MODIFIED: 11/06/94   by: ame *GO18*                */
/*                                   11/30/94   by: jzw *FU38*                */
/*                                   02/14/95   by: str *F0J4*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/96   by: ccc *J053*                */
/* REVISION: 7.3      LAST MODIFIED: 06/27/96   by: jwk *G1YD*                */
/* REVISION: 7.3      LAST MODIFIED: 06/29/96   by: taf *J101*                */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   by: bjl *K01G*                */
/* REVISION: 8.6      LAST MODIFIED: 02/10/98   BY: *J2DY* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00K* rup                */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01Y* Karel Groos        */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *J2PY* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *J2Y6* Hemali Desai       */
/* REVISION: 8.6E     LAST MODIFIED: 12/03/98   BY: *L0CS* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/99   BY: *L0F2* Jose Alex          */
/* REVISION: 8.5      LAST MODIFIED: 06/08/99   BY: *J3GT* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.0      LAST MODIFIED: 07/28/99   BY: *M0CX* Paul Dreslinski    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0WP* BalbeerS Rajput    */
/* REVISION: 8.6E     LAST MODIFIED: 01/12/01   BY: *L17C* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.34      BY: Vinod Nair           DATE: 03/28/01 ECO: *M149*    */
/* Revision: 1.35      BY: Alok Thacker         DATE: 07/19/01 ECO: *M169*    */
/* Revision: 1.36      BY: Santhosh Nair        DATE: 01/16/02 ECO: *M1TD*    */
/* Revision: 1.37      BY: Jose Alex            DATE: 10/10/02 ECO: *N1WN*    */
/* Revision: 1.38      BY: Shoma Salgaonkar     DATE: 01/21/03 ECO: *N24K*    */
/* Revision: 1.40      BY: W.Palczynski         DATE: 05/13/03 ECO: *P0R8*    */
/* Revision: 1.41      BY: Narathip W.          DATE: 05/19/03 ECO: *P0SH*    */
/* Revision: 1.43      BY: Paul Donnelly (SB)   DATE: 06/26/03 ECO: *Q00B*    */
/* Revision: 1.45      BY: Vivek Gogte          DATE: 08/04/03 ECO: *N2J0*    */
/* Revision: 1.47      BY: P. Grzybowski        DATE: 08/25/03 ECO: *P10G*    */
/* Revision: 1.48      BY: Ed van de Gevel      DATE: 07/13/04 ECO: *Q0BB*    */
/* Revision: 1.50      BY: Sukhad Kulkarni      DATE: 07/28/04 ECO: *P2CF*    */
/* Revision: 1.51      BY: Bharath Kumar        DATE: 08/05/04 ECO: *P2FB*    */
/* Revision: 1.53      BY: Preeti Sattur        DATE: 02/23/05 ECO: *P39F*    */
/* Revision: 1.54      BY: Bhagyashri Shinde    DATE: 03/15/05 ECO: *P3CQ*    */
/* Revision: 1.56      BY: Bhavik Rathod        DATE: 05/10/05 ECO: *P3KD*    */
/* Revision: 1.57      BY: Alok Gupta           DATE: 09/08/05 ECO: *Q0LL*    */
/* $Revision: 1.57.1.1 $        BY: Reena Ambavi         DATE: 09/27/05 ECO: *P42Z*    */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARPAMT1A.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{etvar.i}
{gldydef.i}
{gldynrm.i}
{gpglefdf.i}

{xxgpdescm1.i }     /* SS - 110114.1 */


define shared frame b.

define new shared variable gltline like glt_line.
define new shared variable arbuff_recno as recid.
define new shared variable ard_recno as recid.
define new shared variable undo_all like mfc_logical.
define new shared variable base_det_amt like glt_amt.
define new shared variable det_ex_rate like glt_ex_rate.
define new shared variable det_ex_rate2 like glt_ex_rate2.


/* NO-UNDO COMMENTED OUT TO MAINTAIN CONSISTENCY IN DEFINITION */
/* OF aply2_rndmthd WITH PARENT PROGRAM                        */
define shared variable aply2_rndmthd    like rnd_rnd_mthd.
define shared variable pmt_rndmthd      like rnd_rnd_mthd.
define shared variable ar_recno         as recid.
define shared variable unappamt         like ar_amt label "Unapplied".
{&ARPAMT1A-P-TAG20}
define shared variable tot_amt_to_apply like ar_amt
                                        label "Amt to Apply".
define shared variable tot_amt_open     like ar_amt label "Unapplied Amt".
define shared variable base_amt         like ar_amt.
define shared variable gain_amt         like ar_amt.
define shared variable curr_amt         like ar_amt.
define shared variable check_amt        like ar_amt label "Amt of Check".

define variable old_doccurr        like ar_curr.
define variable amt_open           like ar_amt label "Amount Open".
define variable ardamt             like ard_amt label "Amt to Apply".
define variable old_ard_amt        like ard_amt.
define variable del-yn             like mfc_logical initial no.
define variable tmp_amt            as decimal.
define variable amt_app_old        as character initial "->>>>,>>>,>>9.99".
define variable amt_app_fmt        as character.
define variable retval             as integer.
define variable apply2_rndmthd     like rnd_rnd_mthd.
define variable rndmthd            like rnd_rnd_mthd.
define variable amt_to_apply       like ar_amt label "Amt to Apply".
define variable old_amt_to_apply   like amt_to_apply.
define variable old_amt            like ard_amt.
define variable pmt_ex_rate        like ar_ex_rate.
define variable pmt_ex_rate2       like ar_ex_rate2.
define variable exch_var           as decimal.
define variable first_foreign      like mfc_logical.
define variable reset_ok           like mfc_logical.
define variable new_abd_det        like mfc_logical.
define variable is_transparent     like mfc_logical no-undo.
define variable l_yn               like mfc_logical initial no no-undo.
define variable l_lcommit          as integer initial 0 no-undo.
define variable l_ref              as character     format "X(14)" no-undo.

/*VARS. inv_to_base_rate, rate2 REPLACES ar__dec01 INTRODUCED IN ETK*/
define variable inv_to_base_rate   like ar_mstr.ar_ex_rate  no-undo.
define variable inv_to_base_rate2  like ar_mstr.ar_ex_rate2 no-undo.
define variable comb_exch_rate     like ar_ex_rate          no-undo.
define variable comb_exch_rate2    like ar_ex_rate          no-undo.
define variable temp_exch_rate     like ar_ex_rate          no-undo.
define variable temp_exch_rate2    like ar_ex_rate          no-undo.
define variable l_unrnd_amt        like ar_amt              no-undo.
define variable l_rnd_amt          like ar_base_amt         no-undo.
define variable l_unrnd_appl_amt   like ar_applied          no-undo.
define variable l_rnd_appl_amt     like ar_base_applied     no-undo.
define variable l_gl_create        like mfc_logical         no-undo initial no.
define variable l_new_ard          like mfc_logical         no-undo initial no.
define variable l_round_amt        like ar_base_applied     no-undo.

/* BUFFERS: armstr   is the unapplied payment application itself          */
define buffer apply_to for ar_mstr.
define buffer payment  for ar_mstr.
define buffer armstr3  for ar_mstr.
define buffer arddet   for ard_det.
define buffer arddet1  for ard_det.
define buffer arddet2  for ard_det.
define buffer arddet3  for ard_det.

define temp-table t_store_glt_ref no-undo
   field t_ar_dy_code like ar_dy_code
   field t_ar_effdate like ar_effdate
   field t_ard_nbr    like ard_nbr
   field t_ref        as character format "X(14)"
   index t_recid t_ref.
define input-output parameter table for t_store_glt_ref.

find first arc_ctrl  where arc_ctrl.arc_domain = global_domain no-lock.
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

find ar_mstr where recid(ar_mstr) = ar_recno.
find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
ar_mstr.ar_bill no-lock no-error.
global_addr = ar_bill.
{&ARPAMT1A-P-TAG1}
/* DEFINE SHARED FRAME B FOR APPLICATION HEADER AND RUNNING TOTALS */
{arpa01fm.i}

form
   ard_ref
   ard_type
   ard_acct
   ard_sub
   ard_cc
   ardamt
with frame d 1 down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   amt_open colon 19 skip
   apply_to.ar_curr no-label
   amt_to_apply
   /* NO NEED TO PROMPT FOR VAR ACCOUNTS SINCE GAIN */
   /* AND LOSS ACCTS NOW LINKED WITH EACH CURRENCY */
with frame set1_sub attr-space overlay side-labels row 12 column 42.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set1_sub:handle).

/* INITIALIZE CURR DEPENDENT ROUNDING FORMATS */
assign
   ardamt:format = unappamt:format   /* ALWAYS payment except ar_domain.
   CURRENCY FMT */
   amt_app_fmt   = amt_app_old
   unappamt      = tot_amt_to_apply.

/* GET INVOICE OR MEMO TO BASE EXCHANGE RATE FROM qad_wkfl */
{argetwfl.i
   ar_mstr.ar_nbr
   inv_to_base_rate
   inv_to_base_rate2}

loopc:
repeat for apply_to:
   for each ard_det  where ard_det.ard_domain = global_domain and  ard_nbr =
   ar_mstr.ar_nbr
   no-lock:
      unappamt = unappamt - ard_amt.
   end.
   display  unappamt with frame b.

   do while l_lcommit = 0:
      loope:
      repeat with frame d:
         unappamt = tot_amt_to_apply.
         for each ard_det  where ard_det.ard_domain = global_domain
            and  ard_nbr =  ar_mstr.ar_nbr
         no-lock:
            unappamt = unappamt - ard_amt.
         end.
         display unappamt with frame b.

         clear frame d.

         prompt-for ard_det.ard_ref with frame d
         editing:
            {mfnp01.i ard_det ard_ref ard_ref ard_nbr  " ard_det.ard_domain =
            global_domain and ar_mstr.ar_nbr "
               ard_nbr}
            if recno <> ? then do:
               display
                  ard_ref
                  ard_type
                  ard_acct
                  ard_sub
                  ard_cc
                  ard_amt @ ardamt
               with frame d.
            end.
         end.
         if input ard_ref = "" then do:
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            undo, retry.
         end.

         for first apply_to no-lock
             where apply_to.ar_domain = global_domain
                and  apply_to.ar_nbr =  input ard_ref:
         end.
         if available apply_to
         then do:
            if apply_to.ar_type = "D"
               and not apply_to.ar_draft
            then do:
               /* UNAPPROVED DRAFTS CANNOT BE PAID */
               {pxmsg.i &MSGNUM=3533 &ERRORLEVEL=3}
               undo, retry.
            end.

            {gpglef01.i
               ""AR""
               apply_to.ar_entity
               ar_mstr.ar_effdate}

            if gpglef > 0
            then do:
               /* PERIOD HAS BEEN CLOSED FOR ENTITY */
               {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=3}
               undo loope, retry loope.
            end.
         end. /* IF AVAILABLE APPLY_TO */

         {&ARPAMT1A-P-TAG2}
         /* ADD/MOD/DELETE  */
         find first ard_det  where ard_det.ard_domain = global_domain and  ard_ref
         = input ard_ref
            and ard_nbr = ar_mstr.ar_nbr no-error.

         new_abd_det = false.
         if not available ard_det then do:
            /* VALIDATE WHETHER AN ATTEMPT IS BEING MADE TO APPLY AN UNAPPLIED */
            /* PAYMENT AGAINST A REFERENCE WHICH IS ALREADY CLOSED.            */

            find ar_mstr  where ar_mstr.ar_domain = global_domain and
            ar_mstr.ar_nbr = input ard_ref
            no-lock no-error.
            if (available(ar_mstr) and (not ar_mstr.ar_open)) then do:
               /* REFERENCE IS ALREADY CLOSED.                             */
               /* ISSUES AN ERROR WHEN CLOSED REFERENCE IS SELECTED FOR    */
               /* PAYMENT.                                                 */
               {pxmsg.i &MSGNUM=3541 &ERRORLEVEL=3}
               undo, retry.
            end. /* IF (AVAILABLE(AR_MSTR)...                           */
            find ar_mstr where recid(ar_mstr) = ar_recno.
            {&ARPAMT1A-P-TAG21}

            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
            create ard_det. ard_det.ard_domain = global_domain.
            assign
               ard_nbr     = ar_mstr.ar_nbr
               ard_dy_code = dft-daybook
               ard_desc    = ar_mstr.ar_po   /* SS - 110114.1 */
               ard_ref.
            new_abd_det = true.

            l_new_ard = yes.

            if recid(ard_det) = -1 then .
         end.
         else do: /*MODIFY*/

            l_new_ard = no.

            /* BACK OUT APPLY UNAPPLIED TOTAL */
            assign
               ar_mstr.ar_amt = ar_mstr.ar_amt - ard_amt
               l_unrnd_amt    = ard_amt.

            /* WHEN INV AND PMT CURR DO NOT MATCH AND BOTH ARE FOREIGN */
            /* USE ard_cur_amt IN PLACE OF ard_amt SINCE ar_mstr.ar_amt*/
            /* AND ard_amt ARE IN INVOICE CURRENCY AND ard_amt REMAINS */
            /* IN PMT CURR.*/
            if ar_mstr.ar_curr = apply_to.ar_curr then
               assign
                  ar_mstr.ar_applied = ar_mstr.ar_applied - ard_amt
                  l_unrnd_appl_amt   = ard_amt.
            else
               assign
                  ar_mstr.ar_applied = ar_mstr.ar_applied - ard_cur_amt
                  l_unrnd_appl_amt   = ard_cur_amt.

            unappamt = tot_amt_to_apply - ar_mstr.ar_amt.

            /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY */
            /* AND THEN ACCUMULATE IT TO ar_base_amt TO AVOID   */
            /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.   */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input ar_mstr.ar_curr,
                  input base_curr,
                  input ar_mstr.ar_ex_rate,
                  input ar_mstr.ar_ex_rate2,
                  input l_unrnd_amt,
                  input true, /* ROUND */
                  output l_rnd_amt,
                  output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
            end.

            ar_mstr.ar_base_amt = ar_mstr.ar_base_amt - l_rnd_amt.

            /* CHANGES MADE TO CONVERT ard_amt OR ar_cur_amt TO BASE */
            /* CURRENCY AND THEN ACCUMULATE IT TO ar_base_applied TO */
            /* AVOID ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.  */

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

            /* BACK OUT GENERAL LEDGER TRANSACTIONS */
            /* STORE OLD AMT TO UNDO EXCH GAIN/LOSS DURING GL UPDATE*/
            old_ard_amt = ard_amt.
            /*CONVERT INTO BASE HERE. */
            /* 'BASE_AMT' USES EXCHANGE RATE IN EFFECT AT */
            /*            PAYMENT DATE.                   */
            /* 'BASE_DET_AMT' USES EXCHANGE RATE IN       */
            /*                EFFECT AT DOCUMENT DATE.    */
            assign
               base_amt     = - ard_amt
               base_det_amt = - ard_amt
               gain_amt     = 0
               curr_amt     = - ard_amt.

            /* 'APPLY-TO' IS THE AR_MSTR FOR THE DOCUMENT TO WHICH */
            /* THE PAYMENT WAS APPLIED.                            */
            find apply_to  where apply_to.ar_domain = global_domain and
            apply_to.ar_nbr = ard_det.ard_ref
               no-lock.
            {&ARPAMT1A-P-TAG22}

            /* THIS PROC CONTAINS OLD LOGIC THAT REPLACES ABOVE CODE */
            run compute_amt_applied_in_base
               (-1, recid(apply_to) ). /* -1 TO BACKOUT GL TRANS */

            {&ARPAMT1A-P-TAG3}
            /* BACK OUT PAYMENT TOTAL*/
            find payment  where payment.ar_domain = global_domain and
            payment.ar_nbr =
               string(ar_mstr.ar_bill, "x(8)") + ar_mstr.ar_check.

            assign
               payment.ar_applied = payment.ar_applied + ard_amt
               l_unrnd_appl_amt   = ard_amt.

            {&ARPAMT1A-P-TAG4}
            if payment.ar_amt - payment.ar_applied = 0
            then
               payment.ar_open = no.
            else
               payment.ar_open = yes.

            /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY   */
            /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID */
            /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.     */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input payment.ar_curr,
                  input base_curr,
                  input payment.ar_ex_rate,
                  input payment.ar_ex_rate2,
                  input l_unrnd_appl_amt,
                  input true, /* ROUND */
                  output l_rnd_appl_amt,
                  output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
            end.

            assign
               payment.ar_base_applied = payment.ar_base_applied
                                       + l_rnd_appl_amt
               ard_recno    = recid(ard_det)
               arbuff_recno = recid(payment)
               undo_all     = yes.

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            if apply_to.ar_curr <> old_doccurr or
               old_doccurr = ""
            then do:

               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input apply_to.ar_curr,
                    output rndmthd,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo loope, next loope.
               end. /* IF MC-ERROR-NUMBER <> 0 */

               assign
                  aply2_rndmthd  = rndmthd
                  apply2_rndmthd = rndmthd
                  old_doccurr    = apply_to.ar_curr.
            end. /* IF APPLY_TO.AR_CURR <> OLD_DOCCURR ... */

            {&ARPAMT1A-P-TAG18}

            /* TO CREATE GL TRANSACTION ONLY IN CASE OF DIFFERENT  */
            /* EXCHANGE RATES OR IN CASE OF A DIFFERENT ACCOUNT IN */
            /* UNAPPLIED PAYMENT OR IN CASE OF NEW APPLICATION.    */

            if (ar_mstr.ar_curr        <> base_curr
                and ar_mstr.ar_ex_rate <> apply_to.ar_ex_rate)
               or l_new_ard
               or (can-find(first arddet3
                      where arddet3.ard_domain  = global_domain
                      and   arddet3.ard_nbr     = payment.ar_nbr
                      and  (arddet3.ard_entity  <> apply_to.ar_entity
                            or arddet3.ard_acct <> apply_to.ar_acct
                            or arddet3.ard_sub  <> apply_to.ar_sub
                            or arddet3.ard_cc   <> apply_to.ar_cc)))
            then
               l_gl_create = yes.

            /* PARAMETER true PASSED TO DENOTE REVERSAL           */
            /* ADDED 3RD PARAMETER l_ref TO STORE THE VALUE OF GL */
            /* REFERENCE CREATED                                  */
            {gprun.i ""arargl2.p""
               "(input  true,
                 input  l_gl_create,
                 output l_ref)"}

            if undo_all then undo loopc, leave.
            tot_amt_open = tot_amt_open + ard_amt.

            /* UPDATE CUSTOMER BALANCE */
            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
            ar_mstr.ar_bill
               exclusive-lock no-error.
            if available cm_mstr then do:
               /* IF PAYMENT WAS TOWARDS A DRAFT,                     */
               /* ADJUST THE CUSTOMER BALANCE (IN BASE CURRENCY)      */
               /* BY ADDING THE PAYMENT VALUE (-)                     */
               /* AND ADDING THE VALUE OF THE ITEMS                   */
               /* TO WHICH THE DRAFT WAS APPLIED                      */

               cm_balance = cm_balance - gain_amt.
            end.
            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
            ar_mstr.ar_bill no-lock
               no-error.

            /* BACK OUT MEMO APPLIED */
            /* FIND DOCUMENT TO WHICH PAYMENT WAS APPLIED */
            find apply_to  where apply_to.ar_domain = global_domain and
            apply_to.ar_nbr = ard_det.ard_ref
               exclusive-lock.
            assign
               amt_to_apply = ard_det.ard_amt.

            /* INVOICE/MEMO PAID IN FOREIGN CURRENCY           */

            if apply_to.ar_curr <> ar_mstr.ar_curr
            then do:
               /* ROUND PER 'APPLY-TO' CURRENCY ROUND METHOD */
               /* SINCE PAYMENT CAN *ONLY* BE IN BASE CURR  */
               /* OR IN APPLIED-TO-DOCUMENT CURRENCY, THEN: */
               /* APPLY_TO.AR_CURR (THE DOC) IS FOREIGN CURR  */
               /* & AR_MSTR.AR_CURR  (THE PMT) IS BASE.     */
               /* AMT_TO_APPLY (ARD_AMT OF THE PMT) IS BASE. */
               /* AR_MSTR.AR_EX_RATE IS THE EXCHANGE RATE    */
               /* BETWEEN BASE AND THE DOC CURRENCY AT THE   */
               /* TIME PAYMENT WAS MADE (AR_TYPE 'P' REC EFFDATE */
               /* A CHECK (PMT) CAN ONLY BE APPLIED TO       */
               /* DOCUMENTS OF *ONE* FOREIGN CURRENCY.       */

               /* CONVERT FROM FOREIGN TO BASE TO FOREIGN CURRENCY */

               /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
               {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
                  "(input ar_mstr.ar_ex_rate,
                    input ar_mstr.ar_ex_rate2,
                    input apply_to.ar_ex_rate2,
                    input apply_to.ar_ex_rate,
                    output comb_exch_rate,
                    output comb_exch_rate2)"}

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                    input apply_to.ar_curr,
                    input comb_exch_rate,
                    input comb_exch_rate2,
                    input amt_to_apply,
                    input true,  /* ROUND */
                    output amt_to_apply,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end.

               /* TO AVOID ROUNDING DIFF WHILE BACKING OUT MEMO/INVOICE*/
               /* VALUE OF amt_to_apply IS RECOMPUTED FROM ard_curr*   */
               /* FIELDS WHEN FOREIGN CURRENCY IS INVOLVED             */
               if apply_to.ar_curr <> base_curr and
                  ard_det.ard_cur_amt + ard_det.ard_cur_disc <> 0
               then
                  assign
                     amt_to_apply = ard_det.ard_cur_amt + ard_det.ard_cur_disc.

            end.  /* DOC CURR <> PMT CURR */

            assign
               apply_to.ar_applied = apply_to.ar_applied - amt_to_apply
               l_unrnd_appl_amt    = amt_to_apply.

            /* CHANGES MADE TO CONVERT amt_to_apply TO BASE CURRENCY */
            /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID    */
            /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.        */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input apply_to.ar_curr,
                  input base_curr,
                  input apply_to.ar_ex_rate,
                  input apply_to.ar_ex_rate2,
                  input l_unrnd_appl_amt,
                  input true,
                  output l_rnd_appl_amt,
                  output mc-error-number)"}.
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
            end.

            apply_to.ar_base_applied = apply_to.ar_base_applied - l_rnd_appl_amt.

            /* SET OPEN FLAG FOR MEMO*/
            if apply_to.ar_amt - apply_to.ar_applied = 0
            then
               apply_to.ar_open = no.
            else
               apply_to.ar_open = yes.
            if apply_to.ar_applied = 0 then apply_to.ar_paid_date = ?.
         end. /* MODIFY */

         assign
            recno  = recid(ard_det)
            del-yn = no
            ardamt = 0.

         /*FIND MEMO HEADER*/
         find apply_to  where apply_to.ar_domain = global_domain and
         apply_to.ar_nbr = ard_ref no-error.

         {&ARPAMT1A-P-TAG7}
         if not available apply_to or index("PCA",apply_to.ar_type) <> 0
            or (apply_to.ar_bill <> ar_mstr.ar_bill)
         then do:
            {&ARPAMT1A-P-TAG8}
            {pxmsg.i &MSGNUM=1156 &ERRORLEVEL=3}
            undo, retry.
         end.
         else do:
            assign
               ard_acct   = apply_to.ar_acct
               ard_sub    = apply_to.ar_sub
               ard_cc     = apply_to.ar_cc
               ard_entity = apply_to.ar_entity
               ard_type   = apply_to.ar_type.

            /* DEAL WITH MIXED CURRENCIES */
            if apply_to.ar_curr <> base_curr or
               ar_mstr.ar_curr <> base_curr then do:

               /*REMOVE ETK's SETTLEMENT THRU ANY CURRENCY  */
               /*AND IMPLEMENT ONLY EURO TRANSPARENCY.      */
               if  ar_mstr.ar_curr <> base_curr
               and ar_mstr.ar_curr <> apply_to.ar_curr
               then do:
                  run is_euro_transparent
                    (input ar_mstr.ar_curr,
                     input apply_to.ar_curr,
                     input base_curr,
                     input ar_mstr.ar_effdate,
                     output is_transparent).
                  if not is_transparent
                  then do:
                     /* If currencies don't match,
                        Payment curr must be Base */
                     {pxmsg.i &MSGNUM=149 &ERRORLEVEL=3}
                     undo, retry.
                  end.

               end.

               /*MAKE SURE A DIFF FOREIGN CURR NOT PAID BY THIS CHECK*/
               do for arddet1:
                  for each arddet1  where arddet1.ard_domain = global_domain and
                        arddet1.ard_nbr = ar_mstr.ar_nbr:
                     find armstr3  where armstr3.ar_domain = global_domain and
                        armstr3.ar_nbr = arddet1.ard_ref
                        no-lock no-error.
                     if available armstr3
                        and armstr3.ar_curr <> base_curr
                        and armstr3.ar_curr <> apply_to.ar_curr
                     then do:
                        /*CHECK CANNOT PAY 2 DIFFERENT FOREIGN CURRENCIES*/
                        {pxmsg.i &MSGNUM=148 &ERRORLEVEL=3}
                        undo loope, retry.
                     end.
                  end.
               end.

               if ar_mstr.ar_curr <> apply_to.ar_curr
               then do:
                  /* WARNING: INVOICE CURR <> CHECK CURR */
                  {pxmsg.i &MSGNUM=144 &ERRORLEVEL=2}
               end.

               /* GET ROUND METHOD OF APPLY-TO (INVOICE) CURRENCY */
               if apply_to.ar_curr <> old_doccurr
                  or (old_doccurr = "")
               then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input apply_to.ar_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     undo loope, next loope.
                  end.
                  apply2_rndmthd = rndmthd.
                  old_doccurr = apply_to.ar_curr.
               end.

               /* IF FIRST OCCURENCE OF FOREIGN INVOICE, SET AR_EX_RATE*/
               /* ALL PAYMENT APPLICATIONS ARE DONE USING THE */
               /* EXCHANGE RATE IN EFFECT AT PAYMENT EFFECTIVE DATE*/

               if inv_to_base_rate = 1 and inv_to_base_rate2 = 1
               then do:
                  /*Validate exchange rate with the check's effdate*/
                  {&ARPAMT1A-P-TAG9}
                  find payment  where payment.ar_domain = global_domain and
                  payment.ar_nbr =
                     string(ar_mstr.ar_bill, "x(8)") +
                     ar_mstr.ar_check no-lock.
                  {&ARPAMT1A-P-TAG10}

                  if payment.ar_curr <> apply_to.ar_curr
                  then do:
                     {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                        "(input apply_to.ar_curr,   /* INV CURR */
                          input base_curr,
                          input """",
                          input payment.ar_effdate, /* PMT DATE */
                          output inv_to_base_rate,
                          output inv_to_base_rate2,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                        undo, retry.
                     end.
                  end.
                  else
                     assign
                        inv_to_base_rate = payment.ar_ex_rate
                        inv_to_base_rate2 = payment.ar_ex_rate2.

                  /* UPDATE INV OR MEMO TO BASE EXCH RATE IN qad_wkfl */
                  {arupdwfl.i
                     ar_mstr.ar_nbr
                     inv_to_base_rate
                     inv_to_base_rate2}
                  first_foreign = yes.
               end.
               else
                  first_foreign = no.

            end.  /* APPLY-TO.AR_CURR <> BASE_CURR OR ...*/
            else do:   /* IF CURR'S ARE SAME, SET APPLY2_RNDMTHD */
               apply2_rndmthd = pmt_rndmthd.
               old_doccurr = ar_mstr.ar_curr.
               {&ARPAMT1A-P-TAG11}
               for first payment
                   where payment.ar_domain = global_domain and  payment.ar_nbr =
                   string(ar_mstr.ar_bill, "x(8)") +
                                         ar_mstr.ar_check no-lock:
               end.
               {&ARPAMT1A-P-TAG12}
               /*UPDATE INV OR MEMO TO BASE EXCH RATE IN qad_wkfl */
               /*SINCE PMT & INV CUR ARE SAME, JUST COPY RATE FROM PMT*/
               assign
                  inv_to_base_rate  = payment.ar_ex_rate
                  inv_to_base_rate2 = payment.ar_ex_rate2.
               {arupdwfl.i  ar_mstr.ar_nbr
                  inv_to_base_rate
                  inv_to_base_rate2}
            end.

         end.

         /* COMPUTE AMT_OPEN IN APPLY-TO (DOCUMENT) CURRENCY */
         amt_open = apply_to.ar_amt - apply_to.ar_applied.
         {&ARPAMT1A-P-TAG23}
         /* CONVERT UNAPPAMT TO AMT_OPEN CURRENCY FOR COMPARISON */
         /* APPLY-TO (DOC) IS FOREIGN; AR_MSTR (PMT) IS BASE;    */
         /* USES EXCHANGE RATE IN EFFECT WHEN DOC WAS CREATED!   */
         if apply_to.ar_curr <> ar_mstr.ar_curr
         then do:
            /* FOREIGN TO BASE TO FOREIGN */

            /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
            {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
               "(input inv_to_base_rate,
                 input inv_to_base_rate2,
                 input ar_mstr.ar_ex_rate2,
                 input ar_mstr.ar_ex_rate,
                 output comb_exch_rate,
                 output comb_exch_rate2)"}

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input ar_mstr.ar_curr,
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input amt_open,
                 input true,  /* ROUND */
                 output ardamt,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
            end.

         end. /* IF apply_to.ar_curr <> ar_mstr.ar_curr */
         else
            ardamt = amt_open.


         if not new ard_det then ardamt = ard_amt.

         /* SET CURR_AMT */
         if apply_to.ar_curr <> ar_mstr.ar_curr then do:
            /* APPLY-TO DOCUMENT IS FOREIGN; PAYMENT (ARD_AMT) IS */
            /* BASE & ARD_CUR_AMT IS IN DOCUMENT CURRENCY         */
            if not new ard_det then
               curr_amt  = ard_cur_amt.
            else
               /*  WHEN ARD_DET IS NEW, ARDAMT IS THE LESSER OF */
               /*  AMT_OPEN IN DOC CURR OR UNAPPMT IN DOC CURR  */
               assign
                  curr_amt    = ardamt
                  ard_cur_amt = curr_amt.

            /* SET AMT_TO_APPLY IN DOCUMENT CURRENCY */
            amt_to_apply = curr_amt.

         end.  /* APPLY-TO (DOC) CURR <> AR_MSTR (PMT) CURR */

         /* ARDAMT FORMAT IS ALWAYS PER PAYMENT CURRENCY.  WHEN */
         /* DEALING WITH MIXED CURRENCIES, PAYMENT CURRENCY    */
         /* WILL BE BASE.                                       */

         old_amt = ardamt.

         display
            ard_acct
            ard_sub
            ard_cc
            ard_type
            ardamt
         with frame d.

         ststatus = stline[2].
         status input ststatus.

         set1:
         do on error undo, retry:

            set ardamt go-on ("F5" "CTRL-D" ) with frame d.

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               /*CONFIRM DELETE*/
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if not del-yn then undo.
            end.

            /* Skip further I/O if deleting */
            if not del-yn then do:

               /* VALIDATE ARDAMT PER PAYMENT CURRENCY RNDMTHD.  */
               /* PAYMENT CURRENCY IS BASE IF PAYMENT CURRENCY   */
               /* IS DIFFERENT FROM APPLY-TO DOCUMENT CURRENCY   */
               if (ardamt <> 0) then do:
                  {gprun.i ""gpcurval.p"" "(input ardamt,
                                            input pmt_rndmthd,
                                            output retval)"}
                  if (retval <> 0) then do:
                     next-prompt ardamt with frame d.
                     undo set1, retry set1.
                  end.
               end.
               /* CHECK FOR OVERAPPLICATION OF PAYMENT */

               if ardamt > unappamt
               then do:
                  /* AMOUNT APPLIED IS GREATER THAN AMOUNT OPEN */
                  {pxmsg.i &MSGNUM=1157 &ERRORLEVEL=2}
               end.  /* IF ardamt > unappamt */

               /* RECALCULATE IF NECESSARY CURR_AMT AND AMT_TO_APPLY */
               if ardamt <> old_amt or new_abd_det then do:
                  curr_amt = ardamt.
                  if apply_to.ar_curr <> ar_mstr.ar_curr
                  then do:

                     /* CONVERT FROM FOREIGN TO BASE TO FOREIGN */

                     /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
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
                          input curr_amt,
                          input true,  /* ROUND */
                          output curr_amt,
                          output mc-error-number)"}

                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                     end.
                  end.
                  amt_to_apply = curr_amt.
               end.
               else
               if apply_to.ar_curr = ar_mstr.ar_curr then
                  amt_to_apply = ardamt.

               /* MIXED CURRENCIES */
               /* If invoice currency <> payment currency then prompt for   */
               /* Amount to apply in invoice currency; the default will be  */
               /* Calculated using the payment exchange rate.               */
               /* AMT_TO_APPLY (DOC CURR) IS SHOWN IN POP-UP FRAME  */
               /* AFTER ARDAMT HAS BEEN ENTERED IN PAYMENT CURRENCY */
               if apply_to.ar_curr <> ar_mstr.ar_curr
                  and amt_to_apply <> 0
               then
               set1_sub:
               do on error undo, retry:

                  /* CAN'T BE MORE THAN IS OPEN ON THE INVOICE */
                  if apply_to.ar_amt > 0 then
                     amt_to_apply = min(amt_to_apply,
                                    apply_to.ar_amt - apply_to.ar_applied).
                  else
                  if apply_to.ar_amt < 0 then
                     amt_to_apply = max(amt_to_apply,apply_to.ar_amt -
                                        apply_to.ar_applied).

                  /* AMOUNT TO APPLY IN THE INVOICE CURRENCY */
                  old_amt_to_apply = amt_to_apply.

                  display
                     amt_open
                     apply_to.ar_curr
                  with frame set1_sub.

                  /* FORMAT AMT_TO_APPLY PER DOCUMENT CURR */
                  amt_app_fmt = amt_app_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output amt_app_fmt,
                                            input apply2_rndmthd)"}
                  amt_to_apply:format = amt_app_fmt.

                  update
                     amt_to_apply
                  with frame set1_sub.

                  if amt_to_apply = 0 then do:
                     {pxmsg.i &MSGNUM=317 &ERRORLEVEL=3} /*ZERO NOT ALLOWED*/
                     undo set1_sub, retry.
                  end.
                  else do:
                     {gprun.i ""gpcurval.p"" "(input amt_to_apply,
                                               input apply2_rndmthd,
                                               output retval)"}
                     if (retval <> 0) then do:
                        next-prompt amt_to_apply with frame set1_sub.
                        undo set1_sub, retry set1_sub.
                     end.
                     assign ard_cur_amt = amt_to_apply.
                     /* REPLACES CONVERSION LOGIC BELOW (SEE %%% MARK)*/
                  end.

                  if not first_foreign
                     and old_amt_to_apply <> amt_to_apply then do:
                     /* Can only change amount to apply */
                     /* for first foreign invoice       */
                     {pxmsg.i &MSGNUM=143 &ERRORLEVEL=3}
                     undo set1_sub, retry.
                  end.
                  if first_foreign and amt_to_apply <> old_amt_to_apply
                  then do:

                     exch_var = 100 *
                                ((amt_to_apply / old_amt_to_apply) - 1).

                     if exch_var < 0 then exch_var = - exch_var.

                     /* DO NOT VALIDATE IF EXCHANGE TOLERANCE IS SET TO ZERO */
                     if exch_var > arc_ex_tol
                        and arc_ctrl.arc_ex_tol <> 0
                     then do:
                        /* Exchange Rate out of Tolerance, */
                        /* Cannot Apply this amount        */
                        {pxmsg.i &MSGNUM=145 &ERRORLEVEL=3 &MSGARG1="exch_var"}
                        undo set1_sub, retry.
                     end.
                     else do:

                        assign
                           inv_to_base_rate = (amt_to_apply / old_amt_to_apply)
                                            * inv_to_base_rate.

                        /*  UPD INV OR MEMO TO BASE EXCH RATE IN qad_wkfl*/
                        {arupdwfl.i  ar_mstr.ar_nbr
                           inv_to_base_rate
                           inv_to_base_rate2}
                     end.
                  end.  /* if first_foreign and amt_to_apply <> ... */

               end. /* set1_sub for mixed currencies */

               /* CHECK FOR OVERAPPLICATION OF MEMO */
               /* (don't let the application drive the open amount across zero) */
               if   ( apply_to.ar_amt - apply_to.ar_applied < amt_to_apply
                  and apply_to.ar_amt - apply_to.ar_applied >= 0
                  and amt_to_apply > 0 )
                  or ( apply_to.ar_amt - apply_to.ar_applied > amt_to_apply
                  and apply_to.ar_amt - apply_to.ar_applied <= 0
                  and amt_to_apply < 0 )
                  {&ARPAMT1A-P-TAG24}
               then do:
                  {pxmsg.i &MSGNUM=1157 &ERRORLEVEL=3}
                  next-prompt ardamt.
                  undo set1.
               end.

            /* SS - 110114.1 - B */
                {gprun.i ""xxgpdescm.p""
                    "(input        frame-row(d) - 5,
                      input-output ard_det.ard_desc)"}
                if keyfunction(lastkey) = "end-error" or keyfunction(lastkey) = "." then undo set1, retry.  
                {xxgpdescm2.i &table=ard_det &desc=ard_det.ard_desc}

            /* SS - 110114.1 - E */


            end.  /* if not del-yn */
         end. /* set1 */

         ard_amt = ardamt.

         /*IF LINE AMT = ZERO THEN DELETE*/
         if ard_amt = 0 then do:
            {pxmsg.i &MSGNUM=1161 &ERRORLEVEL=2 }.
            if not batchrun then
            do on endkey undo, leave:
               pause.
            end.

            del-yn = yes.
         end.

         if del-yn then do:
            {&ARPAMT1A-P-TAG25}
            /* IF DELETE ONLY FOREIGN MEMO FROM BASE APPL
               RESET EX_RATE TO 1 */
            if apply_to.ar_curr <> ar_mstr.ar_curr then do:
               do for arddet1:
                  reset_ok = yes.
                  for each arddet1  where arddet1.ard_domain = global_domain and
                        arddet1.ard_nbr = ar_mstr.ar_nbr
                        and arddet1.ard_ref <> ard_det.ard_ref:
                     find armstr3  where armstr3.ar_domain = global_domain and
                        armstr3.ar_nbr = arddet1.ard_ref
                        no-lock no-error.
                     if available armstr3 and
                        armstr3.ar_curr <> base_curr
                     then do:
                        reset_ok = no.
                        leave.
                     end.
                  end.

                  if reset_ok
                  then do:  /* IF NO MORE LINE DTL FOUND, RESET EXCH RATE */
                     {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input ar_mstr.ar_exru_seq)"}.
                     assign
                        ar_mstr.ar_ex_rate  = 1
                        ar_mstr.ar_ex_rate2 = 1
                        ar_mstr.ar_exru_seq = 0.
                  end.
               end.
            end.
            delete ard_det.
            clear frame d.
            del-yn = no.
            next loope.
         end. /* if del_yn */

         /* UPDATE GL TRANSACTION FILE */
         /*CONVERT INTO BASE*/
         assign
            base_amt     = ard_amt
            base_det_amt = ard_amt
            gain_amt     = 0
            curr_amt     = ard_amt.

         /* THIS PROC CONTAINS NEW LOGIC THAT REPLACES ABOVE CODE */
         run compute_amt_applied_in_base (1, recid(apply_to) ).

         /* UPDATE MEMO APPLIED AMOUNT */
         assign
            apply_to.ar_applied = apply_to.ar_applied + amt_to_apply
            l_unrnd_appl_amt    = amt_to_apply.

         if apply_to.ar_applied = 0 then
            apply_to.ar_paid_date = ?.
         else
            apply_to.ar_paid_date = ar_mstr.ar_date.
         if apply_to.ar_amt - apply_to.ar_applied = 0 then
            apply_to.ar_open = no.
         else
            apply_to.ar_open = yes.

         /* CHANGES MADE TO CONVERT amt_to_apply TO BASE CURRENCY */
         /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID    */
         /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.        */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input apply_to.ar_curr,
               input base_curr,
               input apply_to.ar_ex_rate,
               input apply_to.ar_ex_rate2,
               input l_unrnd_appl_amt,
               input true, /* ROUND */
               output l_rnd_appl_amt,
               output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.

         apply_to.ar_base_applied = apply_to.ar_base_applied + l_rnd_appl_amt.

         /* UPDATE  PAYMENT TOTAL*/
         {&ARPAMT1A-P-TAG13}
         find first payment  where payment.ar_domain = global_domain and
         payment.ar_nbr =
            string(ar_mstr.ar_bill, "x(8)") + ar_mstr.ar_check.

         assign
            payment.ar_applied = payment.ar_applied - ard_amt
            l_unrnd_appl_amt   = ard_amt.

         {&ARPAMT1A-P-TAG14}
         if payment.ar_amt - payment.ar_applied = 0 then
            payment.ar_open = no.
         else
            payment.ar_open = yes.

         /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY   */
         /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID */
         /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.     */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input payment.ar_curr,
               input base_curr,
               input payment.ar_ex_rate,
               input payment.ar_ex_rate2,
               input l_unrnd_appl_amt,
               input true, /* ROUND */
               output l_rnd_appl_amt,
               output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.

         assign
            payment.ar_base_applied = payment.ar_base_applied - l_rnd_appl_amt
            ard_recno     = recid(ard_det)
            arbuff_recno  = recid(payment)
            undo_all      = yes
            aply2_rndmthd = apply2_rndmthd.

         {&ARPAMT1A-P-TAG19}

         /* TO CREATE GL TRANSACTION ONLY IN CASE OF DIFFERENT  */
         /* EXCHANGE RATES OR IN CASE OF A DIFFERENT ACCOUNT IN */
         /* UNAPPLIED PAYMENT OR IN CASE OF NEW APPLICATION.    */

         if (ar_mstr.ar_curr        <> base_curr
             and ar_mstr.ar_ex_rate <> apply_to.ar_ex_rate)
            or l_new_ard
            or (can-find(first arddet3
                   where arddet3.ard_domain  = global_domain
                   and   arddet3.ard_nbr     = payment.ar_nbr
                   and  (arddet3.ard_entity  <> apply_to.ar_entity
                         or arddet3.ard_acct <> apply_to.ar_acct
                         or arddet3.ard_sub  <> apply_to.ar_sub
                         or arddet3.ard_cc   <> apply_to.ar_cc)))
         then
            l_gl_create = yes.

         /* PARAMETER false PASSED TO DENOTE IT IS NOT A REVERSAL */
         /* ADDED 3RD PARAMETER l_ref TO STORE THE VALUE OF GL    */
         /* REFERENCE CREATED                                     */

         {gprun.i ""arargl2.p""
            "(input  false,
              input  l_gl_create,
              output l_ref   )"}

         if daybooks-in-use
            and l_new_gl
            and available ar_mstr
            and available ard_det
            and not can-find (t_store_glt_ref
                           where t_ref = l_ref)
         then do:
            create t_store_glt_ref.
            assign
               t_ref        = l_ref
               t_ard_nbr    = ard_nbr
               t_ar_dy_code = ar_mstr.ar_dy_code
               t_ar_effdate = ar_mstr.ar_effdate
               l_new_gl     = no.
         end. /* IF daybooks-in-use */

         if undo_all then undo loopc, leave.

         /* UPDATE CUSTOMER BALANCE */
         find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
         ar_mstr.ar_bill
            exclusive-lock no-error.
         if available cm_mstr then do:
            /* IF PAYMENT IS TOWARDS A DRAFT,                      */
            /* ADJUST THE CUSTOMER BALANCE (IN BASE CURRENCY)      */
            /* BY ADDING THE PAYMENT VALUE, AND SUBTRACTING THE    */
            /* VALUE OF THE ITEMS TO WHICH THE DRAFT WAS APPLIED   */

            cm_balance = cm_balance - gain_amt.
         end.
         find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
         ar_mstr.ar_bill no-lock no-error.

         /* UPDATE APPLY UNAPPLIED TOTAL */
         assign
            ar_mstr.ar_amt     = ar_mstr.ar_amt + ard_amt
            ar_mstr.ar_applied = ar_mstr.ar_amt
            ar_mstr.ar_open    = no
            l_unrnd_amt        = ard_amt.

         if apply_to.ar_open          = no
            and apply_to.ar_base_amt <> apply_to.ar_base_applied
            and apply_to.ar_amt       = apply_to.ar_applied
            and apply_to.ar_curr     <> base_curr
            and ar_mstr.ar_curr       = base_curr
         then
            assign
               l_round_amt = apply_to.ar_base_amt - apply_to.ar_base_applied.
               apply_to.ar_base_applied = apply_to.ar_base_applied + l_round_amt.

         {&ARPAMT1A-P-TAG17}

         /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY */
         /* AND THEN ACCUMULATE IT TO ar_base_amt TO AVOID   */
         /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.   */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input ar_mstr.ar_curr,
               input base_curr,
               input ar_mstr.ar_ex_rate,
               input ar_mstr.ar_ex_rate2,
               input l_unrnd_amt,
               input true, /* ROUND */
               output l_rnd_amt,
               output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
         end.

         assign
            ar_mstr.ar_base_amt     = ar_mstr.ar_base_amt + l_rnd_amt
            ar_mstr.ar_base_applied = ar_mstr.ar_base_amt.

         /*UPDATE TOT_AMT_OPEN*/
         tot_amt_open = tot_amt_open - ard_amt.

      end. /* loope */

      if ar_mstr.ar_amt > tot_amt_to_apply
      and tot_amt_to_apply > 0
      then do:

         /* AMOUNT APP TO GREATER THAN THE TOTAL AMOUNT TO APPLY. CONTINUE */
         {pxmsg.i &MSGNUM=6631 &ERRORLEVEL=1 &CONFIRM=l_yn}

         if l_yn
         then
            l_lcommit = 0.
         else do:
           l_lcommit = 1.
           undo, leave loopc.
         end. /* ELSE DO .. */

      end. /* If ar_mstr.ar_amt > tot_amt_to_apply */
      else
         l_lcommit = 1.

   end. /* DO WHILE l_lcommit = 0 */


   leave loopc.

end. /* loopc */

hide frame d no-pause.

PROCEDURE compute_amt_applied_in_base:
   define input parameter op_mode as integer.
   /* -1 TO BACKOUT TRANS ELSE 1 */
   define input parameter apply_to_recid as recid.

   define buffer l_apply_to for ar_mstr. /* LOCAL apply_to BUFFER */

   for first l_apply_to
      where recid(l_apply_to) = apply_to_recid
   no-lock:
   end.

   if ar_mstr.ar_curr <> base_curr then do:

    /* GET BASE AMOUNT USING PAYMENT EXCHANGE RATE */
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
      /* FOREIGN TO BASE TO FOREIGN TO BASE CURRENCY */

      /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
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
           input l_apply_to.ar_ex_rate,
           input l_apply_to.ar_ex_rate2,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      /* CHANGED SECOND INPUT PARAMETER    */
      /* FROM ar_mstr.ar_curr TO base_curr */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input base_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input base_det_amt,
           input true,  /* ROUND */
           output base_det_amt,
           output mc-error-number)"}

      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.
      assign
         det_ex_rate2 = l_apply_to.ar_ex_rate2
         det_ex_rate  = l_apply_to.ar_ex_rate.
   end.
   else if l_apply_to.ar_curr <> base_curr
   then do:
      curr_amt = op_mode * ard_det.ard_cur_amt.

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input l_apply_to.ar_curr,
           input base_curr,
           input l_apply_to.ar_ex_rate,
           input l_apply_to.ar_ex_rate2,
           input curr_amt,
           input true, /* ROUND */
           output base_det_amt,
           output mc-error-number)"}.

      base_det_amt = base_det_amt + l_round_amt.

      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end.

      assign
         det_ex_rate2 = l_apply_to.ar_ex_rate2
         det_ex_rate  = l_apply_to.ar_ex_rate.
   end.
END PROCEDURE. /* compute_amt_applied_in_base */

{gpacctet.i}  /*DEFINES procedure is_euro_transparent */
