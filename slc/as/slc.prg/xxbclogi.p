/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/* DISPLAY TITLE */
/*
{mfdeclre.i}
DEFINE VARIABLE bcname as char .
DEFINE VARIABLE bcpass as char .
DEFINE VARIABLE bcprinttype as char .
DEFINE shared VARIABLE loginyn as logi .
loginyn = no .

find first code_mstr where code_domain = global_domain 
       and code_fldname = "barcode_use_user_management"
       and code_value = "softspeed"
       no-lock no-error.
if not avail code_mstr then do: assign loginyn = yes . leave . end.


hide all no-pause .
form
skip(1)
	bcname	colon 14 label "条码用户名" format "x(8)"
	bcpass	colon 14 	label "密    码"	format "x(20)"
	" 默认条码" to 13 
	bcprinttype colon 14 label "打印机类型" format "x(4)" skip(1)
	"可选项：Z200,Z300,T200,T300" at 8
	skip(1)
	with frame p SIDE-LABELS WIDTH 50 row 6 col 15 attr-space  THREE-D title "条码系统登入" .
find first mon_mstr where mon_userid = global_userid and mon_sid = mfguser no-error.
if avail mon_mstr then do:
	if mon_user1 = "" then do:
		repeat with frame p :
			do on error undo, retry:
				update bcname .
				find first code_mstr where code_domain = global_domain 
						       and code_fldname = "barcode_user"
						       and code_value = bcname 
						       no-lock no-error.
				if not avail code_mstr then do:
					message "用户名不可用,请重新输入!" view-as alert-box .
					undo,retry .
				end.

			end.

			do on error undo, retry:
				set bcpass blank .
				if encode(bcpass) <> code_user1 then do:
					message "密码不正确,请重新输入!" view-as alert-box .
					undo,retry .
				end.
			
			end.

			
			find first code_mstr where code_domain = global_domain 
					       and code_fldname = "barcode_print_type"
					       and code_value = bcname
					       no-error.
			if avail code_mstr then assign bcprinttype = code_cmmt .
			else do:
				create code_mstr .
				assign code_domain = global_domain        
				       code_fldname = "barcode_print_type"
				       code_value = bcname 
				       bcprinttype = "Z200" .   
			end.
			do on error undo, retry:
				update bcprinttype .
				if lookup(bcprinttype,"Z200,Z300,T200,T300") = 0 then do:
					message "只能为Z200,Z300,T200,T300,请重新输入!" view-as alert-box .
					undo,retry .
				end.
				assign code_cmmt = bcprinttype .			
			end.
			assign mon_user1 = bcname 
				loginyn = yes .
			leave .
		end.
	end.
	else assign loginyn = yes .
end.
else do:
	message "Login Error ." view-as alert-box .
	leave .
end.

hide all no-pause .

*/	/*---Remark by davild 20081011.1*/