/* GUI CONVERTED from mfsotrla.i (converter v1.69) Sat Mar 30 01:16:29 1996 */
/* mfsotrla.i - SALES ORDER TRAILER DEFINE VARIABLES                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G0XY*/ /*V8:ConvertMode=ReportAndMaintenance                          */
/* REVISION: 5.0      LAST MODIFIED: 10/10/89   BY: MLB    */
/* REVISION: 6.0      LAST MODIFIED: 08/18/90   BY; MLB *D055* */
/* REVISION: 6.0      LAST MODIFIED: 12/12/90   BY: MLB *D238* */
/* REVISION: 7.0      LAST MODIFIED: 03/03/92   BY: tjs *F247* */
/* REVISION: 7.0      LAST MODIFIED: 03/19/92   BY: TMD *F263* */
/* REVISION: 7.0      LAST MODIFIED: 03/26/92   BY: dld *F297* */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367* */
/* REVISION: 7.0      LAST MODIFIED: 04/20/92   BY: tjs *F371* */
/* REVISION: 7.3      LAST MODIFIED: 08/24/92   BY: tjs *G033* */
/* REVISION: 7.4      LAST MODIFIED: 08/18/93   BY: pcd *H009* */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: bcm *H127**/
/* REVISION: 7.4      LAST MODIFIED: 10/26/93   BY: bcm *H194**/
/*                                   03/07/94   BY: bcm *FM68**/
/*                                   08/10/94   BY: rxm *FP61**/
/*                                   10/20/95   BY: jym *G0XY**/
/* REVISION: 8.5      LAST MODIFIED: 07/17/95   BY: taf *J053**/
/*J053* INDENTED ENTIRE PROGRAM TO BRING UP TO STANDARD */
/*H009*/ /* REVISED CODE BEGIN */

	 define {1} shared variable taxable_amt as decimal
		format "->>>>,>>>,>>9.99" label "应纳税".
	 define {1} shared variable nontaxable_amt like taxable_amt
		label "非应纳税".
	 define {1} shared variable line_total as decimal
		format "-zzzz,zzz,zz9.99" label "项目合计".
	 define {1} shared variable disc_amt like line_total label "折扣"
		format "(zzzz,zzz,zz9.99)".
	 define {1} shared variable tax_amt   like line_total label "税款合计".
	 define {1} shared variable ord_amt like line_total label " 合计".
	 define {1} shared variable tot_line_comm as decimal
		format "->>>>,>>>,>>9.99<<<<" extent 4.
	 define {1} shared variable amt like line_total extent 3
		format "-zzzzzzzzz9.99" label "金额".
	 define {1} shared variable tax like amt label "税" extent 3.
	 define {1} shared variable vtclass as character extent 3
		format "x(1)" label "增值税".
	 define {1} shared variable invcrdt as character format "x(15)".
	 define {1} shared variable vat_label as character format "x(3)".
	 define {1} shared variable user_desc like trl_desc extent 3.
	 define variable i as integer.
	 define {1} shared variable line_pst as decimal
		format "->>>>,>>>,>>9.99" label "PST".
	 define {1} shared variable trail_pst as decimal
		format "->>>>,>>>,>>9.99".
	 define {1} shared variable total_pst like line_total label "PST 合计".
	 define {1} shared variable maint like mfc_logical.
	 define {1} shared frame sotrail.
	 define {1} shared frame cttrail.
	 define {1} shared variable pst_taxed like mfc_logical.
	 define {1} shared variable gst_taxed like mfc_logical.
	 define {1} shared variable pst_on_gst like mfc_logical.
	 define {1} shared variable line_taxable_amt as decimal
		format "->>>>,>>>,>>9.99".
	 define {1} shared variable tax_date like so_tax_date.
/*J053*/ define {1} shared variable tax_edit like mfc_logical initial false.
/*J053*/ define {1} shared variable tax_edit_lbl like mfc_char format "x(28)"
/*J053*/     initial "          查看/编辑纳税明细:".

	 find first gl_ctrl no-lock.
	 find first soc_ctrl no-lock.
/*H127*/ define variable term-disc like ct_disc_pct.

/*FM68** /*H194*/ {vtmfcfld.i} **/

/*J053*/ {socurvar.i {1} }
/*J053*/ {txcurvar.i {1} }

/*J053*/ /* WHEN THE VARIABLES ARE NEW THE FORMATS ARE NOT AVAIALABLE */
/*J053*/ if (string("{1}") <> "NEW") then do:
	    if gl_can then do:
	       {cttrlfrm.i}
	    end.
/*J053*/    else if {txnew.i} then do:
/*J053*/       {sototfrm.i}
/*J053*/    end.
            else do:
	       {sotrlfrm.i}
	    end.
/*J053*/ end. /* IF (STRING("{1}") <> "NEW") */

/*H009*/ /* REVISED CODE END */




/*H009*  REPLACED CODE BEGIN ***
*
*define new shared variable taxable_amt as decimal
* format "->>>>,>>>,>>9.99" label "Taxable".
*define new shared variable nontaxable_amt like taxable_amt
* label "Non-Taxable".
*define new shared variable line_total as decimal
* format "-zzzz,zzz,zz9.99" label "Line Total".
*define new shared variable disc_amt like line_total label "Discount"
* format "(zzzz,zzz,zz9.99)".
*define new shared variable tax_amt   like line_total label "Total Tax".
*define new shared variable ord_amt like line_total label "Total".
*define new shared variable tot_line_comm as decimal
* /*F297 format "->>>>,>>>,>>9.99<<<<" extent 2. */
* /*F297*/ format "->>>>,>>>,>>9.99<<<<" extent 4.
*define new shared variable amt like line_total extent 3
* format "-zzzzzzzzz9.99" label "Amt".
*define new shared variable tax like amt label "Tax" extent 3.
*define new shared variable vtclass as character extent 3
* format "x(1)" label "VAT".
*define new shared variable invcrdt as character format "x(15)".
*define new shared variable vat_label as character format "x(3)".
*define new shared variable user_desc like trl_desc extent 3.
*define variable i as integer.
* /*F367*  define new shared variable line_pst like sod_price label "PST". */
* /*F367*/ define new shared variable line_pst as decimal
* /*F367*/    format "->>>>,>>>,>>9.99" label "PST".
* /*F367*  define new shared variable trail_pst like sod_price. */
* /*F367*/ define new shared variable trail_pst as decimal
* /*F367*/    format "->>>>,>>>,>>9.99".
*define new shared variable total_pst like line_total label "Total PST".
*define new shared variable maint like mfc_logical.
*define new shared frame sotrail.
*define new shared frame cttrail.
*define new shared variable pst_taxed like mfc_logical.
*define new shared variable gst_taxed like mfc_logical.
*define new shared variable pst_on_gst like mfc_logical.
* /*F367*  /*F247*/ define new shared variable line_taxable_amt like sod_price. */
* /*F367*/ /*F247*/ define new shared variable line_taxable_amt as decimal
* /*F367*/             format "->>>>,>>>,>>9.99".
* /*F263*/ define new shared variable tax_date like so_tax_date.
* /*G033*  define new shared variable soc_margin like mfc_logical. */
* /*G033*  define new shared variable soc_marginx as character format "x(3)". */
*find first gl_ctrl no-lock.
* /*G033*/ find first soc_ctrl no-lock.
*
*if gl_can then do:
*   {cttrlfrm.i}
*end.
*else do:
*   {sotrlfrm.i}
*end.
*
* *H009* REPLACED CODE END *** */
