/* xswofirsttime.i  工单首次刷读,更新SFC工艺流程                              */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/


find first xxwrd_det where xxwrd_wolot = v_wolot no-lock no-error .
if not avail xxwrd_det then do:

    /*检查工单有效性*/
    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    if not avail xwo_mstr then do:
        message "指令无法执行:当前工单不存在"  view-as alert-box title ""  .
        undo,leave .
    end.
    else do:
        /*if index("R",xwo_status ) = 0 then do:
            message "指令无法执行:当前工单状态有误" xwo_status  view-as alert-box title ""  .
            undo,leave .
        end. *//*xp-wo-stat*/
    end. 


    /*检查整套工单的批号:即成品工单的批号*/
    v_inv_lot = "" .
    for each xwo_mstr where xwo_nbr = v_wonbr no-lock break by xwo_nbr by xwo_lot :
        if first-of(xwo_nbr) then do:
            v_inv_lot = xwo_lot_next .
        end.        
    end.
    if v_inv_lot = "" then do:
        message "加工单产品批次为空,请先维护!"  view-as alert-box title ""  .
        undo,leave .
    end.

    /*当首次刷读为非首工序(最大工单标志的第一道工序)时报错*/
    define var v_firstwo as logical initial yes .
    define var v_firstwosn as char format "x(15)" .
    define temp-table xsfcwr 
        field xsfc_wonbr like xwr_nbr 
        field xsfc_wolot like xwr_lot
        field xsfc_op    like xwr_op .

    for each xsfcwr : delete xsfcwr . end.

    for each xwr_route 
        fields (xwr_nbr xwr_lot xwr_op)
        where xwr_nbr = v_wonbr 
        no-lock:
        
        find first xxwrd_det 
            where xxwrd_wolot = xwr_lot 
            and   xxwrd_op    = xwr_op 
            and   xxwrd_wonbr = xwr_nbr 
        no-lock no-error .
        if not avail xxwrd_det then do:
            create xsfcwr .
            assign xsfc_wonbr = xwr_nbr
                   xsfc_wolot = xwr_lot
                   xsfc_op    = xwr_op 
                   .
        end.
    end.

    for each xsfcwr where xsfc_wonbr = v_wonbr 
        break by xsfc_wonbr by xsfc_wolot by xsfc_op descending:
        if last-of(xsfc_wonbr) then do:
            if xsfc_wolot <> v_wolot or xsfc_op <> v_op then do:
                v_firstwo = no .
                v_firstwosn = xsfc_wolot + "+" + string(xsfc_op) .
            end .
        end.
    end.
    if v_firstwo = no then do:
        message "警告:首工序" v_firstwosn "尚未反馈." view-as alert-box title "".
        undo,leave  .
    end.
    



    /*取关联号*/
    v_wrnbr = 0 .
    v_nbrtype =  "bcwrnbr" . /*xxwrd_det,工单关联号*/
    run getnbr(input v_nbrtype ,output v_wrnbr) .


    /*按16.13.13 , 新增SFC工艺流程*/
    for each xsfcwr where xsfc_wonbr = v_wonbr ,
        each xwr_route where xwr_nbr = xsfc_wonbr  
        break by xwr_nbr by xwr_lot by xwr_op  :

        /*xwr__chr05 = v_wrnbr . *关联号,因xwr_route太多机会被删改,取消借用字段*/
        find first xxwrd_det where xxwrd_wolot = xwr_lot and xxwrd_op = xwr_op no-lock no-error .
        if not avail xxwrd_det then do:
            create  xxwrd_det .
            assign  xxwrd_wonbr    = xwr_nbr 
                    xxwrd_wolot    = xwr_lot
                    xxwrd_op       = xwr_op
                    xxwrd_part     = xwr_part 
                    xxwrd_wc       = xwr_wkctr /*默认的工作中心(机器)*/
                    xxwrd_opname   = xwr_desc 
                    xxwrd_wrnbr    = integer(v_wrnbr) 
                    xxwrd_qty_ord  = xwr_qty_ord
                    xxwrd_inv_lot  = v_inv_lot /*最小工单ID的批号*/
                    xxwrd_qty_bom  = 1  /*默认单位用量为1*/
                    xxwrd_status   = "" /*正常的-空,工序被删除-D,新增的工序-N,终止的工序-J */
                    xxwrd_opfinish = no /*工序完成*/
                    xxwrd_issok    = no /*退料完成,仅全部发原材料的工单ID才使用这个参数*/
                    xxwrd_lastwo   = no 
                    xxwrd_lastop   = no 
                    .

            if last-of(xwr_lot)  then xxwrd_lastop  = yes . /*判断是否每个工单ID的最后一道工序(删,加工序后也要重算) : xxwrd_lastop*/
            if v_wolot = xwr_lot then xxwrd_lastwo  = yes . /*判断是否全部发原材料的工单ID : xxwrd_lastwo*/
        end.
    end.

    message "工单首次刷读,SFC工单工艺流程更新完成." .
end. /*if not avail xxwrd_det*/




/*计算单位用量:
删除op后也要再算单位用量,
新增op不新增零件,同零件,所以不再算
*/







