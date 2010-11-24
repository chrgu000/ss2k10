/* SS - 090531.1 By: Neil Gao */

{mfdtitle.i "090531.1"}

DEFINE new shared VARIABLE loginyn as logical .

view frame dtitle .

DEFINE VARIABLE vin like xxsovd_id .
DEFINE VARIABLE motorVin like xxsovd_id .
DEFINE VARIABLE qty as inte .
DEFINE VARIABLE i as inte .
DEFINE VARIABLE printyn as logi .
DEFINE VARIABLE updatexxsovd_det_ok as logi .
DEFINE VARIABLE wolot as char .
DEFINE VARIABLE site as char .
DEFINE VARIABLE loc as char .
DEFINE VARIABLE sonbr as char .
DEFINE VARIABLE sodline as inte .
define var xh as char format "x(18)".

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
DEFINE  new shared VARIABLE barcode_vin_id	LIKE xxsovd_id .	/*VIN码*/
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
DEFINE VARIABLE huoyundan_no	as char format "x(20)" .	
DEFINE VARIABLE pack_no	as char format "x(20)" .	
DEFINE VARIABLE tot_qty	as int.

define variable usection as char format "x(16)". 

	FORM
		sonbr		 colon 15 label "订 单"
		skip(1)
		vin			 colon 15 label "VIN码"
		skip(1)
		xh				colon 15 label "箱 号"
		msg at 1 no-label  
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.
	/*setFrameLabels(frame a:handle).*/


{wbrp01.i}
lang = "US" .
vin = "" .

mainloop:
REPEAT : 	
	
	update 
		vin
	with frame a.
	
	find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin no-lock no-error.
	if not avail xxvind_det  then do: 
		msg = "错误:VIN码不存在".
		display msg with frame a .
		next .		
	end.
	sonbr = xxvind_nbr.
	disp sonbr with frame a.
	xh = xxvind_chr02.
	if xh <>  "" then do:
		msg = "警告: 已经绑定箱号" + xh.
		disp msg with frame a.
		pause.
	end.
	loop1:
	DO on error undo,retry:
		
		update xh with frame a.
		
		find first xxxh_det where xxxh_domain = global_domain and xxxh_id = xh no-lock no-error.
		if not avail xxxh_det then do:
			msg = "错误: 箱号不存在" + xh.
			disp msg with frame a.
			undo,retry.
		end.
		
		find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin no-error.
		if avail xxvind_det then do:
			xxvind_chr02 = xh.
		end.
		
		msg = "成功!".
		disp msg with frame a.

	end. /* loop1 */
	
END.	/*{wbrp01.i} REPEAT*/

{wbrp04.i &frame-spec = a}
