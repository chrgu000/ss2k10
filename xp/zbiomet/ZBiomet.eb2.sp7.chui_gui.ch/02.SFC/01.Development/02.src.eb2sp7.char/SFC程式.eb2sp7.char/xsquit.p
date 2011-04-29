/* xsquit.p 离开SFC系统,并结束此用户在所有机器的作业                       */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */


/*      
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*会计期间检查*/
       */



/*检查是否后处理工序的机器v_tail_wc*/
{xstimetail01.i}

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}





define var v_now  as char label "时间" format "x(20)" .
form
    v_user    label "操作员" format "x(16)"
    v_wc      label "机器"  
    xwc_desc   format "x(10)" no-label 
    v_now     label "时间"  colon 57
with frame top1 
title color normal " ZBIOMET SHOPFLOOR SYSTEM "
side-labels 
width 80  .   


hide all no-pause .
define var v_leave as logical format "Y/N".
mainloop:
repeat: /*leave*/

    {xsquit01.i} /*找出未结指令*/
    

    /*显示操作员/机器/时间*/
    view frame top1 .
    v_now = string(string(year(today),"9999") + "/" 
            + string(month(today),"99") + "/" 
            + string(day(today),"99") + " " 
            + string(time,"HH:MM:SS") ) .
    disp v_now with frame top1.

    find first xemp_mstr where xemp_addr = v_user no-lock no-error .
    if avail xemp_mstr then disp caps(xemp_addr + " -" + xemp_lname) @ v_user with frame top1 .

    find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
    if avail xwc_mstr then disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame top1 .


    

    /*显示未结指令*/
    view frame b .
    loopdisp: 
    for each tt no-lock ,
        each xxfb_hist
        where recid(xxfb_hist) = t_rec  
        break by xxfb_trnbr
        on endkey undo, leave loopdisp 
        with frame b 
        title color normal "未结指令清单"
        13 down width 80:

        display
            xxfb_trnbr                      format ">>>>>>"  label "交易号"
            xxfb_wc                         format "x(8)"    label "机器"
            xxfb_type                       format "x(2)"    column-label "指!令"
            xxfb_type2                      format "x(9)"    label "交易类型"
            xxfb_date                                        label "交易日期"
            string(xxfb_time_start,"HH:MM") format "x(5)"    column-label "开始!时间"
            /*string(xxfb_time_end,"HH:MM")*/
            "    "                          format "x(4)"    column-label "结束!时间"
            xxfb_wolot                      format "x(7)"    label "工单ID"
            xxfb_op                         format ">9"      label "OP"
            
            xxfb_rmks                       format "x(13)"   label "备注"
        with frame b.
        down 1 with frame b.

        if frame-line(b) = frame-down(b) then pause.

    end. /*for each,  loopdisp*/
    message "列表完毕" .

    v_leave = yes .
    find first tt no-lock no-error .
    if not avail tt then do:
        message "无未结指令,按任意键退出系统..." view-as alert-box title "" .
        quit .
    end.
    else do:
        message "全部结束,并退出系统 ?" /*此用户在当前机器   view-as alert-box buttons Yes-No title ""*/  update v_leave .
        if v_leave then do:
            {xsquit02.i} /*结束未结指令*/
            v_msgtxt = "指令已结束" .
            quit.
        end. /*if v_leave*/
    end.

leave .
end. /*leave*/

hide frame top1 no-pause .
hide frame b no-pause .
