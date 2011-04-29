/*xxworct01.p 工单入库单维护打印程式 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100722.1   Created On: 20100722   By: Softspeed Roger Xiao                               */



{mfdtitle.i "100722.1"}


define var nbr    like xrc_nbr  no-undo.
define var wonbr  like wo_nbr   no-undo.
define var wonbr1 like wo_nbr   no-undo.
define var wolot  like wo_lot   no-undo.
define var wolot1 like wo_lot   no-undo.
define var part   like wo_part  no-undo.
define var part1  like wo_part  no-undo.
define var site   like wo_site  no-undo.
define var date   as date       no-undo.

define var v_line  as integer  no-undo .
define var v_wolot like wo_lot no-undo.
define var v_new   as logical .
define var v_ii    as integer .
define var v_yn1         as logical initial yes  .
define var v_yn2         as logical .
define var v_print       as logical .
define var v_print_file  as char .
define var v_counter     as integer .
define var choice        as logical initial no.

define variable nrseq          as char    no-undo.
define variable errorst        as logical no-undo.
define variable errornum       as integer no-undo.

define var vv_recid as recid .
define var vv_first_recid as recid .
define var v_framesize as integer .
vv_recid       = ? .
vv_first_recid = ? .
v_framesize    = 8 .
date = today .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else "" .


define temp-table temp1 no-undo
    field t1_line     like xrcd_line 
    field t1_wolot    like wo_lot
    field t1_wonbr    like wo_nbr 
    field t1_part     like wo_part 
    field t1_desc     like pt_desc1
    field t1_qty_open like wo_qty_ord
    field t1_qty_rct  like wo_qty_ord  
    field t1_site     like wo_site
    field t1_loc      like pt_loc    
    .

form
    SKIP(.2)
    nbr                 colon 18 label "入库单号"
           skip(1)
    date                colon 18 label "入库日期"
    site                colon 18 label "地点"
    wonbr               colon 18 label "工单号"
    wonbr1              colon 53 label "至"
    wolot               colon 18 label "工单ID"
    wolot1              colon 53 label "至"
    part                colon 18 label "物料号"
    part1               colon 53 label "至"
        
skip(1) 
with frame a  side-labels width 80 attr-space.
/*setFrameLabels(frame a:handle).*/



form 
   t1_line             label "行"
   t1_wonbr            label "工单号"
   t1_part             label "物料号"
   t1_qty_open         label "短缺量"
   t1_qty_rct          label "入库量"
   t1_loc              label "库位"
   skip 
   t1_wolot            label "工单ID"   at 5
   t1_desc             label "物料说明" at 24
with frame zzz1 width 80 v_framesize down 
title color normal  "单据明细".  


form
    SKIP(.2)
    v_line         colon 10 label "项次"
    v_wolot        colon 10 label "工单ID"
    t1_wonbr       colon 30 label "工单号"
    t1_part        colon 10 label "物料号"
    t1_desc        no-label 
    wo_status      colon 10 label "工单状态"
    t1_qty_open    colon 10 label "短缺量"
    t1_qty_rct     colon 30 label "入库量"
    t1_site        colon 10 label "地点"
    t1_loc         colon 30 label "库位"
with frame z2  
side-labels width 60 row 6 overlay centered 
title color normal "新增记录".


{wbrp01.i}
mainloop:
repeat:
    for each temp1 : delete temp1. end. 
    v_new = no .

    update 
        nbr     
    with frame a editing:
        {mfnp.i xrc_mstr nbr  " xrc_domain = global_domain and xrc_nbr "  nbr xrc_nbr xrc_nbr}
        if recno <> ? then do:
            nbr = xrc_nbr .
            display 
                nbr 
                xrc_date_rct @ date  
                xrc_site @ site 
            with frame a .
        end.        
    end.

    if nbr <> "" then do:
        find first xrc_mstr where xrc_domain = global_domain and xrc_nbr = nbr exclusive-lock no-error .
        if not avail xrc_mstr then do:
            if locked xrc_mstr then do:
                message "警告:此单号正在被编辑,已被锁定" .
                undo,retry.
            end.
            else v_new = yes .
        end.
        else do:
            date = xrc_date_rct .
            site = xrc_site .
            display 
                nbr 
                xrc_date_rct @ date  
                xrc_site @ site 
            with frame a .

            if xrc_date_print <> ? then do:
                message "警告:此单据已打印过,是否允许编辑?" update choice .
                if choice = no then undo,retry.
            end.

            do on error undo,retry on endkey undo,leave :
                update 
                    date  
                go-on ("F5" "CTRL-D") with frame a editing :
                        readkey.
                        if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                            message "确认删除?" update choice .
                            if choice then do :
                                find first xrc_mstr where xrc_domain = global_domain and xrc_nbr = nbr no-error.
                                if avail xrc_mstr then do:
                                    for each xrc_mstr where xrc_domain = global_domain and xrc_nbr = nbr :
                                        delete xrc_mstr.
                                    end.
                                    for each xrcd_det where xrcd_domain = global_domain and xrcd_nbr = nbr :
                                        delete xrcd_det.
                                    end.
                                end.        
                                message "整张单据已删除" .
                                nbr = "" .
                                next mainloop .
                            end.
                        end. /*   "F5" "CTRL-D" */
                        else apply lastkey.
                end. /* update ...EDITING */
            end. /*do on error undo*/
        end. /*else do:*/
    end. /*if nbr <> "" then do:*/
    else v_new = yes .

    /*找旧单*/
    if v_new = no then do:
        for each xrcd_det where xrcd_domain = global_domain and xrcd_nbr = nbr exclusive-lock:
            find first temp1 where t1_line  = xrcd_line no-error .
            if not avail temp1 then do:
                create temp1 .
                assign t1_line      = xrcd_line
                       t1_wolot     = xrcd_wolot
                       t1_wonbr     = xrcd_wonbr
                       t1_part      = xrcd_part 
                       t1_qty_open  = xrcd_qty_open
                       t1_qty_rct   = xrcd_qty_rct
                       t1_site      = xrcd_site
                       t1_loc       = xrcd_loc 
                       .
                find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
                t1_desc = if avail pt_mstr then pt_desc1 else "" .               
            end.
        end.
    end.

    /*产生新单*/
    if v_new = yes then do on error undo ,retry :
        if wolot1   = hi_char  then wolot1 = "" .
        if wonbr1   = hi_char  then wonbr1 = "" .
        if part1    = hi_char  then part1  = "" .
        
        update 
            date 
            site 
            wonbr     
            wonbr1    
            wolot       
            wolot1      
            part        
            part1       
        with frame a.

        if wolot1   = "" then wolot1 = hi_char  .
        if wonbr1   = "" then wonbr1 = hi_char  .
        if part1    = "" then part1  = hi_char  .

        if date  = ? then date = today .

        find first si_mstr where si_domain = global_domain and si_site = site no-lock no-error .
        if not avail si_mstr then do:
            message "错误:地点不存在,请重新输入".
            undo,retry.
        end.

        v_ii = 0 .
        for each wo_mstr 
            where wo_domain = global_domain 
            and wo_nbr  >= wonbr and wo_nbr  <= wonbr1 
            and wo_lot  >= wolot and wo_lot  <= wolot1
            and wo_part >= part  and wo_part <= part1
            and wo_site = site 
            and index("RA",wo_status) > 0 
            and wo_qty_ord - wo_qty_comp > 0 
            no-lock 
            break by wo_lot:

                find first temp1 
                    where t1_wolot = wo_lot 
                    and   t1_wonbr = wo_nbr
                    and   t1_part  = wo_part 
                no-error .
                if not avail temp1 then do:

                    find first pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error .

                    v_ii = v_ii + 1 . 
                    create temp1 .
                    assign t1_line      = v_ii 
                           t1_wolot     = wo_lot
                           t1_wonbr     = wo_nbr
                           t1_part      = wo_part 
                           t1_desc      = if avail pt_mstr then pt_desc1 else "" 
                           t1_qty_open  = max(0,wo_qty_ord - wo_qty_comp)
                           t1_qty_rct   = max(0,wo_qty_ord - wo_qty_comp)
                           t1_site      = wo_site
                           t1_loc       = if avail pt_mstr then pt_loc else wo_loc 
                           .
                end.
        end.        
    end. /*if v_new = yes then*/


v_counter = 0 .
for each temp1 :
    v_counter = v_counter + 1 .
    v_line    = max(t1_line,v_line) + 1 .
end.

if v_counter = 0  then  do:
    message "无明细记录" .
    undo, retry .
end.
/*if v_counter >= 8 then message "每次最多显示8行" . */


hide all no-pause.
view frame zzz1 .
choice = no .
ststatus = stline[3].
status input ststatus.

message "请移动光标选择,按回车键查看明细" .
sw_block:
repeat :
        if not can-find(first temp1 no-lock) then leave sw_block.

        scroll_loop:
        do with frame zzz1:
            {xxswview.i 
                &domain       = "true and "
                &buffer       = temp1
                &scroll-field = t1_line
                &searchkey    = "true"
                &framename    = "zzz1"
                &framesize    = v_framesize
                &display1     = t1_line
                &display2     = t1_wonbr   
                &display3     = t1_wolot     
                &display4     = t1_part      
                &display5     = t1_qty_open              
                &display6     = t1_qty_rct   
                &display7     = t1_loc     
                &display8     = t1_desc   
                &exitlabel    = scroll_loop
                &exit-flag    = "true"
                &record-id    = vv_recid
                &first-recid  = vv_first_recid
                &logical1     = true 
            }

        end. /*scroll_loop*/


        /*退出时提问*/
        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or lastkey = keycode("ESC")
            or keyfunction(lastkey) = "go"
        then do:
            v_yn1 = no . /*v_yn1 = yes 则不可以退出 */
            vv_recid = ? . /*退出前清空vv_recid*/
            if v_yn1 = no then do :
                choice = yes .
                {mfmsg01.i 12 1 choice }  /*是否正确?*/
                leave .
            end. 
        end.  /*if keyfunction(lastkey)*/  

        /*删除记录*/
        if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
        then do:
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                choice = yes.
                message "请确认删除第" t1_line "项?" update choice.
                if choice then do :
                        delete temp1.
                        vv_recid = ? .
                        next sw_block.
                end.  /*if choice then*/ 
                else  next sw_block. 
            end.
        end. /*if lastkey = keycode("F5")*/
    
        /*加入记录*/
        if  keyfunction(lastkey) = "insert-mode"
            or lastkey = keycode("F3")             
        then do:

                clear frame z2 no-pause .
                pause 0 .
                view frame z2 .
                v_wolot = "" .
                
            do on error undo,retry :

                update v_line with frame z2.
                if v_line = 0  then do:
                    message  "错误:项次需为正数,请重新输入".
                    undo,retry .
                end.
                find first temp1 where t1_line = input v_line no-error .
                if avail temp1 then do:
                    message  "错误:项次已经存在,请重新输入".
                    undo,retry .
                end.
                
                do on error undo,retry :
                    update v_wolot with frame z2 editing:
                        {mfnp.i wo_mstr v_wolot  " wo_mstr.wo_domain = global_domain and wo_lot "  v_wolot wo_lot wo_lot}
                        if recno <> ? then do:
                            find first pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error .
                            display 
                                wo_lot   @ v_wolot
                                wo_nbr   @ t1_wonbr  
                                wo_part  @ t1_part 
                                pt_desc1 @ t1_desc
                                wo_site  @ t1_site
                                wo_loc   @ t1_loc 
                                wo_qty_ord - wo_qty_comp @ t1_qty_open 
                                wo_status 
                            with frame z2 .
                        end.
                    end.
                    find first wo_mstr where wo_mstr.wo_domain = global_domain and wo_lot = v_wolot no-lock no-error.
                    if not avail wo_mstr then do:
                        message "错误:工单ID不存在,请重新输入." .
                        undo,retry .
                    end.
                    else do:
                            find first temp1 where t1_wolot = v_wolot no-lock no-error.
                            if avail temp1 then do:
                                message "错误:此工单ID已经存在,项次是" t1_line .
                                undo,retry.
                            end.

                            if index("RA", wo_status) <= 0 then do:
                                message "错误:仅限R,A状态工单".
                                undo,retry.
                            end.
                            if wo_qty_ord - wo_qty_comp <= 0 then do:
                                message "错误:仅限未结数量加工单".
                                undo,retry.
                            end.

                            if wo_site <> site then do:
                                message "错误:仅限地点" site .
                                undo,retry.
                            end.
                            
                            find first pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error .
                            display 
                                wo_lot   @ v_wolot
                                wo_nbr   @ t1_wonbr  
                                wo_part  @ t1_part 
                                pt_desc1 @ t1_desc
                                wo_site  @ t1_site
                                wo_loc   @ t1_loc 
                                wo_qty_ord - wo_qty_comp @ t1_qty_open    
                                wo_status
                            with frame z2 .

                            create temp1.
                            assign t1_line = v_line 
                                   t1_wolot = wo_lot
                                   t1_wonbr = wo_nbr                                         
                                   t1_part  = wo_part  
                                   t1_desc  = pt_desc1 
                                   t1_qty_open = wo_qty_ord - wo_qty_comp
                                   t1_qty_rct  = wo_qty_ord - wo_qty_comp
                                   t1_site     = wo_site
                                   t1_loc      = wo_loc 
                                   .
                    end.
                    
                    qtyloop:
                    do on error undo,retry :
                        update t1_qty_rct t1_loc with frame z2.
                        if t1_qty_rct > t1_qty_open or t1_qty_rct < 0 then do:
                            message "错误:数量超限,请重新输入" .
                            undo ,retry .
                        end.
                        find first loc_mstr where loc_domain = global_domain and loc_site = wo_site and loc_loc = t1_loc no-lock no-error.
                        if not avail loc_mstr then do:
                            message "错误:库位不存在,请重新输入".
                            undo ,retry .
                        end.
                    end. /*do on error undo,retry :*/
                end. /*do on error undo,retry :*/
            end. /*do on error undo,*/
            clear frame z2 no-pause .
            hide  frame z2 no-pause.
            next sw_block .
        end. /*if (keyfunction(lastkey) = "insert-mode"*/


        /*修改现有记录*/
        if vv_recid <> ? then do:
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                    qtyloop2:
                    do on error undo,retry :
                        update   t1_qty_rct t1_loc with frame zzz1.
                        if t1_qty_rct > t1_qty_open or  t1_qty_rct < 0 then do:
                            message "错误:数量超限,请重新输入" .
                            undo ,retry .
                        end.
                        find first loc_mstr where loc_domain = global_domain and loc_site = t1_site and loc_loc = t1_loc no-lock no-error.
                        if not avail loc_mstr then do:
                            message "错误:库位不存在,请重新输入".
                            undo ,retry .
                        end.
                    end. /*do on error undo,retry :*/
            end.
        end.



end. /*sw_block:*/

/***************************/

find first temp1 no-error.
if not avail temp1 then do:
    message "本次无任何入库,单据已删除" .
    choice = no.
    find first xrc_mstr where xrc_domain = global_domain and xrc_nbr = nbr no-error.
    if avail xrc_mstr then do:
        for each xrc_mstr where xrc_domain = global_domain and xrc_nbr = nbr :
            delete xrc_mstr.
        end.
        for each xrcd_det where xrcd_domain = global_domain and xrcd_nbr = nbr :
            delete xrcd_det.
        end.
    end.
    release xrc_mstr.
    release xrcd_det.
    nbr = "" .
end.
else do:
    v_print = No .
    if choice then message "是否打印此单据?" update v_print .
end .


if choice then do :  
    /*单号**********/
    if v_new and nbr = "" then do:
        nrseq = "worct01" .
        {gprun.i ""gpnrmgv.p"" "(nrseq, input-output nbr, output errorst, output errornum)" }
        if errorst then do:
            {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=3}
            next-prompt nbr with frame a.
            undo mainloop, retry mainloop.
        end.
    end.

    /*主档**********/
    find first xrc_mstr 
        where xrc_domain = global_domain 
        and   xrc_nbr    = nbr 
    exclusive-lock no-error.
    if not avail xrc_mstr then do:
        create xrc_mstr.
        assign xrc_domain   = global_domain
               xrc_nbr      = nbr 
               xrc_site     = site
               xrc_date_rct = date 
               .
    end.
    xrc_date_mod = today.
    xrc_user_mod = global_userid .

    if v_print then 
            assign 
            xrc_date_print = today
            xrc_user_print = global_userid .

    /*明细档**********/
    for each xrcd_det 
        where xrcd_domain = global_domain 
        and   xrcd_nbr    = nbr
        exclusive-lock :
        delete xrcd_det .
    end.

    for each temp1 :
        find first xrcd_det
            where xrcd_domain = global_domain 
            and   xrcd_nbr    = nbr
            and   xrcd_line   = t1_line
        no-error.
        if not avail xrcd_det then do:
            create xrcd_det .
            assign xrcd_domain  = global_domain 
                   xrcd_nbr     = nbr 
                   xrcd_line    = t1_line
                   xrcd_wolot   = t1_wolot
                   xrcd_wonbr   = t1_wonbr
                   xrcd_part    = t1_part 
                   xrcd_site    = t1_site
                   xrcd_loc     = t1_loc
                   xrcd_qty_rct = t1_qty_rct 
                   xrcd_qty_open= t1_qty_open
                   .

        end.
    end. /*for each temp1*/
    release xrc_mstr.
    release xrcd_det.


    if v_print then do:
        printloop: 
        do on error undo, return error on endkey undo, return error:                    
            /* PRINTER SELECTION */
            {gpselout.i &printType = "printer"
                        &printWidth = 132
                        &pagedFlag = " "
                        &stream = " "
                        &appendToFile = " "
                        &streamedOutputToTerminal = " "
                        &withBatchOption = "yes"
                        &displayStatementType = 1
                        &withCancelMessage = "yes"
                        &pageBottomMargin = 6
                        &withEmail = "yes"
                        &withWinprint = "yes"
                        &defineVariables = "yes"}


            put unformatted
                "ExcelFile;" 
                + "xxworct01" 
                skip
                "SaveFile;"
                + "xxworct01" 
                + string(year(today),"9999") + string(month(today),"99") + string(day(today),"99")
                + replace(string(time, "HH:MM:SS"), ":", "") 
                skip
                "BeginRow;2"                
                skip.

            put unformatted "单据号;" "'" nbr ";入库日期;" string(year(date)) + "/" + string(month(date),"99") + "/" + string(day(date),"99")  ";检查员;____________" skip.
            put unformatted "入库部门;___________;最后加工者;___________" skip.
            put unformatted ";" skip .
            put unformatted 
                "工单号;工单ID;物料号;物料说明;计量单位;入库数量;入库库位;备注" 
                skip.



            for each temp1 where t1_qty_rct > 0 no-lock:
                define var v_um like pt_um.
                find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
                v_um = if avail pt_mstr then pt_um else "" .
                find first code_mstr where code_domain = global_domain and code_fldname = "pt_um" and code_value = v_um no-lock no-error.
                v_um = if avail code_mstr then code_cmmt else "" .

                put unformatted 
                    t1_wonbr      ";"
                    t1_wolot      ";"
                    t1_part       ";"
                    t1_desc       ";"
                    v_um          ";"
                    t1_qty_rct    ";"
                    t1_loc        ";"
                    ""     
                skip.
            end.


        end. /* printloop: */
        {mfreset.i}
    end. /*if v_print then do:*/


end.  /*if choice then*/


end. /* mainloop: */
{wbrp04.i &frame-spec = a}
