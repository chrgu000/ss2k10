/*By: Neil Gao 08/08/11 ECO: *SS 20080811* */

	{mfdtitle.i "n1"}

define var cust like so_cust.
define var cust1 like so_cust.
define variable duedate as date .
define variable duedate1 as date.
define variable tmpprice like pt_price.
define var desc2 like pt_desc2.
define var tqty1 as deci.
define var exrrate like exr_rate.
define var et_report_curr like so_curr.
define var curr_amt like ar_amt .
define var totamt like ar_amt.
define var mc-error-number as int.

form
   cust 		colon 15 	cust1  colon 45
   duedate		colon 15	duedate1 colon 45 label "至"
   et_report_curr colon 15
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

		et_report_curr = base_curr.
		if cust1  = hi_char then cust1 = "".
		if duedate  = low_date then duedate = ?.
		if duedate1 = hi_date then duedate1 = ?.
		
		IF c-application-mode <> 'web':u THEN
	   update
			cust cust1
			duedate duedate1
			et_report_curr
		 WITH FRAME a.
		
		if cust1 = "" then cust1 = hi_char.
		if duedate = ? then duedate = low_date.
		if duedate1 = ? then duedate1 = hi_date.
		
    {mfselprt.i "printer" 120}
		
		put ";;应收账款余额明细表" skip.
		
		put "客户编码;"	"客户名称;"	"原币;"	"汇率;"	"原币金额;"	"本币金额;" skip.
			
		for each ar_mstr where ar_domain = global_domain and ar_bill >= cust and ar_bill <= cust1
			and ar_type <> "A" and (not ar_type = "D" or ar_draft = true)
			and ar_effdate >= duedate and ar_effdate <= duedate1 no-lock,
			each ad_mstr where ad_domain = global_domain and ad_addr = ar_bill no-lock 
			break by ar_bill by ar_curr:
			
			if ar_curr <> et_report_curr and et_report_curr <> "" then next. 
			if ar_type <> "D" then curr_amt = ar_amt.
			else curr_amt = ar_amt - ar_applied.
			accumulate curr_amt (total by ar_curr).

/*SS 20090304 - B*/
/*
			{gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ar_curr,
                       input base_curr,
                       input ar_ex_rate,
                       input ar_ex_rate2,
                       input curr_amt,
                       input true,
                       output totamt,
                       output mc-error-number)"}
      accumulate totamt (total by ar_curr).
      
      if mc-error-number <> 0 then do:
      	{pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
*/
/*SS 20090304 - E*/
      
			find last exr_rate where exr_domain = global_domain and exr_curr1 = "RMB" and exr_curr2 = ar_curr 
				and exr_start_date <= today and exr_end_date >= today no-lock no-error.
			if avail exr_rate then exrrate = exr_rate / exr_rate2.
			else do:
				find last exr_rate where exr_domain = global_domain and exr_curr2 = "RMB" and exr_curr1 = ar_curr 
				and exr_start_date <= today and exr_end_date >= today no-lock no-error.
				if avail exr_rate then exrrate = exr_rate2 / exr_rate.
				else exrrate = 1.
			end.
			
			if last-of(ar_curr) then do:
				put ar_bill ";" ad_name ";" ar_curr ";" exrrate format ">>>>>>>9.9<<<" ";" 
						accum total by ar_curr curr_amt format "->>>>>>>>9.99" ";" 
						/*accum total by ar_curr totamt format "->>>>>>>>9.99" */
						( accum total by ar_curr curr_amt ) * exrrate format "->>>>>>>>9.99"
						";" skip.
			end.
		end.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    