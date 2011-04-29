/* glbsrp1.i - GENERAL LEDGER BALANCE SHEET REPORT SUBROUTINE TO             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.15 $                                                         */
/*V8:ConvertMode=Report                                                      */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                              */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: JMS      *F058*          */
/*                                   01/31/92   by: jms      *F119*          */
/* REVISION: 7.3                     06/28/96   by: sdp      *G1Z0*          */
/* REVISION: 7.4      LAST MODIFIED: 02/19/98   BY: *H1JR* Prashanth Narayan */
/* REVISION: 8.5                     03/19/98   by: *J240* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00S* D. Sidel          */
/* REVISION: 8.6E                    10/04/98   by: *J314* Alfred Tan        */
/* REVISION: 9.1                     08/14/00   by: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   by: *N0T4* Jyoti Thatte      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.15 $    BY: Sunil Fegade          DATE: 08/29/03  ECO: *P11W*  */
/* SS - 090708.1 By: Neil Gao */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*****************************************************************************/
/*!
This include file prints the detail lines for the balance sheet report.
*/
/*****************************************************************************/

/* DISPLAY ACCOUNT */
if prtflag = no
then do:
   /* INCLUDE FILE TO CREATE STRING FOR ACCOUNT/SUB-ACCOUNT */
   {glacct.i
      &acc=xacc
      &sub=xsub
      &cc=xcc
      &acct=account}

   /* CORRECTLY DISPLAYS ACCOUNT/SUB-ACCOUNT/COSTCENTER */
   /* COMBINATION FOR TERMINAL OUTPUT                   */

/* SS 090708.1 - B */
		find first sb_mstr where sb_domain = global_domain and sb_sub = asc_sub no-lock no-error.
		if avail sb_mstr then do: 
			account_desc = string(account,"x(22)") + " " + sb_desc.
		end.
		else 
/* SS 090708.1 - E */
   account_desc = string(account,"x(22)") + " " + ac_desc.

   put
      account_desc at min(11,(cur_level * 2 + 1)).
end. /* IF prtflag = no */

else
   put
      ac_desc at min(19, (cur_level * 2 + 1)).

/* DISPLAY BALANCE AMOUNT */
if fmbgflag = no
then do:
   if fm_dr_cr = false
   then
      balance1 = - balance.


   if fm_dr_cr = false
   then do:
      et_balance1 = - et_balance.
      put
        string(et_balance1, prtfmt) format "x(20)" to 77.
   end. /* if fm_dr_cr = false */

   else
       put string(et_balance, prtfmt) format "x(20)" to 77.

end. /* if fmbgflag = no */

else
   put skip.

totflag[cur_level] = yes.
