    for each pott:
        /* ȡ��ERPͼ�� */
	    tmp_part = "".
	    FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
	    IF AVAIL vp_mstr THEN tmp_part = vp_part .

        tmp_order_qty = 0.
	    tmp_flagt     = "".
        tmp_qty       = 0.
        for each po_mstr where po_vend = pott_vend 
                           and po_stat = "" NO-LOCK ,	    
			each pod_det where pod_nbr  = po_nbr 
                           and pod_part = pott_part_zh 
                           and pod_status = "" 
                           and pod_site = pott_site 
                           and pod_qty_ord > pod_qty_rcvd NO-LOCK by pod_nbr BY pod_line:
            tmp_flagt="1".			   
            
			find first pt_mstr where pt_part = pott_part_zh no-lock no-error.

			tmp_order_qty = tmp_order_qty + (pod_qty_ord - pod_qty_rcvd) .
            tmp_qty       = pod_qty_ord - pod_qty_rcvd.

            /* �ۼ�δ��po����С��δ���� */
			IF pott_qty >= tmp_order_qty then do:
                 create tt1a .
			     assign tt1a_nbr      = pod_nbr /* ���� */
			            tt1a_curr     = po_curr
			            tt1a_line     = pod_line /*   ������   */
    		     	    tt1a_vend     = po_vend /* ��Ӧ�� */
    				    tt1a_fix_rate = if po_fix_rate = yes then "Y" else "N"
    				    tt1a_openqty  = tmp_qty  /* POδ����   */
    				    tt1a_part     = pod_part	/* ERPͼ�� */			    
    				    tt1a_site     = pod_site /* �ص� */				     
    			        tt1a_loc      = if avail pt_mstr then pt_loc else ""  /* Ĭ�Ͽ�λ */
    			        tt1a_shipno   = pott_shipno
    			        tt1a_lot      = pott_lot
    			        tt1a_vendpart = pott_part_vend
    		     	    tt1a_shipline = pott_line
    				    tt1a_rmks     = "�Ѵ��ڵĶ���,ȫ���ջ�"
                        . 
            end. /* IF pott_qty >= tmp_order_qty then do: */
            else do:
                create tt1a .
				assign tt1a_nbr       = pod_nbr /* ���� */
			    	   tt1a_curr      = po_curr
					   tt1a_line      = pod_line /*   ������   */
					   tt1a_vend      = po_vend /* ��Ӧ�� */
					   tt1a_fix_rate  = if po_fix_rate = yes then "Y" else "N"
					   tt1a_openqty   = pott_qty - (tmp_order_qty - tmp_qty)  /* POδ����   */
					   tt1a_part      = pod_part	/* ERPͼ�� */			    
					   tt1a_site      = pod_site /* �ص� */				     
					   tt1a_loc       = if avail pt_mstr then pt_loc else ""  /* Ĭ�Ͽ�λ */
					   tt1a_shipno    = pott_shipno
					   tt1a_lot       = pott_lot
					   tt1a_vendpart  = pott_part_vend
					   tt1a_shipline  = pott_line
					   tt1a_rmks      = "�Ѵ��ڵĶ���"
                       .
                leave.
			end.         
        end. /* for each po_mstr where po_vend = pott_vend */

        /* POδ�������㣬���Ӷ��� */
	    if tmp_flagt = "1" AND (pott_qty > tmp_order_qty ) then do:
            find first vd_mstr where vd_addr = pott_vend no-lock no-error.

			/* ȡ��PO�� */   
			if month(today) >= 10 then tmpmonth = string(month(today)).
			                      else tmpmonth = "0" + string(month(today)).

            DO i = 1 TO 9 :
    			if avail vd_mstr then do:
                    assign tmp_ponbr = substring(pott_order_type,1,1) + substring(string(year(today)),3) + tmpmonth + substring(vd_sort,1,2) + STRING(i) .
    			end.
    			else do:
    			    assign tmp_ponbr = substring(pott_order_type,1,1) + substring(string(year(today)),3) + tmpmonth + "ER" + STRING(i) .
    			end.

                FIND FIRST po_mstr WHERE po_nbr = tmp_ponbr NO-LOCK NO-ERROR.
                IF NOT AVAIL po_mstr THEN LEAVE .
            END.
		               
			create tt1a .
            assign tt1a_nbr      = tmp_ponbr /* ���� */
                   tt1a_curr     = pott_curr
                   tt1a_line     = 1 /*   ������   */
                   tt1a_vend     = pott_vend /* ��Ӧ�� */
                   tt1a_fix_rate = ""
                   tt1a_openqty  = pott_qty - tmp_order_qty  /* POδ����   */
                   tt1a_part     = tmp_part	/* ERPͼ�� */			    
                   tt1a_site     = pott_site /* �ص� */				     
                   tt1a_loc      = pott_loc  /* Ĭ�Ͽ�λ */
                   tt1a_shipno   = pott_shipno
                   tt1a_lot      = pott_lot
                   tt1a_vendpart = pott_part_vend
                   tt1a_shipline = pott_line
                   tt1a_rmks     = "POδ��������,����PO"
                   . 
	    end. /* if tmp_flagt = "1" and (pott_qty > tmp_order_qty ) then do: */

        /* PO������δ���������Ӷ��� */
	    if tmp_flagt = "" then do:   
            tmp_flagt="2".

			find first vd_mstr where vd_addr=pott_vend no-lock no-error.

			/*ȡ��PO�� B */  
			if month(today)>=10 then tmpmonth = string(month(today)).
			                    else tmpmonth = "0" + string(month(today)).

            DO i = 1 TO 9 :
    			if avail vd_mstr then do:
                    assign tmp_ponbr = substring(pott_order_type,1,1) + substring(string(year(today)),3) + tmpmonth + substring(vd_sort,1,2) + STRING(i) .
    			end.
    			else do:
    			    assign tmp_ponbr = substring(pott_order_type,1,1) + substring(string(year(today)),3) + tmpmonth + "ER" + STRING(i) .
    			end.

                FIND FIRST po_mstr WHERE po_nbr = tmp_ponbr NO-LOCK NO-ERROR.
                IF NOT AVAIL po_mstr THEN LEAVE .
            END.

			create tt1a .
			assign tt1a_nbr      = tmp_ponbr /* ���� */
			       tt1a_curr     = pott_curr
				   tt1a_line     = 1 /*   ������   */
				   tt1a_vend     = pott_vend /* ��Ӧ�� */
				   tt1a_fix_rate = ""
				   tt1a_openqty  = pott_qty  /*   δ����   */
				   tt1a_part     = tmp_part	/* ͼ�� */			    
				   tt1a_site     = pott_site /* �ص� */				     
				   tt1a_loc      = pott_loc  /* Ĭ�Ͽ�λ */
				   tt1a_shipno   = pott_shipno
			       tt1a_lot      = pott_lot
				   tt1a_vendpart = pott_part_vend
				   tt1a_shipline = pott_line
				   tt1a_rmks     = "��������ӦPO,����PO"
                   . 
	    end. /* if tmp_flagt = "" then do: */   
    end. /* for each pott: */


   	   














              
