/* zzIstWkf.p - insert PRODUCT STRUCTURE COMPONENT QUANTITY info into work file*/
/* COPYRIGHT AtosOrigin. ALL RIGHTS	RESERVED. THIS IS AN UNPUBLISHED WORK.	   */
/* REVISION: 8.5	LAST MODIFIED: 11/19/03	 BY: *LB01*	Long Bo				   */

/************************************************************************/
/* input parameter Parent product structure part to be */ 
/* input parameter bSource yes = Դ, no = ±Ƚ͠         */
/************************************************************************/
define input parameter Parent like ps_par.		
define input parameter bSource like mfc_logical.

def var dComp like ps_par.
def var dLevel as integer.
def var dMaxlevel as integer.
def var ddesc like pt_desc1.
def var ddesc2 like pt_desc2.
def var dpmcode like pt_pm_code.
def var dPhantom like pt_phantom.
define variable dRecord as integer extent 100.
define shared work-table mybomcmp
	field bcomp like ps_comp
	field bdesc like pt_desc1
	field bdesc2 like pt_desc2
	field bqty1 like ps_qty_per
	field bqty2 like ps_qty_per.

	dLevel = 1.
	dComp = Parent.	
	dMaxlevel = min(dMaxlevel,99).
	
	find first ps_mstr use-index ps_parcomp where ps_par = dComp
	no-lock no-error.
	repeat:

		if not available ps_mstr then do:
			repeat:
				dLevel = dLevel - 1.
				if dLevel < 1 then leave.
				find ps_mstr where recid(ps_mstr) = dRecord[dLevel]
				no-lock no-error.
				dComp = ps_par.
				find next ps_mstr use-index ps_parcomp where ps_par = dComp
				no-lock no-error.
				if available ps_mstr then leave.
			end.
		end.
		if dLevel < 1 then leave.
		
		dPhantom = yes.
		find pt_mstr where pt_part = ps_comp no-lock no-error.
		if available pt_mstr then do:
			assign
				dPhantom = pt_phantom
				dpmcode = pt_pm_code
				ddesc = pt_desc1
				ddesc2 = pt_desc2.
			find first ptp_det where ptp_part = ps_comp and ptp_site = ps__chr01 no-lock no-error.
				/* in DCEC, we store site in the field of ps_chr01 for reference.
				*  if there is a item-site record in ptp_det, 
				*  we should associate phantom and pm_code value with site.*/
			if available ptp_det then do:
				assign
					dPhantom = ptp_phantom
					dpmcode = ptp_pm_code.
			end.
		end.
		else do:
			find bom_mstr no-lock where bom_parent = ps_comp no-error.
		end.
	
		dRecord[dLevel] = recid(ps_mstr).
		
		/*
		*if dpmcode = "p" or dpmcode = "P"
		*or ((dpmcode = "M" or dpmcode = "m") and (dphantom=no)) then do:*/
		
		if dPhantom = no then do: 
			find first mybomcmp where bcomp = ps_comp exclusive-lock no-error.
			if available mybomcmp then do:
				if bSource then
					mybomcmp.bqty1 = mybomcmp.bqty1 + ps_qty_per.
				else 
					mybomcmp.bqty2 = mybomcmp.bqty2 + ps_qty_per.
			end.
			else do:
				create mybomcmp.
				assign
					mybomcmp.bcomp = ps_comp
					mybomcmp.bdesc = ddesc.
					mybomcmp.bdesc2 = ddesc2.
				if bSource then do:
					mybomcmp.bqty1 = ps_qty_per.
					mybomcmp.bqty2 = 0.
				end.
				else do:
					mybomcmp.bqty1 = 0.
					mybomcmp.bqty2 = ps_qty_per.
				end.
			end.
			/* next node when this node of component is "P" or ("M" and Phantom = no) */ 
			find next ps_mstr use-index ps_parcomp where ps_par = dComp
			no-lock no-error.
			next.					
		end.	/*end of if pmcode and phantom...    */

		if (dLevel < dMaxlevel) or (dMaxlevel = 0) then do:
			dComp = ps_comp.
			dLevel = dLevel + 1.
			find first ps_mstr use-index ps_parcomp where ps_par = dComp
			no-lock no-error.
		end.
		else do:
			find next ps_mstr use-index ps_parcomp where ps_par = dComp
			no-lock no-error.
		end.
	end.	/* repeat */
