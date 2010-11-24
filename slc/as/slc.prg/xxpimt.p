/* SS - 090703.1 By: Neil Gao */

{mfdtitle.i "090703.1"}

define var cust like so_cust.
define var part like pt_part.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.

form
	cust 		colon 25
	part		colon 25 
	desc1 	colon 45 no-label
	desc2   colon 45 no-label
	pt_um		colon 25
	xxpi_start colon 25
	skip(1)
	xxpi_price colon 25
	/*xxpi_end	 colon 25*/
	xxpi_rmks  colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat:
	
	update cust part with frame a.
	
	if cust <> "" then do:
		find first cm_mstr where cm_domain = global_domain and cm_addr = cust no-lock no-error.
		if not avail cm_mstr then do:
			message "错误: 客户不存在".
			next.
		end.
	end.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
	if not avail pt_mstr then do:
		message "错误: 物料号不存在".
		next.
	end.
	
	disp pt_desc1 @ desc1 pt_desc2 @ desc2 pt_um with frame a.
	
	loop1:
	do on error undo,retry :
		prompt-for xxpi_start with frame a editing:
			if frame-field = "xxpi_start" then do:
				
				{mfnp05.i xxpi_mstr xxpi_nbr
  	    	 		" xxpi_domain = global_domain and xxpi_list = cust and xxpi_part = part and xxpi_type = 'S' "
  	          xxpi_start  xxpi_start}
				
				if recno <> ? then do:
					disp xxpi_start xxpi_price xxpi_rmks with frame a.
				end.
				
			end.	
			else do:
				status input .
				readkey.
				apply lastkey.
			end.
			
		end. /* prompt-for */
		
		if input xxpi_start = ? then do:
			message "错误: 生效日期不能为空".
			undo,retry.
		end.
		
		find first xxpi_mstr where xxpi_domain = global_domain and xxpi_list = cust and xxpi_part = part
			and xxpi_type = "S" and xxpi_start = input xxpi_start no-error.
		if not avail xxpi_mstr then do:
			create xxpi_mstr.
			assign xxpi_domain = global_domain 
						 xxpi_list   = cust
						 xxpi_part   = part
						 xxpi_type   = "S"
						 xxpi_start  = input xxpi_start
						 xxpi_um     = pt_um
						 .
		end.
		
		update xxpi_price xxpi_rmks with frame a.
		
	end. /*loop1 */
	
end. /* mainloop */
