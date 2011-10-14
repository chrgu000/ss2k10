/*----rev history-------------------------------------------------------------------------------------*/
/*原版{mfdtitle.i "2+ "}*/
/* SS - 110307.1  By: Roger Xiao */ /* vp_mstr 区分保税非保税,vp_part : P,M开头区分 */
/*-Revision end---------------------------------------------------------------*/

    
    /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. B*/
    for each xxinv_mstr where xxinv_nbr   >= shipno 
                           and xxinv_nbr   <= shipno1 
                           and xxinv_vend >= vend 
                           and xxinv_vend <= vend1
                           and xxinv_site >= site 
                           and xxinv_site <= site1 no-lock,
        each xxship_det where  xxship_nbr  = xxinv_nbr
                           and xxship_vend = xxinv_vend 
                           and xxship_line >= shipline 
                           and xxship_line <= shipline1  
                           and xxship_status = "" 
                           and xxship_qty > xxship_rcvd_qty  /* (待收货量 > 已收货量) */
                           break by xxinv_site by xxinv_vend   
                           by xxship_part :
        
        ACCUMULATE (xxship_qty - xxship_rcvd_qty) ( TOTAL by xxinv_site by xxinv_vend BY xxship_part ) .

        IF LAST-OF(xxship_part) THEN DO:
           find first vd_mstr where vd_addr = xxinv_vend no-lock no-error.

           CREATE pott.
           ASSIGN
               pott_shipno     = xxship_nbr
               pott_site       = xxinv_site
               pott_vend       = xxinv_vend
               pott_case       = xxship_case
               pott_part_vend  = xxship_part
               pott_pkg        = xxship_pkg
               pott_qty_unit   = xxship_qty_unit
               pott_qty        = (ACCUMULATE TOTAL BY xxship_part xxship_qty - xxship_rcvd_qty ) 
               pott_status     = xxship_status
               pott_price      = xxship_price
               pott_value      = xxship_value
               pott_curr       = if avail vd_mstr then vd_curr else "JPY" 

               pott_rcvddate   = rcvddate
               pott_line       = xxship_line
               pott_order_type = xxship_type  /*Z量产，R新机种*/
               pott_inv_pm     = xxinv_pm   /* SS - 110307.1 */
               .

           /* 生成批号 */
            if v_rctdate <> ? then do:
                datestr = substring(string(year(v_rctdate),"9999"),3,2) + string(month(v_rctdate),"99") + string(day(v_rctdate),"99")   .  
            end.
            assign pott_lot = datestr + substring(xxinv_con,6) /*取合同号vt32/后面的字符*/.  /* SS - 110307.1 */ .

           /* 取得生成PO的单价 */
           /* showa 要求:不用发票上的价格,直接用1.10.2.1价格表的价格 */

        end.
    end. /* for each xxship_det */
    /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. E*/
                           
    /* "2,判断供应商图号与ZH图号对应是否存在" . B */
    v_flag = YES.
    FOR EACH pott :
        if pott_inv_pm = no then /*非保税*/
                find first vp_mstr 
                    use-index vp_vend_part
                    where  vp_vend = pott_vend 
                    and  vp_vend_part = pott_part_vend 
                    and  vp_part begins "M" 
                no-lock no-error.
        else  /*保税*/
                find first vp_mstr 
                    use-index vp_vend_part
                    where  vp_vend = pott_vend 
                    and  vp_vend_part = pott_part_vend 
                    and  vp_part begins "P" 
                no-lock no-error.
        if not avail vp_mstr then do:

           CREATE tte.
           ASSIGN
               tte_type1 = "零件图号"
               tte_type = "错误" 
               tte_vend = pott_vend
               tte_part = pott_part_vend
               tte_desc = "供应商零件对应未维护，请到(1.19)菜单进行维护。"
               .
           v_flag = NO.
        END.
        ELSE DO:
            ASSIGN 
                pott_part_zh = vp_part 
                .
        END.          

        FIND FIRST vd_mstr WHERE vd_addr = pott_vend NO-LOCK NO-ERROR.
        IF NOT AVAIL vd_mstr THEN DO:
            CREATE tte.
            ASSIGN
                tte_type1 = "供应商"
                tte_type = "错误" 
                tte_vend = pott_vend
                tte_part = ""
                tte_desc = "此供应商代码在系统中不存在，请先到(2.3.1)维护供应商。"
                .
            v_flag = NO.
        END.
           
        /* 判断生成PO时的兑换率是否存在 */
        IF AVAIL vd_mstr AND vd_curr <> "RMB" THEN DO:
            FIND FIRST exr_rate WHERE (exr_curr1 = vd_curr OR exr_curr2 = vd_curr)
                AND pott_rcvddate >= exr_start_date 
                AND pott_rcvddate <= exr_end_date NO-LOCK NO-ERROR.
            IF NOT AVAIL exr_rate THEN DO:
                FIND FIRST tte WHERE tte_type1 = "兑换率" AND tte_type = "错误"
                    AND tte_vend = pott_vend AND tte_part = vd_curr NO-LOCK NO-ERROR.
                IF NOT AVAIL tte THEN DO:
                    CREATE tte.
                    ASSIGN
                        tte_type1 = "兑换率"
                        tte_type = "错误" 
                        tte_vend = pott_vend
                        tte_part = vd_curr
                        tte_desc = "此收货日期的兑换率在系统中不存在，请先到(26.4)维护兑换率。"
                        .
                END.
                v_flag = NO.
            END.
        END.

        /* get pt_loc ****
        FIND FIRST pt_mstr WHERE pott_part_zh = pt_part NO-LOCK NO-ERROR.
        IF NOT AVAIL pt_mstr THEN DO:
            CREATE tte.
            ASSIGN
                tte_type1 = "默认库位"
                tte_type = "错误" 
                tte_vend = pott_vend
                tte_part = pott_part_vend
                tte_desc = "此图号没有默认库位，请先到(1.4.1)维护默认库位。"
                .
            v_flag = NO.
        END.
        else do:
            if pt_loc = "" then do:
               CREATE tte.
               ASSIGN
                   tte_type1 = "默认库位"
                   tte_type = "错误" 
                   tte_vend = pott_vend
                   tte_part = pott_part_vend
                   tte_desc = "此图号没有默认库位，请先到(1.4.1)维护默认库位。"
                   .
               v_flag = NO.
            end.
            else assign pott_loc = pt_loc.
        end.                       
        ********/
    END. /* FOR EACH pott : */
    /* "2,判断供应商图号与ZH图号对应是否存在" . E */

    /* 建立显示临时表 */
    {xxpocimcreatetta.i}


    for each tte with frame ab1c:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame ab1c:handle).

        disp tte_type1 LABEL "错误类型"
             tte_type  LABEL "严重程度"
             tte_vend  LABEL "供应商"
             tte_part  LABEL "零件号"
             tte_desc  label " 备注"
             with frame ab1c width 200 down.
    end.

    for each tt1a where tt1a_openqty <> 0   with frame ab2c:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame ab2c:handle).

        disp 
            /* tt1a_site  地点 */                     
            /* tt1a_loc   默认库位 */
            /* tt1a_curr  */
            tt1a_vend     /* 供应商 */
            tt1a_nbr      /* 订单 */
            tt1a_line     /* 订单项   */
            tt1a_part     /* 图号 */
            tt1a_vendpart label "Vend part"
            tt1a_openqty  /*   未决量   */
            tt1a_shipno  
            tt1a_lot 
            tt1a_rcvddate LABEL "收货日期"
            tt1a_rmks     LABEL "说明"
            with frame ab2c width 200 down.
    end.
  
    /* REPORT TRAILER */
    {mfrtrail.i}

    IF v_flag = YES THEN DO:
        IF v_flagpo = YES THEN DO:
            FOR EACH tt1a WHERE tt1a_type = "1" BREAK BY tt1a_nbr BY tt1a_line :
                IF FIRST-OF(tt1a_nbr) THEN DO:
                    FOR FIRST vd_mstr WHERE vd_addr = tt1a_vend NO-LOCK :
                    END.
                    IF AVAIL vd_mstr THEN curr = vd_curr.
    
                    usection = "pomt" + TRIM ( string(year(rcvddate)) + string(MONTH(rcvddate)) + string(DAY(rcvddate)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
                    output to value( trim(usection) + ".i") .
                    PUT UNFORMATTED '"' tt1a_nbr '"' skip.
                    PUT UNFORMATTED '"' tt1a_vend '"' skip.
                    PUT UNFORMATTED "-" skip.
                    /*本程式自动创建的PO, so_job = "AC" */
                    put UNFORMATTED '- - - - "AC" - - - - - - "' tt1a_site '"' skip.
            
                    if curr <> "rmb" then do:
                       PUT UNFORMATTED  "-" skip.
                    end.
                    PUT UNFORMATTED "-" skip.          /* 税 */
                END.
    
                PUT UNFORMATTED STRING(tt1a_line) skip.          /* 项次 */   
                PUT UNFORMATTED tt1a_site skip.    /* 地点 */
                put UNFORMATTED "-" skip.
                put UNFORMATTED '"' tt1a_part '"' skip.
                put UNFORMATTED string(tt1a_openqty) skip.
                /* 汇率问题要等财务AP模块上线后才确定 */
                /*
                put UNFORMATTED tmp_cost skip.
                */
                put UNFORMATTED "-" skip.
                put UNFORMATTED "-" skip.
    
                FIND FIRST ad_mstr WHERE ad_addr = tt1a_vend AND ad_taxable = YES NO-LOCK NO-ERROR.
                IF AVAIL ad_mstr THEN PUT UNFORMATTED " - " SKIP.
                                                 
                IF LAST-OF(tt1a_nbr) THEN DO:
                    put "." skip.
                    put "." skip.
                    put "-" skip.
                    put "-" skip.   
                    put "." skip.   
                    output close.

                    input from value ( usection + ".i") .
                    output to  value ( usection + ".o") .
                    batchrun = yes. 
                    {gprun.i ""popomt.p""}
                    batchrun = no. 
                    input close.
                    output close.
            
                    errstr="".
                    ciminputfile = usection + ".i".
                    cimoutputfile = usection + ".o".
                    {xserrlg5.i}
            
                    /**/
                    if errstr = "" then do:
                        unix silent value ( "rm -f "  + Trim(usection) + ".i").
                        unix silent value ( "rm -f "  + Trim(usection) + ".o").
                    end.
                END.
            END.
        END. /* v_flagpo = yes */

        IF v_flagyn = YES THEN DO:
            j = 0.

            for each xxship_det 
                where xxship_nbr  >= shipno 
                and  xxship_nbr   <= shipno1
                and xxship_vend   >= vend 
                and xxship_vend   <= vend1
                break by xxship_nbr by xxship_part by xxship_case :
                if first-of(xxship_part) then  j = 0.
                j = j + 1 .
                xxship_case2 = j .
            end.

            j = 0.

            for each xxinv_mstr 
                    where xxinv_nbr >= shipno 
                    and xxinv_nbr   <= shipno1 
                    and xxinv_vend >= vend 
                    and xxinv_vend <= vend1
                    and xxinv_site >= site 
                    and xxinv_site <= site1 
                    no-lock,
                each xxship_det 
                    where xxship_nbr  =  xxinv_nbr  
                    and xxship_vend   = xxinv_vend 
                    and xxship_line >= shipline 
                    and xxship_line <= shipline1  
                    and xxship_status = "" 
                    and xxship_qty > xxship_rcvd_qty
                BY xxinv_nbr BY xxship_line :
                /* 生成批号 */
                tmp_lot = "".
                if v_rctdate <> ? then do:
                    datestr = substring(string(year(v_rctdate),"9999"),3,2) + string(month(v_rctdate),"99") + string(day(v_rctdate),"99")   .  
                end.
                tmp_lot = datestr 
                        + substring(xxinv_con,6) /*取合同号vt32/后面的字符*/
                        + string(xxship_case2,"99")    /*托号*/
                        .  /* SS - 110307.1 */
    
                /* 取得ERP图号 */
                tmp_part="".
                if xxinv_pm = no then /*非保税*/
                        find first vp_mstr 
                            use-index vp_vend_part
                            where  vp_vend = xxinv_vend 
                            and  vp_vend_part = xxship_part 
                            and  vp_part begins "M" 
                        no-lock no-error.
                else  /*保税*/
                        find first vp_mstr 
                            use-index vp_vend_part
                            where  vp_vend = xxinv_vend 
                            and  vp_vend_part = xxship_part 
                            and  vp_part begins "P" 
                        no-lock no-error.
                IF AVAIL vp_mstr THEN tmp_part = vp_part .
    
                tmp_order_qty = 0 .
                tmp_flagt     = "".
                tmp_qty       = 0 .
                v_qty_rct     = 0 .
                for each po_mstr where po_vend = xxinv_vend 
                                   and po_stat = "" NO-LOCK ,
                    each pod_det where pod_nbr = po_nbr 
                                   and pod_part = tmp_part 
                                   and pod_status = "" 
                                   and pod_site = xxinv_site 
                                   and pod_qty_ord > pod_qty_rcvd
                                   AND (( SUBSTRING(pod_nbr,1,1) = "P" AND substring(xxship_type,1,1) = "Z") OR
                                        ( SUBSTRING(pod_nbr,1,1) = "N" AND substring(xxship_type,1,1) = "R") OR
                                        ( SUBSTRING(pod_nbr,1,1) = "Z" AND substring(xxship_type,1,1) = "Z") OR 
                                        ( SUBSTRING(pod_nbr,1,1) = "R" AND substring(xxship_type,1,1) = "R") ) NO-LOCK BY po_nbr :
                        tmp_flagt = "1" .
        
                        tmp_order_qty = tmp_order_qty + (pod_qty_ord - pod_qty_rcvd) .
                        tmp_qty       = pod_qty_ord - pod_qty_rcvd.
                        v_qty_rct     = 0 .
        
                        IF (xxship_qty - xxship_rcvd_qty) >= tmp_order_qty then do:          
                            j = j + 1.
                            v_qty_rct = tmp_qty .
                            /*累加未结量小于未收量，直接收货B*/
                            {xxpocimrcyes.i}  
                        end. 
                        else do: 
                            j = j + 1.
                            v_qty_rct = (xxship_qty - xxship_rcvd_qty) .
                            /*累加未结量大于未收量，直接收货B*/
                            {xxpocimrcyes.i}  
        
                            LEAVE.
                        end.
                end. /* for each po_mstr where po_vend = xxinv_vend  */
    
            END. /*for each xxinv_mstr */
            MESSAGE "本次共导入" + string(j) + "条数据,请检查导出的信息文件以确认数据是否完整正确的导入到系统!" VIEW-AS ALERT-BOX.
        END. /*IF v_flagyn = YES*/
    END. /* v_flag = yes */
