/* GUI CONVERTED from poporcb4.p (converter v1.69) Sat Mar 30 01:18:28 1996 */
/* poporcb4.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.4           CREATED:  11/04/93    BY: bcm *H210**/
/* REVISION: 7.4           MODIFIED: 11/04/93    BY: cdt *H184**/
/*           7.4                     10/29/94    BY: bcm *GN73**/

	 {mfdeclre.i} /*GUI moved to top.*/
	 define shared variable trqty like tr_qty_chg.
	 define
	    shared
	    variable qty_ord like pod_qty_ord.
	 define variable trnbr like op_trnbr.
	 define shared variable stdcst like tr_price.
	 define
	    shared
	    variable old_status like pod_status.
	 define shared variable ref like glt_ref.
	 define shared variable eff_date like glt_effdate.
	 define shared variable po_recno as recid.
	 define shared variable qopen like pod_qty_rcvd label "∂Ã»±¡ø".
	 define shared variable ps_nbr like prh_ps_nbr.
	 define shared variable base_amt like pod_pur_cost.
	 define shared variable move like mfc_logical.
	 define shared variable receivernbr like prh_receiver.
	 define shared variable site like sod_site.
	 define shared variable location like sod_loc.
	 define shared variable lotser like sod_serial.
	 define shared variable lotref like sr_ref.
	 define variable conv_to_stk_um as decimal.

	 /*F003 ADDED 'EXTENT 6' TO THE FOLLOWING:  */
	 define shared variable gl_amt like trgl_gl_amt extent 6.
	 define shared variable dr_acct like trgl_dr_acct extent 6.
	 define shared variable dr_cc like trgl_dr_cc extent 6.
	 define shared variable dr_proj like trgl_dr_proj extent 6.
	 define shared variable cr_acct like trgl_cr_acct extent 6.
	 define shared variable cr_cc like trgl_cr_cc extent 6.
	 define shared variable cr_proj like trgl_cr_proj extent 6.

	 define shared variable price like tr_price.
	 define shared variable qty_oh like in_qty_oh.
	 define shared variable openqty like mrp_qty.
	 define shared variable rcv_type like poc_rcv_type.
	 define shared variable pod_recno as recid.
	 define shared variable wr_recno as recid.
	 define shared variable exch_rate like exd_rate.
	 define shared variable wolot like pod_wo_lot no-undo.
	 define shared variable woop like pod_op no-undo.
	 define variable i as integer.
	 define shared variable entity like si_entity extent 6.
	 define variable pod_entity like si_entity.
	 define variable pod_po_entity like si_entity.
	 define shared variable project like prh_project.
	 define shared variable sct_recno as recid.
	 define shared variable rct_site like pod_site.
	 define variable poddb like pod_po_db.
	 define variable podpodb like pod_po_db.
	 define shared variable new_db like si_db.
	 define shared variable old_db like si_db.
	 define shared variable new_site like si_site.
	 define shared variable old_site like si_site.
	 define shared stream hs_prh.
	 define shared frame hf_prh_hist.
	 define buffer poddet for pod_det.
	 define shared variable yes_char as character format "x(1)".
	 define shared variable porec like mfc_logical no-undo.
	 define shared variable undo_all like mfc_logical no-undo.
	 define shared variable transtype as character
		format "x(7)" initial "ISS-TR".
	 define variable newmtl_tl as decimal.
	 define variable newlbr_tl as decimal.
	 define variable newbdn_tl as decimal.
	 define variable newovh_tl as decimal.
	 define variable newsub_tl as decimal.
	 define variable newmtl_ll as decimal.
	 define variable newlbr_ll as decimal.
	 define variable newbdn_ll as decimal.
	 define variable newovh_ll as decimal.
	 define variable newsub_ll as decimal.
	 define variable newcst as decimal.
	 define shared variable glx_mthd like cs_method.
	 define variable glx_set like cs_set.
	 define variable cur_mthd like cs_method.
	 define variable cur_set like cs_set.
	 define variable reavg_yn like mfc_logical.
	 define variable qty_chg like tr_qty_loc.
	 define variable curr_yn like mfc_logical.
	 define shared variable msgref like tr_msg.
	 define variable line_tax like trgl_gl_amt.
	 define shared variable crtint_amt like trgl_gl_amt.
	 define shared variable poc_crtacc_acct like gl_crterms_acct.
	 define shared variable poc_crtacc_cc   like gl_crterms_cc.
	 define shared variable poc_crtapp_acct like gl_crterms_acct.
	 define shared variable poc_crtapp_cc   like gl_crterms_cc.

/*GUI moved mfdeclre/mfdtitle.*/

	 FORM /*GUI*/  prh_hist with frame hf_prh_hist THREE-D /*GUI*/.


	 find first gl_ctrl no-lock.
	 find po_mstr where recid(po_mstr) = po_recno.
	 find pod_det where recid(pod_det) = pod_recno.
	 find first poc_ctrl no-lock no-error.
	 rcv_type = poc_rcv_type.
	 find first gl_ctrl no-lock.

	 /* POST THE CREDIT TERMS INTEREST COMPONENT OF THE ITEM PRICE */
	 /* TO A STATISCAL ACCCOUNT FOR THE PO RECEIPT.                */
	 if crtint_amt <> 0 then do:

	    /* GET ACCOUNTS FROM MFC_CTRL */
	    find first mfc_ctrl where mfc_field = "poc_crtacc_acct"
	    no-lock no-error.
	    if available mfc_ctrl and mfc_char <> "" then do:
	       poc_crtacc_acct =  mfc_char.
	       find first mfc_ctrl where mfc_field = "poc_crtacc_cc"
	       no-lock no-error.
	       if available mfc_ctrl and mfc_char <> "" then
		  poc_crtacc_cc =  mfc_char.
	       find first mfc_ctrl where mfc_field = "poc_crtapp_acct"
	       no-lock no-error.
	       if available mfc_ctrl and mfc_char <> "" then do:
		  poc_crtapp_acct =  mfc_char.
		  find first mfc_ctrl where mfc_field = "poc_crtapp_cc"
		  no-lock no-error.
		  if available mfc_ctrl and mfc_char <> "" then
		     poc_crtapp_cc =  mfc_char.
/*GN73* Added same-ref */
/*H184*/          {mficgl02.i
		     &gl-amount=crtint_amt
		     &tran-type=""RCT-PO""
		     &order-no=pod_nbr
		     &dr-acct=poc_crtapp_acct
		     &dr-cc=poc_crtapp_cc
		     &drproj=pod_proj
		     &cr-acct=poc_crtacc_acct
		     &cr-cc=poc_crtacc_cc
		     &crproj=pod_proj
		     &entity=pod_entity
		     &find="true"
		     &same-ref="icc_gl_sum"
		  }
	       end.
	    end.
	 end.
	 if not po_sched then do:
	    close-po:
	    do transaction on error undo, leave:
	       if po_stat <> "c" then do:
		  for each pod_det where pod_nbr = po_nbr:
		     if pod_status <> "c" and pod_status <> "x" then
			leave close-po.
		  end.
		  po_stat = "c".
		  po_cls_date = today.
	       end.
	    end.
	 end.
