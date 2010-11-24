/*By: Neil Gao 08/09/28 ECO: *SS 20080928* */

{mfdtitle.i "N"}

define var trlot like tr_lot.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var effdate as date.
define var vendname like ad_name.
define var xxqty1 like tr_qty_loc.

form
	 trlot		      colon 15 label "收料单"
   tr_nbr					colon 35
   tr_part				colon 15 label "零件号"
   desc1					colon 35 no-label
   desc2					colon 35 no-label
   tr_qty_loc			colon 15 label "货运数量"
   tr_loc					colon 35
   tr_serial			colon 51 label "批/序"
   effdate        colon 15 label "生效日期"
   tr_ref					colon 35 label "参考号"
   vendname       colon 47 no-label
   skip(1)
   xxqty1					colon 15 label "回冲数量"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:
	
	clear frame a all no-pause. 
	update trlot with frame a.
	
	find first prh_hist use-index prh_receiver where prh_domain = global_domain and prh_receiver = trlot no-lock no-error.
	if avail prh_hist then 
	find first tr_hist use-index tr_part_eff where tr_domain = global_domain and tr_type = 'rct-po' and tr_lot = trlot 
		and tr__dec01 = 0 and prh_rcp_date = tr_effdate and prh_part = tr_part and tr_ship_type = "S" no-lock no-error.
	
	if not avail tr_hist then do:
   		message "收料单不存在或不是外协单".
   		undo,retry.
  end.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
   if not avail pt_mstr then do:
   		message "零件不存在".
   		undo,retry.
   end.

   find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
   
   display tr_lot @ trlot
      		 tr_nbr
     			 tr_part
     			 tr_loc 
     			 tr_qty_loc tr_serial tr_ref
     			 tr_effdate @ effdate 
     			 vd_sort  when ( avail vd_mstr ) @ vendname 
     			 pt_desc1 @ desc1 
     			 pt_desc2 @ desc2 with frame a.
   
   xxqty1 = tr_qty_loc.
		update xxqty1 with frame a.
		
		hide frame a no-pause.
		{ gprun.i ""xxdyicintr01.p""
							"(input tr_part,
								input xxqty1,
								input tr_site,
								input tr_loc,
								input tr_serial,
								input tr_ref
							)"} .
end.