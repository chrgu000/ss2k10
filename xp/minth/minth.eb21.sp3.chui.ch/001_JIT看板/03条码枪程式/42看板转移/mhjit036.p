/* mhjit036.p  看板转移  for barcode                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 2007/10/08   BY: Softspeed roger xiao   */ /*xp001*/ 
/* REVISION: 1.1      LAST MODIFIED: 2008/05/26   BY: Softspeed roger xiao   */ /*xp002*/ 
/*-Revision end------------------------------------------------------------          */
      
define shared variable execname as character .  execname = "mhjit036.p".
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



define var v_yn as logical format "Y/N" initial yes .
define var v_qty_tmp like xkb_kb_qty .
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var effdate as date .

define var v_nbr like xdn_next .
define variable p-type like xdn_type.
define variable p-prev like xdn_prev.
define variable p-next like xdn_next.
define variable m2 as char format "x(8)".
define variable k as integer.



define var v_qty like xkb_kb_qty .
define var v_qty_oh like ld_qty_oh .
define var v_fqty  like xmpt_kb_fqty .
define var v_qty_firm like xppt_qty_firm . 
define var v_raim_qty  like xkb_kb_raim_qty .

define variable i as integer .
define variable j as integer .
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
define var stat_from as char  .
define var stat_to as char .
define var v_line as integer .
define var v_part like pt_part .

define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
define new shared variable transtype as character format "x(7)" initial "ISS-TR".
define var v_entity  like si_entity .
define var v_module  as char initial "IC" .
define var v_result  as integer initial 0.
define var v_msg_nbr as integer initial 0.


{gldydef.i new}
{gldynrm.i new}


define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb 
    field tmp_line as integer 
    field tmp_io   as char 
    field tmp_site like xkb_site
    field tmp_id   like xkb_kb_id
    field tmp_type like xkb_type
    field tmp_part like xkb_part
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_qty  like xkb_kb_qty.



find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[看板刷读转移]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


V1400L:
REPEAT:
    
    hide all.
    define variable V1400           as date no-undo .
    define variable L14001          as char format "x(40)".
    define variable L14002          as char format "x(40)".
    define variable L14003          as char format "x(40)".
    define variable L14004          as char format "x(40)".
    define variable L14005          as char format "x(40)".
    define variable L14006          as char format "x(40)".
    
    display dmdesc format "x(40)" skip with fram F1400 no-box.
    
    v1400 = ? .

    L14001 = "" .
    display L14001          skip with fram F1400 no-box.
    L14002 = "" . 
    display L14002          format "x(40)" skip with fram F1400 no-box.
    L14003 = "" . 
    display L14003          format "x(40)" skip with fram F1400 no-box.
    L14004 = "" . 
    display L14004          format "x(40)" skip with fram F1400 no-box.
    L14005 = "" . 
    display L14005          format "x(40)" skip with fram F1400 no-box.
    L14006 = "生效日期 ? " . 
    display L14006          format "x(40)" skip with fram F1400 no-box.

    V1400 = today.
    
    Update V1400   WITH  fram F1400 NO-LABEL
    /* ROLL BAR START */
    EDITING:
       readkey pause wtimeout.
       if lastkey = -1 then quit.
       if lastkey = 404 then  Do: /* DISABLE F4 */
                pause 0 before-hide.
                undo, retry.
       end.
       display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
       
       APPLY LASTKEY.
    END.

    if V1400 = ? then V1400 = today.

    display  skip WMESSAGE NO-LABEL with fram F1400.

    if v1400 < today  then do:
        display "日期不得小于今天,请重新输入." @ WMESSAGE NO-LABEL with fram F1400.
        pause 0  .
        undo ,retry .
    end.

    effdate = v1400 .

    
    find icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = if avail icc_ctrl then icc_site else global_site .

    find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
    if not avail xkbc_ctrl then do:
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            disp  "看板模块没有开启" @ WMESSAGE NO-LABEL with fram F1400.
            pause 0.
            undo, retry  .
        end.
    end.

    /* v_nbr */
        /*xp002*/ 
        /*----------------start:get nbr---------------------------*/
        v_nbr  = "" .
        p-type = "TR" .
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
                disp  "错误:无库存转移单号控制档"  @ WMESSAGE NO-LABEL with fram F1400.
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

    
    display "...处理...  " @ WMESSAGE NO-LABEL with fram F1400.
    pause 0.
    
    display  "" @ WMESSAGE NO-LABEL with fram F1400.
    pause 0.
    leave V1400L.
END.  /* END 1400    */


  loc_from  = "" .


MAINLOOP:
REPEAT: 

for each tmpkb:
    delete tmpkb .
end.

v_line  = 1 .



    hide all.
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .

    site_from = "".
    sn_from   = "" .
    lot_from  = "" .
    ref_from  = "" .
    v_qty = 0 .
    v13001 = "" .
    v13002 = "" .
    v13003 = "" .


    V1000L:
    REPEAT:
        
        hide all.
        define variable V1000           as char format "x(40)".
        define variable L10001          as char format "x(40)".
        define variable L10002          as char format "x(40)".
        define variable L10003          as char format "x(40)".
        define variable L10004          as char format "x(40)".
        define variable L10005          as char format "x(40)".
        define variable L10006          as char format "x(40)".
        
        display dmdesc format "x(40)" skip with fram F1000 no-box.
        
        L10001 = "生效日期:" + string(effdate) .
        display L10001          skip with fram F1000 no-box.
        L10002 = "" . 
        display L10002          format "x(40)" skip with fram F1000 no-box.
        L10003 = "" . 
        display L10003          format "x(40)" skip with fram F1000 no-box.
        L10004 = "" . 
        display L10004          format "x(40)" skip with fram F1000 no-box.
        L10005 = "" . 
        display L10005          format "x(40)" skip with fram F1000 no-box.
        L10006 =  "转出看板" + string(v_line) + " ?"  . 
        display L10006          format "x(40)" skip with fram F1000 no-box.

        v1000 = "" .
        Update V1000   WITH  fram F1000 no-label EDITING:
            readkey pause wtimeout.
            if lastkey = -1 then quit.
            if LASTKEY = 404 Then Do: /* DISABLE F4 */
                pause 0 before-hide.
                undo, retry.
            end.
            display skip "^" @ WMESSAGE NO-LABEL with fram F1000.
            APPLY LASTKEY.
        END.
        display  skip WMESSAGE NO-LABEL with fram F1000.
        
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

        if v1000 <> ""  then do:
            if v1000 = "E" then leave mainloop .
  
            v13001 = substring(v1000,1,1) .  /* xkb_type*/
            v13002 = substring(v1000,2,length(v1000) - 4 ) .  /* xkb_part*/
            v13003 = substring(v1000,length(v1000) - 2 ,3) .    /* xkb_kb_id */
            
            find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001  
                            and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                            and xkb_kb_raim_qty > 0 and (xkb_status = "U" /*or xkb_status = "A"*/ ) no-lock no-error .
            if not avail xkb_mstr then do:
                  disp "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1000. 
                  pause 0.
                  undo, retry.
            end.
            else do :  /* 检查库存 */
                recno_from = recid(xkb_mstr) .
                /*转出条码*/
                sn_from = V1000 .
                /*转出库位*/
                site_from = xkb_site .
                if loc_from = "" then loc_from = xkb_loc .
                /*转出批序号*/
                lot_from = xkb_lot .
                ref_from = xkb_ref .


                    v_entity = xkb_site .
                    v_module = "IC" .
                    v_result = 0.
                    v_msg_nbr = 0 .
                    {gprun.i ""gpglef1.p""
                       "( input v_module ,
                         input  v_entity,
                         input  effdate,
                         output v_result,
                         output v_msg_nbr)" }
                    if v_result > 0 then do:

                       /* INVALID PERIOD */
                       if v_result = 1 then do:
                          run xxmsg01.p (input 0 , input  "无效会计期间/年份" ,input yes )  .
                       end.
                       /* PERIOD CLOSED FOR ENTITY */
                       else if v_result = 2 then do:
                          run xxmsg01.p (input 0 , input "会计单位" + v_entity + "的期间已结" ,input yes )  .
                       end.
                       /* DEFAULT CASE - SHOULDN'T HAPPEN */
                       else do:
                          run xxmsg01.p (input v_msg_nbr , input "" ,input yes )  .
                       end.

                       undo,retry .
                    end.

                if xkb_kb_raim_qty = 0 then do:
                      disp "错误:待转看板库存量为零" @ WMESSAGE NO-LABEL with fram F1000. 
                      pause 0.
                      undo, retry.
                end.

                
                v_qty_oh = 0 .
                for each ld_det where ld_domain = global_domain and ld_site = xkb_site and ld_loc = xkb_loc and ld_part = xkb_part 
                                and ld_lot = xkb_lot and ld_ref = xkb_ref and ld_qty_oh > 0 no-lock:
                    v_qty_oh = v_qty_oh + ld_qty_oh .
                end.
    
                if v_qty_oh < xkb_kb_raim_qty then do:
                      disp "错误:库存(" + string(v_qty_oh) + ")小于待转看板库存量" @ WMESSAGE NO-LABEL with fram F1000. 
                      pause 0.
                      undo, retry.
                end.
                else do: /*if v_qty_oh >= xkb_kb_raim_qty */
                    
                    find first tmpkb where  tmp_io = "out" and tmp_site = xkb_site and tmp_type = xkb_type 
                                     and tmp_part = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                    if avail tmpkb then do:
                         display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1000.
                         pause 0 .
                         undo v1000l, retry v1000l.
                    end.
                    
                    find first tmpkb where  tmp_io = "out" and tmp_loc <> xkb_loc no-lock no-error .
                    if avail tmpkb then do:
                         display  "仅限同库位:" + string(tmp_loc) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1000.
                         pause 0 .
                         undo v1000l, retry v1000l.                        
                    end.

                    if loc_from <> "" and xkb_loc <> loc_from then do:
                         display  "仅限同库位:" + string(loc_from) + ",请重新输入" @ WMESSAGE NO-LABEL with fram F1000.
                         pause 0 .
                         undo v1000l, retry v1000l.                        
                    end.
                     
                     V1100L:
                     REPEAT:

                        hide all no-pause .
                        define variable V1100           like xkb_kb_raim_qty  .
                        define variable L11001          as char format "x(40)".
                        define variable L11002          as char format "x(40)".
                        define variable L11003          as char format "x(40)".
                        define variable L11004          as char format "x(40)".
                        define variable L11005          as char format "x(40)".
                        define variable L11006          as char format "x(40)".


                        display dmdesc format "x(40)" skip with fram F1100 no-box.

                        L11001 = "生效日期:" + string(effdate) .
                        display L11001          skip with fram F1100 no-box.
                        L11002 = "转出看板: " + sn_from  .
                        display L11002          format "x(40)" skip with fram F1100 no-box.
                        L11003 = "" .
                        display L11003          format "x(40)" skip with fram F1100 no-box.
                        L11004 = "" .
                        display L11004          format "x(40)" skip with fram F1100 no-box.
                        L11005 = "" .
                        display L11005          format "x(40)" skip with fram F1100 no-box.
                        L11006 = "转出数量 ? " .
                        display L11006          format "x(40)" skip with fram F1100 no-box.

                        V1100 = xkb_kb_raim_qty .

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

                        if (v1100 <= 0 or v1100 > xkb_kb_raim_qty  ) then do:
                              display "不可超过看板库存量,不可为零."  @ WMESSAGE NO-LABEL with fram F1100.
                              pause 0 .
                              undo ,retry .
                        end.

                        /*待转数量*/
                        v_qty =  v1100 .

                        create tmpkb .
                        assign tmp_line = v_line
                               tmp_io   = "out"
                               tmp_site = xkb_site
                               tmp_type = xkb_type
                               tmp_part = xkb_part
                               tmp_id  = xkb_kb_id
                               tmp_qty = v_qty
                               tmp_loc = xkb_loc 
                               tmp_lot = xkb_lot
                               tmp_ref = xkb_ref  .
                        

                        /*转出条码*/
                        sn_from = V1000 .
                        /*转出库位*/
                        site_from = xkb_site .
                        loc_from = xkb_loc .
                        /*转出批序号*/
                        lot_from = xkb_lot .
                        ref_from = xkb_ref .



                        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.

                        display  "" @ WMESSAGE NO-LABEL with fram F1100.
                        pause 0.
                        leave V1100L.

                     END.   /* END 1100 */



                     V1200L:
                     REPEAT:

                        hide all.
                        define variable V1200           as char format "x(40)".
                        define variable L12001          as char format "x(40)".
                        define variable L12002          as char format "x(40)".
                        define variable L12003          as char format "x(40)".
                        define variable L12004          as char format "x(40)".
                        define variable L12005          as char format "x(40)".
                        define variable L12006          as char format "x(40)".


                        display dmdesc format "x(40)" skip with fram F1200 no-box.

                        L12001 = "生效日期:" + string(effdate)  .
                        display L12001          skip with fram F1200 no-box.
                        L12002 = "转出看板: " + sn_from .
                        display L12002          format "x(40)" skip with fram F1200 no-box.
                        L12003 = "转出数量: " + string(v_qty) .
                        display L12003          format "x(40)" skip with fram F1200 no-box.
                        L12004 = "" .
                        display L12004          format "x(40)" skip with fram F1200 no-box.
                        L12005 = "" .
                        display L12005          format "x(40)" skip with fram F1200 no-box.
                        L12006 = "转入看板" + string(v_line) + " ?"  .
                        display L12006          format "x(40)" skip with fram F1200 no-box.

                        V1200 = "" .

                        Update V1200   WITH  fram F1200 no-label EDITING:
                           readkey pause wtimeout.
                           if lastkey = -1 then quit.
                           if LASTKEY = 404 Then Do: /* DISABLE F4 */
                              pause 0 before-hide.
                              undo, retry.
                           end.
                           display skip "^" @ WMESSAGE NO-LABEL with fram F1200.

                           APPLY LASTKEY.
                        END.
                        display  skip WMESSAGE NO-LABEL with fram F1200.


                        if v1200 <> "" THEN do:   /*  if v1200 <> "" */
                            IF v1200 = "e" THEN LEAVE MAINLOOP.

                            if v1200 = sn_from or v1200 = "" then do:
                                display "不能为空,或与转出看板相同." @ WMESSAGE NO-LABEL with fram F1200.
                                pause 0  .
                                undo ,retry .
                            end.

                            v13001 = substring(v1200,1,1) .  /* xkb_type*/
                            v13002 = substring(v1200,2,length(v1200) - 4 ) .  /* xkb_part*/
                            v13003 = substring(v1200,length(v1200) - 2 ,3) .    /* xkb_kb_id */

                            if v13002 <> substring(sn_from,2,length(sn_from) - 4 ) then do:
                                  disp "转出/转入看板的零件需相同" @ WMESSAGE NO-LABEL with fram F1200.
                                  pause 0.
                                  undo, retry.
                            end.


                            find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001
                                            and xkb_kb_id = inte(v13003) and xkb_part = v13002
                                            and ((xkb_status = "U" and xkb_kb_raim_qty > 0) or xkb_status = "A") no-lock no-error .
                            if not avail xkb_mstr then do:
                                  disp "无看板记录,或非有效状态" @ WMESSAGE NO-LABEL with fram F1200.
                                  pause 0.
                                  undo, retry.
                            end.
                            else do: /* 检查限制 */
                                recno_to = recid(xkb_mstr) .
                                sn_to = v1200 .
                                site_to = xkb_site.
                                loc_to = xkb_loc  .
                                lot_to = xkb_lot  .
                                ref_to = xkb_ref .

                                find first tmpkb where  tmp_io = "in" and tmp_site = xkb_site and tmp_type = xkb_type 
                                                 and tmp_part = xkb_part and tmp_id = xkb_kb_id no-lock no-error .
                                if avail tmpkb then do:
                                     display  "此看板已经刷读,请重新输入" @ WMESSAGE NO-LABEL with fram F1200.
                                     pause 0 .
                                     undo v1200l, retry v1200l.
                                end.
                               
                                if xkb_status = "U" then do :
                                    if (xkb_site <> site_from or xkb_loc <> loc_from or xkb_lot <> lot_from or xkb_ref <> ref_from ) then do:
                                          disp "批序号不一致,是否继续(Y/N)?"  @ L12006 NO-LABEL with fram F1200.
                                          v1200 = "Y" .
                                          update v1200 with frame f1200 .
                                          repeat:
                                              if not ( v1200 = "Y" or v1200 = "N" ) then do:
                                                   disp "仅限输入'Y'或者'N'..."   @ WMESSAGE NO-LABEL with fram F1200.
                                                   pause 0 .
                                                   v1200 = "Y" .
                                                   disp "批序号不一致,是否继续(Y/N)?"   @ l12006 NO-LABEL with fram F1200.
                                                   update v1200 with frame f1200 .
                                              end.
                                              else leave .
                                          end.
                                          if v1200 = "N" then undo ,retry .
                                          if v1200 = "Y" then do:
                                              
                                              disp "批序号用转入看板的(Y/N) ?"  @ l12006 NO-LABEL with fram F1200.
                                              v1200 = "Y" .
                                              update v1200 with frame f1200 .
                                              repeat:
                                                  if not ( v1200 = "Y" or v1200 = "N" ) then do:
                                                       disp "仅限输入'Y'或者'N'..."  @ WMESSAGE NO-LABEL with fram F1200.
                                                       pause 0 .
                                                       disp "批序号用转入看板的(Y/N) ?"  @ l12006 NO-LABEL with fram F1200.
                                                       v1200 = "Y" .
                                                       update v1200 with frame f1200 .
                                                  end.
                                                  else leave .
                                              end.
                                              if v1200 = "Y"  then assign site_to = xkb_site  loc_to = xkb_loc  lot_to = xkb_lot  ref_to = xkb_ref .
                                              if v1200 = "N"  then assign site_to = site_from loc_to = loc_from lot_to = lot_from ref_to = ref_from .
                                          end.  /*if v1200 = "Y" then */
                                    end.
                                end.  /*if xkb_status = "U" */
                                else do:
                                    disp "请确认转入库位 "  @ l12006 NO-LABEL with fram F1200.
                                    v1200 = loc_from .
                                    update v1200 with frame F1200 no-box.
                                    repeat:
                                        find first loc_mstr where loc_domain = global_domain and loc_loc =  v1200  no-lock no-error .
                                        if not avail loc_mstr  then do:
                                               disp "无效库位,请重新输入" @ WMESSAGE NO-LABEL with fram F1200.
                                               v1200 = loc_from .
                                               update v1200 with frame F1200 .
                                        end.
                                        else leave .
                                    end.
                                    assign site_to = site_from
                                           loc_to = v1200
                                           lot_to = lot_from
                                           ref_to = ref_from .
                                end.  /*if xkb_status = "A" */
                                if xkb_kb_id <> 000  and xkb_kb_id <> 999  then do:                                    
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
    
                                    if (xkb_kb_raim_qty + v_qty) > xkb_kb_qty then do:
                                        disp "超过转入看板容量"  @ WMESSAGE NO-LABEL with fram F1200.
                                        pause 2 no-message  .
                                        if v_qty_firm = yes then undo , retry.
                                    end.
                                end.


                                v_entity = site_to .
                                v_module = "IC" .
                                v_result = 0.
                                v_msg_nbr = 0 .
                                {gprun.i ""gpglef1.p""
                                   "( input v_module ,
                                     input  v_entity,
                                     input  effdate,
                                     output v_result,
                                     output v_msg_nbr)" }
                                if v_result > 0 then do:

                                   /* INVALID PERIOD */
                                   if v_result = 1 then do:
                                      run xxmsg01.p (input 0 , input  "无效会计期间/年份" ,input yes )  .
                                   end.
                                   /* PERIOD CLOSED FOR ENTITY */
                                   else if v_result = 2 then do:
                                      run xxmsg01.p (input 0 , input "会计单位" + v_entity + "的期间已结" ,input yes )  .
                                   end.
                                   /* DEFAULT CASE - SHOULDN'T HAPPEN */
                                   else do:
                                      run xxmsg01.p (input v_msg_nbr , input "" ,input yes )  .
                                   end.

                                   undo,retry .
                                end. 


                                create tmpkb .
                                assign tmp_line = v_line
                                       tmp_io   = "in"
                                       tmp_site = site_to
                                       tmp_type = xkb_type
                                       tmp_part = xkb_part
                                       tmp_id  = xkb_kb_id
                                       tmp_loc = loc_to 
                                       tmp_lot = lot_to
                                       tmp_ref = ref_to  .
                                v_line = v_line + 1 .
                            end. /* 检查限制 */
                        end.     /* if v1200 <> "" */

                        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1200.
                        pause 0.

                        display  "" @ WMESSAGE NO-LABEL with fram F1200.
                        pause 0.
                        leave V1200L.
                     END.   /* END 1200 */

                end.  /*if v_qty_oh >= xkb_kb_raim_qty */
            end. /* 检查库存 */
        end.    /*  if v1000 <> ""  then */
        else do: /*  if v1000 = ""  then */


            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "请先刷读看板才可执行"   @ WMESSAGE NO-LABEL with fram F1000. 
                pause 0 .
                undo ,retry .
            end.

/*             hide all no-pause .                                                             */
/*             for each tmpkb break by tmp_line :                                              */
/*                 disp  string(tmp_line,">9")                                                 */
/*                       tmp_type + tmp_part + string(tmp_id,"999") format "x(20)"             */
/*                            with down frame a overlay  row 1 width 24 no-attr-space no-box . */
/*                                                                                             */
/*             end.                                                                            */
/*             pause  before-hide .                                                            */

            V1300L:
            REPEAT:

                hide all no-pause .
                define variable V1300           as logical .
                define variable L13001          as char format "x(40)".
                define variable L13002          as char format "x(40)".
                define variable L13003          as char format "x(40)".
                define variable L13004          as char format "x(40)".
                define variable L13005          as char format "x(40)".
                define variable L13006          as char format "x(40)".

                display dmdesc format "x(40)" skip with fram F1300 no-box.

                L13001 = "转移单号:" +  v_nbr  .
                display L13001          skip with fram F1300 no-box.
                L13002 = "生效日期:" + string(effdate)   .
                display L13002          format "x(40)" skip with fram F1300 no-box.
                L13003 = ""  .
                display L13003          format "x(40)" skip with fram F1300 no-box.
                L13004 = "" .
                display L13004          format "x(40)" skip with fram F1300 no-box.
                L13005 = "" .
                display L13005          format "x(40)" skip with fram F1300 no-box.
                L13006 = "执行库存转移 ? " .
                display L13006          format "x(40)" skip with fram F1300 no-box.

                v1300 = yes .

                Update V1300   WITH  fram F1300 no-label EDITING:
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

                if v1300 then do:

                    v_line = 0 .
                    repeat:
                         v_line = v_line + 1 .
                         find first tmpkb where tmp_io = "out" and tmp_line = v_line no-lock no-error .
                         if not avail tmpkb then do:   leave .
                         end.
                         else do:   /*trfrom*/
                             site_from = tmp_site .
                             v_part = tmp_part .
                             loc_from = tmp_loc .
                             lot_from = tmp_lot .
                             ref_from = tmp_ref .
                             v_qty = tmp_qty .

                             find xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = tmp_type
                                           and xkb_part =tmp_part and xkb_kb_id = tmp_id no-lock no-error .
                             recno_from = if avail xkb_mstr then recid(xkb_mstr) else  ? .


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


                                  /*产生库存交易记录*/
                                    rct_trnbr = 0 .
                                    iss_trnbr = 0 .

                                    if (site_to <> site_from or loc_to <> loc_from or lot_to <> lot_from or ref_to <> ref_from )  then do:
                                        for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
                                                  delete sr_wkfl.
                                        end.

                                        create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
                                        assign  sr_userid = mfguser
                                                sr_lineid = string(1) + "::" + v_part
                                                sr_site = site_from
                                                sr_loc = loc_from
                                                sr_lotser = string(string(lot_from,"x(18)") + string(lot_to,"x(18)") )
                                                sr_qty = v_qty
                                                sr_ref = ref_from
                                                sr_user1 = v_nbr.
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
                                          if avail tr_hist then  assign tr_addr = loc_from .
                                          find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
                                          if avail tr_hist then  assign tr_addr = loc_from .
                                    end.   /*产生库存交易记录*/

                                    find xkb_mstr where recid(xkb_mstr) = recno_to  no-error.
                                    v_raim_qty = if avail xkb_mstr then xkb_kb_raim_qty else 0 .
                                    if avail xkb_mstr then do :
                                        assign  xkb_site = site_to  xkb_loc = loc_to  xkb_upt_date = today  xkb_status = "U"
                                                                   xkb_lot = lot_to    xkb_ref = ref_to  xkb_kb_raim_qty = xkb_kb_raim_qty + v_qty .
                                        v_trnbr = rct_trnbr .
                                        {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit036.p'"
                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                    &b_status="xkb_status"       &c_status="'U'"
                                                    &rain_qty="xkb_kb_raim_qty"}
                                    end.

                                    find xkb_mstr where recid(xkb_mstr) = recno_from  no-error.
                                    v_raim_qty = if avail xkb_mstr then xkb_kb_raim_qty else 0 .
                                    if avail xkb_mstr then do:
                                        assign xkb_kb_raim_qty = xkb_kb_raim_qty - v_qty  xkb_upt_date = today .

                                        v_trnbr = rct_trnbr .
                                        {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit036.p'"
                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                                                    &b_status="xkb_status"       &c_status="xkb_status"
                                                    &rain_qty="xkb_kb_raim_qty"}
                                        if xkb_kb_raim_qty = 0 then do:
                                             xkb_status = "A" .
                                             {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                    &kb_id="xkb_kb_id"    &effdate="effdate"        &program="'mhjit036.p'"
                                                    &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr=v_trnbr
                                                    &b_status="'U'"       &c_status="'A'"
                                                    &rain_qty="xkb_kb_raim_qty"}  
                                        end.
                                    end.
                             end.   /*trto*/
                         end.  /*trfrom*/
                    end.    /* repeat */



                    for each tmpkb:
                        delete tmpkb .
                    end.

                    v_line  = 1 .

                end.  /*if v1300 then do: */
                else do :
                    L13006 = "是否放弃修改,退出(Y/N)?" .
                    display L13006          format "x(40)" skip with fram F1300 no-box.
                    Update V1300   WITH  fram F1300 no-label .
                    if v1300 then do:
                        for each tmpkb:
                            delete tmpkb .
                        end. 
                        run xxmsg01.p (input 0 , input  "请重新刷读所有看板.." ,input yes )  . 
                        undo mainloop,retry mainloop .
                    end.
                    else do:
                        display "请继续刷读.." @ WMESSAGE NO-LABEL with fram F1300.
                        pause 1 no-message .
                        undo v1000l ,retry v1000l .
                    end.
                end.
                    

                display "...处理...  " @ WMESSAGE NO-LABEL with fram F1300.
                pause 0.

                display  "" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0.
                leave V1300L.
            END.  /* END 1300    */
        end.  /*  if v1000 = ""  then */       

        display "...处理...  " @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
        
        display  "" @ WMESSAGE NO-LABEL with fram F1000.
        pause 0.
/*         leave V1000L. */
    END.  /* END 1000    */
   
end. /**MAINLOOP**/

