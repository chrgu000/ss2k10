/*xxtrrp096.p 进销存汇总报表 xxtrrp100.p(rev:100625.1)的BI版本*/
/* REVISION: 100701.1   Created On: 20100701   By: Softspeed Roger Xiao                               */
/* SS - 100726.1  By: Roger Xiao */  /*委外的(M类型的物料),单价取总成本*/
/*-Revision end---------------------------------------------------------------*/





/* 所有的xxtrrp100.p的逻辑修改都要对应修改xxtrrp096.p*/
{mfdtitle.i "100726.1"}

DEFINE VARIABLE part like mrp_part. 
DEFINE VARIABLE part2 like mrp_part.
DEFINE VARIABLE date1 as date.      
DEFINE VARIABLE date2 as date.      
DEFINE VARIABLE loc like tr_loc.    
DEFINE VARIABLE loc1 like tr_loc.
/* SS - 100413.1 - B */
DEFINE VARIABLE type like pt_part_type .
DEFINE VARIABLE type1 like pt_part_type .
DEFINE VARIABLE cmmt like code_cmmt .
/* SS - 100413.1 - E */
DEFINE VARIABLE qcqty like tr_qty_loc.	/*期初数*/
DEFINE VARIABLE qmqty like tr_qty_loc.	/*期末数*/
DEFINE BUFFER ptmstr for pt_mstr.  
/* SS - 100426.1 - B */
DEFINE VARIABLE price like sct_mtl_tl .
/* SS - 10026.1 - E */

/* SS - 100701.1 - B */
define var zhouzhuan as decimal .
/* SS - 100701.1 - E */

DEFINE TEMP-TABLE tmp_mstr 
	field tmp_part like pt_part			/*物料编码*/
	field tmp_loc like tr_loc			/*库位*/

	/* SS - 100413.1 - B */
	field tmp_type like pt_part_type    /*材料类型*/
	/* SS - 100413.1 - E */

	field tmp_qty1 like ld_qty_oh		/*大于截至日期的入库事务的入库数*/
	field tmp_qty2 like ld_qty_oh		/*大于截至日期的出库事务的出库数*/
	field tmp_qty3 like ld_qty_oh		/*本期入库*/
	field tmp_qty4 like ld_qty_oh		/*本期出库*/
	field tmp_qty5 like ld_qty_oh		/*采购入库*/
	field tmp_qty6 like ld_qty_oh		/*采购退货*/
	field tmp_qty7 like ld_qty_oh		/*计划外入库*/
	field tmp_qty8 like ld_qty_oh		/*转仓入库*/
/* SS - 100625.1 - B 
	field tmp_qty9 like ld_qty_oh		/*盘点盈亏*/
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
	field tmp_qty91 like ld_qty_oh		/*盘盈*/
	field tmp_qty92 like ld_qty_oh		/*盘亏*/
/* SS - 100625.1 - E */
	field tmp_qty10 like ld_qty_oh		/*工单出库*/
	field tmp_qty11 like ld_qty_oh		/*销售出库*/	
	field tmp_qty12 like ld_qty_oh		/*计划外出库*/
	field tmp_qty13 like ld_qty_oh		/*转仓出库*/
	field tmp_qty14 like ld_qty_oh		/*库存数*/
	/* SS - 100413.1 - B */
	field tmp_qty15 like ld_qty_oh		/*工单入库*/
	/* SS - 100413.1 - E */

	.

form 
	date1					colon 15
	date2					colon 45
	part					colon 15
	part2 label {t001.i}	colon 45 
	loc						colon 15
	loc1					colon 45
	/* SS - 100413.1 - B */
	type	                colon 15
	type1					colon 45
	/* SS - 100413.1 - E */
	skip(1)

with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

{wbrp01.i}

REPEAT ON ENDKEY UNDO, LEAVE: 
	if part2 = hi_char then part2 = "".
	if date1 = low_date then date1 = ?.
	if date2 = hi_date  then date2 = ?.
	if loc1 = hi_char then loc1 = "".
	/* SS - 100413.1 - B */
	if type1 = hi_char then type1 = "" .
	/* SS - 100413.1 - E */
	
	IF c-application-mode <> 'web':u THEN

	/* SS - 100413.1 - B
	update date1 date2 part part2 loc loc1 WITH FRAME a.
	SS - 100413.1 - E */

	/* SS - 100413.1 - B */
	update date1 date2 part part2 loc loc1 type type1 WITH FRAME a.
	/* SS - 100413.1 - E */

	{wbrp06.i &command = UPDATE	
		/* SS - 100413.1 - B
		&fields = "date1 date2 part part2 loc loc1 "
		SS - 100413.1 - E */

		/* SS - 100413.1 - B */
		&fields = "date1 date2 part part2 loc loc1 type type1"
		/* SS - 100413.1 - E */
		&frm = "a"}
	if part2 = "" then part2 = hi_char.
	if date1 = ? then  date1 = low_date.
	if date2 = ? then date2 = hi_date.
	if loc1 = "" then loc1 = hi_char.
	/* SS - 100413.1 - B */
	if type1 = "" then type1 = hi_char .
	/* SS - 100413.1 - E */

	{mfselprt.i "printer" 132}

	for each tmp_mstr :
		delete tmp_mstr .
	end.

	/* SS - 100413.1 - B
	for each  pt_mstr where pt_part >= part
		and pt_part <= part2 no-lock:
	SS - 100413.1 - E */

	/* SS - 100413.1 - B */
	for each  pt_mstr where pt_part >= part
		and pt_part <= part2
		and pt_part_type >= type
		and pt_part_type <= type1
		no-lock:
	/* SS - 100413.1 - E */

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

						/* SS - 100413.1 - B */
						tmp_type = pt_part_type
						/* SS - 100413.1 - E */

						.
				end.
				if tr_effdate <= date2 then do :
					if ( tr_type begins "RCT" or tr_type = "CN-RCT" 
/* SS - 100625.1 - B 
                       or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 ) 
   SS - 100625.1 - E */
                       or tr_type = "TAG-CNT" 
                       or tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-WO" and tr_program = "icunrc01.p")) 
						then tmp_qty3 = tmp_qty3 + tr_qty_loc.
/* SS - 100625.1 - B 
						else tmp_qty4 = tmp_qty4 - tr_qty_loc.
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
						else if (not tr_type begins "CYC") then tmp_qty4 = tmp_qty4 - tr_qty_loc.
/* SS - 100625.1 - E */
					if ( (tr_type = "RCT-PO" and tr_qty_loc > 0) or (tr_type = "RCT-WO" and tr_program = "icunrc01.p") or (tr_type = "ISS-WO" and tr_program = "icunrc01.p")) then tmp_qty5 = tmp_qty5 + tr_qty_loc.
					if ( tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-PO" and tr_qty_loc <= 0) ) then tmp_qty6 = tmp_qty6 + tr_qty_loc.
					if ( tr_type = "RCT-UNP" ) then tmp_qty7 = tmp_qty7 + tr_qty_loc.
					if ( tr_type = "RCT-TR" ) then tmp_qty8 = tmp_qty8 + tr_qty_loc.

					/* SS - 100413.1 - B */
					if (tr_type = "RCT-WO" and tr_program <> "icunrc01.p") then tmp_qty15 = tmp_qty15 + tr_qty_loc .
					/* SS - 100413.1 - E */

/* SS - 100625.1 - B 
					if ( tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" ) then tmp_qty9 = tmp_qty9 + tr_qty_loc.
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
					if ( tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" ) then do:
                        if tr_qty_loc >= 0 then tmp_qty91 = tmp_qty91 + tr_qty_loc.
                        if tr_qty_loc <  0 then tmp_qty92 = tmp_qty92 - tr_qty_loc.
                    end.
/* SS - 100625.1 - E */

                    if (tr_type = "ISS-WO" ) then tmp_qty10 = tmp_qty10 - tr_qty_loc.
					if (tr_type = "ISS-SO" ) then tmp_qty11 = tmp_qty11 - tr_qty_loc.
					if (tr_type = "ISS-UNP" ) then tmp_qty12 = tmp_qty12 - tr_qty_loc.
					if (tr_type = "ISS-TR" ) then tmp_qty13 = tmp_qty13 - tr_qty_loc.
				end.

				if tr_effdate > date2 then do :
					if ( tr_type begins "RCT" or tr_type = "CN-RCT" or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 )or tr_type = "TAG-CNT" or tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-WO" and tr_program = "icunrc01.p")) 
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

					/* SS - 100413.1 - B */
					tmp_type = pt_part_type
					/* SS - 100413.1 - E */
					.
			end.
			tmp_qty14 = tmp_qty14 + ld_qty_oh .
		end.
	end.

/* SS - 100701.1 - B 
	put "湖南长丰汽车沙发有限责任公司长沙分公司进销存报表"  at 40 skip.
	put unformat
	    "日期:" at 46  year(date1)  "年"  month(date1)  "月"  day(date1)  "日 至 " 
	     year(date2)  "年"  month(date2)  "月"  day(date2)  "日"  skip.
   SS - 100701.1 - E */
/* SS - 100701.1 - B */
PUT UNFORMATTED "#def REPORTPATH=$/csqad/xxtrrp096" SKIP.
PUT UNFORMATTED "#def :end" SKIP.
/* SS - 100701.1 - E */

	for each tmp_mstr no-lock break by tmp_loc by tmp_part :
		/*计算期初及结存数*/
		qmqty = 0 .
		qcqty = 0 .
		/* SS - 100426.1 - B */
		price = 0 .
		/* SS - 100426.1 - E */
		qmqty = tmp_qty14 - tmp_qty1 + tmp_qty2 .
		qcqty = tmp_qty14 - tmp_qty1 + tmp_qty2 - tmp_qty3 + tmp_qty4 /* SS - 100625.1 - B */ - tmp_qty91 + tmp_qty92. /* SS - 100625.1 - E */

		find first pt_mstr where pt_part = tmp_part no-lock no-error .
		find first sct_det where sct_sim = "standard" and sct_part = tmp_part no-lock no-error .
		/* SS - 100412.1 - B */
		find first loc_mstr where loc_loc= tmp_loc no-lock no-error .
		find first code_mstr where code_fldname = "pt_part_type" and code_value = tmp_type no-lock no-error .
		cmmt = if avail code_mstr then code_cmmt else "" .
		/* SS - 100412.1 - E */
		
		/* SS - 100426.1 - B */
		price = sct_mtl_tl + sct_mtl_ll .
/* SS - 100625.1 - B 
		if pt_pm_code = "M" then do :
			find first ro_det where ro_routing = tmp_part and ro_op = 88 no-lock no-error .
		if avail ro_det then price = sct_sub_tl + sct_sub_ll .
		end.
   SS - 100625.1 - E */
/* SS - 100726.1 - B */
if pt_pm_code = "M" then price = sct_cst_tot .
/* SS - 100726.1 - E */

		/* SS - 100426.1 - E */
/* SS - 100701.1 - B 
		display 
			tmp_loc																column-label "库位"
			/* SS - 100412.1 - B */
			loc_desc															column-label "库位名称"
			/* SS - 100412.1 - E */
			tmp_part															column-label "物料编码"
			trim (pt_desc1) + trim (pt_desc2)									column-label "物料名称" format "x(24)"
			/* SS - 100412.1 - B */
			tmp_type															column-label "物料类型"
			cmmt																column-label "类型说明"
			/* SS - 100412.1 - E */
			/* SS - 100426.1 - B
			sct_mtl_tl + sct_mtl_ll	+ sct_sub_tl + sct_sub_ll					column-label "计划单价"
			qcqty																column-label "期初库存"
			qcqty * (sct_mtl_tl + sct_mtl_ll + sct_sub_tl + sct_sub_ll)			column-label "期初库存金额" format "->>,>>>,>>9.99<<"
			tmp_qty3															column-label "本期入库"	
			tmp_qty3 * (sct_mtl_tl + sct_mtl_ll	+ sct_sub_tl + sct_sub_ll)		column-label "本期入库金额"	 format "->>,>>>,>>9.99<<"
			tmp_qty4															column-label "本期出库"
			tmp_qty4 * (sct_mtl_tl + sct_mtl_ll	+ sct_sub_tl + sct_sub_ll)		column-label "本期出库金额" format "->>,>>>,>>9.99<<"
			qmqty																column-label "期末结存"
			qmqty * (sct_mtl_tl + sct_mtl_ll + sct_sub_tl + sct_sub_ll)			column-label "期末结存金额" format "->>,>>>,>>9.99<<"
			SS - 100426.1 - E */
			/* SS - 100412.1 - B */
			price																column-label "计划单价"
			qcqty																column-label "期初库存"
			qcqty * price														column-label "期初库存金额" format "->>,>>>,>>9.99<<"
			tmp_qty3															column-label "本期入库"	
			tmp_qty3 * price													column-label "本期入库金额"	 format "->>,>>>,>>9.99<<"
			tmp_qty4															column-label "本期出库"
			tmp_qty4 * price													column-label "本期出库金额" format "->>,>>>,>>9.99<<"
/* SS - 100625.1 - B */
			tmp_qty91															column-label "盘盈数量"
			tmp_qty91 * price													column-label "盘盈金额" format "->>,>>>,>>9.99<<"
			tmp_qty92															column-label "盘亏数量"
			tmp_qty92 * price													column-label "盘亏金额" format "->>,>>>,>>9.99<<"
/* SS - 100625.1 - E */
            qmqty																column-label "期末结存"
			qmqty * price														column-label "期末结存金额" format "->>,>>>,>>9.99<<"
			/* SS - 100412.1 - E */
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
   SS - 100701.1 - E */
/* SS - 100701.1 - B */
if tmp_qty4 * price <> 0 then do:
zhouzhuan = (qcqty * price + qmqty * price ) / 2 * 30 / tmp_qty4 * price .
end. 

        put unformatted 
			tmp_loc																";" 
			loc_desc															";" 
			tmp_part															";" 
			trim (pt_desc1) + trim (pt_desc2)									";" 
			tmp_type															";" 
			cmmt																";" 
			price																";" 
			qcqty																";" 
			qcqty * price														";" 
			tmp_qty3															";" 
			tmp_qty3 * price													";" 
			tmp_qty4															";" 
			tmp_qty4 * price													";" 
			tmp_qty91															";" 
			tmp_qty91 * price													";" 
			tmp_qty92															";" 
			tmp_qty92 * price													";" 
            qmqty																";" 
			qmqty * price														";" 
            zhouzhuan                                                           ";"
            string(year(date1)) + "/" + string(month(date1)) + "/" + string(day(date1)) ";"
            string(year(date2)) + "/" + string(month(date2)) + "/" + string(day(date2)) 

            skip.
/* SS - 100701.1 - E */

	end .
	{mfreset.i}
	{mfgrptrm.i}
END.

{wbrp04.i &frame-spec = a}