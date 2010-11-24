/*By: Neil Gao 08/08/05 ECO: *SS 20080805* */

{mfdtitle.i "b+ "}

define var site like so_site.
define var cust like so_cust.
define var cust1 like so_cust.
define var part like sod_part.
define var part2 like sod_part.
define var ttrecid as recid.
define var first-recid as recid.
define var tchar as char format "x(40)".

define temp-table ttsod_det
	field ttsod_domain like xtsod_domain
	field ttsod_cust   like xtsod_cust
	field ttsod_shipto like xtsod_shipto
	field ttsod_ord_date like xtsod_ord_date
	field ttsod_req_date like xtsod_req_date
	field ttsod_part like xtsod_part
	field ttsod_qty  like xtsod_qty.

/*SS 20080805 - B*/
{xxdrsomt.i "new"}
/*SS 20080805 - E*/

form
	site 		colon 12
	cust 		colon 12 	cust1 	colon 45
	part 		colon 12 	part2 	colon 45
with frame a side-labels width 80 .

setframelabels(frame a:handle).

site = global_site.
	
mainloop:
repeat:
	
	if cust1 = hi_char then cust1 = "".
	if part2 = hi_char then part2 = "".
	
	update site cust cust1 part part2 with frame a.
	
	if cust1 = "" then cust1 = hi_char.
	if part2 = "" then part2 = hi_char.
	
	empty temp-table ttsod_det.
	for each xtsod_det where xtsod_domain = global_domain and xtsod_site = site
		and xtsod_cust >= cust and xtsod_cust <= cust1
		and xtsod_part >= part and xtsod_part <= part2 no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = xtsod_part no-lock
		break by xtsod_cust by xtsod_shipto :
				
		create 	ttsod_det.
		assign 	ttsod_domain = global_domain
						ttsod_cust = xtsod_cust
						ttsod_shipto = xtsod_shipto
						ttsod_ord_date = xtsod_ord_date
						ttsod_req_date = xtsod_req_date
						ttsod_part = xtsod_part
						ttsod_qty = xtsod_qty.
						
	end.
	
	find first ttsod_det no-lock no-error.
	if not avail xtsod_det then do:
		message "ÎÞ¼ÇÂ¼´æÔÚ".
		next.
	end.
	
	first-recid = ?.
	scroll_loop:
	do :
		{xuview.i
    	     &buffer = ttsod_det
    	     &scroll-field = ttsod_cust
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = ttsod_cust
    	     &display2		 = ttsod_shipto	
    	     &display3     = ttsod_part
    	     &display4     = ttsod_ord_date
    	     &display5     = ttsod_req_date
    	     &display6 		 = ttsod_qty
    	     &searchkey    =  "true"
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = scroll_loop
    	     &exit-flag = true
    	     &record-id = ttrecid
    	     &cursordown = " "
    	     &cursorup   = " "
    }
    
	end.
	if keyfunction(lastkey) = "END-ERROR" then do:
		next.
	end.
	
	for each xtsod_det where xtsod_domain = global_domain and xtsod_site = site
		and xtsod_cust >= cust and xtsod_cust <= cust1
		and xtsod_part >= part and xtsod_part <= part2 no-lock ,
		each pt_mstr where pt_domain = global_domain and pt_part = xtsod_part no-lock
		break by xtsod_cust by xtsod_shipto :
		
		
		if first-of(xtsod_shipto) then do:
			create tt_tb. assign 	tt_sel = 1 tt_f1 =  "@@begin".
			create tt_tb. assign 	tt_sel = 2 tt_f1 =  """" + """" + "," + xtsod_cust + "," + xtsod_shipto.
			create tt_tb. assign 	tt_sel = 3 tt_f1 = string(xtsod_ord_date) + " " + string(xtsod_req_date) + " - " +
														string(xtsod_req_date) + " - " + " - " + xtsod_po
														.
		end.
		
		create tt_tb. assign 		tt_sel = 4 tt_f1 =  """" + """" + "," + xtsod_part + "," + string(xtsod_qty)
														tt_recid = recid(xtsod_det).
		
		if last-of(xtsod_shipto) then do:
			 create tt_tb. assign tt_sel = 4 tt_f1 =  "@@end" .
		end.
		
	end.
	
	hide frame a no-pause.
	hide frame b no-pause.
	pause 0.
	{gprun.i ""xxdrsosomt.p""}
	
end.
