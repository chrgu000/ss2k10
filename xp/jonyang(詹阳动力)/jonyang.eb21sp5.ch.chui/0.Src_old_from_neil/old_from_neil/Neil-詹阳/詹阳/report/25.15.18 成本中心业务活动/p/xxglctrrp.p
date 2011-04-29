/* glctrrp.p - GENERAL LEDGER COST CENTER REPORT                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.20 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* Revision: 1.0      LAST MODIFIED: 01/27/88   BY: JMS                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG *A175*          */
/*                                   03/14/88   by: JMS                 */
/*                                   08/03/88   by: jms *A379*          */
/*                                   02/15/89   by: jms *A647*          */
/* REVISION: 5.0      LAST MODIFIED: 04/26/89   by: jms *B066*          */
/*                                   12/13/89   by: jms *B448*          */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms *D034*          */
/*                                   11/07/90   by: jms *D189*          */
/*                                   02/07/91   by: jms *D330*          */
/*                                   02/20/91   by: jms *D366*          */
/*                                   09/05/91   by: jms *D849*          */
/* REVISION: 7.0      LAST MODIFIED: 11/15/91   by: jms *F058*          */
/*                                   06/24/92   by: jms *F702*          */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   by: skk *G826*          */
/*                                   04/17/93   by: jms *G968*          */
/*                                   09/03/94   by: srk *FQ80*          */
/*                                   02/13/95   by: srk *G0DS*          */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays *K0T1*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna  */
/* REVISION: 8.6E     LAST MODIFIED: 04/09/98   by: EMS *L00S*              */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy   */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01W* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/19/00   BY: *M0PQ* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QH* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 11/02/00   BY: *N0TH* Manish K.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18  BY: Jean Miller DATE: 04/25/02 ECO: *P06H* */
/* $Revision: 1.20 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090707.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* SS 090707.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090707.1"}
/* SS 090707.1 - E */

define variable glname     like en_name     no-undo.
define variable begdt      like gltr_eff_dt no-undo.
define variable enddt      like gltr_eff_dt no-undo.
define variable ctr        like gltr_ctr    no-undo.
define variable ctr1       like gltr_ctr    no-undo.
define variable acc        like ac_code     no-undo.
define variable acc1       like ac_code     no-undo.
define variable sub        like sb_sub      no-undo.
define variable sub1       like sb_sub      no-undo.
define variable entity     like en_entity   no-undo.
define variable entity1    like en_entity   no-undo.
define variable cname      like en_name     no-undo.
define variable acc_tot    like gltr_amt    no-undo.
define variable grand_tot  like gltr_amt    no-undo.
define variable rpt_curr   like ac_curr     no-undo.
define variable yr_end     as date          no-undo.
define variable ret        like co_ret      no-undo.
define variable peryr      as character     no-undo.
define variable yr         as integer       no-undo.
define variable dt         as date          no-undo.
define variable dt1        as date          no-undo.
define variable use_sub    like co_use_sub  no-undo.
define variable l-assigned as logical       no-undo.
define variable zeroflag   like mfc_logical label "Suppress Zeroes" no-undo.
define variable prtcents   like mfc_logical label "Round to Nearest Whole Unit" no-undo.
define variable account    as character format "x(17)" no-undo.
define variable prtfmt     as character format "x(30)" no-undo.
define variable et_acc_tot   like gltr_amt.
define variable et_grand_tot like gltr_amt.

{etvar.i   &new = "new"} /* common euro variables        */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i              } /* some initializations         */

run assign-values ( output l-assigned ).
if not l-assigned then return.

/* SELECT FORM */
form
   entity   colon 30   entity1 colon 50 label {t001.i}
   cname    colon 30   skip(1)
   ctr      colon 30   ctr1    colon 50 label {t001.i}
   acc      colon 30   acc1    colon 50 label {t001.i}
   sub      colon 30   sub1    colon 50 label {t001.i}
   begdt    colon 30   enddt   colon 50 label {t001.i}
   zeroflag colon 30
   prtcents colon 30
   et_report_curr colon 30
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DEFINE PAGE HEADER FOR REPORT */
form header
   cname         at 1
   mc-curr-label at 27 et_report_curr skip
   mc-exch-label at 27 mc-exch-line1 skip
   mc-exch-line2 at 49 skip(1)
   skip

   getTermLabel("PERIOD_ACTIVITY",30) at 80 format "x(30)"
   getTermLabel("COST_CENTER",6)      at 1  format "x(6)"
   getTermLabel("DESCRIPTION",25)           format "x(25)"
   getTermLabel("ACCOUNT",14)               format "x(17)"
   getTermLabel("DESCRIPTION",11)           format "x(12)"

   begdt at 80 "-"  enddt
   getTermLabelRt("COST_CENTER_TOTAL",12) + "  " to 118 format "x(14)"

   fill ("-",4)  format "x(4)"  at 1
   fill ("-",24) format "x(24)" at 8
   fill ("-",17) format "x(17)" at 34
   fill ("-",24) format "x(24)" at 52
   fill ("-",19) format "x(19)" at 80
   fill ("-",25) format "x(25)" at 104
with frame phead1 page-top width 132.

{wbrp01.i}

/* REPORT BLOCK */
repeat:

   run p-reset-high.

   if c-application-mode <> 'web' then
      update
         entity entity1
         cname
         ctr ctr1
         acc acc1
         sub  when (use_sub)
         sub1 when (use_sub)
         begdt enddt
         zeroflag
         prtcents
         et_report_curr
      with frame a.

   {wbrp06.i &command = update &fields = "  entity entity1 cname
        ctr ctr1 acc acc1  sub when (use_sub)  sub1 when (use_sub)
        begdt enddt zeroflag  prtcents et_report_curr
        " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      run p-set-high.

      /* VALIDATE DATES */
      {glper1.i enddt peryr}  /*GET PERIOD/YEAR*/
      if peryr = "" then do:
         /* DATE NOT WITHIN A VALID PERIOD */
         {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt enddt with frame a.
         undo, retry.
      end.

      yr = glc_year.
      find last glc_cal  where glc_cal.glc_domain = global_domain and  glc_year
      = yr no-lock no-error.
      yr_end = glc_end.

      if begdt = ? then
         run find_glc.

      display begdt enddt with frame a.

      if begdt > enddt then do:
         {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
         if c-application-mode = 'web' then return.
         else next-prompt begdt with frame a.
         undo, retry.
      end.

      run create-batch-input-string.

   end.  /* if (c-application-mode <> 'web') ... */

   if et_report_curr <> "" then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input et_report_curr,
           output mc-error-number)"}
      if mc-error-number = 0
         and et_report_curr <> rpt_curr then do:
         /* CURRENCIES AND RATES REVERSED BELOW...             */
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
         /* CURRENCIES AND RATES REVERSED BELOW...             */
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
      end.  /* else do */

   end.  /* if et_report_curr <> "" */

   if et_report_curr = "" or et_report_curr = rpt_curr then
      assign
         mc-exch-line1 = ""
         mc-exch-line2 = ""
         et_report_curr = rpt_curr.

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

   view frame phead1.

   /* CHECK FOR UNPOSTED TRANSACTIONS */

   run p-check-unposted.

   /* SET PRINT FORMATS */
   if not prtcents then prtfmt = ">>>,>>>,>>>,>>9.99cr".
   else prtfmt = ">>,>>>,>>>,>>>,>>9cr".

   /* CYCLE THROUGH ACCOUNT FILE */
   assign
      grand_tot    = 0
      et_grand_tot = 0
      acc_tot      = 0
      et_acc_tot   = 0.

   run ip_account_loop.

   /* PRINT TOTALS */
   if page-size - line-counter < 2 then page.

   put fill("-",19) format "x(19)" at 104
       string(et_grand_tot, prtfmt) format "x(20)" to 118.

   if et_show_diff then do:

      if et_report_curr <> rpt_curr then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input rpt_curr,
              input et_report_curr,
              input et_rate1,
              input et_rate2,
              input grand_tot,
              input true,   /* ROUND */
              output grand_tot,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.  /* if et_report_curr <> rpt_curr */

      /*IF ROUND TO NEAREST UNIT THEN ROUND ORIG. */
      /* AMT. AFTER CONVERSION */
      if prtcents then
         grand_tot = round(grand_tot , 0).
      if (et_grand_tot <> grand_tot) then
         put
            et_diff_txt to 96
            string((et_grand_tot - grand_tot), prtfmt) format "x(20)" to 118.
   end. /*IF ET_SHOW_DIFF*/

   put
      fill("=",20) format "x(20)" at 104.

   hide frame phead1.

   /* REPORT TRAILER */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}

PROCEDURE p-reset-high:
   if entity1 = hi_char then assign entity1 = "".
   if acc1 = hi_char then assign acc1 = "".
   if ctr1 = hi_char then assign ctr1 = "".
   if sub1 = hi_char then assign sub1 = "".
END PROCEDURE.

PROCEDURE p-set-high:
   if entity1 = "" then assign entity1 = hi_char.
   if acc1 = "" then assign acc1 = hi_char.
   if ctr1 = "" then assign ctr1 = hi_char.
   if sub1 = "" then assign sub1 = hi_char.
   if enddt = ? then assign enddt = today.
END PROCEDURE.

PROCEDURE p-check-unposted:
   if can-find (first glt_det
       where glt_det.glt_domain = global_domain and  glt_entity >= entity
        and glt_entity <= entity1
        and glt_acc >= acc
        and glt_acc <= acc1
        and glt_sub >= sub
        and glt_sub <= sub1
        and glt_cc >= ctr
        and glt_cc <= ctr1
        and glt_effdate >= begdt
        and glt_effdate <= enddt)
   then do:
      /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT*/
      {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
   end.
END PROCEDURE.

PROCEDURE assign-values:

   define output parameter l-assigned as logical.

   l-assigned = no.

   /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */

   for first co_ctrl fields( co_domain co_ret co_use_sub)  where
   co_ctrl.co_domain = global_domain no-lock:
   end.
   if not available co_ctrl then do:
      /*CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT*/
      {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      leave.
   end.
   assign
      ret = co_ret
      use_sub = co_use_sub.

   /* GET NAME OF CURRENT ENTITY */

   for first en_mstr fields( en_domain en_name en_curr en_entity)
   no-lock  where en_mstr.en_domain = global_domain and  en_entity =
   current_entity:
   end.
   if not available en_mstr then do:
      {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      leave.
   end.
   else do:
      assign
         glname = en_name.
      release en_mstr.
   end.
   assign
      entity   = current_entity
      entity1  = current_entity
      cname    = glname
      rpt_curr = base_curr
      yr_end   = hi_date.

   l-assigned = yes.

END PROCEDURE. /* assign-values */

PROCEDURE find_glc:

   for first glc_cal fields( glc_domain glc_start glc_end glc_per glc_year)
       where glc_cal.glc_domain = global_domain and  glc_year = yr and glc_per
       = 1 no-lock:
   end.
   if available glc_cal then begdt = glc_start.
   else begdt = low_date.
END PROCEDURE.

PROCEDURE create-batch-input-string:

   /* CREATE BATCH INPUT STRING */
   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,7,
        entity,entity1,cname,ctr,ctr1,acc,acc1,
        null_char,null_char,null_char,null_char,
        null_char,null_char,null_char,
        null_char,null_char,null_char,null_char,
        null_char,null_char)"}

   if use_sub then do:
      {mfquoter.i sub  }
      {mfquoter.i sub1 }
   end.
   {mfquoter.i begdt   }
   {mfquoter.i enddt   }
   {mfquoter.i zeroflag}
   {mfquoter.i prtcents}

   {mfquoter.i et_report_curr}

END PROCEDURE.

PROCEDURE ip_account_loop:
   define variable knt        as integer       no-undo.
   define variable ctr_tot    like gltr_amt    no-undo.

   for each cc_mstr fields( cc_domain cc_desc cc_ctr)
          where cc_mstr.cc_domain = global_domain and  cc_ctr >= ctr and cc_ctr
          <= ctr1 no-lock:
      put cc_ctr at 1 cc_desc at 8.
      assign
         ctr_tot = 0
         knt     = 0.

      for each asc_mstr fields( asc_domain asc_acc asc_sub asc_cc)
          where asc_mstr.asc_domain = global_domain and  asc_cc = cc_ctr
           and asc_acc >= acc and asc_acc <= acc1
           and asc_sub >= sub and asc_sub <= sub1
         no-lock use-index asc_cc:

         for first ac_mstr fields( ac_domain ac_type ac_curr ac_desc ac_code)
         no-lock  where ac_mstr.ac_domain = global_domain and  ac_code =
         asc_acc:
         end.

         if ac_type = "M" or ac_type = "S" then next.

         {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=cc_ctr
            &begdt=begdt &enddt=enddt &balance=acc_tot
            &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}

         if et_report_curr <> rpt_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input acc_tot,
                 input true,  /* ROUND */
                 output et_acc_tot,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.  /* if et_report_curr <> base_curr */
         else et_acc_tot = acc_tot.

         if prtcents then et_acc_tot = round(et_acc_tot, 0).

         assign
            ctr_tot = ctr_tot + et_acc_tot
            grand_tot = grand_tot + acc_tot
            et_grand_tot = et_grand_tot + et_acc_tot.

         if not zeroflag or acc_tot <> 0 then do:
            if page-size - line-counter = 0 then do:
               page.
               put cc_ctr at 1 substring(cc_desc, 1, 16) at 8
                  " (" {gplblfmt.i &FUNC=getTermLabel(""CONTINUE"",4)
                  &CONCAT = "'.)'" }.
            end.

            {glacct.i &acc=asc_acc &sub=asc_sub &cc=""""   &acct=account}

/* SS 090707.1 - B */
/*
            put account at 34 ac_desc at 52
               string(et_acc_tot, prtfmt) format "x(20)" to 96.
*/
						find first sb_mstr where sb_domain = global_domain and sb_sub = asc_sub no-lock no-error.
						if avail sb_mstr then do:
							put account at 34 sb_desc at 52
               string(et_acc_tot, prtfmt) format "x(20)" to 96.
						end.
/* SS 090707.1 - E */
            knt = knt + 1.
         end.
      end.

      if page-size - line-counter < 2 then page.

      if knt <> 0 then put fill("-",19) format "x(19)" at 80 skip.
      put string(ctr_tot, prtfmt) format "x(20)" to 118 skip(1).

      {mfrpchk.i}
   end.

END PROCEDURE.
