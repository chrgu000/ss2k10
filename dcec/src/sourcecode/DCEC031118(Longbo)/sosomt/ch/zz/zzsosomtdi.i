/* GUI CONVERTED from sosomtdi.i (converter v1.69) Tue Oct 29 15:25:33 1996 */
/* sosomtdi.i - Sales Order Maintenance Display header frame b               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/* REVISION: 7.3      LAST MODIFIED: 09/14/92   BY: tjs *G035*               */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: cdt *H086*               */
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: cdt *H184*               */
/* REVISION: 7.4      LAST MODIFIED: 06/29/94   BY: qzl *H419*               */
/* REVISION: 7.5      LAST MODIFIED: 03/10/95   BY: DAH *J042*               */
/* REVISION: 8.5      LAST MODIFIED: 10/02/96   BY: *J15C* Markus Barone     */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

	 if new_order then
/*J15C*     socmmts = soc_hcmmts.  */
/*J15C*/    socmmts = if this-is-rma
/*J15C*/                 then rmc_hcmmts
/*J15C*/                 else soc_hcmmts.
	 else
	    socmmts = (so_cmtindx <> 0).
/*H419*/ if not new_order then socrt_int = so__qad02.

/*H086*/ /* Rearranged frame b, new format follows. */

	 display
	 so_ord_date
/*J042** so_pr_list2 **/
/*J042*/ line_pricing
	 confirm
	 so_conf_date
	 so_req_date
	 so_pr_list
	 so_curr
	 so_lang
	 promise_date
	 so_site
	 so_taxable
	 so_taxc
	 so_tax_date
	 so_due_date
	 so_channel
	 so_fix_pr
/*J042*/ so_pricing_dt
	 so_project
	 so_cr_terms
	 so_po
/*H184*/ socrt_int
	 so_rmks
/*J042*/ reprice
/*LB01*/ so_userid
	 with frame b.
