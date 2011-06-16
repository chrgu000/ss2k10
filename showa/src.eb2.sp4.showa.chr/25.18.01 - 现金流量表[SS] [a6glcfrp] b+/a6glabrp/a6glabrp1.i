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
/* $Revision: 1.19 $    BY: Bill Jiang          DATE: 09/13/05  ECO: *SS - 20050913*  */
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

      /* SS - 20050913 - B */
      /*
      display
         d_acct
         d_desc
      with frame pdetail.
      */
      FIND FIRST tta6glabrp WHERE tta6glabrp_code = d_acct NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tta6glabrp THEN DO:
          CREATE tta6glabrp.
          ASSIGN
              tta6glabrp_code = d_acct
              tta6glabrp_desc = d_desc
              .
      END.
      /* SS - 20050913 - E */

      assign first_acct = no. /* reset the first flag */

   end.

   if not subflag and co_use_sub
      and asc_sub <> "" and first_sub
   then do:

      for first sb_mstr fields (sb_sub sb_desc)
         where sb_sub = asc_sub no-lock:
      end.

      /* SS - 20050913 - B */
      /*
      down with frame pdetail.
      */
      /* SS - 20050913 - E */

      assign
         d_acct =
            substring(account,1,(length(trim(asc_acc)) + 1 + length(asc_sub)))
         d_desc = "*" + sb_desc.

      /* SS - 20050913 - B */
      /*
      display
         d_acct
         d_desc
      with frame pdetail.
      */
      /* SS - 20050913 - E */

      assign first_sub = no. /* reset the first flag */

   end. /* sub-account desrp printed */

   if not ccflag and asc_cc <> "" and first_cc then do:

      for first cc_mstr fields (cc_desc cc_ctr)
         where cc_ctr = asc_cc no-lock:
      end.

      /* SS - 20050913 - B */
      /*
      down with frame pdetail.
      */
      /* SS - 20050913 - E */

      assign
         d_acct = account
         d_desc = "**" + cc_desc.

      /* SS - 20050913 - B */
      /*
      display
         d_acct
         d_desc
      with frame pdetail.
      */
      /* SS - 20050913 - E */

      assign first_cc = no. /* reset the first flag */

   end. /* cc descrp printed */

   /* SS - 20050913 - B */
   /*
   if ac_curr <> et_report_curr then do:
      d_curr = ac_curr.
      display
         d_curr
      with frame pdetail.
   end.

   if ac_type = "M" then do:

      d_curr = getTermLabel("MEMO",4).
      display
         d_curr
      with frame pdetail.
   end.
   if ac_type = "S" then do:

      d_curr = getTermLabel("STAT",4).
      display
         d_curr
      with frame pdetail.
   end.
   d_beg = et_beg_bal.
   display
      d_beg
   with frame pdetail.
   */
   if ac_curr <> et_report_curr then do:
      d_curr = ac_curr.
   end.

   if ac_type = "M" then do:

      d_curr = getTermLabel("MEMO",4).
   end.
   if ac_type = "S" then do:

      d_curr = getTermLabel("STAT",4).
   end.
   d_beg = et_beg_bal.

   FIND FIRST tta6glabrp WHERE tta6glabrp_code = d_acct NO-LOCK NO-ERROR.
   IF AVAILABLE tta6glabrp THEN DO:
       ASSIGN tta6glabrp_et_beg_bal = tta6glabrp_et_beg_bal + et_beg_bal.
   END.
   /* SS - 20050913 - E */

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

   /* SS - 20050913 - B */
   /*
   down with frame pdetail.
   */
   /* SS - 20050913 - E */
   assign

      d_desc = fill(" ",8) + getTermLabel("PERIOD",7) + " " +
      string(cal.glc_per) + "/" + string(cal.glc_year)
      d_act = et_per_act.
   /* SS - 20050913 - B */
   /*
   display
      d_desc
      d_act
   with frame pdetail.
   */
   /* SS - 20050913 - E */

   assign
      act_to_dt = act_to_dt + per_act
      et_act_to_dt = et_act_to_dt + et_per_act
      perknt = perknt + 1.

end.  /* if knt > 0 */

if last(cal.glc_per) then do:

   et_end_bal = et_beg_bal + et_act_to_dt.

   /* SS - 20050913 - B */
   /*
   if perknt = 0 then do:
      d_act = et_act_to_dt.
      display
         d_act
      with frame pdetail.
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
      with frame pdetail.
   end.

   assign
      d_end      = et_end_bal
      d_rpt_curr = et_report_curr.

   display
      d_end
      d_rpt_curr
   with frame pdetail.

   down 2 with frame pdetail.
   */
   if perknt = 0 then do:
      d_act = et_act_to_dt.
   end.

   if perknt > 1 then do:
      d_act = et_act_to_dt.
   end.

   assign
      d_end      = et_end_bal
      d_rpt_curr = et_report_curr.

   FIND FIRST tta6glabrp WHERE tta6glabrp_code = d_acct NO-LOCK NO-ERROR.
   IF AVAILABLE tta6glabrp THEN DO:
       ASSIGN tta6glabrp_et_end_bal = tta6glabrp_et_end_bal + et_end_bal.
   END.
   /* SS - 20050913 - E */

   if lookup(ac_type, "M,S") = 0 then do:
      assign
         beg_tot = beg_tot + beg_bal
         per_tot = per_tot + act_to_dt
         end_tot = end_tot + end_bal
         et_beg_tot = et_beg_tot + et_beg_bal
         et_per_tot = et_per_tot + et_act_to_dt
         et_end_tot = et_end_tot + et_end_bal.
   end.  /* if lookup(ac_type, "M,S") = 0 */

end.  /* if last(cal.glc_per) */
