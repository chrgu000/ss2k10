/*xxshmdmt.p a+			Shipment Method Maintenance					*/
/* REVISION: EB(SP5)    LAST MODIFIED: 09/09/03  BY: Kaine          */

define variable strDesc as character.
define variable blnF5 as logical initial no.

{mfdtitle.i "a+"}

define variable del-yn like mfc_logical initial no.
define variable strErrItem as character.
define variable strErrType as character.
define variable strErrVia  as character.
strErrItem = "Item Code does not exist, Please re-enter".
strErrType = "Invalid  Measurement Type, Please enter <C> or <P> only".
strErrVia  = "Invalid Ship Via value, Please enter <A> or <S> only".
if global_user_lang = "TW" then do:
	strErrItem = "錯誤的料號，請重新輸入".
	strErrType = "箱/卡板錯誤，只可以輸入<C>或<P>".
	strErrVia  = "出貨方式錯誤﹐隻可以輸入<A>或<S>".
end.

form
	ptship_part colon 15
	strDesc at 17 no-label format "x(49)"
	ptship_meas_type colon 15   "(Carton/Pallet)"
	ptship_via colon 15			"(Air/Sea)"
	ptship_ct_length colon 18	"*"
	ptship_ct_height no-label	"*"
	ptship_ct_width  no-label	"="
	ptship_cbm no-label  "CBM (L*H*W in cm)"
	ptship_ctn_qty colon 18
	ptship_pallet_qty colon 18	"in"
	ptship_ctn_pallet no-label  "CTN"
	ptship_netwt colon 18	"KG"
	ptship_grosswt colon 18	"KG"
with frame a side-labels width 80.
setFrameLabels(frame a:handle).

repeat on endkey undo, leave:
	prompt-for
		ptship_part validate(can-find(first pt_mstr no-lock
			where pt_part = input ptship_part), strErrItem)
		ptship_meas_type validate((input ptship_meas_type = "c"
			or input ptship_meas_type = "p"),
			strErrType)
	with frame a editing:		
		if frame-field = "ptship_part" then do:
			{mfnp.i ptship_mstr ptship_part ptship_part ptship_part ptship_part ptship_shv}
			if recno <> ? then do:
				find first pt_mstr where pt_part = ptship_part no-lock no-error.
				if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
				display
					ptship_part
					strDesc
					ptship_meas_type
					ptship_via
					ptship_ct_length
					ptship_ct_height
					ptship_ct_width
					ptship_cbm
					ptship_ctn_qty
					ptship_pallet_qty
					ptship_ctn_pallet
					ptship_netwt
					ptship_grosswt
				with frame a.
			end.
			if lastkey = keycode("Return") or lastkey = keycode("Go")
				or lastkey= keycode("TAB") or lastkey = keycode("Back-TAB") then do:
				find first pt_mstr where pt_part = input ptship_part no-lock no-error.
				if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
				display strDesc with frame a.
			end.
		end.
		else if frame-field = "ptship_meas_type" then do:
			{mfnp09.i ptship_mstr ptship_meas_type ptship_meas_type
				ptship_part:screen-value ptship_part ptship_shv}
			if recno <> ? then do:
				find first pt_mstr where pt_part = ptship_part no-lock no-error.
				if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
				display 
					ptship_part
					strDesc
					ptship_meas_type
					ptship_via
					ptship_ct_length
					ptship_ct_height
					ptship_ct_width
					ptship_cbm
					ptship_ctn_qty
					ptship_pallet_qt
					ptship_ctn_pallet
					ptship_netwt
					ptship_grosswt
				with frame a.
			end.
		end.
		else do:
			readkey.
			apply lastkey.
		end.
	end.	

	find first ptship_mstr where ptship_part = input ptship_part
		and ptship_meas_type = input ptship_meas_type
		and ptship_via = input ptship_via no-lock no-error.
	if available ptship_mstr then do:
		find first pt_mstr where pt_part = input ptship_part no-lock no-error.
		if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
		display
			ptship_part
			strDesc
			ptship_meas_type
			ptship_via
			ptship_ct_length
			ptship_ct_height
			ptship_ct_width
			ptship_cbm
			ptship_ctn_qty
			ptship_pallet_qt
			ptship_ctn_pallet
			ptship_netwt
			ptship_grosswt
		with frame a.
	end.
	else if not available ptship_mstr then do:
		find first ptship_mstr where ptship_part = input ptship_part
			and ptship_meas_type = input ptship_meas_type no-lock no-error.
		if available ptship_mstr then do:
			find first pt_mstr where pt_part = input ptship_part no-lock no-error.
			if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
			display
				ptship_part
				strDesc
				ptship_meas_type
				ptship_via
				ptship_ct_length
				ptship_ct_height
				ptship_ct_width
				ptship_cbm
				ptship_ctn_qty
				ptship_pallet_qt
				ptship_ctn_pallet
				ptship_netwt
				ptship_grosswt
			with frame a.
		end.
		else if not available ptship_mstr then do:
			find first pt_mstr where pt_part = input ptship_part no-lock no-error.
			if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
			display strDesc with frame a.
		end.
	end.
	
	ststatus = stline[2].
	status input ststatus.
	blnF5 = no.
	prompt-for
		ptship_via validate((input ptship_via = "a"
			or input ptship_via = "s"),
			strErrVia)
		go-on(F5 CTRL-D) with frame a editing:

		{mfnp09.i ptship_mstr ptship_via ptship_via
			ptship_part:screen-value ptship_part ptship_shv}
		if recno <> ? then do:
			find first pt_mstr where pt_part = ptship_part no-lock no-error.
			if available pt_mstr then strDesc = pt_desc1 + " " + pt_desc2.
			display
				ptship_part
				strDesc
				ptship_meas_type
				ptship_via
				ptship_ct_length
				ptship_ct_height
				ptship_ct_width
				ptship_cbm
				ptship_ctn_qty
				ptship_pallet_qt
				ptship_ctn_pallet
				ptship_netwt
				ptship_grosswt
			with frame a.
		end.
		if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
			del-yn = yes.
			{mfmsg01.i 11 1 del-yn}
			if del-yn then do:
				blnF5 = yes.
				find first ptship_mstr where ptship_part = input ptship_part
					and ptship_meas_type = input ptship_meas_type
					and ptship_via = input ptship_via no-error.
				if available ptship_mstr then delete ptship_mstr.
				clear frame a.
				display
					"" @ ptship_part
					"" @ strDesc
					"" @ ptship_meas_type 
					"" @ ptship_via       
					"" @ ptship_ct_length 
					"" @ ptship_ct_height 
					"" @ ptship_ct_width  
					"" @ ptship_cbm       
					"" @ ptship_ctn_qty   
					"" @ ptship_pallet_qty
					"" @ ptship_ctn_pallet
					"" @ ptship_netwt     
					"" @ ptship_grosswt   
				with frame a.
			end.
		end.
	end.

	if blnF5 = no then do:
		ststatus = stline[1].
		status input ststatus.

		prompt-for
			ptship_ct_length
			ptship_ct_height
			ptship_ct_width
			ptship_ctn_qty
			ptship_pallet_qty
			ptship_ctn_pallet
			ptship_netwt
			ptship_grosswt
		with frame a editing:
			if (frame-field = "ptship_ct_length" or frame-field = "ptship_ct_height"
				or frame-field = "ptship_ct_width") then do:
				readkey.
				if lastkey = keycode("return") or lastkey = keycode("go")
					or lastkey = keycode("tab") or lastkey = keycode("back-tab") then do:
					display
						(input ptship_ct_length * input ptship_ct_height * input ptship_ct_width / 10000) @ ptship_cbm
					with frame a.
					apply lastkey.
				end.
				else do:
					apply lastkey.
				end.
			end.
			else do:
				readkey.
				apply lastkey.
			end.
		end.

		if input ptship_meas_type = "c" then display "C" @ ptship_meas_type with frame a.
		if input ptship_meas_type = "p" then display "P" @ ptship_meas_type with frame a.
		if input ptship_via = "a" then display "A" @ ptship_via with frame a.
		if input ptship_via = "s" then display "S" @ ptship_via with frame a.
		display
			(input ptship_ct_length * input ptship_ct_height * input ptship_ct_width / 10000) @ ptship_cbm
		with frame a.

		find first ptship_mstr where ptship_part = input ptship_part
			and ptship_meas_type = input ptship_meas_type
			and ptship_via = input ptship_via no-error.
		if not available ptship_mstr then create ptship_mstr.
		assign
			ptship_part
			ptship_meas_type
			ptship_via
			ptship_ct_length
			ptship_ct_height
			ptship_ct_width
			ptship_cbm = (input ptship_ct_length * input ptship_ct_height * input ptship_ct_width) / 10000
			ptship_ctn_qty
			ptship_pallet_qty
			ptship_ctn_pallet
			ptship_netwt
			ptship_grosswt.
	end.
end.
