/* Revision: eB2SP11.Chui   Modified: 08/30/06      By: Kaine Zhang     *ss-20060830.1* */

/*ss-20060830.1*  carton bug.  so edit xxshd_cno ....   */
		for each tmp :
			if tmp_sele = "Y" then do:
				find first xxshd_det where xxshd_inv_no = invno and xxshd_so_nbr = tmp_so_nbr 
							and xxshd_so_line = tmp_so_line no-error.
				if not avail xxshd_det then do:
				create xxshd_det.
				assign
					xxshd_inv_no = invno
					xxshd_so_nbr     	= 	tmp_so_nbr	
					xxshd_so_line    	= 	tmp_so_line
					.
					
				end.
				assign  xxshd_sort       	= 	tmp_sort	
					xxshd_so_part    	= 	tmp_so_part	
					xxshd_so_qty     	= 	tmp_so_qty	
					xxshd_so_price   	= 	tmp_so_price    
					xxshd_carton     	= 	tmp_carton	
					xxshd_pallet     	= 	tmp_pallet	
					xxshd_blance_qty 	= 	tmp_blance_qty  
					xxshd_carton_no  	= 	tmp_carton_no   
					xxshd_pallet_No  	= 	tmp_pallet_no   
					xxshd_ser_no     	= 	tmp_ser_no	
					xxshd_ser_no2     	= 	tmp_ser_no2	
					xxshd_yiyin_date 	= 	tmp_yiyin_date  
					xxshd_seat_part  	= 	tmp_seat_part
					xxshd_dec[1]		=	tmp_dec[1]
					.
				/*根據卡板SIZE和卡板最大層數及每層卡通數，卡通高度算出SIZE及體積-BEGIN*/
					{xxshmt03021x.i}
				/*根據卡板SIZE和卡板最大層數及每層卡通數，卡通高度算出SIZE及體積-END*/

				/*物料凈重毛重及座椅凈重毛重--BEGIN*/
					{xxshmt03022x.i}
				/*物料凈重毛重及座椅凈重毛重---END*/

				/*保存卡板號及尾數卡通號到xxshd_pallet_carton如: Pallet 1-3 Carton 1-100*/
					if xxshd_pallet <> 0 and xxshd_blance_qty <> 0 then do:
						assign xxshd_pallet_carton = "Pallet " + string(xxshd_pallet_no) .
						if xxshd_pallet <> 1 then       /*如果Pallet 1-1 就變成Pallet 1*/
							assign xxshd_pallet_carton = xxshd_pallet_carton + "-" + string(xxshd_pallet_no + xxshd_pallet - 1) .
							
							assign xxshd_pallet_carton = xxshd_pallet_carton  
								+   " Carton " + string(xxshd_carton_No + xxshd_carton - xxshd_blance_qty ) .
							if xxshd_blance_qty <> 1 then      /*如果Carton 1-1 就變成Pallet 1*/
							assign xxshd_pallet_carton = xxshd_pallet_carton + "-" + string(xxshd_carton_No + xxshd_carton - 1) .
						END.

					if xxshd_pallet = 0 and xxshd_blance_qty <> 0 then do:
						assign xxshd_pallet_carton = "Carton " + string(xxshd_carton_No + xxshd_carton - xxshd_blance_qty ) .
						if xxshd_blance_qty <> 1 then      /*如果Carton 1-1 就變成Carton 1*/
							assign xxshd_pallet_carton = xxshd_pallet_carton
								+	"-" + string(xxshd_carton_No + xxshd_carton - 1) .
						END.
					if xxshd_pallet <> 0 and xxshd_blance_qty = 0 then do:
						assign xxshd_pallet_carton = "Pallet " + string(xxshd_pallet_no) .
						if xxshd_pallet <> 1 then       /*如果Pallet 1-1 就變成Pallet 1*/
						assign xxshd_pallet_carton = xxshd_pallet_carton 
							+ "-" + string(xxshd_pallet_no + xxshd_pallet - 1).
							End.
					if xxshd_pallet = 0 and xxshd_blance_qty = 0 then
						assign xxshd_pallet_carton = "" .

				/*把Carton 1-100 保存至xxshd_cno中*/
                if xxshd_carton <> 0 then
                    assign xxshd_cno = "Carton " + string(xxshd_carton_no).
                
                if xxshd_carton <> 1 then 
                    assign xxshd_cno = xxshd_cno + "-" + string(xxshd_carton_no + xxshd_carton - 1) .
                /*ss-20060830.1*  ELSE assign xxshd_cno = "" .  */
			end.
			else do:
				for each xxshd_det where xxshd_inv_no = invno and xxshd_so_nbr = tmp_so_nbr
							and xxshd_so_line = tmp_so_line:
					 delete xxshd_det.
				end.
			end.
			delete tmp .
		end.
		release xxshd_det .
