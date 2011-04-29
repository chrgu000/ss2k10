/*根據卡板SIZE和卡板最大層數及每層卡通數，卡通高度算出SIZE及體積-BEGIN*/

/*mage del def var tmpvar_dec as dec .  */

	find first xxpt_mstr where xxpt_part = tmp_so_part no-lock no-error.
	if avail xxpt_mstr then do:
		assign xxshd_output_max = DEC(xxpt_output_max ).   /*輸出的最大功率*/
		if xxshd_pallet <> 0 then do:
		if xxshd_pallet > xxshd_dec[1] then do:    /*12>11.2  or 1 > 0.2*/   

			if xxshd_pallet <> 1 then do:
				/*第一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-BEGIN*/
				  assign
					xxshd_size1 =	trim(string(xxpt_pt_long,">>>9.9")) + "CMx"
						+	trim(string(xxpt_pt_width,">>>9.9")) + "CMx"
						+	trim(string(xxpt_pt_high + xxpt_pt_maxcheng * xxpt_ct_high,">>>9.9")) + "CM "
						+	"P/No " + string(xxshd_pallet_No) + "-" + string(xxshd_pallet_No + xxshd_pallet - 2 ) .								
				/*第一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-END*/

				/*最後一卡板SIZE=卡板長*卡板寬*（板厚+ 尾數卡通的層數*卡通高)-BEGIN*/
				  tmpvar_dec = xxshd_carton - xxpt_pt_maxcheng * xxpt_pt_pcscheng * (xxshd_pallet - 1 ) .
				  tmpvar_dec = tmpvar_dec / xxpt_pt_pcscheng .
				  run getinteger(input-output tmpvar_dec) .
				  
				  assign
					xxshd_size2 =	trim(string(xxpt_pt_long,">>>9.9")) + "CMx"
						+	trim(string(xxpt_pt_width,">>>9.9")) + "CMx"
						+	trim(string(xxpt_pt_high + tmpvar_dec * xxpt_ct_high,">>>9.9")) + "CM "
						+	"P/No " + string(xxshd_pallet_No + xxshd_pallet - 1) .								
				/*最後一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-END*/

				/*算出總體積--BEGIN*/

				  assign
					xxshd_tiji = ( xxpt_pt_long * xxpt_pt_width * (xxpt_pt_high + xxpt_pt_maxcheng * xxpt_ct_high) * (xxshd_pallet - 1 ) 
						+ xxpt_pt_long * xxpt_pt_width * (xxpt_pt_high + tmpvar_dec * xxpt_ct_high) ) / 1000000 .
				/*算出總體積--END*/
			end.  /*xxshd_pallet <> 1 */
			else do:	/*xxshd_pallet = 1 */
				/*最後一卡板SIZE=卡板長*卡板寬*（板厚+ 尾數卡通的層數*卡通高)-BEGIN*/
				  
				  tmpvar_dec = xxshd_carton / xxpt_pt_pcscheng .
				  run getinteger(input-output tmpvar_dec) .
				  
				  assign
					xxshd_size1 =	trim(string(xxpt_pt_long,">>>9.9")) + "CMx"
						+	trim(string(xxpt_pt_width,">>>9.9")) + "CMx"
						+	trim(string(xxpt_pt_high + tmpvar_dec * xxpt_ct_high,">>>9.9")) + "CM "
						+	"P/No " + string(xxshd_pallet_No + xxshd_pallet - 1) .								
				/*最後一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-END*/

				/*算出總體積--BEGIN*/

				  assign
					xxshd_tiji = 
						( xxpt_pt_long * xxpt_pt_width * (xxpt_pt_high + tmpvar_dec * xxpt_ct_high) ) / 1000000 .
				/*算出總體積--END*/

			end.


		end.

		if xxshd_pallet < xxshd_dec[1] then do:    /*11<11.2*/

			/*第一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-BEGIN*/
			  assign
				xxshd_size1 =	trim(string(xxpt_pt_long,">>>9.9")) + "CMx"
					+	trim(string(xxpt_pt_width,">>>9.9")) + "CMx"
					+	trim(string(xxpt_pt_high + xxpt_pt_maxcheng * xxpt_ct_high,">>>9.9")) + "CM "
					+	"P/No " + string(xxshd_pallet_No) .
				if xxshd_pallet <> 1 then assign xxshd_size1 = xxshd_size1 +	
					"-" + string(xxshd_pallet_No + xxshd_pallet - 1 ) .								
			/*第一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-END*/

			/*最後尾數卡通SIZE=卡通長*卡通寬*卡通高)-BEGIN*/			  	  
			  assign
				xxshd_size2 =	trim(string(xxpt_ct_long,">>>9.9") ) + "CMx"
					+	trim(string(xxpt_ct_width,">>>9.9") ) + "CMx"
					+	trim(string(xxpt_ct_high,">>>9.9") ) + "CM "
					+	"C/No " + string(xxshd_carton_No + xxshd_carton - xxshd_blance_qty ) .
				if xxshd_blance_qty <> 1 then assign xxshd_size2 = xxshd_size2
					+	"-" + string(xxshd_carton_No + xxshd_carton - 1) .								
			/*最後尾數卡通SIZE=卡通長*卡通寬*卡通高)-END*/

			/*算出總體積-卡板+卡通的體積--BEGIN*/

			  assign
				xxshd_tiji = ( xxpt_pt_long * xxpt_pt_width * (xxpt_pt_high + xxpt_pt_maxcheng * xxpt_ct_high) * (xxshd_pallet ) 
					+ xxpt_ct_long * xxpt_ct_width * xxpt_ct_high * xxshd_blance_qty ) / 1000000 .
			/*算出總體積--END*/

		end.

		if xxshd_pallet = xxshd_dec[1] then do:    /*11=11*/

			/*第一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-BEGIN*/
			  assign
				xxshd_size1 =	trim(string(xxpt_pt_long,">>>9.9")) + "CMx"
					+	trim(string(xxpt_pt_width,">>>9.9")) + "CMx"
					+	trim(string(xxpt_pt_high + xxpt_pt_maxcheng * xxpt_ct_high,">>>9.9")) + "CM "
					+	"P/No " + string(xxshd_pallet_No) .
					if xxshd_pallet <> 1 then assign xxshd_size1 = xxshd_size1 
					+ "-" + string(xxshd_pallet_No + xxshd_pallet - 1 ) .								
			/*第一卡板SIZE=卡板長*卡板寬*（板厚+最大層*卡通高)-END*/		
				assign xxshd_size2 = "" .
			/*算出總體積-卡板+卡通的體積--BEGIN*/

			  assign
				xxshd_tiji = ( xxpt_pt_long * xxpt_pt_width * (xxpt_pt_high + xxpt_pt_maxcheng * xxpt_ct_high) * (xxshd_pallet ) 
					) / 1000000 .
			/*算出總體積--END*/

		end.
		end.   /*if xxshd_pallet <> 0 */
		else do:	/*if xxshd_pallet = 0 */
			/*最後尾數卡通SIZE=卡通長*卡通寬*卡通高)-BEGIN*/
			  assign xxshd_size2 = "".
			  assign
				xxshd_size1 =	trim(string(xxpt_ct_long,">>>9.9")) + "CMx"
					+	trim(string(xxpt_ct_width,">>>9.9")) + "CMx"
					+	trim(string(xxpt_ct_high,">>>9.9")) + "CM "
					+	"C/No " + string(xxshd_carton_No + xxshd_carton - xxshd_blance_qty ) .
				if xxshd_blance_qty <> 1 then 
				    assign xxshd_size1 = xxshd_size1
					+	"-" + string(xxshd_carton_No + xxshd_carton - 1) .								
			/*最後尾數卡通SIZE=卡通長*卡通寬*卡通高)-END*/

			/*算出總體積-卡板+卡通的體積--BEGIN*/

			  assign
				xxshd_tiji = ( xxpt_ct_long * xxpt_ct_width * xxpt_ct_high * xxshd_blance_qty ) / 1000000 .
			/*算出總體積--END*/
		end.

		run cutdot(input-output xxshd_size1) .
		run cutdot(input-output xxshd_size2) .
	end.   /*有維護XXPT_MSTR*/
	else do:

	end.
/*根據卡板SIZE和卡板最大層數及每層卡通數，卡通高度算出SIZE及體積-END*/

