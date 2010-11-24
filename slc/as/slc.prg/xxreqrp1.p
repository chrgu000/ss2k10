/*By: Neil Gao 08/10/08 ECO: *SS 20081008* */

{mfdtitle.i "N+ "}

define variable sonbr	like so_nbr.
define variable sonbr1	like sonbr.
define variable rdate as date.
define variable rdate1 as date.
define variable part  like pt_part.
define variable part2 like pt_part.

define temp-table tt1
	field tt1_part like pt_part
	field tt1_date as date
	field tt1_qty  like ld_qty_oh
	index tt1_part
				tt1_part tt1_date.

form
	sonbr colon 15
	sonbr1 colon 45
	rdate colon 15
	rdate1 colon 45
	part  colon 15
	part2 colon 45 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat:
	
	if sonbr1 = hi_char then sonbr1 = "".
  if part2 = hi_char then part2 = "".
  if rdate = low_date then rdate = ?.
  if rdate1 = hi_date then rdate1 = ?.
  
  update sonbr sonbr1 rdate rdate1 part part2 with frame a.
  
  if sonbr1 = "" then sonbr1 = hi_char.
  if part2  = "" then part2 = hi_char.
  if rdate  = ? then rdate = low_date.
  if rdate1  = ? then rdate1 = hi_date.
  
  {mfselprt.i "printer" 132}
  
  empty temp-table tt1.
  for each xxseq_mstr where xxseq_domain = global_domain and xxseq_user1 = "P" 
  	and xxseq_sod_nbr >= sonbr and xxseq_sod_nbr <= sonbr1 
  	and xxseq_part >= part and xxseq_part <= part2
  	and xxseq_due_date >= rdate and xxseq_due_date <= rdate1 no-lock:
  		
  	run crttt1 (input xxseq_part,input xxseq_due_date ,input xxseq_qty_req,input today).
  
	end.
	
	for each tt1 no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = tt1_part no-lock
		break by tt1_part with frame c width 120:
		
		accumulate tt1_qty (total by tt1_part).
		
		disp 	tt1_part label "物料号"
					pt_desc1 label "说明"
					pt_desc2 label "说明"
					tt1_date label "日期"
					tt1_qty  label "数量"
		with frame c.
		down with frame c.
		if last-of(tt1_part) then do:
			disp 	tt1_part label "物料号"
						pt_desc1 label "说明"
						pt_desc2 label "说明"
						"合计:" @ tt1_date
						accumu total by tt1_part ( tt1_qty )  @ tt1_qty
			with frame c.
			down with frame c.
		end.
		
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end.

procedure crttt1:
	define input parameter iptpart like pt_part.
	define input parameter iptdate as date.
	define input parameter iptqty like ld_qty_oh.
	define input parameter ipteff  as date.
	for each ps_mstr where ps_domain = global_domain and ps_par = iptpart and ps_ps_code = ""
		and ( ps_start <= ipteff or ps_start = ? )
		and ( ps_end >= ipteff or ps_end = ? ) no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock
		break by ps_comp by ps_ref by ps_start:
		if last-of(ps_start) then do:
			if pt_pm_code = "P" then do:
				find first tt1 where tt1_part = pt_part and tt1_date = iptdate no-error.
				if not avail tt1 then do:
					create tt1.
					assign tt1_part = pt_part
								 tt1_date = iptdate
								 tt1_qty  = iptqty * ps_qty_per.
				end.
				else do:
					tt1_qty = tt1_qty + iptqty * ps_qty_per.
				end.
			end.
			else do:
				run crttt1 (input pt_part,input iptdate,input iptqty * ps_qty_per,input today ).
			end.
		end.
	end.
end procedure.
