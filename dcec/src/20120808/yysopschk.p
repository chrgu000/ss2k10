{mfdtitle.i}
def var effdate as date label "AS Of Date" init today.
def var part 	like pt_part.
def var par 	like ps_par.
def var par1 	like ps_par label {t001.i}.
def var prodline like pt_prod_line init "7000".
def var prodline1 like pt_prod_line label {t001.i} init "7ZZZ".
def var comp 	like ps_comp.
def var opt as integer label "Option".
def var site 	like si_site init "DCEC-C".
def var sostatus like pt_status label "产品状态".

DEF VAR qty LIKE ps_qty_per.
DEF VAR MAX_level AS INTE format ">>>".
DEF VAR cur_level AS INTE.
DEF VAR max_part LIKE ps_par.
DEF VAR MAX_lt     LIKE pt_mfg_lead.
DEF VAR leadtime AS INTE.
def var disp_all as logical label "显示全部" format "Y/N".
def var seq as integer.
DEF TEMP-TABLE bomd_tmp  
    field bomd_site		like si_site
    FIELD bomd_part LIKE ps_par
    FIELD bomd_comp LIKE ps_comp
    FIELD bomd_level AS INTE
    FIELD bomd_max_part LIKE pt_part		label "Hi-Part"
    FIELD bomd_pm LIKE pt_pm_code
    FIELD bomd_qty LIKE ps_qty_per
    FIELD bomd_lt LIKE pt_mfg_lead
    field bomd_op like ps_op
    field bomd_recno as recid
    field bomd_comp_item like pt_part
    field bomd_comp_status like pt_status
    field bomd_seq as inte
    index idx01 bomd_site bomd_max_part bomd_comp.
    

form	 effdate colon 15 site colon 45 
			 par colon 15 par1 colon 45
			 prodline colon 15 prodline1 colon 45
			 sostatus colon 15 MAX_level colon 45
			 disp_all colon 15 
			 with frame a side-label three-d.
			 
setframelabels(frame a:handle).

MainLoop:
repeat:

if par1 = hi_char then par1 = "".
if prodline1 = hi_char then prodline1 = "".

update effdate 		site	
			 par 				par1 	
			 prodline		prodline1	
			 sostatus MAX_level 
			 disp_all   
			 with frame a side-label three-d.

{mfselprt.i "printer" 80}

if par1 = "" then par1 = hi_char.
if prodline1 = "" then prodline1 = hi_char.
empty temp-table bomd_tmp.
seq = 0.
for each pt_mstr where pt_part >= par 
									 and pt_part <= par1
								   and pt_prod_line >= prodline 
								   and pt_prod_line <= prodline1 
								   and (pt_status = sostatus or sostatus = "")
									 no-lock:
		cur_level = 0.
		qty = 0.
		leadtime = 0.
		MAX_part = pt_part.
		cur_level = cur_level + 1.
		run expand_next_structure(site, pt_part,cur_level,qty,leadtime).
end.
for each bomd_tmp where (bomd_op = 0 or disp_all = yes) no-lock,
		first ps_mstr where recid(ps_mstr) = bomd_recno no-lock 
		break by bomd_max_part by bomd_seq
		with frame rpt stream-io width 320:
		
		setframelabels(frame rpt:handle).
		
		if first-of(bomd_max_part) then do:
				for first pt_mstr where pt_part = bomd_max_part no-lock: end.
		end.
		disp bomd_max_part when first-of(bomd_max_part)
				 pt_status when first-of(bomd_max_part) and avail pt_mstr
				 fill(".", bomd_level) + string(bomd_level) @ bomd_level label "Level"
				 ps_par
				 ps_comp
				 ps_ref
				 ps_start
				 ps_end
				 ps_op
				 bomd_comp_status.
end.
empty temp-table bomd_tmp.
{mfreset.i}
{mfgrptrm.i}
end.

PROCEDURE expand_next_structure:

		DEF INPUT PARAMETER i_site 					AS CHAR.
		DEF INPUT PARAMETER i_part 					AS CHAR.
		DEF INPUT PARAMETER i_level 				AS INTE.
		DEF INPUT PARAMETER i_qty 					LIKE ps_qty_per.
		DEF INPUT PARAMETER i_lt  					LIKE pt_mfg_lead.
		def buffer buff_ptmstr for pt_mstr.
		part = i_part.
		qty = i_qty.
		leadtime = i_lt.
		
		for first ptp_det where ptp_site 			= i_site
												and ptp_part 			= part no-lock: end.
		if avail ptp_det and ptp_bom_code <> "" then part = ptp_bom_code.

		FOR EACH ps_mstr WHERE ps_par = part 
											 AND ((ps_start <= effdate OR ps_start = ?) 
											 				AND (ps_end = ? OR ps_end >= effdate )
											 				or effdate = ?)
											 AND NOT(ps_qty_per = 0) NO-LOCK:
				
				qty = ps_qty_per * i_qty * (100 / (100 - ps_scrp_pct)).
				seq = seq + 1.
				CREATE 	bomd_tmp.
				assign  bomd_recno = recid(ps_mstr).
				ASSIGN 	bomd_site		= i_site
								bomd_part = ps_par
								bomd_comp = ps_comp
								bomd_max_part = MAX_part
								bomd_level = cur_level
								bomd_qty = qty
								bomd_op = ps_op
								bomd_comp_item = ps_comp
								bomd_seq = seq.
				for first bom_mstr where bom_par = bomd_comp_item no-lock: end.
				if avail bom_mstr and bom__chr02 <> "" then do:
						bomd_comp_item = bom__chr02.
				end.								
				for first buff_ptmstr where buff_ptmstr.pt_part = bomd_comp_item no-lock: end.
				if avail buff_ptmstr then do:
						bomd_comp_status = buff_ptmstr.pt_status.
				end.
				cur_level = i_level + 1.
				if (cur_level <= max_level or max_level = 0) then
				RUN expand_next_structure(i_site, ps_comp,cur_level,qty,leadtime).
				cur_level = i_level.
				qty = i_qty.
		END.
end procedure. 