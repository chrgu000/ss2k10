/* REVISION: 1.0      LAST MODIFIED: 2007/12/29  BY: Softspeed roger xiao  */ /*xp001*/ 
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


/*begin defination ****************************************/
define var site  like wo_site .
define var v_wkctr   like wc_wkctr label "车间库位".
define var nbr   like wo_nbr label "加工单" .
define var nbr1  like wo_nbr .
define var part  like wod_part .
define var part1  like wod_part .
define var v_date like wo_rel_Date label "发放日期".
define var v_date1 like wo_rel_Date  label "至".
define var v_type as char format "x(2)" label "单据类别" .
define var v_ordertype as char format "x(2)" label "单据类型".
define var v_nbr as char label "单据号".
define var line as integer .

define var v_um      like pt_um .
define var v_desc1    like pt_desc1.
define var v_desc2    like pt_desc2.
define var v_qty_oh like ld_qty_oh label "在制品库存" .
define var v_qty_iss like tr_qty_loc label "发料量" .
define var v_qty_req like wod_qty_req label "需求量" .
define var v_qty_need like wod_qty_req label "需求量" .



v_ordertype = "LS" .


define  frame a .
/*end defination ****************************************/

/* DISPLAY SELECTION FORM */
form
    SKIP(.3)

    site                     colon 18   
	v_wkctr                  colon 49 

	nbr                      colon 18   
	nbr1                     colon 49   label {t001.i}
	part                     colon 18
    part1                    colon 49   label {t001.i} 
    v_date                   colon 18
    v_date1                  colon 49   label {t001.i} 
	skip(1) 
	v_ordertype              colon 18 "领料单"
	v_type                   colon 18
	v_nbr                    colon 18
    skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).


{wbrp01.i}
mainloop:
repeat:

setloop:
do on error undo, return error on endkey undo, return error:
	if nbr1 = hi_char         then nbr1  = "".
	if part1  = hi_char       then part1  = "".
	if v_date = low_date      then v_date = ? .
	if v_date1 = hi_date      then v_date1 = ? .

	disp v_ordertype v_nbr with frame a . 
    update site v_wkctr nbr nbr1  part part1   v_date v_date1	with frame a.

	find first si_mstr where si_domain = global_domain and si_site = site no-lock no-error .
	if not avail si_mstr then do:
	    message "地点无效" .
		undo,retry.
	end.

	find first loc_mstr where loc_domain = global_domain and loc_loc = v_wkctr no-lock no-error.
	if not avail loc_mstr then do:
		message "工作中心库位无效" .
		undo ,retry .
	end.

	typeloop:
	do on error undo, retry:
		update v_type with frame a .
	
		find first xdn_ctrl where xdn_domain = global_domain 
			and xdn_site = site 
			and xdn_ordertype = v_ordertype 
			and xdn_type = v_type exclusive-lock no-error.
		if not avail xdn_ctrl then do:
			message "单据类别无效:" site v_ordertype v_type.
			undo,retry .
		end.
		else do:
			v_nbr = xdn_prev + xdn_next.
			xdn_next = string(integer(xdn_next) + 1 ,"999999") .

		end.
		release xdn_ctrl.
	end.

	if nbr1 =  ""           then nbr1  = hi_char .
	if part1  = ""          then part1  = hi_char.
	if v_date = ?      then v_date = low_date .
	if v_date1 = ?     then v_date1 = hi_date  .

end. /*setloop:*/


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
crtloop: 
do on error undo, return error on endkey undo, return error:                    

line = 0 .

{mfphead.i}  /*bi*/
for each wo_mstr where wo_domain = global_domain 
		and wo_site = site 
		and wo_nbr >= nbr  and wo_nbr <= nbr1
		and wo_part >= part and wo_part <= part1 
		and ((wo_rel_date >= v_date and wo_rel_date <= v_date1 ) or wo_rel_date = ? )
		and ( wo_status = "R" ) /**/ no-lock,
	each wod_det where wod_domain = global_domain 
		and wod_nbr = wo_nbr and wod_lot = wo_lot
		break by wo_site  by wod_part by wod_nbr by wod_lot by wod_op
		with frame x width 300 :

		if first-of(wod_part) then do:
			v_qty_oh   = 0 .
			v_qty_req  = 0 .
			v_qty_iss  = 0 .
			for each ld_det where ld_domain = global_domain 
							and ld_site = wo_site
							and ld_loc  = v_wkctr
							and ld_part = wod_part
							and ld_qty_oh > 0 no-lock :
							
							v_qty_oh = v_qty_oh + ld_qty_oh .
			end.

			find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error .
			v_um = if avail pt_mstr then pt_um else "" .
			v_desc1 = if avail pt_mstr then pt_desc1 else "" .
			v_desc2 = if avail pt_mstr then pt_desc2 else "" .							
		end. /*if first-of(wod_part) then*/

		v_qty_req = v_qty_req + wod_qty_req .
		v_qty_iss = v_qty_iss + wod_qty_iss .

		if last-of(wod_part) then do:
				v_qty_need = v_qty_req - v_qty_iss - v_qty_oh .
				if v_qty_need <= 0 then next .

				disp wo_site label "地点" 
					 v_wkctr column-label "工作中心" 
					 /*wo_nbr label "加工单" */
					 wod_part label "零件号"
					 v_um label "UM"
					 v_Desc1 label "说明1"
					 v_desc2 label "说明2"
					 v_qty_need  column-label "需求量" 
					 with frame x . 

				find first xic_Det where xic_domain = global_domain and xic_nbr = v_nbr and xic_part = wod_part exclusive-lock no-error .
				if not avail xic_det then do:
					find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = wod_part no-lock no-error.

					line = line + 1.
					create xic_det.
					assign 
						xic_Domain = global_domain 
						xic_type = v_type
						xic_nbr = v_nbr 
						xic_line = line 
						xic_part = wod_part 
						xic_um   = v_um
						xic_ln_line    = v_wkctr 
						xic_qty_to = 0
						xic_loc_to = v_wkctr 
						xic_site_to = site
						xic_qty_from = v_qty_need
						xic_loc_from = if avail pt_mstr then pt_loc else ""  
						xic_site_from = site
						xic_date   = today
						xic_user1  = global_userid .
						/*xic_rsn    = wo_nbr + "," + xic_rsn . */
 				end.
				else do:
					xic_qty_to = v_qty_need + xic_qty_to .
				end.

					
		end. /*if last-of(wod_part) then*/
      {mfrpexit.i} /*bi*/
end. /*for each wo_mstr */


end. /* crtloop: */
{mfrtrail.i} /* bi REPORT TRAILER {mfreset.i} */

end.  /* mainloop */
{wbrp04.i &frame-spec = a}
