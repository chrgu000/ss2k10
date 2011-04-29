/* create by roger 090707.1: print the list of invoice approved */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 By: Roger Xiao */


v_ii = 0 .
for each temp1 where t1_ok = yes no-lock,
    each ih_hist  where ih_inv_nbr  = t1_inv_nbr and ih_nbr  = t1_nbr no-lock,
    each idh_hist where idh_inv_nbr = ih_inv_nbr and idh_nbr = ih_nbr no-lock
    break by t1_line by idh_inv_nbr by idh_nbr by idh_line 
    with frame xxx1 width 132:
        
        net_price = idh_price .
        run get-price (input-output net_price , input idh_tax_in , input ih_tax_date , input idh_taxc) .
        ext_price =  net_price * idh_qty_inv.   


        v_ii = v_ii + 1 .
        disp 
            v_ii          label "序" format ">>9"
            idh_inv_nbr   label "发票号"
            idh_nbr       label "客户订单"
            idh_line      label "行" format ">>9"
            idh_part      label "物料号"
            idh_um        label "UM"
            idh_qty_inv   label "发票数量"
            net_price     label "价格"
            ext_price     label "金额"
            ih_userid     label "批核者"
            ih__dte01     label "批核日期"
        with frame xxx1. 

        if v_print then do:
            {mfrpexit.i}
        end.
end. /*for each temp1*/