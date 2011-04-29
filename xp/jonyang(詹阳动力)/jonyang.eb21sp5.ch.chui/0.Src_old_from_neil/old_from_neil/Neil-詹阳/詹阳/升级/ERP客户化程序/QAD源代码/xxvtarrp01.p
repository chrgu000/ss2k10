/* GUI CONVERTED from vtarrp01.p (converter v1.71) Tue Aug  4 16:31:37 1998 */
/* vtarrp01.p - AR-VAT REPORT BY VAT CLASS                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/* REVISION: 5.0      LAST MODIFIED: 08/11/89   BY: MLB *EU004*           */
/* REVISION: 5.0      LAST MODIFIED: 10/16/89   BY: MLB *EU010 (rev only)**/
/* REVISION: 6.0      LAST MODIFIED: 11/02/90   BY: MLB *D170*            */
/* REVISION: 6.0      LAST MODIFIED: 12/03/90   BY: MLB *D238*            */
/* REVISION: 6.0      LAST MODIFIED: 05/23/91   BY: MLV *D655 (rev only)* */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*            */
/*                                   03/07/94   BY: bcm *FM75*            */
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: EMS *L00S*            */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey      */
/**************************************************************************/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00S*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE vtarrp01_p_1 "增值税金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtarrp01_p_2 "增值税:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable cust like ar_cust.
         define new shared variable cust1 like ar_cust.
         define new shared variable nbr like ar_nbr.
         define new shared variable nbr1 like ar_nbr.
         define new shared variable batch like ar_batch.
         define new shared variable batch1 like ar_batch.
         define new shared variable ardate like ar_date.
         define new shared variable ardate1 like ar_date.
         define new shared variable effdate like ar_effdate.
         define new shared variable effdate1 like ar_effdate.
         define new shared variable taxdate like ar_tax_date.
         define new shared variable taxdate1 like ar_tax_date.
         define new shared variable base_rpt like ar_curr.
         define variable vat like vt_class format "x(1)".
         define variable vat1 like vat.

         define new shared variable tot_base_amt like ar_amt.
         define new shared variable tot_vat_amt like ar_amt.
         define variable vat_label as character format "x(5)".
            vat_label = {&vtarrp01_p_2}.
         define new shared variable vt_recno as recid.
         define new shared workfile vtw_wkfl
            field vtw_class like vt_class format "x(1)"
            field vtw_start like vt_start
            field vtw_amt   like ar_amt          label {&vtarrp01_p_1}.

/*L02S*/ define new shared variable mc_rpt_curr like gl_base_curr no-undo.

         FORM /*GUI*/ 
            vtw_class
            vtw_start
            vt_tax_pct
            space (4)
            vt_ar_acct
            vt_ar_cc no-label
            vtw_amt
         with STREAM-IO /*GUI*/  frame c width 132 down.

/*L00S - BEGIN DELETE */
/*       {vtarrp01.i} */
/*L00S - END DELETE   */

/*L00S - BEGIN ADD*/
         {xxvtaret01.i}
/*L00S - END ADD*/
