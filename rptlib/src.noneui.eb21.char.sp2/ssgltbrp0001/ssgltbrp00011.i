/* gltbrp1.i - GENERAL LEDGER TRIAL BALANCE REPORT SUBROUTINE TO              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                          */
/*V8:ConvertMode=Report                                                       */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                               */
/* REVISION: 7.0      LAST MODIFIED: 10/08/91   by: jms  *F058*               */
/*                                   01/28/92   by: jms  *F107*               */
/* REVISION: 7.3      LAST MODIFIED: 12/18/92   by: mpp  *G479*               */
/*           7.4                     07/20/93   by: skk  *H031* sub/cc descrp */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm  *J1C7*               */
/* REVISION: 8.5      LAST MODIFIED: 03/12/98   BY: *J242*  Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   by: *L00S* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 08/05/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14     BY: Jean Miller          DATE: 04/08/02  ECO: *P058*  */
/* Revision: 1.15  BY: Narathip W. DATE: 04/23/03 ECO: *P0QD* */
/* $Revision: 1.17 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.17 $ BY: Bill Jiang DATE: 08/08/08 ECO: *SS - 20080808.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "GLTBRP1.I"}

/***************************************************************************/
/*!
This include file prints the detail lines for the trial balance report.
*/
/***************************************************************************/

/* DISPLAY ACCOUNT AND AMOUNTS */
assign end_bal = beg_bal + per_act.
/* SS - 20080808.1 - B */
assign 
   end_bal_dr = beg_bal_dr + per_act_dr
   end_bal_cr = beg_bal_cr + per_act_cr
   end_bal_dr_amt = beg_bal_dr_amt + per_act_dr_amt
   end_bal_cr_amt = beg_bal_cr_amt + per_act_cr_amt
   end_bal_dr_camt = beg_bal_dr_camt + per_act_dr_camt
   end_bal_cr_camt = beg_bal_cr_camt + per_act_cr_camt
   end_bal_dr_eamt = beg_bal_dr_eamt + per_act_dr_eamt
   end_bal_cr_eamt = beg_bal_cr_eamt + per_act_cr_eamt
   .
/* SS - 20080808.1 - E */

/* SS - 20080808.1 - B */
if 
   beg_bal_dr_amt <> 0 
   or beg_bal_cr_amt <> 0 
   or per_act_dr_amt <> 0 
   or per_act_cr_amt <> 0 
   or end_bal_dr_amt <> 0
   or end_bal_cr_amt <> 0
   or beg_bal_dr_camt <> 0 
   or beg_bal_cr_camt <> 0 
   or per_act_dr_camt <> 0 
   or per_act_cr_camt <> 0 
   or end_bal_dr_camt <> 0
   or end_bal_cr_camt <> 0
   or beg_bal_dr_eamt <> 0 
   or beg_bal_cr_eamt <> 0 
   or per_act_dr_eamt <> 0 
   or per_act_cr_eamt <> 0 
   or end_bal_dr_eamt <> 0
   or end_bal_cr_eamt <> 0
   then do
   :
   CREATE ttssgltbrp0001.
   ASSIGN
      ttssgltbrp0001_acc = ASC_acc
      ttssgltbrp0001_sub = ASC_sub
      ttssgltbrp0001_cc = ASC_cc
      ttssgltbrp0001_beg_bal_dr_amt = beg_bal_dr_amt
      ttssgltbrp0001_beg_bal_cr_amt = beg_bal_cr_amt
      ttssgltbrp0001_per_act_dr_amt = per_act_dr_amt
      ttssgltbrp0001_per_act_cr_amt = per_act_cr_amt
      ttssgltbrp0001_end_bal_dr_amt = end_bal_dr_amt
      ttssgltbrp0001_end_bal_cr_amt = end_bal_cr_amt
      ttssgltbrp0001_beg_bal_dr_camt = beg_bal_dr_camt
      ttssgltbrp0001_beg_bal_cr_camt = beg_bal_cr_camt
      ttssgltbrp0001_per_act_dr_camt = per_act_dr_camt
      ttssgltbrp0001_per_act_cr_camt = per_act_cr_camt
      ttssgltbrp0001_end_bal_dr_camt = end_bal_dr_camt
      ttssgltbrp0001_end_bal_cr_camt = end_bal_cr_camt
      ttssgltbrp0001_beg_bal_dr_eamt = beg_bal_dr_eamt
      ttssgltbrp0001_beg_bal_cr_eamt = beg_bal_cr_eamt
      ttssgltbrp0001_per_act_dr_eamt = per_act_dr_eamt
      ttssgltbrp0001_per_act_cr_eamt = per_act_cr_eamt
      ttssgltbrp0001_end_bal_dr_eamt = end_bal_dr_eamt
      ttssgltbrp0001_end_bal_cr_eamt = end_bal_cr_eamt
      .
END.
/*
{&GLTBRP1-I-TAG1}
if et_report_curr <> rpt_curr then do:

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input rpt_curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input beg_bal,
        input true,    /* ROUND */
        output et_beg_bal,
        output mc-error-number)"}

     if mc-error-number <> 0 then do:
        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
     end.

     {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input per_act,
           input true,    /* ROUND */
           output et_per_act,
           output mc-error-number)"}
     if mc-error-number <> 0 then do:
        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
     end.
end.  /* if et_report_curr <> rpt_curr          */
else
   assign et_beg_bal = beg_bal
          et_per_act = per_act.
          et_end_bal = et_beg_bal + et_per_act.

{&GLTBRP1-I-TAG2}
if not zeroflag or beg_bal <> 0 or per_act <> 0 or end_bal <> 0
or et_beg_bal <> 0 or et_per_act <> 0 or et_end_bal <> 0
then do:

   if ac_active = yes or beg_bal <> 0 or per_act <> 0 or end_bal <> 0
   or et_beg_bal <> 0 or et_per_act <> 0 or et_end_bal <> 0
   then do:
      {&GLTBRP1-I-TAG3}

      if ccflag and subflag then do:
         {glacct.i &acc=asc_mstr.asc_acc &sub="""" &cc=""""
            &acct=account}
      end.
      else if ccflag then do:
         {glacct.i &acc=asc_mstr.asc_acc &sub=asc_mstr.asc_sub
            &cc="""" &acct=account}
      end.
      else if subflag then do:
         {glacct.i &acc=asc_mstr.asc_acc &sub="""" &cc=asc_mstr.asc_cc
            &acct=account}
      end.
      else do:
         {glacct.i &acc=asc_mstr.asc_acc &sub=asc_mstr.asc_sub
            &cc=asc_mstr.asc_cc &acct=account}
      end.

      {&GLTBRP1-I-TAG4}
      if first_acct then
         put
            asc_acc at 2
            ac_desc at 25.

      {&GLTBRP1-I-TAG5}
      if first_sub and asc_sub <> "" and co_use_sub
      then do:
         for first sb_mstr
         fields( sb_domain sb_desc sb_sub)
          where sb_mstr.sb_domain = global_domain and  sb_sub = asc_sub
         no-lock: end.
         {&GLTBRP1-I-TAG6}
         put
            substring(account,1,(length(trim(asc_acc))+ 1 + length(asc_sub)))
               format "x(22)" at 2
            sb_desc at 26.
         {&GLTBRP1-I-TAG7}
      end. /* sub-account desrp printed */

      if asc_cc <> "" and first_cc then do:
         for first cc_mstr
         fields( cc_domain cc_desc cc_ctr)
          where cc_mstr.cc_domain = global_domain and  cc_ctr = asc_cc no-lock:
          end.
         {&GLTBRP1-I-TAG8}
         put
            account at 2
            cc_desc at 27.
         {&GLTBRP1-I-TAG9}
      end. /* cc descrp printed */

      if ac_curr <> et_report_curr then put ac_curr at 51.

      {&GLTBRP1-I-TAG10}
      /* ROUND IF NECESSARY */
      if prt1000 then do:
         assign
            beg_bal = round(beg_bal / 1000, 0)
            per_act = round(per_act / 1000, 0)
            end_bal = round(end_bal / 1000, 0)
            {&GLTBRP1-I-TAG11}
            et_beg_bal = round(et_beg_bal / 1000, 0)
            et_per_act = round(et_per_act / 1000, 0)
            et_end_bal = round(et_end_bal / 1000, 0).
         {&GLTBRP1-I-TAG12}
      end.

      /* CALCULATE TOTALS */
      assign
         beg_tot = beg_tot + beg_bal
         per_tot = per_tot + per_act
         end_tot = end_tot + end_bal
         {&GLTBRP1-I-TAG13}
         et_beg_tot = et_beg_tot + et_beg_bal
         et_per_tot = et_per_tot + et_per_act
         et_end_tot = et_end_tot + et_end_bal.

      put
         string(et_beg_bal, prtfmt) format "x(20)" to 73
         string(et_per_act, prtfmt) format "x(20)" to 94
         string(et_end_bal, prtfmt) format "x(20)" to 115.
      {&GLTBRP1-I-TAG14}

   end.  /* if ac_active = yes or beg_bal <> 0 ... */

   assign
      first_acct = no
      first_sub = no
      first_cc = no.

end.  /* if not zeroflag or beg_bal <> 0 ... */
*/
/* SS - 20080808.1 - E */