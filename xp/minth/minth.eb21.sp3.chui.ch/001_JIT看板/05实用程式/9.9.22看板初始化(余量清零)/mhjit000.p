/* mhjit000.p  看板初始化(余量清零)  for barcode                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */
      
define shared variable execname as character .  execname = "mhjit000.p".
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
define var v_qty like xkb_kb_qty .
define var v_qty_req like xkb_kb_qty .
define var v_qty_oh like ld_qty_oh .
define variable i as integer .
define variable j as integer .
define var trnbr like tr_trnbr.
define var v_trnbr like tr_trnbr.
define var stat_from as char  .
define var stat_to as char .



{gldydef.i new}
{gldynrm.i new}


define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb 
    field tmp_id   like xkb_kb_id
    field tmp_type like xkb_type
    field tmp_site like xkb_site
    field tmp_loc  like xkb_loc
    field tmp_lot  like xkb_lot
    field tmp_ref  like xkb_ref 
    field tmp_part like xkb_part 
    field tmp_qty  like xkb_kb_qty.



find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
    and code_domain = global_domain no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "[看板库存清零]" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).


MAINLOOP:
REPEAT: 


    for each tmpkb:
        delete tmpkb .
    end.

    hide all no-pause .
    define var v13001          as char format "x(1)" .
    define var v13002          as char format "x(18)" .
    define var v13003          as char format "x(3)" .

    effdate = today .
    j = 0 .  

    
    find icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = if avail icc_ctrl then icc_site else global_site .
    
    find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
    if not avail xkbc_ctrl then do:
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            run xxmsg01.p (input 0 , input  "看板模块没有开启" ,input yes )  . 
            undo, retry  .
        end.
    end.


    
     V1300L:
     REPEAT:

        find first tmpkb no-lock no-error .

        hide all no-pause .
        define variable V1300           as char format "x(40)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".

        display dmdesc format "x(40)" skip with fram F1300 no-box.

        L13001 = "生效日期:" + string(effdate) .
        display L13001          skip with fram F1300 no-box.
        L13002 =  "" .  
        display L13002          format "x(40)" skip with fram F1300 no-box.
        L13003 = "" .
        display L13003          format "x(40)" skip with fram F1300 no-box.
        L13004 = "看板张数:" + string(j)  . 
        display L13004          format "x(40)" skip with fram F1300 no-box.
        L13005 = "" .  
        display L13005          format "x(40)" skip with fram F1300 no-box.
        L13006 = if avail tmpkb then "请继续刷读,或直接确认执行" else "请刷读待清除看板,输E退出:" .
        display L13006          format "x(40)" skip with fram F1300 no-box.
        
        v1300 = "" .

    	Update V1300   WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
           readkey pause wtimeout.
           if lastkey = -1 then leave mainloop.
           if LASTKEY = 404 Then leave mainloop.
/*            if LASTKEY = 404 Then Do: /* DISABLE F4 */ */
/*               pause 0 before-hide.                    */
/*               undo, retry.                            */
/*            end.                                       */
           display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
           
           APPLY LASTKEY.
        END.

        display  skip WMESSAGE NO-LABEL with fram F1300.

        
        if v1300 <> "" then do:
            if v1300 = "e" then leave mainloop.


              v13001 = substring(v1300,1,1) .  /* xkb_type*/
              v13002 = substring(v1300,2,length(v1300) - 4 ) .  /* xkb_part*/
              v13003 = substring(v1300,length(v1300) - 2 ,3) .    /* xkb_kb_id */

              find xkb_mstr where xkb_domain = global_domain and xkb_type = v13001 and xkb_kb_id = inte(v13003) and xkb_part = v13002 
                            /*and xkb_kb_raim_qty > 0*/ and xkb_status = "U" no-lock no-error .
              if not avail xkb_mstr then do:
                  disp "错误:无看板记录,或不在使用状态." @ WMESSAGE NO-LABEL with fram F1300. 
                  pause 0.
                  undo, retry.
              end.
              else do:
                    /* if (xkb_type <> "P") then do:                                             */
                    /*     disp "错误: 仅限采购看板(P类型)" @ WMESSAGE NO-LABEL with fram F1300. */
                    /*     pause 0.                                                              */
                    /*     undo, retry.                                                          */
                    /* end.                                                                      */

                    find first tmpkb no-lock no-error .
                    if not avail tmpkb then do:   /*first scan */
                        create tmpkb .
                        assign tmp_id = xkb_kb_id 
                            tmp_site  = xkb_site 
                            tmp_loc   = xkb_loc 
                            tmp_lot   = xkb_lot 
                            tmp_ref   = xkb_ref 
                            tmp_part  = xkb_part 
                            tmp_type  = xkb_type
                            tmp_qty   = xkb_kb_raim_qty.
                            j = j + 1 .
                    end. /*first scan */
                    else do:  /*not first scan */
                            find tmpkb where tmp_id = inte(v13003) and tmp_part = v13002 no-lock no-error .
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
                                tmp_qty   = xkb_kb_raim_qty  .  
                                j = j + 1 .
                        
                    end.  /*not first scan */
                    
              end.
          end. /*  if v1300 <> "" */
          else do:  /*  if v1300 = "" */

            find first tmpkb no-lock no-error .
            if not avail tmpkb then do:
                disp "请先刷读看板才可执行"   @ WMESSAGE NO-LABEL with fram F1300. 
                pause 0 .
                undo ,retry .
            end.


/*                   hide all no-pause .                                                                     */
/*                   for each tmpkb no-lock break by tmp_site by tmp_loc by tmp_lot by tmp_ref by tmp_part : */
/*                       disp tmp_type + tmp_part + string(tmp_id,"999") format "x(22)"                      */
/*                            with down frame a overlay  row 1 width 25 no-attr-space no-box .               */
/*                                                                                                           */
/*                   end.                                                                                    */
/*                   pause  before-hide .                                                                    */


                    V1400L:
                    REPEAT:

                        hide all no-pause .
                        define variable V1400           as logical  .
                        define variable L14001          as char format "x(40)".
                        define variable L14002          as char format "x(40)".
                        define variable L14003          as char format "x(40)".
                        define variable L14004          as char format "x(40)".
                        define variable L14005          as char format "x(40)".
                        define variable L14006          as char format "x(40)".

                        display dmdesc format "x(40)" skip with fram F1400 no-box.

                        L14001 = "生效日期"  +  string(effdate) .
                        display L14001          skip with fram F1400 no-box.
                        L14002 = "看板张数" + string(j)  .
                        display L14002          format "x(40)" skip with fram F1400 no-box.
                        L14003 = "" .
                        display L14003          format "x(40)" skip with fram F1400 no-box.
                        L14004 = "".
                        display L14004          format "x(40)" skip with fram F1400 no-box.
                        L14005 = "" .
                        display L14005          format "x(40)" skip with fram F1400 no-box.
                        L14006 = "执行库存清除(Y/N) ?" .
                        display L14006          format "x(40)" skip with fram F1400 no-box.


                        Update V1400   WITH  fram F1400 no-label EDITING:
                            readkey pause wtimeout.
                            if lastkey = -1 then leave mainloop.
                            if LASTKEY = 404 Then Do: 
                                    v1400 = no .
                                    /* DISABLE F4 */
                                    /* pause 0 before-hide. */
                                    /* undo, retry.         */
                            end.
                            display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
                            APPLY LASTKEY.
                        END.
                        display skip WMESSAGE NO-LABEL with fram F1400.

                        if v1400 then do:
                                for each tmpkb no-lock break by tmp_site by tmp_type by tmp_part by tmp_id :
                                    find first xkb_mstr where xkb_domain = global_domain and xkb_site = tmp_site and xkb_type = tmp_type and xkb_part = tmp_part and xkb_kb_id = tmp_id no-error.
                                    if avail xkb_mstr then do:
                                            xkb_status = "A" .
                                            xkb_upt_date = today .
                                            xkb_kb_raim_qty = 0 .
											xkb_kb_raim = 0 .
                                            xkb_loc = "" .
                                            xkb_lot = "" .
                                            xkb_ref = "" .
                                            
                                            {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                                        &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit000.p'"
                                                        &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr=0
                                                        &b_status="'U'"       &c_status="'A'"   &rain_qty=0}                                          
                                    end.
                                end. /*for each tmpkb */

                                for each tmpkb:
                                      delete tmpkb .
                                end.
                                j = 0 .
                                leave v1300l .


                         end.  /*  if v1400 then   */
                         else do:
                                run xxmsg02.p (input 0 , input  "是否放弃修改,退出(Y/N)?" ,output v1400 )  .
                                if v1400 then do:
                                    for each tmpkb:
                                          delete tmpkb .
                                    end.
                                    j = 0 .

                                    run xxmsg01.p (input 0 , input  "请重新刷读所有看板.." ,input yes )  . 
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


