/* GUI CONVERTED from ctaprp1a.p (converter v1.71) Tue Oct  6 14:18:00 1998 */
/* ctaprp1a.p - AP GST BY GST CLASS REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ctaprp1a.p (converter v1.00) Fri Oct 10 13:57:30 1997 */
/* web tag in ctaprp1a.p (converter v1.00) Mon Oct 06 14:18:01 1997 */
/*F0PN*/ /*K0WM*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*          */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*          */
/*           7.0      LAST MODIFIED: 03/01/95   BY: str *F0L1*          */
/*           7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1LD*          */
/* REVISION  8.6      LAST MODIFIED: 10/13/97   BY: gyk *K0WM*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

      {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ctaprp1a_p_1 "GST %"
/* MaxLen: Comment: */

&SCOPED-DEFINE ctaprp1a_p_2 "GST 金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE ctaprp1a_p_3 "GST: "
/* MaxLen: Comment: */

&SCOPED-DEFINE ctaprp1a_p_4 "应纳税金额"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K0WM*/ {wbrp02.i}


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
/*G1LD*   define shared variable base_rpt as char label "Currency" initial */
/*G1LD*   "Base" format "x(4)". */
/*G1LD*/  define shared variable base_rpt like ap_curr.
      define variable base_amt like ap_amt.
      define variable disp_curr as character format "x(1)" label "C".
      define buffer apmstr for ap_mstr.
/*F0L1*   define var disc_pct like ap_amt. */
/*F0L1*/  define variable disc_pct like ap_amt decimals 10.
      define shared variable vt_recno as recid.

      define variable base_vat like ap_amt label {&ctaprp1a_p_2}.
      define variable vat_pct like vt_tax_pct label {&ctaprp1a_p_1}.
/*F357*   define variable base_tot_amt like base_amt label "Total Amt". */
/*F357*/  define variable base_tot_amt like base_amt label {&ctaprp1a_p_4}.

/*D238*/  define shared variable vat_label as character format "x(5)".
/*D238*/  vat_label = {&ctaprp1a_p_3}.
      define shared workfile vtw_wkfl
         field vtw_class like vt_class format "x(1)"
         field vtw_start like vt_start
         field vtw_amt   like ar_amt.


      /*D238*/
      {xxvtaprp1a(ls).i}
/*K0WM*/ {wbrp04.i}
