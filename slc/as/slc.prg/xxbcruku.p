/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/* TODO
�п��ܴ�ӡ ������+���ܺ�VIN
*/	/*---Remark by davild 20081011.1*/
{mfdtitle.i "SS"}

/*---Add Begin by davild 20071228.1*/
DEFINE new shared VARIABLE loginyn as logical .
view frame dtitle .
/*---Add End   by davild 20071228.1*/


/*Definition*/
DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE motorVin like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printyn as logi .
DEFINE VARIABLE updatexxsovd_det_ok as logi .
DEFINE VARIABLE wolot as char .
DEFINE VARIABLE site as char .
DEFINE VARIABLE loc as char .

DEFINE  new shared VARIABLE lang			LIKE lng_lang .
DEFINE  new shared VARIABLE barcode_domain	LIKE wo_domain .
DEFINE  new shared VARIABLE barcode_part		LIKE wo_part .
DEFINE  new shared VARIABLE barcode_cust		LIKE so_cust .
DEFINE  new shared VARIABLE barcode_wo_nbr	LIKE wo_nbr .
DEFINE  new shared VARIABLE barcode_wo_lot	LIKE wo_lot .
DEFINE  new shared VARIABLE barcode_sod_nbr	LIKE sod_nbr .
DEFINE  new shared VARIABLE barcode_sod_line	LIKE sod_line .
DEFINE  new shared VARIABLE barcode_sod_ord_date	LIKE so_ord_date .
DEFINE  new shared VARIABLE barcode_site		LIKE wo_site .
DEFINE  new shared VARIABLE barcode_wo_vend	LIKE wo_vend .
DEFINE  new shared VARIABLE barcode_vin_id	LIKE xxsovd_id .	/*VIN��*/
DEFINE  new shared VARIABLE barcode_lang		LIKE lng_lang .
DEFINE  new shared VARIABLE barcode_end		as char format "x(30)" .


DEFINE   VARIABLE barcode_print_type		as char  .
DEFINE   VARIABLE barcode_path		as char  .
DEFINE   VARIABLE cust			LIKE so_cust .
DEFINE   VARIABLE part			LIKE pt_part .
DEFINE VARIABLE tmp as char extent 16 .
/*---Add Begin by davild 20080107.1*/
DEFINE VARIABLE checknumber as char .
DEFINE VARIABLE cimError as logi .
DEFINE VARIABLE v_nbr  as char .
DEFINE VARIABLE v_line as char .
DEFINE VARIABLE v_qty_line like wo_qty_ord .
/*---Add End   by davild 20080107.1*/
define variable usection as char format "x(16)". 

	FORM
		SKIP(1)  /*GUI*/
		wolot	colon 18 label "����ID"     wo_nbr colon 49 label "�ƻ���"
		wo_part colon 18 label "��  Ʒ"     wo_qty_ord label "�ɹ�����" colon 49
		so_cust colon 18 label "��  ��"     v_qty_line label "��������" colon 49
		skip(1)
		motorVin	colon 18 label "��������"
		vin     COLON 18 label "VIN��"
		SKIP(1)  /*GUI*/
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space  THREE-D.
	/*setFrameLabels(frame a:handle).*/


{wbrp01.i}
lang = "US" .

REPEAT : 	
	vin = "" .
 	repeat:
		find first wo_mstr where wo_domain = global_domain and wo_lot = wolot  no-lock no-error.
		if avail wo_mstr then do:
			find first so_mstr where so_domain = global_domain and so_nbr = substring(wo_nbr,1,8) no-lock no-error.
			display wo_nbr 
				wo_part	
				wo_qty_ord
				so_cust 
				wolot				
				with frame a .
			find first xxvin_mstr where xxvin_domain	= global_domain
					 and xxvin_wolot	= wolot
					 and xxvin_part	= wo_part 
					 no-lock no-error.
			if avail xxvin_mstr then do:
				assign v_qty_line = xxvin_qty_ruku .
				display v_qty_line with frame a .
			end.
		end.

		UPDATE
			vin 
		WITH FRAME a.

		find first  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-error.
		if avail xxsovd_det then do:			
			wolot = xxsovd_wolot .
			find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin 
				and xxvind_down_date <> ? no-lock no-error.
			if not avail xxvind_det  then do:
				message "δ������ɨ��,��������⴦��!" view-as alert-box .
				next .
			end.
			checknumber = "5" .
			{gprun.i ""xxddcheckvinhist.p""
			"(input vin,
			  input xxsovd_wolot ,
			  input checknumber ,
			  output cimError)"}
			if cimError then do:
				message "VIN�� " + vin + " �Ѿ������,����Ҫ�ٴ����." view-as alert-box .
				next .
			end.
			/*����Ʒ����飬��������*/
			site = "10000" .
			loc  = "CJ01" .
			cimError = yes .
			do transaction:
				{gprun.i ""xxddautoworc.p""
				"(input vin,
				  input site,
				  input loc,
				  output cimError)"}
				if cimError = no then do:
					
					/*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
					/*����Ƿ�������
						checknumber = 1=����
						checknumber = 2=����
						checknumber = 3=���
						checknumber = 4=��װ
						checknumber = 5=���
						checknumber = 6=װ��	loc ��ʱҪΪ װ�䵥��
						checknumber = 7=����
					*/
					checknumber = "5" .
					{gprun.i ""xxddupdatevinhist.p""
					 "(input vin,
					   input motorvin , 
					   input xxsovd_wolot ,
					   input loc,
					   input checknumber ,
					   output cimError)"}
					   message "VIN�� " + string(vin) + " ���ɹ�." .
					 if cimError then undo,next .
				end.
				else do:
					message "��⶯��ʧ�ܣ�����ϵ����Ա." view-as alert-box .
					undo,next .
				end.
			end.	/*do transaction*/
		end.
		else do:
			message "VIN�벻����!" view-as alert-box .
		end.
	end.
	leave .
	/*{mfreset.i}
	{mfgrptrm.i}*/
END.	/*{wbrp01.i} REPEAT*/

{wbrp04.i &frame-spec = a}
