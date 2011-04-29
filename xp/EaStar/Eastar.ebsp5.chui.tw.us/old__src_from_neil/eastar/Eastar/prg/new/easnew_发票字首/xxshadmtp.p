/* xxshadmtp.p  -- Shipping Advise Maintenance */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS036A* Apple Tam */
    
    {mfdeclre.i}
{pxgblmgr.i}



/*N0K6*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

{mfdatev.i}



define shared variable sanbr like shah_sanbr.
define shared variable pinbr like shah_pinbr.
define shared variable snnbr like sn_nbr no-undo.
define shared variable shipto3       like snp_shipto     .

define variable notify2 as character format "x(36)" extent 5.		
define variable consignee2 as character format "x(36)" extent 5.		

define variable consignee  like shah_shipto.
define variable notify     like shah_notify  .
define variable etdhk      like shah_etdhk     .

define variable ex_date    like shah_etdhk.    /* micho */

define variable eta        like shah_eta       .
define variable eta_date   like shah_eta_date  .
define variable consig     like shah_consig.
define variable dc-loc     like shah_loc.
define variable desc_line1 like shah_desc_line1.
define variable desc_line2 like shah_desc_line2.
define variable desc_line3 like shah_desc_line3.
define variable desc_line4 like shah_desc_line4.
define variable forwarder  like shah_forwarder format "x(28)" .
define variable container  like shah_container .
define variable method     like shah_method .
define variable method_desc as character format "x(60)".

{xxshadmtp.i}

view frame p1.
view frame p2.
view frame p3.


	  find first shah_hdr where shah_sanbr = sanbr and shah_snnbr = snnbr no-lock no-error.
	  if available shah_hdr then do: 
	  	assign
		       consignee    = shah_shipto     
	  		notify      = shah_notify     
	  		etdhk       = shah_etdhk    
			ex_date     = shah_dte01        /* micho */
	  		eta         = shah_eta        
	  		eta_date    = shah_eta_date  
			consig      = shah_consig
			dc-loc      = shah_loc
	  		desc_line1  = shah_desc_line1 
	  		desc_line2  = shah_desc_line2 
	  		desc_line3  = shah_desc_line3 
	  		desc_line4  = shah_desc_line4 
	  		forwarder   = shah_forwarder  
	  		container   = shah_container  
	  		method      = shah_method     .
         end.
	 else do:
		       assign
		       consignee    = shipto3
	  		notify      = shipto3
	  		etdhk       = today
			ex_date     = today            /* micho */
	  		eta         = ""
	  		eta_date    = today
			consig      = ""
			dc-loc      = ""
	  		desc_line1  = ""
	  		desc_line2  = ""
	  		desc_line3  = ""
	  		desc_line4  = ""
	  		forwarder   = ""
	  		container   = ""
	  		method      = "".
	 end.
	  display
	     consignee  
	     notify     
	     etdhk   
	     ex_date            /* micho */
	     eta        
	     eta_date   
	     consig
	     dc-loc
	     desc_line1 
	     desc_line2 
	     desc_line3 
	     desc_line4 
	     forwarder  
	     container  
	     method     
	     method_desc
	  with frame p3 .


repeat:
          set
	     consignee  
	     notify     
	     etdhk      
             ex_date            /* micho */
	     eta        
	     eta_date   
	     consig
	     dc-loc
	     desc_line1 
	     desc_line2 
	     desc_line3 
	     desc_line4 
	     forwarder  
	     container  
	     method     
	  with frame p3 editing:
	    find first ad_mstr where ad_addr = input consignee no-lock no-error.
	    consignee2 = "".
	    notify2 = "".
	    if available ad_mstr then do:
	        consignee2[1]  = ad_name.
		consignee2[2]  = ad_line1.
		consignee2[3]  = ad_line2.
		consignee2[4]  = ad_city + " " + ad_state + " " + ad_zip.
		consignee2[5]  = ad_country.
	    end.
	    display 
	       consignee2[1]
	       consignee2[2] 
	       consignee2[3] 
	       consignee2[4] 
	       consignee2[5] 
	       with frame p1.
          find first ad_mstr where ad_addr = input notify no-lock no-error.
	  if available ad_mstr then do:
	      notify2[1]  =ad_name.                                
	      notify2[2]  =ad_line1.                               
	      notify2[3]  =ad_line2.                               
	      notify2[4]  =ad_city + " " + ad_state + " " + ad_zip.
	      notify2[5]  =ad_country.                             
	  end.
	  display
	      notify2[1] 
	      notify2[2] 
	      notify2[3] 
	      notify2[4] 
	      notify2[5] 
	  with frame p2.
/****************************/
		      find first ship_mt_mstr where ship_mt_code = input method no-lock no-error.
		      if available ship_mt_mstr then do:
			 if trim(ship_rout_seq1) <> "" then do:
		            method_desc = trim(ship_rout_seq1).
			 end.
			 if trim(ship_rout_seq2) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq2).
			 end.
			 if trim(ship_rout_seq3) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq3).
			 end.
			 if trim(ship_rout_seq4) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq4).
			 end.
			 if trim(ship_rout_seq5) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq5).
			 end.
			 if trim(ship_rout_seq6) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq6).
			 end.
			 if trim(ship_rout_seq7) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq7).
			 end.
			 if trim(ship_rout_seq8) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq8).
			 end.
			 if trim(ship_rout_seq9) <> "" then do:
		            method_desc = method_desc + ">" + trim(ship_rout_seq9).
			 end.
			 if trim(ship_rout_seq10) <> "" then do:
			    method_desc = method_desc + ">" + trim(ship_rout_seq10).
			 end.
		      end.
		      else do:
		         method_desc = "".
		      end.
		      display method_desc with frame p3.
/****************************/

            readkey.
            apply lastkey.
          end. /*with frame p3 editing*/
          find first ad_mstr where ad_addr = notify no-lock no-error.
	  if not available ad_mstr then do:
		         message "Error: Invalid Notify customer code.Please re-enter.".
			 next-prompt notify with frame p3.
			 undo,retry.     
	  end.
		      if consig = "" or consig = "C" or consig = "N" then do: 
		      end.
		      else do:
		         message "Error: Invalid Consignment code.Please re-enter.".
			 next-prompt consig with frame p3.
			 undo, retry.
		      end.
		      if dc-loc = "" or dc-loc = "DC" or dc-loc = "MAIN" then do:
		      end. 
		      else do:
		         message "Error: Invalid DC/Main code.Please re-enter.".
			 next-prompt dc-loc with frame p3.
			 undo,retry.
		      end.
/*	  find first shah_hdr where shah_sanbr = sanbr and shah_snnbr = snnbr no-error.
	  if available shah_hdr then do: 
	     if forwarder <> shah_forwarder or method <> shah_method then do:
		         message "Error: Un-match common data.Please remove SA details changes.".
			 next-prompt forwarder with frame p3.
			 undo,retry.     
	     end.
	  end.*/
	  find first shah_hdr where shah_sanbr = sanbr and shah_snnbr = snnbr no-error.
	  if available shah_hdr then do: 
	  	assign
		shah_shipto     =       consignee  
	  	shah_notify     =	notify     
	  	shah_etdhk      =	etdhk      
		shah_dte01      =       ex_date            /* micho */
	  	shah_eta        =	eta        
	  	shah_eta_date   =	eta_date   
		shah_consig     =       consig
		shah_loc        =       dc-loc
	  	shah_desc_line1 =	desc_line1 
	  	shah_desc_line2 =	desc_line2 
	  	shah_desc_line3 =	desc_line3 
	  	shah_desc_line4 =	desc_line4 
	  	shah_forwarder  =	forwarder  
	  	shah_container  =	container  
	  	shah_method     =	method     .
         end.
  	                  {gprun.i ""xxshadmtb.p""}	
   leave.
end.
hide frame p1 no-pause.
hide frame p2 no-pause.
hide frame p3 no-pause.
