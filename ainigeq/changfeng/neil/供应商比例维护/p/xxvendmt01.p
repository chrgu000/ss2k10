/*By: Neil Gao 08/06/30 ECO: *SS 20080630* */

{mfdeclre.i}  
{gplabel.i} 

define var site like ld_site.
define var ifper as logical init yes.
define var ifvend as logical init no.
define var ifbuyer as logical init yes.
define var part  like pt_part.
define var part1 like pt_part.
define var xxproportion like vp_tp_pct.
define var tt_recid as recid.
define var first-recid as recid.
define variable sw_reset     like mfc_logical. 
define var update-yn as logical.

define temp-table xxvdd_det
  field xxvdd_part like vp_part
  field xxvdd_vend like vp_vend
  field xxvdd_vend_part like vp_vend_part format "x(16)"
  field xxvdd_name like ad_name format "x(16)"
  field xxvdd_proportion like vp_tp_pct
  field xxvdd_price like vp_q_price
  index xxvdd_part
  xxvdd_part
  xxvdd_vend.
       
define temp-table xxvd_mstr
  field xxvd_part like vp_part
  field xxvd_desc1 like pt_desc1
  field	xxvd_desc2 like pt_desc2
  field xxvd_proportion like vp_tp_pct
  index xxvd_part
  xxvd_part.	
     		
form
   part     colon 15  part1   colon 48
   ifper    colon 15  label "比例不为100%"
   ifvend   colon 15  label "存在供应商"
   /*ifbuyer  colon 15  label "存在配套员"*/
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	 xxvd_part label "零件号"
   xxvd_desc1 label "品名"
   xxvd_desc2 label "规格"
   xxvd_proportion label "百分比"
with frame b width 80 no-attr-space 5 down scroll 1.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


form
   xxvdd_vend label "供应商"
   xxvdd_part label "零件号"
   xxvdd_name label "供应商名称"
   xxvdd_vend_part label "供应商物料"
   xxvdd_proportion label "百分比"
   xxvdd_price format ">>>>9.9<<" label "临时价格"
with frame c down width 80 no-attr-space.   
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
	
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
   
   if part1  = hi_char then part1  = "".
   
   update  
   	part  part1
		ifper ifvend
		/*ifbuyer*/
   with frame a.
   
   if part1 = "" then part1 = hi_char.
	 hide frame a no-pause.
	 
   scroll_loop:
   repeat with frame b:
	 	
	 	empty temp-table xxvd_mstr.
	 	empty temp-table xxvdd_det.
	 	
   	if ifper then do:
     	for each pt_mstr where pt_part >= part and pt_part <= part1 
        and pt_pm_code = "P" and pt_status <> "fn" no-lock:
        
        xxproportion = 0.
        for each vp_mstr where vp_part = pt_part and vp_vend <>  "" no-lock:
        	 xxproportion = xxproportion + vp_tp_pct.
        end.
        if pt_buyer <> "" then do:
         if ifvend then do:
        	 find first vp_mstr where vp_part = pt_part and vp_vend <>  "" no-lock no-error.
        	 if not avail vp_mstr then next.       	 
         end. 
         if xxproportion = 100 then next.
        end.
        
        for each vp_mstr where vp_part = pt_part and vp_vend <>  "" no-lock,
            each ad_mstr where ad_addr = vp_vend no-lock:
        	create xxvdd_det.
        	assign xxvdd_part = vp_part
        				 xxvdd_vend = vp_vend
        				 xxvdd_name = ad_name
        				 xxvdd_vend_part = vp_vend_part
        				 xxvdd_proportion = vp_tp_pct
        				 xxvdd_price = vp_q_price.
        end.
     		create xxvd_mstr.
     		assign xxvd_part = pt_part
     					 xxvd_desc1 = pt_desc1
     					 xxvd_desc2 = pt_desc2
     					 xxvd_proportion = xxproportion.	
     		
     	end.
    end.
    else do:
    	for each pt_mstr where pt_part >= part and pt_part <= part1 
        and pt_pm_code = "P" and pt_status <> "fn" no-lock:
        
        if pt_buyer <> "" then do:
         if ifvend then do:
        	 find first vp_mstr where vp_part = pt_part and vp_vend <>  "" no-lock no-error.
        	 if not avail vp_mstr then next.
         end.
        end.
        xxproportion = 0.
        for each vp_mstr where vp_part = pt_part and vp_vend <>  "" no-lock,
           each ad_mstr where ad_addr = vp_vend no-lock:
        		xxproportion = xxproportion + vp_tp_pct.
        	create xxvdd_det.
        	assign xxvdd_part = vp_part
          			 xxvdd_vend = vp_vend
        				 xxvdd_name = ad_name
        				 xxvdd_vend_part = vp_vend_part
        				 xxvdd_proportion = vp_tp_pct
        				 xxvdd_price = vp_q_price.
        end.
     		
     		create xxvd_mstr.
     		assign xxvd_part = pt_part
     					 xxvd_desc1 = pt_desc1
     					 xxvd_desc2 = pt_desc2
     					 xxvd_proportion = xxproportion.	
     	end.
    end. 
    
    find first xxvd_mstr no-lock no-error.
    if not avail xxvd_mstr then do:
    	message "记录不存在".
    	leave.
    end. 
    
    repeat on error undo,retry:  
    
    	{xuview.i
    	     &buffer = xxvd_mstr
    	     &scroll-field = xxvd_part
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = xxvd_part
    	     &display2     = xxvd_desc1
    	     &display3     = xxvd_desc2
    	     &display4     = xxvd_proportion
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = scroll_loop
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 		find first pt_mstr where pt_part = xxvd_part no-lock no-error.
    	     										if avail pt_mstr then message '配套员:' pt_buyer '安全库存:' pt_sfty_stk  '订货方法:' pt_ord_pol
    	     																									'最小订量' pt_ord_min.
                              "
    	     &cursorup   = " 
    	     										find first pt_mstr where pt_part = xxvd_part no-lock no-error.
    	     										if avail pt_mstr then message '配套员:' pt_buyer '安全库存:' pt_sfty_stk  '订货方法:' pt_ord_pol
    	     																									'最小订量' pt_ord_min.
                         "
    	     }
    	     
    	
    	if not avail xxvd_mstr then leave.
    	find first xxvdd_det where xxvdd_part = xxvd_part no-lock no-error.
    	if not avail xxvdd_det then do:
    		message "供应商不存在".
    		/*next.*/
    	end.
    	
    	   sw_reset = yes.
    	   
    	   view frame c.
    	   clear frame c all no-pause.
    	   
    		 repeat on error undo,retry:
					 
    	     {xxrescrad.i xxvdd_det "use-index xxvdd_part" xxvdd_vend
    	        "xxvdd_vend xxvdd_name xxvdd_part xxvdd_vend_part xxvdd_proportion xxvdd_price"
    	        xxvdd_vend c
    	        "xxvdd_part = xxvd_part "
    	        " "
    	        " "
    	        " "
    	        }
    	     
    	     if keyfunction(lastkey) = "end-error" then leave.
    	     
    	     if keyfunction(lastkey) = "get"
    	  		or lastkey = keycode("CTRL-D")
    	  		or lastkey = keycode("F5") then
    	  	 do transaction:
    	  	 		update-yn = no.
        			{pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=update-yn}
        			if update-yn = yes then do:
        				for each vp_mstr where vp_part = xxvdd_part and vp_vend = xxvdd_vend:
        					delete vp_mstr.
        				end.
        				delete xxvdd_det.
         				clear frame c no-pause.
        			end.
							next.
    	  	 end.
    	  	 
    	  	 if keyfunction(lastkey) = "return" and recno <> ?
    	  	 	then do :
							
    	     end.
    	     
    	     if recno = ? and not keyfunction(lastkey) = "insert-mode"
    	     and keyfunction(lastkey) <> "return"
    	     then next.
    	
	  	     if keyfunction(lastkey) = "return" and recno <> ?
			      then do transaction on error undo, retry:
			      	update xxvdd_proportion xxvdd_price with frame c.
					 end.
					 
					 if keyfunction(lastkey) = "insert-mode"
			      or (keyfunction(lastkey) = "return" and recno = ?)
    			  then do transaction:
    			  	
    			  	prompt-for xxvdd_vend with frame C
    			  	editing:
    			  		{mfnp06.i vd_mstr vd_addr
          				" 1 = 1 "
              			 "input xxvdd_vend" vd_addr
              			 "input xxvdd_vend" vd_addr}

          			if recno <> ? then do:
          				display  vd_addr @ xxvdd_vend
          								 vd_sort @ xxvdd_name
            			with frame c.
            		end.
            		
          		end.
          		
    			  	find first vd_mstr where vd_addr = input xxvdd_vend no-lock no-error.
            	if avail vd_mstr then do:
            		find first xxvdd_det where xxvdd_part = xxvd_part and xxvdd_vend = vd_addr no-lock no-error.
            		if not avail xxvdd_det then do:
            			create xxvdd_det.
        					assign xxvdd_part = xxvd_part
        							 xxvdd_vend = vd_addr
        				 			 xxvdd_name = vd_sort.
        				 			 
            			disp xxvdd_part xxvdd_vend xxvdd_name with frame c.
            			
            			update xxvdd_vend_part xxvdd_proportion xxvdd_price with frame c.
            			find first pt_mstr where pt_part = xxvd_part no-lock no-error.
            			create vp_mstr.
            			assign vp_vend = vd_addr
            						 vp_part = xxvd_part
            						 vp_vend_part = xxvdd_vend_part
            						 vp_tp_pct = xxvdd_proportion
            						 vp_q_price = xxvdd_price
            						 vp_mod_date = today
            						 vp_um = "EA"
            						 vp_curr = "RMB"
            						 vp_q_date = today
   											 vp_userid = global_userid.
   								if avail pt_mstr then vp_um = pt_um.
            		end.
            	end.
    			  	
					 end.
					 
    	     if keyfunction(lastkey) = "go"
			      then do:
			      	xxproportion = 0.
			      	for each xxvdd_det where xxvdd_part = xxvd_part no-lock,
			      		each vp_mstr where vp_part = xxvdd_part and vp_vend = xxvdd_vend no-lock:
			      		xxproportion = xxproportion + xxvdd_proportion.
			      	end.
			      	if xxproportion <> 100 then do:
			      		message "合计比例为:" xxproportion  "%, 请重新输入".
			    			undo,retry.
			      	end.
			      	else do:
			      		for each xxvdd_det where xxvdd_part = xxvd_part no-lock,
			      		 each vp_mstr where vp_part = xxvdd_part and vp_vend = xxvdd_vend :
			      		 	vp_tp_pct = xxvdd_proportion.
			      		 	vp_q_price = xxvdd_price.
			      		end.
			      		xxvd_proportion = 100.
			      		disp xxvd_proportion with frame b.
			      		leave.
			      	end.
 					 end.
 					 	
    		end. /* repeat */
		end. /* repeat */		
    hide frame c no-pause.	
   end. /* do with frame b */
   hide frame b no-pause.
   hide frame c no-pause.
   
   
end. /* repeat with frame a */

status input.


