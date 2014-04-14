/* ckbmpkrp6.p - PICK LIST REPORT                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert bmpkrpa.p (converter v1.00) Wed Sep 17 11:06:08 1997 */
/* web tag in bmpkrpa.p (converter v1.00) Mon Jul 14 17:24:35 1997 */
/*F0PN*/ /*K10Y*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0       LAST MODIFIED: 05/12/86      BY: EMB             */
/* REVISION: 1.0       LAST MODIFIED: 08/29/86      BY: EMB *12 *       */
/* REVISION: 1.0       LAST MODIFIED: 01/29/87      BY: EMB *A19*       */
/* REVISION: 2.1       LAST MODIFIED: 09/02/87      BY: WUG *A94*       */
/* REVISION: 4.0       LAST MODIFIED: 02/24/88      BY: WUG *A175*      */
/* REVISION: 4.0       LAST MODIFIED: 04/06/88      BY: FLM *A193*      */
/* REVISION: 4.0       LAST MODIFIED: 07/11/88      BY: flm *A318*      */
/* REVISION: 4.0       LAST MODIFIED: 08/03/88      BY: flm *A375*      */
/* REVISION: 4.0       LAST MODIFIED: 11/04/88      BY: flm *A520*      */
/* REVISION: 4.0       LAST MODIFIED: 11/15/88      BY: emb *A535*      */
/* REVISION: 4.0       LAST MODIFIED: 02/21/89      BY: emb *A654*      */
/* REVISION: 5.0       LAST MODIFIED: 06/23/89      BY: MLB *B159*      */
/* REVISION: 6.0       LAST MODIFIED: 07/11/90      BY: WUG *D051*      */
/* REVISION: 6.0       LAST MODIFIED: 10/31/90      BY: emb *D145*      */
/* REVISION: 6.0       LAST MODIFIED: 02/26/91      BY: emb *D376*      */
/* REVISION: 6.0       LAST MODIFIED: 08/02/91      BY: bjb *D811*      */
/* REVISION: 7.2       LAST MODIFIED: 10/26/92      BY: emb *G234*      */
/* REVISION: 7.2       LAST MODIFIED: 11/04/92      BY: pma *G265*      */
/* REVISION: 7.4       LAST MODIFIED: 09/01/93      BY: dzs *H100*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/93      BY: ais *GH69*      */
/* REVISION: 7.2       LAST MODIFIED: 03/18/94      BY: ais *FM19*      */
/* REVISION: 7.2       LAST MODIFIED: 03/23/94      BY: qzl *FM31*      */
/* REVISION: 7.4       LAST MODIFIED: 04/18/94      BY: ais *H357*      */
/* REVISION: 7.4       LAST MODIFIED: 10/18/94      BY: jzs *GN61*      */
/* REVISION: 7.4       LAST MODIFIED: 02/03/95      by: srk *H09T       */
/* REVISION: 7.2       LAST MODIFIED: 02/09/95      BY: qzl *F0HQ*      */
/* REVISION: 8.5       LAST MODIFIED: 05/18/94      BY: dzs *J020*      */
/* REVISION: 7.4       LAST MODIFIED: 12/20/95      BY: bcm *G1H5*      */
/* REVISION: 7.4       LAST MODIFIED: 01/22/96      BY: jym *G1JF*      */
/* REVISION: 8.6       LAST MODIFIED: 09/27/97      BY: mzv *K0J *      */
/* REVISION: 8.6       LAST MODIFIED: 10/15/97      BY: ays *K10Y*      */
/* REVISION: 7.4       LAST MODIFIED: 02/04/98      BY: jpm *H1JC*      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0       LAST MODIFIED: 10/16/98      BY: *J32L* Felcy D'Souza */
/* REVISION: 9.0       LAST MODIFIED: 03/13/99      BY: *M0BD* Alfred Tan    */

/*GN61*/ {mfdtitle.i "f+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpkrpa_p_1 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_2 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_3 "(BOM)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_4 "(PARENT)"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_5 " BOM = "
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpkrpa_p_6 "Quantity"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define new shared workfile pkdet no-undo
/*G1H5*     field pkpart like pk_part */
/*G1H5*/    field pkpart like ps_comp
/*H100*/    field pkop as integer
/*G1H5*/       format ">>>>>9"
            field pkstart like pk_start
            field pkend like pk_end
            field pkqty like pk_qty
/*F0HQ*/    field pkbombatch like bom_batch
            field pkltoff like ps_lt_off.

/*michael add section*/
/*
/*mic*/ define new shared temp-table tblpp
  				field pp_vsm      like pt_site label "W/C"
				field pp_line     like ln_line label "W/C"
				field pp_part  	like pt_part
  				field pp_desc1		like pt_desc1
				field pp_desc2		like pt_desc2
  				field pp_promo 	like pt_promo label "Category"
  				field pp_qty 		like pk_qty label "Request Qty"
  				field pp_qty_main like ld_qty_oh label "Main Stk" 
				field pp_qty_line like ld_qty_oh label "Line Stk"
				field pp_qty_rcv  like ld_qty_oh label "RCV Stk"
				field pp_qty_iss  like ld_qty_oh label "Issue Qty"
				field pp_qty_per	like ps_qty_per
				field pp_op  		like ps_op
				field pp_iss_pol  like pt_iss_pol
				field pp_um 		like pt_um
				index pp_op is primary pp_op pp_promo pp_part
				index pp_part pp_part pp_vsm pp_line.
*/
/*mic*/ define new shared temp-table tblpp
  				field pp_vsm		like pt_site label "W/C"
				field pp_line		like ln_line label "W/C"
				field pp_parent	like pt_part
				field pp_part  	like pt_part
  				field pp_desc1		like pt_desc1
				field pp_desc2		like pt_desc2
  				field pp_promo 	like pt_promo label "Category"
  				field pp_qty 		like pk_qty label "Request Qty"
  				field pp_qty_main like ld_qty_oh label "Main Stk"
				field pp_qty_line like ld_qty_oh label "Line Stk"
				field pp_qty_rcv  like ld_qty_oh label "RCV Stk"
				field pp_qty_iss	like ld_qty_oh label "Issue Qty"
				field pp_qty_per 	like ps_qty_per
				field pp_op  		like ps_op
				field pp_iss_pol	like pt_iss_pol
				field pp_um 		like pt_um
  				index pp_op is primary pp_op pp_promo pp_part pp_parent
				index pp_part pp_part pp_vsm pp_line pp_parent
				index pp_line pp_line pp_parent pp_part.


/*mic*/ define temp-table tblld
				field tmpld_part  	like pt_part
  				field tmpld_qty_oh  like ld_qty_oh
  				field tmpld_qty_iss like ld_qty_oh
				field tmpld_loc 		like loc_loc
				field tmpld_locator	like ckloc_locator
				index tmpld_part is primary tmpld_part tmpld_locator descending tmpld_loc.
/*mic*/ define temp-table tblln
				field pln_vsm 		like pt_site label "VSM"
				field pln_line 	like ln_line label "W/C"
				field pln_part  	like pt_part
  				field pln_qty_iss like ld_qty_oh
				field pln_loc 		like loc_loc
				field pln_locator	like ckloc_locator
  				index pln_line is primary pln_line pln_locator pln_loc pln_part
				index pln_part pln_part pln_vsm pln_line pln_loc pln_locator.
			define new shared variable comp like ps_comp.
/*GH69*  define new shared variable eff_date like tr_effdate.           */
/*GH69*/ define new shared variable eff_date as date label {&bmpkrpa_p_1}.
         define variable level as integer no-undo.
         define variable qty like pk_qty label {&bmpkrpa_p_6} no-undo.
         define variable qty_rcv like pk_qty no-undo.
/*G1H5*  define variable part like pt_part. */
/*G1H5*  define variable part1 like pt_part.*/
/*G1H5*/ define variable part  like ps_par       no-undo.
/*G1H5*/ define variable part1 like ps_par       no-undo.
         define variable line  like ln_line		 no-undo.
/*michael
			define variable line1 like pt_prod_line no-undo.
**Michael*/
			define variable vsm like pt_site label "VSM".
/*G234*/ define new shared variable site like in_site no-undo.
/*G234*/ define new shared variable parent_bom like pt_bom_code.
/*G265/*G234*/ define variable ord_qty like pt_ord_qty */
/*G265*/ define variable ord_qty like qty column-label "Request QTY" no-undo.
/*G265*/ define new shared variable transtype as character format "x(4)".
/*H100*/ define new shared variable op  like ro_op format ">>>>>>" no-undo.
/*H100*/ define new shared variable op1 like ro_op format ">>>>>>" no-undo.
/*H100*/ define variable op3 like ro_op format ">>>>>>" no-undo.
/*H100*/ define variable op4 like ro_op format ">>>>>>" no-undo.
/*H100*/ define variable op5 like ro_op format ">>>>>>" no-undo.
/*H100*/ define variable op6 like ro_op format ">>>>>>" no-undo.
/*G1H5*/ define variable item-code as character no-undo.
/*G1H5*/ define variable bom-code  as character no-undo.
/*G1H5*/ define variable is-item   as logical   no-undo.
/*G265*/ define variable type as character format "x(1)" 
					label "FA/SMT/STUFF/POU" initial "F".

/*FM19*/ define new shared variable phantom like mfc_logical initial yes.
         define buffer ptmstr for pt_mstr.
/*J32L*/ define variable um like bom_batch_um no-undo.
/*J32L*/ define variable batchdesc1 like pt_desc2 no-undo.
/*J32L*/ define variable batchdesc2 like pt_desc2 no-undo.
/*J32L*/ define variable aval as logical no-undo.
/*J32L*/ define variable batchqty like pt_batch no-undo.
			form 
				pp_line
				pp_part  
  				pp_desc1
				pp_qty_line
				ckloc_locator 
				ckloc_location
				pp_qty_main
				pp_qty 	
				pp_qty_iss column-label "Issue Qty"
				/*
				pp_promo
				*/
			with frame b width 140 no-attr-space. 
/*michael 2013.05.09*//*
/*H100*/ {gpxpld01.i "new shared"}
/*michael 2013.05.09*/*/
DEFINE VARIABLE sourcefile AS CHARACTER FORMAT "x(30)" label "Input File".
DEFINE VARIABLE targetfile AS CHARACTER FORMAT "x(20)" VIEW-AS FILL-IN.
DEFINE VARIABLE m_count    as integer.
DEFINE VARIABLE m_error    as integer.
define variable loc 			like loc_loc.
DEFINE new shared TEMP-TABLE temp-seqmstr
FIELD tmp_vsm			LIKE seq_site
field tmp_line 		like seq_line
field tmp_date       like seq_due_date
FIELD tmp_part			LIKE pt_mstr.pt_part
FIELD tmp_qty_req		LIKE seq_qty_req 
field tmp_code			as character format "x(20)"
INDEX tmp_part is primary  tmp_part.

define buffer tblln1 for tblln. 
define buffer tblld1 for tblld. 

FUNCTION dtoc RETURNS character (INPUT parm1 AS date).
        
return(	string(year(parm1)) + 
			string(month(parm1), "99") +
      	string(day(parm1), "99") +
			replace(string(time, "hh:mm:ss"), ":", "") ).
end function.


         eff_date = today.
			type		= "F".
			line 		= "".
			vsm		= "".
/*G265*/ transtype = "BM".
/*G234*/ if ldbname(1) = "newoem" then site = "oem".
			else 
				if ldbname(1) = "newhk" then site = "hkmfg".
				else site = "prc".
         
			form
/*G234*/    site     validate(can-find(si_mstr where si_site = site and 
								site <>"" ), 
								"SITE MUST EXIST. Please re-enter")
								colon 20 
/*G265*/    si_desc     no-label
				type			validate( index("FfSsUuPp", type) <> 0, 
								"Must be F/S/U/P, Please re-enter") 
								colon 20
/* michael delete begin
            loc     	 	/* validate(can-find(loc_mstr where loc_loc = loc or 
								loc = ""), "Location Must Exist. Please re-enter.") */
								colon 20 
            line     /* validate(can-find(ln_mstr where ln_line = line), 
								"Line Must Exist. Please re-enter") */
								colon 20
				vsm         validate(vsm = "vsm1" or vsm = "vsm2" or
											vsm = "vsm3" or vsm = "", 
											"VSM should be VSM1/VSM2/VSM3/Blank, Please re-enter") colon 20
michael delete end */
            sourcefile  validate(search(sourcefile) <> ?, 
								"File Must Exist. Please re-enter")
								colon 20
				skip(1)
				eff_date    colon 20
         with frame a side-labels width 80 attr-space.


/*K10Y*/ {wbrp02.i}

repeat:
	for each temp-seqmstr:
   	delete temp-seqmstr.
	end.
	for each tblpp:
		delete tblpp.
	end.
            update
               site
					type
					/*
					loc
					line
					vsm
					*/
					sourcefile
					eff_date
            with frame a.


               bcdparm = "".
/*G234*/       {mfquoter.i site   }
               /*
					{mfquoter.i loc    }
               {mfquoter.i line   }
					{mfquoter.i vsm    }
               */
					{mfquoter.i eff_date}

/*GN61*/       find si_mstr where si_site = site  no-lock no-error.
/*GN61*/       if available si_mstr then display si_desc with frame a.
	Case type:
		when "F" then
		assign
			op 	= 910
			op1	= 910
			op3	= 910
			op4	= 910
			op5	= 0
			op6	= 0.
		when "S" then
			assign
				op 	= 100
				op1	= 100
				op3	= 100
				op4	= 100
				op5	= 0
				op6	= 0.
		when "U" then
			assign
				op 	= 110
				op1	= 110
				op3	= 110
				op4	= 110
				op5	= 0
				op6	= 0.
		when "P" then
			assign
				op 	= 130
				op1	= 910
				op3	= 0
				op4	= 999
				op5	= 0
				op6	= 0.
	end.
	/*
	op 	= if type = "F" then 910 else ( if type = "S" then 100 else 200 ).
	op1	= if type = "F" then 999 else ( if type = "S" then 120 else 299 ).
	op3	= if type = "F" then 130 else ( if type = "S" then 0 else 0 ).
	op4	= if type = "F" then 199 else ( if type = "S" then 0 else 0 ).
	op5	= if type = "F" then 910 else ( if type = "S" then 0 else 0 ).
	op6	= if type = "F" then 999 else ( if type = "S" then 0 else 0 ).
	*/
	if search(sourcefile) = ? then do:
  		message "File " sourcefile " not found!!!".
  		pause.
	end.    /* end if search(sourcefile) = ? then do:  */
	else do:    
		INPUT FROM value(sourcefile).
		REPEAT:
  			CREATE temp-seqmstr.
  			IMPORT delimiter "," temp-seqmstr no-error.
		END.
		INPUT CLOSE.
		m_count = 0.
		m_error = 0.

		for each temp-seqmstr:
   		find first pt_mstr where pt_part = tmp_part no-lock no-error.
   		if not available pt_mstr then tmp_code = "ItemNumberNotExist".
			if tmp_vsm <> "vsm1" and tmp_vsm <> "vsm2" and tmp_vsm <> "vsm3" 
			then tmp_code = tmp_code +  "VSMNotExist".
			/*
			find ln_mstr where tmp_line = ln_line no-lock no-error.
			if not available ln_mstr then tmp_code = tmp_code + "LineNotExist".
			find lnd_det where tmp_line = lnd_line and  tmp_part = lnd_part 
			and lnd_start <= m_due_date[1] no-lock no-error.
			if not available lnd_det then tmp_code = tmp_code + "ItemNotDefined".
   		michael*/
			if tmp_code <> "" and tmp_part <> ""  then m_error = m_error + 1.
   		m_count = m_count + 1.
		end.  /* end for each temp-seqmstr where tmp_price = 0 */  
		message "Total Records " m_count " /  Error found" m_error.
		if m_error > 0 then do:
			hide frame a.
			{gprun.i ""ckdisperror""}
			view frame a.
		end.   /* end if m_error > 0 then do: */
      /* SELECT PRINTER */
    	{ckselbpr.i "printer" 126} 
    	{ckphead.i 88 117 126}                   
	if m_count > m_error then do:
		for each temp-seqmstr where (tmp_line = line or line = "") and
			 (vsm = tmp_vsm or vsm = ""):
  			/* 
			assign
				qty 	= tmp_qty_req
				part 	= tmp_part.
			*/	
				{gprun.i ""ckbmpkrp5a.p"" "(input tmp_vsm,
													 input tmp_line,
													 input '',
													 input tmp_part,
                                        input tmp_qty_req, 
													 input op3,
													 input op4,
													 input op5,
													 input op6,
													 input No)"}

		end.  /* for each temp-seqmstr */
		for each tblpp where pp_qty <> 0 use-index pp_part break by pp_part:
			if first-of ( pp_part ) then
			do:
				assign 
					qty  		= 0
					ord_qty 	= 0
					qty_rcv	= 0.
				for each ld_det where ld_site = site and ld_qty_oh > 0 and  
									ld_part = pp_part no-lock use-index ld_part_loc,
					 first loc_mstr where loc_loc = ld_loc and 
								 				 loc_site = site no-lock,
					 first is_mstr where is_status = loc_status and
												is_nettable no-lock:
					case loc_type:
						when "Main Stk" then qty = qty + ld_qty_oh.
						when "RCV Stk"  then qty_rcv = qty_rcv + ld_qty_oh.
						/*
						when "Line Stk" then ord_qty = ord_qty + ld_qty_oh.
						*/
					end.
					/* add beging at 2013.07.18 */
					if ld_loc = pp_line then ord_qty = ord_qty + ld_qty_oh.
					/* add end at 2013.07.18 */
					if  loc_type = "Main Stk" or loc_type = "RCV Stk" then 
					do:
						find first tblld where tmpld_part = pp_part and 
										  tmpld_loc  = ld_loc 
										  no-lock no-error.
						if not available tblld then
						do:
							Find first ckloc_mstr where ckloc_part = pp_part 
								and ckloc_location = ld_loc and ckloc_locator <> "" 
								no-lock no-error. 
							create tblld.
							assign
								tmpld_part 	= pp_part
								tmpld_loc 		= ld_loc
								tmpld_qty_oh	= ld_qty_oh
								tmpld_locator = if available ckloc_mstr then 
								ckloc_locator else "".
						end.
					end.
				end. /* for each ld_det */
				if qty = 0 and qty_rcv = 0 then
				do:
					find first pt_mstr where pt_part = pp_part and pt_site = site
						no-lock no-error.
					if available pt_mstr then loc = pt_loc.
					else loc = "".
					find first tblld where tmpld_part = pp_part and 
										  tmpld_loc  = loc 
										  no-lock no-error.
					if not available tblld then
					do:
						Find first ckloc_mstr where ckloc_part = pp_part 
							and ckloc_location = loc and ckloc_locator <> "" 
							no-lock no-error. 
						create tblld.
						assign
							tmpld_part 		= pp_part
							tmpld_loc 		= loc
							tmpld_qty_oh	= 0
							tmpld_locator = if available ckloc_mstr then 
								ckloc_locator else "".
					end.
				end. /* end if qty = 0 and qty_rev = 0 */
			end. /* if first-of ( pp_part ) */
			else
			do:
				ord_qty = 0.
				for each ld_det where ld_site = site and ld_part = pp_part and
					ld_loc = pp_line no-lock:
					ord_qty = ord_qty + ld_qty_oh.
				end.
			end.
			assign 
				pp_qty_main = qty
				pp_qty_line = ord_qty
				pp_qty_rcv	= qty_rcv.
		end.
		for each tblpp where pp_qty <> 0 use-index pp_part:
			find first tblld where tmpld_part = pp_part and 
				tmpld_qty_oh > tmpld_qty_iss no-lock no-error.
			if not available tblld then
			do:
				find first tblln where pln_part = pp_part and 
									  pln_line = pp_line and pln_vsm = pp_vsm 
									  use-index pln_part no-lock no-error.
				if not available tblln then
				do:
					find first tblld where tmpld_part = pp_part and
						tmpld_qty_oh = tmpld_qty_iss no-lock no-error.
					if available tblld then
					do:
						Find first ckloc_mstr where ckloc_part = pp_part 
									and ckloc_location = tmpld_loc no-lock no-error. 
						create tblln.
						assign
							pln_part 	= pp_part
							pln_loc 		= tmpld_loc
							pln_line		= pp_line
							pln_vsm 		= pp_vsm
							pln_locator = if available ckloc_mstr then 
										  ckloc_locator else "".
					end.
				end.
			end.		/* not available tblld */
			else
			do:
				for each tblld where tmpld_part = pp_part and 
					tmpld_qty_oh > tmpld_qty_iss: 
					qty = min(pp_qty - pp_qty_iss, tmpld_qty_oh - tmpld_qty_iss).
					find first tblln where pln_part = pp_part and 
									  pln_loc  = tmpld_loc and
									  pln_line = pp_line and
									  pln_vsm  = pp_vsm use-index pln_part
									  no-lock no-error.
					if not available tblln then
					do:
						create tblln.
						assign
							pln_part 	= pp_part
							pln_loc 		= tmpld_loc
							pln_line		= pp_line
							pln_vsm		= pp_vsm
							pln_locator = tmpld_locator.
					end.
					assign
						pln_qty_iss	= qty
						tmpld_qty_iss = tmpld_qty_iss + qty
						pp_qty_iss	= pp_qty_iss + qty.
					if pp_qty_main = pp_qty_iss then leave.
				end. /* for each tblld */
			end. /* available tblld */
		end. /* for each tblpp */
		/*michael liu 2013.05.20*/
		
		for each tblln no-lock use-index pln_line, 
			 each tblld where tmpld_part = pln_part and tmpld_loc = pln_loc
				no-lock, 
			 each tblpp where pp_part = tmpld_part and pp_qty <> 0  
				and pp_line = pln_line and pp_vsm = pln_vsm and
				/* michael liu */
				( pp_op = op or pp_op = op1 ) and
				/* michael liu */
				((( pp_promo = "stk" or pp_promo = "vmi" ) and type <> "p" ) or
				 ( pp_promo = "pou" and type = "p" ) or type = "u") and pp_iss_pol
				use-index pp_part 
			 	break by pln_line by pln_locator by pln_part with frame b: 
			if pp_qty = 0 or 
				( pp_promo <> "stk" and pp_promo <> "vmi" and 
					index("PU",type) = 0 ) or
				( pp_promo <> "pou" and type = "P" ) or 
				not pp_iss_pol then next.
			if first-of ( pln_line) and type <> "P"  then 
			do:
      		put skip(1). 
				put "Line: " + pp_line  format "x(40)" skip. 
				/*
				put " Line: " + pln_line format "x(40)" skip.
				put "  VSM: " + pp_vsm   format "x(40)" skip.
				*/
			end.
			accumulate pp_qty ( total by pln_part ).
			if last-of( pln_part ) then
			do:
			/*
				qty = accu pp_qty total by pp_op.
				*/
				display
					pp_line
					pp_part 
            	pp_desc1 
					pp_qty_line
					( accumu total by pln_part pp_qty ) @ pp_qty	
					tmpld_loc	@ ckloc_location
					pln_locator	@ ckloc_locator
					tmpld_qty_oh @ pp_qty_main
					/*
					pp_promo
					*/
					/*
					pln_qty_iss @ pp_qty_iss
            	*/
					with frame b.
				for each tblln1 where tblln1.pln_part = pp_part 
						and tblln1.pln_line = pp_line  
						and tblln.pln_loc <> tblln1.pln_loc 
						and tblln.pln_vsm = tblln1.pln_vsm no-lock, 
					each tblld1 where tmpld_part = tblln1.pln_part 
						and tmpld_loc = tblln1.pln_loc
						no-lock with frame b down:
					down 1 with frame b.
					disp 
						tblln1.pln_loc  @ ckloc_location
						tblln1.pln_locator @ ckloc_locator 
						tmpld_qty_oh @ pp_qty_main
					  	/*
					  	pln_qty_iss @ pp_qty_iss
					  	*/
					  	.
					down 1 with frame b.
					if page-size - line-counter < 2 then
					do:
						page.
						if type <> "P" then
						do:
      					put skip(1). 
							put "Line: " + pp_line format "x(40)" skip.
						end.
						/*
						put "Stock: " + tblln.pln_loc  format "x(40)" skip. 
						put "  VSM: " + pp_vsm   format "x(40)" skip.
						*/
					end.
				end. /* for each tblln1 */
			end. /* if last-of( pp_op ) */
				/**/
				pp_qty = 0.	
				/**/
				if ( ( last-of( pln_line ) and type <> "p" )
					or page-size - line-counter < 2 )
					and not last ( pln_line ) then
				do:
					page.
					if not last-of( pln_line ) and type <> "P" then
      			do:
						put skip(1). 
						put "Line: " + pp_line  format "x(40)" skip. 
					end.
				end.
				else
					put fill("-", 126) format "x(126)" skip.
				{mfrpexit.i "false"}
			end. /*for each tblpp*/

/*G1H5*/    {ckrtrail.i}
/*michael liu 2013.05.20*/
end.  /* end if m_count > m_error then do: */
end.  /* end else do: (find sourcefile file) */    
end. /* repeat */
/*K10Y*/ {wbrp04.i &frame-spec = a}
