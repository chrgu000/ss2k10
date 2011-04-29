/* xxglvpiq1.i - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY SUBROUTINE TO*/
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                         */
/*                      CALCULATE JOURNAL ENTRY TOTAL.                   */
/* REVISION: 7.0         LAST MODIFIED:  10/17/91   by: jms   *F058*     */
/*************************************************************************/
/*!
This include file calculates the total amount for the journal entry for
the unposted transaction inquiry.
*/
/*************************************************************************/

      /* CALCULATE JOURNAL ENTRY TOTAL */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

      tot_amt = 0.
      for each hist where hist.gltr_domain = global_domain and hist.gltr_ref = gltr_hist.gltr_ref no-lock:
         find ac_mstr where ac_domain = global_domain and ac_code = hist.gltr_acc no-lock no-error.
         if not available ac_mstr then tot_amt = tot_amt + hist.gltr_amt.
         else if ac_type <> "S" and ac_type <> "M" then
         tot_amt = tot_amt + hist.gltr_amt.
      end.
