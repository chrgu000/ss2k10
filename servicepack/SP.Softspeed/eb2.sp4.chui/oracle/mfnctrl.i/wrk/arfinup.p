/* arfinup.p - A/R CREATE FINANCE CHARGES                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.31 $                                                  */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 4.0      LAST MODIFIED: 09/23/88   BY: WUG                      */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: afs *D243*               */
/*                                   02/28/91   BY: afs *D387*               */
/*                                   04/02/91   BY: bjb *D507*               */
/*                                   10/08/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 10/11/91   BY: jjs *F016*               */
/*                                   11/07/91   BY: MLV *F031*               */
/*                                   02/07/92   BY: afs *F187*               */
/*                                   02/28/92   BY: jjs *F237*               */
/*                                   04/10/92   BY: afs *F356*               */
/* REVISION: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*               */
/*                                   09/16/92   by: jms *F901*               */
/*                                   10/21/92   by: mpp *G476*               */
/*                                   03/17/93   by: skk *G827*               */
/*                                   07/02/93   by: mpp *GC94* rev only      */
/* REVISION: 7.4      LAST MODIFIED: 10/08/93   BY: tjs *H081*               */
/*                                   12/14/93   by: jms *GH82*               */
/*                                   12/15/93   by: srk *GI06*               */
/*                                   02/09/94   by: srk *GI33*               */
/*                                   06/27/94   by: bcm *H405*               */
/*                                   07/01/94   by: bcm *H423*               */
/*                                   08/18/94   by: pmf *FQ33*               */
/*                                   08/24/94   by: rxm *GL40*               */
/*                                   12/02/94   by: str *FU26*               */
/*                                   11/21/95   by: mys *G1DX*               */
/* REVISION: 8.5      LAST MODIFIED: 12/14/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 05/28/96   BY: jxz *J0NL*               */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: ejh *K001*               */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*               */
/* REVISION: 8.6      LAST MODIFIED: 01/29/97   BY: *K05F* Eugene Kim        */
/* REVISION: 8.6      LAST MODIFIED: 02/17/97   BY: *K01R* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *J1MG* Robin McCarthy    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 9.0      LAST MODIFIED: 12/18/98   BY: *J34V* G.Latha           */
/* REVISION: 9.0      LAST MODIFIED: 01/14/99   BY: *J38D* G.Latha           */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/30/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/05/00   BY: *M0QP* Falguni Dalal     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.29     BY: Vandna Rohira       DATE: 01/16/02  ECO: *M1TC*    */
/* Revision: 1.30     BY: Rajiv Ramaiah       DATE: 03/05/02  ECO: *N1BN*    */
/* $Revision: 1.31 $    BY: Manjusha Inglay        DATE: 07/29/02  ECO: *N1P4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arfinup_p_1 "As Of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinup_p_4 "Interest Rate % per Annum"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinup_p_5 "Minimum Finance Charge"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinup_p_6 "Last Run Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinup_p_7 "Include Previous Finance Chgs"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinup_p_8 "Grace Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE arfinup_p_9 "Summary Only"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}
{gldydef.i new}
{gldynrm.i new}

define new shared variable rndmthd                     like rnd_rnd_mthd.
define new shared variable last_run_date               as date
   label {&arfinup_p_6}.
define new shared variable as_of_date                  as date
   label {&arfinup_p_1}.
define new shared variable eff_date                    like ar_effdate.
define new shared variable gracedays                   as integer
   label {&arfinup_p_8}.
define new shared variable intrate                     as decimal
   format ">>>9.99%".
define new shared variable currency                    like ar_curr.
define new shared variable cm_recid                    as recid.
define new shared variable ref                         like glt_ref.
define new shared variable batch                       like ar_batch.
define new shared variable undo_all                    like mfc_logical.
define new shared variable jrnl                        like glt_ref.
define new shared variable customer_gets_a_finance_chg as log.
define new shared variable include_prev_fin_chgs       like mfc_logical.
define new shared variable min_fin_chg                 as decimal
   format ">>>>,>>9.99".
define new shared variable summary_only                like mfc_logical
   label {&arfinup_p_9}
   initial no.

define variable cust                    like ar_bill.
define variable cust1                   like ar_bill.
define variable stmt_cyc                like cm_stmt_cyc.
define variable stmt_cyc1               like cm_stmt_cyc.
define variable ba_recno                as recid.
define variable retval                  as integer.
define variable min_fin_fmt             as character.
define variable min_fin_old             as character.
define variable mc-error-number         like msg_nbr     no-undo.
define variable temp_rate               like ar_ex_rate  no-undo.
define variable temp_rate2              like ar_ex_rate2 no-undo.

form
   cust           colon 15  cust1     label {t001.i} colon 49
   stmt_cyc       colon 15  stmt_cyc1 label {t001.i} colon 49 skip(1)
   currency       colon 33
   as_of_date     colon 33
   eff_date       colon 33
   gracedays      colon 33
   intrate        colon 33  label {&arfinup_p_4}
   min_fin_chg    colon 33  label {&arfinup_p_5}
   include_prev_fin_chgs
                  colon 33  label {&arfinup_p_7}
   summary_only   colon 33
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

min_fin_old = min_fin_chg:format.

for first gl_ctrl
   fields (gl_base_curr gl_rnd_mthd)
   no-lock:
end. /* FOR FIRST gl_ctrl */

assign
   currency   = base_curr
   eff_date   = today
   as_of_date = today.

repeat:

   if cust1 = hi_char
   then
      cust1 = "".
   if stmt_cyc1 = hi_char
   then
      stmt_cyc1 = "".

   display
      cust
      cust1
      stmt_cyc
      stmt_cyc1
      currency
      as_of_date
      eff_date
      gracedays
      intrate
      min_fin_chg
      include_prev_fin_chgs
      summary_only
   with frame a.

   /* TO HAVE ONE SINGLE SET STATEMENT WHEN RUN IN BATCH */
   /* MODE THEREBY PREVENTING PROGRESS ERROR MESSAGE     */

   if batchrun
   then do with frame a width 80 no-attr-space:

      set
         cust
         cust1
         stmt_cyc
         stmt_cyc1
         currency
         as_of_date
         eff_date
         gracedays
         intrate
         min_fin_chg
         include_prev_fin_chgs
         summary_only
      with frame a.

      assign
         cust
         cust1
         stmt_cyc
         stmt_cyc1
         currency
         as_of_date
         eff_date
         gracedays
         intrate
         min_fin_chg
         include_prev_fin_chgs
         summary_only.

      display
         cust
         cust1
         stmt_cyc
         stmt_cyc1
         currency
         as_of_date
         eff_date
         gracedays
         intrate
         min_fin_chg
         include_prev_fin_chgs
         summary_only
      with frame a.

   end. /* IF BATCHRUN */

   else

      set
         cust
         cust1
         stmt_cyc
         stmt_cyc1
         currency
         as_of_date
         eff_date
         gracedays
         intrate
      with frame a.

   if currency = gl_base_curr
   then
      rndmthd = gl_rnd_mthd.
   else do:
      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input currency,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         undo, retry.
         next-prompt currency.
      end. /* IF mc-error-number <> 0 */
   end. /* IF currency <> gl_base_curr */

   min_fin_fmt = min_fin_old.
   {gprun.i ""gpcurfmt.p""
      "(input-output min_fin_fmt,
        input rndmthd)"}
   min_fin_chg:format = min_fin_fmt.

   if currency <> base_curr
   then do:

      /* GET EXCHANGE RATE */
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input currency,
           input base_curr,
           input """",
           input eff_date,
           output temp_rate,
           output temp_rate2,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
      end. /* IF mc-error-number <> 0 */
   end. /* IF currency <> base_curr */

   /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
   {gprun.i ""gpglef1.p""
      "(input  ""AR"",
        input  glentity,
        input  eff_date,
        output gpglef_result,
        output gpglef_msg_nbr
       )" }

   if gpglef_result > 0
   then do:
      /* IF PERIOD CLOSED THEN WARNING ONLY */
      if gpglef_result = 2
      then do:
         {pxmsg.i &MSGNUM=3005 &ERRORLEVEL=2}
      end. /* IF gpglef_result = 2 */
      /* OTHERWISE REGULAR ERROR MESSAGE */
      else do:
         {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=4}
         next-prompt eff_date with frame a.
         undo, retry.
      end. /* IF gpglef_result <> 2 */
   end. /* IF gpglef_result > 0 */

   if as_of_date = ?
   then do:
      /* Invalid date*/
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
      next-prompt as_of_date with frame a.
      undo, retry.
   end. /* IF as_of_date = ? */

   if batchrun
   then do:

      if (min_fin_chg <> 0)
      then do:
         {gprun.i ""gpcurval.p""
            "(input min_fin_chg,
              input rndmthd,
              output retval)"}
         if (retval <> 0)
         then do:
            next-prompt min_fin_chg with frame a.
            undo, retry.
         end. /* IF (retval <> 0) */
      end. /* IF (min_fin_chg <> 0) */

   end. /* IF BATCHRUN */

   else do:

      setloop:
      do on error undo, retry:

         update
            min_fin_chg
            include_prev_fin_chgs
            summary_only
         with frame a.
         if (min_fin_chg <> 0)
         then do:
            {gprun.i ""gpcurval.p""
               "(input min_fin_chg,
                 input rndmthd,
                 output retval)"}
            if (retval <> 0)
            then do:
               next-prompt min_fin_chg with frame a.
               undo setloop, retry setloop.
            end. /* IF (retval <> 0) */
         end. /* IF (min_fin_chg <> 0) */
      end. /* SETLOOP */

   end. /* IF NOT BATCHRUN */

   /* CREATE BATCH INPUT STRING */
   bcdparm = "".
   {mfquoter.i cust        }
   {mfquoter.i cust1       }
   {mfquoter.i stmt_cyc    }
   {mfquoter.i stmt_cyc1   }
   {mfquoter.i currency    }
   {mfquoter.i as_of_date  }
   {mfquoter.i eff_date    }
   {mfquoter.i gracedays   }
   {mfquoter.i intrate     }
   {mfquoter.i min_fin_chg }
   {mfquoter.i include_prev_fin_chgs}
   {mfquoter.i summary_only}

   if cust1 = ""
   then
      cust1 = hi_char.
   if stmt_cyc1 = ""
   then
      stmt_cyc1 = hi_char.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   do transaction:
      /* GET NEXT BATCH NUMBER */

      /*USE GPGETBAT TO GET THE NEXT BATCH NUMBER AND CREATE */
      /*THE BATCH MASTER (BA_MSTR)                           */
      {gprun.i ""gpgetbat.p""
         "(input  """",    /*IN-BATCH #     */
           input  ""AR"",  /*MODULE         */
           input  ""F"",   /*DOC TYPE       */
           input  "0",     /*CONTROL AMOUNT */
           output ba_recno,/*NEW BATCH RECID*/
           output batch)"} /*NEW BATCH #    */

      /* GET NEXT JOURNAL REFERENCE NUMBER  */
      {mfnctrl.i    arc_ctrl arc_jrnl glt_det glt_ref jrnl}

      ref = "AR" + substring(string(year(today),"9999"),3,2)
                 + string(month(today),"99")
                 + string(day(today),"99")
                 + string(integer(jrnl),"999999").

      form header
         getTermLabel("SALES_JOURNAL_REFERENCE",25) format "x(25)"
         ref  format "x(14)"
         getTermLabelRtColon("AR_BATCH",9) format "x(9)"
         batch skip(1)
      with frame jrnl page-top width 80.

      view frame jrnl.
   end. /* DO TRANSACTION */

   for each cm_mstr
      where (cm_addr >= cust
      and    cm_addr <= cust1)
      and cm_fin
      and (cm_stmt_cyc >= stmt_cyc
      and  cm_stmt_cyc <= stmt_cyc1),
      each ad_mstr where ad_addr = cm_addr no-lock
      by cm_sort:

      if as_of_date <= cm_fin_date
      then
         next.
      last_run_date = cm_fin_date.
      if last_run_date = ?
      then
         last_run_date = low_date.

      cm_recid = recid(cm_mstr).
      {gprun.i ""arfinupb.p""}

      if customer_gets_a_finance_chg
      then do:

         display
            skip(2)
            getTermLabelRtColon("CUSTOMER",9) format "x(9)"
            cm_addr
            ad_name
         with no-labels.

         /* FIND DEBITS AND CALCULATE FINANCE CHARGES */

         {gprun.i ""arfinupc.p""
            "(input temp_rate,
              input temp_rate2)"}

         cm_fin_date = as_of_date.

      end. /* IF customer_gets_a_finance_charge */

   end. /* FOR EACH cm_mstr */

   /* DISPLAY GL WORKFILE ENTRIES AND POST TO GL */

   {gprun.i ""arfinupa.p""
      "(input temp_rate,
        input temp_rate2)"}

   hide frame jrnl.
   hide frame c.
   {mfrtrail.i}

end. /* REPEAT */
