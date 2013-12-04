
define {1} shared temp-table xxpod9
  fields x9_nbr like po_nbr
  fields x9_vend like po_vend
  fields x9_ship like po_ship
  fields x9_due_date like po_due_date
  fields x9_pr_list2 like po_pr_list2
  fields x9_pr_list  like po_pr_list
  fields x9_site like po_site
  fields x9_line like pod_line
  fields x9_part like pod_part
  fields x9_qty_ord like pod_qty_ord
  fields x9_qty_fc1 like pod_qty_ord
  fields x9_qty_fc2 like pod_qty_ord
  fields x9_fn as character
  fields x9_chk as character format "x(80)".
