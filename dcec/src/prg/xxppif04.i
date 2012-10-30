/*MJH007   Cancle struct type 's verify*/
        siteerr = 0.
      
        for each xxppif_log exclusive-lock where xxppif_tr_id >= trid_begin and
        (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC" 
        or xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC"):
            xxppif_part = trim(substring(xxppif_content,24,12)). /*COMPONENT*/

/*MJH007    判断是否有本地的item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(linedata,85,16)) <> "" then do :
/*MJH007*/     xxppif_part = trim(substring(linedata,85,16)).
/*MJH007*/  end.
            
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
            if not available pt_mstr then do:
               xxppif_err = 2.
               xxppif_msg = "子件基本信息  " + xxppif_part + " 不存在" .
               next.
            end.

            if siteerr = 1 then do:
                xxppif_err = 2.
                xxppif_msg = "Site does not exist, " + SITE-B + "/" + SITE-C.
                next.
            end.
            else if siteerr = 2 then do:
                xxppif_err = 2.
                xxppif_msg = "User does not have access to site " + SITE-B + "/" + SITE-C.
                next.
            end.
            
            run SET_TRAN_DATE(6).
            if xxppif_tr_date = ? then do:
                xxppif_err = 2.
                xxppif_msg = "传输日起格式错误 YYMMDD .".
                next.
            end.
            
            /*PS_PS_code P, O, D, X, J, OR SPACE*/
/*          strTmp = substring(xxppif_content,69,1). */

            
            /*PS_PAR*/
/*            strTmp = trim(substring(xxppif_content,12,16)).  */
            strTmp = trim(substring(xxppif_content,12,12)).
            
/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.

            
            find first pt_mstr no-lock where pt_part = strTmp no-error.
            if not available pt_mstr then do:
               xxppif_err = 2.
               xxppif_msg = "父零件 " + strTmp + " 基础信息不存在" .
               next.
            end.
            
            if ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and substring(strTmp,1,3) = "SO2")
             or (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC") then do:

                find first ptp_det no-lock where ptp_site = SITE-C 
                and ptp_part = strTmp no-error.
                if not available ptp_det then do:
                    xxppif_err = 2.
                    xxppif_msg = "零件地点计划信息不存在:" + strTmp.
                    next.
                end.
                
                find first ps_mstr no-lock where
                ((ps_par = strTmp or ps_comp = strTmp) and ps__chr01 <> SITE-C) no-error.
                if available ps_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "BOM Par " + strTmp + "Exists in Other Site" + ps__chr01.
                    next.
                end.
                find first ptp_det where ptp_site = SITE-C and ptp_part = xxppif_part no-lock no-error.
                if not available ptp_det then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data does not exist1:" + xxppif_part.
                    next.
                end.
                
                if (available ptp_det and ptp_phantom) or (not available pt_mstr) then do:
                    find first ps_mstr where (ps_par = xxppif_part) and ps__chr01 <> SITE-C no-lock no-error.
                    if available ps_mstr then do:
                        xxppif_err = 2.
                        xxppif_msg = "Component: " + xxppif_part + " exist BOM in other site(" + ps__chr01 + ")".
                        next.
                    end.
                end.   
                 
            end.
            
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
            find bom_mstr no-lock where bom_parent = xxppif_part no-error.
            if available bom_mstr then do:
                if bom_fsm_type = "FSM" then do:
                    xxppif_err = 2.
                    xxppif_msg = "THIS IS A SERVICE BILL OF MATERIAL:" + xxppif_part.
                    next.
                end.
                if not available pt_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "Only Part can be PS_Comp in site " + SITE-C.
                    next.
                end.
                if bom__chr01 <> SITE-C and not available pt_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "BOM CODE SITE NOT site " + SITE-C.
                end.
            end.  /* if available bom_mstr */
            if available pt_mstr then do:
                if pt_joint_type = "5" then do:
                    xxppif_err = 2.
                    xxppif_msg = "COMPONENT MAY NOT BE A BASE PROCESS".
                    next.
                end.
            end.

/*          strTmp = trim(substring(xxppif_content,12,16)). */
            strTmp = trim(substring(xxppif_content,12,12)).

/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.
            
            find first pt_mstr no-lock where pt_part = strTmp no-error.
            if not available pt_mstr then do:
               xxppif_err = 2.
               xxppif_msg = "父零件  " + strTmp + " 基础信息不存在" .
               next.
            end.

            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error.
            
            /*if substring(strTmp,1,3) = "SO1" or (available ptp_det and ptp_phantom = yes) then do:*/
            
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) use-index code_fldval no-error.
            if (available code_mstr and code_cmmt = SITE-B) or (available ptp_det and ptp_phantom = yes) then do:
                if not available ptp_det then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data does not exist2:" + strTmp.
                    next.
                end.

                find first ps_mstr no-lock where
                ((ps_par = (strTmp + "ZZ") ) and ps__chr01 <> SITE-B) no-error.
                if available ps_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "BOM Par " + strTmp + "Exists in Other Site" + ps__chr01.
                    next.
                end.

                find first ptp_det where ptp_site = SITE-C and ptp_part = xxppif_part no-lock no-error.
                if not available ptp_det then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data does not exist3:" + xxppif_part.
                    next.
                end.
                if (available ptp_det and ptp_phantom) or (not available pt_mstr) then do:
                    /*
                    find first ps_mstr where (ps_par = xxppif_part) and ps__chr01 <> SITE-B no-lock no-error.
                    if available ps_mstr then do:
                        xxppif_err = 2.
                        xxppif_msg = "Component: " + xxppif_part + " exist BOM in other site(" + ps__chr01 + ")".
                        next.
                    end.
                    */
                end.    
            end.
                        
/*          run SET_EFF_DATE(44).   /*HEER MEANS EFF_DATE. START OR END.*/ */
            run SET_EFF_DATE(36).   /*HEER MEANS EFF_DATE. START OR END.*/
            if xxppif__dte01 = ? then do:
                xxppif_err = 2.
                xxppif_msg = "Effect Date Error.".
                next.
            end.
            /*
            PDSC
            SOSC

            */
            if trim(substring(xxppif_content,5,1)) <> "I" and
               trim(substring(xxppif_content,5,1)) <> "O"
               then do:
               if (xxppif_tr_code ="PDSC" or xxppif_tr_code = "SOSC") and trim(substring(xxppif_content,5,1)) = " " then do:
               end.
               else do:
                  xxppif_err = 2.
                  xxppif_msg = " Action Code 错误".
                  next.
               end.
                
            end.
            /*START DATE MUST BEFOR END DATE*/
            if trim(substring(xxppif_content,5,1)) = "O" then do:
/*              strTmp = trim(substring(xxppif_content,12,16)).  */
                strTmp = trim(substring(xxppif_content,12,12)).

/*MJH007        判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/      if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/         strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/      end.
            
                find first pt_mstr no-lock where pt_part = strTmp no-error.
                if not available pt_mstr then do:
                   xxppif_err = 2.
                   xxppif_msg = "父零件  " + strTmp + " 基础信息不存在" .
                   next.
                end.

                find last ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
                if available ps_mstr then do:
                    if ps_start <> ? and ps_start > xxppif__dte01 then do:
                        xxppif_err = 2.
                        xxppif_msg = "起始日期必须大于截止日期.".
                        next.
                    end.
                end.
            end.            

            
            
            if trim(substring(xxppif_content,5,1)) = "I" then do:
               iPos = 0. 
               do while iPos < 7:   /*+999.999*/
/*                  if index(" 0123456789",substring(xxppif_content,60 + iPos,1)) = 0 then  */
                    if index("+- 0123456789",substring(xxppif_content, 52 + iPos,1)) = 0 then 
                        iPos = 10.
                    iPos = iPos + 1.
                end.
                if iPos >= 10 then do:
                    xxppif_err = 2.
                    xxppif_msg = "数量格式错误.".
                    next.
                end.
               
               if substring(xxppif_content,52,1) = "+" then do:
                  xxppif_qty_chg = decimal(substring(xxppif_content,53,3)) 
                                + (decimal(substring(xxppif_content,56,3)) / 1000).
               end.
               if substring(xxppif_content,52,1) = "-" then do:
                  xxppif_qty_chg = 0 - (decimal(substring(xxppif_content,53,3)) 
                                     + (decimal(substring(xxppif_content,56,3)) / 1000)
                                      ).
               end.
            end.


            
            /* CHECK FOR CYCLIC PRODUCT STRUCTURES */
            if trim(substring(xxppif_content,5,1)) = "I" then do:
                newBom = no.
                find first ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part
                and ps_ref = "" and ps_start = xxppif__dte01 no-error.
                if not available ps_mstr then do:
                    find first pt_mstr no-lock where pt_part = strTmp no-error.
                    ptstatus1 = pt_status.
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item Status Not Allowed ADD-PS".
                        next.
                    end.
                    find first pt_mstr no-lock where pt_part = xxppif_part no-error.
                    ptstatus1 = pt_status.
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item Status Not Allowed ADD-PS".
                        next.
                    end.

                    newBom = yes.
                    create ps_mstr.
                    assign
                         ps_par = strTmp
                         ps_comp = xxppif_part
                         ps_start = xxppif__dte01.
                end.
                ps_recno = recid(ps_mstr).
               	global_user_lang_dir = "ch/" .   /*tfq*/
                /*tfq {gprun.i ""xxbmpsmta.p""}  */
                /*tfq*/  {gprun.i ""yybmpsmta.p""}
                if newBom then
                    delete ps_mstr.
                
                if ps_recno = 0 then do:
                    xxppif_err = 2.
                    xxppif_msg = "Cyclic Product Structures".
                    next.
                end.
                newBom = no.
                find first ps_mstr no-lock where ps_par = strTmp + "ZZ" and ps_comp = xxppif_part
                and ps_ref = "" and ps_start = xxppif__dte01 no-error.
                if not available ps_mstr then do:
                    find first pt_mstr no-lock where pt_part = strTmp no-error.
                    ptstatus1 = pt_status.
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item Status Not Allowed ADD-PS".
                        next.
                    end.
                    find first pt_mstr no-lock where pt_part = xxppif_part no-error.
                    ptstatus1 = pt_status.
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item Status Not Allowed ADD-PS".
                        next.
                    end.
                    newBom = yes.
                    create ps_mstr.
                    assign
                         ps_par = strTmp + "ZZ"
                         ps_comp = xxppif_part
                         ps_start = xxppif__dte01.
                end.
                ps_recno = recid(ps_mstr).
                
               /*tfq {gprun.i ""xxbmpsmta.p""} */
                /*tfq*/  {gprun.i ""yybmpsmta.p""}
                if newBom then
                    delete ps_mstr.
                
                if ps_recno = 0 then do:
                    xxppif_err = 2.
                    xxppif_msg = "Cyclic Product Structures".
                    next.
                end.
            end. /* CHECK CYCLIC END*/
                        
/*          if substring(xxppif_content,69,1) = "X" then do: */
            /* MJH007
            if substring(xxppif_content,61,1) = "X" then do:
                find first ps_mstr no-lock where ps_par = xxppif_part
                and ps_ps_code = "J" no-error.
                if available ps_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "A JOINT PRODUCT MAY NOT BE A COMPONENT IN A PHANTOM STRUCTURE".
                    next.
                end.
            end.
            */
            /* VERIFY CHECK END.*/
            /* CIM LOAD DATA PREPARE BEGIN*/
            
            /* BOM CODE*/
            /* IF SHOP ORDER IF LIKE SO1XXX, CREAT BOM IN SITE-B*/
            /* IF PT_PHANTOM = YES, THEN CREAT BOM IN SITE-B*/
/*          strTmp = trim(substring(xxppif_content,12,16)). */
            strTmp = trim(substring(xxppif_content,12,12)).
            
/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.
            
            
            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error. /*SITE-B MJH007*/
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) use-index code_fldval no-error.
            /*if substring(strTmp,1,3) = "SO1" or (available ptp_det and ptp_phantom = yes) then do:*/
            if (not available code_mstr) and substring(strTmp,1,2)= "SO" then do:
               xxppif_err = 2.
               xxppif_msg = "请维护通用代码 so site :" + substring(strTmp,1,3).
               next.
            end.
            if (available code_mstr and code_cmmt = site-b) or (available ptp_det and ptp_phantom = yes) then do:
                find first bom_mstr no-lock where bom_parent = (strTmp + "ZZ") no-error.
                find first ptp_det where ptp_part = strTmp no-lock no-error.
                if ptp_pm_code <> "m" then do:
                    xxppif_err = 2.
                    xxppif_msg = "PAR P/M <> 'M'".
                    next.
                end.
                find first ptp_det where ptp_part = strTmp  and ptp_site <> SITE-B no-lock no-error.
                if not available ptp_det then do:
                    xxppif_err = 2.
                    xxppif_msg = "不允许对零件: '" + strTmp + "' 生成地点: '" + SITE-B + "' 的产品结构代码".
                    next.
                end.

                if not available bom_mstr then do:
                    put stream batchdata "~"" at 1 strTmp format "X(16)" "~"" skip.
                    put stream batchdata "-" at 1 skip.
                    put stream batchdata "-" at 1 skip.
                end.
            end.
            
            /*对于子件是虚件，并且bom code 不存在的*/
            strTmp =  trim(substring(xxppif_content,24,12)).
            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error. /*SITE-B MJH007*/
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) use-index code_fldval no-error.
            /*if substring(strTmp,1,3) = "SO1" or (available ptp_det and ptp_phantom = yes) then do:*/
            if (not available code_mstr) and substring(strTmp,1,2)= "SO" then do:
               xxppif_err = 2.
               xxppif_msg = "请维护通用代码so site :" + substring(strTmp,1,3).
               next.
            end.
            
            if (available code_mstr and code_cmmt = site-b) or (available ptp_det and ptp_phantom = yes) then do:
                find first bom_mstr no-lock where bom_parent = (strTmp + "ZZ") no-error.
                find first ptp_det where ptp_part = strTmp no-lock no-error.
                if ptp_pm_code <> "m" then do:
                    xxppif_err = 2.
                    xxppif_msg = "PAR P/M <> 'M'".
                    next.
                end.
                find first ptp_det where ptp_part = strTmp  and ptp_site <> SITE-B no-lock no-error.
                if not available ptp_det then do:
                    xxppif_err = 2.
                    xxppif_msg = "不允许对零件: '" + strTmp + "' 生成地点: '" + SITE-B + "' 的产品结构代码".
                    next.
                end.
                
                if not available bom_mstr then do:
                    put stream batchdata "~"" at 1 strTmp format "X(16)" "~"" skip.
                    put stream batchdata "-" at 1 skip.
                    put stream batchdata "-" at 1 skip.
                end.
            end.
            
        end.
