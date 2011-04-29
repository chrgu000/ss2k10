/* xxshadmte.p  -- Shipping Advise Maintenance */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS036A* Apple Tam */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable sanbr like shah_sanbr.
define shared variable pinbr like shah_pinbr.
define shared variable snnbr like sn_nbr no-undo.

define shared variable total_ctn     like shah_ttl_ctn    .
define shared variable total_plt     like shah_ttl_plt  .
define shared variable total_qty     like sn_total_qty    .
define shared variable total_grosswt like sn_total_grosswt.
define shared variable total_cbm     like sn_total_cbm    .

define shared variable sqnbr    as integer format ">>9".
define shared variable pltnbr   like snh_plt_nbr.
define shared variable sonbr    like so_nbr.
define shared variable part3    like snh_part.
define shared variable desc1    like pt_desc1.
define shared variable desc2    like pt_desc2.
define shared variable destin   like snh_destin.
define shared variable consign  like snh_ctn_consign.
define shared variable loc      like snh_loc.
define shared variable type     like snh_type.
define shared variable ship_via as logical format "A/S".
define shared variable po1      like snh_po format "x(20)".
define shared variable method   like snh_method.
define shared variable modesc   as character format "x(62)".
define shared variable forw     like snh_forwarder format "x(28)".
define shared variable ref      like snh_reference.

define shared variable ctn_line      as integer format ">>9".
define shared variable ctnnbr_fm     like snd_ctnnbr_fm.
define shared variable ctnnbr_to     like snd_ctnnbr_to.
define shared variable ctn_qty       as integer format ">,>>9".       
define shared variable qtyper        as integer format ">,>>>,>>9".   
define shared variable ext_qty       as decimal format ">,>>>,>>9.9<".
define shared variable netwt         as decimal format ">,>>9.99".    
define shared variable ext_netwt     as decimal format ">,>>>,>>9.9<".
define shared variable grosswt       as decimal format ">>,>>9.99".   
define shared variable ext_grosswt   as decimal format ">,>>>,>>9.9<".
define shared variable length        as decimal format ">>9.9".       
define shared variable height        as decimal format ">>9.9".       
define shared variable width         as decimal format ">>9.9".       
define shared variable cbm           as decimal format ">>,>>9.9<<".  
define shared variable p_ext_grosswt   as decimal format ">,>>>,>>9.9<".
define shared variable p_length        as decimal format ">>9.9".       
define shared variable p_height        as decimal format ">>9.9".       
define shared variable p_width         as decimal format ">>9.9".       
define shared variable p_cbm           as decimal format ">>,>>9.9<<".  

/*define shared variable shipto3       like snp_shipto     .
define shared variable nbr3          like snp_nbr        .
define shared variable ext_grosswt3  like snp_ext_grosswt.
define shared variable length3       like snp_length     .
define shared variable height3       like snp_height     .
define shared variable width3        like snp_width      .
define shared variable cbm3          like snp_cbm        .

define shared variable snnbr2 like sn_nbr no-undo.
define shared variable sndate2 like sn_date no-undo.
define shared variable sntime2 like sn_time no-undo.
define shared variable snwk2  like sn_ship_wk no-undo.
define shared variable part2 like snd_part no-undo.
define shared variable order2 like snd_so_order no-undo.
define shared variable ext_qty2 like snd_ext_qty no-undo.*/
define variable extqty3 like snd_ext_qty no-undo.

define shared variable con-yn like mfc_logical initial no.
define variable del-yn2 like mfc_logical initial no.
define variable del-yn3 like mfc_logical initial no.
define variable go-yn like mfc_logical initial no.
define variable sh-yn like mfc_logical initial yes.
define new shared variable shipto2 like so_ship.
define variable via as char format "x(1)".
define variable um2 like sod_um.
define new shared frame a2.
define new shared frame e.

define variable m as integer.
define variable m2 as integer.
define shared variable sq3    as integer format ">>9".

define shared temp-table xxln_tmp
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


define shared temp-table  xxsq_tmp
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

      {xxshadmtc.i}

view frame a2.
view frame e.


   do transaction on error undo, retry:
   sqloop:
   repeat:

	     find first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = sqnbr no-error.
	     if available snh_ctn_hdr then do:
		  assign
		   sqnbr       = snh_sq_nbr
		   pltnbr      = snh_plt_nbr
		   sonbr       = snh_so_order
		   part3       = snh_part
		   desc1       = snh_part_desc1 
		   desc2       = snh_part_desc2 
		   destin      = snh_destin
		   consign     = snh_ctn_consign
		   loc         = snh_loc
		   type        = snh_type
		   ship_via    = if snh_ship_via = "A" then yes else no
		   po1         = snh_po
		   method      = snh_method
		   forw        = snh_forwarder
		   ref         = snh_reference.
	           display 		   
		       sqnbr
		       pltnbr    
		       sonbr     
		       part3     
		       destin    
		       consign   
		       loc       
		       type      
		       ship_via  
		       po1       
		       method    
		       forw      
		       ref   
		       desc1
		       desc2
		       modesc
		       with frame a2.
	     end.
        update 
	/*sqnbr 
	pltnbr  
	sonbr   
	part3   */
     	destin  
	consign 
	loc     
	type    
	ship_via
	po1     
	method  
	forw    
	ref     
	 with frame a2 editing:

		      
		      if frame-field = "sonbr" and method = "" then do:
		      find first so_mstr where so_nbr = sonbr no-lock no-error.
		      if available so_mstr then do:
		         shipto2 = so_ship.
		         find first custship_mstr where custship_code = so_ship no-lock no-error.
			 if available custship_mstr then do:
			     method = custship_method.
			 end.
			 else do:
			     method = "".
			 end.
		      end.
		         display method with frame a2.
		      end.
		      
		      find first ship_mt_mstr where ship_mt_code = input method no-lock no-error.
		      if available ship_mt_mstr then do:
			 if trim(ship_rout_seq1) <> "" then do:
		            modesc = trim(ship_rout_seq1).
			 end.
			 if trim(ship_rout_seq2) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq2).
			 end.
			 if trim(ship_rout_seq3) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq3).
			 end.
			 if trim(ship_rout_seq4) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq4).
			 end.
			 if trim(ship_rout_seq5) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq5).
			 end.
			 if trim(ship_rout_seq6) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq6).
			 end.
			 if trim(ship_rout_seq7) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq7).
			 end.
			 if trim(ship_rout_seq8) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq8).
			 end.
			 if trim(ship_rout_seq9) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq9).
			 end.
			 if trim(ship_rout_seq10) <> "" then do:
			    modesc = modesc + ">" + trim(ship_rout_seq10).
			 end.
		      end.
		      else do:
		         modesc = "".
		      end.
		      if input pltnbr <> 0 then do:
		         type = "P" .
		       end.
		       else do:
		           type = "C".
		       end.
/*		       find first ptship_mstr where ptship_part = input part3 and ptship_meas_type = input type no-lock no-error.
		       if available ptship_mstr then do:
		          if ptship_via = "A" then ship_via = yes .
			  if ptship_via = "S" then ship_via = no.
		       end.
*/
		    display modesc /*method*/ type /*ship_via*/ with frame a2.
            
            readkey.
            apply lastkey.
     end. /*with frame a2 editing*/
		      if pltnbr <> 0 then do:
			 type = "P".
			 display type with frame a2.
		      end.

		      find first so_mstr where so_nbr = sonbr no-lock no-error.
		      if available so_mstr then do:
		         shipto2 = so_ship.
		         find first custship_mstr where custship_code = so_ship no-lock no-error.
			 /*if available custship_mstr then do:
			     method = custship_method.
			     run dispdesc.			     
			 end.
			 else do:
			     method = "".
			 end.*/
			     display method modesc with frame a2.
			 find first sod_det where sod_nbr = so_nbr and sod_part = part3 no-lock no-error.
			 um2 = "".
			 if available sod_det then do:
			    um2 = sod_um.
			 end.
		      end.
		      
		      if method <> "" then do:
		         find first custship_mstr where custship_code = shipto2 and custship_method = method no-lock no-error.
			 if not available custship_mstr then do:
		         message "Error: Invalid Ship Method.Please re-enter.". 
			 next-prompt method with frame a2.
			 undo, retry.
			 end.
		      end.

		      if consign = "" or consign = "C" or consign = "N" then do: 
		      end.
		      else do:
		         message "Error: Invalid Consignment code.Please re-enter.".
			 next-prompt consign with frame a2.
			 undo, retry.
		      end.
		      if loc = "" or loc = "DC" or loc = "MAIN" then do:
		      end. 
		      else do:
		         message "Error: Invalid DC/Main code.Please re-enter.".
			 next-prompt loc with frame a2.
			 undo,retry.
		      end.
		      if type = "C" and pltnbr <> 0 then do:
		         message "Error: Invalid Type code.Please re-enter.".
			 next-prompt type with frame a2.
			 undo,retry.
		      end.
		      if type = "C" or type = "P" then do:
		      end.
		      else do:
		         message "Error: Invalid Type code.Please re-enter.".
			 next-prompt type with frame a2.
			 undo,retry.
		      end.
		      find first ship_mt_mstr where ship_mt_code = method no-lock no-error.
		      if not available ship_mt_mstr then do:
		         message "Error: Invalid Method code.Please re-enter.".
			 next-prompt method with frame a2.
			 undo,retry.
		      end.
		      if forw = "" then do :
		         message "Error: Forwarder cannot be BLANK.Please re-enter.".
			 next-prompt forw with frame a2.
			 undo,retry.
		      end.

	           display 		  
/*		       sqnbr*/
		       pltnbr    
		       sonbr     
		       part3     
		       destin    
		       consign   
		       loc       
		       type      
		       ship_via  
		       po1       
		       method    
		       forw      
		       ref   
		       desc1
		       desc2
		       modesc
		       with frame a2.


	       extqty3 = 0.
	       for each sod_det where sod_nbr = sonbr and sod_part = part3 no-lock:
	           extqty3 = extqty3 + sod_qty_ord - sod_qty_ship.
	       end.
	 
	 find first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = sqnbr no-error.
	 if available snh_ctn_hdr then do:
	    assign
	    snh_sn_nbr      = snnbr
	    snh_part_desc1  = desc1
	    snh_part_desc2  = desc2
	    snh_last_user   = global_userid
	    snh_last_date   = today
	    snh_shipto      = shipto2
	    snh_part_um     = um2
	    snh_qty_open    = extqty3
	    snh_sq_nbr      = sqnbr     
	    snh_plt_nbr     = pltnbr    
	    snh_so_order    = sonbr     
	    snh_part        = part3     
	    snh_destin      = destin    
	    snh_ctn_consign = consign   
	    snh_loc         = loc       
	    snh_type        = type      
	    snh_ship_via    = if ship_via then "A" else "S"
	    snh_po          = po1       
	    snh_method      = method    
	    snh_forwarder   = forw      
	    snh_reference   = ref       .
	 end.


/*  hide frame a2 no-pause.*/

/*       leave.*/
             {gprun.i ""xxshadmt1.p""}
   end.  /*repeat lineloop*/
     end. /*do transaction*/

hide frame a2 no-pause.
hide frame e no-pause.

PROCEDURE dispdesc :
		      find first ship_mt_mstr where ship_mt_code = method no-lock no-error.
		      if available ship_mt_mstr then do:
			 if trim(ship_rout_seq1) <> "" then do:
		            modesc = trim(ship_rout_seq1).
			 end.
			 if trim(ship_rout_seq2) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq2).
			 end.
			 if trim(ship_rout_seq3) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq3).
			 end.
			 if trim(ship_rout_seq4) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq4).
			 end.
			 if trim(ship_rout_seq5) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq5).
			 end.
			 if trim(ship_rout_seq6) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq6).
			 end.
			 if trim(ship_rout_seq7) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq7).
			 end.
			 if trim(ship_rout_seq8) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq8).
			 end.
			 if trim(ship_rout_seq9) <> "" then do:
		            modesc = modesc + ">" + trim(ship_rout_seq9).
			 end.
			 if trim(ship_rout_seq10) <> "" then do:
			    modesc = modesc + ">" + trim(ship_rout_seq10).
			 end.
		      end.

END PROCEDURE.

