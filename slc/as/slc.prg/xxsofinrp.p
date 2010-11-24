/******************************************************************************/
/*name:销售订单完成情况报表                                                */
/*designed by Billy 2009-05-12                                               */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable sonbr like xxvin_nbr.
define variable sonbr1 like xxvin_nbr.
define variable soline like xxvin_line.
define variable soline1 like xxvin_line.
define variable yn1 as logical init no.
define variable orddate1 like so_ord_date.
define variable orddate2 like so_ord_date.
define variable sodduedate like sod_due_date.
define variable sodduedate1 like sod_due_date.
define variable yn as logical.
define variable wonbr like xxvin_wonbr.
define variable ptpart like pt_part.
define variable oldname like pt_desc1.
define variable sodqty like sod_qty_ord.
define variable shipdate like sod_due_date.
define variable saler as character format "x(8)".
define variable woqtyord like wo_qty_ord.
define variable onqty like xxvin_qty_down.
define variable downqty like xxvin_qty_pack.
define variable inqty like xxvin_qty_ruku.
define variable shipqty like sod_qty_ship.
define variable outqty like xxvin_qty_ruku.
define variable custno like so_cust.
define variable custname like cm_sort.
define variable orddate like so_ord_date.
define variable mpsqty like wo_qty_ord.
define variable ontimeqty like wo_qty_ord.
define variable diffqty like wo_qty_ord.
define variable delayday as int.
define variable finish as char.
define variable practicedate like xxvind_ruku_date.
define variable wofindate like wo_due_date.
define variable woreldate like wo_rel_date.

form
  custno     column-label "客户编码"
  custname   column-label "客户简称"
	wonbr      column-label "订单号"
	ptpart     column-label "物料编码"
	oldname    column-label "老机型"
	orddate    column-label "订货日期"
	practicedate column-label "最后入库日期"
	sodqty     column-label "订单数"
	mpsqty     column-label "排产数"
	woqtyord   column-label "派工数"
	onqty      column-label "上线数"
	downqty    column-label "下线数"
	inqty      column-label "入库数"
  ontimeqty  column-label "准时入库数"
	diffqty    column-label "差异数"
	delayday   column-label "延迟天数"
	finish     column-label "是否完成"
with frame b width 400 down attr-space.

form
 orddate1 colon 18 label "订货日期"
 orddate2 colon 49 label "至"
 sonbr COLON 18 label "销售订单号"
 sonbr1 COLON 49 label "至" skip
 soline colon 18 label "项次"
 soline1 colon 49 label "至" skip
 yn1 colon 18 label "只显示完成" skip
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	if sonbr1 = hi_char then sonbr1 = "".
	if orddate1 = low_date then orddate1 = ?.
	if orddate2 = hi_date then orddate2 = ?.
	if soline1 = 999 then soline1 = 0.
	orddate2 = today.
	orddate1 = today - 60.

		update
		  orddate1
		  orddate2
			sonbr 
			sonbr1
			soline
			soline1
			yn1
		with frame a.
			
			
			if sonbr1 = "" then sonbr1 = hi_char.
			if orddate1 = ? then orddate1 = low_date.
			if orddate2 = ? then orddate2 = hi_date.
			if soline1 = 0 then soline1 = 999.

	{mfselprt.i "printer" 132}
	
	form header
	"隆鑫工业有限公司四轮车本部" at 40 skip
	"销售订单完成情况报表" at 43 skip
	WITH STREAM-IO FRAME ph1 PAGE-TOP WIDTH 130 NO-BOX.
	
			for each xxvin_mstr where xxvin_domain = global_domain
			                      and xxvin_nbr >= sonbr and xxvin_nbr <= sonbr1
			                      and xxvin_line >= soline and xxvin_line <= soline1 no-lock,
			    each pt_mstr where pt_domain = global_domain
			                      and pt_part = xxvin_part no-lock,
			    each sod_det where sod_domain = global_domain
			                      and sod_nbr = xxvin_nbr 
			                      and sod_line = xxvin_line
			                      and sod_part = xxvin_part no-lock,
			    each so_mstr where so_domain = global_domain
			                      and so_nbr = sod_nbr
			                      and so_ord_date >= orddate1 and so_ord_date <= orddate2 no-lock
			    break by xxvin_wonbr by xxvin_part:
			    	onqty = onqty + xxvin_qty_up.
			    	downqty = downqty + xxvin_qty_down.
			    	inqty = inqty + xxvin_qty_ruku.
			    	shipqty = shipqty + xxvin_qty_cuku.
			    	if last-of(xxvin_part) then
			    		do:
					    	for each wo_mstr where wo_domain = global_domain
					    	                   and wo_nbr = xxvin_wonbr
					    	                   and wo_part = xxvin_part no-lock
					    	    break by wo_nbr by wo_due_date:
					      		if (wo_status = "R" or wo_status = "C") then woqtyord = woqtyord + wo_qty_ord.
					      		if (wo_status = "F" or wo_status = "R" or wo_status = "C") then mpsqty = mpsqty + wo_qty_ord.
					      		if last-of(wo_nbr) then 
					      		do:
					      			wofindate = wo_due_date.
					      			woreldate = wo_rel_date.
					      		end.
					      end. /*for each wo_mstr*/
					  	 
					      find first sp_mstr where sp_domain = global_domain and sp_addr = sod_slspsn[1] no-lock no-error.
					      if avail sp_mstr then
					      	saler = sp_sort.
					      else
					        saler = "".
					      wonbr = xxvin_wonbr.
					      ptpart = pt_part.
					      oldname = pt_desc1.
					      sodqty = sod_qty_ord.
						    shipdate = sod_due_date.
						    
						    custno = so_cust.
						    orddate = so_ord_date.
						    find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust no-lock no-error.
						    if avail cm_mstr then custname = cm_sort.
						    
						    for each xxvind_det use-index xxvind_sonbrline_wolot_id 
						                            where xxvind_domain = global_domain
						                              and xxvind_nbr = sod_nbr
						                              and xxvind_line = sod_line
						                              and xxvind_ruku_date <> ? no-lock
						        break by xxvind_part by xxvind_ruku_date:
						        	if (xxvind_ruku_date <= wofindate) then 
						        			ontimeqty = ontimeqty + 1.
						        	if last-of(xxvind_part) then
						        	do:
						        			practicedate = xxvind_ruku_date.
						        	end.		
						    end.   
						    diffqty = sodqty - mpsqty. 
						    delayday = practicedate - woreldate.
						    if delayday = ? then
						    		delayday = today - woreldate.
						    if inqty = sodqty then 
						    	finish = "完成".
						    else
						    	finish = "未完成".                                    
						    view frame ph1.
						    if (yn1 = yes) then
						    do:
						    	if finish = "完成" then
						    	do:
							      disp
							      		custno     column-label "客户编码"
											  custname   column-label "客户简称"
												wonbr      column-label "订单号"
												ptpart     column-label "物料编码"
												oldname    column-label "老机型"
												orddate    column-label "订货日期"
												practicedate column-label "最后入库日期"
												sodqty     column-label "订单数"
												mpsqty     column-label "排产数"
												woqtyord   column-label "派工数"
												onqty      column-label "上线数"
												downqty    column-label "下线数"
												inqty      column-label "入库数"
											  ontimeqty  column-label "准时入库数"
												diffqty    column-label "差异数"
												delayday   column-label "延迟天数"
												finish     column-label "是否完成"
							      with frame b.
							      down with frame b.
							      custno = "".
							      custname = "".
							      orddate = ?.
							      mpsqty = 0.
							      ontimeqty = 0.
							      diffqty = 0.
							      delayday = 0.
							      finish = "".
							      wonbr = "".
							      ptpart = "".
							      oldname = "".
							      sodqty = 0.
							      shipdate = ?.
							      saler = "".
							      woqtyord = 0.
							      onqty = 0.
							      downqty = 0.
							      inqty = 0.
							      shipqty = 0.
							      outqty = 0.
							      practicedate = ?.
							     end.
							    end.
							    else
							    do:
							    	disp
							      		custno     column-label "客户编码"
											  custname   column-label "客户简称"
												wonbr      column-label "订单号"
												ptpart     column-label "物料编码"
												oldname    column-label "老机型"
												orddate    column-label "订货日期"
												practicedate column-label "最后入库日期"
												sodqty     column-label "订单数"
												mpsqty     column-label "排产数"
												woqtyord   column-label "派工数"
												onqty      column-label "上线数"
												downqty    column-label "下线数"
												inqty      column-label "入库数"
											  ontimeqty  column-label "准时入库数"
												diffqty    column-label "差异数"
												delayday   column-label "延迟天数"
												finish     column-label "是否完成"
							      with frame b.
							      down with frame b.
							      custno = "".
							      custname = "".
							      orddate = ?.
							      mpsqty = 0.
							      ontimeqty = 0.
							      diffqty = 0.
							      delayday = 0.
							      finish = "".
							      wonbr = "".
							      ptpart = "".
							      oldname = "".
							      sodqty = 0.
							      shipdate = ?.
							      saler = "".
							      woqtyord = 0.
							      onqty = 0.
							      downqty = 0.
							      inqty = 0.
							      shipqty = 0.
							      outqty = 0.
							      practicedate = ?.
							    end.
							
					    end.	                   
			end. /*for each xxvin_mstr*/

	  {mfreset.i}
	  {mfgrptrm.i}
end. /*repeat*/
