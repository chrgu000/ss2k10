/* SS - 090827.1 By: Neil Gao */

{mfdtitle.i "090827.1"}

form
	skip(1)
	mfc_label no-label colon 10
	mfc_logical no-label
	"控制物料: "  colon 25
	mfc_char no-label  format "x(18)"
	skip(1)
with frame a width 80 side-labels attr-space.


mainloop:
repeat:
	
	for first mfc_ctrl where mfc_field = "SoftspeedSCM_VP"
  exclusive-lock: end.
  if not available mfc_ctrl then do:
  	create mfc_ctrl.
    assign mfc_field   = "SoftspeedSCM_VP"
         	 mfc_module  = "SCM"
         	 mfc_label   = "  SCM供应商零件控制文件:"
         	 mfc_seq     = 10
         	 mfc_logical = yes.
	end.
	
	disp mfc_label with frame a.
	
	update mfc_logical mfc_char with frame a.
	
	if mfc_logical then do:
		find first pt_mstr where pt_part = mfc_char no-lock no-error.
		if not avail pt_mstr then do:
			{pxmsg.i &msgnum = 16 &errorlevel = 3}
			next-prompt mfc_char with frame a.
			undo,retry.
		end.
	end. /* if mfc_logical */
end. /* mainloop */
