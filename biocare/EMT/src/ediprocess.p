/****************************************/
/* EDI PROCESS                          */
/* 20110629     PROCESS PRE SO          */
/* 20110629     Write Report For SO/PO  */
/* 20110630     Inventory Control       */
/* 20110701     Report                  */
/* 20110702     Inquriry Report         */
/* 20110708     BUG                     */
/* 20110714     Multi-Domain            */
/****************************************/
/* SS - 121211.1 By: Randy Li */
/* SS - 121211.1 RNB
¡¾ 121211.1 ¡¿
1.
¡¾ 121211.1 ¡¿
SS - 121211.1 - RNE */
{mfdtitle.i  "121211.1"}
define variable ciminputfile   as char .
define variable cimoutputfile  as char .
define variable ExistheaderExistdetailForeignC as char.
define variable socmtindx like so_cmtindx.
define variable sodcmtindx like sod_cmtindx.
define variable soprefix as char.
define variable wglobal_userid as char.
define new shared variable menu as character.
define variable usection as char format "x(16)".
define variable usection1 as char format "x(16)".
define variable wrecid  as recid.
define variable wglobal_domain like so_domain.
wglobal_domain = global_domain .
define buffer dommstr for dom_mstr.


/* Create Section Variable END */
repeat :
/* for each dommstr where dommstr.dom_active = yes and  dommstr.dom_type = "EDI" no-lock:
/*        message "DB1" dommstr.dom_domain  "CURR" global_domain. */
	if dommstr.dom_domain <> global_domain then do:
    	      usection1 = "EDIChangeDomain" + trim(dommstr.dom_domain)  .
	      output to value( trim(usection1) + ".iedichangedomain") .
		 put unformat dommstr.dom_domain skip.   
		 put unformat "." skip.   
		 put unformat "." skip.   
	      output close.
	      /* Change the Domain */ 
		batchrun = yes.
		input from value ( usection1 + ".iedichangedomain") .
		output to  value ( usection1 + ".oedichangedomain") .
		{gprun.i ""mgdomchg.p""}     
		input close.
		output close.
		batchrun = no.
	end.
/*        message "DB2" dommstr.dom_domain  "CURR" global_domain. */


*/
	/* AUTO Create SO  START */
	for each edi_hist where  edi_targetdomain = global_domain and edi_type = "ORD-PO" and edi_sucess  = ""  by edi_group :
		ExistheaderExistdetailForeignC ="".
		socmtindx = 0.	
		sodcmtindx = 0. 
		soprefix = "".
		/* SS - 121211.1 - B */
		/*
		find first dom_mstr where dom_mstr.dom_domain = edi_targetdomain no-lock no-error.
		if AVAILABLE(code_mstr) then soprefix = substring ( trim ( dom_mstr.dom_sname ) ,1,2). 
		*/
		find first code_mstr where code_domain = edi_targetdomain  and code_fldname = "SO-DOMSN" and code_value = edi_targetdomain no-lock no-error.
		if AVAILABLE(code_mstr) then soprefix = substring ( trim ( CODE_cmmt ) ,1,2). 
		/* SS - 121211.1 - E */

		usection = "EDI" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
		find first so_mstr where so_domain = global_domain and so_nbr = soprefix +  substring(edi_nbr,3,6) no-lock no-error .
		if AVAILABLE(so_mstr) then do:
		  ExistheaderExistdetailForeignC = "Y".
		  socmtindx = so_cmtindx.
		end.
		else ExistheaderExistdetailForeignC ="N".

		find first sod_det where sod_domain = global_domain and sod_nbr = soprefix +  substring(edi_nbr,3,6) 
				     and sod_line   = edi_line no-lock no-error .
		If AVAILABLE(sod_det) then do:
		   ExistheaderExistdetailForeignC = ExistheaderExistdetailForeignC + "Y".
		   sodcmtindx = sod_cmtindx.
		end.
		else ExistheaderExistdetailForeignC = ExistheaderExistdetailForeignC + "N".

		
		find first gl_ctrl where gl_domain = global_domain and gl_base_curr = edi_curr no-lock no-error.
		if AVAILABLE(gl_ctrl) then ExistheaderExistdetailForeignC = ExistheaderExistdetailForeignC + "N".
		else ExistheaderExistdetailForeignC = ExistheaderExistdetailForeignC + "Y".

		output to value( trim(usection) + ".i") .
		put unformat  soprefix +  substring(edi_nbr,3,6)   format "x(8)" skip .  /* Sales Order */
		
		/* SS - 121211.1 - B */
		/*
		find first en_mstr where en_domain = edi_sourcedomain and en_entity = edi_entity no-lock no-error.
		if AVAILABLE(en_mstr) then PUT  unformat  trim ( en_addr )  skip .
		*/
		find first code_mstr where code_domain = edi_sourcedomain and code_value = edi_entity no-lock no-error.
		if AVAILABLE(code_mstr) then PUT  unformat  trim ( CODE_cmmt )  skip .
		/* SS - 121211.1 - E */		
		put unformat  "-"               skip .
		
		/* SS - 121211.1 - B */
		find first po_mstr where po_domain = edi_sourcedomain and po_nbr = edi_nbr no-lock no-error.
		/* SS - 121211.1 - E */
		if avail (po_mstr) then put unformat  po_ship skip .
		if substring ( ExistheaderExistdetailForeignC,1,1) = "N" then      /* New Header */
		/* SS - 121211.1 - B */
		do:
		find first cm_mstr where cm_domain = edi_sourcedomain and cm_addr = trim ( CODE_cmmt ) no-lock no-error.
		/* SS - 121211.1 - E */
		put unformat  fill("- ",6) + """" +  trim( edi_nbr ) + """"  + " - - - " + cm_site + " - - " format "x(50)" .
		end.
		else do:
		put unformat  fill("- ",6) + """" +  trim( edi_nbr ) + """"  + " - - - - - " format "x(50)" .
		end.
		if substring ( ExistheaderExistdetailForeignC,1,1) = "N"       /* New Header */
		then  put unformat " Y " + edi_curr  skip .
		else  put unformat "-" skip  .

		if substring ( ExistheaderExistdetailForeignC,1,1) = "N" and substring ( ExistheaderExistdetailForeignC,3,1) ="Y" then
		put unformat "-" skip.

		put unformat "-" skip.   /* TAX */
		put unformat "-" skip.   /* SALESPERSON */

		find first soc_ctrl where soc_domain = global_domain no-lock no-error.
		If AVAILABLE(soc_ctrl) then do:
		   if substring ( ExistheaderExistdetailForeignC,1,1) = "Y" and socmtindx <> 0 then put unformat "." skip.

		   if substring ( ExistheaderExistdetailForeignC,1,1) = "N" and soc_hcmmts = yes then put unformat "." skip. 
		end.

		put unformat "." skip.
		put unformat "S" skip.
		put unformat edi_line  skip.
		if  substring ( ExistheaderExistdetailForeignC,2,1) ="N" then 
		put unformat """" + trim ( edi_part ) + """" format "x(20)" skip .
		put unformat "-" skip.            /*Site */
		put unformat edi_qty_ord skip.
		if substring ( ExistheaderExistdetailForeignC,2,1) ="Y" then put unformat "Y" skip.
		else put unformat "-" skip.                 /*Reprice*/
		put unformat edi_price  skip.     
		put unformat "-"        skip.    /* Net Price*/

		if  substring ( ExistheaderExistdetailForeignC,2,1) ="N" then do:
		    put unformat fill("- ",13)  edi_due_date " " edi_due_date skip.
		end.
		else do:
		    put unformat fill("- ",12)  edi_due_date " " edi_due_date skip.

		end.

		find first soc_ctrl where soc_domain = global_domain no-lock no-error.
		If AVAILABLE(soc_ctrl) then do:
		   if substring ( ExistheaderExistdetailForeignC,1,1) = "Y" and sodcmtindx <> 0 then put unformat "." skip.

		   if substring ( ExistheaderExistdetailForeignC,1,1) = "N" and soc_lcmmts = yes then put unformat "." skip. 
		end.
		put unformat "." skip.   /* Line */
		put unformat "." skip.   /* S */
		put unformat "-" skip.   /* Summary */
		put unformat "-" skip.   /* Tailer */
		put unformat "." skip.

		output close.
		wglobal_userid = global_userid.
		global_userid = edi_group.
		global_domain = edi_targetdomain.
		batchrun = yes.
		input from value ( usection + ".i") .
		output to  value ( usection + ".o") .
		{gprun.i ""sosomt.p""}     
		input close.
		output close.
		batchrun = no.
		global_userid = wglobal_userid.
		ciminputfile = usection + ".i".
		cimoutputfile = usection + ".o".
		{ederrlg.i} 
		/* unix silent value ( "rm -f "  + Trim(usection) + ".i").
		unix silent value ( "rm -f "  + Trim(usection) + ".o"). */


		find first sod_det where sod_domain = global_domain and sod_nbr = soprefix +  substring(edi_nbr,3,6) 
				     and sod_line   = edi_line  no-error .
		If AVAILABLE(sod_det) then do:
		   if sod_qty_ord <> edi_qty_ord OR sod_list_pr <> edi_price Then do:
		      edi_sucess = "N". 
		      edi_errormsg = cimoutputfile.   

		   end.
		   else do : 
		     edi_sucess = "Y". 
		     sod_due_date = edi_due_date.
	/*	     if sod_btb_type <> "01" then do:
			find first pod_det where pod_nbr = sod_btb_po and pod_line = sod_btb_pod_line and pod_is_emt = yes no-error.
			if AVAILABLE(pod_det) then pod_due_date = edi_due_date.
		     end.  */
		   end.

		end.
		else do:
		   edi_sucess = "N". 
		   edi_errormsg = cimoutputfile.
		end.

	end.
	/* AUTO Create SO  END  */

	/*  ReWrite the SO Information START */
	define buffer edihist for edi_hist.
	for each edihist where edihist.edi_targetdomain = global_domain and  ( edihist.edi_exposePreSO = ""  OR edihist.edi_exposeNextSO = "" ) and 
			       edihist.edi_type = "ORD-PO" break by edihist.edi_group  :

		find first sod_det where sod_domain = edihist.edi_sourcedomain      
				   and sod_btb_po = edihist.edi_nbr 
				   and sod_btb_type <> "01"
				   and sod_btb_pod_line = edihist.edi_line no-lock no-error.
		if AVAILABLE(sod_det) then do:

			 find first so_mstr where so_domain = edihist.edi_sourcedomain
					      and so_nbr    = sod_nbr no-lock no-error.

			 if AVAILABLE(so_mstr) and edihist.edi_exposePreSO = "" then do:
			    create	edi_hist.
			    edi_hist.edi_nbr		= so_nbr.         
			    edi_hist.edi_line		= sod_line.     
			    edi_hist.edi_sourcedomain	= edihist.edi_sourcedomain .
			    edi_hist.edi_group		= string ( decimal ( edihist.edi_group )  - 1 ).
			    edi_hist.edi_entity          = edihist.edi_entity.
			    edi_hist.edi_site            = sod_site.
			    edi_hist.edi_userid          = edihist.edi_userid.
			    edi_hist.edi_type            = "ORD-SO".
			    edi_hist.edi_addr            = so_cust.
			    edi_hist.edi_part            = edihist.edi_part.
			    edi_hist.edi_curr            = so_curr.
			    edi_hist.edi_action          = edihist.edi_action.
			    edi_hist.edi_qty_ord         = sod_qty_ord.
			    edi_hist.edi_due_date        = sod_due_date.
			    edi_hist.edi_price           = sod_list_pr.
			    edi_hist.edi_time            = edihist.edi_time.
			    edi_hist.edi_Sucess          = "Y".

			    edihist.edi_exposePreSO      = "Y" .
			 end. /* if AVAILABLE(so_mstr) */
		end. /* if AVAILABLE(sod_det) then do: */
		else edihist.edi_exposePreSO             = "N" .

		/* Write SO Information  NEXT */
		/* SS - 121211.1 - B */
		/*
		find first dom_mstr where dom_mstr.dom_domain = edihist.edi_targetdomain no-lock no-error.
		if AVAILABLE(dom_mstr) then soprefix = substring ( trim ( dom_mstr.dom_sname ) ,1,2).
		*/
		find first code_mstr where code_domain = edi_targetdomain  and code_fldname = "SO-DOMSN" and code_value = edi_targetdomain no-lock no-error.
		if AVAILABLE(code_mstr) then soprefix = substring ( trim ( CODE_cmmt ) ,1,2).
		/* SS - 121211.1 - E */

		find first sod_det where sod_domain = edihist.edi_targetdomain      
				   and sod_nbr    =   soprefix +  substring(edihist.edi_nbr,3,6)
				   and sod_btb_po = "" and sod_line = edihist.edi_line no-lock no-error.
		if AVAILABLE(sod_det) then do:

			 find first so_mstr where so_domain = edihist.edi_targetdomain
					      and so_nbr    = sod_nbr no-lock no-error.
			 if AVAILABLE(so_mstr) and edihist.edi_exposeNextSO = "" then do:
			    create	edi_hist.
			    edi_hist.edi_nbr		= so_nbr.         
			    edi_hist.edi_line		= sod_line.     
			    edi_hist.edi_sourcedomain	= edihist.edi_targetdomain .
			    edi_hist.edi_group		= string ( decimal ( edihist.edi_group )  + 1 ).
			    edi_hist.edi_entity          = sod_site.
			    edi_hist.edi_site            = sod_site.
			    edi_hist.edi_userid          = edihist.edi_userid.
			    edi_hist.edi_type            = "ORD-SO".
			    edi_hist.edi_addr            = so_cust.
			    edi_hist.edi_part            = edihist.edi_part.
			    edi_hist.edi_curr            = so_curr.
			    edi_hist.edi_action          = edihist.edi_action.
			    edi_hist.edi_qty_ord         = edihist.edi_qty_ord.
			    edi_hist.edi_due_date        = edihist.edi_due_date.
			    edi_hist.edi_price           = edihist.edi_price.
			    edi_hist.edi_time            = edihist.edi_time.
			    edi_hist.edi_Sucess          = "Y".

			    edihist.edi_exposeNextSO     = "Y" .

			 end. /* if AVAILABLE(so_mstr) then do: */
			 else  edihist.edi_exposeNextSO  = "E" .   /* E for ERROR */
		end. /* if AVAILABLE(sod_det) then do: */

	end.   /* for each edihist where edihist.edi_targetdomain */
	/*  ReWrite the SO Information END */

     
	/* Inventory  PO Auto-Receipt  START */
	for each edi_hist where  edi_targetdomain = global_domain and edi_type = "ISS-SO" and edi_sucess  = ""  by edi_group :
		find first po_mstr where po_domain  = edi_targetdomain and po_nbr = edi_receiptPO  no-lock no-error.
		find first pod_det where pod_domain = edi_targetdomain and pod_nbr = edi_receiptPO and pod_line = edi_line no-lock no-error.
		if AVAILABLE (po_mstr) and AVAILABLE (pod_det) then do:
			usection = "edireceipt" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
			output to value( trim(usection) + ".iShipperCreat") .
			
				PUT unformat  trim ( po_vend )  "  "  edi_trnbr skip .
				PUT unformat   trim ( pod_site) skip . 
				put unformat "." skip.
				put unformat " - " edi_receiptPO  " " edi_line skip.
				put unformat -1 * edi_transQty  " - - - " .
				if not po_is_btb then put unformat " - " .
				put unformat edi_translot + " " + edi_transref  format "x(40)" skip.
				put unformat "." skip.
				put unformat "." skip.

			output close.
			/*Create PO Shipper  START */
			wglobal_userid = global_userid.
			global_userid = edi_group.
			batchrun = yes.
			input from value ( usection + ".iShipperCreat") .
			output to  value ( usection + ".oShipperCreat") .
			{gprun.i ""rsshmt.p""}     
			input close.
			output close.
			batchrun = no.
			global_userid = wglobal_userid.
			ciminputfile = usection + ".iShipperCreat".
			cimoutputfile = usection + ".oShipperCreat".
			/*Create PO Shipper  END */

			/*PO Shipper  CONFIRM START */



			output to value( trim(usection) + ".iShipperConfirm") .
			
				find first en_mstr where en_domain = edi_sourcedomain and en_entity = edi_entity no-lock no-error.
				/* SS - 121211.1 - B */
				/*
				if AVAILABLE(en_mstr) then PUT  unformat  trim ( en_addr )  "  "  edi_trnbr skip .
				*/
				if AVAILABLE(po_mstr) then PUT  unformat  trim ( po_vend )  "  "  edi_trnbr skip .
				/* SS - 121211.1 - E */
				put unformat "-" skip . 
				put unformat "Y" skip.
				put unformat "." skip.

			output close.

			wglobal_userid = global_userid.
			global_userid = edi_group.
			batchrun = yes.
			input from value ( usection + ".iShipperConfirm") .
			output to  value ( usection + ".oShipperConfirm") .
			{gprun.i ""rsporc.p""}     
			input close.
			output close.
			batchrun = no.
			global_userid = wglobal_userid.
			ciminputfile = usection + ".iShipperConfirm".
			cimoutputfile = usection + ".oShipperConfirm".
			/*PO Shipper  CONFIRM END */


			/* {ederrlg.i}   SAMSAMSAMSAM*/
			/* unix silent value ( "rm -f "  + Trim(usection) + ".i").
			unix silent value ( "rm -f "  + Trim(usection) + ".o"). */

			find first tr_hist where tr_domain = global_domain and 
						 tr_userid = edi_group and tr_type = "RCT-PO"  and
						 tr_nbr     = edi_receiptPO     and tr_line = edi_line  and
						 tr_qty_loc = edi_transQty * -1 no-lock  no-error .
			If AVAILABLE(tr_hist) then do:
			     edi_sucess = "Y". 
			end.
			else do:
			   edi_sucess = "N". 
			   edi_errormsg = cimoutputfile.
			end.
		end. /* if AVAILABLE (po_mstr) then do: */
	end.
	/* Inventory  PO Auto-Receipt  END */

	/* Rewrite PO Receipt  Data TO edi_hist  START */
	for each edihist where edihist.edi_targetdomain = global_domain and edihist.edi_exposeNextSO = ""  and 
			       edihist.edi_type = "ISS-SO" break by edihist.edi_group  :

		find first tr_hist where tr_domain = global_domain and 
					 tr_userid = edihist.edi_group and tr_type = "RCT-PO"  and
					 tr_nbr     = edihist.edi_receiptPO     and tr_line = edihist.edi_line  and
					 tr_qty_loc = edihist.edi_transQty * -1 no-lock  no-error .
		if AVAILABLE(tr_hist) then do:

			     /* CREATE EDI , RECEIPT DATA  START */
			     create edi_hist.
				    edi_hist.edi_nbr	= edihist.edi_receiptPO.
				    edi_hist.edi_line    = edihist.edi_line.            
				    edi_hist.edi_sourcedomain  = global_domain.
				    edi_hist.edi_group   = string ( decimal (edihist.edi_group) + 1 ) .
				    edi_hist.edi_trnbr   = tr_trnbr.
				    find first si_mstr where si_domain = global_domain and si_site = tr_site no-lock no-error.
				    if AVAILABLE(si_mstr) then edi_hist.edi_entity  = si_entity.
				    edi_hist.edi_site    = tr_site.            
				    edi_hist.edi_userid  = edihist.edi_group .            
				    edi_hist.edi_type    = "RCT-PO" .            
				    edi_hist.edi_addr    = tr_addr.            
				    edi_hist.edi_part    = tr_part.            
				    edi_hist.edi_curr    = tr_curr.            
				    edi_hist.edi_action  = "NEW".            
				    edi_hist.edi_due_date = tr_effdate .           
				    edi_hist.edi_price    = tr_price.               
				    edi_hist.edi_time     = time.           
				    edi_hist.edi_Sucess   = "Y".           
				    edi_hist.edi_TransLoc = tr_loc.            
				    edi_hist.edi_Translot = tr_serial.           
				    edi_hist.edi_Transref = tr_ref.           
				    edi_hist.edi_TransQty = tr_qty_loc.           

				   edihist.edi_exposeNextSO      = "Y" .
		end. /* if AVAILABLE(tr_hist) then do: */
		else edihist.edi_exposeNextSO             = "N" .

	end.   /* for each edihist where edihist.edi_targetdomain = global_domain and edihist.edi_exposeNextSO = ""  and  */
	/* Rewrite PO Receipt  Data TO edi_hist  END */

/* end. /* for each do_mstr where dom_active = yes no-lock: */ */

pause 2.

end. /* repeat  */