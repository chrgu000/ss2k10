/* SS - 090410.1 By: Neil Gao */

{mfdtitle.i "090408.1"}

define var yr like glc_year.
define var per like glc_per.
define var vend like po_vend.
define var part like pt_part.
define var tt_recid as recid.
define var first-recid as recid.
define var update-yn as logical.

define temp-table tt1
  field tt1_f1 like po_vend
  field tt1_f2 like pod_part
  field tt1_f3 like pt_desc1
  field tt1_f4 like pt_desc2
  field tt1_f5 like pt_um
  field tt1_f6 like po_curr
  field tt1_f7 like pt_price.

form
	yr colon 25
	per colon 25
	skip(1)
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).
	
form
	tt1_f1 column-label "供应商"
  tt1_f2 column-label "物料号"
	tt1_f3 column-label "名称"
	tt1_f5 column-label "单位"
	tt1_f6 column-label "币别"
	tt1_f7 column-label "价格"
with frame b width 80 5 down scroll 1.

mainloop:	
repeat:
	
	hide frame b no-pause.
	update yr per with frame a .
	
  find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "期间不存在".
	 	next.
	end.
	if glc_user1 <> "" then do:
		message "挂账已经关闭".
		next.
	end.
	
	empty temp-table tt1.
	for each xxld_det where xxld_domain = global_domain and xxld_qty <> 0 and xxld_price = 0 and xxld_zg_price = 0 :
		find last xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr <> "" and xxpc_approve_userid <> "" 
			and xxpc_list = xxld_vend and xxpc_part = xxld_part
			and (xxpc_start <= today or xxpc_start = ? ) and ( xxpc_expire >= today or xxpc_expire  = ? ) no-lock no-error.
		if avail xxpc_mstr then do:
			xxld_price = xxpc_amt[1].
		end.
		else if xxld_nbr = "" then do:
			
			create tt1.
			assign tt1_f1 = xxld_vend
						 tt1_f2 = xxld_part
						 tt1_f6 = "RMB"
						 .
			find first pt_mstr where pt_domain = global_domain and pt_part = xxld_part no-lock no-error.
			if avail pt_mstr then do:
				tt1_f3 = pt_desc1.
				tt1_f4 = pt_desc2.
				tt1_f5 = pt_um.
			end.
		end. /* else if do:*/
		else do:
			message "现采" xxld_nbr xxld_part "没有维护价格".
			next.
		end.
	end. /* for each */
	
	find first tt1 no-lock no-error.
	if not avail tt1 then do:
		message "无记录".
		next.
	end.
	
	loop1:
	repeat on error undo, leave:
		{xuview.i
    	     &buffer = tt1
    	     &scroll-field = tt1_f1
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = tt1_f1
    	     &display2     = tt1_f2
    	     &display3     = tt1_f3
    	     &display4     = tt1_f5
    	     &display5     = tt1_f6
    	     &display6     = tt1_f7
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
			disp tt1_f7 with frame b.
			prompt-for tt1_f7 with frame b.
			if input tt1_f7 <= 0 then do:
				message "错误: 价格不能等于或小于零".
				undo,retry.
			end.
			tt1_f7 = input tt1_f7.
		end.
		
		if keyfunction(lastkey) = "go" then do:
			update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next loop1.
      for each tt1 no-lock where tt1_f7 > 0:
      	find first xxld_det where xxld_domain = global_domain and xxld_vend = tt1_f1 and xxld_part = tt1_f2 and xxld_nbr = "" no-error.
      	if avail xxld_det then do:
      		xxld_zg_price = tt1_f7.
      	end.
			end.
			next mainloop.
		end.
	end. /* loop1 */
end. /* mainloop */
