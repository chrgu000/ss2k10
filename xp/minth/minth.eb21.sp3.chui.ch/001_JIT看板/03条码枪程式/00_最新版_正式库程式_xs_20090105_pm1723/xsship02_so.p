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
define variable wsection as char format "x(16)".
define variable i as integer .
define variable dmdesc like dom_name.
define variable usection as char format "x(16)".
define variable model_yr like scx_modelyr no-undo.
define variable nbr like scx_order no-undo.
define variable V1002 like si_site.
define variable um1 like pt_um.
define variable li_box as integer format "ZZ9".

define variable wtimeout as integer init 99999 .
define temp-table temp2 
       field t_serial like xxbcd_serial.

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.

dmdesc = "[公司内部FG:发自]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


  MAINLOOP:
  REPEAT:   

/*   {xsdfsite.i}      */
/*   V1002 = wDefSite. */
     if global_domain = "01" then V1002 = "01".
     if global_domain = "99" then V1002 = "99".

/************************* comment start *****************************
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
        if trim(V1100) begins "010017" then do:
           display skip "错误:此功能不能发福特." @ WMESSAGE NO-LABEL with fram F1100.
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

     /* START V1200 客户订单：? */
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
        L12001 = "零件订单 ?". 
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
                 IF recid(scx_ref) = ? THEN 
	            find first scx where scx_ref.scx_domain = global_domain 
                       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100)
		       and scx_order >= V1200 no-lock no-error.
                 ELSE find next scx_ref where scx_ref.scx_domain = global_domain 
		       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100) no-lock no-error.

                 IF AVAILABLE scx_ref then
	            display skip 
		        scx_order @ V1200 with fram F1200.
                 else display skip "" @ WMESSAGE with fram F1200.
              END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(scx_ref) = ? THEN 
	            find first scx where scx_ref.scx_domain = global_domain 
                       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100)
		       and scx_order <= V1200 no-lock no-error.
              ELSE find prev scx_ref where scx_ref.scx_domain = global_domain 
		       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100) no-lock no-error.

              IF AVAILABLE scx_ref then 
	         display skip 
 	            scx_order @ V1200 with fram F1200.
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


     /* START V1200 客户订单项：? */
     V1300L:
     REPEAT:
        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(9)".
        define variable PV1300          as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".

        /* --DEFINE VARIABLE -- END */

        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = "".
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

  	display dmdesc format "x(40)" skip with fram F1300 no-box.

        /* LABEL 1 - START */ 
        L13001 = "项: ?". 
        display L13001          format "x(40)" skip with fram F1300 no-box.
        /* LABEL 1 - END */ 

        L13002 = "客户订单:" + V1200. 
        display L13002          format "x(40)" skip with fram F1300 no-box.
        /* LABEL 2 - END */ 

        /* LABEL 3 - START */ 
        L13003 = "客户: " + V1100. 
        display L13003          format "x(40)" skip with fram F1300 no-box.
        /* LABEL 3 - END */ 

        /* LABEL 4 - START */ 
        L13004 = "" . 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        /* LABEL 4 - END */ 

        /* LABEL 5 - START */ 
        L13005 = "". 
        display L13005          format "x(40)" skip with fram F1300 no-box.

        /* LABEL 6 - START */ 
        L13006 = "". 
        display L13006          format "x(40)" skip with fram F1300 no-box.

        display "输入或E退出"       format "x(40)" skip
                skip with fram F1300 no-box.

        Update V1300
        WITH fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
              readkey pause wtimeout.
              if lastkey = -1 then quit.
              if LASTKEY = 404 Then Do: /* DISABLE F4 */
                 pause 0 before-hide.
                 undo, retry.
              end.
              display skip "^" @ WMESSAGE NO-LABEL with fram F1300.

  	      IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
              THEN DO:
                 IF recid(scx_ref) = ? THEN 
	            find first scx where scx_ref.scx_domain = global_domain 
                       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100)
		       and scx_order  = V1200 and scx_line >= integer(V1300) no-lock no-error.
                 ELSE find next scx_ref where scx_ref.scx_domain = global_domain 
		       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100) and scx_order = V1200 no-lock no-error.

              IF AVAILABLE scx_ref then
	         display skip 
		     scx_line @ V1300 with fram F1300.
              else display skip "" @ WMESSAGE with fram F1300.
           END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(scx_ref) = ? THEN 
	         find first scx where scx_ref.scx_domain = global_domain 
                       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100)
		       and scx_order = V1200 and scx_line <= integer(V1300) no-lock no-error.
              ELSE find prev scx_ref where scx_ref.scx_domain = global_domain 
		       and scx_type = 1 and scx_shipfrom = trim(V1002)
	               and scx_shipto = trim(V1100) and scx_order = V1200 no-lock no-error.

              IF AVAILABLE scx_ref then 
	         display skip 
 	            scx_line @ V1300 with fram F1300.
              else display skip "" @ WMESSAGE with fram F1300.
           END.

	      APPLY LASTKEY.
           END.
           /* ROLL BAR END */

           /* PRESS e EXIST CYCLE */
           IF trim(V1300) = "E" THEN LEAVE MAINLOOP.

           display skip WMESSAGE NO-LABEL with fram F1300.

           /*  ---- Valid Check ---- START */

           display "...处理...  " @ WMESSAGE NO-LABEL with fram F1300.
           pause 0.

	   find first xxbcd_hist where xxbcd_domain = global_domain AND xxbcd_cust = trim(V1100)
	      AND xxbcd_nbr = trim(V1200) and xxbcd_ln = integer(V1300) no-lock no-error.	   
           IF NOT AVAILABLE xxbcd_hist then do:
              display skip "错误,没有小箱标签." @ WMESSAGE NO-LABEL with fram F1300.
              pause 0 before-hide.
              undo, retry.
           end.

           /*  ---- Valid Check ---- END */

           display  "" @ WMESSAGE NO-LABEL with fram F1300.
           pause 0.
           leave V1300L.
        END.
        PV1300 = V1300.	
************************* comment end *****************************/
	
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

        L15001 = "客户订单 ?". 
        display L15001          format "x(40)" skip with fram F1500 no-box.

        L15002 = "". 
        display L15002          format "x(40)" skip with fram F1500 no-box.

        L15003 = " " .
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
		     AND scx_order >=  INPUT V1500 no-lock no-error.
              ELSE find next scx_ref where scx_domain = global_domain no-lock no-error.

              IF AVAILABLE scx_ref then
	         display skip 
		     scx_order @ V1500 with fram F1500.
              else display skip "" @ WMESSAGE with fram F1500.
           END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(scx_ref) = ? THEN 
	         find first scx_ref where scx_domain = global_domain 
		    AND scx_order <=  INPUT V1500 no-lock no-error.
              ELSE find prev scx_ref where scx_domain = global_domain no-lock no-error.
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
	       and scx_order = V1500 no-lock no-error.
        
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

	      L14001 = "客户订单:" + substring(trim(PV1500),1,8).
              display L14001          format "x(40)" skip with fram F1400 no-box.

              L14002 = "前条码号:"  + substring(trim(PV1400),1,11).
              display L14002          format "x(40)" skip with fram F1400 no-box.

	      L14003 = "         " + substring(trim(PV1400),12,6). 
              display L14003          format "x(40)" skip with fram F1400 no-box.

              L14004 = "箱数：" + string(li_box,"ZZ9") .
              display L14004          format "x(40)" skip with fram F1400 no-box.

	      L14005 = "条码号 ?" .
              display L14005          format "x(40)" skip with fram F1400 no-box.

	      L14006 = " " .
              display L14006          format "x(40)" skip with fram F1400 no-box.

              display "输入或按E退出"       format "x(40)" skip
                      skip with fram F1400 no-box.

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
/*
	      if substring(V1400,1,4) <> substring(PV1400,1,4) and PV1400 > "" then do:
	         display skip "不同批次不能同集装箱!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
*/
              display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
              pause 0.
              
	      /* CHECK FOR NUMBER VARIABLE START  */
	      find first xxbcd_hist where xxbcd_domain = global_domain 
	         and xxbcd_site = trim(V1002) 
		 and xxbcd_nbr = substring(trim(PV1500),1,8)
	         and xxbcd_serial = substring(trim(V1400),1,17)
  		 and lookup(xxbcd_stat,"R") > 0 exclusive-lock no-error.

	      if not available xxbcd_hist then do:
                 display skip "错误:小标签未找到!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
                 find first xkb_mstr where xkb_domain = global_domain
		        and xkb_type = "M" and xkb_site = xxbcd_site
			and xkb_part = xxbcd_part and xkb_cust = xxbcd_cust 
			and xkb_q1bc = xxbcd_serial no-lock no-error.
		 if available xkb_mstr then do:
                    display skip "错误:请用看板57出货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.

 		 find first xxbct_hist where xxbct_domain = global_domain 
                        and xxbct_site = xxbcd_site 
                        and xxbct_cust = xxbcd_cust
			and xxbct_nbr = xxbcd_nbr
	                and xxbct_serial = substring(trim(V1400),1,17) no-lock no-error.

                 if not available xxbct_hist then do:
 	            find first pt_mstr where pt_domain = global_domain 
		       and pt_part = xxbcd_part no-lock no-error.
	            um1 = (if available pt_mstr then pt_um else "").

		    xxbcd_ship_date = today.
		    xxbcd_char[3] = global_userid. /*出货用户*/
                    xxbcd_dec[3] = time .          /*出货时间*/
                    xxbcd_stat = "R".

                    create xxbct_hist.
                    assign
                       xxbct_domain   = global_domain 
                       xxbct_site     = xxbcd_site
                       xxbct_fgloc    = xxbcd_fgloc 
		       xxbct_wiploc   = xxbcd_wiploc
                       xxbct_cust     = xxbcd_cust
                       xxbct_part     = xxbcd_part
                       xxbct_cust_part = xxbcd_cust_part		    
                       xxbct_box_mult = xxbcd_box_mult
                       xxbct_vend     = xxbcd_vend    /* ? */
                       xxbct_rcode    = xxbcd_rcode   /* ? */
                       xxbct_fline    = xxbcd_fline   /* ? */
                       xxbct_lot      = " "  /* substring(V1400,1,4) +
		                           (if count_page = 0 then "00001" else string(page1, "99999")) */
                       xxbct_serial   = substring(trim(V1400),1,17)
                       xxbct_qty      = xxbcd_qty
                       xxbct_um       = um1  
                       xxbct_shipto   = xxbcd_shipto       /** ? 发往  **/
                       xxbct_prt_date = today
                       xxbct_userid   = global_userid
                       xxbct_time     = time
                       xxbct_stat     = "P" 
		       xxbct_print_ship = "no"
		       xxbct_nbr      = xxbcd_nbr
		       xxbct_ln       = xxbcd_ln
		       xxbct_work_cn  = xxbcd_work_cn
                       xxbct_yr       = xxbcd_yr.

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
           PV1400 = substring(trim(V1400),1,17).
           pause 0 before-hide.
        END.     /* V1300LMAINLOOP: */

        pause 0 before-hide.
  end. /**MAINLOOP**/
