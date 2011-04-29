/* GUI CONVERTED from vtaprp1a.p (converter v1.71) Tue Aug  4 16:31:29 1998 */
/* vtaprp1a.p - AP VAT BY VAT CLASS REPORT                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/* web convert vtaprp1a.p (converter v1.00) Fri Oct 10 13:58:11 1997     */
/* web tag in vtaprp1a.p (converter v1.00) Mon Oct 06 14:18:53 1997      */
/*F0PN*/ /*K0WM*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=Report                                                  */
/* REVISION: 5.0      LAST MODIFIED: 08/31/89   BY: MLB *EU004*          */
/* REVISION: 6.0     LAST MODIFIED: 11/05/90    BY: MLB *D170*           */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*           */
/* REVISION: 7.0      LAST MODIFIED: 08/23/91   BY: MLV *F002*           */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*           */
/*                                   03/07/94   BY: bcm *FM75*           */
/*                                   03/01/95   BY: str *F0L1*           */
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1LD*           */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: GYK *K0WM*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: EMS *L00S*           */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey     */
/*************************************************************************/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE vtaprp1a_p_1 "增值税金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp1a_p_2 "增值税:"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp1a_p_3 "应纳税金额"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}

         define shared variable vend like ap_vend.
         define shared variable vend1 like ap_vend.
         define shared variable ref like ap_ref.
         define shared variable ref1 like ap_ref.
         define shared variable batch like ap_batch.
         define shared variable batch1 like ap_batch.
         define shared variable apdate like ap_date.
         define shared variable apdate1 like ap_date.
         define shared variable effdate like ap_effdate.
         define shared variable effdate1 like ap_effdate.
         define shared variable taxdate like vo_tax_date.
         define shared variable taxdate1 like vo_tax_date.
         define shared variable tot_base_amt like ar_amt.
         define shared variable tot_vat_amt like ar_amt.
         define shared variable base_rpt like ap_curr.
         define variable base_amt like ap_amt.
         define variable disp_curr as character format "x(1)" label "C".
         define buffer apmstr for ap_mstr.
         define variable disc_pct like ap_amt decimals 10.
         define shared variable vt_recno as recid.
         define variable base_vat like ap_amt label {&vtaprp1a_p_1}.
         define variable vat_pct like vt_tax_pct.
         define variable base_tot_amt like base_amt label {&vtaprp1a_p_3}.
         define shared variable vat_label as character format "x(5)".
            vat_label = {&vtaprp1a_p_2}.
         define shared workfile vtw_wkfl
            field vtw_class like vt_class format "x(1)"
            field vtw_start like vt_start
            field vtw_amt   like ar_amt          label {&vtaprp1a_p_1}.

/*L00S - BEGIN ADD*/
         {etrpvar.i &new = " "}
         {etvar.i   &new = " "}

         define     shared variable et_tot_base_amt like tot_base_amt no-undo.
         define     shared variable et_tot_vat_amt  like tot_vat_amt  no-undo.
/*L00S - END ADD*/

/*L02S*/ define     shared variable mc_rpt_curr like gl_base_curr no-undo.

/*L00S - BEGIN DELETE */
/*       {vtaprp1a.i} */
/*L00S - END DELETE   */

/*L00S - BEGIN ADD*/
         {xxvtapet1a(ls).i}
/*L00S - END ADD*/

         {wbrp04.i}
