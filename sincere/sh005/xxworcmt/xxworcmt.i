define {1} shared variable v_type as character format "x(2)".
define {1} shared variable v_nbr  as character format "x(18)".
define {1} shared temp-table tt_wo
  field tw_sel      as   character format "x(1)"
  field tw_line     as   character format "x(2)"
  field tw_wo       like wo_nbr
  field tw_id       like wo_lot
  field tw_part     like wo_part
  field tw_qty_ord  like wo_qty_ord
  field tw_qty_comp like wo_qty_comp
  field tw_qty_open like wo_qty_comp
  field tw_site     like loc_site
  field tw_loc      like loc_loc
  field tw_desc1    like pt_desc1
  field tw_desc2    like pt_desc2
  field tw_ass_nbr  as   character format "x(18)"
  index tw_wo IS PRIMARY tw_wo
  index tw_id tw_id.
