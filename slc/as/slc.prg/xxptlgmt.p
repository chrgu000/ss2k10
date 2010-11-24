/*By: Neil Gao 08/08/22 ECO: *SS 20080822* */

{mfdtitle.i}

define var part like pt_part.
define var ptlang like cd_lang.
define var desc1 like pt_desc1 format "x(60)".
define var del-yn as logical.

form
	part colon 15
	ptlang colon 60
	desc1 colon 15
	skip(1)
  cd_cmmt    no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

part = global_part.
ptlang = "us".

repeat:
	
	update part ptlang with frame a editing:
		if frame-field= "part" then do:
			{mfnp05.i cd_det cd_ref_type  " cd_det.cd_domain = global_domain and input ptlang = cd_lang
        and cd_type = 'pc' "  cd_ref "input part"}
		end.
		else
		if frame-field= "ptlang" then do:
			{mfnp05.i cd_det cd_ref_type  " cd_det.cd_domain = global_domain and input part = cd_ref
        and cd_type = 'pc' "  cd_lang "input ptlang"}
		end.
		else do:
    	readkey.
    	apply lastkey.
    end. /* ELSE DO */
    
    if recno <> ? then do:
    	disp 	cd_ref @ part
    				cd_lang @ ptlang
    				cd_cmmt[1] @ desc1 with frame a.
    end.
	end.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
	if not avail pt_mstr then do:
		{pxmsg.i &msgnum = 16 &errorlevel = 3}
		next.
	end.
	
	global_part = part.
	
	find first cd_det where cd_domain = global_domain and cd_ref = part and cd_lang = ptlang
		and cd_type = "PC" no-error.
	if avail cd_det then do:
		desc1 = cd_cmmt[1].
	end.
	else do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create cd_det. cd_det.cd_domain = global_domain.
      assign
         cd_ref = part 
         cd_type = "PC"
         cd_lang = ptlang
         cd_seq = 0.	
     desc1 = "".	
	end.
	
	update desc1 go-on ( "F5" "CTRL-D") with frame a .
	
	if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
  	del-yn = yes.
    {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
    if del-yn	then do:
    	delete cd_det.
     	clear frame a.
      next.
    end.
  end. /* IF LASTKEY = KEYCODE("F5") */
		 
	if desc1 entered then do:
		cd_cmmt[1] = desc1.
	end.
	
	find first cd_det where cd_det.cd_domain = global_domain and  cd_ref  = part
      and   cd_type = "SC"
      and cd_lang   = ptlang
   exclusive-lock no-error.
   if not available cd_det
   then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create cd_det. cd_det.cd_domain = global_domain.
      assign
         cd_ref = part 
         cd_type = "SC"
         cd_lang = ptlang
         cd_seq = 0.
   end. /* IF NOT AVAILABLE cd_det */

   display cd_cmmt with frame a.

   status input ststatus.
   del-yn = no.
	
  set1:
  do on error undo, retry:
  	
		set text(cd_cmmt) go-on ("F5" "CTRL-D" ) with frame a.
		
		if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      then do:
      	del-yn = yes.
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        if del-yn	then do:
      		delete cd_det.
      		clear frame a.
      		next.
      	end.
    end. /* IF LASTKEY = KEYCODE("F5") */
		
	end.
	
end.