/** yyppifbm01.p 13.1.2 **/
/***xxppif__chr01 1:资料检验 2:Item ADD 3:Item Change 4:BOM ADD 5:BOM Change 6:BOM Code Create 7:Item Del **/
/*** item_type   1.发动机总成
								 2.八大件(自制件)
								 3.组号
								 4.协配件(采购件)
								 5.机型(F件)
								 6.虚件
								 7.套件(C件) ***********/
/* Last Modify by Jean 04/02/2006  add a message to display if exist old production structure *J001*/
/* Last Modify by Jean 04/29/2006  fix PDSAO SOSAO have not been processed  *J003*/
/* Last Modify by Jean 05/15/2006  Cancel any type to change current structure,user should manually to change *J004*/
{ xxppifdef.i }   
def var item_type as inte.
def var item_status as char.
def var item_phantom as log.
def var item_pm_code as char.
def var cummins_par  as char.
def var cummins_child as char.
def var local_par  as char.
def var local_child as char.
def var exec_par as char.
def var exec_child as char.
def var date_str as char format "x(8)".
def var recno_ps_mstr as recid.
def var bom-b as log.
def var bom-c as log.
/*J004*/ def var new_bom as log init no.   /* if yes needs to process */
        strinputfile    = filepath + "\" + "ppifb02b.tmp".
        stroutputfile   = filepath + "\" + "ppifbout02b.tmp".      

        output stream batchdata to value(strinputfile) no-echo.    

        put stream batchdata unformatted "~"" runuser "~" ~"" runpsw "~"" skip.
        put stream batchdata unformatted "~"yybmpsmt-1.p~"" skip.   /*13.5*/
        		for each xxppif_log where lookup(xxppif_tr_code,"PDSA,SOSA,PDSC,SOSC") > 0
        		                      and xxppif_err <> 2
        		                      and substr(xxppif__chr01,1,1) = "1"
        		                      and substr(xxppif__chr01,4,1) = "0":
                      
						cummins_par = trim(substring(xxppif_content,12,12)).
						cummins_child = trim(substring(xxppif_content,24,12)).
						local_par = "".
						local_child = "".
						exec_par = cummins_par.
						exec_child = cummins_child.
						if lookup(xxppif_tr_code,"PDSA,PDSC") > 0 then do:
								local_par = trim(substring(xxppif_content,67,16)).
								local_child = trim(substring(xxppif_content,85,16)).		
								if local_par <> "" then exec_par = local_par.
								if local_child <> "" then exec_child = local_child.
						end.

						find pt_mstr where pt_part = exec_child no-lock no-error.
						if not avail pt_mstr then do:
						   xxppif_err = 2.
						   xxppif_msg = "2014-" + exec_child.						   
						   next.
						end.						
						find pt_mstr where pt_part = exec_par no-lock no-error.
						if not avail pt_mstr then do:
						   xxppif_err = 2.
						   xxppif_msg = "2015-" + exec_par.						   
						   next.
						end.
/*J003**						
       /* PDSAO 忽略不做处理 */
						if lookup(xxppif_tr_code,"PDSAO") > 0 then do:
						   xxppif_err = 2.
						   xxppif_msg = "2039-" + exec_par.						   
						   next.
						end.
**J003*/
						item_phantom = yes.		
						item_pm_code = "".
						if lookup(xxppif_tr_code,"SOSA,SOSC") > 0 then do:
						   find code_mstr where code_fldname = "SO SITE" and code_value = substr(exec_par,1,3) no-lock no-error.
						   if not avail code_mstr then do:
						      xxppif_err = 2.
						      xxppif_msg = "2010-" + exec_par.
						      next.						      
						   end.
						   find ptp_det where ptp_site = code_cmmt and ptp_part = exec_par no-lock no-error.
						   if not avail ptp_det then do:
						      xxppif_err = 2.
						      xxppif_msg = "2037-" + exec_par.
						      next.
						   end.
						   if ptp_pm_code = "P" then do:
									xxppif_err = 2.
									xxppif_msg = "2012-" + exec_par.
									next.
						   end.
						   item_phantom = ptp_phantom.	
						   item_pm_code = ptp_pm_code.
						end.
						else do:
						   find ptp_det where ptp_site = "DCEC-C" and ptp_part = exec_par no-lock no-error.
						   if not avail ptp_det then do:
						      xxppif_err = 2.
						      xxppif_msg = "2030-" + exec_par.
						      next.
						   end.
						   if ptp_pm_code = "P" then do:
									xxppif_err = 2.
									xxppif_msg = "2012-" + exec_par.
									next.
						   end.
						   item_phantom = ptp_phantom.
						   item_pm_code = ptp_pm_code.
						end.   
						   find ptp_det where ptp_site = "DCEC-C" and ptp_part = exec_child no-lock no-error.
						   if not avail ptp_det then do:
						      xxppif_err = 2.
						      xxppif_msg = "2031-" + exec_child.
						      next.
						   end.				
          /* CHECK FOR CYCLIC PRODUCT STRUCTURES */
        		 find first ps_mstr no-lock where ps_par = exec_par and ps_comp = exec_child
                    and ps_ref = "" and ps_start = xxppif__dte01 no-error.
             newBom = no.
             if not avail ps_mstr then do:      
                    find first pt_mstr no-lock where pt_part = exec_par no-error.
                    if available pt_mstr then
                        ptstatus1 = pt_status.
                    else ptstatus1 = "".
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "2023-" + exec_par.
                        next.
                    end.
                    find first pt_mstr no-lock where pt_part = exec_child no-error.
                    if available pt_mstr then
                       ptstatus1 = pt_status.
                    else ptstatus1 = "".
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "2023-" + exec_child.
                        next.
                    end.
                newBom = yes.
                create ps_mstr.
                assign
                     ps_par = exec_par
                     ps_comp = exec_child
                     ps_start = xxppif__dte01.
             end.
             ps_recno = recid(ps_mstr).
             recno_ps_mstr = ps_recno.
                {gprun.i ""yybmpsmta.p""}
                /*run yybmpsmta.p.*/
                if newBom then do:
                   find ps_mstr where recid(ps_mstr) = recno_ps_mstr no-error.
                   if avail ps_mstr then delete ps_mstr.
                end.   
             if ps_recno = 0 then do:
                 xxppif_err = 2.
                 xxppif_msg = "2034-" + exec_par + "~/" + exec_child.
                 next.
             end.
             if item_pm_code = "P" then do:
                 xxppif_err = 2.
                 xxppif_msg = "2038-" + exec_par .
                 next.               
             end.
           /* END CHECK FOR CYCLIC PRODUCT STRUCTURES */  						   		   
						item_type = 0.
						find pt_mstr where pt_part = exec_par no-lock no-error.
						if (pt_group begins "58" and item_pm_code = "M" and item_phantom = no) then item_type = 1.    /*1.发动机总成*/
						if (lookup(pt_group,"M") > 0 and item_pm_code = "M" and item_phantom = no) then item_type = 2.    /*2.八大件(自制件)*/
						if (lookup(pt_group,"O") > 0 and item_pm_code = "M" and item_phantom = yes) then item_type = 3.    /*3.组号*/
						if (lookup(pt_group,"RAW") > 0 and item_pm_code = "P" and item_phantom = no) then item_type = 4.  /*4.协配件(采购件)*/
						if (lookup(pt_group,"ZZ") > 0 and item_pm_code = "F" and item_phantom = no and pt_prod_line = "9999" ) then item_type = 5.   /*5.机型(F件)*/
						if (lookup(pt_group,"PH") > 0 and item_pm_code = "M" and item_phantom = yes) then item_type = 6.   /*6.虚件/随机件*/
						
						if item_type = 0 then do:
                  xxppif_err = 2.
                  xxppif_msg = "2040-" + exec_par + item_pm_code + string(item_phantom).
                  next.		
						end.
						
						if lookup(xxppif_tr_code,"SOSA,SOSC") > 0 then do:
						   find code_mstr where code_fldname = "SO SITE" and code_value = substr(exec_par,1,3) no-lock no-error.
						   if not avail code_mstr then do:
                  xxppif_err = 2.
                  xxppif_msg = "2010-" + exec_par.
                  next.
						   end.
						   if lookup(code_cmmt,"DCEC-B,DCEC-C") = 0 then do:
                  xxppif_err = 2.
                  xxppif_msg = "2011-" + exec_par.
                  next.						   
						   end.
						end.

						if lookup(xxppif_tr_code,"PDSA,PDSC,SOSA,SOSC") > 0  then do:
/*J004*/			 new_bom = yes.
/*J001*/       find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
/*J001*/       if avail ps_mstr then do: /*判断结构是否存在,若存在,显示提示信息**/
/*J001*/          xxppif_err = 3.
/*J001*/		      xxppif_msg = "3004-" + exec_par.
/*J004*/ 					new_bom = no.
/*J001*/       end.
/*J004*/		if new_bom = yes then do:		/* For SITE-C */
						    if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:
     						 /*1.1 不存在本父,存在本子*/
                  if local_par = "" and local_child <> "" then do:
                     if item_type = 3 then do:  /*针对OPTION	处理康明斯件和本地件*/
                        find last ps_mstr where ps_par = cummins_par and ps_comp = cummins_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
                        if avail ps_mstr then do:  /*判断Cummins父子结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
                           if ps_start >= xxppif__dte01 then do:
            						      xxppif_err = 2.
            						      xxppif_msg = "2035-" + cummins_par.
            						      next.
                           end.      
                           date_str = string(day(ps_start),"99/") + string(month(ps_start),"99/") + substr(string(year(ps_start),"9999"),3,2).
                           run fix_date_format(input-output date_str).
                           put stream batchdata unformatted  "~"" SITE-C "~"" skip.
                           put stream batchdata unformatted  "~"" ps_par "~"" skip.
                           put stream batchdata unformatted  "~"" ps_comp "~" " "- ".
                           put stream batchdata unformatted  date_str skip.                    
                           put stream batchdata unformatted  "- - - ".
                           date_str = string(day(xxppif__dte01 - 1),"99/") + string(month(xxppif__dte01 - 1),"99/") + substr(string(year(xxppif__dte01 - 1),"9999"),3,2).
                           run fix_date_format(input-output date_str).
                           put stream batchdata date_str skip.
                           put stream batchdata unformatted "." skip.
                        end.
                     end. /*item_type = 3*/
                  end.  /*1.1*/

                  /*if not avail code_mstr or code_cmmt = site-c then do:*/
                  
                     find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
										 
                     if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
                        if avail ps_mstr and ps_start >= xxppif__dte01 then do:
         						      xxppif_err = 2.
         						      xxppif_msg = "2035-" + exec_par.
         						      next.
                        end.
                  
                        put stream batchdata unformatted  "~"" SITE-C "~"" skip.
                        put stream batchdata unformatted  "~"" ps_par "~"" skip.
                        date_str = string(day(ps_start),"99/") + string(month(ps_start),"99/") + substr(string(year(ps_start),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        put stream batchdata unformatted  "~"" ps_comp "~" " "- " date_str skip.     
                        date_str = string(day(xxppif__dte01 - 1),"99/") + string(month(xxppif__dte01 - 1),"99/") + substr(string(year(xxppif__dte01 - 1),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        put stream batchdata unformatted  "- - - " date_str skip.
                        put stream batchdata unformatted "." skip.
                     end.

/*J003*/					   else if trim(substr(xxppif_content,5,1)) = "O" then do:
/*J003*/							   xxppif_err = 2.
/*J003*/							   xxppif_msg = "2039-" + exec_par.				
/*J003*/						 end.

                   end. /*if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:*/
                  /*end.*/ /*not avail code_mstr or code_cmmt = site-c */

									if trim(substr(xxppif_content,5,1)) = "I" or trim(substr(xxppif_content,5,1)) = "" /*PDSC SOSC更改*/ then do:  
									   date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
                     run fix_date_format(input-output date_str).
                     put stream batchdata unformatted  "~"" SITE-C "~"" skip.
                     put stream batchdata unformatted  "~"" exec_par "~"" skip.
                     put stream batchdata unformatted  "~"" exec_child "~" " "- " date_str skip.  
                     if lookup(xxppif_tr_code,"PDSC,SOSC") > 0 then put stream batchdata unformatted  "- " .
                     else 
                     put stream batchdata unformatted  string(xxppif_qty_chg,"->>9.999") " ".
                     put stream batchdata unformatted (if item_pm_code = "P" then "X " else "- ") date_str. 
                     put stream batchdata unformatted  " - " xxppif_tr_code.
                     put stream batchdata unformatted skip.
                     put stream batchdata unformatted "." skip.
/*J003*/          end.    
                     substr(xxppif__chr01,4,1) = "1".
/*J004*/ 		end. /* new_bom = yes */		/* For SITE-C */
                  if item_type = 6 /* 虚件 PH*/
                    or item_type =  3  /*组件 O */ 
                    or (item_type = 1 AND AVAIL code_mstr and code_cmmt = SITE-B) then do:  /* site-b总成*/
                     exec_par = exec_par + "ZZ".
                     
                        /**if item_type = 1 then do:**/  /*只要子件是虚件的 都用BOM CODE Item + "ZZ"*/
                           find ptp_det where ptp_site = site-c and ptp_part = exec_child no-lock no-error.
                           if ptp_phantom = yes then do:
                              exec_child = exec_child + "ZZ".   /*总成 SITE-B 子件为虚件时 + ZZ */
                           end.
                        /*end.*/
 
/*J004*/			 new_bom = yes.
/*J004*/       find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
/*J004*/       if avail ps_mstr then do: /*判断结构是否存在,若存在,显示提示信息**/
/*J004*/          xxppif_err = 3.
/*J004*/		      xxppif_msg = "3004-" + exec_par.
/*J004*/ 					new_bom = no.
/*J004*/       end.
/*J004*/		if new_bom = yes then do:		/* For SITE-B */
                  /* CHECK FOR CYCLIC PRODUCT STRUCTURES */
                		 find first ps_mstr no-lock where ps_par = exec_par and ps_comp = exec_child
                            and ps_ref = "" and ps_start = xxppif__dte01 no-error.
                     newBom = no.
                     if not avail ps_mstr then do:      
                            find first pt_mstr no-lock where pt_part = exec_par no-error.
                            if available pt_mstr then
                                ptstatus1 = pt_status.
                            else ptstatus1 = "".
                            substring(ptstatus1,9,1) = "#".
                            if can-find(isd_det where isd_status = ptstatus1
                            and isd_tr_type = "ADD-PS") then do:
                                xxppif_err = 2.
                                xxppif_msg = "2023-" + exec_par.
                                next.
                            end.
                            find first pt_mstr no-lock where pt_part = exec_child no-error.
                            if available pt_mstr then
                               ptstatus1 = pt_status.
                            else ptstatus1 = "".
                            substring(ptstatus1,9,1) = "#".
                            if can-find(isd_det where isd_status = ptstatus1
                            and isd_tr_type = "ADD-PS") then do:
                                xxppif_err = 2.
                                xxppif_msg = "2023-" + exec_child.
                                next.
                            end.
                        newBom = yes.
                        

                        create ps_mstr.
                        assign
                             ps_par = exec_par
                             ps_comp = exec_child
                             ps_start = xxppif__dte01.
                     end.
                     
                      ps_recno = recid(ps_mstr).
             					recno_ps_mstr = ps_recno.
                        {gprun.i ""yybmpsmta.p""}
             
                if newBom then do:
                    find ps_mstr where recid(ps_mstr) = recno_ps_mstr no-error.
                    if avail ps_mstr then delete ps_mstr.
                 end.   
                     if ps_recno = 0 then do:
                         xxppif_err = 2.
                         xxppif_msg = "2034-" + exec_par + "~/" + exec_child.
                         next.
                     end.
                   /* END CHECK FOR CYCLIC PRODUCT STRUCTURES */  
                   if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:
                     find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
                     if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
                        if ps_start >= xxppif__dte01 then do:
         						      xxppif_err = 2.
         						      xxppif_msg = "2035-" + exec_par.
         						      next.
                        end.
									      date_str = string(day(ps_start),"99/") + string(month(ps_start),"99/") + substr(string(year(ps_start),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        put stream batchdata unformatted  "~"" SITE-B "~"" skip.
                        put stream batchdata unformatted  "~"" ps_par "~"" skip.
                        put stream batchdata unformatted  "~"" ps_comp "~" " "- " date_str skip.                    
                        date_str = string(day(xxppif__dte01 - 1),"99/") + string(month(xxppif__dte01 - 1),"99/") + substr(string(year(xxppif__dte01 - 1),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        put stream batchdata unformatted  "- - - " date_str  skip.
                        put stream batchdata unformatted "." skip.
                     end.
/*J003*/					   else if trim(substr(xxppif_content,5,1)) = "O" then do:
/*J003*/							   xxppif_err = 2.
/*J003*/							   xxppif_msg = "2039-" + exec_par.						   
/*J003*/							   next.								
/*J003*/						 end. 
                   end. 
/*J003*/					if trim(substr(xxppif_content,5,1)) = "I" or trim(substr(xxppif_content,5,1)) = "" /*PDSC SOSC更改*/ then do:                       
									      date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01 ),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).                     
                        run fix_date_format(input-output date_str).
                        put stream batchdata unformatted  "~"" SITE-B "~"" skip.
                        put stream batchdata unformatted  "~"" exec_par "~"" skip.
                        put stream batchdata unformatted  "~"" exec_child "~" " "- " date_str skip.
                        if lookup(xxppif_tr_code,"PDSC,SOSC") > 0 then put stream batchdata unformatted  "- " .
                        else 
                        put stream batchdata unformatted  string(xxppif_qty_chg,"->>9.999") " ".
                        put stream batchdata unformatted (if item_pm_code = "P" then "X " else "- ") date_str. 
                        put stream batchdata unformatted  " - " xxppif_tr_code.
                        put stream batchdata unformatted skip.
                        put stream batchdata unformatted "." skip.
                  end. /*trim(substr(xxppif_content,5,1)) = "I"*/
							  end. /*if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:*/
/*J004*/ 		end. /* new_bom = yes */		/* For SITE-B */ 
						end. /*虚零件*/

                if xxppif_err = 99 then xxppif_err = 0.
                substr(xxppif__chr01,4,1) = "2".
        		end.
        put stream batchdata unformatted  "." at 1.
        put stream batchdata unformatted "." at 1.
        put stream batchdata unformatted "~"Y~"" at 1.
        output stream batchdata  close.
        
        INPUT CLOSE.
        output to value(stroutputfile).
        INPUT from value(strinputfile).

        PAUSE 0 BEFORE-HIDE.
        RUN MF.P.
        INPUT CLOSE.
        OUTPUT CLOSE.
 
 procedure fix_date_format:
 		def input-output parameter date-io as char format "x(8)".
 		def var new_date as char.
 		def var date_format as char.
 		date_format = "DDMMYY".
 		new_date = date-io.
 		find code_mstr where code_fldname = "DATE FORMAT" AND code_value = "6" no-lock no-error.
 		if avail code_mstr then do:
 		   if code_cmmt = "MMDDYY" then do:
 		      new_date = substr(date-io,4,2) + "/" + substr(date-io,1,2) + "/" + substr(date-io,7,2).
 		   end.
 		   if code_cmmt = "YYMMDD" then do:
 		      new_date = substr(date-io,7,2) + "/" + substr(date-io,4,2) + "/" + substr(date-io,1,2).
 		   end. 		   
 		end.
 		date-io = new_date.
 end procedure.