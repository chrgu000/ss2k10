define {1} shared temp-table tmp_pod
  fields tpo_sel     as   character format "x(1)"
  fields tpo_po      like pod_nbr
  fields tpo_line    like pod_line
  fields tpo_part    like pod_part
  fields tpo_loc     like loc_loc 
  fields tpo_qty_req like pod_qty_ord
  fields tpo_qty_rc  like pod_qty_rcvd
  fields tpo_id      as   integer
  fields tpo_stat    as   character format "x(20)".