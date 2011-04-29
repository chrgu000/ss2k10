/*xxbmzp001.p ZP件工单指定程式 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1   Created On: 20100907   By: Softspeed Roger Xiao                               */



{mfdtitle.i "100907.1"}


define var wonbr  like wo_nbr   no-undo.
define var wolot  like wo_lot   no-undo.
define var desc1  like pt_desc1 no-undo.
define var desc2  like pt_desc2 no-undo.
define var v_wo_tmp like wo_lot no-undo.
define var v_qty_rct like wo_qty_comp no-undo.

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


define temp-table temp1 no-undo
    field t1_line     as integer       
    field t1_part     like wo_part     
    field t1_desc     like pt_desc1    
    field t1_lot      like ld_lot      
    field t1_qty_iss  like wo_qty_ord  
    field t1_zpwo     like xzp_zpwo    
    .

form
    SKIP(.2)
    wonbr               colon 25 label "工单号"
    wolot               colon 50 label "ID"
    wo_part             colon 25 label "完成品"
    desc1               no-label at 47 no-attr-space
    wo_status           colon 25 label "状态"
    desc2               no-label at 47 no-attr-space    
skip(1) 
with frame a  side-labels width 80 attr-space.
/*setFrameLabels(frame a:handle).*/



form 
   t1_line             label "行" format ">>9"
   t1_part             label "物料号"
   t1_qty_iss          label "发料数"
   t1_zpwo             to 78 label "ZP件工单ID(逗号分隔)"
   /*t1_lot              label "  批序号" */
   skip 
   t1_desc             at 5 label "物料说明"
with frame zzz1 width 80 v_framesize down 
title color normal  "单据明细".  


{wbrp01.i}
mainloop:
repeat:
    for each temp1 : delete temp1. end. 
    v_new = no .

    prompt-for 
        wonbr wolot     
    with frame a editing:
        if frame-field = "wonbr" then do:
            {mfnp.i wo_mstr wonbr  "wo_domain = global_domain and wo_nbr "  wonbr wo_nbr wo_nbr}

            if recno <> ? then do:
                find pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error .
                desc1 = if avail pt_mstr then pt_desc1 else "" .
                desc2 = if avail pt_mstr then pt_desc2 else "" .
                display wo_nbr @ wonbr wo_lot @ wolot wo_status wo_part desc1 desc2 with frame a .
            end . /* if recno <> ? then  do: */
        end.
        else if frame-field = "wolot" then do:
             {mfnp01.i wo_mstr  wolot wo_lot  "input wonbr"  "wo_domain = global_domain and wo_nbr " wo_nbr}

            if recno <> ? then do:
                find pt_mstr where pt_domain = global_domain and pt_part = wo_part no-lock no-error .
                desc1 = if avail pt_mstr then pt_desc1 else "" .
                desc2 = if avail pt_mstr then pt_desc2 else "" .
                display wo_nbr @ wonbr wo_lot @ wolot wo_status wo_part desc1 desc2 with frame a .
            end . /* if recno <> ? then  do: */
        end.
        else do:
            status input ststatus.
            readkey.
            apply lastkey.
        end.

    end. /*prompt-for ... editing*/
    assign wonbr wolot .

    if input wonbr = "" and input wolot = "" then undo, retry.

    if wonbr <> "" and wolot <> "" then 
    find first wo_mstr 
        use-index wo_nbr
        where wo_domain = global_domain 
        and wo_nbr = wonbr
        and wo_lot = wolot 
    no-lock no-error.

    if not avail wo_mstr then 
    if wonbr = "" and wolot <> "" then 
    find first wo_mstr 
        use-index wo_lot
        where wo_domain = global_domain 
        and wo_lot = wolot 
    no-lock no-error.
    
    if not avail wo_mstr then 
    if wonbr <> "" and wolot = "" then 
    find first wo_mstr 
        use-index wo_nbr
        where wo_domain = global_domain 
        and wo_nbr = wonbr
    no-lock no-error.

    if not avail wo_mstr and (wonbr <> "" or wolot <> "" ) then do:
         {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3} 
         next-prompt wonbr.
         if wonbr = "" then next-prompt wolot.
         undo, retry.        
    end.
    
    wonbr = wo_nbr .
    wolot = wo_lot .

    if index("R,C",wo_status) = 0
    then do:
        message "错误:仅维护限R,C状态工单".
        undo,retry.
    end.

    find first xzp_det where xzp_domain = global_domain and xzp_wonbr = wonbr and xzp_wolot = wolot exclusive-lock no-error .
    if not avail xzp_det then do:
        if locked xzp_det then do:
            message "警告:此单号正在被编辑,已被锁定" .
            undo,retry.
        end.
        else v_new = yes .
    end.
    else do:
        v_new = no .
    end. /*else do:*/

    /*找旧单*/
    if v_new = no then do:
        v_ii = 0 .
        for each xzp_det where xzp_domain = global_domain and xzp_wonbr = wonbr and xzp_wolot = wolot exclusive-lock:
            find first temp1 where t1_part  = xzp_zppart /*and t1_lot = xzp_zplot*/ no-error .
            if not avail temp1 then do:
                v_ii = v_ii + 1 .
                create temp1 .
                assign t1_line      = v_ii
                       t1_part      = xzp_zppart 
                       /*t1_lot       = xzp_zplot*/
                       t1_qty_iss   = xzp_qty_iss  
                       t1_zpwo      = xzp_zpwo
                       .
                find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
                t1_desc = if avail pt_mstr then pt_desc1 else "" .               
            end.
        end.
    end.

    /*产生新单*/
    if v_new = yes then do on error undo ,retry :
        for each tr_hist
            use-index tr_nbr_eff
            where tr_domain = global_domain
            and   tr_nbr    = wonbr 
            and   tr_lot    = wolot
            and   tr_type   = "ISS-WO"
            no-lock:

            find first temp1 where t1_part  = tr_part /*and t1_lot = tr_serial*/ no-error .
            if not avail temp1 then do:
                v_ii = v_ii + 1 .
                create temp1 .
                assign t1_line      = v_ii
                       t1_part      = tr_part 
                       /*t1_lot       = tr_serial */
                       t1_qty_iss   = - tr_qty_loc  
                       t1_zpwo      = "" 
                       .
                find last wo_mstr where wo_domain = global_domain and wo_nbr = wonbr and wo_part = tr_part no-lock no-error.
                if avail wo_mstr and t1_part begins "zp" then t1_zpwo = wo_lot .

                find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
                t1_desc = if avail pt_mstr then pt_desc1 else "" .               
            end.
            else t1_qty_iss = t1_qty_iss   + ( - tr_qty_loc ) .

        end. /*for each tr_hist*/
    end. /*if v_new = yes then*/


v_counter = 0 .
for each temp1 :
    v_counter = v_counter + 1 .
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

if v_new then message "新增记录" .
else message "修改记录" .

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
                &display2     = t1_part   
                &display3     = t1_qty_iss      
                &display4     = t1_desc         
                &display5     = t1_zpwo              
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
            /**
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                choice = yes.
                message "请确认删除第" t1_line "项?" update choice.
                if choice then do :
                        delete temp1.
                        vv_recid = ? .
                        next sw_block.
                end.  
                else  next sw_block. 
            end.
            **/
        end. /*if lastkey = keycode("F5")*/
    
        /*加入记录*/
        if  keyfunction(lastkey) = "insert-mode"
            or lastkey = keycode("F3")             
        then do:

        end. /*if (keyfunction(lastkey) = "insert-mode"*/


        /*修改现有记录*/
        if vv_recid <> ? then do:
            find first temp1 where recid(temp1) = vv_recid no-error .
            if avail temp1 then do:
                    zpwo-loop:
                    do on error undo,retry :
                        update   t1_zpwo with frame zzz1.
                        if t1_zpwo = "" then do:
                            /*message "错误:加工单ID不可为空,请重新输入" .
                            undo,retry.  */
                        end.
                        else if index(t1_zpwo,",") = 0 then do:
                            find first wo_mstr where wo_domain = global_domain and wo_lot = t1_zpwo no-lock no-error .
                            if not avail wo_mstr then do:
                                message "错误:无此加工单ID,请重新输入" .
                                undo,retry.
                            end.
                            else do:
                                if wo_qty_comp + wo_qty_rjct < wo_qty_ord then do:
                                    
                                    message "错误:此工单数量未结".
                                    undo,retry.
                                end.

                                if wo_qty_comp < t1_qty_iss then do:
                                    
                                    message "错误:此工单完成数不满足领料数1".
                                    undo,retry.
                                end.
                            
                                v_qty_rct = 0 .
                                for each tr_hist
                                    use-index tr_nbr_eff
                                    where tr_domain = global_domain
                                    and   tr_nbr    = wo_nbr 
                                    and   tr_lot    = wo_lot
                                    and   tr_type   = "RCT-WO"
                                    /*and   tr_serial = t1_lot */
                                    no-lock:
                                    v_qty_rct = v_qty_rct + tr_qty_loc . 
                                end.

                                if v_qty_rct < t1_qty_iss then do:
                                    
                                    message "错误:此工单完成数不满足领料数2".
                                    undo,retry.
                                end.
                            end.
                        end. /*else if index(t1_zpwo,",") = 0 */
                        else do:
                            v_ii      = 0 .
                            v_qty_rct = 0 .
                            do v_ii = 1 to num-entries(t1_zpwo,",") :
                                v_wo_tmp = entry(v_ii,t1_zpwo,",") .                               
                                if v_wo_tmp > "" then do:
                                    find first wo_mstr where wo_domain = global_domain and wo_lot = v_wo_tmp no-lock no-error .
                                    if not avail wo_mstr then do:
                                        message "错误:无此加工单ID(" v_wo_tmp "),请重新输入" .
                                        undo,retry.
                                    end.

                                    if wo_qty_comp + wo_qty_rjct < wo_qty_ord  then do:
                                        
                                        message "错误:此工单数量未结"  v_wo_tmp .
                                        undo,retry.
                                    end.


                                    /*v_qty_rct = v_qty_rct + wo_qty_comp. */
                                    for each tr_hist
                                        use-index tr_nbr_eff
                                        where tr_domain = global_domain
                                        and   tr_nbr    = wo_nbr 
                                        and   tr_lot    = wo_lot
                                        and   tr_type   = "RCT-WO"
                                        /*and   tr_serial = t1_lot */
                                        no-lock:
                                        v_qty_rct = v_qty_rct + tr_qty_loc . 
                                    end.

                                end.
                            end.
                            if v_qty_rct < t1_qty_iss then do:
                                message "错误:工单累计完成数(" v_qty_rct ")不满足领料数.".
                                undo,retry.
                            end.
                        end.
                    end. /*do on error undo,retry :*/
            end.
        end.



end. /*sw_block:*/

/***************************/

find first temp1 no-error.
if not avail temp1 then do:
    message "本次无任何修改,单据已删除" .
    choice = no.
    find first xzp_det where xzp_domain = global_domain and xzp_wolot = wolot no-error.
    if avail xzp_det then do:
        for each xzp_det where xzp_domain = global_domain and xzp_wolot = wolot :
            delete xzp_det.
        end.
    end.
    release xzp_det.
end.

if choice then do :  

    /*明细档**********/
    for each xzp_det 
        where xzp_domain = global_domain 
        and   xzp_wolot  = wolot
        exclusive-lock :
        delete xzp_det .
    end.

    for each temp1 
        where t1_zpwo > ""  :
        find first xzp_det
            where xzp_domain = global_domain 
            and   xzp_wolot  = wolot
            and   xzp_zppart = t1_part
            /*and   xzp_zplot  = t1_lot */
        no-error.
        if not avail xzp_det then do:
            create xzp_det .
            assign xzp_domain   = global_domain 
                   xzp_wonbr    = wonbr
                   xzp_wolot    = wolot
                   xzp_zppart   = t1_part 
                   /*xzp_zplot    = t1_lot*/
                   xzp_qty_iss  = t1_qty_iss 
                   xzp_zpwo     = t1_zpwo
                   xzp_mod_user = global_userid
                   xzp_mod_date = today
                   .
        end.
    end. /*for each temp1*/
    release xzp_det.
message "ZP件的工单已指定完成." .
end.  /*if choice then*/


end. /* mainloop: */
{wbrp04.i &frame-spec = a}
