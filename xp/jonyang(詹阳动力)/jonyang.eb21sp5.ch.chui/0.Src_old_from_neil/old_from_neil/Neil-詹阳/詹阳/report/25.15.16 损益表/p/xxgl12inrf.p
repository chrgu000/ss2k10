/* gl12inrf.p - GENERAL LEDGER 12 COLUMN INCOME STATEMENT REPORT (PART VII)*/
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* web convert gl12inrf.p (converter v1.00) Fri Oct 10 13:57:40 1997 */
/* web tag in gl12inrf.p (converter v1.00) Mon Oct 06 14:18:14 1997 */
/*F0PN*/ /*K1DS*/
/*V8:ConvertMode=Report                                           */
/*                  (Individual accounts)                                  */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   by: jms *F340*             */
/*                                   04/14/92   by: jms *F396*             */
/* REVISION: 7.3      LAST MODIFIED: 04/14/93   by: skk *G945*             */
/*                                   02/08/95   by: jzw *F0HJ*             */
/*                                   09/13/96   by: jzw *G2F9*             */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm *K1DS*             */
/* REVISION: 8.6           MODIFIED: 03/12/98   By: *J23W*  Sachin Shah    */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel        */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton   */
/* REVISION: 9.0      LAST MODIFIED: 01/21/00   BY: *M0HX* Ranjit Jain     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* $Revision: 1.12 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/


/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

          {mfdeclre.i}

          {wbrp02.i}

          /* DATA DEFINITIONS */
          {gl12inr3.i}

/*J23W**  find fm_mstr where recid(fm_mstr) = fm_recno no-lock. **/

/*J23W*/  for first fm_mstr fields( fm_domain fm_fpos fm_dr_cr)
/*J23W*/      where recid(fm_mstr) = fm_recno no-lock: end.

          for each asc_mstr
/*J23W*/     fields( asc_domain asc_sub asc_acc asc_cc asc_fpos)
              where asc_mstr.asc_domain = global_domain and  asc_fpos = fm_fpos
              and
                   asc_sub >= sub     and
                   asc_sub <= sub1    and
                   asc_cc  >= ctr     and
                   asc_cc  <= ctr1 no-lock
/*M0HX*/     use-index asc_fasc
             break by asc_fpos
                   by asc_acc:

/*J23W**     find ac_mstr where ac_code = asc_acc no-lock no-error.**/

/*J23W*/     for first ac_mstr
/*J23W*/         fields( ac_domain ac_curr ac_active ac_type ac_desc ac_code)
/*J23W*/          where ac_mstr.ac_domain = global_domain and  ac_code =
asc_acc no-lock: end.

             if first-of(asc_acc) then do:
/*J23W*/        assign
                   xacc = asc_acc.
                display with no-box.
             end.

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
             assign
                xsub = asc_sub
                xcc = asc_cc
                balance = 0
                pct = 0.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */

             do i = 1 to 12:
                if budget[i] and not fmbgflag[i] then do:
                   {glacbg.i &acc=xacc &sub=xsub &cc=xcc
                             &yr=fiscal_yr[i] &begper=per_beg[i]
                             &endper=per_end[i] &budget=balance[i]
                             &bcode=bcode[i]}

/*L01W* /*L00S*/   {etrpconv.i balance[i] balance[i]} */

/*L01W*/           if et_report_curr <> rpt_curr then do:
/*L01W*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input balance[i],
                          input true,    /* ROUND */
                          output balance[i],
                          output mc-error-number)"}
/*L01W*/              if mc-error-number <> 0 then do:
/*L01W*/                 {mfmsg.i mc-error-number 2}
/*L01W*/              end.
/*L01W*/           end.  /* if et_report_curr <> rpt_curr */

                end.  /* if budget[i] and not fmbgflag[i] */

                else if actual[i] then do:
                   {glacbal1.i &acc=xacc &sub=xsub &cc=xcc
                               &begdt=begdt[i] &enddt=enddt[i]
                               &balance=balance[i] &yrend=yr_end[i]
                               &rptcurr=rpt_curr &accurr=ac_curr}

/*L01W* /*L00S*/   {etrpconv.i balance[i] balance[i]} */
/*L01W*/           if et_report_curr <> rpt_curr then do:
/*L01W*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input balance[i],
                          input true,    /* ROUND */
                          output balance[i],
                          output mc-error-number)"}
/*L01W*/              if mc-error-number <> 0 then do:
/*L01W*/                 {mfmsg.i mc-error-number 2}
/*L01W*/              end.
/*L01W*/           end.  /* if et_report_curr <> rpt_curr */

                end.  /* else if actual[i] */

                else if variance[i] and i > 2 then do:
/*J23W*/           assign
                      balance[i] = balance[i - 2] - balance[i - 1].
                end.

                else if varpct[i] and i > 2 and balance[i - 2] <> 0 then
/*J23W*/           assign
                      pct[i] = (balance[i - 1 ] / balance[i - 2]) * 100.

                else if incpct[i] and i > 1 and income[i] <> 0 then
/*J23W*/           assign
                      pct[i] = (balance[i - 1] / income[i]) * 100.
             end.  /* do i = 1 to 12 */

             do i = 1 to 12:
                if prt1000 then assign balance[i] = round(balance[i] / 1000, 0).
                else
/*J23W*/           assign
                      balance[i] = round(balance[i], 0).
             end.  /* do i = 1 to 12 */

             /* CHECK IF ALL COLUMNS ARE ZERO */
/*J23W*/     assign
                zflag = no.
             do i = 1 to 12:
                if balance[i] <> 0 then
/*J23W*/           assign
                      zflag = yes.
             end.  /* do i = 1 to 12 */

             if level > cur_level then
                if zflag then do:
                   /* PRINT ALL NON-ZERO BALANCES FOR ALL ACCOUNTS */
/* SS 090715.1 - B */
/*
                   {gl12inr1.i}
*/
                   {xxgl12inr1.i}
/* SS 090715.1 - E */
                end.
                else
                if not zeroflag and ac_active then do:
                   /* PRINT ZERO BALANCES FOR ACTIVE ACCOUNTS ONLY */
/* SS 090715.1 - B */
/*
                   {gl12inr1.i}
*/
                   {xxgl12inr1.i}
/* SS 090715.1 - E */
                end.

                if lookup(ac_type, "M,S") = 0 then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
                   assign
                      tot1[cur_level] = tot1[cur_level] + balance[1]
                      tot2[cur_level] = tot2[cur_level] + balance[2]
                      tot3[cur_level] = tot3[cur_level] + balance[3]
                      tot4[cur_level] = tot4[cur_level] + balance[4]
                      tot5[cur_level] = tot5[cur_level] + balance[5]
                      tot6[cur_level] = tot6[cur_level] + balance[6]
                      tot7[cur_level] = tot7[cur_level] + balance[7]
                      tot8[cur_level] = tot8[cur_level] + balance[8]
                      tot9[cur_level] = tot9[cur_level] + balance[9]
                      tot10[cur_level] = tot10[cur_level] + balance[10]
                      tot11[cur_level] = tot11[cur_level] + balance[11]
                      tot12[cur_level] = tot12[cur_level] + balance[12].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
                end.  /* if lookup(ac_type, "M,S") = 0 */

             end.  /* if level > cur_level */
             {wbrp04.i}
