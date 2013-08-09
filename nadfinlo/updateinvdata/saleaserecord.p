    DEFINE VAR v_month AS INT.
    DEFINE VAR v_qty LIKE ld_qty_oh.
    DEFINE VAR v_comp LIKE ld_qty_oh.
    DEFINE VAR v_std LIKE sod_price.
    DEFINE VAR v_price LIKE sod_price.

    UPDATE v_month  LABEL "月份"  v_qty LABEL "数量".
    FOR EACH cph_hist exclusive-lock
       where cph_year   = "年"
         and cph_cust   = "客户"
         and cph_ship   = "销往"
         and cph_part   = "零件"
         and cph_type   = "零件类型"
         and cph_pl     = "产品线"
         and cph_site   = "地点" :
           if available cph_hist then do:
                ASSIGN v_std = cph_cost[v_month] / cph_qty[v_month]
                       v_price = cph_sales[v_month] / cph_qty[v_month].
                ASSIGN v_comp =   v_qty -  cph_qty[v_month]
                       cph_qty[v_month] = v_qty
                       cph_tot_qty = cph_tot_qty + v_comp
                       /* 成本 */
                       cph_cost[v_month] = cph_qty[v_month] * v_std
                       cph_tot_cost = cph_tot_cost + v_comp * v_std
                       /* 成本 */
                       /* 销售额 */
                       cph_sales[v_month] = cph_qty[v_month] * v_price
                       cph_tot_sale = cph_tot_cost + v_comp * v_price.
           END.
    END.
