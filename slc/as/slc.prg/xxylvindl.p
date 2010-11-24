/* SS - 090604.1 By: Neil Gao */
/* SS - 090921.1 By: Neil Gao */

{mfdtitle.i}

define var vin  like xxvind_id.
define var sonbr like so_nbr.
define var soline like sod_line.
define var wolot like wo_lot.
define var sonbr1 like so_nbr.
define var soline1 like sod_line.
define var wolot1 like wo_lot.
define var del-yn as logical.

form
	sonbr 	colon 25 label "销售订单"
	soline 	colon 25 label "项"
with frame a side-labels width 80 attr-space.

/*
setFrameLabels(frame a:handle).
*/
mainloop:
repeat:
	
	update sonbr soline with frame a.
	
	{mfselprt.i "printer" 132}
	
	for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = sonbr and (xxsovd_line = soline or soline = 0) 
		and xxsovd_wolot = "" no-lock:
	
		disp xxsovd_nbr xxsovd_line xxsovd_id with stream-io .
	
	end.
	
	message "是否删除" update del-yn.
	
	if del-yn then do:
		for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = sonbr and (xxsovd_line = soline or soline = 0) 
			and xxsovd_wolot = "":
			delete xxsovd_det.
		end.
	end.
	
	{mfreset.i}
	{mfgrptrm.i}
end. /* mainloop */
	