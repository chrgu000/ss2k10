/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*�Զ����߳���*/
{mfdtitle.i "SS"}
/*����Ƿ�������
	checknumber = 1=����
	checknumber = 2=����
	checknumber = 3=���
	checknumber = 4=��װ
	checknumber = 5=���
	checknumber = 6=װ��	loc ��ʱҪΪ װ�䵥��
	checknumber = 7=����
	*/
DEFINE input  parameter vin like xxsovd_id .
DEFINE input  parameter wolot like xxsovd_wolot .
DEFINE input  parameter checknumber as char .
DEFINE output parameter cimError as logi .
pause 0 .
cimError = yes .
find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_wolot = wolot and xxvind_id = vin no-error.
if avail xxvind_det then do :
	if checknumber = "1" then do:
		if xxvind_up_date = ?   then cimError = no . else cimError = yes .
	end.
	if checknumber = "2" then do:
		if xxvind_down_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "3" then do:
		if xxvind_check_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "4" then do:
		if xxvind_pack_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "5" then do:
		if xxvind_ruku_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "6" then do:
		if xxvind_zhuangxiang_date = ? then cimError = no . else cimError = yes .
	end.
	if checknumber = "7" then do:
		if xxvind_cuku_date = ? then cimError = no . else cimError = yes .
	end.	
end .
