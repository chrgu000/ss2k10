/* utfinrev.p - UTILITY PROGRAM TO REVERSE A FINANGE CHARGES                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.2.8 $                                                              */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 7.2      LAST MODIFIED: 11/04/92   by: jms  *G205*         */
/*                                   08/15/94   by: pmf  *FQ17*         */
/* Oracle changes (share-locks)    09/13/94           BY: rwl *FR32*    */
/*           7.3                     12/21/94   by: srk  *GO58*         */
/*           7.3                     03/15/95   by: aed  *G0HL*         */
/*                                   01/30/96   by: ais  *G1L8*         */
/* REVISION: 8.6      LAST MODIFIED: 07/18/96   BY: BJL  *K001*         */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   by: M. Deleeuw *J13N*        */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J13S* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 11/12/96   BY: *H0N9* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 01/02/97   BY: EJH *K01S*               */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/*                                   03/19/97   BY: *K082* E. Hughart        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 9.1      LAST MODIFIED: 08/17/99   BY: *N014* Vijaya Pakala     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/24/00   BY: *N0KB* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *N0W5* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.2.7   BY: Ed van de Gevel      DATE: 07/04/02  ECO: *P0B4*  */
/* $Revision: 1.13.2.8 $         BY: John Corda           DATE: 08/09/02  ECO: *N1QP*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

{mfdtitle.i "2+ "}
{cxcustom.i "UTFINREV.P"}

{gldydef.i new}
{gldynrm.i new}
{gprunpdf.i "nrm" "p"}

define variable cust               like cm_addr no-undo.
define variable cust1              like cm_addr no-undo.
define variable findate            like cm_fin_date
   label "Date of Fin Chgs to be Deleted" no-undo.
define variable newfindate         like cm_fin_date no-undo.

define variable jrnl               like glt_ref no-undo.
define variable dr_amt             as decimal
                                   format "->>>,>>>,>>>.99" no-undo.
define variable cr_amt             as decimal
                                   format "->>>,>>>,>>>.99" no-undo.
define variable ref                like glt_ref  no-undo.
define variable base_amt           like glt_amt  no-undo.
define variable curr_amt           like glt_amt  no-undo.
define variable currency           like glt_curr no-undo.
define variable gl_sum             like mfc_logical initial no no-undo.
define variable need_new_fin_date  like mfc_logical initial no no-undo.
define variable mc-error-number    like msg_nbr no-undo.
define variable hdr-txt            as character format "x(24)" no-undo.
define variable ref-txt            as character format "x(30)" no-undo.

/* Get Informational Text */
{gpcdget.i "UT"}

form
   cust       colon 35
   cust1      colon 50 label {t001.i}
   findate    colon 35
   currency   colon 35
with frame a width 80 side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&UTFINREV-P-TAG1}
find first gl_ctrl no-lock.

currency = base_curr.

for each gltw_wkfl exclusive-lock where gltw_userid = mfguser:
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input gltw_wkfl.gltw_exru_seq)" }
   delete gltw_wkfl.
end.

repeat:

   if cust1 = hi_char then cust1 = "".
   if findate = ? then findate = today.

   update
      cust
      cust1
      findate
      currency
   with frame a.

   if cust1 = "" then cust1 = hi_char.
   if findate = ? then findate = today.

   display findate with frame a.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}


   do transaction:
      /* GET NEXT JOURNAL REFERENCE NUMBER  */
      {mfnctrl.i    arc_ctrl arc_jrnl glt_det glt_ref jrnl}
      ref = "AR" + substring(string(year(today),"9999"),3,2)
                 + string(month(today),"99")
                 + string(day(today),"99")
                 + string(integer(jrnl),"999999").
   end.

   hdr-txt = getTermLabel("JOURNAL_REFERENCE",24) + ":".

   form header
      hdr-txt
      ref
   with frame jrnl page-top width 80.
   view frame jrnl.

   for each cm_mstr exclusive-lock
      where cm_addr >= cust and cm_addr <= cust1 and
            cm_fin and
            cm_curr = currency:

      need_new_fin_date = no.

      /* FIND FINANCE CHARGE RECORD */
      for each ar_mstr exclusive-lock where
            ar_bill = cm_addr and
            ar_type = "F" and
            ar_open and
            ar_date = findate
            use-index ar_bill_type:
         {&UTFINREV-P-TAG3}
         for each ard_det exclusive-lock where
               ard_nbr = ar_nbr:

            /* CONVERT TO BASE TO STORE IN GL*/
            base_amt = - ard_amt.
            curr_amt = - ard_amt.
            if ar_curr <> base_curr then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_amt,
                    input true, /* ROUND */
                    output base_amt,
                    output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}.
               end.

            end.
            else curr_amt = 0.

            /* CREDIT A/R */
            /* ADDED SUB-ACCOUNT REFERENCES TO BELOW INCLUDES */
            /* Replace pre-processors for literal strings */
            ref-txt = getTermLabel("UNPOSTED",18).
            {mfgltw.i &acct=ar_acct
               &sub=ar_sub
               &cc=ar_cc
               &entity=ar_entity
               &project=""""
               &ref=ref-txt
               &date=ar_date
               &type=""FINANCE_CHG""
               &docnbr=cm_addr
               &amt=base_amt
               &curramt=curr_amt
               &daybook=""""}

            /* DEBIT FINANCE CHARGES */
            {mfgltw.i &acct=ard_acct
               &sub=ard_sub
               &cc=ard_cc
               &entity=ar_entity
               &project=""""
               &ref=ref-txt
               &date=ar_date
               &type=""FINANCE_CHG""
               &docnbr=cm_addr
               &amt="- base_amt"
               &curramt="- curr_amt"
               &daybook=""""}

            /* UPDATE CUSTOMER BALANCE */
            cm_balance = cm_balance - ard_amt.
            delete ard_det.

         end.

         {gprun.i ""gpardel.p"" "(input ar_nbr)"}
         /* DEL EXCHANGE RATE USAGE (exru_usage) RECORDS */
         if ar_mstr.ar_exru_seq <> 0
         then do:
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input ar_mstr.ar_exru_seq)"}
         end.
         if ar_mstr.ar_dd_exru_seq <> 0
         then do:
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input ar_mstr.ar_dd_exru_seq)"}
         end.
         delete ar_mstr.
         need_new_fin_date = yes.

      end. /* for each ar_mstr */

      /* FIND LAST FINANCE CHARGE */
      /* ONLY UPDATE LAST FINANCE CHARGE DATE IN THE CUSTOMER  */
      /* RECORD IF A FINANCE CHARGE RECORD IS ACTUALLY DELETED */
      if need_new_fin_date then do:
         newfindate = ?.
         for each ar_mstr where
               ar_bill = cm_addr and
               ar_type = "F"
            no-lock use-index ar_bill_type:
            if ar_date > newfindate or newfindate = ? then
               newfindate = ar_date.
         end.
         cm_fin_date = newfindate.
      end.  /* if need_new ... */

   end. /* for each cm_mstr */

   /* DISPLAY GL WORKFILE ENTRIES AND POST TO GL */
   for each gltw_wkfl where
         gltw_userid = mfguser
         break by gltw_acct by gltw_sub
         by gltw_cc:
      cr_amt = 0.
      dr_amt = 0.
      if gltw_amt < 0 then
         cr_amt = - gltw_amt.
      else
         dr_amt = gltw_amt.

      accumulate dr_amt (total by gltw_cc).
      accumulate cr_amt (total by gltw_cc).

      do with frame b:
         setFrameLabels(frame b:handle).

         if last-of(gltw_cc) then do:

            display
               gltw_acct
               gltw_sub
               gltw_cc
               gltw_date.
            if (accum total by gltw_cc dr_amt) <> 0 then
               display
                  accum total by gltw_cc dr_amt
                  @ dr_amt label "Consolidte Dr".
            if (accum total by gltw_cc cr_amt) <> 0 then
               display
                  accum total by gltw_cc cr_amt
                  @ cr_amt label "Consolidte Cr".
         end.

         if last(gltw_cc) then do:
            down 1.
            display "---------------" @ dr_amt
                    "---------------" @ cr_amt.
            down 1.

            if (accum total dr_amt) <> 0 then
               display
                  accum total dr_amt
                  @ dr_amt label "Consolidte Dr".
            if (accum total cr_amt) <> 0 then
               display
                  accum total cr_amt
                  @ cr_amt label "Consolidte Cr".
         end.

      end. /* do with frame b */

   end. /* for each gltw_wkfl */

   /* POST GL TRANSACTIONS */
   do transaction on error undo, leave:

      for each gltw_wkfl exclusive-lock
         where gltw_userid = mfguser
            break by gltw_entity
                  by gltw_acct
                  by gltw_sub
                  by gltw_cc:

         accumulate gltw_amt (total by gltw_cc).

         if last-of(gltw_cc) then do:

            {gprun.i ""gldydft.p""
               "(input ""AR"",
                 input ""F"",
                 input gltw_entity,
                 output dft-daybook,
                 output daybook-desc)"}

            /* GET LAST LINE NUMBER */
            find last glt_det where
               glt_ref = ref and
               glt_rflag = false
               use-index glt_ref no-error.
            if available glt_det then
               assign
                  nrm-seq-num = glt_dy_num
                  gllinenum   = glt_line + 1.
            else
               assign
                  nrm-seq-num = ""
                  gllinenum = 1.

            /****************************************************/
            /* Assignment of glt_correction flag defaulted from */
            /* data dictionary (NO).                            */
            /****************************************************/

            if gllinenum = 1 and daybooks-in-use
            then do:
              {gprunp.i "nrm" "p" "nr_dispense"
                 "(input  dft-daybook,
                   input  findate,
                   output nrm-seq-num)"}
            end. /* if gllinenum = 1 and daybooks-in-use */

            ref-txt = getTermLabel("A/R_FINANCE_CHG_REV",30).
            create glt_det.
            assign
               glt_entity  = gltw_entity
               glt_acct    = gltw_acct
               glt_sub     = gltw_sub
               glt_cc      = gltw_cc
               glt_ref     = ref
               glt_date    = gltw_date
               glt_effdate = findate
               glt_userid  = global_userid
               glt_curr    = currency
               glt_amt     = accum total by gltw_cc gltw_amt
               glt_desc    = ref-txt
               glt_tr_type = "AR"
               glt_rflag   = false
               glt_dy_code = dft-daybook
               glt_dy_num  = nrm-seq-num
               glt_line    = gllinenum.
            {&UTFINREV-P-TAG2}
         end. /* if last-of */

         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input gltw_wkfl.gltw_exru_seq)" }
         delete gltw_wkfl.

      end.  /* gltw_wkfl */

   end. /* transaction */

   hide frame jrnl.
   {mfrtrail.i}


end.
