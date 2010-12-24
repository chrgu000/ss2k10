define {1} shared temp-table tmp_powoin
  fields tpwi_sel     as   character format "x(1)"
  fields tpwi_po      like po_nbr
  fields tpwi_podline like pod_line
  fields tpwi_lot     like wo_lot
  fields tpwi_part    like pod_part
  fields tpwi_um      like pt_um
  fields tpwi_fsite   like loc_site
  fields tpwi_floc    like loc_loc
  fields tpwi_flot    like ld_lot
  fields tpwi_fref    like ld_ref
  fields tpwi_tsite   like loc_site
  fields tpwi_tloc    like loc_loc
  fields tpwi_tlot    like ld_lot
  fields tpwi_tref    like ld_ref
  fields tpwi_eff_dte as   date
  fields tpwi_qty_loc like ld_qty_oh
  fields tpwi_qty_on  like ld_qty_oh
  fields tpwi_qty_tr  like ld_qty_oh
  fields tpwi_desc1   as   character format "x(34)"
  fields tpwi_null    as   character format "x(2)"
  fields tpwi_stat    as   logical initial no
  index  tpwi_op_lot_part is primary tpwi_po tpwi_lot tpwi_part.
