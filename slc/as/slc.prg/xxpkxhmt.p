/*By: Neil Gao 08/10/14 ECO: *SS 20081014* */
/*By: Neil Gao 09/02/10 ECO: *SS 20090210* */

{mfdtitle.i "n1"}

define var site like ld_site.
define var packno as char.
define var part like pt_part.
define var desc1 like pt_desc1.
define var location like ld_loc.
define var lotserial like ld_lot.
define var lotref like ld_ref.
define var gwt as deci.
define var gwtum like pt_um.
define var gwtrk as char format "x(18)".
define var nwt as deci.
define var nwtum like pt_um.
define var nwtrk like gwtrk.
define var vol as deci.
define var volum like pt_um.
define var volrk like gwtrk.
define var sonbrtype as char.
define var errorst   as logical no-undo.
define var errornum  as integer no-undo.
define var v_number  as char  no-undo.

form
	site colon 12
	packno colon 12 label "包装箱号"
	skip(1)
	part colon 12 label "物料号"
	desc1 colon 45
	location colon 12
	lotserial 
	lotref
	skip(1)
	xxabs_gwt colon 12 label "毛重"
	xxabs_gwt_um no-label xxabs_gwt_rk no-label
	xxabs_nwt colon 12 label "净重"
	xxabs_nwt_um no-label xxabs_nwt_rk no-label
	xxabs_vol_rk colon 12 label "体积"
	xxabs_vol_um no-label 
	xxabs_gh colon 12
	xxabs_fh colon 12
	xxabs_rmks colon 12
	skip(1)
with frame a side-labels width 80 attr-space.	

setFrameLabels(frame a:handle).

site = "12000".
	
Mainloop:
repeat:
	
	update site packno with frame a editing:
		if frame-field = "packno" then do:
			{mfnp05.i xxabs_mstr xxabs_id
       		" xxabs_domain = global_domain and xxabs_shipfrom = input site and xxabs_par_id = '' and xxabs_type = 'P'"
          	xxabs_id  "input packno"}
      if recno <> ? then do:
      	disp xxabs_id @ packno with frame a.
      end.
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end.
	
	find first si_mstr where si_domain= global_domain and si_site = site no-lock no-error.
	if not avail si_mstr then do:
		message "地点不存在".
		undo,retry.
	end.
	
	if packno <> "" then do:
		find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_id = packno  no-error.
		if not avail xxabs_mstr then do:
			message "包装箱号不存在".
			undo,retry.
		end.
	end.
	else do:
		{gprun.i  ""xxgpnrmgv.p""
            		"('packno',
              	input-output packno,
              	output errorst,
              	output errornum)" }
    if packno = "" then do:
    	message "包装箱号没有产生".
    	undo,retry.
    end.
    disp packno with frame a.
   	create xxabs_mstr.
   	assign xxabs_domain = global_domain 
   				 xxabs_shipfrom = site
   				 xxabs_id = packno
   				 xxabs_type = "P"
   				 xxabs_crt_date = today
   				 xxabs_crt_time = now
   				 xxabs_userid = global_userid
   				 xxabs_qty = 1
   				 .
	end.
	
	if not avail xxabs_mstr then next.
	/*
	disp	xxabs_part @ part 
				xxabs_loc  @ location
				xxabs_lot  @ lotserial
				xxabs_ref  @ lotef.
	update xxabs_part xxabs_loc xxabs_ref with frame a.
	*/
	
	update 	xxabs_gwt xxabs_gwt_um xxabs_gwt_rk
					xxabs_nwt xxabs_nwt_um xxabs_nwt_rk
					xxabs_vol_rk xxabs_vol_um 
					xxabs_gh	xxabs_fh
					xxabs_rmks 
	with frame a.
	
	
end.		