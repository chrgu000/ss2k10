    DEFINE VAR v_month AS INT.
    DEFINE VAR v_qty LIKE ld_qty_oh.
    DEFINE VAR v_comp LIKE ld_qty_oh.
    DEFINE VAR v_std LIKE sod_price.
    DEFINE VAR v_price LIKE sod_price.

    UPDATE v_month  LABEL "�·�"  v_qty LABEL "����".
    FOR EACH cph_hist exclusive-lock
       where cph_year   = "��"
         and cph_cust   = "�ͻ�"
         and cph_ship   = "����"
         and cph_part   = "���"
         and cph_type   = "�������"
         and cph_pl     = "��Ʒ��"
         and cph_site   = "�ص�" :
           if available cph_hist then do:
                ASSIGN v_std = cph_cost[v_month] / cph_qty[v_month]
                       v_price = cph_sales[v_month] / cph_qty[v_month].
                ASSIGN v_comp =   v_qty -  cph_qty[v_month]
                       cph_qty[v_month] = v_qty
                       cph_tot_qty = cph_tot_qty + v_comp
                       /* �ɱ� */
                       cph_cost[v_month] = cph_qty[v_month] * v_std
                       cph_tot_cost = cph_tot_cost + v_comp * v_std
                       /* �ɱ� */
                       /* ���۶� */
                       cph_sales[v_month] = cph_qty[v_month] * v_price
                       cph_tot_sale = cph_tot_cost + v_comp * v_price.
           END.
    END.
