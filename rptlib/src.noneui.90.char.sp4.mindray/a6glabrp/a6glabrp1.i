/* glabrp1.i - SUBROUTINE FOR GENERAL LEDGER ACCOUNT BALANCE REPORT      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                         */
/*                     DISPLAYS PERIOD TOTALS                            */
/* REVISION: 7.0      LAST MODIFIED: 10/15/91   BY: JMS  *F058*          */
/*                                   02/25/92   by: jms  *F231*          */
/* REVISION: 7.3      LAST MODIFIED: 02/23/93   by: mpp  *G479*          */
/*           7.4                     07/13/93   by: skk  *H026*          */
/*           7.4                     02/13/95   by: str  *F0HY*          */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm  *J1C7*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 03/19/98   by: *J240* Kawal Batra   */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel      */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01W* Brenda Milton */

/***************************************************************************/
/*!
This include file prints the detail lines for the account balance report.
*/
/***************************************************************************/
/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
                 FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabrp1_i_1 "统计"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp1_i_2 "期间 "
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp1_i_3 "通知"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

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

/*L01W* /*L00M*/ {etrpconv.i beg_bal et_beg_bal} */
/*L01W*/     if et_report_curr <> rpt_curr then do:
/*L01W*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input beg_bal,
                    input true,    /* ROUND */
                    output et_beg_bal,
                    output mc-error-number)"}
/*L01W*/        if mc-error-number <> 0 then do:
/*L01W*/           {mfmsg.i mc-error-number 2}
/*L01W*/        end.
/*L01W*/     end.  /* if et_report_curr <> rpt_curr */
/*L01W*/     else assign et_beg_bal = beg_bal.

             if first_acct then do:
                 /* SS - Bill - B 2005.06.02 */
                 /*
                put asc_acc at 2
                    ac_desc at 17.
                */
                /* SS - Bill - E */
                assign first_acct = no. /* reset the first flag */
             end.

             if not subflag and (co_use_sub or global_sub_len > 0)
                and asc_sub <> "" and first_sub then do:

/*J240**        find sb_mstr where sb_sub = asc_sub no-lock. **/
/*J240*/        for first sb_mstr fields (sb_sub sb_desc)
/*J240*/            where sb_sub = asc_sub no-lock: end.

/* SS - Bill - B 2005.06.02 */
/*
                put substring(account,1,(length(trim(asc_acc)) + 1
                              + length(asc_sub))) format "x(14)" at 2
                              "*" at 17 sb_desc at 18.
                */
                /* SS - Bill - E */
                assign first_sub = no. /* reset the first flag */
             end. /* sub-account desrp printed */

             if not ccflag and asc_cc <> "" and first_cc then do:

/*J240**        find cc_mstr where cc_ctr = asc_cc no-lock.**/
/*J240*/        for first cc_mstr fields (cc_desc cc_ctr)
/*J240*/            where cc_ctr = asc_cc no-lock: end.

/* SS - Bill - B 2005.06.02 */
/*
                put account at 2
                    "**" at 17 cc_desc at 19.
                */
                /* SS - Bill - E */
                assign first_cc = no. /* reset the first flag */
             end. /* cc descrp printed */

/*L00M*      if ac_curr <> rpt_curr /*base_curr*/      */
/*L00M*         then put ac_curr at 42.    */
/*L01W* /*L00M*/ if ac_curr <> et_disp_curr then put ac_curr at 42. */
             /* SS - Bill - B 2005.06.02 */
             /*
/*L01W*/     if ac_curr <> et_report_curr then put ac_curr at 42.

             if ac_type = "M" then put {&glabrp1_i_3} at 42.
             if ac_type = "S" then put {&glabrp1_i_1} at 42.
/*L00M       put beg_bal to 69. */
/*L00M*/     put et_beg_bal to 69.
*/
/* SS - Bill - E */
/* SS - Bill - B 2005.06.02 */
output_et_beg_bal = output_et_beg_bal + et_beg_bal.
/* SS - Bill - E */

             assign print_acct = no.
          end.

          if knt > 0 then do:
/*L01W* /*L00M*/ {etrpconv.i per_act et_per_act} */
/*L01W*/     if et_report_curr <> rpt_curr then do:
/*L01W*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input per_act,
                    input true,    /* ROUND */
                    output et_per_act,
                    output mc-error-number)"}
/*L01W*/        if mc-error-number <> 0 then do:
/*L01W*/           {mfmsg.i mc-error-number 2}
/*L01W*/        end.
/*L01W*/     end.  /* if et_report_curr <> rpt_curr */
/*L01W*/     else assign et_per_act = per_act.

/* SS - Bill - B 2005.06.02 */
/*
             put {&glabrp1_i_2} + string(cal.glc_per) + "/" +
                 string(cal.glc_year) format "x(15)" at 25
/*L00M           per_act to 94. */
/*L00M*/         et_per_act to 94.
             */
             /* SS - Bill - E */

             assign
                act_to_dt = act_to_dt + per_act
/*L00M*/        et_act_to_dt = et_act_to_dt + et_per_act
                perknt = perknt + 1.

          end.  /* if knt > 0 */

          if last(cal.glc_per) then do:
/*L00M*BEGIN DELETE*
 .           end_bal = beg_bal + act_to_dt.
 .
 .           if perknt = 0 then put act_to_dt to 94.
 .           if perknt > 1 then put "-----------------------" to 94
 .              act_to_dt to 94.
 .           put end_bal to 119.
 *L00M*END DELETE*/

/*L00M*ADD SECTION*/
             et_end_bal = et_beg_bal + et_act_to_dt.
             /* SS - Bill - B 2005.06.02 */
             /*
             if perknt = 0 then put et_act_to_dt to 94.
             if perknt > 1 then put "-----------------------" to 94
             et_act_to_dt to 94.
             put et_end_bal to 119.
             */
             output_et_end_bal = output_et_end_bal + et_end_bal.

             /*
/*L01W*      put et_disp_curr at 121. */
/*L01W*/     put et_report_curr at 121.
/*L00M*END ADD SECTION*/
*/
             /* SS - Bill - E */

/*L00M*      if rpt_curr <> base_curr then put rpt_curr at 121. */
             /*
             put skip(1).
             */
             /* SS - Bill - E */
             if lookup(ac_type, "M,S") = 0 then do:

                assign
                   beg_tot = beg_tot + beg_bal
                   per_tot = per_tot + act_to_dt
                   end_tot = end_tot + end_bal.
/*L00M*/           et_beg_tot = et_beg_tot + et_beg_bal.
/*L00M*/           et_per_tot = et_per_tot + et_act_to_dt.
/*L00M*/           et_end_tot = et_end_tot + et_end_bal.
             end.  /* if lookup(ac_type, "M,S") = 0 */
          end.  /* if last(cal.glc_per) */
