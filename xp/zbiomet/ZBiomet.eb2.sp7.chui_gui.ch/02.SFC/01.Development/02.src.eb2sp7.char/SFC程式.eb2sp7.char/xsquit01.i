/* xsquit01.i 结束反馈的part1                                               */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.v_line_prev[ 在xsmf002的最开始赋值 xslndefine.i  
2.本文件被结束反馈指令xsquit.p,吃饭,开会指令 和主程式xsmf002.p调用
3.关闭此用户所有机器的未结指令

*/

define temp-table tt  
    field t_rec as recid
    field t_wc  as char .
for each tt : delete tt . end. 

/*找此用户所有机器的未结指令*/
for each xxfb_hist  
        use-index xxfb_userwc 
        where xxfb_user = v_user
        /*and xxfb_wc     = v_wc*/ 
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

/*这里要不要加校验? 暂时不用*/
