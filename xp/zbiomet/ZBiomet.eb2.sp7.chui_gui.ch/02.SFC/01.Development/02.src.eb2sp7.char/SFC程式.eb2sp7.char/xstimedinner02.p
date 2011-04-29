/* xstimedinner02.p  吃饭时间结束                                          */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

/*    
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*会计期间检查*/
         */


define buffer xxfb_buf for xxfb_hist .
/*--------------------------------------------------------------------------------------------------*/


mainloop:
repeat:

    find first xxpause_det where xxpause_user = v_user no-lock no-error .
    if not avail xxpause_Det then do: 
        message  "无任何暂停的作业,按任意键退出" view-as alert-box title "" .
        undo,leave mainloop.
    end.
    else do:
        for each xxpause_det where xxpause_user = v_user no-lock :
            find first xxwrd_Det 
                    where xxwrd_wrnbr = integer(v_wrnbr) 
                    and xxwrd_wolot   = xxpause_wolot
                    and xxwrd_op      = xxpause_op 
                    and (xxwrd_status = "" or xxwrd_status  = "N" )
                    and xxwrd_close   = no
            exclusive-lock no-wait no-error .
            if not avail xxwrd_det then do:
                if locked xxwrd_det then do:
                    message  "工单条码正在被使用,按任意键退出" view-as alert-box title "" .
                    undo,leave mainloop.
                end.
            end.
        end.
    end.


    v_date   = today.
    v_time   = time - (time mod 60) . /*保证时间点一致*/
    v_msgtxt = "" .   /*提示信息*/

    /*更新:  所有未结指令操作历史记录,这里应该只是吃饭指令*/
    do  : 
        {xsquit01.i}
        {xsquit02.i}
    end.  


    /*更新:恢复所有暂停的指令*/
    find first xxpause_det where xxpause_user = v_user no-lock no-error .
    if avail xxpause_Det then do: /*xxpause_det*/

        /*检查xxpause_Det锁定情况,并锁定表*/
        define temp-table ttt field ttt_recid as recid .
        for each ttt : delete ttt . end. 
        for each xxpause_det where xxpause_user = v_user no-lock :
            find first ttt where ttt_recid = recid(xxpause_det) no-lock no-error .
            if not avail ttt then do:
                create ttt .
                assign  ttt_recid = recid(xxpause_det) .
            end.
        end.
        for each ttt :      
            find first xxpause_det where recid(xxpause_det) = ttt_recid no-lock no-error .
            if not avail xxpause_det then delete ttt .
            else do:
                find first xxpause_det where recid(xxpause_det) = ttt_recid exclusive-lock no-wait no-error .
                if not avail xxpause_det then do:
                    if locked xxpause_det then do:
                        message  "指令暂停控制档被使用,按任意键退出" view-as alert-box title "" .
                        undo mainloop,leave mainloop.
                    end.
                end.
            end.
        end.


        for each ttt,
            each xxpause_det where recid(xxpause_det) = ttt_recid :

            for each xxfb_buf 
                where xxfb_buf.xxfb_user = v_user 
                and xxfb_buf.xxfb_pause  = yes :
                v_trnbr = 0 .
                v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
                run getnbr(input v_nbrtype ,output v_trnbr) .

                create  xxfb_hist.
                assign  xxfb_hist.xxfb_trnbr       = integer(v_trnbr) 
                        xxfb_hist.xxfb_date        = today  
                        xxfb_hist.xxfb_date_end    = ?  
                        xxfb_hist.xxfb_date_start  = v_date  
                        xxfb_hist.xxfb_time        = time - (time mod 60) 
                        xxfb_hist.xxfb_time_end    = 0  
                        xxfb_hist.xxfb_time_start  = v_time   
                        xxfb_hist.xxfb_nbr         = xxfb_buf.xxfb_nbr        
                        xxfb_hist.xxfb_program     = execname
                        xxfb_hist.xxfb_wotype      = xxfb_buf.xxfb_wotype     
                        xxfb_hist.xxfb_qty_fb      = xxfb_buf.xxfb_qty_fb
                        xxfb_hist.xxfb_rmks        = xxfb_buf.xxfb_rmks 
                        xxfb_hist.xxfb_rsn_code    = xxfb_buf.xxfb_rsn_code   
                        xxfb_hist.xxfb_user        = xxfb_buf.xxfb_user        
                        xxfb_hist.xxfb_op          = xxfb_buf.xxfb_op          
                        xxfb_hist.xxfb_wc          = xxfb_buf.xxfb_wc         
                        xxfb_hist.xxfb_wolot       = xxfb_buf.xxfb_wolot      
                        xxfb_hist.xxfb_wonbr       = xxfb_buf.xxfb_wonbr     
                        xxfb_hist.xxfb_part        = xxfb_buf.xxfb_part       
                        xxfb_hist.xxfb_type        = xxfb_buf.xxfb_type       
                        xxfb_hist.xxfb_type2       = xxfb_buf.xxfb_type2      
                        xxfb_hist.xxfb_update      = xxfb_buf.xxfb_update    
                        .

                xxfb_buf.xxfb_pause = no .
            end. /*for each xxfb_buf*/

            release xxfb_buf.

            delete xxpause_Det .
        end. /*执行恢复作业*/


        v_msgtxt = v_msgtxt + "本用户暂停的所有作业已恢复" .
    end.  /*xxpause_det*/
leave.
end. /*mainloop*/
hide frame fixm no-pause . /*for xslnprev01.i */















