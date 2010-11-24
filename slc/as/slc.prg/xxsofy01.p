/*By: Neil Gao 08/08/11 ECO: *SS 20080811* */
/*By: Neil Gao 08/09/20 ECO: *SS 20080920* */
/*SS 20080920 - B*/
/*
增加含税单价
*/
/*SS 20080920 - E*/

	{mfdtitle.i "b+ "}

define variable sonbr like so_nbr.
define variable sonbr1 like so_nbr.
define variable part like mrp_part.
define variable part2 like mrp_part.
define var cust like so_cust.
define var cust1 like so_cust.
define variable pdate as date .
define variable pdate1 as date.
define variable pcnbr like xxpc_nbr.
define variable pcnbr2 like xxpc_nbr.
define variable effdate as date init today.
define var vend like po_vend.
define var vend1 like po_vend.
define variable tmpprice like pt_price.
define var desc2 like pt_desc2.
define var tqty1 as deci.
define var tamt1 as deci.
define var exrrate like exr_rate.

form
   sonbr		colon 15 	sonbr1 colon 45
   cust 		colon 15 	cust1  colon 45
   pdate		colon 15	pdate1 colon 45 label "至"
   part			colon 15	part2  colon 45 label "至"
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

		if sonbr1 = hi_char then sonbr1 = "".
		if cust1  = hi_char then cust1 = "".
		if pdate  = low_date then pdate = ?.
		if pdate1 = hi_date then pdate1 = ?.
		if part2 = hi_char then part2 = "".
		
		IF c-application-mode <> 'web':u THEN
	   update
			sonbr sonbr1
			cust cust1
			pdate pdate1
			part	part2
		 WITH FRAME a.
		
		if sonbr1 = "" then sonbr1 = hi_char.
		if cust1 = "" then cust1 = hi_char.
		if pdate = ? then pdate = low_date.
		if pdate1 = ? then pdate1 = hi_date.
		if part2 = "" then part2 = hi_char.
		
    {mfselprt.i "printer" 150}
		
		put ";;;产品销售发运明细表" skip.
		
		put "订单号;"	"客户编码;"	"客户名称;"	"产品编码;"	"老机型;"	"产品描述;"	"单位;"	"发运数量;"	
				"原币;"	"含税单价;" "不含税单价;"	"不含税金额;"	"税率;"	"税金;"	"含税金额;"	"汇率;"	"本币含税金额;"	"销售部门;" 
				"业务员;"	"直材单位成本;"	"标准单位成本;" skip.
		
			
		for each tr_hist where tr_domain = global_domain and tr_type = "iss-so" 
			and tr_nbr >= sonbr and tr_nbr <= sonbr1 
			and tr_addr >= cust and tr_addr <= cust1
			and tr_effdate >= pdate and tr_effdate <= pdate1
			and tr_part >= part and tr_part <= part2 no-lock,
			each sod_det where sod_domain = global_domain and sod_nbr = tr_nbr
				and sod_line = tr_line,
			each so_mstr where so_domain = global_domain and so_nbr = sod_nbr 
			break by tr_nbr by tr_line by tr_part:
			
			tqty1 = tqty1 - tr_qty_loc.
			find last xxpc_mstr where xxpc_domain = global_domain and xxpc_part = tr_part and (xxpc_start <= tr_effdate or xxpc_start = ?)
			and xxpc_list = substring(tr_serial,10) and (xxpc_expire >= tr_effdate or xxpc_expire = ?) no-lock no-error.
			if avail xxpc_mstr then tamt1 = tamt1 - xxpc_amt[1] * tr_qty_loc.			
			
			if last-of(tr_part) then do:
				if tqty1 = 0 then next.
				find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
				find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
				if avail cd_det then desc2 = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3] + cd_cmmt[4] + cd_cmmt[5]. 
				else desc2 = "".
				desc2 = replace(desc2,";",",").
				find first ad_mstr where ad_domain = global_domain and ad_addr = tr_addr no-lock no-error.
			
				put unformat tr_nbr ";" tr_addr ";" + (if avail ad_mstr then ad_name else "") + ";".
				put	unformat tr_part ";" pt_desc1 ";" desc2 ";" tr_um ";" tqty1 ";" so_curr ";".
				find last tx2_mstr where tx2_domain = global_domain and tx2_tax_type = "VAT" and tx2_pt_taxc = sod_taxc
				 and tx2_tax_usage = sod_tax_usage and tx2_effdate <= today no-lock no-error.
				find last exr_rate where exr_domain = global_domain and exr_curr1 = "RMB" and exr_curr2 = so_curr 
					and exr_start_date <= tr_effdate and exr_end_date >= tr_effdate no-lock no-error.
				if avail exr_rate then exrrate = exr_rate / exr_rate2.
				else do:
					find last exr_rate where exr_domain = global_domain and exr_curr2 = "RMB" and exr_curr1 = so_curr 
						and exr_start_date <= tr_effdate and exr_end_date >= tr_effdate no-lock no-error.
					if avail exr_rate then exrrate = exr_rate2 / exr_rate.
					else exrrate = 1.
				end.
				if sod_tax_in and avail tx2_mstr then do:
					put unformat sod_price ";" sod_price / ( 1 + tx2_tax_pct / 100 ) ";" sod_price / ( 1 + tx2_tax_pct / 100 ) * tqty1 ";"
													tx2_tax_pct ";" sod_price / ( 1 + tx2_tax_pct / 100 ) * tx2_tax_pct  / 100 * tqty1 ";"
													sod_price * tqty1 ";"
													exrrate ";" sod_price * tqty1 * exrrate ";" .
				end.
				else if not sod_tax_in and avail tx2_mstr then do:
					put unformat sod_price * ( 1 + tx2_tax_pct / 100 ) ";" sod_price ";" sod_price * tqty1 ";"
													tx2_tax_pct ";" sod_price * tx2_tax_pct / 100 * tqty1 ";"
													sod_price * ( 1 + tx2_tax_pct / 100 ) * tqty1 ";"
													exrrate ";" sod_price * ( 1 + tx2_tax_pct / 100 ) * tqty1 * exrrate ";" .
				end.
				else do:
					put unformat sod_price ";" sod_price ";" sod_price * tqty1 ";"
													0 ";" 0 ";"	sod_price * tqty1 ";"
													exrrate ";" sod_price * tqty1 * exrrate ";" .
				end.
				if tr_nbr begins "1" then put "国贸" .
				else if tr_nbr begins "2" then put "国内销售".
				else if tr_nbr begins "3" then put "技术".
				else if tr_nbr begins "4" or tr_nbr begins "6" or tr_nbr begins "8" then put "国内散件".
				else if tr_nbr begins "5" or tr_nbr begins "7" then put "国外散件".
				else if tr_nbr begins "T" then put "退回拆机".
				
				put ";".
				find first sp_mstr where sp_domain = global_domain and sp_addr = so_slspsn[1] no-lock no-error.
				if avail sp_mstr then put unformat sp_sort.
				put ";".
				if sod_qty_ord <> 0 then 
					put tamt1 / sod_qty_ord.
				put ";".
				find first sct_det where sct_domain = global_domain and sct_sim = "tj" and sct_part = tr_part no-lock no-error.
				if avail sct_det then put sct_cst_tot.
				put ";".
				
				put skip. 
				tqty1 = 0.
				tamt1 = 0.
			end.
				
		end.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    