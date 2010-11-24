/******************************************************************************/
/*name:生产日报表                                                             */
/*designed by Billy 2009-05-13                                                */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable xxi as int.
define variable reldate like wo_rel_date.
define variable wonbr like wo_lot.
define variable oldname like pt_desc1.
define variable custname like cm_sort.
define variable desc1 as char format "x(100)".
define variable prewipqty like wo_qty_ord.
define variable ordqty like wo_qty_ord.
define variable downqty like wo_qty_ord.
define variable lastwipqty like wo_qty_ord.
define variable inqty like wo_qty_ord.
define variable workdate1 like wo_ord_date. 
define variable workdate2 like wo_ord_date.
define variable worknbr1 like wo_lot.
define variable worknbr2 like wo_lot.
define variable compqty like wo_qty_ord.   /*至日期以前的已完工量*/

define buffer tmpxxvind_det for xxvind_det.

form
  xxi         column-label "序号"
  reldate     column-label "派工日期"
  wonbr       column-label "派工号"
  oldname     column-label "产品型号"
  custname    column-label "客户"
  prewipqty   column-label "期初在制"
  ordqty      column-label "计划量"
  downqty     column-label "下线量"
  lastwipqty  column-label "期末在制"
  inqty       column-label "入库数量"
  desc1       column-label "规格状态"
with frame b width 400 down attr-space.

form
 workdate1    COLON 18 label "完工日期"
 workdate2    COLON 49 label "至" skip
 worknbr1     colon 18 label "派工单号"
 worknbr2     colon 49 label "至" skip
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

form header
	"隆鑫工业有限公司四轮车本部" at 40 skip
	"生产情况日报表" at 43 skip
WITH STREAM-IO FRAME ph1 PAGE-TOP WIDTH 130 NO-BOX.

repeat:
	if worknbr2 = hi_char then worknbr2 = "".
	if workdate1 = low_date then workdate1 = ?.
	if workdate2 = hi_date then workdate2 = ?.
	
		update
			workdate1
			workdate2
			worknbr1
			worknbr2
		with frame a.
			
			if worknbr2 = "" then worknbr2 = hi_char.
			if workdate1 = ? then workdate1 = low_date.
			if workdate2 = ? then workdate2 = hi_date.

	{mfselprt.i "printer" 132}
	
	for each xxvind_det use-index xxvind_wolot_id
	                    where xxvind_domain = global_domain
	                      and xxvind_wolot>= worknbr1 and xxvind_wolot <= worknbr2
	                      and xxvind_down_date >= workdate1 and xxvind_down_date <= workdate2 no-lock
	    break by xxvind_wolot by xxvind_down_date:
	    	downqty = downqty + 1.
	    	
	    	if last-of(xxvind_wolot) then
	    		do:
	    			find first wo_mstr where wo_domain = global_domain and wo_lot = xxvind_wolot no-lock no-error.
	    			if avail wo_mstr then
	    				do:
	    					reldate = wo_rel_date.
	    					wonbr = wo_lot.
	    					ordqty = wo_qty_ord.
	    				end.
	    			
	    			{gprun.i ""xxaddoldname.p"" "(input xxvind_part,output oldname)"}
	    			
	    			find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
	    			find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust no-lock no-error.
	    			if avail cm_mstr then
	    				custname = cm_sort.
	    			/*计算至日期以前的完工数量和日期范围以内的入库数量*/
	    			for each tmpxxvind_det use-index xxvind_wolot_id
	    		                             where tmpxxvind_det.xxvind_domain = global_domain
	    		                               and tmpxxvind_det.xxvind_wolot = xxvind_det.xxvind_wolot
	    		                               and tmpxxvind_det.xxvind_down_date <= workdate2 no-lock:
	    		              compqty = compqty + 1.
	    		              if (tmpxxvind_det.xxvind_ruku_date >= workdate1 and tmpxxvind_det.xxvind_ruku_date <= workdate2) then
	    		              			inqty = inqty + 1.	                         	
	    		  end.
	    			lastwipqty = ordqty - compqty.
	    			prewipqty = ordqty - compqty + downqty.
	    			find first cd_det where cd_domain = global_domain and cd_ref = xxvind_part no-lock no-error.
	    			if avail cd_det then 
	    				desc1 = cd_cmmt[1] + cd_cmmt[2].
	    			xxi = xxi + 1.
	    			
	    		  
	    			view frame ph1.
	    			disp
							  xxi         column-label "序号"
							  reldate     column-label "派工日期"
							  wonbr       column-label "派工号"
							  oldname     column-label "产品型号"
							  custname    column-label "客户"
							  prewipqty   column-label "期初在制"
							  ordqty      column-label "计划量"
							  downqty     column-label "下线量"
							  lastwipqty  column-label "期末在制"
							  inqty       column-label "入库数量"
							  desc1       column-label "规格状态"
					   with frame b.
					   down with frame b.
					  reldate = ?.
		    		wonbr = "".
		    		oldname = "".
		    		custname = "".
		    		prewipqty = 0.
		    		ordqty = 0.
		    		downqty = 0.
		    		lastwipqty = 0.
		    		inqty = 0.
		    		desc1 = "".
		    		compqty = 0.  
	    		end.	
	    		
	end. /*for each xxvind_det*/
	xxi = 0.
	  {mfreset.i}
	  {mfgrptrm.i}
end. /*repeat*/
