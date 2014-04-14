define {1} shared temp-table tmp_pod no-undo
  fields tpo_sel     as   character format "x(1)" column-label "sl"
  fields tpo_po      like pod_nbr
  fields tpo_line    like pod_line format ">>>"
  fields tpo_part    like pod_part
  fields tpo_loc     like loc_loc column-label "Loc" format "x(6)"
  fields tpo_qty_req like pod_qty_ord column-label "LyQty" format ">>>>>9.99"
  fields tpo_qty_rc  like pod_qty_rcvd column-label "Rcvd" format ">>>>>>9.99"
  fields tpo_stype   like cknyh_stype
  fields tpo_id      as   integer
  fields tpo_stat    as   character column-label "Stat" format "x(34)"
  fields tpo_receive like prh_receiver.
