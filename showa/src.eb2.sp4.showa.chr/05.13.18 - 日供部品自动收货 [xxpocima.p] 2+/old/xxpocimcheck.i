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
			               break by xx_inv_site by xx_inv_vend  by xx_ship_part :
        
        ACCUMULATE (xx_ship_qty - xx_ship_rcvd_qty) ( TOTAL by xx_inv_site by xx_inv_vend BY xx_ship_part ) .

        IF LAST-OF(xx_ship_part) THEN DO:
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
	           pott_curr       = xx_ship_curr
	           pott_duedate    = today
	           pott_etadate    = today
	           pott_line       = xx_ship_line
               pott_order_type = xx_ship_type  /*Z������R�»���*/
	           pott_rate       = xx_inv_rate
               .

	       /* �������� */
	       if rcvddate <> ? then do:
		      if month(rcvddate)>9 then assign datestr=substring(string(year(rcvddate)),3)  + string(month(rcvddate)).
		      else assign datestr=string(year(rcvddate))  + "0" + string(month(rcvddate)).
		      if day(rcvddate)>9 then assign datestr= datestr + string(day(rcvddate)).
		      else assign datestr= datestr + "0" + string(day(rcvddate)).
	       end.

           assign pott_lot = datestr + xx_inv_no .

           /* ȡ������PO�ĵ��� */
	       find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
	       if avail vd_mstr then do:
	          if xx_ship_curr <> vd_curr then assign pott_cost = xx_ship_price * xx_inv_rate.
		                                 else ASSIGN pott_cost = xx_ship_price .
	       end.
	       ELSE ASSIGN pott_cost = xx_ship_price .
        end.
    end. /* for each xx_ship_det */
    /* "1,ȡ��������������,��ȴ�......" ����Ӧ�̣�ͼ�Ż���. E*/


    /* "2,�жϹ�Ӧ��ͼ����ZHͼ�Ŷ�Ӧ�Ƿ����" . B */
    v_flag = YES.
    FOR EACH pott :
        FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
        IF NOT AVAIL vp_mstr THEN DO:
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

	    disp tte_type1
	         tte_type
	         tte_vend
	         tte_part
	         tte_desc label "Remark"
             with frame ab1c width 200 down.
    end.

    for each tt1a where tt1a_openqty<>0   with frame ab2c:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame ab2c:handle).

	    disp tt1a_nbr  /* ���� */
	         tt1a_curr 
	         tt1a_line /*   ������   */
        	 tt1a_vend /* ��Ӧ�� */
        	 tt1a_openqty /*   δ����   */
        	 tt1a_part 	/* ͼ�� */
        	 tt1a_vendpart label "Vend part"
        	 tt1a_site /* �ص� */				     
        	 tt1a_loc  /* Ĭ�Ͽ�λ */
        	 tt1a_shipno  
        	 tt1a_lot 
        	 tt1a_shipline
        	 tt1a_rmks /* get lot*/
             with frame ab2c width 200 down.
    end.
  
   /* REPORT TRAILER */
   {mfrtrail.i}
