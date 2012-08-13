{mfdtitle.i}
def var part like pt_part.
def var part1 like pt_part label {t001.i}.
def var prodline like pt_prod_line.
def var prodline1 like pt_prod_line label {t001.i}.

def temp-table tmp_part 
		field tmp_recno as recid
		field tmp_err_yn as log
		field tmp_type 	as char 
		field tmp_last_err_reason as char format "x(40)" label "Error Message"
		index idx01 tmp_recno
		index idx02 tmp_err_yn.
def temp-table tmp_msg
		field tmpmsg_recno as recid
		field tmpmsg_msg  as char format "x(40)" label "Error Message"
		index idx01 tmpmsg_recno. 
def var site as char.
def var i as int.
def var itemtype as int.   /* 1 = 发动机总成,   2 = 八大件(自制件),  3 = 组号或虚件, 4 = 协配件(采购件), 5 = 机型(F件) */

form part 		colon 15 part1 colon 45 
		 prodline colon 15 prodline1 colon 45 
		 with frame a width 80 side-label three-d .
setframelabels(frame a:handle).

MainLoop:
repeat:

if part1 = hi_char then part1 = "".
if prodline1 = hi_char then prodline1 = "".

update part 			part1 	
			 prodline 	prodline1 
			 with frame a side-label three-d.
			 
			 
{mfselprt.i "printer" 80}

if part1 = "" then part1 = hi_char.
if prodline1 = "" then prodline1 = hi_char.

empty temp-table tmp_part.
empty temp-table tmp_msg.

for each pt_mstr no-lock where pt_part >= part and pt_part <= part1
													 and pt_prod_line >= prodline and pt_prod_line <= prodline1:
		create tmp_part.
		assign tmp_recno = recid(pt_mstr)
					 tmp_err_yn = no
					 tmp_last_err_reason = "".
		if pt_group begins "58" then tmp_type = "01".
		if lookup(pt_group, "M") > 0 then tmp_type = "02".
		if lookup(pt_group, "O,PH") > 0 then tmp_type = "03".
		if lookup(pt_group, "RAW") > 0 then tmp_type = "04".
		if lookup(pt_group, "ZZ") > 0 then tmp_type = "05".
		for first code_mstr where code_fldname = "ID CODE" and code_value = substr(pt_part_type,1,index(pt_part_type,"-") - 1) no-lock: end.
		if avail code_mstr then tmp_type = "03".
		for each si_mstr no-lock where lookup(si_site,"DCEC-B,DCEC-C") > 0:
				site = si_site.
			  for first ptp_det where ptp_site = site
													 and ptp_part = pt_part no-lock:  end.
				if not avail ptp_det then do:
						if site = "DCEC-C" then do:
								tmp_err_yn = yes.
								tmp_last_err_reason = Site + " 地点信息不存在".
								create tmp_msg.
								assign tmpmsg_recno = tmp_recno
											 tmpmsg_msg		= tmp_last_err_reason.
						end.
						if site = "DCEC-B" then do:
								if tmp_type <> "03" then do:
										tmp_err_yn = yes.
										tmp_last_err_reason = Site + " 地点信息不存在".
										create tmp_msg.
										assign tmpmsg_recno = tmp_recno
													 tmpmsg_msg		= tmp_last_err_reason.
								end.
						end.
				end.
				if avail ptp_det then do:
						if site = "DCEC-B" and tmp_type = "03"  then do:
								tmp_last_err_reason = "存在地点DCEC-B信息".
								create tmp_msg.
								assign tmpmsg_recno = tmp_recno
											 tmpmsg_msg		= tmp_last_err_reason.
						end.
						else do:
								if not ((tmp_type = "01" and ptp_pm_code = "M" and ptp_phantom = no ) or 
												(tmp_type = "02" and ptp_pm_code = "M" and ptp_phantom = no ) or
												(tmp_type = "03" and ptp_pm_code = "M" and ptp_phantom = yes) or
												(tmp_type = "04" and ptp_pm_code = "P" and ptp_phantom = no) or
												(tmp_type = "05" and ptp_pm_code = "F" and ptp_phantom = no and pt_part_type = "999"))
												then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " 采/制代码,零件虚实与产品组不符".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
								end.
								if site = "DCEC-C" then do:
										if not ((ptp_bom_code = ptp_part and tmp_type <> "04") or (ptp_bom_code = "" and tmp_type = "04")) then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " BOM Code 不正确".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
										end.
										if not ((ptp_routing = ptp_part and tmp_type <> "04") or (ptp_routing = "" and tmp_type = "04")) then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " 工艺流程代码不正确".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
										end.
								end.
								if site = "DCEC-B" and tmp_type <> "03" and tmp_type <> "02" then do:
										if not ((ptp_bom_code = ptp_part + "ZZ"  and tmp_type <> "04") or (ptp_bom_code = "" and tmp_type = "04")) then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " BOM Code 不正确".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
										end.
										if not ((ptp_routing = ptp_part + "ZZ" and tmp_type <> "04") or (ptp_routing = "" and tmp_type = "04")) then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " 工艺流程代码不正确".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
										end.
								end.
								if site = "DCEC-B" and tmp_type = "02" then do:
										if not (ptp_bom_code = ptp_part) then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " BOM Code 不正确".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
										end.
										if not (ptp_routing = ptp_part) then do:
												tmp_err_yn = yes.
												tmp_last_err_reason = Site + " 工艺流程代码不正确".
												create tmp_msg.
												assign tmpmsg_recno = tmp_recno
															 tmpmsg_msg		= tmp_last_err_reason.
										end.
								end.
						end.
				end.
		end.
end.

for each tmp_part no-lock where tmp_err_yn,
		each pt_mstr where recid(pt_mstr) = tmp_recno no-lock with frame rpt width 320 stream-io:
		setframelabels(frame rpt:handle).
		disp pt_part pt_group pt_part_type pt_desc1 pt_desc2 pt_status				 .
		for each tmp_msg no-lock where tmpmsg_recno = tmp_recno with frame rpt:
				disp tmpmsg_msg.
				down.
		end.
end.

empty temp-table tmp_part.
empty temp-table tmp_msg.
{mfreset.i}
{mfgrptrm.i}
end.