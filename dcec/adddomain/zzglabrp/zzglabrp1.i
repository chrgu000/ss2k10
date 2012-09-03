/* glabrp1.i - SUBROUTINE FOR GENERAL LEDGER ACCOUNT BALANCE REPORT           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                          */
/*V8:ConvertMode=Report                                                       */
/*                     DISPLAYS PERIOD TOTALS                                 */
/* REVISION: 7.0      LAST MODIFIED: 10/15/91   BY: JMS  *F058*               */
/*                                   02/25/92   by: jms  *F231*               */
/* REVISION: 7.3      LAST MODIFIED: 02/23/93   by: mpp  *G479*               */
/*           7.4                     07/13/93   by: skk  *H026*               */
/*           7.4                     02/13/95   by: str  *F0HY*               */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm  *J1C7*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/19/98   by: *J240* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01W* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 08/06/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 01/07/99   BY: *M0D6* J. Fernando        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QF* Rajinder Kamra     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.19 $    BY: Jean Miller          DATE: 04/08/02  ECO: *P058*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***************************************************************************/
/*!
This include file prints the detail lines for the account balance report.
*/
/***************************************************************************/
DEFINE VAR dr_act LIKE d_act FORMAT "->>>,>>>,>>>,>>9.99".   /*fm268 借*/
DEFINE VAR cr_act LIKE d_act FORMAT "->>>,>>>,>>>,>>9.99".  /*fm268 贷*/
/*
DEFINE WORKFILE wkacct
    FIELD dacct LIKE d_acct
    FIELD ddesc LIKE d_desc
    FIELD dcurr LIKE d_curr
    FIELD dbeg LIKE d_beg FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD dract LIKE d_act FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD cract LIKE d_act FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD dend LIKE d_end FORMAT "->>>,>>>,>>>,>>9.99"
    FIELD drpt LIKE d_rpt_curr. /*fm268帐户临时表*/ */
DEFINE VAR xxdesc LIKE d_desc.

if print_acct = yes then do:

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
   end.  /* if et_report_curr <> rpt_curr */
   else
      assign et_beg_bal = beg_bal.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame pdetail:handle).

   if first_acct then do:

      assign
         d_acct = asc_acc
         d_desc = ac_desc.

      display
         d_acct
         d_desc
      with frame pdetail. /*fm268 帐户和描述 fm268*/

      assign first_acct = no. /* reset the first flag */

   end.

   if not subflag and co_use_sub
      and asc_sub <> "" and first_sub
   then do:

      for first sb_mstr fields (sb_domain sb_sub sb_desc)
         where sb_domain = global_domain and sb_sub = asc_sub no-lock:
      end.

      down with frame pdetail.

      assign
         d_acct =
            substring(account,1,(length(trim(asc_acc)) + 1 + length(asc_sub)))
         d_desc = "*" + sb_desc.

      display
         d_acct
         d_desc
      with frame pdetail. /*fm268 帐户和描述 fm268*/

      assign first_sub = no. /* reset the first flag */

   end. /* sub-account desrp printed */

   if not ccflag and asc_cc <> "" and first_cc then do:

      for first cc_mstr fields (cc_domain cc_desc cc_ctr)
         where cc_domain = global_domain and  cc_ctr = asc_cc no-lock:
      end.

      down with frame pdetail.

      assign
         d_acct = account
         d_desc = "**" + cc_desc.

      display
         d_acct
         d_desc
      with frame pdetail. /*fm268 帐户和描述 fm268*/

      assign first_cc = no. /* reset the first flag */

   end. /* cc descrp printed */

   if ac_curr <> et_report_curr then do:
      d_curr = ac_curr.
      display
         d_curr
      with frame pdetail.  /*fm268 币种fm268*/
   end.

   if ac_type = "M" then do:

      d_curr = getTermLabel("MEMO",4).
      display
         d_curr
      with frame pdetail. /*fm268 币种fm268*/
   end.
   if ac_type = "S" then do:

      d_curr = getTermLabel("STAT",4).
      display
         d_curr
      with frame pdetail.  /*fm268 币种fm268*/
   end.
   d_beg = et_beg_bal.
   display
      d_beg
   with frame pdetail.  /*fm268 期初 fm268*/

   assign print_acct = no.

end.

if knt > 0 then do:

   if et_report_curr <> rpt_curr then do:
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
   end.  /* if et_report_curr <> rpt_curr */
   else assign et_per_act = per_act.

   down with frame pdetail.
   assign

      d_desc = fill(" ",8) + getTermLabel("PERIOD",7) + " " +
      string(cal.glc_per) + "/" + string(cal.glc_year)
      d_act = et_per_act.
   display
      d_desc
      d_act
   with frame pdetail. /*fm268 描述和活动金额 fm268*/

   assign
      act_to_dt = act_to_dt + per_act
      et_act_to_dt = et_act_to_dt + et_per_act
      perknt = perknt + 1.

end.  /* if knt > 0 */

if last(cal.glc_per) then do:

   et_end_bal = et_beg_bal + et_act_to_dt.

   if perknt = 0 then do:
      d_act = et_act_to_dt.
      display
         d_act
      with frame pdetail. /*fm268 活动金额 fm268*/
   end.

   if perknt > 1 then do:
      down with frame pdetail.
      display
         "-----------------------" @ d_act
      with frame pdetail.
      down with frame pdetail.
      d_act = et_act_to_dt.
      display
         d_act
      with frame pdetail.  /*fm268 活动金额 fm268*/
   end.

   assign
      d_end      = et_end_bal
      d_rpt_curr = et_report_curr.

   display
      d_end
      d_rpt_curr
   with frame pdetail. /*fm268 期末金额 和币种 fm268*/

   down 2 with frame pdetail.

   if lookup(ac_type, "M,S") = 0 then do:
      assign
         beg_tot = beg_tot + beg_bal
         per_tot = per_tot + act_to_dt
         end_tot = end_tot + end_bal
         et_beg_tot = et_beg_tot + et_beg_bal
         et_per_tot = et_per_tot + et_act_to_dt
         et_end_tot = et_end_tot + et_end_bal.
   end.  /* if lookup(ac_type, "M,S") = 0 */

   IF d_act < 0 THEN DO:
       cr_act = d_act.
       dr_act = 0.
   END. 
   IF d_act >= 0 THEN DO:
       cr_act = 0.
       dr_act = d_act.
   END. /*fm268 判断借贷*/

   FIND FIRST ac_mstr WHERE ac_domain = global_domain and
   				    ac_code = d_acct NO-ERROR.
   IF AVAIL ac_mstr THEN xxdesc = ac_desc.
   FIND FIRST ac_mstr WHERE ac_domain = global_domain and
   					  ac_code = d_acct AND ac_curr = d_curr NO-ERROR.
   IF NOT AVAIL ac_mstr THEN d_curr = "RMB". /*fm268 判断币种*/
   /*CREATE wkacct.
   ASSIGN wkacct.dacct = d_acct
          wkacct.ddesc = xxdesc
          wkacct.dcurr = d_curr
          wkacct.dbeg = d_beg
          wkacct.dract = dr_act
          wkacct.cract = cr_act
          wkacct.dend = d_end
          wkacct.drpt = d_rpt_curr.*/ /*fm268 存放到临时表中*/
   CREATE wkacct.
   ASSIGN wkacct.acct = d_acct
          wkacct.descc = xxdesc
          wkacct.acurr = d_curr
          wkacct.dbeg = d_beg
          wkacct.dract = dr_act
          wkacct.cract = cr_act
          wkacct.dend = d_end
          wkacct.rptcurr = d_rpt_curr.

end.  /* if last(cal.glc_per) */

/*FOR EACH wkacct.
    PUT wkacct.acct wkacct.descc wkacct.acurr wkacct.dbeg wkacct.dract wkacct.cract wkacct.dend wkacct.rptcurr  SKIP.
END.*/

/*
FOR EACH wkacct.
    PUT "---"  wkacct.dacct wkacct.ddesc wkacct.dcurr wkacct.dbeg wkacct.dract wkacct.cract  wkacct.dend  wkacct.drpt  "---"  SKIP. /*fm268 change fm268*/
END.
*/
