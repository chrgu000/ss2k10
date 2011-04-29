/* xxdnmt */
/* REVISION: eb2.1 SP3 create 03/13/06 BY: *SS-MIN001* Apple Tam*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/12/04  ECO: *xp001*  */
/*-Revision end---------------------------------------------------------------*/


    /* DISPLAY TITLE */
    {mfdtitle.i "1+"}
define new shared variable p-site    like xdn_site   .
define new shared variable p-ordertype    like xdn_ordertype   .
define new shared variable p-type    like xdn_type   .
define new shared variable p-prev    like xdn_prev   .
define new shared variable p-name    like xdn_name   .
define new shared variable p-next    like xdn_next  /*format "999999"*/ .
define new shared variable p-isonbr    like xdn_isonbr  .
define new shared variable p-isover    like xdn_isover  .
define new shared variable p-desc1     like xdn_desc1   .
define new shared variable p-desc2     like xdn_desc2   .
define new shared variable p-desc3     like xdn_desc3   .
define new shared variable p-desc4     like xdn_desc4   .
define new shared variable p-desc5     like xdn_desc5   .
define new shared variable p-train1    like xdn_train1  .
define new shared variable p-train2    like xdn_train2  .
define new shared variable p-train3    like xdn_train3  .
define new shared variable p-train4    like xdn_train4  .
define new shared variable p-train5    like xdn_train5  .
define new shared variable p-page1     like xdn_page1  .
define new shared variable p-page2     like xdn_page2  .
define new shared variable p-page3     like xdn_page3  .
define new shared variable p-page4     like xdn_page4  .
define new shared variable p-page5     like xdn_page5  .
define new shared variable p-page6     like xdn_page6  .

define variable del-yn like mfc_logical initial no.

/* DISPLAY SELECTION FORM */
form
	p-site        colon 20 label "地点"
	p-ordertype   colon 40 label "交易类型"
	p-type        colon 60 label "单据类型"
	p-prev        colon 20 label "单号前辍" format "x(2)"
	p-name        colon 20 label "表头名称"
	p-next        colon 20 label "下一单号"  format "x(6)"
	p-isonbr      colon 20 label "ISO表号"
	p-isover     colon 20 label "ISO版本/修订"
	p-desc1       colon 20 label  "说明1"
	p-desc2       colon 20 label  "说明2"
	p-desc3       colon 20 label  "说明3"
	p-desc4       colon 20 label  "说明4"
	p-desc5       colon 20 label  "说明5"
	p-train1      colon 20 label "表尾签名1"  
	p-page1       colon 60 label "第一联" 
	p-train2      colon 20 label "表尾签名2"  
	p-page2       colon 60 label "第二联" 
	p-train3      colon 20 label "表尾签名3"  
	p-page3       colon 60 label "第三联" 
	p-train4      colon 20 label "表尾签名4"  
	p-page4       colon 60 label "第四联" 
	p-train5      colon 20 label "表尾签名5"  
	p-page5       colon 60 label "第五联" 
	p-page6       colon 60 label "第六联" 
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find icc_ctrl where icc_domain = global_domain no-lock no-error.
p-site = if avail icc_ctrl then icc_site else global_site .

mainloop:
repeat:  
	view frame a.
	p-next = "000001".
	p-ordertype = "" .
	p-type     = "".
	p-name     = "".
	p-prev     = "".
	p-isonbr   = "". 
	p-isover  = "". 
	p-desc1    = "".
	p-desc2    = "".
	p-desc3    = "".
	p-desc4    = "".
	p-desc5    = "".
	p-train1   = "". 
	p-train2   = "". 
	p-train3   = "". 
	p-train4   = "". 
	p-train5   = "". 
	p-page1   = "". 
	p-page2   = "". 
	p-page3   = "". 
	p-page4   = "". 
	p-page5   = "". 
	p-page6   = "". 

	display 
		p-site 
		p-ordertype
		p-type   
		p-name   
		p-prev   
		p-next
		p-isonbr  
		p-isover   
		p-desc1    
		p-desc2 
		p-desc3 
		p-desc4 
		p-desc5      
		p-train1  
		p-train2  
		p-train3  
		p-train4  
		p-train5
		p-page1  
		p-page2  
		p-page3  
		p-page4  
		p-page5  
		p-page6  
	with frame a.

	update p-site p-ordertype p-type with frame a editing:
	if frame-field = "p-site" then do:
	        {mfnp.i si_mstr p-site  " si_domain = global_domain and si_site " p-site si_site si_site}  
		if recno <> ? then do:
			assign
			p-site     =  si_site       .

		       display 
			   p-site
			with frame a.

		end. /*recno <> ? */
	end. /*if frame-field = "p-site" then*/
	else if frame-field = "p-ordertype" then do:
		{mfnp05.i xdn_ctrl 
				  xdn_type  
				  "xdn_ctrl.xdn_domain = global_domain and xdn_site = input p-site " 
				  xdn_ordertype 
				  "input frame a p-ordertype"}  
		if recno <> ? then do:
			assign
			p-site     =  xdn_site
			p-ordertype = xdn_ordertype
			p-type     =  xdn_type  
			p-name     =  xdn_name  
			p-prev     =  xdn_prev    
			p-next     =  xdn_next  
			p-isonbr   =  xdn_isonbr  
			p-isover  =  xdn_isover 
			p-desc1    =  xdn_desc1   
			p-desc2    =  xdn_desc2 
			p-desc3    =  xdn_desc3   
			p-desc4    =  xdn_desc4 
			p-desc5    =  xdn_desc5    
			p-train1   =  xdn_train1  
			p-train2   =  xdn_train2  
			p-train3   =  xdn_train3  
			p-train4   =  xdn_train4  
			p-train5   =  xdn_train5
			p-page1   =  xdn_page1  
			p-page2   =  xdn_page2  
			p-page3   =  xdn_page3  
			p-page4   =  xdn_page4  
			p-page5   =  xdn_page5
			p-page6   =  xdn_page6.                

		    display 
			   p-site
			   p-ordertype
			   p-type   
			   p-name   
			   p-prev   
			   p-next
			   p-isonbr  
			   p-isover   
			      p-desc1    
			    p-desc2 
			    p-desc3 
			    p-desc4 
			    p-desc5       
			   p-train1  
			   p-train2  
			   p-train3  
			   p-train4  
			   p-train5
			   p-page1  
			   p-page2  
			   p-page3  
			   p-page4  
			   p-page5  
			   p-page6  
			with frame a.

		end. /*recno <> ? */
	end. /*else if frame-field = "p-ordertype"*/
	else if frame-field = "p-type" then do:
		{mfnp05.i xdn_ctrl 
					xdn_type  
					" xdn_ctrl.xdn_domain = global_domain and xdn_site = input p-site and xdn_ordertype = input p-ordertype" 
					xdn_type 
					"input frame a p-type"}  
		if recno <> ? then do:
			assign
				p-site     =  xdn_site
				p-ordertype = xdn_ordertype
				p-type     =  xdn_type  
				p-name     =  xdn_name  
				p-prev     =  xdn_prev    
				p-next     =  xdn_next  
				p-isonbr   =  xdn_isonbr  
				p-isover  =  xdn_isover 
				p-desc1    =  xdn_desc1   
				p-desc2    =  xdn_desc2 
				p-desc3    =  xdn_desc3   
				p-desc4    =  xdn_desc4 
				p-desc5    =  xdn_desc5    
				p-train1   =  xdn_train1  
				p-train2   =  xdn_train2  
				p-train3   =  xdn_train3  
				p-train4   =  xdn_train4  
				p-train5   =  xdn_train5
				p-page1   =  xdn_page1  
				p-page2   =  xdn_page2  
				p-page3   =  xdn_page3  
				p-page4   =  xdn_page4  
				p-page5   =  xdn_page5
				p-page6   =  xdn_page6.                

		       display 
					p-site
					p-ordertype
					p-type   
					p-name   
					p-prev   
					p-next
					p-isonbr  
					p-isover   
					p-desc1    
					p-desc2 
					p-desc3 
					p-desc4 
					p-desc5       
					p-train1  
					p-train2  
					p-train3  
					p-train4  
					p-train5
					p-page1  
					p-page2  
					p-page3  
					p-page4  
					p-page5  
					p-page6  
			with frame a.

		end. /*recno <> ? */

	end. /*else if frame-field = "p-type" */
	else do:
	           status input ststatus.
                   readkey.
                   apply lastkey.
	end. /*else do:*/

	end. /*editing*/
	assign p-site p-ordertype p-type .


	if p-site = "" then do:
	   message "错误：类型不能为空, 请重新输入".
	   undo, retry.
	end.

	if p-ordertype = "" then do:
	   message "错误：类型不能为空, 请重新输入".
	   undo, retry.
	end.

	if p-type = "" then do:
	   message "错误：类型不能为空, 请重新输入".
	   undo, retry.
	end.
		find first si_mstr where si_domain = global_domain and si_site = p-site no-lock no-error .
		if not avail si_mstr then do:
			message "地点无效，请重新输入。" view-as alert-box.
			undo,retry .
		end.
		if not 
		(not can-find(first code_mstr where code_mstr.code_domain = global_domain and  code_fldname = "xdn_ordertype" )
		 or  can-find (code_mstr  where code_mstr.code_domain = global_domain 
					  and code_fldname = "xdn_ordertype" 
					  and code_value   =  p-ordertype )
		) then do:
		  message "交易类型无效，仅限通用代码设定范围。" view-as alert-box .
		  undo,retry .
		end.   /*xp001*/ 
	find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain 
			    and  xdn_site = p-site 
			    and xdn_ordertype = p-ordertype 
			    and xdn_type = p-type no-lock no-error.
	if available xdn_ctrl then do:
	     assign
			p-site     =  xdn_site
			p-ordertype = xdn_ordertype
			p-type     =  xdn_type  
			p-name     =  xdn_name  
			p-prev     =  xdn_prev    
			p-next     =  xdn_next  
			p-isonbr   =  xdn_isonbr  
			p-isover  =  xdn_isover 
			p-desc1    =  xdn_desc1   
			p-desc2    =  xdn_desc2 
			p-desc3    =  xdn_desc3   
			p-desc4    =  xdn_desc4 
			p-desc5    =  xdn_desc5     
			p-train1   =  xdn_train1  
			p-train2   =  xdn_train2  
			p-train3   =  xdn_train3  
			p-train4   =  xdn_train4  
			p-train5   =  xdn_train5   
			p-page1   =  xdn_page1  
			p-page2   =  xdn_page2  
			p-page3   =  xdn_page3  
			p-page4   =  xdn_page4  
			p-page5   =  xdn_page5
			p-page6   =  xdn_page6.     
	end.
	else do:
		assign
			p-name     = ""
			p-prev     = ""
			p-next     = ""
			p-isonbr   = ""
			p-isover  = ""
			 p-desc1    = ""
			p-desc2    = ""
			p-desc3    = ""
			p-desc4    = ""
			p-desc5    = ""
			p-train1   = ""
			p-train2   = ""
			p-train3   = ""
			p-train4   = ""
			p-train5   = "" 
			p-page1   = ""
			p-page2   = ""
			p-page3   = ""
			p-page4   = ""
			p-page5   = ""
			p-page6   = "". 
	end.

	  display 
	   
			p-name   
			p-prev   
			p-next
			p-isonbr  
			p-isover   
			p-desc1    
			p-desc2 
			p-desc3 
			p-desc4 
			p-desc5     
			p-train1  
			p-train2  
			p-train3  
			p-train4  
			p-train5
			p-page1  
			p-page2  
			p-page3  
			p-page4  
			p-page5  
			p-page6  
	with frame a.

	repeat:
	update	p-prev 	with frame a .

	if p-prev = "" then do:
	   message "错误：前辍不能为空. 请重新输入".
	   undo, retry.
	end.
	find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain 
			    and xdn_site = p-site 
			    and xdn_ordertype = p-ordertype
			    and xdn_type = p-type 
			    and xdn_prev = p-prev no-lock no-error.
	if available xdn_ctrl then do:
		 
		   assign
		p-type     =  xdn_type  
		p-name     =  xdn_name  
		p-prev     =  xdn_prev    
		p-next     =  xdn_next  
		p-isonbr   =  xdn_isonbr  
		p-isover  =  xdn_isover 
		p-desc1    =  xdn_desc1   
		p-desc2    =  xdn_desc2 
		p-desc3    =  xdn_desc3   
		p-desc4    =  xdn_desc4 
		p-desc5    =  xdn_desc5   
		p-train1   =  xdn_train1  
		p-train2   =  xdn_train2  
		p-train3   =  xdn_train3  
		p-train4   =  xdn_train4  
		p-train5   =  xdn_train5
		p-page1   =  xdn_page1  
		p-page2   =  xdn_page2  
		p-page3   =  xdn_page3  
		p-page4   =  xdn_page4  
		p-page5   =  xdn_page5
		p-page6   =  xdn_page6.  
	end.
	else do:
		p-next    = "000001" .
		assign
		p-isonbr   = ""
		p-isover  = ""
		p-desc1    = ""
		p-desc2    = ""
		p-desc3    = ""
		p-desc4    = ""
		p-desc5    = ""
		p-train1   = ""
		p-train2   = ""
		p-train3   = ""
		p-train4   = ""
		p-train5   = "" 
		p-page1   = ""
		p-page2   = ""
		p-page3   = ""
		p-page4   = ""
		p-page5   = ""
		p-page6   = "". 

	end.
		     display 
	   
		p-name   
		p-prev   
		p-next
		p-isonbr  
		p-isover   
		p-desc1    
		p-desc2 
		p-desc3 
		p-desc4 
		p-desc5    
		p-train1  
		p-train2  
		p-train3  
		p-train4  
		p-train5
		p-page1  
		p-page2  
		p-page3  
		p-page4  
		p-page5  
		p-page6  
	with frame a.

	    ststatus = stline[2].
	    status input ststatus.
	update
		p-name
		p-next
		p-isonbr  
		p-isover   
		p-desc1    
		p-desc2 
		p-desc3 
		p-desc4 
		p-desc5   
		p-train1  
		p-train2  
		p-train3  
		p-train4  
		p-train5
		p-page1  
		p-page2  
		p-page3  
		p-page4  
		p-page5  
		p-page6  
	 go-on(F5 CTRL-D) with frame a.

	if p-next = "" then do:
	   message "错误：下一个单号不能为空,请重新输入".
	   undo, retry.
	end.

	if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
	   del-yn = yes.
	   {mfmsg01.i 11 1 del-yn}
	   if del-yn then do:
		 find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain 
			    and xdn_site = p-site 
			    and xdn_ordertype = p-ordertype
			    and xdn_type = p-type 			
			    exclusive-lock no-error.
		     if available xdn_ctrl then do:
			delete xdn_ctrl.
		     end.
		  clear frame a.
		p-name    = "" .
		p-next     = "000001".
		p-prev     = "" .
	      assign
		p-isonbr   = ""
		p-isover  = ""
		p-desc1    = ""
		p-desc2    = ""
		p-desc3    = ""
		p-desc4    = ""
		p-desc5    = ""
		p-train1   = ""
		p-train2   = ""
		p-train3   = ""
		p-train4   = ""
		p-train5   = "" 
		p-page1   = ""
		p-page2   = ""
		p-page3   = ""
		p-page4   = ""
		p-page5   = ""
		p-page6   = "". 

	  display 
	   p-name   
		p-prev   
		p-next
		p-isonbr  
		p-isover   
		p-desc1    
		p-desc2 
		p-desc3 
		p-desc4 
		p-desc5 
		p-train1  
		p-train2  
		p-train3  
		p-train4  
		p-train5
		p-page1  
		p-page2  
		p-page3  
		p-page4  
		p-page5  
		p-page6  
	with frame a.

	   end.
	end.
	else do: /*f5*/

	display    
		p-name   
		p-prev   
		p-next
		p-isonbr  
		p-isover   
		p-desc1    
		p-desc2 
		p-desc3 
		p-desc4 
		p-desc5 
		p-train1  
		p-train2  
		p-train3  
		p-train4  
		p-train5
		p-page1  
		p-page2  
		p-page3  
		p-page4  
		p-page5  
		p-page6  
	with frame a.


	     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain 
			    and xdn_site = p-site 
			    and xdn_ordertype = p-ordertype
			    and xdn_type = p-type 
			    no-error.
		 if not available xdn_ctrl then do:  
		    create xdn_ctrl.
		    assign                     
		    xdn_domain = global_domain 
		    xdn_site = upper(p-site) 
		    xdn_ordertype = upper(p-ordertype)
		    xdn_type   = upper(p-type)        
		    xdn_prev   = upper(p-prev)        
		    xdn_name   = p-name        
		    xdn_next   = p-next
		    xdn_isonbr =  p-isonbr  
		    xdn_isover =  p-isover 
		    xdn_desc1  =  p-desc1   
		     xdn_desc2  =  p-desc2
		     xdn_desc3  =  p-desc3   
		     xdn_desc4  =  p-desc4 
		     xdn_desc5  =  p-desc5    
		    xdn_train1 =  p-train1  
		    xdn_train2 =  p-train2  
		    xdn_train3 =  p-train3  
		    xdn_train4 =  p-train4  
		    xdn_train5 =  p-train5 
		    xdn_page1 =  p-page1  
		    xdn_page2 =  p-page2  
		    xdn_page3 =  p-page3  
		    xdn_page4 =  p-page4 
		    xdn_page5 =  p-page5 
		    xdn_page6 =  p-page6 .
		    
		 end.
		 else do:

		 assign
		     xdn_domain = global_domain 
		     xdn_site = upper(p-site) 
		     xdn_ordertype = upper(p-ordertype)
		     xdn_type   = upper(p-type)        
		     xdn_prev   = upper(p-prev) 
		     xdn_name   = p-name        
		     xdn_next   = p-next
		     xdn_isonbr =  p-isonbr  
		     xdn_isover =  p-isover 
		     xdn_desc1  =  p-desc1   
		     xdn_desc2  =  p-desc2
		     xdn_desc3  =  p-desc3   
		     xdn_desc4  =  p-desc4 
		     xdn_desc5  =  p-desc5   
		     xdn_train1 =  p-train1  
		     xdn_train2 =  p-train2  
		     xdn_train3 =  p-train3  
		     xdn_train4 =  p-train4  
		     xdn_train5 =  p-train5 
		     xdn_page1 =  p-page1  
		     xdn_page2 =  p-page2  
		     xdn_page3 =  p-page3  
		     xdn_page4 =  p-page4 
		     xdn_page5 =  p-page5 
		     xdn_page6 =  p-page6 .      
		 end.
	end. /*f5*/
	leave.
	end.
end. /*mainloop*/

    status input.
