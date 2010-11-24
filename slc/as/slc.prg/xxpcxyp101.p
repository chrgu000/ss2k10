/*By: Neil Gao 08/04/15 ECO: *SS 20080415* */
/*By: Neil Gao 08/07/14 ECO: *SS 20080714* */


{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site.
define var stdate as date label "日期".
define var date1 as date.
define var date2 as date.
define var part   like pt_part.
define var part1  like pt_part.
define var vend like po_vend.
define var vend1 like po_vend.
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define variable sw_reset     like mfc_logical. 
define var tmpqty like ld_qty_oh.
define var tmppick like ld_qty_oh.
define var tmpqty1 as int. /* 缺料种类 */
define var tmpqty2 like ld_qty_oh. /* 缺料数量 */
define var inpqty like ld_qty_oh.
define var update-yn as logical.
define var tothours as decimal format "->>>>>>>9.9<".
define var totqty   as decimal.
define var tmprmks as char.
define var ii as int.
define var duedate as date.
define var tdate1 as date.
define var tdate2 as date.
define var tvend  like po_vend.
define var xxnbr like xxpc_nbr.
define var tmpnbr like xxpc_nbr.
define var xxrmks as char format "x(60)".
define var xxrmks1 as char format "x(60)".
define var xxrmks2 as char format "x(60)".
define var xxrmks3 as char format "x(60)".
define var desc2 like pt_desc2.
define var stadesc as char format "x(30)".
define var stadesc1 as char format "x(80)".
define var isel as logical init yes.
define var xxi as int format ">>>9".
define buffer xxpcmstr for xxpc_mstr.

/*SS 20080714 - B*/
define var xxpcnbr like xxpc_nbr.
define var xxpcnbr1 like xxpc_nbr.
/*SS 20080714 - E*/

define temp-table tpc_det
	field tpc_sel as char format "x(1)"
	field tpc_nbr as char format "x(12)"
	field tpc_vend like po_vend
	field tpc_part like sod_part
	field tpc_desc as char format "x(20)"
	field tpc_date as date
	field tpc_price like pc_amt[1]
	field tpc_rmks as char
	index tpc_vend
				tpc_vend tpc_part.

form
   xxpcnbr colon 12	label "价格协议"
   xxpcnbr1 colon 45 label "至"
   vend    colon 12  	vend1  colon 45
   skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
	 tpc_sel  	column-label "选"  format "x(1)"
	 tpc_nbr    column-label "价格协议"
   tpc_vend 	column-label "供应商"
   tpc_part   column-label "物料号" 
   tpc_date 	column-label "生效日期"
   tpc_price  column-label "价格"
   tpc_rmks   column-label "备注"
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
	
form
 	xxi      label "序号"
 	tpc_part label "零件号" format "x(16)"
	vp_vend_part label "老件号" format "x(16)"
	pt_desc1 label "零件名称"	format "x(20)"
	pt_desc2 label "规格型号" format "x(12)"
	pt_um     label "UM"
	xxpc_mstr.xxpc_amt[2]	label "旧价格"
	xxpc_amt[1] label "新价格"
	xxrmks   label "备注" format "x(18)"
with frame e width 200 down no-attr-space.	
	
/* DISPLAY */
view frame a.

stdate = today.
site = "10000".

mainloop:
repeat with frame a:
   
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if part1  = hi_char then part1  = "".
   if vend1 = hi_char then vend1 = "".
   if xxpcnbr1 = hi_char then xxpcnbr1 = "".
   
   update
   	xxpcnbr
   	xxpcnbr1
   	vend vend1
   with frame a.
   
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
   if part1 = "" then part1 = hi_char.
	 if vend1 = "" then vend1 = hi_char.
	 if xxpcnbr1 = "" then xxpcnbr1 = hi_char.
	 
   
   {mfselprt.i "printer" 100}
   	
   {gprun.i ""xxrqpgyrp.p"" "(input xxpcnbr,input xxpcnbr1,input vend ,input vend1)"}
  	
   {mfreset.i}
	 {mfgrptrm.i}
		
   
end. /* repeat with frame a */

status input.

