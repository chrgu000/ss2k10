/* etrpvar.i - INCLUDE FILE FOR EURO REPORTING CURRENCY                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.16 $                                                         */
/*V8:ConvertMode=Maintenance                                              */
/* REVISION: 8.6E           CREATED: 04/28/98   BY: *L00K* CPD/PDJ        */
/* REVISION: 8.6E     LAST MODIFIED: 05/27/98   BY: *L017* Adam Harris    */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *L04H* Robin McCarthy */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder  */
/* REVISION: 9.1      LAST MODIFIED: 08/24/00   BY: *N0NF* Mudit Mehta    */
/* $Revision: 1.16 $    BY: Katie Hilbert  DATE: 03/23/01 ECO: *P008*     */
/* $Revision: 1.16 $    BY: Bill Jiang  DATE: 09/12/05 ECO: *SS - 20050912*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE etrpvar_i_1 "Reporting Currency"
/* MaxLen: 19  Comment: variable used as a side-label */

/* ********** End Translatable Strings Definitions ********* */

                                                                          /* SS - 20050912 - B */
                                                                          /*
define {&new} shared variable et_report_curr  like exr_curr1 no-undo
   label {&etrpvar_i_1}.
*/
/* SS - 20050912 - E */
define {&new} shared variable et_rate1        like exr_rate no-undo.
define {&new} shared variable et_rate2        like exr_rate2 no-undo.
define {&new} shared variable et_ex_rate      like exr_rate no-undo.
define {&new} shared variable et_hide_msg     like mfc_logical no-undo.
define {&new} shared variable et_dec_val      as decimal    no-undo.
define {&new} shared variable et_rnd_mthd    like rnd_rnd_mthd no-undo.
define {&new} shared variable mc-exch-line1   as character
   format "x(40)" no-undo.
define {&new} shared variable mc-exch-line2   as character
   format "x(40)" no-undo.
define {&new} shared variable mc-seq          like exru_seq no-undo.
define {&new} shared variable mc-curr-label   as character
   format "x(21)" no-undo.
define {&new} shared variable mc-exch-label   as character
   format "x(21)" no-undo.

&IF ("{&new}" = "new") &THEN
   assign
      mc-curr-label = getTermLabel("REPORTING_CURRENCY",19) + ": "
      mc-exch-label = getTermLabel("EXCHANGE_RATE",19) + ": ".
&ENDIF
