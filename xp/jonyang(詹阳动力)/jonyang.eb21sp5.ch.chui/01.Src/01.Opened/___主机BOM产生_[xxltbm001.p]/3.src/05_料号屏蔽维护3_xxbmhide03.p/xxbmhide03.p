/*xxbmhide003.p 主机料号屏蔽维护3 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1   Created On: 20100907   By: Softspeed Roger Xiao                               */



{mfdtitle.i "100907.1"}


define var v_lot  like ld_lot   no-undo.
define var v_part like ld_part  no-undo.
define var desc1  like pt_desc1 no-undo.
define var desc2  like pt_desc2 no-undo.

define var v_ii           as integer .
define var v_counter      as integer .
define var choice         as logical initial no.
define var v_yn1          as logical initial yes  .
define var vv_recid       as recid .
define var vv_first_recid as recid .
define var v_framesize    as integer .
vv_recid       = ? .
vv_first_recid = ? .
v_framesize    = 8 .


define temp-table temp1 no-undo
    field t1_line     as integer       
    field t1_part     like wo_part  
    field t1_desc     like pt_desc1 format "x(48)"  
    field t1_hide     as logical     
    .

form
    SKIP(.2)
    v_lot               colon 25 label "主机编号"
    desc1               no-label at 47 no-attr-space
    v_part              colon 25 label "零件编品"
    desc2               no-label at 47 no-attr-space    
with frame a  side-labels width 80 attr-space.
/*setFrameLabels(frame a:handle).*/



form 
   t1_line             label "行" format ">>9"
   t1_part             label "物料号"
   t1_desc             label "物料说明"
   t1_hide             label "隐藏"
with frame zzz1 width 80 v_framesize down 
title color normal  "BOM明细".  

view frame a .
view frame zzz1 .

{wbrp01.i}
mainloop:
repeat:
    for each temp1 : delete temp1. end. 

    update v_lot with frame a .

    find first xbm_mstr 
        where xbm_domain = global_domain 
        and xbm_lot = v_lot 
    no-lock no-error .
    if not avail xbm_mstr then do:
        message "错误:主机BOM并未产生,请重新输入" .
        undo,retry .
    end.

    v_part = xbm_part .
    find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .

    disp 
        v_lot
        v_part
        desc1
        desc2
    with frame a .

    v_ii = 0 .    
    for each xbmd_det 
        where xbmd_domain = global_domain 
        and   xbmd_lot    = xbm_lot 
        and   xbmd_par    = xbm_part
        and   xbmd_wolot  = xbm_wolot
        no-lock :

        find first temp1 
            where t1_part = xbmd_comp 
        no-error .
        if not avail temp1 then do:
            find first pt_mstr where pt_domain = global_domain and pt_part = xbmd_comp no-lock no-error.
            
            v_ii = v_ii + 1 .
            create temp1 .
            assign 
                t1_part = xbmd_comp 
                t1_line = v_ii 
                t1_desc = if avail pt_mstr then trim(pt_Desc1) + trim(pt_desc2) else "" 
                t1_hide = if xbmd_hide = "Y" then yes else no 
                .
        end.
    end. /*for each xbmd_det*/
    for each xbmzp_det 
        where xbmzp_domain = global_domain 
        and   xbmzp_lot    = xbm_lot 
        and   xbmzp_par    = xbm_part
        and   xbmzp_wolot  = xbm_wolot
        no-lock :

        find first temp1 
            where t1_part = xbmzp_comp 
        no-error .
        if not avail temp1 then do:
            find first pt_mstr where pt_domain = global_domain and pt_part = xbmzp_comp no-lock no-error.
            
            v_ii = v_ii + 1 .
            create temp1 .
            assign 
                t1_part = xbmzp_comp 
                t1_line = v_ii 
                t1_desc = if avail pt_mstr then trim(pt_Desc1) + trim(pt_desc2) else "" 
                t1_hide = if xbmzp_hide = "Y" then yes else no 
                .
        end.
    end. /*for each xbmzp_det*/



    v_counter = 0 .
    for each temp1 :
        v_counter = v_counter + 1 .
    end.

    if v_counter = 0  then  do:
        message "无BOM明细记录" .
        undo, retry .
    end.

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
                    &display2     = t1_part   
                    &display3     = t1_desc     
                    &display4     = t1_hide                 
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
            if lastkey = keycode("F5") 
                or lastkey = keycode("CTRL-D")
            then do:
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
                            update t1_hide with frame zzz1.
                        end. /*do on error undo,retry :*/
                end.
            end.
    end. /*sw_block:*/

    if choice then do :  
        for each temp1 :
            for each xbmd_det 
                where xbmd_domain = global_domain 
                and   xbmd_lot    = xbm_lot 
                and   xbmd_par    = xbm_part
                and   xbmd_wolot  = xbm_wolot
                and   xbmd_comp   = t1_part
                :
                xbmd_hide = if t1_hide =  yes then "Y" else "" .
            end. /*for each xbmd_det*/
            for each xbmzp_det 
                where xbmzp_domain = global_domain 
                and   xbmzp_lot    = xbm_lot 
                and   xbmzp_par    = xbm_part
                and   xbmzp_wolot  = xbm_wolot
                and   xbmzp_comp   = t1_part 
                :
                xbmzp_hide = if t1_hide =  yes then "Y" else "" .
            end. /*for each xbmzp_det*/            
        end. /*for each temp1*/
    end.  /*if choice then*/
end. /* mainloop: */
{wbrp04.i &frame-spec = a}
