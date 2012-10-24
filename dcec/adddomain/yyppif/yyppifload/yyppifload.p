/* Last change by Wilber 03/20/2008  solve the new QAD item problem    SO *W001*/


{ xxppifdef.i }       
def buffer xxppif_buff for xxppif_log.
def var exec_par as char.
def var exec_child as char.
find last xxppif_log no-lock no-error.
trid_begin = 0.
if avail xxppif_log then trid_begin = xxppif_tr_id + 1.
/* STEP-1: LOAD DATA INTO XXPPIF_LOG */

        run OPEN_DELIVER_FILE("PPIF_ITEM").
        run OPEN_DELIVER_FILE("PPIF_SO").
        run CHECK_DATA.
        
/* STEP-2: Verify Data **/
procedure CHECK_DATA:
        for each xxppif_log where xxppif_domain = global_domain and 
        			   xxppif_err = 99 and substr(xxppif__chr01,1,1) = "0":
            substr(xxppif__chr01,1,1) = "1".  /* 开始检验 */
        		if lookup(xxppif_tr_code,"PDIA,PDIC,PDID,SOIA,SOIC") > 0 then do:
        		   xxppif_part = trim(substring(xxppif_content,12,12)).
        		   if trim(substring(xxppif_content,81,16)) <> "" then xxppif_part = trim(substring(xxppif_content,81,16)).
        		end.
        		if lookup(xxppif_tr_code,"PDSA,PDSC,SOSA,SOSC") > 0 then do:
        		   xxppif_part = trim(substring(xxppif_content,24,12)).
        		   if trim(substring(xxppif_content,85,16)) <> "" then xxppif_part = trim(substring(xxppif_content,85,16)).
        		end.
        		
        /*1.transaction code 1-4*/
            strTmp = trim(substr(xxppif_content,1,4)).
            if lookup(strTmp,"PDIA,PDIC,PDID,PDSA,PDSC,SOIA,SOIC,SOSA,SOSC") = 0 then do:
               xxppif_msg = "2001-" + strTmp. /*PPIF Transaction Code Not Define */
               xxppif_err = 2.
               next.
            end.
        /*2.Action Code 5*/    
            strTmp = trim(substr(xxppif_content,5,1)).
            if lookup(strTmp,"I,O") = 0 and lookup(xxppif_tr_code,"PDSA,PDSC,SOSA,SOSC") > 0 then do:
               if not (strTmp = "" and lookup(xxppif_tr_code,"PDSC,SOSC") > 0) then do:
                     xxppif_msg =  "2002-" + strTmp.
                     xxppif_err = 2.
                     next.
               end.
            end.
        /*3.transaction date 6-11*/    
            strTmp = trim(substr(xxppif_content,6,6)).
           
            /*set xxppif__dte01 = date(inte(substr(strTmp,3,2)),inte(substr(strTmp,5,2)),2000 + inte(substr(strTmp,1,2))) no-error.*/
            set xxppif_tr_date = date(inte(substr(strTmp,3,2)),inte(substr(strTmp,5,2)),2000 + inte(substr(strTmp,1,2))) no-error.
            if error-status:error then do:
               xxppif_msg = "2003-" + strTmp.
               xxppif_err = 2.
               next.
            end.
        /*4.Cummins Item or Parent Item 12-23 */    
            strTmp = trim(substr(xxppif_content,12,12)).
            if lookup(xxppif_tr_code,"PDIA,PDIC,SOIA,SOIC") > 0 then do:
               if trim(substr(xxppif_content,81,16)) <> ""           then 
               strTmp = trim(substr(xxppif_content,81,16)).
               find pt_mstr where pt_domain = global_domain and
               		  pt_part = strTmp no-lock no-error.
/*W001*               if avail pt_mstr and lookup(xxppif_tr_code,"PDIA,SOIA") > 0 then do:
                  xxppif_msg = "2004-" + strTmp.
                  xxppif_err = 2.
               		next.
               end.
W001*/               
               if not avail pt_mstr then do:
                  if lookup(xxppif_tr_code,"PDIC,SOIC") > 0 then do:
                     if trim(substr(xxppif_content,81,16)) = "" then do:
/*W001*//*delete the error message begin*/

				  /* xxppif_msg = "2005-" + strTmp.
                        xxppif_err = 2.*/

/*W001*//*delete the error message end*/

                    	next.
                     end.
                  end.
               end.
            end. /* end "PDIA,PDIC,SOIA,SOIC" */
        /*5.ID Code 24-25 & 5 & PDIA,PDIC,SOIA,SOIC*/    
            if lookup(xxppif_tr_code,"PDIA,PDIC,SOIA,SOIC") > 0 then do:
            	 strTmp = trim(substr(xxppif_content,24,2)) + (if trim(substr(xxppif_content,5,1)) <> "" then ("-" + trim(substr(xxppif_content,5,1))) else "").
            	 if not can-find (first code_mstr where code_domain = global_domain 
            	 		and code_fldname = "pt_part_type"
            	 		and code_value = strTmp) then do:                
                			xxppif_msg = "2006-" + strTmp.
               				xxppif_err = 2.
               				next.
            		end.        
            end.
           
        /*6.English Description 26-50 & PDIA PDIC*/
            if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
            		strTmp = trim(substr(xxppif_content,26,25)).
            		if length(strTmp) > 24 then do:
               		 xxppif_msg = "1001-" + strTmp.
               		 strTmp = trim(substr(strTmp,1,24)).
            		end.            
            end.
        /*7.MRP Action Code 51 & PDIA PDIC*/
            if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
            		strTmp = trim(substr(xxppif_content,51,1)).
            		find first code_mstr no-lock where code_domain = global_domain 
            				   and code_fldname = "51" and code_value = strTmp use-index code_fldval no-error.
                   if available code_mstr then do:
                      if code_cmmt = "yes" then do:
                         strTmp = "P".  /*虚件P*/
                      end.
                      else do: /*no 代表实件*/
                         strTmp = "S".
                      end.
                   end.
                   else do:
                      xxppif_msg = "2007-" + strTmp.
                      xxppif_err = 2.
               				next.
                   end.
            end.            
        /*8.Make/Buy 52 & PDIA PDIC*/
            if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
            		strTmp = trim(substr(xxppif_content,52,1)).
            		find first code_mstr no-lock where code_domain = global_domain 
            					 and code_fldname = "52" and code_value = strTmp use-index code_fldval no-error.
                   if available code_mstr then do:
                      /*code_cmmt . yes代表采购件 G*/
                      if code_cmmt = "yes" then do:
                         strTmp = "P".
                      end.
                      else do: /*no 代表自制件*/
                         strTmp = "M".
                      end.
                   end.
                   else do:
                      xxppif_msg = "2008-" + strTmp.
                      xxppif_err = 2.
               				next.
                   end.
            end.
        
        /*9.Item Release Phase code 55 & PDIA PDIC  Not applicable*/        
            strTmp = trim(substr(xxppif_content,55,1)).
            if not avail pt_mstr then strTmp = "I".
            else do:
            		if lookup(xxppif_tr_code,"SOIA,SOIC") > 0 then do:
							/*10.Item Effect code 53 & PDIA PDIC  Not applicable*/            		
            		   strTmp = trim(substr(xxppif_content,37,2)).
               		 if lookup(strTmp,"10,40") = 0 then do:
               		    xxppif_msg =  "2009-" + strTmp.
               		    xxppif_err = 2.
               				next.
                   end.
                end.   
            end.
            
        /*11.Unit of Measure 62 & PDIA PDIC** 
            
            		strTmp = trim(substr(xxppif_content,60,2)).
            		strTmp = "EA".
            		if available pt_mstr and pt_um <> strTmp then do:
                		if can-find(first tr_hist use-index tr_part_trn where tr_domain = global_domain and tr_part = pt_part) then do:
                		   xxppif_msg = "1002-" + strTmp.
                		end.
            		end.      
				*******/
				
				/*12.BOM SITE SOIA,SOIC*/
						if lookup(xxppif_tr_code,"SOIA,SOIC") > 0 then do:
                /*SO1 CREATE BOM IN SITE-B*/
                find first code_mstr no-lock where code_domain = global_domain and code_fldname = "so site"
                       and code_value = substring(xxppif_part,1,3) use-index code_fldval no-error.
                if not avail code_mstr then do:
                   xxppif_msg = "2010-" + strTmp.
                   xxppif_err = 2.
               		 xxppif_err = 2.
               		 next.
                end.    
                else do:
                   if lookup(code_cmmt,"dcec-b,dcec-c") = 0 then do:
                   		xxppif_msg = "2011-" + strTmp.
                   		xxppif_err = 2.
                      next.
                   end.
                end.                           
						end.
						/*** Start "PDSA,PDSC,SOSA,SOSC" Check****/
						if lookup(xxppif_tr_code,"PDSA,PDSC,SOSA,SOSC") > 0 then do:
						   strTmp = trim(substr(xxppif_content,12,12)).
						   find first code_mstr no-lock where code_domain = global_domain and code_fldname = "so site"
                                           and code_value = trim(substring(strTmp,1,3)) use-index code_fldval no-error.
               if not avail code_mstr and trim(substring(strTmp,1,2)) = "SO" then do:
                  xxppif_msg = "2010-" + strTmp.
						      xxppif_err = 2.
               		next.
               end.

               strTmp = trim(substring(xxppif_content,52,7)).
               set xxppif_qty_chg = dec(substring(strTmp,1,4)) + (decimal(substring(strTmp,5,3)) / 1000) no-error.
               if error-status:error then do:
                  xxppif_msg = "2026-" + strTmp.
                  xxppif_err = 2.
               		next.
               end.
               
               strTmp = trim(substring(xxppif_content,36,6)).
               set xxppif__dte01 = date(inte(substr(strTmp,3,2)),inte(substr(strTmp,5,2)),2000 + inte(substr(strTmp,1,2))) no-error.
               
               if error-status:error then do:
                  xxppif_msg = "2003-" + strTmp.
                  xxppif_err = 2.
                  next.
               end.
						end.						/** End "PDSA,PDSC,SOSA,SOSC" Check****/
            
        end. /* End step-2*/
end procedure. /* End Procedure CHECK DATA */
        /***********************************************************
        ************************************************************
        **                                                        **
        **     1. PROCEDURE: OPEN_DELIVER_FILE                    **
        **                                                        **
        **        OPEN DELIVER FILE AND READ INFOMATION           **
        **                                                        **
        **        PPIF_WHICH : PPIF_ITEM                          **
        **                     PPIF_SO                            **
        **                                                        **
        **                                                        **
        ************************************************************
        ***********************************************************/
        PROCEDURE OPEN_DELIVER_FILE:
            
            define input parameter PPIF_WHICH as char.
            
            define var vbkfile as char.

            
            
            find first code_mstr no-lock where code_domain = global_domain and code_fldname = PPIF_WHICH no-error.
            if not available code_mstr then do:
                find last xxppif_log no-lock no-error.
                trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
                create xxppif_log. xxppif_domain = global_domain.
                assign  xxppif_tr_id    = trid
                        xxppif_act_date = today
                        xxppif_act_time = string(time, "HH:MM:SS")
                        xxppif_err      = 2
                        xxppif_msg      = "CODE_MSTR NOT DEFINE " + PPIF_WHICH
                        xxppif_tr_code  = "XSYS"
                        xxppif__chr01 = "00000000".
            end.
            else do:
                filename = trim(code_value).
                filepath = trim(code_cmmt).
                sourcename = trim(code_cmmt) + "\" + trim(code_value).
                vbkfile = filepath + "\bak\" + string(year(today),"9999")
                                             + string(month(today),"99")
                                             + string(day(today),"99")
                                             + string(time)
                                             + ppif_which 
                                             + ".txt".
                /** vbkfile =       filepath + "\bak\" +               filename.         */
                if search(sourcename) = ? then do:
                /*CAN NOT FIND THE FILE */
                    find last xxppif_log no-lock no-error.
                    trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
                    create xxppif_log. xxppif_domain = global_domain.
                    assign  xxppif_tr_id    = trid
                            xxppif_act_date = today
                            xxppif_act_time = string(time, "HH:MM:SS")
                            xxppif_err      = 2
                            xxppif_msg      = "NOT FOUND " + sourcename 
                            xxppif_tr_code  = "XSYS"
                            xxppif__chr01 = "00000000".
                end.
                else do:  /* FIND THE FILE AND LOAD INFOMATION INTO XXPPIF_LOG */
                    RUN READ_FILE_INFO.
                    /*2004-09-06 11:39 BACK UP FILE*/
                    DOS SILENT move value(sourcename) value(vbkfile).
                end.
            end.
        END PROCEDURE.          

        /***********************************************************
        ************************************************************
        **                                                        **
        **     2. PROCEDURE: READ_FILE_INFO                       **
        **                                                        **
        **        READ INFO & IMPORT TO FILE XXPPIF_LOG           **
        **                                                        **
        **                                                        **
        ************************************************************
        ***********************************************************/

        PROCEDURE READ_FILE_INFO:
            find last xxppif_log no-lock no-error.
            trid = if available xxppif_log then (xxppif_tr_id + 1) else 1.
/****            
            input from value(sourcename).
        		repeat:
        		create xxppif_log. xxppif_domain = global_domain.
        		import unformatted xxppif_content.
        		assign xxppif_tr_id    = trid
                       xxppif_act_date = today
                       xxppif_act_time = string(time, "HH:MM:SS")
                       xxppif_file     = filename
                       xxppif_tr_code  = trim(substring(xxppif_content,1,4))
                       xxppif_err 		 = 99
                       xxppif__chr01   = "00000000".
            trid = trid + 1.           
        		end.
        		input close.
***/
            input stream batchdata from value(search(sourcename)) no-echo.
            linedata = "".
            readkey stream batchdata.
            do while lastkey <> keycode("RETURN") and lastkey >= 0:
                linedata = linedata + chr(lastkey).
                readkey stream batchdata.
            end.
            end_file = no.
            read_and_create:
            do while lastkey >= 0 or lastkey = -2:
                if end_file then 
                    leave read_and_create.
                if lastkey = -2 then 
                end_file = yes.
                /*if trim(substring(linedata,12,12)) = "" and trim(substring(linedata,12,12)) = "" then */
                find first xxppif_buff where xxppif_buff.xxppif_domain = global_domain and xxppif_buff.xxppif_tr_id >= trid_begin
                                        and lookup(xxppif_buff.xxppif_tr_code,"SOSA,SOSC,PDSA,PDSC") > 0 
                												and xxppif_buff.xxppif_err = 99 
                												and xxppif_buff.xxppif_tr_code = trim(substring(xxppif_buff.xxppif_content,1,4))
                												and trim(substring(xxppif_buff.xxppif_content,12,12)) = trim(substring(linedata,12,12)) 
                												and trim(substring(xxppif_buff.xxppif_content,24,12)) = trim(substring(linedata,24,12))
                												/*and xxppif_buff.xxppif__chr01   = "00000000".*/
                												no-lock no-error.
                if avail xxppif_buff then 
                find first xxppif_buff where xxppif_buff.xxppif_domain = global_domain and xxppif_buff.xxppif_tr_id >= trid_begin
                                        and lookup(xxppif_buff.xxppif_tr_code,"SOSA,SOSC,PDSA,PDSC") > 0 
                												and xxppif_buff.xxppif_err = 99 
                												and xxppif_buff.xxppif_tr_code = trim(substring(xxppif_buff.xxppif_content,1,4))
                												and trim(substring(xxppif_buff.xxppif_content,12,12)) = trim(substring(linedata,12,12)) 
                												and trim(substring(xxppif_buff.xxppif_content,24,12)) = trim(substring(linedata,24,12))
                												and trim(substring(xxppif_buff.xxppif_content,5,1)) = trim(substring(linedata,5,1))
                												/*and xxppif_buff.xxppif__chr01   = "00000000".*/
                												no-lock no-error.
                
                if avail xxppif_buff then do:
                   create xxppif_log. xxppif_log.xxppif_domain = global_domain.
                   assign xxppif_log.xxppif_content  = linedata.
                   assign xxppif_log.xxppif_tr_id    = trid
                          xxppif_log.xxppif_act_date = today
                          xxppif_log.xxppif_act_time = string(time, "HH:MM:SS")
                          xxppif_log.xxppif_file     = filename
                          xxppif_log.xxppif_tr_code  = trim(substring(xxppif_log.xxppif_content,1,4))
                          xxppif_log.xxppif_err 		  = 2
                          xxppif_log.xxppif_msg      = "2036-" + substring(xxppif_log.xxppif_content,12,12) + " ~/ " + substring(xxppif_log.xxppif_content,24,12).
                          xxppif_log.xxppif__chr01   = "10000000".
                          trid = trid + 1.
                end.       
                else do:
                   create xxppif_log. xxppif_log.xxppif_domain = global_domain.
                   assign xxppif_log.xxppif_content  = linedata.
                   assign xxppif_log.xxppif_tr_id    = trid
                          xxppif_log.xxppif_act_date = today
                          xxppif_log.xxppif_act_time = string(time, "HH:MM:SS")
                          xxppif_log.xxppif_file     = filename
                          xxppif_log.xxppif_tr_code  = trim(substring(xxppif_log.xxppif_content,1,4))
                          xxppif_log.xxppif_err 		 = 99
                          xxppif_log.xxppif__chr01   = "00000000".
                          trid = trid + 1.
                end.

                linedata = "".
                readkey stream batchdata.
                do while lastkey <> keycode("RETURN") and lastkey >= 0:
                    linedata = linedata + chr(lastkey).
                    readkey stream batchdata.
                end.                       
            end.
            input stream batchdata close.
        END PROCEDURE.
        
