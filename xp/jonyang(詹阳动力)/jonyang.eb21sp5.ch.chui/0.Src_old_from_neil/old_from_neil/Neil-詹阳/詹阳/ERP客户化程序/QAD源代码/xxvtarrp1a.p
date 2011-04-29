/* GUI CONVERTED from vtarrp1a.p (converter v1.71) Tue Aug  4 16:31:39 1998 */
/* vtarrp1a.p - SUBPROGRAM TO AR-VAT REPORT BY VAT CLASS                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/* web convert vtarrp1a.p (converter v1.00) Fri Oct 10 13:58:11 1997     */
/* web tag in vtarrp1a.p (converter v1.00) Mon Oct 06 14:18:54 1997      */
/*F0PN*/ /*K0VM*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=Report                                                  */
/* REVISION: 5.0      LAST MODIFIED: 08/11/89   BY: MLB *EU004*          */
/* REVISION: 5.0      LAST MODIFIED: 08/22/89   BY: MLB *EU005*          */
/* REVISION: 5.0      LAST MODIFIED: 10/16/89   BY: MLB *EU010*          */
/* REVISION: 6.0      LAST MODIFIED: 11/15/90   BY: MLB *D170*           */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*           */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*           */
/*                                   03/07/94   BY: bcm *FM75*           */
/*                                   03/01/95   BY: str *F0L1*           */
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6*           */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: bvm *K0VM*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: EMS *L00S*           */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey     */
/*************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE vtarrp1a_p_1 "增值税金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtarrp1a_p_2 "应纳税金额"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}

         define shared variable cust like ar_cust.
         define shared variable cust1 like ar_cust.
         define shared variable nbr like ar_nbr.
         define shared variable nbr1 like ar_nbr.
         define shared variable batch like ar_batch.
         define shared variable batch1 like ar_batch.
         define shared variable ardate like ar_date.
         define shared variable ardate1 like ar_date.
         define shared variable effdate like ar_effdate.
         define shared variable effdate1 like ar_effdate.
         define shared variable taxdate like ar_effdate.
         define shared variable taxdate1 like ar_effdate.
         define variable disc_pct like ar_amt decimals 10.
         define shared variable base_rpt like ar_curr.
         define shared variable tot_base_amt like ar_amt.
         define shared variable tot_vat_amt like ar_amt.
         define variable base_amt like ar_amt.
         define variable disp_curr as character format "x(1)".
         define buffer armstr for ar_mstr.
         define buffer arddet for ard_det.
         define shared variable vt_recno as recid.
         define buffer vtmstr for vt_mstr.
         define shared workfile vtw_wkfl
            field vtw_class like vt_class format "x(1)"
            field vtw_start like vt_start
            field vtw_amt   like ar_amt          label {&vtarrp1a_p_1}.

         define variable base_vat like ar_amt label {&vtarrp1a_p_1}.
         define variable base_tot_amt like base_amt label {&vtarrp1a_p_2}.
         define variable vat_pct like vt_tax_pct.

/*L02S*/ define     shared variable mc_rpt_curr like gl_base_curr no-undo.

/*L00S - BEGIN DELETE */
/*       {vtarrp1a.i} */
/*L00S - END DELETE   */

/*L00S - BEGIN ADD*/
         {xxvtaret1a.i}
/*L00S - END ADD*/

         {wbrp04.i}
