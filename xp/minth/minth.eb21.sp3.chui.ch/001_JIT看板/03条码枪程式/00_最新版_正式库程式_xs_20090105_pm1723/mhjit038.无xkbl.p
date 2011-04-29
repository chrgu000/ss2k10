/* xsship01.p   Ford shippment                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 08/17/06   BY: tommy                         */
      
define shared variable execname as character .  execname = "mhjit038.p".
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




define var v_qty like xkb_kb_qty .
define var v_qty_ls like xkb_kb_qty .  /*正常领料单*/
define var v_qty_ly like xkb_kb_qty .  /*异常领料单*/
define var v_qty_oh like ld_qty_oh .
define var v_qty_iss like ld_qty_oh .
define var v_me_qty like xmpt_me_qty .
define var v_raim_qty  like xkb_kb_raim_qty .

define variable i as integer .
define variable j as integer .

define var v_nbr like xdn_next .
define var v_nbr_ly like xdn_next .
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var effdate as date .
define var v_yn as logical format "Y/N" initial yes .
define var v_comb like xppt_comb initial no .
define var v_par like xkb_par .
define var v_part like xkb_part .
define var v_loc like ld_loc .
/* define var site like xkb_site . */

define var sn_from as char format "x(40)" .
define var sn_to   as char format "x(40)" .
define var recno_from  as   recid.
define var recno_to    as   recid.
define var site_from like ld_site .
define var site_to   like ld_site .
define var loc_from  like ld_loc .
define var loc_to    like ld_loc .
define var lot_from  like ld_lot .
define var lot_to    like ld_lot .
define var ref_from  like ld_ref .
define var ref_to    like ld_ref .

define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define new shared variable transtype as character format "x(7)" initial "ISS-TR".


{gldydef.i new}
{gldynrm.i new}


define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb 
    field tmp_id   like xkb_kb_id
    field tmp_type like xkb_type
    field tmp_part like xkb_part
    field tmp_par  like xkb_par 
    field tmp_site like xkb_site
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_qty_ly  like xkb_kb_qty
    field tmp_qty_ls  like xkb_kb_qty.

define temp-table pkb 
    field pkb_id   like xkb_kb_id
    field pkb_type like xkb_type
    field pkb_part like xkb_part
    field pkb_site like xkb_site
    field pkb_loc  like xkb_loc
    field pkb_lot  like xkb_lot
    field pkb_ref  like xkb_ref 
    field pkb_qty  like xkb_kb_qty.


find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[看板刷读领料]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).




MAINLOOP:
REPEAT: 

    V1000L:
    REPEAT:
        
        hide all.
        define variable V1000           as date no-undo .
        define variable L10001          as char format "x(40)".
        define variable L10002          as char format "x(40)".
        define variable L10003          as char format "x(40)".
        define variable L10004          as char format "x(40)".
        define variable L10005          as char format "x(40)".
        define variable L10006          as char format "x(40)".
        
        display dmdesc format "x(40)" skip with fram F1000 no-box.
        
        v_nbr = "" .
        v_nbr_ly = "" .
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
        site_from = if avail icc_ctrl then icc_site else global_site .
    
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site_from) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                disp  "看板模块没有开启" @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
            end.
        end.
    
        /* v_nbr */
        find first rpc_ctrl  where rpc_ctrl.rpc_domain = global_domain no-lock no-error .
        if avail rpc_ctrl then do: 
            if length(string(rpc_nbr)) > 6 then do:
                disp  "错误:领料单号超过6位"  @ WMESSAGE NO-LABEL with fram F1000.
                undo, retry  .   /* 18.22.24 */
            end.
            v_nbr  = "LS" +  string(rpc_nbr ,"999999")  .
            find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
            if avail tr_hist then do:
                repeat:
                    v_nbr = "LS" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .
                    find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
                    if not avail tr_hist then leave .
                end.
            end.
        end.
        else do:
                disp  "错误:无领料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.
    
        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "LY" no-lock no-error.
        if avail xdn_ctrl then do:
            v_nbr_ly  = "LY" + string(xdn_next,"999999")  .
            find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr_ly no-lock no-error .
            if avail tr_hist then do:
                repeat:
                    v_nbr_ly = "LY" + string(inte(substring(v_nbr_ly , 3 , length(v_nbr_ly) - 2 )) + 1 ,"999999") .
                    find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr_ly no-lock no-error .
                    if not avail tr_hist then leave .
                end.
            end.
        end.
        else do:
                disp  "错误:无异常领料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.
        
        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        leave V1000L.
    END.  /* END 1000    */


    for each tmpkb:
        delete tmpkb .
    end.

    for each pkb:
        delete pkb .
    end.
    v_loc = "" .
    v_part = "". 
    j = 0 .

    hide all.
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .
    
    
     V1300L:
     REPEAT:
        hide all.
        define variable V1300           as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
    
        display dmdesc format "x(40)" skip with fram F1300 no-box.
    
        L13001 = "领料单号: " + v_nbr  .
        display L13001          skip with fram F1300 no-box.
        L13002 = "生效日期:" + string(effdate)  .  
        display L13002          format "x(40)" skip with fram F1300 no-box.
        L13003 = "张数: " + string(j).
        display L13003          format "x(40)" skip with fram F1300 no-box.
        L13004 = "" . 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        L13005 = "" .  
        display L13005          format "x(40)" skip with fram F1300 no-box.

        find first tmpkb no-lock no-error .
        L13006 = if avail tmpkb then "请继续刷读领料看板." else "请刷读领料看板." . 
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
              v_par = "".
    
              if v13001 <> "L" then do:
                    disp "错误:非领料看板,请重新刷读." @ WMESSAGE NO-LABEL with fram F1300. 
                    pause 0.
                    undo, retry.
              end.

              find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                            and ( /*xkb_status = "U"  or*/ xkb_status = "A" )  no-error .
              if not avail xkb_mstr then do:
                  disp "错误:无看板记录,或非A状态." @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0.
                  undo, retry.
              end.
              else do:  /* 检查限制 */

                    find first tmpkb  no-lock no-error .
                    if not avail tmpkb then do:  /*first record */
                        v_part = xkb_part .

                        /*检查 v_me_qty & v_comb */
/************************************************************************************************************************  */
                        v_comb = no .
                        v_me_qty = 0 .
                        find first xmpt_mstr where xmpt_domain  = global_domain and xmpt_site = xkb_site and xmpt_part = v_part no-lock no-error .
                        if avail xmpt_mstr and xmpt_me_qty <> 0 then do:
                            v_me_qty = xmpt_me_qty .
                        end.
                        else do:
                            find first xppt_mstr where xppt_domain  = global_domain and xppt_site = xkb_site and xppt_part = v_part no-lock no-error .
                            if avail xppt_mstr and xppt_me_qty <> 0 then do:
                                v_me_qty = xppt_me_qty .
                            end.
                            else do:
                                disp "错误:无领料看板大小设定." @ WMESSAGE NO-LABEL with fram F1300.
                                pause 0.
                                undo, retry.
                            end.
                        end.
                        v_comb = if avail xmpt_mstr then xmpt_comb else (if avail xppt_mstr then xppt_comb else no ) .
                    end.  /*first record */
                    
                    if v_part <> xkb_part then do:
                        disp "错误:限相同零件,请重新刷读." @ WMESSAGE NO-LABEL with fram F1300. 
                        pause 0.
                        undo, retry.
                    end.



                    find first tmpkb where tmp_site = xkb_site and tmp_type = xkb_type 
                                     and tmp_part = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                    if avail tmpkb then do:
                         display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                         pause 0 .
                         undo v1300l, retry v1300l.
                    end.
                    else do:   /*only once */

                        find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par  
                             and ro_start <= effdate and (ro_end >= effdate or ro_end = ? ) no-lock no-error.
                        if not avail ro_det then do:
                              disp "看板父件无有效工艺设定" @ WMESSAGE NO-LABEL with fram F1300. 
                              pause 0.
                              undo, retry.
                        end.
                        else do:    /*v_par*/

                            find first tmpkb where  tmp_loc <> ro_wkctr no-lock no-error .
                            if avail tmpkb then do:
                                 display  "仅限同库位:" + string(tmp_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                                 pause 0 .
                                 undo v1300l, retry v1300l.                        
                            end.

                            if v_loc <> "" and v_loc <> ro_wkctr then do:
                                disp "仅限同库位:" + string(v_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1300. 
                                pause 0.
                                undo, retry.
                            end.
/* ****************************************************************************************************** */
            v_qty_ls = v_me_qty .
            v_qty_ly = 0 .
            create tmpkb .
            assign  tmp_id = xkb_kb_id 
                    tmp_part  = xkb_part 
                    tmp_type  = "L"
                    tmp_par  = xkb_par
                    tmp_site  = xkb_site 
                    tmp_loc   = ro_wkctr   
                    tmp_qty_ls = v_qty_ls
                    tmp_qty_ly = v_qty_ly . 
            j = j + 1 .

    
/* ****************************************************************************************************** */
                        end.   /*v_par*/
                    end. /*only once */
              end. /* 检查限制 */
    
        end. /*  if v1300 <> "" */
        else do:  /*转出看板loop*/

            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "请先刷读看板才可执行"   @ WMESSAGE NO-LABEL with fram F1300. 
                pause 0 .
                undo ,retry .
            end.


            /* message "料号:" v_part view-as alert-box . */

            v_qty = 0 .    /*领料总数*/
            v_qty_iss = 0 .     /*发料总数*/
            for each tmpkb no-lock :
                v_qty = v_qty  + tmp_qty_ly + tmp_qty_ls  .
            end.


             V1100L:
             REPEAT:


                hide all no-pause .
                define variable V1100           as char format "x(40)" .
                define variable L11001          as char format "x(40)".
                define variable L11002          as char format "x(40)".
                define variable L11003          as char format "x(40)".
                define variable L11004          as char format "x(40)".
                define variable L11005          as char format "x(40)".
                define variable L11006          as char format "x(40)".
        
        
                display dmdesc format "x(40)" skip with fram F1100 no-box.
        
                L11001 = "领料单号: " + v_nbr .
                display L11001          skip with fram F1100 no-box.
                find first tmpkb where tmp_qty_ly > 0 no-lock no-error .
                L11002 = if avail tmpkb then ("超领单号: " + v_nbr_ly) else ""  . 
                display L11002          format "x(40)" skip with fram F1100 no-box.
                L11003 = "生效日期: " + string(effdate) . 
                display L11003          format "x(40)" skip with fram F1100 no-box.
                L11004 = "领料总数: " + string(v_qty) . 
                display L11004          format "x(40)" skip with fram F1100 no-box.
                L11005 = "累计待发料数: " + string(v_qty_iss) . 
                display L11005          format "x(40)" skip with fram F1100 no-box.
                find first pkb no-lock no-error .
                L11006 = if avail pkb then "继续刷读或直接确认执行." else "请刷读采购或生产看板." . 
                display L11006          format "x(40)" skip with fram F1100 no-box.
                
        	    V1100 = "" .
        
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
        
                if v1100 <> ""  then do:
                    if v1100 = "e" then leave mainloop.
                    
                    v13001 = substring(v1100,1,1) .  /* xkb_type*/
                    v13002 = substring(v1100,2,length(v1100) - 4 ) .  /* xkb_part*/
                    v13003 = substring(v1100,length(v1100) - 2 ,3) .    /* xkb_kb_id */
                    
                    if (v13001 <> "M" and v13001 <> "P" ) then do:
                        disp "错误:仅限半成品看板或采购看板." @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        undo, retry.
                    end.
            
                    if v13002 <> v_part then do:
                        disp "错误:仅限与领料看板同零件的看板." @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        undo, retry.            
                    end.
            
                    find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                                   and xkb_kb_raim_qty > 0 and xkb_status = "U" no-lock no-error .
                    if not avail xkb_mstr then do:
                        disp "错误:无看板记录,或非(U)状态." @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        undo, retry.
                    end.
                    else do:  /*if avail xkb_mstr */
                        if xkb_kb_raim_qty = 0 then do:
                            disp "刷读失败:看板余量为零." @ WMESSAGE NO-LABEL with fram F1100.
                            pause 0.
                            undo, retry.
                        end.

                        find first pkb where ( pkb_loc <> xkb_loc or pkb_lot <> xkb_lot or pkb_ref <> xkb_ref ) no-lock no-error .
                        if avail pkb then do:
                             display  "限同库位/批序,请重新输入" @ WMESSAGE NO-LABEL with fram F1100.
                             pause 0 .
                             undo v1100l, retry v1100l.
                        end.
    
                        find first pkb where pkb_site = xkb_site and pkb_type = xkb_type 
                                         and pkb_part = xkb_part and pkb_id = xkb_kb_id no-lock no-error .
                        if avail pkb then do:
                             display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1100.
                             pause 0 .
                             undo v1100l, retry v1100l.
                        end.

                        for each ld_det where ld_domain = global_domain and ld_site = xkb_site and ld_part = xkb_part 
                                        and ld_loc = xkb_loc and ld_lot = xkb_lot and ld_ref = xkb_ref and ld_qty_oh > 0 no-lock:
                            v_qty_oh = v_qty_oh + ld_qty_oh .
                        end.
                        
                        if v_qty_oh < xkb_kb_raim_qty then do:
                            disp "有效库存(" + string(v_qty_oh) + ")小于看板余量" @ WMESSAGE NO-LABEL with fram F1100.
                            pause 0.
                            undo, retry.
                        end.
                        else do: /*if v_qty_oh >= xkb_kb_raim_qty */
                             create pkb .
                             assign pkb_id = xkb_kb_id 
                                pkb_part  = xkb_part 
                                pkb_type  = xkb_type
                                pkb_site  = xkb_site 
                                pkb_loc   = xkb_loc   
                                pkb_lot   = xkb_lot
                                pkb_ref   = xkb_ref 
                                pkb_qty   = xkb_kb_raim_qty 
                                v_qty_iss = v_qty_iss + xkb_kb_raim_qty .    

                                site_from = xkb_site .
                                loc_from = xkb_loc .
                                lot_from = xkb_lot .
                                ref_from = xkb_ref .

                            
                        end. /*if v_qty_oh >= xkb_kb_raim_qty */
                    end.  /*if avail xkb_mstr */                    
                end.  /*if v1100 <> ""  then */
                else do :   /*if v1100 = ""  then */

                    if v_qty > v_qty_iss then do:
                        disp "累计发料数不足:" + string(v_qty_iss)  @ WMESSAGE NO-LABEL with fram F1100.
                        pause 2 .
                        
                        disp "按累计发料数领料(Y/N)?"  @ L11006 NO-LABEL with fram F1100.
                        v1100 = "" .
                        update v1100 with frame f1100 .
                        repeat:
                              if not ( v1100 = "Y" or v1100 = "N" ) then do:
                                   disp "仅限输入'Y'或者'N'..."   @ WMESSAGE NO-LABEL with fram F1100.
                                   disp "按累计发料数领料(Y/N)?"   @ l11006 NO-LABEL with fram F1100.
                                   update v1100 with frame f1100 .
                              end.
                              else leave .
                        end.
                        if v1100 = "N" then undo ,retry .
                        
                        for each tmpkb exclusive-lock:
                            if v_qty_iss < 0 then assign tmp_qty_ly = 0  tmp_qty_ls = 0 .
    
                            if tmp_qty_ls <> 0 then do :
                                        assign tmp_qty_ls = min(tmp_qty_ls,v_qty_iss) .
                                        v_qty_iss = v_qty_iss - tmp_qty_ls .
                            end.
                            if tmp_qty_ly <> 0 then do :
                                        assign tmp_qty_ly = min(tmp_qty_ly,v_qty_iss) .
                                        v_qty_iss = v_qty_iss - tmp_qty_ly .
                            end.
                        end.
                    end. /* if v_qty > v_qty_iss */
                    else 
                        v_qty_iss = v_qty .
 
                        
                        V1500L:
                        REPEAT:
                                                                                                               
                            define buffer tmpkb2 for tmpkb .

                            hide all no-pause .
                            define variable V1500           as logical .
                            define variable L15001          as char format "x(40)".
                            define variable L15002          as char format "x(40)".
                            define variable L15003          as char format "x(40)".
                            define variable L15004          as char format "x(40)".
                            define variable L15005          as char format "x(40)".
                            define variable L15006          as char format "x(40)".
            
                            display dmdesc format "x(40)" skip with fram F1500 no-box.
            
                            L15001 = "" .
                            display L15001          skip with fram F1500 no-box.
                            L15002 = ""  .
                            display L15002          format "x(40)" skip with fram F1500 no-box.
                            L15003 = ""  .
                            display L15003          format "x(40)" skip with fram F1500 no-box.
                            L15004 = "" .
                            display L15004          format "x(40)" skip with fram F1500 no-box.
                            L15005 = "" .
                            display L15005          format "x(40)" skip with fram F1500 no-box.
                            L15006 = "执行领料 ? " .
                            display L15006          format "x(40)" skip with fram F1500 no-box.
            
                            v1500 = yes .
            
                            Update V1500   WITH  fram F1500 no-label EDITING:
                                readkey pause wtimeout.
                                if lastkey = -1 then quit.
                                if LASTKEY = 404 Then Do: /* DISABLE F4 */
                                    pause 0 before-hide.
                                    undo, retry.
                                end.
                                display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
                                APPLY LASTKEY.
                            END.
                            display  skip WMESSAGE NO-LABEL with fram F1500.
            
                            if v1500 then do:
                                for each tmpkb where tmp_qty_ls > 0 or tmp_qty_ly > 0 no-lock 
                                    break by tmp_site by tmp_loc by tmp_par by tmp_lot by tmp_ref :

                                    if first-of(tmp_ref) then do:
                                        assign site_to = tmp_site 
                                               loc_to = tmp_loc 
                                               v_par = tmp_par 
                                               lot_to = lot_from 
                                               ref_to = ref_from .
                                               v_qty_ls = 0 .
                                               v_qty_ly = 0 .
                                    end.

                                   v_qty_ls = v_qty_ls +  tmp_qty_ls .
                                   v_qty_ly = v_qty_ly +  tmp_qty_ly .

                                   if last-of(tmp_ref) then do:
                       

                                          /*产生正常领料库存交易记录*/
                                          if v_qty_ls > 0 then do:
                                                for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                                          delete sr_wkfl.
                                                end.
                
                                                create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                                assign  sr_userid = mfguser
                                                        sr_lineid = string(1) + "::" + v_part
                                                        sr_site = site_from
                                                        sr_loc = loc_from
                                                        sr_lotser = string(string(lot_from,"x(18)") + string(lot_to,"x(18)") )
                                                        sr_qty = v_qty_ls
                                                        sr_ref = ref_from
                                                        sr_user1 = v_nbr
                                                        sr_rev = loc_to
                                                        sr_user2 = v_part.
                                                if recid(sr_wkfl) = -1 then .
            
            
                                                from_expire = ?.
                                                from_date = ?.
                                                from_assay = 0.
                                                from_grade = "".
                                                global_part = v_part .
            
                                                find ld_det where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                            and ld_site = site_from and ld_loc = loc_from and ld_lot = lot_from and ld_ref = ref_from  no-lock no-error.
                                                if available ld_det then do:
                                                assign
                                                    from_status = ld_status
                                                    from_expire = ld_expire
                                                    from_date = ld_date
                                                    from_assay = ld_assay 
                                                    from_grade = ld_grade.
                                                end.
                                                
                                                find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                            and ld_site = site_to and ld_loc = loc_to and ld_lot = lot_to and ld_ref = ref_to no-error.
                                                if not available ld_det then do:
                                                    create ld_det. ld_det.ld_domain = global_domain.
                                                    assign
                                                    ld_site = site_to
                                                    ld_loc = loc_to
                                                    ld_part = v_part
                                                    ld_lot = lot_to
                                                    ld_ref = ref_to .
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
            
                                              {gprun.i ""icxfer.p""
                                                 "("""",
                                                   sr_lotser,
                                                   ref_from,
                                                   ref_to,
                                                   sr_qty,
                                                   v_nbr,
                                                   """",
                                                   """",
                                                   """",
                                                   effdate,
                                                   site_from,
                                                   loc_from,
                                                   site_to,
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
                                              
                                                   /*disp  string(iss_trnbr) + " " + string(rct_trnbr)  @ l21003 with frame f2100 no-box .  pause . */
            
                                              j = 1 .
                                              find pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
                                              {gprun.i ""icedit.p""
                                                       "(""RCT-TR"",
                                                         site_to,
                                                         loc_to,
                                                         pt_part,
                                                         lot_to,
                                                         ref_to,
                                                         v_qty_ls,
                                                         pt_um,
                                                         v_nbr,
                                                         j,
                                                         output undo-input)"}
                                              if undo-input then undo , retry.
                                              find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                              if avail tr_hist then  assign tr_addr = loc_to tr_rmks = v_par .
                                              j = 2 .
                                              {gprun.i ""icedit.p""
                                                       "(""ISS-TR"",
                                                         site_from,
                                                         loc_from,
                                                         pt_part,
                                                         lot_from,
                                                         ref_from,
                                                         v_qty_ls,
                                                         pt_um,
                                                         v_nbr,
                                                         j,
                                                         output undo-input)"}
                                              if undo-input then undo , retry.
                                              find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                              if avail tr_hist then  assign tr_addr = loc_to tr_rmks = v_par  .
                                          end.
                                         /*产生正常领料库存交易记录*/
        
                                          /*产生超领料库存交易记录*/ 
                                          if v_qty_ly > 0 then do:
                                                for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                                          delete sr_wkfl.
                                                end.
                
                                                create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                                assign  sr_userid = mfguser
                                                        sr_lineid = string(1) + "::" + v_part
                                                        sr_site = site_from
                                                        sr_loc = loc_from
                                                        sr_lotser = lot_from
                                                        sr_qty = v_qty_ly
                                                        sr_ref = ref_from
                                                        sr_user1 = v_nbr_ly.
                                                        sr_rev = loc_to.
                                                        sr_user2 = v_part.
                                                if recid(sr_wkfl) = -1 then .
                
                                                /* disp sr_lineid @ l21002 with frame f2100 no-box .  pause . */
                
                
                                                    from_expire = ?.
                                                    from_date = ?.
                                                    from_assay = 0.
                                                    from_grade = "".
                                                    global_part = v_part .
                
                                                    find ld_det where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                                and ld_site = site_from and ld_loc = loc_from and ld_lot = lot_from and ld_ref = ref_from  no-lock no-error.
                                                    if available ld_det then do:
                                                    assign
                                                        from_status = ld_status
                                                        from_expire = ld_expire
                                                        from_date = ld_date
                                                        from_assay = ld_assay 
                                                        from_grade = ld_grade.
                                                    end.
                                                    
                                                    find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = v_part
                                                                and ld_site = site_to and ld_loc = loc_to and ld_lot = lot_to and ld_ref = ref_to no-error.
                                                    if not available ld_det then do:
                                                        create ld_det. ld_det.ld_domain = global_domain.
                                                        assign
                                                        ld_site = site_to
                                                        ld_loc = loc_to
                                                        ld_part = v_part
                                                        ld_lot = lot_to
                                                        ld_ref = ref_to .
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
                
                                                  j = 1 .
                                                  find pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
                                                  {gprun.i ""icedit.p""
                                                           "(""RCT-TR"",
                                                             site_to,
                                                             loc_to,
                                                             pt_part,
                                                             lot_to,
                                                             ref_to,
                                                             v_qty_ly,
                                                             pt_um,
                                                             v_nbr_ly,
                                                             j,
                                                             output undo-input)"}
                                                  if undo-input then undo , retry.

        
                                                  j = 2 .
                                                  {gprun.i ""icedit.p""
                                                           "(""ISS-TR"",
                                                             site_from,
                                                             loc_from,
                                                             pt_part,
                                                             lot_from,
                                                             ref_from,
                                                             v_qty_ly,
                                                             pt_um,
                                                             v_nbr_ly,
                                                             j,
                                                             output undo-input)"}
                                                  if undo-input then undo , retry.
                                                    
                                                    
                                                    {gprun.i ""icxfer.p""
                                                     "("""",
                                                       sr_lotser,
                                                       ref_from,
                                                       ref_to,
                                                       sr_qty,
                                                       v_nbr_ly,
                                                       """",
                                                       """",
                                                       """",
                                                       effdate,
                                                       site_from,
                                                       loc_from,
                                                       site_to,
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
                                                  
                                                  /*disp  string(iss_trnbr) + " " + string(rct_trnbr)  @ l21003 with frame f2100 no-box .  pause . */       
                                                  find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                                  if avail tr_hist then  assign tr_addr = loc_to  tr_rmks = v_par .
                                                  find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                                  if avail tr_hist then  assign tr_addr = loc_to  tr_rmks = v_par .
                                          end.  /*产生超领料库存交易记录*/

                                           /*领料 */
                                          for each tmpkb2 where tmpkb2.tmp_id = tmpkb.tmp_id and tmpkb2.tmp_site =tmpkb.tmp_site 
                                              and tmpkb2.tmp_loc = tmpkb.tmp_loc and tmpkb2.tmp_lot =tmpkb.tmp_lot and tmpkb2.tmp_ref = tmpkb.tmp_ref no-lock :
                                                   
                                                    find xkb_mstr where xkb_domain = global_domain and xkb_site =  tmpkb2.tmp_site and xkb_part =  tmpkb2.tmp_part 
                                                                  and xkb_type = "L" and xkb_kb_id =  tmpkb2.tmp_id  no-error.
                                                    if avail xkb_mstr then do : 
                                                        assign  xkb_upt_date = today    xkb_loc = loc_to  xkb_lot = lot_to  xkb_ref = ref_to  .
                                                        
                                                        v_trnbr = rct_trnbr .
                                                        {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="xkb_status"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                    end.
                                          end.

                                            /*发料 */
                                            v_qty = v_qty_ls + v_qty_ly .
                                            for each pkb where pkb_qty > 0 exclusive-lock :
                                                    if v_qty <= 0 then next .
                                                    find xkb_mstr where xkb_domain = global_domain and xkb_site = pkb_site 
                                                         and xkb_type = pkb_type and xkb_part = pkb_part and xkb_kb_id = pkb_id  no-error .
                                                    v_raim_qty = if avail xkb_mstr then xkb_kb_raim_qty else  0.
                                                    if avail xkb_mstr then do:
/* message xkb_kb_raim_qty v_qty view-as alert-box . */
                                                        
                                                        xkb_kb_raim_qty =  if v_qty > xkb_kb_raim_qty  then 0 else xkb_kb_raim_qty - v_qty  .
                                                        xkb_upt_date = today .
                                                        v_qty = v_qty - v_raim_qty  . 
                                                        pkb_qty = xkb_kb_raim_qty .
                                                        
            
                                                        v_trnbr = rct_trnbr .
                                                        {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                                    &b_status="xkb_status"       &c_status="xkb_status"
                                                                    &rain_qty="xkb_kb_raim_qty"}
            
                                                        if xkb_kb_raim_qty = 0 then do:
                                                             {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                                    &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit038.p'"
                                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr=v_trnbr
                                                                    &b_status="'U'"       &c_status="'A'"
                                                                    &rain_qty="xkb_kb_raim_qty"}
                                                        end.
                                                    end.
                                            end.  /* for each pkb */
                                       
                                   end. /* if last-of(tmp_ref) then */  
                                end.  /*  for each tmpkb */


                                for each tmpkb :
                                    delete tmpkb .
                                end.
                                for each pkb :
                                    delete pkb .
                                end.


                            end.  /*if v1500 then do: */
                            else undo mainloop,retry mainloop .
            
                            display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
                            pause 0.
            
                            display  "" @ WMESSAGE NO-LABEL with fram F1500.
                            pause 0.
                            leave V1100L.
                        END.  /* END 1500    */
    

                end.  /*if v1100 = ""  then */
        
                display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
                pause 0.
        
                display  "" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0.
                
             END.   /* END 1100 */  
        end.  /*转出看板loop*/


        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
    
        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        
     end.  /* END 1300   */



/*      leave mainloop . */
end. /**MAINLOOP**/


find first rpc_ctrl  where rpc_ctrl.rpc_domain = global_domain exclusive-lock no-error .
if avail rpc_ctrl then do: 
    find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
    if avail tr_hist then do:
        repeat:
            v_nbr = "LS" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .
            find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
            if not avail tr_hist then leave .
        end.
    end.
    rpc_nbr = (inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) ) .
end.


find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "LY" exclusive-lock no-error.
if avail xdn_ctrl then do:
    find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr_ly no-lock no-error .
    if avail tr_hist then do:
        repeat:
            v_nbr_ly = "LY" + string(inte(substring(v_nbr_ly , 3 , length(v_nbr_ly) - 2 )) + 1 ,"999999") .
            find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr_ly no-lock no-error .
            if not avail tr_hist then leave .
        end.
    end.
    xdn_next = string(inte(substring(v_nbr_ly , 3 , length(v_nbr_ly) - 2 )) ,"999999") .
end.
  
