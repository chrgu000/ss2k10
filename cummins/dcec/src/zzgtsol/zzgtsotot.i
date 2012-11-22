/* GUI CONVERTED from sorp1001.p (converter v1.69) Tue Aug 19 06:21:44 1997 */
/* sorp1001.p - SALES ORDER INVOICE PRINT FOR ENGLISH PRINT CODE "1"    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: MLB *B615*          */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb      *          */
/* REVISION: 6.0      LAST MODIFIED: 07/05/90   BY: WUG *D043*          */
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755*          */
/* REVISION: 6.0      LAST MODIFIED: 08/20/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257*          */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: MLB *D238*          */
/* REVISION: 6.0      LAST MODIFIED: 01/04/90   BY: WUG *D288*          */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*          */
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903*          */
/* REVISION: 6.0      LAST MODIFIED: 11/26/91   BY: WUG *D953*          */
/* REVISION: 7.0      LAST MODIFIED: 11/29/91   BY: SAS *F017*          */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: tjs *F191*          */
/* REVISION: 7.0      LAST MODIFIED: 03/28/92   BY: dld *F322*          */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: sas *F277*          */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F348*          */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369*          */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: sas *F378*          */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: tjs *F504*          */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*          */
/* REVISION: 7.3      LAST MODIFIED: 12/03/92   BY: afs *G341*          */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   by: jms *G712*          */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: tjs *G858*          */
/* REVISION: 7.4      LAST MODIFIED: 07/15/93   BY: jjs *H050*          */
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009*          */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: cdt *H197*          */
/* REVISION: 7.4      LAST MODIFIED: 05/03/94   BY: cdt *FN91*          */
/* REVISION: 7.4      LAST MODIFIED: 06/03/94   BY: dpm *GK02*          */
/* REVISION: 7.4      LAST MODIFIED: 10/05/94   BY: rxm *GM88*          */
/* REVISION: 7.4      LAST MODIFIED: 11/18/94   BY: smp *FT80*          */
/* REVISION: 7.4      LAST MODIFIED: 11/30/94   BY: smp *GO65*          */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: kjm *F0MY*          */
/* REVISION: 7.4      LAST MODIFIED: 03/24/95   BY: kjm *F0NZ*          */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: nte *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: jym *G0ND*          */
/* REVISION: 7.4      LAST MODIFIED: 07/19/95   BY: bcm *F0RW*          */
/* REVISION: 7.4      LAST MODIFIED: 10/13/95   BY: rxm *G0Z9*          */
/* REVISION: 7.4      LAST MODIFIED: 10/20/95   BY: jym *G0XY*          */
/* REVISION: 8.5      LAST MODIFIED: 07/25/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/96   BY: ais *G1J5*          */
/* REVISION: 8.5      LAST MODIFIED: 02/05/96   BY: ais *G0NX*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: GWM *J0HW*          */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: ais *G1QW*          */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: *J0T0* Dennis Hensen*/
/* REVISION: 8.5      LAST MODIFIED: 06/26/96   BY: *J0WF* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *J0ZZ* T. Farnsworth*/
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G29K* Markus Barone*/
/* REVISION: 8.5      LAST MODIFIED: 11/14/96   BY: *G2J1* Amy Esau     */
/* REVISION: 8.5      LAST MODIFIED: 07/22/97   BY: *H1C9* Seema Varma  */
/* REVISION: 8.5      LAST MODIFIED: 08/19/97   BY: *J1Z0* Ajit Deodhar */



/*G0ND*/ {mfdeclre.i}
         {gplabel.i}

 define  variable mc-error-number as int no-undo .
/*G0XY*/ define new shared variable convertmode as character no-undo
/*J1Z0**                            initial "REPORT".*/
/*J1Z0*/                            initial "report".
/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*G047** define new shared variable first_line like mfc_logical. **/
/*G047*/ define new shared variable old_sod_nbr like sod_nbr.
         define new shared variable pages as integer.
         define new shared variable so_recno as recid.
         define new shared variable billto as character format "x(38)" extent 6.
         define new shared variable soldto as character format "x(38)" extent 6.
/*G047*/ define new shared variable print_invoice  like mfc_logical.
/*G047*/ define new shared variable rmaso          like mfc_logical.
/*G047*/ define new shared variable sacontract     like mfc_logical.
/*G047*/ define new shared variable fsremarks as character format "x(60)".
/*G047*/ define new shared variable ext_actual like sod_price.
/*G047*/ define new shared variable ext_margin like sod_price.
/*G047*/ define new shared variable comb_inv_nbr like so_inv_nbr.
/*H050*/ define new shared variable consolidate like mfc_logical initial true.
/*J053* /*H050*/ define new shared variable tax_edit_lbl like mfc_char format "x(28)". */
/*J053* /*H050*/ define new shared variable tax_edit like mfc_logical. */
/*H050*/ define new shared variable undo_trl2 like mfc_logical.
/*H050*/ define new shared variable undo_txdetrp like mfc_logical.
/*G858*/ define new shared variable new_order like mfc_logical.

/*G047*/ define shared variable cust  like ih_cust.
/*G047*/ define shared variable cust1 like ih_cust.
/*G047*/ define shared variable bill  like ih_bill.
/*G047*/ define shared variable bill1 like ih_bill.
/*G047*/ define shared variable conso like mfc_logical
/*G047*/  label "合并发票".
         define shared variable gst_id like so_fst_id.
         define shared variable nbr like so_nbr.
         define shared variable nbr1 like so_nbr.
         define shared variable inv_only like mfc_logical
          label "只打印要开发票的项目".
         define shared variable print_lotserials like mfc_logical initial no
          label "打印发运零件的批/序号".
         define shared variable msg like msg_desc.
         define shared variable inv_date like so_inv_date.
         define shared variable company as character format "x(38)" extent 6.
         define shared variable shipdate like so_ship_date.
         define shared variable shipdate1 like shipdate.
         define shared variable addr as character format "x(38)" extent 6.
         define shared variable print_options like mfc_logical initial no label
          "打印特性与选项".
         define shared variable lang like so_lang.
         define shared variable lang1 like lang.
/*F348*/ define shared variable next_inv_nbr like soc_inv.
/*J04C*/ define shared variable call-detail  like mfc_logical
/*J04C*/        label "打印电话发票明细".

         define variable comp_addr like soc_company.
         define variable termsdesc like ct_desc.
         define variable prepaid-lbl as character format "x(12)".
         define variable po-lbl as character format "x(8)".
         define variable lot-lbl as character format "x(43)".
         define variable cspart-lbl as character format "x(15)".
         define variable resale like cm_resale format "x(20)".
/*F348*/ define variable trl_length as integer initial 11.
/*F348*/ define variable hdr_po as character format "x(38)".
/*F348*/ define variable po-lbl2 as character format "x(16)".
/*G047*/ define variable sales_entity like si_entity.
/*H050*/ define variable col-80 like mfc_logical initial true.
define variable gst_rate like vt_tax_pct.
define variable ext_price like sod_price.
define variable actual_price like sod_price.
define variable gst like sod_price.
define variable disc_pct like so_disc_pct.

/*J042*/ {sodiscwk.i &new="new"} /* Shared workfile for summary discounts */


/*F348*/ define buffer somstr for so_mstr.
/*G047*/ define buffer somstr2 for so_mstr.
/*J053*/ define new shared frame sotot.

/*GK02*  {soivtot1.i}  /* Define variables for invoice totals. */ */
/*GK02*/ {soivtot1.i "NEW"}  /* Define variables for invoice totals. */
/*H009*/ {mfsotrla.i "NEW"}

/*H197*/ define shared variable incinv like mfc_logical initial yes
/*H197*/    label "包括发票".
/*H197*/ define shared variable incmemo like mfc_logical initial yes
/*H197*/    label "包括付款通知单".

/*FT80*/ define variable hdr_call as character format "x(21)".
/*FT80*/ define variable call-lbl as character format "x(16)".
/*J053*/ define variable prepaid_fmt as character no-undo.
/*J053*/ define variable prepaid_old as character no-undo.
/*J053*/ define variable oldsession as character no-undo.
/*J053*/ define variable oldcurr like so_curr no-undo.
/*G1J5*/ define variable tot_prepaid_amt like so_prepaid.
/*J0T0*/ define new shared variable disc_prnt_label as character format "x(8)".
/*J0T0*/ define            variable hdl_sum_disc_lbl as handle.
/*J0WF*/ define            variable tax-tran-type   as  character no-undo.


/*J053  /*H050*/    {sototfrm.i} */

         {so10a01.i}
         {so10c01.i}
/*J04C {fsconst.i}   */   /* FIELD SERVICE CONSTANTS */

/*F017*/ find first sac_ctrl where sac_ctrl.sac_domain = global_domain  no-lock no-error.
/*F277*/ find first rmc_ctrl where rmc_ctrl.rmc_domain = global_domain  no-lock no-error.
/*F277*/ find first svc_ctrl where svc_ctrl.svc_domain = global_domain  no-lock no-error.

/*G712*/ /* DEFINE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
/*G712*/ {gpvtecdf.i &var="shared"}
/*G712*/ {gpvtepdf.i &var=" "}


				maint = no.
			
				old_sod_nbr = ?.


/*G047*/    	{soivtot2.i}  /* Initialize variables for invoice totals. */

				find first so_mstr no-lock where so_mstr.so_domain = global_domain and so_nbr = v_so_nbr no-error.
				if not available so_mstr then return.
				find first gl_ctrl no-lock where gl_ctrl.gl_domain = global_domain .				
/*J0ZZ*/       {gpcurmth.i
				"so_curr"
				"4"
				"old_sod_nbr = ?"
				"old_sod_nbr = ?" }

		
/*H197*/       so_recno = recid(so_mstr).

							
				if gl_vat or gl_can then find first vtc_ctrl no-lock .
				find first soc_ctrl no-lock where soc_ctrl.soc_domain = global_domain.
				
				find so_mstr where recid(so_mstr) = so_recno no-lock.
				
				/* Calculate totals and taxes for trailer */
				if so_tax_date = ? then tax_date = so_ship_date.
				else tax_date = so_tax_date.
				{mfsotrl.i &qty="sod_qty_inv" &vatdate="tax_date"}
