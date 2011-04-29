/*Design by Softspeed Davild*/

/*物料凈重毛重及座椅凈重毛重--BEGIN*/

/*def var tmpvar_dec as dec .*/
	/*物料凈重毛重--BEGIN*/
	find first xxpt_mstr where xxpt_part = tmp_so_part no-lock no-error.
	if avail xxpt_mstr then do:
		
		/*物料凈重*/
			assign xxshd_part_net_weight = round(xxshd_so_qty * xxpt_net_weight ,2) .
		/*物料毛重*/
			assign xxshd_part_gross_weight = round( (xxshd_part_net_weight /*凈重*/
						+	xxpt_ct_weight * xxshd_carton   /*卡通總重*/
						+	xxpt_pt_weight * xxshd_pallet ),2)  /*卡板總重*/ .
		
	end.   /*有維護XXPT_MSTR*/
	else do:

	end.
	/*物料凈重毛重--END*/

	/*座椅凈重毛重--BEGIN*/
	IF tmp_seat_part <> "" then do:
		find first cp_mstr where cp_cust_part = tmp_seat_part no-lock no-error.
		if avail cp_mstr then do:
			find first xxpt_mstr where xxpt_part = cp_part no-lock no-error.
			if avail xxpt_mstr then do:
				/*座椅卡通數量及體積-BEGIN-by ching 20060727*/	
				
                                       /* seat carton and seat tiji */
					 if xxpt_ct_pcs<>0 then do:
						   xxshd_seat_carton= round(xxshd_so_qty / xxpt_ct_pcs,2) .
						   run getinteger(input-output xxshd_seat_carton) .
					  end. 
                                         assign xxshd_seat_tiji=(xxshd_seat_carton * (xxpt_ct_long * xxpt_ct_width * xxpt_ct_high)) / 1000000.
                                         
				 /*座椅卡通數量及體積-END*/

				/*物料凈重*/
					assign xxshd_seat_net_weight = round(xxshd_so_qty * xxpt_net_weight ,2) .
				/*物料毛重*/
					assign xxshd_seat_gross_weight = round( (xxshd_seat_net_weight /*凈重*/
								+	xxpt_ct_weight * xxshd_seat_carton ),2).  /*卡通總重*/

				

			end.   /*有維護XXPT_MSTR*/
			else do:
                               
			end.
		END.
	END.
	/*座椅凈重毛重--END*/

/*物料凈重毛重及座椅凈重毛重--END*/