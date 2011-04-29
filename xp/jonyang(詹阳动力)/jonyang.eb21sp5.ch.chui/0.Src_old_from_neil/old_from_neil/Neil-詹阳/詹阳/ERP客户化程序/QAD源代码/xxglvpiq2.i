/* xxglvpiq2.i - GENERAL LEDGER UNPOSTED TRANSACTION INQUIRY SUBROUTINE TO*/
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                         */
/*                          DISPLAY HEADER INFORMATION.                  */
/* REVISION: 7.0         LAST MODIFIED:  10/17/91   by: jms   *F058*     */
/*                                       02/26/92   by: jms   *F231*     */
/* REVISION: 8.6         LAST MODIFIED:  06/03/96   by: ejh   *K001*     */
/*************************************************************************/
/*!
This include file displays header information for the unposted transaction
inquiry.
*/
/*************************************************************************/



          /*  DISPLAY JOURNAL ENTRY INFORMATION */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          display gltr_ref
                  gltr_batch
                  gltr_eff_dt
                  gltr_ent_dt
                  gltr_user
                  tot_amt
/*K001*/          gltr_user1 with frame b STREAM-IO /*GUI*/ .
