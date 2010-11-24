/* SS - 090403.1 By: Neil Gao */

{mfdtitle.i "090403.1"}

define var yr like glc_year.
define var per like glc_per.
define var vend like po_vend.
define var part like pt_part.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var xxtype as logical format "Y)正常/N)暂估" init yes.
define var yn as logical.

form
	yr colon 25
	per colon 25
	skip(1)
	xxtype colon 25 label "Y)正常/N)暂估"
	skip(1)
	vend colon 25
	part colon 25 desc1 colon 45 no-label
	desc2 colon 45 no-label
	xxgzd_qty colon 25 label  "正常数量"
	xxgzd_end_qty colon 25 label "暂估数量"
	xxgzd_tax_pct colon 25 
	xxgzd_price  colon 25 label "未税单价" format "->>>,>>9.9<<<<"
	xxgzd_amt 	colon 25
with frame a width 80 side-labels attr-space.

setFramelabels(frame a:handle).
	
mainloop:
repeat with frame a:
	
	update yr per with frame a.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	next.
	end.
	if glc_user1 <> "" then do:
		message "挂账已经关闭".
		next.
	end.
	
	update xxtype with frame a.
	
	loop1:
	repeat on error undo,retry:
		
		update vend part with frame a editing:
			if frame-field = "vend" then do:
				{mfnp05.i xxgzd_det xxgzd_part "xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per"
									xxgzd_vend vend}
			end.
			else if frame-field = "part" then do:
				{mfnp05.i xxgzd_det xxgzd_part
							"xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per  
								and xxgzd_vend = input vend" xxgzd_part part}
      end. /* else if */
      else do:
      	readkey.
      	apply lastkey.
      end.
      if recno <> ? then do:
        	 display
        	 		xxgzd_vend @ vend
							xxgzd_part @ part
							xxgzd_qty
							xxgzd_end_qty
							xxgzd_price
							xxgzd_amt
							xxgzd_tax_pct
         	with frame a.
         	find first pt_mstr where pt_domain = global_domain and pt_part = xxgzd_part no-lock no-error.
         	if avail pt_mstr then disp pt_desc1 @ desc1 pt_desc2 @ desc2 with frame a.
      end.
		end.
		
		find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
		if not avail pt_mstr then do:
			message "物料编码不存在".
			next.
		end.
		else disp pt_desc1 @ desc1 pt_desc2 @ desc2 with frame a.
		
		find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per
		and xxgzd_part = part and xxgzd_vend = vend no-error.
		if not avail xxgzd_det then do:
			message "新增记录".
			create xxgzd_det.
			assign xxgzd_domain = global_domain
						 xxgzd_year = yr
						 xxgzd_per  = per
						 xxgzd_vend = vend
						 xxgzd_part = part.
			if xxtype then xxgzd_sort = "正常" . else xxgzd_sort = "暂估".
			
		end.
		
		do on error undo,retry:
			disp xxgzd_qty xxgzd_end_qty xxgzd_price with frame a.
			
			update 	xxgzd_qty when xxtype
						  xxgzd_end_qty when not xxtype
							xxgzd_tax_pct 
							xxgzd_price 
			go-on(F5 ctrl-d)  with frame a .
			
			if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
				message "请确认是否删除" update yn.
				if yn then do:
					delete xxgzd_det.
					vend = "".
					part = "".
					clear frame a no-pause.
					disp yr per with frame a.
					next loop1.
				end.
			end.
			
			xxgzd_amt = ( xxgzd_qty + xxgzd_end_qty ) * xxgzd_price * ( 1 + xxgzd_tax_pct / 100 ).
			
			disp xxgzd_amt with frame a.
			
		end.
		
	end. /* loop1 */
end. /* mainloop */	