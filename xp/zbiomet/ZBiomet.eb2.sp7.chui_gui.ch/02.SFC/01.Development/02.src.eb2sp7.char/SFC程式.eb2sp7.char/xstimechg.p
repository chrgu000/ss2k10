/* xstimechg.p  时间调整                                                   */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

/*检查是否后处理工序的机器v_tail_wc*/
{xstimetail01.i}

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}

define var v_fbnbr like xxfb_trnbr .
define var v_date_start as date  no-undo.
define var v_date_end   as date  no-undo.
define var v_time_start as integer .
define var v_time_end   as integer .
define var v_hs  as integer format "99" no-undo . /*开始小时*/
define var v_ms  as integer format "99" no-undo . /*开始分钟*/
define var v_he  as integer format "99" no-undo . /*结束小时*/
define var v_me  as integer format "99" no-undo . /*结束分钟*/
define var v_time_used as integer .

define buffer xxfbhist for xxfb_hist .


define var v_multi as logical format "Y/N" initial no. 
define var v_yn1 as logical format "Y/N" initial no. 
define var v_ii as integer  format "9" .
define temp-table temp1
    field t1_line        as integer 
    field t1_date_start  as date 
    field t1_date_end    as date 
    field t1_time_start  as integer 
    field t1_time_end    as integer 
    index t1_line t1_line
    .



form
skip(1)                
v_fbnbr                         colon 12 label "交易号"
skip(1)
xxfb_type                       colon 12 label "交易类型"     
xxfb_type2                      no-label                  xxfb_nbr                        colon 50 label "单据号"       
xxfb_date                       colon 12 label "执行日期" xxfb_program                    colon 50 label "程式"     format "x(24)"         
xxfb_time                       colon 12 label "执行时间" xxfb_user                       colon 50 label "用户"       
xxfb_part                       colon 12 label "项目号"   xpt_desc1                        colon 50 label "品名"
xpt_um                           colon 12 label "单位"     xpt_desc2                        colon 50 label "规格"
skip(1)
xxfb_wonbr                      colon 12 label "工单号"    xxfb_wolot                      colon 50 label "工单标志"
xxfb_op                         colon 12 label "工序"      xxfb_wc                         colon 50 label "机器"
xxfb_qty_fb                     colon 12 label "数量"      xxfb_rsn_code                   colon 50 label "原因"      
xxfb_wotype                     colon 12 label "工单类型"  xxfb_rmks                       colon 50 label "备注"      
xxfb_update                     colon 12 label "已更新" 
skip(2)

v_date_start                    colon 12 label "开始日期"  
v_date_end                      colon 50 label "结束日期"   
v_hs                            colon 12 label "开始时间"  v_ms label "" 
v_he                            colon 50 label "结束时间"  v_me label "" 
skip(1)

with frame a 
title color normal "反馈时间调整"
side-labels width 80 .   


form 
v_ii                            colon 12 label "项次" 
v_date_start                    colon 12 label "开始日期"  
v_date_end                      colon 50 label "结束日期"   
v_hs                            colon 12 label "开始时间"  v_ms label "" 
v_he                            colon 50 label "结束时间"  v_me label "" 
with frame b side-labels overlay row 17 centered width 78 no-box .


form with frame c.






hide all no-pause .
view frame a .

find last xxfb_hist no-lock no-error .
v_fbnbr = if avail xxfb_hist then xxfb_trnbr else 0.


mainloop:
repeat :
    clear frame a all no-pause .
    for each temp1 : delete temp1 . end .

    v_date_start = ? .
    v_date_end   = ? .
    v_hs         = 0 .
    v_he         = 0 .
    v_ms         = 0 .
    v_me         = 0 .
    v_time_used  = 0 .

    find last xxfb_hist where xxfb_trnbr = v_fbnbr no-lock no-error .
    if avail xxfb_hist then do:
                v_date_start = xxfb_date_start .
                v_date_end   = xxfb_date_end .
                v_hs         = integer(entry(1,string(xxfb_time_start,"hh:mm"),":")) .
                v_ms         = integer(entry(2,string(xxfb_time_start,"hh:mm"),":")) .
                v_he         = integer(entry(1,string(xxfb_time_end,"hh:mm"),":")) .
                v_me         = integer(entry(2,string(xxfb_time_end,"hh:mm"),":")) .

                DISP 
                    xxfb_trnbr @ v_fbnbr   
                    xxfb_type       
                    xxfb_type2      
                    xxfb_nbr        
                    xxfb_user       
                    xxfb_date       
                    string(xxfb_time,"hh:mm")       @ xxfb_time       
                    xxfb_program    
                    xxfb_part            
                    xxfb_wonbr      
                    xxfb_wolot      
                    xxfb_op         
                    xxfb_wc         
                    xxfb_qty_fb     
                    xxfb_rsn_code   
                    xxfb_rmks       
                    xxfb_update     
                    xxfb_wotype     
                    
                    v_date_start 
                    v_date_end  
                    v_hs   
                    v_he   
                    v_ms   
                    v_me 

                with frame a.

                find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
                if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .
    end.

    update v_fbnbr with frame a editing:
        {xstimeout02.i " quit "    } 
        {xsmfnp11.i xxfb_hist xxfb_trnbr xxfb_trnbr "input v_fbnbr" }
        IF recno <> ?  THEN DO:
            v_date_start = xxfb_date_start .
            v_date_end   = xxfb_date_end .
            v_hs         = integer(entry(1,string(xxfb_time_start,"hh:mm"),":")) .
            v_ms         = integer(entry(2,string(xxfb_time_start,"hh:mm"),":")) .
            v_he         = integer(entry(1,string(xxfb_time_end,"hh:mm"),":")) .
            v_me         = integer(entry(2,string(xxfb_time_end,"hh:mm"),":")) .

            DISP 
                xxfb_trnbr @ v_fbnbr   
                xxfb_type       
                xxfb_type2      
                xxfb_nbr        
                xxfb_user       
                xxfb_date       
                string(xxfb_time,"hh:mm")       @ xxfb_time       
                xxfb_program    
                xxfb_part            
                xxfb_wonbr      
                xxfb_wolot      
                xxfb_op         
                xxfb_wc         
                xxfb_qty_fb     
                xxfb_rsn_code   
                xxfb_rmks       
                xxfb_update     
                xxfb_wotype  
                
                v_date_start 
                v_date_end  
                v_hs   
                v_he   
                v_ms   
                v_me   

            with frame a.

            find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
            if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .
        END.  /*if recno<> ?*/
    end.
    assign v_fbnbr .

    {xserr001.i "v_fbnbr" } /*检查数量栏位是否输入了问号*/

    find first xxfb_hist 
        use-index xxfb_trnbr 
        where xxfb_trnbr = v_fbnbr 
    no-lock no-error .
    if not avail xxfb_hist then do:
        message "无效交易号,请重新输入" .
        undo,retry .
    end.
    else do: /*avail*/
            find first xxfb_hist 
                use-index xxfb_trnbr 
                where xxfb_trnbr = v_fbnbr 
            exclusive-lock no-wait no-error .
            if not avail xxfb_hist then do:
                if locked xxfb_hist then do:
                    message  "记录正在被使用,按任意键退出" view-as alert-box title "" .
                    undo,leave mainloop.
                end.
            end.


            v_date_start = xxfb_date_start .
            v_date_end   = xxfb_date_end .
            v_hs         = integer(entry(1,string(xxfb_time_start,"hh:mm"),":")) .
            v_ms         = integer(entry(2,string(xxfb_time_start,"hh:mm"),":")) .
            v_he         = integer(entry(1,string(xxfb_time_end,"hh:mm"),":")) .
            v_me         = integer(entry(2,string(xxfb_time_end,"hh:mm"),":")) .

            DISP 
                xxfb_trnbr @ v_fbnbr   
                xxfb_type       
                xxfb_type2      
                xxfb_nbr        
                xxfb_user       
                xxfb_date       
                string(xxfb_time,"hh:mm")       @ xxfb_time       
                xxfb_program    
                xxfb_part            
                xxfb_wonbr      
                xxfb_wolot      
                xxfb_op         
                xxfb_wc         
                xxfb_qty_fb     
                xxfb_rsn_code   
                xxfb_rmks       
                xxfb_update     
                xxfb_wotype     
                
                v_date_start 
                v_date_end  
                v_hs   
                v_he   
                v_ms   
                v_me 

            with frame a.

            find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
            if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .


            if xxfb_date_end = ? then do:
                message "未结束指令,不允许调整时间" view-as alert-box title "" .
                undo,retry .
            end.

            if xxfb_type = v_line_prev[3]  or
               xxfb_type = v_line_prev[4]  or
               xxfb_type = v_line_prev[5]  
            then do:
                message "数量反馈指令,不允许调整时间" view-as alert-box title "" .
                undo,retry .
            end.

    end. /*avail*/

v_multi = no .
message "调整为多笔记录?"  update v_multi .

loopexe:
do on error undo,retry :
    hide frame c no-pause .
    clear frame c no-pause.
    if v_multi then do:  /*多笔记录*/
        message "调整为多笔." .
        view frame b .
        v_ii = 1 .
        loopb:
        repeat :
             
             clear frame b no-pause.
             update v_ii with frame b editing:
                if frame-field = "v_ii" then do:
                    {xstimeout02.i " quit "    } 
                    {xsmfnp11.i temp1  t1_line t1_line "input v_ii" }
                    if recno <> ? then do:
                        v_ii         = t1_line .
                        v_date_start = t1_date_start .
                        v_date_end   = t1_date_end   .
                        v_hs = integer(entry(1,string(t1_time_start,"hh:mm"),":")) .
                        v_ms = integer(entry(2,string(t1_time_start,"hh:mm"),":")) .
                        v_he = integer(entry(1,string(t1_time_end,"hh:mm"),":")) .
                        v_me = integer(entry(2,string(t1_time_end,"hh:mm"),":")) .                        

                        display v_ii v_date_start v_hs v_ms v_date_end  v_he v_me with frame b .
                    end. 
                end. 
                else do:
                    status input.
                    readkey . 
                    apply lastkey.  
                end. 
             end. /*update v_ii*/
             assign v_ii . 

             {xserr001.i "v_ii" } /*检查数量栏位是否输入了问号*/

             find first temp1 where t1_line = v_ii no-error .
             if avail temp1 then do:
                        v_date_start = t1_date_start .
                        v_date_end   = t1_date_end   .
                        v_hs = integer(entry(1,string(t1_time_start,"hh:mm"),":")) .
                        v_ms = integer(entry(2,string(t1_time_start,"hh:mm"),":")) .
                        v_he = integer(entry(1,string(t1_time_end,"hh:mm"),":")) .
                        v_me = integer(entry(2,string(t1_time_end,"hh:mm"),":")) .                        

                        display v_ii v_date_start v_hs v_ms v_date_end  v_he v_me with frame b .
             end.
             
             do on error undo,retry :
                find first temp1 where t1_line = v_ii no-error .
                if not avail temp1 then do:
                   message "添加新记录." .
                   v_date_start = xxfb_date_start .
                   v_date_end   = xxfb_date_end   .
                   v_hs = integer(entry(1,string(xxfb_time_start,"hh:mm"),":")) .
                   v_ms = integer(entry(2,string(xxfb_time_start,"hh:mm"),":")) .
                   v_he = integer(entry(1,string(xxfb_time_end,"hh:mm"),":")) .
                   v_me = integer(entry(2,string(xxfb_time_end,"hh:mm"),":")) .                        

                   display v_ii v_date_start v_hs v_ms v_date_end  v_he v_me with frame b .
                end.

                {xstimechg01.i "b"}

                create temp1 .
                assign t1_line = v_ii
                       t1_date_start = v_date_start  
                       t1_date_end   = v_date_end    
                       t1_time_start = v_time_start          
                       t1_time_end   = v_time_end       
                       v_ii = v_ii + 1 
                       .              

             end.


        end. /*loopb:*/
        
        hide frame b no-pause .
    end.  /*多笔记录*/
    else do on error undo , retry : /*单笔记录*/
            message "调整为单笔." .

            {xstimechg01.i "a"}

            create temp1 .
            assign t1_line = 1
                   t1_date_start = v_date_start  
                   t1_date_end   = v_date_end    
                   t1_time_start = v_time_start          
                   t1_time_end   = v_time_end       
                   .

    end.  /*单笔记录*/


    view frame c .
    clear frame c all no-pause. 
    for each temp1 break by t1_line with frame c  8 down width 70 overlay row 8 centered :
        disp t1_line       label "项次"
             t1_date_start label "开始日期"
             string(t1_time_start,"hh:mm")  label "开始时间"
             t1_date_end   label "结束日期"
             string(t1_time_end,"hh:mm")  label "结束时间"
             with frame c .
        down 1 with frame c .
    end.
    
    v_yn1 = yes.
    message "以上是否全部正确?" update v_yn1 .
    if v_yn1 then do:
        
        find first xxfbhist where xxfbhist.xxfb_trnbr = v_fbnbr no-error .
        if avail xxfbhist then do:
            xxfbhist.xxfb_nbr  = "D" .
            xxfbhist.xxfb_rmks = "Delete" .
            v_time_used        = (xxfbhist.xxfb_date_end - xxfbhist.xxfb_date_start ) * (60 * 60 * 24) + xxfbhist.xxfb_time_end - xxfbhist.xxfb_time_start .  
            
            for each temp1 :
                v_trnbr = 0 .
                v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
                run getnbr(input v_nbrtype ,output v_trnbr) .

                create  xxfb_hist .
                assign  xxfb_hist.xxfb_trnbr       = integer(v_trnbr) 
                        xxfb_hist.xxfb_date        = v_date  
                        xxfb_hist.xxfb_date_end    = t1_date_end  
                        xxfb_hist.xxfb_date_start  = t1_date_start  
                        xxfb_hist.xxfb_time        = v_time - (v_time mod 60)  
                        xxfb_hist.xxfb_time_end    = t1_time_end  
                        xxfb_hist.xxfb_time_start  = t1_time_start   
                        xxfb_hist.xxfb_nbr         = string(v_fbnbr) 
                        xxfb_hist.xxfb_program     = execname
                        xxfb_hist.xxfb_wotype      = xxfbhist.xxfb_wotype   
                        xxfb_hist.xxfb_qty_fb      = xxfbhist.xxfb_qty_fb   
                        xxfb_hist.xxfb_rmks        = ""     
                        xxfb_hist.xxfb_rsn_code    = xxfbhist.xxfb_rsn_code 
                        xxfb_hist.xxfb_user        = v_user     
                        xxfb_hist.xxfb_op          = xxfbhist.xxfb_op       
                        xxfb_hist.xxfb_wc          = xxfbhist.xxfb_wc       
                        xxfb_hist.xxfb_wolot       = xxfbhist.xxfb_wolot    
                        xxfb_hist.xxfb_wonbr       = xxfbhist.xxfb_wonbr    
                        xxfb_hist.xxfb_part        = xxfbhist.xxfb_part     
                        xxfb_hist.xxfb_type        = xxfbhist.xxfb_type     
                        xxfb_hist.xxfb_type2       = xxfbhist.xxfb_type2    
                        xxfb_hist.xxfb_update      = xxfbhist.xxfb_update   
                        .
            end. /*for each temp1*/
            v_msgtxt      = "时间调整 完成" .

            
            /*调整前后时间差(= new - old ),如果是准备或运行时间,累计入汇总表
            v_time_used   = (xxfb_hist.xxfb_date_end - xxfb_hist.xxfb_date_start ) * (60 * 60 * 24) + xxfb_hist.xxfb_time_end - xxfb_hist.xxfb_time_start  - v_time_used.  
            find first xxwrd_Det where xxwrd_wolot = xxfbhist.xxfb_wolot and xxwrd_op = xxfbhist.xxfb_op no-error .
            if avail xxwrd_Det then do:
                if xxfbhist.xxfb_type = v_line_prev[1] then xxwrd_time_setup = xxwrd_time_setup + v_time_used .
                if xxfbhist.xxfb_type = v_line_prev[2] then xxwrd_time_run   = xxwrd_time_run   + v_time_used .
            end.*/
            
            /*每次重新汇总准备或运行时间*/
            if xxfbhist.xxfb_type = v_line_prev[1] or
               xxfbhist.xxfb_type = v_line_prev[2] 
            then do:
                v_time_used   = 0 .
                for each xxfb_hist 
                    where xxfb_hist.xxfb_type = xxfbhist.xxfb_type  
                    and xxfb_hist.xxfb_wolot  = xxfbhist.xxfb_wolot 
                    and xxfb_hist.xxfb_op     = xxfbhist.xxfb_op
                    and xxfb_hist.xxfb_nbr    <> "D" 
                    and xxfb_hist.xxfb_date_end <> ? 
                    no-lock :
                    v_time_used = v_time_used  
                                  + (xxfb_hist.xxfb_date_end - xxfb_hist.xxfb_date_start ) * (60 * 60 * 24) 
                                  +  xxfb_hist.xxfb_time_end 
                                  -  xxfb_hist.xxfb_time_start .
                end.


                find first xxwrd_Det where xxwrd_wolot = xxfbhist.xxfb_wolot and xxwrd_op = xxfbhist.xxfb_op no-error .
                if avail xxwrd_Det then do:
                    if xxfbhist.xxfb_type = v_line_prev[1] then xxwrd_time_setup =  v_time_used .
                    if xxfbhist.xxfb_type = v_line_prev[2] then xxwrd_time_run   =  v_time_used .
                end.    

            end.
            

        end. /*if avail xxfbhist*/
    end. /*if v_yn1*/
    else do:
        undo loopexe, retry loopexe.
    end.
end. /*loopexe*/


leave .
end. /*mainloop*/
hide frame a no-pause .
hide frame c no-pause .

