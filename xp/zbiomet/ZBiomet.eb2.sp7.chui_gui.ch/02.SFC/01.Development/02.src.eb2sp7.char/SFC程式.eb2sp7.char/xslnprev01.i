/* xslnprev01.i 结束前笔指令,累计准备和运行时间  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[] 在xsmf002的最开始赋值 xslndefine.i  
2.本文件被所有指令程式调用
3.找前一笔未结记录 by 用户 by 机器 by wolot



指令变更要依次修改的文件:

*/

define var v_fix_edate as date label "结束日期" .  
define var v_fix_etime as integer  label "结束时间".
define var v_fix_eh as integer format "99" label "结束时间的小时".
define var v_fix_em as integer format "99" label "结束时间的分钟".

v_fix_edate = v_date .
v_fix_eh    = integer(substring(string(v_time,"hh:mm"),1,2)) .
v_fix_em    = integer(substring(string(v_time,"hh:mm"),4,2)) .

form
    skip(1)
    v_fix_edate colon 20  label "结束日期(月日年)"
    v_fix_eh    colon 20  label "结束时间(24时制)"     
    v_fix_em              label     ""
    skip(1)
with frame fixm 
title color normal "机器维修结束时间"
side-labels width 50 
row 8 centered overlay .   






define var v_time_used as integer . /*时间反馈*/
define var v_qty_fb    as decimal . /*数量反馈*/

v_time_used = 0 .
v_qty_fb   = 0 .

/*找最后一笔xxfb_hist*/
v_recno = ? .
if v_tail_wc then do:
    for each xxfb_hist  
            use-index xxfb_userwc 
            where xxfb_user = v_user and xxfb_wc = v_wc 
            and xxfb_date_end = ? 
            and ((xxfb_wolot  = v_wolot and xxfb_op = v_op )
                or xxfb_wolot = "" )
            no-lock 
            break by xxfb_user by xxfb_wc by xxfb_trnbr :

            if last(xxfb_user) then v_recno = recid(xxfb_hist) .
    end.
end. /*后处理机器*/
else do:
    for each xxfb_hist  
            use-index xxfb_userwc 
            where xxfb_user = v_user and xxfb_wc = v_wc 
            and xxfb_date_end = ? 
            no-lock 
            break by xxfb_user by xxfb_wc by xxfb_trnbr :

            if last(xxfb_user) then v_recno = recid(xxfb_hist) .
    end.
end. /*非后处理机器*/

find xxfb_hist where recid(xxfb_hist) = v_recno  no-error .
if avail xxfb_hist and xxfb_date_end = ? then do:  /*之前有指令,且是未结指令,才执行本段程式 */

    /*机器维修,结束时间可以手工(向之前)调整,*/
    if xxfb_type = v_line_prev[19]  then do on error undo,retry :
        message "机器维修尚未结束,请确认结束时间." .

        update v_fix_edate v_fix_eh v_fix_em with frame fixm.

        {xserr001.i "v_fix_eh" } /*检查数量栏位是否输入了问号*/
        {xserr001.i "v_fix_em" } /*检查数量栏位是否输入了问号*/

        if v_fix_edate = ? then do:
            message "请正确输入维修结束日期." .
            next-prompt v_fix_edate.
            undo,retry .
        end.

        if v_fix_eh >= 24 then do:
            message "请正确输入维修结束时间." .
            next-prompt v_fix_eh.
            undo,retry .
        end.

        if v_fix_em >= 60 then do:
            message "请正确输入维修结束时间." .
            next-prompt v_fix_em.
            undo,retry .
        end.

        v_fix_etime   = v_fix_eh * 60 * 60 + v_fix_em * 60  . 
        v_fix_etime   = v_fix_etime - (v_fix_etime mod 60). 
        if (integer(v_fix_edate) + v_fix_etime / 86400 ) > (integer(v_date) + (v_time - (v_time mod 60)) / 86400 ) then do:
            message "结束时间不可迟于:现在(" v_date "" string(v_time,"hh:mm") ")." .
            undo,retry .
        end.
        if (integer(xxfb_date_start) + xxfb_time_start / 86400 ) > (integer(v_fix_edate) + v_fix_etime / 86400 ) then do:
            message "结束时间不可早于:维修开始时间(" v_fix_edate "" string(v_fix_etime,"hh:mm") ")." .
            undo,retry .
        end.

        hide frame fixm no-pause .

        v_msgtxt = xxfb_type2 + ":指令结束,  "  .
        assign  xxfb_date_end    = v_fix_edate
                xxfb_time_end    = v_fix_etime .
    end. /*if xxfb_type = v_line_prev[19] */
    else do: /*非机器维修,结束时间都是now*/


        v_msgtxt = xxfb_type2 + ":指令结束,  "  .
        assign  xxfb_date_end    = v_date
                xxfb_time_end    = v_time .

        /*准备时间*/   
        if xxfb_type = v_line_prev[1] then do:
            if xxfb_date_start = v_date then do:
                v_time_used = xxfb_time_end - xxfb_time_start .
            end.
            else do:
                v_time_used = (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start + xxfb_time_end .
            end.

            find first xxwrd_det where xxwrd_wolot = xxfb_wolot and xxwrd_op = xxfb_op no-error .
            if avail xxwrd_Det then do:
                xxwrd_time_setup = xxwrd_time_setup + v_time_used .
            end.
            
        end.

        /*运行时间*/
        if xxfb_type = v_line_prev[2]  then do:
            if xxfb_date_start = v_date then do:
                v_time_used = xxfb_time_end - xxfb_time_start .
            end.
            else do:
                v_time_used = (xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start  + xxfb_time_end .
            end.

            find first xxwrd_det where xxwrd_wolot = xxfb_wolot and xxwrd_op = xxfb_op no-error .
            if avail xxwrd_Det then do:
                xxwrd_time_run = xxwrd_time_run + v_time_used .
            end.
        end.

        /*开会时间,吃饭时间,正常停机,等其他停机时间,
                            暂时这里不行做其他动作,只需前面记录结束时间即可*/

    end.  /*非机器维修,结束时间都是now*/
end. /*if avail xxfb_hist*/

