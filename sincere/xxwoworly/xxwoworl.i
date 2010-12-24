define {1} shared temp-table tmp_wod
  fields twd_sel     as   character format "x(1)"
  fields twd_nbr     like wo_nbr
  fields twd_lot     like wo_lot
  fields twd_part    like pt_part
  fields twd_qty_req like wod_qty_req
  fields twd_qty_loc like ld_qty_oh
  fields twd_qty_act like wod_qty_req
  fields twd_desc1   like pt_desc1
  fields twd_desc2   like pt_desc2
  fields twd_recid   as   recid
  index  twd_recid   is   primary twd_recid.