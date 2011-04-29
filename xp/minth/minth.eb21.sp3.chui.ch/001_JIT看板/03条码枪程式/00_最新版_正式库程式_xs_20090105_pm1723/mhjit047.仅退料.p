/* xsship01.p   Ford shippment                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 08/17/06   BY: tommy                         */
      
define shared variable execname as character .  execname = "mhjit047.p".
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



define var v_line as integer .
define var v_qty like xkb_kb_qty .
define var v_qty_oh like ld_qty_oh .
define var v_me_qty like xmpt_me_qty .
define var v_fqty like xmpt_kb_fqty .
define var v_qty_firm as logical initial no .
define var v_raim_qty  like xkb_kb_raim_qty .

define variable i as integer .
define variable j as integer .

define var v_nbr like xdn_next .
define var v_nbr_ly like xdn_next .
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var effdate as date .
define var v_yn as logical format "Y/N" initial yes .
define var v_par like xkb_par .

define var sn_from as char format "x(40)" .
define var sn_to   as char format "x(40)" .
define var recno_from  as   recid.
define var recno_to    as   recid.
define var site like xkb_site .
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
    field tmp_line as integer 
    field tmp_io   as char 
    field tmp_id   like xkb_kb_id
    field tmp_part like xkb_part 
    field tmp_par  like xkb_par 
    field tmp_type like xkb_type
    field tmp_site like xkb_site
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_qty  like xkb_kb_qty.





find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[看板刷读退料]" + (if available dom_mstr then trim(dom_name) else "")
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
    
        find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "RT" no-lock no-error.
        if avail xdn_ctrl then do:
            v_nbr  = "RT" + string(xdn_next,"999999")  .
            find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
            if avail tr_hist then do:
                repeat:
                    v_nbr = "RT" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .
                    find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
                    if not avail tr_hist then leave .
                end.
            end.
        end.
        else do:
                disp  "错误:无退料单号控制档"  @ WMESSAGE NO-LABEL with fram F1000.
                pause 0.
                undo, retry  .
        end.
        
        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        leave V1000L.
    END.  /* END 1000    */


MAINLOOP:
REPEAT: 


    for each tmpkb:
        delete tmpkb .
    end.

    v_line = 1 .

    hide all no-pause .
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

       L11001 = "退料单号: " + v_nbr .
       display L11001          skip with fram F1100 no-box.
       L11002 = "生效日期: " + string(effdate)  . 
       display L11002          format "x(40)" skip with fram F1100 no-box.
       L11003 = "领料看板" + string(v_line) + " ?"  . 
       display L11003          format "x(40)" skip with fram F1100 no-box.
       L11004 = "" . 
       display L11004          format "x(40)" skip with fram F1100 no-box.
       L11005 = "" . 
       display L11005          format "x(40)" skip with fram F1100 no-box.
       L11006 = "请刷读或直接确认执行"  . 
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


       if  v1100 <> ""  then do :
           if v1100 = "e" then leave mainloop.
    
           v13001 = substring(v1100,1,1) .  /* xkb_type*/
           v13002 = substring(v1100,2,length(v1100) - 4 ) .  /* xkb_part*/
           v13003 = substring(v1100,length(v1100) - 2 ,3) .    /* xkb_kb_id */
    
           if (v13001 <> "L" ) then do:
               disp "错误:仅限领料看板." @ WMESSAGE NO-LABEL with fram F1100.
               pause 0.
               undo, retry.
           end.
    
           find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                           and ( /*xkb_status = "U" or*/  xkb_status = "A" )  no-lock no-error .
           if not avail xkb_mstr then do:
               disp "错误:无看板记录,或非有效状态." @ WMESSAGE NO-LABEL with fram F1100.
               pause 0.
               undo, retry.
           end.
           else do:  /*if avail xkb_mstr */
               recno_from = recid(xkb_mstr) .
               sn_from = v1100 .
               v_qty_oh = 0 .
               v_qty = 0 .


                find first tmpkb where  tmp_io = "out" and tmp_site = xkb_site and tmp_type = xkb_type 
                                 and tmp_part = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                if avail tmpkb then do:
                     display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1100.
                     pause 0 .
                     undo v1100l, retry v1100l.
                end.
                
/*                 find first tmpkb where  tmp_io = "out" and tmp_loc <> xkb_loc no-lock no-error .                   */
/*                 if avail tmpkb then do:                                                                            */
/*                      display  "仅限同库位:" + string(tmp_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1100. */
/*                      pause 2 .                                                                                     */
/*                      undo v1100l, retry v1100l.                                                                    */
/*                 end.                                                                                               */
    
               find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par 
                                 and ro_start <= effdate and (ro_end >= effdate or ro_end = ? ) no-lock no-error.
               if not avail ro_det then do:
                   disp "看板父件无有效工艺流程设定" @ WMESSAGE NO-LABEL with fram F1100. 
                   pause 0 .
                   undo , retry.
               end.
               else do:
                   site_from = xkb_site .
                   lot_from  = xkb_lot .
                   ref_from  = xkb_ref .
                   loc_from  = ro_wkctr .
               end.
    
               for each ld_det where ld_domain = global_domain and ld_site = site_from and ld_loc = loc_from and ld_part = xkb_part
                                and ld_lot = lot_from and ld_ref = ref_from and ld_qty_oh > 0 no-lock:
                   v_qty_oh = v_qty_oh + ld_qty_oh .
               end.
               
               v_qty = v_qty_oh .  
   /*  看板余量v_qty ??   ******************************************************  */ 
/*                find xmpt_mstr where xmpt_domain  =global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error . */
/*                if avail xmpt_mstr then do:                                                                                           */
/*                    if xmpt_kb_fqty <> 0 then v_qty  = ( v_qty_oh modulo xmpt_kb_fqty ).                                              */
/*                    else v_qty = v_qty_oh .                                                                                           */
/*                end.                                                                                                                  */
/*                else v_qty = v_qty_oh .                                                                                               */

               if v_qty = 0 then do:
                   disp "看板余量为0,请重新输入" @ WMESSAGE NO-LABEL with fram F1100. 
                   pause 0 .
                   undo , retry.                
               end.
    
               if v_qty_oh >= 0 then do: /*if v_qty_oh >= xkb_kb_raim_qty */
    
    
                    V1500L:
                    REPEAT:
    
                       hide all no-pause .
                       define variable V1500           like xkb_kb_raim_qty  .
                       define variable L15001          as char format "x(40)".
                       define variable L15002          as char format "x(40)".
                       define variable L15003          as char format "x(40)".
                       define variable L15004          as char format "x(40)".
                       define variable L15005          as char format "x(40)".
                       define variable L15006          as char format "x(40)".
    
    
                       display dmdesc format "x(40)" skip with fram F1500 no-box.
    
                       L15001 = "退料单号: " + v_nbr   .
                       display L15001          skip with fram F1500 no-box.
                       L15002 =  "领料看板: " + sn_from  . 
                       display L15002          format "x(40)" skip with fram F1500 no-box.
                       L15003 = "生效日期:" + string(effdate) . 
                       display L15003          format "x(40)" skip with fram F1500 no-box.
                       L15004 = "看板余量:" + string(v_qty ) . 
                       display L15004          format "x(40)" skip with fram F1500 no-box.
                       L15005 = "" . 
                       display L15005          format "x(40)" skip with fram F1500 no-box.
                       L15006 = "退料数量 ? " . 
                       display L15006          format "x(40)" skip with fram F1500 no-box.
    
                       V1500 =  0 .
    
                       Update V1500     WITH  fram F1500 NO-LABEL
                       /* ROLL BAR START */
                       EDITING:
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
    
                       if (v1500 <= 0 or v1500 > v_qty  ) then do:
                             display "不可超过看板库存余量,不可为零."  @ WMESSAGE NO-LABEL with fram F1500.
                             pause 0 .
                             undo ,retry .
                       end.
    
                       /*待转数量*/ 
                       v_qty =  v1500 .
    
    
                       display "...处理...  " @ WMESSAGE NO-LABEL with fram F1500.
                       pause 0.
    
                       display  "" @ WMESSAGE NO-LABEL with fram F1500.
                       pause 0.
                       leave V1500L.
    
                    END.   /* END 1500 */   

                    create tmpkb .
                    assign  tmp_line = v_line 
                            tmp_io = "out"
                            tmp_id = xkb_kb_id 
                            tmp_type = "L"
                            tmp_part = xkb_part
                            tmp_par = xkb_par 
                            tmp_site = xkb_site
                            tmp_loc = loc_from
                            tmp_lot = lot_from
                            tmp_ref = ref_from 
                            tmp_qty = v_qty .

    
                     V1300L:
                     REPEAT:     

                        hide all no-pause.
                        define variable V1300           as char format "x(40)".
                        define variable L13001          as char format "x(40)".
                        define variable L13002          as char format "x(40)".
                        define variable L13003          as char format "x(40)".
                        define variable L13004          as char format "x(40)".
                        define variable L13005          as char format "x(40)".
                        define variable L13006          as char format "x(40)".
                
                        display dmdesc format "x(40)" skip with fram F1300 no-box.
                
                        L13001 = "退料单号: " + v_nbr  .
                        display L13001          skip with fram F1300 no-box.
                        L13002 = "领料看板: " + sn_from  .  
                        display L13002          format "x(40)" skip with fram F1300 no-box.
                        L13003 = "生效日期:" + string(effdate).
                        display L13003          format "x(40)" skip with fram F1300 no-box.
                        L13004 ="退料数量: " + string(v_qty)  . 
                        display L13004          format "x(40)" skip with fram F1300 no-box.
                        L13005 = "" .  
                        display L13005          format "x(40)" skip with fram F1300 no-box.
                        L13006 =  "采购或生产看板" + string(v_line) + " ?"  .
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
                
                        if v1300 = sn_from or v1300 = "" then do:
                            display "不能为空,或与转出看板相同." @ WMESSAGE NO-LABEL with fram F1300.
                            pause 0  .
                            undo ,retry .
                        end.
                        
                        if v1300 <> "" then do:
                             if v1300 = "e" then leave mainloop.

                              v13001 = substring(v1300,1,1) .  /* xkb_type*/
                              v13002 = substring(v1300,2,length(v1300) - 4 ) .  /* xkb_part*/
                              v13003 = substring(v1300,length(v1300) - 2 ,3) .    /* xkb_kb_id */
    
                              if (v13001 <> "M" and v13001 <> "P" ) then do:
                                    disp "错误:非制造/采购看板,请重新刷读." @ WMESSAGE NO-LABEL with fram F1300. 
                                    pause 0.
                                    undo, retry.
                              end.
                              if v13002 <> substring(sn_from,2,length(sn_from) - 4 ) then do:
                                    disp "错误:转出/转入看板的零件需相同." @ WMESSAGE NO-LABEL with fram F1300. 
                                    pause 0.
                                    undo, retry.
                              end.
                
                              find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                                            and ( (xkb_status = "U" and xkb_kb_raim_qty > 0) or xkb_status = "A" )exclusive-lock no-error .
                              if not avail xkb_mstr then do:
                                  disp "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1300. 
                                  pause 0.
                                  undo, retry.
                              end.
                              else do:  /* 检查限制 */
                                    recno_to = recid(xkb_mstr) .
                                    sn_to =  v1300.

                                    find first tmpkb where  tmp_io = "in" and tmp_site = xkb_site and tmp_type = xkb_type 
                                                     and tmp_part = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                                    if avail tmpkb then do:
                                         display  "此看板已刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                                         pause 0 .
                                         undo , retry.
                                    end.
    
                                    if xkb_loc = "" then do:
                                        disp "此看板的库位为空,请输入" @ L13006 NO-LABEL with fram F1300. 
                                        pause 0.
                                        find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                                        v1300 = if avail pt_mstr then pt_loc else "" .
                                        update v1300 with frame F1300 .
                                        repeat:
                                            find first loc_mstr where loc_domain = global_domain and loc_loc =  v1300  no-lock no-error .
                                            if not avail loc_mstr  then do:
                                                   disp "无效库位,请重新输入" @ L13006 NO-LABEL with fram F1300.
                                                   find first pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
                                                   v1300 = if avail pt_mstr then pt_loc else "" .
                                                   update v1300 with frame F1300 .
                                            end.
                                            else leave .
                                        end.
                                        assign xkb_loc = v1300 .
                                    end.
    
                                    if xkb_status = "U" and (xkb_site <> site_from or xkb_loc <> loc_from or xkb_lot <> lot_from and xkb_ref <> ref_from ) then do:
                                          v1300 = "Y" .
                                          disp "批序号不一致,继续(Y/N)?" @ L13006 NO-LABEL with fram F1300.
                                          update v1300 with frame f1300 .
                                          repeat:
                                              if not ( v1300 = "Y" or v1300 = "N" ) then do:
                                                   disp "仅限输入'Y'或者'N'..." @ L13006 NO-LABEL with fram F1300.
                                                   pause 0.
                                                   disp "批序号不一致,继续(Y/N)?" @ L13006 NO-LABEL with fram F1300.
                                                   V1300 = "Y" .
                                                   update v1300 with frame f1300 .
                                              end.
                                              else leave .
                                          end.
                                          if v1300 = "N" then undo ,retry .
                                          if v1300 = "Y" then do:
                                              v1300 = "Y" .
                                              disp "批序号用转入看板的(Y/N) ?" @ L13006 NO-LABEL with fram F1300.
                                              update v1300 with frame f1300 .
                                              repeat:
                                                  if not ( v1300 = "Y" or v1300 = "N" ) then do:
                                                       disp "仅限输入'Y'或者'N'..." @ L13006 NO-LABEL with fram F1300.
                                                       pause 0.
                                                       V1300 = "Y" .
                                                       disp "批序号用转入看板的(Y/N) ?" @ L13006 NO-LABEL with fram F1300.
                                                       update v1300 with frame f1300 .
                                                  end.
                                                  else leave .
                                              end.
                                              if v1300 = "Y"  then assign site_to = xkb_site  loc_to = xkb_loc  lot_to = xkb_lot  ref_to = xkb_ref .
                                              if v1300 = "N"  then assign site_to = site_from loc_to = loc_from lot_to = lot_from ref_to = ref_from .
                                          end.  /*if v1300 = "Y" then */
                                    end.  /*if xkb_status = "U" */
                                    else do:
                                        v1300 =  loc_from .
                                        disp "请确认转入库位:"  @ L13006 NO-LABEL with fram F1300.
                                        update v1300 with frame F1300 no-box.
                                        assign site_to = site_from
                                               loc_to = v1300
                                               lot_to = lot_from 
                                               ref_to = ref_from .
                                    end.  /*if xkb_status <>  "U" */
                                    if  xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:
                                        if v13001 = "M" then do:
                                            find xmpt_mstr where xmpt_domain = global_domain and xmpt_site = xkb_site and xmpt_part = xkb_part no-lock no-error .
                                            v_fqty = if avail xmpt_mstr then xmpt_kb_fqty else 0  .
                                            v_qty_firm = if avail xmpt_mstr then xmpt_qty_firm else no .
                                        end.
                                        if v13001 = "P" then do:
                                            find xppt_mstr where xppt_domain = global_domain and xppt_site = xkb_site and xppt_part = xkb_part no-lock no-error .
                                            v_fqty = if avail xppt_mstr then xppt_kb_fqty else 0  .
                                            v_qty_firm = if avail xppt_mstr then xppt_qty_firm else no .
                                        end.
                                        if (xkb_kb_raim_qty + v_qty) > v_fqty then do:
                                            disp  "转移后将超过看板固定批量"   @ WMESSAGE NO-LABEL with fram F1300.
                                            pause 1 .
                                            if v_qty_firm then undo , retry.
                                        end.                                        
                                    end.

    
                              end. /* 检查限制 */

                              
                            create tmpkb .
                            assign  tmp_line = v_line 
                                    tmp_io = "in"
                                    tmp_id = xkb_kb_id 
                                    tmp_type = xkb_type
                                    tmp_part = xkb_part 
                                    tmp_site = xkb_site
                                    tmp_loc = loc_to
                                    tmp_lot = lot_to
                                    tmp_ref = ref_to .

                            v_line = v_line + 1 .
    
                        end. /*  if v1300 <> "" */
                
                        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1300.
                        pause 0.
                
                        display  "" @ WMESSAGE NO-LABEL with fram F1300.
                        pause 0.

                        leave v1300L.
                    
                
                     END.  /* END 1300   */
    
               end. /*if v_qty_oh >= xkb_kb_raim_qty */
           end.  /*if avail xkb_mstr */
       end. 
       else do:

            find first tmpkb no-lock no-error   .
            if not avail tmpkb then do:
                disp "请先刷读看板才可执行"   @ WMESSAGE NO-LABEL with fram F1100. 
                pause 0 .
                undo ,retry .
            end.
         
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
            
            L14001 = "退料单: " + v_nbr .
            display L14001          skip with fram F1400 no-box.
            L14002 = "" . 
            display L14002          format "x(40)" skip with fram F1400 no-box.
            L14003 =  "" . 
            display L14003          format "x(40)" skip with fram F1400 no-box.
            L14004 = "" . 
            display L14004          format "x(40)" skip with fram F1400 no-box.
            L14005 = ""   . 
            display L14005          format "x(40)" skip with fram F1400 no-box.
            L14006 = "执行退料 ?" . 
            display L14006          format "x(40)" skip with fram F1400 no-box.

            V1400 = yes.
       
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

                v_line = 0 .
                repeat:
                    v_line = v_line + 1 .
                    find first tmpkb where tmp_io = "out" and tmp_line = v_line no-lock no-error .
                    if not avail tmpkb then do:   leave .
                    end.
                    else do:   /*trfrom*/

                        site_from = tmp_site .
                        v_par = tmp_par .
                        loc_from = tmp_loc .
                        lot_from = tmp_lot .
                        ref_from = tmp_ref .
                        v_qty = tmp_qty .


                        find xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = "L"
                             and xkb_part = tmp_part and xkb_kb_id = tmp_id no-lock no-error .
                        recno_from = if avail xkb_mstr then recid(xkb_mstr) else  ? .
/* message "from" tmp_line recno_from  view-as alert-box. */

                        find first tmpkb where tmp_io = "in" and tmp_line = v_line no-lock no-error .
                        if not avail tmpkb then do:   leave .
                        end.
                        else do:   /*trto*/
                            site_to = tmp_site .
                            loc_to  = tmp_loc .
                            lot_to  = tmp_lot .
                            ref_to  = tmp_ref .


                            find xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = tmp_type
                            and xkb_part =tmp_part and xkb_kb_id = tmp_id no-lock no-error .
                            recno_to = if avail xkb_mstr then recid(xkb_mstr) else  ? .
/* message "to" tmp_line recno_to view-as alert-box. */

                            /*产生库存交易记录*/
                            rct_trnbr = 0 .
                            iss_trnbr = 0 .

                            if (site_from <> site_to or loc_from <> loc_to or lot_from <> lot_to or ref_to <> ref_from ) then do:
                                for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                          delete sr_wkfl.
                                end.

                                create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                assign  sr_userid = mfguser
                                        sr_lineid = string(1) + "::" + xkb_part
                                        sr_site = site_from
                                        sr_loc = loc_from
                                        sr_lotser = string(string(lot_from,"x(18)") + string(lot_to,"x(18)") )
                                        sr_qty = v_qty
                                        sr_ref = ref_from
                                        sr_user1 = v_nbr.
                                        sr_rev = loc_to.
                                        sr_user2 = xkb_part.
                                if recid(sr_wkfl) = -1 then .

                                /* disp sr_lineid @ l21002 with frame f2100 no-box .  pause . */


                                    from_expire = ?.
                                    from_date = ?.
                                    from_assay = 0.
                                    from_grade = "".
                                    global_part = xkb_part .

                                    find ld_det where ld_det.ld_domain = global_domain and  ld_part = xkb_part
                                                and ld_site = site_from and ld_loc = loc_from and ld_lot = lot_from and ld_ref = ref_from  no-lock no-error.
                                    if available ld_det then do:
                                    assign
                                        from_status = ld_status
                                        from_expire = ld_expire
                                        from_date = ld_date
                                        from_assay = ld_assay
                                        from_grade = ld_grade.
                                    end.

                                    find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = xkb_part
                                                and ld_site = site_to and ld_loc = loc_to and ld_lot = lot_to and ld_ref = ref_to no-error.
                                    if not available ld_det then do:
                                        create ld_det. ld_det.ld_domain = global_domain.
                                        assign
                                        ld_site = site_to
                                        ld_loc = loc_to
                                        ld_part = xkb_part
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
                                  find pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error.
                                  {gprun.i ""icedit.p""
                                           "(""RCT-TR"",
                                             site_to,
                                             loc_to,
                                             pt_part,
                                             lot_to,
                                             ref_to,
                                             v_qty,
                                             pt_um,
                                             v_nbr,
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
                                             v_qty,
                                             pt_um,
                                             v_nbr,
                                             j,
                                             output undo-input)"}
                                  if undo-input then undo , retry.


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
                                  find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
                                  if avail tr_hist then  assign tr_addr = loc_to tr_rmks = v_par .
                                  find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                  if avail tr_hist then  assign tr_addr = loc_to tr_rmks = v_par .
                              end.
                             /*产生库存交易记录*/

                            /*收料 */
                            find xkb_mstr where recid(xkb_mstr) = recno_to exclusive-lock no-error.
                            v_raim_qty = if avail xkb_mstr then xkb_kb_raim_qty else 0 .
                            if avail xkb_mstr then do :
                                assign  xkb_status = "U" 
                                        xkb_upt_date = today 
                                        xkb_kb_raim_qty = xkb_kb_raim_qty + v_qty .
/* message "收料" xkb_kb_raim_qty view-as alert-box . */

                                v_trnbr = rct_trnbr .
                                {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                            &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit047.p'"
                                            &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                            &b_status="xkb_status"       &c_status="'U'"
                                            &rain_qty="xkb_kb_raim_qty"}
                            end.

                            /*领料看板发料 */
                            find xkb_mstr where recid(xkb_mstr) = recno_from exclusive-lock no-error.
                            if avail xkb_mstr then do: 
/* message "发料" xkb_kb_raim_qty view-as alert-box . */
                                assign  xkb_upt_date = today .
                                v_trnbr = rct_trnbr .
                                {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                            &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit047.p'"
                                            &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
                                            &b_status="xkb_status"       &c_status="xkb_status"
                                            &rain_qty="xkb_kb_raim_qty"}
                            end.



                        end.
                    end.
                end.  /*repeat:*/
            end.  /*  if v1400 then   */
    
        
            display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
            pause 0.
            
            display  "" @ WMESSAGE NO-LABEL with fram F1400.
            pause 0.
            leave V1400L.
        END.  /* END 1400    */  
           leave v1100L .
       end.   /*if */


       display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
       pause 0.

       display  "" @ WMESSAGE NO-LABEL with fram F1100.
       pause 0.

    END.   /* END 1100 */   

    for each tmpkb exclusive-lock:
        delete tmpkb .
    end.

/*     leave mainloop . */
end. /**MAINLOOP**/

if v_nbr > "" then do:
    find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = "RT" exclusive-lock no-error.
    if avail xdn_ctrl then do:
        find first tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
        if avail tr_hist then do:
            repeat:
                v_nbr = "RT" + string(inte(substring(v_nbr , 3 , length(v_nbr) - 2 )) + 1 ,"999999") .
                find next tr_hist where tr_domain = global_domain and tr_nbr = v_nbr no-lock no-error .
                if not avail tr_hist then leave .
            end.
        end.
        xdn_next = substring(v_nbr , 3 , length(v_nbr) - 2 ) .
    end.
end.
