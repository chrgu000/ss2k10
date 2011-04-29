define {1} shared temp-table temp1
    field t1_nbr   like pod_nbr 
    field t1_line  like pod_line 
    field t1_part  like pod_part
    field t1_lot   like prh_receiver
    field t1_date  like prh_rcp_date

    field t1_qty   like pod_qty_ord
    field t1_price like tr_price 
    field t1_amt   like tr_gl_amt
    .

