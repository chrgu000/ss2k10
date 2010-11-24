/* SS - 090520.1 By: Neil Gao */
/* SS - 090630.1 By: Neil Gao */
/* SS - 100624.1 By: Kaine Zhang */

{mfdeclre.i}
{gplabel.i}

define shared var yr like glc_year.
define shared var per like glc_per.
define shared var vend  like po_vend.
define var tamt like xxgzd_amt.
define buffer ptmstr for pt_mstr.
define var xxqty1 like tr_qty_loc.
define var xxqty2 like tr_qty_loc.
define var gzdate as date.
define var xxamt01 like xxgzd_amt.
define var xxamt02 like xxgzd_amt.

form 
	space(2)
	xxgzd_part    column-label "物料编码"
	ptmstr.pt_desc1 			column-label "车型代码"	format "x(8)"
	pt_mstr.pt_desc2      column-label "名称规格"
	xxqty1								column-label "上期未挂" format "->>>>>>9"
	xxkc_rct_po   column-label "本月入库" format "->>>>>>9"
	xxgzd_end_qty column-label "挂账数量" format "->>>>>>9"
	xxgzd_price   column-label "含税单价"
	xxgzd_tax_pct column-label "税率"    
	xxgzd_amt     column-label "含税金额" format "->>,>>>,>>9.99"
	tamt			 		column-label "未税金额" format "->>,>>>,>>9.99"
	xxqty2  			column-label "未挂账数" format "->>>>>>9"
with frame c width 200 down no-attr-space.
	
find first ad_mstr where ad_domain = global_domain and ad_addr = vend no-lock no-error.
if not avail ad_mstr then next.
find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
if not avail vd_mstr then next.
find first usr_mstr where usr_userid = global_userid no-lock no-error.
			

	for each xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per 
		and xxgzd_vend = vend and (xxgzd_qty + xxgzd_end_qty) <> 0 no-lock,
		each xxgz_mstr where xxgz_domain = global_domain and xxgz_year = yr and xxgz_per = per
			and xxgz_vend = vend no-lock
		break by xxgzd_part:
		
		find first pt_mstr where pt_domain = global_domain and pt_part = xxgzd_part no-lock no-error.
		
		if xxgz_date = ? then gzdate = today.
		else gzdate = xxgz_date.
		form header
			 per colon 50 "月挂账表" skip
			 "会计单位: " colon 2 "隆鑫工业有限公司四轮车本部"
			 "挂账日期: " colon 80 gzdate skip
			 "  供应商: " colon 2 xxgzd_vend ad_name colon 22 
		with frame fh1 page-top stream-io no-box no-label width 100.
		
		view frame fh1.
		
		if avail pt_mstr then do:
			find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
		end.
		else do:
			release ptmstr.
		end.
		find first xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per
			and xxkc_part = xxgzd_part and xxkc_vend = xxgzd_vend no-lock no-error.
        
        /* SS - 100624.1 - B */
        if not(available(xxkc_det)) then do:
            create xxkc_det.
            assign
                xxkc_domain = global_domain 
                xxkc_year = yr 
                xxkc_per = per
			    xxkc_part = xxgzd_part 
			    xxkc_vend = xxgzd_vend
			    .
        end.
        /* SS - 100624.1 - E */
		
		xxqty1 = 0.
		xxqty2 = 0.
		if vd_type = "耗用" then do:
			for each xxld_det where (xxld_year < yr or (xxld_year = yr and xxld_per < per)) and xxld_vend = xxgzd_vend and xxld_part = xxgzd_part no-lock:
				if xxld_zg_qty > 0 then xxqty1 = xxqty1 + xxld_zg_qty.
			end.
			if avail xxkc_det then do:
				xxqty1 = xxqty1 + xxkc_beg_qty.
				xxqty2 = xxkc_end_qty.
			end.
		end.
		else do:
			for each xxld_det where (xxld_year < yr or (xxld_year = yr and xxld_per < per)) and xxld_vend = xxgzd_vend and xxld_part = xxgzd_part no-lock:
				if xxld_zg_qty > 0 then xxqty1 = xxqty1 + xxld_zg_qty.
			end.
		end.
		
		tamt = xxgzd_amt / (1 + xxgzd_tax_pct / 100 ).
		disp	xxgzd_part    
					ptmstr.pt_desc1 when avail ptmstr
					pt_mstr.pt_desc2 when avail pt_mstr
					xxqty1	
					xxkc_rct_po 
					xxgzd_qty + xxgzd_end_qty @ xxgzd_end_qty 
					xxgzd_price   
					xxgzd_tax_pct     
					xxgzd_amt     
					tamt			 		
					xxqty2  			
		with frame c .
		down with frame c.
		
		xxamt01 = xxamt01 + xxgzd_amt.
		xxamt02 = xxamt02 + tamt.
		
		if page-size - line-counter <= 3 then do:
			put "供应商确认: " at 10.
			put "制表人:"      at 70.
			if avail usr_mstr then put usr_name .
			page.
		end. 
	end.	
	
	for each xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per
			and xxkc_vend = vend no-lock:
		
		find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per 
			and xxgzd_vend = vend and xxgzd_part = xxkc_part no-lock no-error.
		if avail xxgzd_det then next.
		
		find first pt_mstr where pt_domain = global_domain and pt_part = xxkc_part no-lock no-error.
		
		if avail pt_mstr then do:
			find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
		end.
		else do:
			release ptmstr.
		end.
		
		xxqty1 = 0.
		xxqty2 = 0.
		if vd_type = "耗用" then do:
			for each xxld_det where (xxld_year < yr or (xxld_year = yr and xxld_per < per)) and xxld_vend = xxkc_vend and xxld_part = xxkc_part no-lock:
				if xxld_zg_qty > 0 then xxqty1 = xxqty1 + xxld_zg_qty.
			end.
			xxqty1 = xxqty1 + xxkc_beg_qty.
			xxqty2 = xxkc_end_qty.
		end.
		else do:
			for each xxld_det where (xxld_year < yr or (xxld_year = yr and xxld_per < per)) and xxld_vend = xxkc_vend and xxld_part = xxkc_part no-lock:
				if xxld_zg_qty > 0 then xxqty1 = xxqty1 + xxld_zg_qty.
			end.
		end.
		xxqty2 = xxqty1 + xxkc_rct_po.
		disp 	xxkc_part @ xxgzd_part
					ptmstr.pt_desc1 when avail ptmstr
					pt_mstr.pt_desc2 when avail pt_mstr
					xxqty1								
					xxkc_rct_po   
					xxqty2
		with frame c .
		down with frame c.
		
		if page-size - line-counter <= 3 then do:
			put "供应商确认: " at 10.
			put "制表人:"      at 70.
			if avail usr_mstr then put usr_name .
			page.
		end.
		
	end.
	
	xxqty1 = 0.
	for each xxld_det where xxld_domain = global_domain and xxld_zg_qty > 0 and xxld_vend = vend no-lock
		break by xxld_vend by xxld_part :
		find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per 
			and xxgzd_vend = vend and xxgzd_part = xxld_part no-lock no-error.
		if avail xxgzd_det then next.
		find first xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per
			and xxkc_vend = vend and xxkc_part = xxld_part no-lock no-error.
		if avail xxkc_det then next.
		
		xxqty1 = xxqty1 + xxld_zg_qty.
		
		if last-of(xxld_part) then do:
			find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_mstr.pt_part = xxld_part no-lock no-error.
		
			if avail pt_mstr then do:
				find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
			end.
			else do:
				release ptmstr.
			end.
			xxqty2 = xxqty1.
			disp	xxld_part @ xxgzd_part
					ptmstr.pt_desc1  when avail ptmstr			
					pt_mstr.pt_desc2 when avail pt_mstr
					xxqty1								
					0 @ xxkc_rct_po   
					xxqty2
			with frame c .
			down with frame c.
			
			xxqty1 = 0.
			
			if page-size - line-counter <= 3 then do:
				put "供应商确认: " at 10.
				put "制表人:"      at 70.
				if avail usr_mstr then put usr_name .
				page.
			end.
			
		end.
	end.
	
	underline xxgzd_amt tamt with frame c.
	down with frame c.
	disp 	"合计:" @ xxgzd_part
				xxamt01  @ xxgzd_amt
				xxamt02  @ tamt
	with frame c.
	down with frame c.
			
	put skip(2).
	put "供应商确认: " at 10.
	put "制表人:"      at 70.
	if avail usr_mstr then put usr_name .	
	
   