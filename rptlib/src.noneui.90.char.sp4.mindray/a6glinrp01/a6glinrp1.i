/* glinrp1.i - GENERAL LEDGER INCOME STATEMENT REPORT -- SUBROUTINE TO     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/*F0PN*/ /*V8:ConvertMode=Report                                           */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                            */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: JMS    *F058*          */
/*                                   02/04/92   by: jms    *F146*          */
/* REVISION: 7.3      LAST MODIFIED: 06/28/96   BY: sdp    *G1Z0*          */
/* REVISION: 8.5      LAST MODIFIED: 03/18/98   BY: *J242*  Sachin Shah    */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: AWe    *L00S*          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/99   BY: *L0HM* Hemali Desai    */
/* REVISION: 9.0SP4 LAST MODIFIED: 2005/07/10 BY: *SS - 20050710* Bill Jiang */
/***************************************************************************/
/*!
This include file prints the detail lines for the income statement report.
*/
/***************************************************************************/
/*J242* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

                           /* SS - 20050710 - B */
      /* DISPLAY ACCOUNT */
      /*
      if prtflag = no then do:
         {glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}
/*G1Z0*      /*F146*/ put account at min(19,(cur_level * 3 + 1)) ac_desc.*/
/*G1Z0*/     put account at min(19,(cur_level * 3 + 1)) " " ac_desc.
      end.

      else put ac_desc at min(19, (cur_level * 3 + 1)).
      */
      /* SS - 20050710 - E */

      /* DISPLAY BALANCE AMOUNT */
      if fm_dr_cr = false then do:
/*L00S   balance1 = - balance.
 *       if income <> 0 then percent = balance1 / income * 100.
 */
/*L00S*ADD SECTION*/
         assign
            balance1 = - balance
            et_balance1 = - et_balance.
            if et_income <> 0
               then assign percent = et_balance1 / et_income * 100.
/*L00S*END ADD SECTION*/
         if not budgflag or not fmbgflag then
/*L00S      put string(balance1, prtfmt) */
             /* SS - 20050710 - B */
             /*
/*L00S*/    put string(et_balance1, prtfmt)
            format "x(20)" to 77
            percent at 79.
         */
         CREATE wfin.
         ASSIGN
             wfin_ac_code = xacc
             wfin_sb_sub = xsub
             wfin_cc_ctr = xcc
             wfin_amt = et_balance1
             wfin_percent = percent
             .
         /* SS - 20050710 - E */
         put skip.
      end.
      else do:
/*L00S   if income <> 0 then percent = balance / income * 100. */
/*L00S*/ if et_income <> 0
/*L0HM**    then assign percent = et_balance1 / et_income * 100. */
/*L0HM*/ then
/*L0HM*/    percent = et_balance / et_income * 100.
         if not budgflag or not fmbgflag then
/*L00S      put string(balance, prtfmt) */
             /* SS - 20050710 - B */
             /*
/*L00S*/    put string(et_balance, prtfmt)
                format "x(20)" to 77
                percent at 79.
         */
         CREATE wfin.
         ASSIGN
             wfin_ac_code = xacc
             wfin_sb_sub = xsub
             wfin_cc_ctr = xcc
             wfin_amt = et_balance
             wfin_percent = percent
             .
         /* SS - 20050710 - E */
         put skip.
      end.
      assign totflag[cur_level] = yes.