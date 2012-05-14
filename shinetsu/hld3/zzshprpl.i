/*zzshprpl.i   Replace Function*/
/*Last Modify by Leo Zhou   12/05/2011 */

v_key2 = string(v_new_month,"999999") + v_new_part + string(v_new_count,"99").

/***Find shipping schedule***/
find first usrw_wkfl no-lock where usrw_domain = global_domain
       and usrw_key1 = "PRE_SHIP"
       and usrw_key2 = v_key2
       /*and int(usrw_key3) = v_new_seq   
       and usrw_decfld[2] > 0 */ no-error.
if not avail usrw_wkfl then do:
     /*No Ship Weight Schedule found*/
     {pxmsg.i &MSGNUM=4551 &ERRORLEVEL=3 &MSGARG1=v_key2}
     pause.
     return.
end.

if usrw_decfld[2] = 0 then do:
     /*Did not find the Ship Weight Preparation detail data.*/
     {pxmsg.i &MSGNUM=31021 &ERRORLEVEL=3 &MSGARG1=v_key2}
     pause.
     return.
end.

find first pt_mstr where pt_domain = global_domain 
     and pt_part = v_new_part no-lock no-error.

v_part    = v_new_part.
v_period  = v_new_month.
v_count   = v_new_count.
v_seq     = int(usrw_key3).
v_plan_wt = usrw_decfld[1].   /* Plan qty*/
v_comp_wt = usrw_decfld[2].   /* Actual preparation qty */
v_remain_wt = max(v_plan_wt - v_comp_wt,0) .
v_desc = pt_desc1.

disp v_part v_desc v_period v_count /*v_seq*/ with frame a.

/*Find Original Data*/
for first usrw_wkfl no-lock where usrw_domain = global_domain
       and usrw_key1 = "PRE_SPSB"
       and usrw_key2 = v_key2 + string(v_new_seq,"99")
       and int(usrw_key3) = v_seq  :
    v_recid = recid(usrw_wkfl).
    for each zzsellot_mstr no-lock where zzsellot_domain = global_domain
        and zzsellot_final = "1"
        and zzsellot_shiplotno >= usrw_charfld[1]
	and zzsellot_shiplotno <= usrw_charfld[2]:

	create tt.
        assign 
	   tt_key1 = yes
           tt_key2 = no
	   tt_key3 = ""
	   tt_lotno  = zzsellot_lotno
	   tt_def    = zzsellot_insp_defect
	   tt_star   = zzsellot_insp_star
	   tt_mfd    = zzsellot_insp_mfd
	   tt_lc     = zzsellot_insp_cutoff
	   tt_l0     = zzsellot_insp_zdw
	   tt_dia    = zzsellot_insp_dia
	   tt_efflen = zzsellot_insp_efflength
	   tt_totwt  = zzsellot_insp_diviedweight
	   tt_calwt  = zzsellot_insp_calcweight
	   tt_gdwt   = zzsellot_insp_goodweight   /*CLZ*/
	   tt_diavar = zzsellot_insp_diavar
	   tt_dn     = zzsellot_insp_dn
	   tt_ecc    = zzsellot_insp_ecc
	   tt_bow    = zzsellot_insp_bow
	   tt_ellip  = zzsellot_insp_noncirc
	   tt_bubb   = zzsellot_insp_bubble.

	if tt_def  = ? then tt_def  = "".
	if tt_star = ? then tt_star = "".
	if tt_mfd  = ? then tt_mfd  = 0.
	if tt_dia  = ? then tt_dia  = 0.
	if tt_bubb = ? then tt_bubb = "".
	
	create t1.
	assign t1_lotno = zzsellot_lotno.
    end.
end.   /*for each PRE_SPSB*/


v_normal_wt = 0.
v_normal_qty = 0.
v_defect_wt = 0.
v_defect_qty = 0.
v_star_wt = 0.
v_star_qty = 0.
v_avail_wt = 0.
v_avail_qty = 0.
v_reserve_wt = 0.
v_reserve_qty = 0.
v_hold_wt = 0.
v_hold_qty = 0.
v_notspec_wt = 0.
v_notspec_qty = 0.
v_result_wt = 0.
v_result_qty = 0.

/*Get Normal Inventory*/
for each ld_det where ld_domain = global_domain
        and ld_part = v_part + "-05" and ld_loc = v_loc:
	find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot2" 
	     and lot__chr02 = v_progress no-lock no-error.
	if not avail lot_mstr then next.

	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = ld_lot
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr or 
	   (zzsellot_shiplotno <> "" and zzsellot_shiplotno <> ?) then next.

	/*Specification Check*/
	v_result = no.
	{gprun.i ""zzspechk.p"" "(ld_lot, '', v_part, output v_result)"} 

	create wk.
	assign wk_lotno = ld_lot
	       wk_flag  = 0
	       wk_qty   = zzsellot_insp_goodweight .

	if v_result = no then do:
	   wk_flag = 7.    /* Out of specification */
	end.
	else do:

	  /*Status Check*/
	  find first lot_mstr where lot_domain = global_domain
	     and lot_serial = ld_lot and lot_part = "zzlot1" 
	     no-lock no-error.
	  if avail lot_mstr then do:
	    if lot__chr02 = "1" then wk_flag = 6.   /*Hold*/
	    else if lot__chr03 <> "1" or lot__chr04 <> "1" or 
	       lot__chr05 <> "1" or lot__chr06 <> "1" 
	       then wk_flag = 5.   /*Reserve*/
	    else wk_flag = 2. /*Normal*/
          end.
	  
	  if wk_flag = 0 or wk_flag = 2 then do:
	     if zzsellot_insp_defect = "*" then wk_flag = 4.
	     else if zzsellot_insp_star = "*" then  wk_flag = 3.
	  end.

	  if wk_flag = 0 then wk_flag = 2.

	end.  /*v_result=yes*/
end.  /*for each ld_det*/

for each wk :
	if wk_flag = 2 then 
	   assign v_normal_wt  = v_normal_wt + wk_qty
	          v_normal_qty = v_normal_qty + 1.
	else if wk_flag = 3 then 
	   assign v_star_wt  = v_star_wt + wk_qty
	          v_star_qty = v_star_qty + 1.
	else if wk_flag = 4 then 
	   assign v_defect_wt  = v_defect_wt + wk_qty
	          v_defect_qty = v_defect_qty + 1.
	else if wk_flag = 5 then  /*Reserve*/
	   assign v_reserve_wt  = v_reserve_wt + wk_qty
	          v_reserve_qty = v_reserve_qty + 1.
	else if wk_flag = 6 then  /*Hold*/
	   assign v_hold_wt  = v_hold_wt + wk_qty
	          v_hold_qty = v_hold_qty + 1.
	else if wk_flag = 7 then  /*Out spec*/
	   assign v_notspec_wt  = v_notspec_wt + wk_qty
	          v_notspec_qty = v_notspec_qty + 1.
end.  /*for each wk*/

v_avail_wt = v_avail_wt + v_normal_wt + v_defect_wt + v_star_wt.
v_avail_qty = v_avail_qty + v_normal_qty + v_defect_qty + v_star_qty.

v_ship_wt = 0.
v_ship_qty = 0.
v_result_wt = 0.
v_result_qty = 0.

disp v_normal_wt  v_normal_qty
	v_reserve_wt  v_reserve_qty 
	v_defect_wt   v_defect_qty
	v_hold_wt     v_hold_qty
	v_star_wt     v_star_qty
	v_notspec_wt  v_notspec_qty 
	v_avail_wt    v_avail_qty 
	v_plan_wt   
	v_comp_wt  
	v_remain_wt 
	v_ship_wt     v_ship_qty 
	v_result_wt   v_result_qty 
    with frame a.


/*Find New Availabel Inventory*/
for each wk where wk_flag = 2 or wk_flag = 3 or wk_flag = 4 :
	find first zzsellot_mstr where zzsellot_domain = global_domain
	    and zzsellot_lotno = wk_lotno
	    and zzsellot_final = "1" no-lock no-error.
	if not avail zzsellot_mstr then next.

        create tt.
        assign 
	   tt_key1 = no
           tt_key2 = no
	   tt_key3 = ""
	   tt_lotno  = wk_lotno
	   tt_def    = zzsellot_insp_defect
	   tt_star   = zzsellot_insp_star
	   tt_mfd    = zzsellot_insp_mfd
	   tt_lc     = zzsellot_insp_cutoff
	   tt_l0     = zzsellot_insp_zdw
	   tt_dia    = zzsellot_insp_dia
	   tt_efflen = zzsellot_insp_efflength
	   tt_totwt  = zzsellot_insp_diviedweight
	   tt_calwt  = zzsellot_insp_calcweight
	   tt_gdwt   = zzsellot_insp_goodweight    /*CLZ*/
	   tt_diavar = zzsellot_insp_diavar
	   tt_dn     = zzsellot_insp_dn
	   tt_ecc    = zzsellot_insp_ecc
	   tt_bow    = zzsellot_insp_bow
	   tt_ellip  = zzsellot_insp_noncirc
	   tt_bubb   = zzsellot_insp_bubble.

        if tt_def  = ? then tt_def  = "".
	if tt_star = ? then tt_star = "".
	if tt_mfd  = ? then tt_mfd  = 0.
	if tt_dia  = ? then tt_dia  = 0.
	if tt_bubb = ? then tt_bubb = "".

	create t2.
	assign t2_lotno = wk_lotno.

end.  /*for each wk*/
