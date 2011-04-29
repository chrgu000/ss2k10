/* xstimerun.p  运行时间                                                  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*反馈前的,变量定义及相关检查*/

{xsfbchk002.i} /*取数量等的默认值:前工序,本工序,下工序*/

/*已完成的工序不允许时间反馈*/
{xstimechk01.i}


/*非cell机器,前工序未完成则本工序不允许开始*/
{xstimecell01.i}


/*外协工序v_sub不允许时间反馈*/
{xsfbsubwo02.i}

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}


/*--------------------------------------------------------------------------------------------------*/

mainloop:
repeat:


    v_yn3 = no .
    find first xxwrd_Det 
            where xxwrd_wrnbr = integer(v_wrnbr) 
            and xxwrd_wolot   = v_wolot
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
    exclusive-lock no-wait no-error .
    if avail xxwrd_det then do:
        if xxwrd_qty_rework - xxwrd_qty_return > 0 then do:
            v_yn3 = yes .
            message "是否返工件?" update v_yn3 .
        end.
    end. /*if avail xxwrd_det*/
    else do:
        if locked xxwrd_det then do:
            message  "工单条码正在被使用,按任意键退出" view-as alert-box title "" .
            undo,leave mainloop.
        end.
    end.


    v_date   = today.
    v_time   = time - (time mod 60) . /*保证时间点一致*/
    v_msgtxt = "" .   /*提示信息*/

    /*更新:  前笔指令操作历史记录*/
    do  :  /*xxfb_prev*/
        {xslnprev01.i}
    end.  /*xxfb_prev*/


    /*更新:本次指令操作历史记录*/
    do :  /*xxfb*/


        find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
        find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

        v_trnbr = 0 .
        v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
        run getnbr(input v_nbrtype ,output v_trnbr) .


        create  xxfb_hist .
        assign  xxfb_trnbr       = integer(v_trnbr) 
                xxfb_date        = today  
                xxfb_date_end    = ?  
                xxfb_date_start  = v_date  
                xxfb_time        = time - (time mod 60) 
                xxfb_time_end    = 0  
                xxfb_time_start  = v_time   
                xxfb_nbr         = "" 
                xxfb_program     = execname
                xxfb_wotype      = if v_yn3 then "R" else ""     
                xxfb_qty_fb      = 0   
                xxfb_rmks        = ""  
                xxfb_rsn_code    = ""  
                xxfb_user        = v_user  
                xxfb_op          = v_op  
                xxfb_wc          = v_wc  
                xxfb_wolot       = v_wolot  
                xxfb_wonbr       = v_wonbr 
                xxfb_part        = if avail xwo_mstr then xwo_part else ""   
                xxfb_type        = v_line  
                xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
                xxfb_update      = no  
                .
        v_msgtxt = v_msgtxt + xxfb_type2 + ":指令开始" .
    end.  /*xxfb*/




leave.
end. /*mainloop*/
hide frame fixm no-pause . /*for xslnprev01.i */















