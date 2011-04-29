/* xxshadmt1.p  -- Shipping Advise Maintenance */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS036A* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */
/* SS - 100222.1  By: Roger Xiao */ /*update the ext_qty ,when ctn_qty = 0 (more than one so_line in one ctn)*/

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
define variable extqty4 like snd_ext_qty no-undo.

define shared variable con-yn like mfc_logical initial no.
define variable del-yn2 like mfc_logical initial no.
define variable del-yn3 like mfc_logical initial no.
define variable go-yn like mfc_logical initial no.
define variable sh-yn like mfc_logical initial yes.
define shared variable shipto2 like so_ship.
define variable via as char format "x(1)".
define variable um2 like sod_um.
define shared frame a2.
define shared frame e.
define shared variable sq3    as integer format ">>9".

define variable m as integer.
define variable m2 as integer.

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

/* SS - 091230.1 - B */
define shared variable soline    like sod_line no-undo.
/* SS - 091230.1 - E */
define shared temp-table  xxsq_tmp
                field xxsq_sq_nbr   /* like snh_sq_nbr*/ as integer format ">>9"
		field xxsq_plt_nbr  like snh_plt_nbr
		field xxsq_so_order like snh_so_order
/* SS - 091230.1 - B */
                field xxsq_so_line  like snh_so_line
/* SS - 091230.1 - E */
		field xxsq_shipto   like snh_shipto  
		field xxsq_part     like snh_part    
		field xxsq_qty_open like sod_qty_ord format ">,>>>,>>9.9<"
		field xxsq_part_um  like snh_part_um 
		field xxsq_qty_ship like sod_qty_ship format ">,>>>,>>9.9<"
               index xxsq_nbr IS PRIMARY UNIQUE xxsq_sq_nbr ascending
	       .

       {xxshadmtc.i}




    lineloop:
    repeat :

  view frame e .


/*      do transaction on error undo, retry:*/
    for each xxln_tmp:
        delete xxln_tmp.
    end.
    for each snd_ctn_det where snd_sn_nbr = snnbr:
           create xxln_tmp.
	   assign
	      xxln_sq_nbr      = snd_sq_nbr
	      xxln_ctn_line    = snd_ctn_line
	      xxln_ctnnbr_fm   = snd_ctnnbr_fm  
	      xxln_ctnnbr_to   = snd_ctnnbr_to  
	      xxln_ctn_qty     = snd_ctn_qty    
	      xxln_qtyper      = snd_qtyper     
	      xxln_ext_qty     = snd_ext_qty    
	      xxln_netwt       = snd_netwt      
	      xxln_ext_netwt   = snd_ext_netwt  
	      xxln_grosswt     = snd_grosswt    
	      xxln_ext_grosswt = snd_ext_grosswt
	      xxln_length      = snd_ctn_length 
	      xxln_height      = snd_ctn_height 
	      xxln_width       = snd_ctn_width  
	      xxln_cbm         = snd_cbm    
	      .
	find first snp_totals where snp_sn_nbr = snd_sn_nbr and snp_nbr = snd_plt_nbr and snp_status <> "D" no-lock no-error.
	if available snp_totals then do:
	      assign
	      xxln_pext_grosswt = snp_ext_grosswt  
	      xxln_plength      = snp_length       
	      xxln_pheight      = snp_height       
	      xxln_pwidth       = snp_width        
	      xxln_pcbm         = snp_cbm          
	      .
        end.
    end.
    
    ctn_line = 0.
    
       update 
          ctn_line    
	  with frame e editing:
           {mfnp01.i xxln_tmp ctn_line xxln_ctn_line sqnbr xxln_sq_nbr xxln_line}        
               if recno <> ? then do:
		  assign
		     ctn_line    = xxln_ctn_line    
		     ctnnbr_fm   = xxln_ctnnbr_fm   
		     ctnnbr_to   = xxln_ctnnbr_to   
		     ctn_qty     = xxln_ctn_qty     
		     qtyper      = xxln_qtyper      
		     ext_qty     = xxln_ext_qty     
		     netwt       = xxln_netwt       
		     ext_netwt   = xxln_ext_netwt   
		     grosswt     = xxln_grosswt     
		     ext_grosswt = xxln_ext_grosswt 
		     length      = xxln_length      
		     height      = xxln_height      
		     width       = xxln_width       
	             cbm         = xxln_cbm 
		     p_ext_grosswt = xxln_pext_grosswt
                     p_length =	     xxln_plength     
     		     p_height =	     xxln_pheight     
     		     p_width  =	     xxln_pwidth      
     		     p_cbm    =		xxln_pcbm             
		     .

	           display 		   
		     ctn_line       
		     ctnnbr_fm     
		     ctnnbr_to     
		     ctn_qty         
		     qtyper           
		     ext_qty         
		     netwt             
		     ext_netwt     
		     grosswt         
		     ext_grosswt 
		     length           
		     height           
		     width             
	             cbm  
		     p_ext_grosswt      
		     p_length           
		     p_height           
		     p_width            
		     p_cbm    		
		     with frame e.
	       
               end. /* IF RECNO <> ? */
	      
/*            readkey.
            apply lastkey.*/
       end. /*editing:*/

	     find first snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = sqnbr 
	                              and snd_ctn_line = ctn_line 
				      and snd_ctn_status = "D"
				      no-error.
	     if available snd_ctn_det then do:
	        message "Error: Line already deleted.Please re-enter.".
		undo, retry.
	     end.
	     find first snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = sqnbr 
	                              and snd_ctn_line = ctn_line 
				      no-error.
	     if available snd_ctn_det then do:
		     assign
		     ctn_line    = snd_ctn_line    
		     ctnnbr_fm   = snd_ctnnbr_fm   
		     ctnnbr_to   = snd_ctnnbr_to   
		     ctn_qty     = snd_ctn_qty     
		     qtyper      = snd_qtyper      
		     ext_qty     = snd_ext_qty     
		     netwt       = snd_netwt       
		     ext_netwt   = snd_ext_netwt   
		     grosswt     = snd_grosswt     
		     ext_grosswt = snd_ext_grosswt 
		     length      = snd_ctn_length      
		     height      = snd_ctn_height      
		     width       = snd_ctn_width       
	             cbm         = snd_cbm 
		     .
	find first snp_totals where snp_sn_nbr = snd_sn_nbr and snp_nbr = snd_plt_nbr and snp_status <> "D" no-lock no-error.
	if available snp_totals then do:
	      assign
	      p_ext_grosswt = snp_ext_grosswt  
	      p_length      = snp_length       
	      p_height      = snp_height       
	      p_width       = snp_width        
	      p_cbm         = snp_cbm          
	      .
        end.
	           display 		   
		     ctn_line    
		     ctnnbr_fm   
		     ctnnbr_to   
		     ctn_qty     
		     qtyper      
		     ext_qty     
		     netwt       
		     ext_netwt   
		     grosswt     
		     ext_grosswt 
		     length      
		     height      
		     width       
	             cbm  
		     p_ext_grosswt      
		     p_length           
		     p_height           
		     p_width            
		     p_cbm    		
		     with frame e.
	     end.
	     else do:
		   assign
		     ctn_line    = 0    
		     ctnnbr_fm   = 0   
		     ctnnbr_to   = 0   
		     ctn_qty     = 0     
		     qtyper      = 0      
		     ext_qty     = 0     
		     netwt       = 0       
		     ext_netwt   = 0   
		     grosswt     = 0     
		     ext_grosswt = 0 
		     length      = 0      
		     height      = 0      
		     width       = 0       
	             cbm         = 0 
		     p_ext_grosswt  = 0     
		     p_length       = 0     
		     p_height       = 0     
		     p_width        = 0     
		     p_cbm    	= 0 	
		     .		    

	           display 		   
		     ctn_line    
		     ctnnbr_fm   
		     ctnnbr_to   
		     ctn_qty     
		     qtyper      
		     ext_qty     
		     netwt       
		     ext_netwt   
		     grosswt     
		     ext_grosswt 
		     length      
		     height      
		     width       
	             cbm  
		     p_ext_grosswt      
		     p_length           
		     p_height           
		     p_width            
		     p_cbm    		
		     with frame e.
		       message "Error: Invalid Line Number.Please re-enter".
		       undo,retry.
	     end.

ftloop:
 repeat on endkey undo lineloop, retry:
       update
	  ctnnbr_fm   
	  ctnnbr_to   
        with frame e.



	           display 		  
		     ctnnbr_fm   
		     ctnnbr_to   
		     ctn_qty     
		     qtyper      
		     ext_qty     
		     netwt       
		     ext_netwt   
		     grosswt     
		     ext_grosswt 
		     length      
		     height      
		     width       
	             cbm  
		     p_ext_grosswt      
		     p_length           
		     p_height           
		     p_width            
		     p_cbm    		
		     with frame e. 

	if ctnnbr_fm <= 0 then do:
	   message "Error: Invalid Carton From number. Please re-enter.".
	   next-prompt ctnnbr_fm with frame e.
	   undo, retry.
	end.	  
	if ctnnbr_to = 0 then do:
	   ctnnbr_to = ctnnbr_fm.
	   display ctnnbr_to with frame e.
	end.	  
	if ctnnbr_to < ctnnbr_fm then do:
	   message "Error: Invalid carton FM/TO. Please re-enter.".
	   next-prompt ctnnbr_to with frame e.
	   undo, retry.
	end.	  
	  ctn_qty = (ctnnbr_to - ctnnbr_fm + 1).
	  display ctn_qty with frame e.

ctnloop:
    repeat:
       set
	  ctn_qty     
	  qtyper      
	  netwt       
	  grosswt     
	  length      
	  height      
	  width
	  p_ext_grosswt      
	  p_length           
	  p_height           
	  p_width            
	  p_cbm    		
        with frame e editing:
            ext_qty = input ctn_qty * input qtyper.
	    ext_netwt = input ctn_qty * input netwt.
	    ext_grosswt = input ctn_qty * input grosswt.
	    cbm = (input length * input height * input width) / 1000000.
	    p_cbm = (input p_length * input p_height * input p_width) / 1000000.
	    if ctn_qty = 0 then ctn_qty = (ctnnbr_to - ctnnbr_fm + 1).
	    display ext_qty ext_netwt ext_grosswt cbm p_cbm with frame e.
            readkey.
            apply lastkey.
     end. /*with frame a2 editing*/
	  display ctn_qty with frame e.
/* SS - 100222.1 - B */
        if ctn_qty = 0 then 
        update ext_qty with frame e .
/* SS - 100222.1 - E */

	if qtyper <= 0 then do:
	   message "Error: Invalid QTY per CTN. Please re-enter.".
	   next-prompt qtyper with frame e.
	   undo, retry.
	end.	  
	if netwt <= 0 then do:
	   message "Error: Invalid Net Wt/CTN. Please re-enter.".
	   next-prompt netwt with frame e.
	   undo, retry.
	end.	  
	if type = "C" and length <= 0 then do:
	   message "Error: Invalid CBM/CTN-L. Please re-enter.".
	   next-prompt length with frame e.
	   undo, retry.
	end.	  
	if type = "C" and height <= 0 then do:
	   message "Error: Invalid CBM/CTN-H. Please re-enter.".
	   next-prompt height with frame e.
	   undo, retry.
	end.	  
	if type = "C" and width <= 0 then do:
	   message "Error: Invalid CBM/CTN-W. Please re-enter.".
	   next-prompt width with frame e.
	   undo, retry.
	end.	  
	if type = "P" and p_ext_grosswt <= 0 then do:
	   message "Error: Invalid Plt Gross Wt. Please re-enter.".
	   next-prompt p_ext_grosswt with frame e.
	   undo, retry.
	end.	  

	if type = "P" and p_length <= 0 then do:
	   message "Error: Invalid Plt-L. Please re-enter.".
	   next-prompt p_length with frame e.
	   undo, retry.
	end.	  
	if type = "P" and p_height <= 0 then do:
	   message "Error: Invalid Plt-H. Please re-enter.".
	   next-prompt p_height with frame e.
	   undo, retry.
	end.	  
	if type = "P" and p_width <= 0 then do:
	   message "Error: Invalid Plt-W. Please re-enter.".
	   next-prompt p_width with frame e.
	   undo, retry.
	end.	  
	

	find first snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = sqnbr 
	                              and snd_ctn_line = ctn_line 
				      no-error.
	 if available snd_ctn_det then do:
	    assign
		  snd_ctn_line     =  ctn_line       
		  snd_sn_nbr       =  snnbr
		  snd_sq_nbr       =  sqnbr
		  snd_shipto       =  shipto2
		  snd_part         =  part3
		  snd_plt_nbr      =  pltnbr
		  snd_so_order     =  sonbr
		  snd_last_user    =  global_userid
		  snd_last_date    =  today
		  snd_ctnnbr_fm    =  ctnnbr_fm     
		  snd_ctnnbr_to    =  ctnnbr_to     
		  snd_ctn_qty      =  ctn_qty         
		  snd_qtyper       =  qtyper           
		  snd_ext_qty      =  ext_qty         
		  snd_netwt        =  netwt             
		  snd_ext_netwt    =  ext_netwt     
		  snd_grosswt      =  grosswt         
		  snd_ext_grosswt  =  ext_grosswt 
		  snd_ctn_length   =  length           
		  snd_ctn_height   =  height           
		  snd_ctn_width    =  width             
	          snd_cbm          =  cbm         .
	 end.
	 if type = "P" then do:

	 find first snp_totals where snp_sn_nbr = snnbr and snp_nbr = pltnbr and snp_status <> "D" /*snp_sq_nbr = sqnbr*/
	                          exclusive-lock no-error.
		if available snp_totals then do:
		   assign
		      snp_shipto	 = shipto2
		      snp_ext_grosswt	 = p_ext_grosswt
		      snp_cbm		 = p_cbm 
		      snp_length	 = p_length
		      snp_height	 = p_height
		      snp_width		 = p_width
		      snp_last_user	 = global_userid
		      snp_last_date      = today.
		end.
		release snp_totals.
	 find first snp_totals where snp_sn_nbr = snnbr and snp_nbr = pltnbr
	                         and snp_shipto = shipto2 no-lock no-error.
         end. /*if type = "P"*/
	 find first snh_ctn_hdr where snh_sn_nbr = snnbr and snh_sq_nbr = sqnbr no-error.
	 if available snh_ctn_hdr then do:
	    extqty3 = 0.
            for each snd_ctn_det where snd_sn_nbr = snnbr and snd_sq_nbr = sqnbr and snd_ctn_status <> "D":
	        extqty3 = extqty3 + snd_qtyper * snd_ctn_qty.
	    end.	 
	    snh_qty_ship = extqty3.
	 end.

	 leave.
     end. /*ctnloop*/
     leave.
   end. /*repeat on endkey undo lineloop*/
  end.
 
