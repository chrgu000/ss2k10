/*By: Neil Gao 08/09/05 ECO: *SS 20080905* */
/*By: Neil Gao 08/11/17 ECO: *SS 20081117* */
/*By: Neil Gao 09/02/04 ECO: *SS 20090204* */
/*By: Neil Gao 09/02/24 ECO: *SS 20090224* */

{mfdtitle.i "n2"}

define var trlot like tr_lot.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var xxqty   like tr_qty_loc.
define var xxqty1	 like tr_qty_loc.
define var xxqty2  like tr_qty_loc.
define var xxqty3  like tr_qty_loc.
define var xxqty4  like tr_qty_loc.
define var xxloc1  like tr_loc.
define var xxloc2	 like tr_loc.
define var xxloc3  like tr_loc.
define var xxloc4  like tr_loc.
define var xxreas1 like prh_reason.
define var xxreas2 like prh_reason.
define var xxreas3 like prh_reason.
define var xxreas4 like prh_reason.
define var xxrecid as recid.
define var effdate like tr_effdate init today.
define var vendname as char format "x(20)".
define var xxrt as logical.
define var xxtype as char.

define var undo-input as logical no-undo.

/* DISPLAY SELECTION FORM */
form
   trlot		      colon 15 label "收料单"
   tr_nbr					colon 35
   tr_part				colon 15 label "零件号"
   desc1					colon 35 no-label
   desc2					colon 35 no-label
   tr_qty_loc			colon 15 label "货运数量"
   tr_loc					colon 35
   tr_serial			colon 55 label "批/序"
   effdate        colon 15 label "生效日期"
   tr_ref					colon 35 label "参考号"
   vendname       colon 55 label "供应商名称"
   xxqty					colon 15 label "抽验数量"
   xxtype 				colon 55 label "类型"
   xxqty1					colon 15 label "总不合格数量"
   /*xxreas1				colon 55 label "原因码"*/
/*SS 20081117 - B*/
		xxrt					colon 55 label "全部退货"
/*SS 20081117 - E*/   
   xxqty2					colon 15 label "不合格数量1"
   xxreas2				colon 55 label "原因码"
   xxqty3					colon 15 label "不合格数量2"
   xxreas3				colon 55 label "原因码"
   xxqty4					colon 15 label "不合格数量3"
   xxreas4				colon 55 label "原因码"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

view frame a.
repeat with frame a:
	
	 clear frame a all no-pause.
   prompt-for trlot
   editing:
   	
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i tr_hist tr_type "tr_domain = global_domain and
      tr_type = 'rct-po' and tr_vend_lot = '' and tr__dec02 = 0"  tr_lot
      "input trlot"
       }

      if recno <> ? then
		  do:
         find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
         find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
         display 	tr_lot @ trlot
         					tr_nbr
         					tr_part
         					tr_loc 
         					tr_qty_loc tr_serial tr_ref
         					vd_sort  when ( avail vd_mstr ) @ vendname
         					pt_desc1 when ( avail pt_mstr ) @ desc1 
         					pt_desc2 when ( avail pt_mstr ) @ desc2  .
      end.
   end.
   
   if avail tr_hist then xxrecid = recid(tr_hist).
   
   if not avail tr_hist or ( avail tr_hist and tr_lot <> input trlot ) then do:
			find first prh_hist use-index prh_receiver where prh_domain = global_domain and prh_receiver = input trlot no-lock no-error.
			if avail prh_hist then 
			find first tr_hist use-index tr_part_eff where tr_domain = global_domain and tr_type = 'rct-po' and tr_lot = input trlot 
				/*and tr_vend_lot = "" and tr__dec02 = 0*/ and prh_rcp_date = tr_effdate and prh_part = tr_part no-lock no-error.
		end.
   
   if not avail tr_hist then do:
   		message "收料单不存在或已结".
   		undo,retry.
   end.
   find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
   if not avail pt_mstr then do:
   		message "零件不存在".
   		undo,retry.
   end.

   if avail tr_hist then xxrecid = recid(tr_hist).
   find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
   
   display tr_lot @ trlot
      		 tr_nbr
     			 tr_part
     			 tr_loc 
     			 tr_qty_loc tr_serial tr_ref
     			 vd_sort  when ( avail vd_mstr ) @ vendname 
     			 pt_desc1 @ desc1 
     			 pt_desc2 @ desc2.
   
   assign xxqty   = 0
   				xxqty1  = 0
   				xxreas1 = ""
   				xxqty2	= 0
   				xxloc2  = ""
   				xxreas2	= ""	
   				xxqty3	= 0			
   				xxloc3  = ""
   				xxreas3	= ""		
   				xxqty4	= 0			
   				xxloc4  = ""
   				xxreas4 = "" .
   if  tr__dec02 <> 0 then do:
   			message "修改记录". 
   			pause.
   			xxqty         =	tr__dec02  .
      	xxqty1        =	tr__dec03  .
      	xxqty2        =	tr__dec04  .
      	xxqty3        =	tr__dec05  .
      	xxqty4				=	int(tr__chr12). 
      	xxreas1       =	tr__chr03  .
      	xxreas2       =	tr__chr04  .
      	xxreas3       =	tr__chr05  .
      	xxreas4       =	tr__chr06  .
      	xxtype 				= tr__chr10  .
   end.
   
   do transaction on error undo, retry:
   		update effdate
   				xxqty
   				xxtype
   				xxqty1
   				/*xxreas1*/
   				xxrt
   				xxqty2	
   				xxreas2			
   				xxqty3				
   				xxreas3			
   				xxqty4				
   				xxreas4
   				with frame a .
   				
   		if effdate = ? then effdate = today.
   		if xxqty > tr_qty_loc then do:
   			message "抽验数量不能大于收货数量".
   			undo,retry.
   		end.
   		
   		if xxqty1 > tr_qty_loc then do:
   			message "不合格数量大于收货数量".
   			undo,retry.
   		end.
   		
   		if xxqty2 + xxqty3 + xxqty4 < xxqty1 then do:
   			message "总不合格数量大于各项之和".
   			undo,retry.
   		end.
   		
   		
   end. /*do on error undo,retry */
		
			/*记录转仓数量 */	
			do transaction on error undo, retry:
		  	for first tr_hist where recid(tr_hist) = xxrecid :
      		tr__dec02 = xxqty.
      		tr__dec03 = xxqty1.
      		tr__dec04 = xxqty2.
      		tr__dec05 = xxqty3.
      		tr__chr03 = xxreas1.
      		tr__chr04 = xxreas2.
      		tr__chr05 = xxreas3.
      		tr__chr06 = xxreas4.
      		tr__chr08 = global_userid.
      		tr__chr10 = xxtype.
      		tr__chr11 = string(time).
      		tr__chr12 = string(xxqty4).
      		tr__dte04 = today.
      		
      		tr_vend_lot = tr_lot.
      		message "执行成功".
      		hide frame a no-pause.
      	end.
			end.
		
end. /* repeat */