/* ss - 100611.1 by: jack */
/* DISPLAY TITLE */
/* ss - 100423.1 by: jack */
/* ss - 100714.1 by: jack */
 {mfdeclre.i}
 {gplabel.i}

 {xxricrt1var1.i}

define variable mm as integer format ">>9".
define variable page-start as integer .
define variable desc1 LIKE pt_desc1 .
DEFINE VAR v_desc1 LIKE pt_desc1 .
DEFINE BUFFER ptmstr FOR  pt_mstr .

/*ss-min001*/  define variable companyname  as char format "x(28)".
/*ss-min001*/  define variable xdnname      like xdn_name.
/*ss-min001*/  define variable xdnisonbr    like xdn_isonbr.
/*ss-min001*/  define variable xdnisover    like xdn_isover.
/*ss-min001*/  define variable xdntrain1    like xdn_train1 .
/*ss-min001*/  define variable xdntrain2    like xdn_train2 .
/*ss-min001*/  define variable xdntrain3    like xdn_train3 .
/*ss-min001*/  define variable xdntrain4    like xdn_train4 .
/*ss-min001*/  define variable xdntrain5    like xdn_train5 .
/*ss-min001*/  define variable xdnpage1    like xdn_page1 .
/*ss-min001*/  define variable xdnpage2    like xdn_page2 .
/*ss-min001*/  define variable xdnpage3    like xdn_page3 .
/*ss-min001*/  define variable xdnpage4    like xdn_page4 .
/*ss-min001*/  define variable xdnpage5    like xdn_page5 .
/*ss-min001*/  define variable xdnpage6    like xdn_page6 .
/* ss - 100423.1 -b */
DEFINE VAR v_rsn AS CHAR .
DEFINE VAR v_method AS CHAR FORMAT "x(12)" .
/* ss - 100423.1 -e */

   {xxricrt1.i}
 find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr =
  global_domain and ad_type = "company"  no-error.

   if available ad_mstr
      then companyname = ad_name. else companyname = "贝尔莱德".

     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "RT"  no-lock no-error.
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
        	message "退料单格式没有设置, 请重新设置后再打印!!"  .
        	undo, retry.
    	end.
   
        /* ss - 100623.1 -b */
        FIND FIRST xxrt_det  NO-LOCK WHERE xxrt_domain = GLOBAL_domain AND xxrt_nbr = rcvno  NO-ERROR .
        IF AVAILABLE xxrt_det  THEN  DO:
            v_rsn = xxrt_rsn .
            FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "xxrt"
                AND CODE_value = xxrt_method NO-LOCK NO-ERROR .
            IF AVAILABLE CODE_mstr  THEN
            v_method = CODE_cmmt .
        END.
     
        view frame phead1.
       mm = 1.
       page-start = 1.
   
 for each xxrt_det  no-lock where xxrt_det.xxrt_domain = global_domain and xxrt_nbr = rcvno use-index xxrt_line ,
   each pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xxrt_wodpart 
   with frame c down width 85 no-box:
   
    if mm = 1 then do:
            find first loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = xxrt_site_from
             and loc_loc = xxrt_loc_from no-lock no-error.
            if available loc_mstr then assign prodline = loc_loc
                                             proddesc = loc_desc.
             else assign prodline = xxrt_loc_from 
                                       proddesc = "".
             PUT "工单/ID           零件号码      描述                          数量     实退           批号         备注"  AT 1 .
             PUT "--------------------------------------------------------------------------------------------------------" AT 1 .

              view frame phead1.  
              
    end.
    
     /*  view frame phead1.  */
   

   desc1 = pt_desc1  + "  " + pt_desc2  .

   /* ss - 100622.1 -b
   FIND FIRST ptmstr WHERE ptmstr.pt_domain = GLOBAL_domain AND ptmstr.pt_part = xxrt_wopart NO-LOCK NO-ERROR .
   IF AVAILABLE ptmstr THEN
       v_desc1 = ptmstr.pt_desc1 .
   ELSE 
       v_desc1 = "" .
     ss - 100622.1 -e  */
 
   if page-size - line-counter < 3  /* 10 */ THEN do:
  
    /*    put "--------------------------------------------------------------------------------------------------------" at 1. */
	             put skip(1).                                                             
         	       
		       if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> "" and xdntrain5 <> "" then do: 
         	     PUT "物料员:"     AT 1 .
                 put xdntrain1    format "x(16)"   at  15.                                    
         	     put xdntrain2    format "x(16)"                 at 32.   
    		     put xdntrain3    format "x(16)"                 at 48.
    		     put xdntrain4    format "x(16)"                 at 64.
    		     put xdntrain5    format "x(16)"                 at 80 .
                
		     end.
		     else  if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> ""  then do:
                     PUT "物料员:"     AT 1 .
                     put xdntrain1    format "x(16)"   at  15.                                    
                     put xdntrain2    format "x(16)"                 at 32.   
                     put xdntrain3    format "x(16)"                 at 48.
                     put xdntrain4    format "x(16)"                 at 64.
    		    
                     
           
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> ""   then do:
                       PUT "物料员:"     AT 1 .
                      put xdntrain1    format "x(16)"   at  15.                                    
             	     put xdntrain2    format "x(16)"                 at 32.   
        		     put xdntrain3    format "x(16)"                 at 48.
    		 
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> ""    then do:
                      PUT "物料员:"     AT 1 .
                       put xdntrain1    format "x(16)"   at  15.                                    
         	           put xdntrain2    format "x(16)"                 at 32.   
    		    
                    
		     end.
		     		     put skip(0).
		   		     if xdnpage1 <>   "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""  and xdnpage6 <> "" then do: 
             PUT "制单人:"      AT 1 .
	 	    put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
             /*
		     put "第四联:"         at  45 xdnpage4  format "x(8)"   . 
		     put "第五联:"         at  60 xdnpage5  format "x(8)"   .
		     put "第六联:"         at  75 xdnpage6   format "x(8)" . 
             */
              
		     end.
                       else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""   then do: 
	 	     PUT "制单人:"      AT 1 .
	 	     put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
		     end. 
                      else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> ""   then do: 
	 	    PUT "制单人:"      AT 1 .
	 	     put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
       
		     end.				     
		     else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> ""  then do: 
	 	     PUT "制单人:"      AT 1 .
	 	      put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
      
		     end.
		     else if xdnpage1 <> "" and xdnpage2 <> ""  then do: 
	 	     PUT "制单人:"      AT 1 .
	 	       put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     
		    
     
		     end.
	   put "Page: "    at 65  string(page-start) format "xxxx".
	   page-start = page-start + 1.
        
    /*   PUT SKIP(2) . */
       PAGE .
  
     
       end.
        
     PUT xxrt_wonbr    + "/" + xxrt_wolot  FORMAT "x(14)"  AT 1 .
     put xxrt_wodpart    FORMAT "x(14)" AT 18 .
      put desc1  FORMAT "x(30)" AT 32 .
     put  string(xxrt_qty_from ) AT 63  .
     PUT xxrt_lot_from  AT 85 .
     PUT xxrt_dept  AT 97.
    
     

     put "--------------------------------------------------------------------------------------------------------" at 1 . 


  
     
	   mm = mm + 1.
      {mfrpchk.i}
   end. /* FOR EACH ld_det ... */

 
      /* ss - 100714.1 -b
      /* ss - 100423.1 -b */
    do while PAGE-SIZE - line-counter > 9  :
	   put skip(1).
	end.
/* ss - 100423.1 -e */  
ss - 100714.1 -e */
      /* ss - 100714.1 -b */
      PUT SKIP(PAGE-SIZE - LINE-COUNTER - 4 ) .
      /* ss - 100714.1 -e */
  /*   put "--------------------------------------------------------------------------------------------------------" at 1. */
	             put skip(1).                                                             
         	       
		      if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> "" and xdntrain5 <> "" then do: 
         	        PUT "物料员:"     AT 1 .
                 put xdntrain1    format "x(16)"   at  15.                                    
         	     put xdntrain2    format "x(16)"                 at 32.   
    		     put xdntrain3    format "x(16)"                 at 48.
    		     put xdntrain4    format "x(16)"                 at 64.
    		    put xdntrain5    format "x(16)"                 at 80 . 
                
		     end.
		     else  if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> "" and xdntrain4 <> ""  then do:
                     PUT "物料员:"     AT 1 .
                      put xdntrain1    format "x(16)"   at  15.                                    
         	     put xdntrain2    format "x(16)"                 at 32.   
    		     put xdntrain3    format "x(16)"                 at 48.
    		     put xdntrain4    format "x(16)"                 at 64.
    		    
                     
           
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> "" and xdntrain3 <> ""   then do:
                       PUT "物料员:"     AT 1 .
                      put xdntrain1    format "x(16)"   at  15.                                    
             	     put xdntrain2    format "x(16)"                 at 32.   
        		     put xdntrain3    format "x(16)"                 at 48.
    		 
		     end.	       
		     else if xdntrain1 <> "" and xdntrain2 <> ""    then do:
                      PUT "物料员:"     AT 1 .
                       put xdntrain1    format "x(16)"   at  15.                                    
         	           put xdntrain2    format "x(16)"                 at 32.   
                    
		     end.
		     		     put skip(0).
		    		    if xdnpage1 <>   "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""  and xdnpage6 <> "" then do: 
             PUT "制单人:"      AT 1 .
	 	     put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
             /*
		     put "第四联:"         at  45 xdnpage4  format "x(8)"   . 
		     put "第五联:"         at  60 xdnpage5  format "x(8)"   .
		     put "第六联:"         at  75 xdnpage6   format "x(8)" . 
             */
              
		     end.
                       else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> "" and xdnpage5 <> ""   then do: 
	 	    PUT "制单人:"      AT 1 .
	 	       put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
		     end. 
                      else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> "" 
		       and xdnpage4 <> ""   then do: 
	 	    PUT "制单人:"      AT 1 .
	 	     put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
       
		     end.				     
		     else if xdnpage1 <> "" and xdnpage2 <> "" and xdnpage3 <> ""  then do: 
	 	     PUT "制单人:"      AT 1 .
	 	      put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     put "蓝色联:"         at  50 xdnpage3  format "x(8)"   .
      
		     end.
		     else if xdnpage1 <> "" and xdnpage2 <> ""  then do: 
	 	     PUT "制单人:"      AT 1 .
	 	       put "白色联:"          at 11  xdnpage1  format "x(8)"   .
		     put "红色联:"          at 30 xdnpage2  format "x(8)"   .
		     
		    
     
		     end.
             
	   put "Page: "    at 65 string(page-start) format "xxxx". 
	    put "(END)" . 
	   page-start =  1.
