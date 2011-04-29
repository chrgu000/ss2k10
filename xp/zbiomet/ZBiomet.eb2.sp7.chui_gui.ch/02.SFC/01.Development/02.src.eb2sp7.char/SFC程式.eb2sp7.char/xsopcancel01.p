/* xsopcancel01.p 删除工序 本/后续工序不可已开始反馈:未汇总的反馈数和时间,且无未结指令  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*反馈前的,变量定义及相关检查*/

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}


/*后续工序不可已开始时间或数量反馈*/
find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_op)
        or
        (xxwrd_wolot < v_wolot)
        )
    and (
        xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0
        or xxwrd_time_setup <> 0  or xxwrd_time_run <> 0 
        )
no-lock no-error .
if avail xxwrd_Det then do:
    message "指令无法执行:后续工序已经开始反馈." .
    undo,leave .
end. 



/*后续工序不可有未结指令*/
find first xxfb_hist 
    where xxfb_wonbr  = v_wonbr 
    and ((xxfb_wolot    = v_wolot  and xxfb_op       > v_op)
        or xxfb_wolot   < v_wolot
        )
    and xxfb_date_end = ?
no-lock no-error .
if avail xxfb_hist then do:
    message "指令无法执行:后续工序已经开始反馈," .
    undo,leave .
end.


/*当前工序不可已开始时间或数量反馈*/
find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wonbr   = v_wonbr 
    and xxwrd_wolot   = v_wolot 
    and xxwrd_op      = v_op
    and (
        xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
        or xxwrd_time_setup <> 0  or xxwrd_time_run <> 0 
        )
no-lock no-error .
if avail xxwrd_Det then do:
    message "指令无法执行:当前工序已经开始反馈." .
    undo,leave .
end. 


/*当前工序不可有未结指令*/
find first xxfb_hist 
    where xxfb_wonbr  = v_wonbr 
    and (xxfb_wolot    = v_wolot  and xxfb_op       = v_op)
    and xxfb_date_end = ?
no-lock no-error .
if avail xxfb_hist then do:
    message "指令无法执行:当前工序已经开始反馈," .
    undo,leave .
end.

find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op )
        or xxwrd_wolot   < v_wolot)
    and xxwrd_close   = yes
no-lock no-error .
if avail xxwrd_Det then do:
    message "指令无法执行:当前/后续工序已经有做更新" .
    undo,leave .
end. 

{xsfbchk002.i} /*取数量等的默认值:前工序,本工序,下工序*/


define var v_del_op as logical format "Y/N" .

v_del_op = no .


form
    skip(1)
    v_wolot       colon 18 label "工单标志"
    v_op          colon 45 label "工序" 
    v_part        colon 18 label "完成品"  
    xpt_desc1      colon 45 label "品名"
    xpt_um         colon 18 label "单位"
    xpt_desc2      colon 45 label "规格"
    skip(1)
    v_qty_ord2    colon 18 label "订购量"
    v_inv_lot     colon 45 label "批号"
    skip(3)
    v_del_op      colon 12 label "取消工序"
    skip(5)
with frame a 
title color normal "取消工序(无反馈记录)"
side-labels width 80 .   



hide all no-pause .
view frame a .

mainloop:
repeat :
    
    do  on error undo,retry: /*update_loop*/
        clear frame a no-pause .

        disp v_wolot v_op v_part v_qty_ord2 v_inv_lot with frame a  .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        
        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        exclusive-lock no-wait no-error .
        if not avail xxwrd_det then do:
            if locked xxwrd_det then do:
                message  "工单条码正在被使用,按任意键退出" view-as alert-box title "" .
                undo,leave mainloop.
            end.
        end.

        update v_del_op with frame a  .
        {xsfbchk002.i} /*防止其他机器也在反馈此工单,重新再找一遍,以便找最新数据*/
        
        if v_del_op = no then do:
            message "当前选择:不取消本工序," skip 
                    "按任意键退出." 
            view-as alert-box title "".
            undo mainloop,leave mainloop  .
        end. /*if v_del_op = no */

        if v_del_op = yes then do:
            if v_lastwo and v_lastop then do:
                message "首工序,不允许删除!" .
                undo,retry .
            end.

            find first xxwrd_det 
                where xxwrd_wrnbr = integer(v_wrnbr)
                and xxwrd_wonbr   = v_wonbr 
                and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op)
                    or
                    (xxwrd_wolot < v_wolot)
                    )
                and (
                    xxwrd_qty_comp <> 0 or xxwrd_qty_rework <> 0 or xxwrd_qty_rejct <> 0 
                    or xxwrd_time_setup <> 0  or xxwrd_time_run <> 0 
                    )
            no-lock no-error .
            if avail xxwrd_Det then do:
                message "指令无法执行:后续工序或本工序已经开始反馈:工序:" + xxwrd_wolot + "+"  + string(xxwrd_op) .
                undo,retry .
            end. 
            
            find first xxfb_hist 
                where xxfb_wonbr  = v_wonbr 
                and ((xxfb_wolot    = v_wolot  and xxfb_op       >= v_op)
                    or xxfb_wolot   < v_wolot
                    )
                and xxfb_date_end = ?
            no-lock no-error .
            if avail xxfb_hist then do:
                message "指令无法执行:当前/后续工序已经开始反馈." .
                undo,retry .
            end.

            find first xxwrd_det 
                where xxwrd_wrnbr = integer(v_wrnbr)
                and ((xxwrd_wolot   = v_wolot and xxwrd_op      >= v_op )
                    or xxwrd_wolot   < v_wolot)
                and xxwrd_close   = yes
            no-lock no-error .
            if avail xxwrd_Det then do:
                message "指令无法执行:当前/后续工序已经有做更新" .
                undo,retry .
            end. 


        end. /*if v_del_op = yes*/


    end. /*update_loop*/
    
/*  start ---------------------------------------------------------------------------------------*/  

v_date   = today.
v_time   = time - (time mod 60) . /*保证时间点一致*/
v_msgtxt = "" .   /*提示信息*/


/*更新:本次指令*/
do  :  /*xxfb*/

    find first xxwrd_det 
        where xxwrd_wrnbr = integer(v_wrnbr)
        and xxwrd_wolot   = v_wolot 
        and xxwrd_op      = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close   = no
        and (
            xxwrd_qty_comp = 0 and xxwrd_qty_rework = 0 and xxwrd_qty_rejct = 0 
            )
    no-error .
    if avail xxwrd_Det then do: /*本工序*/               
            assign xxwrd_status = "D" .

            /*本工单ID有多工序,且删除的是最后一道工序,则把本工单的前工序改成lastop = yes */
            if xxwrd_lastop = yes and v_wolot = v_prev_wolot then do:   /*前工序*/
                find first xxwrd_det 
                    where xxwrd_wrnbr = integer(v_wrnbr)
                    and xxwrd_wolot   = v_prev_wolot 
                    and xxwrd_op      = v_prev_op 
                    and (xxwrd_status = "" or xxwrd_status  = "N" )
                    and xxwrd_close   = no
                no-error .
                if avail xxwrd_Det then do:
                    assign xxwrd_lastop = yes .
                end. 
            end.  /*前工序*/
    end.  /*本工序*/

    /*之前有指令,且是未结指令,才执行本段程式,貌似这段根本不可能执行? */
    for each xxfb_hist where xxfb_wolot = v_wolot and xxfb_op = v_op and xxfb_date_end = ? :
            assign  xxfb_date_end    = v_date
                    xxfb_time_end    = v_time .
            message   "用户/机器:"  xxfb_user  "/"  xxfb_wc skip
                      "工单/工序:  "  xxfb_wolot "/"  xxfb_op skip
                      "指令结束:"   xxfb_type2  "       "
            view-as alert-box title "".
    end. /*for each xxfb_hist*/



    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60)  
            xxfb_time_end    = v_time  
            xxfb_time_start  = v_time   
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = if v_yn3 then "R" else ""   
            xxfb_qty_fb      = 0   
            xxfb_rmks        = "取消工序"   
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

    v_msgtxt = v_msgtxt + xxfb_type2 + ":指令完成" .
    if v_next_wolot <> "" then do:
        message "自动转到后一工序." .
        v_wolot = v_next_wolot .
        v_op    = v_next_op .
        v_sn1 = v_wolot + "+" + string(v_op) .
    end.
end.  /*xxfb*/


/*  end ---------------------------------------------------------------------------------------*/  




leave .
end. /*mainloop:*/

hide frame a no-pause .
