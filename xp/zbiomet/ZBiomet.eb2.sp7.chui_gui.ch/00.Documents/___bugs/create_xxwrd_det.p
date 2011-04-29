/* "v_"开头的都是变量:
    
v_wonbr = 工单号.
v_wrnbr = wrnbr的流水号.
v_inv_lot = 成品工单ID的批号.
v_wolot  = 首工序工单ID.

*/

/*取sequence流水号的方式*/
v_wrnbr =  next-value(sfc_sq01) .
if v_wrnbr = 0 then v_wrnbr = next-value(sfc_sq01) .

    
    /*按16.13.13 , 新增SFC工艺流程*/

    for each xwr_route where xwr_nbr = v_wonbr  
        break by xwr_nbr by xwr_lot by xwr_op  :

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
                    xxwrd_status   = "" /*正常的-空,工序被删除-D,新增的工序-N */
                    xxwrd_opfinish = no /*工序完成*/
                    xxwrd_issok    = no /*退料完成,仅全部发原材料的工单ID才使用这个参数*/
                    xxwrd_lastwo   = no 
                    xxwrd_lastop   = no 
                    .

            if last-of(xwr_lot)  then xxwrd_lastop  = yes . /*判断是否每个工单ID的最后一道工序(删,加工序后也要重算) : xxwrd_lastop*/
            if v_wolot = xwr_lot then xxwrd_lastwo  = yes . /*判断是否全部发原材料的工单ID : xxwrd_lastwo*/
        end.
    end.
