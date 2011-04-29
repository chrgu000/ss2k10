/* xstimedown02.p 其他停机时间                                             */
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

define var v_txt as char format "x(20)" .

form
    skip(1)
    v_txt   colon 20  label "停机原因"
    skip(1)
with frame a 
title color normal "其他停机"
side-labels width 50 
row 8 centered overlay .   


/*--------------------------------------------------------------------------------------------------*/

mainloop:
repeat:


    do  on error undo,retry: 
       update v_txt with frame a .
    end.  


    v_date   = today .
    v_time   = time - (time mod 60) . /*保证时间点一致*/
    v_msgtxt = "" .   /*提示信息*/

    /*更新:  前笔指令操作历史记录*/
    do  : 
        {xslnprev02.i}
    end.  



    /*更新:本次指令操作历史记录*/
    do  :  /*xxfb*/


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
                xxfb_wotype      =  ""     
                xxfb_qty_fb      = 0   
                xxfb_rmks        = v_txt   
                xxfb_rsn_code    = ""  
                xxfb_user        = v_user  
                xxfb_op          = 0  
                xxfb_wc          = v_wc  
                xxfb_wolot       = ""  
                xxfb_wonbr       = "" 
                xxfb_part        = ""   
                xxfb_type        = v_line  
                xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
                xxfb_update      = no  
                .
        v_msgtxt = v_msgtxt + xxfb_type2 + ":指令开始" .
    end.  /*xxfb*/

leave.
end. /*mainloop*/
 hide frame a no-pause .













