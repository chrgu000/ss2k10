
define {1} shared temp-table tt1
  field tt1_sel as character format "x(1)"
  field tt1_seq like xxpkld_line
  field tt1_pkl like xxpkld_nbr
  field tt1_rknbr like xxpkld_nbr  /*µ÷²¦µ¥ºÅ*/
  field tt1_part like pt_part
  field tt1_desc1 like pt_desc1 format "x(10)"
  field tt1_loc_from like ld_loc
  field tt1_qty_req like ld_qty_oh
  field tt1_qty_oh like ld_qty_oh
  field tt1_loc_to like ld_loc
  field tt1_qty_iss like ld_qty_oh
  field tt1_site like si_site
  field tt1_lot  like ld_lot
  field tt1_ref  like ld_ref
  field tt1_stat like ld_stat
  field tt1_qty1 like ld_qty_oh
  field tt1_xx like pt_desc2
  field tt1_chk as character format "x(4)"
  field tt1_recid as integer
  index tt1_index1 tt1_seq.

/*
define {1} shared temp-table tt2
     field tt2_part like ld_part
     field tt2_site like ld_site
     field tt2_loc  like ld_loc
     field tt2_lot  like ld_lot
     field tt2_ref  like ld_ref
     field tt2_stat like ld_stat
     field tt2_qty_oh like ld_qty_oh.
*/
