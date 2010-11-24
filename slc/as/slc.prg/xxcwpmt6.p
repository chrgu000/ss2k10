/* SS - 090403.1 By: Neil Gao */
/* SS - 090717.1 By: Neil Gao */
/* SS - 090812.1 By: Neil Gao */
/* SS - 100629.1 By: Kaine Zhang */


/* SS - 100629.1 - RNB
[100629.1]
在挂账明细中,添加标记.以区分已挂账数据/未挂账数据.
下期处理未挂账账目的时候,可以根据该标记来做.
[100629.1]
SS - 100629.1 - RNE */

{mfdtitle.i "100629.1"}

define new shared var yr like glc_year.
define new shared var per like glc_per.
define new shared var vend  like po_vend.

define var part like pt_part.
define var site like in_site init "10000".
define var tt_recid as recid.
define var first-recid as recid.
define var update-yn as logical.
define var desc1 as char format "x(76)".
define var desc2 as char format "x(76)".
define var desc3 as char format "x(76)".

define temp-table tt1
	field tt1_f1 like pt_part
	field tt1_f2 like pt_desc1
	field tt1_f3 like ld_qty_oh
	field tt1_f4 like ld_qty_oh
	field tt1_f5 like pt_price
	field tt1_f6 like ar_amt
	field tt1_f7 as logical
	field tt1_f8 like xxgzd_tax_pct
	.

form
	yr colon 25
	per colon 25
	vend colon 25
with frame a width 80 side-labels attr-space.

setFramelabels(frame a:handle).

form
	tt1_f1 column-label "物料号"
	tt1_f3 column-label "挂账数量" format "->>>>>9.9"
	tt1_f5 column-label "含税单价" format ">>>>>9.9<<<"
	tt1_f6 column-label "挂账金额" format "->>>>>>9.99"
	tt1_f8 column-label "税率"
	tt1_f4 column-label "未挂账数" format "->>>>>9.9"
	tt1_f7 column-label "挂账"
with frame b width 80 5 down scroll 1.
	
form
	pt_desc1 no-label at 1
	desc1 no-label at 1
	desc2 no-label at 1
	desc3 no-label at 1
with frame e width 80 side-labels attr-space.

mainloop:
repeat with frame a:
	
	hide frame b no-pause.
	hide frame e no-pause.
	update yr per vend with frame a.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "错误:期间不存在".
	 	next.
	end.
	if glc_user1 <> "" then do:
		message "挂账已经关闭".
		next.
	end.
	
	find first vd_mstr where vd_domain = global_domain and vd_domain = global_domain and vd_addr = vend no-lock no-error.
	if not avail vd_mstr then do:
		message "错误: 供应商代码不存在".
		next.
	end.
	
	find first xxgz_mstr where xxgz_domain = global_domain and xxgz_vend = vend 
  	and xxgz_year = yr and xxgz_per = per no-lock no-error.
	if avail xxgz_mstr and xxgz_confirm then do:
		message "已经挂账,不能修改".
		next.
	end.
	
	empty temp-table tt1.
	for each xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr
    and xxgzd_per = per and xxgzd_vend  = vend no-lock,
    each pt_mstr where pt_domain = global_domain and pt_part = xxgzd_part no-lock:
		
		create tt1.
		assign tt1_f1 = xxgzd_part
					 tt1_f2 = pt_desc1
					 tt1_f3 = xxgzd_end_qty
					 tt1_f4 = xxgzd_qty
					 tt1_f5 = xxgzd_price
					 tt1_f6 = xxgzd_amt
					 tt1_f7 = yes
					 tt1_f8 = xxgzd_tax_pct
					 .
		if xxgzd_qty = 0 then tt1_f7 = yes.
		
	end.
	
	find first tt1 no-lock no-error.
	if not avail tt1 then do:
		message "无记录".
		next.
	end.
	
	tt_recid  = ?.
	first-recid = ?.
	loop1:
	repeat on error undo,retry:
		
		{xuview.i
    	     &buffer = tt1
    	     &scroll-field = tt1_f1
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = tt1_f1
    	     &display2     = tt1_f3
    	     &display3     = tt1_f5
    	     &display4     = tt1_f6
    	     &display5     = tt1_f8
    	     &display7     = tt1_f4
    	     &display6     = tt1_f7
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = loop1
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 	if avail tt1 then run dispcmmt (input tt1_f1).	
                         "
    	     &cursorup   = "  if avail tt1 then run dispcmmt (input tt1_f1).
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
			tt1_f7 = input tt1_f7.
		end.
		
		if keyfunction(lastkey) = "go" then do:
			
			{mfselprt.i "priter" 132}
      
      {gprun.i ""xxcwrp02a.p""}
      
      {mfreset.i}
			{mfgrptrm.i}
			
			update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next mainloop.
      for each tt1 no-lock where tt1_f7:
      	find first xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per
      		and xxgzd_vend = vend and xxgzd_part = tt1_f1 no-error.
      	if avail xxgzd_det then do:
      		xxgzd_end_qty = xxgzd_end_qty + xxgzd_qty.
      		xxgzd_qty = 0.
      		/* SS - 100629.1 - B */
      		assign
      		    xxgzd_is_confirm = yes
      		    xxgzd_confirm_date = today
      		    .
      		/* SS - 100629.1 - E */
      		
      		/* SS - 100702.1 - B */
      		/*
      		 *  将本期之前的所有xxld_confirm_gz_price设为yes.
      		 *  表明供应商已经确认挂账,该库存的价格已固定.
      		 */
      		for each xxld_det
      		    where xxld_domain = global_domain
      		        and 
      		        (xxld_year < yr
      		            or (xxld_year = yr and xxld_per < per)
      		        )
      		        and not(xxld_confirm_gz_price)
            :
                xxld_confirm_gz_price = yes.
            end.
      		/* SS - 100702.1 - E */
      	end.
			end.
			for first xxgz_mstr where xxgz_domain = global_domain and xxgz_vend = vend 
      		and xxgz_year = yr and xxgz_per = per :
      	xxgz_confirm = yes.	
      	xxgz_date = today.
      end.
			
			next mainloop.
		end.
		
	end. /* loop1 */
end. /* mainloop */	

procedure dispcmmt:
	define input parameter iptf1 like pt_part .
	disp "" @ pt_desc1 with frame e.
	desc1 = "".
	desc2 = "".
	desc3 = "".
	find first pt_mstr where pt_domain = global_domain and pt_part = iptf1 no-lock no-error.
	if avail pt_mstr then disp pt_desc1 with frame e.
	
	find first cd_det where cd_domain = global_domain and cd_ref = iptf1 and cd_type = "SC" 
		and cd_lang = "ch" no-lock no-error.
	if avail cd_det then do:
		desc1 = cd_cmmt[1].
		desc2 = cd_cmmt[2].
		desc3 = cd_cmmt[3].
	end.
	disp desc1 desc2 desc3 with frame e.
end.