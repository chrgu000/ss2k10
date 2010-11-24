/*By: Neil Gao 08/10/14 ECO: *SS 20081014* */
/*By: Neil Gao 09/01/12 ECO: *SS 20090112* */

/* DISPLAY TITLE */
{mfdtitle.i "n+"}

define var site like ld_site.
define var packno as char.
define var packno1 as char.
define var vin as char format "x(18)".
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var part like pt_part.
define var qty like ld_qty_oh.
define var sonbr like so_nbr.
define var yn as logical.

form
	site colon 12
	packno colon 12 label "外包装箱号"
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

form
/*SS 20090112 - B*/
/*
	vin colon 12 label "条码"
	sonbr  colon 12 label "订单号"
*/
/*SS 20090112 - E*/
	packno1 colon 12 label "内包装箱号" 
	desc1 colon 45 no-label
	desc2 colon 45 no-label
	xxabs_qty  colon 12 label "数量"
	xxabs_gwt colon 12 label "毛重"
	xxabs_gwt_um no-label
	xxabs_nwt colon 12 label "净重"
	xxabs_nwt_um no-label
with frame b side-labels width 80 attr-space.

setFrameLabels(frame b:handle).
	
site = global_site.

mainloop:
repeat:
	
	update site packno with frame a.
	
	find first si_mstr where si_domain= global_domain and si_site = site no-lock no-error.
	if not avail si_mstr then do:
		message "地点不存在".
		next.
	end.
	global_site = site.
	
	find first xxabs_mstr where xxabs_domain = global_domain and xxabs_id = packno and xxabs_type = "P" no-error.
	if not avail xxabs_mstr then do:
		message "包装箱号不存在".
		next.
	end.
	if xxabs_par_id <> "" then do:
		message "此包装箱已经装在" xxabs_par_id.
		next.
	end.
	
	loop:
	repeat transaction on error undo,retry:
		
		update packno1 with frame b editing:
			
			{mfnp05.i xxabs_mstr xxabs_par_id "xxabs_domain = global_domain and xxabs_type = 'P'
      	and xxabs_shipfrom = site and xxabs_par_id = packno "  packno1 "input packno1" 
      }
			
			if recno <> ? then do:
				disp xxabs_id @ packno1 xxabs_gwt xxabs_gwt_um xxabs_nwt xxabs_nwt_um with frame b.
			end.
			
		end.
 		
 		if packno1 = packno then do:
 			message "不能合装自己".
 			next.
 		end.
 		
 		find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_type = "P"
 			and xxabs_id = packno1 no-error.
 		if not avail xxabs_mstr then do:
 			message "包装箱号不存在".
 			next.
 		end.
 		if xxabs_par_id <> "" and xxabs_par_id <> packno then do:
 			message "此包装箱已经合装在" xxabs_par_id .
 			next.
 		end.
 		
   	if xxabs_par_id = "" then message "新增记录".
   	else message "修改记录".
   	
   	update xxabs_gwt xxabs_gwt_um xxabs_nwt xxabs_nwt_um go-on("ctrl-d") with frame b.
   	
   	if lastkey = keycode("ctrl-d") then do:
   		message "请确认是否删除" update yn.
   		if yn then do:
   			xxabs_par_id = "".
   			next loop.
   		end.
   		else undo,retry.
   	end.
   	
   	assign	xxabs_par_id = packno.
   	message packno1 "合箱成功".
   	
 	end.

end.