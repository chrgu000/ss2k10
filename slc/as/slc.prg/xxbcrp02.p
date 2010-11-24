/*By: Neil Gao 09/03/05 ECO: *SS 20090305* */

{mfdtitle.i "090402.1"}

DEFINE new shared VARIABLE loginyn as logical .
view frame dtitle .
DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE vin1 like xxsovd_id .
DEFINE VARIABLE lot like xxsovd_id .
DEFINE VARIABLE lot1 like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printonlyno as logi .
define variable usection as char format "x(16)". 
DEFINE VARIABLE v_xxsovd_part as char .
define variable sonbr like so_nbr.
/*---Add Begin by davild 20080421.1*/
		/*条码程序通用共享变量--BEGIN*/

		DEFINE   VARIABLE barcode_part		LIKE wo_part .
		DEFINE   VARIABLE barcode_domain	LIKE wo_domain .
		DEFINE   VARIABLE barcode_cust		LIKE so_cust .
		DEFINE   VARIABLE barcode_wo_nbr	LIKE wo_nbr .
		DEFINE   VARIABLE barcode_wo_lot	LIKE wo_lot .
		DEFINE   VARIABLE barcode_sod_nbr	LIKE sod_nbr .
		DEFINE   VARIABLE barcode_sod_line	LIKE sod_line .
		DEFINE   VARIABLE barcode_sod_part	LIKE sod_part .
		DEFINE   VARIABLE barcode_so_nbr	LIKE so_nbr .
		DEFINE   VARIABLE barcode_site		LIKE wo_site .
		DEFINE   VARIABLE barcode_wo_vend	LIKE wo_vend .
		DEFINE   VARIABLE barcode_vin_id	LIKE xxsovd_id .	/*VIN码*/
		DEFINE   VARIABLE barcode_lang		LIKE lng_lang .
		DEFINE   VARIABLE barcode_print_type		as char  .

		DEFINE   VARIABLE cust			LIKE so_cust .
		DEFINE   VARIABLE lang			LIKE lng_lang .
		DEFINE   VARIABLE part			LIKE pt_part .
		DEFINE   VARIABLE k			as inte .
		DEFINE   VARIABLE tmp_yesno		as logi .
		DEFINE   VARIABLE labelmodel		as char label "模板号" .
		/*条码程序通用共享变量--END*/

		/*报表条件变量--BEGIN*/
		DEFINE   VARIABLE printyn	as logi .
		/*报表条件变量--BEGIN*/

		/*临时变量--BEGIN*/
		DEFINE   VARIABLE tmp_char	as char .
		DEFINE   VARIABLE tmp_char01	as char .
		DEFINE   VARIABLE tmp_so_nbr	as char .
		DEFINE   VARIABLE tmp_char02	as char .
		DEFINE   VARIABLE tmp_char03	as char .
		DEFINE   VARIABLE tmp_char04	as char .
		DEFINE   VARIABLE tmp_char05	as char .
		DEFINE   VARIABLE tmp_char_array	as char extent 5 .
		/*临时变量--END*/
		DEFINE VARIABLE barcode_vin_default as char .
/*---Add End   by davild 20080421.1*/

	FORM
		SKIP(1)  /*GUI*/
		sonbr             COLON 18
		vin		colon 18	label "VIN起始号"
		vin1		colon 18	label "至"	skip (.6)
		printonlyno	colon 18 label "只打未打印的VIN号" 
		printyn		colon 18 label "确认打印"
		SKIP(1)  /*GUI*/
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space  THREE-D.
	setFrameLabels(frame a:handle).



{wbrp01.i}

REPEAT :
hide all no-pause .
view frame dtitle .
view frame a .

		UPDATE
			sonbr 
		WITH FRAME a.

		i = 0 .
		assign
		vin = "" 
		vin1 = "" .

		for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = sonbr
			and xxsovd_id <> "" no-lock break by substring(xxsovd_id,12):
				if first( substring(xxsovd_id,12) ) then do:
					assign vin = xxsovd_id .
				end.
				i = i + 1 .
				if last ( substring(xxsovd_id,12) ) then assign vin1 = xxsovd_id .
		end.
		if i = 0 then do:
			message "错误: 此订单未生成VIN码!" view-as alert-box .
			undo,retry .
		end.
		disp vin vin1 with frame a.

		update vin vin1 printonlyno with frame a .

		update printyn with frame a .
		{xxmfselprt.i "vinprint" 132}
		if printyn = yes then do:

			FOR EACH  xxsovd_det where xxsovd_domain = global_domain 
				and xxsovd_nbr = sonbr
				by substring(xxsovd_id,12):
				if printonlyno = yes and xxsovd_prt_date <> ? then next .
				
				tmp_so_nbr = xxsovd_nbr + "-" + string(xxsovd_line).	/*---Add by davild 20080102.1*/
					
					/*模板
					^XA^FS ^LH40,20^FS^BY1,3,55^FS ^FO30,5 ^BCN,55,N,N,N^FDD0900006*00001
					^FS^BY1,3,55^FS ^FO30,100 ^BCN,55,N,N,N^FD7409050000001
					^FS^FO400,20 ^A0N,60,60^FD00001
					^FS^FO400,100 ^A0N,30,30^FD7409050000001
					^FS^PQ1^FS^XZ
					说明：两处的LLCLS4RLX8F123456为需打印的字符串
						  第一行为条码打印
						  第二行为条码下放对应字符的打印
					*/
					put unformatted 
					"^XA^FS ^LH40,30^FS^BY2,2,85^FS ^FO30,5 ^BCN,85,N,N,N^FD"
					+ caps(xxsovd_id) at 1 skip .
					put unformatted 
					"^FS^FO40,100 ^A0N,40,50^FD" + caps(xxsovd_id) + "^FS^PQ1^FS^XZ"
					at 1 skip .			
				assign xxsovd_print = yes xxsovd_prt_date = today .
				 
			END.
		end.
		{mfreset.i}	
		{mfgrptrm.i}
END.	/*{wbrp01.i} REPEAT*/

{wbrp04.i &frame-spec = a}
