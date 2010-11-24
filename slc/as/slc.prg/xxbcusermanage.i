/*DEFINE VARIABLE bcname as char .
DEFINE VARIABLE barcodeusermanagement as logi .
bcname = "" .

barcodeusermanagement = no .
find first code_mstr where code_domain = global_domain 
       and code_fldname = "barcode_use_user_management"
       and code_value = "softspeed"
       no-lock no-error.
if avail code_mstr then assign barcodeusermanagement = yes .

find first mon_mstr where mon_userid = global_userid and mon_sid = mfguser no-error.
if avail mon_mstr then do:
	assign bcname = mon_user1 .
end.

if loginyn = no then leave .*/	/*---Remark by davild 20081011.1*/