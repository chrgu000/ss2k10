/*By: Neil Gao 08/09/02 ECO: *SS 20080902* */

	{mfdtitle.i "n1"}

define var cust like so_cust.
define var cust1 like so_cust.
define variable effdate as date .
define variable effdate1 as date.
define var invnbr like ih_nbr.
define var invnbr1 like ih_nbr.
define var sonbr like so_nbr.
define var sonbr1 like so_nbr.
define variable tmpprice like pt_price.
define var desc2 like pt_desc2.
define var tqty1 as deci.
define var exrrate like exr_rate.
define var et_report_curr like so_curr.
define var curr_amt like ar_amt .
define var curr_amt1 like ar_amt.
define var curr_amt2 like ar_amt.
define var totamt like ar_amt.
define var mc-error-number as int.
define var vatprice like sod_price.
define var novatprice like sod_price.
define var zccost like sod_price.
/*SS 20090302 - B*/
define var xxinv as char format "x(18)".
define var xxinv1 like xxinv.
/*SS 20090302 - E*/

form
   effdate		colon 15	effdate1 colon 45 label "至"
   cust 		colon 15 	cust1  colon 45
   invnbr 	colon 15  invnbr1 colon 45
   xxinv		colon 15  label "长发票号"
   xxinv1 colon 45    label "至"
   sonbr		colon 15  sonbr1 colon 45
   et_report_curr colon 15
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

et_report_curr = base_curr.

	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

		
		if cust1  = hi_char then cust1 = "".
		if effdate  = low_date then effdate = ?.
		if effdate1 = hi_date then effdate1 = ?.
		if sonbr1 = hi_char then sonbr1 = "".
		if invnbr1 = hi_char then invnbr1 = "".
		if xxinv1 = hi_char then xxinv1 = "".

		
		IF c-application-mode <> 'web':u THEN
	   update
			effdate effdate1
			cust cust1
			invnbr invnbr1
			xxinv xxinv1
			sonbr sonbr1
			et_report_curr
		 WITH FRAME a.
		
		if cust1 = "" then cust1 = hi_char.
		if effdate = ? then effdate = low_date.
		if effdate1 = ? then effdate1 = hi_date.
		if invnbr1 = "" then invnbr1 = hi_char.
		if sonbr1 = "" then sonbr1 = hi_char.
		if xxinv1 = "" then xxinv1 = hi_char.
		
    {mfselprt.i "printer" 120}

		put "发票号;"	"长发票号;" "发票日期;"	"客户代码;"	"客户名称;"	"订单号;"	"产品编码;"	"老机型;"	"产品描述;"	"单位;"	"订单量;"	"发票数量;"	"欠交量;"	
				"原币;"	"含税单价;"	"不含税单价;"	"不含税金额;"	"税率;"	"税金;"	"含税金额;"	"汇率;"	"本币含税金额;"	"销售部门;"	"业务员;" "直材单位成本;"
				skip.
	
		for each ih_hist where ih_domain = global_domain and ih_inv_nbr >= invnbr and ih_inv_nbr <= invnbr1 
			and ih_inv_date >= effdate and ih_inv_date <= effdate1 and ih_nbr >= sonbr and ih_nbr <= sonbr1
			and ih_po >= xxinv and ih_po <= xxinv1
			and (ih_curr = et_report_curr or et_report_curr = "" ) no-lock,
			each ad_mstr where ad_domain = global_domain and ad_addr = ih_cust no-lock,
			each idh_hist where idh_domain = global_domain and ih_nbr = idh_nbr and idh_inv_nbr = ih_inv_nbr no-lock:
			
			/*
				find last exr_rate where exr_domain = global_domain and exr_curr1 = "RMB" and exr_curr2 = ih_curr 
				and exr_start_date <= today and exr_end_date >= today no-lock no-error.
				if avail exr_rate then exrrate = exr_rate / exr_rate2.
				else do:
					find last exr_rate where exr_domain = global_domain and exr_curr2 = "RMB" and exr_curr1 = ih_curr 
					and exr_start_date <= today and exr_end_date >= today no-lock no-error.
					if avail exr_rate then exrrate = exr_rate2 / exr_rate.
					else exrrate = 1.
				end.
			*/
			exrrate = ih_ex_rate2 / ih_ex_rate.
			
			find last tx2_mstr where tx2_domain = global_domain and tx2_tax_type = "VAT" and tx2_pt_taxc = idh_taxc
				 and tx2_tax_usage = idh_tax_usage and tx2_effdate <= today no-lock no-error.
			if idh_tax_in then do:
				if avail tx2_mstr then do:
					novatprice = idh_price / ( 1 + tx2_tax_pct / 100 ).
					vatprice = idh_price.
				end.
				else do:
					novatprice = idh_price.
					vatprice = idh_price.
				end.
			end.
			else do:
				if avail tx2_mstr then do:
					novatprice = idh_price.
					vatprice = idh_price * ( 1 + tx2_tax_pct / 100 ).
				end.
				else do:
					novatprice = idh_price.
					vatprice   = idh_price.
				end.
			end.
			find first pt_mstr where pt_domain = global_domain and pt_part = idh_part no-lock no-error.
			if not avail pt_mstr then next.
			find first cd_det where cd_domain = global_domain and cd_ref = idh_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
			if avail cd_det then desc2 = cd_cmmt[1] + cd_cmmt[2] + cd_cmmt[3] + cd_cmmt[4] + cd_cmmt[5]. 
			else desc2 = "".
			desc2 = replace(desc2,";",",").
				
			
			put ih_inv_nbr ";" ih_po ";" ih_inv_date ";" ih_cust ";" ad_name ";" ih_nbr ";" idh_part ";" 
					pt_desc1 ";" desc2 ";" pt_um ";"
					idh_qty_ord ";" idh_qty_inv ";" (idh_qty_ord - idh_qty_inv) ";" ih_curr ";"
					vatprice ";" novatprice ";" novatprice * idh_qty_inv format "->>>>>>>>9.99" ";" .
			if avail tx2_mstr then put tx2_tax_pct .  put ";".
			put (vatprice - novatprice) * idh_qty_inv format "->>>>>>>>9.99" ";"
					vatprice * idh_qty_inv format "->>>>>>>>9.99" ";"
					exrrate ";"
					vatprice * idh_qty_inv * exrrate format "->>>>>>>>9.99" ";".
			if ih_nbr begins "1" then put "国贸" .
			else if ih_nbr begins "2" then put "国内销售".
			else if ih_nbr begins "3" then put "技术".
			else if ih_nbr begins "4" or ih_nbr begins "6" or ih_nbr begins "8" then put "国内散件".
			else if ih_nbr begins "5" or ih_nbr begins "7" then put "国外散件".
			else if ih_nbr begins "T" then put "退回拆机".		
			put ";".
			find first sp_mstr where sp_domain = global_domain and sp_addr = ih_slspsn[1] no-lock no-error.
			if avail sp_mstr then put unformat sp_sort.
			put ";".
			
			zccost = 0.
			for each tr_hist use-index tr_nbr_eff where tr_domain = global_domain and tr_nbr = ih_nbr + string(idh_line,"999")
				and tr_type = "iss-wo" no-lock :
				find last xxpc_mstr where xxpc_domain = global_domain and xxpc_part = tr_part and (xxpc_start <= today or xxpc_start = ?)
				and xxpc_list = substring(tr_serial,10) and (xxpc_expire >= today or xxpc_expire = ?) no-lock no-error.
				if avail xxpc_mstr then 
					zccost = zccost - tr_qty_loc * xxpc_amt[1].
			end.
			if zccost = 0 then do:
				for each tr_hist use-index tr_nbr_eff where tr_domain = global_domain and tr_nbr = ih_nbr and tr_Line =  idh_line
				and tr_type = "iss-so" no-lock :
					find last xxpc_mstr where xxpc_domain = global_domain and xxpc_part = tr_part and (xxpc_start <= today or xxpc_start = ?)
					and xxpc_list = substring(tr_serial,10) and (xxpc_expire >= today or xxpc_expire = ?) no-lock no-error.
					if avail xxpc_mstr then 
						zccost = zccost - tr_qty_loc * xxpc_amt[1].
				end.
			end.
			if idh_qty_ord <> 0 then 
			put zccost / idh_qty_ord format "->>>>>>>>9.99".
			
			put ";" skip.
		end.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    