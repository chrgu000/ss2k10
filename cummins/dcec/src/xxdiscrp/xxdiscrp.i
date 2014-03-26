define {1} shared temp-table t0
    fields t0_bill like so_bill
    fields t0_inv_date like so_inv_date
    fields t0_ih_nbr like ih_nbr
    FIELDS t0_price LIKE idh_price
    FIELDS t0_qty_inv LIKE idh_qty_inv
    fields t0_ds_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<"
    fields t0_ih_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<"
    fields t0_sum_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<"
    fields t0_open_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<".

define {1} shared temp-table t1
    fields t1_bill like so_bill
    fields t1_ds_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<"
    fields t1_sum_amt as decimal FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<"
    fields t1_open_amt as decimal FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<"
    index t1_bill t1_bill.