/* glpjrp1.i - SUBROUTINE FOR GENERAL LEDGER PROJECT REPORT SUBROUTINE  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*                     DISPLAYS PERIOD TOTALS                           */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   BY: JMS   *F058*        */
/*                                   07/09/92   BY: JMS   *F712*        */
/*                                   08/17/94   by: pmf   *FQ24*        */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: AWe   *L00M*        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/************************************************************************/
/*!
This include file prints the detail lines for the project report.
*/
/************************************************************************/
/* SS - Bill - B 2005.07.07 */
/*

      /* DISPLAY ACCOUNT CODE & DESCRIPTION */
      if page-size - line-counter < 2 then do:
         view frame phead1.
         page.
         put pj_project at 1.
         hide frame phead1.
      end.
/*FQ24*   {glacct.i &acc=asc_acc &sub=asc_sub &cc=asc_cc &acct=account} */
/*FQ24*/  {glacct.i &acc=asc_acc &sub=xsub    &cc=xcc    &acct=account}
      put account at 11 ac_desc at 27.
      /* PRINT ACCOUNT TOTAL */
/*L00M /*F712*/  put string(acc_tot, prtfmt) format "x(20)" to 78 skip. */
      proj_tot = proj_tot + acc_tot.
      grand_tot = grand_tot + acc_tot.
/*L00M*ADD SECTION*/
      put string(et_acc_tot, prtfmt) format "x(20)" to 78 skip.
      assign
        et_proj_tot = et_proj_tot + et_acc_tot
        et_grand_tot = et_grand_tot + et_acc_tot.
/*L00M*END ADD SECTION*/
      */
/*FQ24*/  {glacct.i &acc=asc_acc &sub=xsub    &cc=xcc    &acct=account}
    proj_tot = proj_tot + acc_tot.
    grand_tot = grand_tot + acc_tot.
    assign
      et_proj_tot = et_proj_tot + et_acc_tot
      et_grand_tot = et_grand_tot + et_acc_tot.
    CREATE wfpj.
    ASSIGN
        wfpj_acc = account
        wfpj_project = pj_project
        wfpj_type = pj_type
        wfpj_desc = pj_desc
        wfpj_amt = et_acc_tot
        .
      /* SS - Bill - E */
