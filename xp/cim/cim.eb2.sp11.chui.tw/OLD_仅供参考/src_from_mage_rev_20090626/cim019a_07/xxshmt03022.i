/*Design by Softspeed Davild*/

/*�����䭫�򭫤ήy���䭫��--BEGIN*/

/*def var tmpvar_dec as dec .*/
	/*�����䭫��--BEGIN*/
	find first xxpt_mstr where xxpt_part = tmp_so_part no-lock no-error.
	if avail xxpt_mstr then do:
		
		/*�����䭫*/
			assign xxshd_part_net_weight = round(xxshd_so_qty * xxpt_net_weight ,2) .
		/*���Ƥ�*/
			assign xxshd_part_gross_weight = round( (xxshd_part_net_weight /*�䭫*/
						+	xxpt_ct_weight * xxshd_carton   /*�d�q�`��*/
						+	xxpt_pt_weight * xxshd_pallet ),2)  /*�d�O�`��*/ .
		
	end.   /*�����@XXPT_MSTR*/
	else do:

	end.
	/*�����䭫��--END*/

	/*�y���䭫��--BEGIN*/
	IF tmp_seat_part <> "" then do:
		find first cp_mstr where cp_cust_part = tmp_seat_part no-lock no-error.
		if avail cp_mstr then do:
			find first xxpt_mstr where xxpt_part = cp_part no-lock no-error.
			if avail xxpt_mstr then do:
				/*�y�ȥd�q�ƶq����n-BEGIN-by ching 20060727*/	
				
                                       /* seat carton and seat tiji */
					 if xxpt_ct_pcs<>0 then do:
						   xxshd_seat_carton= round(xxshd_so_qty / xxpt_ct_pcs,2) .
						   run getinteger(input-output xxshd_seat_carton) .
					  end. 
                                         assign xxshd_seat_tiji=(xxshd_seat_carton * (xxpt_ct_long * xxpt_ct_width * xxpt_ct_high)) / 1000000.
                                         
				 /*�y�ȥd�q�ƶq����n-END*/

				/*�����䭫*/
					assign xxshd_seat_net_weight = round(xxshd_so_qty * xxpt_net_weight ,2) .
				/*���Ƥ�*/
					assign xxshd_seat_gross_weight = round( (xxshd_seat_net_weight /*�䭫*/
								+	xxpt_ct_weight * xxshd_seat_carton ),2).  /*�d�q�`��*/

				

			end.   /*�����@XXPT_MSTR*/
			else do:
                               
			end.
		END.
	END.
	/*�y���䭫��--END*/

/*�����䭫�򭫤ήy���䭫��--END*/