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
define variable qty like xxbcd_qty.
define variable qty_oh like in_qty_oh.
define variable V1002 like si_site.
define variable box_mult as integer.
define variable new_page as logical.
define variable page1 as integer.
define variable serial as integer.
define variable li_box as integer format "ZZ9".
define variable nbr as char format "x(8)" label "客户定单".
define variable ln as integer format ">9" label "项".
define variable l_ship_to like ad_addr no-undo.
define variable l_ship_id like xxbcm_id no-undo. 
define variable kb_id like xkb_kb_id no-undo.
define variable p_qty like xkb_kb_qty label "数量" no-undo.
define variable qty_firm as logical no-undo.
define variable tot_qty like xxbcd_qty no-undo.
define variable um1 like pt_um no-undo.
define variable modelyr as char format "x(4)" no-undo.
define variable outfile as char format "x(40)"  no-undo.
define variable outfile1 as char format "x(40)"  no-undo.
define variable quote as char initial '"' no-undo.
define variable cust_po as char.
define variable custref as char.
define variable locdesc as char no-undo.

         define variable xkbpart1     like xkb_part no-undo.
         define variable xkbtype1     like xkb_type no-undo.
         define variable xkbid1       like xkb_kb_id no-undo.

define temp-table temp1 
       field t1_nbr like so_nbr
       field t1_ln like sod_line
       field t1_part like pt_part
       field t1_kb_qty like xkb_kb_qty
       field t1_loc like xkb_loc
       field t1_lot like xkb_lot
       field t1_modelyr as char format "x(4)"
       field t1_cust as char format "x(8)"
       field t1_bc as char format "x(28)".

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[生成货运单]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).

  mainloop:
  REPEAT:   

/*   {xsdfsite.i}      */
/*   V1002 = wDefSite. */
     V1002 = global_domain.

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

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.


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

        L15002 = "客户:" + V1100. 
        display L15002          format "x(40)" skip with fram F1500 no-box.

        L15003 = " ".
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
		    and scx_shipto = V1100 AND scx_order >= INPUT V1500 no-lock no-error.
              ELSE find next scx_ref where scx_domain = global_domain and scx_shipto = V1100 no-lock no-error.

              IF AVAILABLE scx_ref then
	         display skip 
		     scx_order @ V1500 with fram F1500.
              else display skip "" @ WMESSAGE with fram F1500.
           END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(scx_ref) = ? THEN 
	         find first scx_ref where scx_domain = global_domain and scx_shipto = V1100
		    AND scx_order <= INPUT V1500 no-lock no-error.
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


	/* Internal Cycle Input :1300    */  
        V1300LMAINLOOP:
        REPEAT:
           /* START  LINE :1400  条码号]  */
           V1400L:
           REPEAT:	   

              /* --DEFINE VARIABLE -- START */
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

              L14001 = "客户:" + V1100. 
              display L14001          format "x(40)" skip with fram F1400 no-box.

              L14002 = "客户订单:" + trim(PV1500). 
              display L14002          format "x(40)" skip with fram F1400 no-box.

	      L14003 = "条码:" + string(PV1400).
              display L14003  format "x(40)" skip with fram F1400 no-box.

	      L14004 = "张数: " + string(li_box) .
              display L14004          format "x(40)" skip with fram F1400 no-box.

	      L14005 = "条码号 ?" . 
              display L14005          format "x(40)" skip with fram F1400 no-box.

	      L14006 = "" . 
              display L14006          format "x(40)" skip with fram F1400 no-box.

              display "输入或按E退出,C取消"       format "x(40)" skip
                      skip with fram F1400 no-box.

              Update V1400
              WITH  fram F1400 NO-LABEL.

	      /* PRESS e EXIST CYCLE */
              IF V1400 = "e" or V1400 = "c" THEN LEAVE mainloop.

              display skip WMESSAGE NO-LABEL with fram F1400.
              /*  ---- Valid Check ---- START */

              display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
              pause 0.
              /* CHECK FOR NUMBER VARIABLE START  */
/*mage add 08/08/06***************************************************************************************/
	       xkbtype1 = substring(trim(V1400),1,1).
	       if length(trim(V1400)) >= 19 and xkbtype1 = "M" then assign  xkbpart1 = substring(trim(V1400), 2, length(trim(V1400)) - 4)
	                                          xkbid1   = integer(substring(trim(V1400), length(trim(V1400)) - 2,3)) .
                                     else assign  xkbpart1 = ""
				                  xkbid1   = 0.

               find first xkb_mstr where xkb_domain = global_domain
		      and xkb_site = global_domain
		      and xkb_part = xkbpart1
		      and (xkb_type = "M" or xkb_type = "P")
		      and xkb_kb_id   = xkbid1
 		      no-lock no-error.
/*mage add 08/08/06***************************************************************************************/
		      
/*mage del 08/08/06**************************************************************************************
              find first xkb_mstr where xkb_domain = global_domain and xkb_type = "M"
                and (xkb_type + xkb_part + string(xkb_kb_id, "999")) = trim(V1400) no-lock no-error.
mage del 08/08/06***************************************************************************************/
	      if not available xkb_mstr then do:
                 display skip "错误:制造看板条码不存在!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
	         if xkb_status <> "U" then do:
                    display skip "错误:看板条码不是U状态!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.
		
		 if xkb_cust <> V1100 then do:
                    display skip "错误:看板与出货客户不同!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.
		 if xkb_cust begins "010017" then do:
                    display skip "错误:铭仕订单不可在这出货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.

	         find first xxbcd_hist where xxbcd_domain = global_domain 
	            and xxbcd_site = xkb_site
		    and xxbcd_nbr = trim(PV1500)
	            and xxbcd_serial = xkb_q1bc
  		    and lookup(xxbcd_stat,"R") > 0 no-lock no-error.

	         if not available xxbcd_hist then do:
                    display skip "错误:Q1小标签未找到,请24出货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
	         end.

                 find first loc_mstr where loc_domain = global_domain
		        and loc_loc = xxbcd_fgloc no-lock no-error.
	         locdesc = (if available loc_mstr then loc_desc else "").

		 if index(locdesc, "成品仓") = 0 then do:
	            display skip "不是成品仓,不能出货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.		    
		 end.

	         p_qty = xkb_mstr.xkb_kb_raim_qty.
                 nbr = xxbcd_nbr.
	         ln = xxbcd_ln.
		 modelyr = string(xxbcd_yr, "9999").

/*
                 find last scx_ref where scx_domain = global_domain
                        and scx_shipto = V1100 and scx_type = 1
		        and scx_part = xkb_part
                        and scx_modelyr = string(V1200) no-lock no-error.
  
                 nbr = (if available scx_ref then scx_order else "").
	         ln = (if available scx_ref then scx_line else 0).

		 if ln = 0 then do:
                    display skip "无效的客户定单项存在!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.


                 find first xmpt_mstr where xmpt_domain = global_domain
		    and xmpt_part = xkb_part no-lock no-error.

	         qty_firm = (if available xmpt_mstr then xmpt_qty_firm else no).

		 if xkb_mstr.xkb_kb_id = 000 or xkb_mstr.xkb_kb_id = 999 or qty_firm then do:
                    update p_qty label "数量"
                    with frame bb side-labels overlay
	            row 3 width 80 no-attr-space.
		 end.		 
*/

		 find first ld_det where ld_domain = global_domain
		    and ld_site = xkb_site and ld_loc = xkb_loc  and ld_part = xkb_part
		    and ld_lot = xkb_q1bc and ld_qty_oh >= p_qty no-lock no-error.
		 
		 if not available ld_det then do:
                    display skip "错误：批次库存不够数量!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.		 
		 end.
	      end.

              display  "" @ WMESSAGE NO-LABEL with fram F1400.
              pause 0.
              leave V1400L.
        END.
        
	find first temp1 where t1_bc = V1400
	   and t1_modelyr = modelyr
           and t1_cust = V1100 no-lock no-error.
        if not available temp1 then do:
           create temp1.
	   t1_nbr = nbr.
	   t1_ln = ln.
	   t1_kb_qty = p_qty.
	   t1_part = xkb_mstr.xkb_part.
           t1_loc = xkb_mstr.xkb_loc.
           t1_lot = xkb_mstr.xkb_q1bc.
           t1_modelyr = modelyr.
           t1_cust = V1100.
           t1_bc = V1400.
           li_box = li_box + 1.
        end.

        PV1400 = trim(V1400).
        pause 0 before-hide.       
     END.     /* V1300LMAINLOOP: */
     pause 0 before-hide.
  end. /**mainloop**/

if V1400 = "e" then do:
  if can-find(first temp1) then do:  
     outfile = "/app/bc/tmp/shp" + substring(string(today),1,2) + substring(string(today),4,2)
                      + substring(string(today),7,2) + "_" + substring(string(time,"HH:MM"),1,2)
	              + ":" + substring(string(time,"HH:MM"),4,2) + ".prn".	       

     OUTPUT TO VALUE(outfile).

     for each temp1 no-lock
     break by t1_cust by t1_nbr by t1_ln by t1_loc:
        if first-of(t1_loc) then tot_qty = 0.

     	if first(t1_cust) then 
           put unformatted 
	       quote global_domain quote space
	       "S"   space
	       "-"   space
               quote t1_cust quote space
	       "-"               space skip
	       "-"               space 
	       "N"               space 
	       "-"               space
	       "-"               space 
 	       "-"               space 
	       "-"               space 
	       "-"               space 
	       "01"              space 
               "us"              space
	       "N"               space 
	       "N"               space skip.

        tot_qty = tot_qty + t1_kb_qty.

	if last-of(t1_loc) then do:
           find last sod_det where sod_domain = global_domain 
	      and sod_nbr = t1_nbr and t1_ln = sod_line
	      and ( (sod_start_eff[1] <= today
	      and    sod_end_eff[1] >= today)
	       or   (sod_start_eff[1] <= today and sod_end_eff[1] = ?) )
	      no-lock no-error.

           cust_po = (if available sod_det then sod_contr_id else "").
           custref = (if available sod_det then sod_custref else "").

	   put unformatted
	       skip(1)
	       skip(1)
	       "1"                    space skip     
               quote t1_part    quote space
               quote cust_po    quote space
               quote custref    quote space
	       quote t1_modelyr quote space
               quote t1_nbr     quote space
	       quote t1_ln      quote space skip.
/*
           find last sod_det where sod_domain = global_domain 
	      and sod_nbr = t1_nbr and t1_ln = sod_line no-lock no-error.
	   if available sod_det then do:
	      if sod_dock > "" then 
	         put unformatted "Y" skip.
	   end.
*/
	   put unformatted
               quote tot_qty    quote space
	       "-"                  space
	       "-"                  space
	       "-"                  space
               "-"                  space
               "-"                  space
	       "-"                  space
	       "-"                  space
               quote global_domain quote space
               quote t1_loc quote   space
               quote t1_lot quote   space
               "-"                  space
               "N"                  space 
	       "N"                  space skip
	       "N"                  space
	       "N"                  space skip. 
        end.
     end.

     put unformatted
         "."                  skip
         "-"                  space
         "N"                  space skip
         "." . 
     OUTPUT CLOSE.

     /** 数据开始更新处理 **/
     DO TRANSACTION ON ERROR UNDO,RETRY:
        batchrun = YES.
	outfile1  = outfile + ".o".
        l_ship_id = "".
	l_ship_to = "".

        INPUT FROM VALUE(outfile).
        output to  value (outfile1) .
        
	run /app/mfgpro/eb21/ch/xx/xxrcshwb99.r(input l_ship_to, input-output l_ship_id).
        
	for each temp1 no-lock:
/*mage add 08/08/06***************************************************************************************/
 	       if length(t1_bc) >= 19 then assign  xkbpart1 = substring(t1_bc, 2, length(t1_bc) - 4)
	                                          xkbid1   = integer(substring(t1_bc, length(t1_bc) - 2,3)) .
                                     else assign  xkbpart1 = ""
				                  xkbid1   = 0.

               find first xkb_mstr where xkb_domain = global_domain
	              and xkb_site = global_domain
		      and xkb_part = xkbpart1
		      and (xkb_type = "M"  or xkb_type = "P")
		      and xkb_kb_id   = xkbid1
 		       no-error.
/*mage add 08/08/06**************************************************************************************/
/*mage del 08/08/06***************************************************************************************

	   find first xkb_mstr where xkb_domain = global_domain and xkb_type = "M"
	      and (xkb_type + xkb_part + string(xkb_kb_id, "999")) = t1_bc no-error.
 *mage del 08/08/06***************************************************************************************/
	   if available xkb_mstr then do:
	      assign
	         xkb_nbr  = t1_nbr
	         xkb_line = t1_ln
/*	         xkb_vend = t1_cust */
	         xkb_shp_nbr = l_ship_id.
/*	         xkb_kb_raim_qty = xkb_kb_raim_qty - t1_kb_qty. */

              if xkb_kb_id = 999 or xkb_kb_id = 000 then
                 xkb_fldusr[1] = string(t1_kb_qty).

              /* CHECK FOR NUMBER VARIABLE START  */
	      find first xxbcd_hist where xxbcd_domain = global_domain 
	         and xxbcd_site = xkb_site 
		 and xxbcd_nbr = t1_nbr
	         and xxbcd_serial = xkb_q1bc
  		 and lookup(xxbcd_stat,"R") > 0 exclusive-lock no-error.

	      if available xxbcd_hist then do:
	         assign
		    xxbcd_ship_date = today
		    xxbcd_char[3] = global_userid  /*出货用户*/
                    xxbcd_dec[3] = time            /*出货时间*/
                    xxbcd_stat = "R".

		 find first xxbct_hist where xxbct_domain = global_domain 
                        and xxbct_site = xxbcd_site 
			and xxbct_nbr = t1_nbr
	                and xxbct_serial = xxbcd_serial no-lock no-error.

                 if not available xxbct_hist then do:
 	            find first pt_mstr where pt_domain = global_domain 
		       and pt_part = xxbcd_part no-lock no-error.
	            um1 = (if available pt_mstr then pt_um else "").

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
		       xxbct_ln       = xxbcd_ln
		       xxbct_work_cn  = xxbcd_work_cn
                       xxbct_yr       = xxbcd_yr.
	         end.
	      end. 
	   end.
	end.

	INPUT CLOSE.
        output close.
     END.  /** do transaction ***/
     
     display "货运单号:" + l_ship_id format "x(26)"
     with frame dd no-label overlay
     row 3 width 80 no-attr-space.
     pause.

     run write_error_to_log(input outfile,input outfile1) . 
end.
end.
  PROCEDURE write_error_to_log:
     DEFINE INPUT PARAMETER file_name AS CHAR .
     DEFINE INPUT PARAMETER file_name_o AS CHAR .
     DEFINE VARIABLE linechar AS CHAR .
     DEFINE VARIABLE woutputstatment as char.
     DEFINE VARIABLE ik as inte.
	 
     linechar = "" .
     input from value (file_name_o) .
      
     repeat: 
        IMPORT UNFORMATTED woutputstatment.                         
            
        IF index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */ 
	   index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */
	   index (woutputstatment,"岿粇:")	<> 0       /* for tw langx */ 		     
        then do:			  
	   output to  value ( "/app/bc/tmp/kb_log.err") APPEND.
	   put unformatted today " " string (time,"hh:mm:ss")  " " file_name_o " " woutputstatment  skip.
	   output close.
	   linechar = "ERROR" .			  
        end.		     
     End.

     input close.
     if linechar <> "ERROR" then do:
	unix silent value ("rm -f "  + trim(file_name)).
        unix silent value ("rm -f "  + trim(file_name_o)).
     end. 
  end.
