/*By: Neil Gao 08/04/15 ECO: *SS 20080415* */
/* SS - 090409.1 By: Neil Gao */

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site.
define var stdate as date label "日期".
define var xxpcnbr like xxpc_nbr.
define var xxpcnbr1 like xxpc_nbr.
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
define var irest as logical.
define buffer xxpcmstr for xxpc_mstr.

define temp-table tpc_det
	field tpc_sel as char format "x(1)"
	field tpc_nbr as char format "x(12)"
	field tpc_vend like po_vend
	field tpc_part like sod_part
	field tpc_desc as char format "x(20)"
	field tpc_date as date
	field tpc_price like pc_amt[1]
	field tpc_rmks as char format "x(8)"
	index tpc_vend
				tpc_vend tpc_part.

form
   xxpcnbr colon 12   label "价格协议"
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
	pt_desc1 label "零件名称" format "x(20)"
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
xxrmks  = "1.此价格协议价格为含税价".
xxrmks1 = "2.协议自双方签字(盖章)之日起执行".

mainloop:
repeat with frame a:
   
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if part1  = hi_char then part1  = "".
   if vend1 = hi_char then vend1 = "".
   
   update 
   	xxpcnbr xxpcnbr1
   	vend vend1
   with frame a.
   
   if xxpcnbr1 = "" then xxpcnbr1 = hi_char.
	 if vend1 = "" then vend1 = hi_char.
	 
	 empty temp-table tpc_det.
	 
	 for each xxpc_mstr use-index xxpc_nbr where xxpc_domain = global_domain 
	 		and xxpc_nbr >= xxpcnbr and xxpc_nbr <= xxpcnbr1 and xxpc_approve_userid = ""
	 		and xxpc_list >= vend and xxpc_list <= vend1 no-lock ,
    	each pt_mstr where pt_domain = global_domain and pt_part = xxpc_part no-lock 
    	break by xxpc_list by xxpc_part by xxpc_start:
	 		
	 		if last-of( xxpc_part) then do:	
	 			create 	tpc_det.
	 			assign tpc_sel = "*"
	 						 tpc_nbr = xxpc_nbr	
	 						tpc_vend = xxpc_list
	 						tpc_part = xxpc_part
	 						tpc_desc = pt_desc1
	 						tpc_date = xxpc_start
	 						tpc_price  = xxpc_amt[1].
	 			if isel then tpc_sel = "*".
	 		end.
	 		
	 end.
	 find first tpc_det no-lock no-error.
	 if not avail tpc_det then do:
		 message "无记录存在".
		 next.
		end.
	 
   view frame d.
   pause 0.
   sw_reset = yes.
   scroll_loop:
   repeat with frame d:
	 	 
	   	/*pause 0.*/
      if sw_reset then do:
      end.
   
      do:
        {xusel.i
         	&detfile = tpc_det
         	&scroll-field = tpc_sel
         	&framename = "d"
         	&framesize = 8
         	&searchkey = " "
         	&display1     = tpc_sel
         	&display2     = tpc_nbr
         	&display3     = tpc_vend
         	&display4     = tpc_part
         	&display5     = tpc_date
         	&display6     = tpc_price
         	&display7     = tpc_rmks
         	&sel_on    = ""*""
         	&sel_off   = """"
         	&exitlabel = scroll_loop
         	&exit-flag = true
         	&record-id = tt_recid
         	&CURSORDOWN = "  find first cd_det where cd_domain = global_domain and cd_ref = tpc_part and cd_lang = 'ch' no-lock no-error.
                          if avail cd_det then do: 	message cd_cmmt[1].   message cd_cmmt[2].  end.  "
        	&CURSORUP   = "  find first cd_det where cd_domain = global_domain and cd_ref = tpc_part and cd_lang = 'ch' no-lock no-error.
                          if avail cd_det then do: 	message cd_cmmt[1].   message cd_cmmt[2].  end.  "         
   				}
      end.     
      if keyfunction(lastkey) = "end-error" then do:
      	update-yn = no.
       	{pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       	if update-yn = yes then next mainloop.
     	end.

			/* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do:
			end. /* if keyfunction */
			else if keyfunction(lastkey) = "insert-mode" then 
			do on error undo,retry:
			end.
			else if keyfunction(lastkey) = "go"
      then do:
      	
      	update-yn = yes.
       	{pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
       	if update-yn = no then leave.
      	
      	for each tpc_det where tpc_sel = "*" no-lock break by tpc_nbr:
      		
      		for each xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr = tpc_nbr
      			and xxpc_list = tpc_vend 
      			and xxpc_part = tpc_part and xxpc_start = tpc_date :
      		
      			assign xxpc_approve_userid = global_userid
      						 xxpc_approve_date   = today.
      			
      		end.
      		
      		if last-of(tpc_nbr) then do:
      			find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" 
      				and usrw_key2 = tpc_nbr no-error.
      			if avail usrw_wkfl then do:
      				usrw_user1 = global_userid.
      			end.
      		end.
      		
      	end.
      	leave.
      end.
   end. /* do with frame d */
   
   hide frame d no-pause.

/* SS 090605.1 - B */
/*   
   	{mfselprt.i "printer" 100}
   	
  	{gprun.i ""xxrqpgyrp.p"" "(input xxpcnbr,input xxpcnbr1,input vend ,input vend1)"}
  	
   	{mfreset.i}
		{mfgrptrm.i}
*/
/* SS 090605.1 - E */		
   
end. /* repeat with frame a */

status input.

