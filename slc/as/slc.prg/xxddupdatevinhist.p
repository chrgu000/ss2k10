/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/*---Add Begin by davild 20081011.1*/
/*-huoyundan_no--Add by davild 20081011.1*/
/*---Add End   by davild 20081011.1*/
{mfdtitle.i "SS"}
/*����Ƿ�������"����: "
	checknumber = 1=����
	checknumber = 2=����
	checknumber = 3=���
	checknumber = 4=��װ
	checknumber = 5=���
	checknumber = 6=װ��	loc ��ʱҪΪ װ�䵥��  motorvin Ϊ ���˵���
	checknumber = 7=����
	*/
DEFINE input  parameter vin like xxsovd_id .
DEFINE input  parameter motorvin like xxsovd_id .
DEFINE input  parameter wolot like xxsovd_wolot .
DEFINE input  parameter loc like pt_loc .
DEFINE input  parameter checknumber as char .
DEFINE output parameter cimError as logi .

DEFINE VARIABLE barcode_userid as char .
DEFINE VARIABLE v_repeat_pack as logi .
cimError = no .
find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_wolot = wolot and xxvind_id = vin no-error.
if avail xxvind_det then do :
	/*---Add Begin by davild 20080120.1*/
	/*��SO������ͬ����һ����ʶ--xxvind_log01=YES
	  ͬʱ��SO��������xxvind_dec01*/
        if xxvind_dec01 = 0 then do:
	find first sod_det where sod_domain = global_domain and sod_nbr = xxvind_nbr
		and sod_line = xxvind_line 
		no-lock no-error .
	if avail sod_det then do:
		if  sod_part = xxvind_part then do:
			assign xxvind_log01 = yes .
		end.
			assign xxvind_dec01 = sod_qty_ord .
	end.
	end.
	/*---Add End   by davild 20080120.1*/
	{gprun.i ""xxddgetbarcodeuser.p"" 
	"(output barcode_userid)"}

	if checknumber = "1" then do:
		/*�󶨷�������*/
		assign xxvind_motor_id = motorvin .	
		assign xxvind_up_date = today 
		       xxvind_up_time = time
		       xxvind_up_loc  = loc
		       xxvind_up_userid = barcode_userid .
	end.
	if checknumber = "2" then do:
		assign xxvind_down_date = today 
		       xxvind_down_time = time
		       xxvind_down_loc  = loc
		       xxvind_down_userid = barcode_userid .
	end.
	if checknumber = "3" then do:
		assign xxvind_check_date = today 
		       xxvind_check_time = time
		       xxvind_check_userid = barcode_userid .
	end.
	if checknumber = "4" then do:
		v_repeat_pack = no .
		if xxvind_pack_date <> ? then assign v_repeat_pack = yes .
		assign xxvind_pack_date = today 
		       xxvind_pack_time = time
		       xxvind_pack_userid = barcode_userid .
	end.
	if checknumber = "5" then do:
		assign xxvind_ruku_date = today 
		       xxvind_ruku_time = time
		       xxvind_ruku_loc  = loc
		       xxvind_ruku_userid = barcode_userid .
	end.
	if checknumber = "6" then do:
		assign xxvind_zhuangXiang_date = today 
		       xxvind_zhuangXiang_time = time
		       xxvind_zhuangXiang_NBR  = loc
			   xxvind_chr01 = motorvin	/*-huoyundan_no--Add by davild 20081011.1*/
		       xxvind_zhuangXiang_userid = barcode_userid .
	end.
	if checknumber = "7" then do:
		assign xxvind_cuku_date = today 
		       xxvind_cuku_time = time
		       xxvind_cuku_loc  = loc
		       xxvind_cuku_userid = barcode_userid .
	end.
	
	/*�ı俴�����ݱ�*/
	find first xxkbd_det where xxkbd_domain = global_domain and xxkbd_prod_Line = xxvind_prod_line
		and xxkbd_wolot = xxvind_wolot
		and xxkbd_date = today and xxkbd_type = checknumber no-error.
	if not avail xxkbd_det then do:
		create xxkbd_det .
		assign xxkbd_domain = global_domain
		       xxkbd_prod_line = xxvind_prod_Line
		       xxkbd_date = today
		       xxkbd_type = checknumber 
		       xxkbd_nbr  = xxvind_nbr
		       xxkbd_line = xxvind_line
		       xxkbd_part = xxvind_part
		       xxkbd_wonbr = xxvind_wonbr
		       xxkbd_wolot = xxvind_wolot 
		       .
	end.
	if xxkbd_type = "4" then	/*��װ�ظ���Ͳ�����*/
	do:
		if  v_repeat_pack = no then assign xxkbd_qty = xxkbd_qty + 1 .
	end.
	else assign xxkbd_qty = xxkbd_qty + 1 .	
	
	find first xxvin_mstr where xxvin_domain = global_domain 
		and xxvin_wolot = wolot no-error.
	if avail xxvin_mstr then do:
		if checknumber = "1" then do:
			assign xxvin_qty_up = xxvin_qty_up + 1 .
			assign xxvin_chr01 = string(today) + " " + string(time,"HH:MM:SS") .
		end.
		if checknumber = "2" then do:
			assign xxvin_qty_down = xxvin_qty_down + 1 .
			assign xxvin_chr02 = string(today) + " " + string(time,"HH:MM:SS") .				
		end.
		if checknumber = "3" then do:
			assign xxvin_qty_check = xxvin_qty_check + 1 .
			assign xxvin_chr03 = string(today) + " " + string(time,"HH:MM:SS") .				
		end.
		if checknumber = "4" and v_repeat_pack = no then do:
			assign xxvin_qty_pack = xxvin_qty_pack + 1 .
			assign xxvin_chr04 = string(today) + " " + string(time,"HH:MM:SS") .
		end.
		if checknumber = "5" then do:
			assign xxvin_qty_ruku = xxvin_qty_ruku + 1 .
			assign xxvin_chr05 = string(today) + " " + string(time,"HH:MM:SS") .
		end.
		if checknumber = "6" then do:
			assign xxvin_qty_zhuangxiang = xxvin_qty_zhuangxiang + 1 .
			assign xxvin_chr06 = string(today) + " " + string(time,"HH:MM:SS") .
		end.
		if checknumber = "7" then do:
			assign xxvin_qty_cuku = xxvin_qty_cuku + 1 .
			assign xxvin_chr07 = string(today) + " " + string(time,"HH:MM:SS") .
		end.
	end.
	else do:
		/*һ������ڵ�,����VIN��ʱ��������*/.
	end.
end .
else do:
	message "VIN�����ϲ�����."  .
	cimError = yes .
end.
