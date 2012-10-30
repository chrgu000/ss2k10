/**Last Modified by Li Wei , date:2005-12-6 ECO *lw01*
**/
        siteerr = 0.

        for each xxppif_log exclusive-lock where xxppif_tr_id >= trid_begin 
                                             and (xxppif_tr_code = "PDSA" or 
                                                  xxppif_tr_code = "PDSC" or 
                                                  xxppif_tr_code = "SOSA" or 
                                                  xxppif_tr_code = "SOSC"):
            xxppif_part = trim(substring(xxppif_content,24,12)). /*COMPONENT*/
            
/*MJH007    判断是否有本地的item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,85,16)) <> "" then do :
/*MJH007*/     xxppif_part = trim(substring(xxppif_content,85,16)).
/*MJH007*/  end.
            
            /*找本父有没有，如果有的话，不做任何处理*/
            if xxppif__log02 = yes then do:
               xxppif_err = 1.   /*20050520*/
               /*lw01
               next.  /*第二 ，三种情况*/
               */
            end.
            
            if xxppif__log02 = no and xxppif__log01 = yes then do:
               /*第一种情况，查找康明斯子件是否在系统当中存在*/
               find first ps_mstr no-lock where ps_par = trim(substring(xxppif_content,12,12)) 
                                            and ps_comp = xxppif_part  no-error.
               if not available ps_mstr then do:
                  xxppif_err = 1.   /*20050520*/
                  /*
                  next . /*第一种情况，如果康明斯结构不存在的话，不进行新建*/
                  */
                  
               end.
               else do:
                  if ps_end <> ? then do:
                     xxppif_err = 1.   /*20050520*/
                     /*lw01
                     next.  /*如果ps_end 不等于空，不做任何处理*/
                     */
                  end.
                  else do:
                     /*继续操作，需要更改日期到传过来的日期-1*/
                     /*
                     xxppif_err = 3.
                     xxppif_msg = "继续操作，需要更改日期到传过来的日期-1" .
                     */
                  end.
               end.
            end. /*xxppif__log02 = no and xxppif__log01 = yes*/
            
            find first pt_mstr no-lock where pt_part = xxppif_part no-error.
            if not available pt_mstr then do:
               xxppif_err = 2.
               xxppif_msg = "子件： " + xxppif_part + " 零件基础信息不存在" .
               next.
            end.
            
            if siteerr = 1 then do:
                xxppif_err = 2.
                xxppif_msg = "地点不存在, " + SITE-B + "/" + SITE-C.
                next.
            end.
            else if siteerr = 2 then do:
                xxppif_err = 2.
                xxppif_msg = "用户没有地点权限： " + SITE-B + "/" + SITE-C.
                next.
            end.
            
            run SET_TRAN_DATE(6).
            if xxppif_tr_date = ? then do:
                xxppif_err = 2.
                xxppif_msg = "传入的日期格式错误 YYMMDD .".
                next.
            end.
            
            /*PS_PS_code P, O, D, X, J, OR SPACE*/
/*          strTmp = substring(xxppif_content,61,1). */
            
            /*MJH007
             * strTmp = substring(xxppif_content,61,1).
             * if strTmp <> "P" and strTmp <> " " and strTmp <> "O" and
             *    strTmp <> "D" and strTmp <> "X" then do:
             *      xxppif_err = 2.
             *      xxppif_msg = "Structur Type Error:" + strTmp.
             *      next.
             * end.
             * */
             
            /*PS_PAR*/
            strTmp = trim(substring(xxppif_content,12,12)).
            
/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.

            if substring(xxppif_content,1,5) = "PDSAO" then do:
                  find first ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
                  if not available ps_mstr then do:
                     next. /*对于pdsao来说，如果没有找到结构，不做任何处理*/
                  end.
            end.
            
            find first pt_mstr no-lock where pt_part = strTmp no-error.
            if not available pt_mstr then do:
               xxppif_err = 2.
               xxppif_msg = "父件基础信息不存在:  " + strTmp .
               next.
            end.
            
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) 
                                           use-index code_fldval no-error.
            /*
            if ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and substring(strTmp,1,3) = "SO2")
            or (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC") then do:
            */
            
            if ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and 
               (available code_mstr and code_cmmt = SITE-C))
             or (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC") then do:
                
                find first ptp_det no-lock where ptp_site = SITE-C 
                and ptp_part = strTmp no-error.
                if not available ptp_det  /*2004-08-25 17:17*/
                    and not can-find(first xxppif_log where xxppif_tr_id > trid_begin
                    and xxppif_part = strTmp and (xxppif_tr_code = "PDIA" or xxppif_tr_code = "SOIA"))
                then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data not exists:" + strTmp.
                    next.
                end.
                
                find first ps_mstr no-lock where ((ps_par = strTmp ) 
                                             and ps__chr01 <> SITE-C) 
                                             no-error.
                if available ps_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "BOM Par " + strTmp + "Exists in Other Site" +  ps__chr01.
                    next.
                end.

                find first ptp_det where ptp_site = SITE-C and ptp_part = xxppif_part no-lock no-error.
                if not available ptp_det 
                    and not can-find(first xxppif_log where xxppif_tr_id > trid_begin
                    and xxppif_part = strTmp and (xxppif_tr_code = "PDIA" or xxppif_tr_code = "SOIA"))
                then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data does not exist:" + xxppif_part.
                    next.
                end.
                
                if (available ptp_det and ptp_phantom) or (not available pt_mstr) then do:
                    find first ps_mstr where (ps_par = xxppif_part or ps_comp = xxppif_part) 
                                         and ps__chr01 <> SITE-C no-lock no-error.
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
            else do:
               xxppif_err = 2.
               xxppif_msg = "Component Item is not exist".
               next.
            end.
            
            
/*          strTmp = trim(substring(xxppif_content,12,16)).  */
            strTmp = trim(substring(xxppif_content,12,12)).
            

/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.
            
            find first pt_mstr no-lock where pt_part = strTmp no-error.
            if not available pt_mstr then do:
               xxppif_err = 2.
               xxppif_msg = "父零件 " + strTmp + "不存在" .
               next.
            end.
            
            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-B no-error.
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) 
                                           use-index code_fldval no-error.
            /*if substring(strTmp,1,3) = "SO1" or (available ptp_det and ptp_phantom = yes) then do:*/
            if (not available code_mstr) and substring(strTmp,1,2)= "SO" then do:
               xxppif_err = 2.
               xxppif_msg = "请维护通用代码 so site :" + substring(strTmp,1,3).
               next.
            end.

            if (available code_mstr and code_cmmt = SITE-B) or (available ptp_det and ptp_phantom = yes) then do:
                if (xxppif_tr_code <> "sosa" and xxppif_tr_code <> "sosc") and not available ptp_det 
                    and not can-find(first xxppif_log where xxppif_tr_id > trid_begin
                    and xxppif_part = strTmp and (xxppif_tr_code = "PDIA" or xxppif_tr_code = "SOIA"))
                then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data does not exist4:" + strTmp.
                    next.
                end.

                find first ps_mstr no-lock where
                ((ps_par = (strTmp + "ZZ") ) and ps__chr01 <> SITE-B) no-error.
                if available ps_mstr then do:
                    xxppif_err = 2.
                    xxppif_msg = "BOM Par " + strTmp + "Exists in Other Site" + ps__chr01.
                    next.
                end.
                
                find first ptp_det where ptp_site = SITE-B and ptp_part = xxppif_part no-lock no-error.
                if (xxppif_tr_code <> "sosa" and xxppif_tr_code <> "sosc") and not available ptp_det 
                    and not can-find(first xxppif_log where xxppif_tr_id > trid_begin
                    and xxppif_part = strTmp and (xxppif_tr_code = "PDIA" or xxppif_tr_code = "SOIA"))
                then do:
                    xxppif_err = 2.
                    xxppif_msg = "Item site-plan data does not exist5:" + xxppif_part.
                    next.
                end.
                
                if (available ptp_det and ptp_phantom) or (not available pt_mstr) then do:
                    find first ps_mstr where (ps_par = xxppif_part or ps_comp = xxppif_part) and ps__chr01 <> SITE-B no-lock no-error.
                    if available ps_mstr then do:
                        xxppif_err = 2.
                        xxppif_msg = "Component: " + xxppif_part + " exist BOM in other site(" + ps__chr01 + ")".
                        next.
                    end.
                end.    
            end.
            
/*          run SET_EFF_DATE(44).   /*HEER MEANS EFF_DATE. START OR END.*/ */
            run SET_EFF_DATE(36).   /*HEER MEANS EFF_DATE. START OR END.*/
            if xxppif__dte01 = ? then do:
                xxppif_err = 2.
                xxppif_msg = "传输的日期格式错误.".
                next.
            end.
            
            if trim(substring(xxppif_content,5,1)) <> "I" and
               trim(substring(xxppif_content,5,1)) <> "O"
               then do:
               if (xxppif_tr_code ="PDSC" or xxppif_tr_code = "SOSC") and trim(substring(xxppif_content,5,1)) = " " then do:
               end.
               else do:
                  xxppif_err = 2.
                  xxppif_msg = "Error Action Code".
                  next.
               end.
            end.
            
            /*起始日期必须大于截止日期*/
            
            if xxppif__log01 = yes then do:  /*只要是存在子件是本地件的，都把康明斯件cancle掉*/
                strTmp = trim(substring(xxppif_content,12,12)).
                
/*MJH007        判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/      if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/         strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/      end.
                
                find last ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
                if available ps_mstr then do:
/*MJH007*/         if xxppif__log01 = yes then do:
/*MJH007*/            assign xxppif__dte01 = xxppif__dte01 - 1. /*如果有本地子件子件存在的话，康明斯子件的end date = xxppif__dte01 -1*/
/*MJH007*/         end.
                   if ps_start <> ? and ps_start > xxppif__dte01 then do:
                      xxppif_err = 2.
                      xxppif_msg = "起始日期必须大于截止日期.".
                      next.
                   end.
                end.
                else do:
                   /*
                   next. /*本地子件存在，并且是新建的康明斯结构，不做进一步处理*/
                   */
/*MJH007*/         if xxppif__log01 = yes then do:
/*MJH007*/            assign xxppif__dte01 = xxppif__dte01 - 1. /*如果有本地子件子件存在的话，康明斯子件的end date = xxppif__dte01 -1*/
/*MJH007*/         end.
                end.
            end.
            else do:
                if trim(substring(xxppif_content,5,1)) = "O" then do:
                    strTmp = trim(substring(xxppif_content,12,12)).
                    
    /*MJH007        判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
    /*MJH007*/      if trim(substring(xxppif_content,67,16)) <> "" then do :
    /*MJH007*/         strTmp = trim(substring(xxppif_content,67,16)).
    /*MJH007*/      end.
                    
                    
                    /********************************************/
                    find last ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
                    if available ps_mstr then do:
                       if ps_start <> ? and ps_start > xxppif__dte01 then do:
                           xxppif_err = 2.
                           xxppif_msg = "起始日期必须大于截止日期.".
                           next.
                       end.
                       if ps_end <> ? then do:
                           xxppif_err = 2.
                           xxppif_msg = "已经失效掉了，请查证: " + string(ps_end).
                           next.
                       end.
                    end.
                end.
            end.
            
            if trim(substring(xxppif_content,5,1)) = "I" then do:
               iPos = 0. 
               do while iPos < 7:   /*+999.999*/
                   if index("+- 0123456789",substring(xxppif_content, 52 + iPos,1)) = 0 then 
                      iPos = 10.
                   iPos = iPos + 1.
               end.
               if iPos >= 10 then do:
                  xxppif_err = 2.
                  xxppif_msg = "传输的数量数据格式错误.".
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
            else do:
               xxppif_qty_chg = ?.
            end.
            
            
            
            /* CHECK FOR CYCLIC PRODUCT STRUCTURES */
            if trim(substring(xxppif_content,5,1)) = "I" then do:
                newBom = no.
                find first ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part
                and ps_ref = "" and ps_start = xxppif__dte01 no-error.
                if not available ps_mstr then do:
                    find first pt_mstr no-lock where pt_part = strTmp no-error.
                    if available pt_mstr then
                        ptstatus1 = pt_status.
                    else ptstatus1 = "".
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item Status Not Allowed ADD-PS".
                        next.
                    end.
                    find first pt_mstr no-lock where pt_part = xxppif_part no-error.
                    if available pt_mstr then
                       ptstatus1 = pt_status.
                    else ptstatus1 = "".
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
                {gprun.i ""yybmpsmta.p""}        /*tfq*/
              /*  {gprun.i ""xxbmpsmta.p""}   */
                
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
                    if available pt_mstr then
                    ptstatus1 = pt_status.
                    else ptstatus1 = "".
                    substring(ptstatus1,9,1) = "#".
                    if can-find(isd_det where isd_status = ptstatus1
                    and isd_tr_type = "ADD-PS") then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item Status Not Allowed ADD-PS".
                        next.
                    end.
                    find first pt_mstr no-lock where pt_part = xxppif_part no-error.
                    if available pt_mstr then
                    ptstatus1 = pt_status.
                    else ptstatus1 = "".
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
            /*tfq*/    {gprun.i ""yybmpsmta.p""}
               /*tfq {gprun.i ""xxbmpsmta.p""}  */
                if newBom then
                    delete ps_mstr.
                
                if ps_recno = 0 then do:
                    xxppif_err = 2.
                    xxppif_msg = "Cyclic Product Structures".
                    next.
                end.
            end. /* CHECK CYCLIC END*/
                        
/*          if substring(xxppif_content,69,1) = "X" then do: */
            /*  MJH007
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
            if trim(substring(xxppif_content,5,1)) = "I" then do:
               find first ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part
                                            and ps_ref = "" and ps_end = xxppif__dte01 no-error.
               if available ps_mstr then do:
                  xxppif_err = 2.
                  xxppif_msg = "Date ranges may not overlap.".
                  next.
               end.
               
            end.
            /* VERIFY CHECK END.*/
            /* CIM LOAD DATA PREPARE BEGIN*/
            
            
            
                                    
            /*BOM BEGIN - SITE-C WITHOUT ZZ*/
            /*FOR SHOP ORDER STRUCTURE, IF SHOP ORDER IS LIKE SO2XXX THEN CREATE BOM IN SITE-C*/
            /*FOR ITEM STRUCTURE, CREATE*/
            /*SITE*/
            /*PS_PAR*/
/*            strTmp = trim(substring(xxppif_content,12,16)). */
            strTmp = trim(substring(xxppif_content,12,12)).

/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.

            /*对于新增的bom，检查一下当前的系统中是否存在这个bom如果存在，不做处理20050520*/
            if xxppif_tr_code = "sosa" then do:
               find first ps_mstr no-lock where ps_par = strtmp and ps_comp = xxppif_part no-error.
               if available ps_mstr then do:
                  
/*                  xxppif_msg = "SOSA类型中在系统已经存在 " + strtmp + "这个bom结构". lw01*/
/*lw01*/          if trim(substring(xxppif_content,5,1)) = "O" then do:
/*lw01*/              xxppif_err = if ps_end <= xxppif__dte01 then 2 else 0.
/*lw01*/              xxppif_msg = "SOSAO类型中子零件 " + xxppif_part + "在 " + strtmp + "已经失效".
                  end.
                  else do:
                      xxppif_err = 2.
                      xxppif_msg = "SOSA类型中子零件 " + xxppif_part + "在 " + strtmp + "已经存在". 
                  end.
                  /*next. lw01*/
               end.
            
               /*子零件失效*/
               if trim(substring(xxppif_content,5,1)) = "O" then xxppif__dte01 = xxppif__dte01 - 1.
            end.
            
            if substring(xxppif_log.xxppif_content,1,5)="PDSAI" then do:
               if not can-find(first xxppiflog where xxppiflog.xxppif_tr_id >= trid_begin
                                             and xxppiflog.xxppif_tr_code = "PDSA"
                                             and substring(xxppiflog.xxppif_content,1,5)="PDSAO"
                                             and (
                                                  trim(substring(xxppif_content,24,12)) = xxppif_log.xxppif_part
                                               or trim(substring(xxppif_content,85,16)) = xxppif_log.xxppif_part
                                               )
                                             ) then do:
                  find first ps_mstr no-lock where ps_par = strtmp and ps_comp = xxppif_part no-error.
                  if available ps_mstr then do:
                     xxppif_err = 2.
                     xxppif_msg = "PDSAI类型中,子零件 " + xxppif_part + "在 " + strtmp + "存在".
                     next.
                  end.
               end.
            end.            
            
            
            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error.
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) 
                                           use-index code_fldval no-error.
            /*
            if ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and substring(strTmp,1,3) = "SO2")
             or (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC") then do:
            */
            

            if ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and 
                (available code_mstr and code_cmmt = SITE-C))
             or (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC") then do:
                
                /*PS_PAR*/
                strTmp = trim(substring(xxppif_content,12,12)).

                
                
/*MJH007        判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/      if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/         strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/      end.
                
                 
                /*检测start date是否符合要求*/
                
                put stream batchdata "~"" at 1 SITE-C "~"" skip.
                
                
                put stream batchdata "~"" at 1 strTmp format "x(18)" "~"" skip.
                /*PS_COMP & ref*/
                put stream batchdata "~"" at 1 xxppif_part "~" - ".
                /*PS_START*/
                if trim(substring(xxppif_content,5,1)) = "I" then do:
                   effdate = xxppif__dte01.
                end.
                else do:
                    find last ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
                    if available ps_mstr then 
                        effdate = ps_start.
                    else effdate = ?.
                end.
                /*lw01
                put stream batchdata effdate skip.
                */  

                /*lw01*/
                put stream batchdata unformatted 
                       string(day(effdate),"99") + "/" +
                       string(month(effdate),"99") + "/" +
                       substring(string(year(effdate)),3,2) skip.
                
                
                /*PS_QTY_PER*/
                if trim(substring(xxppif_content,5,1)) = "I" then do:
                    put stream batchdata xxppif_qty_chg format "->>9.999" at 1.
                end.
                else do:
                    put stream batchdata "-" at 1.
                end.
                
                
                /*MJH007  by ptp_det if phantom = yes then struct type = x else struct type  = " " */
                find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = SITE-C no-error.
                if available ptp_det then do:   /*comp item */
                   /*ptp_phantom*/
                   if ptp_phantom = yes then  put stream batchdata " " '"' "X" '" '. /*" ~"" "X" "~" - ".*/
                   else put stream batchdata " " '"' " " '" '.  /*" ~"" " " "~" - ".*/ 
                end.
                else do:
                   xxppif_err = 2.
                   xxppif_msg = "Item site-plan data not exists2:" + SITE-C + xxppif_part .
                   next.
                end.
                
                
                /*pdsc修改生效起始日期*/
                if xxppif_tr_code = "PDSC" or xxppif_tr_code = "sosc" then do:
                   /*lw01 
                   put stream batchdata xxppif__dte01 " ".
                   */
                put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2) + " ".

                end.
                else do:
                   put stream batchdata "-" " ".
                end.
                
                
                /*End of MJH007*/
                
/*MJH007*/      if xxppif__log01 = yes then do:
/*MJH007*/         assign xxppif__dte01 = xxppif__dte01.  /*如果有本地子件子件存在的话，康明斯子件的end date = xxppif__dte01*/
/* /*MJH007*/         put stream batchdata xxppif__dte01. lw01*/

/*lw01*/               put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2).


/*MJH007*/      end.
/*MJH007*/      else do:
                   if trim(substring(xxppif_content,5,1)) = "O" then do:
                      if can-find(first xxppiflog where xxppiflog.xxppif_tr_id >= trid_begin
                                                    and xxppiflog.xxppif_tr_code = "PDSA"
                                                    and substring(xxppiflog.xxppif_content,1,5)="PDSAI"
                                                    and (
                                                         trim(substring(xxppif_content,24,12)) = xxppif_log.xxppif_part
                                                      or trim(substring(xxppif_content,85,16)) = xxppif_log.xxppif_part
                                                      )
                                                    ) 
                         and substring(xxppif_content,1,5) ="PDSAO" then do: 
                             assign xxppif__dte01 = xxppif__dte01 - 1. /*对于pdsao而言，把终止时间设置成 - 1*/
                      end.

/*                      put stream batchdata xxppif__dte01.    lw01*/

/*lw01*/               put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2).

                   end.
                   else do:
                      put stream batchdata "-".

                   end.
                end.
                /*EXIT */
                put stream batchdata "." at 1.
            end.
            
            /*BOM BEGIN - SITE-B WITH ZZ*/
            /* IF SHOP ORDER IF LIKE SO1XXX, CREAT BOM IN SITE-B*/
            /* IF PT_PHANTOM = YES, THEN CREAT BOM IN SITE-B*/
            /*PS_PAR*/
            strTmp = trim(substring(xxppif_content,12,12)).

/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.

            if substring(xxppif_content,1,5) = "PDSAO" then do:
               find first ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
               if not available ps_mstr then do:
                  next. /*对于pdsao来说，如果没有找到结构，不做任何处理*/
               end.
            end.

            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-B no-error.
            
            find first code_mstr no-lock where code_fldname = "so site"
                                           and code_value = substring(strTmp,1,3) 
                                           use-index code_fldval no-error.
            if (not available code_mstr) and substring(strTmp,1,2)= "SO" then do:
               xxppif_err = 2.
               xxppif_msg = "请维护通用代码 so site :" + substring(strTmp,1,3).
               next.
            end.
            
            /*if  ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and substring(strTmp,1,3) = "SO1") then do:*/
            if  ((xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC") and 
                (available code_mstr and code_cmmt = SITE-B)) then do:

                find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = site-c no-error.
                if available ptp_det and ptp_phantom = yes  then do:
                   xxppif_part = xxppif_part + "ZZ".
                end.
                
                /*SITE*/
                put stream batchdata "~"" at 1 SITE-B "~"" skip.
                
                put stream batchdata "~"" at 1 string(strTmp + "ZZ") format "x(18)" "~"" skip.
                /*PS_COMP & ref*/
                
                put stream batchdata "~"" at 1 xxppif_part "~" - ".
                /*PS_START*/
                if trim(substring(xxppif_content,5,1)) = "I" then do:
                    effdate = xxppif__dte01.
                end.
                else do:
                    find last ps_mstr no-lock where ps_par = strTmp + "ZZ" and ps_comp = xxppif_part no-error.
                    if available ps_mstr then 
                        effdate = ps_start.
                    else effdate = ?.
                end.

/*                put stream batchdata effdate skip. lw01*/

                put stream batchdata unformatted 
                       string(day(effdate),"99") + "/" +
                       string(month(effdate),"99") + "/" +
                       substring(string(year(effdate)),3,2) skip.

                  
                /*PS_QTY_PER*/
                if trim(substring(xxppif_content,5,1)) = "I" then do:
                    put stream batchdata xxppif_qty_chg format "->>9.999" at 1.
                end.
                else do:
                    put stream batchdata "-" at 1.
                end.
                
                /*PS_PS_CODE start end*/
/*              put stream batchdata " ~"" substring(xxppif_content,69,1)  format "x(1)" "~" - ". */
                
                /* MJH007    compact item's struct type
                put stream batchdata " ~"" substring(xxppif_content,61,1)  format "x(1)" "~" - ".
                */
                
                /*MJH007  compact item's struct type by ptp_det if phantom = yes then struct type = x else struct type  = " " */
                find first ptp_det no-lock where ptp_part = trim(substring(xxppif_content,24,12)) and ptp_site = SITE-C no-error.
                /*MJH007  by ptp_det if phantom = yes then struct type = x else struct type  = " " */
                find first ptp_det no-lock where ptp_part = trim(substring(xxppif_content,24,12)) and ptp_site = SITE-C no-error.
                if available ptp_det then do:   /*comp item */
                   /*ptp_phantom*/
                   if ptp_phantom = yes then  put stream batchdata " " '"' "X" '" '. /*" ~"" "X" "~" - ".*/
                   else put stream batchdata " " '"' " " '" '.  /*" ~"" " " "~" - ".*/ 
                end.
                else do:
                   xxppif_err = 2.
                   xxppif_msg = "Item site-plan data not exists2:" + xxppif_part.
                   next.
                end.

                /*pdsc修改生效日期*/
                if xxppif_tr_code = "PDSC" or xxppif_tr_code = "sosc" then do:
                   /*lw01*
                   put stream batchdata xxppif__dte01 " ".
                   *lw01*/
                   put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2) + " ".
                end.
                else do:
                   put stream batchdata "-" " ".
                end.
                
                /*End of MJH007*/
/*MJH007*/      if xxppif__log01 = yes then do:
/*MJH007*/         assign xxppif__dte01 = xxppif__dte01. /*如果有本地子件子件存在的话，康明斯子件的end date = xxppif__dte01 -1*/
/*/*MJH007*/         put stream batchdata xxppif__dte01. lw01*/

/*lw01*/                put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2).
/*MJH007*/      end.
/*MJH007*/      else do:
                   if trim(substring(xxppif_content,5,1)) = "O" then do:
/*                      put stream batchdata xxppif__dte01. lw01*/

/*lw01*/                put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2).

                   end.
                   else do:                      
                      put stream batchdata "-".
                   end.
                end.
                /*EXIT */
                put stream batchdata "." at 1.
            end. /*xxppif_tr_code = "SOSA" or xxppif_tr_code = "SOSC"*/
            
            /*对应于PDSA/PDSC如果是par item 在site-c中是虚件的话，需重新建立site-b的ZZ bom*/
            strTmp = trim(substring(xxppif_content,12,12)).
            
/*MJH007    判断是否有本地的par item,如果有的话，就代替掉康明斯的*/
/*MJH007*/  if trim(substring(xxppif_content,67,16)) <> "" then do :
/*MJH007*/     strTmp = trim(substring(xxppif_content,67,16)).
/*MJH007*/  end.
               if substring(xxppif_content,1,5) = "PDSAO" then do:
                  find first ps_mstr no-lock where ps_par = strTmp and ps_comp = xxppif_part no-error.
                  if not available ps_mstr then do:
                     next. /*对于pdsao来说，如果没有找到结构，不做任何处理*/
                  end.
               end.
            

            find first ptp_det no-lock where ptp_part = strTmp and ptp_site = SITE-C no-error.
             
            if (xxppif_tr_code = "PDSA" or xxppif_tr_code = "PDSC")
             and (available ptp_det and ptp_phantom = yes) then do:
                
                find first ptp_det no-lock where ptp_part = xxppif_part and ptp_site = site-c no-error.
                if available ptp_det then do:
                  if ptp_phantom = yes  then do:
                     xxppif_part = xxppif_part + "ZZ".
                  end.
                  else do:
                     find first ptp_det where ptp_site = SITE-B and ptp_part = xxppif_part no-lock no-error.
                     if not available ptp_det then do:
                        xxppif_err = 2.
                        xxppif_msg = "Item site-plan B site data does not exist:" + xxppif_part.
                        next.
                     end.
                  end.  
                end.
                
                
                /*SITE*/
                put stream batchdata "~"" at 1 SITE-B "~"" skip.
                
                put stream batchdata "~"" at 1 string(strTmp + "ZZ") format "x(18)" "~"" skip.
                /*PS_COMP & ref*/
                put stream batchdata "~"" at 1 xxppif_part "~" - ".
                /*PS_START*/
                if trim(substring(xxppif_content,5,1)) = "I" then do:
                    effdate = xxppif__dte01.
                end.
                else do:
                    find last ps_mstr no-lock where ps_par = strTmp + "ZZ" and ps_comp = xxppif_part no-error.
                    if available ps_mstr then 
                        effdate = ps_start.
                    else effdate = ?.
                end.
               /*tfq put stream batchdata effdate skip.  */
 /*tfq*/  put stream batchdata  string(day(effdate),"99") format "99" 
 /*tfq*/   "/" string(month(effdate),"99") format "99"  "/"  substring(string(year(effdate)),3,2) format "99" skip .

/******lw01*****
/*lw01*/  put stream batchdata  string(month(effdate),"99") format "99" "/" 
                                string(day(effdate),"99") format "99"  "/"  
                                substring(string(year(effdate)),3,2) format "99" skip.
******lw01*****/

/*lw01*/

                /*PS_QTY_PER*/
                if trim(substring(xxppif_content,5,1)) = "I" then do:
                    put stream batchdata xxppif_qty_chg format "->>9.999" at 1 skip.
                    put stream batchdata "." skip.
                end.
                else do:
                    put stream batchdata "-" at 1 skip "." skip.
 
               end.
                
                /*PS_PS_CODE start end*/
/*              put stream batchdata " ~"" substring(xxppif_content,69,1)  format "x(1)" "~" - ". */
                
                /* MJH007    compact item's struct type
                put stream batchdata " ~"" substring(xxppif_content,61,1)  format "x(1)" "~" - ".
                */
                
                /*MJH007  compact item's struct type by ptp_det if phantom = yes then struct type = x else struct type  = " " */
                find first ptp_det no-lock where ptp_part = trim(substring(xxppif_content,24,12)) and ptp_site = SITE-C no-error.
                if available ptp_det then do:   /*comp item */
                   /*ptp_phantom*/
                   if ptp_phantom = yes then  put stream batchdata " " '"' "X" '" '. /*" ~"" "X" "~" - ".*/
                   else put stream batchdata " " '"' " " '" '.  /*" ~"" " " "~" - ".*/ 
                end.
                else do:
                   xxppif_err = 2.
                   xxppif_msg = "Item site-plan data not exists2:" + xxppif_part.
                   next.
                end.
                /*pdsc修改生效日期*/
                if xxppif_tr_code = "PDSC" or xxppif_tr_code = "sosc" then do:
/*                   put stream batchdata xxppif__dte01 " ". lw01*/
/*lw01*/                put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2) + " ".

                end.
                else do:
                   put stream batchdata "-" " ".
                end.
                
                /*End of MJH007*/
/*MJH007*/      if xxppif__log01 = yes then do:
/*MJH007*/         assign xxppif__dte01 = xxppif__dte01. /*如果有本地子件子件存在的话，康明斯子件的end date = xxppif__dte01 -1*/
/*/*MJH007*/         put stream batchdata xxppif__dte01. lw01*/
/*lw01*/                put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2).

/*MJH007*/      end.
/*MJH007*/      else do:
                   if trim(substring(xxppif_content,5,1)) = "O" then
/*                      put stream batchdata xxppif__dte01. lw01*/
/*lw01*/                put stream batchdata unformatted 
                       string(day(xxppif__dte01),"99") + "/" +
                       string(month(xxppif__dte01),"99") + "/" +
                       substring(string(year(xxppif__dte01)),3,2) + " ".

                   else do:
                      put stream batchdata "-".
                   end.
                end.
                /*EXIT */
                put stream batchdata "." at 1.
            end.
        end.
