/* etrpvar.i - INCLUDE FILE FOR EURO REPORTING CURRENCY                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*V8:ConvertMode=Maintenance                                              */
/* REVISION: 8.6E           CREATED: 04/28/98   BY: *L00K* CPD/PDJ        */
/* REVISION: 8.6E     LAST MODIFIED: 05/27/98   BY: *L017* Adam Harris    */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *L04H* Robin McCarthy */

/* ********** Begin Translatable Strings Definitions ********* */

/*L01G   ADDED PRE-PROCESSOR LABELS */
&SCOPED-DEFINE etrpvar_i_1 "报告货币"
/* MaxLen: 19  Comment: variable used as a side-label */

&SCOPED-DEFINE etrpvar_i_2 "报告货币:  "
/* MaxLen: 21  Comment: variable used as literal text in report */

&SCOPED-DEFINE etrpvar_i_3 "兑换率:       "
/* MaxLen: 21  Comment: variable used as literal text in report*/

/* ********** End Translatable Strings Definitions ********* */

/*L01G   define {&new} shared variable et_report_curr  like exd_curr no-undo. */
/* SS - 20050711 - B */
/*
/*L01G*/ define {&new} shared variable et_report_curr  like exr_curr1 no-undo
            label {&etrpvar_i_1}.
*/
/* SS - 20050711 - E */
/*L04H **** OBSOLETING VARIABLES NO LONGER REQUIRED
 * /*L01G **** FOLLOWING VARIABLES WILL BE OBSOLETED AT END OF TRIANGULATION */
 *       define {&new} shared variable et_report_rate  like exd_rate
 *          initial 0 no-undo.
 *       define {&new} shared variable et_report_txt   as character
 *          initial "Reporting Currency:" format "x(19)" no-undo.
 *       define {&new} shared variable et_rate_txt     as character
 *          initial "Ex. rate:" format "x(9)" no-undo.
 *       define {&new} shared variable et_disp_curr    like exd_curr no-undo.
 *       define {&new} shared variable et_sr_curr      like exd_curr no-undo.
 *       define {&new} shared variable et_third_curr   like exd_curr no-undo.
 *       define {&new} shared variable et_action1      as character  no-undo.
 *       define {&new} shared variable et_action2      as character  no-undo.
 * /*L017 define {&new} shared variable et_round    like gl_ex_round no-undo. */
 * /*L017*/ define {&new} shared variable et_round  as character  no-undo.
 * /*L01G **** END VARIABLE LIST TO BE OBSOLETED AT END OF TRIANGULATION ***/
 *L04H **** END OF OBSOLETED VARIABLES SECTION */

/*L017*  define {&new} shared variable et_base_rate    like exd_rate no-undo. */
/*L017*  define {&new} shared variable et_rpt_rate     like exd_rate no-undo. */
/*L017*  define {&new} shared variable et_tr_curr      like exd_curr no-undo. */
/*L01G   define {&new} shared variable et_rate1        like exd_rate no-undo. */
/*L01G*/ define {&new} shared variable et_rate1        like exr_rate no-undo.
/*L01G   define {&new} shared variable et_rate2        like exd_rate no-undo. */
/*L01G*/ define {&new} shared variable et_rate2        like exr_rate2 no-undo.
/*L01G   define {&new} shared variable et_ex_rate      like exd_rate no-undo. */
/*L01G*/ define {&new} shared variable et_ex_rate      like exr_rate no-undo.
         define {&new} shared variable et_hide_msg     like mfc_logical no-undo.
         define {&new} shared variable et_dec_val      as decimal    no-undo.
/*L01G*/ define {&new} shared variable et_rnd_mthd    like rnd_rnd_mthd no-undo.
/*L01G*/ define {&new} shared variable mc-exch-line1   as character
            format "x(40)" no-undo.
/*L01G*/ define {&new} shared variable mc-exch-line2   as character
            format "x(40)" no-undo.
/*L01G*/ define {&new} shared variable mc-seq          like exru_seq no-undo.
/*L01G*/ define {&new} shared variable mc-curr-label   as character
            initial {&etrpvar_i_2} format "x(21)" no-undo.
/*L01G*/ define {&new} shared variable mc-exch-label   as character
            initial {&etrpvar_i_3} format "x(21)" no-undo.
