/*By: Neil Gao 08/12/02 ECO: *SS 20081202* */

{mfdtitle.i "n1"}

define var xxqz as char.
define var xxyr as char format "x(2)".

form
	xxqz colon 15 label "前缀"
	xxyr colon 15 label "年制"
	skip(1)
	xxslc_last_number colon 15 label "最后使用号码"
with frame a width 80 side-labels attr-space.

setframelabels(frame a:handle).

Mainloop:
repeat:
	
	update xxqz xxyr with frame a editing:
		if frame-field = "xxqz" then do:
			{mfnp05.i "xxslc_mstr" "xxslc_qianbawei" "xxslc_domain = global_domain "
					xxslc_QianBaWei "input xxqz" }
		end.
		else if frame-field = "xxyr"  then do:
			{mfnp05.i "xxslc_mstr" "xxslc_qianbawei" "xxslc_domain = global_domain and xxslc_QianBaWei = input xxqz"
					xxslc_ShiShiYi "input xxyr" }
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
		if recno <> ? then do:
			disp xxslc_QianBaWei @ xxqz xxslc_ShiShiYi @ xxyr xxslc_last_number with frame a.
		end.
	end.
	
	find first xxslc_mstr where xxslc_domain = global_domain and xxslc_QianBaWei = input xxqz 
		and xxslc_shishiyi = input xxyr no-error.
	if not avail xxslc_mstr then do:
		message "新增记录".
		create 	xxslc_mstr.
		assign 	xxslc_domain    = global_domain
						xxslc_QianBaWei = input xxqz
						xxslc_ShiShiYi  = input xxyr  
						xxslc_last_number = 10 .
	end.
	
	loop:
	do on error undo,retry:
		
		update xxslc_last_number with frame a.
		
		/*
		find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_id =   xxslc_last_number + 1 no-lock no-error.
		if avail xxvind_det then do:
			message "下一个号码已经存在".
			undo,retry.
		end.*/
		
	end.
	
end.