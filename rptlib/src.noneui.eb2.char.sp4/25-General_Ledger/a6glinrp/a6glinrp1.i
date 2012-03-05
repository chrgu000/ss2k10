/* glinrp1.i - GENERAL LEDGER INCOME STATEMENT REPORT -- SUBROUTINE TO        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                           */
/*V8:ConvertMode=Report                                                       */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                               */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: JMS    *F058*             */
/*                                   02/04/92   by: jms    *F146*             */
/* REVISION: 7.3      LAST MODIFIED: 06/28/96   BY: sdp    *G1Z0*             */
/* REVISION: 8.5      LAST MODIFIED: 03/18/98   BY: *J242*  Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: AWe    *L00S*             */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/99   BY: *L0HM* Hemali Desai       */
/* REVISION: 9.1      LAST MODIFIED: 11/12/99   BY: *N05G* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *N0T4* Manish K.          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.12 $    BY: Ashish M.             DATE: 10/22/01  ECO: *N14T*  */
/* $Revision: 1.12 $    BY: Bill jiang             DATE: 09/22/05  ECO: *SS - 20050922*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/
/*!
This include file prints the detail lines for the income statement report.
*/
/******************************************************************************/

/* DISPLAY ACCOUNT */
/* SS - 20050922 - B */
/*
if prtflag = no
then do:
   {glacct.i &acc=xacc &sub=xsub &cc=xcc &acct=account}

   /* CORRECTLY DISPLAYS ACCOUNT/SUB-ACCOUNT/COSTCENTER */
   /* COMBINATION FOR TERMINAL OUTPUT                   */

   l_acct_desc = string(account,"x(22)") + " " + ac_desc.

   put l_acct_desc at min(13,(cur_level + 1)).
end. /* IF partflag = no */

else
   put ac_desc at min(19, (cur_level * 2 + 1)).
   */
   /* SS - 20050922 - E */

/* DISPLAY BALANCE AMOUNT */

if fm_dr_cr = false
then do:
   assign
      balance1    = - balance
      et_balance1 = - et_balance.

   if et_income <> 0
   then
      percent = et_balance1 / et_income * 100.

   if not budgflag
   or not fmbgflag
   then
       /* SS - 20050922 - B */
       /*
      put string(et_balance1, prtfmt)
         format "x(20)" to 77
         percent at 79.

   put skip.
   */
   DO:
       CREATE tta6glinrp.
       ASSIGN
           tta6glinrp_acc = xacc
           tta6glinrp_sub = xsub
           tta6glinrp_cc = xcc
           tta6glinrp_amt = et_balance1
           .
   END.
   /* SS - 20050922 - E */
end. /* IF fm_dr_cr = false */

else do:
   if et_income <> 0
   then
      percent = et_balance / et_income * 100.

   if not budgflag
   or not fmbgflag
   then
       /* SS - 20050922 - B */
       /*
      put string(et_balance, prtfmt)
         format "x(20)" to 77
         percent at 79.

   put skip.
   */
   DO:
       CREATE tta6glinrp.
       ASSIGN
           tta6glinrp_acc = xacc
           tta6glinrp_sub = xsub
           tta6glinrp_cc = xcc
           tta6glinrp_amt = et_balance
           .
   END.
   /* SS - 20050922 - E */
end. /* ELSE DO */

totflag[cur_level] = yes.
