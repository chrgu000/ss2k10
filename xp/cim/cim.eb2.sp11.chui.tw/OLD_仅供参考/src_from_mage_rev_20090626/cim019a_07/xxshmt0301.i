/* Revision: eB2SP11.Chui   Modified: 10/11/06      By: Kaine Zhang     *ss - 20061011.1* */

if v_so_nbr <> "" then do:
	find first sod_det where sod_nbr = v_so_nbr no-lock no-error.
	if not avail sod_det then do:
		message "No such So NBR" .
		next .
	end.
	find first xxshd_det where xxshd_inv_no = invno and xxshd_so_nbr = v_so_nbr no-error.
	if avail xxshd_det then do:
		for each xxshd_det where xxshd_inv_no = invno and xxshd_so_nbr = v_so_nbr no-lock:
			create tmp.
			assign
				tmp_sele = "Y"
				tmp_so_nbr	= xxshd_so_nbr
				tmp_so_line	= xxshd_so_line
				tmp_sort	= xxshd_sort
				tmp_so_part	= xxshd_so_part
				tmp_so_qty	= xxshd_so_qty
				tmp_so_price    = xxshd_so_price
				tmp_carton	= xxshd_carton
				tmp_pallet	= xxshd_pallet
				tmp_blance_qty  = xxshd_blance_qty
				tmp_carton_no   = xxshd_carton_no
				tmp_pallet_no   = xxshd_pallet_No
				tmp_ser_no	= xxshd_ser_no
				tmp_ser_no2	= xxshd_ser_no2
				tmp_yiyin_date  = xxshd_yiyin_date
				tmp_seat_part   = xxshd_seat_part
				tmp_dec[1]	= xxshd_dec[1] 
				tmp_dec[2]      = 1 .    /*第二次修改時Pallet不重新被算*/

		end.
	end.
	for each sod_det where sod_nbr = v_so_nbr no-lock :
		find first tmp where tmp_so_nbr = sod_nbr and tmp_so_line = sod_line no-error.
		if avail tmp then next .
		else do:
			create tmp.
			assign  tmp_sele = ""
				tmp_so_nbr = sod_nbr
				tmp_so_line = sod_line
				tmp_sort = 10
				tmp_so_part = sod_part
				tmp_so_qty  = sod_qty_ord
				tmp_so_price = sod_price .
			
			/*計算此項未結數量--BEGIN*/
			
			/* ********************ss - 20061011.1 B Del*******************
			 *  for each xxshd_det where xxshd_so_nbr = sod_nbr and xxshd_so_line = sod_line 
			 *  		and xxshd_inv_no <> invno no-lock:
			 *  	assign tmp_so_qty = tmp_so_qty - xxshd_so_qty .
			 *  end.
			 * ********************ss - 20061011.1 E Del*******************/
			
			/* ***********************ss - 20061011.1 B Add********************** */
			for each xxshd_det where xxshd_so_nbr = sod_nbr and xxshd_so_line = sod_line 
                and xxshd_inv_no <> invno AND (NOT xxshd_inv_no MATCHES "*CS") no-lock:
				assign tmp_so_qty = tmp_so_qty - xxshd_so_qty .
			end.
			/* ***********************ss - 20061011.1 E Add********************** */
			
			/*計算此項未結數量--END*/
			
			
			/*計算卡通及卡板數及找座椅料號-BEGIN*/

			find first xxpt_mstr where xxpt_part = sod_part no-lock no-error.
			if avail xxpt_mstr then do:
				if xxpt_ct_pcs > 0 then 
					assign tmp_carton = tmp_so_qty / xxpt_ct_pcs .
				else	assign tmp_carton = 0 .
				run getinteger(input-output tmp_carton) .

				if tmp_carton = 0 then
					assign tmp_pallet = 0 .
				else do:
					if xxpt_pt_maxcheng = 0 or xxpt_pt_pcscheng = 0 or xxpt_ct_pcs = 0 then
						assign tmp_pallet = 0 .
					else	do:
                                                 /* pallet ji suan  --by ching 20060727--begin*/    
						 tmp_pallet = round(tmp_carton /  (xxpt_pt_maxcheng * xxpt_pt_pcscheng ),2) .
						 /*run getinteger(input-output tmp_pallet) .*/
						  /* pallet ji suan  --by ching 20060727--end*/ 

					  /* assign tmp_pallet = round(tmp_so_qty / ( xxpt_ct_pcs * xxpt_pt_maxcheng * xxpt_pt_pcscheng ) ,2) . */
					end.
				end.
				/*找座椅料號-BEGIN*/
				if xxpt_custseat_part  = "" then tmp_seat_part = "".
				else do:
					find first cp_mstr where cp_cust_part = xxpt_custseat_part no-lock no-error.
					if avail cp_mstr then tmp_seat_part = xxpt_custseat_part .
					else tmp_seat_part = "".
				end.
				/*找座椅料號-END*/

			end.
			else do:
				assign  tmp_carton = 0
					tmp_pallet = 0 .
			end.
			assign tmp_dec[1] = tmp_pallet .   /*保存原始卡板數量*/
			/*計算卡通及卡板數及找座椅料號-END*/

		end.
	end.
END.   /*if v_so_nbr <> ""*/
else do:
	find first xxshd_det where xxshd_inv_no = invno  no-error.
	if avail xxshd_det then do:
		for each xxshd_det where xxshd_inv_no = invno  no-lock:
			create tmp.
			assign
				tmp_sele = "Y"
				tmp_so_nbr	= xxshd_so_nbr
				tmp_so_line	= xxshd_so_line
				tmp_sort	= xxshd_sort
				tmp_so_part	= xxshd_so_part
				tmp_so_qty	= xxshd_so_qty
				tmp_so_price    = xxshd_so_price
				tmp_carton	= xxshd_carton
				tmp_pallet	= xxshd_pallet
				tmp_blance_qty  = xxshd_blance_qty
				tmp_carton_no   = xxshd_carton_no
				tmp_pallet_no   = xxshd_pallet_No
				tmp_ser_no	= xxshd_ser_no
				tmp_ser_no2	= xxshd_ser_no2
				tmp_yiyin_date  = xxshd_yiyin_date
				tmp_seat_part   = xxshd_seat_part
				tmp_dec[1]	= xxshd_dec[1]  
				tmp_dec[2]      = 1 .    /*第二次修改時Pallet不重新被算*/


		end.
	end.
end.
	release xxshd_det .
