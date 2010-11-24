/* SS - 090730.1 By: Neil Gao */
/* SS - 091021.1 By: Neil Gao */
/* SS - 091112.1 By: Neil Gao */

{mfdtitle.i "091112.1"}

define var yr like glc_year.
define var per like glc_per.
define var part like pt_part.
define var part2 like pt_part.
define var xxqty01 like ld_qty_oh.
define var xxqty02 like ld_qty_oh.
define var xxprc01 like pt_price.
define var tqty01 like ld_qty_oh.
define var tamt01 like ar_amt.
define var tqty02 like ld_qty_oh.
define var tamt02 like ar_amt.
define var tqty03 like ld_qty_oh.
define var tamt03 like ar_amt.
define var tqty04 like ld_qty_oh.
define var tamt04 like ar_amt.
define var xxamt01 like ar_amt.
define var xxamt02 like ar_amt.
define var xxqty03 like ld_qty_oh.
define var xxamt03 like ar_amt.
define var xxqty04 like ld_qty_oh.
define var xxamt04 like ar_amt.

form
	yr colon 15
	per colon 15
	part colon 15
	part2 colon 48
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
mainloop:
repeat:
	
	if part2 = hi_char then part2 = "".
	
	update yr per part part2 with frame a.
	
	if part2 = "" then part2 = hi_char.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "�ڼ䲻����".
	 	next.
	end.

	{mfselprt.i "printer" 132}
	
	for each xxld_det where xxld_domain = global_domain
		and xxld_part >= part and xxld_part <= part2 no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = xxld_part no-lock,
		each vd_mstr where vd_domain = global_domain and vd_addr = xxld_vend no-lock
		break by xxld_vend by xxld_part:
		
		if first-of( xxld_part ) then do:
			xxqty04 = 0.
			xxamt04 = 0.
		end.
		
		xxqty04 = xxqty04 + xxld_qty.
		xxamt04 = xxamt04 + xxld_qty * xxld_tax_price.
		
		if last-of( xxld_part ) then do:
			tqty01 = 0.
			tqty02 = 0.
			tqty03 = 0.
			tamt01 = 0.
			tamt02 = 0.
			tamt03 = 0.
			for each xxtr_hist where xxtr_domain = global_domain 
				and (xxtr_year < yr or (xxtr_year = yr and xxtr_per >= per))
				and xxtr_vend = xxld_vend and xxtr_part = xxld_part no-lock:
				
				if xxtr_year = yr and xxtr_per = per then do:
					if xxtr_sort = "in" then do:
						tqty01 = tqty01 + xxtr_qty.
/* SS 091112.1 - B */
/*
						tamt01 = tamt01 + xxtr_amt.
*/
						tamt01 = tamt01 + xxtr_amt / ( 1 + xxtr_tax_pct / 100 ).
/* SS 091112.1 - E */
					end.
					else do:
						tqty02 = tqty02 + xxtr_qty.
/* SS 091112.1 - B */
/*
						tamt02 = tamt02 + xxtr_amt.
*/
						tamt02 = tamt02 + xxtr_amt / ( 1 + xxtr_tax_pct / 100 ).
/* SS 091112.1 - E */
					end.
				end.
				else do:
					if xxtr_sort = "in" then do:
						tqty03 = tqty03 + xxtr_qty.
/* SS 091112.1 - B */
/*
						tamt03 = tamt03 + xxtr_amt.
*/
						tamt03 = tamt03 + xxtr_amt / ( 1 + xxtr_tax_pct / 100 ).
/* SS 091112.1 - E */
					end.
					else do:
						tqty03 = tqty03 - xxtr_qty.
/* SS 091112.1 - B */
/*
						tamt03 = tamt03 - xxtr_amt.
*/
						tamt03 = tamt03 - xxtr_amt / ( 1 + xxtr_tax_pct / 100 ).
/* SS 091112.1 - E */
					end.
				end.
				
			end. /* for each xxtr_hist */
			
			xxqty01 = xxqty04 - tqty03 - tqty01 + tqty02.
			xxamt01 = xxamt04 - tamt03 - tamt01 + tamt02.
			xxqty02 = tqty01.
			xxamt02 = tamt01.
			xxqty03 = tqty02.
			xxamt03 = tamt02.
			xxqty04 = xxqty04 - tqty03.
			xxamt04 = xxamt04 - tamt03.
			
			disp 	xxld_vend column-label "��Ӧ�̱���"
						vd_sort   column-label "��Ӧ�̼��"
						xxld_part column-label "���ϱ���"
						pt_desc1  column-label "��������"
						xxqty01   column-label "�ڳ�����"
						xxamt01   column-label "�ڳ����"
						xxqty02   column-label "�������"
						xxamt02   column-label "�����"
						xxqty03   column-label "��������"
						xxamt03   column-label "������"
						xxqty04   column-label "�������"
						xxamt04   column-label "�����"
						with stream-io width 300. 
					
		end.
	end.
	
	{mfreset.i}
	{mfgrptrm.i}

end. /* mainloop */
	
	