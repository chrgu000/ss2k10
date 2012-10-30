/*Modified by Bobo Ma *MJH007*    2005-2-2 17:11*/
/*xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC"*/
        for each xxppif_log exclusive-lock where xxppif_tr_id >= trid_begin and
        (xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC" 
        or xxppif_tr_code = "SOIA" or xxppif_tr_code = "SOIC"):
            run SET_TRAN_DATE(6).
            if xxppif_tr_date = ? then do:
                xxppif_err = 2.
                xxppif_msg = "传输日起格式错误 YYMMDD .".
                next.
            end.
/*          xxppif_part = trim(substring(xxppif_content,12,16)).  */
            assign xxppif_part = trim(substring(xxppif_content,12,12)).
            
/*MJH007*/  /*判断是否有本地item MJH007*/
/*MJH007*/  localitem = substring(xxppif_content,81,16).
/*MJH007*/  if trim(localitem) <> "" then do:
/*MJH007*/     assign xxppif_part = trim(localitem).
/*MJH007*/  end.
            
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
            if (xxppif_tr_code = "pdia" or xxppif_tr_code = "soia") and available pt_mstr then do:
               /*已经存在item，对于pdia报错*/
               xxppif_err = 2.
               xxppif_msg = "零件在1.4.3中存在，不做新建".
               next.
            end.
            if (xxppif_tr_code = "pdic" or xxppif_tr_code = "soic") and not available pt_mstr then do:
               /*不存在item,对于pdic报错*/
               localitem = substring(xxppif_content,81,16).
               if trim(localitem) <> "" then do: 
                  /*对于本地件而言，在pdic/soic的时候，可以新建*/
               end.
               else do:
                  xxppif_err = 2.
                  xxppif_msg = "零件在1.4.3中不存在，无法更改".
                  next.
               end.
            end.
            
            /*UM*/
            
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do: 
/*              strTmp = substring(xxppif_content,64,2). */
                strTmp = substring(xxppif_content,60,2).
                strTmp = "EA".  /*MJH007*/
            end.
            else strTmp = "EA".
            if (available pt_mstr and pt_um <> strTmp 
                and can-find(first tr_hist use-index
                 tr_part_trn where tr_part = pt_part)) then do:
                xxppif_err = 1.
                xxppif_msg = "Transaction history exists for this Item. - When Chg UM".
            end.
            /*Desc*/
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then 
/*              strTmp = trim(substring(xxppif_content,30,25)).  */
                strTmp = trim(substring(xxppif_content,26,25)).
            else strTmp = "".
            if length(strTmp) > 24 then do:
                xxppif_err = 1.
                xxppif_msg = "零件的描述超过24位".
            end.
            
            /*ADD DATE*/
/*          Cancled by mjh007 2005-2-2 17:11 由于原始70开始的5码错误，全部改为当天日期
 *          if(xxppif_tr_code = "PDIA" /*or xxppif_tr_code = "PDIC"*/) then do:
 * /*               run SET_ADD_DATE(74). */
 *              run SET_ADD_DATE(70).
 *              if xxppif__dte01 = ? then do:
 *                  xxppif_err = 2.
 *                  xxppif_msg = "Item Effect Date Error.".
 *                  next.
 *              end.
 *          end.
 *          else
 *              xxppif__dte01 = today.
 */  /*End of Cancled by*/
            
            assign xxppif__dte01 = today.  /*MJH007  for WEIhua 2005-2-2 17:10*/ 
            /*STATUS*/
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then 
/*              strTmp = trim(substring(xxppif_content,59,1)).  */
                strTmp = trim(substring(xxppif_content,55,1)).
/*          else strTmp = trim(substring(xxppif_content,73,1)). */
            else do:
                strTmp = trim(substring(xxppif_content,37,2)).
                if strTmp <> "10" and strTmp <> "40" then do:
                    xxppif_err = 2.
                    xxppif_msg = "影响代码必须是10或40".
                    next.
                end.
                else if strTmp = "10" then
                    strTmp = "A".
                else strTmp = "O".
            
            end.

            if can-find (first qad_wkfl where qad_key1 = "PT_STATUS") then do:
                find qad_wkfl where qad_key1 = "PT_STATUS"
                and qad_key2 = strTmp no-error.
                if not available qad_wkfl then do:
                    xxppif_err = 2.
                    xxppif_msg = "零件状态不存在: " + strTmp.
                    next.
                end.
            end.
            /* PART TYPE*/
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do:
/*              strTmp = trim(substring(xxppif_content,28,2)). */
                strTmp = trim(substring(xxppif_content,24,2)).
                if trim(substring(xxppif_content,5,1)) <> "" then
                    strTmp = strTmp + "-" + substring(xxppif_content,5,1).
            end.
/*          else strTmp = trim(substring(xxppif_content,28,2)). */
            else strTmp = trim(substring(xxppif_content,24,2)).
            
            if not can-find (first code_mstr where code_fldname = "pt_part_type"
            and code_value = strTmp) then do:
                xxppif_err = 2.
                xxppif_msg = "零件种类不存在:" + strTmp.
                next.
            end.
            /* PART GROUP */
            /*PDIC10503283770010     15CONNECTOR,MALEZWH        PG10P00  EA  0000  05081000NY C3770010*/
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do:
/*              if substring(xxppif_content,56,1) = "P" then */
                
                find first code_mstr no-lock where code_fldname = "52"
                                             and code_value = substring(xxppif_content,52,1) use-index code_fldval
                                             no-error.
                if available code_mstr then do:
                   /*code_cmmt.yes代表采购件*/
                   if code_cmmt = "yes" then do:
                      strTmp = "RAW".
                   end.
                   else do:
                      find first code_mstr no-lock where code_fldname = "51"
                                                     and code_value = substring(xxppif_content ,51,1) use-index code_fldval
                                                     no-error.
                      if code_cmmt = "no" then do:
                         strTmp = "M". /*针对于八大件*/
                      end.
                      else do:
                         strTmp = "ZZ".
                      end.
                   end.
                end.
                else do:
                   strTmp = "ZZ".
                end.
                if substring(xxppif_content,52,1) = "G" then strTmp = "O".
                
                
                /*
                if substring(xxppif_content,52,1) = "P" then
                    strTmp = "RAW".
                else
                    strTmp = "ZZ".
                */
            end.
            else strTmp = "58B".

            if not can-find (first code_mstr where code_fldname = "pt_group"
            and code_value = strTmp) then do:
                xxppif_err = 2.
                xxppif_msg = "零件组不存在:" + strTmp.
                next.
            end.

            /* VERIFY CHECK END. CIM LOAD DATA PREPARE BEGIN.*/
            put stream batchdata "~"" at 1 xxppif_part format "x(16)" "~"" skip.
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do:
/*              strTmp = substring(xxppif_content,64,2). */
                strTmp = substring(xxppif_content,60,2).
                strTmp = "EA". /*MJH007*/
            end.
            else strTmp = "EA".
            put stream batchdata "~"" at 1 strTmp format "x(2)" "~"". 
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then 
/*              strTmp = trim(substring(xxppif_content,30,25)). */
                strTmp = trim(substring(xxppif_content,26,25)).
            else strTmp = "".
            put stream batchdata " ~"" strTmp  format "x(24)" "~"" skip.
            
            /* add date 2004-08-25 09:25 and design group promted group*/
            if available pt_mstr then
                put stream batchdata "-" at 1.
            else
            do:
               /*tfq put stream batchdata today  xxppif__dte01 at 1. */
             /*tfq*/  put stream batchdata  string(day(today),"99") format "99" at 1 
             /*tfq*/   "/"  string(month(today),"99") format "99"  "/"  substring(string(year(today)),3,2) format "99"  .
             end.
            put stream batchdata " - - " .
            /*part type*/
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do:
/*              strTmp = trim(substring(xxppif_content,28,2)). */
                strTmp = trim(substring(xxppif_content,24,2)).
                if trim(substring(xxppif_content,5,1)) <> "" then
                    strTmp = strTmp + "-" + substring(xxppif_content,5,1).
            end.
/*          else strTmp = trim(substring(xxppif_content,28,2)). */
            else strTmp = trim(substring(xxppif_content,24,2)).
            put stream batchdata "~"" strTmp "~" ".
            
            /*pt_status*/
            if available pt_mstr then do:
                if(xxppif_tr_code = "PDIC") then do: 
                   strTmp = trim(substring(xxppif_content,55,1)).
                   find first code_mstr no-lock where code_fldname = "item style" and code_value = strTmp no-error.
                   if available code_mstr and code_cmmt = "O" then do:
                      put stream batchdata "~"" strTmp "~" ".
                   end.
                   else do:
                      put stream batchdata "- ".
                   end.
                end.
                else do:
                    strTmp = trim(substring(xxppif_content,37,2)).
                    if strTmp <> "10" and strTmp <> "40" then do:
                        xxppif_err = 2.
                        xxppif_msg = "Eff Code must be 10 or 40.".
                        next.
                    end.
                    else if strTmp = "10" then do:
                        strTmp = "A".
                        put stream batchdata "- ".
                    end.
                    else do:
                        strTmp = "O".
                        put stream batchdata "~"" strTmp "~" ".
                    end.
                end.
            end.
            else do:
                strTmp = "I".
                put stream batchdata "~"" strTmp "~" ".
            end.
            
            /*
            if strTmp = "O" 
            or strTmp = "I"  /*longbo 2005-01-21 15:39*/
            then
                put stream batchdata "~"" strTmp "~" ".
            else
                put stream batchdata "- ".
            */
            
            /*产品组变换*/        
            if available pt_mstr then do:
                /*put stream batchdata "-". long bo原始写的，对于产品组不做变动*/
                if xxppif_tr_code = "pdic" then do:
                   
                   strTmp = substring(xxppif_content,52,1). /*PT_PM_CODE , M,P,U-internal purchase*/
                   strTmp1 = substring(xxppif_content,51,1). /*R S P.IN PPIF; X SPACE IN QAD*/
                   /*pur/mfg = m and phantom = n    ONLY IN SITE-C*/
                   
                   find first code_mstr no-lock where code_fldname = "52" and code_value = substring(xxppif_content,52,1) use-index code_fldval no-error.
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
                      xxppif_err = 2.
                      xxppif_msg = "通用代码库 52位 :" + strTmp  + " 没有维护.".
                      next.
                   end.
                
                   find first code_mstr no-lock where code_fldname = "51" and code_value = substring(xxppif_content,51,1) use-index code_fldval no-error.
                   if available code_mstr then do:
                      if code_cmmt = "yes" then do:
                         strTmp1 = "P".  /*虚件P*/
                      end.
                      else do: /*no 代表实件*/
                         strTmp1 = "S".
                      end.
                   end.
                   else do:
                      xxppif_err = 2.
                      xxppif_msg = "通用代码库 51 位:" + strTmp1  + "没有维护.".
                      next.
                   end.
                
                   if strTmp = "M" then do: /*自制件*/
                      if (strTmp1 <> "P" and strTmp1 <> "X") then do: /*实件*/
                         /*
                           5、虚零件-〉自制+ 实（八大件）：1.4.3中零件组变成M，
                           3、实零件-〉自制+ 实（八大件）：1.4.3中零件组变成M，
                         */
                         put stream batchdata "~"M~"".
                         
                      end.
                      /*pur/mfg = m and phantom = y    BOTH IN SITE-B AND SITE-C*/
                      if (strTmp1 = "P" or strTmp1 = "X") then do: /*虚件*/
                         /*
                           1、实零件                -〉虚零件：1.4.3中零件组变成ZZ
                           6、自制+ 实+M组（八大件）-〉虚零件：1.4.3种零件组变成ZZ
                         */
                         if substring(xxppif_content,52,1) = "G" then do:
                            put stream batchdata "~"O~"".
                         end.
                         else do:
                            put stream batchdata "~"ZZ~"".
                         end.
                      end.
                   end. /*end of strTmp = "M"*/
                
                   /*pur/mfg <> p BOTH IN SITE-B AND SITE-C*/
                   if strTmp <>"M" then do:  /*非自制部分*/
                      /*
                        2、虚零件            -〉实零件：1.4.3中零件组变成RAW，在13.4中增加DCEC-B地点的信息，并更改P/M和虚实的值。
                        4、自制+ 实（八大件）-〉实零件：1.4.3中零件组变成RAW， 在13.4中更改P/M的值。
                      */
                      put stream batchdata "~"RAW~"".
                   end.
                   
                end.
            end.
            else do:
                if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do:
                
                find first code_mstr no-lock where code_fldname = "52"
                                             and code_value = substring(xxppif_content,52,1) use-index code_fldval
                                             no-error.
                if available code_mstr then do:
                   /*code_cmmt.yes代表采购件*/
                   if code_cmmt = "yes" then do:
                      strTmp = "RAW".
                   end.
                   else do:
                      find first code_mstr no-lock where code_fldname = "51"
                                                     and code_value = substring(xxppif_content,51,1) use-index code_fldval
                                                     no-error.
                      if code_cmmt = "no" then do: /*实件*/
                         strTmp = "M".  /*针对于八大件*/
                      end.
                      else do:
                         strTmp = "ZZ".
                      end.
                   end.
                end.
                else do:
                   strTmp = "ZZ".
                end.
                
                if substring(xxppif_content,52,1) = "G" then strTmp = "O".
                
                /*
                    if substring(xxppif_content,52,1) = "P" then
                        strTmp = "RAW".
                    else
                        strTmp = "ZZ".
                */
                end.
                else strTmp = "58B".
                put stream batchdata "~"" strTmp "~"".
            end.
            
        end.
