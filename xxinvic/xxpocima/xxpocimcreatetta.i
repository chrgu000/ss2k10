/*----rev history-------------------------------------------------------------------------------------*/
/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */
/*原版{mfdtitle.i "2+ "}*/
/* SS - 110307.1  By: Roger Xiao */ /* vp_mstr 区分保税非保税,vp_part : P,M开头区分 */
/*-Revision end---------------------------------------------------------------*/

    
    for each pott BREAK BY pott_site BY pott_vend BY pott_order_type :
        IF FIRST-OF(pott_order_type) THEN DO:
            jj = 0 .
            find first vd_mstr where vd_addr = pott_vend no-lock no-error.

            tmp_ponbr = "" .
            if month(rcvddate) < 10 THEN tmpmonth = STRING(MONTH(rcvddate)).
            ELSE IF MONTH(rcvddate) = 10 THEN tmpmonth = "A" .
            ELSE IF MONTH(rcvddate) = 11 THEN tmpmonth = "B" .
            ELSE IF MONTH(rcvddate) = 12 THEN tmpmonth = "C" .
        
            DO i = 1 TO 99 :
                if avail vd_mstr then do:
                    assign tmp_ponbr = substring(pott_order_type,1,1) + substring(string(year(rcvddate)),3) + tmpmonth + substring(vd_sort,1,2) + STRING(i,"99") .
                end.
                else do:
                    assign tmp_ponbr = substring(pott_order_type,1,1) + substring(string(year(rcvddate)),3) + tmpmonth + "ER" + STRING(i,"99") .
                end.
        
                FIND FIRST po_mstr WHERE po_nbr = tmp_ponbr NO-LOCK NO-ERROR.
                IF NOT AVAIL po_mstr THEN LEAVE .
            END.
        END.

        /* 取得ERP图号 */
	    tmp_part = "".
/* SS - 110307.1 - B 
	    FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
   SS - 110307.1 - E */
/* SS - 110307.1 - B */
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
/* SS - 110307.1 - E */
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
                           and pod_qty_ord > pod_qty_rcvd
                           AND (( SUBSTRING(pod_nbr,1,1) = "P" AND substring(pott_order_type,1,1) = "Z") OR
                                ( SUBSTRING(pod_nbr,1,1) = "N" AND substring(pott_order_type,1,1) = "R") OR 
                                ( SUBSTRING(pod_nbr,1,1) = "Z" AND substring(pott_order_type,1,1) = "Z") OR 
                                ( SUBSTRING(pod_nbr,1,1) = "R" AND substring(pott_order_type,1,1) = "R") )
                           NO-LOCK by pod_nbr BY pod_line:
            tmp_flagt="1".			   
            
			find first pt_mstr where pt_part = pott_part_zh no-lock no-error.

			tmp_order_qty = tmp_order_qty + (pod_qty_ord - pod_qty_rcvd) .
            tmp_qty       = pod_qty_ord - pod_qty_rcvd.

            /* 累加未结po数量小于未收量 */
			IF pott_qty >= tmp_order_qty then do:
                 create tt1a .
			     assign tt1a_nbr      = pod_nbr /* 订单 */
			            tt1a_curr     = po_curr
			            tt1a_line     = pod_line /*   订单项   */
    		     	    tt1a_vend     = po_vend /* 供应商 */
    				    tt1a_fix_rate = if po_fix_rate = yes then "Y" else "N"
    				    tt1a_openqty  = tmp_qty  /* PO未收量   */
    				    tt1a_qty      = tmp_qty
    				    tt1a_part     = pod_part	/* ERP图号 */			    
    				    tt1a_site     = pod_site /* 地点 */				     
    			        tt1a_loc      = if avail pt_mstr then pt_loc else ""  /* 默认库位 */
    			        tt1a_shipno   = pott_shipno
    			        tt1a_lot      = pott_lot
    			        tt1a_vendpart = pott_part_vend
    		     	    tt1a_rcvddate = pott_rcvddate
    				    tt1a_rmks     = "存在相应PO,本次全部收货"
                        . 
            end. /* IF pott_qty >= tmp_order_qty then do: */
            else do:
                create tt1a .
				assign tt1a_nbr       = pod_nbr /* 订单 */
			    	   tt1a_curr      = po_curr
					   tt1a_line      = pod_line /*   订单项   */
					   tt1a_vend      = po_vend /* 供应商 */
					   tt1a_fix_rate  = if po_fix_rate = yes then "Y" else "N"
					   tt1a_openqty   = pott_qty - (tmp_order_qty - tmp_qty)  /* PO未收量   */
					   tt1a_qty       = pott_qty - (tmp_order_qty - tmp_qty)
					   tt1a_part      = pod_part	/* ERP图号 */			    
					   tt1a_site      = pod_site /* 地点 */				     
					   tt1a_loc       = if avail pt_mstr then pt_loc else ""  /* 默认库位 */
					   tt1a_shipno    = pott_shipno
					   tt1a_lot       = pott_lot
					   tt1a_vendpart  = pott_part_vend
					   tt1a_rcvddate = pott_rcvddate
					   tt1a_rmks      = "存在相应PO"
                       .
                leave.
			end.         
        end. /* for each po_mstr where po_vend = pott_vend */

        /* PO未结量不足，增加订单 */
	    if tmp_flagt = "1" AND (pott_qty > tmp_order_qty ) then do:
            find first vd_mstr where vd_addr = pott_vend no-lock no-error.

			/* 取得PO号 */   
            /*
			if month(rcvddate) >= 10 then tmpmonth = string(month(rcvddate)).
			                      else tmpmonth = "0" + string(month(rcvddate)).
              */
            jj = jj + 1.

			create tt1a .
            assign tt1a_nbr      = tmp_ponbr /* 订单 */
                   tt1a_curr     = pott_curr
                   tt1a_line     = jj /*   订单项   */
                   tt1a_vend     = pott_vend /* 供应商 */
                   tt1a_fix_rate = ""
                   tt1a_openqty  = pott_qty - tmp_order_qty  /* PO未收量   */
                   tt1a_qty      = pott_qty - tmp_order_qty
                   tt1a_part     = tmp_part	/* ERP图号 */			    
                   tt1a_site     = pott_site /* 地点 */				     
                   tt1a_loc      = pott_loc  /* 默认库位 */
                   tt1a_shipno   = pott_shipno
                   tt1a_lot      = pott_lot
                   tt1a_vendpart = pott_part_vend
                   tt1a_rcvddate = pott_rcvddate
                   tt1a_type     = "1"
                   tt1a_cost     = pott_cost
                   tt1a_rmks     = "PO未结量不足,新增PO"
                   . 
	    end. /* if tmp_flagt = "1" and (pott_qty > tmp_order_qty ) then do: */

        /* PO不存在未结量，增加订单 */
	    if tmp_flagt = "" then do:   
            tmp_flagt="2".

			find first vd_mstr where vd_addr=pott_vend no-lock no-error.

			/*取得PO号 B */  
            /*
			if month(rcvddate)>=10 then tmpmonth = string(month(rcvddate)).
			                    else tmpmonth = "0" + string(month(rcvddate)).
                                */
            jj = jj + 1.
			create tt1a .
			assign tt1a_nbr      = tmp_ponbr /* 订单 */
			       tt1a_curr     = pott_curr
				   tt1a_line     = jj /*   订单项   */
				   tt1a_vend     = pott_vend /* 供应商 */
				   tt1a_fix_rate = ""
				   tt1a_openqty  = pott_qty  /*   未决量   */
				   tt1a_qty      = pott_qty
				   tt1a_part     = tmp_part	/* 图号 */			    
				   tt1a_site     = pott_site /* 地点 */				     
				   tt1a_loc      = pott_loc  /* 默认库位 */
				   tt1a_shipno   = pott_shipno
			       tt1a_lot      = pott_lot
				   tt1a_vendpart = pott_part_vend
                   tt1a_rcvddate = pott_rcvddate
                   tt1a_type     = "1"
                   tt1a_cost     = pott_cost
				   tt1a_rmks     = "不存在相应PO,新增PO"
                   . 
	    end. /* if tmp_flagt = "" then do: */   
    end. /* for each pott: */

   	   














              
