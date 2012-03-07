/*V8:ConvertMode=Report                                                      */
define {1} shared variable cust  like vd_addr.
define {1} shared variable cust1 like vd_addr.
define {1} shared temp-table tmp_ar
    fields ta_cust like cm_addr
    fields ta_date like ar_effdate
    fields ta_nbr  like ar_nbr
    fields ta_type like ar_type
    fields ta_sub  like ar_sub
    fields ta_due_date like ar_due_date
    fields ta_curr as character
    fields ta_amt  like ar_amt
    fields ta_open like ar_amt
    fields ta_check like ar_nbr
    fields ta_so_nbr like so_nbr
    fields ta_cc like ar_cc
    index ta_nbr ta_nbr.
