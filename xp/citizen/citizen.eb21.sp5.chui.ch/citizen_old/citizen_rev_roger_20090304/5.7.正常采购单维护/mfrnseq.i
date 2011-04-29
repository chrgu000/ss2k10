/* mfrnseq.i -  READ THE NEXT SEQUENCE VALUE OF AN INDEXED COLUMN             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 07/10/95   BY: RMH    *J04K*             */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: sxb    *J0RK*             */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* $Revision: 1.7 $    BY: Jean Miller           DATE: 05/25/02  ECO: *P076*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
*
* mfrnseq.i - This routine will read the next sequence value of an indexed
*            column.
*
* INTERFACE:
*
*        {1} - the table of the column that will receive the next sequence
*               value
*        {2} - the fully qualified table and column name to which the
*              sequence is applied.  For example,  tr_hist.tr_trnbr
*        {3} - the name of the sequence
*        {4} - (J0RK) If "no", then don't suppress message display
*
*/

qad_next_seq:
do while true on error undo, retry:

   do on error undo, leave:

      /* INCLUDE MSG/PAUSE CMDS ONLY IF NOT PART OF woopmv.p */
      &if "{&file-name}" <> "woopmv.p" &then
         pause 0 no-message.
         hide message no-pause.
      &endif

      assign {2} = next-value({3}).

      /* The next-value() function reads the value which is then
       * applied to the indexed field {2}.  As the first value in
       * the sequence must allow a transaction identifier of one - 1,
       * the minimum value of the sequence is defined as zero - 0.
       * This will result in the next-value() returning the value one
       * - 1 - when the current value is defined as zero - 0.
       * The use of zero as part of a transaction number is not
       * permitted.  The sequence will cycle once it reaches its
       * maximum value.  Immediately after the sequence cycles at
       * its maximum value,  the function will return a zero.  This
       * value must be discarded and the search repeated.
       */
      if {2} = 0 then
         next qad_next_seq.

      /* ORACLE compatibility */
      if recid({1}) = -1 then .

      leave qad_next_seq.
   end. /* end:  do on error */

   /* The flow of control will arrive at this point ONLY
    * when there is a record collision on the column - {2} - value.
    * The flow of control will immediately return to the sequence
    * acquisition loop and attempt to gather the next sequence.
    */
   /* INCLUDE MSG/PAUSE CMDS ONLY IF NOT PART OF woopmv.p */
   &if "{&file-name}" <> "woopmv.p" &then
      pause 0 no-message.
      hide message no-pause.
   &endif

end. /* END:  QAD_NEXT_SEQ: DO:  */
