/* GUI CONVERTED from sotrlfrm.i (converter v1.69) Mon Aug 12 14:35:42 1996 */
/* sotrlfrm.i - DEFINE FORM REGULAR SALES ORDER TRAILER INCLUDE FILE    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G0XY*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755*          */
/* REVISION: 7.0      LAST MODIFIED: 03/19/92   BY: TMD *F263*          */
/* REVISION: 7.2      LAST MODIFIED: 08/02/94   BY: RXM *FP61*          */
/* REVISION: 7.2      LAST MODIFIED: 09/10/94   BY: bcm *FQ96*          */
/* REVISION: 7.3      LAST MODIFIED: 10/20/95   BY: jym *G0XY*          */
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *G1ZR* Suresh Nayak */

/*G1ZR*/      {sotrlfra.i}
/*G1ZR** FOLLOWING SECTION INCLUDED IN sotrlfra.i
 *    form
 *    nontaxable_amt colon 12
 * /*F263*/ so_mstr.so_curr
 *    line_total   colon 60 no-attr-space
 *    taxable_amt colon 12
 *    so_mstr.so_disc_pct to 49 no-label   disc_amt     colon 60 no-attr-space
 * /*F263*/ tax_date     colon 12
 *    user_desc[1] to 53 no-label so_mstr.so_trl1_cd to 58 no-label
 *				":" at 60 so_mstr.so_trl1_amt no-label
 *    user_desc[2] to 53 no-label so_mstr.so_trl2_cd to 58 no-label
 *				":" at 60 so_mstr.so_trl2_amt no-label
 * /*FQ96*/ invcrdt no-label at 2
 * /*FQ96** invcrdt no-label **/
 *    user_desc[3] to 53 no-label so_mstr.so_trl3_cd to 58 no-label
 *				":" at 60 so_mstr.so_trl3_amt no-label
 *
 * /*FP61   vtclass[1] no-label to 4                               */
 * /*FP61   so_mstr.so_tax_pct[1] no-label format "-zz9.99%" to 15 */
 * /*FP61   vtclass[2] no-label to 20                              */
 * /*FP61   so_mstr.so_tax_pct[2] no-label format "-zz9.99%" to 30 */
 * /*FP61   vtclass[3] no-label to 36                              */
 * /*FP61   so_mstr.so_tax_pct[3] no-label format "-zz9.99%" to 46 */
 *
 * /*FQ96** /*FP61*/ vtclass[1] no-label to 3 **/
 * /*FQ96*/ vtclass[1] no-label at 3
 * /*FP61*/ so_mstr.so_tax_pct[1] no-label format "-zz9.999%" to 14
 * /*FP61*/ vtclass[2] no-label to 19
 * /*FP61*/ so_mstr.so_tax_pct[2] no-label format "-zz9.999%" to 30
 * /*FP61*/ vtclass[3] no-label to 35
 * /*FP61*/ so_mstr.so_tax_pct[3] no-label format "-zz9.999%" to 46
 *					 tax_amt      colon 60 skip
 * /*FP61   amt[1] no-label to 15 no-attr-space                    */
 * /*FP61*/ amt[1] no-label to 14 no-attr-space
 *	 amt[2] no-label to 30 no-attr-space
 *	 amt[3] no-label to 46 no-attr-space
 *					ord_amt      colon 60
 * /*FP61   tax[1] no-label to 15 no-attr-space                    */
 * /*FP61*/ tax[1] no-label to 14 no-attr-space
 *	 tax[2] no-label to 30 no-attr-space
 *	 tax[3] no-label to 46 no-attr-space
 *     with frame sotrail side-labels width 80 attr-space.
 *G1ZR */

/*J053*/ /* SET CURRENCY DEPENDENT FORMATS */
/*J053*/ assign
/*J053*/    nontaxable_amt:format in frame sotrail = nontax_fmt
/*J053*/    line_total:format in frame sotrail = line_tot_fmt
/*J053*/    taxable_amt:format in frame sotrail = taxable_fmt
/*J053*/    disc_amt:format in frame sotrail = disc_fmt
/*J053*/    so_trl1_amt:format in frame sotrail = trl_amt_fmt
/*J053*/    so_trl2_amt:format in frame sotrail = trl_amt_fmt
/*J053*/    so_trl3_amt:format in frame sotrail = trl_amt_fmt
/*
/*J053*/    tax_amt:format in frame sotrail = tax_amt_fmt

/*J053*/    amt[1]:format in frame sotrail = amt_fmt
/*J053*/    amt[2]:format in frame sotrail = amt_fmt
/*J053*/    amt[3]:format in frame sotrail = amt_fmt*/
/*J053*/    ord_amt:format in frame sotrail = ord_amt_fmt
/*
/*J053*/    tax[1]:format in frame sotrail = tax_fmt
/*J053*/    tax[2]:format in frame sotrail = tax_fmt
/*J053*/    tax[3]:format in frame sotrail = tax_fmt*/.

