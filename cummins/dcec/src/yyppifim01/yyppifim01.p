/** yyppifim02.p 1.4.17 ppptmt04.p CIM_LOAD out of ERP**/
/***xxppif__chr01 1:资料检验 2:Item ADD 3:Item Change 4:BOM ADD 5:BOM Change 6:BOM Code Create 7:Item Del **/
/*** item_type   1.发动机总成
								 2.八大件(自制件)
								 3.组号或虚件
								 4.协配件(采购件)
								 5.机型(F件)
								 6.随机件
								 7.套件(C件) ***********/
                                 
/* Last change by Wilber 03/21/2008  automatically new a  QAD item when having no such Item when PDIC    SO *W001*/
/* Last change by Wilber 03/31/2008      SO *W002*/
/* Last change by Wilber 04/01/2008      SO *W003*/
/* Last change by Wilber 06/16/2008     leave the former status when PDIA SOSI *W004*/
/*  session:date-format = 'ymd'.                      */
{mfdeclre.i "new global"}                        
{mf1.i "new global"}                             
                                                 
base_curr = "RMB".                               
IF global_userid = "" THEN global_userid = "MFG".
mfguser="".                                      
global_user_lang = "ch".                         
global_user_lang_dir = "ch/".                    
global_domain = "DCEC".                          

{ xxppifdef.i }   
def var item_type as char.
def var item_status as char.
def var item_phantom as char.
def var item_pm_code as char.
/*J001*/ def var exec_part 	like pt_part.
/*J001*/ def var i_exec 		as integer.

        strinputfile    = filepath + "\" +  "ppifi01.tmp".
        stroutputfile   = filepath + "\" + "ppifiout01.tmp".      

/*W002 begin*/
        
        output stream batchdata to value(strinputfile) no-echo.    

/*     put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"".  */
/*     put stream batchdata unformatted "-" at 1 skip.                          */
/*     put stream batchdata unformatted "~"yyppptmt04-2.p~"" at 1.   /*1.4.3*/  */
        		for each xxppif_log where xxppif_domain = global_domain 
        		    and lookup(xxppif_tr_code,"PDIC,SOIC,PDIA,SOIA") > 0        		                      
        		    and xxppif_err <> 2
        		    and substr(xxppif__chr01,1,1) = "1"
        		    and substr(xxppif__chr01,3,1) = "0"
                and substr(xxppif__chr01,2,1) = "0":
                    /*PAUSE .
                    DISP xxppif_log .*/
                                      
/*for each xxppif_log where xxppif_domain = global_domain 
            and lookup(xxppif_tr_code,"PDIC,SOIC") > 0        		                      
            and xxppif_err <> 2
            and substr(xxppif__chr01,1,1) = "1"
            and substr(xxppif__chr01,3,1) = "0"
			      and substr(xxppif__chr01,2,1) = "0":


        output stream batchdata to value(strinputfile) no-echo.    
	/*no-error process*/
    if error-status:error then do:
		output stream batchdata close .
		output stream batchdata to value(strinputfile) no-echo.
	end. 

        put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"".
        put stream batchdata unformatted "~"yyppptmt04-2.p~"" at 1.   /*1.4.3*/
*/
/*W002 end*/                    
        		    
	i_exec = 0.
	repeat:
		 i_exec = i_exec + 1.
		if i_exec >= 3 then leave.
/*W002	 if i_exec = 1  then exec_part = exec_part.  */
        if i_exec = 1  then exec_part = trim(substring(xxppif_content,12,12)).
        if i_exec = 2  then do:
			exec_part = xxppif_part.							
	                if lookup(xxppif_tr_code,"PDIA") > 0 then exec_part = trim(substr(xxppif_content,81,18)).
			if lookup(xxppif_tr_code,"SOIA") > 0 then exec_part = trim(substr(xxppif_content,64,18)).
			if exec_part = "" then next.
	         end.
								
        	/** Check exist Item error**/
/*W004		if lookup(xxppif_tr_code,"PDIC,SOIC") > 0 then do:			 */   	
/*W004	*/  if lookup(xxppif_tr_code,"PDIC,SOIC,PDIA,SOIA") > 0 then do:           
			 find pt_mstr where pt_domain = global_domain and pt_part = exec_part no-lock no-error.
			 if not avail pt_mstr  then do:
				if trim(substring(xxppif_content,81,16)) = "" then do:
/*W001*/
/*        		               xxppif_msg = "2005-" + exec_part.
				       xxppif_err = 2.                     
				       next.    
*/  
				 end.
/*W003				 else do:
					  xxppif_msg = "0001-" + exec_part.
 			        end.   
W003*/ 
			 end. /*avail pt_mstr end*/
			strTmp = "".  
			if not avail pt_mstr then do:
					strTmp = "I". 
			end.		
			else do:                        
                		strTmp = pt_status.
			    if(xxppif_tr_code = "PDIC") then do: 
			       find first code_mstr no-lock where code_domain = global_domain and 
			       						code_fldname = "item style" and 
			       						code_value = strTmp no-error.
			       if available code_mstr and code_cmmt = "O" then do:
				  strTmp = trim(substring(xxppif_content,55,1)).
			       end.
			    end.

			end.
		end .  /*lookup(xxppif_tr_code,"PDIC,SOIC") > 0*/
/*W004				else if lookup(xxppif_tr_code,"PDIA,SOIA") > 0 then do:
			find pt_mstr where pt_domain = global_domain and 
					 pt_part = exec_part no-lock no-error.
/*W001                if avail pt_mstr then do:
        		       xxppif_msg = "2004-" + exec_part.
				      xxppif_err = 2.
        		       next.
        		    end.
W001 */                    
		end. */
			
/*** Not applicable ***                    
                    else do:
                        if trim(substring(xxppif_content,37,2)) = "10" then do:
                            if strTmp = "" then strTmp = "A".
                        end.
                        else do:
                            strTmp = "O".                        
                        end.
                    end.
******************/                    
         /*      
		    if can-find (first qad_wkfl where qad_domain = global_domain and 
		    									 qad_key1 = "PT_STATUS") then do:
			find qad_wkfl where qad_domain = global_domain and
			     qad_key1 = "PT_STATUS" and
			     qad_key2 = strTmp no-error.
			if not available qad_wkfl then do:
			    xxppif_err = 2.
			    xxppif_msg = "2028-" + strTmp.
			    next.
			end.
		    end.
            */
                 item_status = strTmp.
  
	    if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
            /** Make/Buy **/
            
		  strTmp = "".
                  find first code_mstr no-lock where 
                  		 code_domain = global_domain and
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
/*W003   */
                   find first code_mstr no-lock where code_domain = global_domain 
                   			and code_fldname = "ID_CODE" 
                        AND code_value = substring(xxppif_content,24,2) 
                        AND code_cmmt = "y" use-index code_fldval no-error.
                   if available code_mstr then do:
                       strTmp = "M".  /*强行改为M*/
                      
                   end.
/*W003*/
/*W003             ELSE DO:
                       xxppif_err = 2.
                       xxppif_msg = "2053-" + strTmp.
                      next.

                   END.
W003 */                  

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
/*W001 move down        item_phantom = strTmp.
                   
          if item_phantom = "" then do:
                      xxppif_err = 2.
                      xxppif_msg = "2007-" + strTmp.
                      next.
                   end.
*W001*/ 
/*W001*/
                   /*ID(pt_pt_type ) = 17,74,77,79  mantanence in code ID_CODE     if substring(xxppif_content,24,2) in them ,then phantom    */

/*W003 */
                   find first code_mstr no-lock where code_domain = global_domain 
                   		  and code_fldname = "ID_CODE" 
                        AND code_value = substring(xxppif_content,24,2)
                        AND code_cmmt = "y" use-index code_fldval no-error.
                   if available code_mstr then do:
                            strTmp = "P".  /*虚件P*/
                   end.
/*W003                   ELSE DO:
                       xxppif_err = 2.
                       xxppif_msg = "2053-" + strTmp.
                      next.

                   END.
*/                   
/*W001*/
/*W001*/         item_phantom = strTmp.
                   if item_phantom = "" then do:
                      xxppif_err = 2.
                      xxppif_msg = "2007-" + strTmp.
                      next.
                   end.
/*W001*/ 

            end. /* end lookup(xxppif_tr_code,"PDIA,PDIC") > 0 */

                /** Unit of Measure exist transaction  warning **/
            		strTmp = trim(substr(xxppif_content,60,2)).
            		strTmp = "EA".
            		if available pt_mstr and pt_um <> strTmp then do:
                		if can-find(first tr_hist use-index tr_part_trn where
                										  tr_domain = global_domain and
                									    tr_part = pt_part) then do:
                		   xxppif_msg = "1002-" + strTmp.
                		end.
            		end.
            		
        		    /** check description length warning**/
        		strTmp = trim(substr(xxppif_content,26,25)).
            		if length(strTmp) > 24 then do:
               		 xxppif_msg = "1001-" + strTmp.
               		 xxppif_err = 1.
               		 strTmp = substr(strTmp,1,24).
            		end.  
                    
                put stream batchdata unformatted "~"" at 1 exec_part "~"" skip.
                strTmp = "EA".
                put stream batchdata unformatted "~"" strTmp "~" " .
                strTmp = trim(substr(xxppif_content,26,24)).
                put stream batchdata unformatted "~"" strTmp "~" " skip.
                put stream batchdata unformatted "- - - - ".
                strTmp = trim(substr(xxppif_content,24,2)) + (if trim(substr(xxppif_content,5,1)) <> "" then ("-" + trim(substr(xxppif_content,5,1))) else "").
                put stream batchdata unformatted "~"" strTmp "~" ".
                
/*W004                if lookup(xxppif_tr_code,"PDIC") > 0 then strTmp = item_status. 
	            if lookup(xxppif_tr_code,"PDIA") > 0 then strTmp = "I" .
/*W003*/        if lookup(xxppif_tr_code,"SOIA") > 0 then strTmp = "I" .
/*W003*/        if lookup(xxppif_tr_code,"SOIC") > 0 then strTmp = item_status.
       */ 

/*W004*/       if lookup(xxppif_tr_code,"PDIC,PDIA,SOIA,SOIC") > 0 then strTmp = item_status. 
/*W003*/       IF strTmp = "" THEN strTmp = "I" .

                put stream batchdata unformatted "~"" strTmp "~" ".
								
			strTmp = "".
			/** 产品组变换 ***/
            if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
				if item_pm_code = "M" then do:
					if item_phantom = "P" then do:  /*虚件*/
						if substring(xxppif_content,52,1) = "G" then do:
							strTmp = "O".
						end.
						else strTmp = "Ph".			         
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
                end.
                put stream batchdata unformatted "~"" strTmp "~" " skip.
                
                if xxppif_err = 99 then xxppif_err = 0.
		substr(xxppif__chr01,2,1) = "1" .
                substr(xxppif__chr01,3,1) = "1".
         
        end. /*repeat end*/

 /*W002 begin*/
              end.         /*end lookup(xxppif_tr_code,"PDIA,SOIA,PDIC,SOIC") > 0 */
            /**/
/*W002 end*/             
        	   
        		
        put stream batchdata unformatted  "." at 1.
        output stream batchdata  close.
        
        INPUT CLOSE.
        output to value(stroutputfile) .
	    
        INPUT from value(strinputfile).
        
        
            PAUSE 0 BEFORE-HIDE.
            {gprun.i ""xxptmt04.p""}
            LEAVE .
        
        INPUT CLOSE.
        OUTPUT CLOSE.
 
/*W002 begin*/
   /* end.       */  /*end lookup(xxppif_tr_code,"PDIA,SOIA,PDIC,SOIC") > 0 */
/*W002 end*/
