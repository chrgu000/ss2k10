  	    /* 生成批号 */
	    tmp_lot = "".
	    if rcvddate <> ? then do:
		    if month(rcvddate) > 9 then assign datestr = substring(string(year(rcvddate)),3) + string(month(rcvddate)).
		                           else assign datestr = string(year(rcvddate))  + "0" + string(month(rcvddate)).
		    if day(rcvddate) > 9 then assign datestr = datestr + string(day(rcvddate)).
		                         else assign datestr = datestr + "0" + string(day(rcvddate)).
	    end.
        tmp_lot = datestr + xx_inv_no .

        /* 取得生成PO是的单价B*/
        tmp_cost=0. 
	    find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
        /* 汇率问题要等财务AP模块上线后才确定 */
        /*
	    if avail vd_mstr then do:
            if xx_ship_curr <> vd_curr then tmp_cost = xx_ship_price * xx_inv_rate.
		                              else tmp_cost = xx_ship_price .
	    end.
	    else tmp_cost = xx_ship_price .
        */

        /* 取得ERP图号 */
	    tmp_part="".
	    FIND FIRST vp_mstr WHERE xx_inv_vend = vp_vend AND xx_ship_part = vp_vend_part NO-LOCK NO-ERROR.
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
                                ( SUBSTRING(pod_nbr,1,1) = "N" AND substring(xx_ship_type,1,1) = "R") )    NO-LOCK BY po_nbr :
			    IF (xx_ship_qty - xx_ship_rcvd_qty) >= (pod_qty_ord - pod_qty_rcvd) then do:          
                    j = j + 1.
                    tmp_qty = pod_qty_ord - pod_qty_rcvd.
 
                    /*
                    MESSAGE "1." + pod_nbr + " " + STRING(pod_line) + " " + string(tmp_qty) VIEW-AS ALERT-BOX.
                      */

			        /*累加未结量小于未收量，直接收货B*/
			        {xxpocimrcyes.i}  
                end. 
			    else do: 
			        j = j + 1.
                    tmp_qty = xx_ship_qty - xx_ship_rcvd_qty .

                    /*
                    MESSAGE "2." + pod_nbr + " " + STRING(pod_line) + " " + string(tmp_qty) VIEW-AS ALERT-BOX.
                      */

                    /*累加未结量大于未收量，直接收货B*/
                    {xxpocimrcyes.i}  

                    LEAVE.
			    end.
        end. /* for each po_mstr where po_vend = xx_inv_vend  */

        /*PO未结量不足，增加订单，再收货B*/
        IF xx_ship_qty - xx_ship_rcvd_qty > 0 then do:
            j = j + 1. 
		    tmp_qty = xx_ship_qty - xx_ship_rcvd_qty .
		       
            /*
            MESSAGE "3." + " " + string(tmp_qty) VIEW-AS ALERT-BOX.
              */

            /*PO未结量不足，余量增加定单B*/
		    {xxpocimrcaddpo.i}
		      
		    /*PO未结量不足，余量增加定单完成后收货B*/
		    {xxpocimrcno.i}  
	    end.  
















              
