/* By: Neil Gao Date: 08/01/06 ECO: * ss 20080106 * */

{mfdtitle.i "1"}
def var lot as char label "工单 ID" .
def var lot1 as char label "至".
DEFINE VARIABLE loc like loc_Loc .
define var duedate 	like wo_due_date .
define var duedate1	like wo_due_date .
define var xxqty like ld_qty_oh.
define var open_only as logical init yes.
define var part like pt_part.
define var part1 like pt_part.

	form
		skip(1)
    duedate	 colon 12 label "完工日期"
    duedate1 colon 38 label "至"
    lot	     colon 12 label "工单ID"
    lot1     colon 38 label "至"
    part     colon 12 
    part1    colon 38 label "至"
    loc			 colon 12 label "库位"
    open_only colon 12 label "只显示缺料"
    skip(1)
  with frame a width 80 side-label.


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

	{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
hide all no-pause .
view frame dtitle .

  IF c-application-mode <> 'web':u THEN
			if duedate = low_date then duedate = ?.
			if duedate1 = hi_date then duedate1 = ?.
			if lot1 = hi_char then lot1 = "".
			if part1 = hi_char then part1 = "".
			
			UPDATE
				duedate 
				duedate1
				lot
				lot1
				part
				part1
				loc
				open_only
			WITH FRAME a.
			
			if duedate = ? then duedate = low_date.
			if duedate1 = ? then duedate1 = hi_date.
			if lot1 = "" then lot1 = hi_char.
			if part1 = "" then part1 = hi_char.

  {mfselprt.i "printer" 132}
	
	for each wo_mstr where wo_domain = global_domain and wo_status = "R" and wo_due_date >= duedate
		and wo_due_date <= duedate1 and wo_lot >= lot and wo_lot <= lot1 no-lock,
		each wod_det where wod_domain = global_domain and wod_nbr = wo_nbr and wod_lot = wo_lot 
			and (wod_loc = loc or loc = "") 
			and wod_part >= part and wod_part <= part1
			and (wod_qty_req > wod_qty_iss or not open_only )no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = wod_part and pt_iss_pol no-lock
		by wo_due_date by wo_lot by wod_part
		with frame c width 200:
		
		setframelabels(frame c:handle).
		
		xxqty = 0 .
		for each ld_det where ld_domain = global_domain and ld_part = wod_part and ld_status begins "Y" no-lock:
			xxqty = xxqty + ld_qty_oh.
		end.
		
		disp 	wo_due_date wo_lot wod_part pt_desc1 wod_loc wod_qty_req wod_qty_iss 
					xxqty label "可用库存"
		with frame c.
		down with frame c.
		
  end.
  
  {mfreset.i}
	{mfgrptrm.i}

end.
	{wbrp04.i &frame-spec = a}
