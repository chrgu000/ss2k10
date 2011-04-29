/* xxkbporc.p  For PO KB read receipt                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 06/28/2007   BY: Softspeed tommy xie         */

define shared variable execname as character .  execname = "xxkbporc.p".

define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid.
define shared variable batchrun like mfc_logical.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable dmdesc like dom_name.
define variable wtimeout as integer init 99999 .
define variable li_num as integer.
define variable p_qty like xkb_kb_qty label "数量" no-undo.
define variable p_qty1 like xkb_kb_qty.
define variable pp_qty like xkb_kb_qty.
define variable serial like tr_lot.
define variable lot like pt_lot_ser.
define variable bc as char format "x(20)".
define shared variable suser as char no-undo.
define variable eff_date1 as date.
define variable b_site as char.
define variable i as integer.
define variable outfile as char format "x(40)"  no-undo.
define variable outfile1 as char format "x(40)"  no-undo.
define variable quote as char initial '"' no-undo.
define variable trnbr like tr_trnbr.
define variable k as integer.
define variable l_ship_id like xxbcm_id no-undo. 

define buffer xkbhhist for xkbh_hist.

define temp-table temp1
       field t1_nbr like po_nbr
       field t1_ln like pod_line
       field t1_curr like po_curr
       field t1_part like pod_part
       field t1_due_date as date
       field t1_qty like xkb_kb_qty
       field t1_site like pod_site
       field t1_loc like pod_loc
       field t1_barcode as char format "x(20)".

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[WIP转FG仓]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).

for each temp1: delete temp1.  end.

  mainloop:
  REPEAT:   
     V1100L:
     REPEAT:

        hide all.
        define variable V1100           as date no-undo .
        define variable PV1100          as date no-undo .
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".

        V1100 = ? .

        display dmdesc format "x(40)" skip with fram F1100 no-box.

        L11001 = "生效日期 ?" .
        display L11001          skip with fram F1100 no-box.

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
        
	V1100 = today.

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
           
           APPLY LASTKEY.
        END.
	
	if V1100 = ? then V1100 = today.

        display  skip WMESSAGE NO-LABEL with fram F1100.

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END 1100  客户  */

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
	   define variable qty_firm like xppt_qty_firm.

           /* --DEFINE VARIABLE -- END */

           V1400 = "".
	   display dmdesc format "x(40)" skip with fram F1400 no-box.

           L14001 = "生效日期:" + string(PV1100).
           display L14001          format "x(40)" skip with fram F1400 no-box.

           L14002 = "顺序号: " + PV1400.
           display L14002          format "x(40)" skip with fram F1400 no-box.

	   L14003 = "张数:" + string(li_num, "ZZ9") .
           display L14003          format "x(40)" skip with fram F1400 no-box.

           L14004 = "条码号 ?" . 
           display L14004          format "x(40)" skip with fram F1400 no-box.

           L14005 = " ". 
           display L14005          format "x(40)" skip with fram F1400 no-box.

           L14006 = "" . 
           display L14006          format "x(40)" skip with fram F1400 no-box.

           display "输入或按E退出,C取消"       format "x(40)" skip
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
              apply lastkey.
           end.

	   /* PRESS e EXIST CYCLE */
           IF V1400 = "e" or V1400 = "c" THEN LEAVE mainloop.
           
           display skip WMESSAGE NO-LABEL with fram F1400.
           /*  ---- Valid Check ---- START */

           display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
           pause 0.
           /* CHECK FOR NUMBER VARIABLE START  */

	   find first xkb_mstr where xkb_domain = global_domain 
	          and (xkb_type + xkb_part + string(xkb_kb_id,"999")) = trim(V1400)
		  and (xkb_type = "P" or xkb_type = "M") no-lock no-error.

	   if not available xkb_mstr then do:
              display skip "错误:采购看板条码没找到!" @ WMESSAGE NO-LABEL with fram F1400.
              pause 0 before-hide.
              undo, retry.
           end.
	   else do:	   
	      if xkb_status <> "R" then do:
	         display "错误:采购看板条码状态不是'R'" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
              b_site = xkb_site.

	      find first pod_det where pod_domain = global_domain 
		     and pod_nbr = xkb_nbr and pod_line = xkb_line no-lock no-error.
	      if not available pod_det then do:
	         display "错误:条码的采购单项不存在!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
	         if pod_status <> "" then do:
	            display "采购单零件不允许收货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.

                 if pod_end_eff[1] < V1100 then do:
	            display "采购单零件已超过有效日期!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		 end.
		 find first po_mstr where po_domain = global_domain
		    and po_nbr = pod_nbr no-lock no-error.

/*mage add 08/10/13**********************************************************************/
		    if "CNY"  <> po_curr
      then do:
             
		      
         if not po_fix_rate
         then do:
         find first exr_rate no-lock where exr_domain = global_domain and ((exr_curr1 = "cny"  and exr_curr2 = po_curr) or (exr_curr2 = "cny"  and exr_curr1 = po_curr)) 
	      and V1100 >= exr_start_date  and  V1100 <= exr_end_date no-error.
	      if not available exr_rate then do:
             display "兑换率不存在,请重新输入!!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.
		    end.
         end. /*IF NOT po_fix_rate */
      end. /* IF 'CNY' <> po_curr */
/*mage add 08/10/13**********************************************************************/

/*debug
                 /*minth ******************控制提前收货**************/
                 FUNCTION nextworkdate RETURNS DATE (  date12 AS DATE).
                     date12 = date12 + 1.
                     if not available shop_cal then
                     find shop_cal no-lock where shop_domain = global_domain 
                         and shop_site = b_site
                         and shop_wkctr = "" and shop_mch = ""  no-error.

                     if not available shop_cal then
                     find shop_cal no-lock where shop_domain = global_domain 
                        and shop_site = "" and shop_wkctr = "" 
			and shop_mch = "" no-error.

                     if available shop_cal
                        and (shop_wday[1] or shop_wday[2] or shop_wday[3]
                          or shop_wday[4] or shop_wday[5] or shop_wday[6] or shop_wday[7])
                     then do:
                        repeat:
                           if shop_wdays[weekday(date12)] then do:
                              if not can-find(hd_mstr where hd_domain = global_domain 
                                 and hd_date = date12
                                 and hd_site = b_site) then do:
                                 leave.
                              end.
                              else do:
                                 date12 = date12 + 1.
                              end.
                           end.
                           else date12 = date12 + 1.
                        end. /*repeat*/
                     end. /*available shop_cal*/
                     else release shop_cal.
                     RETURN date12.
                 END.  /*FUNCTION nextworkdate RETURNS DATE (  date12 AS DATE)*/

                 eff_date1 = V1100.
	                         
		 find first vd_mstr where vd_domain = global_domain 
		       and vd_addr = po_vend no-lock no-error.

                 if available vd_mstr then do:
                    IF vd__dec02  >= 1 THEN 
                    DO i = 1 TO integer(vd__dec02):
                       eff_date1 =  nextworkdate(eff_date1).
	            END.
                 end. /*if available vd_mstr ***************/
 /*minth ******************控制提前收货**************/
debug*/
                 
		 if not pod_sched then do:
                    pp_qty = max(pod_qty_ord - pod_qty_rcv,0).
                 end.
		 else do:
                    pp_qty = 0.

                    for first sch_mstr
                       fields( sch_domain sch_line sch_nbr sch_pcr_qty sch_rlse_id
                               sch_type)
                        where sch_mstr.sch_domain = global_domain 
			  and sch_type = 4
                          and sch_nbr = pod_nbr
                          and sch_line = pod_line
                          and sch_rlse_id = pod_curr_rlse_id[1]
                          no-lock:
                    end. /* FOR FIRST SCH_MSTR */

                    if available sch_mstr then do:
                       for last schd_det
                         fields( schd_domain schd_cum_qty schd_date schd_line schd_nbr
                                 schd_rlse_id schd_type)
                          where schd_det.schd_domain = global_domain 
			    and schd_type = sch_type
                            and schd_nbr = sch_nbr
                            and schd_line = sch_line
                            and schd_rlse_id = sch_rlse_id
                            and schd_date   <= V1100 no-lock:
                       end. /* FOR LAST SCHD_DET */

                       if available schd_det then do:
                          pp_qty = max(schd_cum_qty - pod_cum_qty[1],0).
                       end.
                       else do:
                          pp_qty = max(sch_pcr_qty - pod_cum_qty[1],0).
                       end.
                    end.
		 end.
		 
                 p_qty1 = xkb_qty.
                 for each temp1 no-lock where t1_nbr = xkb_nbr
		      and t1_ln = xkb_line:
		    p_qty1 = p_qty1 + t1_qty.
	         end.

		 find first poc_ctrl no-lock no-error.
		 if available poc_ctrl then do:
                    pp_qty = pp_qty * (poc_tol_pct + 100) * 0.01.

		    if poc_tol_pct <> 0 and p_qty1 > pp_qty then do:
	               display "采购零件超量收货不允许!" @ WMESSAGE NO-LABEL with fram F1400.
                       pause 0 before-hide.
                       undo, retry.		        
		    end.
		 end.
		 else do:
		    if p_qty1 > pp_qty then do:
	               display "采购零件超量收货不允许!" @ WMESSAGE NO-LABEL with fram F1400.
                       pause 0 before-hide.
                       undo, retry.		        
		    end.
                 end.

	         p_qty = xkb_kb_qty - xkb_kb_raim_qty.
                 find first xppt_mstr where xppt_domain = global_domain
		    and xppt_part = xkb_part no-lock no-error.

	         qty_firm = (if available xppt_mstr then xppt_qty_firm else no).

		 if xkb_kb_id = 000 or xkb_kb_id = 999 or qty_firm = no then do:
                    update p_qty label "数量"
                    with frame dd side-labels overlay
	            row 3 width 80 no-attr-space.
		    hide frame dd no-pause.
		 end.		 
              end.
	   end.

           display "" @ WMESSAGE NO-LABEL with fram F1400.
           pause 0.
           leave V1400L.
        END.

        find first temp1 where t1_barcode = trim(V1400) no-lock no-error.
        if not available temp1 then do:
           create temp1.
           assign 
              t1_nbr      = xkb_nbr
              t1_ln       = xkb_line
              t1_curr     = (if available po_mstr then po_curr else "")
              t1_due_date = PV1100
	      t1_part     = xkb_part
              t1_site = pod_site
              t1_loc = pod_loc
              t1_barcode  = trim(V1400)
	      t1_qty = p_qty
	      li_num = li_num + 1.
	end.

	PV1400 = string(xkb_kb_id, "999").
        pause 0 before-hide.       
     END.     /* V1300LMAINLOOP: */

     pause 0 before-hide.
  end. /**mainloop**/

IF V1400 = "e" then do:
  if can-find(first temp1) then do:
     k = 0.
     for each temp1 no-lock break by t1_nbr:
        if last-of(t1_nbr) then k = k + 1.
     end.
     if k > 1 then do:
        display "错误: 一次只能一个采购定单!".
        pause 0.
        leave.
     end.

     outfile = "/app/bc/tmp/PORC" + substring(string(today),1,2) + substring(string(today),4,2)
                      + substring(string(today),7,2) + "_" + substring(string(time,"HH:MM"),1,2)
	              + ":" + substring(string(time,"HH:MM"),4,2) + ".prn".	       

     OUTPUT TO VALUE(outfile).

     for each temp1 no-lock break by t1_nbr by t1_ln:
        accumulate t1_qty (total by t1_ln). 
        
        if first-of(t1_nbr) then do:
           PUT UNFORMATTED 
               quote trim(t1_nbr) quote space skip            
               "-" space
               "-" space
               quote t1_due_date quote space
               "Y"                 space 
               "N"                 space 
               "N"                 space 
               "-" space skip.

	   if t1_curr <> "CNY" then do:
              PUT UNFORMATTED 
	          "-" space
                  "-" space skip.
	   end.
        end.

        if last-of(t1_ln) then do:
  	   find first pt_mstr where pt_domain = global_domain
	          and pt_part = t1_part no-lock no-error.
	   lot = (if available pt_mstr then pt_lot_ser else "").

	   serial = " ".
	   if lot = "L" or lot = "S" then do:
              for each tr_hist no-lock
                 where tr_domain = global_domain
/*                 and tr_type = "rct-po" */
                   and tr_effdate = t1_due_date
                   and tr_part = t1_part
              break by tr_serial:
	         serial = tr_serial.
	      end.
	      if serial > "" and length(serial) = 10 then
	         serial = string(integer(substring(serial, 9,2)) + 1, "99").
	      else serial = "01".
	      serial = "2007" + string(month(t1_due_date), "99") 
	                      + string(day(t1_due_date),"99") + serial.
	   end.

           PUT UNFORMATTED 
               quote t1_ln quote space skip
               quote (accum total by t1_ln t1_qty) quote space
	       "-" space
               "N" space 
	       "-" space
	       "-" space
	       "-" space
	       quote t1_site quote space
	       quote t1_loc quote space.

           if lot = "L" then 
              PUT UNFORMATTED 
   	          quote serial quote space.
	   else PUT UNFORMATTED "-" space.

           PUT UNFORMATTED 
	       "-" space
	       "-" space
              "N" space 
              "N" space 
              "N" space skip.
        end.

	if last-of(t1_nbr) then do:
           put unformatted
	       quote 0 quote space skip.
        end.

/*mage del 08/10/13 *********************************************************************
	find first xkb_mstr where xkb_domain = global_domain 
	       and (xkb_type + xkb_part + string(xkb_kb_id,"999")) = t1_barcode
	       and lookup(xkb_type,"P,M") > 0 and xkb_status = "R" no-error.

	if available xkb_mstr then do:    
	   xkb_status = "U".
	   xkb_kb_raim_qty = xkb_kb_raim_qty + t1_qty.

	   find first pod_det where pod_domain = global_domain 
	          and pod_nbr = t1_nbr and pod_line = t1_ln no-lock no-error.
           xkb_loc = (if available pod_det then pod_loc else pt_loc).
           if lot = "L" then xkb_lot = serial.
           else xkb_lot = "".

	   find last xkbhhist where xkbhhist.xkbh_domain = global_domain
	        use-index xkbh_trnbr no-lock no-error.
           trnbr = (if available xkbhhist then xkbhhist.xkbh_trnbr else 0).

           create xkbh_hist.
           assign
              xkbh_hist.xkbh_domain      = global_domain
              xkbh_hist.xkbh_type        = xkb_type  
              xkbh_hist.xkbh_part        = xkb_part
              xkbh_hist.xkbh_site        = xkb_site  
              xkbh_hist.xkbh_kb_id       = xkb_kb_id
              xkbh_hist.xkbh_trnbr       = trnbr + 1
              xkbh_hist.xkbh_eff_date    = today 
              xkbh_hist.xkbh_date        = today 
              xkbh_hist.xkbh_time        = time
              xkbh_hist.xkbh_program     = "xxkbporc.p"
              xkbh_hist.xkbh_userid      = global_userid
              xkbh_hist.xkbh_qty         = xkb_kb_qty
              xkbh_hist.xkbh_ori_qty     = xkb_kb_qty
              xkbh_hist.xkbh_b_status    = "R"
              xkbh_hist.xkbh_c_status    = "U"
              xkbh_hist.xkbh_kb_rain_qty = xkb_kb_raim_qty.
        end.

*mage del 08/10/13 *********************************************************************/

     end.
     OUTPUT CLOSE.

     /** 数据开始更新处理 **/
     DO TRANSACTION ON ERROR UNDO,RETRY:
        batchrun = YES.
	outfile1  = outfile + ".o".
        l_ship_id = "".

        INPUT FROM VALUE(outfile).
        output to  value (outfile1) .

	run /app/mfgpro/eb21/ch/xx/xxpoporc99.p(input-output l_ship_id).

        output close.
	INPUT CLOSE.

     END.  /** do transaction ***/
     output close.
     INPUT CLOSE.

/*mage add 08/10/13 ****************************************************/
   if l_ship_id >= "1" then do:
       for each temp1 no-lock break by t1_nbr by t1_ln:
         
	find first xkb_mstr where xkb_domain = global_domain 
	       and (xkb_type + xkb_part + string(xkb_kb_id,"999")) = t1_barcode
	       and lookup(xkb_type,"P,M") > 0 and xkb_status = "R" no-error.

	if available xkb_mstr then do:    
	   xkb_status = "U".
	   xkb_kb_raim_qty = xkb_kb_raim_qty + t1_qty.

	   find first pod_det where pod_domain = global_domain 
	          and pod_nbr = t1_nbr and pod_line = t1_ln no-lock no-error.
           xkb_loc = (if available pod_det then pod_loc else pt_loc).
           if lot = "L" then xkb_lot = serial.
           else xkb_lot = "".

	   find last xkbhhist where xkbhhist.xkbh_domain = global_domain
	        use-index xkbh_trnbr no-lock no-error.
           trnbr = (if available xkbhhist then xkbhhist.xkbh_trnbr else 0).

           create xkbh_hist.
           assign
              xkbh_hist.xkbh_domain      = global_domain
              xkbh_hist.xkbh_type        = xkb_type  
              xkbh_hist.xkbh_part        = xkb_part
              xkbh_hist.xkbh_site        = xkb_site  
              xkbh_hist.xkbh_kb_id       = xkb_kb_id
              xkbh_hist.xkbh_trnbr       = trnbr + 1
              xkbh_hist.xkbh_eff_date    = today 
              xkbh_hist.xkbh_date        = today 
              xkbh_hist.xkbh_time        = time
              xkbh_hist.xkbh_program     = "xxkbporc.p"
              xkbh_hist.xkbh_userid      = global_userid
              xkbh_hist.xkbh_qty         = xkb_kb_qty
              xkbh_hist.xkbh_ori_qty     = xkb_kb_qty
              xkbh_hist.xkbh_b_status    = "R"
              xkbh_hist.xkbh_c_status    = "U"
              xkbh_hist.xkbh_kb_rain_qty = xkb_kb_raim_qty.
        end.
     end. /*for each temp1 ********************/

 end. /*   if l_ship_id >= "0" then do: */

/*mage add 08/10/13 ****************************************************/

     display "收货单号:" + l_ship_id format "x(18)"
     with frame dd1 no-label overlay
     row 3 width 80 no-attr-space.
     pause.
	 
    /*
     run write_error_to_log(input outfile,input outfile1) . 
     */
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
            
        IF index (woutputstatment,"ERROR:")   <> 0 OR      /* for us langx */ 
	   index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */
	   index (woutputstatment,"岿粇:")	<> 0       /* for tw langx */ 		     
        then do:			  
	   output to  value ( "/app/bc/xs/kb_log.err") APPEND.
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

