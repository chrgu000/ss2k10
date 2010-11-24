/* SS - 090520.1 By: Neil Gao */
/* SS - 090630.1 By: Neil Gao */
/* SS - 090717.1 By: Neil Gao */

{mfdtitle.i "090717.1"}

define new shared var yr like glc_year.
define new shared var per like glc_per.
define new shared var vend  like po_vend.

form
  yr    		colon 12
  per     	colon 12
  vend			colon 12
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

mainloop:
repeat:
	
	update yr per vend with frame a.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	next.
	end.
	
	find first vd_mstr where vd_domain = global_domain and vd_domain = global_domain and vd_addr = vend no-lock no-error.
	if not avail vd_mstr then do:
		message "错误: 供应商代码不存在".
		next.
	end.
	
	{mfselprt.i "priter" 132}

/* SS 090717.1 - B */
/*	
*	for each xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per 
*		and xxgzd_vend = vend and xxgzd_end_qty > 0 no-lock,
*		each xxgz_mstr where xxgz_domain = global_domain and xxgz_year = yr and xxgz_per = per
*			and xxgz_vend = vend no-lock,
*		each ad_mstr where ad_domain = global_domain and ad_addr = xxgzd_vend no-lock 
*		break by xxgzd_part
*		with frame c width 200 no-attr-space:
*		
*		find first pt_mstr where pt_domain = global_domain and pt_part = xxgzd_part no-lock no-error.
*		
*		form header
*			 per colon 50 "月挂账表" skip
*			 "会计单位: " colon 2 "隆鑫工业有限公司四轮车本部"
*			 "挂账日期: " colon 80 xxgz_date skip
*			 "  供应商: " colon 2 xxgzd_vend ad_name colon 22 
*		with frame fh1 page-top stream-io no-box no-label width 100.
*		
*		view frame fh1.
*		
*		if avail pt_mstr then do:
*			find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
*		end.
*		else do:
*			release ptmstr.
*		end.
*		find first xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per
*			and xxkc_part = xxgzd_part and xxkc_vend = xxgzd_vend no-lock no-error.
*		
*		tamt = xxgzd_amt / (1 + xxgzd_tax_pct / 100 ).
*		disp 	space(2)
*					xxgzd_part    column-label "物料编码"
*					ptmstr.pt_desc1 			column-label "车型代码"	when avail ptmstr format "x(8)"
*					pt_mstr.pt_desc2      column-label "名称规格" when avail pt_mstr
*					xxgzd_begin_qty column-label "上期未挂" format "->>>>>>9"
*					xxkc_rct_po   column-label "本月入库" when avail xxkc_det format "->>>>>>9"
*					xxgzd_end_qty column-label "挂账数量" format "->>>>>>9"
*					xxgzd_price   column-label "含税单价"
*					xxgzd_tax_pct column-label "税率"    
*					xxgzd_amt     column-label "含税金额"
*					tamt			 		column-label "未税金额"
*					xxkc_end_qty  column-label "未挂账数" when avail xxkc_det format "->>>>>>9"
*		with frame c .
*		down with frame c.
*		
*		accumulate xxgzd_amt ( total ).
*		accumulate tamt ( total ).
*		
*		if last(xxgzd_part) then do:
*			
*			underline xxgzd_amt tamt with frame c.
*			down with frame c.
*			disp 	"合计:" @ xxgzd_part
*						( accum total xxgzd_amt )  @ xxgzd_amt
*						( accum total tamt )  @ tamt
*						with frame c.
*			down with frame c.
*			
*			put skip(2).
*			put "供应商确认: " at 10.
*			put "制表人:"      at 70.
*			find first usr_mstr where usr_userid = global_userid no-lock no-error.
*			if avail usr_mstr then put usr_name .	
*			
*		end.
*		else do:		
*			if page-size - line-counter <= 3 then do:
*				put "供应商确认: " at 10.
*				put "制表人:"      at 70.
*				find first usr_mstr where usr_userid = global_userid no-lock no-error.
*				if avail usr_mstr then put usr_name .
*				page.
*			end.
*		end. 
*	end.
*/
	{gprun.i ""xxcwrp02a.p""}
/* SS 090717.1 - E */
	
	{mfreset.i}
	{mfgrptrm.i}
	
end.	
	
	
		
   