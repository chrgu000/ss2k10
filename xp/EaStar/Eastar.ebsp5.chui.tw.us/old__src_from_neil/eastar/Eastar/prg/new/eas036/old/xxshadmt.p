/* xxshntmt.p  -- Shipping Notes Maintenance */
/* REVISION: eb SP5 create 02/10/04 BY: *EAS036A* Ricky Ho */
/* REVISION: eb SP5 create 04/20/04 BY: *EAS036A* Apple Tam */

{mfdtitle.i "sp5 "}

define new shared variable sanbr like shah_sanbr.
define new shared variable pinbr like shah_pinbr.
define new shared variable snnbr like sn_nbr no-undo.
define variable m as char format "x(9)".
define variable m2 as char format "x(4)".
define variable k as integer.
define variable del-yn like mfc_logical initial no.
define new shared variable con-yn like mfc_logical initial no.
define new shared variable total_ctn     like shah_ttl_ctn    .
define new shared variable total_plt     like shah_ttl_plt  .
define new shared variable total_qty     like sn_total_qty    .
define new shared variable total_grosswt like sn_total_grosswt.
define new shared variable total_cbm     like sn_total_cbm    .

define new shared variable sqnbr    as integer format ">>9".
define new shared variable pltnbr   like snh_plt_nbr.
define new shared variable sonbr    like so_nbr.
define new shared variable part3    like snh_part.
define new shared variable desc1    like pt_desc1.
define new shared variable desc2    like pt_desc2.
define new shared variable destin   like snh_destin.
define new shared variable consign  like snh_ctn_consign.
define new shared variable loc      like snh_loc.
define new shared variable type     like snh_type.
define new shared variable ship_via as logical format "A/S".
define new shared variable po1      like snh_po format "x(20)".
define new shared variable method   like snh_method.
define new shared variable modesc   as character format "x(62)".
define new shared variable forw     like snh_forwarder format "x(28)".
define new shared variable ref      like snh_reference.

define new shared variable ctn_line      as integer format ">>9".
define new shared variable ctnnbr_fm     like snd_ctnnbr_fm.
define new shared variable ctnnbr_to     like snd_ctnnbr_to.
define new shared variable ctn_qty       as integer format ">,>>9".       
define new shared variable qtyper        as integer format ">,>>>,>>9".   
define new shared variable ext_qty       as decimal format ">,>>>,>>9.9<".
define new shared variable netwt         as decimal format ">,>>9.99".    
define new shared variable ext_netwt     as decimal format ">,>>>,>>9.9<".
define new shared variable grosswt       as decimal format ">>,>>9.99".   
define new shared variable ext_grosswt   as decimal format ">,>>>,>>9.9<".
define new shared variable length        as decimal format ">>9.9".       
define new shared variable height        as decimal format ">>9.9".       
define new shared variable width         as decimal format ">>9.9".       
define new shared variable cbm           as decimal format ">>,>>9.9<<".  
define new shared variable p_ext_grosswt   as decimal format ">,>>>,>>9.9<".
define new shared variable p_length        as decimal format ">>9.9".       
define new shared variable p_height        as decimal format ">>9.9".       
define new shared variable p_width         as decimal format ">>9.9".       
define new shared variable p_cbm           as decimal format ">>,>>9.9<<".  


define new shared variable shipto3       like snp_shipto     .
define new shared variable nbr3          like snp_nbr        .
define new shared variable ext_grosswt3  like snp_ext_grosswt.
define new shared variable length3       like snp_length     .
define new shared variable height3       like snp_height     .
define new shared variable width3        like snp_width      .
define new shared variable cbm3          like snp_cbm        .


define new shared variable snnbr2 like sn_nbr no-undo.
define new shared variable sndate2 like sn_date no-undo.
define new shared variable sntime2 like sn_time no-undo.
define new shared variable snwk2  like sn_ship_wk no-undo.
define new shared variable part2 like snd_part no-undo.
define new shared variable order2 like snd_so_order no-undo.
define new shared variable ext_qty2 like snd_ext_qty no-undo.
define variable i as integer.

define new shared temp-table xxln_tmp
                field xxln_sq_nbr        as integer format ">>9"
                field xxln_ctn_line      as integer format ">>9"
		field xxln_ctnnbr_fm     like snd_ctnnbr_fm 
		field xxln_ctnnbr_to     like snd_ctnnbr_to     
		field xxln_ctn_qty       like snd_ctn_qty      
		field xxln_qtyper        like snd_qtyper        
		field xxln_ext_qty       like snd_ext_qty       
		field xxln_netwt         like snd_netwt        
		field xxln_ext_netwt     like snd_ext_netwt     
		field xxln_grosswt       like snd_grosswt      
		field xxln_ext_grosswt   like snd_ext_grosswt   
		field xxln_length        like snd_ctn_length    
		field xxln_height        like snd_ctn_height    
		field xxln_width         like snd_ctn_width     
		field xxln_cbm           like snd_cbm
		field xxln_pext_grosswt   like snd_ext_grosswt   
		field xxln_plength        like snd_ctn_length    
		field xxln_pheight        like snd_ctn_height    
		field xxln_pwidth         like snd_ctn_width     
		field xxln_pcbm           like snd_cbm
               index xxln_line IS PRIMARY UNIQUE xxln_sq_nbr xxln_ctn_line ascending
		. 


define new shared temp-table  xxsq2_tmp
		field xxsq2_flag		as character format "x(1)" 
		field xxsq2_sel		as character format "x(1)" 
        field xxsq2_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
		field xxsq2_plt_nbr  like snh_plt_nbr
		field xxsq2_shipto   like snh_shipto  
		field xxsq2_ponbr	like shad_ponbr
		field xxsq2_part     like snh_part    
		field xxsq2_ctnnbr_fm like shad_ctnnbr_fm
		field xxsq2_ctnnbr_to like shad_ctnnbr_to
		field xxsq2_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
        index xxsq2_nbr IS PRIMARY UNIQUE xxsq2_sq_nbr ascending
		.
define new shared temp-table  xxsq_tmp
                field xxsq_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
		field xxsq_plt_nbr  like snh_plt_nbr
		field xxsq_so_order like snh_so_order
		field xxsq_shipto   like snh_shipto  
		field xxsq_part     like snh_part    
		field xxsq_qty_open like sod_qty_ord format ">,>>>,>>9.9<"
		field xxsq_part_um  like snh_part_um 
		field xxsq_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
        index xxsq_nbr IS PRIMARY UNIQUE xxsq_sq_nbr ascending
		.

DEFINE VARIABLE doc_recid as recid.


form
   sanbr	  colon 18 label "SA"
   pinbr	  colon 45 label "PI"
   snnbr          colon 60
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

	   sanbr = "".
	   pinbr = "".
	   snnbr = "".

    mainloop:
    repeat on error undo, retry:  
        view frame a.
       i = 1.
       update 
          sanbr 
        with frame a editing:
           {mfnp.i shah_hdr sanbr shah_sanbr sanbr shah_sanbr shah_sanbr}
             if recno <> ? then do:
                assign

		   sanbr     = shah_sanbr
		   snnbr	 = shah_snnbr
		   pinbr	 = shah_pinbr.
		
		display 
		    sanbr
			pinbr
		    snnbr    
		    with frame a.
	     end. /* if recno<>? */
	end.  /*with frame a eiting:*/
            
	    find first shah_hdr where shah_sanbr = sanbr no-error.
	    if available shah_hdr then do:
                assign
		   sanbr     = shah_sanbr
		   snnbr	= shah_snnbr
		   pinbr	= shah_pinbr.
	    end.
		
		
	    if not available shah_hdr and sanbr <> "" then do:
	        message "Error: Invalid SA Number.Please re-enter".
			undo, retry.
	    end.


		display sanbr pinbr snnbr with frame a.
/*		FIND first shad_det where shad_sanbr = shah_sanbr NO-ERROR.
		if available shad_det then snnbr = shad_snnbr.
*/
              snloop:
              repeat on endkey undo mainloop, retry:
		update snnbr with frame a.
	    	find first shah_hdr where shah_sanbr = sanbr no-error.
	    	if available shah_hdr then do:
                      if shah_snnbr <> snnbr and snnbr <> "" then do:
			message "Error: Invalid SN. Please re-enter".
			next-prompt snnbr with frame a.
			undo,retry.
		      end.
	    	end.

		FIND first sn_hdr where sn_nbr = snnbr no-lock NO-ERROR.
		IF not available sn_hdr THEN
		DO:
		     if snnbr <> "" then do:
			message "Error: Invalid SN. Please re-enter".
			next-prompt snnbr with frame a.
			undo,retry.
		     end.
/*		     else do:
		         {gprun.i ""xxshadmtb.p""}	
		     end.*/
		END.
		else do:
			IF sn_status = "D" THEN
			DO:
				message "Error: SN already deleted. Please re-enter".
				next-prompt snnbr with frame a.
				undo,retry.
			END.
			else IF not sn_confirm THEN
			DO:
				message "Error: Un-confirmed SN. Please re-enter".
				next-prompt snnbr with frame a.
				undo,retry.
			END.
		end.

/****************************************************************************************/
		for each xxsq2_tmp:
		    delete xxsq2_tmp.
		end.

			for each shad_det where shad_sanbr = sanbr 
					    and shad_snnbr = snnbr 
					    and shad_line > 0
					    break by shad_sq:
			   if last-of(shad_sq) then do:
				create xxsq2_tmp.
				assign
					xxsq2_sel		= "Y"
					xxsq2_sq_nbr		= shad_sq
					xxsq2_plt_nbr	= shad_plt_nbr
					xxsq2_shipto		= shad_shipto
					xxsq2_ponbr		= shad_ponbr
					xxsq2_part		= shad_part.
               end.
			END.

		FOR EACH snd_ctn_det where snd_sn_nbr = snnbr and snd_ctn_status <> "D" and 
				(snd_sanbr = "" or snd_sanbr = sanbr) no-lock break by snd_sq_nbr :
			FIND first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = snd_sq_nbr and snh_ctn_status <> "D" NO-ERROR.
				FIND first xxsq2_tmp where xxsq2_sq_nbr = snd_sq_nbr NO-ERROR.
				if not available xxsq2_tmp then do:
				   if last-of(snd_sq_nbr) then do:
					create xxsq2_tmp.
					assign 
						xxsq2_sel		= " "
						xxsq2_sq_nbr		= snd_sq_nbr
						xxsq2_plt_nbr	= snd_plt_nbr
						xxsq2_shipto		= snd_shipto
						xxsq2_ponbr		= snh_po when available snh_ctn_hdr
						xxsq2_part		= snd_part.
				   end.
				end.

		END.
        find first xxsq2_tmp no-error.
	    if not available xxsq2_tmp then do:
           message "".
			next-prompt snnbr with frame a.
			undo,retry.
        end.
/****************************************************************************************/
		leave.
	    end. /*repeat*/
	    if sanbr = "" and snnbr <> "" then do transaction:

		   find first doc_nbr_ctl where doc_type = "SA" and doc_year = string(year(today))   
	                 no-lock no-error.
	            if available doc_nbr_ctl then 
				doc_recid = recid(doc_nbr_ctl).
				else do:
					create doc_nbr_ctl.
					doc_recid = recid(doc_nbr_ctl).
				end.

				FIND doc_nbr_ctl where recid(doc_nbr_ctl) = doc_recid exclusive-lock NO-ERROR.
		        assign
		          doc_sn_last = doc_sn_last + 1
				  doc_year = string(year(today))
			      doc_type = "SA".
                  m = "".
		          m = fill("0",5 - length(string(doc_sn_last))).
		          m = m + string(doc_sn_last).
		          sanbr = "Y" +  substr(doc_year,3,2) + m.
				  pinbr = "1" +  substr(doc_year,3,2) + m.

			release doc_nbr_ctl.
/*0824*********************************************/
			FIND first shah_hdr where shah_sanbr = sanbr NO-ERROR.
			IF not available shah_hdr THEN do:
				create shah_hdr.
				assign shah_sanbr	= sanbr
				       shah_pinbr	= pinbr
					   shah_snnbr	= snnbr.
		        end.
/*0824*********************************************/

        end.
		display sanbr pinbr with frame a.


             if snnbr <> "" then do:
		{gprun.i ""xxshadmta.p""}
	     end.
	     else do:
	         {gprun.i ""xxshadmtb.p""}	
	     end.


/*END.*/

HIDE FRAME w NO-PAUSE.

    end. /*mainloop*/
  
            status input.
