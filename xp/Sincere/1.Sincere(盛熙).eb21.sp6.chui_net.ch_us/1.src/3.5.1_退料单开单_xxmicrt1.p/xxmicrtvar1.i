define {1} shared variable prodline like loc_loc .
define {1} shared variable rcvno as character format "x(8)" .
define {1} shared variable proddesc like loc_desc.
define {1} shared variable p-type like xdn_type.
define {1} shared variable p-prev like xdn_prev.
define {1} shared variable p-next like xdn_next.
define {1} shared variable loc-to like ld_loc.
define {1} shared variable locdesc like loc_desc.
define {1} shared variable locdesc1  like loc_desc.
define {1} shared variable  site   like si_site.

define {1} shared temp-table  xxld_tmp
		field xxld_part                like pt_part  
		field xxld_desc1               like pt_desc1 format "x(48)"
		field xxld_desc	               like pt_desc1 
		field xxld_desc2               like pt_desc1
		field xxld_qty_oh              like ld_qty_oh   
		field xxld_qty                 like ld_qty_oh
		field xxld_um                  like pt_um
		field xxld_line                as integer format ">>9"
		field xxld_loc                 like loc_loc
		field xxld_site                like ld_site
		field xxld_lot                 like ld_lot
		field xxld_ref                 like ld_ref
		field xxld_loc_to              like ld_loc

        index xxld_part IS PRIMARY UNIQUE xxld_line xxld_part ascending
		.
