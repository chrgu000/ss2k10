/*By: Neil Gao 08/08/11 ECO: *SS 20080811* */

	{mfdtitle.i "b+ "}

define var cust like so_cust.
define var cust1 like so_cust.
define variable effdate as date .
define variable effdate1 as date.
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

form
   effdate		colon 15	effdate1 colon 45 label "至"
   cust 		colon 15 	cust1  colon 45
   et_report_curr colon 15
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

		et_report_curr = base_curr.
		if cust1  = hi_char then cust1 = "".
		if effdate  = low_date then effdate = ?.
		if effdate1 = hi_date then effdate1 = ?.
		
		IF c-application-mode <> 'web':u THEN
	   update
			effdate effdate1
			cust cust1
			et_report_curr
		 WITH FRAME a.
		
		if cust1 = "" then cust1 = hi_char.
		if effdate = ? then effdate = low_date.
		if effdate1 = ? then effdate1 = hi_date.
		
    {mfselprt.i "printer" 120}
		
		put ";;;;" "期初余额;;"	"本期发生应收;;" "本期回款;;"	"应收账款余额;;" skip.	

		put "客户编码;"	"客户名称;"	"原币;"	"汇率;"	"原币金额;"	"本币金额;"	
				"原币金额;"	"本币金额;"	"原币金额;"	"本币金额;"	"原币金额;"	"本币金额;" skip.
			
		for each ar_mstr where ar_domain = global_domain and ar_bill >= cust and ar_bill <= cust1
			and (ar_curr = et_report_curr or et_report_curr = "")
			/*and ar_effdate >= effdate*/ and ar_effdate <= effdate1 no-lock,
			each ad_mstr where ad_domain = global_domain and ad_addr = ar_bill no-lock 
			break by ar_bill by ar_curr:
			 
			if ar_effdate <= effdate then do:
				curr_amt = curr_amt + ar_amt /*- ar_applied*/.
				/*accumulate curr_amt (total by ar_curr).*/
			end.
			else do:
				if ar_type = "P" or ar_type = "D" or ar_type = "A" then do:
					curr_amt2 = curr_amt2 - ar_amt .
				end.
				else do:
					curr_amt1 = curr_amt1 + ar_amt .
				end.
			end.
			
			if last-of(ar_curr) then do:
				find last exr_rate where exr_domain = global_domain and exr_curr1 = "RMB" and exr_curr2 = ar_curr 
				and exr_start_date <= min(today,effdate1) and exr_end_date >= min(today,effdate1) no-lock no-error.
				if avail exr_rate then exrrate = exr_rate / exr_rate2.
				else do:
					find last exr_rate where exr_domain = global_domain and exr_curr2 = "RMB" and exr_curr1 = ar_curr 
					and exr_start_date <= min(today,effdate1) and exr_end_date >= min(today,effdate1) no-lock no-error.
					if avail exr_rate then exrrate = exr_rate2 / exr_rate.
					else exrrate = 1.
				end.
				
				put ar_bill ";" ad_name ";" ar_curr ";" exrrate format ">>>>>>>9.9<<<" ";" 
						curr_amt format "->>>>>>>>9.99" ";" 
					  curr_amt * exrrate format "->>>>>>>>9.99" ";"
					  curr_amt1 format "->>>>>>>>9.99" ";" 
					  curr_amt1 * exrrate format "->>>>>>>>9.99" ";"
					  curr_amt2 format "->>>>>>>>9.99" ";" 
					  curr_amt2 * exrrate format "->>>>>>>>9.99" ";"
					  ( curr_amt + curr_amt1 - curr_amt2 ) format "->>>>>>>>9.99" ";"
						( curr_amt + curr_amt1 - curr_amt2 ) * exrrate format "->>>>>>>>9.99"
						";" skip.
				curr_amt = 0.
				curr_amt1 = 0.
				curr_amt2 = 0.
			end.
		end.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    