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
/* Last Modify by Jean 01/23/2007  Revise SO production generate structure *J005*/
/* Last Modify by Jean 01/23/2007  *J006*/
/* Last change by Jean 04/10/2007  For SOSA SOSC local components change *J007*/
/* Last change by Jean 07/22/2007  For PDSC SOSC verify the qty not equal to zero *J008*/
/* Last change by Jean 09/03/2007  For PDSC SOSC verify the qty not equal to zero *J009*/
/* Last change by Jean 12/23/2007  Skip check Site-C for Site-B SO *J010*/

/* Last change by Wilber 03/24/2008  Change the effect date logic *W001 */
/* The new logic:
If the xxppif__dte01 >=ps_start and xxppif__dte01<= ps_end ,then 
ps_end = xxppif__dte01 - 1 .
else if xxppif__dte01 <= ps_start then ps_start = xxppif__dte01   */

/* Last change by Wilber 04/01/2008                  *W002 */
/* Last change by Wilber 04/01/2008                  *W003 */
/* Last change by Wilber 04/02/2008                  *W004*/
/* Last change by Wilber 04/07/2008    add the logic of PDSCI and PDSCO               *W005*/
/* Last change by Wilber 05/06/2008    process the ps_start = ?  and ps_start = today            *W006*/
/* Last change by Wilber 05/08/2008    process the ps_start < xxppif__chr01            *W007*/
/* Last change by Wilber 05/13/2008    process the sosai add the bom            *W008*/
/* Last change by Wilber 05/14/2008    indentify the t-code pdsco pdsao sosao sasco          *W009*/
/* Last change by Wilber 05/21/2008    process when xxppif__chr01 < ps_start and ps_start < today         *W010*/
/* Last change by Wilber 05/22/2008    delete the 2039 error of pdsao and differ pdsio and pdsco        *W011*/
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
/*J010*/ def var predef_site as char.
/*J009*/ def var last_bom_qty like ps_qty_per.
/*J004*/ def var new_bom as log init no.   /* if yes needs to process */



        strinputfile    = filepath + "\" + "ppifb02b.tmp".
        stroutputfile   = filepath + "\" + "ppifbout02b.tmp".      

/*W001 begin*/
        /*process the cimload record one by one */
        /*

        output stream batchdata to value(strinputfile) no-echo.    

        put stream batchdata unformatted "~"" runuser "~" ~"" runpsw "~"" skip.
        put stream batchdata unformatted "~"yybmpsmt-1.p~"" skip.   /*13.5*/
        		for each xxppif_log where lookup(xxppif_tr_code,"PDSA,SOSA,PDSC,SOSC") > 0
        		                      and xxppif_err <> 2
        		                      and substr(xxppif__chr01,1,1) = "1"
        		                      and substr(xxppif__chr01,4,1) = "0":
         */
output stream batchdata to value(strinputfile) NO-ECHO.   
            
            /*no-error proceed*/
            IF ERROR-STATUS:ERROR THEN DO:
                OUTPUT STREAM batchdata CLOSE .
                output stream batchdata to value(strinputfile) NO-ECHO .    
            END.
            put stream batchdata unformatted "~"" runuser "~" ~"" runpsw "~"" skip.
            put stream batchdata unformatted "~"yybmpsmt-1.p~"" skip.   /*13.5*/  

for each xxppif_log where lookup(xxppif_tr_code,"PDSA,SOSA,PDSC,SOSC") > 0
        		                      and xxppif_err <> 2
        		                      and substr(xxppif__chr01,1,1) = "1"
        		                      and substr(xxppif__chr01,4,1) = "0":
   

/*W001 end*/
	    cummins_par = trim(substring(xxppif_content,12,12)).
	    cummins_child = trim(substring(xxppif_content,24,12)).
	    local_par = "".
	    local_child = "".
	    exec_par = cummins_par.
	    exec_child = cummins_child.
/*J007*			if lookup(xxppif_tr_code,"PDSA,PDSC") > 0 then do: */
            local_par = trim(substring(xxppif_content,67,16)).
	    local_child = trim(substring(xxppif_content,85,16)).
	    if local_par <> "" then exec_par = local_par.
	    if local_child <> "" then exec_child = local_child.
/*J007*			end.  */

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
		end. /* end for if lookup(xxppif_tr_code,"SOSA,SOSC") > 0 */
		else do:
			find ptp_det where ptp_site = SITE-C and ptp_part = exec_par no-lock no-error.
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
		end.   /*end for else do */

/*J005*/	item_type = 0.
/*J005*/	find pt_mstr where pt_part = exec_par no-lock no-error.
/*J005*/	if (pt_group begins "58" and item_pm_code = "M" and item_phantom = no) then item_type = 1.    /*1.发动机总成*/
/*J005*/	if (lookup(pt_group,"M") > 0 and item_pm_code = "M" and item_phantom = no) then item_type = 2.    /*2.八大件(自制件)*/
/*J005*/	if (lookup(pt_group,"O") > 0 and item_pm_code = "M" and item_phantom = yes) then item_type = 3.    /*3.组号*/
/*J005*/	if (lookup(pt_group,"RAW") > 0 and item_pm_code = "P" and item_phantom = no) then item_type = 4.  /*4.协配件(采购件)*/
/*J005*/	if (lookup(pt_group,"ZZ") > 0 and item_pm_code = "F" and item_phantom = no and pt_prod_line = "9999" ) then item_type = 5.   /*5.机型(F件)*/
/*J005*/	if (lookup(pt_group,"PH") > 0 and item_pm_code = "M" and item_phantom = yes) then item_type = 6.   /*6.虚件/随机件*/

		find ptp_det where ptp_site = SITE-C and ptp_part = exec_child no-lock no-error.
		if not avail ptp_det then do:
/*J005*/		for first ptp_det where ptp_site = SITE-B and ptp_part = exec_child no-lock: end.
/*J005*/			if not avail ptp_det then do:						   	
					xxppif_err = 2.
					xxppif_msg = "2031-" + exec_child.
					next.
/*J005*/		      	end.
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
                /*{gprun.i ""yybmpsmta.p""}*/
                run yybmpsmta.p.
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
             
/*J005** Move up
*						item_type = 0.
*						find pt_mstr where pt_part = exec_par no-lock no-error.
*						if (pt_group begins "58" and item_pm_code = "M" and item_phantom = no) then item_type = 1.    /*1.发动机总成*/
*						if (lookup(pt_group,"M") > 0 and item_pm_code = "M" and item_phantom = no) then item_type = 2.    /*2.八大件(自制件)*/
*						if (lookup(pt_group,"O") > 0 and item_pm_code = "M" and item_phantom = yes) then item_type = 3.    /*3.组号*/
*						if (lookup(pt_group,"RAW") > 0 and item_pm_code = "P" and item_phantom = no) then item_type = 4.  /*4.协配件(采购件)*/
*						if (lookup(pt_group,"ZZ") > 0 and item_pm_code = "F" and item_phantom = no and pt_prod_line = "9999" ) then item_type = 5.   /*5.机型(F件)*/
*						if (lookup(pt_group,"PH") > 0 and item_pm_code = "M" and item_phantom = yes) then item_type = 6.   /*6.虚件/随机件*/
**J005*/
		if item_type = 0 then do:
			  xxppif_err = 2.
			  xxppif_msg = "2040-" + exec_par + item_pm_code + string(item_phantom).
			  next.		
		end.
/*J010*/	predef_site = "".
			    		
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
/*J010*/		predef_site = code_cmmt.
		end.  /*end for lookup(xxppif_tr_code,"SOSA,SOSC") > 0*/

		if lookup(xxppif_tr_code,"PDSA,PDSC,SOSA,SOSC") > 0  then do:
/*J004*/		 new_bom = yes.
/*J001*/		find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
/*J001*/		if avail ps_mstr
/*J006*/  			and trim(substr(xxppif_content,5,1)) <> "O" 
				and lookup(xxppif_tr_code,"PDSC,SOSC") = 0
/*J001*/			then do: /*判断结构是否存在,若存在,显示提示信息**/
/*J001*//*W002			xxppif_err = 3.        */
/*J001*/		      /*xxppif_msg = "3004-" + exec_par.
/*J004*/ 			new_bom = no.*/
/*J001*/		end.
/*J005*/		for first ptp_det where ptp_site = SITE-C and ptp_part = exec_child no-lock: end.
/*J004*/		if avail ptp_det and new_bom = yes 
/*J010*/		and predef_site <> SITE-B
/*J004*/		then do:		/* For SITE-C */		/*J005* Add an new condition to judge if it exist in SITE-C*/
/*J005*/			item_phantom = ptp_phantom.
/*J008*/
/*J009*/			last_bom_qty = 0.
/*J008*/			if lookup(xxppif_tr_code,"PDSC,SOSC") > 0  and xxppif_qty_chg = 0 then do:
/*J008*/				find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
/*J008*/				if not avail ps_mstr or ps_qty_per = 0 then do:
/*J008*/						xxppif_err = 2.
/*J008*/		    		                xxppif_msg = "2026-" + exec_par.
/*J008*/		    		                next.
/*J008*/				end.
/*J009*/				else last_bom_qty = ps_qty_per.
/*J008*/			end.  /*lookup(xxppif_tr_code,"PDSC,SOSC") > 0 */
                      
            
/**W006			     if lookup(xxppif_tr_code,"PDSC,SOSC") = 0  */
/*W006*/            if lookup(xxppif_tr_code,"PDSC,SOSC,PDSA,SOSA") = 0 
/*J006*//*W002			or trim(substr(xxppif_content,5,1)) = "O"    */
/*W002*//*W009                or ((lookup(xxppif_tr_code,"PDSA,SOSA") > 0 ) AND trim(substr(xxppif_content,5,1)) = "O") */
    /*W009*/         or trim(substr(xxppif_content,5,1)) = "O" 
				then do:
     	    				 /*1.1 不存在本父,存在本子*/
                  			if local_par = "" and local_child <> "" then do:
                  			   if item_type = 3 then do:  /*针对OPTION	处理康明斯件和本地件*/
/*W001**                  	      find last ps_mstr where ps_par = cummins_par and ps_comp = cummins_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.*/

/*W001*//*W011					 find last ps_mstr where ps_par = cummins_par 
									and ps_comp = cummins_child 
									and (ps_end = ? or ps_end >= xxppif__dte01)  no-error. */
/*W001*//*W011 */ 				 find last ps_mstr where ps_par = cummins_par 
									and ps_comp = cummins_child 
									and (ps_end = ? or ps_end >= xxppif__dte01 OR trim(substr(xxppif_content,4,2)) = "CO") no-error. 
        /*W011*/

                  				 if avail ps_mstr then do:  /*判断Cummins父子结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
/*W001               					if ps_start >= xxppif__dte01 then do:
            							      xxppif_err = 2.
            							      xxppif_msg = "2035-" + cummins_par.
            							      next.
                  					end.      
*/
						 date_str = string(day(ps_start),"99/") + string(month(ps_start),"99/") + substr(string(year(ps_start),"9999"),3,2).
						 run fix_date_format(input-output date_str).
						 put stream batchdata unformatted  "~"" SITE-C "~"" skip.
						 put stream batchdata unformatted  "~"" ps_par "~"" skip.
						 put stream batchdata unformatted  "~"" ps_comp "~" " "- ".
                         put stream batchdata unformatted  date_str skip.       
    
						 if lookup(xxppif_tr_code,"SOSC,PDSC") > 0 and trim(substr(xxppif_content,5,1)) <> "O" then do:
							date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
                          
						end.  /* end for lookup(xxppif_tr_code,"SOSC,PDSC") > 0 and trim(substr(xxppif_content,5,1)) <> "O"*/

                        put stream batchdata unformatted  "- - " date_str " ".  

                        date_str = string(day(xxppif__dte01 - 1),"99/") + string(month(xxppif__dte01 - 1),"99/") + substr(string(year(xxppif__dte01 - 1),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        if trim(substr(xxppif_content,5,1)) = "O" or lookup(xxppif_tr_code,"SOSC,PDSC") = 0 then
                        	 put stream batchdata unformatted date_str " ".
												else put stream batchdata unformatted "- ".
                        put stream batchdata unformatted xxppif_tr_code skip.
                  	         put stream batchdata unformatted "." skip.


                  			   end. /*end for item_type = 3*/
                  			end. /* local_par = ""*/
                  		end.  /*1.1*/
			  
			    /*if not avail code_mstr or code_cmmt = site-c then do:*/
	      
 /*W011   		     find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error. */
 /*W011*/       find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01 OR trim(substr(xxppif_content,4,2)) = "CO" ) NO-ERROR .   						 
			    if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
/*				if avail ps_mstr and ps_start >= xxppif__dte01 then do:
								      xxppif_err = 2.
								      xxppif_msg = "2035-" + exec_par.
								      next.
				end.
 */   	    
				put stream batchdata unformatted  "~"" SITE-C "~"" skip.
				put stream batchdata unformatted  "~"" ps_par "~"" skip.
				date_str = string(day(ps_start),"99/") + string(month(ps_start),"99/") + substr(string(year(ps_start),"9999"),3,2).
				run fix_date_format(input-output date_str).
 			put stream batchdata unformatted  "~"" ps_comp "~" " "- " date_str skip.     

				if lookup(xxppif_tr_code,"SOSC,PDSC") > 0 and trim(substr(xxppif_content,5,1)) <> "O" then do:

				    date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
				
				end.           

         
                        put stream batchdata unformatted  "- - " date_str " ".  

               date_str = string(day(xxppif__dte01 - 1),"99/") + string(month(xxppif__dte01 - 1),"99/") + substr(string(year(xxppif__dte01 - 1),"9999"),3,2).
               run fix_date_format(input-output date_str).
               if trim(substr(xxppif_content,5,1)) = "O" or lookup(xxppif_tr_code,"SOSC,PDSC") = 0 then
                        	 put stream batchdata unformatted date_str " ".
               else put stream batchdata unformatted "- ".
               put stream batchdata unformatted xxppif_tr_code skip.
               put stream batchdata unformatted "." skip.
   
			    end.   /* end for if avail ps_mstr*/

/*J003*/   /*W011 	    else if trim(substr(xxppif_content,5,1)) = "O" then do:
/*J003*/				 xxppif_err = 2.
/*J003*/				 xxppif_msg = "2039-" + exec_par.				
/*J003*/		    end.   */

			  end. /*if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:*/
                  /*end.*/ /*not avail code_mstr or code_cmmt = site-c */

/*W001*/    find code_mstr where code_fldname = "SO SITE" and code_value = substr(exec_par,1,3) no-lock no-error.
 			if trim(substr(xxppif_content,5,1)) = "I" or trim(substr(xxppif_content,5,1)) = "" /*PDSC SOSC更改*/ 
/*W002*/ /*W009            OR (lookup(xxppif_tr_code,"PDSC,SOSC") > 0 AND trim(substr(xxppif_content,5,1)) = "O") */
            then do:
/*J005*/          		if lookup(xxppif_tr_code,"PDSA,PDSC") > 0 or (lookup(xxppif_tr_code,"PDSA,PDSC") = 0 and (code_cmmt = site-c or (avail code_mstr) = no))
/*J005*/			then do:  

/*W001*/ /*W002 move down           find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
/*W001*/                          if avail ps_mstr then last_bom_qty = ps_qty_per.
/*W001*/                          if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
          W002*/  
/*W007*/ /* find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) AND (xxppif__dte01 > ps_start OR ps_start = ?) no-error.
*/
 /*W010*/  find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) AND (xxppif__dte01 < ps_start OR ps_start = ?) AND ps_start < TODAY NO-ERROR .
/*W007*/ /*W008 IF AVAIL ps_mstr THEN DO :  /*xxppif_dte01 < ps_start then 2039 */  */
/*W008*/ /*W010  IF AVAIL ps_mstr OR (lookup(xxppif_tr_code,"PDSA,SOSA") > 0 AND trim(substr(xxppif_content,5,1)) = "I") THEN DO:
*/
 /*W010*/  IF NOT AVAIL ps_mstr THEN DO :

				   date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
                  		   run fix_date_format(input-output date_str).
                  		   put stream batchdata unformatted  "~"" SITE-C "~"" skip.
                  		   put stream batchdata unformatted  "~"" exec_par "~"" skip.
/*W005*/           /* 		   put stream batchdata unformatted  "~"" exec_child "~" " "- " date_str skip.  */
/*W005*//*W006                  put stream batchdata unformatted  "~"" exec_child "~" " "- -"  skip. */
/*W006*/                  put stream batchdata unformatted  "~"" exec_child "~" " "- " date_str skip.
/*J009*/ /* W001        		   if lookup(xxppif_tr_code,"PDSC,SOSC") > 0 then put stream batchdata unformatted string(last_bom_qty,"->>9.999") " ".
                  		   else   
          W001 */
                           put stream batchdata unformatted  string(xxppif_qty_chg,"->>9.999") " ".
/*J005**          		   put stream batchdata unformatted (if item_pm_code = "P" then "X " else "- ") date_str.  */

/*J005*/	/*W001		   put stream batchdata unformatted (if item_pm_code = "P" or item_phantom = yes then "X " else "- ") date_str.
             W001*/
/*W001*/                    put stream batchdata unformatted (if item_pm_code = "P" or item_phantom = yes then "X " else "- ") .

/*W001 begin*/   

                     date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
                     run fix_date_format(input-output date_str).
/*W005 begin*//*add the logic of PDSCI and PDSCO*/
        if lookup(xxppif_tr_code,"PDSC") > 0 and trim(substr(xxppif_content,5,1)) = "O" then do:
        	find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
        	if avail ps_mstr then last_bom_qty = ps_qty_per.
        		if avail ps_mstr then do:      
        			put stream batchdata unformatted (string(day(ps_start),"99/") + STRING(MONTH(ps_start),"99/") + SUBSTR(STRING(YEAR(ps_start),"9999"),3,2)) " " .
        			put stream batchdata unformatted date_str " " xxppif_tr_code .
        		end.
        		else do:
        			xxppif_err = 2.
                     		xxppif_msg = "2055-" + exec_par. /*没有存在的生效日期，不能设置截至日期*/
                     		put stream batchdata unformatted SKIP.
                            put stream batchdata unformatted "." .
                            next.
        
        		end.
        end. /*lookup(xxppif_tr_code,"PDSC,SOSC") > 0 and trim(substr(xxppif_content,5,1)) = "0" */
/*W005 end*/
/*W005*/else do:

/*W002*/            find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
/*W002*/              if avail ps_mstr then last_bom_qty = ps_qty_per.
/*W002*/              if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/

/*W003*/                  /*    IF (ps_start <= (xxppif__dte01 - 1) OR ps_start = ?) AND (ps_end >= (xxppif__dte01 - 1) OR ps_end = ?) THEN DO:*/
/*W003*/ /*W006*/   /*          IF (ps_start <= TODAY OR ps_start = ?) AND (ps_end >= TODAY OR ps_end = ?) THEN DO:*/
                                  /*if 数据中生效日期(xxppif__dte01) - 1   大于startx小于  end                       */
  /*W006*/                    IF (ps_start < TODAY OR ps_start = ?) AND (ps_end >= TODAY OR ps_end = ?) AND ps_start <> xxppif__dte01 THEN DO:
                                    ps_end = (xxppif__dte01 - 1) .
                                  put stream batchdata unformatted   date_str .
                              END.
/* W003                       ELSE IF ps_start >= xxppif__dte01  THEN DO:*/
/*W003*/  /*W006*//*                    ELSE IF ps_start >= TODAY  THEN DO:  */
          /*W006*/            ELSE IF ps_start >= TODAY OR ps_start = xxppif__dte01  THEN DO:          
                                  /*if start >= 数据中生效日期*/
                                  put stream batchdata unformatted   date_str .

                              END.

/*W002*/              END . /*if avial ps_mstr */    
/*W002*/              ELSE DO:  
/*W002*/                    put stream batchdata unformatted   date_str .
/*W002*/              END.

/*W001 end */
                  		   put stream batchdata unformatted  " ? " xxppif_tr_code.
/*W005*/end. /*else do*/

/*W001 begin*/ /*add the general code PHANTOM OP to define the OP */
                  	      /*put stream batchdata unformatted "- " skip. */
                           put stream batchdata UNFORMATTED  " - - " .
/*W002*                          find ptp_det where ptp_part = cummins_child AND ptp_site = SITE-B no-lock no-error.   */
/*W002*/                  find ptp_det where ptp_part = cummins_child  no-lock no-error. 
                          IF AVAIL ptp_det THEN DO:
                              IF  ptp_phantom THEN DO:
                                  FIND CODE_mstr WHERE code_fldname = "PHANTOM OP" AND code_value = "DCEC C" NO-LOCK NO-ERROR .
                                   IF AVAIL CODE_mstr THEN DO:
                                       PUT STREAM batchdata UNFORMATTED code_cmmt .
                                       PUT STREAM batchdata UNFORMATTED SKIP .
                                   END.
                                   ELSE DO :
                                          xxppif_err = 2.
             						      xxppif_msg = "2054-" + exec_par    .             
/*W005*/                                           PUT STREAM batchdata UNFORMATTED SKIP .
/*W005*/                                          put stream batchdata unformatted "." .
             						      next.
                                   END.
                              END.
                              ELSE DO:
                                  PUT STREAM batchdata UNFORMATTED SKIP .
                              END.
                          END.
                          ELSE DO:
                              PUT STREAM batchdata UNFORMATTED SKIP .
                          END.
 /*W001 END*/                 
   /*W001           		   put stream batchdata unformatted skip.    */
                  		   put stream batchdata unformatted "." skip.
/*W007*/                        END. /*if avial ps_mstr */ 
/*W007*/                                ELSE DO :
/*W007*/                                     xxppif_err = 2.
/*W007*/        							   xxppif_msg = "2039-" + exec_par.						   
 /*W007*/          						   next.

   /*W007*/                             END.
/*W001*/ /*W002 move up              END . /*if avial ps_mstr */    */
/*J005*/			end.
/*J005*/			else do:
/*J005*/				xxppif_err = 1.
/*J005*/				xxppif_msg = "2041-" + exec_par. /* 总成 SITE-B */
/*J005*/			end.
/*J003*/              end.   /*trim(substr(xxppif_content,5,1)) = "I"  */ 
			substr(xxppif__chr01,4,1) = "1".
/*J004*/ 	 end. /* new_bom = yes */		/* For SITE-C */
/*J005*/		for first ptp_det where ptp_site = SITE-B and ptp_part = exec_child no-lock: end.
/*J005*/		if avail ptp_det then item_phantom = ptp_phantom.
/*J005*/		else do:
/*J005*/				for first pt_mstr where pt_part = exec_child no-lock: end.
/*J005*/				if avail pt_mstr then item_phantom = pt_phantom.
/*J005*/		end.



            if item_type = 6 /* 虚件 PH*/
               or item_type =  3  /*组件 O */ 
               or (item_type = 1 AND AVAIL code_mstr and code_cmmt = SITE-B) then do:  /* site-b总成*/
                     exec_par = exec_par + "ZZ".

                       /**if item_type = 1 then do:**/  /*只要子件是虚件的 都用BOM CODE Item + "ZZ"*/
                           find ptp_det where ptp_site = SITE-C and ptp_part = exec_child no-lock no-error.
/*J005*/									 if not avail ptp_det then for first ptp_det where ptp_site = SITE-B and ptp_part = exec_child no-lock: end.
                           if avail ptp_det and ptp_phantom = yes then do:
                              exec_child = exec_child + "ZZ".   /*总成 SITE-B 子件为虚件时 + ZZ */
                           end.
                        /*end.*/

/*J009*/				last_bom_qty = 0.
/*J009*/		if lookup(xxppif_tr_code,"PDSC,SOSC") > 0  and xxppif_qty_chg = 0 then do:
/*J009*/				find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
/*J009*/				if not avail ps_mstr or ps_qty_per = 0 then do:
/*J009*/						xxppif_err = 2.
/*J009*/		    		xxppif_msg = "2026-" + exec_par.
/*J009*/		    		next.
/*J009*/				end.
/*J009*/				else last_bom_qty = ps_qty_per.
/*J009*/		end.

/*J004*/			 new_bom = yes.
/*J004*/       find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) no-lock no-error.
/*J004*/       if avail ps_mstr 
/*J006*/  								and trim(substr(xxppif_content,5,1)) <> "O" 
													and lookup(xxppif_tr_code,"PDSC,SOSC") = 0
/*J004*/          then do: /*判断结构是否存在,若存在,显示提示信息**/
/*J004*//*W002          xxppif_err = 3. */
/*J004*/		      /*xxppif_msg = "3004-" + exec_par.
/*J004*/ 					new_bom = no.*/
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
                      /*  {gprun.i ""yybmpsmta.p""} */
                            run yybmpsmta.p.
                        
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
/**W006			     if lookup(xxppif_tr_code,"PDSC,SOSC") = 0  */
/*W006*/            if lookup(xxppif_tr_code,"PDSC,SOSC,PDSA,SOSA") = 0 
/*J006*//*W002			or trim(substr(xxppif_content,5,1)) = "O"    */
/*W002*/  /*W009              or ((lookup(xxppif_tr_code,"PDSA,SOSA") > 0 ) AND trim(substr(xxppif_content,5,1)) = "O") */
    /*W009*/ or trim(substr(xxppif_content,5,1)) = "O" 
                      then do:
/********
if not(exec_child matches "*ZZ") then do:
/*J005*/					for first ptp_det where ptp_site = SITE-B and ptp_part = exec_child no-lock: end.
/*J005*/						if not avail ptp_det then do:						   	
									      xxppif_err = 2.
									      xxppif_msg = "2031-" + SITE-B + exec_child.
									      next.
/*J005*/		      	end.
end.
**********/ 
 /*W011                    find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
*/
 /*W011*/            find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01 
                                                                                             OR trim(substr(xxppif_content,4,2)) = "CO" ) NO-ERROR .   						 
                     if avail ps_mstr then last_bom_qty = ps_qty_per.
                     if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
 /*  W001                     if ps_start >= xxppif__dte01 then do:
         						      xxppif_err = 2.
         						      xxppif_msg = "2035-" + exec_par.
         						      next.
                        end.
 */   					date_str = string(day(ps_start),"99/") + string(month(ps_start),"99/") + substr(string(year(ps_start),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        put stream batchdata unformatted  "~"" SITE-B "~"" skip.
                        put stream batchdata unformatted  "~"" ps_par "~"" skip.
                        put stream batchdata unformatted  "~"" ps_comp "~" " "- " date_str skip.  
 
                        if lookup(xxppif_tr_code,"SOSC,PDSC,PDSA,SOSA") > 0 and trim(substr(xxppif_content,5,1)) <> "O" then do:
                        		date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
                        end.

                        put stream batchdata unformatted  "- - " date_str " ".  

                
                        date_str = string(day(xxppif__dte01 - 1),"99/") + string(month(xxppif__dte01 - 1),"99/") + substr(string(year(xxppif__dte01 - 1),"9999"),3,2).
                        run fix_date_format(input-output date_str).
                        if trim(substr(xxppif_content,5,1)) = "O" or lookup(xxppif_tr_code,"SOSC,PDSC") = 0 then
                        	 put stream batchdata unformatted date_str " ".
                        put stream batchdata unformatted "- " skip.
                        put stream batchdata unformatted "." skip.
                    end.    /* end for if avail ps_mstr*/
/*J003*/ /*   				   else if trim(substr(xxppif_content,5,1)) = "O" then do:
/*J003*/							   xxppif_err = 2.
/*J003*/							   xxppif_msg = "2039-" + exec_par.						   
/*J003*/							   next.								
/*J003*/						 end.  */
                 end. /*if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:*/

/*W001*/         find code_mstr where code_fldname = "SO SITE" and code_value = substr(exec_par,1,3) no-lock no-error.
/*J003*/		 if trim(substr(xxppif_content,5,1)) = "I" or trim(substr(xxppif_content,5,1)) = "" /*PDSC SOSC更改*/ 
/*W002*/   /*W009          OR (lookup(xxppif_tr_code,"PDSC,SOSC") > 0 AND trim(substr(xxppif_content,5,1)) = "O") */
                then do:       
/*J005*/          		if lookup(xxppif_tr_code,"PDSA,PDSC") > 0 or (lookup(xxppif_tr_code,"PDSA,PDSC") = 0 and (code_cmmt = site-B or (avail code_mstr) = no)) then do:          
                        
/*W001*//*W002            find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
/*W001*/            if avail ps_mstr then last_bom_qty = ps_qty_per.
/*W001*/            if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/
        W002*/
/*W007*//*W010  find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) AND (xxppif__dte01 > ps_start OR ps_start = ?) no-error.
*/
/*W010*/find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01) AND (xxppif__dte01 < ps_start OR ps_start = ?) AND ps_start < TODAY no-error.


/*W007*/ /*W008 IF AVAIL ps_mstr THEN DO :  /*xxppif_dte01 < ps_start then 2039 */  */
/*W008*//*W010   IF AVAIL ps_mstr OR (lookup(xxppif_tr_code,"PDSA,SOSA") > 0 AND trim(substr(xxppif_content,5,1)) = "I") THEN DO: */
/*W010*/       IF NOT AVAIL ps_mstr THEN DO :  


                        date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01 ),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).                     
                        run fix_date_format(input-output date_str).

                        put stream batchdata unformatted  "~"" SITE-B "~"" skip.
                        put stream batchdata unformatted  "~"" exec_par "~"" skip.
/*W005*/           /* 		   put stream batchdata unformatted  "~"" exec_child "~" " "- " date_str skip.  */
/*W005*//*W006                  put stream batchdata unformatted  "~"" exec_child "~" " "- -"  skip. */
/*W006*/                put stream batchdata unformatted  "~"" exec_child "~" " "- " date_str skip.

/*W001                        if lookup(xxppif_tr_code,"PDSC,SOSC") > 0 then put stream batchdata unformatted  string(last_bom_qty,"->>9.999") " ".
                        else 
*W001*/                        
                        put stream batchdata unformatted  string(xxppif_qty_chg,"->>9.999") " ".
/*J005**                put stream batchdata unformatted (if item_pm_code = "P" then "X " else "- ") date_str. */
/*J005*/  /*W001		put stream batchdata unformatted (if (item_pm_code = "P" or item_phantom = yes) then "X " else "- ") date_str.
           *W001*/ 

/*W001*/                  put stream batchdata unformatted (if (item_pm_code = "P" or item_phantom = yes) then "X " else "- ") .

/*W001 begin*/   
                              date_str = string(day(xxppif__dte01),"99/") + string(month(xxppif__dte01),"99/") + substr(string(year(xxppif__dte01),"9999"),3,2).
                              run fix_date_format(input-output date_str).
/*W005 begin*//*add the logic of PDSCI and PDSCO*/
        if lookup(xxppif_tr_code,"PDSC") > 0 and trim(substr(xxppif_content,5,1)) = "O" then do:
        	find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
        	if avail ps_mstr then last_bom_qty = ps_qty_per.
        		if avail ps_mstr then do:
        			put stream batchdata unformatted (string(day(ps_start),"99/") + STRING(MONTH(ps_start),"99/") + SUBSTR(STRING(YEAR(ps_start),"9999"),3,2)) " " .
        			put stream batchdata unformatted date_str " " xxppif_tr_code .
        		end.
        		else do:
        			xxppif_err = 2.
                     		xxppif_msg = "2055-" + exec_par. /*??óD′??úμ?éúD§è??ú￡?2??üéè?????áè??ú*/
                     		put stream batchdata unformatted SKIP .
                            put stream batchdata unformatted "." .
                            next.
        
        		end.
        end. /*lookup(xxppif_tr_code,"PDSC,SOSC") > 0 and trim(substr(xxppif_content,5,1)) = "0" */
/*W005 end*/
/*W005*/else do:

/*W002*/            find last ps_mstr where ps_par = exec_par and ps_comp = exec_child and (ps_end = ? or ps_end >= xxppif__dte01)  no-error.
/*W002*/              if avail ps_mstr then last_bom_qty = ps_qty_per.
/*W002*/              if avail ps_mstr then do: /*判断结构是否存在,若存在,结束日期=数据中生效日期(xxppif__dte01) - 1 **/

/*W003*/                  /*    IF (ps_start <= (xxppif__dte01 - 1) OR ps_start = ?) AND (ps_end >= (xxppif__dte01 - 1) OR ps_end = ?) THEN DO:*/
/*W003*//*W006*//*              IF (ps_start <= TODAY OR ps_start = ?) AND (ps_end >= TODAY OR ps_end = ?) THEN DO:      */                             /*if 数据中生效日期(xxppif__dte01) - 1   大于startx小于  end                       */
        /*W006*/                      IF (ps_start < TODAY OR ps_start = ?) AND (ps_end >= TODAY OR ps_end = ?) AND ps_start <> xxppif__dte01 THEN DO:    
                                  ps_end = (xxppif__dte01 - 1) .
                                  put stream batchdata unformatted   date_str .
                              END.
/* W003                       ELSE IF ps_start >= xxppif__dte01  THEN DO:*/

/*W003*/  /*W006*//*                    ELSE IF ps_start >= TODAY  THEN DO:  */
          /*W006*/            ELSE IF ps_start >= TODAY OR ps_start = xxppif__dte01  THEN DO:    
                                  /*if start >= 数据中生效日期*/
                                  put stream batchdata unformatted   date_str .

                               END.
                      END.
/*W002*/              ELSE DO:
    
/*W002*/                     put stream batchdata unformatted   date_str .
/*W002*/              END.

/*W001 end */
            
                         put stream batchdata unformatted  " ? " xxppif_tr_code.
/*W005 */ end . /*else do:*/

/*W001 begin*/ /*add the general code PHANTOM OP to define the OP */
                  	      /*put stream batchdata unformatted "- " skip. */
                           put stream batchdata UNFORMATTED  " - - " .
/*W002*                          find ptp_det where ptp_part = cummins_child AND ptp_site = SITE-B no-lock no-error.   */
/*W002*/                  find ptp_det where ptp_part = cummins_child  no-lock no-error. 
                          IF AVAIL ptp_det THEN DO:
                              IF  ptp_phantom THEN DO:
                                  FIND CODE_mstr WHERE code_fldname = "PHANTOM OP" AND code_value = "DCEC B" NO-LOCK NO-ERROR .
                                   IF AVAIL CODE_mstr THEN DO:
                                       PUT STREAM batchdata UNFORMATTED code_cmmt .
                                       PUT STREAM batchdata UNFORMATTED SKIP .
                                   END.
                                   ELSE DO :
                                          xxppif_err = 2.
             						      xxppif_msg = "2054-" + exec_par.
/*W005*/                                           PUT STREAM batchdata UNFORMATTED SKIP .
/*W005*/                                          put stream batchdata unformatted "." .
  
             						      next.
                                   END.
                              END.
                              ELSE DO:
                                  PUT STREAM batchdata UNFORMATTED SKIP .
                              END.
                          END.
                          ELSE DO:
                              PUT STREAM batchdata UNFORMATTED SKIP .
                          END.
 /*W001 END*/                 


 /*W001                 put stream batchdata unformatted skip.   */
                        put stream batchdata unformatted "." skip.
 /*W007*/  /*W010*/                      END. /*if avial ps_mstr */  /*if not avail*/
/*W007*/                                ELSE DO :
/*W007*/                                     xxppif_err = 2.
/*W007*/        							   xxppif_msg = "2039-" + exec_par.						   
 /*W007*/          						   next.

   /*W007*/                             END.

/*W001*/ /*W002 move up                      END . /*if avial ps_mstr */   */

                      end.
                  end. /*trim(substr(xxppif_content,5,1)) = "I"*/
							  end. /*if lookup(xxppif_tr_code,"PDSC,SOSC") = 0 then do:*/
/*J004*/ 		end. /* new_bom = yes */		/* For SITE-B */ 
/*W004*/   /* end. /*虚零件*/    */
/*W004*/    END . /*item_type <> 0*/

                if xxppif_err = 99 then xxppif_err = 0.
                substr(xxppif__chr01,4,1) = "2".
        		

/*W001 begin*/
        /*process the cimload record one by one */
 /*move down*/            /*  end.    /*end of for each xxppif_log */ */
 /*W001 end */

/*W001 begin*/
        /*process the cimload record one by one */
        /**/
        END . /*end of for each xxppif_log */ 
 /*W001 end */

        put stream batchdata unformatted  "." at 1.
        put stream batchdata unformatted "." at 1.
        put stream batchdata unformatted "~"Y~"" at 1.
     


        output stream batchdata  close.
        
        /*INPUT CLOSE. */
        output to value(stroutputfile) .
        
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
