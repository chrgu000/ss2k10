for each ld_det no-lock
   where ld_qty_oh <> 0
  , each pt_mstr no-lock
   where pt_part = ld_part
     and pt_pm_code = "P"
     and lookup(pt_prod_line, "S000,T000") > 0
:
    

display
   pt_part pt_prod_line ld_loc ld_lot ld_qty_oh. 
