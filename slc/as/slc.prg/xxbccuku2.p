/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/* SS - 090827.1 By: Neil Gao */
/* SS 090827.1 - B */
/*
���ӽ����ڽӿ�
*/
/* SS 090827.1 - E */

/* TODO
�п��ܴ�ӡ ������+���ܺ�VIN
*/	/*---Remark by davild 20081011.1*/

/* SS - 100428.1 By: Kaine Zhang */


/* SS - 100428.1 - RNB
[100428.1]
ȡ��'ֻslcqad2����'������.
[100428.1]
SS - 100428.1 - RNE */

{mfdtitle.i "100428.1"}

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
DEFINE VARIABLE sodnbr as char .
DEFINE VARIABLE sodline as inte .

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


DEFINE VARIABLE barcode_print_type		as char  .
DEFINE VARIABLE barcode_path		as char  .
DEFINE VARIABLE cust			LIKE so_cust .
DEFINE VARIABLE part			LIKE pt_part .
DEFINE VARIABLE tmp as char extent 16 .
DEFINE VARIABLE checknumber as char .
DEFINE VARIABLE cimError as logi .
DEFINE VARIABLE v_nbr  as char .
DEFINE VARIABLE v_line as char .
DEFINE VARIABLE v_qty_line like wo_qty_ord .
DEFINE VARIABLE msg as char format "x(60)" .
DEFINE VARIABLE pack_no	as char format "x(20)" .	
DEFINE VARIABLE chr_tot_qty	as char format "x(20)" .

	FORM
		"��ע:VIN�� ���� tr__Chr06 �ֶ���  " at 2
		"     Tr_vend_lot = BcPackNo: + װ�䵥��" at 2 skip(2)
		pack_no colon 8 label "װ�䵥"
		skip(2)
		msg at 1 no-label  
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space  THREE-D.
	/*setFrameLabels(frame a:handle).*/

{wbrp01.i}
lang = "US" .


/* SS - 100428.1 - B
/* SS 090828.1 - B */
/*
ֻ����slcqad2��¼ʹ��.
*/
define var dluser as char.
define stream sdluser.
input stream sdluser thru whoami.
import stream sdluser dluser.
input stream sdluser close.

if dluser <> "slcqad2" then do:
	message "ֻ����slcqad2ʹ��" dluser view-as alert-box.
	return.
end.
/* SS 090828.1 - E */
SS - 100428.1 - E */

REPEAT : 	
	/*---Add Begin by davild 20080620.1*/
	update pack_no  with frame a.
	i = 0 .
	for each xxvind_det where xxvind_domain = global_domain 
			and xxvind_zhuangxiang_NBR = pack_no
			and xxvind_zhuangxiang_date <> ?	/*��װ��*/
			and xxvind_cuku_date = ?			/*δ����*/
			no-lock:
		
		site = "10000" .
		loc  = pack_no /*װ�䵥��*/ .
		cimError = no .
		do transaction:
			
			{xxddautosois.i
				 xxvind_nbr
				 string(xxvind_line)
				 """1"""
				 """10000"""
				 """CJ01"""	
				 xxvind_lot
				 """ """
				}
     
			FIND LAST tr_hist WHERE tr_domain = global_domain 				
				AND tr_type = "ISS-SO" 
				and tr_effdate = today 
				and tr_part = xxvind_part 
				AND tr_nbr = xxvind_nbr
				AND tr_loc = "CJ01" AND (tr_qty_chg) = -1
				and tr_serial = xxvind_lot		/*����*/
				and trim(tr_vend_lot) = ""	/*---Add by davild 20081011.1*/
				NO-ERROR.
			IF not AVAIL tr_hist THEN do:
				msg = "VIN��:" + xxvind_id + "û�г���ɹ�".
				display msg with frame a .
				undo,next .
			end. 
			/*---Add by davild 20080107.1*/
			else do:
				unix silent value ( "rm -f "  + Trim(usection) + ".i").
				unix silent value ( "rm -f "  + Trim(usection) + ".o"). 			
				message "VIN�� " + string(vin) + " װ��ɹ�." .
				assign tr_vend_Lot = "BcPackNo:" + pack_no .
				assign tr__chr06 = xxvind_id .		/*VIN ��*/
				
				/*�Զ�������ʷ��¼xxvind_det�ͻ��ܼ�¼xxvin_mstr*/
				/*����Ƿ�������
					checknumber = 1=����
					checknumber = 2=����
					checknumber = 3=���
					checknumber = 4=��װ
					checknumber = 5=װ��
					checknumber = 6=װ��	loc ��ʱҪΪ װ�䵥��
					checknumber = 7=����
				*/
				checknumber = "7" .
				/*����װ��� xxspld_det--BEGIN*/
				pause 0 .
				{gprun.i ""xxddupdatexxspld.p""
				"(input checknumber,
				  input site,
				  input pack_no,
				  input xxvind_nbr,
				  input xxvind_line)"}
				/*����װ��� xxspld_det--end*/
				pause 0 .
				{gprun.i ""xxddupdatevinhist.p""
				 "(input xxvind_id,
				   input motorvin , 
				   input xxvind_wolot ,
				   input loc,
				   input checknumber ,
				   output cimError)"}
				if cimError then undo,next .
/* SS 090827.1 - B */
				find first so_mstr where so_domain = global_domain and so_nbr = xxvind_nbr no-lock no-error.
				if avail so_mstr then do:
					find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust and cm_type = "S3" no-lock no-error.
					if avail cm_mstr then do:
						{gprun.i ""xxbccku2a.p""
							"(input xxvind_id,
								input motorvin ,
								output cimError)" }
						if cimError then undo,next.
					end.
				end. /* if avail so_mstr */
/* SS 090827.1 - E */	
				i = i + 1 .			
			end.
		end.	/*do transaction*/
	end.	/*for each xxvind_det*/
	msg = "�ܳ��� " + string(i) + " ��" .
	display msg with frame a .
END.	/*{wbrp01.i} REPEAT*/

{wbrp04.i &frame-spec = a}
