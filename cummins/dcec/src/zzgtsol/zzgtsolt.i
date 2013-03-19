define {1} shared temp-table sotax
  fields sotax_nbr like sod_nbr
  fields sotax_line like sod_line
  fields sotax_part like sod_part
  fields sotax_qty like sod_qty_ord
  fields sotax_tot  like tx2d_totamt 
  fields sotax_sub  like sod_sub
  fields sotax_tax  like tx2d_cur_tax_amt
  fields sotax_inv  like so_inv_nbr
  fields sotax_desc1 like pt_desc1.

define {1} shared variable cimmfname as character.
