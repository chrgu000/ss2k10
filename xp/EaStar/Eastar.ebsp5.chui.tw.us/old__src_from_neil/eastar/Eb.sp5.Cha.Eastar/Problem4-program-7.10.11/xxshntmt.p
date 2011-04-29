/* xxshntmt.p  -- Shipping Notes Maintenance */
/* REVISION: eb SP5 create 02/10/04 BY: *EAS033A3* Apple Tam */
/* Revision eB SP5 Linux  Last Modified: 12/01/05   By: Kaine  *easnew* */

{mfdtitle.i "sp5 "}

define variable snnbr like sn_nbr no-undo.
define variable sndate like sn_date no-undo.
define variable sntime like sn_time format "99:99" no-undo.
define variable ship_wk like sn_ship_wk no-undo.
define variable truck_hk like sn_truck_hk no-undo.
define variable truck_prc like sn_truck_prc no-undo.
define variable remark like sn_remark no-undo.
define variable container like sn_container no-undo.
define variable part like snd_part no-undo.
define variable order like snd_so_order no-undo.
define variable extqty like snd_ext_qty no-undo.
define new shared variable extqty2 like snd_ext_qty no-undo.
define variable m as char format "x(9)".
define variable m2 as char format "x(4)".
define variable k as integer.
define variable del-yn like mfc_logical initial no.
define variable qty-yn like mfc_logical initial yes.
define new shared variable con-yn like mfc_logical initial no.
define new shared variable total_ctn     like sn_total_ctn    .
define new shared variable total_netwt   like sn_total_netwt  .
define new shared variable total_qty     like sn_total_qty    .
define new shared variable total_grosswt like sn_total_grosswt.
define new shared variable total_cbm     like sn_total_cbm    .

define new shared variable sqnbr    as integer format ">>9".
define new shared variable pltnbr   like snh_plt_nbr no-undo.
define new shared variable sonbr    like so_nbr no-undo.
define new shared variable part3    like snh_part no-undo.
define new shared variable desc1    like pt_desc1 no-undo.
define new shared variable desc2    like pt_desc2 no-undo.
define new shared variable destin   like snh_destin no-undo.
define new shared variable consign  like snh_ctn_consign no-undo.
define new shared variable loc      like snh_loc no-undo.
define new shared variable type     like snh_type no-undo.
define new shared variable ship_via as logical format "A/S" no-undo.
define new shared variable po1      like snh_po no-undo.
define new shared variable method   like snh_method no-undo.
define new shared variable modesc   as character format "x(62)" no-undo.
define new shared variable forw     like snh_forwarder no-undo.
define new shared variable ref      like snh_reference no-undo.

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
define new shared frame aa.
define new shared frame d2.
define new shared frame a2.
define new shared frame f.
define new shared frame g.

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
               index xxln_line IS PRIMARY UNIQUE xxln_sq_nbr xxln_ctn_line ascending
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
define new shared temp-table xxsnp_tmp
                field xxsnp_shipto      like snp_shipto
		field xxsnp_nbr         like snp_nbr
		field xxsnp_ext_grosswt like snp_ext_grosswt
		field xxsnp_length      like snp_length
		field xxsnp_height      like snp_height
		field xxsnp_width       like snp_width
		field xxsnp_cbm         like snp_cbm
		field xxsnp_line        as integer format ">>9"
		index xxsnp_nbr IS PRIMARY UNIQUE xxsnp_shipto xxsnp_nbr ascending
/*		index xxsnp_nbr IS PRIMARY xxsnp_shipto ascending*/
		.

/*easnew*/  DEFINE VARIABLE strYearChr AS CHARACTER FORMAT "x(1)".
/*easnew*/  {xxyr2let.i}

form
   snnbr          colon 3
   sndate         colon 25
   sntime         colon 43
   ship_wk        colon 68
   truck_hk       colon 14
   truck_prc      colon 50
   remark         colon 8
   container      colon 50
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
  part          colon 9   label "Item No."
  order         colon 42  label "Sales Order"
  extqty       colon 63   label "QTY"
with frame b attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form 
  snnbr2        colon 3 
  sndate2 	colon 25
  sntime2 	colon 43
  snwk2         colon 68
  part2         colon 9  label "Item No."       
  order2 	colon 42 label "Sales Order"    
  ext_qty2	colon 63 label "QTY"            
with frame c attr-space side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

       {xxshmta.i}

    mainloop:
    repeat on error undo, retry:  
        hide frame d2 no-pause.
        hide frame a2 no-pause.
	hide frame b no-pause.
	hide frame c no-pause.
     hide frame e no-pause.
     hide frame f no-pause.
     hide frame g no-pause.
/*	clear frame a.
	clear frame aa.*/
        view frame a.
	view frame aa.
       snnbr = "".
       i = 1.
       update 
          snnbr
        with frame a editing:
           {mfnp.i sn_hdr snnbr sn_nbr snnbr sn_nbr sn_nbr}
             if recno <> ? then do:
                assign
		   snnbr     = sn_nbr
		   sndate    = sn_date
		   sntime    = sn_time
		   ship_wk   = sn_ship_wk
		   truck_hk  = sn_truck_hk
		   truck_prc = sn_truck_prc
		   remark    = sn_remark
		   container = sn_container.
		   total_ctn     = sn_total_ctn    .
		   total_netwt   = sn_total_netwt  .
		   total_qty     = sn_total_qty    .
		   total_grosswt = sn_total_grosswt.
		   total_cbm     = sn_total_cbm    .
		
		display 
		    snnbr    
		    sndate   
		    sntime   
		    ship_wk  
		    truck_hk 
		    truck_prc
		    remark   
		    container
		    with frame a.
 run disptotal2.
	     end. /* if recno<>? */
	end.  /*with frame a eiting:*/
            
	    find first sn_hdr where sn_nbr = snnbr no-error.
	    if available sn_hdr then do:

		if sn_confirm = yes then do:
		    message "Error: Already posted.Please re-enter".
	            undo, retry.
		end.

		if sn_status = "D" then do:
		    message "Error: Already deleted.Please re-enter".
	            undo, retry.		 
		end.

                assign
		   snnbr     = sn_nbr
		   sndate    = sn_date
		   sntime    = sn_time
		   ship_wk   = sn_ship_wk
		   truck_hk  = sn_truck_hk
		   truck_prc = sn_truck_prc
		   remark    = sn_remark
		   container = sn_container
		   total_ctn     = sn_total_ctn    
		   total_netwt   = sn_total_netwt  
		   total_qty     = sn_total_qty    
		   total_grosswt = sn_total_grosswt
		   total_cbm     = sn_total_cbm    .
		
		
	    end. /*if available sn_hdr*/
	    if not available sn_hdr and snnbr <> "" then do:
	        message "Error: Invalid SN Number.Please re-enter".
		undo, retry.
	    end.

	    if snnbr = "" then do:
/*                  clear frame a.*/
		  assign
		   sndate    = today
		   sntime    = "" /*string(time,"hh:mm")*/
		   ship_wk   = 0
		   truck_hk  = ""
		   truck_prc = ""
		   remark    = ""
		   container = ""
		   total_ctn     = 0
		   total_netwt   = 0  
		   total_qty     = 0   
		   total_grosswt = 0 
		   total_cbm     = 0    .
	           display 
		       snnbr     
		       sndate    
		       sntime    
		       ship_wk   
		       truck_hk  
		       truck_prc 
		       remark    
		       container 
		       with frame a.
	    end.
 run disptotal2.

	    
	    
	    ststatus = stline[2].
            status input ststatus.

     repeat on endkey undo mainloop, retry:
/*     repeat on error undo mainloop, retry:*/
	update  
		 sndate     
		 sntime     
		 ship_wk    
		 truck_hk   
		 truck_prc  
		 remark     
		 container  		
	 go-on(F5 CTRL-D) with frame a editing:
	    readkey.
	    apply lastkey.
         end. /*editing*/
	    if sndate = ? then do:
                message "Error: Invalid Date.Please re-enter".
		 next-prompt sndate with frame a.
  	        undo, retry.
	    end.
	    if integer(substr(sntime,1,2)) > 23 then do:
                message "Error: Invalid Time.Please re-enter".
		 next-prompt sntime with frame a.
  	        undo, retry.
	    end.
	    if integer(substr(sntime,3,2)) > 59 then do:
                message "Error: Invalid Time.Please re-enter".
		 next-prompt sntime with frame a.
  	        undo, retry.
	    end.
	    if ship_wk = 0 then do:
                message "Error: Invalid Week.Please re-enter".
		 next-prompt ship_wk with frame a.
  	        undo, retry.
	    end.
	    m2 = fill("0",4 - length(string(ship_wk))).
	    if integer(substr(m2 + string(ship_wk),3,2)) > 52 then do:
                message "Error: Invalid Week.Please re-enter".
		 next-prompt ship_wk with frame a.
  	        undo, retry.
	    end.
	    if integer(substr(m2 + string(ship_wk),3,2)) < 1 then do:
                message "Error: Invalid Week.Please re-enter".
		 next-prompt ship_wk with frame a.
  	        undo, retry.
	    end.

	    if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
               del-yn = no.
               {mfmsg01.i 11 1 del-yn}
               if del-yn then do:
	         find first sn_hdr where sn_nbr = snnbr exclusive-lock no-error.
		 if available sn_hdr then do:
                  /* delete sn_hdr.*/
		     sn_status = "D".
		 end.
		 for each snd_ctn_det where snd_sn_nbr = snnbr:
                      snd_ctn_status = "D".
		      snd_last_date = today.
		      snd_last_user = global_userid.
		 end.
		 for each snp_totals where snp_sn_nbr = snnbr exclusive-lock:
		      snp_status = "D".
		      snp_last_date = today.
		      snp_last_user = global_userid.
		 end.
		 for each snp_totals where snp_sn_nbr = snnbr no-lock:
		 end.

		 for each snh_ctn_hdr where snh_sn_nbr = snnbr:
		     snh_ctn_status = "D".
		     snh_last_date = today.
		     snh_last_user = global_userid.
		 end.
                  clear frame a.
		  assign
		   snnbr     = ""
		   sndate    = today
		   sntime    = "" /*string(time,"hh:mm")*/
		   ship_wk   = 0
		   truck_hk  = ""
		   truck_prc = ""
		   remark    = ""
		   container = "".
		   total_ctn     = 0.
		   total_netwt   = 0  .
		   total_qty     = 0   .
		   total_grosswt = 0 .
		   total_cbm     = 0    .
	           display 
		       snnbr     
		       sndate    
		       sntime    
		       ship_wk   
		       truck_hk  
		       truck_prc 
		       remark    
		       container 
		       with frame a.
 run disptotal2.
		end.
	       if del-yn then next mainloop.
	    end.

	       else do: /*f5*/

	           display 
		       snnbr     
		       sndate    
		       sntime    
		       ship_wk   
		       truck_hk  
		       truck_prc 
		       remark    
		       container 
		       with frame a.
run disptotal2.

       /******************/
       if snnbr = "" then do:
               do transaction on error undo, retry:
	       find first doc_nbr_ctl where doc_year = string(year(today)) and doc_type = "SN" 
	                  EXCLUSIVE-LOCK no-error.
	            if available doc_nbr_ctl then do:
		       doc_sn_last = doc_sn_last + 1.
                       m = "".
		       m = fill("0",5 - length(string(doc_sn_last))).
		       m = m + string(doc_sn_last).
		       /*easnew*  snnbr = "X" +  substr(doc_year,3,2) + m.  */
				/* ***********************easnew B Add********************** */
				strYearChr = strYear2Let(doc_year).
				snnbr = "XS" + strYearChr + m.
				/* ***********************easnew E Add********************** */
		    end.
		    else do:
		       create doc_nbr_ctl.
		       assign
		          doc_sn_last = 1
			  doc_year = string(year(today))
			  doc_type = "SN".
                          m = "".
		          m = fill("0",5 - length(string(doc_sn_last))).
		          m = m + string(doc_sn_last).
		       /*easnew*  snnbr = "X" +  substr(doc_year,3,2) + m.  */
				/* ***********************easnew B Add********************** */
				strYearChr = strYear2Let(doc_year).
				snnbr = "XS" + strYearChr + m.
				/* ***********************easnew E Add********************** */
		    end.
                    if recid(doc_nbr_ctl) = ? then .
                    release doc_nbr_ctl.
                end. /*do transaction*/
		display snnbr with frame a.
       end.
       /******************/
		 find first sn_hdr where sn_nbr = snnbr no-error.
		 if available sn_hdr then do:
		   assign
		    sn_nbr        = snnbr     
		    sn_date       = sndate    
		    sn_time       = sntime    
		    sn_ship_wk    = ship_wk   
		    sn_truck_hk   = truck_hk  
		    sn_truck_prc  = truck_prc 
		    sn_remark     = remark   
		    sn_last_user  = global_userid
		    sn_last_date  = today
		    sn_container  = container  .
	        end.
	        else do:
	         create sn_hdr.
	         assign
		    sn_nbr        = snnbr     
		    sn_date       = sndate    
		    sn_time       = sntime    
		    sn_ship_wk    = ship_wk   
		    sn_truck_hk   = truck_hk  
		    sn_truck_prc  = truck_prc 
		    sn_remark     = remark    
		    sn_last_user  = global_userid
		    sn_last_date  = today
		    sn_container  = container  .
	        end.
              end. /*f5*/	
	   leave.
      end. /*repeat*/
/********************************************************************************/


      run disptotal2.
	    ststatus = stline[3].
            status input ststatus.

   mainloop3:
   repeat on endkey undo mainloop, retry:
      view frame b.
      update
         part
	 order
	 extqty
      with frame b . 

	if part <> "" and order <> "" then do:
	    find first sod_det where sod_part = part and sod_nbr = order no-lock no-error.
	    if not available sod_det then do:
	       message "Error: Item not in this Sales Order. Please re-enter".
	       undo, retry.
	    end.
	    if extqty > 0 then do:
	       extqty2 = 0.
	       for each sod_det where sod_nbr = order and sod_part = part no-lock:
	           extqty2 = extqty2 + sod_qty_ord - sod_qty_ship.
	       end.
	       if extqty > extqty2 then do:
	          message "Warning: QTY not match. Expected is(" + string(extqty2) + "). Entered is("
		           + string(extqty) + "). Continue? " update qty-yn.
	          if qty-yn = no then do:
		     message " ".
		     undo, retry.
		  end.
	       end.
	    end.
	end.

	else do:
	   if extqty > 0 and part = "" then do:
	       message "Error: Invalid Item. Please re-enter".
	       undo, retry.   
	   end.
	end.
	if part <> "" then do:
	   find first pt_mstr where pt_part = part no-lock no-error.
	   if not available pt_mstr then do:
	       message "Error: Invalid Item. Please re-enter".
	       undo, retry.   
	   end.
	end.
	if order <> "" then do:
	   find first so_mstr where so_nbr = order no-lock no-error.
	   if not available so_mstr then do:
	       message "Error: Invalid Sales Order. Please re-enter".
	       undo, retry.   
	   end.
	end.

	leave.
	
   end. /*repeat: mainloop3*/

           for each xxsq_tmp :
	       delete xxsq_tmp.
	   end.

	   for each snh_ctn_hdr where snh_sn_nbr = snnbr and snh_ctn_status <> "D" no-lock:
	       create xxsq_tmp.
	       assign
	          xxsq_sq_nbr    = snh_sq_nbr
 		  xxsq_plt_nbr   = snh_plt_nbr
		  xxsq_so_order  = snh_so_order
		  xxsq_shipto    = snh_shipto
		  xxsq_part      = snh_part
		  xxsq_qty_open  = snh_qty_open
		  xxsq_part_um   = snh_part_um
		  xxsq_qty_ship  = snh_qty_ship
		  .
		  xxsq_qty_open = 0.
		  for each sod_det where sod_nbr = snh_so_order and sod_part = snh_part no-lock:
		      xxsq_qty_open = xxsq_qty_open + sod_qty_ord - sod_qty_ship.
		  end.
	   end.

           assign
            snnbr2   = snnbr  
	    sndate2  = sndate 
	    sntime2  = sntime
	    snwk2    = ship_wk
	    part2    = part   
	    order2   = order
	    ext_qty2 = extqty.
	    hide frame a.
	    hide frame b.
	    view frame c.
	    display
	       snnbr2   
	       sndate2  
	       sntime2 
	       snwk2
	       part2    
	       order2   
	       ext_qty2 
	    with frame c.
/********************************************************************************/
         
           {gprun.i ""xxshmta.p""}
           {gprun.i ""xxshmtb.p""}
/**********************************************************************/
   repeat:
     con-yn = no.
     message "Post to SA?" update con-yn.
     if con-yn then do:
        find first sn_hdr where sn_nbr = snnbr2 no-error.
	if available sn_hdr then sn_confirm = yes.
     end.
     leave.
   end.
     
     clear frame f all no-pause.
     clear frame aa no-pause.
     clear frame a no-pause.
     hide frame d2 no-pause.
     hide frame a2 no-pause.
     hide frame e no-pause.
     hide frame f no-pause.
     hide frame g no-pause.
    end. /*mainloop*/


	    
	    
	    status input.


PROCEDURE disptotal2 :
       assign
	total_ctn     = 0
	total_netwt   = 0
	total_qty     = 0
	total_grosswt = 0
	total_cbm     = 0.

	for each snd_ctn_det where snd_sn_nbr = snnbr and snd_ctn_status <> "D" no-lock:
	       total_ctn     = total_ctn     + snd_ctn_qty.
	       total_netwt   = total_netwt   + snd_ext_netwt.
	       total_qty     = total_qty     + snd_ext_qty.
	       total_grosswt = total_grosswt + snd_ext_grosswt.
/*	       if snd_plt_nbr = 0 then total_grosswt = total_grosswt + snd_ext_grosswt.*/
	       if snd_plt_nbr = 0 then total_cbm = total_cbm + snd_cbm * snd_ctn_qty.
	end.
	for each snp_totals where snp_sn_nbr = snnbr and snp_status <> "D" no-lock:
	       total_grosswt = total_grosswt + snp_ext_grosswt.
	       total_cbm     = total_cbm + snp_cbm.
	end.
	clear frame aa all no-pause.
		 display
		    total_ctn    
		    total_netwt  
		    total_qty    
		    total_grosswt
		    total_cbm    
		    with frame aa.
END PROCEDURE.

