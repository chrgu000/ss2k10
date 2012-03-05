/* gltbrpa.p - GENERAL LEDGER TRIAL BALANCE REPORT (PART II)             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.20 $                                                   */
/*V8:ConvertMode=Report                                                  */
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                  */
/*                                   01/29/88       jms  CSR 28967       */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88       jms                  */
/*                                   02/29/88   BY: WUG *A175*           */
/*                                   03/14/88   by: jms                  */
/*                                   06/13/88   by: jms *A274* (no-undo) */
/* REVISION: 5.0      LAST MODIFIED: 04/26/88   by: jms *B066*           */
/*                                   06/19/89   by: jms *B154*           */
/*                                   06/20/89   by: jms *B155*           */
/*                                   04/11/90   by: jms *B499*           */
/*                                   05/21/90   by: jms *C187*           */
/*                                  (program also split into two)        */
/*                                   06/07/90   by: jms *B704*           */
/*                                   07/03/90   by: jms *B727*           */
/* REVISION: 6.0      LAST MODIFIED: 10/08/90   by: jms *D034*           */
/*                                   11/07/90   by: jms *D189*           */
/*                                   01/04/91   by: jms *D287*           */
/*                                   02/20/91   by: jms *D366*           */
/*                                   09/05/91   by: jms *D849*           */
/* REVISION: 7.0      LAST MODIFIED: 11/07/91   by: jms *F058*           */
/*                                                 (major re-write)      */
/*                                   01/28/92   by: jms *F107*           */
/* REVISION: 7.3      LAST MODIFIED: 12/16/92   by: mpp *G479*           */
/*           7.4                     07/20/93   by: skk *H031* sub/cc descrp  */
/*       ORACLE PERFORMANCE FIX      11/21/96   BY: rxm *H0PS*           */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm *J1C7*           */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   by: ckm *K118*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   by: *L00S*  D. Sidel     */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton */
/* REVISION: 9.1      LAST MODIFIED: 08/05/99   BY: *N014* Murali Ayyagari */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 09/23/00   BY: *N0VY* BalbeerS Rajput */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.17     BY: Katie Hilbert  DATE: 03/10/01 ECO: *N0XB*   */
/* Revision: 1.18  BY: Narathip W. DATE: 04/23/03 ECO: *P0QD* */
/* $Revision: 1.20 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.20 $ BY: Bill Jiang DATE: 08/08/08 ECO: *SS - 20080808.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "GLTBRPA.P"}

/* SS - 20080808.1 - B */
{ssgltbrp0001.i}
/* SS - 20080808.1 - E */

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

{wbrp02.i}

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
/* SS - 20080808.1 - B */
define variable beg_bal_dr like beg_tot no-undo.
define variable beg_bal_cr like beg_tot no-undo.
define variable beg_bal_dr_amt like beg_tot no-undo.
define variable beg_bal_cr_amt like beg_tot no-undo.
define variable beg_bal_dr_camt like beg_tot no-undo.
define variable beg_bal_cr_camt like beg_tot no-undo.
define variable beg_bal_dr_eamt like beg_tot no-undo.
define variable beg_bal_cr_eamt like beg_tot no-undo.
/* SS - 20080808.1 - E */
define variable end_bal like beg_tot no-undo.
/* SS - 20080808.1 - B */
define variable end_bal_dr like beg_tot no-undo.
define variable end_bal_cr like beg_tot no-undo.
define variable end_bal_dr_amt like beg_tot no-undo.
define variable end_bal_cr_amt like beg_tot no-undo.
define variable end_bal_dr_camt like beg_tot no-undo.
define variable end_bal_cr_camt like beg_tot no-undo.
define variable end_bal_dr_eamt like beg_tot no-undo.
define variable end_bal_cr_eamt like beg_tot no-undo.
/* SS - 20080808.1 - E */
define variable per_act like beg_tot no-undo.
/* SS - 20080808.1 - B */
define variable per_act_dr like beg_tot no-undo.
define variable per_act_cr like beg_tot no-undo.
define variable per_act_dr_amt like beg_tot no-undo.
define variable per_act_cr_amt like beg_tot no-undo.
define variable per_act_dr_camt like beg_tot no-undo.
define variable per_act_cr_camt like beg_tot no-undo.
define variable per_act_dr_eamt like beg_tot no-undo.
define variable per_act_cr_eamt like beg_tot no-undo.
/* SS - 20080808.1 - E */
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

   /* SS - 20080808.1 - B */
   /*
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
   */
   do:
   /* SS - 20080808.1 - E */

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

            /* SS - 20080808.1 - B */
            /*
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
            {gltbrp1.i}
            */
            /* CALCULATE BEGINNING BALANCE */
            if lookup(ac_type, "A,L") = 0 then do:
               {ssgltbrp0001acbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                  &begdt=yr_beg &enddt=begdt1 &balance=beg_bal
                  &balance_dr=beg_bal_dr
                  &balance_cr=beg_bal_cr
                  &balance_dr_amt=beg_bal_dr_amt
                  &balance_cr_amt=beg_bal_cr_amt
                  &balance_dr_curramt=beg_bal_dr_camt
                  &balance_cr_curramt=beg_bal_cr_camt
                  &balance_dr_ecur_amt=beg_bal_dr_eamt
                  &balance_cr_ecur_amt=beg_bal_cr_eamt
                  &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}
            end.
            else do:
               {&GLTBRPA-P-TAG2}
               {ssgltbrp0001acbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                  &begdt=low_date &enddt=begdt1 &balance=beg_bal
                  &balance_dr=beg_bal_dr
                  &balance_cr=beg_bal_cr
                  &balance_dr_amt=beg_bal_dr_amt
                  &balance_cr_amt=beg_bal_cr_amt
                  &balance_dr_curramt=beg_bal_dr_camt
                  &balance_cr_curramt=beg_bal_cr_camt
                  &balance_dr_ecur_amt=beg_bal_dr_eamt
                  &balance_cr_ecur_amt=beg_bal_cr_eamt
                  &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}
               {&GLTBRPA-P-TAG3}
            end.

            /* CALCULATE PERIOD ACTIVITY */
            {ssgltbrp0001acbal2.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
               &begdt=begdt &enddt=enddt &balance=per_act
               &balance_dr=per_act_dr
               &balance_cr=per_act_cr
               &balance_dr_amt=per_act_dr_amt
               &balance_cr_amt=per_act_cr_amt
               &balance_dr_curramt=per_act_dr_camt
               &balance_cr_curramt=per_act_cr_camt
               &balance_dr_ecur_amt=per_act_dr_eamt
               &balance_cr_ecur_amt=per_act_cr_eamt
               &yrend=yr_end &rptcurr=rpt_curr &accurr=ac_curr}

            /* DISPLAY ACCOUNT AND AMOUNTS */
            {ssgltbrp00011.i}
            /* SS - 20080808.1 - E */
         end.  /* if lookup(ac_type, "M,S") = 0 */
      end.  /* for each asc_mstr */

      {mfrpchk.i}
   end.

   /* SS - 20080808.1 - B */
   /*
   /*  PRINT TOTALS */

   {&GLTBRPA-P-TAG7}
   put skip(1) "--------------------" to 73 "--------------------" to 94
      "--------------------" to 115 skip(1).

   put string(et_beg_tot, prtfmt) format "x(20)" to 73
       string(et_per_tot, prtfmt) format "x(20)" to 94
       string(et_end_tot, prtfmt) format "x(20)" to 115.

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

   if (beg_tot <> et_beg_tot or per_tot <> et_per_tot or
      end_tot <> et_end_tot) and et_show_diff
      and not prt1000 and not round_cnts then do:

      put et_diff_txt to 40
         string(et_beg_tot - beg_tot, prtfmt) format "x(20)" to 73
         string(et_per_tot - per_tot, prtfmt) format "x(20)" to 94
         string(et_end_tot - end_tot, prtfmt) format "x(20)" to 115.
   end.

   put "====================" to 73 "====================" to 94
      "====================" to 115.
   {&GLTBRPA-P-TAG8}
   */
   /* SS - 20080808.1 - E */
   {wbrp04.i}
