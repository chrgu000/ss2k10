/* By: Neil Gao Date: 07/12/20 ECO: * ss 20071220 */
/*By: Neil Gao 08/04/10 ECO: *SS 20080410* */

{mfdeclre.i}  
{gplabel.i} 

define var site like ld_site.
define var ifper as logical init no.
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
   site     colon 15
   part     colon 15  part1   colon 48
   ifper    colon 15  label "��������100%"
   /*ifvend   colon 15  label "���ڹ�Ӧ��"*/
   /*ifbuyer  colon 15  label "��������Ա"*/
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	 xxvd_part label "�����"
   xxvd_desc1 label "Ʒ��"
   xxvd_desc2 label "���"
   xxvd_proportion label "�ٷֱ�"
with frame b width 80 no-attr-space 5 down scroll 1.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


form
   xxvdd_vend label "��Ӧ��"
   xxvdd_part label "�����"
   xxvdd_name label "��Ӧ������"
   xxvdd_vend_part label "��Ӧ������"
   xxvdd_proportion label "�ٷֱ�"
   xxvdd_price format ">>>>9.9<<" label "��ʱ�۸�"
with frame c down width 80 no-attr-space.   
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
	
/* DISPLAY */
view frame a.

{gprunp.i "xxproced" "p" "getglsite" "(output site)"}

mainloop:
repeat with frame a:
   
   if part1  = hi_char then part1  = "".
   
   update 
   	site 
   	part  part1
		ifper
		/*ifbuyer*/
   with frame a.
   
   if part1 = "" then part1 = hi_char.
	 hide frame a no-pause.
	 
   scroll_loop:
   repeat with frame b:
	 	
	 	empty temp-table xxvd_mstr.
	 	empty temp-table xxvdd_det.
	 	
   	if not ifper then do:
     	for each pt_mstr where pt_domain = global_domain and pt_part >= part and pt_part <= part1 
        and pt_pm_code = "P" and pt_status <> "fn" no-lock:
        
        xxproportion = 0.
        for each vp_mstr where vp_domain = global_domain and vp_part = pt_part and vp_vend <>  "" no-lock:
        	 xxproportion = xxproportion + vp_tp_pct.
        end.
        /*
        if ifvend then do:
        	find first vp_mstr where vp_domain = global_domain and vp_part = pt_part and vp_vend <>  "" no-lock no-error.
        	if not avail vp_mstr then next.       	 
        end.*/ 
        if xxproportion = 100 then next.
        
        for each vp_mstr where vp_domain = global_domain and vp_part = pt_part and vp_vend <>  "" no-lock,
            each ad_mstr where ad_domain = global_domain and ad_addr = vp_vend no-lock:
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
    	for each pt_mstr where pt_domain = global_domain and pt_part >= part and pt_part <= part1 
        and pt_pm_code = "P" and pt_status <> "fn" no-lock:
        
        if pt_buyer <> "" then do:
         /*
         if ifvend then do:
        	 find first vp_mstr where vp_domain = global_domain and vp_part = pt_part and vp_vend <>  "" no-lock no-error.
        	 if not avail vp_mstr then next.
         end.
         */
        end.
        xxproportion = 0.
        for each vp_mstr where vp_domain = global_domain and vp_part = pt_part and vp_vend <>  "" no-lock,
           each ad_mstr where ad_domain = global_domain and ad_addr = vp_vend no-lock:
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
    	message "��¼������".
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
    	     &cursordown = " 		find first pt_mstr where pt_domain = global_domain and pt_part = xxvd_part no-lock no-error.
    	     										if avail pt_mstr then message '����Ա:' pt_buyer '��ȫ���:' pt_sfty_stk  '��������:' pt_ord_pol
    	     																									'��С����' pt_ord_min.
    	     										find first cd_det where cd_domain = global_domain and cd_ref = xxvd_part 
                            	and cd_lang = 'ch' no-lock no-error.
                            	if avail cd_det then message cd_cmmt[1].
                              "
    	     &cursorup   = " 
    	     										find first pt_mstr where pt_domain = global_domain and pt_part = xxvd_part no-lock no-error.
    	     										if avail pt_mstr then message '����Ա:' pt_buyer '��ȫ���:' pt_sfty_stk  '��������:' pt_ord_pol
    	     																									'��С����' pt_ord_min.
    	     										find first cd_det where cd_domain = global_domain and cd_ref = xxvd_part 
                            	and cd_lang = 'ch' no-lock no-error.
                            	if avail cd_det then message cd_cmmt[1].
                         "
    	     }
    	     
    	
    	if not avail xxvd_mstr then leave.
    	find first xxvdd_det where xxvdd_part = xxvd_part no-lock no-error.
    	if not avail xxvdd_det then do:
    		message "��Ӧ�̲�����".
    		/*next.*/
    	end.
    	
    	   sw_reset = yes.
    	   
    	   view frame c.
    	   clear frame c all no-pause.
    	   
    		 repeat on error undo,retry
    		 				on endkey undo,retry:
					 
					 sw_reset = yes.
					 
    	     {xxrescrad.i xxvdd_det "use-index xxvdd_part" xxvdd_vend
    	        "xxvdd_vend xxvdd_name xxvdd_part xxvdd_vend_part xxvdd_proportion xxvdd_price"
    	        xxvdd_vend c
    	        "xxvdd_part = xxvd_part "
    	        " "
    	        " "
    	        " "
    	        }
    	     
    	     	if keyfunction(lastkey) = "end-error" then do:
    	    		find first xxvdd_det where xxvdd_part = xxvd_part no-lock no-error.
    	    		if not avail xxvdd_det then leave.
    	    		
    	    		run pdpct( input xxvd_part , output update-yn ).
			      	if update-yn then do:
			      		xxvd_proportion = 100.
   							disp xxvd_proportion with frame b.
			      		leave.
			      	end.
			      	else do:
			      		undo,retry.
			      	end.
    	    	end.
    	     
    	     if keyfunction(lastkey) = "get"
    	  		or lastkey = keycode("CTRL-D")
    	  		or lastkey = keycode("F5") then
    	  	 do transaction:
    	  	 		update-yn = no.
        			{pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=update-yn}
        			if update-yn = yes then do:
        				for each vp_mstr where vp_domain = global_domain and vp_part = xxvdd_part and vp_vend = xxvdd_vend:
        					delete vp_mstr.
        				end.
        				delete xxvdd_det.
         				clear frame c no-pause.
        			end.
							next.
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
          				" 1 = 1 and vd_domain = global_domain "
              			 "input xxvdd_vend" vd_addr
              			 "input xxvdd_vend" vd_addr}

          			if recno <> ? then do:
          				display  vd_addr @ xxvdd_vend
          								 vd_sort @ xxvdd_name
            			with frame c.
            		end.
            		
          		end.
          		
    			  	find first vd_mstr where vd_domain = global_domain and vd_addr = input xxvdd_vend no-lock no-error.
            	if avail vd_mstr then do:
            		find first xxvdd_det where xxvdd_part = xxvd_part and xxvdd_vend = vd_addr no-lock no-error.
            		if not avail xxvdd_det then do:
            			create xxvdd_det.
        					assign xxvdd_part = xxvd_part
        							 xxvdd_vend = vd_addr
        				 			 xxvdd_name = vd_sort.
        				 			 
            			disp xxvdd_part xxvdd_vend xxvdd_name with frame c.
            			
            			update xxvdd_vend_part xxvdd_proportion xxvdd_price with frame c.
            			find first pt_mstr where pt_domain = global_domain and pt_part = xxvd_part no-lock no-error.
            			create vp_mstr.
            			assign vp_domain = global_domain
            						 vp_vend = vd_addr
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
			      	/*
			      	xxproportion = 0.
			      	for each xxvdd_det where xxvdd_part = xxvd_part no-lock,
			      		each vp_mstr where vp_part = xxvdd_part and vp_vend = xxvdd_vend no-lock:
			      		xxproportion = xxproportion + xxvdd_proportion.
			      	end.
			      	if xxproportion <> 100 then do:
			      		message "�ϼƱ���Ϊ:" xxproportion  "%, ����������".
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
			      	*/
			      	run pdpct( input xxvd_part , output update-yn ).
			      	if update-yn then do:
			      		xxvd_proportion = 100.
   							disp xxvd_proportion with frame b.
			      		leave.
			      	end.
			      	else undo,retry.
 					 end.
 					 	
    		end. /* repeat */
		end. /* repeat */		
    hide frame c no-pause.	
   end. /* do with frame b */
   hide frame b no-pause.
   hide frame c no-pause.
   
   
end. /* repeat with frame a */

status input.

procedure pdpct:
	define input  parameter iptpart like pt_part.
	define output parameter optrst as logical.
	xxproportion = 0.
	for each xxvdd_det where xxvdd_part = iptpart no-lock,
		each vp_mstr where vp_part = xxvdd_part and vp_vend = xxvdd_vend no-lock:
			xxproportion = xxproportion + xxvdd_proportion.
  end.
  if xxproportion <> 100 then do:
   	message "�ϼƱ���Ϊ:" xxproportion  "%, ����������".
 		optrst = no.
 		return.
  end.
  else do:
   	for each xxvdd_det where xxvdd_part = iptpart no-lock,
   	each vp_mstr where vp_part = xxvdd_part and vp_vend = xxvdd_vend :
   		vp_tp_pct = xxvdd_proportion.
   		vp_q_price = xxvdd_price.
   	end.
   	optrst = yes.
  end.
	
end procedure.

