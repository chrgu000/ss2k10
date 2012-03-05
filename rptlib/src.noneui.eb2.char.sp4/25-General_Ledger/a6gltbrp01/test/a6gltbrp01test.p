/* gltbrp.p - GENERAL LEDGER TRIAL BALANCE REPORT                          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.20 $                                                         */
/*V8:ConvertMode=Report                                                    */
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                    */
/*                                   01/29/88       jms  CSR 28967         */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88       jms                    */
/*                                   02/29/88   BY: WUG *A175*             */
/*                                   03/14/88   by: jms                    */
/*                                   06/13/88   by: jms *A274* (no-undo)   */
/* REVISION: 5.0      LAST MODIFIED: 04/26/88   by: jms *B066*             */
/*                                   06/19/89   by: jms *B154*             */
/*                                   06/20/89   by: jms *B155*             */
/*                                   04/11/90   by: jms *B499*             */
/*                                   05/21/90   by: jms *C187*             */
/*                                  (program also split into two)          */
/*                                   06/07/90   by: jms *B704*  (rev only) */
/*                                   07/03/90   by: jms *B727*  (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 09/05/90   by: jms *D034*             */
/*                                   11/07/90   by: jms *D189*             */
/*                                   12/11/90   by: jms *D255*             */
/*                                   01/04/91   by: jms *D287* (rev only)  */
/*                                   02/20/91   by: jms *D366* (rev only)  */
/*                                   09/05/91   by: jms *D849* (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 11/07/91   by: jms *F058*             */
/*                                   01/28/92   by: jms *F107*             */
/*                                   02/25/92   by: jms *F231*             */
/*                                   06/24/92   by: jms *F702*             */
/* REVISION: 7.3      LAST MODIFIED: 12/16/92   by: mpp *G479*             */
/*                                   09/03/94   by: srk *FQ80*             */
/*                                   01/18/95   by: srk *G0C1*             */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm *J1C7*             */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   by: ckm *K118*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah   */
/* REVISION: 8.6E     LAST MODIFIED: 04/08/98   BY: *H1K1* Samir Bavkar    */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00S* D. Sidel        */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt       */
/* REVISION: 9.1      LAST MODIFIED: 08/05/99   BY: *N014* Murali Ayyagari */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QJ* BalbeerS Rajput */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.20 $    BY: Narathip W.           DATE: 04/23/03  ECO: *P0QD*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060107 - B */
{a6gltbrp01.i "new"}
/* SS - 20060107 - E */

{mfdtitle.i "2+ "}
{cxcustom.i "GLTBRP.P"}

define new shared variable glname     like en_name no-undo.
define new shared variable begdt      like gltr_eff_dt
                                      label "Beginning Date" no-undo.
define new shared variable enddt      like gltr_eff_dt
                                      label "Ending Date" no-undo.
define new shared variable yr         like glc_year no-undo.
define new shared variable yr_beg     like gltr_eff_dt no-undo.
define new shared variable ccflag     like mfc_logical initial no
                                      label "Summarize Cost Centers" no-undo.
define new shared variable ret        like co_ret no-undo.
define new shared variable entity     like en_entity no-undo.
define new shared variable entity1    like en_entity no-undo.
define new shared variable cname      like glname no-undo.
define new shared variable yr_end     as date no-undo.
define new shared variable pl         like co_pl no-undo.
define new shared variable zeroflag   like mfc_logical
                                      label "Suppress Zero Amounts"
                                      initial yes no-undo.
define new shared variable prt1000    like mfc_logical no-undo
                                      label "Round to Nearest Thousand".
define new shared variable round_cnts like mfc_logical no-undo
                                      label "Round to Nearest Whole Unit".
define new shared variable subflag    like mfc_logical
                                      label "Summarize Sub-Accounts" no-undo.
define new shared variable prtfmt     as character format "x(30)" no-undo.
define new shared variable rpt_curr   like en_curr no-undo.

define variable msg1000               as character format "x(16)" no-undo.
define variable peryr                 as character no-undo.
define variable use_cc                like co_use_cc no-undo.
define variable use_sub               like co_use_sub no-undo.

{etvar.i   &new = "new"} /* common euro variables        */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i              } /* some initializations         */

/* GET NAME OF CURRENT ENTITY */

for first en_mstr
   fields (en_name en_curr en_entity)
no-lock where en_entity = current_entity:
end.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
   if not batchrun then
      if c-application-mode <> 'web' then
         pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.

assign
   entity   = current_entity
   entity1  = current_entity
   cname    = glname
   rpt_curr = base_curr.

/* SELECT FORM */
form
   entity         colon 30 entity1    colon 45 label "To"
   cname          colon 30 skip(1)
   begdt          colon 30
   enddt          colon 30
   subflag        colon 30
   ccflag         colon 30
   rpt_curr       colon 30
   zeroflag       colon 30
   prt1000        colon 30
   round_cnts     colon 30
   et_report_curr colon 30
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */

for first co_ctrl
   fields (co_enty_bal co_pl co_ret co_use_cc co_use_sub)
no-lock:
end.
if not available co_ctrl then do:
   /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
   {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
   if not batchrun then
      if c-application-mode <> 'web' then
         pause.
   leave.
end.

assign
   ret     = co_ret
   pl      = co_pl
   use_cc  = co_use_cc
   use_sub = co_use_sub.

if co_enty_bal = no then
   assign
      entity  = ""
      entity1 = ""
      cname   = "".

/* SS - 20060107 - B */
/*
{&GLTBRP-P-TAG1}
/* DEFINE HEADERS */
form header
   cname         at 1
   space(2)
   msg1000
   mc-curr-label at 60 et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 skip
   mc-exch-line2 at 82 skip(1)
   skip
   getTermLabelRt("BEGINNING_BALANCE",35) to 72  format "x(35)"
   getTermLabel("PERIOD_ACTIVITY",17)     to 94  format "x(17)"
   getTermLabel("ENDING_BALANCE",16)      to 114 format "x(16)" skip
   getTermLabel("ACCOUNT",22)             at 1   format "x(22)"
   getTermLabel("DESCRIPTION",30)         at 24  format "x(30)"
   begdt at 61
   enddt at 102
   getTermLabel("ADJUST",6)  at 117 format "x(6)"
   getTermLabel("BALANCE",7) at 124 format "x(7)" skip
   "----------------------- ------------------------" at 1
   "-------------------" to 73
   "-------------------" to 94
   "-------------------" to 115
   "------"  at 117
   "-------" at 124
with frame phead1 page-top width 132.
{&GLTBRP-P-TAG2}
*/
/* SS - 20060107 - E */

/* REPORT BLOCK */

{wbrp01.i}

repeat:

   if entity1 = hi_char then entity1 = "".

   display
      entity
      entity1
      cname
      begdt
      enddt
      subflag
      ccflag
      rpt_curr
      zeroflag
      prt1000
      round_cnts
      et_report_curr
   with frame a.

   if c-application-mode <> 'web' then
      set
         entity
         entity1
         cname
         begdt
         enddt
         subflag when (use_sub)
         ccflag  when (use_cc)
         rpt_curr
         zeroflag
         prt1000
         round_cnts
         et_report_curr
      with frame a.

   {wbrp06.i &command = set
             &fields = "  entity entity1 cname begdt enddt
                          subflag when ( use_sub ) ccflag when ( use_cc )
                          rpt_curr zeroflag prt1000 round_cnts
                          et_report_curr "
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      if entity1 = "" then entity1 = hi_char.
      if rpt_curr = "" then rpt_curr = base_curr.

      /* VALIDATE DATES */
      if enddt = ? then assign enddt = today.
      {glper1.i enddt peryr} /* GET PERIOD/YEAR */
      if peryr = "" then do:
         /* DATE NOT WITHIN A VALID PERIOD */
         {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt enddt with frame a.
         undo, retry.
      end.

      yr = glc_year.

      for first glc_cal
         fields (glc_end glc_per glc_start glc_year)
      no-lock where glc_year = yr and glc_per = 1:
      end.
      if not available glc_cal then do:
         /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR */
         {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt enddt with frame a.
         undo, retry.
      end.

      yr_beg = glc_start.
      if begdt = ? then
         begdt = yr_beg.

      display
         begdt
         enddt
      with frame a.

      if begdt > enddt then do:
         /* END DATE CANNOT BE BEFORE START DATE */
         {pxmsg.i &MSGNUM=123 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt enddt with frame a.
         undo, retry.
      end.

      if begdt < yr_beg then do:
         /* REPORT CANNOT SPAN FISCAL YEARS */
         {pxmsg.i &MSGNUM=3031 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         undo, retry.
      end.

      find last glc_cal where glc_year = yr no-lock no-error.
      yr_end = glc_end.

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i cname   }
      {mfquoter.i begdt   }
      {mfquoter.i enddt   }
      if use_sub then do:
         {mfquoter.i subflag }
      end.
      if use_cc then do:
         {mfquoter.i ccflag  }
      end.
      {mfquoter.i rpt_curr}
      {mfquoter.i zeroflag}
      {mfquoter.i prt1000 }
      {mfquoter.i round_cnts}
      {mfquoter.i et_report_curr}

      if et_report_curr <> "" then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input et_report_curr,
              output mc-error-number)"}
         if mc-error-number = 0
            and et_report_curr <> rpt_curr then do:
            /* CURRENCIES AND RATES REVERSED BELOW...*/
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input et_report_curr,
                 input rpt_curr,
                 input "" "",
                 input et_eff_date,
                 output et_rate2,
                 output et_rate1,
                 output mc-seq,
                 output mc-error-number)"}
         end.  /* if mc-error-number = 0 */

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt et_report_curr with frame a.
            undo, retry.
         end.  /* if mc-error-number <> 0 */
         else if et_report_curr <> rpt_curr then do:
            /* CURRENCIES AND RATES REVERSED BELOW...*/
            {gprunp.i "mcui" "p" "mc-ex-rate-output"
               "(input et_report_curr,
                 input rpt_curr,
                 input et_rate2,
                 input et_rate1,
                 input mc-seq,
                 output mc-exch-line1,
                 output mc-exch-line2)"}
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input mc-seq)"}
         end.
      end.  /* if et_report_curr <> "" */
      if et_report_curr = "" or et_report_curr = rpt_curr then
         assign
            mc-exch-line1  = ""
            mc-exch-line2  = ""
            et_report_curr = rpt_curr.

      /* SET MESSAGE */
      msg1000 = "".

      if prt1000 then
         msg1000 = "(" + getTermLabel("IN_1000'S",10) + " " +
                   et_report_curr + ")".

      /* SET PRINT FORMAT */
      {&GLTBRP-P-TAG3}
      prtfmt = ">>>,>>>,>>>,>>>.99cr".
      if round_cnts or prt1000 then
         prtfmt = ">>,>>>,>>>,>>>,>>9cr".
      {&GLTBRP-P-TAG4}

   end.  /* if (c-application-mode <> 'web') ... */

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
   /* SS - 20060107 - B */            
   /*
   {mfphead.i}

   view frame phead1.
   */
   /* SS - 20060107 - E */

   /* CHECK FOR UNPOSTED TRANSACTIONS */

   if can-find (first glt_det no-lock where
      glt_entity >= entity and
      glt_entity <= entity1 and
      glt_effdate <= enddt)
   then do:
      /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
      {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
   end.

   /* SS - 20060107 - B */
   /*
   /* PRINT REPORT */
   {gprun.i ""gltbrpa.p""}

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6gltbrp01:
      DELETE tta6gltbrp01.
   END.
   {gprun.i ""a6gltbrp01.p"" "(
      INPUT entity,
      INPUT entity1,
      INPUT begdt,  
      INPUT enddt,
      INPUT subflag,
      INPUT ccflag,
      INPUT rpt_curr,
      INPUT zeroflag,
      INPUT prt1000,
      INPUT ROUND_cnts,
      INPUT et_report_curr
      )"}
   EXPORT DELIMITER ";" "ac_code" "ac_desc" "sb_sub" "sb_desc" "cc_ctr" "cc_desc" "ac_curr" "beg_bal" "per_act" "end_bal" "et_beg_bal" "et_per_act" "et_end_bal".
   FOR EACH tta6gltbrp01:
      EXPORT DELIMITER ";" tta6gltbrp01.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {a6mfrtrail.i}
   /* SS - 20060107 - E */

end.  /* repeat */

{wbrp04.i &frame-spec = a}
