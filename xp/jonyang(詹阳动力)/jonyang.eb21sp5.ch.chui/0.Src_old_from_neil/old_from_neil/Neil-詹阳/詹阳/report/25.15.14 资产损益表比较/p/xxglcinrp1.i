/* glcinrp1.i - GENERAL LEDGER COMPARATIVE INCOME STATEMENT--SUBROUTINE TO */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*V8:ConvertMode=Report                                           */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                            */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: JMS    *F058*          */
/*                                   06/30/92   by: jms    *F714*          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: rup    *L00W*          */
/* REVISION: 8.6E     LAST MODIFIED: 10/05/98   BY: *L0B6* Brenda Milton   */
/* REVISION: 9.1      LAST MODIFIED: 11/12/99   BY: *N05G* Reetu Kapoor    */
/* REVISION: 9.1      LAST MODIFIED: 02/08/00   BY: *J3P3* Ranjit Jain     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *N0T4* Manish K.       */
/* SS - 090709.1 By: Neil Gao */
/* SS - 090715.1 By: Neil Gao */

/***************************************************************************/
/*!
This include file prints the detail lines for the comparative income
statement report.
*/
/***************************************************************************/

          /* DISPLAY ACCOUNT AND AMOUNTS */
          if prtflag = no then do:
             {glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}

/*N05G*/     /* CORRECTLY DISPLAYS ACCOUNT/SUB-ACCOUNT/COSTCENTER */
/*N05G*/     /* COMBINATION FOR TERMINAL OUTPUT                   */

/* SS 090709.1 - B */
		find first sb_mstr where sb_domain = global_domain and sb_sub = asc_sub no-lock no-error.
		if avail sb_mstr then do: 
			l_acct_desc = string(account,"x(22)") + " " + sb_desc.
		end.
		else 
/* SS 090709.1 - E */
/*N05G*/     assign
/*N0T4** /*N05G*/ l_acct_desc = string(account,"x(14)") + " " + ac_desc. */
/*N0T4*/        l_acct_desc = string(account,"x(22)") + " " + ac_desc.
/*N05G**     put account at min(13,(cur_level * 3 + 1)) space(1) ac_desc. */
/*N0T4** /*N05G*/ put l_acct_desc at min(13,(cur_level * 3 + 1)). */
/* SS 090715.1 - B */
/*
/*N0T4*/     put l_acct_desc at min(9,(cur_level * 2 + 1)).
*/
							put l_acct_desc at 5 format "x(45)".
/* SS 090715.1 - E */
          end.
/*N0T4**  else put ac_desc at min(13, (cur_level * 3 + 1)). */
/*N0T4*/  else put ac_desc at min(9, (cur_level * 2 + 1)).
          if fm_dr_cr = false then do:
             do i = 1 to 2:
                balance1[i] = - balance[i].
/*L00W*         if income[i] <> 0 then */
/*L00W*            percent[i] = balance1[i] / income[i] * 100.  */
/*L00W*/        et_balance1[i] = - et_balance[i].
/*L00W*/        if et_income[i] <> 0 then
/*L00W*/           assign percent[i] = et_balance1[i] / et_income[i] * 100.
             end.
             assign variance = balance1[1] - balance1[2]
/*L00W*/            et_variance = et_balance1[1] - et_balance1[2].
             if varflag and (roundcnts or prt1000) then do:
/*L00W*         if balance1[2] <> 0 then do:                 */
/*L00W*/        if et_balance1[2] <> 0 then
/*L00W*            varpct = (variance / balance1[2]) * 100.     */
/*L00W*/           assign varpct = (et_variance / et_balance1[2]) * 100
                          pctchar = string(varpct, "->>>9.9%").
                else pctchar = "     **".
/*J3P3**        if not budget[1] or not fmbgflag then  */
/*J3P3*/        if not budget[1]    or
/*J3P3*/           not fmbgflag[1]
/*J3P3*/        then
/*L00W*            put string(balance1[1], prtfmt) format "x(17)" to 68 */
/*L00W*/           put string(et_balance1[1], prtfmt) format "x(17)" to 68
                       percent[1] to 77.
/*J3P3**        if not budget[2] or not fmbgflag then  */
/*J3P3*/        if not budget[2]   or
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(balance1[2], prtfmt) format "x(17)" to 95 */
/*L00W*/           put string(et_balance1[2], prtfmt) format "x(17)" to 95
                       percent[2] to 104.
/*J3P3**        if not fmbgflag then   */
/*J3P3*/        if not fmbgflag[1] and
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(variance, vprtfmt) format "x(17)" to 122 */
/*L00W*/           put string(et_variance, vprtfmt) format "x(17)" to 122
                       pctchar to 131.
             end.  /* if varflag and (roundcnts or prt1000) */
             else do:
/*J3P3**        if not budget[1] or not fmbgflag then       */
/*J3P3*/        if not budget[1]   or
/*J3P3*/           not fmbgflag[1]
/*J3P3*/        then
/*L00W*            put string(balance1[1], prtfmt) format "x(20)" to 71 */
/*L00W*/           put string(et_balance1[1], prtfmt) format "x(20)" to 71
                       percent[1] at 73.

/*J3P3**        if not budget[2] or not fmbgflag then       */
/*J3P3*/        if not budget[2]   or
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(balance1[2], prtfmt) format "x(20)" to 101 */
/*L00W*/           put string(et_balance1[2], prtfmt) format "x(20)" to 101
                       percent[2] at 103.

/*J3P3**        if varflag and not fmbgflag then   */
/*J3P3*/        if varflag         and
/*J3P3*/           not fmbgflag[1] and
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(variance, vprtfmt) format "x(20)" at 112.  */
/*L00W*/           put string(et_variance, vprtfmt) format "x(20)" at 112.
             end.  /* else do */
             put skip.
          end.  /* if fm_dr_cr = false */
          else do:
             do i = 1 to 2:
/*L00W*         if income[i] <> 0 then  */
/*L00W*            percent[i] = balance[i] / income[i] * 100.  */
/*L00W*/        if et_income[i] <> 0 then
/*L00W*/           percent[i] = et_balance[i] / et_income[i] * 100.
             end.  /* do i = 1 to 2 */
             assign variance = balance[2] - balance[1]
/*L00W*/            et_variance = et_balance[2] - et_balance[1].
             if varflag and (roundcnts or prt1000) then do:
/*L00W*         if balance[2] <> 0 then do:    */
/*L00W*/        if et_balance[2] <> 0 then
/*L00W*            varpct = (variance / balance[2]) * 100.   */
/*L00W*/           assign varpct = (et_variance / et_balance[2]) * 100
                          pctchar = string(varpct, "->>>9.9%").
                else pctchar = "     **".

/*J3P3**        if not budget[1] or not fmbgflag then        */
/*J3P3*/        if not budget[1]   or
/*J3P3*/           not fmbgflag[1]
/*J3P3*/        then
/*L00W*            put string(balance[1], prtfmt) format "x(17)" to 68 */
/*L00W*/           put string(et_balance[1], prtfmt) format "x(17)" to 68
                       percent[1] to 77.

/*J3P3**        if not budget[2] or not fmbgflag then        */
/*J3P3*/        if not budget[2]   or
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(balance[2], prtfmt) format "x(17)" to 95 */
/*L0B6* /*L00W*/   put string(et_variance, vprtfmt) format "x(17)" to 122 */
/*L0B6*/           put string(et_balance[2], prtfmt) format "x(17)" to 95
                       percent[2] to 104.

/*J3P3**        if not fmbgflag then    */
/*J3P3*/        if not fmbgflag[1] and
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(variance, vprtfmt) format "x(17)" to 122  */
/*L0B6* /*L00W*/   put string(et_balance[1], prtfmt) format "x(20)" to 71 */
/*L0B6*/           put string(et_variance, vprtfmt) format "x(17)" to 122
                       pctchar to 131.
             end.  /* if varflag and (roundcnts or prt1000) */
             else do:
/*J3P3**        if not budget[1] or not fmbgflag then  */
/*J3P3*/        if not budget[1]   or
/*J3P3*/           not fmbgflag[1]
/*J3P3*/        then
/*L00W*            put string(balance[1], prtfmt) format "x(20)" to 71  */
/*L0B6* /*L00W*/   put string(et_balance[2], prtfmt) format "x(20)" to 101 */
/*L0B6*/           put string(et_balance[1], prtfmt) format "x(20)" to 71
                       percent[1] at 73.

/*J3P3**        if not budget[2] or not fmbgflag then  */
/*J3P3*/        if not budget[2]   or
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L00W*            put string(balance[2], prtfmt) format "x(20)" to 101 */
/*L0B6* /*L00W*/   put string(et_variance, vprtfmt) format "x(20)" at 112 */
/*L0B6*/           put string(et_balance[2], prtfmt) format "x(20)" to 101
                       percent[2] at 103.
/*J3P3**        if varflag and not fmbgflag then  */
/*J3P3*/        if varflag         and
/*J3P3*/           not fmbgflag[1] and
/*J3P3*/           not fmbgflag[2]
/*J3P3*/        then
/*L0B6*            put string(variance, vprtfmt) format "x(20)" at 112. */
/*L0B6*/           put string(et_variance, vprtfmt) format "x(20)" at 112.
             end.  /* else do */
             put skip.
          end.  /* else do */

          totflag[cur_level] = yes.
