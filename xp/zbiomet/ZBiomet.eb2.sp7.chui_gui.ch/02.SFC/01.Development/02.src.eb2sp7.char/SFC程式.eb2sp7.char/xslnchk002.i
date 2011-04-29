/* xslnchk002.i 操作指令逻辑检查 */
/* REVISION: 1.0         Last Modified: 2008/11/29   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
1.called by xsmf002.p 和 xsdowntime.p
2.检查当前指令是否应该被执行(前后指令衔接)
3.指令判读逻辑如下
*/    

/*
指令判读逻辑如下:
1.按用户和机器查找前一笔交易
2.
*/



if  (
    v_line = v_line_prev[1]  /*准备时间*/  
or  v_line = v_line_prev[2]  /*运行时间*/  
or  v_line = v_line_prev[3]  /*合格反馈*/  
or  v_line = v_line_prev[4]  /*报废反馈*/  
or  v_line = v_line_prev[5]  /*返工反馈*/  
or  v_line = v_line_prev[18] /*停机时间*/  
or  v_line = v_line_prev[19] /*机器维修*/  
or  v_line = v_line_prev[20] /*开会时间*/  
or  v_line = v_line_prev[21] /*吃饭时间*/  
or  v_line = v_line_prev[23] /*正常停机*/  
or  v_line = v_line_prev[24] /*其他停机*/  
    ) 
then do:
    /*同一时刻,一个工单条码(wo+op)只能被一台机器反馈,(可多人)
    if v_wolot <> "" then do:
        find first xxfb_hist  
                where xxfb_wolot  = v_wolot 
                and xxfb_op       = v_op
                and xxfb_date_end = ? 
                and xxfb_wc       <> v_wc 
        no-lock no-error.
        if avail xxfb_hist then do:
            message "此工单条码正在被(用户" xxfb_user "/机器 " xxfb_wc ")使用" .
            undo,retry .
        end.
    end.*/

    if v_tail_wc = no then do:
        /*同一时刻,一台机器只能被一个人使用*/
        find first xxfb_hist  
                where xxfb_wc = v_wc and xxfb_date_end = ? 
                and xxfb_user <> v_user
        no-lock no-error.
        if avail xxfb_hist then do:
            message "机器正在被(用户" xxfb_user ")使用" .
            undo,retry .
        end.


        /*同一时刻,一个工单条码(wo+op)只能被(一个人+一台机器)反馈*/
        if v_wolot <> "" then do:
            find first xxfb_hist  
                    where xxfb_wolot = v_wolot 
                    and xxfb_op      = v_op
                    and xxfb_date_end = ? 
                    and (xxfb_user <> v_user or xxfb_wc <> v_wc )
            no-lock no-error.
            if avail xxfb_hist then do:
                message "此工单条码正在被(用户" xxfb_user "/机器 " xxfb_wc ")使用" .
                undo,retry .
            end.
        end.    
    end. /*非后处理工序的机器*/



end. /*if v_line <> v_line_prev[13]*/



/*找最后一笔未结xxfb_hist*/
v_recno = ? .
for each xxfb_hist  
        use-index xxfb_userwc 
        where xxfb_user = v_user and xxfb_wc = v_wc 
        and xxfb_date_end = ? 
        and ((xxfb_wolot = v_wolot and xxfb_op = v_op) 
            or xxfb_wolot = "" )
        no-lock 
        break by xxfb_user by xxfb_wc by xxfb_trnbr :

        if last(xxfb_user) then v_recno = recid(xxfb_hist) .
end.

find xxfb_hist where recid(xxfb_hist) = v_recno  no-lock no-error .
if avail xxfb_hist and xxfb_date_end = ? then do: /*之前有指令,且是未结指令,才执行本段程式 */

    if (v_line = v_line_prev[1] and xxfb_wolot = v_wolot and xxfb_op = v_op ) or 
       (v_line = v_line_prev[2] and xxfb_wolot = v_wolot and xxfb_op = v_op ) or
       v_line = v_line_prev[19] or
       v_line = v_line_prev[20] or
       v_line = v_line_prev[21] or
       v_line = v_line_prev[23] or
       v_line = v_line_prev[24]
    then do:
        if xxfb_type = v_line then do:
            message "指令已在执行,请勿重复刷读." .
            undo,retry .
        end.
    end. /*if v_line = v_line_prev[1]*/

end.  /*if avail xxfb_hist*/



/* 指令,循环关系判断: */


/*合格反馈,报废反馈,返工反馈 : 非外协单工序,则之前必须有准备或运行时间*/
if v_line = v_line_prev[3] 
or v_line = v_line_prev[4] 
or v_line = v_line_prev[5]  
then do:
    find first xxwrd_det 
        where xxwrd_wolot = v_wolot 
        and xxwrd_op = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close = no 
    no-lock no-error .
    if avail xxwrd_det then do:
        find first xpod_det
            use-index xpod_part
            where xpod_part = xxwrd_part 
            and xpod_wo_lot = xxwrd_wolot
            and xpod_op     = xxwrd_op
        no-lock no-error .
        if not avail xpod_det then do:
            find first xxfb_hist use-index xxfb_wolot 
                where xxfb_wolot = v_wolot 
                and   xxfb_op    = v_op 
                and  (xxfb_type  = v_line_prev[2]   /*运行时间*/
                    or xxfb_type = v_line_prev[1]   /*准备时间*/)
            no-lock no-error .
            if not avail xxfb_hist then do:
                message "指令无法执行:非外协工单工序,且尚未准备或运行" .
                undo,retry .
            end. /*if avail xxfb_hist*/
        end.
    end.

end. /*if v_line = v_line_prev[3]*/

