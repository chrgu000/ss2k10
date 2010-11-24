/*By: Neil Gao 09/03/05 ECO: *SS 20090305* */

{mfdtitle.i "090524.1"}

DEFINE new shared VARIABLE loginyn as logical .
view frame dtitle .
DEFINE VARIABLE vin like xxxh_id .
DEFINE VARIABLE vin1 like xxxh_id .
DEFINE VARIABLE lot like xxxh_id .
DEFINE VARIABLE lot1 like xxxh_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printonlyno as logi .
define variable usection as char format "x(16)". 
DEFINE VARIABLE v_xxxh_part as char .
define variable sonbr like so_nbr.
DEFINE   VARIABLE printyn	as logi .

/* SS 090531.1 - B */
/*
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
		DEFINE   VARIABLE barcode_vin_id	LIKE xxxh_id .	/*VIN码*/
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
*/
/* SS 090531.1 - E */
	FORM
		SKIP(1)  /*GUI*/
		sonbr             COLON 18
		vin		colon 18	label "包装条码起始号"
		vin1		colon 18	label "至"	skip (1)
		printonlyno	colon 18 label "只打未打印条码" 
		printyn		colon 18 label "确认打印"
		SKIP(1)  /*GUI*/
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.
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

	for each xxxh_det where xxxh_domain = global_domain and xxxh_nbr = sonbr
		and xxxh_id <> "" no-lock break by xxxh_id :
			if first( xxxh_id ) then do:
				assign vin = xxxh_id .
			end.
			i = i + 1 .
			if last ( xxxh_id ) then assign vin1 = xxxh_id .
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
		FOR EACH  xxxh_det where xxxh_domain = global_domain 
			and xxxh_nbr = sonbr and xxxh_id >= vin and xxxh_id <= vin1
			by xxxh_id:
			if printonlyno = yes and xxxh_prt_date <> ? then next .
						
					/*模板
^XA^FS ^LH20,20^FS^BY2,2,60^FS ^FO30,5 ^BCN,60,N,N,N^FDD0900006*00001
^FS^BY2,2,60^FS ^FO30,80 ^BCN,60,N,N,N^FD7409050000001
^FS^FO430,5 ^A0N,60,60^FD00001
^FS^FO430,75 ^A0N,30,30^FDD09060001
^FS^FO400,110 ^A0N,30,30^FD7409050000001
^FS^PQ2^FS^XZ
					*/
			put	unformat "^XA^FS ^LH20,20^FS^BY2,2,60^FS ^FO30,5 ^BCN,60,N,N,N^FD" + caps(xxxh_id) skip.
			put unformat "^FS^BY2,2,60^FS ^FO30,80 ^BCN,60,N,N,N^FD" + caps(xxxh_id1) skip.
			put unformat "^FS^FO430,5 ^A0N,60,60^FD" + substring(caps(xxxh_id),10) skip.
			put unformat "^FS^FO430,70 ^A0N,30,30^FD" + xxxh_nbr skip.
			put unformat "^FS^FO400,110 ^A0N,30,30^FD" + caps(xxxh_id1) skip.
			put unformat "^FS^PQ2^FS^XZ" skip.

			assign xxxh_prt = yes xxxh_prt_date = today .
			 
		END.
	end.
	{mfreset.i}	
	{mfgrptrm.i}
	
END.	/*{wbrp01.i} REPEAT*/

