define {1} shared variable days as integer extent 9 no-undo.
define {1} shared temp-table x_ret
   fields xr_part like pt_part
   fields xr_site like si_site
   fields xr_desc1 like pt_desc1
   fields xr_prodline like pt_prod_line
   fields xr_qty_oh like ld_qty_oh
   fields xr_cst like sct_cst_tot
   fields xr_qty like ld_qty_oh extent 10
   index xr_part xr_part.
