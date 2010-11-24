/*By: Neil Gao 08/12/03 ECO: *SS 20081203* */

{mfdtitle.i "n1"}

 DEFINE new shared VARIABLE loginyn as logical .

view frame dtitle .
 /*Definition*/
DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE motorVin like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printyn as logi .
DEFINE VARIABLE updatexxsovd_det_ok as logi .
DEFINE VARIABLE wolot as char .
DEFINE VARIABLE loc as char init "".

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
		vin     COLON 18 label "VIN��"		skip(1)
		motorVin	colon 18 label "��������"
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
				assign v_qty_line = xxvin_qty_up .
				display v_qty_line with frame a .
			end.
		end.

		UPDATE
			vin 
		WITH FRAME a.

		assign updatexxsovd_det_ok = no .
		find first  xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-error.
		if avail xxsovd_det then do:			
			wolot = xxsovd_wolot .
			find first xxvind_det where xxvind_domain = global_domain 
				and xxvind_id = xxsovd_id no-lock no-error.
			if not avail xxvind_det then do:
				message "VIN��δ��ӡ,���������ߴ���,����ϵ��ӡ��Ա��34.5.2��ȥ��ӡ!" view-as alert-box .
				next .
			end.
			/*---Add Begin by davild 20081117.1*/
			/*������ʾ1.12 ǰ4�� LLCLSD1009F000001 */
				
				find first cd_det where cd_domain = global_domain
					and cd_ref = xxsovd_part   /*�Ӽ�״̬*/
					and cd_type = "SC"
					and cd_lang = "CH"
					and cd_seq  = 0
					no-lock no-error.
				if avail cd_det then do:
					display 
						cd_cmmt[1] no-label
						cd_cmmt[2] no-label
						cd_cmmt[3] no-label
						cd_cmmt[4] no-label
						with frame Fdesc row 15 overlay.
				end.
				else display "�Ϻ�:" + xxsovd_part + " δά��1.12" @ cd_cmmt[1] with frame Fdesc .
			/*---Add End   by davild 20081117.1*/
			checknumber = "1" .
			{gprun.i ""xxddcheckvinhist.p""
			"(input vin,
			  input xxsovd_wolot ,
			  input checknumber ,
			  output cimError)"}
			if not cimError then do:
				message "VIN�� " + vin + " ��û��������" view-as alert-box .
				next .
			end.
			

			update motorvin with frame a.
			{gprun.i ""xxddcheckmotorvin.p""
			"(input motorvin,
			output cimError)"}
			if cimError then do:
				message "�������� " + motorvin + " �Ѿ�������." view-as alert-box .
				next .
			end.

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
			checknumber = "1" .
			{gprun.i ""xxddupdatevinhist.p""
			 "(input vin,
			   input motorvin , 
			   input xxsovd_wolot ,
			   input loc,
			   input checknumber ,
			   output cimError)"}	
			message "VIN�� " + vin + "�󶨳ɹ�." .
		end.
		else do:
			message "VIN�벻����!" view-as alert-box .
		end.
	end.
	leave .
END.

{wbrp04.i &frame-spec = a}
