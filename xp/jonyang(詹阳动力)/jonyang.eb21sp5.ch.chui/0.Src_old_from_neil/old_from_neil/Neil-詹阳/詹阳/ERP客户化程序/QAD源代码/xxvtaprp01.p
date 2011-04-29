/* GUI CONVERTED from vtaprp01.p (converter v1.71) Tue Aug  4 16:31:27 1998 */
/* vtaprp01.p - AP VAT BY TRANSACTION REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/* REVISION: 5.0      LAST MODIFIED: 08/31/89   BY: MLB *EU004*           */
/* REVISION: 6.0     LAST MODIFIED: 11/05/90    BY: MLB *D170*            */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*            */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*            */
/* REVISION: 7.3      LAST MODIFIED: 03/01/93   BY: bcm *G763*            */
/*                                   04/15/93   BY: bcm *G958* (rev only) */
/*                                   03/07/94   BY: bcm *FM75*            */
/*                                   04/10/96   BY: jzw *G1LD*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: EMS *L00S*            */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey      */
/**************************************************************************/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00S*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE vtaprp01_p_1 "增值税:"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp01_p_2 "增值税金额"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable vend like ap_vend.
         define new shared variable vend1 like ap_vend.
         define new shared variable ref like ap_ref.
         define new shared variable ref1 like ap_ref.
         define new shared variable batch like ap_batch.
         define new shared variable batch1 like ap_batch.
         define new shared variable apdate like ap_date.
         define new shared variable apdate1 like ap_date.
         define new shared variable effdate like ap_effdate.
         define new shared variable effdate1 like ap_effdate.
         define new shared variable taxdate like vo_tax_date.
         define new shared variable taxdate1 like vo_tax_date.
         define variable vat like vt_class format "x(1)".
         define variable vat1 like vat.

         define new shared variable base_rpt like ap_curr.

         define new shared variable tot_base_amt like ar_amt.
         define new shared variable tot_vat_amt like ar_amt.
         define new shared variable vt_recno as recid.
         define new shared variable vat_label as character format "x(5)".
            vat_label = {&vtaprp01_p_1}.

         define new shared workfile vtw_wkfl
            field vtw_class like vt_class format "x(1)"
            field vtw_start like vt_start
            field vtw_amt   like ar_amt          label {&vtaprp01_p_2}.

/*L02S*/ define new shared variable mc_rpt_curr like gl_base_curr no-undo.

         FORM /*GUI*/ 
            vtw_class
            vtw_start
            vt_tax_pct
            space (4)
            vt_ap_acct
            vt_ap_cc no-label 
            vtw_amt
         with STREAM-IO /*GUI*/  frame c width 132 down.

					setFrameLabels(frame c:handle).

/*L00S - BEGIN DELETE */
/*       {vtaprp01.i} */
/*L00S- END DELETE    */

/*L00S - BEGIN ADD*/
         {xxvtapet01.i}
/*L00S - END ADD*/
