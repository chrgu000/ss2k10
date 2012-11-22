define {1} shared variable site like si_site no-undo.
define {1} shared variable site1 like si_site no-undo.
define {1} shared variable absid like abs_id no-undo.
define {1} shared variable absid1 like abs_id no-undo.
define {1} shared variable shnbr like xxsh_nbr no-undo.
define {1} shared variable shnbr1 like xxsh_nbr no-undo.
define {1} shared variable stat  as character format "x(1)" initial "*".

define {1} shared temp-table xsh_det
	fields xsh_site like abs_shipfrom	
	fields xsh_abs_id like abs_id
	fields xsh_nbr as character
	fields xsh_indent_id as character format "x(12)"
  fields xsh_abs_item like abs_item
  fields xsh_shipper_po like sod_contr_id format "x(22)"
  fields xsh_abs_site like abs_site
  fields xsh_abs_order like abs_order
  fields xsh_abs_line  like abs_line       
  fields xsh_abs_qty like abs_qty
  fields xsh_um like pt_um
  fields xsh_open_qty like abs_qty
  fields xsh_due_date as date
  fields xsh_abs_shp_date like abs_shp_date   
  fields xsh_sod_modelyr like sod_modelyr
  fields xsh_sod_custref like sod_custref                  
  .
  