/* gl4inrp1.i - GENERAL LEDGER 4-COLUMN INCOME STATEMENT--SUBROUTINE TO       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8 $                                                           */
/*V8:ConvertMode=Report                                                       */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                               */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: JMS     *F058*            */
/* REVISION: 8.5      LAST MODIFIED: 03/12/98   BY: *J23W*  Sachin Shah       */
/* REVISION: 9.0      LAST MODIFIED: 02/08/00   BY: *J3P3*  Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.8 $    BY: Jean Miller           DATE: 08/18/04  ECO: *Q0CD*  */
/* SS - 090715.1 By: Neil Gao */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
This include file prints the detail lines for the 4-column income statement
report.
*/

/* DISPLAY ACCOUNT AND AMOUNTS */
/* SS 090715.1 - B */
find first sb_mstr where sb_domain = global_domain and sb_sub = asc_sub no-lock no-error.
if avail sb_mstr then put sb_desc at min(9, ((cur_level - 1) * 2 + 3)).
else
/* SS 090715.1 - E */
put ac_desc at min(9, ((cur_level - 1) * 2 + 3)).

if fm_dr_cr = false then do:
   do i = 1 to 4:

      assign
         cramt = - balance[i]
         pct = 0.

      if income[i] <> 0 then
         assign pct = cramt / income[i] * 100.

      if not budget[i] or not fmbgflag[i]
      then
         put
            cramt at (34 + ((i - 1) * 25))
            pct at (52 + ((i - 1) * 25)).
   end.

   put skip.

end.

else do:

   do i = 1 to 4:

      assign pct = 0.
      if income[i] <> 0 then assign pct = balance[i] / income[i] * 100.

      if not budget[i] or not fmbgflag[i]
      then
      put
         balance[i] at (34 + ((i - 1) * 25))
         pct at (52 + ((i - 1) * 25)).
   end.

   put skip.

end.

assign
   totflag[cur_level] = yes.
