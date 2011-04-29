/* xsmf002frm.i  called by xsmf002.p   BARCODE SFC SYSTEM MAIN FRAME frame defines      */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

form
    /*v_user    label "操作员"  
    xemp_lname format "x(8)" no-label */ 
    v_user2    label "操作员" format "x(16)"
    v_wc      label "机器"  
    xwc_desc   format "x(10)" no-label 
    v_now     label "时间"  colon 57
with frame top1 
title color normal " ZBIOMET SHOPFLOOR SYSTEM "
side-labels 
width 80  .   

define var v_user_name as char format "x(16)" .
form 
    v_user_name        colon 10  format "x(16)"  label "雇员名称"  
    xemp_addr          colon 40 label "雇员代码" 
    v_wc               colon 10 label "机器代码"   
    xwc_desc           colon 40 format "x(10)" label "机器名称"   

    v_sn1              colon 10  label "工单条码"  
    xwr_desc            colon 32  label "工序说明" format "x(8)"
    v_line             colon 55  label "  操作指令"
    xcode_cmmt                    no-label format "x(16)" 
    
    xxwrd_qty_ord      colon 10  label "订购数" 
    v_qty_open         colon 32  label "未结数"
    v_wonbr            colon 55  label "工单号" format "x(18)"
    xxwrd_close                  no-label format "Y/ "

    xxwrd_qty_comp     colon 10  label "合格数" 
    xxwrd_qty_rework   colon 32  label "返工件次"                     
    xxwrd_time_setup   colon 55  label "准备时间" 

    xxwrd_qty_rejct    colon 10  label "报废数" 
    xxwrd_qty_return   colon 32  label "返工完成" 
    xxwrd_time_run     colon 55  label "运行时间" 


with frame main2 
side-labels 
width 80 
no-box .


form with frame main1 .
/*如要修改行数,需查找修改所有: *frame_main1_行数*  */
/***********
main1调用方式:  --->called by procedure disphist
for each xxx
    with frame main1 10 down width 80:

    disp xxx with frame main1 .
    down 1   with frame main1 .

end.
************/ 


/*-----------------------------------------------------------------------------------------------------------*/

procedure disphist: /*最近操作记录显示: 本机器,本人,今天所有的交易记录*/
do on error undo,retry  :
    for each temp1 : delete temp1 . end.
    clear frame main1 all no-pause. 

    v_nn = 0 .
    for each xxfb_hist no-lock
        use-index xxfb_dateuser
        where xxfb_date = today
        and   xxfb_user = v_user
        and   xxfb_wc   = v_wc
        /*and   xxfb_date_start = today*/ 
        break by xxfb_trnbr descending :        
        

        find first temp1 where t1_trnbr = xxfb_trnbr no-lock no-error .
        if not avail temp1 then do:

            v_nn = v_nn + 1 .
            create temp1 .
            assign t1_trnbr        = xxfb_trnbr 
                   t1_date_start   = xxfb_date_start
                   t1_date_end     = xxfb_date_end   
                   t1_time_start   = string(xxfb_time_start,"HH:MM")
                   t1_time_end     = if xxfb_date_end <> ? then string(xxfb_time_end,"HH:MM")  else "" 
                   t1_time_used    = if xxfb_date_end = ? then 0 
                                     else ((xxfb_date_end - xxfb_date_start) * (60 * 60 * 24) - xxfb_time_start + xxfb_time_end) / 60 
                   t1_type         = xxfb_type2 
                   t1_wolot        = xxfb_wolot     
                   t1_op           = xxfb_op        
                   t1_qty          = xxfb_qty     
                   t1_rmks         = xxfb_rmks                                                
                   .
        end.
        if v_nn = 7 /*frame_main1_行数*/ then leave .


    end.   /*for each xxfb_hist*/

    v_nn = 0 .
    for each temp1 
        break by t1_trnbr 
        with frame main1 7 /*frame_main1_行数*/ down width 80:
        
        disp 
            t1_trnbr        label "交易号"       format ">>>>>>"
            t1_type         label "交易类型"     format "x(10)"
            t1_date_start   label "开始日期"
            t1_time_start   label "开始"
            t1_time_end     label "结束"
            t1_time_used    when (t1_date_end <> ? )
                            label "耗时"         format ">>>9" 
            t1_wolot        label "工单ID"       format "x(7)"
            t1_op           label "OP"           format ">>>"
            t1_qty          when (t1_qty <> 0 )         
                            label "数量"         format "->>>>>9.9<<"
            t1_rmks         label "备注"         format "x(12)"
        with frame main1 .

        v_nn = v_nn + 1 .
        if v_nn < 7 /*frame_main1_行数*/ then down 1 with frame main1 .

    end. /*for each temp1*/

end. /*do on error*/
end procedure .    /*procedure disphist*/


form 
    skip(2)
    "                         * * * * W E L C O M E * * * *                        "
    "                 M F G / P R O   SHOPFLOOR   CONTROL   SYSTEM                 "
    "                                                                              "
    "                                     QAD                                      "
    "                                6450 Via Real                                 "
    "                            Carpinteria, CA  93013                            "
    "                                                                              "
    "                                                                              "
    "                               (805) 684-6614                                 "
    "                               (805) 684-1890 FAX                             "
    "                                                                              "
    "              Copyright 1986-2002 QAD Inc.  All rights reserved.              "
    "               This product may not be reproduced or distributed              " 
    skip(2)
    v_user        colon 35  label "User ID"
    v_pwd         colon 35  label "Password"

with frame login 
side-labels width 80 .