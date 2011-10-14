/*----rev history-------------------------------------------------------------------------------------*/
/*ԭ��{mfdtitle.i "2+ "}*/
/* SS - 110307.1  By: Roger Xiao */ /* vp_mstr ���ֱ�˰�Ǳ�˰,vp_part : P,M��ͷ���� */
/*-Revision end---------------------------------------------------------------*/

    
    /* "1,ȡ��������������,��ȴ�......" ����Ӧ�̣�ͼ�Ż���. B*/
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
                           and xxship_qty > xxship_rcvd_qty  /* (���ջ��� > ���ջ���) */
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
               pott_order_type = xxship_type  /*Z������R�»���*/
               pott_inv_pm     = xxinv_pm   /* SS - 110307.1 */
               .

           /* �������� */
            if v_rctdate <> ? then do:
                datestr = substring(string(year(v_rctdate),"9999"),3,2) + string(month(v_rctdate),"99") + string(day(v_rctdate),"99")   .  
            end.
            assign pott_lot = datestr + substring(xxinv_con,6) /*ȡ��ͬ��vt32/������ַ�*/.  /* SS - 110307.1 */ .

           /* ȡ������PO�ĵ��� */
           /* showa Ҫ��:���÷�Ʊ�ϵļ۸�,ֱ����1.10.2.1�۸��ļ۸� */

        end.
    end. /* for each xxship_det */
    /* "1,ȡ��������������,��ȴ�......" ����Ӧ�̣�ͼ�Ż���. E*/
                           
    /* "2,�жϹ�Ӧ��ͼ����ZHͼ�Ŷ�Ӧ�Ƿ����" . B */
    v_flag = YES.
    FOR EACH pott :
        if pott_inv_pm = no then /*�Ǳ�˰*/
                find first vp_mstr 
                    use-index vp_vend_part
                    where  vp_vend = pott_vend 
                    and  vp_vend_part = pott_part_vend 
                    and  vp_part begins "M" 
                no-lock no-error.
        else  /*��˰*/
                find first vp_mstr 
                    use-index vp_vend_part
                    where  vp_vend = pott_vend 
                    and  vp_vend_part = pott_part_vend 
                    and  vp_part begins "P" 
                no-lock no-error.
        if not avail vp_mstr then do:

           CREATE tte.
           ASSIGN
               tte_type1 = "���ͼ��"
               tte_type = "����" 
               tte_vend = pott_vend
               tte_part = pott_part_vend
               tte_desc = "��Ӧ�������Ӧδά�����뵽(1.19)�˵�����ά����"
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
                tte_type1 = "��Ӧ��"
                tte_type = "����" 
                tte_vend = pott_vend
                tte_part = ""
                tte_desc = "�˹�Ӧ�̴�����ϵͳ�в����ڣ����ȵ�(2.3.1)ά����Ӧ�̡�"
                .
            v_flag = NO.
        END.
           
        /* �ж�����POʱ�Ķһ����Ƿ���� */
        IF AVAIL vd_mstr AND vd_curr <> "RMB" THEN DO:
            FIND FIRST exr_rate WHERE (exr_curr1 = vd_curr OR exr_curr2 = vd_curr)
                AND pott_rcvddate >= exr_start_date 
                AND pott_rcvddate <= exr_end_date NO-LOCK NO-ERROR.
            IF NOT AVAIL exr_rate THEN DO:
                FIND FIRST tte WHERE tte_type1 = "�һ���" AND tte_type = "����"
                    AND tte_vend = pott_vend AND tte_part = vd_curr NO-LOCK NO-ERROR.
                IF NOT AVAIL tte THEN DO:
                    CREATE tte.
                    ASSIGN
                        tte_type1 = "�һ���"
                        tte_type = "����" 
                        tte_vend = pott_vend
                        tte_part = vd_curr
                        tte_desc = "���ջ����ڵĶһ�����ϵͳ�в����ڣ����ȵ�(26.4)ά���һ��ʡ�"
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
                tte_type1 = "Ĭ�Ͽ�λ"
                tte_type = "����" 
                tte_vend = pott_vend
                tte_part = pott_part_vend
                tte_desc = "��ͼ��û��Ĭ�Ͽ�λ�����ȵ�(1.4.1)ά��Ĭ�Ͽ�λ��"
                .
            v_flag = NO.
        END.
        else do:
            if pt_loc = "" then do:
               CREATE tte.
               ASSIGN
                   tte_type1 = "Ĭ�Ͽ�λ"
                   tte_type = "����" 
                   tte_vend = pott_vend
                   tte_part = pott_part_vend
                   tte_desc = "��ͼ��û��Ĭ�Ͽ�λ�����ȵ�(1.4.1)ά��Ĭ�Ͽ�λ��"
                   .
               v_flag = NO.
            end.
            else assign pott_loc = pt_loc.
        end.                       
        ********/
    END. /* FOR EACH pott : */
    /* "2,�жϹ�Ӧ��ͼ����ZHͼ�Ŷ�Ӧ�Ƿ����" . E */

    /* ������ʾ��ʱ�� */
    {xxpocimcreatetta.i}


    for each tte with frame ab1c:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame ab1c:handle).

        disp tte_type1 LABEL "��������"
             tte_type  LABEL "���س̶�"
             tte_vend  LABEL "��Ӧ��"
             tte_part  LABEL "�����"
             tte_desc  label " ��ע"
             with frame ab1c width 200 down.
    end.

    for each tt1a where tt1a_openqty <> 0   with frame ab2c:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame ab2c:handle).

        disp 
            /* tt1a_site  �ص� */                     
            /* tt1a_loc   Ĭ�Ͽ�λ */
            /* tt1a_curr  */
            tt1a_vend     /* ��Ӧ�� */
            tt1a_nbr      /* ���� */
            tt1a_line     /* ������   */
            tt1a_part     /* ͼ�� */
            tt1a_vendpart label "Vend part"
            tt1a_openqty  /*   δ����   */
            tt1a_shipno  
            tt1a_lot 
            tt1a_rcvddate LABEL "�ջ�����"
            tt1a_rmks     LABEL "˵��"
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
                    /*����ʽ�Զ�������PO, so_job = "AC" */
                    put UNFORMATTED '- - - - "AC" - - - - - - "' tt1a_site '"' skip.
            
                    if curr <> "rmb" then do:
                       PUT UNFORMATTED  "-" skip.
                    end.
                    PUT UNFORMATTED "-" skip.          /* ˰ */
                END.
    
                PUT UNFORMATTED STRING(tt1a_line) skip.          /* ��� */   
                PUT UNFORMATTED tt1a_site skip.    /* �ص� */
                put UNFORMATTED "-" skip.
                put UNFORMATTED '"' tt1a_part '"' skip.
                put UNFORMATTED string(tt1a_openqty) skip.
                /* ��������Ҫ�Ȳ���APģ�����ߺ��ȷ�� */
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
                /* �������� */
                tmp_lot = "".
                if v_rctdate <> ? then do:
                    datestr = substring(string(year(v_rctdate),"9999"),3,2) + string(month(v_rctdate),"99") + string(day(v_rctdate),"99")   .  
                end.
                tmp_lot = datestr 
                        + substring(xxinv_con,6) /*ȡ��ͬ��vt32/������ַ�*/
                        + string(xxship_case2,"99")    /*�к�*/
                        .  /* SS - 110307.1 */
    
                /* ȡ��ERPͼ�� */
                tmp_part="".
                if xxinv_pm = no then /*�Ǳ�˰*/
                        find first vp_mstr 
                            use-index vp_vend_part
                            where  vp_vend = xxinv_vend 
                            and  vp_vend_part = xxship_part 
                            and  vp_part begins "M" 
                        no-lock no-error.
                else  /*��˰*/
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
                            /*�ۼ�δ����С��δ������ֱ���ջ�B*/
                            {xxpocimrcyes.i}  
                        end. 
                        else do: 
                            j = j + 1.
                            v_qty_rct = (xxship_qty - xxship_rcvd_qty) .
                            /*�ۼ�δ��������δ������ֱ���ջ�B*/
                            {xxpocimrcyes.i}  
        
                            LEAVE.
                        end.
                end. /* for each po_mstr where po_vend = xxinv_vend  */
    
            END. /*for each xxinv_mstr */
            MESSAGE "���ι�����" + string(j) + "������,���鵼������Ϣ�ļ���ȷ�������Ƿ�������ȷ�ĵ��뵽ϵͳ!" VIEW-AS ALERT-BOX.
        END. /*IF v_flagyn = YES*/
    END. /* v_flag = yes */
