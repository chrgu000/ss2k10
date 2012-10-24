/** yyppifim01.p 1.4.17 **/
/***xxppif__chr01 1:资料检验 2:Item ADD 3:Item Change 4:BOM ADD 5:BOM Change 6:BOM Code Create 7:Item Del **/
/*** item_type   1.发动机总成
								 2.八大件(自制件)
								 3.组号或虚件
								 4.协配件(采购件)
								 5.机型(F件)
								 6.随机件
								 7.套件(C件) ***********/
/* Last change by Wilber 03/21/2008  mantainence 1.4.17 whenever PDIA or PDIC    SO *W001*/
/* Last change by Wilber 03/24/2008        *W002*/
/* Last change by Wilber 03/31/2008        *W003*/

{ xxppifdef.i }   
def var item_type as char.
def var item_status as char.
def var item_phantom as char.
def var item_pm_code as char.
def var item_group as char.
/*J001*/ def var exec_part 	like pt_part.
/*J001*/ def var i_exec 		as integer.

        strinputfile    = filepath + "\" + "ppifi02.tmp".
        stroutputfile   = filepath + "\" + "ppifiout02.tmp".      


 /*W002 begin*/


        output stream batchdata to value(strinputfile) no-echo.    
 
        put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"" skip.
        put stream batchdata unformatted "~"yypppsmt02-1.p~"" skip.   /*1.4.17*/
        		for each xxppif_log where xxppif_domain = global_domain 
        				 and lookup(xxppif_tr_code,"PDIA,SOIA,PDIC,SOIC") > 0
        		     and xxppif_err <> 2        		                      
        		     and substr(xxppif__chr01,1,1) = "1"
                 and  substr(xxppif__chr01,2,1) <> "2":
/*for each xxppif_log where xppif_domain = global_domain 
			 and lookup(xxppif_tr_code,"PDIA,SOIA,PDIC,SOIC") > 0
       and xxppif_err <> 2        		                      
       and substr(xxppif__chr01,1,1) = "1":
 /*W001*/                          /*  and substr(xxppif__chr01,2,1) = "1"*/
    /*PAUSE .
    DISP xxppif_log . */

        output stream batchdata to value(strinputfile) no-echo.    
	/*no-error process*/
	if error-status:error then do:
		output stream batchdata close .
		output stream batchdata to value(strinputfile) no-echo.
	end.
 
        put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"" skip.
        put stream batchdata unformatted "~"yypppsmt02-1.p~"" skip.   /*1.4.17*/
     */   	
 /*W002 end*/
	i_exec = 0.
	 repeat:
		 i_exec = i_exec + 1.
		 if i_exec >= 3 then leave.

/*W003	 if i_exec = 1  then exec_part = exec_part.  */
        if i_exec = 1  then exec_part = trim(substring(xxppif_content,12,12)).
		 if i_exec = 2  then do:
			 exec_part = xxppif_part.										
			 if lookup(xxppif_tr_code,"PDIA") > 0 then exec_part = trim(substr(xxppif_content,81,18)).
			 if lookup(xxppif_tr_code,"SOIA") > 0 then exec_part = trim(substr(xxppif_content,64,18)).
			 if exec_part = "" then next.
		 end.
          
         /*    /** Check exist Item error**/
        	 find pt_mstr where pt_domain = global_domain and 
        	 		  pt_part = exec_part no-lock no-error.
        	 if not avail pt_mstr then do:
        		 xxppif_msg = "2029-" + exec_part.
			 xxppif_err = 2.
        		 next.
        	 end.*/
		 if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
            /** Make/Buy **/            
			 strTmp = "".
			  find first code_mstr no-lock where code_domain = global_domain and
			  				   code_fldname = "52" and 
			  				   code_value = substring(xxppif_content,52,1) 
			  		 use-index code_fldval no-error.
			   if available code_mstr then do:
			      /*code_cmmt . yes代表采购件 G*/
			      if code_cmmt = "yes" then do:
				 strTmp = "P".
			      end.
			      else do: /*no 代表自制件*/
				 strTmp = "M".
			      end.
			   end.
                           item_pm_code = strTmp.
			   if item_pm_code = "" then do:
			      xxppif_err = 2.
			      xxppif_msg = "2008-" + strTmp.
			      next.
			   end.
            /** Phantom **/   
            		  strTmp = "".
			   find first code_mstr no-lock where code_domain = global_domain 
			   			  and code_fldname = "51" 
			   			  and code_value = substring(xxppif_content,51,1)
			   use-index code_fldval no-error.
			   if available code_mstr then do:
			      if code_cmmt = "yes" then do:
				 strTmp = "P".  /*虚件P*/
			      end.
			      else do: /*no 代表实件*/
				 strTmp = "S".
			      end.
			   end.
  /*W001*/
			   /*ID(pt_pt_type ) = 17,74,77,79  mantanence in code ID_CODE     if substring(xxppif_content,24,2) in them ,then phantom    */

               
/*W003*/       find first code_mstr no-lock where code_domain = global_domain 
											and code_fldname = "ID_CODE" 
/*W003*/              and code_value = substring(xxppif_content,24,2) 
										  and code_cmmt = "y" use-index code_fldval no-error.
 /*W003*/      if available code_mstr then do:
/*W001*/              ITEM_pm_code = "M" .        /*强制改为M*/
                      strTmp = "P".  /*虚件P*/
               END.
			   
/*W003   		   
			   ELSE DO:
			       xxppif_err = 2.
			      xxppif_msg = "2053-" + strTmp.
			      next.

			   END.*/ 
/*W001*/
			   item_phantom = strTmp.
			   
			   if item_phantom = "" then do:
			      xxppif_err = 2.
			      xxppif_msg = "2007-" + strTmp.
			      next.
			   end.


		end. /* end lookup(xxppif_tr_code,"PDIA,PDIC") > 0 */     
		
		 strTmp = "".
		 /** 产品组变换 ***/
		 if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
			 if item_pm_code = "M" then do:
				 if item_phantom = "P" then do:  /*虚件*/
					 strTmp = "O".								         
				 end.
				 if item_phantom = "S" then do:  /*实件*/
					 strTmp = "M".								         
				 end.
			 end.
			 if item_pm_code = "P" then do:         
				    strTmp = "RAW".
			 end. 
		 end.
                if lookup(xxppif_tr_code,"SOIA,SOIC") > 0 then do:
                   strTmp = "58B".
                   item_phantom = "S".
                   item_pm_code = "M".
                end.
                item_group = strTmp.
                item_type = "".
                if lookup(item_group,"58,58A,58B,58Z") > 0 and item_pm_code = "M" and item_phantom = "S" then item_type = "1". /* 1.发动机总成*/
                if lookup(item_group,"M") > 0 and item_pm_code = "M" and item_phantom = "S" then item_type = "2". /*2.八大件(自制件)*/
		if lookup(item_group,"O,Ph") > 0 and item_pm_code = "M" and item_phantom = "P" then item_type = "3". /*3.组号或虚件*/
		if lookup(item_group,"RAW") > 0 and item_pm_code = "P" and item_phantom = "S" then item_type = "4". /*4.协配件(采购件)*/
		if lookup(item_group,"ZZ") > 0 and item_pm_code = "F" and item_phantom = "S" then item_type = "5". /*5.机型(F件)*/
		if lookup(item_group,"Ph") > 0 and item_pm_code = "M" and item_phantom = "P" then item_type = "6". /*6.随机件*/
            
           /** check description length warning**/
            /*check the item_type if defined in the bom*/
/*W003*/           if lookup(item_type,"1,2,3,4,5") = 0 then do:
/*W003*/			     xxppif_err = 2.
/*W003*/			    xxppif_msg = "2040-" + exec_part + item_pm_code + string(item_phantom).
/*W003*/   		          next.		
/*W003*/	         end.
                if lookup(item_type,"1,2,3,4,5") > 0 then do:
                   /* DCEC-C*/
                    
                   put stream batchdata unformatted "~"" exec_part format "x(16)" "~" ".
                   put stream batchdata unformatted "~"" site-c "~"" skip.
                   put stream batchdata unformatted "~"" item_pm_code "~" ".
                   put stream batchdata unformatted "- ".
                   if item_phantom = "P" then put stream batchdata unformatted "Y ".
                   else put stream batchdata unformatted "N ".   /*Phantom*/
                   if lookup(item_type,"1,2,3,5") > 0 then do:
                      put stream batchdata unformatted "~"" exec_part "~" ".
                      put stream batchdata unformatted "~"" exec_part "~" ".
                   end.
                   else do:
                      put stream batchdata unformatted "~""  "~" ".
                      put stream batchdata unformatted "~""  "~" ".
                   end.
                   put stream batchdata unformatted skip.
                   /* DCEC-B */
                   if lookup(item_type,"3") > 0 then do:
                      strTmp = exec_part.
                      find first ptp_det  where ptp_domain = global_domain 
                      			 and ptp_part = exec_part 
                      			 and ptp_site = SITE-B no-error.
                      if avail ptp_det then do:
                         delete ptp_det.
                         xxppif_err = 1.
                         xxppif_msg = "1004-" + strTmp.
                      end.
                 end.  /*end for lookup(item_type,"1,2,3,4,5")*/
                 else do:
                       put stream batchdata unformatted "~"" exec_part format "x(16)" "~" ".
                       put stream batchdata unformatted "~"" site-b "~"" skip.
                       put stream batchdata unformatted "~"" item_pm_code "~" ".
                       put stream batchdata unformatted "- ".
                       if item_phantom = "P" then put stream batchdata unformatted "Y ".
                       else put stream batchdata unformatted "N ".   /*Phantom*/
                       if lookup(item_type,"1,5") > 0 then do:  
                          put stream batchdata unformatted "~"" exec_part "ZZ~" ".
                          put stream batchdata unformatted "~"" exec_part "ZZ~" ".
                       end.   
                       else if lookup(item_type,"2") > 0 then do: 
                          put stream batchdata unformatted "~"" exec_part "~" ".
                          put stream batchdata unformatted "~"" exec_part "~" ".                          
                       end.
                       else if lookup(item_type,"4") > 0 then do: 
                          put stream batchdata unformatted "~""  "~" ".
                          put stream batchdata unformatted "~""  "~" ".                          
                       end.
                       put stream batchdata unformatted skip.
                  end. /*else do end*/
                   
                  if lookup(item_type,"2") > 0 then do:
                       strTmp = exec_part.
/*W001                 find first ps_mstr no-lock where ps_domain = global_domain
											        and ps_par = strTmp and ps_comp <> ""  no-error.
                       if avail ps_mstr then do:
                          xxppif_err = 3.
                          xxppif_msg = "3001-" + strTmp.
                       end.
W001 */
                   end.
                   if lookup(item_type,"3") > 0 then do:
                      strTmp = exec_part.
                      find first ps_mstr no-lock where ps_domain = global_domain 
                      			 and ps_par = strTmp and ps__chr01 = site-c  no-error. 
                      if avail ps_mstr then do:
                         strTmp = exec_part + "ZZ".
                         find first ps_mstr no-lock where ps_domain = global_domain 
                         				and ps_par = strTmp and ps__chr01 = site-b  no-error. 
                         if not avail ps_mstr then do:
                             xxppif_err = 3.
                             xxppif_msg = "3002-" + strTmp.
                         end.
                      end.
                   end.
                   if lookup(item_type,"4") > 0 then do:
                       strTmp = exec_part.
                       find first ps_mstr no-lock where ps_domain = global_domain 
                       			  and ps_par = strTmp and ps_comp <> ""  no-error.
                       if avail ps_mstr then do:
                          xxppif_err = 3.
                          xxppif_msg = "3003-" + strTmp.
                       end.
                   end.
                   
                end.  /* end lookup(item_type,"1,2,3,4,5") > 0*/
                
                if xxppif_err = 99 then xxppif_err = 0.                
                substr(xxppif__chr01,2,1) = "2".
              end.
        		
     /*W002 begin*/

              end.         /*end lookup(xxppif_tr_code,"PDIA,SOIA,PDIC,SOIC") > 0 */
           /* */

     /*W002 end*/
        put stream batchdata unformatted "." at 1.
        put stream batchdata unformatted "." at 1.
        put stream batchdata unformatted "~"Y~"" at 1.
        output stream batchdata  close.
        
        INPUT CLOSE.
        output to value(stroutputfile) .
	 
        INPUT from value(strinputfile).
        
        PAUSE 0 BEFORE-HIDE.
        RUN MF.P.
        INPUT CLOSE.
        OUTPUT CLOSE.
     /*W002 begin*/

    /* end.   */      /*end lookup(xxppif_tr_code,"PDIA,SOIA,PDIC,SOIC") > 0 */
     /*W002 end*/
