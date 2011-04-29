/* xxworp001.p  工单欠料报表                                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 2007/11/21  BY: Softspeed roger xiao  /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


/*begin defination ****************************************/
define var site  like po_site .
define var site1  like po_site .
define var nbr   like wo_nbr label "加工单" .
define var nbr1  like wo_nbr .
define var so    like wo_so_job label "销售订单".
define var so1   like wo_so_job .
define var date  like wo_rel_date label "下达日期".
define var date1    like wo_rel_date .
define var v_buyer  like pt_buyer  label "计划员".
define var v_buyer1 like pt_buyer .
define var v_vend   like pt_vend  label "供应商".
define var v_vend1  like pt_vend .
define var v_vend2  like pt_vend  label "供应商".
define var part  like pt_part .
define var part1 like pt_part .
define var nbr3  like wo_nbr label "加工单".
define var nbr4  like wo_nbr .
define var so3    like wo_so_job  label "销售订单" .
define var so4   like wo_so_job .
define var date3  like wo_rel_date  label "下达日期".
define var date4  like wo_rel_date .
define var part3  like pt_part label "零件号".
define var part4 like pt_part .
define var v_yn1 as logical format "Yes-仅检查有效库存/No-优先分配下列加工单" label "预分配".

define var v_choice as integer initial 1 label "筛选" format "9" .
define var v_yn2 as logical format "Yes/No" label "显示替代料" initial yes .

define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var desc3 like pt_desc1.
define var desc4 like pt_desc2 .
define var v_need_date  as date label "需求日期".
define var v_qty_rst    like wo_qty_ord label "未完成量" .
define var v_qty_per    like wo_qty_ord label "单位用量" .
define var v_qty_req    like wo_qty_ord label "需求量" .
define var v_qty_need   like wo_qty_ord label "短缺量" .
define var v_qty_need2  like wo_qty_ord label "短缺量" .
define var v_qty_need3  like wo_qty_ord label "短缺量" .
define var v_qty_need4  like wo_qty_ord label "短缺量" .
define var v_qty_need5  like wo_qty_ord label "短缺量" .
define var v_qty_oh     like ld_qty_oh  label "库存量" .
define var v_qty_pk     like ld_qty_oh  label "已分配量" .
define var v_qty_ord    like ld_qty_oh  . /*PO累计开单量*/
define var v_qty_rct    like prh_rcvd .   /*PO累计收料量*/
define var v_qty_onway  like prh_rcvd label "在途量" .   /*PO累计在途量*/


define temp-table xld_det 
	field xld_site like ld_site 
	field xld_part like ld_part 
	field xld_qty_oh like ld_qty_oh /*总库存*/
	field xld_qty_pk like ld_qty_oh /*累计备料*/ .

define  temp-table xwod_det 
	field xwod_site like wo_site 
	field xwod_nbr  like wo_nbr 
	field xwod_lot  like wo_lot 
	field xwod_part like wod_part
	field xwod_qty_req like wod_qty_req .



define  frame a .
define  frame b .
/*end defination ****************************************/

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)

    site                     colon 18   
	site1                    colon 54   label {t001.i}
	nbr                      colon 18   
	nbr1                     colon 54   label {t001.i}
	so                       colon 18   
	so1                      colon 54   label {t001.i}
	date                     colon 18   
	date1                    colon 54   label {t001.i}
    part                     colon 18
    part1                    colon 54   label {t001.i} 
    v_buyer                  colon 18   
    v_buyer1                 colon 54   label {t001.i}   
    v_vend                   colon 18   
    v_vend1                  colon 54   label {t001.i}  
	v_choice                 colon 18 
	"1-全部发放不足料"               colon 28
	"2-仅现有库存不足料"               colon 28
	"3-仅库存预分配后的短缺料"     colon 28
v_yn2                    colon 18  
	"4-仅考虑在途PO的短缺料"       colon 28
	
	
	v_yn1                    colon 18        

	nbr3                     colon 18   
	nbr4                     colon 54   label {t001.i}
	so3                      colon 18   
	so4                      colon 54   label {t001.i}
	date3                    colon 18   
	date4                    colon 54   label {t001.i}
    part3                    colon 18
    part4                    colon 54   label {t001.i} 
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)

   
with frame b  side-labels width 80 attr-space.
setFrameLabels(frame b:handle).

/*
find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
disp site with frame a .   
*/


{wbrp01.i}
repeat:
    if site1 = site       then site1 = "".
	if nbr1 = nbr         then nbr1  = "".
	if so1 = so           then so1   = "".
	if date1 = date       then date1 = ? .
	if part1 = part       then part1 = "".
    if v_buyer1 = v_buyer   then v_buyer1 = "".
	if v_vend1 = v_vend     then v_vend1 = "".

	if nbr4 = nbr3         then nbr4  = "".
	if so4 = so3           then so4   = "".
	if date4 = date3       then date4 = ? .
	if part4 = part3       then part4 = "".


    if c-application-mode <> 'web' then  
        update site site1 nbr nbr1 so so1 date date1 part part1 v_buyer v_buyer1 v_vend v_vend1 
				v_choice v_yn2 v_yn1
		       nbr3 nbr4 so3 so4 date3 date4 part3 part4 with frame a.

	{wbrp06.i &command = update &fields = " site site1 nbr nbr1 so so1 date date1 part part1 v_buyer v_buyer1  v_vend v_vend1 
				v_choice v_yn2 v_yn1
		       nbr3 nbr4 so3 so4 date3 date4 part3 part4  "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

         
    

        bcdparm = "".
        {mfquoter.i site       }
		{mfquoter.i site1       }
		{mfquoter.i nbr       }
		{mfquoter.i nbr1       }
		{mfquoter.i so       }
		{mfquoter.i so1       }
		{mfquoter.i date       }
		{mfquoter.i date1       }
		{mfquoter.i part       }
		{mfquoter.i part1       }
        {mfquoter.i v_buyer    }
        {mfquoter.i v_buyer1   }
        {mfquoter.i v_vend    }
        {mfquoter.i v_vend1   }
        {mfquoter.i v_choice      }
		{mfquoter.i v_yn2       }
		{mfquoter.i v_yn1       }

		if site1 = ""      then site1 = site .
		if nbr1 = ""       then nbr1  = nbr .
		if so1 = ""        then so1   = so .
		if date1 = ?       then date1 = date .
        if part1 = ""      then part1 = part.
        if v_buyer1 = ""   then v_buyer1 = v_buyer.
		if v_vend1 = ""    then v_vend1 = v_vend.

		if nbr4  = ""      then nbr4  = nbr3 .
		if so4   = ""      then so4   = so3 .
		if date4 = ?       then date4 = date3 .
        if part4 = ""      then part4 = part3 .

	end.  /* if c-application-mode <> 'web' */

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    


for each xwod_det : delete xwod_det . end.
for each xld_det : delete xld_det . end.

/*begin 排除项优先计算*********************************************/

if v_yn1 = no then do:
	for each wo_mstr 
            use-index wo_site   
            where wo_domain = global_domain 
			and wo_site >= site and ( wo_site <= site1 or site1 = "" )
			and wo_nbr >= nbr3  and (wo_nbr <= nbr4 or nbr4 = "" )
			and wo_so_job >= so3 and (wo_so_job <= so4 or so4 = "")
			and ( wo_rel_date >= date3 or date3 = ?) and (wo_rel_date <= date4 or date4 = ? )
			and ( wo_status = "R" or wo_status = "F" )
			no-lock :
			
			if  wo_nbr >= nbr  and (wo_nbr <= nbr1 or nbr1 = "" ) 
				and wo_so_job >= so and (wo_so_job <= so1 or so1 = "") 
				and ( wo_rel_date >= date or date = ?) and (wo_rel_date <= date1 or date1 = ? ) 
			then next .

			for each wod_det use-index wod_nbrpart  
				where wod_domain = global_domain 
				and wod_nbr = wo_nbr and wod_lot  = wo_lot 
				and wod_part >= part3 and (wod_part <= part4 or part4 = "" )
				no-lock :

				if wod_part >= part and (wod_part <= part1 or part1 = "" ) then next .
				
				find first xwod_det where xwod_site = wo_site 
									and xwod_nbr = wod_nbr 
									and xwod_lot = wod_lot 
									and xwod_part = wod_part 
				 no-error .
				if not avail xwod_Det then do:
					create  xwod_Det .
					assign  xwod_site  = wo_site 
							xwod_nbr   = wod_nbr 
							xwod_lot   = wod_lot
							xwod_part  = wod_part 
							xwod_qty_req = max(0,wod_qty_req - wod_qty_iss) .
				end.
				else do: /*同一个零件,不同OP*/
					assign xwod_qty_req = xwod_qty_req + max(0,wod_qty_req - wod_qty_iss) .
				end.
				
			end.  /*for each wod_det */
	end. /*for each wo_mstr*/
end. /*if v_yn1 = no*/

/*debug1 begin 
for each xwod_det no-lock break by xwod_site by xwod_lot by xwod_part with frame test width 300 :
	disp xwod_site xwod_nbr xwod_lot xwod_part xwod_qty_req with frame test .
end.*/
/*debug1 end */
/*end 排除项优先计算*********************************************/


{mfphead.i}  /*bi*/
for each wo_mstr use-index wo_site 
        where wo_domain = global_domain 
		and wo_site >= site and ( wo_site <= site1 or site1 = "" )
		and wo_nbr >= nbr  and (wo_nbr <= nbr1 or nbr1 = "" )
		and wo_so_job >= so and (wo_so_job <= so1 or so1 = "")
		and ( wo_rel_date >= date or date = ?) and (wo_rel_date <= date1 or date1 = ? )
		and ( wo_status = "R" or wo_status = "F" )
		no-lock break by wo_site by wo_rel_date by wo_nbr  :

		v_qty_rst = wo_qty_ord - wo_qty_comp .
		v_need_date = if wo_rel_date > today then wo_rel_date else today .
		
		for each wod_det use-index wod_nbrpart  
			 where wod_domain = global_domain 
			 and wod_nbr = wo_nbr and wod_lot  = wo_lot 
			 and wod_part >= part and (wod_part <= part1 or part1 = "" )
			 and (can-find(first ptp_det where ptp_domain = global_domain and ptp_site = wo_site 
										 and ptp_part = wod_part 
										 and (ptp_buyer >= v_buyer )
										 and (ptp_buyer <= v_buyer1  or v_buyer1 = "") 
										 and (ptp_vend >= v_vend )
										 and (ptp_vend <= v_vend1  or v_vend1 = ""))
				  or
				 ((not can-find(first ptp_det where ptp_domain = global_domain and ptp_site = wo_site 
							   and ptp_part = wod_part 
							   and (ptp_buyer >= v_buyer )
							   and (ptp_buyer <= v_buyer1  or v_buyer1 = "")
							   and (ptp_vend >= v_vend )
							   and (ptp_vend <= v_vend1  or v_vend1 = "")  ))
				   and can-find(first pt_mstr where pt_domain = global_domain  
							   and pt_part = wod_part 
							   and (pt_buyer >= v_buyer )
							   and (pt_buyer <= v_buyer1  or v_buyer1 = "")
							   and (pt_vend >= v_vend )
							   and (pt_vend <= v_vend1  or v_vend1 = "")  )) )
			no-lock break by wod_part
			with frame x width 300 :
			/*setFrameLabels(frame x:handle).*/

			if first-of(wod_part) then do:
				for each xwod_det where xwod_site  = wo_site 
					and xwod_nbr   = wod_nbr 
					and xwod_lot   = wod_lot
					and xwod_part  = wod_part 
					 :
						delete xwod_det .
				end.

				v_qty_ord = 0 . 
				v_qty_rct = 0 .
				v_qty_onway = 0 .			
				for each pod_det where pod_domain = global_domain 
								and pod_part = wod_part
								/*and pod_due_date <= v_need_date*/ 
								and pod_stat = "" no-lock,
					each po_mstr where po_domain  = global_domain 
								and po_nbr = pod_nbr  no-lock
					break by po_vend by pod_nbr by pod_line:

					if first-of(po_vend) then do:
						v_qty_ord = 0 . 
						v_qty_rct = 0 .
						v_qty_onway = 0 .
					end.              

					v_Qty_ord = v_Qty_ord + pod_qty_ord .

					if last-of(pod_nbr) then do:
						for each prh_hist where prh_domain = global_domain 
							and prh_nbr = pod_nbr  
							and prh_part = pod_part no-lock :
							v_qty_rct = v_qty_rct + prh_rcvd .
						end.        
					end.

					if last-of(po_vend) then do:
						v_qty_onway = max(v_qty_ord - v_qty_rct ,0 ) .          
					end.				
				end. /*for each pod_det*/
			end. /*if first-of(wod_part)*/

if last-of(wod_part) then do:
/* 同料件不同OP汇总显示**************/
end.
			
			v_qty_need = max(0,wod_qty_req - wod_qty_iss ) . /*欠发料量*/
			if v_qty_need = 0 and v_choice = 1 then next .  /*仅显示短缺料*/


			find first xld_det where xld_site = wo_site and xld_part = wod_part  no-error .
			if not avail xld_det then do:
				v_qty_oh = 0 .				
				for each ld_det use-index ld_part_loc 
                        where ld_domain = global_domain 
						and ld_part = wod_part 
						and ld_site = wo_site
						no-lock :

                        find first is_mstr  
                            where is_mstr.is_domain = global_domain 
                            and is_status = ld_status 
                        no-lock no-error.
                        if avail is_mstr 
                            and (is_avail = no 
                            and is_nettable = no 
                            and is_overissue = no )
                        then next .

						v_qty_oh = ld_qty_oh + v_qty_oh .
				end. /*for each ld_det */

				v_qty_pk = 0 .
				for each xwod_det where xwod_site  = wo_site and xwod_part  = wod_part no-lock :
					v_qty_pk = v_qty_pk + xwod_qty_req .
				end.

				create  xld_det .
				assign  xld_site = wo_site 
						xld_part = wod_part 
						xld_qty_oh = v_qty_oh 
						xld_qty_pk = v_qty_pk .
			end.

			v_qty_oh = xld_qty_oh .
			v_qty_pk = xld_qty_pk .			 
			xld_qty_pk = xld_qty_pk + v_qty_need . 

			v_qty_need3 = max(0,v_qty_need - v_qty_oh) .
			if v_qty_need3 = 0 and v_choice = 2  then next .  /*仅显示不考虑库存预分配的 短缺料*/
			v_qty_need4 = max(0,v_qty_need - max(0,v_qty_oh - v_qty_pk)) .
			if v_qty_need4 = 0 and v_choice = 3  then next .  /*仅显示考虑库存预分配后的 短缺料*/
			v_qty_need5 = max(0,v_qty_need - max(0,v_qty_oh + v_qty_onway - v_qty_pk)) .
			if v_qty_need5 = 0 and v_choice = 4  then next .  /*考虑库存预分配 + 在途PO的 短缺料*/
			
			v_vend2 = "" .
			find first ptp_det 
				where ptp_domain = global_domain  
				and ptp_site = wo_site 
				and ptp_part = wod_part 
			no-lock no-error .
			if avail ptp_det then do:
				v_vend2 = ptp_vend .
			end.
			else do:
				find first pt_mstr 
					where pt_domain = global_domain  
					and   pt_part = wod_part 
				no-lock no-error .
				if avail pt_mstr then v_vend2 = pt_vend .
			end.

			disp wo_site label "地点" 
				 wo_nbr label "工单号" 
				 wo_part label "成品号" /*desc1 desc2*/ 
				 wo_qty_ord label "已订购量" 
				 wo_qty_comp label "完成量" 
				 v_qty_rst 
				 wod_part label "零件号"  /*desc3 desc4*/ 
				 v_vend2  label "供应商"
				 wod_bom_qty column-label "单耗" 
				 v_need_date 
				 wod_qty_req column-label "需求量" 
				 wod_qty_iss column-label "发放量"
				 v_qty_need column-label "工单不足!(a)" 
				 xld_qty_oh column-label "现有库存!(b)"
				 v_qty_need3 column-label "库存不足!(a-b)" 
				 v_qty_pk column-label "已分配量!(c)" 
				 v_qty_need4 column-label "分配不足!(a-(b-c))" 
				 v_qty_onway column-label "在途PO!(d)" 
				 v_qty_need5 column-label "缺料量!(a-(b+d-c))" with frame x .
				 
			v_qty_need2 = 0 .
			v_qty_per = 0 .
			v_qty_req = 0 .

			if v_qty_need > 0 and v_yn2 then do:  /*替代料*/			

				for each pts_det 
                        where pts_domain = global_domain 
                        and pts_part = wod_part 
                        and ( pts_par = wo_part or pts_par = "" ) 
                        no-lock :
					
					v_qty_per = pts_qty_per .
					v_qty_req =  pts_qty_per *  wod_qty_req .
					v_qty_need2 = pts_qty_per * v_qty_need .

					find first xld_det where xld_site = wo_site and xld_part = pts_sub_part  no-error .
					if not avail xld_det then do:
						v_qty_oh = 0 .				
						for each ld_det use-index ld_part_loc where ld_domain = global_domain 
								and ld_part = pts_sub_part 
								and ld_site = wo_site 
								no-lock :
								v_qty_oh = ld_qty_oh + v_qty_oh .
						end. /*for each ld_det */

						v_qty_pk = 0 .
						for each xwod_det where xwod_site  = wo_site and xwod_part  = pts_sub_part no-lock :
							v_qty_pk = v_qty_pk + xwod_qty_req .
						end.

						create  xld_det .
						assign  xld_site = wo_site 
								xld_part = pts_sub_part 
								xld_qty_oh = v_qty_oh 
								xld_qty_pk = v_qty_pk .
					end.

					v_qty_oh = xld_qty_oh .
					v_qty_pk = xld_qty_pk .
                    xld_qty_pk = xld_qty_pk + v_qty_need2 . 

					v_qty_ord = 0 . 
					v_qty_rct = 0 .
					v_qty_onway = 0 .			
					for each pod_det where pod_domain = global_domain 
									and pod_part = pts_sub_part
									/*and pod_due_date <= v_need_date */
									and pod_stat = "" no-lock,
						each po_mstr where po_domain  = global_domain 
									and po_nbr = pod_nbr  no-lock
						break by po_vend by pod_nbr by pod_line:

						if first-of(po_vend) then do:
							v_qty_ord = 0 . 
							v_qty_rct = 0 .
							v_qty_onway = 0 .
						end.              

						v_Qty_ord = v_Qty_ord + pod_qty_ord .

						if last-of(pod_nbr) then do:
							for each prh_hist where prh_domain = global_domain 
								and prh_nbr = pod_nbr  
								and prh_part = pod_part no-lock :
								v_qty_rct = v_qty_rct + prh_rcvd .
							end.        
						end.

						if last-of(po_vend) then do:
							v_qty_onway = max(v_qty_ord - v_qty_rct ,0 ) .          
						end.				
					end. /*for each pod_det*/

					v_qty_need3 = max(0,v_qty_need2 - v_qty_oh) .
					if v_qty_need3 = 0 and v_choice = 2  then next .  /*仅显示不考虑库存预分配的 短缺料*/
					v_qty_need4 = max(0,v_qty_need2 - max(0,v_qty_oh - v_qty_pk)) .
					if v_qty_need4 = 0 and v_choice = 3  then next .  /*仅显示考虑库存预分配后的 短缺料*/
					v_qty_need5 = max(0,v_qty_need2 - max(0,v_qty_oh + v_qty_onway - v_qty_pk)) .
					if v_qty_need5 = 0 and v_choice = 4 then next .  /*考虑库存预分配 + 在途PO的 短缺料*/

					v_vend2 = "" .
					find first ptp_det 
						where ptp_domain = global_domain  
						and ptp_site = wo_site 
						and ptp_part = pts_sub_part 
					no-lock no-error .
					if avail ptp_det then do:
						v_vend2 = ptp_vend .
					end.
					else do:
						find first pt_mstr 
							where pt_domain = global_domain  
							and   pt_part = pts_sub_part
						no-lock no-error .
						if avail pt_mstr then v_vend2 = pt_vend .
					end.


					put space(78) "替代料: "  pts_sub_part "" v_vend2 /*"" desc3 "" desc4 */ "" v_qty_per "" v_need_date "" v_qty_req "" space(12) 
							"" v_qty_need2 "" v_qty_oh "" v_qty_need3 "" v_qty_pk "" v_qty_need4 "" v_qty_onway "" v_qty_need5 skip .


				end.  
			end . /*替代料*/
				 
		end. /*for each wod_det */
      {mfrpexit.i} /*bi*/
end. /*for each wo_mstr */

end. /* mainloop: */
{mfrtrail.i} /* bi REPORT TRAILER {mfreset.i} */

end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
