/* By: Neil Gao Date: 20070522 ECO: *ss 20070522* */
/* By: Neil Gao Date: 20070719 ECO: *ss 20070719* */
/* By: Neil Gao Date: 20080227 ECO: *ss 20070227* */
/* By: axiang   Date: 20080428 ECO: *ss 20080227* */

	{mfdtitle.i "b+ "}

define variable part like mrp_part.
define variable part2 like mrp_part.
define variable date1 as date.
define variable date2 as date.
define variable loc like tr_loc.
define variable loc1 like tr_loc.
define variable transfer1 like pt_article.
define variable transfer2 like pt_article.

/* ss 20080227 - b */
define var vend like po_vend.
define var vend1 like po_vend.
/* ss 20080227 - e */

define temp-table xxvd
	  field xxvd_part   like pt_part
		field xxvd_vendno like vd_addr.

	DEFINE VARIABLE wpage     AS integer format ">>>" init 1.
	DEFINE VARIABLE wct_desc  LIKE ct_desc NO-UNDO.
	DEFINE VARIABLE i		AS	INTEGER.
	DEFINE VARIABLE xxrmk as char format "x(4)" label "其他".
	DEFINE VARIABLE xxi   as int label "序" format ">>>" .
	define variable v_ok  as logical.
	define variable adname like ad_name.
	define variable xxold as character format "x(46)".
	
	define variable xxqty1 like tr_qty_loc.     /*期初*/  
	define variable xxqty2 like xxqty1.         /*入库数*/
	define variable xxqty3 like xxqty1.         /*出库数*/
	define variable xxqty4 like xxqty1.         /*不合格品数*/
	define variable xxqty5 like xxqty1.         /*结存*/
	define variable xxqty6 like xxqty1.         /**/
	define variable xxqty7 like xxqty1.         /* ld 中有效库存 */
	define variable xxqty8 like xxqty1.         /* ld 中无效库存 */
	define variable xxqty9 like xxqty1.         /*大于截至日期的入库事务的入库数*/ 
	define variable xxqty10 like xxqty1.        /*大于截至日期的出库事务的出口数*/
	
	define variable xxqty11 like xxqty1.        /*送货数*/
	
	define variable xxqty13 like xxqty1.        /*计划外入库数*/
	define variable xxqty14 like xxqty1.        /*调拨转仓入库数*/
	define variable xxqty15 like xxqty1.        /*盘点入库数*/
	
	define variable xxqty16 like xxqty1.        /*生产领用*/
	define variable xxqty17 like xxqty1.        /*计划外出库数*/
	define variable xxqty19 like xxqty1.        /*换件出库数*/
	define variable xxqty20 like xxqty1.        /*调拨转仓出库数*/
	define variable xxqty21 like xxqty1.        /*散件销售出库数*/
	define variable xxqty22 like xxqty1.        /*盘点出库数*/
	
	define variable xxqty23 like xxqty1.        /*退货数*/
	define variable xxqty24 like xxqty1.        /*送货小计*/
	define variable xxqty25 like xxqty1.        /*生产小领料*/
	define variable xxqty26 like xxqty1.        /*品技小领料*/
	define variable xxqty27 like xxqty1.        /*买断销售*/
	define variable xxqty28 like xxqty1.        /*售后领用*/
	define variable xxqty29 like xxqty1.        /*小领料小计*/
	define variable xxqty30 like xxqty1.        /*非买断委外出库*/
	define variable xxqty31 like xxqty1.        /*领用小计*/
	define variable xxqty32 like xxqty1.        /*散件领用*/
	
	define variable xxqty33 like xxqty1.        /*合格品库转入*/
	define variable xxqty34 like xxqty1.        /*散件发料*/
	
	define buffer xxtrhist for tr_hist.
	 
form
	 date1										colon 15
	 date2										colon 45
   part                     colon 15
   part2 label {t001.i}     colon 45 
   loc                      colon 15
   loc1                     colon 45 
   transfer1                colon 15 label "帐务库房"
   transfer2                colon 45 label "至"
/* ss 20080227 - b */
	 vend                     colon 15
	 vend1                    colon 45
/* ss 20080227 - e */
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
	tr_part COLUMN-LABEL "物料编码"
	pt_desc1 column-label "物料名称" format "x(14)"
	xxold column-label "描述"
	tr_loc  COLUMN-LABEL "库区"
	ld_loc  COLUMN-LABEL "供应商" 
	vd_sort column-label "简称" format "x(8)"
	xxqty1  column-label "期初"
  xxqty11 column-label "送货"
  xxqty33 column-label "合格库转入"
  xxqty23 column-label "退货数"
  xxqty24 column-label "送货小计"
  xxqty34 column-label "散件发料"
	xxqty5  column-label "结存"
with frame c down width 320.


	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

   if part2 = hi_char then part2 = "".
   if date1 = low_date then date1 = ?.
   if date2 = hi_date  then date2 = ?.
   if loc1 = hi_char then loc1 = "".
	 if vend1 = hi_char then vend1 = "".
	 if transfer2 = hi_char then transfer2 = "".
	 
	 date2 = today.
		IF c-application-mode <> 'web':u THEN
		 loc = "SJ01".
		 loc1 = "SJ01".
	   update
	   	date1 date2
      part part2
      loc  loc1
      transfer1 transfer2
      vend vend1
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "date1 date2 part part2 loc loc1 transfer1 transfer2 vend vend1"
			&frm = "a"}

		  if part2 = "" then part2 = hi_char.
		  if date1 = ? then  date1 = low_date.
		  if date2 = ? then date2 = hi_date.
		  if loc1 = "" then loc1 = hi_char.
		  if vend1 = "" then vend1 = hi_char.
		  if transfer2 = "" then transfer2 = hi_char.

    {mfselprt.i "printer" 132}

		wpage = 0.
		xxi   = 1.
			
		for each pt_mstr where pt_domain = global_domain 
		     and pt_part >= part and pt_part <= part2 
		     and pt_loc >= transfer1 and pt_loc <= transfer2 no-lock:
			 
			 /*查找时间范围内，零件发生的事务中有那些供应商*/
			 for each tr_hist use-index tr_part_eff where tr_domain = global_domain
			                                           and tr_effdate >= date1 and tr_effdate <= date2
			                                           and tr_part = pt_part
			                                           and tr_loc >= loc and tr_loc <= loc1 no-lock
			     break by tr_part by tr_loc by substring(tr_serial,7) by tr_effdate:
			     if first-of(substring(tr_serial,7)) then
			     	do:
			     		create xxvd.
			     		assign
			     			xxvd_part = tr_part
			     			xxvd_vendno = substring(tr_serial,7).
			     	end.	
			 end.
			 /*查找当前库存零件中供应商*/
			 for each ld_det where ld_domain = global_domain
			                   and ld_part = pt_part
			                   and ld_loc >= loc and ld_loc <= loc1 no-lock
			     break by ld_part by substring(ld_lot,7):
			     if first-of(substring(ld_lot,7)) then
			     do:
				     find first xxvd where xxvd_part = ld_part and xxvd_vendno = substring(ld_lot,7) no-lock no-error.
				     if not avail xxvd then
				     	do:
				     		create xxvd.
				     		assign
				     			xxvd_part = ld_part
				     			xxvd_vendno = substring(ld_lot,7).
				     	end. 
				   end.	
			 end.
			 
			 for each xxvd where xxvd_part = pt_part no-lock:                   
					find first tr_hist where tr_domain = global_domain and
						tr_part = pt_part and tr_effdate >= date1
					  and tr_loc >= loc and tr_loc <= loc1 
			      and substring(tr_serial,7) = xxvd_vendno
					  and tr_qty_loc <> 0 and tr_ship_type = "" no-lock no-error.
		
					FORM  HEADER
						"库房帐务月报表" colon 35
					WITH STREAM-IO FRAME phead PAGE-TOP WIDTH 132 NO-BOX.
		
					VIEW FRAME phead.
			
	if avail tr_hist then do:

		for each tr_hist where tr_domain = global_domain 
		  and tr_part = pt_part  
		  and tr_effdate >= date1
		  and tr_loc >= loc and tr_loc <= loc1 
      and substring(tr_serial,7) = xxvd_vendno
		  and tr_qty_loc <> 0 and tr_ship_type = ""  no-lock
			break by tr_part by tr_loc by substring(tr_serial,7) by tr_effdate:
		
			if tr_effdate <= date2 then do:
				if ( tr_type begins "rct" or tr_type = "cn-rct" or tr_type = "CYC-RCNT" or tr_type = "TAG-CNT" ) 
					then xxqty2 = xxqty2 + tr_qty_loc.
				else /*if ( tr_type begins "iss" or tr_type = "cn-iss" ) then*/ xxqty3 = xxqty3 - tr_qty_loc.
				
/************************add by axiang 2008-4-28*******************************/
/*purpose:增加详细入库，出库事务统计*/
        if (tr_type = "RCT-TR" and tr_program = "xxtrchmt.p") then xxqty11 = xxqty11 + tr_qty_loc.

        if (tr_type = "RCT-UNP" and tr_program = "xxicunrc.p") then xxqty13 = xxqty13 + tr_qty_loc.
/*      if (tr_type = "RCT-TR" and tr_program = "xxlotr04.p") then xxqty14 = xxqty14 + tr_qty_loc.  */
        if ((tr_type = "CYC-RCNT" or tr_type = "CYC-CNT") and tr_qty_loc > 0) then xxqty15 = xxqty15 + tr_qty_loc.
        
        if (tr_type = "ISS-WO" and (tr_program ="xxwowois.p" or tr_program = "wowois.p" or tr_program = "xxautowois.p")) then xxqty16 = xxqty16 - tr_qty_loc.
        if (tr_type = "ISS-UNP" and tr_program = "xxicunis.p") then xxqty17 = xxqty17 - tr_qty_loc.
        if (tr_type = "ISS-WO" and tr_program = "xxhuanjcu.p") then xxqty19 = xxqty19 - tr_qty_loc.
        if (tr_type = "ISS-TR" and tr_program = "xxlotr04.p") then xxqty20 = xxqty20 - tr_qty_loc.
        if (tr_type = "ISS-SO") then xxqty21 = xxqty21 - tr_qty_loc.
        if ((tr_type = "CYC-RCNT" or tr_type = "CYC-CNT") and tr_qty_loc < 0) then xxqty22 = xxqty22 - tr_qty_loc.
        
        if (tr_type = "ISS-PRV" and tr_program = "xxporvis.p") then xxqty23 = xxqty23 - tr_qty_loc.
        if (tr_type = "ISS-UNP" and tr_program = "xxicunis.p" and tr_rmks begins "生") then xxqty25 = xxqty25 - tr_qty_loc.
        if (tr_type = "ISS-UNP" and tr_program = "xxicunis.p" and tr_rmks begins "品") then xxqty26 = xxqty26 - tr_qty_loc.
        if (tr_type = "ISS-SO" and tr_program = "sosois.p" and tr_nbr begins "W") then xxqty27 = xxqty27 - tr_qty_loc.

        if (tr_type = "ISS-TR" and tr_program = "xxlotr04.p" and tr_rmks begins "售后") then xxqty28 = xxqty28 - tr_qty_loc.
        if (tr_type = "ISS-TR" and tr_program = "xxlotr04.p" and tr_rmks begins "委外") then xxqty30 = xxqty30 - tr_qty_loc. 
        if (tr_type = "ISS-TR" and tr_program = "xxlotr04.p" and tr_rmks begins "散件") then xxqty32 = xxqty32 - tr_qty_loc.  
        
        if (tr_type = "RCT-TR" and (tr_program = "xxlotr04.p" or tr_program = "iclotr03.p") and tr_rmks begins "散件") then xxqty33 = xxqty33 + tr_qty_loc.
        if (tr_type = "ISS-TR" and tr_program = "xxsjmt01.p") then xxqty34 = xxqty34 - tr_qty_loc.   
/************************end***************************************************/				
			end.
			
			if tr_effdate > date2 then do:
				if ( tr_type begins "rct" or tr_type = "cn-rct" or tr_type = "CYC-RCNT" or tr_type = "TAG-CNT")  
					then xxqty9 = xxqty9 + tr_qty_loc.
				else /*if ( tr_type begins "iss" or tr_type = "cn-iss" ) then*/ xxqty10 = xxqty10 - tr_qty_loc.
			end.
					
			if last-of(substring(tr_serial,7)) then do:
			
				xxqty7 = 0.
				xxqty8 = 0.
				for each ld_det where ld_domain = global_domain and ld_part = tr_part and 
					ld_loc = tr_loc and substring(ld_lot,7) = substring(tr_serial,7) no-lock:
					if ld_status begins "N-N" then
						xxqty8 = xxqty8 + ld_qty_oh.
					else
						xxqty7 = xxqty7 + ld_qty_oh.
			  end.
/*				  
				xxqty1 = xxqty8 + xxqty7 - xxqty2 + xxqty3 - xxqty9 + xxqty10 .
				xxqty4 = xxqty8.
*/
				xxqty5 = xxqty7 - xxqty9 + xxqty10 + xxqty4.
				
				/*送货数小计*/
				xxqty24 = xxqty11 + xxqty33 - xxqty23.
				/*小领料小计*/
				xxqty29 = xxqty25 + xxqty26 + xxqty27 + xxqty28.
				/*领用小计*/
				xxqty31 = xxqty29 + xxqty16 + xxqty19 + xxqty30 + xxqty32.
				
				xxqty1 = xxqty5 + xxqty34 - xxqty24.
				
				find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
        find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
        if avail cd_det then
        		xxold = cd_cmmt[1].
        else
            xxold = "".
            
				disp 
						tr_part 
						pt_desc1
						xxold
						tr_loc 
					  substring(tr_serial,7) @ ld_loc  
						vd_sort when avail vd_mstr
						xxqty1  column-label "期初"
					  xxqty11 column-label "送货"
					  xxqty33 column-label "合格库转入"
					  xxqty23 column-label "退货数"
					  xxqty24 column-label "送货小计"
					  xxqty34 column-label "散件发料"
						xxqty5  column-label "结存"
				WITH frame c.
				down with frame c.
						
				xxqty1 = 0.
				xxqty2 = 0.
				xxqty3 = 0.
				xxqty4 = 0.
				xxqty5 = 0.
				xxqty7 = 0.
				xxqty8 = 0.
				xxqty9 = 0.
				xxqty10 = 0.
				xxqty11 = 0.

				xxqty23 = 0.
				xxqty13 = 0.
				xxqty14 = 0.
				xxqty15 = 0.
				xxqty16 = 0.
				xxqty17 = 0.
				xxqty19 = 0.
				xxqty20 = 0.
				xxqty21 = 0.
				xxqty22 = 0.
				
				xxqty11 = 0.
				xxqty23 = 0.
				xxqty24 = 0.
				xxqty25 = 0.
				xxqty26 = 0.
				xxqty27 = 0.
				xxqty28 = 0.
				xxqty29 = 0.
				xxqty16 = 0.
				xxqty19 = 0.
				xxqty30 = 0.
				xxqty31 = 0.
				xxqty32 = 0.
				
				xxqty33 = 0.
				xxqty34 = 0.
				
			end.

		END. /* for each tr_hist */
		
	end. /* if avail tr_hist*/
	else do:	
				xxqty7 = 0.
				xxqty8 = 0.
				for each ld_det where ld_domain = global_domain and ld_part = pt_part 
				and ld_loc >= loc and ld_loc <= loc1
        and substring(ld_lot,7) = xxvd_vendno no-lock 
				break by ld_loc by substring(ld_lot,7):
					
					if ld_status begins "N-N" then
						xxqty8 = xxqty8 + ld_qty_oh.
					else
						xxqty7 = xxqty7 + ld_qty_oh.
					
					find first vd_mstr where vd_domain = global_domain and vd_addr = substring(ld_lot,7) no-lock no-error.
					find first cd_det where cd_domain = global_domain and cd_ref = pt_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
					if avail cd_det then 
							xxold = cd_cmmt[1].
					else
					    xxold = "".
					
					if last-of(substring(ld_lot,7)) then do:	
						if xxqty8 = 0 and xxqty7 = 0 then next.
						disp 
							pt_part @ tr_part
							pt_desc1
							xxold
							ld_loc @ tr_loc
							substring(ld_lot,7) @ ld_loc
							vd_sort  when avail vd_mstr
							xxqty7 + xxqty8 @ xxqty1
							0 @ xxqty11 
							0 @ xxqty33
							0 @ xxqty23
							0 @ xxqty24
							0 @ xxqty34
							xxqty7 + xxqty8 @ xxqty5					
						WITH frame c.		
						down with frame c.	 	
					 	xxqty1 = 0.
						xxqty2 = 0.
						xxqty3 = 0.
						xxqty4 = 0.
						xxqty5 = 0.
						xxqty7 = 0.
						xxqty8 = 0.
						xxqty9 = 0.
						xxqty10 = 0.
						xxqty11 = 0.

						xxqty23 = 0.
						xxqty13 = 0.
						xxqty14 = 0.
						xxqty15 = 0.
						xxqty16 = 0.
						xxqty17 = 0.
						xxqty19 = 0.
						xxqty20 = 0.
						xxqty21 = 0.
						xxqty22 = 0.
						
						xxqty11 = 0.
						xxqty23 = 0.
						xxqty24 = 0.
						xxqty25 = 0.
						xxqty26 = 0.
						xxqty27 = 0.
						xxqty28 = 0.
						xxqty29 = 0.
						xxqty16 = 0.
						xxqty19 = 0.
						xxqty30 = 0.
						xxqty31 = 0.
						xxqty32 = 0.
					 	
					end. /* if last-of(ld_loc) */
					
				end.
				
	end. /* else do: */
	 end. /*for each xxvd*/
	 	 empty temp-table xxvd.
	end. /* for each pt_mstr */

		{mfreset.i}
		{mfgrptrm.i}
		
	END.

	{wbrp04.i &frame-spec = a}