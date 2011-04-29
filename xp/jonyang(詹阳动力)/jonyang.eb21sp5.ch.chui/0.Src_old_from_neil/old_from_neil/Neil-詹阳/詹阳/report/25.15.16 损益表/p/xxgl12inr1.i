/* gl12inr1.i - GENERAL LEDGER 12-COLUMN INCOME STATEMENT--SUBROUTINE TO      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11 $                                                           */
/*V8:ConvertMode=Report                                                       */
/*                DISPLAY ACCOUNTS AND AMOUNTS.                               */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: JMS     *F340*            */
/* REVISION: 7.3      LAST MODIFIED: 09/13/96   BY: jzw     *G2F9*            */
/* REVISION: 8.5      LAST MODIFIED: 03/12/98   BY: *J23W*  Sachin Shah       */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel rev only  */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.11 $    BY: Jean Miller           DATE: 08/18/04  ECO: *Q0CD*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
This include file prints the detail lines for the 12-column income statement
report.
*/

/* DISPLAY ACCOUNT AND AMOUNTS */
/* SS 090715.1 - B */
find first sb_mstr where sb_domain = global_domain and sb_sub = asc_sub no-lock no-error.
if avail sb_mstr then put sb_desc at min(9, ((cur_level - 1) * 2 + 3)).
else
/* SS 090715.1 - E */
if available ac_mstr then
   put ac_desc at min(9, ((cur_level - 1) * 2 + 3)).

if fm_dr_cr = false then do:
   do i = 1 to 12:
      assign
         cramt = - balance[i].
      if incpct[i] then assign pct[i] = - pct[i].
      if actual[i] or variance[i] or (budget[i] and not fmbgflag[i])
         then put cramt to (51 + ((i - 1) * 17)).
      else
      if varpct[i] or incpct[i] then
         put pct[i] to (51 + ((i - 1) * 17)).
   end.
   put skip.
end.
else do:
   do i = 1 to 12:
      if actual[i] or variance[i] or (budget[i] and not fmbgflag[i])
         then put balance[i] to (51 + ((i - 1) * 17)).
      else
      if varpct[i] or incpct[i] then
         put pct[i] to (51 + ((i - 1) * 17)).
   end.
   put skip.
end.

assign
   totflag[cur_level] = yes.
