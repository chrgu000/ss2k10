/*xxovisap.p 超发申请单审批程式 */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110121.1  By: Roger Xiao */ /*created*/
/* SS - 110316.1  By: Roger Xiao */ /*翻页时仅显示P,C状态的记录*/
/*-Revision end---------------------------------------------------------------*/



{mfdtitle.i "110316.1"}


define var v_nbr              like rqd_nbr no-undo.
define var v_site             like wo_site no-undo.
define var v_wonbr            like wo_nbr  no-undo.
define var v_wolot            like wo_lot  no-undo.

define var v_iss_times        as integer  .
define var v_qty_pct          as decimal format ">>>>9.99%" .
define var v_qty_open         like tr_qty_loc .
define var v_qty_ord          like tr_qty_loc .
define var v_qty_total        like tr_qty_loc .
define var line               as integer format ">>>" .
define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .

define var v_all              as logical format "Yes/No" init yes no-undo.
define var v_status           as char format "x(1)" no-undo.
define var v_newline          as logical .

define var v_error            as logical .
define var v_todo             as char extent 4 .
v_todo[1] = "add".
v_todo[2] = "mod".
v_todo[3] = "del".
v_todo[4] = "app".




define var vv_recid as recid .
define var vv_first_recid as recid .
define var v_framesize as integer .
vv_recid       = ? .
vv_first_recid = ? .
v_framesize    = 11 .

define var v_line  as integer  no-undo .
define var v_yn1         as logical initial yes  .
define var v_yn2         as logical .
define var v_counter     as integer .
define var choice        as logical initial no.



define temp-table temp1 no-undo
    field t1_select      as char format "x(1)"
    field t1_line        as char format "x(3)"
    field t1_part        like wo_part 
    field t1_wonbr       like wo_nbr 
    field t1_wolot       like wo_lot 
    field t1_qty_open    as decimal format "->,>>>,>>9.9<<<<"
    field t1_qty_total   as decimal format ">,>>>,>>9.9<<<<"
    field t1_qty_pct     as decimal format ">>>>9.9<%"     
    field t1_iss_qty     as decimal format ">,>>>,>>9.9<<<<"
    field t1_iss_times   as integer format ">>>9"
    field t1_status      as char format "x(1)"
    .

form
    SKIP(.2)
    v_nbr          colon 10  label "申请单号" v_site         colon 35  label "地点"     xovm_status    colon 70 label "当前状态"
    xovm_mod_date  colon 10  label "申请日期" v_wonbr        colon 35  label "加工单"   v_status       colon 70 label "审批为(P/A/C)"
    xovm_mod_user  colon 10  label "申请人"   v_wolot        colon 35  label "工单ID"   v_all          colon 70 label "默认审批"          

with frame a  side-labels width 80 .

form 
   t1_select          label "S"
   t1_line            label "行"         
   t1_part            label "物料号"       
   t1_qty_open        label "欠缺量"       
   t1_iss_qty         label "超发量"       
   t1_iss_times       label "第次"     
   t1_qty_total       label "累计超发量"   
   t1_qty_pct         label "超发%"    
   t1_status          label "状"
with frame zzz1 width 80 v_framesize down 
title color normal  "单据明细".  

view frame a .
view frame zzz1 .

v_status = "A".

mainloop:
repeat:
    for each temp1 : delete temp1. end. 

    clear frame zzz1 all no-pause.

    update 
        v_nbr     
    with frame a editing:
         if frame-field = "v_nbr" then do:
             {mfnp01.i xovm_mstr  v_nbr xovm_nbr  yes "index('PC',xovm_status) > 0 and yes"  xovm_nbr}
             if recno <> ? then do:
                disp 
                    xovm_nbr  @ v_nbr 
                    xovm_site @ v_site 
                    xovm_mod_user 
                    xovm_mod_date 
                    xovm_status  
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update..EDITING */

    find first xovm_mstr where xovm_nbr = v_nbr exclusive-lock no-wait no-error .
    if not avail xovm_mstr then do:
        if locked xovm_mstr then do:
            message "警告:此单号正在被编辑,已被锁定" .
            undo,retry.
        end.
        else do:
            message "错误:超发申请单号不存在,请重新输入".
            undo,retry.
        end.
    end.
    else do: /*if avail xovm_mstr*/
            disp 
                xovm_nbr  @ v_nbr 
                xovm_site @ v_site 
                xovm_mod_user 
                xovm_mod_date 
                xovm_status
                v_all
                v_status  
            with frame a .

            v_site = xovm_site.

            find first si_mstr where si_site = xovm_site no-lock no-error.
            if not avail si_mstr then do:
                message "错误:地点不存在,请重新输入" .
                undo mainloop, retry mainloop.
            end.
            {gprun.i ""gpsiver.p"" "(input si_site, input recid(si_mstr), output return_int)"}
            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}  
               undo , retry .
            end.            

            {gprun.i ""xxovisapb.p"" "(input global_userid, input v_todo[4] , input 0, input xovm_site, output v_error )"}
            if v_error then do:
                message "错误:您没有申请单的 审批权限".
                undo,retry.
            end.

            woloop:
            repeat :
                for each temp1 : delete temp1. end. 
                clear frame zzz1 all no-pause.

                find first xovm_mstr where xovm_nbr = v_nbr exclusive-lock no-error .
                disp 
                    xovm_nbr  @ v_nbr 
                    xovm_site @ v_site 
                    xovm_mod_user 
                    xovm_mod_date 
                    xovm_status
                    v_all
                    v_status  
                with frame a .

                prompt-for 
                    v_wonbr 
                    v_wolot 
                with frame a editing:
                    if frame-field = "v_wonbr" then do:
                        {mfnp11.i xovd_det xovd_nbr_wonbr "xovd_nbr = v_nbr and xovd_wonbr" "input v_wonbr"}
                    end.
                    else if frame-field = "v_wolot" then do:
                        {mfnp11.i xovd_det xovd_nbr_wolot "xovd_nbr = v_nbr and xovd_wolot" "input v_wolot"}
                    end.
                    else do:
                        readkey.
                        apply lastkey.
                    end.

                    if recno <> ? then do:
                        find first wo_mstr use-index wo_lot where wo_lot = xovd_wolot no-lock no-error .
                        if avail wo_mstr then 
                        display
                            wo_nbr @ v_wonbr 
                            wo_lot @ v_wolot
                            
                        with frame a.
                    end.
                end. /* prompt-for ... with frame a editing: */

                if input v_wonbr <> "" or input v_wolot <> "" then do: /*not null*/

                    if input v_wonbr <> "" and input v_wolot <> "" then
                        find wo_mstr no-lock use-index wo_lot where wo_lot = input v_wolot and wo_nbr = input v_wonbr no-error.

                    if input v_wonbr = "" and input v_wolot <> "" then
                        find wo_mstr no-lock use-index wo_lot where wo_lot = input v_wolot no-error.

                    if input v_wonbr <> "" and input v_wolot = "" then
                        find first wo_mstr no-lock use-index wo_nbr where wo_nbr = input v_wonbr no-error.

                    if not available wo_mstr then if input v_wolot <> "" then
                        find wo_mstr no-lock use-index wo_lot where wo_lot = input v_wolot no-error.

                    if not available wo_mstr then do:
                        {pxmsg.i &msgnum=503 &errorlevel=3}
                        undo , retry .
                    end.
                    else do:   /*if available wo_mstr*/
                        if wo_nbr <> input v_wonbr and input v_wonbr <> "" then do:
                            {pxmsg.i &msgnum=508 &errorlevel=3}
                            undo , retry .
                        end.

                        disp 
                            wo_nbr @ v_wonbr 
                            wo_lot @ v_wolot
                            
                        with frame a .

                        v_wolot = wo_lot.
                        v_wonbr = wo_nbr.
                    end.  /*if available wo_mstr*/
                end. /*not null*/
                assign v_wolot v_wonbr.

                do on error undo,retry on endkey undo,leave :
                    update v_status v_all with frame a .
                    if index("PAC",v_status ) = 0 then do:
                        message "错误:审批状态仅限P-待审批,A-批准,C-取消,请重新输入 ".
                        undo,retry.
                    end.

                    if index("AC",v_status) > 0 and xovm_status = v_status then do:
                        message "错误:申请单的审批状态已经是" v_status ",请重新输入 ".
                        undo,retry.                    
                    end.

                    for each xovd_det 
                        where xovd_nbr = v_nbr 
                        and xovd_status <> v_status 
                        and (xovd_wolot = v_wolot or v_wolot = "" )
                        no-lock :
                        v_qty_open = 0 .
                        v_qty_ord  = 0 .
                        v_iss_times = 0.
                        v_qty_total = 0.
                        for each wod_det where wod_lot = xovd_wolot and wod_part = xovd_part no-lock :
                            v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
                            v_qty_ord  = v_qty_ord  + wod_qty_req .
                        end.

                        {gprun.i ""xxovisapa.p"" "(input xovd_part, input xovd_nbr, input xovd_wolot, output v_iss_times , output v_qty_total )"}
                        
                        v_iss_times = v_iss_times + 1 .
                        v_qty_total = v_qty_total + xovd_iss_qty .
                        v_qty_pct = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.

                        find first temp1 where integer(t1_line) = xovd_line  no-error.
                        if not avail temp1 then do:
                            create temp1 .
                            assign t1_line        = string(xovd_line)
                                   t1_part        = xovd_part 
                                   t1_wonbr       = xovd_wonbr
                                   t1_wolot       = xovd_wolot
                                   t1_iss_qty     = xovd_iss_qty
                                   t1_qty_open    = v_qty_open
                                   t1_qty_total   = v_qty_total
                                   t1_qty_pct     = v_qty_pct
                                   t1_iss_times   = xovd_iss_times 
                                   t1_status      = xovd_status 
                                   t1_select      = if v_all then "*" else ""
                                   .
                        end.
                    end.

                    v_counter = 0 .
                    for each temp1 :
                        v_counter = v_counter + 1 .
                        v_line    = max(integer(t1_line),v_line) + 1 .
                    end.
                    if v_counter = 0  then  do:
                        message "错误:超发申请单无符合条件的明细记录,请重新输入" .
                        undo, retry .
                    end.

                    choice = no .
                    ststatus = stline[3].
                    status input ststatus.

                    sw_block1:
                    do on endkey undo, leave:
                        sw_block:
                        do on endkey undo, leave:
                            for first temp1 no-lock:
                            end.        
                            {xxswselect.i
                                &detfile      = temp1
                                &scroll-field = t1_line
                                &framename    = "zzz1"
                                &framesize    = v_framesize
                                &sel_on       = ""*""
                                &sel_off      = """"
                                &display1     = t1_select
                                &display2     = t1_line     
                                &display3     = t1_part     
                                &display4     = t1_qty_open 
                                &display5     = t1_iss_qty  
                                &display6     = t1_iss_times
                                &display7     = t1_qty_total
                                &display8     = t1_qty_pct 
                                &display9     = t1_status
                                &exitlabel    = sw_block
                                &exit-flag    = true
                                &record-id    = vv_recid
                                &include3     = "if v_wolot = '' then message '工单编号:' t1_wonbr ',工单ID:' t1_wolot .  "
                            }

                        end. /*sw_block:*/

                        {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=choice}

                        if not choice
                            or keyfunction(lastkey) = "end-error"
                            or lastkey              = keycode("F4")
                            or lastkey              = keycode("CTRL-E")
                        then do:
                            message "警告:未审批任何明细记录" .
                            clear frame zzz1 all no-pause.
                            undo sw_block1, next woloop.
                        end.

                        for each temp1 where t1_select = "*":
                            {gprun.i ""xxovisapb.p"" "(input global_userid, input v_todo[4] , input t1_qty_pct, input xovm_site, output v_error )"}
                            if v_error then do:
                                message "错误:您没有申请单 第" t1_line "项的 审批权限,超发比例:" t1_qty_pct .
                                vv_recid = recid(temp1).
                                undo sw_block1,retry sw_block1.
                            end.            
                        end. /*for each temp1*/
                    end.  /* sw_block1 */

                end. /*do on error undo*/



                find first temp1 where t1_select = "*" no-error.
                if not avail temp1 then do:
                    message "警告:未选择审批任何明细记录" .
                    choice = no.
                end.


                if choice then do :  

                    /*明细档**********/
                    for each temp1 where t1_select = "*":
                        find first xovd_det
                            where xovd_nbr    = v_nbr
                            and   xovd_line   = integer(t1_line)
                        no-error.
                        if avail xovd_det then do:
                            assign xovd_status      = v_status 
                                   xovd_app_date    = today
                                   xovd_app_user    = global_userid
                                   .
                        end.
                    end. /*for each temp1*/


                    /*主档**********/
                    find first xovd_det where xovd_nbr = v_nbr and xovd_status = "P" no-lock no-error.
                    if not avail xovd_det then do:
                        find first xovm_mstr 
                            where xovm_nbr    = v_nbr 
                        exclusive-lock no-error.
                        if avail xovm_mstr then do:
                            find first xovd_det where xovd_nbr = v_nbr and xovd_status = "A" no-lock no-error.
                            xovm_status   = if avail xovd_det then "A" else "C".
                            xovm_app_date = today.
                            xovm_app_user = global_userid .
                        end.        
                    end.
                    else do:
                        find first xovm_mstr 
                            where xovm_nbr    = v_nbr 
                        exclusive-lock no-error.
                        if avail xovm_mstr and xovm_status <> "P" then do:
                            xovm_status   = "P".
                            xovm_app_date = today.
                            xovm_app_user = global_userid .
                        end.        
                    end.

                    /*clear frame a no-pause. */
                    clear frame zzz1 all no-pause.
                    release xovm_mstr.
                    release xovd_det.
                    if v_wolot = "" then 
                         message "申请单:" v_nbr "审批完成" .
                    else message "申请单:" v_nbr ",加工单/ID" v_wonbr "/" v_wolot "审批完成" .
                end.  /*if choice then*/

            end. /* woloop: */
    end. /*if avail xovm_mstr*/
end. /* mainloop: */
