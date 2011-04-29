/*xxshmdmt.p a+			Shipment Method Maintenance					*/
/* REVISION: EB(SP5)    LAST MODIFIED: 09/09/03  BY: Kaine          */

	define variable strMethod as character extent 10 initial "".
	define variable i as integer.
	define variable j as integer.
	define variable strCodefld like code_fldname.
	define variable blnUnique as logical.
	strCodefld = "loc_type".
	
	define new shared variable routseq1 as character.
	define new shared variable routseq2 as character.
	define new shared variable routseq3 as character.
	define new shared variable routseq4 as character.
	define new shared variable routseq5 as character.
	define new shared variable routseq6 as character.
	define new shared variable routseq7 as character.
	define new shared variable routseq8 as character.
	define new shared variable routseq9 as character.
	define new shared variable routseq10 as character.
	
	define variable strTilRout as character.
	define variable strTilLoc as character.
	define variable strErrType as character.
	define variable strErrLoc as character.
	define variable strUnique as character.
	define variable ship# like ship_mt_code.
	
	{mfdtitle.i "a+"}
	define variable del-yn like mfc_logical initial no.
	
	strTilRout	= "Routing Sequence".
	strTilLoc	= "Location Sequence".
	strErrType	= "Invalid Routing, Please re-enter".
	strErrLoc	= "Location Code does not belong to related Routing Code, Please re-enter".
	strUnique	= "Location Code has already exist with the related Routing Code, Please re-enter".
	if global_user_lang = "TW" then do:
		strTilRout	= "行程路線排序".
		strTilLoc	= "地點排序".
		strErrType	= "無傚的庫位類型，請重新輸入".
		strErrloc	= "庫位不屬于該庫位類型，請重新輸入".
		strUnique	= "庫位類型中已經存在該庫位﹐請重新輸入".
	end.

	form
		ship_mt_code colon 20
		skip(1)
		strTilRout at 16 no-label format "x(18)"
		strTilLoc at 38 no-label format "x(18)"
		ship_rout_seq1  at 20   ship_loc_seq1  at 44
		ship_rout_seq2  at 20   ship_loc_seq2  at 44
		ship_rout_seq3  at 20   ship_loc_seq3  at 44
		ship_rout_seq4  at 20   ship_loc_seq4  at 44
		ship_rout_seq5  at 20   ship_loc_seq5  at 44
		ship_rout_seq6  at 20   ship_loc_seq6  at 44
		ship_rout_seq7  at 20   ship_loc_seq7  at 44
		ship_rout_seq8  at 20   ship_loc_seq8  at 44
		ship_rout_seq9  at 20   ship_loc_seq9  at 44
		ship_rout_seq10 at 19   ship_loc_seq10 at 43
	with frame frmshipcode side-labels width 80.
	setFrameLabels(frame frmshipcode:handle).
	
	display strTilRout strTilLoc with frame frmshipcode.

	repeat on endkey undo, leave:
		ststatus = stline[1].
		status input ststatus.
		prompt-for ship_mt_code with frame frmshipcode editing:
			{mfnp.i ship_mt_mstr ship_mt_code ship_mt_code
				ship_mt_code ship_mt_code ship_mt_code}
			if recno <> ? then do:
				display
					ship_mt_code
					strTilRout strTilLoc
					ship_rout_seq1  ship_loc_seq1
					ship_rout_seq2  ship_loc_seq2
					ship_rout_seq3  ship_loc_seq3
					ship_rout_seq4  ship_loc_seq4
					ship_rout_seq5  ship_loc_seq5
					ship_rout_seq6  ship_loc_seq6
					ship_rout_seq7  ship_loc_seq7
					ship_rout_seq8  ship_loc_seq8
					ship_rout_seq9  ship_loc_seq9
					ship_rout_seq10 ship_loc_seq10
				with frame frmshipcode.
			end.
		end.
		find first ship_mt_mstr where ship_mt_code = input ship_mt_code no-lock no-error.
		if available ship_mt_mstr then
			display
				ship_mt_code
				ship_rout_seq1  ship_loc_seq1
				ship_rout_seq2  ship_loc_seq2
				ship_rout_seq3  ship_loc_seq3
				ship_rout_seq4  ship_loc_seq4
				ship_rout_seq5  ship_loc_seq5
				ship_rout_seq6  ship_loc_seq6
				ship_rout_seq7  ship_loc_seq7
				ship_rout_seq8  ship_loc_seq8
				ship_rout_seq9  ship_loc_seq9
				ship_rout_seq10 ship_loc_seq10
			with frame frmshipcode.

		blnUnique = no.

		method-loop:
		repeat while blnUnique = no on endkey undo, leave:
			ststatus = stline[2].
			status input ststatus.
			del-yn = no.
			
			prompt-for
ship_rout_seq1
ship_loc_seq1
ship_rout_seq2 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq2 no-lock) or input ship_rout_seq2 = ""), strErrType)
ship_loc_seq2  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq2 and loc_loc = input ship_loc_seq2 no-lock) or (input ship_rout_seq2 = "" and input ship_loc_seq2 = "")), strErrLoc)
ship_rout_seq3 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq3 no-lock) or input ship_rout_seq3 = ""), strErrType)
ship_loc_seq3  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq3 and loc_loc = input ship_loc_seq3 no-lock) or (input ship_rout_seq3 = "" and input ship_loc_seq3 = "")), strErrLoc)
ship_rout_seq4 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq4 no-lock) or input ship_rout_seq4 = ""), strErrType)
ship_loc_seq4  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq4 and loc_loc = input ship_loc_seq4 no-lock) or (input ship_rout_seq4 = "" and input ship_loc_seq4 = "")), strErrLoc)
ship_rout_seq5 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq5 no-lock) or input ship_rout_seq5 = ""), strErrType)
ship_loc_seq5  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq5 and loc_loc = input ship_loc_seq5 no-lock) or (input ship_rout_seq5 = "" and input ship_loc_seq5 = "")), strErrLoc)
ship_rout_seq6 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq6 no-lock) or input ship_rout_seq6 = ""), strErrType)
ship_loc_seq6  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq6 and loc_loc = input ship_loc_seq6 no-lock) or (input ship_rout_seq6 = "" and input ship_loc_seq6 = "")), strErrLoc)
ship_rout_seq7 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq7 no-lock) or input ship_rout_seq7 = ""), strErrType)
ship_loc_seq7  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq7 and loc_loc = input ship_loc_seq7 no-lock) or (input ship_rout_seq7 = "" and input ship_loc_seq7 = "")), strErrLoc)
ship_rout_seq8 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq8 no-lock) or input ship_rout_seq8 = ""), strErrType)
ship_loc_seq8  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq8 and loc_loc = input ship_loc_seq8 no-lock) or (input ship_rout_seq8 = "" and input ship_loc_seq8 = "")), strErrLoc)
ship_rout_seq9 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq9 no-lock) or input ship_rout_seq9 = ""), strErrType)
ship_loc_seq9  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq9 and loc_loc = input ship_loc_seq9 no-lock) or (input ship_rout_seq9 = "" and input ship_loc_seq9 = "")), strErrLoc)
ship_rout_seq10 validate((can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq10 no-lock) or input ship_rout_seq10 = ""), strErrType)
ship_loc_seq10  validate((can-find(first loc_mstr where loc_type = input ship_rout_seq10 and loc_loc = input ship_loc_seq10 no-lock) or (input ship_rout_seq10 = "" and input ship_loc_seq10 = "")), strErrLoc)
go-on(F5 ctrl-d) with frame frmshipcode editing:
				if frame-field = "ship_rout_seq1" then do:
					{mfnp09.i code_mstr ship_rout_seq1 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq1 with frame frmshipcode.
					assign routseq1 = input ship_rout_seq1.
					/*if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
						del-yn = yes.
						{mfmsg01.i 11 1 del-yn}
						if del-yn then do:
							find first ship_mt_mstr where ship_mt_code = input ship_mt_code no-error.
							if available ship_mt_mstr then delete ship_mt_mstr.
							clear frame frmshipcode.
							next-prompt ship_mt_code with frame frmshipcode.
							leave method-loop.
						end.
					end.*/
					ship# = input ship_mt_code.
					run del_F5(input ship#).
					if keyfunction(lastkey) = "RETURN" or keyfunction(lastkey) = "GO"
						or keyfunction(lastkey) = "TAB" or keyfunction(lastkey) = "BACK-TAB"
					then do:
						if not (can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq1 no-lock) or input ship_rout_seq1 = "") then do:
							message strErrType.
							next-prompt ship_rout_seq1 with frame frmshipcode.
						end.
					end.
				end.
				else if frame-field = "ship_rout_seq2" then do:
					{mfnp09.i code_mstr ship_rout_seq2 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq2 with frame frmshipcode.
					assign routseq2 = input ship_rout_seq2.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq3" then do:
					{mfnp09.i code_mstr ship_rout_seq3 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq3 with frame frmshipcode.
					assign routseq3 = input ship_rout_seq3.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq4" then do:
					{mfnp09.i code_mstr ship_rout_seq4 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq4 with frame frmshipcode.
					assign routseq4 = input ship_rout_seq4.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq5" then do:
					{mfnp09.i code_mstr ship_rout_seq5 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq5 with frame frmshipcode.
					assign routseq5 = input ship_rout_seq5.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq6" then do:
					{mfnp09.i code_mstr ship_rout_seq6 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq6 with frame frmshipcode.
					assign routseq6 = input ship_rout_seq6.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq7" then do:
					{mfnp09.i code_mstr ship_rout_seq7 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq7 with frame frmshipcode.
					assign routseq7 = input ship_rout_seq7.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq8" then do:
					{mfnp09.i code_mstr ship_rout_seq8 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq8 with frame frmshipcode.
					assign routseq8 = input ship_rout_seq8.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq9" then do:
					{mfnp09.i code_mstr ship_rout_seq9 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq9 with frame frmshipcode.
					assign routseq9 = input ship_rout_seq9.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_rout_seq10" then do:
					{mfnp09.i code_mstr ship_rout_seq10 code_value
						strCodefld code_fldname code_fldval}
					if recno <> ? then display code_value @ ship_rout_seq10 with frame frmshipcode.
					assign routseq10 = input ship_rout_seq10.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq1" then do:
					{mfnp09.i loc_mstr ship_loc_seq1 loc_loc
						ship_rout_seq1:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq1 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
					if keyfunction(lastkey) = "RETURN" or keyfunction(lastkey) = "GO"
						or keyfunction(lastkey) = "TAB" or keyfunction(lastkey) = "BACK-TAB"
					then do:
						if not (can-find(first loc_mstr where loc_type = input ship_rout_seq1
								and loc_loc = input ship_loc_seq1 no-lock)
							or (input ship_rout_seq1 = "" and input ship_loc_seq1 = ""))
						then do:
							message strErrType.
							next-prompt ship_loc_seq1 with frame frmshipcode.
						end.
					end.
				end.
				else if frame-field = "ship_loc_seq2" then do:
					{mfnp09.i loc_mstr ship_loc_seq2 loc_loc
						ship_rout_seq2:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq2 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq3" then do:
					{mfnp09.i loc_mstr ship_loc_seq3 loc_loc
						ship_rout_seq3:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq3 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq4" then do:
					{mfnp09.i loc_mstr ship_loc_seq4 loc_loc
						ship_rout_seq4:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq4 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq5" then do:
					{mfnp09.i loc_mstr ship_loc_seq5 loc_loc
						ship_rout_seq5:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq5 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq6" then do:
					{mfnp09.i loc_mstr ship_loc_seq6 loc_loc
						ship_rout_seq6:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq6 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq7" then do:
					{mfnp09.i loc_mstr ship_loc_seq7 loc_loc
						ship_rout_seq7:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq7 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq8" then do:
					{mfnp09.i loc_mstr ship_loc_seq8 loc_loc
						ship_rout_seq8:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq8 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq9" then do:
					{mfnp09.i loc_mstr ship_loc_seq9 loc_loc
						ship_rout_seq9:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq9 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
				else if frame-field = "ship_loc_seq10" then do:
					{mfnp09.i loc_mstr ship_loc_seq10 loc_loc
						ship_rout_seq10:screen-value loc_type loc_loc}
					if recno <> ? then display loc_loc @ ship_loc_seq10 with frame frmshipcode.
					ship# = input ship_mt_code.
					run del_F5(input ship#).
				end.
			end.
			if not(can-find(first code_mstr where code_fldname = "loc_type" and code_value = input ship_rout_seq1 no-lock) or input ship_rout_seq1 = "") then do:
				message strErrType.
				next-prompt ship_rout_seq1 with frame frmshipcode.
				next.
			end.
			if not (can-find(first loc_mstr where loc_type = input ship_rout_seq1
					and loc_loc = input ship_loc_seq1 no-lock)
				or (input ship_rout_seq1 = "" and input ship_loc_seq1 = ""))
			then do:
				message strErrType.
				next-prompt ship_loc_seq1 with frame frmshipcode.
				next.
			end.
				
			strMethod[1]  = string(input ship_rout_seq1, "x(8)") + string(input ship_loc_seq1, "x(8)").
			strMethod[2]  = string(input ship_rout_seq2, "x(8)") + string(input ship_loc_seq2, "x(8)").
			strMethod[3]  = string(input ship_rout_seq3, "x(8)") + string(input ship_loc_seq3, "x(8)").
			strMethod[4]  = string(input ship_rout_seq4, "x(8)") + string(input ship_loc_seq4, "x(8)").
			strMethod[5]  = string(input ship_rout_seq5, "x(8)") + string(input ship_loc_seq5, "x(8)").
			strMethod[6]  = string(input ship_rout_seq6, "x(8)") + string(input ship_loc_seq6, "x(8)").
			strMethod[7]  = string(input ship_rout_seq7, "x(8)") + string(input ship_loc_seq7, "x(8)").
			strMethod[8]  = string(input ship_rout_seq8, "x(8)") + string(input ship_loc_seq8, "x(8)").
			strMethod[9]  = string(input ship_rout_seq9, "x(8)") + string(input ship_loc_seq9, "x(8)").
			strMethod[10] = string(input ship_rout_seq10, "x(8)") + string(input ship_loc_seq10, "x(8)").

			blnUnique = yes.
			isUnique-loop:
			do i = 1 to 9:
				do j = i + 1 to 10:
					if strMethod[i] = strMethod[j] and strMethod[i] <> "" then do:
						blnUnique = no.
						message strUnique.
						if i = 1 then next-prompt ship_rout_seq1 with frame frmshipcode.
						if i = 2 then next-prompt ship_rout_seq2 with frame frmshipcode.
						if i = 3 then next-prompt ship_rout_seq3 with frame frmshipcode.
						if i = 4 then next-prompt ship_rout_seq4 with frame frmshipcode.
						if i = 5 then next-prompt ship_rout_seq5 with frame frmshipcode.
						if i = 6 then next-prompt ship_rout_seq6 with frame frmshipcode.
						if i = 7 then next-prompt ship_rout_seq7 with frame frmshipcode.
						if i = 8 then next-prompt ship_rout_seq8 with frame frmshipcode.
						if i = 9 then next-prompt ship_rout_seq9 with frame frmshipcode.
						leave isUnique-loop.
					end.
				end.
			end.
			if blnUnique = yes  and del-yn = no then do:
				find first ship_mt_mstr where ship_mt_code = input ship_mt_code no-error.
				if not available ship_mt_mstr then create ship_mt_mstr.
				assign
				ship_mt_code
				ship_rout_seq1  ship_loc_seq1
				ship_rout_seq2  ship_loc_seq2
				ship_rout_seq3  ship_loc_seq3
				ship_rout_seq4  ship_loc_seq4
				ship_rout_seq5  ship_loc_seq5
				ship_rout_seq6  ship_loc_seq6
				ship_rout_seq7  ship_loc_seq7
				ship_rout_seq8  ship_loc_seq8
				ship_rout_seq9  ship_loc_seq9
				ship_rout_seq10 ship_loc_seq10.
			end.
		end.
	end.
	
	
	/******Kaine Procedure ***/
	Procedure del_F5:
	    define input parameter ship_mt_code# like ship_mt_code.
		if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
			del-yn = yes.
			{mfmsg01.i 11 1 del-yn}
			if del-yn then do:
				find first ship_mt_mstr where ship_mt_code = ship_mt_code# no-error.
				if available ship_mt_mstr then delete ship_mt_mstr.
				clear frame frmshipcode.
				next-prompt ship_mt_code with frame frmshipcode.
			end.
		end.
	end Procedure.