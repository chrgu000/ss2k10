/* GUI CONVERTED from ctarrp1a.p (converter v1.71) Tue Oct  6 14:18:01 1998 */
/* ctarrp1a.p - SUBPROGRAM TO AR-GST REPORT BY VAT CLASS                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ctarrp1a.p (converter v1.00) Fri Oct 10 13:57:30 1997 */
/* web tag in ctarrp1a.p (converter v1.00) Mon Oct 06 14:18:01 1997 */
/*F0PN*/ /*K0VM*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 5.0      LAST MODIFIED: 08/11/89   BY: MLB *EU004*         */
/* REVISION: 5.0      LAST MODIFIED: 08/22/89   BY: MLB *EU005*         */
/* REVISION: 5.0      LAST MODIFIED: 10/16/89   BY: MLB *EU010*         */
/* REVISION: 6.0      LAST MODIFIED: 11/15/90   BY: MLB *D170*          */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*          */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*          */
/* REVISION: 7.0      LAST MODIFIED: 03/01/95   BY: str *F0L1*          */
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6*          */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: bvm *K0VM*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

      {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ctarrp1a_p_1 "GST %"
/* MaxLen: Comment: */

&SCOPED-DEFINE ctarrp1a_p_2 "GST 金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE ctarrp1a_p_3 "应纳税金额"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K0VM*/ {wbrp02.i}


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
/*F357*/  define shared variable taxdate like ar_tax_date.
/*F357*/  define shared variable taxdate1 like ar_tax_date.
/*F0L1*   define variable disc_pct like ar_amt. */
/*F0L1*/  define variable disc_pct like ar_amt decimals 10.
/*G1P6*   define shared variable base_rpt as char label "Currency" */
/*G1P6*      initial "Base" format "x(4)". */
/*G1P6*/  define shared variable base_rpt like ar_curr.
      define shared variable tot_base_amt like ar_amt.
      define shared variable tot_vat_amt like ar_amt.
      define variable base_amt like ar_amt.
/*G1P6*   define variable disp_curr like base_rpt label "Curr". */
/*G1P6*/  define variable disp_curr as character format "x(1)".
      define buffer armstr for ar_mstr.
      define buffer arddet for ard_det.
      define shared variable vt_recno as recid.
      define buffer vtmstr for vt_mstr.
      define shared workfile vtw_wkfl
         field vtw_class like vt_class format "x(1)"
         field vtw_start like vt_start
         field vtw_amt   like ar_amt.

      define variable base_vat like ar_amt label {&ctarrp1a_p_2}.
/*F357*   define variable base_tot_amt like base_amt label "Total Amt". */
/*F357*/  define variable base_tot_amt like base_amt label {&ctarrp1a_p_3}.
      define variable vat_pct like vt_tax_pct label {&ctarrp1a_p_1}.

      /*D238*/
      {xxvtarrp1a.i}
/*K0VM*/ {wbrp04.i}
