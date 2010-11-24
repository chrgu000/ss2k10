/*By: Neil Gao 08/11/06 ECO: *SS 20081106* */
/*Modified by Billy 2009-01-08             */
/*Modified by Billy 2009-06-30             */

{mfdtitle.i "Billy+ "}

define variable site like ld_site init "10000".
define variable spnbr	like xxspl_id.
define variable spnbr1	like xxspl_id.
define variable pdate as date.
define variable pdate1 as date.
define variable part  like pt_part.
define variable part2 like pt_part.
define variable custname like cm_sort.
define variable notice as character format "x(100)".
define variable oldname like pt_desc1 format "x(14)".


form
	spnbr colon 15	label "发运计划"
	spnbr1 colon 45 label "至"
	pdate colon 15  label "发运日期"
	pdate1 colon 45 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat:
	
	if spnbr1 = hi_char then spnbr1 = "".
  if pdate = low_date then pdate = ?.
  if pdate1 = hi_date then pdate1 = ?.
  
  update spnbr spnbr1 pdate pdate1 with frame a.
  
  if spnbr1 = "" then spnbr1 = hi_char.
  if pdate  = ? then pdate = low_date.
  if pdate1  = ? then pdate1 = hi_date.
  
  {mfselprt.i "printer" 132}
	
	for each xxspl_mstr where xxspl_domain = global_domain and xxspl_site = site
		and xxspl_id >= spnbr and xxspl_id <= spnbr1 
		and xxspl_shp_date >= pdate and xxspl_shp_date <= pdate1 no-lock,
		each xxspld_det where xxspld_domain = global_domain and xxspld_site = xxspl_site
			and xxspld_id = xxspl_id no-lock ,
		each so_mstr where so_domain = global_domain and so_nbr = xxspld_nbr no-lock
		break by xxspl_id :
			
		find first cm_mstr where cm_domain = global_domain and cm_addr = xxspl_cust no-lock no-error.
		if avail cm_mstr then custname = cm_sort. 	
		form header
			"重庆隆鼎动力有限公司" colon 35
			"发货单(LX,J-TSLD-WL-21)" colon 35
			"发运计划:" colon 1 xxspl_id
			"制单日期:" colon 60 today colon 70
			"购货单位:" colon 1 custname 
			"发运日期:" colon 60
		with STREAM-IO FRAME ph1 PAGE-TOP WIDTH 80 NO-BOX.
		
		view frame ph1.
		
		{gprun.i ""xxaddoldname.p"" "(input xxspld_part,output oldname)"}
		disp 
			xxspld_nbr 
			xxspld_line 
			so_po column-label "合同号"
			xxspld_part
			oldname label "老车型"  
			xxspld_qty_ship 
		with width 150.
		
/*			
		if last-of(xxspl_id) then do:
			repeat while page-size - line-counter >= 4:
				put skip(1).
			end.
		end.
*/			
		if last-of(xxspl_id) or (page-size - line-counter < 4) then do:
			put skip(1).
		  put "备注:" xxspl_rmks format "x(100)" skip(1).
			put "-------------------------------------------------------------------------------------" skip.
			put "库管员:                 审核:                  财务主管:                 制单:"  global_userid skip.
			put "[白联:存根  红联:财务  蓝联:发货员  黄联:库房]" skip.
			page.
		end.
			
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
	
end.

