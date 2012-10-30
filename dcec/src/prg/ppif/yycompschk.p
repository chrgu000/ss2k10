{mfdtitle.i}
def var effdate as date label "AS Of Date" init today.
def var part 	like pt_part.
def var par 	like ps_par.
def var par1 	like ps_par label {t001.i}.
def var comp 	like ps_comp.
def var opt as integer label "Option".
def var site like si_site init "DCEC-C".

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
		
form effdate 		colon 25 
		 with frame a width 80 side-label three-d .
setframelabels(frame a:handle).

MainLoop:
repeat:

if par1 = hi_char then par1 = "".

update effdate colon 15
			 par colon 15 par1 colon 45
			 with frame a side-label three-d.

{mfselprt.i "printer" 80}

if par1 = "" then par1 = hi_char.

empty temp-table tmp_part.
empty temp-table tmp_msg.

for each ps_mstr where 
   ((ps_start >= effdate or ps_start = ?) and (ps_end <= effdate or ps_end = ?) or effdate = ?) 
   and ps_par >= par and ps_par <= par1
   no-lock:  
		part = ps_par.
		for first bom_mstr where bom_par = part no-lock: end.
		if avail bom_mstr then do:
				if bom__chr02 <> "" then par = bom__chr02.
		end.
		if ps_op = ? then do:
				for first tmp_part where tmp_recno = recid(ps_mstr) no-lock: end.
				if not avail tmp_part then do:
						create tmp_part.
						assign tmp_recno = recid(ps_mstr).
				end.
						tmp_err_yn = yes.
						tmp_last_err_reason = "BOM结构中的工序不存在".
						create tmp_msg.
						assign tmpmsg_recno = tmp_recno
									 tmpmsg_msg		= tmp_last_err_reason.
		end.
		for first ptp_det where ptp_site = site and ptp_part = par no-lock: end.
		if not avail ptp_det then do:
				for first tmp_part where tmp_recno = recid(ps_mstr) no-lock: end.
				if not avail tmp_part then do:
						create tmp_part.
						assign tmp_recno = recid(ps_mstr).
				end.
						tmp_err_yn = yes.
						tmp_last_err_reason = part + " 地点信息不存在".
						create tmp_msg.
						assign tmpmsg_recno = tmp_recno
									 tmpmsg_msg		= tmp_last_err_reason.
		end.
		else if ptp_pm_code = "P" then do:
				for first tmp_part where tmp_recno = recid(ps_mstr) no-lock: end.
				if not avail tmp_part then do:
						create tmp_part.
						assign tmp_recno = recid(ps_mstr).
				end.
						tmp_err_yn = yes.
						tmp_last_err_reason = "父件" + part + " 为采购件".
						create tmp_msg.
						assign tmpmsg_recno = tmp_recno
									 tmpmsg_msg		= tmp_last_err_reason.
		end.
		
		part = ps_comp.
		for first bom_mstr where bom_par = part no-lock: end.
		if avail bom_mstr then do:
				if bom__chr02 <> "" then par = bom__chr02.
		end.
		
		for first ptp_det where ptp_site = site and ptp_part = part no-lock: end.
		if not avail ptp_det then do:
				for first tmp_part where tmp_recno = recid(ps_mstr) no-lock: end.
				if not avail tmp_part then do:
						create tmp_part.
						assign tmp_recno = recid(ps_mstr).
				end.
						tmp_err_yn = yes.
						tmp_last_err_reason = part + " 地点信息不存在".
						create tmp_msg.
						assign tmpmsg_recno = tmp_recno
									 tmpmsg_msg		= tmp_last_err_reason.
		end.
		else if ptp_phantom = yes and ps__chr01 = "DCEC-B" then do:
				find first bom_mstr where bom_par = ps_comp no-lock no-error.
				if (not avail bom_mstr) or bom_par <> part + "ZZ" then do:
						for first tmp_part where tmp_recno = recid(ps_mstr) no-lock: end.
						if not avail tmp_part then do:
								create tmp_part.
								assign tmp_recno = recid(ps_mstr).
						end.
								tmp_err_yn = yes.
								tmp_last_err_reason = "DCEC-B结构子零件为虚件,那么子零件的结构代码应该+ZZ".
								create tmp_msg.
								assign tmpmsg_recno = tmp_recno
											 tmpmsg_msg		= tmp_last_err_reason.
				end.
		end.
		
end.
for each tmp_part no-lock,
		each ps_mstr where recid(ps_mstr) = tmp_recno no-lock,
		each tmp_msg where tmpmsg_recno = tmp_recno no-lock
		with frame rpt stream-io width 320
		break by tmp_recno:
		if first-of(tmp_recno) then 
		disp ps_par ps_comp ps_ref ps_start ps_end ps_op ps_ps_code.
		disp tmpmsg_msg.
		down.
end.
empty temp-table tmp_part.
empty temp-table tmp_msg.

{mfreset.i}
{mfgrptrm.i}
end.