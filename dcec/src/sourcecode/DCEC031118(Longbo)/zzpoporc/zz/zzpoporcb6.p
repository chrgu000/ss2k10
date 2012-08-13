/* GUI CONVERTED from poporcb6.p (converter v1.69) Tue Apr 29 19:31:00 1997 */
/* poporcb6.p - PURCHASE ORDER RECEIPT W/ SERIAL NUMBER CONTROL         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.4     LAST MODIFIED: 03/25/94    BY: dpm *FM94**/
/* REVISION: 7.4     LAST MODIFIED: 04/12/94    BY: bcm *H336**/
/* REVISION: 7.4     LAST MODIFIED: 08/01/94    BY: dpm *H466**/
/* REVISION: 7.4     LAST MODIFIED: 09/26/94    BY: bcm *H539**/
/* REVISION: 7.4     LAST MODIFIED: 10/31/94    BY: ame *GN82**/
/* REVISION: 8.5     LAST MODIFIED: 10/31/94    BY: taf *J038**/
/* REVISION: 7.4     LAST MODIFIED: 11/17/94    BY: bcm *GO37**/
/* REVISION: 7.4     LAST MODIFIED: 02/16/95    BY: jxz *F0JC**/
/* REVISION: 7.4     LAST MODIFIED: 10/09/95    BY: ais *G0YP**/
/* REVISION: 7.4     LAST MODIFIED: 11/09/95    BY: jym *G1BR**/
/* REVISION: 8.5     LAST MODIFIED: 10/09/95    BY: taf *J053**/
/* REVISION: 7.4     LAST MODIFIED: 01/09/96    BY: emb *G1GX**/
/* REVISION: 7.4     LAST MODIFIED: 01/09/96    BY: ais *G1JL**/
/* REVISION: 8.5     LAST MODIFIED: 02/15/96    BY: tjs *J0CZ**/
/* REVISION: 8.5     LAST MODIFIED: 01/08/97    BY: *H0QF* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 03/04/97    BY: *H0SW* Robin McCarthy     */
/* REVISION: 8.5     LAST MODIFIED: 04/18/97    BY: *H0Y5* Aruna Patil   */
/* REVISION: 8.5     LAST MODIFIED: 04/24/97    BY: *H0YF* Aruna Patil   */
/* REVISION: 8.5     LAST MODIFIED: 11/28/03    BY: *LB01* Long Bo   */


/*GO37*/ {mfdeclre.i}
/*GO37*/ {porcdef.i}

/*J053*/ define shared variable rndmthd         like rnd_rnd_mthd.
/*J053*/ define variable glamt as decimal.
/*J053*/ define variable docamt as decimal.
/*J053*/ define variable tmp_amt as decimal.
/*H0Y5*/ define variable l_ro_routing like ro_routing no-undo.
/*GO37** MOVED COMMON SHARED VARIABLES TO porcdef.i **
 *       define shared variable base_amt        like pod_pur_cost.
 *       define shared variable eff_date        like glt_effdate.
 *       define shared variable exch_rate       like exd_rate.
 *       define shared variable location        like sod_loc.
 *       define shared variable lotref          like sr_ref.
 *       define shared variable move            like mfc_logical.
 *       define shared variable msgref          like tr_msg.
 *       define shared variable porec           like mfc_logical no-undo.
 *       define shared variable po_recno        as recid.
 *       define shared variable pod_recno       as recid.
 *       define shared variable ps_nbr          like prh_ps_nbr.
 *       define shared variable qopen           like pod_qty_rcvd
 *                                              label "Qty Open".
 *       define shared variable site            like sod_site.
 *       define shared variable ref             like glt_ref.
 *       define shared variable transtype       as character
 *                                              format "x(7)" initial "ISS-TR".
 *       define shared variable wolot           like pod_wo_lot no-undo.
 *       define shared variable woop            like pod_op no-undo.
*GO37** END MOVED **/

/*H0SW*/ define new shared variable totl_qty_this_rcpt like pod_qty_chg no-undo.
/*H0SW*/ define new shared variable last_sr_wkfl like mfc_logical no-undo.
/*H0SW*/ define new shared variable accum_taxamt like tx2d_tottax no-undo.

	 define shared variable trqty           like tr_qty_chg.
	 define shared variable qty_ord         like pod_qty_ord.
	 define shared variable stdcst          like tr_price.
	 define shared variable old_status      like pod_status.
	 define shared variable receivernbr     like prh_receiver.
	 define shared variable lotser          like sod_serial.
	 define shared variable conv_to_stk_um  as decimal.
	 define shared variable gl_amt          like trgl_gl_amt extent 6.
	 define shared variable dr_acct         like trgl_dr_acct extent 6.
	 define shared variable dr_cc           like trgl_dr_cc extent 6.
	 define shared variable dr_proj         like trgl_dr_proj extent 6.
	 define shared variable cr_acct         like trgl_cr_acct extent 6.
	 define shared variable cr_cc           like trgl_cr_cc extent 6.
	 define shared variable cr_proj         like trgl_cr_proj extent 6.
	 define shared variable price           like tr_price.
	 define shared variable qty_oh          like in_qty_oh.
	 define shared variable openqty         like mrp_qty.
	 define shared variable rcv_type        like poc_rcv_type.
	 define shared variable wr_recno        as recid.
	 define        variable i               as integer.
	 define shared variable entity          like si_entity extent 6.
	 define shared variable pod_entity      like si_entity.
	 define shared variable pod_po_entity   like si_entity.
	 define shared variable project         like prh_project.
	 define shared variable sct_recno       as recid.
	 define shared variable rct_site        like pod_site.
	 define shared variable poddb           like pod_po_db.
	 define shared variable podpodb         like pod_po_db.
	 define shared variable new_db          like si_db.
	 define shared variable old_db          like si_db.
	 define shared variable new_site        like si_site.
	 define shared variable old_site        like si_site.
	 define buffer poddet for pod_det.
	 define shared variable yes_char        as character format "x(1)".
	 define shared variable undo_all        like mfc_logical no-undo.
	 define shared variable newmtl_tl       as decimal.
	 define shared variable newlbr_tl       as decimal.
	 define shared variable newbdn_tl       as decimal.
	 define shared variable newovh_tl       as decimal.
	 define shared variable newsub_tl       as decimal.
	 define shared variable newmtl_ll       as decimal.
	 define shared variable newlbr_ll       as decimal.
	 define shared variable newbdn_ll       as decimal.
	 define shared variable newovh_ll       as decimal.
	 define shared variable newsub_ll       as decimal.
	 define shared variable newcst          as decimal.
	 define shared variable glx_mthd        like cs_method.
	 define shared variable reavg_yn        like mfc_logical.
	 define        variable line_tax        like trgl_gl_amt.
/*H539*/ define        variable type_tax        like trgl_gl_amt.
/*H0SW*/ define        variable accum_type_tax  like type_tax no-undo.
	 define shared variable crtint_amt      like trgl_gl_amt.
	 define shared variable poc_crtacc_acct like gl_crterms_acct.
	 define shared variable poc_crtacc_cc   like gl_crterms_cc.
	 define shared variable poc_crtapp_acct like gl_crterms_acct.
	 define shared variable poc_crtapp_cc   like gl_crterms_cc.
/*J038*/ define new shared variable srvendlot   like tr_vend_lot no-undo.
/*GO37*/ define shared variable msg-nbr         like tr_msg.

/*LB01*/ define variable isMpart        like mfc_logical.

/*GO37*/ define shared workfile posub
/*GO37*/                   field    posub_nbr       as character
/*GO37*/                   field    posub_line      as integer
/*GO37*/                   field    posub_qty       as decimal
/*GO37*/                   field    posub_wolot     as character
/*GO37*/                   field    posub_woop      as integer
/*GO37*/                   field    posub_gl_amt    like glt_amt
/*GO37*/                   field    posub_cr_acct   as character
/*GO37*/                   field    posub_cr_cc     as character
/*GO37*/                   field    posub_effdate   as date
/*GO37*/                   field    posub_move      like mfc_logical.

/*GO37** {mfdeclre.i} MOVED ABOVE **/

	 find pod_det where pod_recno = recid(pod_det) no-error.
	 find po_mstr where po_nbr    = pod_nbr no-error.
/*F0JC*  find pt_mstr where pt_recno  = recid(pt_mstr) no-error.*/
/*F0JC*/ find pt_mstr where pt_recno  = recid(pt_mstr) no-lock no-error.
	 find sct_det where sct_recno = recid(sct_det) no-error.

	 find first gl_ctrl  no-lock.
	 find first icc_ctrl no-lock.

/*H0SW*/ if {txnew.i} then do:
/*H0SW*/    assign
/*H0SW*/       last_sr_wkfl = no
/*H0SW*/       accum_type_tax = 0
/*H0SW*/       accum_taxamt = 0
/*H0SW*/       totl_qty_this_rcpt = 0.

/*H0SW*/    for each sr_wkfl where sr_userid = mfguser
/*H0SW*/    and sr_lineid = string(pod_line) no-lock:
/*H0SW*/       totl_qty_this_rcpt = totl_qty_this_rcpt
/*H0SW*/                          + if is-return then ( - sr_qty) else sr_qty.
/*H0SW*/    end.
/*H0SW*/ end.

	 srloop:
	 for each sr_wkfl where sr_userid = mfguser
	 and sr_lineid = string(pod_line) no-lock
/*H0SW*/ break by sr_userid:
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/    if last(sr_userid) then
/*H0SW*/       last_sr_wkfl = yes.

	    assign
/*GO37**           trqty    = sr_qty **/
/*GO37*/           trqty    = if is-return then ( - sr_qty) else sr_qty
		   site     = sr_site
		   location = sr_loc
		   lotser   = sr_lotser
		   lotref   = sr_ref
/*J038*/           srvendlot  = sr_vend_lot
		   base_amt = price
		   trqty    = trqty * conv_to_stk_um.

	    do i = 1 to 6:
	       assign
		      dr_acct[i] = ""
		      dr_cc[i]   = ""
		      dr_proj[i] = ""
		      cr_acct[i] = ""
		      cr_cc[i]   = ""
		      cr_proj[i] = ""
		      entity[i]  = ""
		      gl_amt[i]  = 0.
	    end.
	    line_tax = 0.

/*J053*/    /* IN ORDER TO ENSURE ACCURATE CALCULATIONS, IF AMOUNT BEING  */
/*J053*/    /* MULTIPLIED IS STORED IN DOCUMENT CURRENCY THEN CALCULATE   */
/*J053*/    /* IN DOCUMENT CURRENCY THEN PERFORM CONVERSION AND ROUND PER */
/*J053*/    /* BASE CURRENCY. */

/*J053*/    /* BASE_AMT IS IN DOCUMENT CURRENCY */
/*J053*/    /* CALCULATE GLAMT BASED UNIT PRICE AND TRQTY */
/*J053*/    glamt = base_amt * trqty.
/*J053*/    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J053*/    {gprun.i ""gpcurrnd.p"" "(input-output glamt,
				      input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/    docamt = glamt.   /* SAVE IN DOC CURRENCY */

/*J053*/    /* IF NECESSARY CONVERT GLAMT TO BASE */
/*J053*/    if po_curr <> base_curr
/*J053*/    then do:
/*J053*/       glamt = glamt / exch_rate.
/*J053*/       /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output glamt,
					 input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/    end.

	    /* BASE_AMT IS THE UNIT PRICE */
	    /* IF NECESSARY CONVERT BASE_AMT TO BASE CURRENCY */
	    if po_curr <> base_curr then
	       base_amt = base_amt / exch_rate.

	    /*INVENTORY ITEM RECEIPTS*/
	    if available pt_mstr and pod_type = "" then do:
	       find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
	       /*BASE RECEIPT*/
	       assign
		      dr_acct[1] = pl_inv_acct
		      dr_cc[1]   = pl_inv_cc
		      dr_proj[1] = pod_proj
		      cr_acct[1] = pl_rcpt_acct
		      cr_cc[1]   = pl_rcpt_cc
		      cr_proj[1] = pod_proj
		      entity[1]  = pod_entity
		      gl_amt[1]  = trqty * (sct_cst_tot - sct_ovh_tl).

/*J053*/       /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[1],
					 input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	       find pld_det
		  where pld_prodline = pt_prod_line
		  and pld_site = pod_site and pld_loc = location
		  no-lock no-error.
	       if not available pld_det then do:
		  find pld_det
		     where pld_prodline = pt_prod_line and pld_site = pod_site
		     and pld_loc = "" no-lock no-error.
		  if not available pld_det then do:
		     find pld_det
			where pld_prodline = pt_prod_line and pld_site = ""
			and pld_loc = "" no-lock no-error.
		  end.
	       end.

	       if available pld_det then
		  assign
			 dr_acct[1] = pld_inv_acct
			 dr_cc[1]   = pld_inv_cc.

	       
	       /*OVERHEAD RECEIPT*/
/******* LB01 add block begin:   */
/*LB01*/  isMpart = no.
/*LB01*/  find ptp_det where ptp_part = pod_part and
/*LB01*/  ptp_site = pod_site no-lock no-error.
/*LB01*/  
/*LB01*/  if available ptp_det and ptp_pm_code = "m" then
/*LB01*/  	isMpart = yes.
/*LB01*/  else
/*LB01*/  	if pt_pm_code = "m" then
/*LB01*/  		isMpart = yes.
		
/*LB01*/	 if isMpart = yes then			 
/*LB01*/     assign
/*LB01*/       dr_acct[2] = pl_inv_acct
/*LB01*/	      dr_cc[2]   = pl_inv_cc
/*LB01*/	      dr_proj[2] = pod_proj
/*LB01*/	      cr_acct[2] = pl_ppv_acct
/*LB01*/	      cr_cc[2]   = pl_ppv_cc
/*LB01*/	      cr_proj[2] = pod_proj
/*LB01*/	      entity[2]  = pod_entity
/*LB01*/	      gl_amt[2]  = trqty * sct_ovh_tl.
/*LB01*/	 else
/*LB01*/      assign
/*LB01*/	      dr_acct[2] = pl_inv_acct
/*LB01*/	      dr_cc[2]   = pl_inv_cc
/*LB01*/	      dr_proj[2] = pod_proj
/*LB01*/	      cr_acct[2] = pl_ovh_acct
/*LB01*/	      cr_cc[2]   = pl_ovh_cc
/*LB01*/	      cr_proj[2] = pod_proj
/*LB01*/	      entity[2]  = pod_entity
/*LB01*/       gl_amt[2]  = trqty * sct_ovh_tl.
/******* LB01 add block above and delete block below
*
*	       assign
*		      dr_acct[2] = pl_inv_acct
*		      dr_cc[2]   = pl_inv_cc
*		      dr_proj[2] = pod_proj
*		      cr_acct[2] = pl_ovh_acct
*		      cr_cc[2]   = pl_ovh_cc
*		      cr_proj[2] = pod_proj
*		      entity[2]  = pod_entity
*		      gl_amt[2]  = trqty * sct_ovh_tl.
*       LB01 delete block end.    */

/*J053*/       /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[2],
					 input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	       if available pld_det then
		  assign
			 dr_acct[2] = pld_inv_acct
			 dr_cc[2]   = pld_inv_cc.

	       if {txnew.i} then do:
		  line_tax = 0.
		  /* NON-RECOVERABLE TAXES GO INTO PPV */
/*GO37**          for each tx2d_det where tx2d_tr_type = '21' and **/
/*GO37*/          for each tx2d_det where tx2d_tr_type = tax_tr_type and
		     tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
		     tx2d_line = pod_line no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                        /* TAX INCLUDED = NO */
/*H539*/                if substring(tx2d__qad02,33,1) = 'n' then
/*H0SW*/                do:
/*H539*/                   type_tax = tx2d_taxamt[1] - tx2d_ntaxamt[5].
/*H0SW*/                   /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                              TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                              NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/                   if last_sr_wkfl then do:
/*H0SW*/                      if type_tax <> 0 then
/*H0SW*/                         type_tax = type_tax - accum_type_tax.
/*H0SW*/                   end.
/*H0SW*/                   else
/*H0SW*/                      if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/                         type_tax = type_tax
/*H0SW*/                                  * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                      end.
/*H0SW*/                end.
/*H539*/                else   /* TAX INCLUDED = YES */
/*H0SW*/                do:
           		   type_tax = - tx2d_ntaxamt[5].
/*H0SW*/                   /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                              TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                              NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/                   if last_sr_wkfl then do:
/*H0SW*/                      if type_tax <> 0 then
/*H0SW*/                         type_tax = type_tax - accum_type_tax.
/*H0SW*/                      else
/*H0SW*/                         if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/   		            type_tax = type_tax
/*H0SW*/                                     * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                         end.
/*H0SW*/                   end.
/*H0SW*/                   else
/*H0SW*/                      if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/   		         type_tax = type_tax
/*H0SW*/                                  * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                      end.
/*H0SW*/                end.

/*H539*/                if base_curr <> po_curr then
/*J053*/                do:
/*H539*/                   type_tax = type_tax / exch_rate.
/*J053*/                   {gprun.i ""gpcurrnd.p"" "(input-output type_tax,
						     input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/                end.

			line_tax = line_tax + type_tax.
/*H0SW*/                accum_type_tax = accum_type_tax + type_tax.

/*H539** /*H336*/                if substring(tx2d__qad02,33,1) = 'n' then
 ** /*H336*/                   line_tax = line_tax + tx2d_taxamt[1] -
 ** /*H336*/                              tx2d_ntaxamt[5].
 ** /*H336*/                else
 **                           line_tax = line_tax - tx2d_ntaxamt[5]. **/

		  end.
/*GUI*/ if global-beam-me-up then undo, leave.

	       end.
	       /* If U.S. taxes, add taxes to total PPV */
	       else if pod_taxable and not gl_vat and not gl_can
	       then do:
		  line_tax = 0.
		  do i = 1 to 3:
/*J053*              line_tax = line_tax +                                  */
/*J053*                         (trqty * base_amt) * (po_tax_pct[i] / 100). */
/*J053*/             /* DOCAMT IS (trqty * base_amt) IN DOCUMENT CURRENCY */
/*J053*/             /* FIRST CALCULATE IN DOC CURRENCY THEN CONVERT IF NEEDED*/
/*J053*/             tmp_amt = docamt * (po_tax_pct[i] / 100).
/*J053*/             /* ROUND PER DOC CURRENCY ROUND METHOD */
/*J053*/             {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
					       input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             /* CONVERT TMP_AMT IF NECESSARY */
/*J053*/             if (base_curr <> po_curr)
/*J053*/             then do:
/*J053*/                tmp_amt = tmp_amt / exch_rate.
/*J053*/                /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/                {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
					       input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             end.
/*J053*/             line_tax = line_tax + tmp_amt.
		  end.
	       end.

	       /*PPV RECEIPT*/
	       assign
		      dr_acct[3] = pl_ppv_acct
		      dr_cc[3]   = pl_ppv_cc
		      dr_proj[3] = pod_proj
		      cr_acct[3] = pl_rcpt_acct
		      cr_cc[3]   = pl_rcpt_cc
		      cr_proj[3] = pod_proj
		      entity[3]  = pod_entity
/*J053*/              gl_amt[3]  = line_tax + (trqty
/*J053*/                   * (base_amt - sct_cst_tot + sct_ovh_tl)).
/*J053*               gl_amt[3]  = round(line_tax + (trqty              */
/*J053*                    * (base_amt - sct_cst_tot + sct_ovh_tl)),2). */

/*J053*/       /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[3],
					 input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	       if pod_entity <> pod_po_entity
		  or poddb <> podpodb then do:
		  /*INTERCOMPANY POSTING - INTERCO ACCT*/
		  assign
			 dr_acct[4] = pl_rcpt_acct
			 dr_cc[4]   = pl_rcpt_cc
			 dr_proj[4] = pod_proj
			 cr_acct[4] = icc_ico_acct
			 cr_cc[4]   = icc_ico_cc
			 cr_proj[4] = pod_proj
			 entity[4]  = pod_entity
/*J0CZ*/                 gl_amt[4]  = glamt + line_tax.
/*J0CZ*/          /* G1JL logic incoporated into J0CZ during Feb '96 merge tjs*/

/*J0CZ****
/*J053*/ *               gl_amt[4]  = glamt.
**J0CZ****/
/*J053*/                 /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/                 /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*                  gl_amt[4]  = round((trqty * base_amt),2).  */

		  /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
		  assign
			 dr_acct[6] = icc_ico_acct
			 dr_cc[6]   = icc_ico_cc
			 dr_proj[6] = pod_proj
			 cr_acct[6] = pl_rcpt_acct
			 cr_cc[6]   = pl_rcpt_cc
			 cr_proj[6] = pod_proj
			 entity[6]  = pod_po_entity
/*J0CZ*/                 gl_amt[6]  = glamt + line_tax.

/*J0CZ****
/*J053*/ *               gl_amt[6]  = glamt.
**J0CZ****/
/*J053*/                 /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/                 /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*                  gl_amt[6]  = round((trqty * base_amt),2). */
	       end.

	       /*RE-CALCULATE AVERAGE COST*/
	       if glx_mthd = "AVG" then do:
		  if reavg_yn then do:
		     {gprun.i ""csavg03.p"" "(input recid(sct_det),
					      input trqty,
					      input newmtl_tl,
					      input newlbr_tl,
					      input newbdn_tl,
					      input newovh_tl,
					      input newsub_tl,
					      input newmtl_ll,
					      input newlbr_ll,
					      input newbdn_ll,
					      input newovh_ll,
					      input newsub_ll)"
		     }
/*GUI*/ if global-beam-me-up then undo, leave.

		  end.
		  gl_amt[1]  = trqty * (newcst - newovh_tl).
/*J053*/          /* ROUND PER BASE CURR ROUND METHOD */
/*J053*/          {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[1],
					    input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

		  gl_amt[2]  = trqty * newovh_tl.
/*J053*/          /* ROUND PER BASE CURR ROUND METHOD */
/*J053*/          {gprun.i ""gpcurrnd.p"" "(input-output gl_amt[2],
					    input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

		  gl_amt[3]  = 0.
	       end.
	    end. /*if pod_type = ""*/

	    /*SUBCONTRACT RECEIPTS*/
	    else if available pt_mstr and pod_type = "S" then do:
/*H466*/       find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
	       /*BASE RECEIPT*/
	       assign
		      dr_acct[1] = pl_cop_acct
		      dr_cc[1]   = pl_cop_cc
		      dr_proj[1] = pod_proj
		      cr_acct[1] = pl_rcpt_acct
		      cr_cc[1]   = pl_rcpt_cc
		      cr_proj[1] = pod_proj
		      entity[1]  = pod_entity
/*J053*/              gl_amt[1]  = glamt.
/*J053*/              /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/              /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*               gl_amt[1]  = round((trqty * base_amt),2). */

	       wolot = pod_wo_lot.
	       woop  = pod_op.

	       if can-find(first wr_route
	       where wr_lot = wolot and wr_op = woop)
	       then do:
		  find wo_mstr where wo_lot = wolot.
		  find wr_route where wr_lot = wolot and wr_op = woop.
		  wr_recno = recid(wr_route).

/* WHEN wo_type = 'c' and wo_nbr = "" AND wo_status = "r" THEN THIS     */
/* WORK ORDER WAS CREATED BY THE ADVANCED REPETETIVE MODULE.  THE       */
/* COSTING WILL BE DONE LATER IN removea.p WHICH HAS THE WORKFILE       */
/* podsub PASSED TO IT.                                                 */
		  if index ("FPC",wo_status) = 0 then do:
/*GO37*/             if wo_type = "c" and wo_nbr = ""
/*GO37*/             and wo_status = "r" then do:
/*GO37*/                create posub.

/*GO37*/                assign
/*GO37*/                   posub_nbr = po_nbr
/*GO37*/                   posub_line = pod_line
/*GO37*/                   posub_qty = trqty
/*GO37*/                   posub_wolot = pod_wo_lot
/*GO37*/                   posub_woop = pod_op
/*GO37*/                   posub_gl_amt = gl_amt[1]
/*GO37*/                   posub_cr_acct = dr_acct[1]
/*GO37*/                   posub_cr_cc = dr_cc[1]
/*GO37*/                   posub_effdate = eff_date
/*GO37*/                   posub_move = move.

/*G1BR* GET THE SUBCONTRACT COST FROM THE ROUTING DETAIL RECORD */
/*G1BR*/                find ro_det no-lock where ro_routing =
/*G1BR*/                (if wo_routing <> "" then wo_routing
/*G1BR*/                  else wo_part)
/*G1BR*/                 and ro_op = woop no-error.
/*G1GX****
/*G1BR*/ *              if available ro_det then stdcst = ro_sub_cost.
/*G1BR*/ *              else stdcst = 0.
**G1GX***/

/*G1GX*/                /* Added section */
			stdcst = 0.
			if available ro_det then do:
			   {rerosdef.i}
			   {rerosget.i
			      &routing=ro_routing
			      &op=ro_op
			      &start=ro_start
			      &lock=no-lock}

			   assign
			   stdcst = ro_sub_cost
			   posub_move = ro_mv_nxt_op.
			end.
			else do:
			  {rewrsdef.i}
			  {rewrsget.i
			     &lot=wr_lot
			     &op=wr_op
			     &lock=no-lock}

			   assign
			   posub_move = wr_mv_nxt_op
			   stdcst = wr_sub_cost.
			end.
/*G1GX*/                /* End of added section */
/*GO37*/             end.
/*GO37*/             else do:
			wr_po_nbr = pod_nbr.
			{gprun.i ""porcsub.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO37*/             end.
		  end.
	       end.
/*H0Y5*/       else do:
/*H0Y5*/          l_ro_routing = "".
/*H0Y5*/          find ptp_det where ptp_part = pod_part and
/*H0Y5*/          ptp_site = pod_site no-lock no-error.
/*H0Y5*/          if available ptp_det then do:
/*H0Y5*/             if ptp_routing <> "" then
/*H0Y5*/                l_ro_routing = ptp_routing.
/*H0Y5*/             else
/*H0Y5*/                l_ro_routing = pod_part.
/*H0Y5*/          end.
/*H0Y5*/          else do:
/*H0Y5*/             find pt_mstr where pt_part = pod_part no-lock no-error.
/*H0Y5*/             if available pt_mstr then do:
/*H0Y5*/                if pt_routing <> "" then
/*H0Y5*/                   l_ro_routing = pt_routing.
/*H0Y5*/                else
/*H0Y5*/                   l_ro_routing = pod_part.
/*H0Y5*/             end.
/*H0Y5*/          end. /* not available ptp_det */
/*H0Y5*/          find ro_det where ro_routing = l_ro_routing and
/*H0Y5*/          ro_op = woop no-lock no-error.
/*H0Y5*/          if available ro_det then
/*H0Y5*/             stdcst = ro_sub_cost.
/*H0Y5*/          else
/*H0Y5*/             stdcst = 0.
/*H0Y5*/       end. /* IF WORKORDER IS NOT AVAILABLE */

/*G0YP*/       if {txnew.i} then do:
/*G0YP*/          line_tax = 0.
/*G0YP*/          /* NON-RECOVERABLE TAXES GO INTO PPV */
/*G0YP*/          for each tx2d_det where tx2d_tr_type = tax_tr_type and
/*G0YP*/             tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
/*G0YP*/             tx2d_line = pod_line no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                        /* TAX INCLUDED = NO */
/*G0YP*/                if substring(tx2d__qad02,33,1) = 'n' then
/*H0SW*/                do:
/*G0YP*/                   type_tax = tx2d_taxamt[1] - tx2d_ntaxamt[5].
/*H0SW*/                   /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                              TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                              NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/                   if last_sr_wkfl then do:
/*H0SW*/                      if type_tax <> 0 then
/*H0SW*/                         type_tax = type_tax - accum_type_tax.
/*H0SW*/                   end.
/*H0SW*/                   else
/*H0SW*/                      if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/                         type_tax = type_tax
/*H0SW*/                                  * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                      end.
/*H0SW*/                end.
/*G0YP*/                else   /* TAX INCLUDED = YES */
/*H0SW*/                do:
/*G0YP*/                   type_tax = - tx2d_ntaxamt[5].
/*H0SW*/                   /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                              TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                              NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/                   if last_sr_wkfl then do:
/*H0SW*/                      if type_tax <> 0 then
/*H0SW*/                         type_tax = type_tax - accum_type_tax.
/*H0SW*/                      else
/*H0SW*/                         if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/   		            type_tax = type_tax
/*H0SW*/                                     * (trqty / totl_qty_this_rcpt).
/*H0SW*/                            /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                            {gprun.i ""gpcurrnd.p""
                                             "(input-output type_tax,
                                               input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                         end.
/*H0SW*/                   end.
/*H0SW*/                   else
/*H0SW*/                      if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/                         type_tax = type_tax
/*H0SW*/                                  * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                      end.
/*H0SW*/                end.

/*G0YP*/                if base_curr <> po_curr then
/*J053*/                do:
/*G0YP*/                   type_tax = type_tax / exch_rate.
/*J053*/                   /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/                   {gprun.i ""gpcurrnd.p"" "(input-output type_tax,
						     input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/                end.
/*G0YP*/
/*G0YP*/                line_tax = line_tax + type_tax.
/*H0SW*/                accum_type_tax = accum_type_tax + type_tax.

/*G0YP*/          end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0YP*/       end.
/*G0YP*/       /* If U.S. taxes, add taxes to total PPV */
/*G0YP*/       else if pod_taxable and not gl_vat and not gl_can
/*G0YP*/       then do:
/*G0YP*/          line_tax = 0.
/*G0YP*/          do i = 1 to 3:
/*J053* /*G0YP*/     line_tax = line_tax +                                 */
/*J053* /*G0YP*/                (trqty * base_amt) * (po_tax_pct[i] / 100).*/
/*J053*/             /* DOCAMT IS (trqty * base_amt) IN DOCUMENT CURRENCY */
/*J053*/             /* FIRST CALCULATE IN DOC CURRENCY THEN CONVERT IF NEEDED*/
/*J053*/             tmp_amt = docamt * (po_tax_pct[i] / 100).
/*J053*/             /* ROUND PER DOC CURRENCY ROUND METHOD */
/*J053*/             {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
					       input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             /* CONVERT TO BASE CURRENCY */
/*J053*/             if (base_curr <> po_curr)
/*J053*/             then do:
/*J053*/                tmp_amt = tmp_amt / exch_rate.
/*J053*/                /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/                {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
						  input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             end.
/*J053*/             line_tax = line_tax + tmp_amt.
/*G0YP*/          end.
/*G0YP*/       end.
/*G0YP*/
/*G0YP*/       /*PPV RECEIPT*/
/*G0YP*/       assign
/*G0YP*/              dr_acct[3] = pl_ppv_acct
/*G0YP*/              dr_cc[3]   = pl_ppv_cc
/*G0YP*/              dr_proj[3] = pod_proj
/*G0YP*/              cr_acct[3] = pl_rcpt_acct
/*G0YP*/              cr_cc[3]   = pl_rcpt_cc
/*G0YP*/              cr_proj[3] = pod_proj
/*G0YP*/              entity[3]  = pod_entity
/*J053*/              gl_amt[3]  = line_tax.
/*J053* /*G0YP*/      gl_amt[3]  = round(line_tax,2).  */

	       if entity[1] <> pod_po_entity or poddb <> podpodb
	       then do:
		  /*INTERCOMPANY POSTING - INTERCO ACCT*/
		  assign
			 dr_acct[2] = pl_rcpt_acct
			 dr_cc[2]   = pl_rcpt_cc
			 dr_proj[2] = project
			 cr_acct[2] = icc_ico_acct
			 cr_cc[2]   = icc_ico_cc
			 cr_proj[2] = project
			 entity[2]  = entity[1]
/*J053*/                 gl_amt[2]  = glamt.
/*J053*/                 /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/                 /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*                  gl_amt[2]  = round((trqty * base_amt),2). */

		  /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
		  assign
			 dr_acct[6] = icc_ico_acct
			 dr_cc[6]   = icc_ico_cc
			 dr_proj[6] = project
			 cr_acct[6] = pl_rcpt_acct
			 cr_cc[6]   = pl_rcpt_cc
			 cr_proj[6] = project
			 entity[6]  = pod_po_entity
/*J053*/                 gl_amt[6]  = glamt.
/*J053*/                 /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/                 /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*                  gl_amt[6]  = round((trqty * base_amt),2). */
	       end.
	    end. /*if pod_type = "S"*/

	    /*MEMO ITEM RECEIPTS*/
	    else do:
	       /*BASE RECEIPT*/
	       assign
		      dr_acct[1] = pod_acct
		      dr_cc[1]   = pod_cc
		      dr_proj[1] = pod_proj
		      cr_acct[1] = gl_rcptx_acct
		      cr_cc[1]   = gl_rcptx_cc
		      cr_proj[1] = pod_proj
		      entity[1]  = pod_entity
/*J053*/              gl_amt[1]  = glamt.
/*J053*/              /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/              /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*               gl_amt[1]  = round((trqty * base_amt),2). */

	       if {txnew.i} then do:
		  line_tax = 0.
		  /* NON-RECOVERABLE TAXES GO INTO PPV */
/*H0YF**          for each tx2d_det where tx2d_tr_type = '21' and   */
/*H0YF*/          for each tx2d_det where tx2d_tr_type = tax_tr_type and
		     tx2d_ref = receivernbr and tx2d_nbr = po_nbr and
		     tx2d_line = pod_line no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                        /* TAX INCLUDED = NO */
/*H539*/                if substring(tx2d__qad02,33,1) = 'n' then
/*H0SW*/                do:
/*H539*/                   type_tax = tx2d_taxamt[1] - tx2d_ntaxamt[5].
/*H0SW*/                   /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                              TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                              NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/                   if last_sr_wkfl then do:
/*H0SW*/                      if type_tax <> 0 then
/*H0SW*/                         type_tax = type_tax - accum_type_tax.
/*H0SW*/                   end.
/*H0SW*/                   else
/*H0SW*/                      if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/                         type_tax = type_tax
/*H0SW*/                                  * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                      end.
/*H0SW*/                end.
/*H539*/                else   /* TAX INCLUDED = YES */
/*H0SW*/                do:
     			   type_tax = - tx2d_ntaxamt[5].
/*H0SW*/                   /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                              TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS
                              NOT BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/                   if last_sr_wkfl then do:
/*H0SW*/                      if type_tax <> 0 then
/*H0SW*/                         type_tax = type_tax - accum_type_tax.
/*H0SW*/                      else
/*H0SW*/                         if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/   		            type_tax = type_tax
/*H0SW*/                                     * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                         end.
/*H0SW*/                   end.
/*H0SW*/                   else
/*H0SW*/                      if totl_qty_this_rcpt <> 0 then do:
/*H0SW*/		         type_tax = type_tax
/*H0SW*/                                  * (trqty / totl_qty_this_rcpt).
/*H0SW*/                         /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                         {gprun.i ""gpcurrnd.p""
                                          "(input-output type_tax,
                                            input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                      end.
/*H0SW*/                end.

/*H539*/                if base_curr <> po_curr then
/*J053*/                do:
/*H539*/                   type_tax = type_tax / exch_rate.
/*J053*/                   /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/                   {gprun.i ""gpcurrnd.p"" "(input-output type_tax,
						     input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/                end.

			line_tax = line_tax + type_tax.
/*H0SW*/                accum_type_tax = accum_type_tax + type_tax.

/*H539** /*H336*/           if substring(tx2d__qad02,33,1) = 'n' then
 ** /*H336*/                   line_tax = line_tax + tx2d_taxamt[1] -
 ** /*H336*/                              tx2d_ntaxamt[5].
 ** /*H336*/                else
 **                           line_tax = line_tax - tx2d_ntaxamt[5]. **/
		  end.
/*GUI*/ if global-beam-me-up then undo, leave.

	       end.
	       /* If U.S. taxes, add taxes to total PPV */
	       else if pod_taxable and not gl_vat and not gl_can
	       then do:
		  line_tax = 0.
		  do i = 1 to 3:
/*J053*              line_tax = line_tax +                                 */
/*J053*                         (trqty * base_amt) * (po_tax_pct[i] / 100).*/
/*J053*/             /* DOCAMT IS (trqty * base_amt) IN DOCUMENT CURRENCY */
/*J053*/             /* FIRST CALCULATE IN DOC CURRENCY THEN CONVERT IF NEEDED*/
/*J053*/             tmp_amt = docamt * (po_tax_pct[i] / 100).
/*J053*/             /* ROUND PER DOC CURRENCY ROUND METHOD */
/*J053*/             {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
					       input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             /* CONVERT TO BASE CURRENCY */
/*J053*/             if (base_curr <> po_curr)
/*J053*/             then do:
/*J053*/                tmp_amt = tmp_amt / exch_rate.
/*J053*/                /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/                {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,
						  input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             end.
/*J053*/             line_tax = line_tax + tmp_amt.
		  end.
	       end.
/*J053*/       /* COMPONENTS ALREADY ROUNDED */
/*J053*/       gl_amt[1] = gl_amt[1] + line_tax.
/*J053*        gl_amt[1]  = round(gl_amt[1] + line_tax, 2).   */

	       if pod_entity <> pod_po_entity or poddb <> podpodb
	       then do:
		  /*INTERCOMPANY POSTING - INTERCO ACCT*/
		  assign
			 dr_acct[2] = gl_rcptx_acct
			 dr_cc[2]   = gl_rcptx_cc
			 dr_proj[2] = pod_proj
			 cr_acct[2] = icc_ico_acct
			 cr_cc[2]   = icc_ico_cc
			 cr_proj[2] = pod_proj
			 entity[2]  = pod_entity
/*J0CZ*/                 gl_amt[2]  = glamt + line_tax.

/*J0CZ****
/*J053*/ *               gl_amt[2]  = glamt.
**J0CZ****/
/*J053*/                 /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/                 /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*                  gl_amt[2]  = round((trqty * base_amt),2).  */

		  /*INTERCOMPANY POSTING - PO RECEIPTS ACCT*/
		  assign
			 dr_acct[6] = icc_ico_acct
			 dr_cc[6]   = icc_ico_cc
			 dr_proj[6] = pod_proj
			 cr_acct[6] = gl_rcptx_acct
			 cr_cc[6]   = gl_rcptx_cc
			 cr_proj[6] = pod_proj
			 entity[6]  = pod_po_entity
/*J0CZ*/                 gl_amt[6]  = glamt + line_tax.

/*J0CZ****
/*J053*/ *               gl_amt[6]  = glamt.
**J0CZ****/
/*J053*/                 /* GLAMT WAS CALCULATED AND CONVERTED IN THE */
/*J053*/                 /* BEGINNING, NO NEED TO RECALCULATE. */
/*J053*                  gl_amt[6]  = round((trqty * base_amt),2). */
	       end.
	    end. /*else do (memo items)*/

	    /* CREATE TRAN HISTORY RECORD FOR EACH LOT/SERIAL/PART */
	    assign
		   pt_recno  = recid(pt_mstr)
		   pod_recno = recid(pod_det)
		   po_recno  = recid(po_mstr)
		   wr_recno  = recid(wr_route).
/*LB01*/ {gprun.i ""zzpoporcc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


	    if (pod_rma_type = "I"   or
	       pod_rma_type = "O")
	    then do:
	       {gprun.i ""fsrtvtrn.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

	       if undo_all then leave .
	    end.
	 end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* for each sr_wkfl */

/*GN82* for each sr_wkfl where sr_userid = mfguser*/
/*GN82*/ for each sr_wkfl exclusive-lock where sr_userid = mfguser
	 and sr_lineid = string(pod_line):
	    delete sr_wkfl.
	 end.

	 if  pod_qty_chg <> 0 then do:

	    find rmd_det
	       where rmd_nbr  = pod_nbr and   rmd_prefix   = "V"
	       and   rmd_line = pod_line no-error.
		   /*******************************************/
		   /* Update receive/ship date and qty in rma */
		   /*******************************************/
	    if  available rmd_det then do:
	       if  rmd_type = "O" then
				  rmd_qty_acp  = - (pod_qty_rcvd + pod_qty_chg).
	       else rmd_qty_acp  =   pod_qty_rcvd + pod_qty_chg.
/*H0QF*/       if rmd_qty_acp <> 0 then	
	           rmd_cpl_date =   eff_date.
/*H0QF*/       else rmd_cpl_date = ?.	
	    end.
	 end. /**********end pod_qty_chg*************/
