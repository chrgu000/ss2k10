/*By: Neil Gao 08/11/06 ECO: *SS 20081106* */

{mfdtitle.i "N+ "}

define variable site like ld_site.
define variable sonbr	like so_nbr.
define variable sonbr1	like sonbr.
define variable rdate as date.
define variable rdate1 as date.
define variable part  like pt_part.
define variable part2 like pt_part.
define variable pline like lnd_line.
define variable pline1 like lnd_line.

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
	pline colon 15
	pline1 colon 45
	part  colon 15
	part2 colon 45 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	xxseq_due_date  column-label "生产日期"
	xxseq_line      column-label "生产线"
	xxseq_sod_nbr   column-label "销售订单"
	xxseq_sod_line  column-label "项"
	pt_part      
	pt_desc1 				
	xxseq_qty				column-label "数量"
	xxseq_shift1 		column-label "工时"
	xxseq_user1			 format "x(1)" column-label "状态"
with frame c down width 200 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

mainloop:
repeat:
	
	if sonbr1 = hi_char then sonbr1 = "".
  if part2 = hi_char then part2 = "".
  if rdate = low_date then rdate = ?.
  if rdate1 = hi_date then rdate1 = ?.
  if pline1 = hi_char then pline1 = "".
  
  update sonbr sonbr1 rdate rdate1 pline pline1 part part2 with frame a.
  
  if sonbr1 = "" then sonbr1 = hi_char.
  if part2  = "" then part2 = hi_char.
  if rdate  = ? then rdate = low_date.
  if rdate1  = ? then rdate1 = hi_date.
  if pline1 = "" then pline1 = hi_char.
  
  {mfselprt.i "printer" 132}
	
	for each xxseq_mstr use-index xxseq_site where xxseq_domain = global_domain 
		and xxseq_sod_nbr >= sonbr and xxseq_sod_nbr <= sonbr1
		and xxseq_part >= part and xxseq_part <= part2
		and xxseq_due_date >= rdate and xxseq_due_date <= rdate1
		and xxseq_line >= pline and xxseq_line <= pline1 no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = xxseq_part no-lock
		break by xxseq_due_date by xxseq_line:
	
		accumulate xxseq_qty ( total by xxseq_line) .
		accumulate xxseq_shift1 ( total  by xxseq_line ).
		
		disp 	xxseq_due_date xxseq_line 
					xxseq_sod_nbr 
					xxseq_sod_line 
					pt_part 
					pt_desc1 
					xxseq_qty 
					xxseq_shift1
					xxseq_user1
		with frame c.
		
		if xxseq_user1 <> "P" then do:
			find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot no-lock no-error.
			if not avail wo_mstr then do:
				disp "X" @ xxseq_user1 with frame c.
			end.
		end.
		down with frame c.
		
		if last-of(xxseq_line) then do:
			disp 	xxseq_due_date 
						xxseq_line
						accum total by xxseq_line xxseq_qty @ xxseq_qty
						accum total by xxseq_line xxseq_shift1 @ xxseq_shift1
			with frame c.
			down with frame c.
		end.
		
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end.

