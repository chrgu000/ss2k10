/*By: Neil Gao 08/11/15 ECO: *SS 20081115* */
/*By: Neil Gao 08/12/27 ECO: *SS 20081227* */

{mfdtitle.i "n2"}

define var site like ld_site .
define var shipid like xxspl_id.
define var shipto like so_ship.
define var cust like so_cust.
define var sonbr like so_nbr.
define var soline like sod_line.
define var sodpart like pt_part.
define var desc1 like pt_desc1.
define var planqty like ld_qty_oh.
define var pid  as char format "x(30)".
define var packno as char.

form
	site		colon 10
	shipid colon 10 label "发运单号"
	cust   colon 40 label "客户"
	shipto colon 60 label "发货至"
	xxspl_shp_date colon 10 
	xxspl_status 
	xxspl_rmks
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	packno colon 25 label "包装箱号"
	skip(1) 
	xxabs_gwt colon 25 label "毛重"
	xxabs_gwt_um no-label
	xxabs_nwt colon 25 label "净重"
	xxabs_nwt_um no-label
	xxabs_vol_rk colon 25 label "体积"
	xxabs_vol_um no-label 
	xxabs_gh colon 25
	xxabs_fh colon 25
	xxabs_rmks colon 25
	skip
with frame c side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
	
site = "12000".
	
mainloop:
repeat with frame a:
	
	update site shipid with frame a editing:
		if frame-field = "shipid" then do:
			{mfnp05.i xxspl_mstr xxspl_id
       		" xxspl_domain = global_domain "
            xxspl_id  shipid}
      if recno <> ? then do:
      	disp  xxspl_id @ shipid 
      			  xxspl_cust @ cust
      			  xxspl_ship @ shipto
      			  xxspl_shp_date
      			  xxspl_status
      			  xxspl_rmks
      			  with frame a.
      end.
		end.
		else do:
			status input .
			readkey.
			apply lastkey.
		end.
	end. /*editing */
	
	find first xxspl_mstr where xxspl_domain = global_domain and xxspl_id = shipid no-error.
	if not avail xxspl_mstr then do:
		message "计划号不存在".
		next.
	end.
	else if xxspl_status = "c" then do:
		message "货运单已经发运".
		next.
	end.
	
	disp  xxspl_id @ shipid 
      	xxspl_cust @ cust
      	xxspl_ship @ shipto
      	xxspl_shp_date
      	xxspl_status
      	xxspl_rmks
  with frame a.
	
	loop1:
	repeat:
		
		update packno with frame c editing:
			if frame-field = "packno" then do:
				{mfnp05.i xxabs_mstr xxabs_id
       		" xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_par_id = xxspl_id"
            xxabs_id packno}
      	if recno <> ? then do:
      		disp  xxabs_id @ packno
      			  	xxabs_gwt xxabs_gwt_um xxabs_nwt xxabs_nwt_um
      			  	xxabs_vol_rk xxabs_vol_um xxabs_fh xxabs_gh 
      			  	xxabs_rmks
      		with frame c.
      	end.
			end.
			else do:
				status input .
				readkey.
				apply lastkey.
			end.
		end.
		
		for each xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_type = "I" 
			and xxabs_par_id = packno no-lock:
				
			find first xxspld_det where xxspld_domain = global_domain and xxspld_id = shipid 
				and xxspld_nbr = xxabs_nbr and xxspld_line = xxabs_line no-lock no-error.
			if not avail xxspld_det then do:
				message "错误 货运单不存在订单:" xxabs_nbr "项:" xxabs_line .
				next loop1.
			end.
			
		end.
		
		find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_type = "P"
 			and xxabs_id = packno no-error.
 		if not avail xxabs_mstr then do:
 			message "包装箱号不存在".
 			next.
 		end.
		
		if xxabs_par_id <> "" and xxabs_par_id <> xxspl_id then do:
 			message "此包装箱已经合装在" xxabs_par_id .
 			next.
 		end.
 		
 		
 		if xxabs_par_id = "" then message "新增记录".
   	else message "修改记录".
 		
 		xxabs_par_id = xxspl_id.
 		
		update xxabs_gwt xxabs_gwt_um xxabs_nwt xxabs_nwt_um xxabs_vol_rk xxabs_vol_um xxabs_gh xxabs_fh xxabs_rmks with frame c.
		
		if xxspl_status = "" then xxspl_status = "R".
		
	end. /* loop1 */
	
end . /* mainloop */	