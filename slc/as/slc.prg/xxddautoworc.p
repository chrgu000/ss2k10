/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*�Զ�������*/
{mfdtitle.i "SS"}

pause 0 .
DEFINE input  parameter vin like xxsovd_id .
DEFINE input  parameter site as char  .
DEFINE input  parameter loc  as char  .
DEFINE output parameter cimError as logi .
DEFINE VARIABLE checknumber as char .
cimError = yes .
FOR EACH  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin :
	message "�������.. " + xxsovd_id .
	/* �������CIMLOAD
	{1} = ����ID
	{2} = �������
	{3} = �ص�
	{4} = ��λ
	{5} = ����
	{6} = �ο�
	*/
	{xxddautoworc.i
	 xxsovd_wolot
	 """1"""
	 site
	 loc
	 xxsovd_id1
	 """ """
	}
	/*����Ƿ���ɹ�*/
	find last tr_hist where tr_domain = global_domain
		and tr_type = "rct-wo"
		and tr_effdate = today 
		and tr_part = xxsovd_part
		and tr_nbr = xxsovd_wonbr
		and tr_lot = xxsovd_wolot
		and tr_serial = xxsovd_id1
		and tr_vend_lot = "" 
		and tr_program begins "xxbc"
		no-error.
	if avail tr_hist then do:
		cimError = no .
		assign tr_vend_lot = vin .		/*---Add by davild 20081011.1*/
		unix silent value ( "rm -f "  + Trim(usection) + ".i").
		unix silent value ( "rm -f "  + Trim(usection) + ".o"). 		
	end.
	else do: 
		cimError = yes .
	end.
end.
	