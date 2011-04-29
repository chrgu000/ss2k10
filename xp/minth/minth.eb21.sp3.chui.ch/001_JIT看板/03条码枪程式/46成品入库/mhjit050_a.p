/* xsship01.p   Ford shippment                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 08/17/06   BY: tommy                         */
/* REVISION: 1.2      LAST MODIFIED: 2009/01/07   BY: Softspeed roger xiao   ECO:*xp003* */ /*成功入库完成后也提示*/
/*-Revision end------------------------------------------------------------          */




define shared variable execname as character .  execname = "mhjit050_a.p".
define shared variable global_site as char .
define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid.
define shared variable mfguser as character.
define shared variable global_part as character.
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable batchrun like mfc_logical.
define variable dmdesc like dom_name.
define variable WMESSAGE as char format "x(80)" init "".
define variable wtimeout as integer init 99999 .
define variable undo-input like mfc_logical.
define var loc_to like loc_loc .
define var effdate as date .
define var site like xkb_site .
define var v_yn as logical format "Y/N" initial yes .

define var v_nbr like xdn_next .
define variable p-type like xdn_type.
define variable p-prev like xdn_prev.
define variable p-next like xdn_next.
define variable m2 as char format "x(8)".
define variable k as integer.

define var v_qty like xkb_kb_qty .
define var v_qty_req like xkb_kb_qty .
define var v_qty_oh like ld_qty_oh .
define var v_raim_qty  like xkb_kb_raim_qty .

define variable i as integer .
define variable j as integer format ">>9" no-undo.
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var stat_from as char  .
define var stat_to as char .

define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define new shared variable transtype as character format "x(7)" initial "ISS-TR".
/*tx01*/ define variable bc_qty like xxbcd_qty.
/*tx01*/ define variable bc as integer format "zz9" no-undo.
/*tx01*/ define variable q1bc as char format "x(22)" no-undo.
/*tx01*/ define variable wip_loc like loc_loc no-undo.
/*tx01*/ define variable nbr like so_nbr no-undo.
/*tx01*/ define variable ln like pod_line no-undo.

{gldydef.i new}
{gldynrm.i new}


define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb no-undo
    field tmp_id   like xkb_kb_id
    field tmp_type like xkb_type
    field tmp_site like xkb_site
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_part like xkb_part 
    field tmp_qty  like xkb_kb_qty
/*tx01*/ field tmp_cust like ad_addr
/*tx01*/ field tmp_nbr like so_nbr
/*tx01*/ field tmp_ln like pod_line
/*tx01*/ field tmp_q1bc as char format "x(22)"
/*tx01*/ field tmp_bc as char format "x(22)".


/************** start tx01***************/
define temp-table temp1 no-undo
       field t1_cust like ad_addr
       field t1_part like pt_part
       field t1_loc_to like loc_loc
       field t1_nbr as char format "x(20)"
       field t1_serial like xxbcd_serial.       
/************** end tx01***************/

find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[看板转仓入库]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


    V1000L:
    REPEAT:
        hide all no-pause.
        define variable V1000           as date no-undo .
        define variable L10001          as char format "x(40)".
        define variable L10002          as char format "x(40)".
        define variable L10003          as char format "x(40)".
        define variable L10004          as char format "x(40)".
        define variable L10005          as char format "x(40)".
        define variable L10006          as char format "x(40)".
        
        display dmdesc format "x(40)" skip with fram F1000 no-box.
        
        v1000 = ? .

        L10001 = "" .
        display L10001          skip with fram F1000 no-box.
        L10002 = "" . 
        display L10002          format "x(40)" skip with fram F1000 no-box.
        L10003 = "" . 
        display L10003          format "x(40)" skip with fram F1000 no-box.
        L10004 = "" . 
        display L10004          format "x(40)" skip with fram F1000 no-box.
        L10005 = "" . 
        display L10005          format "x(40)" skip with fram F1000 no-box.
        L10006 = "生效日期 ? " . 
        display L10006          format "x(40)" skip with fram F1000 no-box.

        V1000 = today.
        
        Update V1000   WITH  fram F1000 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if lastkey = 404 then  Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1000.
           
           APPLY LASTKEY.
        END.
    
        if V1000 = ? then V1000 = today.

        display  skip WMESSAGE NO-LABEL with fram F1000.

        if v1000 < today  then do:
            display "日期不得小于今天,请重新输入." @ WMESSAGE NO-LABEL with fram F1000.
            pause 0  .
            undo ,retry .
        end.

        effdate = v1000 .
        
        find icc_ctrl where icc_domain = global_domain no-lock no-error.
        site = if avail icc_ctrl then icc_site else global_site .
    
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                disp  "看板模块没有开启" @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
            end.
        end.
    
        /* v_nbr */
            /*----------------start:get nbr---------------------------*/
        v_nbr  = "" .
        p-type = "MI" .
        p-prev = "" .
        p-next = "" .
        m2 = "".
        k  = 0 .



        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
        if available xdn_ctrl then do:
            p-prev = xdn_prev.
            p-next = xdn_next.
        end. 
        else do:
                disp  "错误:无入库单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.

        do transaction on error undo, retry:
            find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
            if available xdn_ctrl then do:
                k = integer(p-next) .
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                v_nbr = trim(p-prev) + trim(m2).
                k = integer(p-next) + 1.
                m2 = fill("0",length(p-next) - length(string(k))) + string(k).
                xdn_next = m2.
            end.
            if recid(xdn_ctrl) = ? then .
            release xdn_ctrl.
        end. /*do transaction*/
        /*----------------end:get nbr---------------------------*/

        
        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        leave V1000L.
    END.  /* END 1000    */

loc_to = "" .
/* 每次只能在入库一个库位 */

MAINLOOP:
REPEAT: 

/***************** start tx01**************/
     V1600L:
     REPEAT:

        hide all.
        define variable V1600           as char format "x(50)" no-undo.
        define variable PV1600          as char format "x(50)".
        define variable L16001          as char format "x(40)".
        define variable L16002          as char format "x(40)".
        define variable L16003          as char format "x(40)".
        define variable L16004          as char format "x(40)".
        define variable L16005          as char format "x(40)".
        define variable L16006          as char format "x(40)".

        V1600 = "".

        display dmdesc format "x(40)" skip with fram F1600 no-box.

        L16001 = "客户 ?" .
        display L16001          format "x(40)" skip with fram F1600 no-box.
        L16002 = "" . 
        display L16002          format "x(40)" skip with fram F1600 no-box.
        L16003 = "" . 
        display L16003          format "x(40)" skip with fram F1600 no-box.
        L16004 = "" . 
        display L16004          format "x(40)" skip with fram F1600 no-box.
        L16005 = "" . 
        display L16005          format "x(40)" skip with fram F1600 no-box.
        L16006 = "" . 
        display L16006          format "x(40)" skip with fram F1600 no-box.

        display "输入或按E退出"       format "x(40)" skip
                skip with fram F1600 no-box.
        Update V1600
        WITH  fram F1600 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1600.
           
	   IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
           THEN DO:
              IF recid(AD_MSTR) = ? THEN 
	         find first AD_MSTR where AD_DOMAIN = global_domain 
		    AND AD_ADDR >=  INPUT V1600 no-lock no-error.
              ELSE find next AD_MSTR where AD_DOMAIN = global_domain no-lock no-error.

              IF AVAILABLE AD_MSTR then
	         display skip 
		     AD_ADDR @ V1600 
		     AD_NAME @ WMESSAGE NO-LABEL with fram F1600.
              else display skip "" @ WMESSAGE with fram F1600.
           END.

           IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
           THEN DO:
              IF recid(AD_MSTR) = ? THEN 
	         find first AD_MSTR where AD_DOMAIN = global_domain 
		    AND AD_ADDR <=  INPUT V1600 no-lock no-error.
              ELSE find prev AD_MSTR where AD_DOMAIN = global_domain no-lock no-error.
              IF AVAILABLE AD_MSTR then 
	         display skip 
                    AD_ADDR @ V1600 
		    AD_NAME @ WMESSAGE NO-LABEL with fram F1600.
              else display skip "" @ WMESSAGE with fram F1600.
           END.
           APPLY LASTKEY.
        END.
        /* ROLL BAR END */

        /* PRESS e EXIST CYCLE */
        IF V1600 = "e" THEN leave mainloop.
	
        display  skip WMESSAGE NO-LABEL with fram F1600.

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.

	find first AD_MSTR where AD_DOMAIN = global_domain AND AD_ADDR = V1600 no-lock no-error.
        IF NOT AVAILABLE AD_MSTR then do:
           display skip "错误:客户不存在." @ WMESSAGE NO-LABEL with fram F1600.
           pause 0 before-hide.
           undo, retry.
        end.
        IF not trim(V1600) <> "" THEN DO:
           display skip "错误:客户不允许空." @ WMESSAGE NO-LABEL with fram F1600.
           pause 0 before-hide.
           undo, retry.
        end.
/*debug
	if not (trim(V1600) begins "010017") then do:
           display skip "错误:仅允许福特客户." @ WMESSAGE NO-LABEL with fram F1600.
           pause 0 before-hide.
           undo, retry.	   
	end.
debug*/
        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END 1400  客户  */

     /* START V1200 客户零件：? */
     V1500L:
     REPEAT:
        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1500           as char format "x(50)".
        define variable PV1500          as char format "x(50)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".
	define variable part            like pt_part.
        /* --DEFINE VARIABLE -- END */

        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = "".
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

  	display dmdesc format "x(40)" skip with fram F1500 no-box.

        /* LABEL 1 - START */ 
        L15001 = "客户零件 ?". 
        display L15001          format "x(40)" skip with fram F1500 no-box.
        /* LABEL 1 - END */ 

        /* LABEL 2 - START */ 
        L15002 = "客户:" + PV1600. 
        display L15002          format "x(40)" skip with fram F1500 no-box.
        /* LABEL 1 - END */ 

        /* LABEL 3 - START */ 
        L15003 = "" . 
        display L15003          format "x(40)" skip with fram F1500 no-box.
        /* LABEL 3 - END */ 

        /* LABEL 4 - START */ 
        L15004 = "". 
        display L15004          format "x(40)" skip with fram F1500 no-box.

        /* LABEL 5 - START */ 
        L15005 = "". 
        display L15005          format "x(40)" skip with fram F1500 no-box.

        /* LABEL 6 - START */ 
        L15006 = "". 
        display L15006          format "x(40)" skip with fram F1500 no-box.

        display "输入或E退出"       format "x(40)" skip
                skip with fram F1500 no-box.

        Update V1500
        WITH fram F1500 NO-LABEL
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
                 IF recid(CP_MSTR) = ? THEN 
		    find first CP_MSTR where CP_DOMAIN = global_domain 
		       AND CP_CUST = trim(PV1600) AND CP_CUST_PART >=  INPUT V1500 no-lock no-error.
                 ELSE find next CP_MSTR where CP_DOMAIN = global_domain 
		         AND CP_CUST = trim(PV1600) no-lock no-error.

                 IF AVAILABLE CP_MSTR then do:
		    display skip 
                        CP_CUST_PART @ V1500 
			CP_PART @ WMESSAGE NO-LABEL with fram F1500.
		    part = cp_part.
		 end.
                 else display skip "" @ WMESSAGE with fram F1500.
              END.

              IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
              THEN DO:
                 IF recid(CP_MSTR) = ? THEN 
		    find first CP_MSTR where CP_CUST = trim(PV1600) AND CP_DOMAIN = global_domain
		       AND CP_CUST_PART <= INPUT V1500 no-lock no-error.
                 ELSE find prev CP_MSTR where CP_DOMAIN = global_domain 
		         AND CP_CUST = trim(PV1600) no-lock no-error.
                 IF AVAILABLE CP_MSTR then do:
		    part = cp_part.
		    display skip 
                       CP_CUST_PART @ V1500 
		       CP_PART @ WMESSAGE NO-LABEL with fram F1500.
                 end.
                 else display skip "" @ WMESSAGE with fram F1500.
              END.
              APPLY LASTKEY.
           END.
           /* ROLL BAR END */

           /* PRESS e EXIST CYCLE */
           IF trim(V1500) = "e" THEN LEAVE MAINLOOP.

           display skip WMESSAGE NO-LABEL with fram F1500.

           /*  ---- Valid Check ---- START */

           display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
           pause 0.

	   find first xxbcd_hist where xxbcd_domain = global_domain AND xxbcd_cust = trim(PV1600)
	      AND xxbcd_cust_part = trim(V1500) no-lock no-error.	   
           IF NOT AVAILABLE xxbcd_hist then do:
              display skip "错误,没有小箱标签." @ WMESSAGE NO-LABEL with fram F1500.
              pause 0 before-hide.
              undo, retry.
           end.

           find first CP_MSTR where CP_CUST = trim(PV1600) AND CP_DOMAIN = global_domain
		       AND CP_CUST_PART = V1500 no-lock no-error.
           part = (if available cp_mstr then cp_part else "").

	   IF not trim(V1500) <> "" THEN DO:
              display skip "错误,不允许空." @ WMESSAGE NO-LABEL with fram F1500.
              pause 0 before-hide.
              undo, retry.
           end.

           display  "" @ WMESSAGE NO-LABEL with fram F1500.
           pause 0.
           leave V1500L.
        END.
        PV1500 = V1500.	
/***************** end tx01****************/

    for each tmpkb:
        delete tmpkb .
    end.

    hide all no-pause.
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .



     V1100L:
     REPEAT:

        hide all no-pause.
        define variable V1100           as char format "x(40)" .
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".


        display dmdesc format "x(40)" skip with fram F1100 no-box.

        L11001 = "入库单号: " + v_nbr .
        display L11001          skip with fram F1100 no-box.
        L11002 = "生效日期:" + string(effdate). 
        display L11002          format "x(40)" skip with fram F1100 no-box.
        L11003 = "" . 
        display L11003          format "x(40)" skip with fram F1100 no-box.
        L11004 = "" . 
        display L11004          format "x(40)" skip with fram F1100 no-box.
        L11005 = "" . 
        display L11005          format "x(40)" skip with fram F1100 no-box.
        L11006 = "转入库位 ? " . 
        display L11006          format "x(40)" skip with fram F1100 no-box.
        
	    V1100 = loc_to .

    	Update V1100     WITH  fram F1100 NO-LABEL
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

        display  skip WMESSAGE NO-LABEL with fram F1100.

        if v1100 = "e" then leave mainloop.

         find first loc_mstr where loc_domain = global_domain and loc_loc = v1100  /*and loc_user1 = "1"*/ no-lock no-error . 
        if not avail loc_mstr then do:
              display "错误:库位不存在."  @ WMESSAGE NO-LABEL with fram F1100.
              pause 0 .
              undo ,retry .
        end.
        
        if loc_to = "" then loc_to = v1100 .
        else do:
            if v1100 <> loc_to then do:
                  display "库位变化,请重新进入产生新单号" @ WMESSAGE NO-LABEL with fram F1100.
                  pause 0 .
                  undo ,retry .                
            end.
        end.

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
        
     END.   /* END 1100 */    
    
     j = 0 .
    /*tx01*/ bc = 0.
    
     V1300L:
     REPEAT:

        find first tmpkb no-lock no-error .

        hide all no-pause.
        define variable V1300           as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".

        display dmdesc format "x(40)" skip with fram F1300 no-box.

        L13001 = "入库单号: " + v_nbr .
        display L13001          skip with fram F1300 no-box.
        L13002 =  "生效日期:" + string(effdate)  .  
        display L13002          format "x(40)" skip with fram F1300 no-box.
        L13003 = "转入库位: " + loc_to.
        display L13003          format "x(40)" skip with fram F1300 no-box.
/*tx01* L13004 = "看板张数:" + string(j).  */	
/*tx01*/ L13004 = "看板张数:" + string(j, "zz9") + " Q1:" + string(bc, "zz9"). 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        L13005 =  "" .  
        display L13005          format "x(40)" skip with fram F1300 no-box.
        L13006 = if avail tmpkb then "先刷Q1条码再刷看板条码,或直接确认执行" else "请先刷Q1条码再刷看板条码!" .
        display L13006          format "x(40)" skip with fram F1300 no-box.
        
        v1300 = "" .
   
    	Update V1300   WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then quit.
           if LASTKEY = 404 Then Do: /* DISABLE F4 */
              pause 0 before-hide.
              undo, retry.
           end.
           display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
           
           APPLY LASTKEY.
        END.

        display  skip WMESSAGE NO-LABEL with fram F1300.

        
        if v1300 <> "" then do:
            if v1300 = "e" then leave mainloop.

              v13001 = substring(v1300,1,1) .  /* xkb_type*/
              v13002 = substring(v1300,2,length(v1300) - 4 ) .  /* xkb_part*/
              v13003 = substring(v1300,length(v1300) - 2 ,3) .    /* xkb_kb_id */
/********** tx01**********
              if v13001 <> "M"  then do:
                  disp "仅限生产看板,请重刷读" @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0 .
                  undo, retry.
              end.

              find first xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
	             and (xkb_type + xkb_part + string(xkb_kb_id, "999")) = V1300
                     and (xkb_status = "U" and xkb_kb_raim_qty > 0) no-lock no-error .
              if not avail xkb_mstr then do:
                  disp "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0.
                  undo, retry.
              end.
              else do:
********** tx01**********/
/************ start tx01***********/
              find first xkb_mstr where xkb_domain = global_domain and xkb_type = "M"
	             and (xkb_type + xkb_part + string(xkb_kb_id, "999")) = trim(v1300) no-lock no-error .
              if avail xkb_mstr then do:
                 if v13001 <> "M"  then do:
                    disp "仅限生产看板,请重刷读" @ WMESSAGE NO-LABEL with fram F1300. 
                    pause 0 .
                    undo, retry.
                 end. 
		 if xkb_status <> "U" then do:
                    disp "看板不是 U 状态,不能转仓" @ WMESSAGE NO-LABEL with fram F1300. 
                    pause 0 .
                    undo, retry.
		 end.
		 if xkb_kb_raim_qty <= 0 then do:
                    disp "看板余数<=0,不能转仓" @ WMESSAGE NO-LABEL with fram F1300. 
                    pause 0 .
                    undo, retry.
		 end.
/************ end tx01***********/
                    if loc_to  = xkb_loc  then do:
                      disp "错误:看板已在该库位" @ WMESSAGE NO-LABEL with fram F1300. 
                      pause 0 .
                      undo, retry.
                    end.
/********** start tx01*********/
	            if q1bc = "" then do:
                       disp "错误:请先刷读Q1条码" @ WMESSAGE NO-LABEL with fram F1300. 
                       pause 0 .
                       undo, retry.
		    end.
		    if bc_qty <> xkb_kb_raim_qty then do:
                       disp "错误:条码与看板余量不一致" @ WMESSAGE NO-LABEL with fram F1300. 
                       pause 0 .
                       undo, retry.
		    end.
		    if wip_loc <> xkb_loc then do:
                       disp "错误:条码库位与看板库位不一致" @ WMESSAGE NO-LABEL with fram F1300. 
                       pause 0 .
                       undo, retry.
		    end.
/********** end tx01*********/
                    v_qty_oh = 0 .
                    v_qty_req = xkb_kb_raim_qty .
                    for each ld_Det where ld_domain = global_domain and ld_site = xkb_site and ld_loc = xkb_loc and ld_lot = xkb_lot
                              and ld_ref = xkb_ref and ld_part = xkb_part no-lock:
                         v_qty_oh = v_qty_oh + ld_qty_oh .
                    end.

                    for each tmpkb where tmp_site = xkb_site and tmp_loc = xkb_loc and tmp_part = xkb_part and tmp_lot = xkb_lot and tmp_ref = xkb_ref no-lock :
                        v_qty_req = v_qty_req + tmp_qty . 
                    end.

                    if v_qty_req > v_qty_oh then do:
                          disp "有效库存不足,请确认" @ WMESSAGE NO-LABEL with fram F1300. 
                          pause 0.
                          undo, retry.
                    end.

                    find first tmpkb no-lock no-error .
                    if not avail tmpkb then do:   /*first scan */
                        create tmpkb .
                        assign tmp_id = xkb_kb_id 
                            tmp_site  = xkb_site 
                            tmp_loc   = xkb_loc 
                            tmp_lot   = xkb_lot 
                            tmp_ref   = xkb_ref 
                            tmp_part  = xkb_part 
                            tmp_type  = v13001 
                            tmp_qty   = xkb_kb_raim_qty  
/*tx01*/                    tmp_bc    = trim(v1300)	
/*tx01*/                    tmp_cust  = V1600
/*tx01*/                    tmp_nbr   = nbr
/*tx01*/                    tmp_ln    = ln
/*tx01*/                    tmp_q1bc  = q1bc.
                            j = j + 1 .
/*tx01*/                    q1bc = "".	
                    end. /*first scan */
                    else do:  /*not first scan */
/*tx01*                find tmpkb where tmp_id = inte(v13003) and tmp_part = v13002 no-lock no-error .  */
/*tx01*/               find first tmpkb where tmp_bc = trim(v1300) no-lock no-error. 
                            if avail tmpkb then do:
                                  disp "此条码已经存在,请勿重复刷读" @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                            end.

                            create tmpkb .
                            assign tmp_id = xkb_kb_id 
                                tmp_site  = xkb_site 
                                tmp_loc   = xkb_loc 
                                tmp_lot   = xkb_lot 
                                tmp_ref   = xkb_ref 
                                tmp_part  = xkb_part 
                                tmp_type  = xkb_type 
                                tmp_qty   = xkb_kb_raim_qty  
/*tx01*/                        tmp_cust  = V1600
/*tx01*/                        tmp_nbr   = nbr
/*tx01*/                        tmp_ln    = ln
/*tx01*/                        tmp_q1bc  = q1bc.
/*tx01*/                        tmp_bc    = trim(v1300).	
                                j = j + 1 .
/*tx01*/                        q1bc = "".	
                    end.  /*not first scan */
              end.
/***************** start tx01*******************/
              if q1bc <> "" then do:
                 display skip "错误:请扫看板条码!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.	      
	      end.

	      find first xxbcd_hist where xxbcd_domain = global_domain 
	         and xxbcd_cust = trim(V1600) 
	         and xxbcd_site = site and xxbcd_part = part 
	         and xxbcd_serial = substring(trim(V1300),1,14)
		 and xxbcd_stat = "P" no-lock no-error.

	      if not available xxbcd_hist then do:
                 display skip "错误:小标签库存未找到!" @ WMESSAGE NO-LABEL with fram F1400.
                 pause 0 before-hide.
                 undo, retry.
	      end.
	      else do:
                 find first temp1 where t1_cust = xxbcd_cust
                    and t1_part = xxbcd_part
                    and t1_serial = xxbcd_serial no-lock no-error.
                 if not available temp1 then do:
		    create temp1.
		    assign
		       t1_cust = xxbcd_cust
		       t1_part = xxbcd_part
                       t1_loc_to = loc_to
                       t1_nbr = v_nbr
		       t1_serial = xxbcd_serial.

		    q1bc = xxbcd_serial.
                    bc_qty = xxbcd_qty.
		    wip_loc = xxbcd_wiploc.
		    nbr = xxbcd_nbr.
		    ln = xxbcd_ln.
		    bc = bc + 1.
                 end.
	      end.
/***************** end tx01*******************/
          end. /*  if v1300 <> "" */
          else do:  /*  if v1300 = "" */
            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "请先刷Q1与看板条码才可执行"   @ WMESSAGE NO-LABEL with fram F1300. 
                pause 0 .
                undo ,retry .
            end.
/***************** start tx01*******************/
	    if bc <> j and (j <> 0 or bc <> 0) then do:
               disp "看板与Q1条码数不等不允许" @ WMESSAGE NO-LABEL with fram F1300. 
               pause 0 .
               undo ,retry .
	    end.
/***************** end tx01*******************/
                    V1400L:
                    REPEAT:
                        
                        hide all no-pause.
                        define variable V1400           as logical  .
                        define variable L14001          as char format "x(40)".
                        define variable L14002          as char format "x(40)".
                        define variable L14003          as char format "x(40)".
                        define variable L14004          as char format "x(40)".
                        define variable L14005          as char format "x(40)".
                        define variable L14006          as char format "x(40)".
                        
                        display dmdesc format "x(40)" skip with fram F1400 no-box.
                        
                        L14001 = "入库单号: " + v_nbr  .
                        display L14001          skip with fram F1400 no-box.
                        L14002 = "生效日期:" + string(effdate) . 
                        display L14002          format "x(40)" skip with fram F1400 no-box.
                        L14003 = "转入库位: " + loc_to.
                        display L14003          format "x(40)" skip with fram F1400 no-box.
/*tx01*                 L14004 = "看板张数:" + string(j) .   */
/*tx01*/                L14004 = "看板张数:" + string(j, "zz9") + " Q1:" + string(bc, "zz9"). 
                        display L14004          format "x(40)" skip with fram F1400 no-box.
                        L14005 = "" . 
                        display L14005          format "x(40)" skip with fram F1400 no-box.
                        L14006 = "执行看板入库?" . 
                        display L14006          format "x(40)" skip with fram F1400 no-box.
                        
                        Update V1400   WITH  fram F1400 no-label EDITING:
                            readkey pause wtimeout.
                            if lastkey = -1 then quit.
                            if LASTKEY = 404 Then Do: /* DISABLE F4 */
                                pause 0 before-hide.
                                undo, retry.
                            end.
                            display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
                            APPLY LASTKEY.
                        END.
                        display skip WMESSAGE NO-LABEL with fram F1400.

                        if v1400 then do:

/*tx01*                        for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part : */
/*tx01*/                       for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_q1bc by tmp_ref by tmp_part :

                                  if first-of(tmp_part) then  assign j = 0    v_qty = 0 .

                                  v_qty = v_qty + tmp_qty .
      
        
                                  if last-of(tmp_part) then do:
                                      v_qty_oh = 0 .
                                      j = j + 1 .
                                      for each ld_Det where ld_domain = global_domain and ld_site = tmp_site and ld_loc = tmp_loc and ld_lot = tmp_lot
                                                      and ld_ref = tmp_ref and ld_part = tmp_part no-lock:
                                          v_qty_oh = v_qty_oh + ld_qty_oh .
                                      end.

 
                                      if v_qty <= v_qty_oh then do:
        
        
                                          for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                              delete sr_wkfl.
                                          end.
                
                                          create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                          assign sr_userid = mfguser
                                                sr_lineid = string(j) + "::" + tmp_part
                                                sr_site = tmp_site
                                                sr_loc = tmp_loc
/*tx01*                                         sr_lotser = tmp_lot */
/*tx01*/                                        sr_lotser = string(string(tmp_lot,"x(18)") + string(tmp_q1bc,"x(18)") )
                                                sr_qty = v_qty 
                                                sr_ref = tmp_ref
                                                sr_user1 = v_nbr.
                                                sr_rev = loc_to.
                                                sr_user2 = tmp_part.
                                          if recid(sr_wkfl) = -1 then .
					  
                                            from_expire = ?.
                                            from_date = ?.
                                            from_assay = 0.
                                            from_grade = "".
                                            global_part = tmp_part .
        
                                            find first ld_det where ld_det.ld_domain = global_domain and  ld_part = tmp_part
/*tx01*                                        and ld_site = tmp_site and ld_loc = tmp_loc and ld_lot = tmp_lot and ld_ref = tmp_ref  no-lock no-error. */
/*tx01*/                                       and ld_site = tmp_site and ld_loc = tmp_loc and ld_lot = tmp_q1bc and ld_ref = tmp_ref  no-lock no-error.
                                            if available ld_det then do:
                                            assign
                                                from_status = ld_status
                                                from_expire = ld_expire
                                                from_date = ld_date
                                                from_assay = ld_assay
                                                from_grade = ld_grade.
                                            end.
        
                                            find first ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = tmp_part
/*tx01*                                        and ld_site = tmp_site and ld_loc = loc_to and ld_lot = tmp_lot and ld_ref = tmp_ref no-error. */
/*tx01*/                                       and ld_site = tmp_site and ld_loc = loc_to and ld_lot = sr_lotser and ld_ref = tmp_ref no-error.
                                            if not available ld_det then do:
                                                create ld_det. ld_det.ld_domain = global_domain.
                                                assign
                                                ld_site = tmp_site
                                                ld_loc = loc_to
                                                ld_part = tmp_part
                                                ld_lot = sr_lotser
                                                ld_ref = sr_ref.
					
                                                if recid(ld_det) = -1 then .
        
                                                find loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and loc_site = ld_site  and loc_loc = ld_loc no-error.
                                                if available loc_mstr then ld_status = loc_status.
                                                else do:
                                                    find si_mstr no-lock  where si_mstr.si_domain = global_domain and si_site = ld_site no-error.
                                                    if available si_mstr then ld_status = si_status.
                                                end.
                                            end. /* not available ld_det */
        
                                            if from_expire <> ? then ld_expire = from_expire.
                                            if from_date <> ? then ld_date = from_date.
                                            ld_assay = from_assay.
                                            ld_grade = from_grade.

                                          find pt_mstr where pt_domain = global_domain and pt_part = tmp_part no-lock no-error.
                                          {gprun.i ""icedit.p""
                                                   "(""RCT-TR"",
                                                     tmp_site,
                                                     loc_to,
                                                     pt_part,
                                                     tmp_q1bc,
                                                     tmp_ref,
                                                     v_qty,
                                                     pt_um,
                                                     v_nbr,
                                                     j,
                                                     output undo-input)"}

					  if undo-input then undo , retry.

                                          {gprun.i ""icedit.p""
                                                   "(""ISS-TR"",
                                                     tmp_site,
                                                     tmp_loc,
                                                     pt_part,
                                                     tmp_lot,
                                                     tmp_ref,
                                                     v_qty,
                                                     pt_um,
                                                     v_nbr,
                                                     j,
                                                     output undo-input)"}
						     
                                          if undo-input then undo , retry.        
        
                                          {gprun.i ""icxfer.p""
                                             "("""",
                                               sr_lotser,
                                               sr_ref,
                                               sr_ref,
                                               sr_qty,
                                               v_nbr,
                                               """",
                                               """",
                                               """",
                                               effdate,
                                               tmp_site,
                                               tmp_loc,
                                               tmp_site,
                                               loc_to,
                                               no,
                                               """",
                                               ?,
                                               """",
                                               0,
                                               """",
                                               output glcost,
                                               output iss_trnbr,
                                               output rct_trnbr,
                                               input-output from_assay,
                                               input-output from_grade,
                                               input-output from_expire)"
                                             }
        
                                          find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                          if avail tr_hist then  assign tr_addr = tmp_loc .  /*写入转出库位*/
                                          find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                          if avail tr_hist then  assign tr_addr = tmp_loc .   /*写入转出库位*/
        
                                         /*    leave v1300l . */
        
                                      end.
                                      else do:
                                          run xxmsg01.p (input 0 , input  "有效库存不足,转移失败" ,input yes )  . 
                                          undo mainloop ,retry mainloop .
                                      end.
                                  end.  /*if last-of(tmp_part) then*/
                              end. /*for each tmpkb */

                              for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part :
                                  
/*tx01*                           find xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = tmp_type and xkb_kb_id = tmp_id and xkb_part = tmp_part exclusive-lock no-error . */
/*tx01*/                          find first xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = "M"
/*tx01*/                              and (xkb_type + xkb_part + string(xkb_kb_id,"999")) = tmp_bc  no-error .
 
                                  if avail xkb_mstr then do:
                                      assign xkb_loc = loc_to
/*tx01*/                                     xkb_cust = tmp_cust
/*tx01*/                                     xkb_q1bc = tmp_q1bc
/*tx01*/                                     xkb_nbr = tmp_nbr
/*tx01*/                                     xkb_line = tmp_ln
                                             xkb_upt_date = today .
                                      find last tr_hist where tr_domain = global_domain and tr_type = "RCT-TR" and tr_nbr = v_nbr and tr_part = xkb_part and tr_effdate = effdate no-lock no-error.
                                      v_trnbr = if avail tr_hist then tr_trnbr else 0 .
                                      {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit035.p'"
                                                &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
                                                &b_status="xkb_status"       &c_status="xkb_status"
                                                &rain_qty="xkb_kb_raim_qty"}
        
                                  end.
                              end.

                              for each tmpkb:
                                  delete tmpkb .
                              end.

                              j = 0 .
/********************* start  tx01**********************/                                
                              bc = 0.
			      
                              for each temp1 :
		                 
                                  find first xxbcd_hist where xxbcd_domain = global_domain
	                                
                                  and xxbcd_part = t1_part and xxbcd_cust = t1_cust
	                                
                                  and xxbcd_serial = t1_serial  /* and xxbcd_stat = "A" */ no-error.
	                         
                                  if available xxbcd_hist then
                                    
                                  assign 
 	                               
                                  xxbcd_trans = Yes				    
				       
                                  xxbcd_stat = "R"
                                       
                                  xxbcd_effdate = today
	                               
                                  xxbcd_fgloc = t1_loc_to
                                       
                                  xxbcd_rcvnbr = t1_nbr.
			         
			         
                                  delete temp1.
			      
                              end.

/********************* end tx01**********************/  
                              
                              run xxmsg01.p (input 0 , input  "入库已完成" ,input yes )  .  /*xp003*/


                         
                         end.  /*  if v1400 then   */
                         else do:
                                L14006 = "是否退出?" . 
                                display L14006          format "x(40)" skip with fram F1400 no-box.
                                Update V1400   WITH  fram F1400 no-label .
                                if v1400 then do:
                                    for each tmpkb:
                                          delete tmpkb .
                                    end.
				    
                                    run xxmsg01.p (input 0 , input  "请先刷Q1条码再刷看板条码.." ,input yes )  . 
                                    undo mainloop ,retry mainloop.
                                end.
                                else do :
                                    run xxmsg01.p (input 0 , input  "请继续刷读.." ,input yes )  . 
                                    undo v1300l,retry v1300l .
                                end.

                         end.
                    
                        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
                        pause 0.
                        
                        display  "" @ WMESSAGE NO-LABEL with fram F1400.
                        pause 0.
                        leave V1400L.
                    END.  /* END 1400    */   


                  
          end.   /*  if v1300 = "" */       


        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.

     END.  /* END 1300   */
end. /**MAINLOOP**/



