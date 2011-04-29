output to "/home/public/t.txt" .

for each xpk_mstr where xpk_nbr = "00000271" no-lock with frame x width 300:
disp xpk_nbr xpk__int01 xpk_sonbr xpk_soline xpk_part xpk_qty_shp with frame x.
end.
output close .





output to "/mfgeb2/bc_test/20090416.txt" .

	for each tr_hist where tr_effdate = today - 1 and tr_type = "ISS-SO" no-lock with frame x width 300:
		disp 
		tr_nbr tr_line tr_part tr_qty_chg tr_qty_loc 
		tr_site tr_loc tr_lot  
		tr_trnbr tr_date string(tr_time,"hh:mm:ss") tr_program
		with frame x. 
	end.

output close .





