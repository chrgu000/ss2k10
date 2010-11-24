/* SS - 090403.1 By: Neil Gao */

{mfdtitle.i "090601.1"}

define var ponbr like po_nbr.
define var poline like pod_line.
define var adname like ad_name .
define var desc1 like pt_desc1.
define var desc2 like pt_desc1.
define var tt_recid as recid.
define var first-recid as recid.
define var update-yn as logical.

define temp-table tt1
	field tt1_f1 like pod_line
	field tt1_f2 like pt_desc1 format "x(16)"
	field tt1_f3 like pt_desc2
	field tt1_f4 like pod_qty_ord
	field tt1_f5 like pod_due_date
	field tt1_f6 like pod_pur_cost
	field tt1_f7 like pt_part
	.

form
	skip(1)
	ponbr  colon 25 
	skip(1)
with frame a side-labels width 80 no-attr-space.

setFrameLabels(frame a:handle).
	
form
	tt1_f1	column-label "项"
	tt1_f7  column-label "物料号"
	tt1_f2 	column-label "说明"
	/*tt1_f3  column-label "说明"*/
	tt1_f4  column-label "订购量"
	tt1_f5	column-label "交货日期"
	tt1_f6  column-label "价格"
with frame b width 80 5 down scroll 1.
	
Mainloop:
repeat:
	
	update ponbr with frame a.
	
	find first po_mstr where po_domain = global_domain and po_nbr = ponbr no-lock no-error.
	if avail po_mstr then do:
		message "采购订单不存在".
	end.
	
	empty temp-table tt1.
	for each pod_det where pod_domain = global_domain and pod_nbr = ponbr no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = pod_part no-lock:
		create tt1.
		assign tt1_f1 = pod_line
					 tt1_f7 = pod_part
					 tt1_f2 = pt_desc1
					 tt1_f3 = pt_desc2
					 tt1_f4 = pod_qty_ord
					 tt1_f5 = pod_due_date
					 tt1_f6 = pod_pur_cost
					 .
	end.
	
	find first tt1 no-lock no-error.
	if not avail tt1 then do:
		message "无记录".
		next mainloop.
	end.
	
	loop1:
	repeat on error undo, leave:
		{xuview.i
    	     &buffer = tt1
    	     &scroll-field = tt1_f1
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = tt1_f1
    	     &display2     = tt1_f7
    	     &display3     = tt1_f2
    	     &display4     = tt1_f4
    	     &display5     = tt1_f5
    	     &display6     = tt1_f6
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = loop1
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 		
                         "
    	     &cursorup   = " 
    	     							
                         "
    	     }
    
		if keyfunction(lastkey) = "end-error" then do:
			update-yn = no.
      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       if update-yn = yes then next mainloop.
       else next loop1.
		end.
		
		if keyfunction(lastkey) = "return" then 
		do on error undo,retry :
			disp tt1_f6 with frame b.
			prompt-for tt1_f6 with frame b.
			if input tt1_f6 <= 0 then do:
				message "错误: 价格不能等于或小于零".
				undo,retry.
			end.
			tt1_f6 = input tt1_f6.
		end.
		
		if keyfunction(lastkey) = "go" then do:
			update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next loop1.
      for each tt1 no-lock where tt1_f6 > 0,
      	each pod_det where pod_domain = global_domain and pod_nbr = ponbr and pod_line = tt1_f1 :
      	pod_pur_cost = tt1_f6.
			end.
			next mainloop.
		end.
	end. /* loop1 */
end.