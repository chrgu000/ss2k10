
define {1} shared workfile temp0
     fields t0_site        like cncix_site
     fields t0_si_desc     like si_desc
     fields t0_sod_nbr     like cncix_so_nbr
     fields t0_sod_ln      like cncix_sod_line
     fields t0_cust        like cncix_cust
     fields t0_cm_desc     like cm_sort
     fields t0_shipto      like cncix_shipto
     fields t0_st_desc     like si_desc
     fields t0_part        like cncix_part
     fields t0_pt_desc     like pt_desc1
     fields t0_po          like cncix_po
     fields t0_max_days    as   integer
     fields t0_loc         like cncix_current_loc
     fields t0_lot         like cncix_lotser
     fields t0_ref         like cncix_ref
     fields t0_auth        like cncix_auth
     fields t0_stock       like cncix_qty_stock
     fields t0_um          like cncix_stock_um
     fields t0_qty_ship    like cncix_qty_ship
     fields t0_asn_shipper like cncix_asn_shipper
     fields t0_ship_date   like cncix_ship_date
     fields t0_intransit   like cncix_intransit
     fields t0_aged_date   like cncix_aged_date
     fields t0_price       like cncix_price
     fields t0_curr        like cncix_curr
     .
