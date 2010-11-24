/*By: Neil Gao 09/01/13 ECO: *SS 20090113* */
/*By: Neil Gao 09/02/16 ECO: *SS 20090216* */

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
define var yn as logical.
define var tqty1 like tr_qty_loc.
define var tqty2 like tqty1.

DEFINE new shared temp-table tmp_mstr
	field tmp_packno as char
	field tmp_vin as char format "x(18)"
	field tmp_nbr like sod_nbr
	field tmp_line like sod_line
	field tmp_part like pt_part
	field tmp_desc as char format "x(40)"
	field tmp_site like ld_site
	field tmp_loc	like ld_Loc
	field tmp_lot	like ld_Lot
	field tmp_ref like ld_ref
	field tmp_qty	like ld_qty_oh.

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
	packno colon 25 label "条码号"
	skip(1) 
	xxabs_gwt colon 12 label "毛重"
	xxabs_gwt_um no-label
	xxabs_nwt colon 12 label "净重"
	xxabs_nwt_um no-label
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
	else if xxspl_status = "" then do:
		message "货运单还未装箱".
		/*next.*/
	end.
	
	disp  xxspl_id @ shipid 
      	xxspl_cust @ cust
      	xxspl_ship @ shipto
      	xxspl_shp_date
      	xxspl_status
      	xxspl_rmks
  with frame a.
	
	message "是否确认发运" update yn .
	
	if yn then do:
		do on error undo,retry:

/*SS 20090216 - B*/
/*			
			run crttmp (input xxspl_id).
*/		
			tqty1 = 0.
			tqty2 = 0.
			
			for each xxspld_det where xxspld_domain = global_domain and xxspld_id = shipid no-lock 
				break by xxspld_nbr by xxspld_part:
				tqty1 = tqty1 + xxspld_qty_ship.
				if last-of(xxspld_part) then do:
					for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = xxspld_part 
						and ld_loc = "cs01" and ld_ref = xxspld_nbr no-lock :
						tqty2 = tqty2 + ld_qty_oh.
					end.
					if tqty1 > tqty2 then do:
						message "错误:" xxspld_nbr xxspld_line xxspld_part "库存量" tqty2 "小于发运量" tqty1.
						next mainloop.
					end.
					tqty1 = 0.
					tqty2 = 0.	
				end.	
			end.
			/*创建临时表*/
			empty temp-table tmp_mstr.
			for each xxspld_det where xxspld_domain = global_domain and xxspld_id = shipid no-lock 
				break by xxspld_nbr by xxspld_part:
				tqty1 = xxspld_qty_ship.
				for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = xxspld_part 
					and ld_loc = "cs01" and ld_ref = xxspld_nbr no-lock :
					tqty2 = min(tqty1,ld_qty_oh).
					tqty1 = tqty1 - tqty2.
					create tmp_mstr.
					assign tmp_packno = xxspld_id
						 tmp_site = site
						 tmp_nbr = xxspld_nbr
						 tmp_line = xxspld_line
				 		 tmp_part = xxspld_part
						 tmp_loc	= ld_loc
						 tmp_lot	= ld_lot
						 tmp_ref  = ld_ref
						 tmp_qty	= tqty2.
					if tqty1 <= 0 then leave.
				end. /* for each ld_det */
				if tqty1 > 0 then do:
					message "错误:" xxspld_part "分配出错".
					next mainloop.
				end.
			end. /*for each xxspld_det */
/*SS 20090216 - E*/
			
			/*记录发运单发运前数量*/
			for each xxspld_det where xxspld_domain = global_domain and xxspld_id = shipid ,
				each sod_det where sod_domain = global_domain and sod_nbr = xxspld_nbr 
					and sod_line = xxspld_line :
				xxspld_bc_qty_ship = sod_qty_ship.
			end.
			
			do on error undo,retry:
				{gprun.i ""xxpksois01.p""}
				tqty1 = 0.
				/*
				for each xxspld_det where xxspld_domain = global_domain and xxspld_id = shipid 
					break by xxspld_nbr by xxspld_line:
					tqty1 = tqty1 + xxspld_qty_ship.
					if last-of(xxspld_line) then do:
						find first sod_det where sod_domain = global_domain and sod_nbr = xxspld_nbr and sod_line = xxspld_line no-error.
						if not avail sod_det or tqty1 + xxspld_bc_qty_ship <> sod_qty_ship then do:
							message "错误: 发运失败".
							undo,next mainloop.
						end.
					end.
				end.
				*/
			end.	
/*SS 20090216 - B*/
/*
			for each xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site 
				and xxabs_par_id = xxspl_id and xxabs_type = "I" :
				xxabs_ship_qty = xxabs_qty.
				xxabs_ship_date = today.
			end.
*/
/*SS 20090216 - E*/
			xxspl_status = "C".
			xxspl_effdate = today.
			message "发运成功".
		end.
	end.
		
end . /* mainloop */	

procedure crttmp:
	define input parameter iptno as char.

	for each xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site 
		and xxabs_par_id = iptno  no-lock:
		if xxabs_type = "I" then do:
			create tmp_mstr.
			assign tmp_packno = xxabs_par_id
						 tmp_site = xxabs_shipfrom
						 tmp_vin = xxabs_id
						 tmp_nbr = xxabs_nbr
						 tmp_line = xxabs_line
				 		 tmp_part = xxabs_part
						 tmp_loc	= xxabs_loc
						 tmp_lot	= xxabs_lot
						 tmp_ref  = xxabs_ref
						 tmp_qty	= xxabs_qty.
			find first pt_mstr where pt_domain = global_domain and pt_part = xxabs_part no-lock no-error.
			if avail pt_mstr then tmp_desc = pt_desc1.
		end.
		else do:
			run crttmp ( input xxabs_id ).
		end.
	end.
end.

