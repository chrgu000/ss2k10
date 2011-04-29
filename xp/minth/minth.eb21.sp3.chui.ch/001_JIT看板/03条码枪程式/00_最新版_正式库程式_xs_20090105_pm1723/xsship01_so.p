/* xsship01.p   Ford shippment                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 08/17/06   BY: tommy                         */

define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid.
define shared variable batchrun like mfc_logical.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable i as integer .
define variable dmdesc like dom_name.
define variable count_box as integer.
define variable count_page as integer.
define variable usection as char format "x(16)".
define variable last_ser as integer format "999".
define variable model_yr like scx_modelyr.
define variable nbr like scx_order.
define variable qty like xxbcd_qty.
define variable qty_oh like in_qty_oh.
define variable V1002 like si_site.
define variable box_mult as integer.
define variable new_page as logical.
define variable page1 as integer.
define variable serial as integer.
define variable k as integer.
define variable um1 like pt_um.

define variable l_fgloc like xxbcm_fgloc no-undo.
define variable l_cust like xxbcm_cust no-undo.
define variable l_part like xxbcm_part no-undo.
define variable l_site like xxbcm_site no-undo.
define variable l_cust_part like xxbcm_cust_part no-undo.
define variable l_box_mult like xxbcm_box_mult no-undo.
define variable l_serial like xxbcm_serial no-undo.
define variable l_box as integer format "999" no-undo.
define variable l_qty like xxbcm_qty no-undo.
define variable l_um like xxbcm_um no-undo.
define variable l_box_pc like xxbcm_box_pc no-undo.
define variable l_nbr like xxbcm_nbr no-undo.
define variable l_yr as integer format "9999" no-undo.
define variable l_vend like xxbcd_vend no-undo.
define variable l_shipto like xxbcd_shipto no-undo.
define variable l_work_cn like xxbcd_work_cn.
define variable l_ln like xxbcd_ln.
define variable wsection as char format "x(16)".
define variable ts9130 AS CHARACTER FORMAT "x(100)".
define variable av9130 AS CHARACTER FORMAT "x(100)".
define variable l_indx as integer format "9".
define variable custpart1 like xxbcd_cust_part format "x(18)".
define variable custpart2 like xxbcd_cust_part format "x(12)".
define variable wtimeout as integer init 99999 .
define variable mn as char format "x(6)".
define variable li_box as integer format "ZZ9".
define temp-table temp2 
       field t_serial like xxbcd_serial.

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.

dmdesc = "[福特FG:发自]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


  MAINLOOP:
  REPEAT:   

/*   {xsdfsite.i}      */
/*   V1002 = wDefSite. */
     V1002 = global_domain.
     if global_domain = "01" then V1002 = "01".
     if global_domain = "99" then V1002 = "99".

     /* START  LINE :1200  客户  */
     V1100L:
     REPEAT:

        hide all.
        define variable V1100           as char format "x(50)".
        define variable PV1100          as char format "x(50)".
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".

        V1100 = "".

        display dmdesc format "x(40)" skip with fram F1100 no-box.

        L11001 = "客户 ?" .
        display L11001          format "x(40)" skip with fram F1100 no-box.
        L11002 = "" . 
        display L11002          format "x(40)" skip with fram F1100 no-box.
        L11003 = "" . 
        display L11003          format "x(40)" skip with fram F1100 no-box.
        L11004 = "" . 
        display L11004          format "x(40)" skip with fram F1100 no-box.
        L11005 = "" . 
        display L11005          format "x(40)" skip with fram F1100 no-box.
        L11006 = "" . 
        display L11006          format "x(40)" skip with fram F1100 no-box.

        display "输入或按E退出"       format "x(40)" skip
                skip with fram F1100 no-box.
        Update V1100
        WITH  fram F1100 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
           
	   IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
           THEN DO:
              IF recid(AD_MSTR) = ? THEN 
	         find first AD_MSTR where AD_DOMAIN = global_domain 
		    AND AD_ADDR >=  INPUT V1100 no-lock no-error.
              ELSE find next AD_MSTR where AD_DOMAIN = global_domain no-lock no-error.

              IF AVAILABLE AD_MSTR then
	         display skip 
		     AD_ADDR @ V1100 
		     AD_NAME @ WMESSAGE NO-LABEL with fram F1100.
              else display skip "" @ WMESSAGE with fram F1100.
           END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(AD_MSTR) = ? THEN 
	         find first AD_MSTR where AD_DOMAIN = global_domain 
		    AND AD_ADDR <=  INPUT V1100 no-lock no-error.
              ELSE find prev AD_MSTR where AD_DOMAIN = global_domain no-lock no-error.
              IF AVAILABLE AD_MSTR then 
	         display skip 
                    AD_ADDR @ V1100 
		    AD_NAME @ WMESSAGE NO-LABEL with fram F1100.
              else display skip "" @ WMESSAGE with fram F1100.
           END.
           APPLY LASTKEY.
        END.
        /* ROLL BAR END */

        /* PRESS e EXIST CYCLE */
        IF trim(V1100) = "e" THEN LEAVE MAINLOOP.
	
        display  skip WMESSAGE NO-LABEL with fram F1100.

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.  
/*debug
        if not (trim(V1100) begins "010017") then do:
           display skip "错误:只能发福特." @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.
	end.
debug*/
	find first AD_MSTR where AD_DOMAIN = global_domain AND AD_ADDR = V1100 no-lock no-error.
        IF NOT AVAILABLE AD_MSTR then do:
           display skip "错误:客户不存在." @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.
        end.
        IF not trim(V1100) <> "" THEN DO:
           display skip "错误:客户不允许空." @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.
        end.
        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END 1100  客户  */

     /* START V1200 客户零件：? */
     V1200L:
     REPEAT:
        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1200           as char format "x(50)".
        define variable PV1200          as char format "x(50)".
        define variable L12001          as char format "x(40)".
        define variable L12002          as char format "x(40)".
        define variable L12003          as char format "x(40)".
        define variable L12004          as char format "x(40)".
        define variable L12005          as char format "x(40)".
        define variable L12006          as char format "x(40)".
	define variable part            like pt_part.
        /* --DEFINE VARIABLE -- END */

        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1200 = "".
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

  	display dmdesc format "x(40)" skip with fram F1200 no-box.

        /* LABEL 1 - START */ 
        L12001 = "客户零件 ?". 
        display L12001          format "x(40)" skip with fram F1200 no-box.
        /* LABEL 1 - END */ 

        /* LABEL 2 - START */ 
        L12002 = "客户:" + V1100. 
        display L12002          format "x(40)" skip with fram F1200 no-box.
        /* LABEL 1 - END */ 

        /* LABEL 3 - START */ 
        L12003 = "" + V1200. 
        display L12003          format "x(40)" skip with fram F1200 no-box.
        /* LABEL 3 - END */ 

        /* LABEL 4 - START */ 
        L12004 = "". 
        display L12004          format "x(40)" skip with fram F1200 no-box.

        /* LABEL 5 - START */ 
        L12005 = "". 
        display L12005          format "x(40)" skip with fram F1200 no-box.

        /* LABEL 6 - START */ 
        L12006 = "". 
        display L12006          format "x(40)" skip with fram F1200 no-box.

        display "输入或E退出"       format "x(40)" skip
                skip with fram F1200 no-box.

        Update V1200
        WITH fram F1200 NO-LABEL
        /* ROLL BAR START */
        EDITING:
              readkey pause wtimeout.
              if lastkey = -1 then quit.
              if LASTKEY = 404 Then Do: /* DISABLE F4 */
                 pause 0 before-hide.
                 undo, retry.
              end.
              display skip "^" @ WMESSAGE NO-LABEL with fram F1200.

              IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
              THEN DO:
                 IF recid(CP_MSTR) = ? THEN 
		    find first CP_MSTR where CP_DOMAIN = global_domain 
		       AND CP_CUST = trim(V1100) AND CP_CUST_PART >=  INPUT V1200 no-lock no-error.
                 ELSE find next CP_MSTR where CP_DOMAIN = global_domain 
		         AND CP_CUST = trim(V1100) no-lock no-error.

                 IF AVAILABLE CP_MSTR then do:
		    display skip 
                        CP_CUST_PART @ V1200 
			CP_PART @ WMESSAGE NO-LABEL with fram F1200.
		    part = cp_part.
		 end.
                 else display skip "" @ WMESSAGE with fram F1200.
              END.

              IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
              THEN DO:
                 IF recid(CP_MSTR) = ? THEN 
		    find first CP_MSTR where CP_CUST = trim(V1100) AND CP_DOMAIN = global_domain
		       AND CP_CUST_PART <= INPUT V1200 no-lock no-error.
                 ELSE find prev CP_MSTR where CP_DOMAIN = global_domain 
		         AND CP_CUST = trim(V1100) no-lock no-error.
                 IF AVAILABLE CP_MSTR then do:
		    part = cp_part.
		    display skip 
                       CP_CUST_PART @ V1200 
		       CP_PART @ WMESSAGE NO-LABEL with fram F1200.
                 end.
                 else display skip "" @ WMESSAGE with fram F1200.
              END.
              APPLY LASTKEY.
           END.
           /* ROLL BAR END */

           /* PRESS e EXIST CYCLE */
           IF V1200 = "e" THEN LEAVE MAINLOOP.

           display skip WMESSAGE NO-LABEL with fram F1200.

           /*  ---- Valid Check ---- START */

           display "...处理...  " @ WMESSAGE NO-LABEL with fram F1200.
           pause 0.

	   find first xxbcd_hist where xxbcd_domain = global_domain AND xxbcd_cust = trim(V1100)
	      AND xxbcd_cust_part = trim(V1200) no-lock no-error.	   
           IF NOT AVAILABLE xxbcd_hist then do:
              display skip "错误,没有小箱标签." @ WMESSAGE NO-LABEL with fram F1200.
              pause 0 before-hide.
              undo, retry.
           end.

           find first CP_MSTR where CP_CUST = trim(V1100) AND CP_DOMAIN = global_domain
		       AND CP_CUST_PART = V1200 no-lock no-error.
           part = (if available cp_mstr then cp_part else "").
	   box_mult = (if available cp_mstr then integer(cp__qadc01) else 0).
	   find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
	   um1 = (if available pt_mstr then pt_um else "").

	   if box_mult = 0 then do:
              display skip "错误,集装箱倍数没输入！" @ WMESSAGE NO-LABEL with fram F1200.
              pause 0 before-hide.
              undo, retry.
	   end.

           IF not trim(V1200) <> "" THEN DO:
              display skip "错误,不允许空." @ WMESSAGE NO-LABEL with fram F1200.
              pause 0 before-hide.
              undo, retry.
           end.
           /*  ---- Valid Check ---- END */

           display  "" @ WMESSAGE NO-LABEL with fram F1200.
           pause 0.
           leave V1200L.
        END.
        PV1200 = V1200.	

/*********** debug start **********/

     V1500L:
     REPEAT:

        hide all.
        define variable V1500           as char format "x(50)".
        define variable PV1500          as char format "x(50)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".

        V1500 = "".

        display dmdesc format "x(40)" skip with fram F1500 no-box.


        /* LABEL 1 - START */ 
        L15001 = "客户订单 ?". 
        display L15001          format "x(40)" skip with fram F1500 no-box.
        /* LABEL 1 - END */ 

        L15002 = "客户:" + V1100. 
        display L15002          format "x(40)" skip with fram F1500 no-box.

        L15003 = "客户零件:" + PV1200.
        display L15003          format "x(40)" skip with fram F1500 no-box.

	L15004 = "" . 
        display L15004          format "x(40)" skip with fram F1500 no-box.
        
	L15005 = "" . 
        display L15005          format "x(40)" skip with fram F1500 no-box.
        
	L15006 = "" . 
        display L15006          format "x(40)" skip with fram F1500 no-box.

        display "输入或按E退出"       format "x(40)" skip
                skip with fram F1500 no-box.
        Update V1500
        WITH  fram F1500 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
           
	   IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
           THEN DO:
              IF recid(scx_ref) = ? THEN 
	         find first scx_ref where scx_domain = global_domain 
		    and scx_shipto = V1100 AND scx_order >=  INPUT V1500 no-lock no-error.
              ELSE find next scx_ref where scx_domain = global_domain and scx_shipto = V1100 no-lock no-error.

              IF AVAILABLE scx_ref then
	         display skip scx_order @ V1500 with fram F1500.
              else display skip "" @ WMESSAGE with fram F1500.
           END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(scx_ref) = ? THEN 
	         find first scx_ref where scx_domain = global_domain and scx_shipto = V1100
		    AND scx_order <=  INPUT V1500 no-lock no-error.
              ELSE find prev scx_ref where scx_domain = global_domain and scx_shipto = V1100 no-lock no-error.
              IF AVAILABLE scx_ref then 
	         display skip 
                    scx_order @ V1500 with fram F1500.
              else display skip "" @ WMESSAGE with fram F1500.
           END.
           APPLY LASTKEY.
        END.
        /* ROLL BAR END */

        /* PRESS e EXIST CYCLE */
        IF trim(V1500) = "e" THEN LEAVE MAINLOOP.
	
        display  skip WMESSAGE NO-LABEL with fram F1500.

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.  

	find first scx_ref where scx_domain = global_domain 
	       AND scx_shipto = V1100 and scx_order = V1500 no-lock no-error.
        
	IF NOT AVAILABLE scx_ref then do:
           display skip "错误:客户订单不存在." @ WMESSAGE NO-LABEL with fram F1500.
           pause 0 before-hide.
           undo, retry.
        end.
        IF not trim(V1500) <> "" THEN DO:
           display skip "错误:客户订单不允许空." @ WMESSAGE NO-LABEL with fram F1500.
           pause 0 before-hide.
           undo, retry.
        end.
        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     PV1500 = V1500.
/*********** debug end **********/

        last_ser = 0.  count_page = 0.  k = 0.
        for each xxbct_hist where xxbct_domain = global_domain 
             and xxbct_site = trim(V1002) and xxbct_cust = trim(V1100)
/*  	     and xxbct_nbr = trim(PV1500)   */
             and xxbct_cust_part = trim(V1200) no-lock
        break by xxbct_serial:
	   if last(xxbct_serial) then assign
              last_ser = integer(substring(xxbct_lot,7,3))
	      count_page = integer(substring(xxbct_lot,10,3)).
        end.
	for each xxbcm_hist where xxbcm_domain = global_domain
	     and xxbcm_site = trim(V1002) and xxbcm_cust = trim(V1100)
/*  	     and xxbcm_nbr = trim(PV1500)  */
	     and xxbcm_cust_part = (V1200) no-lock
        break by xxbcm_serial:
	   if last(xxbcm_serial) then do:
	      if integer(substring(xxbcm_serial,7,3)) > last_ser then
		 assign last_ser = integer(substring(xxbcm_serial,7,3))
	              count_page = integer(substring(xxbcm_serial,10,3)).
	   end.
	end.

	count_box = 0.
        qty = 0.

        /* Internal Cycle Input :1300    */  
        V1300LMAINLOOP:
        REPEAT:

           /* START  LINE :1400  条码号]  */
           V1400L:
           REPEAT:	   
              hide all.
              define variable V1400           as char format "x(50)".
              define variable PV1400          as char format "x(50)".
              define variable L14001          as char format "x(40)".
              define variable L14002          as char format "x(40)".
              define variable L14003          as char format "x(40)".
              define variable L14004          as char format "x(40)".
              define variable L14005          as char format "x(40)".
              define variable L14006          as char format "x(40)".

              V1400 = "".
	      display dmdesc format "x(40)" skip with fram F1400 no-box.

              /* LABEL 1 - START */ 
              L14001 = "客户零件:" + V1200. 
              display L14001          format "x(40)" skip with fram F1400 no-box.
              /* LABEL 1 - END */ 

              /* LABEL 2 - START */ 
              L14002 = "客户:" + substring(trim(V1100),1,5) + " SO:" + substring(trim(PV1500),1,8). 
              display L14002          format "x(40)" skip with fram F1400 no-box.
              /* LABEL 2 - END */ 

              /* LABEL 3 - START */ 
              L14003 = "前条码号:"  + PV1400.
              display L14003          format "x(40)" skip with fram F1400 no-box.
              /* LABEL 3 - END */ 

              /* LABEL 4 - START */ 
              L14004 = "箱数: " + string(li_box,"ZZ9").
              display L14004          format "x(40)" skip with fram F1400 no-box.
              /* LABEL 4 - END */ 

              /* LABEL 5 - START */ 
              L14005 = " " .
              display L14005          format "x(40)" skip with fram F1400 no-box.
              /* LABEL 5 - END */ 
	      
	      /* LABEL 6 - START */ 
              L14006 = "条码号 ?" .
              display L14006          format "x(40)" skip with fram F1400 no-box.

              display "输入或按E退出"       format "x(40)" skip
                      skip with fram F1400 no-box.
/*
		    update nbr label "客户订单"
                    with frame dd side-labels overlay
	            row 3 width 80 no-attr-space.
*/

              Update V1400
              WITH  fram F1400 NO-LABEL
                 /* ROLL BAR START */
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit. 
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 APPLY LASTKEY.
              end.

	      /* PRESS e EXIST CYCLE */
              IF V1400 = "e" THEN LEAVE MAINLOOP.
              
              display skip WMESSAGE NO-LABEL with fram F1400.
              /*  ---- Valid Check ---- START */
	      if substring(V1400,9,3) <> substring(PV1400,9,3) and PV1400 > "" then do:
	         display skip "不同批次不能同集装箱!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.

              display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
              pause 0.
              /* CHECK FOR NUMBER VARIABLE START  */
	      find first xxbcd_hist where xxbcd_domain = global_domain 
	         and xxbcd_cust = trim(V1100) 
	         and xxbcd_site = trim(V1002) 
  	         and xxbcd_nbr = trim(PV1500) 
		 and xxbcd_cust_part = trim(V1200)
	         and xxbcd_serial = substring(trim(V1400),1,14) 
		 and lookup(xxbcd_stat,"A,R") > 0 use-index xxbcd_serial
                 exclusive-lock no-error.

	      if not available xxbcd_hist then do:
                 display skip "错误:小标签库存未找到!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
	         if l_shipto <> xxbcd_shipto and l_shipto > "" then do:
	            display skip "发往不同地点不能同集装箱!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.		    
		 end.

                 find first xkb_mstr where xkb_domain = global_domain
		        and xkb_type = "M" and xkb_site = xxbcd_site
			and xkb_part = xxbcd_part and xkb_cust = xxbcd_cust 
			and xkb_q1bc = xxbcd_serial no-lock no-error.
		 
		 if available xkb_mstr then do:
                    display skip "错误:请用看板56出货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.

		 find first xxbct_hist where xxbct_domain = global_domain 
                       and xxbct_site = trim(V1002) and xxbct_cust = trim(V1100)
/*  		       and xxbct_nbr = trim(PV1500)   */
	               and xxbct_cust_part = trim(V1200) 
	               and xxbct_serial = substring(trim(V1400),1,14)
                       use-index xxbct_serial no-lock no-error.

                 if not available xxbct_hist then do:
	            xxbcd_ship_date = today.
		    xxbcd_char[3] = global_userid. /*出货用户*/
                    xxbcd_dec[3] = time .          /*出货时间*/

 		    k = k + 1.
		    if k = 1 then do:
		       if last_ser <> integer(substring(trim(V1400),9,3)) then
		          count_page = 0.
		    end.

		    new_page = no.
		    qty = qty + xxbcd_qty.
		    count_box = count_box + 1.
		    l_fgloc = xxbcd_fgloc.
                    l_vend = xxbcd_vend.
                    l_shipto = xxbcd_shipto.
		    l_cust = trim(V1100).
                    l_part = part.
                    l_cust_part = trim(PV1200).
                    l_box_mult = box_mult.
		    l_um = xxbcd_um.
                    l_box_pc = count_box.
                    l_nbr = xxbcd_nbr.
                    l_yr = xxbcd_yr.
                    l_work_cn = xxbcd_work_cn.
                    l_ln = xxbcd_ln.
                    mn = substring(string(year(today)),3,4) + string(month(today),"99") 
		       + string(day(today),"99").

                    if count_box = box_mult then do: 
	               count_page = count_page + 1.
		       create xxbcm_hist.
                       assign
                          xxbcm_domain   = global_domain 
                          xxbcm_site     = V1002
                          xxbcm_fgloc    = xxbcd_fgloc   
                          xxbcm_cust     = trim(V1100)
                          xxbcm_part     = part
                          xxbcm_cust_part = PV1200
                          xxbcm_box_mult = box_mult
                          xxbcm_vend     = xxbcd_vend   /* ? */
                          xxbcm_rcode    = ""   /* ? */
                          xxbcm_fline    = ""   /* ? */
                          xxbcm_serial   = mn + substring(trim(V1400),9,3) + string(count_page,"999")
                          xxbcm_qty      = qty
                          xxbcm_um       = l_um  
                          xxbcm_box_pc   = count_box 
                          xxbcm_shipto   = xxbcd_shipto   /** 发往 **/
                          xxbcm_prt_date = today
			  xxbcm_nbr      = xxbcd_nbr
                          xxbcm_yr       = xxbcd_yr
			  xxbcm_work_cn  = xxbcd_work_cn
			  xxbcm_ln       = xxbcd_ln
                          xxbcm_userid   = global_userid
                          xxbcm_time     = time
                          xxbcm_stat     = "P" .

                       /** 开始打印大标签 **/	
/*		       
                       run prt_lbl.
*/
		       new_page = yes.
		       count_box = 0.
	               qty = 0.
		    end.

		    if new_page then page1 =  count_page.
		    else page1 = count_page + 1.

                    create xxbct_hist.
                    assign
                       xxbct_domain   = global_domain 
                       xxbct_site     = xxbcd_site
                       xxbct_fgloc    = xxbcd_fgloc 
		       xxbct_wiploc   = xxbcd_wiploc
                       xxbct_cust     = trim(V1100)
                       xxbct_part     = xxbcd_part
                       xxbct_cust_part = xxbcd_cust_part		    
                       xxbct_box_mult = xxbcd_box_mult
                       xxbct_vend     = xxbcd_vend    /* ? */
                       xxbct_rcode    = xxbcd_rcode   /* ? */
                       xxbct_fline    = xxbcd_fline   /* ? */
                       xxbct_lot      = mn + substring(V1400,9,3) +
		                           (if count_page = 0 then "001" else string(page1, "999"))
                       xxbct_serial   = xxbcd_serial
                       xxbct_qty      = xxbcd_qty
                       xxbct_um       = um1  
                       xxbct_shipto   = xxbcd_shipto       /** ? 发往  **/
                       xxbct_prt_date = today
                       xxbct_userid   = global_userid
                       xxbct_time     = time
                       xxbct_stat     = "P" 
       		       xxbct_print_ship = "no"
		       xxbct_nbr      = xxbcd_nbr
                       xxbct_yr       = xxbcd_yr
		       xxbct_work_cn  = xxbcd_work_cn
		       xxbct_ln       = xxbcd_ln.
	               new_page = no.
                       xxbcd_lot = xxbct_lot.

                    display (trim(PV1400) + "扫描成功!!") @ WMESSAGE NO-LABEL with fram F1400 no-box.
	         end.
		 else do:
                    display (trim(PV1400) + "已经扫过!") @ WMESSAGE NO-LABEL with fram F1400 no-box.
		 end.
	      end. /*else do: */

              display  "" @ WMESSAGE NO-LABEL with fram F1400.
              pause 0.
              leave V1400L.
           END.
           find first temp2 where t_serial = V1400 no-lock no-error.
           if not available temp2 then do:
              create temp2.
              t_serial = V1400.
              li_box = li_box + 1.
           end.

           PV1400 = substring(trim(V1400),1,14).
           pause 0 before-hide.
        END.     /* V1300LMAINLOOP: */

        pause 0 before-hide.
  end. /**MAINLOOP**/

  if qty <> 0 then do:
     k = k + 1.
     if k = 1 and last_ser <> integer(substring(trim(V1400),9,3)) then
     count_page = 0.
     count_page = count_page + 1. 
     l_qty = qty.
     l_site = V1002.
     mn = substring(string(year(today)),3,4) + string(month(today),"99") 
          + string(day(today),"99").

     create xxbcm_hist.
     assign
       xxbcm_domain   = global_domain
       xxbcm_site     = V1002
       xxbcm_fgloc    = l_fgloc 
       xxbcm_cust     = l_cust
       xxbcm_part     = l_part
       xxbcm_cust_part = l_cust_part
       xxbcm_box_mult = l_box_mult
       xxbcm_vend     = l_vend   /* ? */
       xxbcm_rcode    = ""       /* ? */
       xxbcm_fline    = ""       /* ? */
       xxbcm_serial   = mn + substring(PV1400,9,3) + string(count_page, "999")
       xxbcm_qty      = l_qty
       xxbcm_um       = l_um
       xxbcm_box_pc   = l_box_pc  
       xxbcm_shipto   = l_shipto  /** ? 发往  **/
       xxbcm_prt_date = today
       xxbcm_nbr      = l_nbr
       xxbcm_yr       = l_yr
       xxbcm_userid   = global_userid
       xxbcm_time     = time
       xxbcm_stat     = "P" 
       xxbcm_nbr      = l_nbr
       xxbcm_yr       = l_yr
       xxbcm_work_cn  = l_work_cn
       xxbcm_ln       = l_ln.

      /** 开始打印大标签 **/
/*
      run prt_lbl.
*/
  end.

  Procedure prt_lbl:
     INPUT FROM VALUE("/app/bc/labels/PX6i_IPL_MSTR").
     wsection = string(MONTH(TODAY)) + string(DAY(TODAY))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) . 

     output to value( trim(wsection) + "l.l") .

     repeat:
        IMPORT UNFORMATTED ts9130.
	IF INDEX(ts9130, "$part1") <> 0 THEN DO:
           custpart1 = xxbcm_hist.xxbcm_cust_part.
           custpart2 = "".

           l_indx = index(trim(custpart1)," ").
           if l_indx > 0 then assign
              custpart1 = trim(substring(xxbcm_hist.xxbcm_cust_part,1,l_indx - 1))
              custpart2 = trim(substring(xxbcm_hist.xxbcm_cust_part,l_indx)).

           l_indx = index(trim(custpart2)," ").
           if l_indx > 0 then assign
           custpart1 = custpart1 + " " + trim(substring(custpart2,1,l_indx))
           custpart2 = trim(substring(custpart2,l_indx)) .

           av9130 = custpart1. 
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$part1") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$part1") 
		     + length("$part1"), LENGTH(ts9130) - ( index(ts9130 , "$part1") + length("$part1") - 1 ) ).
	END.

        av9130 = string(xxbcm_hist.xxbcm_box_pc, "zzz9").
        if INDEX(ts9130, "$qty") <> 0 THEN DO:
	   TS9130 = substring(TS9130, 1, Index(TS9130 , "$qty") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$qty") 
		     + length("$qty"), LENGTH(ts9130) - ( index(ts9130 , "$qty") + length("$qty") - 1 ) ).
	END.

        if INDEX(ts9130, "$um") <> 0 THEN DO:
           av9130 = "PC".
	   TS9130 = substring(TS9130, 1, Index(TS9130 , "$um") - 1) + av9130 
                    + SUBSTRING( ts9130 , index(ts9130 ,"$um") 
		    + length("$um"), LENGTH(ts9130) - ( index(ts9130 , "$um") + length("$um") - 1 ) ).
	END.

        if INDEX(ts9130, "$part2") <> 0 THEN DO:
           av9130 = custpart2. 
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$part2") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$part2") 
		     + length("$part2"), LENGTH(ts9130) - ( index(ts9130 , "$part2") + length("$part2") - 1 ) ).

	END.

        if INDEX(ts9130, "$supp") <> 0 THEN DO:
           av9130 = xxbcm_hist.xxbcm_vend.
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$supp") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$supp") 
		     + length("$supp"), LENGTH(ts9130) - ( index(ts9130 , "$supp") + length("$supp") - 1 ) ).
	END.

        if INDEX(ts9130, "$rcode") <> 0 THEN DO:
           av9130 = xxbcm_hist.xxbcm_rcode.
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$rcode") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$rcode") 
		     + length("$rcode"), LENGTH(ts9130) - ( index(ts9130 , "$rcode") + length("$rcode") - 1 ) ).
	END.

        if INDEX(ts9130, "$line") <> 0 THEN DO:
	   av9130 = xxbcm_hist.xxbcm_fline.
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$line") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$line") 
		     + length("$line"), LENGTH(ts9130) - ( index(ts9130 , "$line") + length("$line") - 1 ) ).
	END.

        if INDEX(ts9130, "$serial") <> 0 THEN DO:
           av9130 = xxbcm_hist.xxbcm_serial.
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$serial") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$serial") 
		     + length("$serial"), LENGTH(ts9130) - ( index(ts9130 , "$serial") + length("$serial") - 1 ) ).
	END.

        if INDEX(ts9130, "$ship") <> 0 THEN DO:
           av9130 = xxbcm_hist.xxbcm_shipto.
           TS9130 = substring(TS9130, 1, Index(TS9130 , "$ship") - 1) + av9130 
                     + SUBSTRING( ts9130 , index(ts9130 ,"$ship") 
		     + length("$ship"), LENGTH(ts9130) - ( index(ts9130 , "$ship") + length("$ship") - 1 ) ).
	END.

        put unformatted ts9130 skip.
     END.

     INPUT CLOSE.
     OUTPUT CLOSE.

     output to value("prt1.prn") .
     unix silent value ("chmod 777  " + trim(wsection) + "l.l").

     find first prd_det where prd_dev = "bcb" no-lock no-error.
     IF AVAILABLE prd_det then do:
        unix silent value (trim(prd_path) + " " + trim(wsection) + "l.l").
     end.
     OUTPUT CLOSE.
  end.
