/*By: Neil Gao 08/10/14 ECO: *SS 20081014* */
/*By: Neil Gao 09/01/12 ECO: *SS 20090112* */

/* DISPLAY TITLE */
{mfdtitle.i "n1"}

define var site like ld_site.
define var packno as char.
define var packno1 as char.
define var vin as char format "x(18)".
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var part like pt_part.
define var qty like ld_qty_oh.
define var sonbr like so_nbr.
define var soline like sod_Line.
define var location like ld_loc.
define var lotserial like ld_lot.
define var lotref like ld_ref.
define var lotop as char format "x(18)".
define var ifyn as logical.

form
	site colon 12
	packno colon 12 label "包装箱号"
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

form
/*SS 20090112 - B*/
/*
	vin colon 12 label "条码"
*/
	sonbr  colon 12 label "订单号"
	soline colon 12 label "项"
/*SS 20090112 - E*/
	part colon 12 label "物料号" 
	desc1 colon 45 no-label
	desc2 colon 45 no-label
	location	 colon 12 label "库位"
/*SS 20090215 - B*/
/*
	lotserial  colon 12 label "批号"
	lotref 			colon 12 label "参考"
*/
	lotop				colon 12 label "序号"
/*SS 20090215 - E*/
	xxabs_pk_no colon 12 xxabs_pk_qty
	xxabs_pk_per_qty colon 12
	xxabs_gwt colon 12 label "毛重"
	xxabs_gwt_um no-label
	xxabs_nwt colon 12 label "净重"
	xxabs_nwt_um no-label
	xxabs_vol_rk colon 12 label "体积"
	xxabs_vol_um no-label
	xxabs_qty  colon 12 label "总数量"
	xxabs_rmks colon 12
with frame b side-labels width 80 attr-space.

setFrameLabels(frame b:handle).
	
site = "12000".

mainloop:
repeat:
	
	update site packno with frame a editing:
		if frame-field = "packno" then do:
			{mfnp05.i xxabs_mstr xxabs_id
       		" xxabs_domain = global_domain and xxabs_shipfrom = input site and xxabs_par_id = '' and xxabs_type = 'P'"
          	xxabs_id  "input packno"}
      if recno <> ? then do:
      	disp xxabs_id @ packno with frame a.
      end.
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end.
	
	find first si_mstr where si_domain= global_domain and si_site = site no-lock no-error.
	if not avail si_mstr then do:
		message "地点不存在".
		undo,retry.
	end.
	
	find first xxabs_mstr where xxabs_domain = global_domain and xxabs_id = packno and xxabs_shipfrom = site no-error.
	if not avail xxabs_mstr then do:
		message "包装箱号不存在".
		undo,retry.
	end.
	
	loop:
	repeat transaction on error undo,retry:

 		prompt-for sonbr soline with frame b editing:
 			if frame-field = "sonbr" then do:
				{mfnp05.i xxabs_mstr xxabs_id
       		" xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_par_id = packno and xxabs_type = 'I'"
          	xxabs_nbr  "input sonbr"}
      	if recno <> ? then do:
      		disp xxabs_nbr @ sonbr xxabs_line @ soline with frame b.
      		find first pt_mstr where pt_domain = global_domain and pt_part = xxabs_part no-lock no-error.
      		if avail pt_mstr then disp pt_part @ part pt_desc1 @ desc1	pt_desc2 @ desc2	with frame b.
      	end. 	
			end.
			else if frame-field = "soline" then do:
				{mfnp05.i xxabs_mstr xxabs_id
       		" xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_par_id = packno and xxabs_nbr = input sonbr and xxabs_type = 'I'"
          	xxabs_line  "input soline"}
      	if recno <> ? then do:
      		disp xxabs_nbr @ sonbr xxabs_line @ soline with frame b.
      		find first pt_mstr where pt_domain = global_domain and pt_part = xxabs_part no-lock no-error.
      		if avail pt_mstr then disp pt_desc1 @ desc1	pt_desc2 @ desc2	with frame b.
      	end. 	
			end.
			else do:
					status input.
      		readkey.
      		apply lastkey.
      end.
 		end.
 		
 		find first sod_det where sod_domain = global_domain and sod_nbr = input sonbr and sod_line = input soline no-lock no-error.
 		if not avail sod_det then do:
 			message "销售订单不存在".
 			next.
 		end.
		
 		find first pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
 		if avail pt_mstr then disp 	pt_desc1 @ desc1	pt_desc2 @ desc2	with frame b.
 		else do:
 			message "零件号不存在".
 			next.
 		end.
 		assign sonbr soline.
		location = "BZ01".
		disp sod_part @ part location with frame b.
		global_site = site.
		global_loc  = location.
		global_part = sod_part.
		lotserial = "".
		lotref = "".
		
		do on error undo,retry:

/*SS 20090215 - B*/
/*			
			update lotserial lotref with frame b editing:
				if frame-field = "lotserial" then do:
					{mfnp05.i xxabs_mstr xxabs_id
    	   		" xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_par_id = packno and xxabs_nbr = sonbr and xxabs_line = soline
    	   			and xxabs_loc = location and xxabs_type = 'I' "
    	      	lotserial  "input lotserial"}
    	  	if recno <> ? then do:
    	  		disp xxabs_lot @ lotserial xxabs_ref @ lotref with frame b.
    	  	end.
				end.
				else do:
						status input.
    	  		readkey.
    	  		apply lastkey.
    	  end.
			end.
*/
			update lotop with frame b editing:
				if frame-field = "lotop" then do:
					{mfnp05.i xxabs_mstr xxabs_id
					" xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_par_id = packno and xxabs_nbr = sonbr and xxabs_line = soline
    	   			and xxabs_loc = location and xxabs_type = 'I' "
    	      	lotop  "input lotop"}
    	  	if recno <> ? then do:
    	  		disp xxabs_op @ lotop xxabs_pk_qty xxabs_qty
    	  		xxabs_pk_no xxabs_pk_per_qty xxabs_gwt xxabs_rmks
							xxabs_gwt_um	xxabs_nwt	xxabs_nwt_um 	xxabs_vol_rk  xxabs_vol_um 
    	  		with frame b.
    	  	end.
				end.
				else do:
						status input.
    	  		readkey.
    	  		apply lastkey.
    	  end.
			end.
/*SS 20090215 - E*/
			
 			find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_type = "I"
 				and xxabs_par_id = packno and xxabs_nbr = sod_nbr and xxabs_line = sod_line
 				and xxabs_loc = location 
/*SS 20090215 - B*/
/*
 				and xxabs_lot = lotserial and xxabs_ref = lotref 
*/
				and xxabs_op = lotop
/*SS 20090215 - E*/ 				
 				no-error.
 			if not avail xxabs_mstr then do:
 				create xxabs_mstr.
   			assign xxabs_domain = global_domain 
   						 xxabs_shipfrom = site
   						 xxabs_par_id = packno
   						 xxabs_id = packno + "&" + site + "&" +  sod_part + "&" + lotop + "&" + location + "&" + lotserial + "&" + lotref
   						 xxabs_nbr = sod_nbr
   						 xxabs_line = sod_line
   						 xxabs_part = sod_part
   					 	 xxabs_type = "I"
   					 	 xxabs_loc = location
/*SS 20090215 - B*/
/*
   					 	 xxabs_lot = lotserial
   					 	 xxabs_ref = lotref
*/
								xxabs_op = lotop
/*SS 20090215 - E*/
   					 	 xxabs_crt_date = today
   						 xxabs_crt_time = now
   					 	xxabs_userid = global_userid
   					 	xxabs_gwt = pt_ship_wt
   					 	xxabs_gwt_um = pt_ship_wt_um
   					 	xxabs_nwt = pt_net_wt
   					 	xxabs_nwt_um = pt_net_wt_um.
   		end.
/*SS 20090215 - B*/
/*   		
   		find first ld_det where ld_domain = global_domain and ld_site = site and ld_part = xxabs_part
   				and ld_loc = xxabs_loc and ld_lot = xxabs_lot and ld_ref = xxabs_ref no-lock no-error.
   		if not avail ld_det then do:
   			message "错误: 批次不存在".
   			undo,retry.
   		end.
   		else message "此批次数量为:" ld_qty_oh .
*/
/*SS 20090215 - E*/
   		
   		disp xxabs_pk_qty xxabs_qty with frame b.
   		update xxabs_pk_no xxabs_pk_per_qty xxabs_gwt 
							xxabs_gwt_um	xxabs_nwt	xxabs_nwt_um 	xxabs_vol_rk  xxabs_vol_um 
							xxabs_rmks
	 		go-on("ctrl-d") with frame b.
   		
   		if lastkey = keycode("ctrl-d") then do:
   			message "是否删除记录" update ifyn.
   			if ifyn then do:
   				delete xxabs_mstr.
   				message "记录删除".
   				next loop.
   			end.
   		end.
   		
   		{gprun.i ""xxdysdsum.p"" "(input xxabs_pk_no,output xxabs_pk_qty)"} .
   		
   		xxabs_qty = xxabs_pk_per_qty * xxabs_pk_qty.
   		disp xxabs_pk_qty xxabs_qty with frame b.
   		
   		if xxabs_qty > 0 then do:
   			find first sod_det where sod_domain = global_domain and sod_nbr = xxabs_nbr and sod_line = xxabs_line no-lock no-error.
   			if avail sod_det and sod_qty_ord < xxabs_qty then do:
   				message "错误: 大于订单数量".
   				undo,retry.
   			end.
/*SS 20090215 - B*/
/*
   			find first ld_det where ld_domain = global_domain and ld_site = site and ld_part = xxabs_part
   				and ld_loc = xxabs_loc and ld_lot = xxabs_lot and ld_ref = xxabs_ref no-lock no-error.
   			if not avail ld_det then do:
   				message "错误: 批次不存在".
   				undo,retry.
   			end.
   			else if ld_qty_oh < xxabs_qty  then do:
   				message "错误: 数量不够".
   				undo,retry.
   			end.
*/
/*SS 20090215 - E*/
   		end.
   	end. /* do no error undo,retry */
 	end.

end.