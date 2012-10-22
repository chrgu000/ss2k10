/** yyppifim01.p 1.4.3 **/
/***xxppif__chr01 1:���ϼ��� 2:Item ADD 3:Item Change 4:BOM ADD 5:BOM Change 6:BOM Code Create 7:Item Del **/
/*** item_type   1.�������ܳ�
								 2.�˴��(���Ƽ�)
								 3.��Ż����
								 4.Э���(�ɹ���)
								 5.����(F��)
								 6.�����
								 7.�׼�(C��) ***********/
								 
{ xxppifdef.i }   
def var item_type as char.
def var item_status as char.
def var item_phantom as char.
def var item_pm_code as char.

        strinputfile    = filepath + "\" + "ppifi01.tmp".
        stroutputfile   = filepath + "\" + "ppifiout01.tmp".      

        output stream batchdata to value(strinputfile) no-echo.    

        put stream batchdata unformatted "~"" at 1 runuser "~" ~"" runpsw "~"".
        put stream batchdata unformatted "~"yyppptmt04-2.p~"" at 1.   /*1.4.3*/
        		for each xxppif_log where lookup(xxppif_tr_code,"PDIA,SOIA") > 0
        		                      and xxppif_err <> 2
        		                      and substr(xxppif__chr01,1,1) = "1"
        		                      and substr(xxppif__chr01,2,1) = "0":
        		    /** Check exist Item error**/              		    
        		    find pt_mstr where pt_part = xxppif_part no-lock no-error.
        		    if avail pt_mstr then do:
        		       xxppif_msg = "2004-" + xxppif_part.
                   xxppif_err = 2.
        		       next.
        		    end.
                /** Unit of Measure exist transaction  warning 
            
            		strTmp = trim(substr(xxppif_content,60,2)).
            		strTmp = "EA".
            		if available pt_mstr and pt_um <> strTmp then do:
                		if can-find(first tr_hist use-index tr_part_trn where tr_part = pt_part) then do:
                		   xxppif_msg = "1002-" + strTmp.
                		end.
            		end.
            		****/
            /** Make/Buy **/
            if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
            strTmp = "".
            
                  find first code_mstr no-lock where code_fldname = "52" and code_value = substring(xxppif_content,52,1) use-index code_fldval no-error.
                   if available code_mstr then do:
                      /*code_cmmt . yes�����ɹ��� G*/
                      if code_cmmt = "yes" then do:
                         strTmp = "P".
                      end.
                      else do: /*no �������Ƽ�*/
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
                   find first code_mstr no-lock where code_fldname = "51" and code_value = substring(xxppif_content,51,1) use-index code_fldval no-error.
                   if available code_mstr then do:
                      if code_cmmt = "yes" then do:
                         strTmp = "P".  /*���P*/
                      end.
                      else do: /*no ����ʵ��*/
                         strTmp = "S".
                      end.
                   end.
                   item_phantom = strTmp.
                   
                   if item_phantom = "" then do:
                      xxppif_err = 2.
                      xxppif_msg = "2007-" + strTmp.
                      next.
                   end.
              end. /* end lookup(xxppif_tr_code,"PDIA,PDIC") > 0 */
        		    /** check description length warning**/
        		    strTmp = trim(substr(xxppif_content,26,25)).
            		if length(strTmp) > 24 then do:
               		 xxppif_msg = "1001-" + strTmp.
               		 xxppif_err = 1.
               		 strTmp = substr(strTmp,1,24).
            		end.  
                put stream batchdata unformatted "~"" at 1 xxppif_part format "x(16)" "~"" skip.
                strTmp = "EA".
                put stream batchdata unformatted "~"" strTmp "~" " .
                strTmp = trim(substr(xxppif_content,26,24)).
                put stream batchdata unformatted "~"" strTmp "~" " skip.
                put stream batchdata unformatted "- - - ".
                strTmp = trim(substr(xxppif_content,24,2)) + (if trim(substr(xxppif_content,5,1)) <> "" then ("-" + trim(substr(xxppif_content,5,1))) else "").
                put stream batchdata unformatted "~"" strTmp "~" ".
                strTmp = "I".
                put stream batchdata unformatted "~"" strTmp "~" ".
                
								strTmp = "".
								/** ��Ʒ��任 ***/
								if lookup(xxppif_tr_code,"PDIA,PDIC") > 0 then do:
								   if item_pm_code = "M" then do:
								      if item_phantom = "P" then do:  /*���*/
								         if substring(xxppif_content,52,1) = "G" then do:
								            strTmp = "O".
								         end.
								         else strTmp = "Ph".
								      end.
								      if item_phantom = "S" then do:  /*ʵ��*/
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
                substr(xxppif__chr01,2,1) = "1".
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
 