/** yyppifbm01.p 13.1.2 **/
/***xxppif__chr01 1:资料检验 2:Item ADD 3:Item Change 4:BOM ADD 5:BOM Change 6:BOM Code Create 7:Item Del **/
/*** item_type   1.发动机总成
								 2.八大件(自制件)
								 3.组号或虚件
								 4.协配件(采购件)
								 5.机型(F件)
								 6.随机件
								 7.套件(C件) ***********/
								 
{ xxppifdef.i }   
def var item_type as char.
def var item_status as char.
def var item_phantom as char.
def var item_pm_code as char.

        strinputfile    = filepath + "\" + "ppifb01.tmp".
        stroutputfile   = filepath + "\" + "ppifbout01.tmp".      

        output stream batchdata to value(strinputfile) no-echo.    

        put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"".
        put stream batchdata unformatted "~"yybmmamt2.p~"" at 1.   /*1.4.3*/
        		for each xxppif_log where lookup(xxppif_tr_code,"PDSA,SOSA,PDSC,SOSC") > 0
        		                      and xxppif_err <> 2
        		                      and substr(xxppif__chr01,1,1) = "1"
        		                      and substr(xxppif__chr01,6,1) = "0":
     						strTmp = trim(substring(xxppif_content,12,12)).
    						/*  判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
    					  if trim(substring(xxppif_content,67,16)) <> "" then do :
    					     strTmp = trim(substring(xxppif_content,67,16)).
     					  end.        		                      
        		    /** Check exist Item error**/              		    
        		    find pt_mstr where pt_part = strTmp no-lock no-error.
        		    if not avail pt_mstr then do:
        		       xxppif_msg = "2015-" + strTmp.
                   xxppif_err = 2.
        		       next.
        		    end.
        		/** site-c **/
								find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error. /*SITE-B MJH007*/
								
            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error. /*SITE-B MJH007*/
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) use-index code_fldval no-error.
            /*if substring(strTmp,1,3) = "SO1" or (available ptp_det and ptp_phantom = yes) then do:*/
            if (not available code_mstr) and substring(strTmp,1,2)= "SO" then do:
               xxppif_err = 2.
               xxppif_msg = "2010-" + strTmp.
               next.
            end.
            if avail code_mstr then do:
               find ptp_det where ptp_part = strTmp and ptp_site = code_cmmt no-lock no-error.
               if not avail ptp_det then do:
                  xxppif_err = 2.
                  xxppif_msg = "2016-" + strTmp.
                  next.
               end.
               else do:
                  if ptp_pm_code <> "m" then do:
                     xxppif_err = 2.
                     xxppif_msg = "2012-" + strTmp.
                     next.
                  end.
               end.
               if lookup(code_cmmt,"DCEC-B,DCEC-C") = 0 then do:
                  	 xxppif_err = 2.
                     xxppif_msg = "2011-" + strTmp.
                     next.
               end.
                    put stream batchdata unformatted "~"" at 1 strTmp  "~"" skip.
                    put stream batchdata unformatted "-" at 1 skip.
                    put stream batchdata unformatted "-" at 1 skip.
            end.
            else do:
               find first ptp_det where ptp_part = strTmp and ptp_site = site-c no-lock no-error.
               if not avail ptp_det then do:
                  xxppif_err = 2.
                  xxppif_msg = "2016-" + strTmp.
                  next.
               end.
               else do:
                  if ptp_pm_code <> "M" then do:
                     xxppif_err = 2.
                     xxppif_msg = "2012-" + strTmp.
                     next.
                  end.
                  find first ptp_det where ptp_part = strTmp and ptp_site = site-B no-lock no-error.
                  if avail ptp_det and ptp_pm_code <> "M" then do:
                     xxppif_err = 2.
                     xxppif_msg = "2012-" + strTmp.
                     next.
                  end.
                  
                    put stream batchdata unformatted "~"" at 1 strTmp "~"" skip.
                    put stream batchdata unformatted "-" at 1 skip.
                    put stream batchdata unformatted "-" at 1 skip.
                  find first ptp_det where ptp_part = strTmp and ptp_site = site-c no-lock no-error.
                  if avail ptp_det then do:
                    find pt_mstr where pt_part = strTmp no-lock no-error.
                    if lookup(pt_group,"RAW,M") = 0 and ptp_pm_code <> "P" then do: 
                    		put stream batchdata unformatted "~"" at 1 strTmp "~"" skip.
                    		put stream batchdata unformatted "-" at 1 skip.
                    		put stream batchdata unformatted "-" at 1 skip.
                    end.
                  end.
               end.
            end.

                if xxppif_err = 99 then xxppif_err = 0.
                substr(xxppif__chr01,6,1) = "1".
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
 