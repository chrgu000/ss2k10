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
define variable count_box as integer no-undo.
define variable count_page as integer no-undo.
define variable usection as char format "x(16)".
define variable last_ser like xxbcm_serial.
define variable model_yr like scx_modelyr.
define variable nbr like scx_order.
define variable qty like xxbcd_qty.
define variable qty_oh like in_qty_oh.
define variable V1002 like si_site.
define variable box_mult as integer.
define variable new_page as logical.
define variable page1 as integer.
define variable serial as integer.
define variable li_box as integer format "ZZ9".

define variable wtimeout as integer init 99999 .
define temp-table temp2 
       field t_serial like xxbcd_serial.

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[WIP转FG仓]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).

  mainloop:
  REPEAT:   

   {xsdfsite.i}      
   V1002 = wDefSite. 
   /*  V1002 = global_domain.

     if global_domain = "01" then
        V1002 = "01".

     if global_domain = "99" then
        V1002 = "99".
  */
    
/*********************************comment start *******************************
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
        IF V1100 = "e" THEN leave mainloop.
	
        display  skip WMESSAGE NO-LABEL with fram F1100.

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.

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
/*debug
	if trim(V1100) begins "010017" then do:
           display skip "错误:福特客户不允许." @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.	   
	end.
debug*/

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
        /* --DEFINE VARIABLE -- END */

        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1200 = "".
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

  	display dmdesc format "x(40)" skip with fram F1200 no-box.

        /* LABEL 1 - START */ 
        L12001 = "客户订单 ?". 
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
           IF trim(V1200) = "e" THEN LEAVE MAINLOOP.

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
*********************************comment end *******************************/

	/* START  LINE :1400  客户  */
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
           define variable L14007          as char format "x(1)" initial "0".
           if global_domain = "01" then L14007 = "0".
           if global_domain = "99" then L14007 = "1".

           /* --CYCLE TIME DEFAULT  VALUE -- START  */ 
           V1400 = "".
           /* --CYCLE TIME DEFAULT  VALUE -- END  */

	   display dmdesc format "x(40)" skip with fram F1400 no-box.

           /* LABEL 1 - START */ 
           L14001 = "转入库位 ?" . 
           display L14001          format "x(40)" skip with fram F1400 no-box.

           /* LABEL 2 - START */ 
           L14002 = " ".
           display L14002          format "x(40)" skip with fram F1400 no-box.
           /* LABEL 2 - END */ 

           /* LABEL 3 - START */ 
           L14003 = " ". 
           display L14003          format "x(40)" skip with fram F1400 no-box.
           /* LABEL 3 - END */ 

           /* LABEL 4 - START */ 
           L14004 = " ". 
           display L14004          format "x(40)" skip with fram F1400 no-box.
           /* LABEL 4 - END */ 

           /* LABEL 5 - START */ 
           L14005 = "" . 
           display L14005          format "x(40)" skip with fram F1400 no-box.
           /* LABEL 4 - END */ 

           /* LABEL 6 - START */ 
           L14006 = "" . 
           display L14006          format "x(40)" skip with fram F1400 no-box.

           display "输入或按E退出"       format "x(40)" skip
              skip with fram F1400 no-box.

           Update V1400
           WITH  fram F1400 NO-LABEL
           EDITING:
              readkey pause wtimeout.
              if lastkey = -1 then quit.
              if LASTKEY = 404 Then Do: /* DISABLE F4 */
                 pause 0 before-hide.
                 undo, retry.
              end.
              display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
              IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
              THEN DO:
                 IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where loc_domain = global_domain and
                    LOC_SITE = V1002 AND LOC_LOC >=  INPUT V1400 AND (loc_loc BEGINS L14007) no-lock no-error.
                  ELSE find next LOC_MSTR where loc_domain = global_domain and LOC_SITE = V1002 AND (loc_loc BEGINS L14007) no-lock no-error.
                  IF AVAILABLE LOC_MSTR then
		     display skip LOC_LOC @ V1400 
		        LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else display skip "" @ WMESSAGE with fram F1400.
              END.
              IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
              THEN DO:
                 IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR 
		    where loc_domain = global_domain and LOC_SITE = V1002 AND  
                          LOC_LOC <=  INPUT V1400 AND (loc_loc BEGINS L14007) no-lock no-error.
                  ELSE find prev LOC_MSTR where loc_domain = global_domain and LOC_SITE = V1002 AND (loc_loc BEGINS L14007) no-lock no-error.
                  IF AVAILABLE LOC_MSTR then
		     display skip 
                         LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
              END.
              APPLY LASTKEY.
           END.
           /* ROLL BAR END */

              /* PRESS e EXIST CYCLE */
              IF V1400 = "e" THEN leave mainloop.
	
              display skip WMESSAGE NO-LABEL with fram F1400.

              /*  ---- Valid Check ---- START */

              display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
              pause 0.
              find first LOC_MSTR where loc_domain = global_domain and LOC_LOC = V1400 AND LOC_SITE = V1002 no-lock no-error.
              IF NOT AVAILABLE LOC_MSTR then do:
                 display skip "错误: 库位不存在" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
              end.
              IF not trim(V1400) <> "" THEN DO:
                 display skip "错误:不允许空." @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
              end.
	       if not (trim(V1400) begins L14007) then do:
                 display skip "错误:库位仅FG仓,请重输！" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	       end.

             display  "" @ WMESSAGE NO-LABEL with fram F1400.
             pause 0.
             leave V1400L.
          END.
          PV1400 = V1400.
          /* END 1400   */

        /* Internal Cycle Input :1500    */  
        V1500LMAINLOOP:
        REPEAT:
           /* START  LINE :1400  条码号]  */
           V1500L:
           REPEAT:	   

              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1500           as char format "x(50)".
              define variable PV1500          as char format "x(50)".
              define variable L15001          as char format "x(40)".
              define variable L15002          as char format "x(12)".
              define variable L15003          as char format "x(40)".
              define variable L15004          as char format "x(40)".
              define variable L15005          as char format "x(40)".
              define variable L15006          as char format "x(40)".

              /* --DEFINE VARIABLE -- END */

              V1500 = "".
	      display dmdesc format "x(40)" skip with fram F1500 no-box.

              /* LABEL 1 - START */ 
              L15001 = "转入库位: " + V1400.
              display L15001          format "x(40)" skip with fram F1500 no-box.
              /* LABEL 1 - END */ 	     

              /* LABEL 2 - START */ 
              L15002 = "前条码号: " + substring(PV1500,1,11).
              display L15002          format "x(40)" skip with fram F1500 no-box.

              /* LABEL 3 - START */ 
              L15003 = "          " + substring(PV1500,12,6).
              display L15003          format "x(40)" skip with fram F1500 no-box.

	      /* LABEL 4 - START */ 
              L15004 = "箱数:" + string(li_box, "ZZ9").
              display L15004          format "x(40)" skip with fram F1500 no-box.
              /* LABEL 4 - END */ 

	      /* LABEL 5 - START */ 
              L15005 = "条码号 ?" .              /* LABEL 4 - START */ 
              display L15005          format "x(40)" skip with fram F1500 no-box.
              /* LABEL 5 - END */ 

              /* LABEL 6 - START */ 
              L15006 = " ".
              display L15006          format "x(40)" skip with fram F1500 no-box.
              /* LABEL 6 - END */ 

              display "输入或按E退出"       format "x(40)" skip
                      skip with fram F1500 no-box.

              Update V1500
              WITH  fram F1500 NO-LABEL
                 /* ROLL BAR START */
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit.
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 apply lastkey.
              end.
              /* PRESS e EXIST CYCLE */
              IF V1500 = "e" THEN LEAVE mainloop.
              
              display skip WMESSAGE NO-LABEL with fram F1500.
              /*  ---- Valid Check ---- START */

              display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
              pause 0.
              /* CHECK FOR NUMBER VARIABLE START  */

	      find first xxbcd_hist where xxbcd_domain = global_domain 
	         and xxbcd_site = trim(V1002) 
	         and xxbcd_serial = substring(trim(V1500),1,17) exclusive-lock no-error.

	      if not available xxbcd_hist then do:
                 display skip "错误:小标签未找到!" @ WMESSAGE NO-LABEL with fram F1500.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
                 find first xkb_mstr where xkb_domain = global_domain
		        and xkb_type = "M" and xkb_site = trim(V1002)
			and xkb_part = xxbcd_part
			and xkb_q1bc = xxbcd_serial no-lock no-error.
		 if available xkb_mstr then do:
                    display skip "错误:请用看板46转仓!" @ WMESSAGE NO-LABEL with fram F1500.
                    pause 0 before-hide.
                    undo, retry.
		 end.

		assign xxbcd_fgloc = trim(V1400)
	               xxbcd_trans = Yes
/*		       xxbcd_prt_date = today */ .
              end.

	   /* CHECK FOR NUMBER VARIABLE  END */
           /*  ---- Valid Check ---- END */

           display  "" @ WMESSAGE NO-LABEL with fram F1500.
           pause 0.
           leave V1500L.
        END.
        find first temp2 where t_serial = V1500 no-lock no-error.
        if not available temp2 then do:
           create temp2.
           t_serial = V1500.
           li_box = li_box + 1.
        end.
        PV1500 = substring(trim(V1500),1,17).
        pause 0 before-hide.       
     END.     /* V1300LMAINLOOP: */
     pause 0 before-hide.
  end. /**mainloop**/
