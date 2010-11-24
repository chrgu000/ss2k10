/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/* Creation: eB21SP3 Chui Last Modified: 20080112 By: Davild Xu *ss-20080112.1*/
/*---Add Begin by davild 20080611.1*/
/*By: Neil Gao 08/12/02 ECO: *SS 20081202* */


/*
20080611程序准备OK，= TJ左强看新得利改好否.
新得利需要在小条码下
增加变量10 ，打刻样式
和变量3 ，ID + 数量

增加第10个打印变量Model打刻样式 .
*/
/*---Add End   by davild 20080611.1*/
/*检查是否入SO里的，是单机动力或者机组动力对应 的机组才给打印!-20080112-begin*/
/*
VIN码打印
*/
{mfdtitle.i "n1"}
/*---Add Begin by davild 20071228.1*/
DEFINE new shared VARIABLE loginyn as logical .
/*SS 20081202 - B*/
/*
{gprun.i ""xxbclogi.p""}
{xxbcusermanage.i}
*/
/*SS 20081202 - E*/
view frame dtitle .
/*---Add End   by davild 20071228.1*/
/*Definition*/
DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE vin1 like xxsovd_id .
DEFINE VARIABLE lot like xxsovd_id .
DEFINE VARIABLE lot1 like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printonlyno as logi .
define variable usection as char format "x(16)". 
DEFINE VARIABLE v_xxsovd_part as char .
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
		lot             COLON 18
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
			lot 
		WITH FRAME a.

		/*检查是否入SO里的，是单机动力或者机组动力对应 的机组才给打印!-20080112-begin*/

		find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_wolot = lot no-lock no-error.
		if avail xxsovd_det then do:
			find first wo_mstr where wo_domain = global_domain and wo_nbr = xxsovd_wonbr
				and wo_part <> xxsovd_part no-lock no-error.
				v_xxsovd_part = if avail wo_mstr then wo_part else xxsovd_part .
			find first sod_det where sod_domain = global_domain and sod_nbr = xxsovd_nbr
				and sod_line = xxsovd_line 
				no-lock no-error .
			if avail sod_det then do:
				if  sod_part <> v_xxsovd_part then do:
					message "成品 " + xxsovd_part + " 不能打印VIN码!" skip
						"对应的半成品(动力)是 " + v_xxsovd_part 
						view-as alert-box .
					next .
				end.
			end.
		end.
		/*检查是否入SO里的，是单机动力或者机组动力对应 的机组才给打印!-20080112-begin*/

		i = 0 .
		assign
		vin = "" 
		vin1 = "" .

		for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_wolot = lot 
			and xxsovd_id <> "" no-lock break by substring(xxsovd_id,12):
				if first( substring(xxsovd_id,12) ) then do:
					assign vin = xxsovd_id .
				end.
				i = i + 1 .
				if last ( substring(xxsovd_id,12) ) then assign vin1 = xxsovd_id .
		end.
		if i = 0 then do:
			message "此工单ID未生成VIN码!" view-as alert-box .
			undo,retry .
		end.
		disp vin vin1 with frame a.

		update vin vin1 printonlyno with frame a .

		update printyn with frame a .
		{xxmfselprt.i "vinprint" 132}	/*---Add by davild 20080107.1*/
		if printyn = yes then do:

			FOR EACH  xxsovd_det where xxsovd_domain = global_domain 
				/*and xxsovd_id >= vin 
				and xxsovd_id <= vin1		*/
				and xxsovd_wolot = lot
				 
				by substring(xxsovd_id,12):
				if printonlyno = yes and xxsovd_prt_date <> ? then next .
				
				tmp_so_nbr = xxsovd_nbr + "-" + string(xxsovd_line).	/*---Add by davild 20080102.1*/
					
					/*模板
					^XA^FS ^LH40,30^FS^BY2,2,85^FS ^FO30,5 ^BCN,85,N,N,N^FDLLCLS4RLX8F123456
					^FS^FO40,100 ^A0N,40,50^FDLLCLS4RLX8F123456^FS^PQ1^FS^XZ
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
				assign xxsovd_print = yes xxsovd_prt_date = today .	/*---Add by davild 20080421.1*/
				/*新增或者修改最后打印VIN时间xxvind_det and xxvin_mstr */
				{gprun.i ""xxddcreatevinhist.p""
				 "(input xxsovd_id)"}
				 /*---Add End   by davild 20080107.1*/
			END.
		end.
		{mfreset.i}	
		{mfgrptrm.i}
END.	/*{wbrp01.i} REPEAT*/

{wbrp04.i &frame-spec = a}

/*---Add Begin by davild 20080421.1*/
PROCEDURE getstring:
		define input  parameter iptstring as char.
		define input  parameter iptlength as int.
		define output parameter optstring as char.
		define output parameter xxk as int.	/*---Add by davild 20071220.1*/
		define var xxs as char.
		define var xxss as char.
		define var xxi as int.
		define var xxj as int.
		
		optstring = "".
		xxss = "".
		xxi = 1.
		
		if iptlength < 2 then return.
		
		repeat while xxi <= length(iptstring,"RAW") :
			xxs = substring(iptstring,xxi,1).
			if length( xxss + xxs , "RAW") > iptlength then do:
				optstring = optstring + xxss + "^".
				xxss = "".
				next.
			end.
			xxi = xxi + 1.
			xxss = xxss + xxs.
		end.
		optstring = optstring + xxss.

		/*---Add Begin by davild 20071220.1*/
		xxk = 1 .
		do xxj = 1 to length(optstring):
			if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1 .
		end.
		/*---Add End   by davild 20071220.1*/

END PROCEDURE.
/*---Add End   by davild 20080421.1*/