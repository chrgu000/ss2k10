/* SS - 100413.1 By: Randy Li */

{mfdtitle.i "100413.1"}

DEFINE VARIABLE code like vd_addr.
DEFINE VARIABLE code1 like vd_addr .
DEFINE VARIABLE part like pt_part .
DEFINE VARIABLE part2 like pt_part.
DEFINE VARIABLE effdate as date .
define buffer ptmstr for pt_mstr.



form
code						colon 15
code1						colon 45
part						colon 15
part2 label {t001.i}		colon 45
effdate						colon 15
skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
effdate = today .
{wbrp01.i}
mainloop:
REPEAT ON ENDKEY UNDO, LEAVE:

	if code1 = hi_char then code1 = "".
	if part2 = hi_char then part2 = "".

	IF c-application-mode <> 'web':u THEN

	update code code1 part part2 effdate  with frame a.

	if code = "" then code1 = hi_char.
	if part2 = "" then part2 = hi_char.
	if effdate = ? then effdate = today .

	{mfselprt.i "printer" 650}
	for each pc_mstr where pc_list >= code and pc_list <= code1
		and pc_part >= part 
		and pc_part <= part2
		and (pc_start = ? or pc_start <= effdate )
		and (pc_expire = ? or pc_expire >= effdate)
		and pc_amt_type = "L"
		no-lock 
		break  by pc_list by pc_part by pc_start:

		find first ptmstr where  ptmstr.pt_part = pc_part no-lock no-error.
		if not avail ptmstr then next .
		find first vd_mstr where vd_addr = pc_list no-lock no-error .
		if not avail vd_mstr then next .
		display 
			pc_list								column-label "供应商"
			vd_sort								column-label "供应商名称"
			pc_part								column-label "物料编码"
			trim(pt_desc1) + trim(pt_desc2)		column-label "物料名称" format "x(48)"
			pc_start							column-label "开始日期"
			pc_expire							column-label "结束日期"
			pc_amt[1]							column-label "价格"
			pc_min_price						column-label "最低价格"
			pc_max_price[1]						column-label "最高价格"

			with stream-io width 320 .		
	end.


	
	{mfreset.i}
	{mfgrptrm.i}


END.

{wbrp04.i &frame-spec = a}