/* SS - 090601.1 By: Neil Gao */

{mfdtitle.i "090601.1"}

define var xxpcnbr like xxpc_nbr.
define var vend like po_vend.
define var yn as logical.

form
	skip(1)
	xxpcnbr colon 25
	skip(1) 
with frame a side-labels attr-space.

setframelabels(frame a:handle).
	
mainloop:
repeat:

	update xxpcnbr with frame a.
	
	find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpcnbr no-lock no-error.
	if not avail usrw_wkfl then do:
		message "错误: 协议号不存在".
		next.
	end.
	else if usrw_user1 <> "" then do:
		message "已经转成正式不能删除".
		next.
	end.
	vend = usrw_key4.
	
	{mfselprt.i "printer" 100}
  
  {gprun.i ""xxrqpgyrp.p"" "(input xxpcnbr,input xxpcnbr,input vend ,input vend)"}
   	
  {mfreset.i}
	{mfgrptrm.i}
	
	message "是否删除" update yn.
	if yn then do:
		for each xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr = xxpcnbr:
			delete xxpc_mstr.
		end.
		for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpcnbr :
			delete usrw_wkfl.
		end.
		for each cd_det where cd_domain = global_domain and cd_ref = xxpcnbr and cd_lang = "ch" and cd_type = "sc" :
			delete cd_det.
		end.
		message "删除完成".
	end.
	
end. /* mainloop */	