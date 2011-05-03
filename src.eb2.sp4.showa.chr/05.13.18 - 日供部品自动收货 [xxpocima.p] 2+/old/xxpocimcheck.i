    /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. B*/
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
                           and xx_ship_qty > xx_ship_rcvd_qty  /* (待收货量 > 已收货量) */
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
               pott_order_type = xx_ship_type  /*Z量产，R新机种*/
	           pott_rate       = xx_inv_rate
               .

	       /* 生成批号 */
	       if rcvddate <> ? then do:
		      if month(rcvddate)>9 then assign datestr=substring(string(year(rcvddate)),3)  + string(month(rcvddate)).
		      else assign datestr=string(year(rcvddate))  + "0" + string(month(rcvddate)).
		      if day(rcvddate)>9 then assign datestr= datestr + string(day(rcvddate)).
		      else assign datestr= datestr + "0" + string(day(rcvddate)).
	       end.

           assign pott_lot = datestr + xx_inv_no .

           /* 取得生成PO的单价 */
	       find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
	       if avail vd_mstr then do:
	          if xx_ship_curr <> vd_curr then assign pott_cost = xx_ship_price * xx_inv_rate.
		                                 else ASSIGN pott_cost = xx_ship_price .
	       end.
	       ELSE ASSIGN pott_cost = xx_ship_price .
        end.
    end. /* for each xx_ship_det */
    /* "1,取符合条件的数据,请等待......" 按供应商，图号汇总. E*/


    /* "2,判断供应商图号与ZH图号对应是否存在" . B */
    v_flag = YES.
    FOR EACH pott :
        FIND FIRST vp_mstr WHERE pott_vend = vp_vend AND pott_part_vend = vp_vend_part NO-LOCK NO-ERROR.
        IF NOT AVAIL vp_mstr THEN DO:
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
           
        /* get pt_loc */
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
    END. /* FOR EACH pott : */
    /* "2,判断供应商图号与ZH图号对应是否存在" . E */

    /* 建立显示临时表 */
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

	    disp tt1a_nbr  /* 订单 */
	         tt1a_curr 
	         tt1a_line /*   订单项   */
        	 tt1a_vend /* 供应商 */
        	 tt1a_openqty /*   未决量   */
        	 tt1a_part 	/* 图号 */
        	 tt1a_vendpart label "Vend part"
        	 tt1a_site /* 地点 */				     
        	 tt1a_loc  /* 默认库位 */
        	 tt1a_shipno  
        	 tt1a_lot 
        	 tt1a_shipline
        	 tt1a_rmks /* get lot*/
             with frame ab2c width 200 down.
    end.
  
   /* REPORT TRAILER */
   {mfrtrail.i}
