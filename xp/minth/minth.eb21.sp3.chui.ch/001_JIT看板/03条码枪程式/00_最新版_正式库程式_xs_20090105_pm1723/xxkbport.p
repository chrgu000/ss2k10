/* xxkbport.p  For PO KB read return                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 07/23/2007   BY: Softspeed tommy xie         */

define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid.
define shared variable batchrun like mfc_logical.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable dmdesc like dom_name.
define variable wtimeout as integer init 99999 .
define variable li_num as integer.
define variable p_qty as decimal format ">>,>>>,>>9" label "数量" no-undo.
define variable serial like tr_lot.
define variable lot like pt_lot_ser.
define variable bc as char format "x(20)".
define variable qty_oh like ld_qty_oh.
define shared variable suser as char no-undo.
define variable l_stat like po_stat.

define variable outfile as char format "x(40)"  no-undo.
define variable outfile1 as char format "x(40)"  no-undo.
define variable quote as char initial '"' no-undo.
define variable trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

define temp-table temp1
       field t1_nbr like po_nbr
       field t1_ln like pod_line
       field t1_part like pod_part
       field t1_curr like po_curr
       field t1_due_date as date
       field t1_qty like xkb_kb_qty
       field t1_loc like xkb_loc
       field t1_lot like xkb_lot
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
		  and xkb_type = "P" no-lock no-error.

	   if not available xkb_mstr then do:
              display skip "错误:采购看板条码没找到!" @ WMESSAGE NO-LABEL with fram F1400.
              pause 0 before-hide.
              undo, retry.
           end.
	   else do:
	      if xkb_status <> "U" then do:
	         display "错误:采购看板条码状态不是'U'" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.

	      find first pod_det where pod_domain = global_domain 
		     and pod_nbr = xkb_nbr and pod_part = xkb_part 
		     and pod_line = xkb_line no-lock no-error.
	      if not available pod_det then do:
	         display "错误:条码的采购单项不存在!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
	         if xkb_loc = "" then do:
	            display "错误:条码的库位错误!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.		 
		 end.
		 find first po_mstr where po_domain = global_domain and po_nbr = pod_nbr no-lock no-error.

		 p_qty = xkb_kb_raim_qty.
		 
		 find first xppt_mstr where xppt_domain = global_domain
		    and xppt_part = xkb_part no-lock no-error.

	         qty_firm = (if available xppt_mstr then xppt_qty_firm else no).
                 
		 if xkb_kb_id = 0 or xkb_kb_id = 999 or qty_firm = no then do:
                    update p_qty label "数量"
                    with frame dd side-labels overlay
                    row 3 width 80 no-attr-space.
		 end.		 

		 qty_oh = 0.
                 for each ld_det no-lock 
		    where ld_domain = global_domain
		      and ld_loc = xkb_loc
		      and ld_part = xkb_part
		      and ld_site = xkb_site
		   , each is_mstr no-lock where is_domain = ld_domain
		      and is_status = ld_status:
                    qty_oh = qty_oh + ld_qty_oh.
		 end.

		 if qty_oh < p_qty then do:
	            display "错误:库存数量不够,不能退货!" @ WMESSAGE NO-LABEL with fram F1400.
                    pause 0 before-hide.
                    undo, retry.		 
		 end.
              end.
	   end.

           display  "" @ WMESSAGE NO-LABEL with fram F1400.
           pause 0.
           leave V1400L.
        END.

        find first temp1 where t1_barcode = trim(V1400) no-lock no-error.
        if not available temp1 then do:
           create temp1.
           assign 
              t1_nbr      = xkb_nbr
              t1_ln       = xkb_line
              t1_due_date = PV1100
	      t1_part     = xkb_part
              t1_curr     = (if available po_mstr then po_curr else "")
              t1_barcode  = trim(V1400)
              t1_loc = xkb_loc
              t1_lot = xkb_lot
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
     outfile = "/app/bc/tmp/PORT" + substring(string(today),1,2) + substring(string(today),4,2)
                      + substring(string(today),7,2) + "_" + substring(string(time,"HH:MM"),1,2)
	              + ":" + substring(string(time,"HH:MM"),4,2) + ".prn".	       

     OUTPUT TO VALUE(outfile).

     for each temp1 no-lock break by t1_nbr by t1_ln:
        accumulate t1_qty (total by t1_ln). 
        
        if first-of(t1_nbr) then do:
	   find first po_mstr where po_domain = global_domain
	      and po_nbr = t1_nbr no-lock no-error.
           l_stat = (if available po_mstr then po_stat else " ").

           PUT UNFORMATTED 
               quote trim(t1_nbr) quote space skip.

	   if l_stat <> "" then 
	   PUT UNFORMATTED 
	      "Y" space skip.   /* 和上段多一个N */

	   PUT UNFORMATTED 
               "-" space
               "-" space
               "-" space
               quote t1_due_date quote space
               "N" space 
               "Y" space 
               "N" space 
               "Y" space skip.

	   if t1_curr <> "CNY" then do:
              PUT UNFORMATTED 
	          "-" space
                  "-" space skip.
	   end.
        end.

        if last-of(t1_ln) then do:
	   find first pod_det where pod_domain = global_domain
	      and pod_nbr = t1_nbr and pod_line = t1_ln no-lock no-error.
           l_stat = (if available pod_det then pod_stat else " ").

           PUT UNFORMATTED 
               quote t1_ln quote space skip.

           if l_stat <> "" then 
              PUT UNFORMATTED 
	      "Y" space skip.   /* 和上段多一个N */

           PUT UNFORMATTED 
               quote (accum total by t1_ln t1_qty) quote space
	       "-" space
	       "-" space
	       "-" space
	       "-" space
	       "-" space
               quote t1_loc quote space
               quote t1_lot quote space
	       "-" space
	       "N" space
	       "-" space
	       "N" space skip.
        end.

	if last-of(t1_nbr) then do:
           put unformatted
	       quote 0 quote space skip
	       "N" space skip
	       "Y" space skip
/*	       skip
               "." space skip
*/
	       .
        end.

        find first xkb_mstr where xkb_domain = global_domain 
	       and (xkb_type + xkb_part + string(xkb_kb_id,"999")) = t1_barcode
               and xkb_type = "P" and xkb_status = "U" no-error.

	if available xkb_mstr then do:	           
	   find last xkbhhist where xkbhhist.xkbh_domain = global_domain
	        use-index xkbh_trnbr no-lock no-error.
           trnbr = (if available xkbhhist then xkbhhist.xkbh_trnbr else 0).
	   xkb_kb_raim_qty = xkb_kb_raim_qty - t1_qty.
	   if xkb_kb_raim_qty = 0 then xkb_status = "A".

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
              xkbh_hist.xkbh_program     = "xxkbport.p"
              xkbh_hist.xkbh_userid      = suser
              xkbh_hist.xkbh_qty         = xkb_kb_qty
              xkbh_hist.xkbh_ori_qty     = xkb_kb_qty
              xkbh_hist.xkbh_b_status    = "U"
              xkbh_hist.xkbh_c_status    = "A"
              xkbh_hist.xkbh_kb_rain_qty = xkb_kb_raim_qty.
        end.
     end.
     OUTPUT CLOSE.

     /** 数据开始更新处理 **/
     DO TRANSACTION ON ERROR UNDO,RETRY:
        batchrun = YES.
	outfile1  = outfile + ".o".

        INPUT FROM VALUE(outfile).
        output to  value (outfile1) .
        
	run /app/mfgpro/eb21/ch/po/porvis.r.

	INPUT CLOSE.
        output close.
     END.  /** do transaction ***/
     
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
