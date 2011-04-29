define {1} shared variable line2 as integer format ">>9" initial 20 label "ÏîÊý".
define {1} shared variable wcdesc like wc_desc.
define {1} shared variable prodline like loc_loc .
define {1} shared variable rcvno as character format "x(8)" .
define {1} shared variable proddesc like loc_desc.
define {1} shared variable v_ordertype like xdn_ordertype.
define {1} shared variable p-type like xdn_type.
define {1} shared variable p-prev like xdn_prev.
define {1} shared variable p-next like xdn_next.
define {1} shared variable companyname like ad_name.
define {1} shared var site like loc_site .


define {1} shared temp-table  xxld_tmp
		field xxld_part                like pt_part  
		field xxld_desc1               like pt_desc1 format "x(48)"
		field xxld_desc	               like pt_desc1 
		field xxld_desc2               like pt_desc1
		field xxld_qty_oh              like ld_qty_oh   
		field xxld_qty                 like ld_qty_oh
		field xxld_um                  like pt_um
		field xxld_loc                 like loc_loc
		field xxld_site                like ld_site
		field xxld_lot                 like ld_lot
		field xxld_ref                 like ld_ref
		field xxld_line                as char format "x(3)"
		field xxld_line2               as integer format ">>9"
        index xxld_part IS PRIMARY UNIQUE xxld_line2 xxld_part ascending
		.
