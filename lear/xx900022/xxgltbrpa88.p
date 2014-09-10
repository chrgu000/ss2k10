/* gltbrpa.p - GENERAL LEDGER TRIAL BALANCE REPORT (PART II)             */
/*V8:ConvertMode=Report                                                  */

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "GLTBRPA.P"}
{xxgltbrpdef.i}
/* ********** Begin Translatable Strings Definitions ********* */

      &SCOPED-DEFINE gltbrpa_p_1 "Summarize Cost Centers"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_2 "Summarize Sub-Accounts"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_3 "Suppress Zero Amounts"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_4 "Round to Nearest Whole Unit"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_5 "Round to Nearest Thousand"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_6 "Ending Date"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_7 "Account"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE gltbrpa_p_8 "Beginning Date"
      /* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* {wbrp02.i} */

define new shared variable first_acct like mfc_logical no-undo.
define new shared variable first_sub like mfc_logical no-undo.
define new shared variable first_cc like mfc_logical no-undo.

{&GLTBRPA-P-TAG4}
define new shared variable beg_tot as decimal format
      ">>>,>>>,>>>,>>9.99cr" no-undo.
{&GLTBRPA-P-TAG5}
define new shared variable per_tot like beg_tot no-undo.
define new shared variable end_tot like beg_tot no-undo.
define new shared variable begdt1 as date no-undo.
define shared variable rpt_curr like gltr_curr no-undo.

define shared variable glname like en_name no-undo.
define shared variable begdt like gltr_eff_dt label {&gltbrpa_p_8}
      no-undo.
define shared variable enddt like gltr_eff_dt label {&gltbrpa_p_6}
      no-undo.
define shared variable yr like glc_year no-undo.
define shared variable yr_beg like gltr_eff_dt no-undo.
define shared variable ccflag like mfc_logical initial no
      label {&gltbrpa_p_1} no-undo.
define shared variable ret like co_ret no-undo.
define shared variable entity like en_entity no-undo.
define shared variable entity1 like en_entity no-undo.
define shared variable cname like glname no-undo.
define shared variable yr_end as date no-undo.
define shared variable pl like co_pl no-undo.
define shared variable var_acct like co_var_acct no-undo.
define shared variable zeroflag like mfc_logical
      label {&gltbrpa_p_3} no-undo.
define shared variable prt1000 like mfc_logical
      label {&gltbrpa_p_5} no-undo.
define shared variable round_cnts like mfc_logical
      label {&gltbrpa_p_4} no-undo.
define shared variable subflag like mfc_logical
      label {&gltbrpa_p_2} no-undo.
define shared variable prtfmt as character format "x(30)" no-undo.

define variable beg_bal like beg_tot no-undo.
define variable end_bal like beg_tot no-undo.
define variable per_act like beg_tot no-undo.
define variable knt as integer no-undo.
define variable dt as date no-undo.
define variable dt1 as date no-undo.

define variable account as character format "x(22)"
      label {&gltbrpa_p_7} no-undo.

{etvar.i}   /* common euro variables */
{etrpvar.i} /* common euro report variables */
define new shared variable et_beg_tot like beg_tot initial 0.
define new shared variable et_end_tot like end_tot initial 0.
define new shared variable et_per_tot like per_tot initial 0.
define variable et_beg_bal like beg_bal.
define variable et_per_act like per_act.
define variable et_end_bal like end_bal.

   /* CYCLE THROUGH ACCOUNT FILE */
   assign
      beg_tot = 0
      end_tot = 0
      per_tot = 0
      begdt1 = begdt - 1.
   {&GLTBRPA-P-TAG1}
   {&GLTBRPA-P-TAG6}

   /* CALCULATE BALANCE IF BOTH SUB-ACCTS & COST CTRS SUMMARIZED*/
   if ccflag and subflag then do:
      {gprun.i ""gltbrpb.p""}
   end.

   /* CALCULATE BALANCE IF SUMMARIZED SUB-ACCOUNTS*/
   else if subflag then do:
      {gprun.i ""gltbrpc.p""}
   end.

   /* CALCULATE BALANCE IF SUMMARIZED COST CENTERS */
   else if ccflag then do:
      {gprun.i ""gltbrpd.p""}
   end.

   /* CALCULATE BALANCE FOR STANDARD ACCOUNT */
   else do:

      for each asc_mstr
            fields( asc_domain asc_acc asc_sub asc_cc )
            no-lock  where asc_mstr.asc_domain = global_domain and  asc_acc >=
            "" and asc_sub >= "" and asc_cc >= ""
            break by asc_acc by asc_sub by asc_cc:

         if first-of(asc_acc) then assign first_acct = yes.
         if first-of(asc_sub) then assign first_sub = yes.
         if first-of(asc_cc) then assign first_cc = yes.

         for first ac_mstr fields( ac_domain ac_type ac_curr ac_active
                                   ac_desc ac_code)
               no-lock  where ac_mstr.ac_domain = global_domain and  ac_code =
               asc_acc:
         end.
         if not available ac_mstr then next.
         if asc_acc = pl then next.

         if lookup(ac_type, "M,S") = 0 then do:
            assign knt = 0.

            /* CALCULATE BEGINNING BALANCE */
            if lookup(ac_type, "A,L") = 0 then do:
               {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                  &begdt=yr_beg &enddt=begdt1 &balance=beg_bal
                  &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}
            end.
            else do:
               {&GLTBRPA-P-TAG2}
               {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                  &begdt=low_date &enddt=begdt1 &balance=beg_bal
                  &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}
               {&GLTBRPA-P-TAG3}
            end.

            /* CALCULATE PERIOD ACTIVITY */
            {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
               &begdt=begdt &enddt=enddt &balance=per_act
               &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}

            /* DISPLAY ACCOUNT AND AMOUNTS */
            {xxgltbrp188.i}
         end.  /* if lookup(ac_type, "M,S") = 0 */
      end.  /* for each asc_mstr */

      {mfrpchk.i}
   end.

   /*  PRINT TOTALS */

/* {&GLTBRPA-P-TAG7}                                                        */
/*   put skip(1) "-------end----------" to 73 "--------------------" to 94  */
/*      "--------------------" to 115 skip(1).                              */
/*                                                                          */
/*   put "END" + string(et_beg_tot, prtfmt) format "x(20)" to 73            */
/*       string(et_per_tot, prtfmt) format "x(20)" to 94                    */
/*       string(et_end_tot, prtfmt) format "x(20)" to 115.                  */

   if et_report_curr <> rpt_curr then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input beg_tot,
           input true,    /* ROUND */
           output beg_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input per_tot,
           input true,    /* ROUND */
           output per_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input end_tot,
           input true,    /* ROUND */
           output end_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.  /* if et_report_curr <> rpt_curr */

/*   if (beg_tot <> et_beg_tot or per_tot <> et_per_tot or                   */
/*      end_tot <> et_end_tot) and et_show_diff                              */
/*      and not prt1000 and not round_cnts then do:                          */
/*                                                                           */
/*      put "endx" + et_diff_txt to 40                                       */
/*         string(et_beg_tot - beg_tot, prtfmt) format "x(20)" to 73         */
/*         string(et_per_tot - per_tot, prtfmt) format "x(20)" to 94         */
/*         string(et_end_tot - end_tot, prtfmt) format "x(20)" to 115.       */
/*   end.                                                                    */
/*                                                                           */
/*   put "=====endx1===============" to 73 "====================" to 94      */
/*      "====================" to 115.                                       */
/*   {&GLTBRPA-P-TAG8}                                                       */
/*   {wbrp04.i}                                                              */
