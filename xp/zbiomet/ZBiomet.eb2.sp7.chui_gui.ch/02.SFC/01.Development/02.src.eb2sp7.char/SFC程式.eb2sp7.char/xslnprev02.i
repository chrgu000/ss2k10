/* xslnprev02.i 结束此用户本机器所有未结指令,累计准备和运行时间  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[] 在xsmf002的最开始赋值 xslndefine.i  
2.本文件被所有指令程式调用
3.找此用户本机器所有未结的指令 by 用户 by 机器



指令变更要依次修改的文件:

*/



define var v_time_used as integer . /*时间反馈*/
define var v_qty_fb    as decimal . /*数量反馈*/

v_time_used = 0 .
v_qty_fb   = 0 .


define temp-table tt  
    field t_rec as recid
    field t_wc  as char .
for each tt : delete tt . end. 

/*找此用户本机器所有未结的指令xxfb_hist*/
for each xxfb_hist  
        use-index xxfb_userwc 
        where xxfb_user = v_user
        and xxfb_wc     = v_wc 
        and xxfb_date_end = ? 
        no-lock 
        break by xxfb_user by xxfb_wc by xxfb_trnbr :

        find first tt where t_rec = recid(xxfb_hist) no-lock no-error .
        if not avail tt then do:
            create tt .
            assign t_rec = recid(xxfb_hist) 
                   t_wc  = xxfb_wc .
        end.
end.

/*结束每一笔未结指令*/
for each tt :
    find xxfb_hist where recid(xxfb_hist) = t_rec  no-error .
    if avail xxfb_hist and xxfb_date_end = ? then do:  /*之前有指令,且是未结指令,才执行本段程式 */

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

    end. /*if avail xxfb_hist*/
end. /*for each tt*/