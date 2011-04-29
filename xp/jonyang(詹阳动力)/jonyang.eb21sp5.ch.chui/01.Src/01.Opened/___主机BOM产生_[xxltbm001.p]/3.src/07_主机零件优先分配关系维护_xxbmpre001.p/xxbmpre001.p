/*xxbmpre001.p 主机零件优先分配关系维护 */
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
v_framesize    = 15 .


define temp-table temp1 no-undo
    field t1_line     as integer       
    field t1_part     like wo_part     
    field t1_desc     like pt_desc1    
    field t1_lot      like ld_lot   
    field t1_wolot    like wo_lot
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
   t1_lot              label "主机号"
   t1_part             label "物料号"
   t1_desc             label "物料说明"
with frame zzz1 width 80 v_framesize down 
title color normal  "工单主机明细".  


{wbrp01.i}
mainloop:
repeat:
    for each temp1 : delete temp1. end. 

    v_ii = 0 .

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
    

    if index("R,C",wo_status) = 0
    then do:
        message "错误:仅维护限R,C状态工单".
        undo,retry.
    end.

    for each tr_hist
        use-index tr_nbr_eff
        where tr_domain = global_domain
        and   tr_nbr    = wo_nbr 
        and   tr_lot    = wo_lot
        and   tr_type   = "RCT-WO"
        no-lock:

        find first temp1 where t1_part  = tr_part and t1_lot = tr_serial no-error .
        if not avail temp1 then do:
            v_ii = v_ii + 1 .
            create temp1 .
            assign t1_line      = v_ii
                   t1_part      = tr_part 
                   t1_lot       = tr_serial
                   t1_wolot     = wo_lot
                   .
            find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
            t1_desc = if avail pt_mstr then pt_desc1 else "" .               
        end.

    end. /*for each tr_hist*/



    v_counter = 0 .
    for each temp1 :
        v_counter = v_counter + 1 .
    end.

    if v_counter = 0  then  do:
        message "无主机入库记录" .
        undo, retry .
    end.
    /*if v_counter >= 8 then message "每次最多显示8行" . */


    choice = no .
    ststatus = stline[3].
    status input ststatus.

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
                    &display2     = t1_lot   
                    &display3     = t1_part    
                    &display4     = t1_desc       
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
            then do:
                vv_recid = ? . /*退出前清空vv_recid*/
                leave.
            end.  /*if keyfunction(lastkey)*/  

            /*temp1为工单主机的入库明细,不可新增或删除*/
        
            /*修改现有记录*/
            if vv_recid <> ? then do:
                find first temp1 where recid(temp1) = vv_recid no-error .
                if avail temp1 then do:
                    hide frame a no-pause.
                    hide frame zzz1 no-pause.
                    {gprun.i ""xxbmpre001a.p"" "(input t1_part , input t1_lot , input t1_wolot )"}
                end.
            end.

    end. /*sw_block:*/


end. /* mainloop: */
{wbrp04.i &frame-spec = a}
