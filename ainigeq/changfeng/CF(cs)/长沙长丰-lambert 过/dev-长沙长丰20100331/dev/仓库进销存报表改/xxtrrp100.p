/*By: Randy Li 09/07/13 ECO: *SS 20090713* */
/*By: Lambert Xiang 2010/01/28 ECO: *SS 20100128* */


{mfdtitle.i "20100129.1"}

DEFINE VARIABLE part like mrp_part. 
DEFINE VARIABLE part2 like mrp_part.
DEFINE VARIABLE date1 as date.      
DEFINE VARIABLE date2 as date.      
DEFINE VARIABLE loc like tr_loc.    
DEFINE VARIABLE loc1 like tr_loc.
DEFINE VARIABLE qcqty like tr_qty_loc.	/*期初数*/
DEFINE VARIABLE qmqty like tr_qty_loc.	/*期末数*/
DEFINE BUFFER ptmstr for pt_mstr.   

DEFINE TEMP-TABLE tmp_mstr 
	field tmp_part like pt_part			/*物料编码*/
	field tmp_loc like tr_loc			/*库位*/
	field tmp_qty1 like ld_qty_oh		/*大于截至日期的入库事务的入库数*/
	field tmp_qty2 like ld_qty_oh		/*大于截至日期的出库事务的出库数*/
	field tmp_qty3 like ld_qty_oh		/*本期入库*/
	field tmp_qty4 like ld_qty_oh		/*本期出库*/
	field tmp_qty5 like ld_qty_oh		/*采购入库*/
	field tmp_qty6 like ld_qty_oh		/*采购退货*/
	field tmp_qty7 like ld_qty_oh		/*计划外入库*/
	field tmp_qty8 like ld_qty_oh		/*转仓入库*/
	field tmp_qty9 like ld_qty_oh		/*盘点盈亏*/
	field tmp_qty10 like ld_qty_oh		/*工单出库*/
	field tmp_qty11 like ld_qty_oh		/*销售出库*/	
	field tmp_qty12 like ld_qty_oh		/*计划外出库*/
	field tmp_qty13 like ld_qty_oh		/*转仓出库*/
	field tmp_qty14 like ld_qty_oh		/*库存数*/
	.

form 
	date1					colon 15
	date2					colon 45
	part					colon 15
	part2 label {t001.i}	colon 45 
	loc						colon 15
	loc1					colon 45
	skip(1)

with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

{wbrp01.i}

REPEAT ON ENDKEY UNDO, LEAVE: 
	if part2 = hi_char then part2 = "".
	if date1 = low_date then date1 = ?.
	if date2 = hi_date  then date2 = ?.
	if loc1 = hi_char then loc1 = "".
	
	IF c-application-mode <> 'web':u THEN
	update date1 date2 part part2 loc loc1 WITH FRAME a.

	{wbrp06.i &command = UPDATE
		&fields = "date1 date2 part part2 loc loc1 "
		&frm = "a"}
	if part2 = "" then part2 = hi_char.
	if date1 = ? then  date1 = low_date.
	if date2 = ? then date2 = hi_date.
	if loc1 = "" then loc1 = hi_char.

	{mfselprt.i "printer" 132}

	for each tmp_mstr :
		delete tmp_mstr .
	end.

	for each  pt_mstr where pt_part >= part
		and pt_part <= part2 no-lock:
		/****find first tr_hist where tr_part = pt_part 
			and tr_effdate >= date1
			and tr_loc >= loc
			and tr_loc <= loc1
			no-lock no-error
			.
		if avail tr_hist then do :
		*****/ /* SS - 090706.1 - B
		SS - 090706.1 - E */
			for each tr_hist where tr_part = pt_part
				and tr_effdate >= date1
				and tr_loc >= loc
				and tr_loc <= loc1
				and tr_qty_loc <> 0
				and tr_ship_type = ""
				no-lock 
				/****break by tr_part by tr_loc by tr_effdate 
				****/	/* SS - 090706.1 - B
				SS - 090706.1 - E */
				:
				find first tmp_mstr where tmp_part = tr_part and tmp_loc = tr_loc no-error .
				if not avail tmp_mstr then do :
					create tmp_mstr .
					assign 
						tmp_part = tr_part
						tmp_loc = tr_loc
						.
				end.
				if tr_effdate <= date2 then do :
					if ( tr_type begins "RCT" or tr_type = "CN-RCT" or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 )or tr_type = "TAG-CNT" ) 
						then tmp_qty3 = tmp_qty3 + tr_qty_loc.
						else tmp_qty4 = tmp_qty4 - tr_qty_loc.
					if ( tr_type = "RCT-PO" and tr_qty_loc > 0) then tmp_qty5 = tmp_qty5 + tr_qty_loc.
					if ( tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-PO" and tr_qty_loc <= 0) ) then tmp_qty6 = tmp_qty6 + tr_qty_loc.
					if ( tr_type = "RCT-UNP" ) then tmp_qty7 = tmp_qty7 + tr_qty_loc.
					if ( tr_type = "RCT-TR" ) then tmp_qty8 = tmp_qty8 + tr_qty_loc.
					if ( tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" ) then tmp_qty9 = tmp_qty9 + tr_qty_loc.
					if (tr_type = "ISS-WO" ) then tmp_qty10 = tmp_qty10 - tr_qty_loc.
					if (tr_type = "ISS-SO" ) then tmp_qty11 = tmp_qty11 - tr_qty_loc.
					if (tr_type = "ISS-UNP" ) then tmp_qty12 = tmp_qty12 - tr_qty_loc.
					if (tr_type = "ISS-TR" ) then tmp_qty13 = tmp_qty13 - tr_qty_loc.
				end.

				if tr_effdate > date2 then do :
					if ( tr_type begins "RCT" or tr_type = "CN-RCT" or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 )or tr_type = "TAG-CNT" ) 
					then tmp_qty1 = tmp_qty1 + tr_qty_loc.
					else tmp_qty2 = tmp_qty2 - tr_qty_loc.
				end.
			/***
			end.
			****/	/* SS - 090706.1 - B
			SS - 090706.1 - E */
		end.
		for each ld_det where ld_part = pt_part
			and ld_loc >= loc
			and ld_loc <= loc1
			and ld_qty_oh <> 0
			no-lock:
			find first tmp_mstr where tmp_part = ld_part and tmp_loc = ld_loc  no-error .
			if not avail tmp_mstr then do :
				create tmp_mstr .
				assign 
					tmp_part = ld_part 
					tmp_loc = ld_loc
					.
			end.
			tmp_qty14 = tmp_qty14 + ld_qty_oh .
		end.
	end.

	put "湖南长丰汽车沙发有限责任公司长沙分公司进销存报表"  at 20 skip.
	put unformat
	    "日期:"   year(date1)  "年"  month(date1)  "月"  day(date1)  "日 至 " 
	     year(date2)  "年"  month(date2)  "月"  day(date2) + "日" skip.
	for each tmp_mstr no-lock break by tmp_loc by tmp_part :
		/*计算期初及结存数*/
		qmqty = 0 .
		qcqty = 0 .
		qmqty = tmp_qty14 - tmp_qty1 + tmp_qty2 .
		qcqty = tmp_qty14 - tmp_qty1 + tmp_qty2 - tmp_qty3 + tmp_qty4 .
		find first pt_mstr where pt_part = tmp_part no-lock no-error .
		find first sct_det where sct_sim = "standard" and sct_part = tmp_part no-lock no-error . 
		display 
			tmp_loc									column-label "库位"
			tmp_part								column-label "物料编码"
			trim (pt_desc1) + trim (pt_desc2)		column-label "物料名称" format "x(24)"
			sct_mtl_tl + sct_mtl_ll					column-label "计划单价"
			qcqty									column-label "期初库存"
			qcqty * (sct_mtl_tl + sct_mtl_ll) column-label "期初库存金额" format "->>,>>>,>>9.9<<<"
			tmp_qty3								column-label "本期入库"	
			tmp_qty3 * (sct_mtl_tl + sct_mtl_ll)								column-label "本期入库金额"	 format "->>,>>>,>>9.9<<<"
			tmp_qty4								column-label "本期出库"
			tmp_qty4 * (sct_mtl_tl + sct_mtl_ll)							column-label "本期出库金额" format "->>,>>>,>>9.9<<<"
			qmqty									column-label "期末结存"
			qmqty		 * (sct_mtl_tl + sct_mtl_ll)							column-label "期末结存金额" format "->>,>>>,>>9.9<<<"
			/*  SS - 20100129
			tmp_qty5								column-label "采购入库"
			tmp_qty6								column-label "采购退货"
			tmp_qty7								column-label "计划外入库"
			tmp_qty8								column-label "转仓入库"
			tmp_qty9								column-label "盘点盈亏"
			tmp_qty10								column-label "工单出库"
			tmp_qty11								column-label "销售出库"
			tmp_qty12								column-label "计划外出库"
			tmp_qty13								column-label "转仓出库"
			*/
			
		with stream-io	width 320.
	end .
	{mfreset.i}
	{mfgrptrm.i}
END.

{wbrp04.i &frame-spec = a}

