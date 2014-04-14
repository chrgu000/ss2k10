
define {1} shared temp-table tt1
  field tt1_seq like xxpkld_line
  field tt1_pkl like xxpkld_nbr
  field tt1_part like pt_part
  field tt1_desc1 like pt_desc1 format "x(10)"
  field tt1_loc_from like ld_loc
  field tt1_qty_req like xxpkld_qty_req
  field tt1_loc_to like ld_loc
  field tt1_qty_iss like xxpkld_qty_req
  field tt1_site like si_site
  field tt1_qty2 like ld_qty_oh
  field tt1_xx like pt_desc2.

define {1} shared temp-table tt2
  field tt2_part like ld_part
  field tt2_site like ld_site
  field tt2_loc  like ld_loc
  field tt2_lot  like ld_lot
  field tt2_ref  like ld_ref
  field tt2_stat like ld_stat
  field tt2_qty_oh like ld_qty_oh.
