/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*�Զ����߳���*/
{mfdtitle.i "SS"}
pause 0 .


DEFINE input  parameter vin like xxsovd_id .
DEFINE input  parameter wolot like wo_Lot .
DEFINE output parameter cimError as logi .
DEFINE VARIABLE checknumber as char .
cimError = yes .
FOR EACH  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin and xxsovd_wolot <> wolot :
	cimError = no .
	/*����Ƿ�������
	checknumber = 1  ���߼�������
	checknumber = 2  ��װ��������
	checknumber = 3  ���(��Ʒ����Ʒ)��������
	checknumber = 4  �������(���Ʒ,����鶯��)��������
	*/

	checknumber = "4" .
	{gprun.i ""xxddcheckvinhist.p""
	"(input vin,
	  input xxsovd_wolot ,
	  input checknumber ,
	  output cimError)"}
 	if cimError = yes then do:		
		next .	/*�ѷ���*/
	end.
 	message "���ڷ���.. " + xxsovd_part + " " + xxsovd_id  .
	/* �������CIMLOAD
	{1} = ����ID
	{2} = �������
	{3} = �ص�
	{4} = ��λ
	{5} = ����
	{6} = �ο�
	{7} = ����
	*/
	{xxddautowois.i
	 wolot
	 """1"""
	 """10000"""
	 """W10"""
	 xxsovd_id1
	 """ """
	 xxsovd_part
	}
	/*����Ƿ���ɹ�*/
	find last tr_hist where tr_domain = global_domain
		and tr_type = "iss-wo"
		and tr_effdate = today 
		and tr_part = xxsovd_part
		and tr_nbr = xxsovd_wonbr
		and tr_lot = wolot
		and tr_serial = xxsovd_id1
		no-lock no-error.
	if avail tr_hist then do:
		unix silent value ( "rm "  + Trim(usection) + ".i").
		unix silent value ( "rm "  + Trim(usection) + ".o"). 
		message "���ڷ���.. " + xxsovd_part  + " " + xxsovd_id + " �ɹ�.".
		/*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
		checknumber = "4" .
		{gprun.i ""xxddupdatevinhist.p""
		 "(input vin,
		   input xxsovd_wolot ,
		   input tr_loc,
		   input checknumber ,
		   output cimError)"}
	end.
	else do: 
		message "���ڷ���.. " + xxsovd_part  + " " + xxsovd_id + " ʧ��.".
		message "����.. " + xxsovd_part  + " " + xxsovd_id + " ʧ��,��������ϵ����Ա!" view-as alert-box .
		cimError = yes .
	end.
end.
	