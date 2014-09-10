/* gltbrp.p - GENERAL LEDGER TRIAL BALANCE REPORT                             */
/*V8:ConvertMode=Report                                                       */
/******************************************************************************/
{mfdtitle.i "903"}
{cxcustom.i "GLTBRP.P"}
{xxgltbrpdef.i "new"}
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
                                      initial no no-undo.
define new shared variable prt1000    like mfc_logical no-undo
                                      label "Round to Nearest Thousand".
define new shared variable round_cnts like mfc_logical no-undo
                                      label "Round to Nearest Whole Unit".
define new shared variable subflag    like mfc_logical
                                      label "Summarize Sub-Accounts" no-undo.
define new shared variable prtfmt     as character format "x(30)" no-undo.
define new shared variable rpt_curr   like en_curr no-undo.
define variable vups as decimal format "->>>,>>>,>>>,>>9.99".

define variable msg1000               as character format "x(16)" no-undo.
define variable peryr                 as character no-undo.
define variable use_cc                like co_use_cc no-undo.
define variable use_sub               like co_use_sub no-undo.
define variable unposted              like mfc_logical no-undo initial yes.

define variable vaccount as character format "x(22)" no-undo.
define stream bf.
{etvar.i   &new = "new"} /* common euro variables        */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i              } /* some initializations         */

/* GET NAME OF CURRENT ENTITY */

for first en_mstr
   fields( en_domain en_name en_curr en_entity)
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
   unposted       colon 30
   et_report_curr colon 30
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */

for first co_ctrl
   fields( co_domain co_enty_bal co_pl co_ret co_use_cc co_use_sub)
 where co_ctrl.co_domain = global_domain no-lock:
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
    unposted
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
     unposted
         et_report_curr
      with frame a.

   {wbrp06.i &command = set
             &fields = "  entity entity1 cname begdt enddt
                          subflag when ( use_sub ) ccflag when ( use_cc )
                          rpt_curr zeroflag prt1000 round_cnts unposted
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
         fields( glc_domain glc_end glc_per glc_start glc_year)
      no-lock  where glc_cal.glc_domain = global_domain and  glc_year = yr and
      glc_per = 1:
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

      find last glc_cal  where glc_cal.glc_domain = global_domain and  glc_year
      = yr no-lock no-error.
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
    {mfquoter.i unposted}
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
   {mfphead.i}
/*
   view frame phead1.

   /* CHECK FOR UNPOSTED TRANSACTIONS */

   if can-find (first glt_det no-lock  where glt_det.glt_domain = global_domain
   and
      glt_entity >= entity and
      glt_entity <= entity1 and
      glt_effdate <= enddt)
   then do:
      /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
      {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
   end.
*/
   /* PRINT REPORT */
   empty temp-table tmp88 no-error.
   empty temp-table ttxxglutrrp001 no-error.

    {gprun.i ""xxgltbrpa88.p""}

   if unposted then do:
      {gprun.i ""xxglutrrp001.p"" "(
         INPUT entity,
         INPUT entity1,
         INPUT '',
         INPUT hi_char,
         INPUT low_date,
         INPUT hi_date,
         INPUT begdt,
         INPUT enddt,
         INPUT '',
         INPUT '',
         INPUT NO
         )"}


      for each ttxxglutrrp001 no-lock break by ttxxglutrrp001_glt_acc
         by ttxxglutrrp001_glt_sub by ttxxglutrrp001_glt_cc:
        if first-of(ttxxglutrrp001_glt_cc) then do:
         assign vups = 0.
        end.
        assign vups = vups + ttxxglutrrp001_glt_amt.
        if last-of(ttxxglutrrp001_glt_cc) then do:
         find first tmp88 exclusive-lock where
              t88_acct = ttxxglutrrp001_glt_acc and
              t88_sub = ttxxglutrrp001_glt_sub and
              t88_cc = ttxxglutrrp001_glt_cc no-error.
           if not available tmp88 then do:
       vaccount = "".
         {glacct.i &acc=ttxxglutrrp001_glt_acc &sub=ttxxglutrrp001_glt_sub
                       &cc=ttxxglutrrp001_glt_cc &acct=vaccount}
            create tmp88.
            assign t88_account = vaccount
           t88_acct = ttxxglutrrp001_glt_acc
                   t88_sub = ttxxglutrrp001_glt_sub
                   t88_cc = ttxxglutrrp001_glt_cc
                   t88_desc = ttxxglutrrp001_glt_desc.
         end.
         assign t88_ups = vups
                t88_end = t88_end + t88_ups.
        end.
      end.
    end.   /* if unposted then do:     */

/**
   for each tmp88 exclusive-lock:
       for each ttxxglutrrp001 no-lock where ttxxglutrrp001_glt_acc = t88_acct
            and ttxxglutrrp001_glt_sub = t88_sub
            and ttxxglutrrp001_glt_cc = t88_cc:
            assign t88_ups = t88_ups + ttxxglutrrp001_glt_amt.
       end.
   end.
**/
  if unposted then do:
     for each tmp88 no-lock where break by t88_account with frame x width 300:
       setframelabels(frame x:handle).
       display t88_account t88_desc t88_beg t88_per t88_ups t88_end.
       {mfrpchk.i}
     end.
  end.
  else do:
     for each tmp88 no-lock where break by t88_account with frame y width 300:
       setframelabels(frame y:handle).
       display t88_account t88_desc t88_beg t88_per t88_end.
       {mfrpchk.i}
     end.
  end.
   /* REPORT TRAILER */
   {mfrtrail.i}

end.  /* repeat */

{wbrp04.i &frame-spec = a}
