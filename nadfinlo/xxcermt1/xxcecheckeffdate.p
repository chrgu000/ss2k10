/* Creation: eB21SP3 Chui Last Modified: 20080421 By: Davild Xu *ss-20080421.1*/
/***
xxcermt4.i ����
ͬһ�����ͬһ��Ӧ�̣����ܴ���OK/QTY/ALLOC�������͵�CER��Ч�����ص��������
	 BEGIN  �ڱ���ʱ��һ����Ҫ����б������
	{gprun.i ""xxcecheckeffdate.p""
	"(input danju,
	  input xxcer_part,
	  input xxcer_vend,
	  input xxcer_dec_result,
	  input xxcer_effdate,
	  input xxcer_expire,
	  output checkEffdateError
	)"}
	if checkEffdateError then do:
		next-prompt xxcer_effdate with frame a42 .
		undo,retry .
	end.
****/
{mfdtitle.i "dd"}

pause 0 .
def input parameter pro_xxcer_nbr	like xxcer_nbr	 .
def input parameter pro_xxcer_part	like xxcer_part	 .
def input parameter pro_xxcer_vend	like xxcer_vend	 .
def input parameter pro_xxcer_dec_result like xxcer_dec_result .
def input parameter pro_xxcer_effdate	like xxcer_effdate	 .
def input parameter pro_xxcer_expire	like xxcer_expire	 .
def output parameter pro_Error as logi .
DEFINE VARIABLE dteTmpB as date .
pro_Error = no .

if pro_xxcer_effdate = ? then assign pro_xxcer_expire = low_date .
if pro_xxcer_expire = ? then assign pro_xxcer_expire = hi_date .
for each xxcer_mstr where 
	xxcer_avail = yes	/*---Add by davild 20080707.1*/
		     and  xxcer_part = pro_xxcer_part
		     and  xxcer_vend = pro_xxcer_vend
		     and  xxcer_nbr <> pro_xxcer_nbr
		     and  xxcer_dec_result <> "���ϸ�(NG)"
		     no-lock :
	dteTmpB = xxcer_expire .
	if dteTmpB = ? then assign dteTmpB = hi_date .

	if xxcer_effdate = ? then assign pro_Error = yes .
	if xxcer_effdate >= pro_xxcer_effdate and xxcer_effdate <= pro_xxcer_expire then assign pro_Error = yes .
	if dteTmpB >= pro_xxcer_effdate and dteTmpB <= pro_xxcer_expire then assign pro_Error = yes .
	
	if pro_error then do:
		message "���뵥�� " + xxcer_nbr + " ����Ч���� " + string(xxcer_effdate) + " �������� " + string(dteTmpB)
		skip 
		"��������������ڵ����ص�,����������" view-as alert-box .
	end.
end.