/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */

/* DISPLAY TITLE */
 {mfdeclre.i}
 {gplabel.i}
 {xxrevar03.i}

define variable mm as integer format ">>9".
define variable issued as character format "x(12)" extent 4 initial "____________".
define variable page-start as integer .

define variable xdnname      like xdn_name.
define variable xdnisonbr    like xdn_isonbr.
define variable xdnisover    like xdn_isover.
define variable xdntrain1    like xdn_train1 .
define variable xdntrain2    like xdn_train2 .
define variable xdntrain3    like xdn_train3 .
define variable xdntrain4    like xdn_train4 .
define variable xdntrain5    like xdn_train5 .
define variable xdnpage1    like xdn_page1 .
define variable xdnpage2    like xdn_page2 .
define variable xdnpage3    like xdn_page3 .
define variable xdnpage4    like xdn_page4 .
define variable xdnpage5    like xdn_page5 .
define variable xdnpage6    like xdn_page6 .

   {xxrepk03.i}
 /*ss-min001*add mage *************************************************/
 find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr =
  global_domain and ad_type = "company"  no-error.

   if available ad_mstr
   then companyname = ad_name. else companyname = "西铁城".

find first xdn_ctrl   
					where xdn_ctrl.xdn_domain = global_domain 
					and xdn_ordertype = v_ordertype
					and xdn_type = p-type 	
no-lock no-error.
	if available xdn_ctrl then do:
	   xdntrain1 = xdn_train1.
	   xdntrain2 = xdn_train2.
	   xdntrain3 = xdn_train3.
	   xdntrain4 = xdn_train4.
	   xdntrain5 = xdn_train5.
	   xdnpage1 = xdn_page1.
	   xdnpage2 = xdn_page2.
	   xdnpage3 = xdn_page3.
	   xdnpage4 = xdn_page4.
	   xdnpage5 = xdn_page5.
	   xdnpage6 = xdn_page6.
	   xdnname   = xdn_name.
	   xdnisonbr = xdn_isonbr.
	   xdnisover = xdn_isover.
	  
	end. 
	else do:
		message "单据格式没有设置, 请重新设置后再打印!!"  view-as alert-box.
		undo, retry.
	end.
/*ss-min001*add mage *************************************************/
   view frame phead1.
   mm = 1.
   page-start = 1.
   for each xxld_tmp where xxld_qty <> 0 no-lock   with frame c down width 132 no-box:
                  if page-size - line-counter < 6 then do:
   	             do while page-size - line-counter > 5:
		        put skip(1).                       
		     end.                                  
                     put "-----------------------------------------------------------------------------------------------------------------------------------" at 1.
	                 put skip(1).                                                             
         	       
		     if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> "" and xdntrain5 <> "" then do: 
         	     put xdntrain1    format "x(16)"   at  1.                                    
         	     put xdntrain2    format "x(16)"                 at 20.   
		     put xdntrain3    format "x(16)"                 at 40.
		     put xdntrain4    format "x(16)"                 at 60.
		     put xdntrain5    format "x(16)"                 at 80.
		     end.
		     else  if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> ""  then do:
                     put xdntrain1   format "x(16)"                 at  1.                                    
         	     put xdntrain2   format "x(16)"                  at 25.   
		     put xdntrain3   format "x(16)"                  at 50.
		     put xdntrain4   format "x(16)"                  at 75.
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> ""   then do:
                     put xdntrain1   format "x(16)"                 at  1.                                    
         	     put xdntrain2   format "x(16)"                  at 30.   
		     put xdntrain3   format "x(16)"                  at 60.
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> ""    then do:
                     put xdntrain1  format "x(16)"                  at  1.                                    
         	     put xdntrain2  format "x(16)"                   at 40.   
		     end.
		     		     put skip(0).
		  		     if xdnpage1 <>   "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""  and xdnpage6 <> "" then do: 
	 	     put "第一联:"          at 1  xdnpage1  format "x(8)"   .
		     put "第二联:"          at 15 xdnpage2  format "x(8)"   .
		     put "第三联:"         at  30 xdnpage3  format "x(8)"   .
		     put "第四联:"         at  45 xdnpage4  format "x(8)"   . 
		     put "第五联:"         at  60 xdnpage5  format "x(8)"   .
		     put "第六联:"         at  75 xdnpage6   format "x(8)" . 
		     end.
                       else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""   then do: 
	 	     put "第一联:"   at 1  xdnpage1  format "x(12)" .
		     put "第二联:"   at 20 xdnpage2  format "x(12)" .
		     put "第三联:"   at 40 xdnpage3  format "x(12)" .
		     put "第四联:"   at 60 xdnpage4  format "x(12)" . 
		     put "第五联:"   at 80 xdnpage5  format "x(12)" . 
		     end. 
                      else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> ""   then do: 
	 	     put "第一联:"        at 1  xdnpage1     format "x(14)".
		     put "第二联:"       at 25 xdnpage2     format "x(14)". 
		     put "第三联:"       at 50 xdnpage3     format "x(14)".
		     put "第四联:"       at 75 xdnpage4     format "x(14)". 
		     end.				     
		     else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> ""  then do: 
	 	     put "第一联:"           at 1  xdnpage1     format "x(18)".
		     put "第二联:"          at 30 xdnpage2     format "x(18)" .
		     put "第三联:"          at 60 xdnpage3     format "x(18)" .
		     end.
		     else if xdnpage1 <> "" and xdnpage2 <> ""  then do: 
	 	     put "第一联："   at 1    xdnpage1     format "x(18)" .
		     put "第二联："  at 40  xdnpage2     format "x(18)".
		     end.
 		     put "Page: " at 117 string(page-start) format "xxxx".
		     page-start = page-start + 1.
		     page.
		  end.
       display 
           mm          label "项次"
	   xxld_part   label "零件号码"
	   xxld_desc   label "说明"
	   xxld_desc2  label "规格"
	   xxld_qty_oh label "库存量"
	   xxld_loc    label "库位"
	   xxld_qty    label "领料数量"
	   "" @ issued[1] label "实发1" 
	   with frame c. 
	   display  "-----------------------------------------------------------------------------------------------------------------------------------" at 1
	        with frame c.     		
	   mm = mm + 1.
      {mfrpchk.i}
   end. /* FOR EACH ld_det ... */

   	do while page-size - line-counter > 4:
	   put skip(1).
	end.
                     put "-----------------------------------------------------------------------------------------------------------------------------------" at 1.
	                 put skip(1).                                                             
         	       
		     if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> "" and xdntrain5 <> "" then do: 
         	     put xdntrain1    format "x(16)"   at  1.                                    
         	     put xdntrain2    format "x(16)"                 at 20.   
		     put xdntrain3    format "x(16)"                 at 40.
		     put xdntrain4    format "x(16)"                 at 60.
		     put xdntrain5    format "x(16)"                 at 80.
		     end.
		     else  if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> ""  then do:
                     put xdntrain1   format "x(16)"                 at  1.                                    
         	     put xdntrain2   format "x(16)"                  at 25.   
		     put xdntrain3   format "x(16)"                  at 50.
		     put xdntrain4   format "x(16)"                  at 75.
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> ""   then do:
                     put xdntrain1   format "x(16)"                 at  1.                                    
         	     put xdntrain2   format "x(16)"                  at 30.   
		     put xdntrain3   format "x(16)"                  at 60.
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> ""    then do:
                     put xdntrain1  format "x(16)"                  at  1.                                    
         	     put xdntrain2  format "x(16)"                   at 40.   
		     end.
		     		     put skip(0).
		    		     if xdnpage1 <>   "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""  and xdnpage6 <> "" then do: 
	 	     put "第一联:"          at 1  xdnpage1  format "x(8)"   .
		     put "第二联:"          at 15 xdnpage2  format "x(8)"   .
		     put "第三联:"         at  30 xdnpage3  format "x(8)"   .
		     put "第四联:"         at  45 xdnpage4  format "x(8)"   . 
		     put "第五联:"         at  60 xdnpage5  format "x(8)"   .
		     put "第六联:"         at  75 xdnpage6   format "x(8)" . 
		     end.
                       else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""   then do: 
	 	     put "第一联:"   at 1  xdnpage1  format "x(12)" .
		     put "第二联:"   at 20 xdnpage2  format "x(12)" .
		     put "第三联:"   at 40 xdnpage3  format "x(12)" .
		     put "第四联:"   at 60 xdnpage4  format "x(12)" . 
		     put "第五联:"   at 80 xdnpage5  format "x(12)" . 
		     end. 
                      else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> ""   then do: 
	 	     put "第一联:"        at 1  xdnpage1     format "x(14)".
		     put "第二联:"       at 25 xdnpage2     format "x(14)". 
		     put "第三联:"       at 50 xdnpage3     format "x(14)".
		     put "第四联:"       at 75 xdnpage4     format "x(14)". 
		     end.				     
		     else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> ""  then do: 
	 	     put "第一联:"           at 1  xdnpage1     format "x(18)".
		     put "第二联:"          at 30 xdnpage2     format "x(18)" .
		     put "第三联:"          at 60 xdnpage3     format "x(18)" .
		     end.
		     else if xdnpage1 <> "" and xdnpage2 <> ""  then do: 
	 	     put "第一联："   at 1    xdnpage1     format "x(18)" .
		     put "第二联："  at 40  xdnpage2     format "x(18)".
		     end.
 		   put "Page: " at 117 string(page-start) format "xxxx".
		   put "(END)".
		   page-start = 1.
