/* ardeltx.i - AR Dr/Cr MEMO MAINTENANCE Delete Tax Line Detail          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.6.1.4 $                                                         */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 7.4       CREATED       : 07/13/93            BY: wep *H021**/
/*                     LAST MODIFIED : 06/27/94            BY: wep *H409**/
/* REVISION: 7.4       LAST MODIFIED : 10/27/94            BY: ame *GN63**/
/* REVISION: 8.5       LAST MODIFIED : 12/19/95            BY: taf *J053**/
/* REVISION: 8.6      LAST MODIFIED : 12/30/96   BY: *K03F* Jeff Wootton */
/* REVISION: 8.6      LAST MODIFIED : 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED : 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED : 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED : 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.6.1.4 $    BY: Vinod Nair     DATE: 06/11/01 ECO: *M18H*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! ardeltx.i - Delete AR Tax Line Detail Records
*/

/*!
This include is used to delete tax detail records in AR (e.g., DR/CR
Memos) and to create the reversing GL transactions for those records.
This is used primarily before a recalculation of the taxes takes place.

Arguments:
&looplabel -   used to uniquely identify the transaction scope

*/

/* INCREMENT JOURNAL FOR FIRST CALL TO arargl.p */
if jrnl = ""
then do:
   /* GET NEXT JOURNAL REFERENCE NUMBER  */
   {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
   release glt_det.
end. /* IF jrnl = "" */

{&looplabel}:
for each ard_det where ard_nbr = ar_nbr and ard_tax = "t"
   exclusive-lock:

   /* BACK OUT GENERAL LEDGER TRANSACTIONS */

   curr_amt = - ard_amt.

   run calc_base_amt in h_rules
      (- ard_amt,
      buffer ar_mstr,
      buffer gl_ctrl,
      output base_amt).

   /* FIND THE ENTITY FOR THE CREDIT ACCOUNT */
   assign
      ard_recno = recid(ard_det)
      undo_all = yes
      base_det_amt = base_amt.

   /* CREATE GL RECORDS, DELETE TAX DETAIL RECORDS */
   {gprun.i ""arargl.p""}
   if undo_all then undo {&looplabel}, leave.

   run update_ar_amt in h_rules
      (- ard_amt,
      buffer ar_mstr).

   find cm_mstr where cm_addr = ar_bill
      exclusive-lock.
   run update_cm_balance in h_rules
      (base_amt,
      buffer ar_mstr,
      buffer cm_mstr).

   run update_ba_total in h_rules
      (- ard_amt,
      buffer ba_mstr).

   delete ard_det.

end.
