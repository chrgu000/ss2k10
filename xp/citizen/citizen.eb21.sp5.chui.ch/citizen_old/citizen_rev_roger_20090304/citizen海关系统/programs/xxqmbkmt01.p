/* xxqmbkmt01.p 海关手册维护                                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 01/30/2008   BY: Softspeed tommy xie         */

         {mfdtitle.i "1.0"}

         /* --------------------  Define Query  ------------------- */

         define query q_xxcbk_mstr for
           xxcbk_mstr
           scrolling.

           define var v_amt like tr_qty_loc .

         /* -----------------  Standard Variables  ---------------- */
         define variable p-status as character no-undo.
         define variable perform-status as character format "x(25)"
            initial "first":U no-undo.
         define variable p-skip-update like mfc_logical no-undo.
         define variable l-rowid as rowid no-undo.
         define variable l-delete-it like mfc_logical no-undo.
         define variable l-del-rowid as rowid no-undo.
         define variable l-top-rowid as rowid no-undo.
         define variable lines as integer initial 10 no-undo.
         define variable l-found like mfc_logical no-undo.
         define variable pos as integer no-undo.
         define variable l-error like mfc_logical no-undo.
         define variable l-title as character no-undo.

        define var j as integer .
        define temp-table temp1 
            field t1_bk_nbr like xxcbkd_bk_nbr  
            field t1_bk_ln  like  xxcbkd_bk_ln   
            field t1_cu_ln   like xxcbkd_cu_ln
            field t1_cu_part like xxcbkd_cu_part .

         /* ------------------  Button Variables  ----------------- */
         define button b-find   label "找寻".
         define button b-add    label "新增".
         define button b-update label "修改".
         define button b-export label "出口成品".
         define button b-import label "进口料件".
         define button b-bkbom  label "单耗输入".
         define button b-delete label "删除".
         define button b-end    label "完成".

         /* -------------  Standard Widget Variables  ------------- */
         define variable l-focus as widget-handle no-undo.
         define variable w-frame as widget-handle no-undo.

         /* ------------------  Screen Variables  ----------------- */
         define new shared variable l-key as character format "x(12)"
            no-undo.
         define variable l-err-nbr as integer format "9999" no-undo.
         define variable valid_acct like mfc_logical
            initial no no-undo.
         define variable l-continue like mfc_logical no-undo.
         define variable l-period as character format "x(6)" no-undo.
         define variable l-cal as character format "x(8)" no-undo.
         define variable l-fa-id as character format "x(12)" no-undo.
         define variable l-temp-amt as decimal format "->>>>,>>>,>>9.99<<<<"
            no-undo.
         define variable mc-error-number as character format "x(4)" no-undo.
         define variable l_msg_list      as character               no-undo.
         define variable l_sev_list      as character               no-undo.

         define new shared variable l-reopen-bk-query like mfc_logical no-undo.
         define variable ext_cost as decimal format ">>>,>>>,>>9.99".
         define variable i as integer.

         /* ------------------  Frame Definition  ----------------- */
         /* Added side-labels phrase to frame statement              */

         define frame f-button
            b-find   at 1
            b-add    at 10
            b-update at 19
            b-export at 28
            b-import at 39
            b-bkbom  at 50
            b-delete at 61
            b-end    at 70
         with no-box overlay three-d side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-button:handle).

         assign
            l-focus = b-find:handle in frame f-button
            b-find:width = 8
            b-find:private-data = "find":U
            b-add:width = 8
            b-add:private-data = "add":U
            b-update:width = 8
            b-update:private-data = "update":U
            b-export:width = 10
            b-export:private-data = "export":U
            b-import:width = 10
            b-import:private-data = "import":U
            b-bkbom:width = 10
            b-bkbom:private-data = "bkbom":U
            b-delete:width = 8
            b-delete:private-data = "delete":U
            b-end:width = 8
            b-end:private-data = "end":U.

         {xxqmbkmt01.i}

         define frame f-2
            skip(.4)
            xxcbkd_bk_ln       column-label "序"
            xxcbkd_cu_ln       column-label "商品序"
            xxcbkd_cu_part     column-label "商品编号"
            xxcbkd_qty_ord     column-label "数量"
            xxcbkd_um
            xxcbkd_price       column-label "单价" format ">>,>>9.9<<<<"
            ext_cost           column-label "总值"
            xxcbkd_ctry_code   column-label "产地"
            xxcbkd_tax         format "Y 征/N 免" column-label "征免"            
            xxcbkd_stat        column-label "状"
         with three-d overlay 8 down scroll 1 width 80.

         run ip-framesetup.

         view frame f-1.

         open query q_xxcbk_mstr 
             for each xxcbk_mstr where xxcbk_domain = global_domain
             use-index xxcbk_bk_nbr no-lock.

         get first q_xxcbk_mstr no-lock.

         main-loop:
         do while perform-status <> "end":U on error undo:
            if perform-status = "first":U then
               assign p-status = "first-one":U.
            if perform-status = "first":U and
               p-status = "first-one":U then
            do:
               assign p-status = "".
            end.
            if perform-status = "end":U or
               perform-status = "add":U  then
            do:
               assign p-status = perform-status.
               if available xxcbk_mstr then
               assign p-status = "".
            end.

            run ip-query
               (input-output perform-status,
               input-output l-rowid).

            if available xxcbk_mstr then
               l-key = xxcbk_bk_nbr.

            if perform-status = "delete":U then
            do:
               run ip-lock
                 (input-output perform-status).
               assign
                 perform-status = "first":U.
               run ip-predisplay.
            end.

            /* ----------------------  Export ---------------------- */
            if perform-status = "export":U then
            do:
               if available xxcbk_mstr then do:
                  get current q_xxcbk_mstr exclusive-lock no-wait .
/*debug*/
                  if not locked xxcbk_mstr then
                     {gprun.i ""xxqmbkmta.p""}

                  get current q_xxcbk_mstr no-lock .
                  run ip-display.
               end.
            end.
            /* --------------------  End Export -------------------- */

            /* ----------------------  Import  --------------------- */
            if perform-status = "import":U then
            do:
               if available xxcbk_mstr then do:
                  get current q_xxcbk_mstr exclusive-lock no-wait .
/*debug*/
                  if not locked xxcbk_mstr then
                     {gprun.i ""xxqmbkmtb.p""}
         
                  get current q_xxcbk_mstr no-lock .
                  run ip-display.
               end.
            end.
            /* --------------------  End Import  ------------------- */

            /* ----------------------  BKBom   --------------------- */
            if perform-status = "bkbom":U then
            do:
               if available xxcbk_mstr then do:
                  get current q_xxcbk_mstr exclusive-lock no-wait .
/*debug*/
                  if not locked xxcbk_mstr then
                     {gprun.i ""xxqmbkmtc.p"" "(xxcbk_bk_nbr)"}

                  get current q_xxcbk_mstr no-lock .
                  run ip-display.
               end.
            end.
            /* --------------------  End BKBom   ------------------- */

            /* ----------------------  Display  ---------------------- */
            run ip-predisplay.

            /* -------------------  Add/Update  -------------------- */
            if (perform-status = "update":U or
                perform-status = "add":U) then
            do:
               run ip-prompt.

               if perform-status = "undo":U then
                  do:
                     assign
                        perform-status = "first":U.
                     next main-loop.
                  end.
               run ip-displayedits.

            end.

            /* -----------------------  End  ----------------------- */
            if perform-status = "end":U then
              do:
                hide frame f-1 no-pause.
                delete procedure this-procedure no-error.
                leave.
              end.

            /* ----------------  Selection Buttons  ---------------- */
            if perform-status <> "first":U then
              run ip-button
                (input-output perform-status).

            if perform-status = "find":U then
            do:
               prompt-for
                  xxcbk_bk_nbr
               with frame f-1 editing:
                  if frame-field = "xxcbk_bk_nbr" then do:
                     {mfnp01.i xxcbk_mstr xxcbk_bk_nbr xxcbk_bk_nbr global_domain xxcbk_domain xxcbk_bk_nbr}

                     if recno <> ? then do:
                        find first xxdept_mstr where xxdept_domain = global_domain
                               and xxdept_code = xxcbk_dept no-lock no-error. 

                        find first xxctra_mstr where xxctra_domain = global_domain
                               and xxctra_code = xxcbk_trade no-lock no-error.

                        find first xxctax_mstr where xxctax_domain = global_domain
                               and xxctax_code = xxcbk_tax_mtd no-lock no-error.

                        find first xxctry_mstr where xxctry_domain = global_domain
                               and xxctry_code = xxcbk_fm_loc no-lock no-error.

                        display 
                           xxcbk_bk_nbr
                           xxcbk_list_nbr
                           xxcbk_end_date  
                           xxcbk_comp
                           xxcbk_fm_loc    
                           (if available xxctry_mstr then xxctry_name
                            else "") @ xxctry_name
                            xxcbk_trade
                           (if available xxctra_mstr then xxctra_desc1 
                            else "") @ xxctra_desc1
                            xxcbk_dept      
                           (if available xxdept_mstr then xxdept_desc
                            else "") @ xxdept_desc
                            xxcbk_stat
                            xxcbk_tax_mtd   
                           (if available xxctax_mstr then xxctax_desc1
                            else "") @ xxctax_desc1                  
                            xxcbk_doc
                            /*xxcbk_cust*/      xxcbk_imp_amt
                            xxcbk_contract  xxcbk_cur
                            xxcbk_exp_amt   
                        with frame f-1.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.

               for first xxcbk_mstr no-lock
                   where xxcbk_domain = global_domain
                     and xxcbk_bk_nbr >= input frame f-1 xxcbk_bk_nbr:
                  l-rowid = rowid(xxcbk_mstr).
               end. /* for first eecbk_mstr */
               run ip-query (input-output perform-status,
                             input-output l-rowid).
               perform-status = "first":U.
            end.
            /* -----------  END After Strip Menu Include  ---------- */
         end.
         /* -------------  End Main Loop  ------------ */

         /* -------------  Add / Update / Field Edits  ------------ */
         procedure ip-prompt:
            if perform-status = "add":U then
               clear frame f-1 all no-pause.
            case perform-status:
                when ("add":U) then do:
                  clear frame f-2 all no-pause.
                  /* ADDING NEW RECORD */
                 {mfmsg.i 1 1}
                end.
                when ("update":U) then
                  /* MODIFYING EXISTING RECORD */
                 {mfmsg.i 10 1}
                otherwise
                  hide message no-pause.
            end case.
            assign
               ststatus = stline[3].
            status input ststatus.

            ip-prompt:
            repeat :
            do transaction with frame f-1 on endkey undo, leave ip-prompt:

               if perform-status = "add":U then do:
                  prompt-for
                     xxcbk_mstr.xxcbk_bk_nbr with frame f-1.
                  
                  if input frame f-1 xxcbk_mstr.xxcbk_bk_nbr = "" then do:
                     {mfmsg.i 40 3}   /* BLANK NOT ALLOWED */
                     next-prompt xxcbk_bk_nbr with frame f-1.
                     next.
                  end.
                  if (can-find(xxcbk_mstr no-lock where xxcbk_domain = global_domain
                               and xxcbk_bk_nbr = input frame f-1 xxcbk_bk_nbr))
                  and perform-status = "add":U
                  then do:
                     {mfmsg.i 2041 3}  /* DUPLICATE RECORD EXISTS */
                     next-prompt xxcbk_bk_nbr with frame f-1.
                     next.
                  end.

                  run ip-add
                     (input-output perform-status).
                  get current q_xxcbk_mstr exclusive-lock no-wait.

                  find first xxcbkc_ctrl where xxcbkc_domain = global_domain no-lock no-error.

                  assign
                     xxcbk_mstr.xxcbk_domain = global_domain
                     xxcbk_mstr.xxcbk_bk_nbr
                     xxcbk_mstr.xxcbk_cur    = "USD"
                     xxcbk_mstr.xxcbk_dept   = xxcbkc_dept
                     xxcbk_mstr.xxcbk_fm_loc = xxcbkc_frm_loc
                     xxcbk_mstr.xxcbk_trade  = xxcbkc_trade
                     xxcbk_mstr.xxcbk_tax_mtd = xxcbkc_tax_mtd
                     xxcbk_mstr.xxcbk_end_date = today
                     xxcbk_mstr.xxcbk_cr_date = today 
                     xxcbk_mstr.xxcbk_userid = global_userid
                     xxcbk_mstr.xxcbk_comp = (if available xxcbkc_ctrl then xxcbkc_comp else "").

                  l-key = input frame f-1 xxcbk_mstr.xxcbk_bk_nbr.

                  run ip-display.
                  
                  perform-status = "add".
               end.   /*  end perform-status = "add"  */

               do on error undo , retry with frame f-1:
                  prompt-for
                     xxcbk_mstr.xxcbk_comp
                     xxcbk_mstr.xxcbk_dept
                     xxcbk_mstr.xxcbk_doc
                     xxcbk_mstr.xxcbk_contract
                     xxcbk_mstr.xxcbk_list_nbr when (perform-status = "add":U)
                     xxcbk_mstr.xxcbk_fm_loc
                     /*xxcbk_mstr.xxcbk_cust*/
                     xxcbk_mstr.xxcbk_cur when (perform-status = "add":U)
                     xxcbk_mstr.xxcbk_end_date
                     xxcbk_mstr.xxcbk_trade
                     xxcbk_mstr.xxcbk_tax_mtd
                  with frame f-1 editing:
                     if frame-field = "xxcbk_dept" then do:
                        {mfnp01.i xxdept_mstr xxcbk_dept xxdept_code global_domain xxdept_domain xxdept_code}
                     
                        if recno <> ? then do:
                           display
                              xxdept_code @ xxcbk_dept
                              xxdept_desc
                           with frame f-1.
                        end.                        

                        if input xxcbk_dept <> "" then do:
                           find first xxdept_mstr no-lock where xxdept_domain = global_domain 
                              and xxdept_code = input xxcbk_dept no-error .

                           display xxdept_desc when available xxdept_mstr
                              "" when not available xxdept_mstr @ xxdept_desc
                           with frame f-1.
                        end.
                     end.
                     /*else if frame-field = "xxcbk_cust" then do:
                        {mfnp01.i cm_mstr xxcbk_cust cm_addr global_domain cm_domain cm_addr}

                        if recno <> ? then do:
                           display cm_addr @ xxcbk_cust with frame f-1.                              
                        end.
                     end.*/
                     else if frame-field = "xxcbk_trade" then do:
                        {mfnp01.i xxctra_mstr xxcbk_trade xxctra_code global_domain xxctra_domain xxctra_code}

                        if recno <> ? then do:
                           display xxctra_code @ xxcbk_trade 
                                   xxctra_desc1 
                           with frame f-1.
                        end.

                        if input xxcbk_trade <> "" then do:
                           find first xxctra_mstr no-lock where xxctra_domain = global_domain 
                               and xxctra_code = input xxcbk_trade no-error .
                        
                           display xxctra_desc1 when available xxctra_mstr
                              "" when not available xxctra_mstr @  xxctra_desc1
                           with frame f-1.
                        end.
                     end.
                     else if frame-field = "xxcbk_tax_mtd" then do:
                        {mfnp01.i xxctax_mstr xxcbk_tax_mtd xxctax_code global_domain xxctax_domain xxctax_code}

                        if recno <> ? then do:
                           display xxctax_code  @ xxcbk_tax_mtd 
                              xxctax_desc1 
                           with frame f-1.
                        end.

                        if input xxcbk_tax_mtd <> "" then do:
                           find first xxctax_mstr no-lock where xxctax_domain = global_domain
                               and xxctax_code = input xxcbk_tax_mtd no-error .

                           display xxctax_desc1 when available xxctax_mstr
                               "" when not available xxctax_mstr @ xxctax_desc1
                           with frame f-1.
                        end.
                     end.
                     else if frame-field = "xxcbk_fm_loc" then do:
                        {mfnp01.i xxctry_mstr xxcbk_fm_loc xxctry_code global_domain xxctry_domain xxctry_code}

                        if recno <> ? then do:
                           display
                              xxctry_code @ xxcbk_fm_loc
                              xxctry_name
                           with frame f-1.
                        end.                     

                        if input xxcbk_fm_loc <> "" then do:
                           find first xxctry_mstr no-lock where xxctry_domain = global_domain 
                               and xxctry_code = input xxcbk_fm_loc no-error .

                           display xxctry_name when available xxctry_mstr
                               "" when not available xxctry_mstr @ xxctry_name
                           with frame f-1.
                        end.
                     end.
                     else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end.
                  end.

                  if not can-find (xxdept_mstr no-lock where xxdept_domain = global_domain
                     and xxdept_code = input frame f-1 xxcbk_dept)
                  then do:
                     {mfmsg03.i 902 3 """进口口岸""" """" """"}
                     next-prompt xxcbk_dept with frame f-1.
                     undo,retry.
                  end.
                  if input frame f-1 xxcbk_mstr.xxcbk_cur = "" then do:
                     {mfmsg.i 1260 3}  /* BLANK CURRENCY NOT ALLOWED */
                     next-prompt xxcbk_cur with frame f-1.
                     undo,retry.
                  end.
                  if input frame f-1 xxcbk_list_nbr > "" then do:
                     find first xxcpl_mstr where xxcpl_domain = global_domain
                            and xxcpl_list_nbr = (input frame f-1 xxcbk_list_nbr) no-lock no-error.

                     if not available xxcpl_mstr then do:
                        message "错误: 进/出口计划清单号不存在,请重新输入".
                        next-prompt xxcbk_list_nbr with frame f-1.
                        undo,retry.
                     end.
                  end.

                  if not can-find(first cu_mstr no-lock where cu_curr = input frame f-1 xxcbk_cur)
                  then do:
                     {mfmsg.i 3088 3}  /* Invalid currency code*/
                     next-prompt xxcbk_cur with frame f-1.
                     undo,retry.
                  end.                  
                  if not can-find(xxctry_mstr no-lock where xxctry_domain = global_domain
                     and xxctry_code = input frame f-1 xxcbk_fm_loc)
                  then do:
                     {mfmsg03.i 902 3 """起抵地""" """" """"}
                     next-prompt xxcbk_fm_loc with frame f-1.
                     undo,retry.
                  end.
                  /*if not can-find(cm_mstr no-lock where cm_domain = global_domain
                     and cm_addr = input frame f-1 xxcbk_cust)
                  then do:
                     {mfmsg03.i 902 3 """客户""" """" """"}
                     next-prompt xxcbk_cust with frame f-1.
                     undo,retry.
                  end.  */                
                  if not can-find(xxctra_mstr no-lock where xxctra_domain = global_domain
                     and xxctra_code = input frame f-1 xxcbk_trade)
                  then do:
                     {mfmsg03.i 902 3 """贸易方式""" """" """"}
                     next-prompt xxcbk_trade with frame f-1.
                     undo,retry.
                  end.
                  if not can-find(xxctax_mstr no-lock where xxctax_domain = global_domain
                     and xxctax_code = input frame f-1 xxcbk_tax_mtd)
                  then do:
                     {mfmsg03.i 902 3 """征免性质""" """" """"}
                     next-prompt xxcbk_tax_mtd with frame f-1.
                     undo,retry.
                  end.

                  if (perform-status = "add":U) then do:
/*debug
                     /* 1 - 海关计划 */
                     if input frame f-1 xxcbk_gn_type = "1" then do:
                        {gprun.i ""xxqmbkselpl.p""}                 
                     end.

                     /* 2 - 客户订单 */
                     if input frame f-1 xxcbk_gn_type = "2" then do:
                        {gprun.i ""xxqmbkselso.p""}                       
                     end.
debug*/
             
                     /* 新增出口成品 */
                     i = 1.
                     for each xxcpl_mstr
                        where xxcpl_domain = global_domain
                          and xxcpl_list_nbr = (input frame f-1 xxcbk_list_nbr)
                          and xxcpl_bk_nbr = "":

                                create xxcbkd_det.
                                assign 
                                   xxcbkd_domain  = global_domain
                                   xxcbkd_bk_nbr  = (input frame f-1 xxcbk_bk_nbr)
                                   xxcbkd_bk_ln   = i
                                   xxcbkd_bk_type = "out"
                                   xxcbkd_cu_ln   = xxcpl_cu_ln
                                   xxcbkd_cu_part = xxcpl_cu_part
                                   xxcbkd_qty_ord = xxcpl_cu_qty
                                   xxcbkd_um      = xxcpl_cu_um.
                                                                  
                               find first xxcpt_mstr 
                                            where xxcpt_domain = global_domain
                                            and xxcpt_ln = xxcbkd_cu_ln 
                               no-lock no-error.
                               if available xxcpt_mstr then do:
                                            xxcbkd_price = xxcpt_price.
                                            xxcbkd_tax = (if xxcpt_tax = "Y" then yes else no).
                                    find first xxccpt_mstr 
                                        where xxccpt_domain = global_domain 
                                        and xxccpt_ln  = xxcbkd_cu_ln
                                        and xxccpt_key_bom = yes 
                                    no-lock no-error .
                                    if avail xxccpt_mstr then 
                                        xxcbkd_ctry_code = xxccpt_ctry.
                                    else do:
                                        find first xxccpt_mstr 
                                            where xxccpt_domain = global_domain 
                                            and xxccpt_ln  = xxcbkd_cu_ln
                                        no-lock no-error .
                                        if avail xxccpt_mstr then 
                                            xxcbkd_ctry_code = xxccpt_ctry.
                                    end.
                               end.

                                    xxcpl_bk_nbr = (input frame f-1 xxcbk_bk_nbr).
                                    xxcpl_stat = "C".
                                    i = i + 1.
                     end. /*for each xxcpl_mstr*/

                     /* 新增进口 */
                     for each temp1 : delete temp1. end.
                     i = 1.
                     for each xxcpld_det 
                        where xxcpld_domain = global_domain
                        and xxcpld_list_nbr = (input frame f-1 xxcbk_list_nbr)
                        and xxcpld_stat = "":
                        
                                create xxcbkd_det.
                                assign 
                                    xxcbkd_domain  = global_domain
                                    xxcbkd_bk_nbr  = (input frame f-1 xxcbk_bk_nbr)
                                    xxcbkd_bk_ln   = i
                                    xxcbkd_bk_type = "imp"
                                    xxcbkd_cu_part = xxcpld_cu_comp
                                    xxcbkd_qty_ord = xxcpld_cu_qty
                                    xxcbkd_um      = xxcpld_cu_um
                                    xxcbkd_cu_ln   = xxcpld_cu_ln .
                                                        
                                xxcpld_bk_nbr = (input frame f-1 xxcbk_bk_nbr).
                                xxcpld_stat = "C".

                                find first xxcpt_mstr 
                                        where xxcpt_domain = global_domain
                                        and xxcpt_ln = xxcbkd_cu_ln 
                                no-lock no-error.
                                if available xxcpt_mstr then do:
                                        xxcbkd_price = xxcpt_price.
                                        xxcbkd_tax = (if xxcpt_tax = "Y" then yes else no).
                                    find first xxccpt_mstr 
                                        where xxccpt_domain = global_domain 
                                        and xxccpt_ln  = xxcbkd_cu_ln
                                        and xxccpt_key_bom = yes 
                                    no-lock no-error .
                                    if avail xxccpt_mstr then 
                                        xxcbkd_ctry_code = xxccpt_ctry.
                                    else do:
                                        find first xxccpt_mstr 
                                            where xxccpt_domain = global_domain 
                                            and xxccpt_ln  = xxcbkd_cu_ln
                                        no-lock no-error .
                                        if avail xxccpt_mstr then 
                                            xxcbkd_ctry_code = xxccpt_ctry.
                                    end.                                                   
                                end. 
                                
                                create temp1 .
                                assign 
                                    t1_bk_nbr = xxcbkd_bk_nbr  
                                    t1_bk_ln  = xxcbkd_bk_ln   
                                    t1_cu_ln  = xxcbkd_cu_ln
                                    t1_cu_part = xxcbkd_cu_part .                                    

                                i = i + 1.
                     end. /*for each xxcpld_det */

                     /* 新增单耗 */
                     j = i + 1 .  /*for xxcps_mstr存在, xxcbkd_det(temp1)不存在的项次*/
                     i = 0 .
                     for each xxcbkd_det
                        where xxcbkd_domain = global_domain
                        and xxcbkd_bk_nbr = (input frame f-1 xxcbk_bk_nbr)
                        and xxcbkd_bk_type = "out"
                        no-lock break by xxcbkd_bk_ln :

                        for each xxcbkps_mstr 
                                where xxcbkps_domain  = global_domain
                                and   xxcbkps_bk_nbr  = (input frame f-1 xxcbk_bk_nbr)
                                and   xxcbkps_cu_ln_par = xxcbkd_cu_ln 
                                and   xxcbkps_ln_par = xxcbkd_bk_ln :
                            delete xxcbkps_mstr .
                        end.

                        for each xxcps_mstr 
                            where xxcps_domain = global_domain 
                            and xxcps_par_ln = xxcbkd_cu_ln 
                            no-lock:

                            find first temp1 
                                where t1_bk_nbr = xxcbkd_bk_nbr   
                                and   t1_cu_ln  = xxcps_comp_ln
                            no-lock no-error .
                            if avail temp1 then i = t1_bk_ln .
                            else do:
                                i = j .
                                j = j + 1 .
                            end.

                            create xxcbkps_mstr.
                            assign
                               xxcbkps_domain  = global_domain
                               xxcbkps_bk_nbr  = (input frame f-1 xxcbk_bk_nbr)
                               xxcbkps_ln_par  = xxcbkd_bk_ln
                               xxcbkps_ln_comp = i
                               xxcbkps_cu_ln_par = xxcps_par_ln
                               xxcbkps_cu_ln_comp = xxcps_comp_ln
                               xxcbkps_cu_par  = xxcps_cu_par
                               xxcbkps_cu_comp = xxcps_cu_comp                              
                               xxcbkps_scrap   = 0
                               xxcbkps_qty_per = xxcps_cu_qty_per
                               .

                        end. /*for each xxcps_mstr*/     
                     end. /*新增单耗*/
                    
                    /*计算进出口总值*/
                    v_amt = 0 .
                    for each xxcbkd_det no-lock 
                       where xxcbkd_domain = global_domain
                         and xxcbkd_bk_nbr = (input frame f-1 xxcbk_bk_nbr) 
                         and xxcbkd_bk_type = "out" :
                       v_amt = v_amt + xxcbkd_price * xxcbkd_qty_ord.
                    end.                    
                    find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = (input frame f-1 xxcbk_bk_nbr) no-error .
                    if available xxcbk_mstr then xxcbk_exp_amt = v_amt.

                    v_amt = 0 .
                    for each xxcbkd_det no-lock 
                       where xxcbkd_domain = global_domain
                         and xxcbkd_bk_nbr = (input frame f-1 xxcbk_bk_nbr) 
                         and xxcbkd_bk_type = "imp" :
                       v_amt = v_amt + xxcbkd_price * xxcbkd_qty_ord.
                    end.                    
                    find first xxcbk_mstr where xxcbk_domain = global_domain and xxcbk_bk_nbr = (input frame f-1 xxcbk_bk_nbr) no-error .
                    if available xxcbk_mstr then xxcbk_imp_amt = v_amt .


                  end. /*if (perform-status = "add":U) then do:*/
               end. /*do on error undo , retry with frame f-1:*/
               perform-status = "update".

               run ip-lock
                  (input-output perform-status).
               leave.
            end.    /* transaction */
            end.    /* repeat */
         end procedure.
         /* -------------  Add / Update / Field Edits  ------------ */

         /* -----------------------  Locking  ----------------------- */
         procedure ip-lock:
           define input-output parameter perform-status as character no-undo.

           if perform-status = "add":U or
              perform-status = "update":U or
              perform-status = "delete":U then
             ip-lock:
             do transaction on error undo:
               assign
                 pos = 0
                 l-delete-it = yes.

               if available xxcbk_mstr then
                 get current q_xxcbk_mstr no-lock.
               if available xxcbk_mstr and
                  current-changed xxcbk_mstr then
                 do:
                   assign
                     l-delete-it = yes.
                   /* RECORD HAS BEEN MODIFIED SINCED YOU EDITED IT
                      SAVE ANYWAY */
                   {mfmsg01.i 2042 1 l-delete-it}
                   if l-delete-it = no then
                     do:
                       hide message no-pause.
                       run ip-displayedits.
                       return.
                     end.
                   hide message no-pause.
                 end.
               if available xxcbk_mstr then
                 tran-lock:
                 do while perform-status <> "":
                   get current q_xxcbk_mstr exclusive-lock no-wait.
                   if locked xxcbk_mstr then
                     do:
                       if pos < 3 then
                         do:
                           assign pos = pos + 1.
                           pause 1 no-message.
                           next tran-lock.
                         end.
                       assign
                         perform-status = "error":U.
                     end.
                   leave.
                 end. /*while*/

               if (perform-status = "update":U or
                   p-status = "update":U) and
                  l-delete-it = yes then
                 run ip-update
                   (input-output perform-status).
               if perform-status = "delete":U then
                 run ip-delete
                   (input-output perform-status).

               if available xxcbk_mstr then
                 get current q_xxcbk_mstr no-lock.
               if perform-status = "add":U then
                 run ip-update
                   (input-output perform-status).
               if perform-status = "undo" then
                 undo ip-lock, return.
             end.
         end procedure.          /* ip-lock */

         procedure ip-update:
           define input-output parameter perform-status as character no-undo.

           if p-status = "update":U then
             assign
               p-status = "".

           run ip-assign
             (input-output perform-status).
           
           if perform-status = "undo":U then
              return.
           assign
             perform-status = "open":U.
           run ip-query
             (input-output perform-status,
              input-output l-rowid).
         end procedure.             /*  update */

         procedure ip-add:
           define input-output parameter perform-status as character no-undo.

           create xxcbk_mstr.
           run ip-assign
             (input-output perform-status).
           if perform-status = "undo":U then
              return.
           l-rowid = rowid(xxcbk_mstr).
           assign
             perform-status = "open":U.
           run ip-query
             (input-output perform-status,
              input-output l-rowid).
           assign
             perform-status = "first":U.
           return.
         end procedure.    /* add */

         procedure ip-delete:
           define input-output parameter perform-status as character no-undo.

           if not can-find(first xxcbkd_det where xxcbkd_domain = global_domain and xxcbkd_bk_nbr = l-key) then
           do:
           assign
             l-delete-it = no.
           /* PLEASE CONFIRM DELETE */
           {mfmsg01.i 11 1 l-delete-it}
           case l-delete-it:
             when yes then
               do:
                 /* LOCKED-DELETE-EDIT */
                 hide message no-pause.
           /*
                 if xxcbk_stat = "C" then do:
                    message "错误：状态已关闭, 不允许删除!".
                    undo, retry.                      
                 end.
             */
                 delete xxcbk_mstr.
                 clear frame f-1 no-pause.
                 get next q_xxcbk_mstr no-lock.
                 if available xxcbk_mstr then
                   do:
                     assign
                       perform-status = "first":U
                       l-rowid = rowid(xxcbk_mstr).
                   end.
                 else
                   do:
                     get prev q_xxcbk_mstr no-lock.
                     if available xxcbk_mstr then
                       do:
                         assign
                           perform-status = "first":U
                           l-rowid = rowid(xxcbk_mstr).
                       end.
                     else
                       assign
                         perform-status = "first":U
                         l-rowid = rowid(xxcbk_mstr).
                   end.

                /* RECORD DELETED */
                {mfmsg.i 22 1}
                 return.
               end.
             otherwise
               run ip-displayedits.
           end case.
           end.
           else do:
              /* DELETE NOT ALLOWED */
              {mfmsg.i 1021 1}
           end.
         end procedure.       /* delete */

         procedure ip-assign:
            define input-output parameter perform-status as character no-undo.
            do with frame f-1:
               assign
                  xxcbk_mstr.xxcbk_domain = global_domain
                  xxcbk_mstr.xxcbk_bk_nbr
                  xxcbk_mstr.xxcbk_comp
                  xxcbk_mstr.xxcbk_dept
                  xxcbk_mstr.xxcbk_doc
                  xxcbk_mstr.xxcbk_contract
                  xxcbk_mstr.xxcbk_cur
                  xxcbk_mstr.xxcbk_fm_loc
                  xxcbk_mstr.xxcbk_end_date
                  xxcbk_mstr.xxcbk_trade
                  xxcbk_mstr.xxcbk_tax_mtd
                  xxcbk_mstr.xxcbk_list_nbr
                  /*xxcbk_mstr.xxcbk_cust*/
                  xxcbk_mstr.xxcbk_userid = global_userid.
            end.
         end procedure.

         procedure ip-predisplay:
           if perform-status = "" and
              available xxcbk_mstr then
             display-loop:
             do:
               clear frame f-1 all no-pause.
               run ip-displayedits.
               run ip-postdisplay.
             end.
         end procedure.

         procedure ip-displayedits:
           if available xxcbk_mstr then
             do:

               /* DISPLAY-EDITS */
               if l-reopen-bk-query = yes then do:

                 /* RE-OPEN QUERY TO INCLUDE NEWLY CREATED ASSETS */
                 perform-status = "open":U.
                 run ip-query
                   (input-output perform-status,
                    input-output l-rowid).
               end.
               run ip-display.
               l-reopen-bk-query = no.
             end.
         end procedure.

         procedure ip-display:
            display
               xxcbk_mstr.xxcbk_list_nbr
               /*xxcbk_mstr.xxcbk_cust*/
               xxcbk_mstr.xxcbk_stat
               xxcbk_mstr.xxcbk_bk_nbr
               xxcbk_mstr.xxcbk_cur
               xxcbk_mstr.xxcbk_end_date
               xxcbk_mstr.xxcbk_comp
               xxcbk_mstr.xxcbk_fm_loc
               xxcbk_mstr.xxcbk_trade
               xxcbk_mstr.xxcbk_dept
               xxcbk_mstr.xxcbk_tax_mtd
               xxcbk_mstr.xxcbk_doc
               xxcbk_mstr.xxcbk_imp_amt
               xxcbk_mstr.xxcbk_contract
               xxcbk_mstr.xxcbk_exp_amt
            with frame f-1.

            if xxcbk_mstr.xxcbk_dept <> "" then do:
               find first xxdept_mstr where xxdept_domain = global_domain
                  and xxdept_code = xxcbk_mstr.xxcbk_dept no-lock no-error .

               display xxdept_desc when available xxdept_mstr
                 "" when not available xxdept_mstr @  xxdept_desc
               with frame f-1.
            end.
            if xxcbk_mstr.xxcbk_fm_loc <> "" then do:
               find first xxctry_mstr where xxctry_domain = global_domain
                      and xxctry_code = xxcbk_mstr.xxcbk_fm_loc no-lock no-error .
               
               display xxctry_name when available xxctry_mstr
                  "" when not available xxctry_mstr @ xxctry_name
               with frame f-1.
            end.
            if xxcbk_mstr.xxcbk_tax_mtd <> "" then do:
               find first xxctax_mstr where xxctax_domain = global_domain
                  and xxctax_code = xxcbk_mstr.xxcbk_tax_mtd no-lock no-error .

               display xxctax_desc1 when available xxctax_mstr
                  "" when not available xxctax_mstr @ xxctax_desc1
               with frame f-1.
            end.
            if xxcbk_mstr.xxcbk_trade <> "" then do:
               find first xxctra_mstr where xxctra_domain = global_domain
                  and xxctra_code = xxcbk_mstr.xxcbk_trade no-lock no-error .
               
               display xxctra_desc1 when available xxctra_mstr
                  "" when not available xxctra_mstr @ xxctra_desc1
               with frame f-1.
            end.
            
            view frame f-2.
            clear frame f-2 all no-pause.

            for each xxcbkd_det no-lock where xxcbkd_domain = global_domain
                 and xxcbkd_bk_nbr = l-key and xxcbkd_bk_type = "out":
               ext_cost = xxcbkd_price * xxcbkd_qty_ord.

               display
                  xxcbkd_det.xxcbkd_bk_ln
                  xxcbkd_det.xxcbkd_cu_ln
                  xxcbkd_det.xxcbkd_cu_part
                  xxcbkd_det.xxcbkd_ctry_code
                  xxcbkd_det.xxcbkd_qty_ord
                  xxcbkd_det.xxcbkd_um
                  xxcbkd_det.xxcbkd_price
                  ext_cost
                  xxcbkd_det.xxcbkd_tax
                with frame f-2.
                if frame-line(f-2) = frame-down(f-2) then leave.
                down 1 with frame f-2.
            end.
         end procedure.

         procedure ip-postdisplay:
           color display message xxcbk_bk_nbr
             with frame f-1.

         end procedure.

         procedure ip-query:
           define input-output parameter perform-status as character
             no-undo.
           define input-output parameter l-rowid as rowid no-undo.

           if perform-status = "first":U then
             do:
               if l-rowid <> ? then
                 do:
                   reposition q_xxcbk_mstr to rowid l-rowid no-error.
                   get next q_xxcbk_mstr no-lock.
                 end.
               if not available xxcbk_mstr then
                 get first q_xxcbk_mstr no-lock.
               if available xxcbk_mstr then
                 assign
                   perform-status = ""
                   l-rowid = rowid(xxcbk_mstr).
               else
                 do:
                   assign
                     perform-status = ""
                     l-rowid = ?.
                   assign
                     frame f-1:visible = true.
                   return.
                 end.
             end.
           if perform-status = "open":U then
             do:
               open query q_xxcbk_mstr for each xxcbk_mstr where xxcbk_domain = global_domain
                 use-index xxcbk_bk_nbr no-lock.

               reposition q_xxcbk_mstr to rowid l-rowid no-error.
               get next q_xxcbk_mstr no-lock.
               if available xxcbk_mstr then
                 assign
                   perform-status = ""
                   l-rowid = rowid(xxcbk_mstr).
               else
                 do:
                   get first q_xxcbk_mstr no-lock.
                   if not available xxcbk_mstr then
                     do:
                       assign
                         perform-status = ""
                         frame f-1:visible = true.
                       return.
                     end.
                   else
                     assign
                       perform-status = ""
                       l-rowid = rowid(xxcbk_mstr).
                 end.
             end.
           if perform-status = "next":U then
             do:
               get next q_xxcbk_mstr no-lock.
               if available xxcbk_mstr then
                 do:
                   assign
                     l-rowid = rowid(xxcbk_mstr)
                     perform-status = "first":U.
                   hide message no-pause.
                   run ip-displayedits.
                 end.
               else
                 do:
                   assign
                     perform-status = "".
                   /* End of file */
                   {mfmsg.i 20 2}
                   get prev q_xxcbk_mstr no-lock.
                 end.
             end.
           if perform-status = "prev":U then
             do:
               get prev q_xxcbk_mstr no-lock.
               if available xxcbk_mstr then
                 do:
                   assign
                     l-rowid = rowid(xxcbk_mstr)
                     perform-status = "first":U.
                   hide message no-pause.
                   run ip-displayedits.
                 end.
               else
                 do:
                   assign
                     perform-status = "".
                   /* Beginning of file */
                   {mfmsg.i 21 2}
                   get next q_xxcbk_mstr no-lock.
                 end.
             end.
           if perform-status = "update":U or
              perform-status = "delete":U then
             do:
               get current q_xxcbk_mstr no-lock.
               if not available xxcbk_mstr then
                 do:
                   hide message no-pause.
                   /* RECORD NOT FOUND */
                   {mfmsg.i 1310 3}
                   assign
                     perform-status = "".
                 end.
             end.
         end procedure.

         procedure ip-framesetup:
           if session:display-type = "gui":U then
             do:
               assign
                 current-window:bgcolor = 8
                 frame f-1:box = true
                 frame f-1:row = 3
                 frame f-1:centered = true
                 frame f-1:overlay = true
                 frame f-button:centered = true
                 frame f-button:row = 21.
             end.
           else
             assign
               frame f-1:row = 2
               frame f-1:box = true
               frame f-1:centered = true
               frame f-2:row = 09
               frame f-2:box = true
               frame f-2:centered = true
               frame f-2:title = (getFrameTitle("出口成品",26))
               frame f-2:title-dcolor = 8
               frame f-button:centered = true
               frame f-button:row = 21.
         end procedure.

         procedure ip-button:
           define input-output parameter perform-status as character
             format "x(25)" no-undo.

           if not batchrun
           then do:

             enable all with frame f-button.
             assign
               ststatus = stline[2].
             status input ststatus.
             on choose of b-update
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle.
                 hide frame f-button no-pause.
               end.
             on choose of b-add
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle.
                 hide frame f-button no-pause.
               end.
             on choose of b-delete
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle.
                 hide frame f-button no-pause.
               end.
             on choose of b-import
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle
                   l-title = current-window:title
                             + " - "
                             + self:label.
                 hide frame f-button no-pause.
               end.
             on choose of b-export
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle
                   l-title = current-window:title
                             + " - "
                             + self:label.
                 hide frame f-button no-pause.
               end.
             on choose of b-bkbom
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle
                   l-title = current-window:title
                             + " - "
                             + self:label.
                 hide frame f-button no-pause.
               end.
             on choose of b-find
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle
                   l-title = current-window:title
                             + " - "
                             + self:label.
                 hide frame f-button no-pause.
               end.
             on choose of b-end
               do:
                 assign
                   perform-status = self:private-data
                   l-focus = self:handle.
                 hide frame f-1 no-pause.
                 hide frame f-button no-pause.
               end.
             on cursor-up, f9 anywhere
               do:
                 assign
                   perform-status = "prev":U
                   l-focus = focus:handle.
                 apply "go":U to frame f-button.
               end.
             on cursor-down, f10 anywhere
               do:
                 assign
                   perform-status = "next":U
                   l-focus = focus:handle.
                 apply "go":U to frame f-button.
               end.
             on cursor-right anywhere
               do:
                 assign
                   l-focus = self:handle.
                 apply "tab":U to l-focus.
               end.
             on cursor-left anywhere
               do:
                 assign
                   l-focus = self:handle.
                 if session:display-type = "gui":U then
                   apply "shift-tab":U to l-focus.
                 else
                   apply "ctrl-u":U to l-focus.
               end.
             on f3 anywhere
               apply "choose":U to b-add in frame f-button.
             on f5 anywhere
               apply "choose":U to b-delete in frame f-button.
             on esc anywhere
               do:
                 if session:display-type = "gui":U then
                   apply "choose":U to b-end in frame f-button.
               end.
             on end-error anywhere
               apply "choose":U to b-end in frame f-button.
             on window-close of current-window
               apply "choose":U to b-end in frame f-button.
             on go anywhere
               do:
                 if (lastkey = keycode("cursor-down":U) or
                     lastkey = keycode("cursor-up":U) or
                     lastkey = keycode("f9":U) or
                     lastkey = keycode("f10":U)) then
                   return.
                 else
                   assign
                     l-focus = focus:handle.
                   apply "choose":U to l-focus.
               end.
             wait-for
               go of frame f-button or
             window-close of current-window or
             choose of
               b-update,
               b-add,
               b-delete,
               b-import,
               b-export,
               b-bkbom,
               b-find,
               b-end
             focus
               l-focus.
             hide message no-pause.

           end. /* IF NOT BATCHRUN */
           else
             set perform-status.
         end procedure.
