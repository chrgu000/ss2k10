/*xxppif_tr_code = "SOIA" or xxppif_tr_code = "SOIC"*/
/*Last Modified BY:Li Wei , Date:2005-12-7 *lw01* */

        for each xxppif_log exclusive-lock where xxppif_tr_id >= trid_begin and
        (xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC" 
        or xxppif_tr_code = "SOIA" or xxppif_tr_code = "SOIC"):
            run SET_TRAN_DATE(6).
            if xxppif_tr_date = ? then do:
                xxppif_err = 2.
                xxppif_msg = "传输日起格式错误 YYMMDD .".
                next.
            end.
/*          xxppif_part = trim(substring(xxppif_content,12,16)). */

            assign xxppif_part = trim(substring(xxppif_content,12,12)).
/*MJH007*/  /*判断是否有本地item MJH007*/
/*MJH007*/  localitem = substring(xxppif_content,81,16).
/*MJH007*/  if trim(localitem) <> "" then do:
/*MJH007*/     assign xxppif_part = trim(localitem).
/*MJH007*/  end.
            
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
            if (xxppif_tr_code = "pdia" or xxppif_tr_code = "soia") and available pt_mstr then do:
               /*已经存在item，对于pdia/soia报错*/
               xxppif_err = 1.
               xxppif_msg = "零件基本信息1.4.3存在".
            end.
            if (xxppif_tr_code = "pdic" or xxppif_tr_code = "soic") and not available pt_mstr then do:
               /*不存在item,对于pdic/soic报错*/
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
                strTmp = "EA". /*MJH007*/
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
/*              strTmp = trim(substring(xxppif_content,30,25)). */
                strTmp = trim(substring(xxppif_content,26,25)).
            else strTmp = "".
            if length(strTmp) > 24 then do:
                xxppif_err = 1.
                xxppif_msg = "零件描述超过24位".
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
                    xxppif_msg = "影响代码必须是10或者40.".
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
                    xxppif_msg = "零件状态代码不存在:" + strTmp.
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
            if(xxppif_tr_code = "PDIA" or xxppif_tr_code = "PDIC") then do:
/*              if substring(xxppif_content,56,1) = "P" then  */
                /*if substring(xxppif_content,52,1) = "P" then MJH007*/
                
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
                                                     and code_value = substring(xxppif_content ,51,1) 
                                                     use-index code_fldval
                                                     no-error.
                      if code_cmmt = "no" then do:
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
            end.
            else strTmp = "58B".
            if not can-find (first code_mstr where code_fldname = "pt_group"
            and code_value = strTmp) then do:
                xxppif_err = 2.
                xxppif_msg = "零件组不存在:" + strTmp.
                next.
            end.
            
            /*ITEM SITE-PLAN DATA  MAINT IN .13.4 ZZPPPSMT02-1.P*/
            /*SHOP ORDER*/
            
            if xxppif_tr_code = "SOIA" or xxppif_tr_code = "SOIC" then do:
                /*SO1 CREATE BOM IN SITE-B*/
                find first code_mstr no-lock where code_fldname = "so site"
                                               and code_value = substring(xxppif_part,1,3) 
                                               use-index code_fldval no-error.
                if available code_mstr and code_cmmt = "dcec-b" then do:
                    find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-B no-error.
                    if not available ptp_det then do:
                        put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-B "~"" skip.
                     /* put stream batchdata "~"M~"" at 1         " ~"" string(xxppif_part + "ZZ") format "x(18)" "~" ~"" string(xxppif_part + "ZZ") format "x(18)" "~" n". */
               /*tfq*/  put stream batchdata "~"M~"" at 1  " - n" " ~"" string(xxppif_part + "ZZ") format "x(18)" "~" ~"" string(xxppif_part + "ZZ") format "x(18)" "~" ".       
                    end.
                    find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                    if not available ptp_det then do:
                        put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                    /*  put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" n". */
                /*tfq*/ put stream batchdata "~"M~"" at 1 " - n" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".      
                    end.
                end.
                /*SO2 CREATE BOM IN SITE-C*/
                else if available code_mstr and code_cmmt = "dcec-c" then do:
                    find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                    if not available ptp_det then do:
                        put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                  /*    put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" n".  */
             /*tfq*/    put stream batchdata "~"M~"" at 1 " - n" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".      
                    end.
                end.
                else if not available code_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "通用代码 so site 没有维护".
                    next.
                end.
                else do:
                    xxppif_err = 2.
                    xxppif_msg = "通用代码 so site :" + substring(xxppif_part,1,3)  + " not maintaince".
                    next.
                end.
            end.
            else do:    /*PDIA PDIC*/
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
                   xxppif_msg = "通用代码 52 :" + strTmp  + "没有维护.".
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
                   xxppif_msg = "通用代码 51 :" + strTmp1  + " 没有维护.".
                   next.
                end.
                
              if xxppif_tr_code = "PDIA" then do:
                if strTmp = "M" then do: /*自制件*/
                   if (strTmp1 <> "P" and strTmp1 <> "X") then do: /*实件*/
                      find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                      if not available ptp_det then do:
                          put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                      /* put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" n". */
                 /*tfq*/ put stream batchdata "~"M~"" at 1 " - n" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".     
                      end.
                      /*下面原来没有，现在添加 MJH007*/
                      find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-B no-error.
                      if not available ptp_det then do:
                          put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-B "~"" skip.
                          /*put stream batchdata "~"M~"" at 1 " ~"" xxppif_part "~" ~"" xxppif_part "~" n". */
                     /*   put stream batchdata "~"M~"" at 1        " ~"" string(xxppif_part) format "x(18)" "~" ~"" string(xxppif_part) format "x(18)" "~" n".*/
                 /*tfq*/  put stream batchdata "~"M~"" at 1 " - n" " ~"" string(xxppif_part) format "x(18)" "~" ~"" string(xxppif_part) format "x(18)" "~" ".     
                      end.
                   end.
                   /*pur/mfg = m and phantom = y    BOTH IN SITE-B AND SITE-C*/
                   if (strTmp1 = "P" or strTmp1 = "X") then do: /*虚件*/
                      find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                      if not available ptp_det then do:
                         put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                  /*     put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" y".   */
                 /*tfq*/ put stream batchdata "~"M~"" at 1 " - y" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".    
                      end.
                      /*
                      find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-B no-error.
                      if not available ptp_det then do:
                         put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-B "~"" skip.
                         put stream batchdata "~"M~"" at 1 " ~"" string(xxppif_part + "ZZ") format "x(18)" "~" ~"" string(xxppif_part + "ZZ") format "x(18)" "~" y". 
                      end.
                      */
                   end.
                end. /*end of strTmp = "M"*/
                
                /*pur/mfg <> p BOTH IN SITE-B AND SITE-C*/
                if strTmp <>"M" then do:
                    find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                    if not available ptp_det then do:
                        put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                        put stream batchdata "~"P~"" at 1. 
                    end.
                    find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-B no-error.
                    if not available ptp_det then do:
                        put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-B "~"" skip.
                        put stream batchdata "~"P~"" at 1. 
                    end.
                end.
              end. /*if xxppif_tr_code = "pdia"*/
              else do :
                /*if xxppif_tr_code = "pdic"*/
                if strTmp = "M" then do: /*自制件*/
                   if (strTmp1 <> "P" and strTmp1 <> "X") then do: /*实件*/
                      
                      put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
              /*      put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" n".   */
              /*tfq*/ put stream batchdata "~"M~"" at 1 " - n" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".
                      put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-B "~"" skip.
               /*     put stream batchdata "~"M~"" at 1        " ~"" string(xxppif_part) format "x(18)" "~" ~"" string(xxppif_part) format "x(18)" "~" n". */
             /*tfq*/  put stream batchdata "~"M~"" at 1 " - n" " ~"" string(xxppif_part) format "x(18)" "~" ~"" string(xxppif_part) format "x(18)" "~" ".    
                      find first ps_mstr no-lock where ps_par = xxppif_part and ps_comp <> ""  no-error.
                      if available ps_mstr then do:
                         /*提示删除bom*/
                         xxppif_err = 3.  
                         xxppif_msg = "请删除DCEC-B 地点 Bom  " + xxppif_part + "的结构".
                         /*xxppif_msg = "请删除Bom  " + xxppif_part + "的结构1 site:" + ps__chr01.*/
                      end.
                      
                   end.
                   /*pur/mfg = m and phantom = y    BOTH IN SITE-B AND SITE-C*/
                   if (strTmp1 = "P" or strTmp1 = "X") then do: /*虚件*/
                      find first ptp_det  where ptp_part = xxppif_part and ptp_site = SITE-B no-error.
                      if  available ptp_det then do:
                         /*提示删除*/
                         /*
                         xxppif_err = 3.
                         xxppif_msg = "delete item " + xxppif_part + "'s site : " + site-b + "planning data".
                         */
                         delete ptp_det.
                      end.
                      find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                      if available ptp_det then do:
                         put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                     /*  put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" y".  */
                 /*tfq*/ put stream batchdata "~"M~"" at 1 " - y" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".
                      end.
                      else do:
                        localitem = substring(xxppif_content,81,16).
                        if trim(localitem) <> "" then do:
                           /*对于本地件，pdic类型，对于系统是新的来说*/
                           put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                    /*     put stream batchdata "~"M~"" at 1        " ~"" xxppif_part "~" ~"" xxppif_part "~" y".  */
                   /*tfq*/ put stream batchdata "~"M~"" at 1 " - y" " ~"" xxppif_part "~" ~"" xxppif_part "~" ".     
                        end.
                      end.
                      
                      find first ps_mstr no-lock where ps_par = (xxppif_part + "ZZ") and ps__chr01 = site-b  no-error.
                      if not available ps_mstr then do:
                         find first ps_mstr no-lock where ps_par = xxppif_part and ps__chr01 = site-c  no-error.
                         if available ps_mstr then do:
                            xxppif_err = 3.
                            xxppif_msg = "建立" + site-b + "地点的 Bom " + xxppif_part + "结构".
                         end.
                      end.
                      
                      
                      
                   end.
                end. /*end of strTmp = "M"*/
                
                /*pur/mfg <> p BOTH IN SITE-B AND SITE-C*/
                if strTmp <>"M" then do: /*实件*/
                    
                    put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-C "~"" skip.
                    put stream batchdata "~"P~"" at 1 " ~"" " " "~" " /*~"" " " "~  lw01*/ "n". 
                
                
                    put stream batchdata "~"" at 1  xxppif_part format "x(16)" "~"" " ~"" SITE-B "~"" skip.
                    put stream batchdata "~"P~"" at 1 " ~"" " " "~" " /*~"" " " "~ lw01 */ "n". 
                    
                    
                    find first ps_mstr no-lock where ps_par = xxppif_part and ps_comp <>"" no-error.
                    if available ps_mstr then do:
                       /*提示删除bom*/
                       xxppif_err = 3.
                       xxppif_msg = "请删除Bom " + xxppif_part + " 的结构". /* ，Site：" + ps__chr01.20050524*/
                    end.
                end.
              end. /*if xxppif_tr_code = "pdic"*/
            end.
            /*END OF - ITEM SITE-PLAN DATA  MAINT IN .13.4 ZZPPPSMT02-1.P*/
            
        end.
