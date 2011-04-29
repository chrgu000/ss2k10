/* xsquit02.i 结束反馈的part2                                               */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[ 在xsmf002的最开始赋值 xslndefine.i  
2.本文件被结束反馈指令xsquit.p,吃饭,开会指令 和主程式xsmf002.p调用
3.关闭此用户所有机器的未结指令(理论上,应该是每个机器只有一笔是未结的) 

*/



define var v_time_used as integer . /*时间反馈*/
define var v_qty_fb    as decimal . /*数量反馈*/

v_date   = today.                 /*执行日期*/
v_time   = time - (time mod 60) . /*执行时间:变量保证时间点一致*/
v_time_used = 0 .                 /*累计的时间*/
v_qty_fb   = 0 .                  /*累计的数量*/




/*结束每一笔未结指令*/
for each tt :
    find xxfb_hist where recid(xxfb_hist) = t_rec  no-error .
    if avail xxfb_hist and xxfb_date_end = ? then do:  /*之前有指令,且是未结指令,才执行本段程式 */
        
        /*指令结束*/
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

        /*提示信息*/
        /*message   "用户/机器:"  xxfb_user  "/"  xxfb_wc skip
                  "工单/工序:    "  xxfb_wolot "/"  xxfb_op skip
                  "指令结束:"   xxfb_type2  "       "
        view-as alert-box title "".
        */
    end. /*if avail xxfb_hist*/

end. /*for each tt*/


{xsgetuser01.i} /*记录此用户本次刷读的机器和条码,作为下次登陆时的默认值*/

