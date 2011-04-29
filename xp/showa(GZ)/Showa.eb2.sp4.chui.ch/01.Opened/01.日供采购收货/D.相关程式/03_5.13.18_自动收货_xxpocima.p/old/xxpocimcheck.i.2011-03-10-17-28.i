/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110307.1  By: Roger Xiao */ /* vp_mstr ���ֱ�˰�Ǳ�˰,vp_part : P,M��ͷ���� */
/*-Revision end---------------------------------------------------------------*/

    
    /* "1,ȡ��������������,��ȴ�......" ����Ӧ�̣�ͼ�Ż���. B*/
    for each xx_inv_mstr where xx_inv_no   >= shipno 
                           and xx_inv_no   <= shipno1 
                           and xx_inv_vend >= vend 
                           and xx_inv_vend <= vend1
			               and xx_inv_site >= site 
                           and xx_inv_site <= site1 no-lock,
        each xx_ship_det where xx_inv_no   = xx_ship_no 
			               and xx_ship_line >= shipline 
                           and xx_ship_line <= shipline1  
			               and xx_ship_status = "" 
                           and xx_ship_qty > xx_ship_rcvd_qty  /* (���ջ��� > ���ջ���) */
			               break by xx_inv_site by xx_inv_vend   
                           by xx_ship_part :
        
        ACCUMULATE (xx_ship_qty - xx_ship_rcvd_qty) ( TOTAL by xx_inv_site by xx_inv_vend BY xx_ship_part ) .

        IF LAST-OF(xx_ship_part) THEN DO:
            /* SS - 110307.1 - B */
           find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
            /* SS - 110307.1 - E */

           CREATE pott.
           ASSIGN
               pott_shipno     = xx_ship_no
	           pott_site       = xx_inv_site
	           pott_vend       = xx_inv_vend
	           pott_case       = xx_ship_case
	           pott_part_vend  = xx_ship_part
	           pott_pkg        = xx_ship_pkg
	           pott_qty_unit   = xx_ship_qty_unit
	           pott_qty        = (ACCUMULATE TOTAL BY xx_ship_part xx_ship_qty - xx_ship_rcvd_qty ) 
	           pott_status     = xx_ship_status
	           pott_price      = xx_ship_price
	           pott_value      = xx_ship_value
            /* SS - 110307.1 - B 
	           pott_curr       = xx_ship_curr
	           pott_rate       = xx_inv_rate
               SS - 110307.1 - E */
            /* SS - 110307.1 - B */
	           pott_curr       = if avail vd_mstr then vd_curr else "JPY" 
            /* SS - 110307.1 - E */

               pott_rcvddate   = rcvddate
	           pott_line       = xx_ship_line
               pott_order_type = xx_ship_type  /*Z������R�»���*/
               pott_inv_pm     = xx_inv_pm   /* SS - 110307.1 */
               .

	       /* �������� */
	       if rcvddate <> ? then do:
            /* SS - 110307.1 - B 
		      if month(rcvddate)>9 then assign datestr=substring(string(year(rcvddate)),3)  + string(month(rcvddate)).
		      else assign datestr=string(year(rcvddate))  + "0" + string(month(rcvddate)).
		      if day(rcvddate)>9 then assign datestr= datestr + string(day(rcvddate)).
		      else assign datestr= datestr + "0" + string(day(rcvddate)).
               SS - 110307.1 - E */
            /* SS - 110307.1 - B */
              datestr = substring(string(year(rcvddate),"9999"),3,2) + string(month(rcvddate),"99") + string(day(rcvddate),"99")   . 
            /* SS - 110307.1 - E */

	       end.

           assign pott_lot = datestr + xx_inv_no .

           /* ȡ������PO�ĵ��� */
/* SS - 110307.1 - B 
	       find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
	       if avail vd_mstr then do:
	          if xx_ship_curr <> vd_curr then assign pott_cost = xx_ship_price * xx_inv_rate.
		                                 else ASSIGN pott_cost = xx_ship_price .
	       end.
	       ELSE ASSIGN pott_cost = xx_ship_price .
   SS - 110307.1 - E */
/* SS - 110307.1 - B */
           /* pott_cost Ҫ��:���÷�Ʊ�ϵļ۸�,ֱ����1.10.2.1�۸��ļ۸� */
/* SS - 110307.1 - E */

        end.
    end. /* for each xx_ship_det */
    /* "1,ȡ��������������,��ȴ�......" ����Ӧ�̣�ͼ�Ż���. E*/
                           
    /* "2,�жϹ�Ӧ��ͼ����ZHͼ�Ŷ�Ӧ�Ƿ����" . B */
    v_flag = YES.
    FOR EACH pott :
/* SS - 110307.1 - B 
        FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
        IF NOT AVAIL vp_mstr THEN DO:
   SS - 110307.1 - E */
/* SS - 110307.1 - B */
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
/* SS - 110307.1 - E */

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

        /* get pt_loc */
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
            tt1a_site /* �ص� */				     
            tt1a_loc  /* Ĭ�Ͽ�λ */
            tt1a_vend /* ��Ӧ�� */
            tt1a_curr
            tt1a_nbr  /* ���� */
            tt1a_line /*   ������   */
            tt1a_part 	/* ͼ�� */
            tt1a_vendpart label "Vend part"
            tt1a_openqty /*   δ����   */
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
    
                    usection = TRIM ( string(year(rcvddate)) + string(MONTH(rcvddate)) + string(DAY(rcvddate)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "pomt" .
                    output to value( trim(usection) + ".i") .
                    PUT UNFORMATTED tt1a_nbr skip.
            	    PUT UNFORMATTED tt1a_vend skip.
                    PUT UNFORMATTED " - " skip.
            	    do i = 1 to 11:
            	       put UNFORMATTED "- ".
            	    end.
            	    PUT UNFORMATTED tt1a_site skip.
            
                    if curr <> "rmb" then do:
            	       PUT UNFORMATTED  " - " skip.
            	    end.
                    PUT UNFORMATTED " - " skip.          /* ˰ */
                END.
    
                PUT UNFORMATTED STRING(tt1a_line) skip.          /* ��� */   
        	    PUT UNFORMATTED tt1a_site skip.    /* �ص� */
        	    put UNFORMATTED " - " skip.
        	    put UNFORMATTED tt1a_part skip.
        	    put UNFORMATTED string(tt1a_openqty) skip.
                /* ��������Ҫ�Ȳ���APģ�����ߺ��ȷ�� */
                /*
        	    put UNFORMATTED tmp_cost skip.
                */
                put UNFORMATTED " - " skip.
        	    put UNFORMATTED " - " skip.
    
                FIND FIRST ad_mstr WHERE ad_addr = tt1a_vend AND ad_taxable = YES NO-LOCK NO-ERROR.
                IF AVAIL ad_mstr THEN PUT UNFORMATTED " - " SKIP.
                                                 
                IF LAST-OF(tt1a_nbr) THEN DO:
                    put "." skip.
    	            put "." skip.
            	    put " - " skip.
            	    put " - " skip.   
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
            
            	    /*if errstr = "" then do:
                      unix silent value ( "rm -f "  + Trim(usection) + ".i").
                      unix silent value ( "rm -f "  + Trim(usection) + ".o").
                    end.*/
                END.
            END.
        END. /* v_flagpo = yes */

        IF v_flagyn = YES THEN DO:
            j = 0.
            for each xx_inv_mstr where xx_inv_no   >= shipno 
                                       and xx_inv_no   <= shipno1 
                                       and xx_inv_vend >= vend 
                                       and xx_inv_vend <= vend1
    			                       and xx_inv_site >= site 
                                       and xx_inv_site <= site1 no-lock,
                each xx_ship_det where xx_inv_no     = xx_ship_no 
    			                       and xx_ship_line >= shipline 
                                       and xx_ship_line <= shipline1  
    			                       and xx_ship_status = "" 
                                       and xx_ship_qty > xx_ship_rcvd_qty
                BY xx_inv_no BY xx_ship_line :
                /* �������� */
        	    tmp_lot = "".
        	    if rcvddate <> ? then do:
                    /* SS - 110307.1 - B 
        		    if month(rcvddate) > 9 then assign datestr = substring(string(year(rcvddate)),3) + string(month(rcvddate)).
        		                           else assign datestr = string(year(rcvddate))  + "0" + string(month(rcvddate)).
        		    if day(rcvddate) > 9 then assign datestr = datestr + string(day(rcvddate)).
        		                         else assign datestr = datestr + "0" + string(day(rcvddate)).
                       SS - 110307.1 - E */
                    /* SS - 110307.1 - B */
                    datestr = substring(string(year(rcvddate),"9999"),3,2) + string(month(rcvddate),"99") + string(day(rcvddate),"99")   .  
                    /* SS - 110307.1 - E */
        	    end.
                tmp_lot = datestr + xx_inv_no .
    
                /* ȡ��ERPͼ�� */
        	    tmp_part="".
/* SS - 110307.1 - B 
        	    FIND FIRST vp_mstr WHERE xx_inv_vend = vp_vend AND xx_ship_part = vp_vend_part NO-LOCK NO-ERROR.
   SS - 110307.1 - E */
/* SS - 110307.1 - B */
        if xx_inv_pm = no then /*�Ǳ�˰*/
                find first vp_mstr 
                    use-index vp_vend_part
                    where  vp_vend = xx_inv_vend 
                    and  vp_vend_part = xx_ship_part 
                    and  vp_part begins "M" 
                no-lock no-error.
        else  /*��˰*/
                find first vp_mstr 
                    use-index vp_vend_part
                    where  vp_vend = xx_inv_vend 
                    and  vp_vend_part = xx_ship_part 
                    and  vp_part begins "P" 
                no-lock no-error.
/* SS - 110307.1 - E */
        	    IF AVAIL vp_mstr THEN tmp_part = vp_part .
    
                tmp_order_qty = 0.
        	    tmp_flagt     = "".
                tmp_qty       = 0 .
                for each po_mstr where po_vend = xx_inv_vend 
                                   and po_stat = "" NO-LOCK ,
                    each pod_det where pod_nbr = po_nbr 
                                   and pod_part = tmp_part 
                                   and pod_status = "" 
                                   and pod_site = xx_inv_site 
                                   and pod_qty_ord > pod_qty_rcvd
                                   AND (( SUBSTRING(pod_nbr,1,1) = "P" AND substring(xx_ship_type,1,1) = "Z") OR
                                        ( SUBSTRING(pod_nbr,1,1) = "N" AND substring(xx_ship_type,1,1) = "R") OR
                                        ( SUBSTRING(pod_nbr,1,1) = "Z" AND substring(xx_ship_type,1,1) = "Z") OR 
                                        ( SUBSTRING(pod_nbr,1,1) = "R" AND substring(xx_ship_type,1,1) = "R") ) NO-LOCK BY po_nbr :
                        tmp_flagt = "1" .
        
        			    tmp_order_qty = tmp_order_qty + (pod_qty_ord - pod_qty_rcvd) .
                        tmp_qty       = pod_qty_ord - pod_qty_rcvd.
        
        			    IF (xx_ship_qty - xx_ship_rcvd_qty) >= tmp_order_qty then do:          
                            j = j + 1.
                            /*�ۼ�δ����С��δ������ֱ���ջ�B*/
        			        {xxpocimrcyes.i}  
                        end. 
        			    else do: 
        			        j = j + 1.
                            /*�ۼ�δ��������δ������ֱ���ջ�B*/
                            {xxpocimrcyes1.i}  
        
                            LEAVE.
        			    end.
                end. /* for each po_mstr where po_vend = xx_inv_vend  */
    
            END.
            MESSAGE "���ι�����" + string(j) + "������,���鵼������Ϣ�ļ���ȷ�������Ƿ�������ȷ�ĵ��뵽ϵͳ!" VIEW-AS ALERT-BOX.
        END.
    END. /* v_flag = yes */
